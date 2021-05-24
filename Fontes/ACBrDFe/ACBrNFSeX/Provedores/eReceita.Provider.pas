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

unit eReceita.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceeReceita = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProvidereReceita = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, eReceita.GravarXml, eReceita.LerXml;

{ TACBrNFSeProvidereReceita }

procedure TACBrNFSeProvidereReceita.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  ConfigGeral.UseCertificateHTTP := False;

  with ConfigWebServices do
  begin
    VersaoDados := '2.02';
    VersaoAtrib := '2.02';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProvidereReceita.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_eReceita.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvidereReceita.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_eReceita.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvidereReceita.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceeReceita.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceeReceita }

function TACBrNFSeXWebserviceeReceita.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:RecepcionarLoteRpsRequest>';

  Result := Executar('https://www.ereceita.net.br/RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:RecepcionarLoteRpsSincronoRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:RecepcionarLoteRpsSincronoRequest>';

  Result := Executar('https://www.ereceita.net.br/RecepcionarLoteRpsSincrono', Request,
                     ['outputXML', 'EnviarLoteRpsSincronoResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:GerarNfseRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:GerarNfseRequest>';

  Result := Executar('https://www.ereceita.net.br/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultarLoteRpsRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultarLoteRpsRequest>';

  Result := Executar('https://www.ereceita.net.br/ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultarNfseFaixaRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultarNfseFaixaRequest>';

  Result := Executar('https://www.ereceita.net.br/ConsultarNfseFaixa', Request,
                     ['outputXML', 'ConsultarNfseFaixaResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultarNfsePorRpsRequest>';

  Result := Executar('https://www.ereceita.net.br/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:CancelarNfseRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:CancelarNfseRequest>';

  Result := Executar('https://www.ereceita.net.br/CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

function TACBrNFSeXWebserviceeReceita.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:SubstituirNfseRequest>';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:SubstituirNfseRequest>';

  Result := Executar('https://www.ereceita.net.br/SubstituirNfse', Request,
                     ['outputXML', 'SubstituirNfseResposta'],
         ['xmlns:nfs="http://webservice.ereceita.net.br/soap/NfseWebService"']);
end;

end.
