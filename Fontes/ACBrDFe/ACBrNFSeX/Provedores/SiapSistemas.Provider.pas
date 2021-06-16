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

unit SiapSistemas.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceSiapSistemas = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNamespace: string;
    function GetSoapAction: string;
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property Namespace: string read GetNamespace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderSiapSistemas = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, SiapSistemas.GravarXml, SiapSistemas.LerXml;

{ TACBrNFSeProviderSiapSistemas }

procedure TACBrNFSeProviderSiapSistemas.Configuracao;
begin
  inherited Configuracao;

  ConfigAssinar.IncluirURI := False;

  ConfigWebServices.AtribVerLote := '';

  with ConfigMsgDados do
  begin
    LoteRps.DocElemento := 'nfse:Enviarloterpsenvio';
    ConsultarLote.DocElemento := 'nfse:Consultarloterpsenvio';
    CancelarNFSe.DocElemento := 'nfse:Cancelarnfseenvio';
    GerarNFSe.DocElemento := 'nfse:Gerarnfseenvio';
    LoteRpsSincrono.DocElemento := 'nfse:Enviarloterpssincronoenvio';

    DadosCabecalho := '<nfse:Cabecalho xmlns="http://www.abrasf.org.br/nfse.xsd">' +
                        '<Versao>1.0</Versao>' +
                        '<versaoDados>2.03</versaoDados>' +
                      '</nfse:Cabecalho>';

  end;

  // Provedor ainda n�o disponibilizou os schemas.
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSiapSistemas.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SiapSistemas.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiapSistemas.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SiapSistemas.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiapSistemas.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSiapSistemas.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceSiapSistemas }

function TACBrNFSeXWebserviceSiapSistemas.GetNamespace: string;
begin
  Result := 'xmlns:nfse="' + TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params1 +
            'RPS"';
end;

function TACBrNFSeXWebserviceSiapSistemas.GetSoapAction: string;
begin
  Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params1 + 'RPSaction/';
end;

function TACBrNFSeXWebserviceSiapSistemas.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRps.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:RecepcionarLoteRps.Execute>';

  Result := Executar(SoapAction + 'ARECEPCIONARLOTERPS.Execute', Request,
                     ['Enviarloterpsresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:RecepcionarLoteRpsSincrono.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:RecepcionarLoteRpsSincrono.Execute>';

  Result := Executar(SoapAction + 'ARECEPCIONARLOTERPSSINCRONO.Execute', Request,
                     ['Enviarloterpssincronoresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:GerarNfse.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:GerarNfse.Execute>';

  Result := Executar(SoapAction + 'AGERARNFSE.Execute', Request,
                     ['Gerarnfseresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:ConsultarLoteRps.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:ConsultarLoteRps.Execute>';

  Result := Executar(SoapAction + 'ACONSULTARLOTERPS.Execute', Request,
                     ['Consultarloterpsresposta'], [NameSpace]);
end;

function TACBrNFSeXWebserviceSiapSistemas.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:CancelarNfse.Execute>';
  Request := Request + ACabecalho;
  Request := Request + AMSG;
  Request := Request + '</nfse:CancelarNfse.Execute>';

  Result := Executar(SoapAction + 'ACANCELARNFSE.Execute', Request,
                     ['Cancelarnfseresposta'], [NameSpace]);
end;

end.
