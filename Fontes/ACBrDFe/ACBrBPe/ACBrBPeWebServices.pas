{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

{$I ACBr.inc}

unit ACBrBPeWebServices;

interface

uses
  Classes, SysUtils, dateutils, blcksock, synacode,
  ACBrDFe, ACBrDFeUtil, ACBrDFeWebService,
  pcnAuxiliar, pcnConversao, pcnBPe, pcnConversaoBPe, pcnProcBPe,
  pcnEnvEventoBPe, pcnRetEnvEventoBPe, pcnRetConsSitBPe, pcnDistDFeInt,
  pcnRetDistDFeInt, pcnRetEnvBPe, ACBrBPeBilhetes, ACBrBPeConfiguracoes;

type

  { TBPeWebService }

  TBPeWebService = class(TDFeWebService)
  private
    FOldSSLType: TSSLType;
    FOldHeaderElement: String;
  protected
    FPStatus: TStatusACBrBPe;
    FPLayout: TLayOutBPe;
    FPConfiguracoesBPe: TConfiguracoesBPe;

  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    function GerarVersaoDadosSoap: String; override;
    procedure FinalizarServico; override;

  public
    constructor Create(AOwner: TACBrDFe); override;
    procedure Clear; override;

    property Status: TStatusACBrBPe read FPStatus;
    property Layout: TLayOutBPe read FPLayout;
  end;

  { TBPeStatusServico }

  TBPeStatusServico = class(TBPeWebService)
  private
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FTMed: Integer;
    FdhRetorno: TDateTime;
    FxObs: String;
  protected
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
    procedure Clear; override;

    property versao: String read Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: Integer read FcUF;
    property dhRecbto: TDateTime read FdhRecbto;
    property TMed: Integer read FTMed;
    property dhRetorno: TDateTime read FdhRetorno;
    property xObs: String read FxObs;
  end;

  { TBPeRecepcao }

  TBPeRecepcao = class(TBPeWebService)
  private
    FLote: String;
    FBilhetes: TBilhetes;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FcUF: Integer;
    FxMotivo: String;
    FdhRecbto: TDateTime;
    FTMed: Integer;
    FProtocolo: String;
    FMsgUnZip: String;
    FVersaoDF: TVersaoBPe;

    FBPeRetorno: TretEnvBPe;

    function GetLote: String;
  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    procedure SalvarEnvio; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ABilhetes: TBilhetes);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property cUF: Integer read FcUF;
    property xMotivo: String read FxMotivo;
    property dhRecbto: TDateTime read FdhRecbto;
    property TMed: Integer read FTMed;
    property Protocolo: String read FProtocolo;
    property Lote: String read GetLote write FLote;
    property MsgUnZip: String read FMsgUnZip write FMsgUnZip;

    property BPeRetorno: TretEnvBPe read FBPeRetorno;
  end;

  { TBPeConsulta }

  TBPeConsulta = class(TBPeWebService)
  private
    FOwner: TACBrDFe;
    FBPeChave: String;
    FExtrairEventos: Boolean;
    FBilhetes: TBilhetes;
    FProtocolo: String;
    FDhRecbto: TDateTime;
    FXMotivo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FcUF: Integer;
    FRetBPeDFe: String;

    FprotBPe: TProcBPe;
    FprocEventoBPe: TRetEventoBPeCollection;

    procedure SetBPeChave(const AValue: String);
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function GerarUFSoap: String; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; ABilhetes: TBilhetes);
      reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property BPeChave: String read FBPeChave write SetBPeChave;
    property ExtrairEventos: Boolean read FExtrairEventos write FExtrairEventos;
    property Protocolo: String read FProtocolo;
    property DhRecbto: TDateTime read FDhRecbto;
    property XMotivo: String read FXMotivo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: Integer read FcStat;
    property cUF: Integer read FcUF;
    property RetBPeDFe: String read FRetBPeDFe;

    property protBPe: TProcBPe read FprotBPe;
    property procEventoBPe: TRetEventoBPeCollection read FprocEventoBPe;
  end;

  { TBPeEnvEvento }

  TBPeEnvEvento = class(TBPeWebService)
  private
    FidLote: Integer;
    FEvento: TEventoBPe;
    FcStat: Integer;
    FxMotivo: String;
    FTpAmb: TpcnTipoAmbiente;
    FCNPJ: String;

    FEventoRetorno: TRetEventoBPe;

    function GerarPathEvento(const ACNPJ: String = ''; const AIE: String = ''): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AEvento: TEventoBPe); reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property idLote: Integer read FidLote write FidLote;
    property cStat: Integer read FcStat;
    property xMotivo: String read FxMotivo;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;

    property EventoRetorno: TRetEventoBPe read FEventoRetorno;
  end;

  { TDistribuicaoDFe }

  TDistribuicaoDFe = class(TBPeWebService)
  private
    FcUFAutor: Integer;
    FCNPJCPF: String;
    FultNSU: String;
    FNSU: String;
    FchBPe: String;
    FNomeArq: String;
    FlistaArqs: TStringList;

    FretDistDFeInt: TretDistDFeInt;

    function GerarPathDistribuicao(AItem :TdocZipCollectionItem): String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarMsgErro(E: Exception): String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    property cUFAutor: Integer read FcUFAutor write FcUFAutor;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property ultNSU: String read FultNSU write FultNSU;
    property NSU: String read FNSU write FNSU;
    property chBPe: String read FchBPe write FchBPe;
    property NomeArq: String read FNomeArq;
    property ListaArqs: TStringList read FlistaArqs;

    property retDistDFeInt: TretDistDFeInt read FretDistDFeInt;
  end;

  { TBPeEnvioWebService }

  TBPeEnvioWebService = class(TBPeWebService)
  private
    FXMLEnvio: String;
    FPURLEnvio: String;
    FVersao: String;
    FSoapActionEnvio: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgErro(E: Exception): String; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property Versao: String read FVersao;
    property XMLEnvio: String read FXMLEnvio write FXMLEnvio;
    property URLEnvio: String read FPURLEnvio write FPURLEnvio;
    property SoapActionEnvio: String read FSoapActionEnvio write FSoapActionEnvio;
  end;

  { TWebServices }

  TWebServices = class
  private
    FACBrBPe: TACBrDFe;
    FStatusServico: TBPeStatusServico;
    FEnviar: TBPeRecepcao;
    FConsulta: TBPeConsulta;
    FEnvEvento: TBPeEnvEvento;
    FDistribuicaoDFe: TDistribuicaoDFe;
    FEnvioWebService: TBPeEnvioWebService;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    function Envia(ALote: Integer): Boolean; overload;
    function Envia(const ALote: String): Boolean; overload;

    property ACBrBPe: TACBrDFe read FACBrBPe write FACBrBPe;
    property StatusServico: TBPeStatusServico read FStatusServico write FStatusServico;
    property Enviar: TBPeRecepcao read FEnviar write FEnviar;
    property Consulta: TBPeConsulta read FConsulta write FConsulta;
    property EnvEvento: TBPeEnvEvento read FEnvEvento write FEnvEvento;
    property DistribuicaoDFe: TDistribuicaoDFe
      read FDistribuicaoDFe write FDistribuicaoDFe;
    property EnvioWebService: TBPeEnvioWebService
      read FEnvioWebService write FEnvioWebService;
  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil, ACBrCompress, ACBrBPe,
  pcnGerador, pcnLeitor, pcnConsStatServ, pcnRetConsStatServ,
  pcnConsSitBPe;

{ TBPeWebService }

constructor TBPeWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPConfiguracoesBPe := TConfiguracoesBPe(FPConfiguracoes);
  FPLayout := LayBPeStatusServico;

  FPBodyElement := 'bpeDadosMsg';
end;

procedure TBPeWebService.Clear;
begin
  inherited Clear;

  FPStatus := stIdleBPe;
  FPDFeOwner.SSL.UseCertificateHTTP := True;
end;

procedure TBPeWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  inherited InicializarServico;

  FOldSSLType := FPDFeOwner.SSL.SSLType;
  FOldHeaderElement := FPHeaderElement;
  FPDFeOwner.SSL.SSLType := LT_TLSv1_2;
  FPHeaderElement := '';

  TACBrBPe(FPDFeOwner).SetStatus(FPStatus);
end;

procedure TBPeWebService.DefinirURL;
var
  Versao: Double;
begin
  { sobrescrever apenas se necess�rio.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';

  TACBrBPe(FPDFeOwner).LerServicoDeParams(FPLayout, Versao, FPURL);
  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;


function TBPeWebService.GerarVersaoDadosSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  if EstaVazio(FPVersaoServico) then
    FPVersaoServico := TACBrBPe(FPDFeOwner).LerVersaoDeParams(FPLayout);

  Result := '<versaoDados>' + FPVersaoServico + '</versaoDados>';
end;

procedure TBPeWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

  // Retornar configura��es anteriores
  FPDFeOwner.SSL.SSLType := FOldSSLType;
  FPHeaderElement := FOldHeaderElement;

  TACBrBPe(FPDFeOwner).SetStatus(stIdleBPe);
end;

{ TBPeStatusServico }

procedure TBPeStatusServico.Clear;
begin
  inherited Clear;

  FPStatus := stBPeStatusServico;
  FPLayout := LayBPeStatusServico;
  FPArqEnv := 'ped-sta';
  FPArqResp := 'sta';

  Fversao := '';
  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  FdhRecbto := 0;
  FTMed := 0;
  FdhRetorno := 0;
  FxObs := '';

  if Assigned(FPConfiguracoesBPe) then
  begin
    FtpAmb := FPConfiguracoesBPe.WebServices.Ambiente;
    FcUF := FPConfiguracoesBPe.WebServices.UFCodigo;
  end
end;

procedure TBPeStatusServico.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'BPeStatusServico';
  FPSoapAction := FPServico + '/bpeStatusServicoBP';
end;

procedure TBPeStatusServico.DefinirDadosMsg;
var
  ConsStatServ: TConsStatServ;
begin
  ConsStatServ := TConsStatServ.Create(FPVersaoServico, NAME_SPACE_BPE,
                                       'BPe', False);
  try
    ConsStatServ.TpAmb := FPConfiguracoesBPe.WebServices.Ambiente;
    ConsStatServ.CUF := FPConfiguracoesBPe.WebServices.UFCodigo;

    AjustarOpcoes( ConsStatServ.Gerador.Opcoes );
    ConsStatServ.GerarXML;

    // Atribuindo o XML para propriedade interna //
    FPDadosMsg := ConsStatServ.Gerador.ArquivoFormatoXML;
  finally
    ConsStatServ.Free;
  end;
end;

function TBPeStatusServico.TratarResposta: Boolean;
var
  BPeRetorno: TRetConsStatServ;
begin
  FPRetWS := SeparaDadosArray(['bpeResultMsg', 'bpeStatusServicoBPResult'], FPRetornoWS );

  BPeRetorno := TRetConsStatServ.Create('BPe');
  try
    BPeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    BPeRetorno.LerXml;

    Fversao := BPeRetorno.versao;
    FtpAmb := BPeRetorno.tpAmb;
    FverAplic := BPeRetorno.verAplic;
    FcStat := BPeRetorno.cStat;
    FxMotivo := BPeRetorno.xMotivo;
    FcUF := BPeRetorno.cUF;
    { WebService do RS retorna hor�rio de ver�o mesmo pros estados que n�o
      adotam esse hor�rio, ao utilizar esta hora para basear a emiss�o do bilhete
      acontece o erro. }
    if (pos('svrs.rs.gov.br', FPURL) > 0) and
       (MinutesBetween(BPeRetorno.dhRecbto, Now) > 50) and
       (not IsHorarioDeVerao(CUFtoUF(FcUF), BPeRetorno.dhRecbto)) then
      FdhRecbto:= IncHour(BPeRetorno.dhRecbto, -1)
    else
      FdhRecbto := BPeRetorno.dhRecbto;

    FTMed := BPeRetorno.TMed;
    FdhRetorno := BPeRetorno.dhRetorno;
    FxObs := BPeRetorno.xObs;
    FPMsg := FxMotivo + LineBreak + FxObs;

    if FPConfiguracoesBPe.WebServices.AjustaAguardaConsultaRet then
      FPConfiguracoesBPe.WebServices.AguardarConsultaRet := FTMed * 1000;

    Result := (FcStat = 107);

  finally
    BPeRetorno.Free;
  end;
end;

function TBPeStatusServico.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s' + LineBreak +
                           'Status Descri��o: %s' + LineBreak +
                           'UF: %s' + LineBreak +
                           'Recebimento: %s' + LineBreak +
                           'Tempo M�dio: %s' + LineBreak +
                           'Retorno: %s' + LineBreak +
                           'Observa��o: %s' + LineBreak),
                   [Fversao, TpAmbToStr(FtpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoParaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto)),
                    IntToStr(FTMed),
                    IfThen(FdhRetorno = 0, '', FormatDateTimeBr(FdhRetorno)),
                    FxObs]);
  {*)}
end;

function TBPeStatusServico.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Consulta Status servi�o:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TBPeRecepcao }

constructor TBPeRecepcao.Create(AOwner: TACBrDFe; ABilhetes: TBilhetes);
begin
  inherited Create(AOwner);

  FBilhetes := ABilhetes;
end;

destructor TBPeRecepcao.Destroy;
begin
  FBPeRetorno.Free;

  inherited Destroy;
end;

procedure TBPeRecepcao.Clear;
begin
  inherited Clear;

  FPStatus := stBPeRecepcao;
  FPLayout := LayBPeRecepcao;
  FPArqEnv := 'env-lot';
  FPArqResp := 'rec';

  Fversao    := '';
  FTMed      := 0;
  FverAplic  := '';
  FcStat     := 0;
  FxMotivo   := '';
  FdhRecbto  := 0;
  FProtocolo := '';

  if Assigned(FPConfiguracoesBPe) then
  begin
    FtpAmb := FPConfiguracoesBPe.WebServices.Ambiente;
    FcUF := FPConfiguracoesBPe.WebServices.UFCodigo;
  end;

  if Assigned(FBPeRetorno) then
    FBPeRetorno.Free;

  FBPeRetorno := TretEnvBPe.Create;
end;

function TBPeRecepcao.GetLote: String;
begin
  Result := Trim(FLote);
end;

procedure TBPeRecepcao.InicializarServico;
var
  ok: Boolean;
begin
  if FBilhetes.Count > 0 then    // Tem BPe ? Se SIM, use as informa��es do XML
    FVersaoDF := DblToVersaoBPe(ok, FBilhetes.Items[0].BPe.infBPe.Versao)
  else
    FVersaoDF := FPConfiguracoesBPe.Geral.VersaoDF;

  inherited InicializarServico;
end;

procedure TBPeRecepcao.DefinirURL;
var
  xUF: String;
  VerServ: Double;
begin
  if FBilhetes.Count > 0 then    // Tem BPe ? Se SIM, use as informa��es do XML
  begin
    FcUF := FBilhetes.Items[0].BPe.Ide.cUF;

    if FPConfiguracoesBPe.WebServices.Ambiente <> FBilhetes.Items[0].BPe.Ide.tpAmb then
      raise EACBrBPeException.Create( ACBRBPE_CErroAmbienteDiferente );
  end
  else
  begin     // Se n�o tem BPe, use as configura��es do componente
    FcUF := FPConfiguracoesBPe.WebServices.UFCodigo;
  end;

  VerServ := VersaoBPeToDbl(FVersaoDF);
  FTpAmb  := FPConfiguracoesBPe.WebServices.Ambiente;
  FPVersaoServico := '';
  FPURL := '';

  FPLayout := LayBPeRecepcao;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesBPe.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrBPe(FPDFeOwner).LerServicoDeParams(
    ModeloDF,
    xUF,
    FTpAmb,
    LayOutBPeToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TBPeRecepcao.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'BPeRecepcao';

  if FPConfiguracoesBPe.WebServices.UFCodigo in [31, 52] then
    FPSoapAction := FPServico + '/bpeRecepcao'
  else
    FPSoapAction := FPServico;
end;

procedure TBPeRecepcao.DefinirDadosMsg;
begin
  // No envio s� podemos ter apena UM BP-e, pois o seu processamento � s�ncrono
  if FBilhetes.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de BP-e transmitidos (m�ximo de 1 BP-e)' +
             ' excedido. Quantidade atual: ' + IntToStr(FBilhetes.Count)));

  if FBilhetes.Count > 0 then
    FPDadosMsg := '<BPe' +
       RetornarConteudoEntre(FBilhetes.Items[0].XMLAssinado, '<BPe', '</BPe>') +
       '</BPe>';

  FMsgUnZip := FPDadosMsg;

  FPDadosMsg := EncodeBase64(GZipCompress(FPDadosMsg));

  // Lote tem mais de 500kb ? //
  if Length(FPDadosMsg) > (500 * 1024) then
    GerarException(ACBrStr('Tamanho do XML de Dados superior a 500 Kbytes. Tamanho atual: ' +
      IntToStr(trunc(Length(FPDadosMsg) / 1024)) + ' Kbytes'));
end;

procedure TBPeRecepcao.SalvarEnvio;
var
  Prefixo, xArqEnv: String;
  IsUTF8: Boolean;
begin
  if FPArqEnv = '' then
    exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoesBPe.Geral.Salvar then
  begin
    xArqEnv := Prefixo + '-' + FPArqEnv + '.xml';

    IsUTF8  := XmlEstaAssinado(FMsgUnZip);
    FPDFeOwner.Gravar(xArqEnv, FMsgUnZip, '', IsUTF8);
  end;

  if FPConfiguracoesBPe.WebServices.Salvar then
  begin
    xArqEnv := Prefixo + '-' + FPArqEnv + '-soap.xml';

    IsUTF8  := XmlEstaAssinado(FPEnvelopeSoap);
    FPDFeOwner.Gravar(xArqEnv, FPEnvelopeSoap, '', IsUTF8);
  end;
end;

function TBPeRecepcao.TratarResposta: Boolean;
var
  I: Integer;
  chBPe, NomeXMLSalvo: String;
  AProcBPe: TProcBPe;
  SalvarXML: Boolean;
begin
  FPRetWS := SeparaDadosArray(['bpeResultMsg', 'bpeRecepcaoResult'], FPRetornoWS );

  FBPeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
  FBPeRetorno.LerXml;

  Fversao   := FBPeRetorno.versao;
  FTpAmb    := FBPeRetorno.TpAmb;
  FverAplic := FBPeRetorno.verAplic;
  FcUF      := FBPeRetorno.cUF;
  FcStat    := FBPeRetorno.cStat;
  FPMsg     := FBPeRetorno.xMotivo;
  FxMotivo  := FBPeRetorno.xMotivo;

  if FBPeRetorno.ProtBPe.Count > 0 then
  begin
    chBPe      := FBPeRetorno.ProtBPe[0].chBPe;
    FcStat     := FBPeRetorno.protBPe[0].cStat;
    FPMsg      := FBPeRetorno.protBPe[0].xMotivo;
    FxMotivo   := FBPeRetorno.protBPe[0].xMotivo;
    FProtocolo := FBPeRetorno.ProtBPe[0].nProt;
  end;

  // Verificar se o BP-e foi autorizado com sucesso
  Result := TACBrBPe(FPDFeOwner).CstatConfirmada(FBPeRetorno.cStat) and
      (TACBrBPe(FPDFeOwner).CstatProcessado(FBPeRetorno.protBPe[0].cStat));

  if Result then
  begin
    for I := 0 to TACBrBPe(FPDFeOwner).Bilhetes.Count - 1 do
    begin
      with TACBrBPe(FPDFeOwner).Bilhetes.Items[I] do
      begin
        if OnlyNumber(chBPe) = NumID then
        begin
          if (FPConfiguracoesBPe.Geral.ValidarDigest) and
             (FBPeRetorno.protBPe[0].digVal <> '') and
             (BPe.signature.DigestValue <> FBPeRetorno.protBPe[0].digVal) then
            raise EACBrBPeException.Create('DigestValue do documento ' + NumID + ' n�o confere.');

          BPe.procBPe.cStat    := FBPeRetorno.protBPe[0].cStat;
          BPe.procBPe.tpAmb    := FBPeRetorno.tpAmb;
          BPe.procBPe.verAplic := FBPeRetorno.verAplic;
          BPe.procBPe.chBPe    := FBPeRetorno.ProtBPe[0].chBPe;
          BPe.procBPe.dhRecbto := FBPeRetorno.protBPe[0].dhRecbto;
          BPe.procBPe.nProt    := FBPeRetorno.ProtBPe[0].nProt;
          BPe.procBPe.digVal   := FBPeRetorno.protBPe[0].digVal;
          BPe.procBPe.xMotivo  := FBPeRetorno.protBPe[0].xMotivo;

          AProcBPe := TProcBPe.Create;
          try
            // Processando em UTF8, para poder gravar arquivo corretamente //
            AProcBPe.XML_BPe := RemoverDeclaracaoXML(XMLAssinado);
            AProcBPe.XML_Prot := FBPeRetorno.ProtBPe[0].XMLprotBPe;
            AProcBPe.Versao := FPVersaoServico;
            AjustarOpcoes( AProcBPe.Gerador.Opcoes );
            AProcBPe.GerarXML;

            XMLOriginal := AProcBPe.Gerador.ArquivoFormatoXML;

            if FPConfiguracoesBPe.Arquivos.Salvar then
            begin
              SalvarXML := (not FPConfiguracoesBPe.Arquivos.SalvarApenasBPeProcessadas) or
                             Processada;

              // Salva o XML do BP-e assinado e protocolado
              if SalvarXML then
              begin
                NomeXMLSalvo := '';
                if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                begin
                  FPDFeOwner.Gravar( NomeArq, XMLOriginal ); // Atualiza o XML carregado
                  NomeXMLSalvo := NomeArq;
                end;

                if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                  GravarXML; // Salva na pasta baseado nas configura��es do PathBPe
              end;
            end;
          finally
            AProcBPe.Free;
          end;

          Break;
        end;
      end;
    end;
  end;
end;

function TBPeRecepcao.GerarMsgLog: String;
begin
  {(*}
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                             'Ambiente: %s ' + LineBreak +
                             'Vers�o Aplicativo: %s ' + LineBreak +
                             'Status C�digo: %s ' + LineBreak +
                             'Status Descri��o: %s ' + LineBreak +
                             'UF: %s '),
                     [FBPeRetorno.versao,
                      TpAmbToStr(FBPeRetorno.TpAmb),
                      FBPeRetorno.verAplic,
                      IntToStr(FBPeRetorno.cStat),
                      FBPeRetorno.xMotivo,
                      CodigoParaUF(FBPeRetorno.cUF)]);
  {*)}
end;

function TBPeRecepcao.GerarPrefixoArquivo: String;
begin
  Result := Lote;
  FPArqResp := 'pro-lot';
end;

{ TBPeConsulta }

constructor TBPeConsulta.Create(AOwner: TACBrDFe; ABilhetes: TBilhetes);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
  FBilhetes := ABilhetes;
end;

destructor TBPeConsulta.Destroy;
begin
  FprotBPe.Free;
  FprocEventoBPe.Free;

  inherited Destroy;
end;

procedure TBPeConsulta.Clear;
begin
  inherited Clear;

  FPStatus   := stBPeConsulta;
  FPLayout   := LayBPeConsulta;
  FPArqEnv   := 'ped-sit';
  FPArqResp  := 'sit';
  FverAplic  := '';
  FcStat     := 0;
  FxMotivo   := '';
  FProtocolo := '';
  FDhRecbto  := 0;
  Fversao    := '';
  FRetBPeDFe := '';

  if Assigned(FPConfiguracoesBPe) then
  begin
    FtpAmb := FPConfiguracoesBPe.WebServices.Ambiente;
    FcUF := FPConfiguracoesBPe.WebServices.UFCodigo;
  end;

  if Assigned(FprotBPe) then
    FprotBPe.Free;

  if Assigned(FprocEventoBPe) then
    FprocEventoBPe.Free;

  FprotBPe       := TProcBPe.Create;
  FprocEventoBPe := TRetEventoBPeCollection.Create;
end;

procedure TBPeConsulta.SetBPeChave(const AValue: String);
var
  NumChave: String;
begin
  if FBPeChave = AValue then Exit;
  NumChave := OnlyNumber(AValue);

  if not ValidarChave(NumChave) then
     raise EACBrBPeException.Create('Chave "' + AValue + '" inv�lida.');

  FBPeChave := NumChave;
end;

procedure TBPeConsulta.DefinirURL;
var
  VerServ: Double;
  xUF: String;
begin
  FPVersaoServico := '';
  FPURL   := '';
  FcUF    := ExtrairUFChaveAcesso(FBPeChave);
  VerServ := VersaoBPeToDbl(FPConfiguracoesBPe.Geral.VersaoDF);

  if FBilhetes.Count > 0 then
    FTpAmb  := FBilhetes.Items[0].BPe.Ide.tpAmb
  else
    FTpAmb  := FPConfiguracoesBPe.WebServices.Ambiente;

  // Se o bilhete foi enviado para o SVC a consulta tem que ser realizada no SVC e
  // n�o na SEFAZ-Autorizadora
  case FPConfiguracoesBPe.Geral.FormaEmissao of
    teSVCAN: xUF := 'SVC-AN';
    teSVCRS: xUF := 'SVC-RS';
  else
    xUF := CUFtoUF(FcUF);
  end;

  TACBrBPe(FPDFeOwner).LerServicoDeParams(
    ModeloDF,
    xUF,
    FTpAmb,
    LayOutBPeToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TBPeConsulta.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'BPeConsulta';
  FPSoapAction := FPServico + '/bpeConsultaBP';
end;

procedure TBPeConsulta.DefinirDadosMsg;
var
  ConsSitBPe: TConsSitBPe;
begin
  ConsSitBPe := TConsSitBPe.Create;
  try
    ConsSitBPe.TpAmb := FTpAmb;
    ConsSitBPe.chBPe := FBPeChave;
    ConsSitBPe.Versao := FPVersaoServico;
    AjustarOpcoes( ConsSitBPe.Gerador.Opcoes );
    ConsSitBPe.GerarXML;

    FPDadosMsg := ConsSitBPe.Gerador.ArquivoFormatoXML;
  finally
    ConsSitBPe.Free;
  end;
end;

function TBPeConsulta.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(FcUF) + '</cUF>';
end;

function TBPeConsulta.TratarResposta: Boolean;

procedure SalvarEventos(Retorno: string);
var
  aEvento, aProcEvento, aIDEvento, sPathEvento, sCNPJ: string;
  Inicio, Fim: Integer;
  TipoEvento: TpcnTpEvento;
  Ok: Boolean;
begin
  while Retorno <> '' do
  begin
    Inicio := Pos('<procEventoBPe', Retorno);
    Fim    := Pos('</procEventoBPe>', Retorno) + 15;

    aEvento := Copy(Retorno, Inicio, Fim - Inicio + 1);

    Retorno := Copy(Retorno, Fim + 1, Length(Retorno));

    aProcEvento := '<procEventoBPe versao="' + FVersao + '" xmlns="' + ACBRBPe_NAMESPACE + '">' +
                      SeparaDados(aEvento, 'procEventoBPe') +
                   '</procEventoBPe>';

    Inicio := Pos('Id=', aProcEvento) + 6;
    Fim    := 52;

    if Inicio = 6 then
      aIDEvento := FormatDateTime('yyyymmddhhnnss', Now)
    else
      aIDEvento := Copy(aProcEvento, Inicio, Fim);

    TipoEvento  := StrToTpEventoBPe(Ok, SeparaDados(aEvento, 'tpEvento'));
    sCNPJ       := SeparaDados(aEvento, 'CNPJ');
    sPathEvento := PathWithDelim(FPConfiguracoesBPe.Arquivos.GetPathEvento(TipoEvento, sCNPJ));

    if (aProcEvento <> '') then
      FPDFeOwner.Gravar( aIDEvento + '-procEventoBPe.xml', aProcEvento, sPathEvento);
  end;
end;

var
  BPeRetorno: TRetConsSitBPe;
  SalvarXML, BPCancelado, Atualiza: Boolean;
  aEventos, sPathBPe, NomeXMLSalvo: String;
  AProcBPe: TProcBPe;
  I, J, Inicio, Fim: Integer;
  dhEmissao: TDateTime;
begin
  BPeRetorno := TRetConsSitBPe.Create;
  try
    FPRetWS := SeparaDadosArray(['bpeResultMsg', 'bpeConsultaBPResult'], FPRetornoWS );

    BPeRetorno.Leitor.Arquivo := ParseText(FPRetWS);
    BPeRetorno.LerXML;

    BPCancelado := False;
    aEventos := '';

    // <retConsSitBPe> - Retorno da consulta da situa��o do BP-e
    // Este � o status oficial do BP-e
    Fversao := BPeRetorno.versao;
    FTpAmb := BPeRetorno.tpAmb;
    FverAplic := BPeRetorno.verAplic;
    FcStat := BPeRetorno.cStat;
    FXMotivo := BPeRetorno.xMotivo;
    FcUF := BPeRetorno.cUF;
    FPMsg := FXMotivo;

    // <protBPe> - Retorno dos dados do ENVIO do BP-e
    // Consider�-los apenas se n�o existir nenhum evento de cancelamento (110111)
    FprotBPe.PathBPe := BPeRetorno.protBPe.PathBPe;
    FprotBPe.PathRetConsReciBPe := BPeRetorno.protBPe.PathRetConsReciBPe;
    FprotBPe.PathRetConsSitBPe := BPeRetorno.protBPe.PathRetConsSitBPe;
//    FprotBPe.PathRetConsSitBPe := BPeRetorno.protBPe.PathRetConsSitBPe;
    FprotBPe.tpAmb := BPeRetorno.protBPe.tpAmb;
    FprotBPe.verAplic := BPeRetorno.protBPe.verAplic;
    FprotBPe.chBPe := BPeRetorno.protBPe.chBPe;
    FprotBPe.dhRecbto := BPeRetorno.protBPe.dhRecbto;
    FprotBPe.nProt := BPeRetorno.protBPe.nProt;
    FprotBPe.digVal := BPeRetorno.protBPe.digVal;
    FprotBPe.cStat := BPeRetorno.protBPe.cStat;
    FprotBPe.xMotivo := BPeRetorno.protBPe.xMotivo;

    {(*}
    if Assigned(BPeRetorno.procEventoBPe) and (BPeRetorno.procEventoBPe.Count > 0) then
    begin
      aEventos := '=====================================================' +
        LineBreak + '================== Eventos do BP-e ==================' +
        LineBreak + '=====================================================' +
        LineBreak + '' + LineBreak + 'Quantidade total de eventos: ' +
        IntToStr(BPeRetorno.procEventoBPe.Count);

      FprocEventoBPe.Clear;
      for I := 0 to BPeRetorno.procEventoBPe.Count - 1 do
      begin
        with FprocEventoBPe.New.RetEventoBPe do
        begin
          idLote   := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.idLote;
          tpAmb    := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.tpAmb;
          verAplic := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.verAplic;
          cOrgao   := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.cOrgao;
          cStat    := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.cStat;
          xMotivo  := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.xMotivo;
          XML      := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.XML;

          infEvento.ID           := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.ID;
          infEvento.tpAmb        := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.tpAmb;
          infEvento.CNPJ         := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.CNPJ;
          infEvento.chBPe        := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.chBPe;
          infEvento.dhEvento     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.dhEvento;
          infEvento.TpEvento     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.TpEvento;
          infEvento.nSeqEvento   := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.nSeqEvento;
          infEvento.VersaoEvento := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.VersaoEvento;

          infEvento.DetEvento.xCorrecao := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.DetEvento.xCorrecao;
          infEvento.DetEvento.xCondUso  := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.DetEvento.xCondUso;
          infEvento.DetEvento.nProt     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.DetEvento.nProt;
          infEvento.DetEvento.xJust     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.infEvento.DetEvento.xJust;

          retEvento.Clear;
          for J := 0 to BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Count-1 do
          begin
            with retEvento.New.RetinfEvento do
            begin
              Id          := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.Id;
              tpAmb       := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.tpAmb;
              verAplic    := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.verAplic;
              cOrgao      := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.cOrgao;
              cStat       := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.cStat;
              xMotivo     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.xMotivo;
              chBPe       := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.chBPe;
              tpEvento    := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.tpEvento;
              xEvento     := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.xEvento;
              nSeqEvento  := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.nSeqEvento;
              CNPJDest    := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.CNPJDest;
              emailDest   := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.emailDest;
              dhRegEvento := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.dhRegEvento;
              nProt       := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.nProt;
              XML         := BPeRetorno.procEventoBPe.Items[I].RetEventoBPe.retEvento.Items[J].RetinfEvento.XML;
            end;
          end;
        end;

        with BPeRetorno.procEventoBPe.Items[I].RetEventoBPe do
        begin
          for j := 0 to retEvento.Count -1 do
          begin
            aEventos := aEventos + LineBreak + LineBreak +
              Format(ACBrStr('N�mero de sequ�ncia: %s ' + LineBreak +
                             'C�digo do evento: %s ' + LineBreak +
                             'Descri��o do evento: %s ' + LineBreak +
                             'Status do evento: %s ' + LineBreak +
                             'Descri��o do status: %s ' + LineBreak +
                             'Protocolo: %s ' + LineBreak +
                             'Data/Hora do registro: %s '),
                     [IntToStr(infEvento.nSeqEvento),
                      TpEventoToStr(infEvento.TpEvento),
                      infEvento.DescEvento,
                      IntToStr(retEvento.Items[J].RetinfEvento.cStat),
                      retEvento.Items[J].RetinfEvento.xMotivo,
                      retEvento.Items[J].RetinfEvento.nProt,
                      FormatDateTimeBr(retEvento.Items[J].RetinfEvento.dhRegEvento)]);

            if retEvento.Items[J].RetinfEvento.tpEvento = teCancelamento then
            begin
              BPCancelado := True;
              FProtocolo := retEvento.Items[J].RetinfEvento.nProt;
              FDhRecbto := retEvento.Items[J].RetinfEvento.dhRegEvento;
              FPMsg := retEvento.Items[J].RetinfEvento.xMotivo;
            end;
          end;
        end;
      end;
    end;
    {*)}

    if (not BPCancelado) and (NaoEstaVazio(BPeRetorno.protBPe.nProt))  then
    begin
      FProtocolo := BPeRetorno.protBPe.nProt;
      FDhRecbto := BPeRetorno.protBPe.dhRecbto;
      FPMsg := BPeRetorno.protBPe.xMotivo;
    end;

    with TACBrBPe(FPDFeOwner) do
    begin
      Result := CstatProcessado(BPeRetorno.CStat) or
                CstatCancelada(BPeRetorno.CStat);
    end;

    if Result then
    begin
      if TACBrBPe(FPDFeOwner).Bilhetes.Count > 0 then
      begin
        for i := 0 to TACBrBPe(FPDFeOwner).Bilhetes.Count - 1 do
        begin
          with TACBrBPe(FPDFeOwner).Bilhetes.Items[i] do
          begin
            if (OnlyNumber(FBPeChave) = NumID) then
            begin
              Atualiza := (NaoEstaVazio(BPeRetorno.XMLprotBPe));
              if Atualiza and TACBrBPe(FPDFeOwner).CstatCancelada(BPeRetorno.CStat) then
                Atualiza := False;

              if (FPConfiguracoesBPe.Geral.ValidarDigest) and
                (BPeRetorno.protBPe.digVal <> '') and (BPe.signature.DigestValue <> '') and
                (UpperCase(BPe.signature.DigestValue) <> UpperCase(BPeRetorno.protBPe.digVal)) then
              begin
                raise EACBrBPeException.Create('DigestValue do documento ' +
                  NumID + ' n�o confere.');
              end;

              // Atualiza o Status do BPe interna //
              BPe.procBPe.cStat := BPeRetorno.cStat;

              if Atualiza then
              begin
                BPe.procBPe.tpAmb := BPeRetorno.tpAmb;
                BPe.procBPe.verAplic := BPeRetorno.verAplic;
    //            BPe.procBPe.chBPe := BPeRetorno.chBPe;
                BPe.procBPe.dhRecbto := FDhRecbto;
                BPe.procBPe.nProt := FProtocolo;
                BPe.procBPe.digVal := BPeRetorno.protBPe.digVal;
                BPe.procBPe.cStat := BPeRetorno.cStat;
                BPe.procBPe.xMotivo := BPeRetorno.xMotivo;

                // O c�digo abaixo � bem mais r�pido que "GerarXML" (acima)...
                AProcBPe := TProcBPe.Create;
                try
                  AProcBPe.XML_BPe := RemoverDeclaracaoXML(XMLOriginal);
                  AProcBPe.XML_Prot := NativeStringToUTF8(BPeRetorno.XMLprotBPe);
                  AProcBPe.Versao := FPVersaoServico;
                  AjustarOpcoes( AProcBPe.Gerador.Opcoes );
                  AProcBPe.GerarXML;

                  XMLOriginal := AProcBPe.Gerador.ArquivoFormatoXML;
                finally
                  AProcBPe.Free;
                end;
              end;

              { Se no retorno da consulta constar que o bilhete possui eventos vinculados
               ser� disponibilizado na propriedade FRetBPeDFe, e conforme configurado
               em "ConfiguracoesBPe.Arquivos.Salvar", tamb�m ser� gerado o arquivo:
               <chave>-BPeDFe.xml}

              FRetBPeDFe := '';

              if (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoBPe'))) then
              begin
                Inicio := Pos('<procEventoBPe', FPRetWS);
                Fim    := Pos('</retConsSitBPe', FPRetWS) -1;

                aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

                FRetBPeDFe := '<' + ENCODING_UTF8 + '>' +
                              '<BPeDFe>' +
                               '<procBPe versao="' + FVersao + '">' +
                                 SeparaDados(XMLOriginal, 'BPeProc') +
                               '</procBPe>' +
                               '<procEventoBPe versao="' + FVersao + '">' +
                                 aEventos +
                               '</procEventoBPe>' +
                              '</BPeDFe>';
              end;

              SalvarXML := Result and FPConfiguracoesBPe.Arquivos.Salvar and Atualiza;

              if SalvarXML then
              begin
                // Salva o XML do BP-e assinado, protocolado e com os eventos
                if FPConfiguracoesBPe.Arquivos.EmissaoPathBPe then
                  dhEmissao := BPe.Ide.dhEmi
                else
                  dhEmissao := Now;

                sPathBPe := PathWithDelim(FPConfiguracoesBPe.Arquivos.GetPathBPe(dhEmissao, BPe.Emit.CNPJ));

                if (FRetBPeDFe <> '') then
                  FPDFeOwner.Gravar( FBPeChave + '-BPeDFe.xml', FRetBPeDFe, sPathBPe);

                if Atualiza then
                begin
                  // Salva o XML do BP-e assinado e protocolado
                  NomeXMLSalvo := '';
                  if NaoEstaVazio(NomeArq) and FileExists(NomeArq) then
                  begin
                    FPDFeOwner.Gravar( NomeArq, XMLOriginal );  // Atualiza o XML carregado
                    NomeXMLSalvo := NomeArq;
                  end;

                  // Salva na pasta baseado nas configura��es do PathBPe
                  if (NomeXMLSalvo <> CalcularNomeArquivoCompleto()) then
                    GravarXML;

                  // Salva o XML de eventos retornados ao consultar um BP-e
                  if ExtrairEventos then
                    SalvarEventos(aEventos);
                end;
              end;

              break;
            end;
          end;
        end;
      end
      else
      begin
        if ExtrairEventos and FPConfiguracoesBPe.Arquivos.Salvar and
           (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoBPe'))) then
        begin
          Inicio := Pos('<procEventoBPe', FPRetWS);
          Fim    := Pos('</retConsSitBPe', FPRetWS) -1;

          aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

          // Salva o XML de eventos retornados ao consultar um BP-e
          SalvarEventos(aEventos);
        end;
      end;
    end;
  finally
    BPeRetorno.Free;
  end;
end;

function TBPeConsulta.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Identificador: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Chave Acesso: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak +
                           'Protocolo: %s ' + LineBreak +
                           'Digest Value: %s ' + LineBreak),
                   [Fversao, FBPeChave, TpAmbToStr(FTpAmb), FverAplic,
                    IntToStr(FcStat), FXMotivo, CodigoParaUF(FcUF), FBPeChave,
                    FormatDateTimeBr(FDhRecbto), FProtocolo, FprotBPe.digVal]);
  {*)}
end;

function TBPeConsulta.GerarPrefixoArquivo: String;
begin
  Result := Trim(FBPeChave);
end;

{ TBPeEnvEvento }

constructor TBPeEnvEvento.Create(AOwner: TACBrDFe; AEvento: TEventoBPe);
begin
  inherited Create(AOwner);

  FEvento := AEvento;
end;

destructor TBPeEnvEvento.Destroy;
begin
  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  inherited;
end;

procedure TBPeEnvEvento.Clear;
begin
  inherited Clear;

  FPStatus := stBPeEvento;
  FPLayout := LayBPeEvento;
  FPArqEnv := 'ped-eve';
  FPArqResp := 'eve';

  FcStat   := 0;
  FxMotivo := '';
  FCNPJ := '';

  if Assigned(FPConfiguracoesBPe) then
    FtpAmb := FPConfiguracoesBPe.WebServices.Ambiente;

  if Assigned(FEventoRetorno) then
    FEventoRetorno.Free;

  FEventoRetorno := TRetEventoBPe.Create;
end;

function TBPeEnvEvento.GerarPathEvento(const ACNPJ: String = ''; const AIE: String = ''): String;
begin
  with FEvento.Evento.Items[0].infEvento do
  begin
    Result := FPConfiguracoesBPe.Arquivos.GetPathEvento(tpEvento, ACNPJ, AIE);
  end;
end;

procedure TBPeEnvEvento.DefinirURL;
var
  UF: String;
  VerServ: Double;
begin
  { Verifica��o necess�ria pois somente os eventos de Cancelamento e CCe ser�o tratados pela SEFAZ do estado
    os outros eventos como manifestacao de destinat�rios ser�o tratados diretamente pela RFB }

  FPLayout := LayBPeEvento;
  VerServ  := VersaoBPeToDbl(FPConfiguracoesBPe.Geral.VersaoDF);
  FCNPJ    := FEvento.Evento.Items[0].infEvento.CNPJ;
  FTpAmb   := FEvento.Evento.Items[0].infEvento.tpAmb;

  // Configura��o correta ao enviar para o SVC
  case FPConfiguracoesBPe.Geral.FormaEmissao of
    teSVCAN: UF := 'SVC-AN';
    teSVCRS: UF := 'SVC-RS';
  else
    UF := CUFtoUF(ExtrairUFChaveAcesso(FEvento.Evento.Items[0].infEvento.chBPe));
  end;

  if not (FEvento.Evento.Items[0].infEvento.tpEvento in [teCancelamento, teNaoEmbarque]) then
  begin
    FPLayout := LayBPeEventoAN;
    UF       := 'AN';
  end;

  FPURL := '';

  TACBrBPe(FPDFeOwner).LerServicoDeParams(
    ModeloDF,
    UF,
    FTpAmb,
    LayOutBPeToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TBPeEnvEvento.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'BPeRecepcaoEvento';
  FPSoapAction := FPServico + '/bpeRecepcaoEvento';
end;

procedure TBPeEnvEvento.DefinirDadosMsg;
var
  EventoBPe: TEventoBPe;
  I, F: Integer;
  Evento, Eventos, EventosAssinados, AXMLEvento: AnsiString;
  FErroValidacao: String;
  EventoEhValido: Boolean;
  SchemaEventoBPe: TSchemaBPe;
begin
  EventoBPe := TEventoBPe.Create;

  try
    EventoBPe.idLote := FidLote;
    SchemaEventoBPe  := schErro;

    {(*}
    for I := 0 to FEvento.Evento.Count - 1 do
    begin
      with EventoBPe.Evento.New do
      begin
        infEvento.tpAmb := FTpAmb;
        infEvento.CNPJ := FEvento.Evento[I].infEvento.CNPJ;
        infEvento.cOrgao := FEvento.Evento[I].infEvento.cOrgao;
        infEvento.chBPe := FEvento.Evento[I].infEvento.chBPe;
        infEvento.dhEvento := FEvento.Evento[I].infEvento.dhEvento;
        infEvento.tpEvento := FEvento.Evento[I].infEvento.tpEvento;
        infEvento.nSeqEvento := FEvento.Evento[I].infEvento.nSeqEvento;
        infEvento.versaoEvento := FEvento.Evento[I].InfEvento.versaoEvento;

        case infEvento.tpEvento of
          teCancelamento: SchemaEventoBPe := schevCancBPe;
          teNaoEmbarque: SchemaEventoBPe := schevNaoEmbBPe;
          teAlteracaoPoltrona: SchemaEventoBPe := schevAlteracaoPoltrona;
        end;

        infEvento.detEvento.nProt    := FEvento.Evento[I].infEvento.detEvento.nProt;
        infEvento.detEvento.xJust    := FEvento.Evento[I].infEvento.detEvento.xJust;
        infEvento.detEvento.poltrona := FEvento.Evento[I].infEvento.detEvento.poltrona;
      end;
    end;
    {*)}

    EventoBPe.Versao := FPVersaoServico;
    AjustarOpcoes( EventoBPe.Gerador.Opcoes );
    EventoBPe.GerarXML;

    Eventos := NativeStringToUTF8( EventoBPe.Gerador.ArquivoFormatoXML );
    EventosAssinados := '';

    // Realiza a assinatura para cada evento
    while Eventos <> '' do
    begin
      F := Pos('</eventoBPe>', Eventos);

      if F > 0 then
      begin
        Evento := Copy(Eventos, 1, F + 12);
        Eventos := Copy(Eventos, F + 13, length(Eventos));

        AssinarXML(Evento, 'eventoBPe', 'infEvento', 'Falha ao assinar o Envio de Evento ');
        EventosAssinados := EventosAssinados + FPDadosMsg;
      end
      else
        Break;
    end;

    // Separa o XML especifico do Evento para ser Validado.
    AXMLEvento := SeparaDados(FPDadosMsg, 'detEvento');

    case SchemaEventoBPe of
      schevCancBPe:
        begin
          AXMLEvento := '<evCancBPe xmlns="' + ACBRBPE_NAMESPACE + '">' +
                          Trim(RetornarConteudoEntre(AXMLEvento, '<evCancBPe>', '</evCancBPe>')) +
                        '</evCancBPe>';
        end;

      schevNaoEmbBPe:
        begin
          AXMLEvento := '<evNaoEmbBPe xmlns="' + ACBRBPE_NAMESPACE + '">' +
                          Trim(RetornarConteudoEntre(AXMLEvento, '<evNaoEmbBPe>', '</evNaoEmbBPe>')) +
                        '</evNaoEmbBPe>';
        end;

      schevAlteracaoPoltrona:
        begin
          AXMLEvento := '<evAlteracaoPoltrona xmlns="' + ACBRBPE_NAMESPACE + '">' +
                          Trim(RetornarConteudoEntre(AXMLEvento, '<evAlteracaoPoltrona>', '</evAlteracaoPoltrona>')) +
                        '</evAlteracaoPoltrona>';
        end;
    end;

    AXMLEvento := '<' + ENCODING_UTF8 + '>' + AXMLEvento;

    with TACBrBPe(FPDFeOwner) do
    begin
      EventoEhValido := SSL.Validar(FPDadosMsg,
                                    GerarNomeArqSchema(FPLayout,
                                                       StringToFloatDef(FPVersaoServico, 0)),
                                    FPMsg) and
                        SSL.Validar(AXMLEvento,
                                    GerarNomeArqSchemaEvento(SchemaEventoBPe,
                                                             StringToFloatDef(FPVersaoServico, 0)),
                                    FPMsg);
    end;

    if not EventoEhValido then
    begin
      FErroValidacao := ACBrStr('Falha na valida��o dos dados do Evento: ') +
        FPMsg;

      raise EACBrBPeException.CreateDef(FErroValidacao);
    end;

    for I := 0 to FEvento.Evento.Count - 1 do
      FEvento.Evento[I].infEvento.id := EventoBPe.Evento[I].infEvento.id;
  finally
    EventoBPe.Free;
  end;
end;

function TBPeEnvEvento.TratarResposta: Boolean;
var
  Leitor: TLeitor;
  I, J: Integer;
  NomeArq, PathArq, VersaoEvento, Texto: String;
begin
  FEvento.idLote := idLote;

  FPRetWS := SeparaDadosArray(['bpeResultMsg', 'bpeRecepcaoEventoResult'], FPRetornoWS );

  EventoRetorno.Leitor.Arquivo := ParseText(FPRetWS);
  EventoRetorno.LerXml;

  FcStat := EventoRetorno.cStat;
  FxMotivo := EventoRetorno.xMotivo;
  FPMsg := EventoRetorno.xMotivo;
  FTpAmb := EventoRetorno.tpAmb;

  if FcStat =0 then
  begin
    if EventoRetorno.retEvento.Count > 0 then
    begin
      FcStat   := EventoRetorno.retEvento.Items[0].RetinfEvento.cStat;
      FxMotivo := EventoRetorno.retEvento.Items[0].RetinfEvento.xMotivo;
      FPMsg    := EventoRetorno.retEvento.Items[0].RetinfEvento.xMotivo;
      FTpAmb   := EventoRetorno.retEvento.Items[0].RetinfEvento.tpAmb;

      FEventoRetorno.cStat    := FcStat;
//      FEventoRetorno.xMotivo  := FxMotivo;
      FEventoRetorno.xMotivo  := FPMsg;
      FEventoRetorno.tpAmb    := FTpAmb;
      FEventoRetorno.verAplic := EventoRetorno.retEvento.Items[0].RetinfEvento.verAplic;
    end;
  end;

  // 135 = Evento Registrado e vinculado ao BPe
  Result := (FcStat = 135);

  //gerar arquivo proc de evento
  if Result then
  begin
    Leitor := TLeitor.Create;
    try
      for I := 0 to FEvento.Evento.Count - 1 do
      begin
        for J := 0 to EventoRetorno.retEvento.Count - 1 do
        begin
          if FEvento.Evento.Items[I].infEvento.chBPe =
            EventoRetorno.retEvento.Items[J].RetinfEvento.chBPe then
          begin
            FEvento.Evento.Items[I].RetinfEvento.tpAmb :=
              EventoRetorno.retEvento.Items[J].RetinfEvento.tpAmb;
            FEvento.Evento.Items[I].RetinfEvento.nProt :=
              EventoRetorno.retEvento.Items[J].RetinfEvento.nProt;
            FEvento.Evento.Items[I].RetinfEvento.dhRegEvento :=
              EventoRetorno.retEvento.Items[J].RetinfEvento.dhRegEvento;
            FEvento.Evento.Items[I].RetinfEvento.cStat :=
              EventoRetorno.retEvento.Items[J].RetinfEvento.cStat;
            FEvento.Evento.Items[I].RetinfEvento.xMotivo :=
              EventoRetorno.retEvento.Items[J].RetinfEvento.xMotivo;

            Texto := '';

            if EventoRetorno.retEvento.Items[J].RetinfEvento.cStat in [135, 136, 155] then
            begin
              VersaoEvento := TACBrBPe(FPDFeOwner).LerVersaoDeParams(LayBPeEvento);

              Leitor.Arquivo := FPDadosMsg;
              Texto := '<procEventoBPe versao="' + VersaoEvento + '" xmlns="' + ACBRBPe_NAMESPACE + '">' +
                        '<eventoBPe versao="' + VersaoEvento + '">' +
                         Leitor.rExtrai(1, 'infEvento', '', I + 1) +
                         '<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
                          Leitor.rExtrai(1, 'SignedInfo', '', I + 1) +
                          Leitor.rExtrai(1, 'SignatureValue', '', I + 1) +
                          Leitor.rExtrai(1, 'KeyInfo', '', I + 1) +
                         '</Signature>'+
                        '</eventoBPe>';

              Leitor.Arquivo := FPRetWS;
              Texto := Texto +
                         '<retEventoBPe versao="' + VersaoEvento + '">' +
                          Leitor.rExtrai(1, 'infEvento', '', J + 1) +
                         '</retEventoBPe>' +
                        '</procEventoBPe>';

              if FPConfiguracoesBPe.Arquivos.Salvar then
              begin
                NomeArq := OnlyNumber(FEvento.Evento.Items[i].infEvento.Id) + '-procEventoBPe.xml';
                PathArq := PathWithDelim(GerarPathEvento(FEvento.Evento.Items[I].infEvento.CNPJ, FEvento.Evento.Items[I].infEvento.detEvento.IE));

                FPDFeOwner.Gravar(NomeArq, Texto, PathArq);
                FEventoRetorno.retEvento.Items[J].RetinfEvento.NomeArquivo := PathArq + NomeArq;
                FEvento.Evento.Items[I].RetinfEvento.NomeArquivo := PathArq + NomeArq;
              end;

              { Converte de UTF8 para a String nativa e Decodificar caracteres HTML Entity }
              Texto := ParseText(Texto);
            end;

            // Se o evento for rejeitado a propriedade XML conter� uma String vazia
            FEventoRetorno.retEvento.Items[J].RetinfEvento.XML := Texto;
            FEvento.Evento.Items[I].RetinfEvento.XML := Texto;

            break;
          end;
        end;
      end;
    finally
      Leitor.Free;
    end;
  end;
end;

function TBPeEnvEvento.GerarMsgLog: String;
var
  aMsg: String;
begin
  {(*}
  aMsg := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                         'Ambiente: %s ' + LineBreak +
                         'Vers�o Aplicativo: %s ' + LineBreak +
                         'Status C�digo: %s ' + LineBreak +
                         'Status Descri��o: %s ' + LineBreak),
                 [FEventoRetorno.versao, TpAmbToStr(FEventoRetorno.tpAmb),
                  FEventoRetorno.verAplic, IntToStr(FEventoRetorno.cStat),
                  FEventoRetorno.xMotivo]);

  if FEventoRetorno.retEvento.Count > 0 then
    aMsg := aMsg + Format(ACBrStr('Recebimento: %s ' + LineBreak),
       [IfThen(FEventoRetorno.retEvento.Items[0].RetinfEvento.dhRegEvento = 0, '',
               FormatDateTimeBr(FEventoRetorno.retEvento.Items[0].RetinfEvento.dhRegEvento))]);

  Result := aMsg;
  {*)}
end;

function TBPeEnvEvento.GerarPrefixoArquivo: String;
begin
  Result := IntToStr(FidLote);
end;

{ TDistribuicaoDFe }

constructor TDistribuicaoDFe.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
end;

destructor TDistribuicaoDFe.Destroy;
begin
  FretDistDFeInt.Free;
  FlistaArqs.Free;

  inherited;
end;

procedure TDistribuicaoDFe.Clear;
begin
  inherited Clear;

  FPStatus := stDistDFeInt;
  FPLayout := LayDistDFeInt;
  FPArqEnv := 'con-dist-dfe';
  FPArqResp := 'dist-dfe';
  FPBodyElement := 'bpeDistDFeInteresse';
  FPHeaderElement := '';

  if Assigned(FretDistDFeInt) then
    FretDistDFeInt.Free;

  FretDistDFeInt := TRetDistDFeInt.Create('BPe');

  if Assigned(FlistaArqs) then
    FlistaArqs.Free;

  FlistaArqs := TStringList.Create;
end;

procedure TDistribuicaoDFe.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoBPeToDbl(FPConfiguracoesBPe.Geral.VersaoDF);

  TACBrBPe(FPDFeOwner).LerServicoDeParams(
    TACBrBPe(FPDFeOwner).GetNomeModeloDFe,
    UF ,
    FPConfiguracoesBPe.WebServices.Ambiente,
    LayOutBPeToServico(FPLayout),
    Versao,
    FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TDistribuicaoDFe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'BPeDistribuicaoDFe';
  FPSoapAction := FPServico + '/bpeDistDFeInteresse';
end;

procedure TDistribuicaoDFe.DefinirDadosMsg;
var
  DistDFeInt: TDistDFeInt;
begin
  DistDFeInt := TDistDFeInt.Create(FPVersaoServico, NAME_SPACE_BPE,
                                     'bpeDadosMsg', 'consChBPe', 'chBPe', True);
  try
    DistDFeInt.TpAmb := FPConfiguracoesBPe.WebServices.Ambiente;
    DistDFeInt.cUFAutor := FcUFAutor;
    DistDFeInt.CNPJCPF := FCNPJCPF;
    DistDFeInt.ultNSU := trim(FultNSU);
    DistDFeInt.NSU := trim(FNSU);
    DistDFeInt.Chave := trim(FchBPe);

    AjustarOpcoes( DistDFeInt.Gerador.Opcoes );
    DistDFeInt.GerarXML;

    FPDadosMsg := DistDFeInt.Gerador.ArquivoFormatoXML;
  finally
    DistDFeInt.Free;
  end;
end;

function TDistribuicaoDFe.TratarResposta: Boolean;
var
  I: Integer;
  AXML: String;
begin
  FPRetWS := SeparaDadosArray(['bpeResultMsg', 'bpeDistDFeInteresseResult'], FPRetornoWS );

  // Processando em UTF8, para poder gravar arquivo corretamente //
  FretDistDFeInt.Leitor.Arquivo := FPRetWS;
  FretDistDFeInt.LerXml;

  for I := 0 to FretDistDFeInt.docZip.Count - 1 do
  begin
    AXML := FretDistDFeInt.docZip.Items[I].XML;
    FNomeArq := '';
    if (AXML <> '') then
    begin
      case FretDistDFeInt.docZip.Items[I].schema of
        schresBPe:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resDFe.chDFe + '-resBPe.xml';

        schresEvento:
          FNomeArq := OnlyNumber(TpEventoToStr(FretDistDFeInt.docZip.Items[I].resEvento.tpEvento) +
                     FretDistDFeInt.docZip.Items[I].resEvento.chDFe +
                     Format('%.2d', [FretDistDFeInt.docZip.Items[I].resEvento.nSeqEvento])) +
                     '-resEventoBPe.xml';

        schprocBPe:
          FNomeArq := FretDistDFeInt.docZip.Items[I].resDFe.chDFe + '-bpe.xml';

        schprocEventoBPe:
          FNomeArq := OnlyNumber(FretDistDFeInt.docZip.Items[I].procEvento.Id) +
                     '-procEventoBPe.xml';
      end;

      if NaoEstaVazio(NomeArq) then
        FlistaArqs.Add( FNomeArq );

      if (FPConfiguracoesBPe.Arquivos.Salvar) and NaoEstaVazio(FNomeArq) then
      begin
        if FPConfiguracoesBPe.Arquivos.SalvarEvento then
           if (FretDistDFeInt.docZip.Items[I].schema in [schprocEventoBPe]) then // salvar evento
              FPDFeOwner.Gravar(FNomeArq, AXML, GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]));

        if (FretDistDFeInt.docZip.Items[I].schema in [schprocBPe]) then
           FPDFeOwner.Gravar(FNomeArq, AXML, GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]));
      end;
    end;
  end;

  { Processsa novamente, chamando ParseTXT, para converter de UTF8 para a String
    nativa e Decodificar caracteres HTML Entity }
  FretDistDFeInt.Free;   // Limpando a lista
  FretDistDFeInt := TRetDistDFeInt.Create('BPe');

  FretDistDFeInt.Leitor.Arquivo := ParseText(FPRetWS);
  FretDistDFeInt.LerXml;

  FPMsg := FretDistDFeInt.xMotivo;
  Result := (FretDistDFeInt.CStat = 137) or (FretDistDFeInt.CStat = 138);
end;

function TDistribuicaoDFe.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Resposta: %s ' + LineBreak +
                           '�ltimo NSU: %s ' + LineBreak +
                           'M�ximo NSU: %s ' + LineBreak),
                   [FretDistDFeInt.versao, TpAmbToStr(FretDistDFeInt.tpAmb),
                    FretDistDFeInt.verAplic, IntToStr(FretDistDFeInt.cStat),
                    FretDistDFeInt.xMotivo,
                    IfThen(FretDistDFeInt.dhResp = 0, '',
                           FormatDateTimeBr(RetDistDFeInt.dhResp)),
                    FretDistDFeInt.ultNSU, FretDistDFeInt.maxNSU]);
  {*)}
end;

function TDistribuicaoDFe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Distribui��o de DFe:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TDistribuicaoDFe.GerarPathDistribuicao(AItem: TdocZipCollectionItem): String;
var
  Data: TDateTime;
begin
  if FPConfiguracoesBPe.Arquivos.EmissaoPathBPe then
    Data := AItem.resDFe.dhEmi
  else
    Data := Now;

  case AItem.schema of
    schprocEventoBPe:
      Result := FPConfiguracoesBPe.Arquivos.GetPathDownloadEvento(AItem.procEvento.tpEvento,
                                                          AItem.resDFe.xNome,
                                                          AItem.resDFe.CNPJCPF,
                                                          AItem.resDFe.IE,
                                                          Data);

    schprocBPe:
      Result := FPConfiguracoesBPe.Arquivos.GetPathDownload(AItem.resDFe.xNome,
                                                        AItem.resDFe.CNPJCPF,
                                                        AItem.resDFe.IE,
                                                        Data);
  end;
end;

{ TBPeEnvioWebService }

constructor TBPeEnvioWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stEnvioWebService;
end;

destructor TBPeEnvioWebService.Destroy;
begin
  inherited Destroy;
end;

procedure TBPeEnvioWebService.Clear;
begin
  inherited Clear;

  FVersao := '';
end;

function TBPeEnvioWebService.Executar: Boolean;
begin
  Result := inherited Executar;
end;

procedure TBPeEnvioWebService.DefinirURL;
begin
  FPURL := FPURLEnvio;
end;

procedure TBPeEnvioWebService.DefinirServicoEAction;
begin
  FPServico := FPSoapAction;
end;

procedure TBPeEnvioWebService.DefinirDadosMsg;
var
  LeitorXML: TLeitor;
begin
  LeitorXML := TLeitor.Create;
  try
    LeitorXML.Arquivo := FXMLEnvio;
    LeitorXML.Grupo := FXMLEnvio;
    FVersao := LeitorXML.rAtributo('versao')
  finally
    LeitorXML.Free;
  end;

  FPDadosMsg := FXMLEnvio;
end;

function TBPeEnvioWebService.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'soap:Body');
  Result := True;
end;

function TBPeEnvioWebService.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService: '+FPServico + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TBPeEnvioWebService.GerarVersaoDadosSoap: String;
begin
  Result := '<versaoDados>' + FVersao + '</versaoDados>';
end;

{ TWebServices }

constructor TWebServices.Create(AOwner: TACBrDFe);
begin
  FACBrBPe := TACBrBPe(AOwner);

  FStatusServico := TBPeStatusServico.Create(FACBrBPe);
  FEnviar := TBPeRecepcao.Create(FACBrBPe, TACBrBPe(FACBrBPe).Bilhetes);
  FConsulta := TBPeConsulta.Create(FACBrBPe, TACBrBPe(FACBrBPe).Bilhetes);
  FEnvEvento := TBPeEnvEvento.Create(FACBrBPe, TACBrBPe(FACBrBPe).EventoBPe);
  FDistribuicaoDFe := TDistribuicaoDFe.Create(FACBrBPe);
  FEnvioWebService := TBPeEnvioWebService.Create(FACBrBPe);
end;

destructor TWebServices.Destroy;
begin
  FStatusServico.Free;
  FEnviar.Free;
  FConsulta.Free;
  FEnvEvento.Free;
  FDistribuicaoDFe.Free;
  FEnvioWebService.Free;

  inherited Destroy;
end;

function TWebServices.Envia(ALote: Integer): Boolean;
begin
  Result := Envia(IntToStr(ALote));
end;

function TWebServices.Envia(const ALote: String): Boolean;
begin
  FEnviar.Clear;

  FEnviar.Lote := ALote;

  if not Enviar.Executar then
    Enviar.GerarException( Enviar.Msg );

  Result := True;
end;

end.
