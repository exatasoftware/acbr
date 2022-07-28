{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit CTA.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceCTA200 = class(TACBrNFSeXWebserviceMulti1)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    {
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;
    }

//    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderCTA200 = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function DefinirIDLote(const ID: string): string; override;
    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    (*
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = 'Erro'); override;
    *)
  end;

implementation

uses
  DateUtils,
  synacode,
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes,
  CTA.GravarXml, CTA.LerXml;

{ TACBrNFSeProviderCTA203 }

procedure TACBrNFSeProviderCTA200.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
//    UseAuthorizationHeader := False;
//    NumMaxRpsGerar  := 1;
//    NumMaxRpsEnviar := 50;

//    TabServicosExt := False;
//    Identificador := 'Id';
//    QuebradeLinha := ';';

    ModoEnvio := meLoteAssincrono;
    DetalharServico := True;

//    ConsultaSitLote := False;
    ConsultaLote := False;
//    ConsultaNFSe := True;

//    ConsultaPorFaixa := True;
//    ConsultaPorFaixaPreencherNumNfseFinal := False;

//    CancPreencherMotivo := False;
//    CancPreencherSerieNfse := False;
//    CancPreencherCodVerificacao := False;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.00';
    VersaoAtrib := '2.00';
    AtribVerLote := 'versao';
  end;

  SetXmlNameSpace('');

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderCTA200.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_CTA200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCTA200.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_CTA200.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderCTA200.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceCTA200.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

function TACBrNFSeProviderCTA200.DefinirIDLote(const ID: string): string;
begin
  if ConfigGeral.Identificador <> '' then
    Result := ' ' + ConfigGeral.Identificador + '="' + ID + '"'
  else
    Result := '';
end;

function TACBrNFSeProviderCTA200.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := '<Rps>' + SeparaDados(aXml, 'Rps') + '</Rps>';
end;

procedure TACBrNFSeProviderCTA200.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
  ChaveSeguranca, DataEmissao, Producao: string;
  wAno, wMes, wDia, wHor, wMin, wSeg, wMse: word;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  DecodeDateTime(Now, wAno, wMes, wDia, wHor, wMin, wSeg, wMse);

  DataEmissao :=  FormatFloat('0000', wAno) + '-' +
    FormatFloat('00', wMes) + '-' + FormatFloat('00', wDia) +
    'T' + FormatFloat('00', wHor) + ':' + FormatFloat('00', wMin) +
    ':' + FormatFloat('00', wSeg);

  ChaveSeguranca := Emitente.CNPJ + Emitente.WSChaveAcesso + DataEmissao;

  ChaveSeguranca := EncodeBase64(SHA1(ChaveSeguranca));

  if ConfigGeral.Ambiente = taProducao then
    Producao := '2'
  else
    Producao := '1';

  with Params do
  begin
    Versao := ' versao="' + ConfigWebServices.VersaoAtrib + '"';

    Response.ArquivoEnvio := '<RpsNfse' +  Versao + IdAttr + '>' +
                               '<ChaveSeguranca>' +
                                  ChaveSeguranca +
                               '</ChaveSeguranca>' +
                               '<Producao>' +
                                  Producao +
                               '</Producao>' +
                               '<Prestador>' +
                                 '<DataEmissao>' +
                                    DataEmissao +
                                 '</DataEmissao>' +
                                 '<Cnpj>' +
                                    Emitente.CNPJ +
                                 '</Cnpj>' +
                                 '<InscricaoEstadual>' +
                                    TACBrNFSeX(FAOwner).NotasFiscais.Items[0].NFSe.Prestador.IdentificacaoPrestador.InscricaoEstadual +
                                 '</InscricaoEstadual>' +
                                 '<InscricaoMunicipal>' +
                                    Emitente.InscMun +
                                 '</InscricaoMunicipal>' +
                                 '<OptanteSimplesNacional>' +
                                    SimNaoToStr(TACBrNFSeX(FAOwner).NotasFiscais.Items[0].NFSe.OptanteSimplesNacional) +
                                 '</OptanteSimplesNacional>' +
                                 '<IncentivoFiscal>' +
                                    SimNaoToStr(TACBrNFSeX(FAOwner).NotasFiscais.Items[0].NFSe.IncentivadorCultural) +
                                 '</IncentivoFiscal>' +
                               '</Prestador>' +
                               '<ListaRps>' +
                                 Xml +
                               '</ListaRps>' +
                             '</RpsNfse>';
  end;
end;

{ TACBrNFSeXWebserviceCTA200 }

function TACBrNFSeXWebserviceCTA200.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('' {'http://tempuri.org/IServiceNfse/GerarNfse' + Operacao},
                     Request, ['GerarNfseResposta'], []);
end;

function TACBrNFSeXWebserviceCTA200.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('' {'http://tempuri.org/IServiceNfse/GerarNfse' + Operacao},
                     Request, ['GerarNfseResposta'], []);
end;

{
function TACBrNFSeXWebserviceCTA200.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  // Reescrever se necess�rio;
end;
}
end.
