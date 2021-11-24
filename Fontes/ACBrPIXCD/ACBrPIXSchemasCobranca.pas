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

unit ACBrPIXSchemasCobranca;

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
  ACBrBase, ACBrPIXBase,
  ACBrPIXSchemasCalendario, ACBrPIXSchemasDevedor, ACBrPIXSchemasLocation,
  ACBrPIXSchemasPix;

resourcestring
  sErroInfoAdicLimit = 'Limite de infoAdicionais atingido (50)';

type

  { TACBrPIXInfoAdicional }

  TACBrPIXInfoAdicional = class(TACBrPIXSchema)
  private
    fnome: String;
    fvalor: String;
    procedure SetNome(AValue: String);
    procedure SetValor(AValue: String);
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); override;
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXInfoAdicional);

    property nome: String read fnome write SetNome;
    property valor: String read fvalor write SetValor;
  end;

  { TACBrPIXInfoAdicionalArray }

  TACBrPIXInfoAdicionalArray = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXInfoAdicional;
    procedure SetItem(Index: Integer; Value: TACBrPIXInfoAdicional);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(AInfoAdicional: TACBrPIXInfoAdicional): Integer;
    Procedure Insert(Index: Integer; AInfoAdicional: TACBrPIXInfoAdicional);
    function New: TACBrPIXInfoAdicional;
    property Items[Index: Integer]: TACBrPIXInfoAdicional read GetItem write SetItem; default;
  end;

  { TACBrPIXRetirada }

  TACBrPIXRetirada = class(TACBrPIXSchema)
  private
    fsaque: TACBrPIXSaqueTroco;
    ftroco: TACBrPIXSaqueTroco;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXRetirada);

    property saque: TACBrPIXSaqueTroco read fsaque;
    property troco: TACBrPIXSaqueTroco read ftroco;
  end;

  { TACBrPIXCobValor }

  TACBrPIXCobValor = class(TACBrPIXSchema)
  private
    fmodalidadeAlteracao: Boolean;
    foriginal: Currency;
    fretirada: TACBrPIXRetirada;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobValor);

    property original: Currency read foriginal write foriginal;
    property modalidadeAlteracao: Boolean read fmodalidadeAlteracao write fmodalidadeAlteracao;
    property retirada: TACBrPIXRetirada read fretirada;
  end;

  { TACBrPIXCobBase }

  TACBrPIXCobBase = class(TACBrPIXSchema)
  private
    fchave: String;
    finfoAdicionais: TACBrPIXInfoAdicionalArray;
    fsolicitacaoPagador: String;
    procedure SetChave(AValue: String);
    procedure SetSolicitacaoPagador(AValue: String);
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobBase);

    property chave: String read fchave write SetChave;
    property solicitacaoPagador: String read fsolicitacaoPagador write SetSolicitacaoPagador;
    property infoAdicionais: TACBrPIXInfoAdicionalArray read finfoAdicionais;
  end;

  { TACBrPIXCobSolicitada }

  TACBrPIXCobSolicitada = class(TACBrPIXCobBase)
  private
    fcalendario: TACBrPIXCalendarioCobSolicitada;
    fdevedor: TACBrPIXDevedor;
    floc: TACBrPIXLocationCobSolicitada;
    fvalor: TACBrPIXCobValor;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobSolicitada);

    property calendario: TACBrPIXCalendarioCobSolicitada read fcalendario;
    property devedor: TACBrPIXDevedor read fdevedor;
    property loc: TACBrPIXLocationCobSolicitada read floc;
    property valor: TACBrPIXCobValor read fvalor;
  end;

  { TACBrPIXCobRevisada }

  TACBrPIXCobRevisada = class(TACBrPIXCobBase)
  private
    fcalendario: TACBrPIXCalendarioCobSolicitada;
    fdevedor: TACBrPIXDevedor;
    floc: TACBrPIXLocationCobRevisada;
    fstatus: TACBrPIXStatusCobranca;
    fvalor: TACBrPIXCobValor;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobRevisada);

    property calendario: TACBrPIXCalendarioCobSolicitada read fcalendario;
    property devedor: TACBrPIXDevedor read fdevedor;
    property loc: TACBrPIXLocationCobRevisada read floc;
    property status: TACBrPIXStatusCobranca read fstatus write fstatus;
    property valor: TACBrPIXCobValor read fvalor;
  end;

  { TACBrPIXCobBaseCopiaCola }

  TACBrPIXCobBaseCopiaCola = class(TACBrPIXCobBase)
  private
    fpixCopiaECola: String;
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobBaseCopiaCola);

    property pixCopiaECola: String read fpixCopiaECola write fpixCopiaECola;
  end;

  { TACBrPIXCobGerada }

  TACBrPIXCobGerada = class(TACBrPIXCobBaseCopiaCola)
  private
    fcalendario: TACBrPIXCalendarioCobGerada;
    fdevedor: TACBrPIXDevedor;
    floc: TACBrPIXLocation;
    flocation: String;
    frevisao: Integer;
    fstatus: TACBrPIXStatusCobranca;
    ftxId: String;
    fvalor: TACBrPIXCobValor;
    procedure SetRevisao(AValue: Integer);
    procedure SetTxId(AValue: String);
  protected
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    destructor Destroy; override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCobGerada);

    property calendario: TACBrPIXCalendarioCobGerada read fcalendario;
    property txId: String read ftxId write SetTxId;
    property revisao: Integer read frevisao write SetRevisao;
    property devedor: TACBrPIXDevedor read fdevedor;
    property loc: TACBrPIXLocation read floc;
    property location: String read flocation;
    property status: TACBrPIXStatusCobranca read fstatus write fstatus;
    property valor: TACBrPIXCobValor read fvalor;
  end;

  { TACBrPIXCobCompleta }

  TACBrPIXCobCompleta = class(TACBrPIXCobGerada)
  private
    fpix: TACBrPIXArray;
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); override;
    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; reintroduce;
    function IsEmpty: Boolean; override;
    destructor Destroy; override;
    procedure Assign(Source: TACBrPIXCobCompleta);

    property pix: TACBrPIXArray read fpix;
  end;

  { TACBrPIXCobCompletaArray }

  TACBrPIXCobCompletaArray = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXCobCompleta;
    procedure SetItem(Index: Integer; Value: TACBrPIXCobCompleta);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(ACob: TACBrPIXCobCompleta): Integer;
    Procedure Insert(Index: Integer; ACob: TACBrPIXCobCompleta);
    function New: TACBrPIXCobCompleta;
    property Items[Index: Integer]: TACBrPIXCobCompleta read GetItem write SetItem; default;
  end;


implementation

uses
  DateUtils, Math,
  ACBrUtil, ACBrConsts, ACBrPIXUtil;

{ TACBrPIXInfoAdicional }

constructor TACBrPIXInfoAdicional.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXInfoAdicional.Clear;
begin
  fnome := '';
  fvalor := '';
end;

function TACBrPIXInfoAdicional.IsEmpty: Boolean;
begin
  Result := (fnome = '') and (fvalor = '');
end;

procedure TACBrPIXInfoAdicional.AssignSchema(ASource: TACBrPIXSchema);
begin
  if (ASource is TACBrPIXInfoAdicional) then
    Assign(TACBrPIXInfoAdicional(ASource));
end;

procedure TACBrPIXInfoAdicional.Assign(Source: TACBrPIXInfoAdicional);
begin
  fnome := Source.nome;
  fvalor := Source.valor;
end;

procedure TACBrPIXInfoAdicional.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['nome'] := fnome;
   AJSon.S['valor'] := fvalor;
  {$Else}
   AJSon['nome'].AsString := fnome;
   AJSon['valor'].AsString := fvalor;
  {$EndIf}
end;

procedure TACBrPIXInfoAdicional.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   nome := AJSon.S['nome'];
   valor := AJSon.S['valor'];
  {$Else}
   nome := AJSon['nome'].AsString;
   valor := AJSon['valor'].AsString;
  {$EndIf}
end;

procedure TACBrPIXInfoAdicional.SetNome(AValue: String);
begin
  if fnome = AValue then
    Exit;
  fnome := copy(AValue, 1, 50);
end;

procedure TACBrPIXInfoAdicional.SetValor(AValue: String);
begin
  if fvalor = AValue then
    Exit;
  fvalor := copy(AValue, 1, 200);
end;

{ TACBrPIXInfoAdicionalArray }

function TACBrPIXInfoAdicionalArray.GetItem(Index: Integer): TACBrPIXInfoAdicional;
begin
  Result := TACBrPIXInfoAdicional(inherited Items[Index]);
end;

procedure TACBrPIXInfoAdicionalArray.SetItem(Index: Integer; Value: TACBrPIXInfoAdicional);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXInfoAdicionalArray.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXInfoAdicionalArray.Add(AInfoAdicional: TACBrPIXInfoAdicional): Integer;
begin
  if Count >= 50 then
    raise EACBrPixException.Create(ACBrStr(sErroInfoAdicLimit));

  Result := inherited Add(AInfoAdicional);
end;

procedure TACBrPIXInfoAdicionalArray.Insert(Index: Integer; AInfoAdicional: TACBrPIXInfoAdicional);
begin
  inherited Insert(Index, AInfoAdicional);
end;

function TACBrPIXInfoAdicionalArray.New: TACBrPIXInfoAdicional;
begin
  Result := TACBrPIXInfoAdicional.Create('');
  Self.Add(Result);
end;

{ TACBrPIXRetirada }

constructor TACBrPIXRetirada.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fsaque := TACBrPIXSaqueTroco.Create('saque', 'prestadorDoServicoDeSaque');
  ftroco := TACBrPIXSaqueTroco.Create('troco', 'prestadorDoServicoDeSaque');
end;

destructor TACBrPIXRetirada.Destroy;
begin
  fsaque.Free;
  ftroco.Free;
  inherited Destroy;
end;

procedure TACBrPIXRetirada.Clear;
begin
  fsaque.Clear;
  ftroco.Clear;
end;

function TACBrPIXRetirada.IsEmpty: Boolean;
begin
  Result := fsaque.IsEmpty and
            ftroco.IsEmpty;
end;

procedure TACBrPIXRetirada.Assign(Source: TACBrPIXRetirada);
begin
  fsaque.Assign(Source.saque);
  ftroco.Assign(Source.troco);
end;

procedure TACBrPIXRetirada.DoWriteToJSon(AJSon: TJsonObject);
begin
  if not saque.IsEmpty then
    saque.WriteToJSon(AJSon)
  else if not troco.IsEmpty then
    troco.WriteToJSon(AJSon);
end;

procedure TACBrPIXRetirada.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   saque.ReadFromJSon(AJSon);
   troco.ReadFromJSon(AJSon);
  {$Else}
   saque.ReadFromJSon(AJSon);
   troco.ReadFromJSon(AJSon);
  {$EndIf}
end;

{ TACBrPIXCobValor }

constructor TACBrPIXCobValor.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fretirada := TACBrPIXRetirada.Create('retirada');
  Clear;
end;

destructor TACBrPIXCobValor.Destroy;
begin
  fretirada.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobValor.Clear;
begin
  foriginal := 0;
  fmodalidadeAlteracao := False;
  fretirada.Clear;
end;

function TACBrPIXCobValor.IsEmpty: Boolean;
begin
  Result := (foriginal = 0) and  // (fmodalidadeAlteracao = False) and
            fretirada.IsEmpty;
end;

procedure TACBrPIXCobValor.Assign(Source: TACBrPIXCobValor);
begin
  foriginal := Source.original;
  fmodalidadeAlteracao := Source.modalidadeAlteracao;
  fretirada.Assign(Source.retirada);
end;

procedure TACBrPIXCobValor.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   AJSon.S['original'] := FormatarValorPIX(original);
   AJSon.I['modalidadeAlteracao'] := IfThen(modalidadeAlteracao, 1, 0);
  {$Else}
   AJSon['original'].AsString := FormatarValorPIX(original);
   AJSon['modalidadeAlteracao'].AsInteger := IfThen(modalidadeAlteracao, 1, 0);
  {$EndIf}
  retirada.WriteToJSon(AJSon);
end;

procedure TACBrPIXCobValor.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   original := StringToFloatDef( AJSon.S['original'], 0 );
   modalidadeAlteracao := (AJSon.I['modalidadeAlteracao'] = 1);
  {$Else}
   original := StringToFloatDef( AJSon['original'].AsString, 0 );
   modalidadeAlteracao := (AJSon['modalidadeAlteracao'].AsInteger = 1);
  {$EndIf}
  retirada.ReadFromJSon(AJSon);
end;

{ TACBrPIXCobBase }

constructor TACBrPIXCobBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  finfoAdicionais := TACBrPIXInfoAdicionalArray.Create('infoAdicionais');
  Clear;
end;

destructor TACBrPIXCobBase.Destroy;
begin
  finfoAdicionais.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobBase.Clear;
begin
  fchave := '';
  fsolicitacaoPagador := '';
  finfoAdicionais.Clear;
end;

function TACBrPIXCobBase.IsEmpty: Boolean;
begin
  Result := (fchave = '') and
            (fsolicitacaoPagador = '') and
            finfoAdicionais.IsEmpty;
end;

procedure TACBrPIXCobBase.Assign(Source: TACBrPIXCobBase);
begin
  fchave := Source.chave;
  fsolicitacaoPagador := Source.solicitacaoPagador;
  finfoAdicionais.Assign(Source.infoAdicionais);
end;

procedure TACBrPIXCobBase.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fchave <> '') then
     AJSon.S['chave'] := fchave;
   if (fsolicitacaoPagador <> '') then
     AJSon.S['solicitacaoPagador'] := fsolicitacaoPagador;
   finfoAdicionais.WriteToJSon(AJSon);
  {$Else}
   if (fchave <> '') then
     AJSon['chave'].AsString := fchave;
   if (fsolicitacaoPagador <> '') then
     AJSon['solicitacaoPagador'].AsString := fsolicitacaoPagador;
   finfoAdicionais.WriteToJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXCobBase.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fchave := AJSon.S['chave'];
   fsolicitacaoPagador := AJSon.S['solicitacaoPagador'];
   finfoAdicionais.ReadFromJSon(AJSon);
  {$Else}
   fchave := AJSon['chave'].AsString;
   fsolicitacaoPagador := AJSon['solicitacaoPagador'].AsString;
   finfoAdicionais.ReadFromJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXCobBase.SetChave(AValue: String);
var
  e: String;
begin
  if fchave = AValue then
    Exit;

  e := ValidarChave(AValue);
  if (e <> '') then
    raise EACBrPixException.Create(ACBrStr(e));

  fchave := AValue;
end;

procedure TACBrPIXCobBase.SetSolicitacaoPagador(AValue: String);
begin
  if fsolicitacaoPagador = AValue then
    Exit;
  fsolicitacaoPagador := copy(AValue, 1, 140);
end;

{ TACBrPIXCobSolicitada }

constructor TACBrPIXCobSolicitada.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcalendario := TACBrPIXCalendarioCobSolicitada.Create('calendario');
  fdevedor := TACBrPIXDevedor.Create('devedor');
  floc := TACBrPIXLocationCobSolicitada.Create('loc');
  fvalor := TACBrPIXCobValor.Create('valor');
  Clear;
end;

destructor TACBrPIXCobSolicitada.Destroy;
begin
  fcalendario.Free;
  fdevedor.Free;
  floc.Free;
  fvalor.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobSolicitada.Clear;
begin
  inherited Clear;
  fcalendario.Clear;
  fdevedor.Clear;
  floc.Clear;
  fvalor.Clear;
end;

function TACBrPIXCobSolicitada.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            fcalendario.IsEmpty and
            fdevedor.IsEmpty and
            floc.IsEmpty and
            fvalor.IsEmpty;
end;

procedure TACBrPIXCobSolicitada.Assign(Source: TACBrPIXCobSolicitada);
begin
  inherited Assign(Source);
  fcalendario.Assign(Source.calendario);
  fdevedor.Assign(Source.devedor);
  floc.Assign(Source.loc);
  fvalor.Assign(Source.valor);
end;

procedure TACBrPIXCobSolicitada.DoWriteToJSon(AJSon: TJsonObject);
begin
  inherited DoWriteToJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.WriteToJSon(AJSon);
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   fvalor.WriteToJSon(AJSon);
  {$Else}
   fcalendario.WriteToJSon(AJSon);
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   fvalor.WriteToJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXCobSolicitada.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  inherited DoReadFromJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.ReadFromJSon(AJSon);
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   fvalor.ReadFromJSon(AJSon);
  {$Else}
   fcalendario.ReadFromJSon(AJSon);
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   fvalor.ReadFromJSon(AJSon);
  {$EndIf}
end;

{ TACBrPIXCobBaseCopiaCola }

procedure TACBrPIXCobBaseCopiaCola.Clear;
begin
  inherited Clear;
  fpixCopiaECola := '';
end;

function TACBrPIXCobBaseCopiaCola.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            (fpixCopiaECola = '');
end;

procedure TACBrPIXCobBaseCopiaCola.Assign(Source: TACBrPIXCobBaseCopiaCola);
begin
  inherited Assign(Source);
  fpixCopiaECola := Source.pixCopiaECola;
end;

procedure TACBrPIXCobBaseCopiaCola.DoWriteToJSon(AJSon: TJsonObject);
begin
  inherited DoWriteToJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fpixCopiaECola <> '') then
     AJSon.S['pixCopiaECola'] := fpixCopiaECola;
  {$Else}
   if (fpixCopiaECola <> '') then
     AJSon['pixCopiaECola'].AsString := fpixCopiaECola;
  {$EndIf}
end;

procedure TACBrPIXCobBaseCopiaCola.DoReadFromJSon(AJSon: TJsonObject);
begin
  inherited DoReadFromJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fpixCopiaECola := AJSon.S['pixCopiaECola'];
  {$Else}
   fpixCopiaECola := AJSon['pixCopiaECola'].AsString;
  {$EndIf}
end;

{ TACBrPIXCobGerada }

constructor TACBrPIXCobGerada.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcalendario := TACBrPIXCalendarioCobGerada.Create('calendario');
  fdevedor := TACBrPIXDevedor.Create('devedor');
  floc := TACBrPIXLocation.Create('loc');
  fvalor := TACBrPIXCobValor.Create('valor');
  Clear;
end;

destructor TACBrPIXCobGerada.Destroy;
begin
  fcalendario.Free;
  fdevedor.Free;
  floc.Free;
  fvalor.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobGerada.Clear;
begin
  inherited Clear;
  fcalendario.Clear;
  fdevedor.Clear;
  floc.Clear;
  fvalor.Clear;
  flocation := '';
  frevisao := 0;
  fstatus := stcNENHUM;
  ftxId := '';
end;

function TACBrPIXCobGerada.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            fcalendario.IsEmpty and
            fdevedor.IsEmpty and
            floc.IsEmpty and
            fvalor.IsEmpty and
            (flocation = '') and
            (frevisao = 0) and
            (fstatus = stcNENHUM) and
            (ftxId = '');
end;

procedure TACBrPIXCobGerada.Assign(Source: TACBrPIXCobGerada);
begin
  inherited Assign(Source);
  fcalendario.Assign(Source.calendario);
  fdevedor.Assign(Source.devedor);
  floc.Assign(Source.loc);
  fvalor.Assign(Source.valor);
  flocation := Source.location;
  frevisao := Source.revisao;
  fstatus := Source.status;
  ftxId := Source.txId;
end;

procedure TACBrPIXCobGerada.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.WriteToJSon(AJSon);
   AJSon.S['txid'] := ftxId;
   AJSon.I['revisao'] := frevisao;
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   AJSon.S['location'] := flocation;
   AJSon.S['status'] := PIXStatusCobrancaToString(fstatus);
   fvalor.WriteToJSon(AJSon);
  {$Else}
   fcalendario.WriteToJSon(AJSon);
   AJSon['txid'].AsString := ftxId;
   AJSon['revisao'].AsInteger := frevisao;
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   AJSon['location'].AsString := flocation;
   AJSon['status'].AsString := PIXStatusCobrancaToString(fstatus);
   fvalor.WriteToJSon(AJSon);
  {$EndIf}
  inherited DoWriteToJSon(AJSon);
end;

procedure TACBrPIXCobGerada.DoReadFromJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.ReadFromJSon(AJSon);
   ftxId := AJSon.S['txid'];
   frevisao := AJSon.I['revisao'];
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   flocation := AJSon.S['location'];
   fstatus := StringToPIXStatusCobranca(AJSon.S['status']);
   fvalor.ReadFromJSon(AJSon);
  {$Else}
   fcalendario.ReadFromJSon(AJSon);
   ftxId := AJSon['txid'].AsString;
   frevisao := AJSon['revisao'].AsInteger;
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   flocation := AJSon['location'].AsString;
   fstatus := StringToPIXStatusCobranca(AJSon['status'].AsString);
   fvalor.ReadFromJSon(AJSon);
  {$EndIf}
  inherited DoReadFromJSon(AJSon);
end;

procedure TACBrPIXCobGerada.SetTxId(AValue: String);
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

procedure TACBrPIXCobGerada.SetRevisao(AValue: Integer);
begin
  if frevisao = AValue then
    Exit;
  frevisao := max(AValue,0);
end;

{ TACBrPIXCobRevisada }

constructor TACBrPIXCobRevisada.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fcalendario := TACBrPIXCalendarioCobSolicitada.Create('calendario');
  fdevedor := TACBrPIXDevedor.Create('devedor');
  floc := TACBrPIXLocationCobRevisada.Create('loc');
  fvalor := TACBrPIXCobValor.Create('valor');
  Clear;
end;

destructor TACBrPIXCobRevisada.Destroy;
begin
  fcalendario.Free;
  fdevedor.Free;
  floc.Free;
  fvalor.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobRevisada.Clear;
begin
  inherited Clear;
  fcalendario.Clear;
  fdevedor.Clear;
  floc.Clear;
  fvalor.Clear;
  fstatus := stcNENHUM;
end;

function TACBrPIXCobRevisada.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            fcalendario.IsEmpty and
            fdevedor.IsEmpty and
            floc.IsEmpty and
            fvalor.IsEmpty and
            (fstatus = stcNENHUM);
end;

procedure TACBrPIXCobRevisada.Assign(Source: TACBrPIXCobRevisada);
begin
  inherited Assign(Source);
  fcalendario.Assign(Source.calendario);
  fdevedor.Assign(Source.devedor);
  floc.Assign(Source.loc);
  fvalor.Assign(Source.valor);
  fstatus := Source.status;
end;

procedure TACBrPIXCobRevisada.DoWriteToJSon(AJSon: TJsonObject);
begin
  inherited DoWriteToJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.WriteToJSon(AJSon);
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   AJSon.S['status'] := PIXStatusCobrancaToString(fstatus);
   fvalor.WriteToJSon(AJSon);
  {$Else}
   fcalendario.WriteToJSon(AJSon);
   fdevedor.WriteToJSon(AJSon);
   floc.WriteToJSon(AJSon);
   AJSon['status'].AsString := PIXStatusCobrancaToString(fstatus);
   fvalor.WriteToJSon(AJSon);
  {$EndIf}
end;

procedure TACBrPIXCobRevisada.DoReadFromJSon(AJSon: TJsonObject);
begin
  Clear;
  inherited DoReadFromJSon(AJSon);
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fcalendario.ReadFromJSon(AJSon);
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   fstatus := StringToPIXStatusCobranca(AJSon.S['status']);
   fvalor.ReadFromJSon(AJSon);
  {$Else}
   fcalendario.ReadFromJSon(AJSon);
   fdevedor.ReadFromJSon(AJSon);
   floc.ReadFromJSon(AJSon);
   fstatus := StringToPIXStatusCobranca(AJSon['status'].AsString);
   fvalor.ReadFromJSon(AJSon);
  {$EndIf}
 end;

{ TACBrPIXCobCompleta }

constructor TACBrPIXCobCompleta.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fpix := TACBrPIXArray.Create('pix');
  Clear;
end;

destructor TACBrPIXCobCompleta.Destroy;
begin
  fpix.Free;
  inherited Destroy;
end;

procedure TACBrPIXCobCompleta.Clear;
begin
  fpix.Clear;
  inherited Clear;
end;

function TACBrPIXCobCompleta.IsEmpty: Boolean;
begin
  Result := inherited IsEmpty and
            fpix.IsEmpty;
end;

procedure TACBrPIXCobCompleta.AssignSchema(ASource: TACBrPIXSchema);
begin
  if (ASource is TACBrPIXCobCompleta) then
    Assign(TACBrPIXCobCompleta(ASource));
end;

procedure TACBrPIXCobCompleta.Assign(Source: TACBrPIXCobCompleta);
begin
  inherited Assign(Source);
  fpix.Assign(Source.pix);
end;

procedure TACBrPIXCobCompleta.DoWriteToJSon(AJSon: TJsonObject);
begin
  inherited DoWriteToJSon(AJSon);
  fpix.WriteToJSon(AJSon);
end;

procedure TACBrPIXCobCompleta.DoReadFromJSon(AJSon: TJsonObject);
begin
  inherited DoReadFromJSon(AJSon);
  fpix.ReadFromJSon(AJSon);
end;

{ TACBrPIXCobCompletaArray }

function TACBrPIXCobCompletaArray.GetItem(Index: Integer): TACBrPIXCobCompleta;
begin
  Result := TACBrPIXCobCompleta(inherited Items[Index]);
end;

procedure TACBrPIXCobCompletaArray.SetItem(Index: Integer; Value: TACBrPIXCobCompleta);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXCobCompletaArray.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXCobCompletaArray.Add(ACob: TACBrPIXCobCompleta): Integer;
begin
  Result := inherited Add(ACob);
end;

procedure TACBrPIXCobCompletaArray.Insert(Index: Integer; ACob: TACBrPIXCobCompleta);
begin
  inherited Insert(Index, ACob);
end;

function TACBrPIXCobCompletaArray.New: TACBrPIXCobCompleta;
begin
  Result := TACBrPIXCobCompleta.Create('');
  Self.Add(Result);
end;

end.

