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

unit GovBr.Provider;

interface

uses
  SysUtils, Classes,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceGovBr = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderGovBr = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException,
  GovBr.GravarXml, GovBr.LerXml;

{ TACBrNFSeProviderGovBr }

procedure TACBrNFSeProviderGovBr.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := 'id';
    UseCertificateHTTP := False;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    CancelarNFSe := True;
  end;
end;

function TACBrNFSeProviderGovBr.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_GovBr.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGovBr.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_GovBr.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGovBr.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceGovBr.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceGovBr }

function TACBrNFSeXWebserviceGovBr.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEGeracao/RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceGovBr.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceGovBr.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarSituacaoLoteRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarSituacaoLoteRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarSituacaoLoteRps', Request,
                     ['outputXML', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceGovBr.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorRps>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceGovBr.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfse>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:ConsultarNfse>';

  Result := Executar('http://tempuri.org/INFSEConsultas/ConsultarNfse', Request,
                     ['outputXML', 'ConsultarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceGovBr.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelarNfse>';
  Request := Request + '<tem:xmlEnvio>' + XmlToStr(AMSG) + '</tem:xmlEnvio>';
  Request := Request + '</tem:CancelarNfse>';

  Result := Executar('http://tempuri.org/INFSEGeracao/CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

end.
