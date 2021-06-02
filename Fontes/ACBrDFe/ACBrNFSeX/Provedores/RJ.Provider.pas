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

unit RJ.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml, ACBrNFSeXWebservicesResponse,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceRJ = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderRJ = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, RJ.GravarXml, RJ.LerXml;

{ TACBrNFSeXWebserviceRJ }

function TACBrNFSeXWebserviceRJ.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRpsRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</RecepcionarLoteRpsRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.GerarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
  xXml, NS1, NS2: string;
begin
  FPMsgOrig := AMSG;

  NS1 := 'xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd"';
  NS2 := 'xmlns:ns2="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd" ' +
         'xmlns="http://notacarioca.rio.gov.br/WSNacional/XSD/1/nfse_pcrj_v01.xsd"';

  xXml := StringReplace(AMSG, NS1, NS2, [rfReplaceAll]);

  Request := '<GerarNfseRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(xXml) + '</inputXML>';
  Request := Request + '</GerarNfseRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRpsRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ConsultarLoteRpsRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarSituacaoLoteRpsRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ConsultarSituacaoLoteRpsRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/ConsultarSituacaoLoteRps', Request,
                     ['outputXML', 'ConsultarSituacaoLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRpsRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ConsultarNfsePorRpsRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</ConsultarNfseRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/ConsultarNfse', Request,
                     ['outputXML', 'ConsultarNfseResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceRJ.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfseRequest xmlns="http://notacarioca.rio.gov.br/">';
  Request := Request + '<inputXML>' + XmlToStr(AMSG) + '</inputXML>';
  Request := Request + '</CancelarNfseRequest>';

  Result := Executar('http://notacarioca.rio.gov.br/CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['']);
end;

{ TACBrNFSeProviderRJ }

procedure TACBrNFSeProviderRJ.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.QuebradeLinha := '';

  ConfigAssinar.CancelarNFSe := True;
end;

function TACBrNFSeProviderRJ.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_RJ.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderRJ.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_RJ.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderRJ.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, GerarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceRJ.Create(FAOwner, AMetodo, GerarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

end.
