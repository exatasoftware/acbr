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

unit Salvador.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSalvador = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSalvador = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrXmlBase,
  Salvador.GravarXml, Salvador.LerXml;

{ TACBrNFSeXWebserviceSalvador }

function TACBrNFSeXWebserviceSalvador.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:EnviarLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:EnviarLoteRPS>';

  Result := Executar('http://tempuri.org/IEnvioLoteRPS/EnviarLoteRPS', Request,
                     ['EnviarLoteRPSResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSalvador.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:ConsultarLoteRPS>';

  Result := Executar('http://tempuri.org/IConsultaLoteRPS/ConsultarLoteRPS', Request,
                     ['ConsultarLoteRPSResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSalvador.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarSituacaoLoteRPS>';
  Request := Request + '<tem:loteXML>' + IncluirCDATA(AMSG) + '</tem:loteXML>';
  Request := Request + '</tem:ConsultarSituacaoLoteRPS>';

  Result := Executar('http://tempuri.org/IConsultaSituacaoLoteRPS/ConsultarSituacaoLoteRPS', Request,
                     ['ConsultarSituacaoLoteRPSResult', 'ConsultarSituacaoLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSalvador.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseRPS>';
  Request := Request + '<tem:consultaxml>' + IncluirCDATA(AMSG) + '</tem:consultaxml>';
  Request := Request + '</tem:ConsultarNfseRPS>';

  Result := Executar('http://tempuri.org/IConsultaNfseRPS/ConsultarNfseRPS', Request,
                     ['ConsultarNfseRPSResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSalvador.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfse>';
  Request := Request + '<tem:consultaxml>' + IncluirCDATA(AMSG) + '</tem:consultaxml>';
  Request := Request + '</tem:ConsultarNfse>';

  Result := Executar('http://tempuri.org/IConsultaNfse/ConsultarNfse', Request,
                     ['ConsultarNfseResult', 'ConsultarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

{ TACBrNFSeProviderSalvador }

procedure TACBrNFSeProviderSalvador.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;
end;

function TACBrNFSeProviderSalvador.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Salvador.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSalvador.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Salvador.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSalvador.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmConsultarNFSeURL:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeURL);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, GerarNFSe);
        tmRecepcionarSincrono:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, RecepcionarSincrono);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, SubstituirNFSe);
        tmAbrirSessao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, AbrirSessao);
        tmFecharSessao:
          Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, FecharSessao);
      else
        // tmTeste
        Result := TACBrNFSeXWebserviceSalvador.Create(FAOwner, AMetodo, TesteEnvio);
      end;
    end;
  end;
end;

end.
