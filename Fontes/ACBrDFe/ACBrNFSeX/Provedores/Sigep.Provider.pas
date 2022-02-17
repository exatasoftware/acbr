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

unit Sigep.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSigep200 = class(TACBrNFSeXWebserviceSoap11)
  public
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderSigep200 = class (TACBrNFSeProviderABRASFv2)
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
  ACBrNFSeXNotasFiscais, Sigep.GravarXml, Sigep.LerXml;

{ TACBrNFSeProviderSigep200 }

procedure TACBrNFSeProviderSigep200.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    ConsultaNFSe := False;
    CancPreencherMotivo := True;
    CancPreencherCodVerificacao := True;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;

    IncluirURI := False;
  end;
end;

function TACBrNFSeProviderSigep200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Sigep200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigep200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Sigep200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigep200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSigep200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSigep200.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml, credenciais: string;
  i, j: Integer;
begin
  xXml := Response.ArquivoEnvio;

  with TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente do
  begin
    credenciais := '<credenciais>' +
                     '<usuario>' + WSUser + '</usuario>' +
                     '<senha>' + WSSenha + '</senha>' +
                     '<chavePrivada>' + WSChaveAcesso + '</chavePrivada>' +
                   '</credenciais>';
  end;

  case aMetodo of
    tmRecepcionarSincrono:
      begin
        xXml := RetornarConteudoEntre(xXml,
          '<EnviarLoteRpsSincronoEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">',
          '</EnviarLoteRpsSincronoEnvio>', False);

        xXml := '<EnviarLoteRpsSincronoEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                  credenciais + xXml +
                '</EnviarLoteRpsSincronoEnvio>';
      end;

    tmGerar:
      begin
        xXml := RetornarConteudoEntre(xXml,
                '<GerarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">',
                '</GerarNfseEnvio>', False);

        xXml := '<GerarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                  credenciais + xXml +
                '</GerarNfseEnvio>';
      end;

    tmConsultarLote:
      begin
        xXml := RetornarConteudoEntre(xXml,
                '<ConsultarLoteRpsEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">',
                '</ConsultarLoteRpsEnvio>', False);

        xXml := '<ConsultarLoteRpsEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                  credenciais + xXml +
                '</ConsultarLoteRpsEnvio>';
      end;

    tmConsultarNFSePorRps:
      begin
        xXml := RetornarConteudoEntre(xXml,
                '<ConsultarNfseRpsEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">',
                '</ConsultarNfseRpsEnvio>', False);

        xXml := '<ConsultarNfseRpsEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                  credenciais + xXml +
                '</ConsultarNfseRpsEnvio>';

        i := Pos('<Serie>', xXml);
        j := Pos('<Tipo>', xXml);
        xXml := Copy(xXml, 1, i -1) + Copy(xXml, j, length(xXml));
      end;

    tmCancelarNFSe:
      begin
        xXml := RetornarConteudoEntre(xXml,
                '<CancelarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">',
                '</CancelarNfseEnvio>', False);

        xXml := '<CancelarNfseEnvio xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                  credenciais + xXml +
                '</CancelarNfseEnvio>';

        xXml := StringReplace(xXml, 'MotivoCancelamento', 'DescricaoCancelamento', [rfReplaceAll]);

        i := Pos('<CodigoMunicipio>', xXml);
        j := Pos('<CodigoVerificacao>', xXml);
        xXml := Copy(xXml, 1, i -1) + Copy(xXml, j, length(xXml));
      end;
  else
    Response.ArquivoEnvio := xXml;
  end;

  Response.ArquivoEnvio := xXml;

  inherited ValidarSchema(Response, aMetodo);
end;

{ TACBrNFSeXWebserviceSigep200 }

function TACBrNFSeXWebserviceSigep200.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:enviarLoteRpsSincrono>';
  Request := Request + '<EnviarLoteRpsSincronoEnvio>' + XmlToStr(AMSG) + '</EnviarLoteRpsSincronoEnvio>';
  Request := Request + '</ws:enviarLoteRpsSincrono>';

  Result := Executar('', Request,
                     ['EnviarLoteRpsSincronoResposta', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:ws="http://ws.integration.pm.bsit.com.br/"']);
end;

function TACBrNFSeXWebserviceSigep200.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:gerarNfse>';
  Request := Request + '<GerarNfseEnvio>' + XmlToStr(AMSG) + '</GerarNfseEnvio>';
  Request := Request + '</ws:gerarNfse>';

  Result := Executar('', Request,
                     ['GerarNfseRetorno', 'GerarNfseResposta'],
                     ['xmlns:ws="http://ws.integration.pm.bsit.com.br/"']);
end;

function TACBrNFSeXWebserviceSigep200.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarLoteRps>';
  Request := Request + '<ConsultarLoteRpsEnvio>' + XmlToStr(AMSG) + '</ConsultarLoteRpsEnvio>';
  Request := Request + '</ws:consultarLoteRps>';

  Result := Executar('', Request,
                     ['ConsultarLoteRpsResposta', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:ws="http://ws.integration.pm.bsit.com.br/"']);
end;

function TACBrNFSeXWebserviceSigep200.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:consultarNfseRps>';
  Request := Request + '<ConsultarNfseRpsEnvio>' + XmlToStr(AMSG) + '</ConsultarNfseRpsEnvio>';
  Request := Request + '</ws:consultarNfseRps>';

  Result := Executar('', Request,
                     ['ConsultarNfseRpsResposta', 'ConsultarNfseRpsResposta'],
                     ['xmlns:ws="http://ws.integration.pm.bsit.com.br/"']);
end;

function TACBrNFSeXWebserviceSigep200.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:cancelarNfse>';
  Request := Request + '<CancelarNfseEnvio>' + XmlToStr(AMSG) + '</CancelarNfseEnvio>';
  Request := Request + '</ws:cancelarNfse>';

  Result := Executar('', Request,
                     ['CancelarNfseResposta', 'CancelarNfseResposta'],
                     ['xmlns:ws="http://ws.integration.pm.bsit.com.br/"']);
end;

function TACBrNFSeXWebserviceSigep200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := StrToXml(Result);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverIdentacao(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
  Result := string(NativeStringToUTF8(Result));
end;

end.
