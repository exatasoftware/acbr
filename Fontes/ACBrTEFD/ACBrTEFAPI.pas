{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrTEFAPI;

interface

uses
  Classes, SysUtils,
  ACBrBase, ACBrTEFAPIClass
  {$IfNDef NOGUI}
    {$IfDef FPC}
  , LResources
    {$EndIf}
  {$EndIf};

resourcestring
  sACBrTEFAPIErrClassCreateException = 'Essa Classe deve ser instanciada por TACBrTEFAPI';
  sACBrTEFAPIErrSetModeloException = 'N�o � poss�vel mudar o Modelo de API com o ACBrTEFAPI Inicializado';
  sACBrTEFAPIErrModeloNaoDefinido = 'Modelo de API n�o definido';
  sACBrTEFAPIErrNaoInicializado = 'ACBrTEFAPI n�o foi inicializado corretamente';
  sACBrTEFAPIErrJaInicializado = 'Configura��o n�o pode ser modificada com o ACBrTEFAPI Inicializado';
  sACBrTEFAPIErrNaoImplementado = 'Procedure: %s ' + sLineBreak + ' n�o implementada para API: %s';

type

  TACBrTEFAPITipo = (taNenhum, taSiTEF, taElgin, taOKI);

  { TACBrTEFAPIIdentificacaoAplicacao }

  TACBrTEFAPIIdentificacaoAplicacao = class(TComponent)
  private
    FCNPJ: String;
    FNome: String;
    FRazaoSocial: String;
    FSoftwareHouse: String;
    FVersao: String;
    procedure SetNome(AValue: String);
    procedure SetRazaoSocial(AValue: String);
    procedure SetSoftwareHouse(AValue: String);
    procedure SetVersao(AValue: String);
  public
    constructor Create;
    procedure Clear;

  published
    property Nome: String read FNome write SetNome;
    property Versao: String read FVersao write SetVersao;
    property SoftwareHouse: String read FSoftwareHouse write SetSoftwareHouse;
    property CNPJ: String read FCNPJ write FCNPJ;
    property RazaoSocial: String read FRazaoSocial write SetRazaoSocial;
  end;

  { TACBrTEFAPIIdentificacaoEstabelecimento }

  TACBrTEFAPIIdentificacaoEstabelecimento = class(TComponent)
  private
    FCNPJ: String;
    FRazaoSocial: String;
    procedure SetRazaoSocial(AValue: String);
  public
    constructor Create;
    procedure Clear;

  published
    property CNPJ: String read FCNPJ write FCNPJ;
    property RazaoSocial: String read FRazaoSocial write SetRazaoSocial;
  end;

  { TACBrTEFAPIConfigTerminal }

  TACBrTEFAPIConfigTerminal = class(TComponent)
  private
    FCodEmpresa: String;
    FCodFilial: String;
    FCodTerminal: String;
    FOperador: String;
    FPortaPinPad: String;
  public
    constructor Create;
    procedure Clear;

  published
    property CodEmpresa: String read FCodEmpresa write FCodEmpresa;
    property CodFilial: String read FCodFilial write FCodFilial;
    property CodTerminal: String read FCodTerminal write FCodTerminal;
    property Operador: String read FOperador write FOperador;
    property PortaPinPad: String read FPortaPinPad write FPortaPinPad;
  end;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrTEFAPI = class(TACBrComponent)
  private
    FAPI: TACBrTEFAPIClass;
    FAplicacao: TACBrTEFAPIIdentificacaoAplicacao;
    FArqLOG: String;
    FPathBackup: String;
    FEstabelecimento: TACBrTEFAPIIdentificacaoEstabelecimento;
    FIP: String;
    FModelo: TACBrTEFAPITipo;
    FOnGravarLog: TACBrGravarLog;
    FPorta: String;
    FInicializado: Boolean;
    FTerminal: TACBrTEFAPIConfigTerminal;
    function GetPathBackup: String;
    procedure SetArqLOG(AValue: String);
    procedure SetInicializado(AValue: Boolean);
    procedure SetModelo(AValue: TACBrTEFAPITipo);
    procedure SetPathBackup(AValue: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Inicializar;
    procedure DesInicializar;
    procedure GravarLog(const AString: String);

    procedure RealizarPagamentoTEF(CodigoOperacao: String = ''; AValor: currency = 0);

    procedure CancelarTransacoesPendentes;
    procedure ConfirmarTransacoesPendentes(ApagarRespostasPendentes: Boolean = True);

  published
    property IP: String read FIP write FIP;
    property Porta: String read FPorta write FPorta;
    property Modelo: TACBrTEFAPITipo read FModelo write SetModelo;
    property PathBackup: String read GetPathBackup write SetPathBackup;

    property Inicializado: Boolean read FInicializado write SetInicializado;

    property ArqLOG: String read FArqLOG write SetArqLOG;
    property OnGravarLog: TACBrGravarLog read FOnGravarLog write FOnGravarLog;

    property Terminal: TACBrTEFAPIConfigTerminal read FTerminal write FTerminal;
    property Estabelecimento: TACBrTEFAPIIdentificacaoEstabelecimento read FEstabelecimento write FEstabelecimento;
    property Aplicacao: TACBrTEFAPIIdentificacaoAplicacao read FAplicacao write FAplicacao;

  end;

implementation

uses
  ACBrUtil;

{ TACBrTEFAPIConfigTerminal }

constructor TACBrTEFAPIConfigTerminal.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrTEFAPIConfigTerminal.Clear;
begin
  FCodEmpresa := '001';
  FCodFilial := '001';
  FCodTerminal := '001';
  FOperador := '';
  FPortaPinPad := '';
end;


{ TACBrTEFAPIIdentificacaoEstabelecimento }

constructor TACBrTEFAPIIdentificacaoEstabelecimento.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrTEFAPIIdentificacaoEstabelecimento.Clear;
begin
  FCNPJ := '';
  FRazaoSocial := '';
end;

procedure TACBrTEFAPIIdentificacaoEstabelecimento.SetRazaoSocial(AValue: String);
begin
  if FRazaoSocial = AValue then
    Exit;
  FRazaoSocial := Trim(AValue);
end;

{ TACBrTEFAPIIdentificacaoAplicacao }

procedure TACBrTEFAPIIdentificacaoAplicacao.SetNome(AValue: String);
begin
  if FNome = AValue then
    Exit;
  FNome := Trim(AValue);
end;

procedure TACBrTEFAPIIdentificacaoAplicacao.SetRazaoSocial(AValue: String);
begin
  if FRazaoSocial = AValue then
    Exit;
  FRazaoSocial := Trim(AValue);
end;

procedure TACBrTEFAPIIdentificacaoAplicacao.SetSoftwareHouse(AValue: String);
begin
  if FSoftwareHouse = AValue then
    Exit;
  FSoftwareHouse := Trim(AValue);
end;

procedure TACBrTEFAPIIdentificacaoAplicacao.SetVersao(AValue: String);
begin
  if FVersao = AValue then
    Exit;
  FVersao := Trim(AValue);
end;

constructor TACBrTEFAPIIdentificacaoAplicacao.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrTEFAPIIdentificacaoAplicacao.Clear;
begin
  FCNPJ := '';
  FNome := '';
  FRazaoSocial := '';
  FSoftwareHouse := '';
  FVersao := '';
end;


{ TACBrTEFAPI }

constructor TACBrTEFAPI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FIP := '';
  FPorta := '';
  FModelo := taNenhum;
  FPathBackup := '';
  FInicializado := False;

  FAPI := TACBrTEFAPIClass.Create(Self);

  FTerminal := TACBrTEFAPIConfigTerminal.Create;
  FTerminal.Name := 'ConfigTerminal';
  {$IFDEF COMPILER6_UP}
  FTerminal.SetSubComponent(True);
  {$ENDIF}

  FEstabelecimento := TACBrTEFAPIIdentificacaoEstabelecimento.Create;
  FEstabelecimento.Name := 'Estabelecimento';
  {$IFDEF COMPILER6_UP}
  FEstabelecimento.SetSubComponent(True);
  {$ENDIF}

  FAplicacao := TACBrTEFAPIIdentificacaoAplicacao.Create;
  FAplicacao.Name := 'Aplicacao';
  {$IFDEF COMPILER6_UP}
  FAplicacao.SetSubComponent(True);
  {$ENDIF}

end;

destructor TACBrTEFAPI.Destroy;
begin
  if Assigned(FAPI) then
    FreeAndNil(FAPI);

  FTerminal.Free;
  FEstabelecimento.Free;
  FAplicacao.Free;

  inherited Destroy;
end;

procedure TACBrTEFAPI.SetInicializado(AValue: Boolean);
begin
  if AValue then
    Inicializar
  else
    DesInicializar;
end;

procedure TACBrTEFAPI.Inicializar;
begin
  if FInicializado then
    Exit;

  GravarLog('Inicializar');
  FAPI.Inicializar;
  FInicializado := True;
end;

procedure TACBrTEFAPI.DesInicializar;
begin
  if not FInicializado then
    Exit;

  GravarLog('DesInicializar');
  FAPI.DesInicializar;
  FInicializado := False;
end;

procedure TACBrTEFAPI.GravarLog(const AString: String);
var
  Tratado: Boolean;
begin
  Tratado := False;
  if Assigned(FOnGravarLog) then
    FOnGravarLog(AString, Tratado);

  if (not Tratado) and (ArqLOG <> '') then
    WriteLog(ArqLOG, FormatDateTime('dd/mm/yy hh:nn:ss:zzz', now) + ' - ' + AString);
end;

procedure TACBrTEFAPI.RealizarPagamentoTEF(CodigoOperacao: String; AValor: currency);
begin
  GravarLog('RealizarPagamentoTEF(' + CodigoOperacao + ', ' + FloatToString(AValor) + ')');

end;

procedure TACBrTEFAPI.CancelarTransacoesPendentes;
begin
  GravarLog('CancelarTransacoesPendentes');
end;

procedure TACBrTEFAPI.ConfirmarTransacoesPendentes(ApagarRespostasPendentes: Boolean);
begin
  GravarLog('ConfirmarTransacoesPendentes');
end;

procedure TACBrTEFAPI.SetModelo(AValue: TACBrTEFAPITipo);
begin
  if FModelo = AValue then
    Exit;

  if Inicializado then
    raise EACBrTEFAPIException.CreateAnsiStr(sACBrTEFAPIErrSetModeloException);

  FreeAndNil(FAPI);

  { Instanciando uma nova classe de acordo com AValue }
  case AValue of
    taSiTEF:; // FAPI := TACBrTEFAPISitef.Create( Self ) ;
    taElgin:; // FAPI := TACBrTEFAPIElgin.Create( Self ) ;
  else
    FAPI := TACBrTEFAPIClass.Create(Self);
  end;

  FModelo := AValue;
end;

procedure TACBrTEFAPI.SetPathBackup(AValue: String);
begin
  if (FPathBackup = AValue) then
    Exit;

  if Inicializado then
    raise EACBrTEFAPIException.CreateAnsiStr(sACBrTEFAPIErrJaInicializado);

  FPathBackup := PathWithoutDelim(Trim(AValue));
end;

function TACBrTEFAPI.GetPathBackup: String;
begin
  if (FPathBackup = '') then
    if not (csDesigning in Self.ComponentState) then
      FPathBackup := ExtractFilePath(ParamStr(0)) + 'tef';

  Result := FPathBackup;
end;

procedure TACBrTEFAPI.SetArqLOG(AValue: String);
begin
  if FArqLOG = AValue then
    Exit;
  FArqLOG := Trim(AValue);
end;

end.
