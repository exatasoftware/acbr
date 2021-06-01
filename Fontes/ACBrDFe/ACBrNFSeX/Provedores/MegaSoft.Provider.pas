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

unit MegaSoft.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceMegaSoft = class(TACBrNFSeXWebserviceSoap11)
  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderMegaSoft = class (TACBrNFSeProviderABRASFv2)
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
  ACBrNFSeXNotasFiscais, MegaSoft.GravarXml, MegaSoft.LerXml;

{ TACBrNFSeProviderMegaSoft }

procedure TACBrNFSeProviderMegaSoft.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ModoEnvio := meUnitario;

  ConfigAssinar.RpsGerarNFSe := True;

  SetXmlNameSpace('http://megasoftarrecadanet.com.br/xsd/nfse_v01.xsd');

  with ConfigMsgDados do
  begin
    DadosCabecalho := '<cabecalho versao="2.00" xmlns="http://megasoftarrecadanet.com.br/xsd/nfse_v01.xsd">' +
                      '<versaoDados>2.00</versaoDados>' +
                      '</cabecalho>';
  end;

  SetNomeXSD('nfse_v01.xsd');
end;

function TACBrNFSeProviderMegaSoft.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_MegaSoft.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMegaSoft.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_MegaSoft.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderMegaSoft.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceMegaSoft.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmGerar:
          Result := TACBrNFSeXWebserviceMegaSoft.Create(FAOwner, AMetodo, GerarNFSe);
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
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceMegaSoft.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmGerar:
          Result := TACBrNFSeXWebserviceMegaSoft.Create(FAOwner, AMetodo, GerarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderMegaSoft.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
var
  xXml: string;
  i, j: Integer;
begin
  xXml := Response.XmlEnvio;

  // Remove as tags Serie e Tipo ao realizar a consulta da NFS-e por Rps.
  case aMetodo of
    tmConsultarNFSePorRps:
      begin
        i := Pos('<Serie>', xXml);
        j := Pos('</IdentificacaoRps>', xXml);

        xXml := Copy(xXml, 1, i -1) + Copy(xXml, j, length(xXml));
        Response.XmlEnvio := xXml;
      end;
  else
    Response.XmlEnvio := xXml;
  end;

  inherited ValidarSchema(Response, aMetodo);
end;

{ TACBrNFSeXWebserviceMegaSoft }

function TACBrNFSeXWebserviceMegaSoft.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:GerarNfseRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ws:GerarNfseRequest>';

  Result := Executar('http://ws.megasoftarrecadanet.com.br/GerarNfse', Request,
                     ['outputXML', 'GerarNfseResposta'],
                     ['xmlns:ws="http://ws.megasoftarrecadanet.com.br"']);
end;

function TACBrNFSeXWebserviceMegaSoft.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws:ConsultarNfsePorRpsRequest>';
  Request := Request + '<nfseCabecMsg>' + XmlToStr(ACabecalho) + '</nfseCabecMsg>';
  Request := Request + '<nfseDadosMsg>' + XmlToStr(AMSG) + '</nfseDadosMsg>';
  Request := Request + '</ws:ConsultarNfsePorRpsRequest>';

  Result := Executar('http://ws.megasoftarrecadanet.com.br/ConsultarNfsePorRps', Request,
                     ['outputXML', 'ConsultarNfseRpsResposta'],
                     ['xmlns:ws="http://ws.megasoftarrecadanet.com.br"']);
end;

end.
