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

unit CIGA.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceCIGA = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderCIGA = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, CIGA.GravarXml, CIGA.LerXml;

{ TACBrNFSeXWebserviceCIGA }

function TACBrNFSeXWebserviceCIGA.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:RecepcionarLoteRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCIGA.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarLoteRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCIGA.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarSituacaoLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarSituacaoLoteRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarSituacaoLoteRps', Request,
                     ['ConsultarSituacaoLoteRpsResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCIGA.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfsePorRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCIGA.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/ConsultarNfse', Request,
                     ['ConsultarNfseResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceCIGA.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg><![CDATA[' + ACabecalho + ']]></nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg><![CDATA[' + AMSG + ']]></nfseDadosMsg>';
  Request := Request + '</nfse:CancelarNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/CancelarNfse', Request,
                     ['CancelarNfseResponse', 'outputXML'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

{ TACBrNFSeProviderCIGA }

procedure TACBrNFSeProviderCIGA.Configuracao;
begin
  inherited Configuracao;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');

  ConfigWebServices.AtribVerLote := 'versao';
end;

function TACBrNFSeProviderCIGA.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_CIGA.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCIGA.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_CIGA.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCIGA.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCIGA.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

end.
