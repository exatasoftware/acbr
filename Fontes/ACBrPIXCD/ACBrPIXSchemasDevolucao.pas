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

unit ACBrPIXSchemasDevolucao;

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

  { TACBrPIXHorario }

  TACBrPIXHorario = class(TACBrPIXSchema)
  private
    fliquidacao: TDateTime;
    fsolicitacao: TDateTime;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXHorario);

    property solicitacao: TDateTime read fsolicitacao write fsolicitacao;
    property liquidacao: TDateTime read fliquidacao write fliquidacao;
  end;

  { TACBrPIXDevolucao }

  TACBrPIXDevolucao = class(TACBrPIXSchema)
  private
    fdescricao: String;
    fhorario: TACBrPIXHorario;
    fid: String;
    fmotivo: String;
    fnatureza: TACBrPIXNaturezaDevolucao;
    frtrId: String;
    fstatus: TACBrPIXStatusDevolucao;
    fvalor: Currency;
    procedure SetDescricao(AValue: String);
    procedure Setid(AValue: String);
    procedure Setmotivo(AValue: String);
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); override;
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXDevolucao);

    property id: String read fid write Setid;
    property rtrId: String read frtrId write frtrId;
    property valor: Currency read fvalor write fvalor;
    property natureza: TACBrPIXNaturezaDevolucao read fnatureza write fnatureza;
    property descricao: String read fdescricao write SetDescricao;
    property horario: TACBrPIXHorario read fhorario;
    property status: TACBrPIXStatusDevolucao read fstatus write fstatus;
    property motivo: String read fmotivo write Setmotivo;
  end;

  { TACBrPIXDevolucoes }

  TACBrPIXDevolucoes = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXDevolucao;
    procedure SetItem(Index: Integer; Value: TACBrPIXDevolucao);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(ADevolucao: TACBrPIXDevolucao): Integer;
    Procedure Insert(Index: Integer; ADevolucao: TACBrPIXDevolucao);
    function New: TACBrPIXDevolucao;
    property Items[Index: Integer]: TACBrPIXDevolucao read GetItem write SetItem; default;
  end;


implementation

uses
  ACBrPIXUtil, ACBrUtil;

{ TACBrPIXHorario }

constructor TACBrPIXHorario.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXHorario.Clear;
begin
  fsolicitacao := 0;
  fliquidacao := 0;
end;

function TACBrPIXHorario.IsEmpty: Boolean;
begin
  Result := (fsolicitacao = 0) and (fliquidacao = 0);
end;

procedure TACBrPIXHorario.Assign(Source: TACBrPIXHorario);
begin
  fsolicitacao := Source.solicitacao;
  fliquidacao := Source.liquidacao;
end;

procedure TACBrPIXHorario.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['solicitacao'] := DateTimeToIso8601( fsolicitacao );
   AJSon.S['liquidacao'] := DateTimeToIso8601( fliquidacao );
  {$Else}
   AJSon['solicitacao'].AsString := DateTimeToIso8601( fsolicitacao );
   AJSon['liquidacao'].AsString := DateTimeToIso8601( fliquidacao );
  {$EndIf}
end;

procedure TACBrPIXHorario.DoReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   s := AJSon.S['solicitacao'];
   if (s <> '') then
     fsolicitacao := Iso8601ToDateTime(s);
   s := AJSon.S['liquidacao'];
   if (s <> '') then
     fliquidacao := Iso8601ToDateTime(s);
  {$Else}
   s := AJSon['solicitacao'].AsString;
   if (s <> '') then
     fsolicitacao := Iso8601ToDateTime(s);
   s := AJSon['liquidacao'].AsString;
   if (s <> '') then
     fliquidacao := Iso8601ToDateTime(s);
  {$EndIf}
end;

{ TACBrPIXDevolucao }

constructor TACBrPIXDevolucao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fhorario := TACBrPIXHorario.Create('horario');
  Clear;
end;

destructor TACBrPIXDevolucao.Destroy;
begin
  fhorario.Free;
  inherited Destroy;
end;

procedure TACBrPIXDevolucao.Clear;
begin
  fdescricao := '';
  fid := '';
  fmotivo := '';
  fnatureza := ndNENHUMA;
  frtrId := '';
  fstatus := stdNENHUM;
  fvalor := 0;
  fhorario.Clear;
end;

function TACBrPIXDevolucao.IsEmpty: Boolean;
begin
  Result := (fdescricao = '') and
            (fid = '') and
            (fmotivo = '') and
            (fnatureza = ndNENHUMA) and
            (frtrId = '') and
            (fstatus = stdNENHUM) and
            (fvalor = 0) and
            fhorario.IsEmpty;
end;

procedure TACBrPIXDevolucao.AssignSchema(ASource: TACBrPIXSchema);
begin
  if (ASource is TACBrPIXDevolucao) then
    Assign(TACBrPIXDevolucao(ASource));
end;

procedure TACBrPIXDevolucao.Assign(Source: TACBrPIXDevolucao);
begin
  fdescricao := Source.descricao;
  fid := Source.id;
  fmotivo := Source.motivo;
  fnatureza := Source.natureza;
  frtrId := Source.rtrId;
  fstatus := Source.status;
  fvalor := Source.valor;
  fhorario.Assign(Source.horario);
end;

procedure TACBrPIXDevolucao.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['descricao'] := fdescricao;
   AJSon.S['id'] := fid;
   AJSon.S['motivo'] := fmotivo;
   AJSon.S['natureza'] := PIXNaturezaDevolucaoToString(fnatureza);
   AJSon.S['rtrId'] := frtrId;
   AJSon.S['status'] := PIXStatusDevolucaoToString(fstatus);
   AJSon.S['valor'] := FormatarValorPIX(fvalor);
   fhorario.WriteToJSon(AJSon);
  {$Else}
   AJSon['descricao'].AsString := fdescricao;
   AJSon['id'].AsString := fid;
   AJSon['motivo'].AsString := fmotivo;
   AJSon['natureza'].AsString := PIXNaturezaDevolucaoToString(fnatureza);
   AJSon['rtrId'].AsString := frtrId;
   AJSon['status'].AsString := PIXStatusDevolucaoToString(fstatus);
   AJSon['valor'].AsString := FormatarValorPIX(fvalor);
   fhorario.WriteToJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXDevolucao.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fdescricao := AJSon.S['descricao'];
   fid := AJSon.S['id'];
   fmotivo := AJSon.S['motivo'];
   fnatureza := StringToPIXNaturezaDevolucao( AJSon.S['natureza'] );
   frtrId := AJSon.S['rtrId'];
   fstatus := StringToPIXStatusDevolucao( AJSon.S['status'] );
   fvalor := StringToFloat( AJSon.S['valor']);
   fhorario.ReadFromJSon(AJSon);
  {$Else}
   fdescricao := AJSon['descricao'].AsString;
   fid := AJSon['id'].AsString;
   fmotivo := AJSon['motivo'].AsString;
   fnatureza := StringToPIXNaturezaDevolucao(AJSon['natureza'].AsString);
   frtrId := AJSon['rtrId'].AsString;
   fstatus := StringToPIXStatusDevolucao(AJSon['status'].AsString);
   fvalor := StringToFloat(AJSon['valor'].AsString);
   fhorario.ReadFromJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXDevolucao.SetDescricao(AValue: String);
begin
  if fdescricao = AValue then
    Exit;
  fdescricao := copy(AValue, 1, 140);
end;

procedure TACBrPIXDevolucao.Setid(AValue: String);
var
  e: String;
begin
  if fid = AValue then
    Exit;

  e := ValidarTxId(AValue, 35, 1);
  if (e <> '') then
    raise EACBrPixException.Create(ACBrStr(e));

  fId := AValue;
end;

procedure TACBrPIXDevolucao.Setmotivo(AValue: String);
begin
  if fmotivo = AValue then
    Exit;
  fmotivo :=copy(AValue, 1, 140);
end;

{ TACBrPIXDevolucoes }

function TACBrPIXDevolucoes.GetItem(Index: Integer): TACBrPIXDevolucao;
begin
  Result := TACBrPIXDevolucao(inherited Items[Index]);
end;

procedure TACBrPIXDevolucoes.SetItem(Index: Integer; Value: TACBrPIXDevolucao);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXDevolucoes.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXDevolucoes.Add(ADevolucao: TACBrPIXDevolucao): Integer;
begin
  Result := inherited Add(ADevolucao);
end;

procedure TACBrPIXDevolucoes.Insert(Index: Integer; ADevolucao: TACBrPIXDevolucao
  );
begin
  inherited Insert(Index, ADevolucao);
end;

function TACBrPIXDevolucoes.New: TACBrPIXDevolucao;
begin
  Result := TACBrPIXDevolucao.Create('');
  Self.Add(Result);
end;

end.

