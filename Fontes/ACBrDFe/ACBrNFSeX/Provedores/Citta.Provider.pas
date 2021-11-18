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

unit Citta.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeX, ACBrNFSeXClass, ACBrNFSeXConversao, ACBrNFSeXConfiguracoes,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceCitta203 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderCitta203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  ACBrDFeException,
  Citta.GravarXml, Citta.LerXml;

{ TACBrNFSeProviderCitta203 }

procedure TACBrNFSeProviderCitta203.Configuracao;
begin
  inherited Configuracao;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
    AtribVerLote := 'versao';
  end;
end;

function TACBrNFSeProviderCitta203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Citta203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCitta203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Citta203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCitta203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCitta203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderCitta203.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  Xml: string;
begin
  inherited ValidarSchema(Response, aMetodo);

  Xml := Response.XmlEnvio;

  Xml := StringReplace(Xml,
              ' xmlns="http://www.abrasf.org.br/nfse.xsd"', '', [rfReplaceAll]);

  case aMetodo of
    tmRecepcionar:
      begin
        Xml := StringReplace(Xml,
              'EnviarLoteRpsEnvio', 'nfse:RecepcionarLoteRpsEnvio', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            '<Rps><InfDecla', '<rps><InfDecla', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            'Servico></Rps>', 'Servico></rps>', [rfReplaceAll]);
      end;

    tmRecepcionarSincrono:
      begin
        Xml := StringReplace(Xml,
              'EnviarLoteRpsSincronoEnvio', 'nfse:RecepcionarLoteRpsSincronoEnvio', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            '<Rps><InfDecla', '<rps><InfDecla', [rfReplaceAll]);
        Xml := StringReplace(Xml,
                            'Servico></Rps>', 'Servico></rps>', [rfReplaceAll]);
      end;

    tmGerar:
      begin
        Xml := StringReplace(Xml,
              'GerarNfseEnvio', 'nfse:GerarNfseEnvio', [rfReplaceAll]);
      end;

    tmConsultarLote:
      begin
        Xml := StringReplace(Xml,
              'ConsultarLoteRpsEnvio', 'nfse:ConsultarLoteRpsEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSePorRps:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseRpsEnvio', 'nfse:ConsultarNfseRpsEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSePorFaixa:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseFaixaEnvio', 'nfse:ConsultarNfsePorFaixaEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSeServicoPrestado:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseServicoPrestadoEnvio', 'nfse:ConsultarNfseServicoPrestadoEnvio', [rfReplaceAll]);
      end;

    tmConsultarNFSeServicoTomado:
      begin
        Xml := StringReplace(Xml,
              'ConsultarNfseServicoTomadoEnvio', 'nfse:ConsultarNfseServicoTomadoEnvio', [rfReplaceAll]);
      end;

    tmCancelarNFSe:
      begin
        Xml := StringReplace(Xml,
              'CancelarNfseEnvio', 'nfse:CancelarNfseEnvio', [rfReplaceAll]);
      end;

    tmSubstituirNFSe:
      begin
        Xml := StringReplace(Xml,
              'SubstituirNfseEnvio', 'nfse:SubstituirNfseEnvio', [rfReplaceAll]);
      end;
  else
    Response.XmlEnvio := Xml;
  end;

  Response.XmlEnvio := Xml;
end;

{ TACBrNFSeXWebserviceCitta203 }

function TACBrNFSeXWebserviceCitta203.Recepcionar(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/RecepcionarLoteRps', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/RecepcionarLoteRpsSincrono', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.GerarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/GerarNfse', AMSG,
                     [''],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarLote(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarLoteRps', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorFaixa', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorRps', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoPrestado', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfseServicoTomado', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.Cancelar(ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/CancelarNfse', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCitta203.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('http://nfse.abrasf.org.br/SubstituirNfse', AMSG,
                     [''], ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

end.
