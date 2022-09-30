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

unit PadraoNacional.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrJSON, ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebservicePadraoNacional = class(TACBrNFSeXWebserviceRest)
  public
    function GerarNFSe(ACabecalho, AMSG: string): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: string): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: string): string; override;
    function EnviarEvento(ACabecalho, AMSG: string): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderPadraoNacional = class (TACBrNFSeProviderProprio)
  private
    FpPath: string;
    FpMethod: string;
    FpChave: string;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararEnviarEvento(Response: TNFSeEnviarEventoResponse); override;
    procedure TratarRetornoEnviarEvento(Response: TNFSeEnviarEventoResponse); override;

    procedure ProcessarMensagemDeErros(LJson: TACBrJSONObject;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'erros');

    procedure ValidarSchema(Response: TNFSeWebserviceResponse; aMetodo: TMetodo); override;
  public
    function RegimeEspecialTributacaoToStr(const t: TnfseRegimeEspecialTributacao): string; override;
    function StrToRegimeEspecialTributacao(out ok: boolean; const s: string): TnfseRegimeEspecialTributacao; override;
    function RegimeEspecialTributacaoDescricao(const t: TnfseRegimeEspecialTributacao): string; override;
  end;

implementation

uses
  synacode,
  pcnAuxiliar,
  ACBrDFeException, ACBrCompress,
  ACBrUtil.Base, ACBrUtil.XMLHTML, ACBrUtil.Strings,
  ACBrNFSeX, ACBrNFSeXConsts, ACBrNFSeXConfiguracoes,
  PadraoNacional.GravarXml, PadraoNacional.LerXml;

{ TACBrNFSeProviderPadraoNacional }

procedure TACBrNFSeProviderPadraoNacional.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meUnitario;
    ConsultaLote := False;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '1.00';
    VersaoAtrib := '1.00';
    AtribVerLote := 'versao';
  end;

  SetXmlNameSpace('http://www.sped.fazenda.gov.br/nfse');

  with ConfigMsgDados do
  begin
    UsarNumLoteConsLote := False;

    DadosCabecalho := GetCabecalho('');

    with XmlRps do
    begin
      InfElemento := 'infDPS';
      DocElemento := 'DPS';
    end;

    with EnviarEvento do
    begin
      InfElemento := 'infPedReg';
      DocElemento := 'pedRegEvento';
    end;
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := True;
    EnviarEvento := True;
  end;

  with ConfigSchemas do
  begin
    GerarNFSe := 'DPS_v1.00.xsd';
    ConsultarNFSe := 'DPS_v1.00.xsd';
    ConsultarNFSeRps := 'DPS_v1.00.xsd';
    EnviarEvento := 'pedRegEvento_v1.00.xsd';
  end;
end;

function TACBrNFSeProviderPadraoNacional.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_PadraoNacional.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPadraoNacional.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_PadraoNacional.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderPadraoNacional.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
  begin
    URL := URL + FpPath;
    Result := TACBrNFSeXWebservicePadraoNacional.Create(FAOwner, AMetodo, URL, FpMethod);
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.ProcessarMensagemDeErros(
  LJson: TACBrJSONObject; Response: TNFSeWebserviceResponse;
  const AListTag: string);
var
  I: Integer;
  JSonErros: TACBrJSONArray;
  JsonErro, JSon: TACBrJSONObject;
  Codigo: string;
  AErro: TNFSeEventoCollectionItem;
  LerErro: Boolean;
begin
  LerErro := True;
  JSonErros := LJson.AsJSONArray['erros'];

  if JSonErros.Count = 0 then
  begin
    JSonErros := LJson.AsJSONArray['erro'];
    LerErro := False;
  end;

  for I := 0 to JSonErros.Count-1 do
  begin
    JSon := JSonErros.ItemAsJSONObject[i];

    Codigo := JSon.AsString['Codigo'];

    if Codigo <> '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Codigo;
      AErro.Descricao := JSon.AsString['Descricao'];
      AErro.Correcao := JSon.AsString['Complemento'];
    end
    else
    begin
      Codigo := JSon.AsString['codigo'];

      if Codigo <> '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Codigo;
        AErro.Descricao := JSon.AsString['descricao'];
        AErro.Correcao := JSon.AsString['complemento'];
      end;
    end;
  end;

  if LerErro then
  begin
    JSonErro := LJson.AsJSONObject['erro'];

    if JsonErro <> nil then
    begin
      Codigo := JSonErro.AsString['codigo'];

      if Codigo <> '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Codigo;
        AErro.Descricao := JSonErro.AsString['descricao'];
        AErro.Correcao := JSonErro.AsString['complemento'];
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.PrepararEmitir(
  Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Nota: TNotaFiscal;
  IdAttr, ListaRps: string;
  I: Integer;
begin
  if TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod002;
    AErro.Descricao := Desc002;
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > Response.MaxRps then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod003;
    AErro.Descricao := 'Conjunto de DPS transmitidos (m�ximo de ' +
                       IntToStr(Response.MaxRps) + ' DPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count);
  end;

  if Response.Erros.Count > 0 then Exit;

  ListaRps := '';

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  for I := 0 to TACBrNFSeX(FAOwner).NotasFiscais.Count -1 do
  begin
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[I];

    Nota.GerarXML;

    Nota.XmlRps := AplicarXMLtoUTF8(Nota.XmlRps);
    Nota.XmlRps := AplicarLineBreak(Nota.XmlRps, '');

    if (ConfigAssinar.Rps and (Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono])) or
       (ConfigAssinar.RpsGerarNFSe and (Response.ModoEnvio = meUnitario)) then
    begin
      Nota.XmlRps := FAOwner.SSL.Assinar(Nota.XmlRps,
                                         PrefixoTS + ConfigMsgDados.XmlRps.DocElemento,
                                         ConfigMsgDados.XmlRps.InfElemento, '', '', '', IdAttr);

      Response.ArquivoEnvio := Nota.XmlRps;
    end;

    SalvarXmlRps(Nota);

    ListaRps := ListaRps + Nota.XmlRps;
  end;

  Response.ArquivoEnvio := ListaRps;
end;

procedure TACBrNFSeProviderPadraoNacional.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  NFSeXml: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  NumNFSe, NumRps: string;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := Desc201;
    Exit
  end;

  Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

  try
    try
      ProcessarMensagemDeErros(Document, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      Response.Data := Document.AsISODateTime['dataHoraProcessamento'];
      Response.idNota := Document.AsString['idDPS'];
      Response.Link := Document.AsString['chaveAcesso'];
      NFSeXml := Document.AsString['nfseXmlGZipB64'];

      if NFSeXml <> '' then
        NFSeXml := DeCompress(DecodeBase64(NFSeXml));

      DocumentXml := TACBrXmlDocument.Create;

      try
        try
          if NFSeXml = '' then
          begin
            AErro := Response.Erros.New;
            AErro.Codigo := Cod203;
            AErro.Descricao := Desc203;
            Exit
          end;

          DocumentXml.LoadFromXml(NFSeXml);

          ANode := DocumentXml.Root.Childrens.FindAnyNs('infNFSe');

          NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('Numero'), tcStr);
          ANode := ANode.Childrens.FindAnyNs('DPS');
          ANode := ANode.Childrens.FindAnyNs('infDPS');
          NumRps := ObterConteudoTag(ANode.Childrens.FindAnyNs('nDPS'), tcStr);

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

          ANota := CarregarXmlNfse(ANota, DocumentXml.Root.OuterXml);
          SalvarXmlNfse(ANota);
        except
          on E:Exception do
          begin
            AErro := Response.Erros.New;
            AErro.Codigo := Cod999;
            AErro.Descricao := Desc999 + E.Message;
          end;
        end;
      finally
        FreeAndNil(DocumentXml);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.NumRPS) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod126;
    AErro.Descricao := Desc126;
    Exit;
  end;

  Response.ArquivoEnvio := '';
  FpPath := '/dps/' + Response.NumRPS;
  FpMethod := 'GET';
end;

procedure TACBrNFSeProviderPadraoNacional.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := Desc201;
    Exit
  end;

  Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

  try
    try
      ProcessarMensagemDeErros(Document, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      Response.Data := Document.AsISODateTime['dataHoraProcessamento'];
      Response.idNota := Document.AsString['chaveAcesso'];
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod118;
    AErro.Descricao := Desc118;
    Exit;
  end;

  Response.Metodo := tmConsultarNFSe;

  Response.ArquivoEnvio := '';

  if Response.InfConsultaNFSe.tpRetorno = trXml then
    FpPath := '/nfse/' + Response.InfConsultaNFSe.NumeroIniNFSe
  else
    FpPath := '/danfse/' + Response.InfConsultaNFSe.NumeroIniNFSe;

  FpMethod := 'GET';
end;

procedure TACBrNFSeProviderPadraoNacional.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  NFSeXml: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  NumNFSe, NumRps: string;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := Desc201;
    Exit
  end;

  if Response.InfConsultaNFSe.tpRetorno = trXml then
  begin
    Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

    try
      try
        ProcessarMensagemDeErros(Document, Response);
        Response.Sucesso := (Response.Erros.Count = 0);

        Response.Data := Document.AsISODateTime['dataHoraProcessamento'];

        NFSeXml := Document.AsString['nfseXmlGZipB64'];

        if NFSeXml <> '' then
          NFSeXml := DeCompress(DecodeBase64(NFSeXml));

        DocumentXml := TACBrXmlDocument.Create;

        try
          try
            if NFSeXml = '' then
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Cod203;
              AErro.Descricao := Desc203;
              Exit
            end;

            DocumentXml.LoadFromXml(NFSeXml);

            ANode := DocumentXml.Root.Childrens.FindAnyNs('infNFSe');

            NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('Numero'), tcStr);
            ANode := ANode.Childrens.FindAnyNs('DPS');
            ANode := ANode.Childrens.FindAnyNs('infDPS');
            NumRps := ObterConteudoTag(ANode.Childrens.FindAnyNs('nDPS'), tcStr);

            ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

            ANota := CarregarXmlNfse(ANota, DocumentXml.Root.OuterXml);
            SalvarXmlNfse(ANota);
          except
            on E:Exception do
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Cod999;
              AErro.Descricao := Desc999 + E.Message;
            end;
          end;
        finally
          FreeAndNil(DocumentXml);
        end;
      except
        on E:Exception do
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod999;
          AErro.Descricao := Desc999 + E.Message;
        end;
      end;
    finally
      FreeAndNil(Document);
    end;
  end
  else
  begin
    Response.ArquivoRetorno := RemoverDeclaracaoXML(Response.ArquivoRetorno);
    SalvarPDFNfse(Response.InfConsultaNFSe.NumeroIniNFSe, Response.ArquivoRetorno);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.PrepararEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
var
  AErro: TNFSeEventoCollectionItem;
  xEvento, xUF, xAutorEvento, IdAttr, xCamposEvento: string;
begin
  with Response.InfEvento.pedRegEvento do
  begin
    if chNFSe = '' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod004;
      AErro.Descricao := Desc004;
    end;

    if Response.Erros.Count > 0 then Exit;

    xUF := TACBrNFSeX(FAOwner).Configuracoes.WebServices.UF;

    if Length(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ) < 14 then
    begin
      xAutorEvento := '<CPFAutor>' +
                        TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ +
                      '</CPFAutor>';
    end
    else
    begin
      xAutorEvento := '<CNPJAutor>' +
                        TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.CNPJ +
                      '</CNPJAutor>';
    end;

    ID := chNFSe + OnlyNumber(tpEventoToStr(tpEvento)) +
              FormatFloat('000', nPedRegEvento);

    IdAttr := 'Id="' + 'PRE' + ID + '"';

    case tpEvento of
      teCancelamento:
        xCamposEvento := '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>';

      teCancelamentoSubstituicao:
        xCamposEvento := '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '<chSubstituta>' + chSubstituta + '</chSubstituta>';

      teAnaliseParaCancelamento:
        xCamposEvento := '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                         '<xMotivo>' + xMotivo + '</xMotivo>';

      teRejeicaoPrestador:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';

      teRejeicaoTomador:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';

      teRejeicaoIntermediario:
        xCamposEvento := '<infRej>' +
                           '<cMotivo>' + IntToStr(cMotivo) + '</cMotivo>' +
                           '<xMotivo>' + xMotivo + '</xMotivo>' +
                         '</infRej>';
    else
      // teConfirmacaoPrestador, teConfirmacaoTomador,
      // ConfirmacaoIntermediario e teConfirmacaoTacita
      xCamposEvento := '';
    end;

    xEvento := '<pedRegEvento xmlns="' + ConfigMsgDados.EnviarEvento.xmlns +
                           '" versao="' + ConfigWebServices.VersaoAtrib + '">' +
                 '<infPedReg ' + IdAttr + '>' +
                   '<tpAmb>' + IntToStr(tpAmb) + '</tpAmb>' +
                   '<verAplic>' + verAplic + '</verAplic>' +
                   '<dhEvento>' +
                     FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', dhEvento) +
                     GetUTC(xUF, dhEvento) +
                   '</dhEvento>' +
                   xAutorEvento +
                   '<chNFSe>' + chNFSe + '</chNFSe>' +
                   '<nPedRegEvento>' +
                     FormatFloat('000', nPedRegEvento) +
                   '</nPedRegEvento>' +
                   '<' + tpEventoToStr(tpEvento) + '>' +
                     '<xDesc>' + tpEventoToDesc(tpEvento) + '</xDesc>' +
                     xCamposEvento +
                   '</' + tpEventoToStr(tpEvento) + '>' +
                 '</infPedReg>' +
               '</pedRegEvento>';

    xEvento := AplicarXMLtoUTF8(xEvento);
    xEvento := AplicarLineBreak(xEvento, '');

    Response.ArquivoEnvio := xEvento;
    FpChave := chNFSe;

    SalvarXmlEvento(ID + '-pedRegEvento', Response.ArquivoEnvio);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.TratarRetornoEnviarEvento(
  Response: TNFSeEnviarEventoResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  EventoXml, IDEvento: string;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  Ok: Boolean;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := Desc201;
    Exit
  end;

  Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

  try
    try
      ProcessarMensagemDeErros(Document, Response);
      Response.Sucesso := (Response.Erros.Count = 0);

      Response.Data := Document.AsISODateTime['dataHoraProcessamento'];

      EventoXml := Document.AsString['eventoXmlGZipB64'];

      if EventoXml <> '' then
      begin
        EventoXml := DeCompress(DecodeBase64(EventoXml));

        DocumentXml := TACBrXmlDocument.Create;

        try
          try
            if EventoXml = '' then
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Cod211;
              AErro.Descricao := Desc211;
              Exit
            end;

            DocumentXml.LoadFromXml(EventoXml);

            ANode := DocumentXml.Root.Childrens.FindAnyNs('infEvento');

            IDEvento := OnlyNumber(ObterConteudoTag(ANode.Attributes.Items['Id']));

            Response.nSeqEvento := ObterConteudoTag(ANode.Childrens.FindAnyNs('nSeqEvento'), tcInt);
            Response.Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dhProc'), tcDatHor);
            Response.idEvento := IDEvento;
            Response.tpEvento := StrTotpEvento(Ok, Copy(IDEvento, 51, 6));

            ANode := ANode.Childrens.FindAnyNs('pedRegEvento');
            ANode := ANode.Childrens.FindAnyNs('infPedReg');

            Response.idNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('chNFSe'), tcStr);

            SalvarXmlEvento(IDEvento + '-procEveNFSe', EventoXml);
          except
            on E:Exception do
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Cod999;
              AErro.Descricao := Desc999 + E.Message;
            end;
          end;
        finally
          FreeAndNil(DocumentXml);
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderPadraoNacional.ValidarSchema(
  Response: TNFSeWebserviceResponse; aMetodo: TMetodo);
begin
  if aMetodo in [tmGerar, tmEnviarEvento] then
  begin
    inherited ValidarSchema(Response, aMetodo);

    Response.ArquivoEnvio := AplicarLineBreak(Response.ArquivoEnvio, '');
    Response.ArquivoEnvio := EncodeBase64(GZipCompress(Response.ArquivoEnvio));

    case aMetodo of
      tmGerar:
        begin
          Response.ArquivoEnvio := '{"dpsXmlGZipB64":"' + Response.ArquivoEnvio + '"}';
          FpPath := '/nfse';
        end;

      tmEnviarEvento:
        begin
          Response.ArquivoEnvio := '{"pedidoRegistroEventoXmlGZipB64":"' + Response.ArquivoEnvio + '"}';
          FpPath := '/nfse/' + FpChave + '/eventos';
        end;
    end;

    FpMethod := 'POST';
  end;
end;

function TACBrNFSeProviderPadraoNacional.RegimeEspecialTributacaoToStr(
  const t: TnfseRegimeEspecialTributacao): string;
begin
  Result := EnumeradoToStr(t,
                         ['0', '1', '2', '3', '4', '5', '6'],
                         [retNenhum, retCooperativa, retEstimativa,
                         retMicroempresaMunicipal, retNotarioRegistrador,
                         retISSQNAutonomos, retSociedadeProfissionais]);
end;

function TACBrNFSeProviderPadraoNacional.StrToRegimeEspecialTributacao(
  out ok: boolean; const s: string): TnfseRegimeEspecialTributacao;
begin
  Result := StrToEnumerado(ok, s,
                        ['0', '1', '2', '3', '4', '5', '6'],
                        [retNenhum, retCooperativa, retEstimativa,
                         retMicroempresaMunicipal, retNotarioRegistrador,
                         retISSQNAutonomos, retSociedadeProfissionais]);
end;

function TACBrNFSeProviderPadraoNacional.RegimeEspecialTributacaoDescricao(
  const t: TnfseRegimeEspecialTributacao): string;
begin
  case t of
    retNenhum:                 Result := '0 - Nenhum';
    retCooperativa:            Result := '1 - Cooperativa';
    retEstimativa:             Result := '2 - Estimativa';
    retMicroempresaMunicipal:  Result := '3 - Microempresa Municipal';
    retNotarioRegistrador:     Result := '4 - Not�rio ou Registrador';
    retISSQNAutonomos:         Result := '5 - Profissional Aut�nomo';
    retSociedadeProfissionais: Result := '6 - Sociedade de Profissionais';
  else
    Result := '';
  end;
end;

{ TACBrNFSeXWebservicePadraoNacional }

function TACBrNFSeXWebservicePadraoNacional.GerarNFSe(ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebservicePadraoNacional.ConsultarNFSe(ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebservicePadraoNacional.ConsultarNFSePorRps(ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebservicePadraoNacional.EnviarEvento(ACabecalho,
  AMSG: string): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebservicePadraoNacional.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);
end;

end.
