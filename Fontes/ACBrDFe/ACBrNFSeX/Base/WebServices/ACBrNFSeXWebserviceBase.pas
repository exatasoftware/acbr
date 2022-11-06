{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Dias                                     }
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

unit ACBrNFSeXWebserviceBase;

interface

uses
  Classes, SysUtils,
  {$IFNDEF NOGUI}
   {$IFDEF CLX}
     QDialogs,
   {$ELSE}
     {$IFDEF FMX}
       FMX.Dialogs,
     {$ELSE}
       Dialogs,
     {$ENDIF}
   {$ENDIF}
  {$ENDIF}
  ACBrBase, ACBrDFe, ACBrDFeConfiguracoes, ACBrDFeSSL,
  ACBrXmlDocument, ACBrNFSeXConversao;

resourcestring
  ERR_NAO_IMP = 'Servi�o n�o implementado para este provedor.';
  ERR_SEM_URL_PRO = 'N�o informado a URL de Produ��o, favor entrar em contato com a Prefeitura ou Provedor.';
  ERR_SEM_URL_HOM = 'N�o informado a URL de Homologa��o, favor entrar em contato com a Prefeitura ou Provedor.';

type

  TACBrNFSeXWebservice = class
  private
    FPrefixo: string;

    function GetBaseUrl: string;

  protected
    HttpClient: TDFeSSLHttpClass;
    FPMethod: string;

    FPFaultNode: string;
    FPFaultCodeNode: string;
    FPFaultMsgNode: string;

    FPConfiguracoes: TConfiguracoes;
    FPDFeOwner: TACBrDFe;
    FPURL: string;
    FPMimeType: string;
    FPEnvio: string;
    FPRetorno: string;
    FUseOuterXml: Boolean;

    FPArqEnv: string;
    FPArqResp: string;
    FPMsgOrig: string;

    procedure FazerLog(const Msg: string; Exibir: Boolean = False); virtual;
    procedure GerarException(const Msg: string; E: Exception = nil); virtual;
    function GetSoapBody(const Response: string): string; virtual;

    function GerarPrefixoArquivo: string; virtual;

    procedure SalvarEnvio(ADadosSoap, ADadosMsg: string); virtual;
    procedure SalvarRetornoWebService(ADadosSoap: string); virtual;
    procedure SalvarRetornoDadosMsg(ADadosMsg: string); virtual;

    procedure SetHeaders(aHeaderReq: THTTPHeader); virtual;

    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                                  namespace: array of string): string; virtual; abstract;

    function ExtrairRetorno(const ARetorno: string; responseTag: array of string): string; virtual;
    function TratarXmlRetornado(const aXML: string): string; virtual;

    procedure VerificarErroNoRetorno(const ADocument: TACBrXmlDocument); virtual;
    procedure UsarCertificado; virtual;
    procedure EnviarDados(SoapAction: string); virtual;
    procedure EnvioInterno(var CodigoErro, CodigoInterno: Integer); virtual;
    procedure ConfigurarHttpClient; virtual;
    procedure LevantarExcecaoHttp; virtual;

    function Executar(SoapAction, Message, responseTag: string): string; overload;
    function Executar(SoapAction, Message, responseTag, namespace: string): string; overload;
    function Executar(SoapAction, Message, responseTag: string;
                                  namespace: array of string): string; overload;
    function Executar(SoapAction, Message: string;
                      responseTag, namespace: array of string): string; overload;
    function Executar(SoapAction, Message, SoapHeader: string;
                      responseTag, namespace: array of string): string; overload;
  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST');

    function Recepcionar(ACabecalho, AMSG: string): string; virtual;
    function ConsultarLote(ACabecalho, AMSG: string): string; virtual;
    function ConsultarSituacao(ACabecalho, AMSG: string): string; virtual;
    function ConsultarNFSePorRps(ACabecalho, AMSG: string): string; virtual;
    function ConsultarNFSe(ACabecalho, AMSG: string): string; virtual;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: string): string; virtual;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: string): string; virtual;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: string): string; virtual;
    function Cancelar(ACabecalho, AMSG: string): string; virtual;
    function GerarNFSe(ACabecalho, AMSG: string): string; virtual;
    function RecepcionarSincrono(ACabecalho, AMSG: string): string; virtual;
    function SubstituirNFSe(ACabecalho, AMSG: string): string; virtual;
    function GerarToken(ACabecalho, AMSG: string): string; virtual;
    function AbrirSessao(ACabecalho, AMSG: string): string; virtual;
    function FecharSessao(ACabecalho, AMSG: string): string; virtual;
    function TesteEnvio(ACabecalho, AMSG: string): string; virtual;
    function EnviarEvento(ACabecalho, AMSG: string): string; virtual;
    function ConsultarEvento(ACabecalho, AMSG: string): string; virtual;
    function ConsultarDFe(ACabecalho, AMSG: string): string; virtual;
    function ConsultarParam(ACabecalho, AMSG: string): string; virtual;

    property URL: string read FPURL;
    property BaseURL: string read GetBaseUrl;
    property MimeType: string read FPMimeType;
    property Envio: string read FPEnvio;
    property Retorno: string read FPRetorno;
    property Prefixo: string read FPrefixo write FPrefixo;
    property Method: string read FPMethod;

  end;

  TACBrNFSeXWebserviceSoap11 = class(TACBrNFSeXWebservice)
  protected
    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                                  namespace: array of string): string; override;
  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'text/xml');

  end;

  TACBrNFSeXWebserviceSoap12 = class(TACBrNFSeXWebservice)
  protected
    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                                  namespace: array of string): string; override;
  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'application/soap+xml');

  end;

  TACBrNFSeXWebserviceNoSoap = class(TACBrNFSeXWebservice)
  protected
    function GetSoapBody(const Response: string): string; override;

    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                                  namespace: array of string): string; override;
  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'application/xml');

  end;

  TACBrNFSeXWebserviceRest = class(TACBrNFSeXWebserviceNoSoap)
  protected
    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                           namespace: array of string): string; override;

  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'application/json');

  end;

  TACBrNFSeXWebserviceRest2 = class(TACBrNFSeXWebserviceNoSoap)
  protected
    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                           namespace: array of string): string; override;

  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'application/json');

  end;

  TACBrNFSeXWebserviceMulti1 = class(TACBrNFSeXWebserviceNoSoap)
  protected
    FPBound: string;

    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                                  namespace: array of string): string; override;
  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'text/xml');

  end;

  TACBrNFSeXWebserviceMulti2 = class(TACBrNFSeXWebserviceNoSoap)
  protected
    FPBound: string;

    function DefinirMsgEnvio(const Message, SoapAction, SoapHeader: string;
                           namespace: array of string): string; override;

  public
    constructor Create(AOwner: TACBrDFe; AMetodo: TMetodo; AURL: string;
      AMethod: string = 'POST'; AMimeType: string = 'text/xml');

  end;

  TInfConsultaNFSe = class
 private
   FNumeroIniNFSe: string;
   FNumeroFinNFSe: string;
   FNumeroLote: string;
   FDataInicial: TDateTime;
   FDataFinal: TDateTime;

   FCNPJPrestador: string;
   FIMPrestador: string;
   FCNPJTomador: string;
   FIMTomador: string;
   FCNPJInter: string;
   FIMInter: string;
   FRazaoInter: string;

   FPagina: Integer;
   FtpConsulta: TtpConsulta;
   FtpPeriodo: TtpPeriodo;
   FtpDocumento: TtpDocumento;
   FCadEconomico: string;
   FSerieNFSe: string;
   FCodServ: string;
   FCodVerificacao: string;
   FtpRetorno: TtpRetorno;

 public
   constructor Create;

   function LerFromIni(const AIniStr: string): Boolean;

   property NumeroIniNFSe: string   read FNumeroIniNFSe write FNumeroIniNFSe;
   property NumeroFinNFSe: string   read FNumeroFinNFSe write FNumeroFinNFSe;
   property NumeroLote: string      read FNumeroLote    write FNumeroLote;
   property DataInicial: TDateTime  read FDataInicial   write FDataInicial;
   property DataFinal: TDateTime    read FDataFinal     write FDataFinal;
   property CNPJPrestador: string   read FCNPJPrestador write FCNPJPrestador;
   property IMPrestador: string     read FIMPrestador   write FIMPrestador;
   property CNPJTomador: string     read FCNPJTomador   write FCNPJTomador;
   property IMTomador: string       read FIMTomador     write FIMTomador;
   property CNPJInter: string       read FCNPJInter     write FCNPJInter;
   property IMInter: string         read FIMInter       write FIMInter;
   property RazaoInter: string      read FRazaoInter    write FRazaoInter;
   property Pagina: Integer         read FPagina        write FPagina;
   property tpConsulta: TtpConsulta read FtpConsulta    write FtpConsulta;
   property tpPeriodo: TtpPeriodo   read FtpPeriodo     write FtpPeriodo;
   property tpDocumento: TtpDocumento read FtpDocumento write FtpDocumento;
   property CadEconomico: string    read FCadEconomico  write FCadEconomico;
   property SerieNFSe: string       read FSerieNFSe     write FSerieNFSe;
   property CodServ: string         read FCodServ       write FCodServ;
   property CodVerificacao: string  read FCodVerificacao write FCodVerificacao;
   property tpRetorno: TtpRetorno   read FtpRetorno     write FtpRetorno;
 end;

  TInfCancelamento = class
  private
    FNumeroNFSe: string;
    FSerieNFSe: string;
    FChaveNFSe: string;
    FDataEmissaoNFSe: TDateTime;
    FCodCancelamento: string;
    FMotCancelamento: string;
    FNumeroLote: string;
    FNumeroRps: Integer;
    FSerieRps: string;
    FValorNFSe: Double;
    FCodVerificacao: string;
    Femail: string;
    FNumeroNFSeSubst: string;
    FSerieNFSeSubst: string;
    FCodServ: string;
    FtpDocumento: TtpDocumento;

  public
    constructor Create;

    function LerFromIni(const AIniStr: string): Boolean;

    property NumeroNFSe: string      read FNumeroNFSe      write FNumeroNFSe;
    property SerieNFSe: string       read FSerieNFSe       write FSerieNFSe;
    property ChaveNFSe: string       read FChaveNFSe       write FChaveNFSe;
    property DataEmissaoNFSe: TDateTime read FDataEmissaoNFSe write FDataEmissaoNFSe;
    property CodCancelamento: string read FCodCancelamento write FCodCancelamento;
    property MotCancelamento: string read FMotCancelamento write FMotCancelamento;
    property NumeroLote: string      read FNumeroLote      write FNumeroLote;
    property NumeroRps: Integer      read FNumeroRps       write FNumeroRps;
    property SerieRps: string        read FSerieRps        write FSerieRps;
    property ValorNFSe: Double       read FValorNFSe       write FValorNFSe;
    property CodVerificacao: string  read FCodVerificacao  write FCodVerificacao;
    property email: string           read Femail           write Femail;
    property NumeroNFSeSubst: string read FNumeroNFSeSubst write FNumeroNFSeSubst;
    property SerieNFSeSubst: string  read FSerieNFSeSubst  write FSerieNFSeSubst;
    property CodServ: string         read FCodServ         write FCodServ;
    property tpDocumento: TtpDocumento read FtpDocumento   write FtpDocumento;

  end;

   TpedRegEvento = class
  private
    FID: string;
    FtpAmb: Integer;
    FverAplic: string;
    FdhEvento: TDateTime;
    FchNFSe: string;
    FnPedRegEvento: Integer;
    FtpEvento: TtpEvento;
    FcMotivo: Integer;
    FxMotivo: string;
    FchSubstituta: string;
  public
    constructor Create;

    property ID: string             read FID            write FID;
    property tpAmb: Integer         read FtpAmb         write FtpAmb;
    property verAplic: string       read FverAplic      write FverAplic;
    property dhEvento: TDateTime    read FdhEvento      write FdhEvento;
    property chNFSe: string         read FchNFSe        write FchNFSe;
    property nPedRegEvento: Integer read FnPedRegEvento write FnPedRegEvento;
    property tpEvento: TtpEvento    read FtpEvento      write FtpEvento;
    property cMotivo: Integer       read FcMotivo       write FcMotivo;
    property xMotivo: string        read FxMotivo       write FxMotivo;
    property chSubstituta: string   read FchSubstituta  write FchSubstituta;
  end;

 TInfEvento = class
  private
    FID: string;
    FverAplic: string;
    FambGer: Integer;
    FnSeqEvento: Integer;
    FdhProc: TDateTime;
    FnDFe: string;
    FpedRegEvento: TpedRegEvento;
  public
    constructor Create;
    destructor Destroy; override;

    function LerFromIni(const AIniStr: string): Boolean;

    property ID: string                  read FID;
    property verAplic: string            read FverAplic     write FverAplic;
    property ambGer: Integer             read FambGer       write FambGer;
    property nSeqEvento: Integer         read FnSeqEvento   write FnSeqEvento;
    property dhProc: TDateTime           read FdhProc       write FdhProc;
    property nDFe: string                read FnDFe         write FnDFe;
    property pedRegEvento: TpedRegEvento read FpedRegEvento write FpedRegEvento;
  end;

implementation

uses
  IniFiles, StrUtils, synautil,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.DateTime,
  ACBrUtil.FilesIO,
  ACBrConsts, ACBrDFeException, ACBrXmlBase,
  ACBrNFSeX, ACBrNFSeXConfiguracoes;

{ TACBrNFSeXWebservice }

constructor TACBrNFSeXWebservice.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string);
begin
  FPDFeOwner := AOwner;
  if Assigned(AOwner) then
    FPConfiguracoes := AOwner.Configuracoes;

  FUseOuterXml := True;

  FPFaultNode := 'Fault';
  FPFaultCodeNode := 'faultcode';
  FPFaultMsgNode := 'faultstring';

  case AMetodo of
    tmRecepcionar:
      begin
        FPArqEnv := 'env-lot';
        FPArqResp := 'rec';
      end;

    tmTeste:
      begin
        FPArqEnv := 'env-lot-teste';
        FPArqResp := 'rec-teste';
      end;

    tmConsultarSituacao:
      begin
        FPArqEnv := 'con-sit';
        FPArqResp := 'sit';
      end;

    tmConsultarLote:
      begin
        FPArqEnv := 'con-lot';
        FPArqResp := 'lista-nfse-con-lot';
      end;

    tmConsultarNFSePorRps:
      begin
        FPArqEnv := 'con-nfse-rps';
        FPArqResp := 'comp-nfse';
      end;

    tmConsultarNFSe:
      begin
        FPArqEnv := 'con-nfse';
        FPArqResp := 'lista-nfse-con';
      end;

    tmConsultarNFSePorFaixa:
      begin
        FPArqEnv := 'con-nfse-fai';
        FPArqResp := 'lista-nfse-fai';
      end;

    tmConsultarNFSeServicoPrestado:
      begin
        FPArqEnv := 'con-nfse-ser-pres';
        FPArqResp := 'lista-nfse-ser-pres';
      end;

    tmConsultarNFSeServicoTomado:
      begin
        FPArqEnv := 'con-nfse-ser-tom';
        FPArqResp := 'lista-nfse-ser-tom';
      end;

    tmCancelarNFSe:
      begin
        FPArqEnv := 'ped-can';
        FPArqResp := 'can';
      end;

    tmGerar:
      begin
        FPArqEnv := 'ger-nfse';
        FPArqResp := 'lista-nfse-ger';
      end;

    tmRecepcionarSincrono:
      begin
        FPArqEnv := 'env-lot-sinc';
        FPArqResp := 'lista-nfse-sinc';
      end;

    tmSubstituirNFSe:
      begin
        FPArqEnv := 'ped-sub';
        FPArqResp := 'sub';
      end;

    tmGerarToken:
      begin
        FPArqEnv := 'ped-token';
        FPArqResp := 'ret-token';
      end;

    tmAbrirSessao:
      begin
        FPArqEnv := 'abr-ses';
        FPArqResp := 'ret-abr';
      end;

    tmFecharSessao:
      begin
        FPArqEnv := 'fec-ses';
        FPArqResp := 'ret-fec';
      end;

    tmEnviarEvento:
      begin
        FPArqEnv := 'env-eve';
        FPArqResp := 'eve';
      end;

    tmConsultarEvento:
      begin
        FPArqEnv := 'con-eve';
        FPArqResp := 'eve';
      end;

    tmConsultarDFe:
      begin
        FPArqEnv := 'con-dfe';
        FPArqResp := 'dfe';
      end;

    tmConsultarParam:
      begin
        FPArqEnv := 'con-param';
        FPArqResp := 'param';
      end;
  end;

  FPURL := AURL;
  FPMethod := AMethod;
end;

procedure TACBrNFSeXWebservice.FazerLog(const Msg: string; Exibir: Boolean);
var
  Tratado: Boolean;
begin
  if (Msg <> '') then
  begin
    FPDFeOwner.FazerLog(Msg, Tratado);

    if Tratado then Exit;

    {$IFNDEF NOGUI}
    if Exibir and FPConfiguracoes.WebServices.Visualizar then
      ShowMessage(ACBrStr(Msg));
    {$ENDIF}
  end;
end;

procedure TACBrNFSeXWebservice.GerarException(const Msg: string; E: Exception);
begin
  FPDFeOwner.GerarException(ACBrStr(Msg), E);
end;

function TACBrNFSeXWebservice.GetBaseUrl: string;
var
  i:Integer;
begin
  Result := '';

  if EstaVazio(Url) then Exit;

  i := Pos('//', Url);

  if i>0 then
    i := PosEx('/', Url, i+2)
  else
    i := Pos('/', Url);

  if i=0 then
    i := Length(Url);

  Result := Copy(Url, 1, i);
end;

function TACBrNFSeXWebservice.GerarPrefixoArquivo: string;
begin
  if FPrefixo = '' then
    Result := FormatDateTime('yyyymmddhhnnss', Now)
  else
    Result := TiraPontos(FPrefixo);
end;

procedure TACBrNFSeXWebservice.SalvarEnvio(ADadosSoap, ADadosMsg: string);
var
  Prefixo, ArqEnv: string;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqEnv = '' then Exit;

  Prefixo := GerarPrefixoArquivo;

  if FPConfiguracoes.Geral.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqEnv + '.xml';

    FPDFeOwner.Gravar(ArqEnv, ADadosMsg);
  end;

  if FPConfiguracoes.WebServices.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqEnv + '-soap.xml';

    FPDFeOwner.Gravar(ArqEnv, ADadosSoap);
  end;
end;

procedure TACBrNFSeXWebservice.SalvarRetornoDadosMsg(ADadosMsg: string);
var
  Prefixo, ArqEnv: string;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqResp = '' then Exit;

  Prefixo := GerarPrefixoArquivo;

  if FPDFeOwner.Configuracoes.Geral.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqResp + '.xml';

    FPDFeOwner.Gravar(ArqEnv, ADadosMsg);
  end;
end;

procedure TACBrNFSeXWebservice.SalvarRetornoWebService(ADadosSoap: string);
var
  Prefixo, ArqEnv: string;
begin
  { Sobrescrever apenas se necess�rio }

  if FPArqResp = '' then Exit;

  Prefixo := GerarPrefixoArquivo;

  if FPDFeOwner.Configuracoes.WebServices.Salvar then
  begin
    ArqEnv := Prefixo + '-' + FPArqResp + '-soap.xml';

    if not XmlEhUTF8(ADadosSoap) then
      ADadosSoap := RemoverDeclaracaoXML(ADadosSoap);

    FPDFeOwner.Gravar(ArqEnv, ADadosSoap);
  end;
end;

procedure TACBrNFSeXWebservice.SetHeaders(aHeaderReq: THTTPHeader);
begin
  if TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.UseAuthorizationHeader then
    aHeaderReq.AddHeader('Authorization', TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSChaveAutoriz);
end;

function TACBrNFSeXWebservice.GetSoapBody(const Response: string): string;
begin
  Result := SeparaDados(Response, 'Body');
end;

procedure TACBrNFSeXWebservice.LevantarExcecaoHttp;
var
  aRetorno: TACBrXmlDocument;
begin
  // Verifica se o ResultCode �: 200 OK; 201 Created; 202 Accepted
  // https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html

//  if not (HttpClient.HTTPResultCode in [200..202]) then
//    raise EACBrDFeException.Create('Erro de Conex�o.');

  if not (HttpClient.HTTPResultCode in [200..202]) then
  begin
    aRetorno := TACBrXmlDocument.Create;
    try
      aRetorno.LoadFromXml(FPRetorno);
      VerificarErroNoRetorno(aRetorno);
    finally
      aRetorno.Free;
    end;
  end;
end;

procedure TACBrNFSeXWebservice.VerificarErroNoRetorno(const ADocument: TACBrXmlDocument);
var
  ANode: TACBrXmlNode;
  aMsg, xFaultCodeNode, xFaultMsgNode, xCode, xReason, xDetail: string;
begin
  if ADocument.Root.LocalName = FPFaultNode then
    ANode := ADocument.Root
  else
    ANode := ADocument.Root.Childrens.FindAnyNs(FPFaultNode);

  {
    Se o ANode for igual a nil significa que n�o foi retornado nenhum
    Grupo/Elemento de erro no Soap, logo n�o tem erro Soap a ser apresentado.
  }

  if ANode = nil then
    Exit;

  xFaultCodeNode := ObterConteudoTag(ANode.Childrens.FindAnyNs(FPFaultCodeNode), tcStr);
  xFaultMsgNode := ObterConteudoTag(ANode.Childrens.FindAnyNs(FPFaultMsgNode), tcStr);

  xCode := ObterConteudoTag(ANode.Childrens.FindAnyNs('Code'), tcStr);
  xReason := ObterConteudoTag(ANode.Childrens.FindAnyNs('Reason'), tcStr);
  xDetail := ObterConteudoTag(ANode.Childrens.FindAnyNs('Detail'), tcStr);

  if (xFaultCodeNode <> '') or (xFaultMsgNode <> '') then
    aMsg := IfThen(xFaultCodeNode = '', '999', xFaultCodeNode) + ' - ' +
            IfThen(xFaultMsgNode = '', 'Erro Desconhecido.', xFaultMsgNode)
  else
    aMsg := xCode + ' - ' + xReason + ' - ' + xDetail;

  raise EACBrDFeException.Create(aMsg);
end;

function TACBrNFSeXWebservice.ExtrairRetorno(const ARetorno: string;
  responseTag: array of string): string;
var
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  I: Integer;
  xRetorno: string;
begin
  Result := '';

  xRetorno := TratarXmlRetornado(ARetorno);

  if xRetorno = '' then
    Exit;

  if not StringIsXML(xRetorno) then
  begin
    Result := xRetorno;
    Exit;
  end;

  if (Length(responseTag) = 0) then
  begin
    Result := xRetorno;
    Exit;
  end;

  Document := TACBrXmlDocument.Create;
  try
    Document.LoadFromXml(xRetorno);

    VerificarErroNoRetorno(Document);
    ANode := Document.Root;

    if ANode.Name <> 'a' then
    begin
      for I := Low(responseTag) to High(responseTag) do
      begin
        if ANode <> nil then
          ANode := ANode.Childrens.FindAnyNs(responseTag[I]);
      end;

      if ANode = nil then
        ANode := Document.Root.Childrens.FindAnyNs(responseTag[0]);

      if ANode = nil then
        ANode := Document.Root;
    end;

    if ANode <> nil then
    begin
      if FUseOuterXml then
        Result := ANode.OuterXml
      else
        Result := ANode.Content;
    end;
  finally
    Document.Free;
  end;
end;

function TACBrNFSeXWebservice.TratarXmlRetornado(const aXML: string): string;
begin
  // Reescrever na Unit Provider do Provedor se necess�rio;
  Result := GetSoapBody(aXML);
end;

procedure TACBrNFSeXWebservice.UsarCertificado;
var
  TemCertificadoConfigurado: Boolean;
begin
  FPDFeOwner.SSL.UseCertificateHTTP := TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.UseCertificateHTTP;

  if FPDFeOwner.SSL.UseCertificateHTTP then
  begin
    TemCertificadoConfigurado := (FPConfiguracoes.Certificados.NumeroSerie <> '') or
                                 (FPConfiguracoes.Certificados.DadosPFX <> '') or
                                 (FPConfiguracoes.Certificados.ArquivoPFX <> '');

    if TemCertificadoConfigurado then
      if FPConfiguracoes.Certificados.VerificarValidade then
        if (FPDFeOwner.SSL.CertDataVenc < Now) then
          raise EACBrDFeException.Create('Data de Validade do Certificado j� expirou: '+
                                            FormatDateBr(FPDFeOwner.SSL.CertDataVenc));
  end;
end;

function TACBrNFSeXWebservice.Executar(SoapAction, Message, responseTag: string): string;
begin
  Result := Executar(SoapAction, Message, '', [], []);
end;

function TACBrNFSeXWebservice.Executar(SoapAction, Message, responseTag, namespace: string): string;
begin
  Result := Executar(SoapAction, Message, '', [responseTag], [namespace]);
end;

function TACBrNFSeXWebservice.Executar(SoapAction, Message, responseTag: string;
  namespace: array of string): string;
begin
  Result := Executar(SoapAction, Message, '', [responseTag], namespace);
end;

function TACBrNFSeXWebservice.Executar(SoapAction, Message: string;
  responseTag, namespace: array of string): string;
begin
  Result := Executar(SoapAction, Message, '', responseTag, namespace);
end;

procedure TACBrNFSeXWebservice.EnviarDados(SoapAction: string);
var
  Tentar, Tratado: Boolean;
  HTTPResultCode: Integer;
  InternalErrorCode: Integer;
begin
  Tentar := True;

  while Tentar do
  begin
    Tentar  := False;
    Tratado := False;
    FPRetorno := '';
    HTTPResultCode := 0;
    InternalErrorCode := 0;

    try
      // Envio por Evento... Aplica��o cuidar� do envio
      if Assigned(FPDFeOwner.OnTransmit) then
      begin
        FPDFeOwner.OnTransmit(FPEnvio, FPURL, SoapAction,
                              FPMimeType, FPRetorno,
                              HTTPResultCode, InternalErrorCode);

        if (InternalErrorCode <> 0) then
          raise EACBrDFeException.Create('Erro ao Transmitir');
      end
      else   // Envio interno, por TDFeSSL
      begin
        EnvioInterno(HTTPResultCode, InternalErrorCode);
      end;
    except
      if Assigned(FPDFeOwner.OnTransmitError) then
        FPDFeOwner.OnTransmitError(HTTPResultCode, InternalErrorCode,
                                   FPURL, FPEnvio, SoapAction,
                                   Tentar, Tratado);

      if not (Tentar or Tratado) then raise;
    end;
  end;
end;

procedure TACBrNFSeXWebservice.ConfigurarHttpClient;
begin
  HttpClient.URL := FPURL;
  HttpClient.Method := FPMethod;
  HttpClient.MimeType := FPMimeType;

  SetHeaders(HttpClient.HeaderReq);

  if FPMethod = 'POST' then
    WriteStrToStream(HttpClient.DataReq, AnsiString(FPEnvio));
end;

procedure TACBrNFSeXWebservice.EnvioInterno(var CodigoErro, CodigoInterno: Integer);
begin
  ConfigurarHttpClient;

  try
    try
      HttpClient.Execute;
    finally
      CodigoErro := HttpClient.HTTPResultCode;
      CodigoInterno := HttpClient.InternalErrorCode;
    end;

    HttpClient.DataResp.Position := 0;

    FPRetorno := ReadStrFromStream(HttpClient.DataResp, HttpClient.DataResp.Size);

    if FPRetorno = '' then
      raise EACBrDFeException.Create('WebService retornou um XML vazio.');

    if StringIsXML(FPRetorno) then
      LevantarExcecaoHttp;
  except
    on E:Exception do
    begin
      raise EACBrDFeException.CreateDef(Format(ACBrStr(cACBrDFeSSLEnviarException),
        [HttpClient.InternalErrorCode, HttpClient.HTTPResultCode, HttpClient.URL])
        + sLineBreak + HttpClient.LastErrorDesc+ sLineBreak + E.Message);
    end;
  end;
end;

function TACBrNFSeXWebservice.Executar(SoapAction, Message, SoapHeader: string;
  responseTag, namespace: array of string): string;
begin
  FPEnvio := DefinirMsgEnvio(Message, SoapAction, SoapHeader, namespace);
  SalvarEnvio(FPEnvio, FPMsgOrig);

  UsarCertificado;

  EnviarDados(SoapAction);
  SalvarRetornoWebService(FPRetorno);

  Result := ExtrairRetorno(FPRetorno, responseTag);
  SalvarRetornoDadosMsg(Result);
end;

function TACBrNFSeXWebservice.Recepcionar(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarDFe(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarEvento(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarLote(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarSituacao(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarNFSePorRps(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarNFSe(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarNFSePorFaixa(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarNFSeServicoPrestado(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarNFSeServicoTomado(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.ConsultarParam(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.Cancelar(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.GerarNFSe(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.RecepcionarSincrono(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.SubstituirNFSe(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.GerarToken(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.AbrirSessao(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.FecharSessao(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.TesteEnvio(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

function TACBrNFSeXWebservice.EnviarEvento(ACabecalho, AMSG: string): string;
begin
  Result := '';
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceSoap11 }

constructor TACBrNFSeXWebserviceSoap11.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPMimeType := AMimeType;
end;

function TACBrNFSeXWebserviceSoap11.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
var
  i: Integer;
  ns: string;
begin
  Result := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';

  for i := Low(namespace) to High(namespace) do
  begin
    ns := namespace[i];
    Result := Result + ' ' + ns;
  end;

  Result := Result + '>';

  if NaoEstaVazio(SoapHeader) then
    Result := Result + '<soapenv:Header>' + soapHeader + '</soapenv:Header>'
  else
    Result := Result + '<soapenv:Header/>';

  Result := Result + '<soapenv:Body>' + Message + '</soapenv:Body></soapenv:Envelope>';
  Result := string(NativeStringToUTF8(Result));

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
  HttpClient.HeaderReq.AddHeader('SOAPAction', SoapAction);
end;

{ TACBrNFSeXWebserviceSoap12 }

constructor TACBrNFSeXWebserviceSoap12.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPMimeType := AMimeType;
end;

function TACBrNFSeXWebserviceSoap12.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
var
  i: Integer;
  ns: string;
begin
  Result := '<soapenv:Envelope xmlns:soapenv="http://www.w3.org/2003/05/soap-envelope"';

  for i := Low(namespace) to High(namespace) do
  begin
    ns := namespace[i];
    Result := Result + ' ' + ns;
  end;

  Result := Result + '>';

  if NaoEstaVazio(SoapHeader) then
    Result := Result + '<soapenv:Header>' + soapHeader + '</soapenv:Header>'
  else
    Result := Result + '<soapenv:Header/>';

  Result := Result + '<soapenv:Body>' + message + '</soapenv:Body></soapenv:Envelope>';
  Result := string(NativeStringToUTF8(Result));

  FPMimeType := FPMimeType + ';action="' + SoapAction + '"';

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
end;

{ TACBrNFSeXWebserviceNoSoap }

constructor TACBrNFSeXWebserviceNoSoap.Create(AOwner: TACBrDFe;
  AMetodo: TMetodo; AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPMimeType := AMimeType;
end;

function TACBrNFSeXWebserviceNoSoap.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
begin
  Result := Message;

  Result := string(NativeStringToUTF8(Result));

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
  HttpClient.HeaderReq.AddHeader('SOAPAction', SoapAction);
end;

function TACBrNFSeXWebserviceNoSoap.GetSoapBody(const Response: string): string;
begin
  Result := Response;
end;

{ TACBrNFSeXWebserviceRest }

constructor TACBrNFSeXWebserviceRest.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL, AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPMimeType := AMimeType;
end;

function TACBrNFSeXWebserviceRest.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
begin
  Result := Message;

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
end;

{ TACBrNFSeXWebserviceRest2 }

constructor TACBrNFSeXWebserviceRest2.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPMimeType := AMimeType;
end;

function TACBrNFSeXWebserviceRest2.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
var
  UsuarioWeb, SenhaWeb, Texto: string;
begin
  UsuarioWeb := Trim(TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSUser);

  if UsuarioWeb = '' then
    GerarException(ACBrStr('O provedor ' + TConfiguracoesNFSe(FPConfiguracoes).Geral.xProvedor +
      ' necessita que a propriedade: Configuracoes.Geral.Emitente.WSUser seja informada.'));

  SenhaWeb := Trim(TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSSenha);

  if SenhaWeb = '' then
    GerarException(ACBrStr('O provedor ' + TConfiguracoesNFSe(FPConfiguracoes).Geral.xProvedor +
      ' necessita que a propriedade: Configuracoes.Geral.Emitente.WSSenha seja informada.'));

  Texto := StringReplace(Message, '"', '\"', [rfReplaceAll]);
  Texto := StringReplace(Texto, #10, '', [rfReplaceAll]);
  Texto := StringReplace(Texto, #13, '', [rfReplaceAll]);

  Result := Format('{"xml": "%s", "usuario": "%s", "senha": "%s"}', [Texto, UsuarioWeb, SenhaWeb]);

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
end;

{ TACBrNFSeXWebserviceMulti1 }

constructor TACBrNFSeXWebserviceMulti1.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPBound := IntToHex(Random(MaxInt), 8) + '_Synapse_boundary';
  FPMimeType := 'multipart/form-data; boundary=' + AnsiQuotedStr(FPBound, '"');
end;

function TACBrNFSeXWebserviceMulti1.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
var
  UsuarioWeb, SenhaWeb: string;
begin
  UsuarioWeb := Trim(TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSUser);

  if UsuarioWeb = '' then
    GerarException(ACBrStr('O provedor ' + TConfiguracoesNFSe(FPConfiguracoes).Geral.xProvedor +
      ' necessita que a propriedade: Configuracoes.Geral.Emitente.WSUser seja informada.'));

  SenhaWeb := Trim(TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente.WSSenha);

  if SenhaWeb = '' then
    GerarException(ACBrStr('O provedor ' + TConfiguracoesNFSe(FPConfiguracoes).Geral.xProvedor +
      ' necessita que a propriedade: Configuracoes.Geral.Emitente.WSSenha seja informada.'));

  Result := '--' + FPBound + sLineBreak +
            'Content-Disposition: form-data; name=' +
            AnsiQuotedStr( 'login', '"') + sLineBreak + sLineBreak + UsuarioWeb + sLineBreak +
            '--' + FPBound + sLineBreak +
            'Content-Disposition: form-data; name=' +
            AnsiQuotedStr( 'senha', '"') + sLineBreak + sLineBreak + SenhaWeb + sLineBreak +
            '--' + FPBound + sLineBreak +
            'Content-Disposition: form-data; name=' +
            AnsiQuotedStr('f1', '"' ) + '; ' + 'filename=' +
            AnsiQuotedStr(GerarPrefixoArquivo + '-' + FPArqEnv + '.xml', '"') + sLineBreak +
            'Content-Type: text/xml' + sLineBreak + sLineBreak + Message + sLineBreak +
            '--' + FPBound + '--' + sLineBreak;

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
end;

{ TACBrNFSeXWebserviceMulti2 }

constructor TACBrNFSeXWebserviceMulti2.Create(AOwner: TACBrDFe; AMetodo: TMetodo;
  AURL: string; AMethod: string; AMimeType: string);
begin
  inherited Create(AOwner, AMetodo, AURL, AMethod);

  FPBound := '----=_Part_1_' + IntToHex(Random(MaxInt), 8);
  FPMimeType := 'multipart/form-data; boundary=' + AnsiQuotedStr(FPBound, '"');
end;

function TACBrNFSeXWebserviceMulti2.DefinirMsgEnvio(const Message, SoapAction,
  SoapHeader: string; namespace: array of string): string;
var
  NomeArq: string;
  Tamanho: Integer;
  xTamanho: string;
begin
  NomeArq := GerarPrefixoArquivo + '-' + FPArqEnv + '.xml';

  Result := '--' + FPBound + sLineBreak +
            'Content-Type: text/xml; charset=Cp1252; name=' +
            NomeArq + sLineBreak +
            'Content-Transfer-Encoding: binary' + sLineBreak +
//            'Content-Length: ****' + sLineBreak +
            'Content-Disposition: form-data; name=' + AnsiQuotedStr(NomeArq, '"') +
            '; filename=' + AnsiQuotedStr(NomeArq, '"') + sLineBreak +
            sLineBreak +
            Message + sLineBreak +
            '--' + FPBound + '--' + sLineBreak;

  Tamanho := Length(Result);
  xTamanho := IntToStr(Tamanho);

//  Result := StringReplace(Result, '****', xTamanho, [rfReplaceAll]);

  HttpClient := FPDFeOwner.SSL.SSLHttpClass;

  HttpClient.Clear;
  HttpClient.HeaderReq.AddHeader('Content-Length', xTamanho);
end;

{ TInfConsulta }

constructor TInfConsultaNFSe.Create;
begin
  tpConsulta    := tcPorNumero;
  tpPeriodo     := tpEmissao;
  NumeroIniNFSe := '';
  NumeroFinNFSe := '';
  NumeroLote    := '';
  DataInicial   := 0;
  DataFinal     := 0;
  CNPJPrestador := '';
  IMPrestador   := '';
  CNPJTomador   := '';
  IMTomador     := '';
  CNPJInter     := '';
  IMInter       := '';
  RazaoInter    := '';
  CadEconomico  := '';
  SerieNFSe     := '';
  CodServ       := '';
  CodVerificacao:= '';
  Pagina        := 1;
  tpDocumento   := tdNFSe;
  tpRetorno     := trXml;
end;

function TInfConsultaNFSe.LerFromIni(const AIniStr: string): Boolean;
var
  sSecao: string;
  INIRec: TMemIniFile;
  Ok: Boolean;
begin
{$IFNDEF COMPILER23_UP}
  Result := False;
{$ENDIF}

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniStr, INIRec);

    sSecao := 'ConsultarNFSe';

    tpConsulta := StrTotpConsulta(Ok, INIRec.ReadString(sSecao, 'tpConsulta', '1'));
    tpPeriodo  := StrTotpPeriodo(Ok, INIRec.ReadString(sSecao, 'tpPeriodo', '1'));
    tpRetorno  := StrTotpRetorno(Ok, INIRec.ReadString(sSecao, 'tpRetorno', 'XML'));

    NumeroIniNFSe := INIRec.ReadString(sSecao, 'NumeroIniNFSe', '');
    NumeroFinNFSe := INIRec.ReadString(sSecao, 'NumeroFinNFSe', '');
    NumeroLote    := INIRec.ReadString(sSecao, 'NumeroLote', '');
    DataInicial   := StringToDateTime(INIRec.ReadString(sSecao, 'DataInicial', '0'));
    DataFinal     := StringToDateTime(INIRec.ReadString(sSecao, 'DataFinal', '0'));

    CNPJPrestador := INIRec.ReadString(sSecao, 'CNPJPrestador', '');
    IMPrestador   := INIRec.ReadString(sSecao, 'IMPrestador', '');
    CNPJTomador   := INIRec.ReadString(sSecao, 'CNPJTomador', '');
    IMTomador     := INIRec.ReadString(sSecao, 'IMTomador', '');
    CNPJInter     := INIRec.ReadString(sSecao, 'CNPJInter', '');
    IMInter       := INIRec.ReadString(sSecao, 'IMInter', '');
    RazaoInter    := INIRec.ReadString(sSecao, 'RazaoInter', '');
    tpDocumento   := StrTotpDocumento(Ok, INIRec.ReadString(sSecao, 'Tipo', '1'));
    CadEconomico  := INIRec.ReadString(sSecao, 'CadEconomico', '');
    SerieNFSe     := INIRec.ReadString(sSecao, 'SerieNFSe', '');
    CodServ       := INIRec.ReadString(sSecao, 'CodServ', '');
    CodVerificacao:= INIRec.ReadString(sSecao, 'CodVerificacao', '');

    Pagina        := INIRec.ReadInteger(sSecao, 'Pagina', 1);

    Result := True;
  finally
    INIRec.Free;
  end;
end;

{ TInfCancelamento }

constructor TInfCancelamento.Create;
begin
  FNumeroNFSe := '';
  FSerieNFSe := '';
  FChaveNFSe := '';
  FDataEmissaoNFSe := 0;
  FCodCancelamento := '';
  FMotCancelamento := '';
  FNumeroLote := '';
  FNumeroRps := 0;
  FSerieRps := '';
  FValorNFSe := 0.0;
  FCodVerificacao := '';
  Femail := '';
  FNumeroNFSeSubst := '';
  FSerieNFSeSubst := '';
  FCodServ := '';
  FtpDocumento := tdNFSe;
end;

function TInfCancelamento.LerFromIni(const AIniStr: string): Boolean;
var
  sSecao: string;
  INIRec: TMemIniFile;
  Ok: Boolean;
begin
{$IFNDEF COMPILER23_UP}
  Result := False;
{$ENDIF}

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniStr, INIRec);

    sSecao := 'CancelarNFSe';

    NumeroNFSe      := INIRec.ReadString(sSecao, 'NumeroNFSe', '');
    SerieNFSe       := INIRec.ReadString(sSecao, 'SerieNFSe', '');
    ChaveNFSe       := INIRec.ReadString(sSecao, 'ChaveNFSe', '');
    DataEmissaoNFSe := INIRec.ReadDateTime(sSecao, 'DataEmissaoNFSe', 0);
    CodCancelamento := INIRec.ReadString(sSecao, 'CodCancelamento', '');
    MotCancelamento := INIRec.ReadString(sSecao, 'MotCancelamento', '');
    NumeroLote      := INIRec.ReadString(sSecao, 'NumeroLote', '');
    NumeroRps       := INIRec.ReadInteger(sSecao, 'NumeroRps', 0);
    SerieRps        := INIRec.ReadString(sSecao, 'SerieRps', '');
    ValorNFSe       := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorNFSe', ''), 0);
    CodVerificacao  := INIRec.ReadString(sSecao, 'CodVerificacao', '');
    email           := INIRec.ReadString(sSecao, 'email', '');
    NumeroNFSeSubst := INIRec.ReadString(sSecao, 'NumeroNFSeSubst', '');
    SerieNFSeSubst  := INIRec.ReadString(sSecao, 'SerieNFSeSubst', '');
    CodServ         := INIRec.ReadString(sSecao, 'CodServ', '');
    tpDocumento     := StrTotpDocumento(Ok, INIRec.ReadString(sSecao, 'Tipo', '1'));

    Result := True;
  finally
    INIRec.Free;
  end;
end;

{ TInfEvento }

constructor TInfEvento.Create;
begin
  FverAplic := '';
  FambGer := 0;
  FnSeqEvento := 0;
  FnDFe := '';

  FpedRegEvento := TpedRegEvento.Create;
end;

destructor TInfEvento.Destroy;
begin
  FpedRegEvento.Free;

  inherited Destroy;
end;

function TInfEvento.LerFromIni(const AIniStr: string): Boolean;
var
  sSecao: string;
  INIRec: TMemIniFile;
  Ok: Boolean;
begin
{$IFNDEF COMPILER23_UP}
  Result := False;
{$ENDIF}

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniStr, INIRec);

    sSecao := 'Evento';

    with pedRegEvento do
    begin
      tpAmb := INIRec.ReadInteger(sSecao, 'tpAmb', 0);
      verAplic := INIRec.ReadString(sSecao, 'verAplic', '');
      dhEvento := INIRec.ReadDateTime(sSecao, 'dhEvento', 0);
      chNFSe := INIRec.ReadString(sSecao, 'chNFSe', '');
      nPedRegEvento := INIRec.ReadInteger(sSecao, 'nPedRegEvento', 0);
      tpEvento := StrTotpEvento(Ok, INIRec.ReadString(sSecao, 'tpEvento', 'e101101'));
      cMotivo := INIRec.ReadInteger(sSecao, 'cMotivo', 0);
      xMotivo := INIRec.ReadString(sSecao, 'xMotivo', '');
      chSubstituta := INIRec.ReadString(sSecao, 'chSubstituta', '');
    end;

    Result := True;
  finally
    INIRec.Free;
  end;
end;

{ TpedRegEvento }

constructor TpedRegEvento.Create;
begin
  FtpAmb := 0;
  FverAplic := '';
  FdhEvento := 0;
  FchNFSe := '';
  FnPedRegEvento := 0;
  FtpEvento := teCancelamento;
  FcMotivo := 0;
  FxMotivo := '';
  FchSubstituta := '';
end;

end.

