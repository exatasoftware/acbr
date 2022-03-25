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

unit fintelISS.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebservicefintelISS200 = class(TACBrNFSeXWebserviceSoap11)
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

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderfintelISS200 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function GetSchemaPath: string; override;
  end;

  TACBrNFSeXWebservicefintelISS202 = class(TACBrNFSeXWebservicefintelISS200)
  public

  end;

  TACBrNFSeProviderfintelISS202 = class (TACBrNFSeProviderfintelISS200)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;

  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, fintelISS.GravarXml, fintelISS.LerXml;

{ TACBrNFSeProviderfintelISS200 }

procedure TACBrNFSeProviderfintelISS200.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.02';
    VersaoAtrib := '2.02';
    AtribVerLote := 'versao';
  end;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');

  SetNomeXSD('nfseV202.xsd');
end;

function TACBrNFSeProviderfintelISS200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_fintelISS200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderfintelISS200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_fintelISS200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderfintelISS200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebservicefintelISS200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderfintelISS200.GetSchemaPath: string;
begin
  Result := inherited GetSchemaPath;

  Result := Result + ConfigGeral.CodIBGE + '\';
end;

{ TACBrNFSeXWebservicefintelISS200 }

function TACBrNFSeXWebservicefintelISS200.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:RecepcionarLoteRps>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:RecepcionarLoteRps>';

  Result := Executar('http://www.fintel.com.br/WebService/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:RecepcionarLoteRpsSincrono>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:RecepcionarLoteRpsSincrono>';

  Result := Executar('http://www.fintel.com.br/WebService/RecepcionarLoteRpsSincrono', Request,
                     ['RecepcionarLoteRpsSincronoResult', 'EnviarLoteRpsSincronoResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:GerarNfse>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:GerarNfse>';

  Result := Executar('http://www.fintel.com.br/WebService/GerarNfse', Request,
                     ['GerarNfseResult', 'GerarNfseResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:ConsultarLoteRps>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:ConsultarLoteRps>';

  Result := Executar('http://www.fintel.com.br/WebService/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:ConsultarNfseFaixa>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:ConsultarNfseFaixa>';

  Result := Executar('http://www.fintel.com.br/WebService/ConsultarNfseFaixa', Request,
                     ['ConsultarNfseFaixaResult', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:ConsultarNfsePorRps>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:ConsultarNfsePorRps>';

  Result := Executar('http://www.fintel.com.br/WebService/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:ConsultarNfseServicoPrestado>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:ConsultarNfseServicoPrestado>';

  Result := Executar('http://www.fintel.com.br/WebService/ConsultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:ConsultarNfseServicoTomado>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:ConsultarNfseServicoTomado>';

  Result := Executar('http://www.fintel.com.br/WebService/ConsultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:CancelarNfse>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:CancelarNfse>';

  Result := Executar('http://www.fintel.com.br/WebService/CancelarNfse', Request,
                     ['CancelarNfseResult', 'CancelarNfseResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<web:SubstituirNfse>';
  Request := Request + '<web:cabecalho>' + XmlToStr(ACabecalho) + '</web:cabecalho>';
  Request := Request + '<web:xml>' + XmlToStr(AMSG) + '</web:xml>';
  Request := Request + '</web:SubstituirNfse>';

  Result := Executar('http://www.fintel.com.br/WebService/SubstituirNfse', Request,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     ['xmlns:web="http://www.fintel.com.br/WebService"']);
end;

function TACBrNFSeXWebservicefintelISS200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(AnsiString(Result), True, False);
  Result := RemoverDeclaracaoXML(Result);
end;

{ TACBrNFSeProviderfintelISS202 }

procedure TACBrNFSeProviderfintelISS202.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    Rps := True;
    LoteRps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.02';
    VersaoAtrib := '2.02';
    AtribVerLote := '';
  end;

  with ConfigMsgDados do
  begin
    with XmlRps do
    begin
      xmlns := ConfigWebServices.Producao.XMLNameSpace;

      SetXmlNameSpace(xmlns);
    end;

    DadosCabecalho := GetCabecalho(XmlRps.xmlns);
  end;

  SetNomeXSD('nfseV202.xsd');
end;

function TACBrNFSeProviderfintelISS202.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_fintelISS202.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderfintelISS202.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_fintelISS202.Create(Self);
  Result.NFSe := ANFSe;
end;

end.
