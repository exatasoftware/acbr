{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibResposta;

interface

uses
  SysUtils, Classes, laz2_DOM, laz2_XMLWrite, StrUtils,
  inifiles, fpjson, jsonparser, TypInfo, rttiutils,
  ACBrBase, ACBrUtil;

const
  CSessaoHttpResposta = 'RespostaHttp';
  CSessionFormat = '%s%.3d';

type
  TACBrLibRespostaTipo = (resINI, resXML, resJSON);
  TACBrLibCodificacao = (codUTF8, codANSI);

  TArrayOfVariant = array of Variant;
  TArrayOfObject = array of TObject;
  TArrayOfClass = array of TClass;

  { TACBrLibRespostaBase }
  TACBrLibRespostaBase = class abstract
  private
    FSessao: String;
    FTipo: TACBrLibRespostaTipo;
    FFormato: TACBrLibCodificacao;

    function GerarXml: Ansistring;
    function GerarIni: Ansistring;
    function GerarJson: Ansistring;

  protected
    procedure GravarXml(const xDoc: TXMLDocument; const RootNode: TDomNode; const Target: TObject); virtual;
    procedure GravarIni(const AIni: TCustomIniFile; const ASessao: String; const Target: TObject; const APrefix: String = ''); virtual;
    procedure GravarJson(const JSON: TJSONObject; const ASessao: String; const Target: TObject); virtual;

  public
    constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);

    property Sessao: String read FSessao;
    property Tipo: TACBrLibRespostaTipo read FTipo;
    property Formato: TACBrLibCodificacao read FFormato;

    function Gerar: Ansistring; virtual;

  end;

  { TACBrLibResposta }
  TACBrLibResposta<T: TACBrComponent> = class abstract(TACBrLibRespostaBase)
  public
    procedure Processar(const Control: T); virtual; abstract;
  end;

  { TACBrLibHttpResposta }
  TACBrLibHttpResposta = class(TACBrLibRespostaBase)
  private
    FWebService: string;
    FCodigoHTTP: Integer;
    FMsg: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

  published
    property WebService: String read FWebService write FWebService;
    property CodigoHTTP: Integer read FCodigoHTTP write FCodigoHTTP;
    property Msg: string read FMsg write FMsg;

  end;

  { TLibImpressaoResposta }
  TLibImpressaoResposta = class(TACBrLibRespostaBase)
  private
    FMsg: string;

  public
    constructor Create(const QtdImpresso: Integer; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;

  published
    property Msg: string read FMsg write FMsg;

  end;

implementation

uses
  math;

{ TACBrLibResposta }
constructor TACBrLibRespostaBase.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create;
  FSessao := ASessao;
  FTipo := ATipo;
  FFormato := AFormato;
end;

function TACBrLibRespostaBase.GerarXml: Ansistring;
var
  xDoc: TXMLDocument;
  RootNode: TDomNode;
  Stream: TMemoryStream;
begin
  xDoc := TXMLDocument.Create;

  try
    RootNode := xDoc.CreateElement(Sessao);
    xDoc.AppendChild(RootNode);
    RootNode := xDoc.DocumentElement;
    GravarXml(xDoc, RootNode, Self);
    Stream := TMemoryStream.Create();
    WriteXML(xDoc.FirstChild, Stream);
    SetString(Result, PChar(Stream.Memory), Stream.Size div SizeOf(char));
  finally
    if Stream <> nil then
      Stream.Free;
    if xDoc <> nil then
      xDoc.Free;
  end;
end;

procedure TACBrLibRespostaBase.GravarXml(const xDoc: TXMLDocument; const RootNode: TDomNode; const Target: TObject);
Var
  PropList: TPropInfoList;
  i, j: Integer;
  PI: PPropInfo;
  TI: PTypeInfo;
  TD: PTypeData;
  ClassObject: TObject;
  CollectionObject: TCollection;
  CollectionItem: TCollectionItem;
  ListObject: TList;
  Item: TObject;
  ParentNode: TDomNode;
  FloatValue: Extended;
begin
  PropList := TPropInfoList.Create(Target, tkProperties);
  try
    for i := 0 to PropList.Count - 1 do
    begin
      PI := PropList.Items[i];
      TI := PI^.PropType;
      TD := GetTypeData(TI);
      case TI^.Kind of
        tkClass:
          begin
            if TD.ClassType = nil then continue;

            ClassObject := GetObjectProp(Target, PI);
            if not Assigned(ClassObject) or (ClassObject = nil) then continue;

            if (TD.ClassType.InheritsFrom(TCollection)) then
            begin
              ParentNode := xDoc.CreateElement(Pi^.Name);
              CollectionObject := TCollection(ClassObject);
              for j := 0 to CollectionObject.Count - 1 do
              begin
                CollectionItem := CollectionObject.Items[j];
                GravarXml(xDoc, ParentNode, CollectionItem);
              end;
            end
            else if (TD.ClassType.InheritsFrom(TList)) then
            begin
              ParentNode := xDoc.CreateElement(Pi^.Name);
              ListObject := TList(ClassObject);
              for j := 0 to ListObject.Count - 1 do
              begin
                Item := ListObject.Items[j];
                GravarXml(xDoc, ParentNode, Item);
              end;
            end
            else
            begin
              if (TD.ClassType.InheritsFrom(TACBrLibRespostaBase)) then
                ParentNode := xDoc.CreateElement(TACBrLibRespostaBase(ClassObject).Sessao)
              else
                ParentNode := xDoc.CreateElement(Pi^.Name);

              GravarXml(xDoc, ParentNode, ClassObject);
            end;
          end;
        tkSet,
        tkEnumeration,
        tkInteger,
        tkBool,
        tkInt64:
          begin
            ParentNode := xDoc.CreateElement(Pi^.Name);
            ParentNode.AppendChild(xDoc.CreateTextNode(IntToStr(GetOrdProp(Target, PI))));
          end;
        tkWString,
        tkUString,
        tkSString,
        tkLString,
        tkAString:
          begin
            ParentNode := xDoc.CreateElement(Pi^.Name);
            ParentNode.AppendChild(xDoc.CreateTextNode(Trim(GetStrProp(Target, PI))));
          end;
        tkFloat:
          begin
            ParentNode := xDoc.CreateElement(Pi^.Name);
            FloatValue := GetFloatProp(Target, PI);

            if (TI = TypeInfo(TDate)) then
            begin
              if not IsZero(FloatValue) then
                ParentNode.AppendChild(xDoc.CreateTextNode(DateToStr(FloatValue)));
            end
            else if (TI = TypeInfo(TTime)) then
            begin
              if not IsZero(FloatValue) then
                ParentNode.AppendChild(xDoc.CreateTextNode(TimeToStr(FloatValue)));
            end
            else if(TI = TypeInfo(TDateTime))then
            begin
              if not IsZero(FloatValue) then
                ParentNode.AppendChild(xDoc.CreateTextNode(DateTimeToStr(FloatValue)));
            end
            else
              ParentNode.AppendChild(xDoc.CreateTextNode(FloatToStr(FloatValue)));
          end;
      end;
      RootNode.AppendChild(ParentNode);
    end;
  finally
    if PropList <> nil then
      PropList.Free;
  end;
end;

function TACBrLibRespostaBase.GerarIni: Ansistring;
var
  AIni: TMemIniFile;
  TList: TStringList;
begin
  AIni := TMemIniFile.Create('');
  TList := TStringList.Create;

  try
    GravarIni(AIni, Sessao, Self);

    AIni.GetStrings(TList);
    Result := TList.Text;
  finally
    if TList <> nil then
      TList.Free;
    if AIni <> nil then
      AIni.Free;
  end;
end;

procedure TACBrLibRespostaBase.GravarIni(const AIni: TCustomIniFile; const ASessao: String; const Target: TObject; const APrefix: String);
var
  PropList: TPropInfoList;
  i, j: Integer;
  PI: PPropInfo;
  TI: PTypeInfo;
  TD: PTypeData;
  Sessao: String;
  ClassObject: TObject;
  CollectionObject: TCollection;
  CollectionItem: TCollectionItem;
  ListObject: TList;
  Item: TObject;
  FloatValue: Extended;
begin
  PropList := TPropInfoList.Create(Target, tkProperties);

  try
    for i := 0 to PropList.Count - 1 do
    begin
      PI := PropList.Items[i];
      TI := PI^.PropType;
      TD := GetTypeData(TI);
      case TI^.Kind of
        tkClass:
          begin
            if TD.ClassType = nil then continue;

            ClassObject := GetObjectProp(Target, PI);
            if not Assigned(ClassObject) or (ClassObject = nil) then continue;

            if (TD.ClassType.InheritsFrom(TCollection)) then
            begin
              CollectionObject := TCollection(ClassObject);
              for j := 0 to CollectionObject.Count - 1 do
              begin
                CollectionItem := CollectionObject.Items[j];
                Sessao := IfThen(NaoEstaVazio(APrefix), PI.Name + APrefix, PI.Name);
                GravarIni(AIni, Format(CSessionFormat, [Sessao, J+1]), CollectionItem, APrefix + Trim(IntToStrZero(J +1, 3)))
              end;
            end
            else if (TD.ClassType.InheritsFrom(TList)) then
            begin
              ListObject := TList(ClassObject);
              for j := 0 to ListObject.Count - 1 do
              begin
                Item := ListObject.Items[j];
                Sessao := IfThen(NaoEstaVazio(APrefix), PI.Name + APrefix, PI.Name);
                GravarIni(AIni, Format(CSessionFormat, [Sessao, J+1]), Item, APrefix + Trim(IntToStrZero(J +1, 3)))
              end;
            end
            else
            begin
              if (TD.ClassType.InheritsFrom(TACBrLibRespostaBase)) then
              begin
                Sessao := IfThen(NaoEstaVazio(APrefix), TACBrLibRespostaBase(ClassObject).Sessao + APrefix,
                                                        TACBrLibRespostaBase(ClassObject).Sessao);
                GravarIni(AIni, Sessao, ClassObject, APrefix)
              end
              else
              begin
                Sessao := IfThen(NaoEstaVazio(APrefix), PI.Name + APrefix, PI.Name);
                GravarIni(AIni, PI.Name, ClassObject, APrefix);
              end;
            end;
          end;
        tkSet:
            AIni.WriteString(ASessao, PI^.Name, GetSetProp(Target, PI, True));
        tkBool,
        tkEnumeration,
        tkInteger,
        tkInt64:
          AIni.WriteInt64(ASessao, PI^.Name, GetOrdProp(Target, PI));
        tkWString,
        tkUString,
        tkSString,
        tkLString,
        tkAString:
          AIni.WriteString(ASessao, PI^.Name, Trim(GetStrProp(Target, PI)));
        tkFloat:
          begin
            FloatValue := GetFloatProp(Target, PI);
            if (TI = TypeInfo(TDate)) then
            begin
              if not IsZero(FloatValue) then
                AIni.WriteDate(ASessao, PI^.Name, FloatValue);
            end
            else if (TI = TypeInfo(TTime)) then
            begin
              if not IsZero(FloatValue) then
                AIni.WriteTime(ASessao, PI^.Name, FloatValue);
            end
            else if (TI = TypeInfo(TDateTime)) then
            begin
              if not IsZero(FloatValue) then
                AIni.WriteDateTime(ASessao, PI^.Name, FloatValue);
            end
            else
              AIni.WriteFloat(ASessao, PI^.Name, FloatValue);
          end;
      end;
    end;
  finally
    if PropList <> nil then
      PropList.Free;
  end;
end;

function TACBrLibRespostaBase.GerarJson: Ansistring;
var
  JSON: TJSONObject;
begin
  JSon := TJSONObject.Create;
  try
    GravarJson(JSon, Sessao, Self);
    Result := JSON.AsJSON;
  finally
    if JSON <> nil then
      JSON.Free;
  end;
end;

procedure TACBrLibRespostaBase.GravarJson(const JSON: TJSONObject; const ASessao: String; const Target: TObject);
var
  PropList: TPropInfoList;
  i, j: Integer;
  PI: PPropInfo;
  TI: PTypeInfo;
  TD: PTypeData;
  ClassObject: TObject;
  CollectionObject: TCollection;
  CollectionItem: TCollectionItem;
  ListObject: TList;
  Item: TObject;
  FloatValue: Double;
  JSONRoot: TJSONObject;
begin
  JSONRoot := TJSONObject.Create;
  JSON.Add(ASessao, JSONRoot);
  PropList := TPropInfoList.Create(Target, tkProperties);

  try
    for i := 0 to PropList.Count - 1 do
    begin
      PI := PropList.Items[i];
      TI := PI^.PropType;
      TD := GetTypeData(TI);
      case TI^.Kind of
        tkClass:
          begin
            if TD.ClassType = nil then continue;

            ClassObject := GetObjectProp(Target, PI);
            if not Assigned(ClassObject) or (ClassObject = nil) then continue;

            if (TD.ClassType.InheritsFrom(TCollection)) then
            begin
              CollectionObject := TCollection(ClassObject);
              for j := 0 to CollectionObject.Count - 1 do
              begin
                CollectionItem := CollectionObject.Items[j];
                GravarJson(JSONRoot, Format(CSessionFormat, [PI.Name, J+1]), CollectionItem)
              end;
            end
            else if (TD.ClassType.InheritsFrom(TList)) then
            begin
              ListObject := TList(ClassObject);
              for j := 0 to ListObject.Count - 1 do
              begin
                Item := ListObject.Items[j];
                GravarJson(JSONRoot, Format(CSessionFormat, [PI.Name, J+1]), Item)
              end;
            end
            else
            begin
              if (TD.ClassType.InheritsFrom(TACBrLibRespostaBase)) then
                GravarJson(JSONRoot, TACBrLibRespostaBase(ClassObject).Sessao, ClassObject)
              else
                GravarJson(JSONRoot, PI.Name, ClassObject);
            end;
          end;
        tkSet:
          JSONRoot.Add(PI^.Name, GetSetProp(Target, PI, True));
        tkEnumeration,
        tkInteger,
        tkBool,
        tkInt64:
          JSONRoot.Add(PI^.Name, GetOrdProp(Target, PI));
        tkWString,
        tkUString,
        tkSString,
        tkLString,
        tkAString:
          JSONRoot.Add(PI^.Name, Trim(GetStrProp(Target, PI)));
        tkFloat:
          begin
            FloatValue := GetFloatProp(Target, PI);

            if (TI = TypeInfo(TDate)) then
            begin
              if not IsZero(FloatValue) then
                JSONRoot.Add(PI^.Name, DateToStr(FloatValue));
            end
            else if (TI = TypeInfo(TTime)) then
            begin
              if not IsZero(FloatValue) then
                JSONRoot.Add(PI^.Name, TimeToStr(FloatValue));
            end
            else if (TI = TypeInfo(TDateTime)) then
            begin
              if not IsZero(FloatValue) then
                JSONRoot.Add(PI^.Name, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', FloatValue));
            end
            else
              JSONRoot.Add(PI^.Name, FloatValue);
          end;
      end;
    end;
  finally
    if PropList <> nil then
      PropList.Free;
  end;
end;

function TACBrLibRespostaBase.Gerar: Ansistring;
begin
  case FTipo of
    resXML: Result := GerarXml;
    resJSON: Result := GerarJson;
    else
      Result := GerarIni;
  end;

  if FFormato = codANSI then
    Result := ACBrUTF8ToAnsi(Result);
end;

{ TACBrLibHttpResposta }
constructor TACBrLibHttpResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoHttpResposta, ATipo, AFormato);
end;

{ TLibImpressaoResposta }
constructor TLibImpressaoResposta.Create(const QtdImpresso: Integer; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create('Impressao', ATipo, AFormato);
  Msg := Format('%d Documento (s) impresso(s) com sucesso', [QtdImpresso]);
end;

end.


