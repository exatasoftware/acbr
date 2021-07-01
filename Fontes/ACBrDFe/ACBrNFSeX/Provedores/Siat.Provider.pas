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

unit Siat.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio, ISSDSF.Provider,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSiat = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNameSpace: string;
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function TesteEnvio(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property NameSpace: string read GetNameSpace;
  end;

  TACBrNFSeProviderSiat = class (TACBrNFSeProviderISSDSF)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Siat.GravarXml, Siat.LerXml;

{ TACBrNFSeProviderSiat }

procedure TACBrNFSeProviderSiat.Configuracao;
begin
{
  inherited Configuracao;

  with ConfigGeral do
  begin
    QuebradeLinha := '<br >';
    ModoEnvio := meLoteSincrono;
  end;

  with ConfigAssinar do
  begin
    LoteRps := True;
    ConsultarNFSeRps := True;
    ConsultarNFSe := True;
    CancelarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.00';
  end;

  SetXmlNameSpace('http://localhost:8080/WsNFe2/lote');

  with ConfigMsgDados do
  begin
    Prefixo := 'ns1';
    PrefixoTS := 'tipos';

    XmlRps.xmlns := 'http://localhost:8080/WsNFe2/tp';

    with LoteRps do
    begin
      InfElemento := 'Lote';
      DocElemento := 'ReqEnvioLoteRPS';
    end;

    with LoteRpsSincrono do
    begin
      InfElemento := 'Lote';
      DocElemento := 'ReqEnvioLoteRPS';
    end;

    with ConsultarLote do
    begin
      InfElemento := '';
      DocElemento := 'ReqConsultaLote';
    end;

    with ConsultarNFSeRps do
    begin
      InfElemento := 'Lote';
      DocElemento := 'ReqConsultaNFSeRPS';
    end;

    with ConsultarNFSe do
    begin
      InfElemento := 'Lote';
      DocElemento := 'ReqConsultaNotas';
    end;

    with CancelarNFSe do
    begin
      InfElemento := 'Lote';
      DocElemento := 'ReqCancelamentoNFSe';
    end;
  end;

  with ConfigSchemas do
  begin
    Recepcionar := 'ReqEnvioLoteRPS.xsd';
    ConsultarLote := 'ReqConsultaLote.xsd';
    ConsultarNFSeRps := 'ReqConsultaNFSeRPS.xsd';
    ConsultarNFSe := 'ReqConsultaNotas.xsd';
    CancelarNFSe := 'ReqCancelamentoNFSe.xsd';
    RecepcionarSincrono := 'ReqEnvioLoteRPS.xsd';
    Teste := 'ReqEnvioLoteRPS.xsd';
  end;
  }
end;

function TACBrNFSeProviderSiat.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Siat.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiat.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Siat.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiat.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSiat.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

{ TACBrNFSeXWebserviceSiat }

function TACBrNFSeXWebserviceSiat.GetNameSpace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 1 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.NameSpace
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.NameSpace;

  Result := 'xmlns:lot="' + Result + '"';
end;

function TACBrNFSeXWebserviceSiat.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:enviar>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:enviar>';

  Result := Executar('', Request,
                     ['enviarReturn', 'ReqEnvioLoteRPS'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:enviarSincrono>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:enviarSincrono>';

  Result := Executar('', Request,
                     ['enviarSincronoReturn', 'RetornoEnvioLoteRPS'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.TesteEnvio(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:testeEnviar>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:testeEnviar>';

  Result := Executar('', Request,
                     ['testeEnviarReturn', 'RetornoEnvioLoteRPS'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:consultarLote>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:consultarLote>';

  Result := Executar('', Request,
                     ['consultarLoteReturn', 'RetornoConsultaLote'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:consultarNFSeRps>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:consultarNFSeRps>';

  Result := Executar('', Request,
                     ['consultarNFSeRpsReturn', 'RetornoConsultaNFSeRPS'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:consultarNota>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:consultarNota>';

  Result := Executar('', Request,
                     ['consultarNotaReturn', 'RetornoConsultaNotas'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceSiat.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<lot:cancelar>';
  Request := Request + '<mensagemXml>' + XmlToStr(AMSG) + '</mensagemXml>';
  Request := Request + '</lot:cancelar>';

  Result := Executar('', Request,
                     ['cancelarReturn', 'RetornoCancelamentoNFSe'],
                     [NameSpace]);
end;

end.
