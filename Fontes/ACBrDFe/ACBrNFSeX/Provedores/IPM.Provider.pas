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

unit IPM.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrBase, ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio, ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type

  TACBrNFSeXWebserviceIPM = class(TACBrNFSeXWebserviceMulti1)
  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    function AjustarRetorno(const Retorno: string): string;
    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderIPM = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = 'mensagem'); override;

  public
    function SimNaoToStr(const t: TnfseSimNao): string; override;
    function StrToSimNao(out ok: boolean; const s: string): TnfseSimNao; override;
  end;

  TACBrNFSeXWebserviceIPM101 = class(TACBrNFSeXWebserviceMulti2)
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;

  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    function AjustarRetorno(const Retorno: string): string;
    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderIPM101 = class (TACBrNFSeProviderIPM)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;
  end;

  TACBrNFSeXWebserviceIPM204 = class(TACBrNFSeXWebserviceSoap11)
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;

  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
//    N�o foi implementado no ambiente de homologa��o
//    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
//    N�o foi implementado no ambiente de homologa��o
//    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderIPM204 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'item'); override;

  end;

implementation

uses
  synacode,
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.XMLHTML, ACBrUtil.FilesIO,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts, ACBrJSON,
  IPM.GravarXml, IPM.LerXml;

{ TACBrNFSeProviderIPM }

procedure TACBrNFSeProviderIPM.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;
    DetalharServico := True;
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := ConfigGeral.Params.ParamTemValor('Assinar', 'AssRpsGerarNfse');
    CancelarNFSe := ConfigGeral.Params.ParamTemValor('Assinar', 'AssCancelarNfse');
  end;

  SetXmlNameSpace('');

  with ConfigMsgDados do
  begin
    with XmlRps do
    begin
      InfElemento := 'nfse';
      DocElemento := 'nfse';
    end;

    with CancelarNFSe do
    begin
      InfElemento := 'nfse';
      DocElemento := 'nfse';
    end;
  end;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderIPM.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_IPM.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_IPM.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceIPM.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderIPM.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
var
  I{, j, k}: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  aMsg, Codigo: string;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    aMsg := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('codigo'), tcStr);

    Codigo := Copy(aMsg, 1, 5);

    {
     Codigo = 00001 significa que o processamento ocorreu com sucesso, logo n�o
     tem erros.
    }
    if Codigo <> '00001' then
    begin
      AErro := Response.Erros.New;

      AErro.Codigo := Codigo;
      AErro.Descricao := ACBrStr(Copy(aMsg, 9, Length(aMsg)));
      AErro.Correcao := '';
    end;
  end;
end;

function TACBrNFSeProviderIPM.SimNaoToStr(const t: TnfseSimNao): string;
begin
  Result := EnumeradoToStr(t, ['0', '1'], [snNao, snSim]);
end;

function TACBrNFSeProviderIPM.StrToSimNao(out ok: boolean;
  const s: string): TnfseSimNao;
begin
  Result := StrToEnumerado(ok, s,
                           ['0', '1', 'N', 'S'],
                           [snNao, snSim, snNao, snSim]);
end;

function TACBrNFSeProviderIPM.PrepararRpsParaLote(const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderIPM.GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
  Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := Params.Xml;
end;

procedure TACBrNFSeProviderIPM.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  AResumo: TNFSeResumoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  NumRps: String;
  ANota: TNotaFiscal;
  I: Integer;
  NotaCompleta: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      NotaCompleta := (Pos('<nfse>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      if NotaCompleta then
      begin
        ANodeArray := ANode.Childrens.FindAllAnyNs('nfse');
        if not Assigned(ANodeArray) and (Response.Sucesso) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit;
        end;

        for I := Low(ANodeArray) to High(ANodeArray) do
        begin
          ANode := ANodeArray[I];
          AuxNode := ANode.Childrens.FindAnyNs('rps');

          NumRps := '';
          if AuxNode <> nil then
            NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr);

          with Response do
          begin
            AuxNode := ANode.Childrens.FindAnyNs('nf');

            NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
            SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
            Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
            Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);
            Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
            Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
            Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
            CodigoVerificacao := Protocolo;
            Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
            DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          end;

          AResumo := Response.Resumos.New;
          AResumo.NumeroNota := Response.NumeroNota;
          AResumo.SerieNota := Response.SerieNota;
          AResumo.Data := Response.Data;
          AResumo.Link := Response.Link;
          AResumo.Protocolo := Response.Protocolo;
          AResumo.CodigoVerificacao := Response.CodigoVerificacao;
          AResumo.Situacao := Response.Situacao;
          AResumo.DescSituacao := Response.DescSituacao;

          if NumRps <> '' then
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
          else
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

          ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
          SalvarXmlNfse(ANota);
        end;
      end
      else
      begin
        with Response do
        begin
          NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(ANode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM.PrepararConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := ACBrStr(Desc101);
    Exit;
  end;

  Response.ArquivoEnvio := '<nfse>' +
                             '<pesquisa>' +
                               '<codigo_autenticidade>' +
                                 Response.Protocolo +
                               '</codigo_autenticidade>' +
                             '</pesquisa>' +
                           '</nfse>';
end;

procedure TACBrNFSeProviderIPM.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  AResumo: TNFSeResumoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  NumRps: String;
  ANota: TNotaFiscal;
  NotaCompleta: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      NotaCompleta := (Pos('<nfse>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);
      ProcessarMensagemErros(ANode, Response, 'ListaMensagemRetorno', 'MensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      if NotaCompleta then
      begin
        AuxNode := ANode.Childrens.FindAnyNs('rps');
        NumRps := '';

        if AuxNode <>  nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr);

        with Response do
        begin
          AuxNode := ANode.Childrens.FindAnyNs('nf');

          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;

        if NumRps <> '' then
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
        else
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end
      else
      begin
        with Response do
        begin
          NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(ANode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.NumeroRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod102;
    AErro.Descricao := ACBrStr(Desc102);
    Exit;
  end;

  if EstaVazio(Response.SerieRps) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod103;
    AErro.Descricao := ACBrStr(Desc103);
    Exit;
  end;

  Response.ArquivoEnvio := '<consulta_rps>' +
                             '<cidade>' +
                               CodIBGEToCodTOM(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio) +
                             '</cidade>' +
                             '<serie_rps>' +
                               OnlyNumber(Response.SerieRps) +
                             '</serie_rps>' +
                             '<numero_rps>' +
                               OnlyNumber(Response.NumeroRps) +
                             '</numero_rps>' +
                           '</consulta_rps>';
end;

procedure TACBrNFSeProviderIPM.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  AResumo: TNFSeResumoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  NumRps: String;
  ANota: TNotaFiscal;
  NotaCompleta: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      NotaCompleta := (Pos('<nfse>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      if NotaCompleta then
      begin
        AuxNode := ANode.Childrens.FindAnyNs('rps');
        NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr);

        with Response do
        begin
          AuxNode := ANode.Childrens.FindAnyNs('nf');

          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end
      else
      begin
        with Response do
        begin
          AuxNode := ANode.Childrens.FindAnyNs('rps');

          if AuxNode = nil then
            AuxNode := ANode;

          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          if NumeroNota = '' then
            NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfe'), tcStr);

          SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          if SerieNota = '' then
            SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfe'), tcStr);

          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);

          if Data = 0 then
            Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_hora_conversao'), tcDatVcto);

          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);

          DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          if DescSituacao = '' then
            DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao'), tcStr);

          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);

          Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
          if Protocolo = '' then
            Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('codigo_autenticidade'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  TagSerie: string;
begin
  if ConfigGeral.Versao = ve101 then
    TagSerie := 'serie_nfse'
  else
    TagSerie := 'serie';

  case Response.InfConsultaNFSe.tpConsulta of
    tcPorNumero:
      begin
        if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod108;
          AErro.Descricao := ACBrStr(Desc108);
          Exit;
        end;

        if EstaVazio(Response.InfConsultaNFSe.SerieNFSe) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod112;
          AErro.Descricao := ACBrStr(Desc112);
          Exit;
        end;

        if EstaVazio(Response.InfConsultaNFSe.CadEconomico) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod121;
          AErro.Descricao := ACBrStr(Desc121);
          Exit;
        end;

        Response.ArquivoEnvio := '<nfse>' +
                                   '<pesquisa>' +
                                     '<numero>' +
                                       OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                                     '</numero>' +
                                     '<' + TagSerie + '>' +
                                       OnlyNumber(Response.InfConsultaNFSe.SerieNFSe) +
                                     '</' + TagSerie + '>' +
                                     '<cadastro>' +
                                       OnlyNumber(Response.InfConsultaNFSe.CadEconomico) +
                                     '</cadastro>' +
                                   '</pesquisa>' +
                                 '</nfse>';

      end;
    tcPorFaixa: ;
    tcPorPeriodo: ;
    tcServicoPrestado: ;
    tcServicoTomado: ;
    tcPorCodigoVerificacao:
      begin
        if EstaVazio(Response.InfConsultaNFSe.CodVerificacao) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod117;
          AErro.Descricao := ACBrStr(Desc117);
          Exit;
        end;

        Response.ArquivoEnvio := '<nfse>' +
                                   '<pesquisa>' +
                                     '<codigo_autenticidade>' +
                                       Response.InfConsultaNFSe.CodVerificacao +
                                     '</codigo_autenticidade>' +
                                   '</pesquisa>' +
                                 '</nfse>';
      end;
  end;
end;

procedure TACBrNFSeProviderIPM.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  AResumo: TNFSeResumoCollectionItem;
  NumRps: String;
  ANota: TNotaFiscal;
  NotaCompleta: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      NotaCompleta := (Pos('<nfse>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      if NotaCompleta then
      begin
        AuxNode := ANode.Childrens.FindAnyNs('rps');

        if AuxNode <> nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr);

        with Response do
        begin
          AuxNode := ANode.Childrens.FindAnyNs('nf');

          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end
      else
      begin
        with Response do
        begin
          NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(ANode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  xSerie, IdAttr, xSubstituta: string;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.SerieNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod112;
    AErro.Descricao := ACBrStr(Desc112);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := ACBrStr(Desc110);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if ConfigGeral.Versao = ve101 then
    xSerie := '<serie_nfse>' +
                Response.InfCancelamento.SerieNFSe +
              '</serie_nfse>'
  else
    xSerie := '';

  if ConfigGeral.Params.TemParametro('SolicitarCancelamento') then
  begin
    xSubstituta := '';
    if Response.InfCancelamento.NumeroNFSeSubst <> '' then
      xSubstituta := '<substituta>' +
                       '<numero>' +
                         Response.InfCancelamento.NumeroNFSeSubst +
                       '</numero>' +
                       '<serie>' +
                         Response.InfCancelamento.SerieNFSeSubst +
                       '</serie>' +
                     '</substituta>';

    Response.ArquivoEnvio := '<solicitacao_cancelamento>' +
                               '<prestador>' +
                                 '<cpfcnpj>' +
                                   OnlyNumber(Emitente.CNPJ) +
                                 '</cpfcnpj>' +
                                 '<cidade>' +
                                   CodIBGEToCodTOM(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio) +
                                 '</cidade>' +
                               '</prestador>' +
                               '<documentos>' +
                                 '<nfse>' +
                                   '<numero>' +
                                     Response.InfCancelamento.NumeroNFSe +
                                   '</numero>' +
                                   '<serie>' +
                                     Response.InfCancelamento.SerieNFSe +
                                   '</serie>' +
                                   '<observacao>' +
                                     Response.InfCancelamento.MotCancelamento +
                                   '</observacao>' +
                                   xSubstituta +
                                 '</nfse>' +
                               '</documentos>' +
                             '</solicitacao_cancelamento>';
  end
  else
  begin
    if ConfigAssinar.CancelarNFSe then
      IdAttr := ' Id="nota"'
    else
      IdAttr := '';

    Response.ArquivoEnvio := '<nfse' + IdAttr + '>' +
                               '<nf>' +
                                 '<numero>' +
                                   Response.InfCancelamento.NumeroNFSe +
                                 '</numero>' +
                                 xSerie +
                                 '<situacao>' +
                                   'C' +
                                 '</situacao>' +
                                 '<observacao>' +
                                   Response.InfCancelamento.MotCancelamento +
                                 '</observacao>' +
                               '</nf>' +
                               '<prestador>' +
                                 '<cpfcnpj>' +
                                   OnlyNumber(Emitente.CNPJ) +
                                 '</cpfcnpj>' +
                                 '<cidade>' +
                                   CodIBGEToCodTOM(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio) +
                                 '</cidade>' +
                               '</prestador>' +
                             '</nfse>';
  end;
end;

procedure TACBrNFSeProviderIPM.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  AResumo: TNFSeResumoCollectionItem;
  ANodeArray: TACBrXmlNodeArray;
  NumRps: String;
  ANota: TNotaFiscal;
  I: Integer;
  NotaCompleta: Boolean;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      NotaCompleta := (Pos('<nfse>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      if NotaCompleta then
      begin
        ANodeArray := ANode.Childrens.FindAllAnyNs('nfse');
        if not Assigned(ANodeArray) and (Response.Sucesso) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit;
        end;

        for I := Low(ANodeArray) to High(ANodeArray) do
        begin
          ANode := ANodeArray[I];
          AuxNode := ANode.Childrens.FindAnyNs('rps');

          if AuxNode <> nil then
            NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr)
          else
            NumRps := '';

          with Response do
          begin
            AuxNode := ANode.Childrens.FindAnyNs('nf');

            NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
            SerieNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);
            Data := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
            Data := Data + ObterConteudoTag(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcHor);
            Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);
            Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
            Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
            Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
            DescSituacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          end;

          AResumo := Response.Resumos.New;
          AResumo.NumeroNota := Response.NumeroNota;
          AResumo.SerieNota := Response.SerieNota;
          AResumo.Data := Response.Data;
          AResumo.Link := Response.Link;
          AResumo.Protocolo := Response.Protocolo;
          AResumo.Situacao := Response.Situacao;
          AResumo.DescSituacao := Response.DescSituacao;

          if NumRps <> '' then
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps)
          else
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(Response.NumeroNota);

          ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
          SalvarXmlNfse(ANota);
        end;
      end
      else
      begin
        with Response do
        begin
          NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numero_nfse'), tcStr);
          SerieNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('serie_nfse'), tcStr);
          Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('data_nfse'), tcDatVcto);
          Data := Data + ObterConteudoTag(ANode.Childrens.FindAnyNs('hora_nfse'), tcHor);
          Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr);
          DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('situacao_descricao_nfse'), tcStr);
          Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('link_nfse'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);
        end;

        AResumo := Response.Resumos.New;
        AResumo.NumeroNota := Response.NumeroNota;
        AResumo.SerieNota := Response.SerieNota;
        AResumo.Data := Response.Data;
        AResumo.Link := Response.Link;
        AResumo.Protocolo := Response.Protocolo;
        AResumo.Situacao := Response.Situacao;
        AResumo.DescSituacao := Response.DescSituacao;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

{ TACBrNFSeXWebserviceIPM }

function TACBrNFSeXWebserviceIPM.TratarXmlRetornado(const aXML: string): string;
var
  jDocument, JSonErro: TACBrJSONObject;
  Codigo, Mensagem: string;
begin
  if StringIsXML(aXML) then
  begin
    Result := inherited TratarXmlRetornado(aXML);

    Result := String(NativeStringToUTF8(Result));
    Result := ParseText(AnsiString(Result), True, {$IfDef FPC}True{$Else}False{$EndIf});
    Result := RemoverDeclaracaoXML(Result);
    Result := RemoverIdentacao(Result);
    Result := RemoverCaracteresDesnecessarios(Result);
    Result := AjustarRetorno(Result);
  end
  else
  begin
    jDocument := TACBrJSONObject.Parse(aXML);
    JSonErro := jDocument.AsJSONObject['retorno'];

    if not Assigned(JSonErro) then Exit;

    Codigo := '00' + JSonErro.AsString['code'];
    Mensagem := ' - ' + ACBrStr(JSonErro.AsString['msg']);

    Result := '<a>' +
                '<mensagem>' +
                  '<codigo>' + Codigo + Mensagem + '</codigo>' +
                  '<Mensagem>' + '</Mensagem>' +
                  '<Correcao>' + '</Correcao>' +
                '</mensagem>' +
              '</a>';

    Result := ParseText(AnsiString(Result), True, {$IfDef FPC}True{$Else}False{$EndIf});
    Result := String(NativeStringToUTF8(Result));
  end;
end;

function TACBrNFSeXWebserviceIPM.GerarNFSe(ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM.ConsultarLote(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM.AjustarRetorno(const Retorno: string): string;
var
  i: Integer;
begin
  i := Pos('<codigo_html>', Retorno);

  if i > 0 then
    Result := Copy(Retorno, 1, i -1) + '</retorno>'
  else
    Result := Retorno;

  Result := Trim(StringReplace(Result, '&', '&amp;', [rfReplaceAll]));
end;

function TACBrNFSeXWebserviceIPM.Cancelar(ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

{ TACBrNFSeXWebserviceIPM101 }

procedure TACBrNFSeXWebserviceIPM101.SetHeaders(aHeaderReq: THTTPHeader);
var
  Auth: string;
begin
  with TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente do
    Auth := 'Basic ' + string(EncodeBase64(AnsiString(WSUser + ':' +
      ParseText(AnsiString(WSSenha), False))));

  aHeaderReq.AddHeader('Authorization', Auth);
end;

function TACBrNFSeXWebserviceIPM101.TratarXmlRetornado(
  const aXML: string): string;
var
  jDocument, JSonErro: TACBrJSONObject;
  Codigo, Mensagem: string;
begin
  if StringIsXML(aXML) then
  begin
    Result := inherited TratarXmlRetornado(aXML);

    Result := String(NativeStringToUTF8(Result));
    Result := ParseText(AnsiString(Result), True, {$IfDef FPC}True{$Else}False{$EndIf});
    Result := RemoverDeclaracaoXML(Result);
    Result := RemoverIdentacao(Result);
    Result := RemoverCaracteresDesnecessarios(Result);
    Result := AjustarRetorno(Result);
  end
  else
  begin
    jDocument := TACBrJSONObject.Parse(aXML);
    JSonErro := jDocument.AsJSONObject['retorno'];

    if not Assigned(JSonErro) then Exit;

    Codigo := '00' + JSonErro.AsString['code'];
    Mensagem := ' - ' + ACBrStr(JSonErro.AsString['msg']);

    Result := '<a>' +
                '<mensagem>' +
                  '<codigo>' + Codigo + Mensagem + '</codigo>' +
                  '<Mensagem>' + '</Mensagem>' +
                  '<Correcao>' + '</Correcao>' +
                '</mensagem>' +
              '</a>';

    Result := ParseText(AnsiString(Result), True, {$IfDef FPC}True{$Else}False{$EndIf});
    Result := String(NativeStringToUTF8(Result));
  end;
end;

function TACBrNFSeXWebserviceIPM101.GerarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM101.ConsultarLote(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM101.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

function TACBrNFSeXWebserviceIPM101.AjustarRetorno(
  const Retorno: string): string;
var
  i: Integer;
begin
  i := Pos('<codigo_html>', Retorno);

  if i > 0 then
    Result := Copy(Retorno, 1, i -1) + '</retorno>'
  else
    Result := Retorno;

  Result := Trim(StringReplace(Result, '&', '&amp;', [rfReplaceAll]));
end;

function TACBrNFSeXWebserviceIPM101.Cancelar(ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar('', AMSG, [], []);
end;

{ TACBrNFSeProviderIPM101 }

procedure TACBrNFSeProviderIPM101.Configuracao;
begin
  inherited Configuracao;

end;

function TACBrNFSeProviderIPM101.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_IPM101.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM101.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_IPM101.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM101.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceIPM101.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

{ TACBrNFSeXWebserviceIPM204 }

procedure TACBrNFSeXWebserviceIPM204.SetHeaders(aHeaderReq: THTTPHeader);
var
  Auth: string;
begin
  with TConfiguracoesNFSe(FPConfiguracoes).Geral.Emitente do
    Auth := 'Basic ' + string(EncodeBase64(AnsiString(WSUser + ':' +
      ParseText(AnsiString(WSSenha), False))));

  aHeaderReq.AddHeader('Authorization', Auth);
end;

function TACBrNFSeXWebserviceIPM204.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'EnviarLoteRpsEnvio');

  Request := '<net:EnviarLoteRpsEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:EnviarLoteRpsEnvio>';

  Result := Executar('net.atende#EnviarLoteRpsEnvio', Request,
              ['return', 'EnviarLoteRpsResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'EnviarLoteRpsSincronoEnvio');

  Request := '<net:EnviarLoteRpsSincronoEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:EnviarLoteRpsSincronoEnvio>';

  Result := Executar('net.atende#EnviarLoteRpsSincronoEnvio', Request,
              ['return', 'EnviarLoteRpsSincronoResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.GerarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'GerarNfseEnvio');

  Request := '<net:GerarNfseEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:GerarNfseEnvio>';

  Result := Executar('net.atende#GerarNfseEnvio', Request,
              ['return', 'GerarNfseResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'ConsultarLoteRpsEnvio');

  Request := '<net:ConsultarLoteRpsEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:ConsultarLoteRpsEnvio>';

  Result := Executar('net.atende#ConsultarLoteRpsEnvio', Request,
              ['return', 'ConsultarLoteRpsResposta'], ['xmlns:net="net.atende"']);
end;
{
function TACBrNFSeXWebserviceIPM204.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
begin

end;
}
function TACBrNFSeXWebserviceIPM204.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'ConsultarNfseFaixaEnvio');

  Request := '<net:ConsultarNfseFaixaEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:ConsultarNfseFaixaEnvio>';

  Result := Executar('net.atende#ConsultarNfseFaixaEnvio', Request,
              ['return', 'ConsultarNfseFaixaResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'ConsultarNfseServicoPrestadoEnvio');

  Request := '<net:ConsultarNfseServicoPrestadoEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:ConsultarNfseServicoPrestadoEnvio>';

  Result := Executar('net.atende#ConsultarNfseServicoPrestadoEnvio', Request,
              ['return', 'ConsultarNfseServicoPrestadoResposta'], ['xmlns:net="net.atende"']);
end;
{
function TACBrNFSeXWebserviceIPM204.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
begin

end;
}
function TACBrNFSeXWebserviceIPM204.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'CancelarNfseEnvio');

  Request := '<net:CancelarNfseEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:CancelarNfseEnvio>';

  Result := Executar('net.atende#CancelarNfseEnvio', Request,
              ['return', 'CancelarNfseResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  AMSG := SeparaDados(AMSG, 'SubstituirNfseEnvio');

  Request := '<net:SubstituirNfseEnvio>';
  Request := Request + AMSG;
  Request := Request + '</net:SubstituirNfseEnvio>';

  Result := Executar('net.atende#SubstituirNfseEnvio', Request,
              ['return', 'SubstituirNfseResposta'], ['xmlns:net="net.atende"']);
end;

function TACBrNFSeXWebserviceIPM204.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(AnsiString(Result), True, {$IfDef FPC}True{$Else}False{$EndIf});
end;

{ TACBrNFSeProviderIPM204 }

procedure TACBrNFSeProviderIPM204.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.Identificador := '';
  ConfigGeral.ConsultaPorFaixaPreencherNumNfseFinal := True;

  ConfigWebServices.AtribVerLote := '';

  ConfigMsgDados.GerarPrestadorLoteRps := True;
end;

function TACBrNFSeProviderIPM204.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_IPM204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM204.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_IPM204.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderIPM204.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceIPM204.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderIPM204.ProcessarMensagemErros(RootNode: TACBrXmlNode;
  Response: TNFSeWebserviceResponse; const AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if (ANodeArray = nil) then
    ANodeArray := ANode.Childrens.FindAllAnyNs('item');

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;

    AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);
    AErro.Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
  end;
end;

procedure TACBrNFSeProviderIPM204.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode, AuxNode2: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  NumRps: String;
  ANota: TNotaFiscal;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;
  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      with Response do
      begin
        Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), FpFormatoDataRecebimento);
        Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
      end;

      if Response.ModoEnvio in [meLoteSincrono, meUnitario] then
      begin
        ANode := ANode.Childrens.FindAnyNs('ListaNfse');

        if not Assigned(ANode) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod202;
          AErro.Descricao := ACBrStr(Desc202);
          Exit;
        end;

        ProcessarMensagemErros(ANode, Response);

        ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

        if not Assigned(ANodeArray) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit;
        end;

        for I := Low(ANodeArray) to High(ANodeArray) do
        begin
          ANode := ANodeArray[I];
          AuxNode := ANode.Childrens.FindAnyNs('item');

          if Assigned(AuxNode) then
            AuxNode := AuxNode.Childrens.FindAnyNs('Nfse')
          else
            AuxNode := ANode.Childrens.FindAnyNs('Nfse');

          if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

          AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');

          with Response do
          begin
            NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
            CodigoVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          end;

          AuxNode2 := AuxNode.Childrens.FindAnyNs('DeclaracaoPrestacaoServico');

          if AuxNode2 = nil then
            AuxNode2 := AuxNode.Childrens.FindAnyNs('Rps');
          if not Assigned(AuxNode2) or (AuxNode2 = nil) then Exit;

          AuxNode := AuxNode2.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');
          if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

          AuxNode := AuxNode.Childrens.FindAnyNs('Rps');

          if AuxNode <> nil then
          begin
            AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
            if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

            NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

            ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
            SalvarXmlNfse(ANota);
          end;
        end;
      end;

      Response.Sucesso := (Response.Erros.Count = 0);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM204.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Response.Situacao := '3'; // Processado com Falhas

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Situacao'), tcStr);

      if Response.Situacao = '' then
        Response.Situacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('SituacaoLoteRps'), tcStr);

      ANode := ANode.Childrens.FindAnyNs('ListaNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];

        AuxNode := ANode.Childrens.FindAnyNs('item');

        if Assigned(AuxNode) then
          AuxNode := AuxNode.Childrens.FindAnyNs('Nfse')
        else
          AuxNode := ANode.Childrens.FindAnyNs('Nfse');

        if AuxNode = nil then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit;
        end
        else
        begin
          if PreencherNotaRespostaConsultaLoteRps(AuxNode, ANode, Response) then
            Response.Situacao := '4' // Processado com sucesso pois retornou a nota
          else
          begin
            AErro := Response.Erros.New;
            AErro.Codigo := Cod203;
            AErro.Descricao := ACBrStr(Desc203);
            Exit;
          end;
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM204.TratarRetornoConsultaNFSeporFaixa(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumNFSe: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      TACBrNFSeX(FAOwner).NotasFiscais.Clear;

      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];

        AuxNode := ANode.Childrens.FindAnyNs('item');

        if Assigned(AuxNode) then
          AuxNode := AuxNode.Childrens.FindAnyNs('Nfse')
        else
          AuxNode := ANode.Childrens.FindAnyNs('Nfse');

        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        NumNFSe := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderIPM204.TratarRetornoConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  NumNFSe: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      TACBrNFSeX(FAOwner).NotasFiscais.Clear;

      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod202;
        AErro.Descricao := ACBrStr(Desc202);
        Exit;
      end;

      ProcessarMensagemErros(ANode, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := ACBrStr(Desc203);
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];

        AuxNode := ANode.Childrens.FindAnyNs('item');

        if Assigned(AuxNode) then
          AuxNode := AuxNode.Childrens.FindAnyNs('Nfse')
        else
          AuxNode := ANode.Childrens.FindAnyNs('Nfse');

        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

        NumNFSe := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
        SalvarXmlNfse(ANota);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := ACBrStr(Desc999 + E.Message);
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

end.
