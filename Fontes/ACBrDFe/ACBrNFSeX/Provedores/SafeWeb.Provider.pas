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

unit SafeWeb.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSafeWeb = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSafeWeb = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SafeWeb.GravarXml, SafeWeb.LerXml;

{ TACBrNFSeProviderSafeWeb }

procedure TACBrNFSeProviderSafeWeb.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ModoEnvio := meLoteAssincrono;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsSubstituirNFSe := True;
  end;

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<CabecalhoEnvio versao="2" xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                        '<versaoDados>2</versaoDados>' +
                        // verificar se o valor 1 � produ��o
                        // '<TpAmb>' + '1' + '</TpAmb>' +
                        '<Cnpj>' +
                           TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.WSUser +
                        '</Cnpj>' +
                        '<CodigoIbge>' +
                           IntToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio) +
                        '</CodigoIbge>' +
                      '</CabecalhoEnvio>';
  end;
end;

function TACBrNFSeProviderSafeWeb.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SafeWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSafeWeb.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SafeWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSafeWeb.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSafeWeb.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceSafeWeb }

function TACBrNFSeXWebserviceSafeWeb.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<enviarLoteRpsEnvio>' + XmlToStr(AMSG) + '</enviarLoteRpsEnvio>';
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceSafeWeb.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<consultarLoteRpsEnvio>' + XmlToStr(AMSG) + '</consultarLoteRpsEnvio>';
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceSafeWeb.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseFaixa xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<consultarNfseFaixaEnvio>' + XmlToStr(AMSG) + '</consultarNfseFaixaEnvio>';
  Request := Request + '</ConsultarNfseFaixa>';

  Result := Executar('http://tempuri.org/ConsultarNfseFaixa', Request,
                     ['ConsultarNfseFaixaResult'], ['']);
end;

function TACBrNFSeXWebserviceSafeWeb.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRps xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<consultarNfseRpsEnvio>' + XmlToStr(AMSG) + '</consultarNfseRpsEnvio>';
  Request := Request + '</ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceSafeWeb.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<cancelarNfseEnvio>' + XmlToStr(AMSG) + '</cancelarNfseEnvio>';
  Request := Request + '</CancelarNfse>';

  Result := Executar('http://tempuri.org/CancelarNfse', Request,
                     ['CancelarNfseResult'], ['']);
end;

function TACBrNFSeXWebserviceSafeWeb.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<SubstituirNfse xmlns="http://tempuri.org/">';
  Request := Request + '<cabecalho>' + XmlToStr(ACabecalho) + '</cabecalho>';
  Request := Request + '<substituirNfseEnvio>' + XmlToStr(AMSG) + '</substituirNfseEnvio>';
  Request := Request + '</SubstituirNfse>';

  Result := Executar('http://tempuri.org/SubstituirNfse', Request,
                     ['SubstituirNfseResult'], ['']);
end;

end.
