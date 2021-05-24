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

unit Siam.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSiam = class(TACBrNFSeXWebserviceSoap11)
  public
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSiam = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Siam.GravarXml, Siam.LerXml;

{ TACBrNFSeProviderSiam }

procedure TACBrNFSeProviderSiam.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.UseCertificateHTTP := False;

  SetXmlNameSpace('https://ws.imap.org.br/siam/nfse.xsd');
end;

function TACBrNFSeProviderSiam.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Siam.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiam.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Siam.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiam.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSiam.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceSiam }

function TACBrNFSeXWebserviceSiam.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:EnviarLoteRpsSincronoEnvio>';
  Request := Request + '<tem:param>' + XmlToStr(AMSG) + '</tem:param>';
  Request := Request + '</tem:EnviarLoteRpsSincronoEnvio>';

  Result := Executar('http://tempuri.org/INfse/EnviarLoteRpsSincronoEnvio', Request,
                     ['return', 'outputXML', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSiam.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRpsEnvio>';
  Request := Request + '<tem:param>' + XmlToStr(AMSG) + '</tem:param>';
  Request := Request + '</tem:ConsultarLoteRpsEnvio>';

  Result := Executar('http://tempuri.org/INfse/ConsultarLoteRpsEnvio', Request,
                     ['return', 'outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSiam.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelarNfseEnvio>';
  Request := Request + '<tem:param>' + XmlToStr(AMSG) + '</tem:param>';
  Request := Request + '</tem:CancelarNfseEnvio>';

  Result := Executar('http://tempuri.org/INfse/CancelarNfseEnvio', Request,
                     ['return', 'outputXML', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

end.
