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

unit ACBrPIXSchemasProblema;

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
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrBase, ACBrPIXBase;

type

  { TACBrPIXViolacao }

  TACBrPIXViolacao = class(TACBrPIXSchema)
  private
    fpropriedade: String;
    frazao: String;
    fvalor: String;
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); override;
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXViolacao);

    property razao: String read frazao write frazao;
    property propriedade: String read fpropriedade write fpropriedade;
    property valor: String read fvalor write fvalor;
  end;

  { TACBrPIXViolacoes }

  TACBrPIXViolacoes = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXViolacao;
    procedure SetItem(Index: Integer; Value: TACBrPIXViolacao);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(AViolacao: TACBrPIXViolacao): Integer;
    Procedure Insert(Index: Integer; AViolacao: TACBrPIXViolacao);
    function New: TACBrPIXViolacao;
    property Items[Index: Integer]: TACBrPIXViolacao read GetItem write SetItem; default;
  end;

  { TACBrPIXProblema }

  TACBrPIXProblema = class(TACBrPIXSchema)
  private
    fcorrelationId: String;
    fdetail: String;
    fstatus: Integer;
    ftitle: String;
    ftype_uri: String;
    fviolacoes: TACBrPIXViolacoes;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXProblema);

    property type_uri: String read ftype_uri write ftype_uri;
    property title: String read ftitle write ftitle;
    property status: Integer read fstatus write fstatus;
    property detail: String read fdetail write fdetail;
    property correlationId: String read fcorrelationId write fcorrelationId;
    property violacoes: TACBrPIXViolacoes read fviolacoes;
  end;

implementation

{ TACBrPIXViolacao }

constructor TACBrPIXViolacao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXViolacao.Clear;
begin
  fpropriedade := '';
  frazao := '';
  fvalor := '';
end;

function TACBrPIXViolacao.IsEmpty: Boolean;
begin
  Result := (fpropriedade = '') and (frazao = '') and (fvalor = '');
end;

procedure TACBrPIXViolacao.AssignSchema(ASource: TACBrPIXSchema);
begin
  if (ASource is TACBrPIXViolacao) then
    Assign(TACBrPIXViolacao(ASource));
end;

procedure TACBrPIXViolacao.Assign(Source: TACBrPIXViolacao);
begin
  fpropriedade := Source.propriedade;
  frazao := Source.razao;
  fvalor := Source.valor;
end;

procedure TACBrPIXViolacao.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
  if (frazao <> '') then
    AJSon.S['razao'] := frazao;
  if (fpropriedade <> '') then
    AJSon.S['propriedade'] := fpropriedade;
  if (fvalor <> '') then
    AJSon.S['valor'] := fvalor;
  {$Else}
  if (frazao <> '') then
    AJSon['razao'].AsString := frazao;
  if (fpropriedade <> '') then
    AJSon['propriedade'].AsString := fpropriedade;
  if (fvalor <> '') then
    AJSon['valor'].AsString := fvalor;
  {$EndIf}
end;

procedure TACBrPIXViolacao.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   frazao := AJSon.S['razao'];
   fpropriedade := AJSon.S['propriedade'];
   fvalor := AJSon.S['valor'];
  {$Else}
   frazao := AJSon['razao'].AsString;
   fpropriedade := AJSon['propriedade'].AsString;
   fvalor := AJSon['valor'].AsString;
  {$EndIf}
end;

{ TACBrPIXViolacoes }

function TACBrPIXViolacoes.GetItem(Index: Integer): TACBrPIXViolacao;
begin
  Result := TACBrPIXViolacao(inherited Items[Index]);
end;

procedure TACBrPIXViolacoes.SetItem(Index: Integer; Value: TACBrPIXViolacao);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXViolacoes.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXViolacoes.Add(AViolacao: TACBrPIXViolacao): Integer;
begin
  Result := inherited Add(AViolacao);
end;

procedure TACBrPIXViolacoes.Insert(Index: Integer; AViolacao: TACBrPIXViolacao);
begin
  inherited Insert(Index, AViolacao);
end;

function TACBrPIXViolacoes.New: TACBrPIXViolacao;
begin
  Result := TACBrPIXViolacao.Create('');
  Self.Add(Result);
end;

{ TACBrPIXProblema }

constructor TACBrPIXProblema.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fviolacoes := TACBrPIXViolacoes.Create('violacoes');
  Clear;
end;

destructor TACBrPIXProblema.Destroy;
begin
  fviolacoes.Free;
  inherited Destroy;
end;

procedure TACBrPIXProblema.Clear;
begin
  fcorrelationId := '';
  fdetail := '';
  fstatus := 0;
  ftitle := '';
  ftype_uri := '';
  fviolacoes.Clear;
end;

function TACBrPIXProblema.IsEmpty: Boolean;
begin
  Result := (fcorrelationId = '') and
            (fdetail = '') and
            (fstatus = 0) and
            (ftitle = '') and
            (ftype_uri = '') and
            fviolacoes.IsEmpty;
end;

procedure TACBrPIXProblema.Assign(Source: TACBrPIXProblema);
begin
  fcorrelationId := Source.correlationId;
  fdetail := Source.detail;
  fstatus := Source.status;
  ftitle := Source.title;
  ftype_uri := Source.type_uri;
  fviolacoes.Assign(Source.violacoes);
end;

procedure TACBrPIXProblema.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['type'] := ftype_uri;
   AJSon.S['title'] := ftitle;
   AJSon.I['status'] := fstatus;
   if (fdetail <> '') then
     AJSon.S['detail'] := fdetail;
   if (fcorrelationId <> '') then
     AJSon.S['correlationId'] := fcorrelationId;
   fviolacoes.WriteToJSon(AJSon);
  {$Else}
   AJSon['type'].AsString := ftype_uri;
   AJSon['title'].AsString := ftitle;
   AJSon['status'].AsInteger := fstatus;
   if (fdetail <> '') then
     AJSon['detail'].AsString := fdetail;
   if (fcorrelationId <> '') then
     AJSon['correlationId'].AsString := fcorrelationId;
   fviolacoes.WriteToJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXProblema.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ftype_uri := AJSon.S['type'];
   ftitle := AJSon.S['title'];
   fstatus := AJSon.I['status'];
   fdetail := AJSon.S['detail'];
   fcorrelationId := AJSon.S['correlationId'];
   fviolacoes.ReadFromJSon(AJSon);
  {$Else}
   ftype_uri := AJSon['type'].AsString;
   ftitle := AJSon['title'].AsString;
   fstatus := AJSon['status'].AsInteger;
   fdetail := AJSon['detail'].AsString;
   fcorrelationId := AJSon['correlationId'].AsString;
   fviolacoes.ReadFromJSon(AJSon);
  {$EndIf}
end;

end.

