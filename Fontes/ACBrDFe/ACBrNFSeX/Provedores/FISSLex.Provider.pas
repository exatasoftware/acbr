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

{ Observa��o sobre o funcionamento deste provedor
     Funcionou informando httpWinINet para HTTPLib
}

{$I ACBr.inc}

unit FISSLex.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceFISSLex = class(TACBrNFSeXWebserviceSoap11)

  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderFISSLex = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, FISSLex.GravarXml, FISSLex.LerXml;

{ TACBrNFSeXWebserviceFISSLex }

function TACBrNFSeXWebserviceFISSLex.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_RecepcionarLoteRps.Execute>';
  Request := Request + '<fiss:Enviarloterpsenvio>' + XmlToStr(AMSG) + '</fiss:Enviarloterpsenvio>';
  Request := Request + '</fiss:WS_RecepcionarLoteRps.Execute>';

  Result := Executar('FISS-LEXaction/AWS_RECEPCIONARLOTERPS.Execute', Request,
                     ['Enviarloterpsresposta', 'EnviarLoteRpsResposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

function TACBrNFSeXWebserviceFISSLex.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_ConsultaLoteRps.Execute>';
  Request := Request + '<fiss:Consultarloterpsenvio>' + AMSG + '</fiss:Consultarloterpsenvio>';
  Request := Request + '</fiss:WS_ConsultaLoteRps.Execute>';

  Result := Executar('FISS-LEXaction/AWS_CONSULTALOTERPS.Execute', Request,
                     ['Consultarloterpsresposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

function TACBrNFSeXWebserviceFISSLex.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_ConsultarSituacaoLoteRps.Execute>';
  Request := Request + '<fiss:Consultarsituacaoloterpsenvio>' + AMSG + '</fiss:Consultarsituacaoloterpsenvio>';
  Request := Request + '</fiss:WS_ConsultarSituacaoLoteRps.Execute>';

  Result := Executar('FISS-LEXaction/AWS_CONSULTARSITUACAOLOTERPS.Execute', Request,
                     ['Consultarsituacaoloterpsresposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

function TACBrNFSeXWebserviceFISSLex.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_ConsultaNfsePorRps.Execute>';
  Request := Request + '<fiss:Consultarnfserpsenvio>' + AMSG + '</fiss:Consultarnfserpsenvio>';
  Request := Request + '</fiss:WS_ConsultaNfsePorRps.Execute>';

  Result := Executar('FISS-LEXaction/AWS_CONSULTANFSEPORRPS.Execute', Request,
                     ['Consultarnfserpsresposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

function TACBrNFSeXWebserviceFISSLex.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_ConsultaNfse.Execute>';
  Request := Request + '<fiss:Consultarnfseenvio>' + AMSG + '</fiss:Consultarnfseenvio>';
  Request := Request + '</fiss:WS_ConsultaNfse.Execute>';

  Result := Executar('FISS-LEXaction/AWS_CONSULTANFSE.Execute', Request,
                     ['Consultarnfseresposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

function TACBrNFSeXWebserviceFISSLex.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<fiss:WS_CancelarNfse.Execute>';
  Request := Request + '<fiss:Cancelarnfseenvio>' + XmlToStr(AMSG) + '</fiss:Cancelarnfseenvio>';
  Request := Request + '</fiss:WS_CancelarNfse.Execute>';

  Result := Executar('FISS-LEXaction/AWS_CANCELARNFSE.Execute', Request,
                     ['Cancelarnfseresposta', 'CancelarNfseResposta'],
                     ['xmlns:fiss="FISS-LEX"']);
end;

{ TACBrNFSeProviderFISSLex }

procedure TACBrNFSeProviderFISSLex.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  ConfigAssinar.LoteRps := True;
end;

function TACBrNFSeProviderFISSLex.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_FISSLex.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFISSLex.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_FISSLex.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderFISSLex.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, CancelarNFSe);
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
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceFISSLex.Create(FAOwner, AMetodo, CancelarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderFISSLex.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml: string;
begin
  inherited ValidarSchema(Response, aMetodo);

  xXml := Response.XmlEnvio;

  case aMetodo of
    tmConsultarSituacao:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<ConsultarSituacaoLoteRpsEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">',
          '</ConsultarSituacaoLoteRpsEnvio>', False);
     end;

    tmConsultarLote:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<ConsultarLoteRpsEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">',
          '</ConsultarLoteRpsEnvio>', False);
      end;

    tmConsultarNFSePorRps:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<ConsultarNfseRpsEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">',
          '</ConsultarNfseRpsEnvio>', False);
      end;

    tmConsultarNFSe:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<ConsultarNfseEnvio xmlns="http://www.abrasf.org.br/ABRASF/arquivos/nfse.xsd">',
          '</ConsultarNfseEnvio>', False);
      end;

  else
    Response.XmlEnvio := xXml;
  end;

  Response.XmlEnvio := xXml;
end;

end.
