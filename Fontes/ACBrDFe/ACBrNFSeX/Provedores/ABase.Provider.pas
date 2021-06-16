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

unit ABase.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceABase = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderABase = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException, ABase.GravarXml, ABase.LerXml;

{ TACBrNFSeXWebserviceABase }

function TACBrNFSeXWebserviceABase.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:RecepcionarLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:RecepcionarLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/RecepcionarLoteRps',
                     Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'], ['']);
end;

function TACBrNFSeXWebserviceABase.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaLoteRps' +
                ' xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';

  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaLoteRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaLoteRps',
                     Request,
                     ['ConsultaLoteRpsResult', 'ConsultarLoteRpsResposta'], ['']);
end;

function TACBrNFSeXWebserviceABase.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:ConsultaNfseRps xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:ConsultaNfseRps>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/ConsultaNfseRps',
                     Request,
                     ['ConsultaNfseRpsResult', 'ConsultarNfseRpsResposta'], ['']);
end;

function TACBrNFSeXWebserviceABase.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfs:CancelaNfse xmlns:nfs="http://nfse.abase.com.br/NFSeWS">';
  Request := Request + '<nfs:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfs:nfseCabecMsg>';
  Request := Request + '<nfs:nfseDadosMsg>' + XmlToStr(AMSG) + '</nfs:nfseDadosMsg>';
  Request := Request + '</nfs:CancelaNfse>';

  Result := Executar('http://nfse.abase.com.br/NFSeWS/CancelaNfse',
                     Request,
                     ['CancelaNfseResult', 'CancelarNfseResposta'], ['']);
end;

{ TACBrNFSeProviderABase }

procedure TACBrNFSeProviderABase.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meLoteAssincrono;
  end;

  SetXmlNameSpace('http://nfse.abase.com.br/nfse.xsd');

  with ConfigWebServices do
  begin
    VersaoDados := '2.01';
    VersaoAtrib := '2.01';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderABase.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ABase.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ABase.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderABase.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceABase.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

end.
