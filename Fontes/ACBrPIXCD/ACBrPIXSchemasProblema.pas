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
  ACBrBase;

type

  { TACBrPIXViolacao }

  TACBrPIXViolacao = class
  private
    fpropriedade: String;
    frazao: String;
    fvalor: String;
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TACBrPIXViolacao);

    property razao: String read frazao write frazao;
    property propriedade: String read fpropriedade write fpropriedade;
    property valor: String read fvalor write fvalor;

    procedure WriteToJSon(AJSon: TJsonObject);
    procedure ReadFromJSon(AJSon: TJsonObject);
  end;

  { TACBrPIXViolacoes }

  TACBrPIXViolacoes = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TACBrPIXViolacao;
    procedure SetItem(Index: Integer; Value: TACBrPIXViolacao);
  public
    procedure Assign(Source: TACBrPIXViolacoes);
    Function Add(AViolacao: TACBrPIXViolacao): Integer;
    Procedure Insert(Index: Integer; AViolacao: TACBrPIXViolacao);
    function New: TACBrPIXViolacao;
    property Items[Index: Integer]: TACBrPIXViolacao read GetItem write SetItem; default;

    procedure WriteToJSon(AJSon: TJsonObject);
    procedure ReadFromJSon(AJSon: TJsonObject);
  end;

  { TACBrPIXProblema }

  TACBrPIXProblema = class
  private
    fcorrelationId: String;
    fdetail: String;
    fstatus: Integer;
    ftitle: String;
    ftype_uri: String;
    fviolacoes: TACBrPIXViolacoes;
    function GetAsJSON: String;
    procedure SetAsJSON(AValue: String);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Assign(Source: TACBrPIXProblema);

    property type_uri: String read ftype_uri write ftype_uri;
    property title: String read ftitle write ftitle;
    property status: Integer read fstatus write fstatus;
    property detail: String read fdetail write fdetail;
    property correlationId: String read fcorrelationId write fcorrelationId;
    property violacoes: TACBrPIXViolacoes read fviolacoes;

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

implementation

{ TACBrPIXViolacao }

constructor TACBrPIXViolacao.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrPIXViolacao.Clear;
begin
  fpropriedade := '';
  frazao := '';
  fvalor := '';
end;

procedure TACBrPIXViolacao.Assign(Source: TACBrPIXViolacao);
begin
  fpropriedade := Source.propriedade;
  frazao := Source.razao;
  fvalor := Source.valor;
end;

procedure TACBrPIXViolacao.WriteToJSon(AJSon: TJsonObject);
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

procedure TACBrPIXViolacao.ReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   razao := AJSon.S['razao'];
   propriedade := AJSon.S['propriedade'];
   valor := AJSon.S['valor'];
  {$Else}
   razao := AJSon['razao'].AsString;
   propriedade := AJSon['propriedade'].AsString;
   valor := AJSon['valor'].AsString;
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

procedure TACBrPIXViolacoes.Assign(Source: TACBrPIXViolacoes);
var
  i: Integer;
begin
  Clear;
  for i := 0 to Source.Count-1 do
    New.Assign(Source[i]);
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
  Result := TACBrPIXViolacao.Create;
  Self.Add(Result);
end;

procedure TACBrPIXViolacoes.WriteToJSon(AJSon: TJsonObject);
var
  i: Integer;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.A['violacoes'].Clear;
   for i := 0 to Count-1 do
     Items[i].WriteToJSon(AJSon.A['violacoes'].AddObject);
  {$Else}
   AJSon['violacoes'].AsArray.Clear;
   for i := 0 to Count-1 do
     Items[i].WriteToJSon(AJSon['violacoes'].AsArray.Add.AsObject);
  {$EndIf}
end;

procedure TACBrPIXViolacoes.ReadFromJSon(AJSon: TJsonObject);
var
  ja: TJsonArray;
  i: Integer;
  jai: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ja := AJSon.A['violacoes'];
   for i := 0 to ja.Count-1 do
     New.ReadFromJSon(ja.O[i]);
  {$Else}
   ja := AJSon['violacoes'].AsArray;
   for i := 0 to ja.Count-1 do
     New.ReadFromJSon(ja[i].AsObject);
  {$EndIf}
end;

{ TACBrPIXProblema }

constructor TACBrPIXProblema.Create;
begin
  inherited;
  fviolacoes := TACBrPIXViolacoes.Create();
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

procedure TACBrPIXProblema.Assign(Source: TACBrPIXProblema);
begin
  fcorrelationId := Source.correlationId;
  fdetail := Source.detail;
  fstatus := Source.status;
  ftitle := Source.title;
  ftype_uri := Source.type_uri;
  fviolacoes.Assign(Source.violacoes);
end;

function TACBrPIXProblema.GetAsJSON: String;
var
  jo: TJsonObject;
begin
  jo := TJsonObject.Create();
  try
    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     jo.S['type'] := ftype_uri;
     jo.S['title'] := ftitle;
     jo.I['status'] := fstatus;
     if (fdetail <> '') then
       jo.S['detail'] := fdetail;
     if (fcorrelationId <> '') then
       jo.S['correlationId'] := fcorrelationId;

     fviolacoes.WriteToJSon(jo);

     Result := jo.ToJSON();
    {$Else}
     jo['type'].AsString := ftype_uri;
     jo['title'].AsString := ftitle;
     jo['status'].AsInteger := fstatus;
     if (fdetail <> '') then
       jo['detail'].AsString := fdetail;
     if (fcorrelationId <> '') then
       jo['correlationId'].AsString := fcorrelationId;

     fviolacoes.WriteToJSon(jo);

     Result := jo.Stringify;
    {$EndIf}
  finally
    jo.Free;
  end;
end;

procedure TACBrPIXProblema.SetAsJSON(AValue: String);
var
  jo: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   jo := TJsonObject.Parse(AValue) as TJsonObject;
   try
     ftype_uri := jo.S['type'];
     ftitle := jo.S['title'];
     fstatus := jo.I['status'];
     fdetail := jo.S['detail'];
     fcorrelationId := jo.S['correlationId'];
     fviolacoes.ReadFromJSon(jo);
   finally
     jo.Free;
   end;
  {$Else}
   jo := TJsonObject.Create();
   try
     jo.Parse(AValue);

     ftype_uri := jo['type'].AsString;
     ftitle := jo['title'].AsString;
     fstatus := jo['status'].AsInteger;
     fdetail := jo['detail'].AsString;
     fcorrelationId := jo['correlationId'].AsString;
     fviolacoes.ReadFromJSon(jo);
   finally
     jo.Free;
   end;
  {$EndIf}
end;

end.

