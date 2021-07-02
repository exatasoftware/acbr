{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrNFSeXParametros;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrXmlBase, ACBrNFSeXConversao;

type

  { TConfigGeral }
  TConfigGeral = class
  private
    // define como � o atributo ID: "Id" ou "id", se for fazio o atributo n�o � gerado
    FIdentificador: string;
    // define o caracter ou caracteres a serem usados como quebra de linha
    FQuebradeLinha: string;
    // define se vai usar certificado digital ou n�o
    FUseCertificateHTTP: boolean;
    // define se vai usar autoriza��o no cabe�alho ou n�o
    FUseAuthorizationHeader: boolean;
    // define o numero maximo de Rps a serem incluidos no GerarNfse
    FNumMaxRpsGerar: integer;
    // define o numero maximo de Rps a serem incluidos no EnviarLoteRpsEnvio e EnviarLoteRpsSincronoEnvio
    FNumMaxRpsEnviar: integer;
    // define o formato que o c�digo do ItemListaServico deve ser gerado
    FFormItemLServico: TFormatoItemListaServico;
    // define se vai ser utilizado uma tabela externa de servi�o ou n�o
    FTabServicosExt: Boolean;
    // define o modo de envio dos Rps para o webservice
    FModoEnvio: TmodoEnvio;
    // uso diverso
    FParams1: string;
    // uso diverso
    FParams2: string;

  public
    procedure LoadParams1(AINI: TCustomIniFile; ASession: string);
    procedure LoadParams2(AINI: TCustomIniFile; ASession: string);

    property Identificador: string read FIdentificador write FIdentificador;
    property QuebradeLinha: string read FQuebradeLinha write FQuebradeLinha;
    property UseCertificateHTTP: boolean read FUseCertificateHTTP write FUseCertificateHTTP;
    property UseAuthorizationHeader: boolean read FUseAuthorizationHeader write FUseAuthorizationHeader;
    property NumMaxRpsGerar: integer read FNumMaxRpsGerar write FNumMaxRpsGerar;
    property NumMaxRpsEnviar: integer read FNumMaxRpsEnviar write FNumMaxRpsEnviar;
    property FormatoItemListaServico: TFormatoItemListaServico read FFormItemLServico write FFormItemLServico;
    property TabServicosExt: Boolean read FTabServicosExt write FTabServicosExt;
    property ModoEnvio: TmodoEnvio read FModoEnvio write FModoEnvio;
    // Parametros lidos no arquivo .Res ou .ini
    property Params1: string read FParams1;
    property Params2: string read FParams2;

  end;

  { TWebserviceInfo }
  TWebserviceInfo = class
  private
    // URL para verifica��o no site se a note realmente existe
    FLinkURL: string;
    // NameSpace utilizado no Envelope Soap
    FNameSpace: string;
    // NameSpace utilizado no XML
    FXMLNameSpace: string;
    // URL de homologa��o ou produ��o para o servi�o Recepcionar
    FRecepcionar: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarLote
    FConsultarLote: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSeRps
    FConsultarNFSeRps: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarSituacao
    FConsultarSituacao: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSe
    FConsultarNFSe: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSeURL
    FConsultarNFSeURL: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSePorFaixa
    FConsultarNFSePorFaixa: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSeServicoPrestado
    FConsultarNFSeServicoPrestado: string;
    // URL de homologa��o ou produ��o para o servi�o ConsultarNFSeServicoTomado
    FConsultarNFSeServicoTomado: string;
    // URL de homologa��o ou produ��o para o servi�o CancelarNFSe
    FCancelarNFSe: string;
    // URL de homologa��o ou produ��o para o servi�o GerarNFSe
    FGerarNFSe: string;
    // URL de homologa��o ou produ��o para o servi�o RecepcionarSincrono
    FRecepcionarSincrono: string;
    // URL de homologa��o ou produ��o para o servi�o SubstituirNFSe
    FSubstituirNFSe: string;
    // URL de homologa��o ou produ��o para o servi�o AbrirSessao
    FAbrirSessao: string;
    // URL de homologa��o ou produ��o para o servi�o FecharSessao
    FFecharSessao: string;
    // URL de homologa��o ou produ��o para o servi�o TesteEnvio
    FTesteEnvio: string;
    // URL de homologa��o ou produ��o do SoapAction
    FSoapAction: string;

  public
    property LinkURL: string read FLinkURL;
    property NameSpace: string read FNameSpace;
    property XMLNameSpace: string read FXMLNameSpace;
    property Recepcionar: string read FRecepcionar;
    property ConsultarLote: string read FConsultarLote;
    property ConsultarNFSeRps: string read FConsultarNFSeRps;
    property ConsultarSituacao: string read FConsultarSituacao;
    property ConsultarNFSe: string read FConsultarNFSe;
    property ConsultarNFSeURL: string read FConsultarNFSeURL;
    property ConsultarNFSePorFaixa: string read FConsultarNFSePorFaixa;
    property ConsultarNFSeServicoPrestado: string read FConsultarNFSeServicoPrestado;
    property ConsultarNFSeServicoTomado: string read FConsultarNFSeServicoTomado;
    property CancelarNFSe: string read FCancelarNFSe;
    property GerarNFSe: string read FGerarNFSe;
    property RecepcionarSincrono: string read FRecepcionarSincrono;
    property SubstituirNFSe: string read FSubstituirNFSe;
    property AbrirSessao: string read FAbrirSessao;
    property FecharSessao: string read FFecharSessao;
    property TesteEnvio: string read FTesteEnvio;
    property SoapAction: string read FSoapAction;

  end;

  { TConfigWebServices }
  TConfigWebServices = class
  private
    // Vers�o dos dados informado na tag <VersaoDados>
    FVersaoDados: string;
    // Vers�o informada no atributo versao=
    FVersaoAtrib: string;
    // Grafia do atributo usado como vers�o no Lote de Rps
    FAtribVerLote: string;
    // Grupo de URLs do Ambiente de Produ��o
    FProducao: TWebserviceInfo;
    // Grupo de URLs do Ambiente de Homologa��o
    FHomologacao: TWebserviceInfo;

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadUrl(AINI: TCustomIniFile; ASession: string);

    property VersaoDados: string read FVersaoDados write FVersaoDados;
    property VersaoAtrib: string read FVersaoAtrib write FVersaoAtrib;
    property AtribVerLote: string read FAtribVerLote write FAtribVerLote;
    property Producao: TWebserviceInfo read FProducao;
    property Homologacao: TWebserviceInfo read FHomologacao;

  end;

  { TDocElement }
  TDocElement = class
  private
    // contem o namespace a ser incluido no XML
    Fxmlns: string;
    // nome do elemento a ser utilizado na assinatura digital que contem o atributo ID
    FInfElemento: string;
    // nome do elemento do documento a ser assinado
    FDocElemento: string;

  public
    property xmlns: string read Fxmlns write Fxmlns;
    property InfElemento: string read FInfElemento write FInfElemento;
    property DocElemento: string read FDocElemento write FDocElemento;
  end;

  { TConfigMsgDados }
  TConfigMsgDados = class
  private
    // Alguns provedores como o Ginfes existem a presen�a de prefixo nas tags
    FPrefixo: String;
    // Prefixo para Tipo Simples usado na montagem do XML de envio
    FPrefixoTS: String;
    // Contem o XML do cabe�alho exigido por alguns provedores
    FDadosCabecalho: String;

    // Contem a defini��o dos campos TDocElement para o XML do Rps
    FXmlRps: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Lote Rps
    FLoteRps: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Lote Rps Sincrono
    FLoteRpsSincrono: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a Situa��o
    FConsultarSituacao: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta ao Lote
    FConsultarLote: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFSe por Rps
    FConsultarNFSeRps: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFS-e
    FConsultarNFSe: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFS-e por Faixa
    FConsultarNFSePorFaixa: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFS-e Servi�o Prestado
    FConsultarNFSeServicoPrestado: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFS-e Servi�o Tomado
    FConsultarNFSeServicoTomado: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Consulta a NFS-e URL
    FConsultarNFSeURL: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Cancelamento da NFS-e
    FCancelarNFSe: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Gerar NFS-e
    FGerarNFSe: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML da Substitui��o da NFS-e
    FSubstituirNFSe: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Abrir Sess�o
    FAbrirSessao: TDocElement;
    // Contem a defini��o dos campos TDocElement para o XML do Fechar Sess�o
    FFecharSessao: TDocElement;

    // Se True gera o namespace no Lote de Rps
    FGerarNSLoteRps: Boolean;
    // Se True gera o Prestador no Lote de Rps
    FGerarPrestadorLoteRps: Boolean;

  public
    constructor Create;
    destructor Destroy; override;

    property Prefixo: String read FPrefixo write FPrefixo;
    property PrefixoTS: String read FPrefixoTS write FPrefixoTS;
    property DadosCabecalho: String read FDadosCabecalho write FDadosCabecalho;

    property XmlRps: TDocElement read FXmlRps;
    property LoteRps: TDocElement read FLoteRps;
    property LoteRpsSincrono: TDocElement read FLoteRpsSincrono;
    property ConsultarSituacao: TDocElement read FConsultarSituacao;
    property ConsultarLote: TDocElement read FConsultarLote;
    property ConsultarNFSeRps: TDocElement read FConsultarNFSeRps;
    property ConsultarNFSe: TDocElement read FConsultarNFSe;
    property ConsultarNFSePorFaixa: TDocElement read FConsultarNFSePorFaixa;
    property ConsultarNFSeServicoPrestado: TDocElement read FConsultarNFSeServicoPrestado;
    property ConsultarNFSeServicoTomado: TDocElement read FConsultarNFSeServicoTomado;
    property ConsultarNFSeURL: TDocElement read FConsultarNFSeURL;
    property CancelarNFSe: TDocElement read FCancelarNFSe;
    property GerarNFSe: TDocElement read FGerarNFSe;
    property SubstituirNFSe: TDocElement read FSubstituirNFSe;
    property AbrirSessao: TDocElement read FAbrirSessao;
    property FecharSessao: TDocElement read FFecharSessao;

    property GerarNSLoteRps: Boolean read FGerarNSLoteRps write FGerarNSLoteRps;
    property GerarPrestadorLoteRps: Boolean read FGerarPrestadorLoteRps write FGerarPrestadorLoteRps;
  end;

  { TConfigAssinar }
  TConfigAssinar = class
  private
    // Se True assina o Rps
    FRps: boolean;
    // Se True assina o Lote de Rps
    FLoteRps: boolean;
    // Se True assina a Consulta a Situa��o
    FConsultarSituacao: boolean;
    // Se True assina a Consulta ao Lote
    FConsultarLote: boolean;
    // Se True assina a Consulta a NFS-e por Rps
    FConsultarNFSeRps: boolean;
    // Se True assina a Consulta a NFS-e
    FConsultarNFSe: boolean;
    // Se True assina a Consulta a NFS-e por Faixa
    FConsultarNFSePorFaixa: boolean;
    // Se True assina a Consulta a NFS-e Servi�o Prestado
    FConsultarNFSeServicoPrestado: boolean;
    // Se True assina a Consulta a NFS-e Servi�o Tomado
    FConsultarNFSeServicoTomado: boolean;
    // Se True assina o Cancelamento da NFS-e
    FCancelarNFSe: boolean;
    // Se True assina o Rps do Gerar NFS-e
    FRpsGerarNFSe: boolean;
    // Se True assina o Lote do Gerar NFS-e
    FLoteGerarNFSe: boolean;
    // Se True assina o Rps do Substituir NFS-e
    FRpsSubstituirNFSe: boolean;
    // Se True assina o Substituir NFS-e
    FSubstituirNFSe: boolean;
    // Se True assina o Abrir Sess�o
    FAbrirSessao: boolean;
    // Se True assina o Fechar Sess�o
    FFecharSessao: boolean;
    // Se True Incluir o valor de ID na URI da assinatura
    FIncluirURI: boolean;
    // Se True gera uma assinatura adicional
    FAssinaturaAdicional: boolean;

  public
    property Rps: boolean read FRps write FRps;
    property LoteRps: boolean read FLoteRps write FLoteRps;
    property ConsultarSituacao: boolean read FConsultarSituacao write FConsultarSituacao;
    property ConsultarLote: boolean read FConsultarLote write FConsultarLote;
    property ConsultarNFSeRps: boolean read FConsultarNFSeRps write FConsultarNFSeRps;
    property ConsultarNFSe: boolean read FConsultarNFSe write FConsultarNFSe;
    property ConsultarNFSePorFaixa: boolean read FConsultarNFSePorFaixa write FConsultarNFSePorFaixa;
    property ConsultarNFSeServicoPrestado: boolean read FConsultarNFSeServicoPrestado write FConsultarNFSeServicoPrestado;
    property ConsultarNFSeServicoTomado: boolean read FConsultarNFSeServicoTomado write FConsultarNFSeServicoTomado;
    property CancelarNFSe: boolean read FCancelarNFSe write FCancelarNFSe;
    property RpsGerarNFSe: boolean read FRpsGerarNFSe write FRpsGerarNFSe;
    property LoteGerarNFSe: boolean read FLoteGerarNFSe write FLoteGerarNFSe;
    property RpsSubstituirNFSe: boolean read FRpsSubstituirNFSe write FRpsSubstituirNFSe;
    property SubstituirNFSe: boolean read FSubstituirNFSe write FSubstituirNFSe;
    property AbrirSessao: boolean read FAbrirSessao write FAbrirSessao;
    property FecharSessao: boolean read FFecharSessao write FFecharSessao;
    property IncluirURI: boolean read FIncluirURI write FIncluirURI;
    property AssinaturaAdicional: boolean read FAssinaturaAdicional write FAssinaturaAdicional;

  end;

  { TConfigSchemas }
  TConfigSchemas = class
  private
    // Nome do arquivo XSD para validar o Recepcionar (Envio do Lote de Rps)
    FRecepcionar: string;
    // Nome do arquivo XSD para validar o Consultar Situa��o
    FConsultarSituacao: string;
    // Nome do arquivo XSD para validar o Consultar Lote
    FConsultarLote: string;
    // Nome do arquivo XSD para validar o Consultar NFSe por Rps
    FConsultarNFSeRps: string;
    // Nome do arquivo XSD para validar o Consultar NFSe
    FConsultarNFSe: string;
    // Nome do arquivo XSD para validar o Consultar NFSe URL
    FConsultarNFSeURL: string;
    // Nome do arquivo XSD para validar o Consultar NFSe por Faixa
    FConsultarNFSePorFaixa: string;
    // Nome do arquivo XSD para validar o Consultar NFSe Servi�o Prestado
    FConsultarNFSeServicoPrestado: string;
    // Nome do arquivo XSD para validar o Consultar NFSe Servi�o Tomado
    FConsultarNFSeServicoTomado: string;
    // Nome do arquivo XSD para validar o Cancelar NFSe
    FCancelarNFSe: string;
    // Nome do arquivo XSD para validar o Gerar NFSe
    FGerarNFSe: string;
    // Nome do arquivo XSD para validar o Recepcionar Sincrono (Envio do Lote de Rps)
    FRecepcionarSincrono: string;
    // Nome do arquivo XSD para validar o Substituir NFSe
    FSubstituirNFSe: string;
    // Nome do arquivo XSD para validar o Abrir Sess�o
    FAbrirSessao: string;
    // Nome do arquivo XSD para validar o Fechar Sess�o
    FFecharSessao: string;
    // Nome do arquivo XSD para validar o Teste de Envio
    FTeste: string;
    // Se True realiza a valida��o do XML com os Schemas
    FValidar: boolean;

  public
    property Recepcionar: string read FRecepcionar write FRecepcionar;
    property ConsultarSituacao: string read FConsultarSituacao write FConsultarSituacao;
    property ConsultarLote: string read FConsultarLote write FConsultarLote;
    property ConsultarNFSeRps: string read FConsultarNFSeRps write FConsultarNFSeRps;
    property ConsultarNFSe: string read FConsultarNFSe write FConsultarNFSe;
    property ConsultarNFSeURL: string read FConsultarNFSeURL write FConsultarNFSeURL;
    property ConsultarNFSePorFaixa: string read FConsultarNFSePorFaixa write FConsultarNFSePorFaixa;
    property ConsultarNFSeServicoPrestado: string read FConsultarNFSeServicoPrestado write FConsultarNFSeServicoPrestado;
    property ConsultarNFSeServicoTomado: string read FConsultarNFSeServicoTomado write FConsultarNFSeServicoTomado;
    property CancelarNFSe: string read FCancelarNFSe write FCancelarNFSe;
    property GerarNFSe: string read FGerarNFSe write FGerarNFSe;
    property RecepcionarSincrono: string read FRecepcionarSincrono write FRecepcionarSincrono;
    property SubstituirNFSe: string read FSubstituirNFSe write FSubstituirNFSe;
    property AbrirSessao: string read FAbrirSessao write FAbrirSessao;
    property FecharSessao: string read FFecharSessao write FFecharSessao;
    property Teste: string read FTeste write FTeste;
    property Validar: boolean read FValidar write FValidar;

  end;

implementation

{ TConfigWebServices }

constructor TConfigWebServices.Create;
begin
  FProducao := TWebserviceInfo.Create;
  FHomologacao := TWebserviceInfo.Create;
end;

destructor TConfigWebServices.Destroy;
begin
  FProducao.Free;
  FHomologacao.Free;

  inherited Destroy;
end;

procedure TConfigWebServices.LoadUrl(AINI: TCustomIniFile; ASession: string);
begin
  with Producao do
  begin
    FRecepcionar         := AINI.ReadString(ASession, 'ProRecepcionar'        , '');
    FConsultarSituacao   := AINI.ReadString(ASession, 'ProConsultarSituacao'  , FRecepcionar);
    FConsultarLote       := AINI.ReadString(ASession, 'ProConsultarLote'      , FRecepcionar);
    FConsultarNFSeRPS    := AINI.ReadString(ASession, 'ProConsultarNFSeRps'   , FRecepcionar);
    FConsultarNFSe       := AINI.ReadString(ASession, 'ProConsultarNFSe'      , FRecepcionar);
    FConsultarNFSeURL    := AINI.ReadString(ASession, 'ProConsultarNFSeURL'   , FRecepcionar);
    FCancelarNFSe        := AINI.ReadString(ASession, 'ProCancelarNFSe'       , FRecepcionar);
    FGerarNFSe           := AINI.ReadString(ASession, 'ProGerarNFSe'          , FRecepcionar);
    FRecepcionarSincrono := AINI.ReadString(ASession, 'ProRecepcionarSincrono', FRecepcionar);
    FSubstituirNFSe      := AINI.ReadString(ASession, 'ProSubstituirNFSe'     , FRecepcionar);
    FAbrirSessao         := AINI.ReadString(ASession, 'ProAbrirSessao'        , FRecepcionar);
    FFecharSessao        := AINI.ReadString(ASession, 'ProFecharSessao'       , FRecepcionar);

    FConsultarNFSePorFaixa        := AINI.ReadString(ASession, 'ProConsultarNFSePorFaixa'       , FRecepcionar);
    FConsultarNFSeServicoPrestado := AINI.ReadString(ASession, 'ProConsultarNFSeServicoPrestado', FRecepcionar);
    FConsultarNFSeServicoTomado   := AINI.ReadString(ASession, 'ProConsultarNFSeServicoTomado'  , FRecepcionar);

    FXMLNameSpace := AINI.ReadString(ASession, 'ProXMLNameSpace', '');

    FNameSpace := AINI.ReadString(ASession, 'ProNameSpace', '');

    FSoapAction := AINI.ReadString(ASession, 'ProSoapAction', '');

    FLinkURL := AINI.ReadString(ASession, 'ProLinkURL', '');
  end;

  with Homologacao do
  begin
    FRecepcionar         := AINI.ReadString(ASession, 'HomRecepcionar'        , '');
    FConsultarSituacao   := AINI.ReadString(ASession, 'HomConsultarSituacao'  , FRecepcionar);
    FConsultarLote       := AINI.ReadString(ASession, 'HomConsultarLote'      , FRecepcionar);
    FConsultarNFSeRPS    := AINI.ReadString(ASession, 'HomConsultarNFSeRps'   , FRecepcionar);
    FConsultarNFSe       := AINI.ReadString(ASession, 'HomConsultarNFSe'      , FRecepcionar);
    FConsultarNFSeURL    := AINI.ReadString(ASession, 'HomConsultarNFSeURL'   , FRecepcionar);
    FCancelarNFSe        := AINI.ReadString(ASession, 'HomCancelarNFSe'       , FRecepcionar);
    FGerarNFSe           := AINI.ReadString(ASession, 'HomGerarNFSe'          , FRecepcionar);
    FRecepcionarSincrono := AINI.ReadString(ASession, 'HomRecepcionarSincrono', FRecepcionar);
    FSubstituirNFSe      := AINI.ReadString(ASession, 'HomSubstituirNFSe'     , FRecepcionar);
    FAbrirSessao         := AINI.ReadString(ASession, 'HomAbrirSessao'        , FRecepcionar);
    FFecharSessao        := AINI.ReadString(ASession, 'HomFecharSessao'       , FRecepcionar);

    FConsultarNFSePorFaixa        := AINI.ReadString(ASession, 'HomConsultarNFSePorFaixa'       , FRecepcionar);
    FConsultarNFSeServicoPrestado := AINI.ReadString(ASession, 'HomConsultarNFSeServicoPrestado', FRecepcionar);
    FConsultarNFSeServicoTomado   := AINI.ReadString(ASession, 'HomConsultarNFSeServicoTomado'  , FRecepcionar);

    FXMLNameSpace := AINI.ReadString(ASession, 'HomXMLNameSpace', '');

    FNameSpace := AINI.ReadString(ASession, 'HomNameSpace', '');

    FSoapAction := AINI.ReadString(ASession, 'HomSoapAction', '');

    FLinkURL := AINI.ReadString(ASession, 'HomLinkURL', '');

    if FRecepcionar = '' then
    begin
      FRecepcionar         := Producao.Recepcionar;
      FConsultarSituacao   := Producao.ConsultarSituacao;
      FConsultarLote       := Producao.ConsultarLote;
      FConsultarNFSeRps    := Producao.ConsultarNFSeRps;
      FConsultarNFSe       := Producao.ConsultarNFSe;
      FConsultarNFSeURL    := Producao.ConsultarNFSeURL;
      FCancelarNFSe        := Producao.CancelarNFSe;
      FGerarNFSe           := Producao.GerarNFSe;
      FRecepcionarSincrono := Producao.RecepcionarSincrono;
      FSubstituirNFSe      := Producao.SubstituirNFSe;
      FAbrirSessao         := Producao.AbrirSessao;
      FFecharSessao        := Producao.FecharSessao;

      FConsultarNFSePorFaixa        := Producao.ConsultarNFSePorFaixa;
      FConsultarNFSeServicoPrestado := Producao.ConsultarNFSeServicoPrestado;
      FConsultarNFSeServicoTomado   := Producao.ConsultarNFSeServicoTomado;
    end;

    if FXMLNameSpace = '' then
      FXMLNameSpace := Producao.XMLNameSpace;

    if FNameSpace = '' then
      FNameSpace := Producao.NameSpace;

    if FSoapAction = '' then
      FSoapAction := Producao.SoapAction;

    if FLinkURL = '' then
      FLinkURL := Producao.LinkURL;
  end;
end;

{ TConfigMsgDados }

constructor TConfigMsgDados.Create;
begin
  FXmlRps := TDocElement.Create;
  FLoteRps := TDocElement.Create;
  FLoteRpsSincrono := TDocElement.Create;
  FConsultarSituacao := TDocElement.Create;
  FConsultarLote := TDocElement.Create;
  FConsultarNFSeRps := TDocElement.Create;
  FConsultarNFSe := TDocElement.Create;
  FConsultarNFSePorFaixa := TDocElement.Create;
  FConsultarNFSeServicoPrestado := TDocElement.Create;
  FConsultarNFSeServicoTomado := TDocElement.Create;
  FConsultarNFSeURL := TDocElement.Create;
  FCancelarNFSe := TDocElement.Create;
  FGerarNFSe := TDocElement.Create;
  FSubstituirNFSe := TDocElement.Create;
  FAbrirSessao := TDocElement.Create;
  FFecharSessao := TDocElement.Create;
end;

destructor TConfigMsgDados.Destroy;
begin
  FXmlRps.Free;
  FLoteRps.Free;
  FLoteRpsSincrono.Free;
  FConsultarSituacao.Free;
  FConsultarLote.Free;
  FConsultarNFSeRps.Free;
  FConsultarNFSe.Free;
  FConsultarNFSePorFaixa.Free;
  FConsultarNFSeServicoPrestado.Free;
  FConsultarNFSeServicoTomado.Free;
  FConsultarNFSeURL.Free;
  FCancelarNFSe.Free;
  FGerarNFSe.Free;
  FSubstituirNFSe.Free;
  FAbrirSessao.Free;
  FFecharSessao.Free;

  inherited Destroy;
end;

{ TConfigGeral }

procedure TConfigGeral.LoadParams1(AINI: TCustomIniFile; ASession: string);
begin
  FParams1 := AINI.ReadString(ASession, 'Params1', '');
end;

procedure TConfigGeral.LoadParams2(AINI: TCustomIniFile; ASession: string);
begin
  FParams2 := AINI.ReadString(ASession, 'Params2', '');
end;

end.
