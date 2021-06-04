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

unit ModeloV1.Provider;
{
  Trocar todas as ocorrencias de "ModeloV1" pelo nome do provedor
}

interface

uses
  SysUtils, Classes,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceModeloV1 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderModeloV1 = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException,
  ModeloV1.GravarXml, ModeloV1.LerXml;

{ TACBrNFSeProviderModeloV1 }

procedure TACBrNFSeProviderModeloV1.Configuracao;
begin
  inherited Configuracao;
  {
     Todos os par�metros de configura��o est�o com os seus valores padr�es.

     Se a configura��o padr�o atende o provedor ela pode ser excluida dessa
     procedure.

     Portanto deixe somente os par�metros de configura��o que foram alterados
     para atender o provedor.
  }

  // Inicializa os par�metros de configura��o: Geral
  with ConfigGeral do
  begin
    UseCertificateHTTP := True;
    UseAuthorizationHeader := False;
    NumMaxRpsGerar  := 1;
    NumMaxRpsEnviar := 50;

    // filsComFormatacao, filsSemFormatacao, filsComFormatacaoSemZeroEsquerda
    FormatoItemListaServico := filsComFormatacao;

    TabServicosExt := False;
    Identificador := 'Id';

    // meLoteAssincrono, meLoteSincrono ou meUnitario
    ModoEnvio := meLoteAssincrono;
  end;

  // Inicializa os par�metros de configura��o: WebServices
  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.00';
    AtribVerLote := '';
  end;

  // Define o NameSpace utilizado por todos os servi�os disponibilizados pelo
  // provedor
  SetXmlNameSpace('http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd');

  // Inicializa os par�metros de configura��o: Mensagem de Dados
  with ConfigMsgDados do
  begin
    // Usado na tag raiz dos XML de envio do Lote, Consultas, etc.
    Prefixo := '';

//    DadosCabecalho := GetCabecalho('');

    DadosCabecalho := '<cabecalho versao="1.00" xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">' +
                      '<versaoDados>1.00</versaoDados>' +
                      '</cabecalho>';

    // Usado para gera��o do Xml do Rps
    with XmlRps do
    begin
      // Define o NameSpace do XML do Rps, sobrep�e a defini��o global: SetXmlNameSpace
      xmlns := '';
      InfElemento := 'InfRps';
      DocElemento := 'Rps';
    end;

    // Usado para gera��o do Envio do Lote em modo ass�ncrono
    with LoteRps do
    begin
      xmlns := '';
      InfElemento := 'LoteRps';
      DocElemento := 'EnviarLoteRpsEnvio';
    end;

    // Usado para gera��o do Envio do Lote em modo Sincrono
    with LoteRpsSincrono do
    begin
      xmlns := '';
      InfElemento := 'LoteRps';
      DocElemento := 'EnviarLoteRpsSincronoEnvio';
    end;

    // Usado para gera��o da Consulta a Situa��o do Lote
    with ConsultarSituacao do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := 'ConsultarSituacaoLoteRpsEnvio';
    end;

    // Usado para gera��o da Consulta do Lote
    with ConsultarLote do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := 'ConsultarLoteRpsEnvio';
    end;

    // Usado para gera��o da Consulta da NFSe por RPS
    with ConsultarNFSeRps do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := 'ConsultarNfseRpsEnvio';
    end;

    // Usado para gera��o da Consulta da NFSe
    with ConsultarNFSe do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := 'ConsultarNfseEnvio';
    end;

    // Usado para gera��o do Cancelamento
    with CancelarNFSe do
    begin
      xmlns := '';
      InfElemento := 'InfPedidoCancelamento';
      DocElemento := 'Pedido';
    end;

    // Usado para gera��o do Gerar
    with GerarNFSe do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := 'GerarNfseEnvio';
    end;

    // Usado para gera��o do Substituir
    with SubstituirNFSe do
    begin
      xmlns := '';
      InfElemento := 'SubstituicaoNfse';
      DocElemento := 'SubstituirNfseEnvio';
    end;

    // Usado para gera��o da Abertura de Sess�o
    with AbrirSessao do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := '';
    end;

    // Usado para gera��o do Fechamento de Sess�o
    with FecharSessao do
    begin
      xmlns := '';
      InfElemento := '';
      DocElemento := '';
    end;
  end;

  // Inicializa os par�metros de configura��o: Assinar
  with ConfigAssinar do
  begin
    Rps               := False;
    LoteRps           := False;
    ConsultarSituacao := False;
    ConsultarLote     := False;
    ConsultarNFSeRps  := False;
    ConsultarNFSe     := False;
    CancelarNFSe      := False;
    RpsGerarNFSe      := False;
    LoteGerarNFSe     := False;
    RpsSubstituirNFSe := False;
    SubstituirNFSe    := False;
    AbrirSessao       := False;
    FecharSessao      := False;

    IncluirURI := True;

    AssinaturaAdicional := False;
  end;

  // Define o nome do arquivo XSD utilizado para todos os servi�os disponibilizados
  // pelo provedor
  SetNomeXSD('nfse.xsd');

  // Define o nome do arquivo XSD para cada servi�os disponibilizado pelo
  // provedor
  with ConfigSchemas do
  begin
    Recepcionar := 'nfse.xsd';
    ConsultarSituacao := 'nfse.xsd';
    ConsultarLote := 'nfse.xsd';
    ConsultarNFSeRps := 'nfse.xsd';
    ConsultarNFSe := 'nfse.xsd';
    ConsultarNFSeURL := 'nfse.xsd';
    ConsultarNFSePorFaixa := 'nfse.xsd';
    ConsultarNFSeServicoPrestado := 'nfse.xsd';
    ConsultarNFSeServicoTomado := 'nfse.xsd';
    CancelarNFSe := 'nfse.xsd';
    GerarNFSe := 'nfse.xsd';
    RecepcionarSincrono := 'nfse.xsd';
    SubstituirNFSe := 'nfse.xsd';
    AbrirSessao := 'nfse.xsd';
    FecharSessao := 'nfse.xsd';
    Teste := 'nfse.xsd';
    Validar := True;
  end;
end;

function TACBrNFSeProviderModeloV1.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ModeloV1.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderModeloV1.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ModeloV1.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderModeloV1.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        // M�todos padr�es da vers�o 1 do layout da ABRASF
        tmRecepcionar: URL := Recepcionar;
        tmConsultarLote: URL := ConsultarLote;
        tmConsultarSituacao: URL := ConsultarSituacao;
        tmConsultarNFSePorRps: URL := ConsultarNFSeRps;
        tmConsultarNFSe: URL := ConsultarNFSe;
        tmCancelarNFSe: URL := CancelarNFSe;

        // M�todos que por padr�o n�o existem na vers�o 1 do layout da ABRASF
        {
        tmRecepcionarSincrono: URL := RecepcionarSincrono;
        tmGerar: URL := GerarNFSe;
        tmSubstituirNFSe: URL := SubstituirNFSe;
        tmConsultarNFSeURL: URL := ConsultarNFSeURL;
        tmConsultarNFSePorFaixa: URL := ConsultarNFSePorFaixa;
        tmConsultarNFSeServicoPrestado: URL := ConsultarNFSeServicoPrestado;
        tmConsultarNFSeServicoTomado: URL := ConsultarNFSeServicoTomado;
        tmAbrirSessao: URL := AbrirSessao;
        tmFecharSessao: URL := FecharSessao;
        tmTeste: URL := TesteEnvio;
        }
      else
        URL := '';
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        // M�todos padr�es da vers�o 1 do layout da ABRASF
        tmRecepcionar: URL := Recepcionar;
        tmConsultarLote: URL := ConsultarLote;
        tmConsultarSituacao: URL := ConsultarSituacao;
        tmConsultarNFSePorRps: URL := ConsultarNFSeRps;
        tmConsultarNFSe: URL := ConsultarNFSe;
        tmCancelarNFSe: URL := CancelarNFSe;

        // M�todos que por padr�o n�o existem na vers�o 1 do layout da ABRASF
        {
        tmRecepcionarSincrono: URL := RecepcionarSincrono;
        tmGerar: URL := GerarNFSe;
        tmSubstituirNFSe: URL := SubstituirNFSe;
        tmConsultarNFSeURL: URL := ConsultarNFSeURL;
        tmConsultarNFSePorFaixa: URL := ConsultarNFSePorFaixa;
        tmConsultarNFSeServicoPrestado: URL := ConsultarNFSeServicoPrestado;
        tmConsultarNFSeServicoTomado: URL := ConsultarNFSeServicoTomado;
        tmAbrirSessao: URL := AbrirSessao;
        tmFecharSessao: URL := FecharSessao;
        tmTeste: URL := TesteEnvio;
        }
      else
        URL := '';
      end;
    end;
  end;

  if URL <> '' then
    Result := TACBrNFSeXWebserviceModeloV1.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceModeloV1 }

function TACBrNFSeXWebserviceModeloV1.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:RecepcionarLoteRpsRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceModeloV1.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:ConsultarLoteRpsRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceModeloV1.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarSituacaoLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:ConsultarSituacaoLoteRpsRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarSituacaoLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceModeloV1.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:ConsultarNfsePorRpsRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceModeloV1.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:ConsultarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:ConsultarNfseRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'ConsultarNfseResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceModeloV1.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<wsn:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</wsn:CancelarNfseRequest>';

  Result := Executar('', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['']);
end;

end.
