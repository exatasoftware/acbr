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

unit SimplISS.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSimplISS = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetDadosUsuario: string;

  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property DadosUsuario: string read GetDadosUsuario;
  end;

  TACBrNFSeProviderSimplISS = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  end;

  TACBrNFSeXWebserviceSimplISSv2 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSimplISSv2 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrXmlWriter, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SimplISS.GravarXml, SimplISS.LerXml;

{ TACBrNFSeProviderSimplISS }

procedure TACBrNFSeProviderSimplISS.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := 'id';

  SetXmlNameSpace('http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd');

  with ConfigMsgDados do
  begin
    Prefixo := 'nfse';
    PrefixoTS := 'nfse';
  end;

  SetNomeXSD('nfse_3.xsd');
end;

function TACBrNFSeProviderSimplISS.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SimplISS.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimplISS.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SimplISS.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimplISS.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, CancelarNFSe);
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
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSimplISS.Create(FAOwner, AMetodo, CancelarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderSimplISS.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml: string;
begin
  inherited ValidarSchema(Response, aMetodo);

  xXml := Response.XmlEnvio;

  case aMetodo of
    tmRecepcionar:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:EnviarLoteRpsEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:EnviarLoteRpsEnvio>', False);

        xXml := '<sis:EnviarLoteRpsEnvio>' + xXml + '</sis:EnviarLoteRpsEnvio>';
      end;

    tmConsultarSituacao:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:ConsultarSituacaoLoteRpsEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:ConsultarSituacaoLoteRpsEnvio>', False);

        xXml := '<sis:ConsultarSituacaoLoteRpsEnvio>' + xXml + '</sis:ConsultarSituacaoLoteRpsEnvio>';
      end;

    tmConsultarLote:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:ConsultarLoteRpsEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:ConsultarLoteRpsEnvio>', False);

        xXml := '<sis:ConsultarLoteRpsEnvio>' + xXml + '</sis:ConsultarLoteRpsEnvio>';
      end;

    tmConsultarNFSePorRps:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:ConsultarNfseRpsEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:ConsultarNfseRpsEnvio>', False);

        xXml := '<sis:ConsultarNfseRpsEnvio>' + xXml + '</sis:ConsultarNfseRpsEnvio>';
      end;

    tmConsultarNFSe:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:ConsultarNfseEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:ConsultarNfseEnvio>', False);

        xXml := '<sis:ConsultarNfseEnvio>' + xXml + '</sis:ConsultarNfseEnvio>';
      end;

    tmCancelarNFSe:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<nfse:CancelarNfseEnvio xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd">',
          '</nfse:CancelarNfseEnvio>', False);

        xXml := '<sis:CancelarNfseEnvio>' + xXml + '</sis:CancelarNfseEnvio>';
      end;
  else
    Response.XmlEnvio := xXml;
  end;

  Response.XmlEnvio := xXml;
end;

{ TACBrNFSeXWebserviceSimplISS }

function TACBrNFSeXWebserviceSimplISS.GetDadosUsuario: string;
begin
  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    Result := '<sis:pParam>' +
                '<sis1:P1>' + Emitente.WSUser + '</sis1:P1>' +
                '<sis1:P2>' + Emitente.WSSenha + '</sis1:P2>' +
              '</sis:pParam>';
  end;
end;

function TACBrNFSeXWebserviceSimplISS.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:RecepcionarLoteRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:RecepcionarLoteRps>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/RecepcionarLoteRps',
                     Request,
                     ['RecepcionarLoteRpsResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

function TACBrNFSeXWebserviceSimplISS.ConsultarSituacao(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:ConsultarSituacaoLoteRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:ConsultarSituacaoLoteRps>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/ConsultarSituacaoLoteRps',
                     Request,
                     ['ConsultarSituacaoLoteRpsResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

function TACBrNFSeXWebserviceSimplISS.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:ConsultarLoteRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:ConsultarLoteRps>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/ConsultarLoteRps',
                     Request,
                     ['ConsultarLoteRpsResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

function TACBrNFSeXWebserviceSimplISS.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:ConsultarNfsePorRps>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:ConsultarNfsePorRps>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/ConsultarNfsePorRps',
                     Request,
                     ['ConsultarNfsePorRpsResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

function TACBrNFSeXWebserviceSimplISS.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:ConsultarNfse>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:ConsultarNfse>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/ConsultarNfse',
                     Request,
                     ['ConsultarNfseResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

function TACBrNFSeXWebserviceSimplISS.Cancelar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<sis:CancelarNfse>';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</sis:CancelarNfse>';

  Result := Executar('http://www.sistema.com.br/Sistema.Ws.Nfse/INfseService/CancelarNfse',
                     Request,
                     ['CancelarNfseResult'],
                     ['xmlns:sis="http://www.sistema.com.br/Sistema.Ws.Nfse"',
                      'xmlns:sis1="http://www.sistema.com.br/Sistema.Ws.Nfse.Cn"',
            'xmlns:nfse="http://www.sistema.com.br/Nfse/arquivos/nfse_3.xsd"']);
end;

{ TACBrNFSeProviderSimplISSv2 }

procedure TACBrNFSeProviderSimplISSv2.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ModoEnvio := meLoteAssincrono;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderSimplISSv2.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SimplISSv2.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimplISSv2.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SimplISSv2.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimplISSv2.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, GerarNFSe);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, SubstituirNFSe);
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
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSePorFaixa:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSePorFaixa);
        tmConsultarNFSeServicoPrestado:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeServicoPrestado);
        tmConsultarNFSeServicoTomado:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, ConsultarNFSeServicoTomado);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, GerarNFSe);
        tmSubstituirNFSe:
          Result := TACBrNFSeXWebserviceSimplISSv2.Create(FAOwner, AMetodo, SubstituirNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceSimplISSv2 }

function TACBrNFSeXWebserviceSimplISSv2.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:RecepcionarLoteRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/RecepcionarLoteRps', Request,
                     ['outputXML', 'EnviarLoteRpsResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:GerarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:GerarNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarLoteRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/ConsultarLoteRps', Request,
                     ['outputXML', 'ConsultarLoteRpsResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseFaixaRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseFaixaRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/ConsultarNfseFaixa', Request,
                     ['outputXML', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseRpsRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/ConsultarNfseRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoPrestadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseServicoPrestadoRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/ConsultarNfseServicoPrestado', Request,
                     ['outputXML', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarNfseServicoTomadoRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:ConsultarNfseServicoTomadoRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/ConsultarNfseServicoTomado', Request,
                     ['outputXML', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:CancelarNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/CancelarNfse', Request,
                     ['outputXML', 'CancelarNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

function TACBrNFSeXWebserviceSimplISSv2.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:SubstituirNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</nfse:SubstituirNfseRequest>';

  Result := Executar('http://nfse.abrasf.org.br/INfseService/SubstituirNfse', Request,
                     ['outputXML', 'SubstituirNfseResposta'],
                     ['xmlns:nfse="http://nfse.abrasf.org.br"']);
end;

{
  Para a vers�o 1 desse provedor todas as tags recebem prefixo, inclusive as
  referente a montagem do lote de envio, por exemplo.
}
end.
