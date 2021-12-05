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

unit ACBrPIXSchemasLoteCobV;

interface

uses
  Classes, SysUtils,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrPIXBase,
  ACBrPIXSchemasParametrosConsultaCob, ACBrPIXSchemasCobV, ACBrPIXSchemasProblema;

type

  { TACBrPIXLoteCobV }

  TACBrPIXLoteCobV = class(TACBrPIXSchema)
  private
    fcriacao: TDateTime;
    fproblema: TACBrPIXProblema;
    fstatus: TACBrPIXStatusLoteCobranca;
    ftxId: String;
    procedure SetTxId(AValue: String);
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLoteCobV);

    property txId: String read ftxId write SetTxId;
    property status: TACBrPIXStatusLoteCobranca read fstatus write fstatus;
    property problema: TACBrPIXProblema read fproblema;
    property criacao: TDateTime read fcriacao write fcriacao;
  end;


  { TACBrPIXLoteCobVArray }

  TACBrPIXLoteCobVArray = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXLoteCobV;
    procedure SetItem(Index: Integer; Value: TACBrPIXLoteCobV);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(ALoteCobV: TACBrPIXLoteCobV): Integer;
    Procedure Insert(Index: Integer; ALoteCobV: TACBrPIXLoteCobV);
    function New: TACBrPIXLoteCobV;
    property Items[Index: Integer]: TACBrPIXLoteCobV read GetItem write SetItem; default;
  end;


  { TACBrPIXLoteCobVConsultado }

  TACBrPIXLoteCobVConsultado = class(TACBrPIXSchema)
  private
    fcobsv: TACBrPIXLoteCobVArray;
    fcriacao: TDateTime;
    fdescricao: String;
    fid: Int64;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLoteCobVConsultado);

    property id: Int64 read fid write fid;
    property descricao: String read fdescricao write fdescricao;
    property criacao: TDateTime read fcriacao write fcriacao;
    property cobsv: TACBrPIXLoteCobVArray read fcobsv;
  end;

  { TACBrPIXCobVSolicitadaLote }

  TACBrPIXCobVSolicitadaLote = class(TACBrPIXCobVSolicitada)
  private
    ftxId: String;
    procedure SetTxId(AValue: String);
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobVSolicitadaLote);

    property txId: String read ftxId write SetTxId;
  end;

  { TACBrPIXCobVSolicitadaLoteArray }

  TACBrPIXCobVSolicitadaLoteArray = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXCobVSolicitadaLote;
    procedure SetItem(Index: Integer; Value: TACBrPIXCobVSolicitadaLote);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(ACobV: TACBrPIXCobVSolicitadaLote): Integer;
    Procedure Insert(Index: Integer; ACobV: TACBrPIXCobVSolicitadaLote);
    function New: TACBrPIXCobVSolicitadaLote;
    property Items[Index: Integer]: TACBrPIXCobVSolicitadaLote read GetItem write SetItem; default;
  end;

  { TACBrPIXLoteCobVBody }

  TACBrPIXLoteCobVBody = class(TACBrPIXSchema)
  private
    fcobsv: TACBrPIXCobVSolicitadaLoteArray;
    fdescricao: String;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLoteCobVBody);

    property descricao: String read fdescricao write fdescricao;
    property cobsv: TACBrPIXCobVSolicitadaLoteArray read fcobsv;
  end;

  { TACBrPIXCobVRevisadaLote }

  TACBrPIXCobVRevisadaLote = class(TACBrPIXCobVRevisada)
  private
    ftxId: String;
    procedure SetTxId(AValue: String);
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobVRevisadaLote);

    property txId: String read ftxId write SetTxId;
  end;

  { TACBrPIXCobVRevisadaLoteArray }

  TACBrPIXCobVRevisadaLoteArray = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXCobVRevisadaLote;
    procedure SetItem(Index: Integer; Value: TACBrPIXCobVRevisadaLote);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(ACobV: TACBrPIXCobVRevisadaLote): Integer;
    Procedure Insert(Index: Integer; ACobV: TACBrPIXCobVRevisadaLote);
    function New: TACBrPIXCobVRevisadaLote;
    property Items[Index: Integer]: TACBrPIXCobVRevisadaLote read GetItem write SetItem; default;
  end;

  { TACBrPIXLoteCobVBodyRevisado }

  TACBrPIXLoteCobVBodyRevisado = class(TACBrPIXSchema)
  private
    fcobsv: TACBrPIXCobVRevisadaLoteArray;
    fdescricao: String;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLoteCobVBodyRevisado);

    property descricao: String read fdescricao write fdescricao;
    property cobsv: TACBrPIXCobVRevisadaLoteArray read fcobsv;
  end;

implementation

uses
  ACBrPIXUtil,
  ACBrUtil;

{ TACBrPIXLoteCobV }

constructor TACBrPIXLoteCobV.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fproblema := TACBrPIXProblema.Create('problema');
end;

destructor TACBrPIXLoteCobV.Destroy;
begin
  fproblema.Free;
  inherited Destroy;
end;

procedure TACBrPIXLoteCobV.Clear;
begin
  fcriacao := 0;
  fproblema.Clear;
  fstatus := stlNENHUM;
  ftxId := '';
end;

function TACBrPIXLoteCobV.IsEmpty: Boolean;
begin
  Result := (fcriacao = 0) and
            (fstatus = stlNENHUM) and
            (ftxId = '') and
            fproblema.IsEmpty;
end;

procedure TACBrPIXLoteCobV.Assign(Source: TACBrPIXLoteCobV);
begin
  fcriacao := Source.criacao;
  fstatus := Source.status;
  ftxId := Source.txId;
  fproblema.Assign(Source.problema);
end;

procedure TACBrPIXLoteCobV.SetTxId(AValue: String);
var
  s, e: String;
begin
  if ftxid = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') then
  begin
    e := ValidarTxId(s, 35, 26);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fTxId := s;
end;

procedure TACBrPIXLoteCobV.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (ftxId <> '') then
     AJSon.S['txId'] := ftxId;
   if (fstatus <> stlNENHUM) then
     AJSon.S['status'] := PIXStatusLoteCobrancaToString(fstatus);
   fproblema.WriteToJSon(AJSon);
   if (fcriacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(fcriacao);
  {$Else}
   if (ftxId <> '') then
     AJSon['txId'].AsString := ftxId;
   if (fstatus <> stlNENHUM) then
     AJSon['status'].AsString := PIXStatusLoteCobrancaToString(fstatus);
   fproblema.WriteToJSon(AJSon);
   if (fcriacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(fcriacao);
  {$EndIf}
end;

procedure TACBrPIXLoteCobV.DoReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ftxId := AJSon.S['txId'];
   fstatus := StringToPIXStatusLoteCobranca(AJSon.S['status']);
   fproblema.ReadFromJSon(AJSon);
   s := AJSon.S['criacao'];
  {$Else}
   ftxId := AJSon['txId'].AsString;
   fstatus := StringToPIXStatusLoteCobranca(AJSon['status'].AsString);
   fproblema.ReadFromJSon(AJSon);
   s := AJSon['criacao'].AsString;
  {$EndIf}
  if (s <> '') then
    fcriacao := Iso8601ToDateTime(s);
end;

{ TACBrPIXLoteCobVArray }

function TACBrPIXLoteCobVArray.GetItem(Index: Integer): TACBrPIXLoteCobV;
begin
  Result := TACBrPIXLoteCobV(inherited Items[Index]);
end;

procedure TACBrPIXLoteCobVArray.SetItem(Index: Integer; Value: TACBrPIXLoteCobV);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXLoteCobVArray.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXLoteCobVArray.Add(ALoteCobV: TACBrPIXLoteCobV): Integer;
begin
  Result := inherited Add(ALoteCobV);
end;

procedure TACBrPIXLoteCobVArray.Insert(Index: Integer; ALoteCobV: TACBrPIXLoteCobV);
begin
  inherited Insert(Index, ALoteCobV);
end;

function TACBrPIXLoteCobVArray.New: TACBrPIXLoteCobV;
begin
  Result := TACBrPIXLoteCobV.Create('');
  Self.Add(Result);
end;

{ TACBrPIXLoteCobVConsultado }

constructor TACBrPIXLoteCobVConsultado.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcobsv := TACBrPIXLoteCobVArray.Create('cobsv');
end;

destructor TACBrPIXLoteCobVConsultado.Destroy;
begin
  inherited Destroy;
  fcobsv.Free;
end;

procedure TACBrPIXLoteCobVConsultado.Clear;
begin
  fcobsv.Clear;
  fcriacao := 0;
  fdescricao := '';
  fid := 0;
end;

function TACBrPIXLoteCobVConsultado.IsEmpty: Boolean;
begin
  Result := fcobsv.IsEmpty and
            (fcriacao = 0) and
            (fdescricao = '') and
            (fid = 0);
end;

procedure TACBrPIXLoteCobVConsultado.Assign(Source: TACBrPIXLoteCobVConsultado);
begin
  fcobsv.Assign(Source.cobsv);
  fcriacao := Source.criacao;
  fdescricao := Source.descricao;
  fid := Source.id;
end;

procedure TACBrPIXLoteCobVConsultado.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fid <> 0) then
     AJSon.I['id'] := fid;
   if (fdescricao <> '') then
     AJSon.S['descricao'] := fdescricao;
   if (fcriacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(fcriacao);
  {$Else}
   if (fid <> 0) then
     AJSon['id'].AsInteger := fid;
   if (fdescricao <> '') then
     AJSon['descricao'].AsString := fdescricao;
   if (fcriacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(fcriacao);
  {$EndIf}
  fcobsv.WriteToJSon(AJSon);
end;

procedure TACBrPIXLoteCobVConsultado.DoReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fid := AJSon.I['id'];
   fdescricao := AJSon.S['descricao'];
   s := AJSon.S['criacao'];
  {$Else}
   fid := AJSon['id'].AsInteger;
   fdescricao := AJSon['descricao'].AsString;
   s := AJSon['criacao'].AsString;
  {$EndIf}
  if (s <> '') then
    fcriacao := Iso8601ToDateTime(s);
  fcobsv.ReadFromJSon(AJSon);
end;

{ TACBrPIXCobVSolicitadaLote }

procedure TACBrPIXCobVSolicitadaLote.Clear;
begin
  inherited Clear;
  ftxId := '';
end;

function TACBrPIXCobVSolicitadaLote.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            (ftxId = '');
end;

procedure TACBrPIXCobVSolicitadaLote.Assign(Source: TACBrPIXCobVSolicitadaLote);
begin
   inherited Assign(Source);
   ftxId := Source.txId;
end;

procedure TACBrPIXCobVSolicitadaLote.SetTxId(AValue: String);
var
  s, e: String;
begin
  if ftxid = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') then
  begin
    e := ValidarTxId(s, 35, 26);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fTxId := s;
end;

procedure TACBrPIXCobVSolicitadaLote.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['txid'] := ftxId;
  {$Else}
   AJSon['txid'].AsString := ftxId;
  {$EndIf}
  inherited DoWriteToJSon(AJSon);
end;

procedure TACBrPIXCobVSolicitadaLote.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ftxId := AJSon.S['txid'];
  {$Else}
   ftxId := AJSon['txid'].AsString;
  {$EndIf}
  inherited DoReadFromJSon(AJSon);
end;

{ TACBrPIXCobVSolicitadaLoteArray }

function TACBrPIXCobVSolicitadaLoteArray.GetItem(Index: Integer): TACBrPIXCobVSolicitadaLote;
begin
  Result := TACBrPIXCobVSolicitadaLote(inherited Items[Index]);
end;

procedure TACBrPIXCobVSolicitadaLoteArray.SetItem(Index: Integer; Value: TACBrPIXCobVSolicitadaLote);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXCobVSolicitadaLoteArray.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXCobVSolicitadaLoteArray.Add(ACobV: TACBrPIXCobVSolicitadaLote): Integer;
begin
  Result := inherited Add(ACobV);
end;

procedure TACBrPIXCobVSolicitadaLoteArray.Insert(Index: Integer; ACobV: TACBrPIXCobVSolicitadaLote);
begin
  inherited Insert(Index, ACobV);
end;

function TACBrPIXCobVSolicitadaLoteArray.New: TACBrPIXCobVSolicitadaLote;
begin
  Result := TACBrPIXCobVSolicitadaLote.Create('');
  Self.Add(Result);
end;

{ TACBrPIXLoteCobVBody }

constructor TACBrPIXLoteCobVBody.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcobsv := TACBrPIXCobVSolicitadaLoteArray.Create('cobsv');
end;

destructor TACBrPIXLoteCobVBody.Destroy;
begin
  fcobsv.Free;
  inherited Destroy;
end;

procedure TACBrPIXLoteCobVBody.Clear;
begin
  fcobsv.Clear;
  fdescricao := '';
end;

function TACBrPIXLoteCobVBody.IsEmpty: Boolean;
begin
  Result := fcobsv.IsEmpty and
            (fdescricao = '');
end;

procedure TACBrPIXLoteCobVBody.Assign(Source: TACBrPIXLoteCobVBody);
begin
  fdescricao := Source.descricao;
  fcobsv.Assign(Source.cobsv);
end;

procedure TACBrPIXLoteCobVBody.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fdescricao <> '') then
     AJSon.S['descricao'] := fdescricao;
  {$Else}
   if (fdescricao <> '') then
     AJSon['descricao'].AsString := fdescricao;
  {$EndIf}
  fcobsv.WriteToJSon(AJSon);
end;

procedure TACBrPIXLoteCobVBody.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fdescricao := AJSon.S['descricao'];
  {$Else}
   fdescricao := AJSon['descricao'].AsString;
  {$EndIf}
  fcobsv.ReadFromJSon(AJSon);
end;

{ TACBrPIXCobVRevisadaLote }

procedure TACBrPIXCobVRevisadaLote.Clear;
begin
  inherited Clear;
  ftxId := '';
end;

function TACBrPIXCobVRevisadaLote.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            (ftxId = '');
end;

procedure TACBrPIXCobVRevisadaLote.Assign(Source: TACBrPIXCobVRevisadaLote);
begin
  inherited Assign(Source);
  ftxId := Source.txId;
end;

procedure TACBrPIXCobVRevisadaLote.SetTxId(AValue: String);
var
  s, e: String;
begin
  if ftxid = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') then
  begin
    e := ValidarTxId(s, 35, 26);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fTxId := s;
end;

procedure TACBrPIXCobVRevisadaLote.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['txid'] := ftxId;
  {$Else}
   AJSon['txid'].AsString := ftxId;
  {$EndIf}
  inherited DoWriteToJSon(AJSon);
end;

procedure TACBrPIXCobVRevisadaLote.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   ftxId := AJSon.S['txid'];
  {$Else}
   ftxId := AJSon['txid'].AsString;
  {$EndIf}
  inherited DoReadFromJSon(AJSon);
end;

{ TACBrPIXCobVRevisadaLoteArray }

function TACBrPIXCobVRevisadaLoteArray.GetItem(Index: Integer): TACBrPIXCobVRevisadaLote;
begin
  Result := TACBrPIXCobVRevisadaLote(inherited Items[Index]);
end;

procedure TACBrPIXCobVRevisadaLoteArray.SetItem(Index: Integer; Value: TACBrPIXCobVRevisadaLote);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXCobVRevisadaLoteArray.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXCobVRevisadaLoteArray.Add(ACobV: TACBrPIXCobVRevisadaLote): Integer;
begin
  Result := inherited Add(ACobV);
end;

procedure TACBrPIXCobVRevisadaLoteArray.Insert(Index: Integer; ACobV: TACBrPIXCobVRevisadaLote);
begin
  inherited Insert(Index, ACobV);
end;

function TACBrPIXCobVRevisadaLoteArray.New: TACBrPIXCobVRevisadaLote;
begin
  Result := TACBrPIXCobVRevisadaLote.Create('');
  Self.Add(Result);
end;

{ TACBrPIXLoteCobVBodyRevisado }

constructor TACBrPIXLoteCobVBodyRevisado.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcobsv := TACBrPIXCobVRevisadaLoteArray.Create('cobsv');
end;

destructor TACBrPIXLoteCobVBodyRevisado.Destroy;
begin
  fcobsv.Free;
  inherited Destroy;
end;

procedure TACBrPIXLoteCobVBodyRevisado.Clear;
begin
  fcobsv.Clear;
  fdescricao := '';
end;

function TACBrPIXLoteCobVBodyRevisado.IsEmpty: Boolean;
begin
  Result := fcobsv.IsEmpty and
            (fdescricao = '');
end;

procedure TACBrPIXLoteCobVBodyRevisado.Assign(Source: TACBrPIXLoteCobVBodyRevisado);
begin
  fdescricao := Source.descricao;
  fcobsv.Assign(Source.cobsv);
end;

procedure TACBrPIXLoteCobVBodyRevisado.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fdescricao <> '') then
     AJSon.S['descricao'] := fdescricao;
  {$Else}
   if (fdescricao <> '') then
     AJSon['descricao'].AsString := fdescricao;
  {$EndIf}
  fcobsv.WriteToJSon(AJSon);
end;

procedure TACBrPIXLoteCobVBodyRevisado.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fdescricao := AJSon.S['descricao'];
  {$Else}
   fdescricao := AJSon['descricao'].AsString;
  {$EndIf}
  fcobsv.ReadFromJSon(AJSon);
end;

end.

