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

unit TcheInfo.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceTcheInfo = class(TACBrNFSeXWebserviceSoap11)
  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderTcheInfo = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, TcheInfo.GravarXml, TcheInfo.LerXml;

{ TACBrNFSeProviderTcheInfo }

procedure TACBrNFSeProviderTcheInfo.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
    IncluirURI := False;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.04';
    VersaoAtrib := '2.04';
  end;

  with ConfigMsgDados do
  begin
    with TACBrNFSeX(FAOwner).Configuracoes.Geral do
    begin
      DadosCabecalho := '<cabecalho versao="1.00" xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                        '<versaoDados>2.04</versaoDados>' +
                        '<CodigoIBGE>' + IntToStr(CodigoMunicipio) + '</CodigoIBGE>' +
                        '<CpfCnpj>' + Emitente.WSUser + '</CpfCnpj>' +
                        '<Token>' + Emitente.WSSenha + '</Token>' +
                        '</cabecalho>';
    end;
  end;
end;

function TACBrNFSeProviderTcheInfo.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_TcheInfo.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTcheInfo.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_TcheInfo.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderTcheInfo.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, GerarNFSe);
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
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, CancelarNFSe);
        tmGerar:
          Result := TACBrNFSeXWebserviceTcheInfo.Create(FAOwner, AMetodo, GerarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceTcheInfo }

function TACBrNFSeXWebserviceTcheInfo.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.GERARNFSE>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.GERARNFSE>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.GERARNFSE',
                     Request,
                     ['Outputxml', 'GerarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceTcheInfo.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.CONSULTARNFSERPS>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.CONSULTARNFSERPS>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.CONSULTARNFSERPS',
                     Request,
                     ['Outputxml', 'ConsultarNfseRpsResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

function TACBrNFSeXWebserviceTcheInfo.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:NfseWebService.CANCELARNFSE>';
  Request := Request + '<nfse:Nfsecabecmsg>' + XmlToStr(ACabecalho) + '</nfse:Nfsecabecmsg>';
  Request := Request + '<nfse:Nfsedadosmsg>' + XmlToStr(AMSG) + '</nfse:Nfsedadosmsg>';
  Request := Request + '</nfse:NfseWebService.CANCELARNFSE>';

  Result := Executar('http://www.abrasf.org.br/nfse.xsdaction/ANFSEWEBSERVICE.CANCELARNFSE',
                     Request,
                     ['Outputxml', 'CancelarNfseResposta'],
                     ['xmlns:nfse="http://www.abrasf.org.br/nfse.xsd"']);
end;

end.
