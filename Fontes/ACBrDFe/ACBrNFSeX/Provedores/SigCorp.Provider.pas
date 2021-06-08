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

unit SigCorp.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSigCorp = class(TACBrNFSeXWebserviceSoap11)
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

  TACBrNFSeProviderSigCorp = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SigCorp.GravarXml, SigCorp.LerXml;

{ TACBrNFSeProviderSigCorp }

procedure TACBrNFSeProviderSigCorp.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.UseCertificateHTTP := False;

  with ConfigAssinar do
  begin
    Rps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderSigCorp.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SigCorp.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigCorp.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SigCorp.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigCorp.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, SubstituirNFSe);
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
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSigCorp.Create(FAOwner, AMetodo, SubstituirNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceSigCorp }

function TACBrNFSeXWebserviceSigCorp.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult', 'RecepcionarLoteRps'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRpsSincrono>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:RecepcionarLoteRpsSincrono>';

  Result := Executar('http://tempuri.org/RecepcionarLoteRpsSincrono', Request,
                     ['RecepcionarLoteRpsSincronoResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:GerarNfse>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:GerarNfse>';

  Result := Executar('http://tempuri.org/GerarNfse', Request,
                     ['GerarNfseResult', 'GerarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorFaixa>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfsePorFaixa>';

  Result := Executar('http://tempuri.org/ConsultarNfsePorFaixa', Request,
                     ['ConsultarNfsePorFaixaResult', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoPrestado>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfseServicoPrestado>';

  Result := Executar('http://tempuri.org/ConsultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoTomado>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfseServicoTomado>';

  Result := Executar('http://tempuri.org/ConsultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelaNota>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:CancelaNota>';

  Result := Executar('http://tempuri.org/CancelaNota', Request,
                     ['CancelaNotaResult', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:SubstituirNfse>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:SubstituirNfse>';

  Result := Executar('http://tempuri.org/SubstituirNfse', Request,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

end.
