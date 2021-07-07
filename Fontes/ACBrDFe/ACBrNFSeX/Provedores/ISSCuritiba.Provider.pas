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

unit ISSCuritiba.Provider;

interface

uses
  SysUtils, Classes,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceISSCuritiba = class(TACBrNFSeXWebserviceSoap12)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderISSCuritiba = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ISSCuritiba.GravarXml, ISSCuritiba.LerXml;

{ TACBrNFSeProviderISSCuritiba }

procedure TACBrNFSeProviderISSCuritiba.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    FormatoItemListaServico := filsSemFormatacao;
    Identificador := 'id';
  end;

  SetXmlNameSpace('http://srv2-isscuritiba.curitiba.pr.gov.br/iss/nfse.xsd');

  ConfigAssinar.LoteRps := True;

  SetNomeXSD('nfse.xsd');
end;

function TACBrNFSeProviderISSCuritiba.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSCuritiba.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSCuritiba.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSCuritiba.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSCuritiba.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSCuritiba.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceISSCuritiba }

function TACBrNFSeXWebserviceISSCuritiba.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<RecepcionarLoteRps xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</RecepcionarLoteRps>';

  Result := Executar('http://www.e-governeapps2.com.br/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceISSCuritiba.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarLoteRps xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</ConsultarLoteRps>';

  Result := Executar('http://www.e-governeapps2.com.br/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceISSCuritiba.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarSituacaoLoteRps xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</ConsultarSituacaoLoteRps>';

  Result := Executar('http://www.e-governeapps2.com.br/ConsultarSituacaoLoteRps', Request,
                     ['ConsultarSituacaoLoteRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceISSCuritiba.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfsePorRps xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</ConsultarNfsePorRps>';

  Result := Executar('http://www.e-governeapps2.com.br/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult'], ['']);
end;

function TACBrNFSeXWebserviceISSCuritiba.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ConsultarNfse xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</ConsultarNfse>';

  Result := Executar('http://www.e-governeapps2.com.br/ConsultarNfse', Request,
                     ['ConsultarNfseResult'], ['']);
end;

function TACBrNFSeXWebserviceISSCuritiba.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<CancelarNfse xmlns="http://www.e-governeapps2.com.br/">';
  Request := Request + AMSG;
  Request := Request + '</CancelarNfse>';

  Result := Executar('http://www.e-governeapps2.com.br/CancelarNfse', Request,
                     ['CancelarNfseResult'], ['']);
end;

end.
