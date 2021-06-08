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

unit Vitoria.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceVitoria = class(TACBrNFSeXWebserviceSoap11)
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

  TACBrNFSeProviderVitoria = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, Vitoria.GravarXml, Vitoria.LerXml;

{ TACBrNFSeProviderVitoria }

procedure TACBrNFSeProviderVitoria.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    RpsSubstituirNFSe := True;
  end;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  ConfigMsgDados.XmlRps.xmlns := 'http://www.abrasf.org.br/';
end;

function TACBrNFSeProviderVitoria.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Vitoria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderVitoria.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Vitoria.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderVitoria.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, SubstituirNFSe);
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
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceVitoria.Create(FAOwner, AMetodo, SubstituirNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceVitoria }

function TACBrNFSeXWebserviceVitoria.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRpsSincrono xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</RecepcionarLoteRpsSincrono>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/RecepcionarLoteRpsSincrono', Request,
                     ['RecepcionarLoteRpsSincronoResult', 'EnviarLoteRpsSincronoResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<GerarNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</GerarNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/GerarNfse', Request,
                     ['GerarNfseResult', 'GerarNfseResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseFaixa xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseFaixa>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseFaixa', Request,
                     ['ConsultarNfseFaixaResult', 'ConsultarNfseFaixaResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRps xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfsePorRps>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoPrestado xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseServicoPrestado>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfseServicoTomado xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</ConsultarNfseServicoTomado>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/ConsultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</CancelarNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/CancelarNfse', Request,
                     ['CancelarNfseResult', 'CancelarNfseResposta'],
                     ['']);
end;

function TACBrNFSeXWebserviceVitoria.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<SubstituirNfse xmlns="http://www.abrasf.org.br/nfse.xsd">';
  Request := Request + '<mensagemXML>' + XmlToStr(AMSG) + '</mensagemXML>';
  Request := Request + '</SubstituirNfse>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsd/SubstituirNfse', Request,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     ['']);
end;

end.
