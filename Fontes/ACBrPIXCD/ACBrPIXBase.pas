{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXBase;

interface

uses
  Classes, SysUtils,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr
  {$Else}
   Jsons
  {$EndIf},
  ACBrBase;

resourcestring
  sErroMetodoNaoImplementado = 'M�todo %s n�o implementado para Classe %s';

const
  cGUIPIX = 'br.gov.bcb.pix';
  cBRCurrency = 986;
  cBRCountryCode = 'BR';
  cMPMValueNotInformed = '***';
  cEMVLimit = 99;

type
  TACBrPIXTipoChave = ( tchNenhuma,
                        tchCPF,
                        tchCNPJ,
                        tchCelular,
                        tchAleatoria );

  TACBrPIXStatusCobranca = ( stcNENHUM,
                             stcATIVA,
                             stcCONCLUIDA,
                             stcREMOVIDA_PELO_USUARIO_RECEBEDOR,
                             stcREMOVIDA_PELO_PSP );

  TACBrPIXStatusDevolucao = ( stdNENHUM,
                              stdEM_PROCESSAMENTO,
                              stdDEVOLVIDO,
                              stdNAO_REALIZADO );

  TACBrPIXNaturezaDevolucao = ( ndNENHUMA, ndORIGINAL, ndRETIRADA ) ;

  TACBrPIXModalidadeAgente = ( maNENHUM,
                               maAGTEC,
                               maAGTOT,
                               maAGPSS );

  TACBrPIXTipoCobranca = ( tcoNenhuma, tcoCob, tcoCobV );

  EACBrPixException = class(EACBrException);

  { TACBrPIXSchema }

  TACBrPIXSchema = class
  private
    function GetAsJSON: String; virtual;
    procedure SetAsJSON(AValue: String); virtual;
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); virtual;
  public
    procedure Clear; virtual;
    procedure WriteToJSon(AJSon: TJsonObject); virtual;
    procedure ReadFromJSon(AJSon: TJsonObject); virtual;

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

  { TACBrPIXSchemaArray }

  TACBrPIXSchemaArray = class(TACBrObjectList)
  private
    function GetAsJSON: String;
    procedure SetAsJSON(AValue: String);
  protected
    fpArrayName: String;
    function NewSchema: TACBrPIXSchema; virtual;
  public
    constructor Create(const ArrayName: String);
    procedure Clear; override;
    procedure Assign(Source: TACBrObjectList); virtual;
    procedure WriteToJSon(AJSon: TJsonObject); virtual;
    procedure ReadFromJSon(AJSon: TJsonObject); virtual;

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;


  function PIXStatusCobrancaToString(AStatus: TACBrPIXStatusCobranca): String;
  function StringToPIXStatusCobranca(const AString: String): TACBrPIXStatusCobranca;

  function PIXModalidadeAgenteToString(AModalidadeAgente: TACBrPIXModalidadeAgente): String;
  function StringToPIXModalidadeAgente(const AString: String): TACBrPIXModalidadeAgente;

  function PIXStatusDevolucaoToString(AStatus: TACBrPIXStatusDevolucao): String;
  function StringToPIXStatusDevolucao(const AString: String): TACBrPIXStatusDevolucao;

  function PIXNaturezaDevolucaoToString(AStatus: TACBrPIXNaturezaDevolucao): String;
  function StringToPIXNaturezaDevolucao(const AString: String): TACBrPIXNaturezaDevolucao;

  function PIXTipoCobrancaToString(ACob: TACBrPIXTipoCobranca): String;
  function StringToPIXTipoCobranca(const AString: String): TACBrPIXTipoCobranca;

implementation

uses
  ACBrUtil;

function PIXStatusCobrancaToString(AStatus: TACBrPIXStatusCobranca): String;
begin
  case AStatus of
    stcATIVA: Result := 'ATIVA';
    stcCONCLUIDA: Result := 'CONCLUIDA';
    stcREMOVIDA_PELO_USUARIO_RECEBEDOR: Result := 'REMOVIDA_PELO_USUARIO_RECEBEDOR';
    stcREMOVIDA_PELO_PSP: Result := 'REMOVIDA_PELO_PSP';
  else
    Result := '';
  end;
end;

function StringToPIXStatusCobranca(const AString: String): TACBrPIXStatusCobranca;
begin
  if (AString = 'ATIVA') then
    Result := stcATIVA
  else if (AString = 'CONCLUIDA') then
    Result := stcCONCLUIDA
  else if (AString = 'REMOVIDA_PELO_USUARIO_RECEBEDOR') then
    Result := stcREMOVIDA_PELO_USUARIO_RECEBEDOR
  else if (AString = 'REMOVIDA_PELO_PSP') then
    Result := stcREMOVIDA_PELO_PSP
  else
    Result := stcNENHUM;
end;

function PIXModalidadeAgenteToString(AModalidadeAgente: TACBrPIXModalidadeAgente): String;
begin
  case AModalidadeAgente of
    maAGTEC: Result := 'AGTEC';
    maAGTOT: Result := 'AGTOT';
    maAGPSS: Result := 'AGPSS';
  else
    Result := '';
  end;
end;

function StringToPIXModalidadeAgente(const AString: String
  ): TACBrPIXModalidadeAgente;
begin
  if (AString = 'AGTEC') then
    Result := maAGTEC
  else if (AString = 'AGTOT') then
    Result := maAGTOT
  else if (AString = 'AGPSS') then
    Result := maAGPSS
  else
    Result := maNENHUM;
end;

function PIXStatusDevolucaoToString(AStatus: TACBrPIXStatusDevolucao): String;
begin
  case AStatus of
    stdEM_PROCESSAMENTO: Result := 'EM_PROCESSAMENTO';
    stdDEVOLVIDO: Result := 'DEVOLVIDO';
    stdNAO_REALIZADO: Result := 'NAO_REALIZADO';
  else
    Result := '';
  end;
end;

function StringToPIXStatusDevolucao(const AString: String
  ): TACBrPIXStatusDevolucao;
begin
  if (AString = 'EM_PROCESSAMENTO') then
    Result := stdEM_PROCESSAMENTO
  else if (AString = 'DEVOLVIDO') then
    Result := stdDEVOLVIDO
  else if (AString = 'NAO_REALIZADO') then
    Result := stdNAO_REALIZADO
  else
    Result := stdNENHUM;
end;

function PIXNaturezaDevolucaoToString(AStatus: TACBrPIXNaturezaDevolucao): String;
begin
  case AStatus of
    ndORIGINAL: Result := 'ORIGINAL';
    ndRETIRADA: Result := 'RETIRADA';
  else
    Result := '';
  end;
end;

function StringToPIXNaturezaDevolucao(const AString: String
  ): TACBrPIXNaturezaDevolucao;
begin
  if (AString = 'ORIGINAL') then
    Result := ndORIGINAL
  else if (AString = 'RETIRADA') then
    Result := ndRETIRADA
  else
    Result := ndNENHUMA;
end;

function PIXTipoCobrancaToString(ACob: TACBrPIXTipoCobranca): String;
begin
  case ACob of
    tcoCobV: Result := 'cobv';
    tcoCob: Result := 'cob';
  else
    Result := '';
  end;
end;

function StringToPIXTipoCobranca(const AString: String): TACBrPIXTipoCobranca;
begin
  if (AString = 'cobv') then
    Result := tcoCobV
  else if (AString = 'cob') then
    Result := tcoCob
  else
    Result := tcoNenhuma;
end;

{ TACBrPIXSchema }

function TACBrPIXSchema.GetAsJSON: String;
var
  js: TJsonObject;
begin
  js := TJsonObject.Create;
  try
    WriteToJSon(js);
    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     Result := js.ToJSON();
    {$Else}
     Result := js.Stringify;
    {$EndIf}
  finally
    js.Free;
  end;
end;

procedure TACBrPIXSchema.SetAsJSON(AValue: String);
var
  js: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   js := TJsonObject.Parse(AValue) as TJsonObject;
   try
     ReadFromJSon(js);
   finally
     js.Free;
   end;
  {$Else}
   js := TJsonObject.Create;
   try
     js.Parse(AValue);
     ReadFromJSon(js);
   finally
     js.Free;
   end;
  {$EndIf}
end;

procedure TACBrPIXSchema.Clear;
begin
  raise EACBrPixException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['Clear', ClassName]);
end;

procedure TACBrPIXSchema.AssignSchema(ASource: TACBrPIXSchema);
begin
  raise EACBrPixException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['AssignSchema', ClassName]);
end;

procedure TACBrPIXSchema.WriteToJSon(AJSon: TJsonObject);
begin
  raise EACBrPixException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['WriteToJSon', ClassName]);
end;

procedure TACBrPIXSchema.ReadFromJSon(AJSon: TJsonObject);
begin
  raise EACBrPixException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['ReadFromJSon', ClassName]);
end;

{ TACBrPIXSchemaArray }

constructor TACBrPIXSchemaArray.Create(const ArrayName: String);
begin
  inherited Create(True);
  fpArrayName := ArrayName;
end;

procedure TACBrPIXSchemaArray.Clear;
begin
  inherited Clear;
end;

function TACBrPIXSchemaArray.NewSchema: TACBrPIXSchema;
begin
  {$IfDef FPC}Result := Nil;{$EndIf}
  raise EACBrPixException.CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['NewSchema', ClassName]);
end;

procedure TACBrPIXSchemaArray.Assign(Source: TACBrObjectList);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Source.Count-1 do
    NewSchema.AssignSchema(TACBrPIXSchema(Source[i]));
end;

procedure TACBrPIXSchemaArray.WriteToJSon(AJSon: TJsonObject);
var
  i: Integer;
  ja: TJsonArray;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ja := AJSon.A[fpArrayName];
   ja.Clear;
   for i := 0 to Count-1 do
     TACBrPIXSchema(Items[i]).WriteToJSon(ja.AddObject);
  {$Else}
   ja := AJSon[fpArrayName].AsArray;
   ja.Clear;
   for i := 0 to Count-1 do
     TACBrPIXSchema(Items[i]).WriteToJSon(ja.Add.AsObject);
  {$EndIf}
end;

procedure TACBrPIXSchemaArray.ReadFromJSon(AJSon: TJsonObject);
var
  i: Integer;
  ja: TJsonArray;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ja := AJSon.A[fpArrayName];
   for i := 0 to ja.Count-1 do
     NewSchema.ReadFromJSon(ja.O[i]);
  {$Else}
   ja := AJSon[fpArrayName].AsArray;
   for i := 0 to ja.Count-1 do
     NewSchema.ReadFromJSon(ja[i].AsObject);
  {$EndIf}
end;

function TACBrPIXSchemaArray.GetAsJSON: String;
var
  js: TJsonObject;
begin
  js := TJsonObject.Create;
  try
    WriteToJSon(js);
    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     Result := js.ToJSON();
    {$Else}
     Result := js.Stringify;
    {$EndIf}
  finally
    js.Free;
  end;
end;

procedure TACBrPIXSchemaArray.SetAsJSON(AValue: String);
var
  js: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   js := TJsonObject.Parse(AValue) as TJsonObject;
   try
     ReadFromJSon(js);
   finally
     js.Free;
   end;
  {$Else}
   js := TJsonObject.Create;
   try
     js.Parse(AValue);
     ReadFromJSon(js);
   finally
     js.Free;
   end;
  {$EndIf}
end;

end.

