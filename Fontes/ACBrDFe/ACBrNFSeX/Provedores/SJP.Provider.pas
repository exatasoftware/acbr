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

unit SJP.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSJP = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSJP = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SJP.GravarXml, SJP.LerXml;

{ TACBrNFSeXWebserviceSJP }

function TACBrNFSeXWebserviceSJP.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_RecepcionarLoteRpsV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_RecepcionarLoteRpsV3>';

  Result := Executar('RecepcionarLoteRpsV3', Request,
                     ['return', 'EnviarLoteRpsResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

function TACBrNFSeXWebserviceSJP.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_ConsultarLoteRpsV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_ConsultarLoteRpsV3>';

  Result := Executar('ConsultarLoteRpsV3', Request,
                     ['return', 'ConsultarLoteRpsResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

function TACBrNFSeXWebserviceSJP.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_ConsultarSituacaoLoteRpsV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_ConsultarSituacaoLoteRpsV3>';

  Result := Executar('ConsultarSituacaoLoteRpsV3', Request,
                     ['return', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

function TACBrNFSeXWebserviceSJP.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_ConsultarNfsePorRpsV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_ConsultarNfsePorRpsV3>';

  Result := Executar('ConsultarNfsePorRpsV3', Request,
                     ['return', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

function TACBrNFSeXWebserviceSJP.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_ConsultarNfseV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_ConsultarNfseV3>';

  Result := Executar('ConsultarNfseV3', Request,
                     ['return', 'ConsultarNfseResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

function TACBrNFSeXWebserviceSJP.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:nfse_CancelarNfseV3>';
  Request := Request + '<arg0>' + XmlToStr(ACabecalho) + '</arg0>';
  Request := Request + '<arg1>' + XmlToStr(AMSG) + '</arg1>';
  Request := Request + '</nfse:nfse_CancelarNfseV3>';

  Result := Executar('CancelarNfseV3', Request,
                     ['return', 'CancelarNfseResposta'],
                     ['xmlns:nfe="http://nfe.sjp.pr.gov.br"']);
end;

{ TACBrNFSeProviderSJP }

procedure TACBrNFSeProviderSJP.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    LoteRps := True;
    ConsultarSituacao := True;
    ConsultarLote := True;
    ConsultarNFSeRps := True;
    ConsultarNFSe := True;
  end;

  with ConfigMsgDados do
  begin
    PrefixoTS := 'tipos';

    XmlRps.xmlns := 'http://nfe.sjp.pr.gov.br/tipos_v03.xsd';

    LoteRps.xmlns := 'http://nfe.sjp.pr.gov.br/servico_enviar_lote_rps_envio_v03.xsd';

    ConsultarSituacao.xmlns := 'http://nfe.sjp.pr.gov.br/servico_consultar_situacao_lote_rps_envio_v03.xsd';

    ConsultarLote.xmlns := 'http://nfe.sjp.pr.gov.br/servico_consultar_lote_rps_envio_v03.xsd';

    ConsultarNFSeRps.xmlns := 'http://nfe.sjp.pr.gov.br/servico_consultar_nfse_rps_envio_v03.xsd';

    ConsultarNFSe.xmlns := 'http://nfe.sjp.pr.gov.br/servico_consultar_nfse_envio_v03.xsd';

    CancelarNFSe.xmlns := 'http://nfe.sjp.pr.gov.br/servico_cancelar_nfse_envio_v03.xsd';

    DadosCabecalho := '<ns2:cabecalho versao="3" xmlns:ns2="http://nfe.sjp.pr.gov.br/cabecalho_v03.xsd">' +
                      '<versaoDados>3</versaoDados>' +
                      '</ns2:cabecalho>';
  end;

  with ConfigSchemas do
  begin
    Recepcionar := 'servico_enviar_lote_rps_envio_v03.xsd';
    ConsultarSituacao := 'servico_consultar_situacao_lote_rps_envio_v03.xsd';
    ConsultarLote := 'servico_consultar_lote_rps_envio_v03.xsd';
    ConsultarNFSeRps := 'servico_consultar_nfse_rps_envio_v03.xsd';
    ConsultarNFSe := 'servico_consultar_nfse_envio_v03.xsd';
    CancelarNFSe := 'servico_cancelar_nfse_envio_v03.xsd';
  end;
end;

function TACBrNFSeProviderSJP.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SJP.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSJP.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SJP.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSJP.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSJP.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end;
end;

end.
