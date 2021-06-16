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

unit Sistemas4R.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebservice4R = class(TACBrNFSeXWebserviceSoap11)

  public
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProvider4R = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrDFeException, Sistemas4R.GravarXml, Sistemas4R.LerXml;

{ TACBrNFSeXWebservice4R }

function TACBrNFSeXWebservice4R.RecepcionarSincrono(ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'RecepcionarLoteRpsSincrono.Execute';
    xSoap := 'Abrasf2action/ARECEPCIONARLOTERPSSINCRONO.Execute';
  end
  else
  begin
    xTag := 'hRecepcionarLoteRpsSincrono.Execute';
    xSoap := 'Abrasf2action/AHRECEPCIONARLOTERPSSINCRONO.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'EnviarLoteRpsSincronoResposta'], ['']);
end;

function TACBrNFSeXWebservice4R.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'ConsultarLoteRps.Execute';
    xSoap := 'AbrasfNFSeactionACONSULTARLOTERPS.Execute';
  end
  else
  begin
    xTag := 'hConsultarLoteRps.Execute';
    xSoap := 'AbrasfNFSeactionAHCONSULTARLOTERPS.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="AbrasfNFSe">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'ConsultarLoteRpsResposta'], ['']);
end;

function TACBrNFSeXWebservice4R.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'ConsultarNfsePorRps.Execute';
    xSoap := 'Abrasf2action/ACONSULTARNFSEPORRPS.Execute';
  end
  else
  begin
    xTag := 'hConsultarNfsePorRps.Execute';
    xSoap := 'Abrasf2action/AHCONSULTARNFSEPORRPS.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'ConsultarNfseRpsResposta'], ['']);
end;

function TACBrNFSeXWebservice4R.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
  xTag, xSoap: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
  begin
    xTag := 'CancelarNfse.Execute';
    xSoap := 'Abrasf2action/ACANCELARNFSE.Execute';
  end
  else
  begin
    xTag := 'hCancelarNfse.Execute';
    xSoap := 'Abrasf2action/AHCANCELARNFSE.Execute';
  end;

  FPMsgOrig := AMSG;

  Request := '<' + xTag + ' xmlns="Abrasf2">';
  Request := Request + '<Entrada>' + XmlToStr(AMSG) + '</Entrada>';
  Request := Request + '</' + xTag + '>';

  Result := Executar(xSoap, Request, ['Resposta', 'CancelarNfseResposta'], ['']);
end;

{ TACBrNFSeProvider4R }

procedure TACBrNFSeProvider4R.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.QuebradeLinha := '&lt;br&gt;';

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
  end;

  with ConfigMsgDados.XmlRps do
  begin
    InfElemento := 'Rps';
    DocElemento := 'Rps';
  end;
end;

function TACBrNFSeProvider4R.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_4R.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvider4R.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_4R.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProvider4R.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservice4R.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

end.
