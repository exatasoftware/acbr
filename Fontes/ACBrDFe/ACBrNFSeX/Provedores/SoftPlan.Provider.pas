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

unit SoftPlan.Provider;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrXmlBase, ACBrXmlDocument, ACBrJSON,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSoftPlan = class(TACBrNFSeXWebserviceRest)
  private
    FpMetodo: TMetodo;
  protected
    procedure SetHeaders(aHeaderReq: THTTPHeader); override;

  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function GerarToken(ACabecalho, AMSG: String): string; override;
    function ConsultarDFe(ACabecalho, AMSG: string): string; override;

  end;

  TACBrNFSeProviderSoftPlan = class (TACBrNFSeProviderProprio)
  private
    FpPath: string;
    FpMethod: string;
    FpMimeType: string;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'message';
                                     const AMessageTag: string = ''); override;

    procedure ProcessarMensagemDeErros(LJson: TACBrJSONObject;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'erros');

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararGerarToken(Response: TNFSeGerarTokenResponse); override;
    procedure TratarRetornoGerarToken(Response: TNFSeGerarTokenResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararConsultarDFe(Response: TNFSeConsultarDFeResponse); override;
    procedure TratarRetornoConsultarDFe(Response: TNFSeConsultarDFeResponse); override;
  end;

implementation

uses
  synacode,
  ACBrDFeException, ACBrUtil.Base, ACBrUtil.FilesIO, ACBrUtil.Strings,
  ACBrNFSeX, ACBrNFSeXNotasFiscais, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  SoftPlan.GravarXml, SoftPlan.LerXml;

{ TACBrNFSeProviderSoftPlan }

procedure TACBrNFSeProviderSoftPlan.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;
    Identificador := '';
  end;

  with ConfigAssinar do
  begin
    RpsGerarNFSe := True;
    CancelarNFSe := True;
  end;

  with ConfigMsgDados do
  begin
    with XmlRps do
    begin
      InfElemento := 'xmlProcessamentoNfpse';
      DocElemento := 'xmlProcessamentoNfpse';
    end;

    with CancelarNFSe do
    begin
      InfElemento := 'xmlCancelamentoNfpse';
      DocElemento := 'xmlCancelamentoNfpse';
    end;
  end;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSoftPlan.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SoftPlan.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSoftPlan.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SoftPlan.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSoftPlan.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
  begin
    URL := URL + FpPath;
    Result := TACBrNFSeXWebserviceSoftPlan.Create(FAOwner, AMetodo, URL,
      FpMethod, FpMimeType);
  end
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSoftPlan.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse; const AListTag,
  AMessageTag: string);
var
//  I: Integer;
  ANode: TACBrXmlNode;
//  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if ANode <> nil then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '';
    AErro.Descricao := ACBrStr(ANode.AsString);
    AErro.Correcao := '';
  end;
  {
  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '';
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('ERRO'), tcStr);
    AErro.Correcao := '';
  end;
  }
end;

procedure TACBrNFSeProviderSoftPlan.ProcessarMensagemDeErros(
  LJson: TACBrJSONObject; Response: TNFSeWebserviceResponse;
  const AListTag: string);
var
  Codigo, Descricao: string;
  AErro: TNFSeEventoCollectionItem;
begin
  Codigo := '';
  Descricao := '';
  LJson.Value('error', Codigo);
  LJson.Value('error_description', Descricao);

  AErro := Response.Erros.New;
  AErro.Codigo := Codigo;
  AErro.Descricao := ACBrStr(Descricao);
  AErro.Correcao := '';
end;

procedure TACBrNFSeProviderSoftPlan.PrepararEmitir(
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
    AErro.Descricao := ACBrStr(Desc002);
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > Response.MaxRps then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod003;
    AErro.Descricao := ACBrStr('Conjunto de DPS transmitidos (m�ximo de ' +
                       IntToStr(Response.MaxRps) + ' DPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count));
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

  FpMimeType := 'application/xml';
  FpPath := '/processamento/notas/processa';
  FpMethod := 'POST';
end;

procedure TACBrNFSeProviderSoftPlan.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  if StringIsXml(Response.ArquivoRetorno) then
  begin
    DocumentXml := TACBrXmlDocument.Create;

    try
      try
        if Response.ArquivoRetorno = '' then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit
        end;

        DocumentXml.LoadFromXml(Response.ArquivoRetorno);

        ANode := DocumentXml.Root;

        ProcessarMensagemErros(ANode, Response);
        Response.Sucesso := (Response.Erros.Count = 0);

        if Response.Sucesso then
        begin
          with Response do
          begin
            CodVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);
            Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dataEmissao'), tcDat);
            DataCanc := ObterConteudoTag(ANode.Childrens.FindAnyNs('dataCancelamento'), tcDat);
            DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('motivoCancelamento'), tcStr);
            NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('numeroSerie'), tcStr);
          end;

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(Response.NumeroNota);

          ANota := CarregarXmlNfse(ANota, DocumentXml.Root.OuterXml);
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
      FreeAndNil(DocumentXml);
    end;
  end
  else
  begin
    Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

    try
      try
        ProcessarMensagemDeErros(Document, Response);
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
end;

procedure TACBrNFSeProviderSoftPlan.PrepararGerarToken(
  Response: TNFSeGerarTokenResponse);
begin
  FpPath := '/autenticacao/oauth/token';

  with TACBrNFSeX(FAOwner).Configuracoes.Geral do
  begin
    FpPath := FpPath + '?grant_type=password';
    FpPath := FpPath + '&username=' + Emitente.WSUser;
    FpPath := FpPath + '&password=' + Emitente.WSSenha;
    FpPath := FpPath + '&client_id=' + Emitente.WSChaveAcesso;
    FpPath := FpPath + '&client_secret=' + Emitente.WSFraseSecr;
  end;

  FpMimeType := 'application/x-www-form-urlencoded';
  FpMethod := 'POST';

  Response.Clear;
end;

procedure TACBrNFSeProviderSoftPlan.TratarRetornoGerarToken(
  Response: TNFSeGerarTokenResponse);
var
  AErro: TNFSeEventoCollectionItem;
  json: TACBrJsonObject;
begin
  try
    if (Copy(Response.ArquivoRetorno, 1, 1) = '{') then
    begin
      json := TACBrJsonObject.Parse(Response.ArquivoRetorno);
      try
        if (json.AsString['access_token'] <> '') then
        begin
          Response.Token := json.AsString['access_token'];
        end;

        if (json.AsString['error'] <> '') then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod999;
          AErro.Descricao := ACBrStr(json.AsString['error']);
          AErro.Correcao := ACBrStr(json.AsString['error_description']);
        end;
      finally
        json.Free;
      end;
    end
    else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod212;
      AErro.Descricao := ACBrStr(Desc212);
      AErro.Correcao := ACBrStr(Response.ArquivoRetorno);
    end;
  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod999;
      AErro.Descricao := ACBrStr(Desc999 + E.Message);
    end;
  end;

  Response.Sucesso := (Response.Erros.Count = 0);
end;

procedure TACBrNFSeProviderSoftPlan.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := ACBrStr(Desc110);
    Exit;
  end;

  if EstaVazio(Emitente.WSChaveAutoriz) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod125;
    AErro.Descricao := ACBrStr(Desc125);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodVerificacao) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod117;
    AErro.Descricao := ACBrStr(Desc117);
    Exit;
  end;

  // AEDF = Autoriza��o para emiss�o de documentos fiscais eletr�nicos.
  Response.ArquivoEnvio := '<xmlCancelamentoNfpse>' +
                             '<motivoCancelamento>' +
                                Response.InfCancelamento.MotCancelamento +
                             '</motivoCancelamento>' +
                             '<nuAedf>' +
                                Emitente.WSChaveAutoriz +
                             '</nuAedf>' +
                             '<nuNotaFiscal>' +
                                Response.InfCancelamento.NumeroNFSe +
                             '</nuNotaFiscal>' +
                             '<codigoVerificacao>' +
                                Response.InfCancelamento.CodVerificacao +
                             '</codigoVerificacao>' +
                           '</xmlCancelamentoNfpse>';

  FpMimeType := 'application/xml';
  FpPath := '/cancelamento/notas/cancela';
  FpMethod := 'POST';
end;

procedure TACBrNFSeProviderSoftPlan.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrJSONObject;
  AErro: TNFSeEventoCollectionItem;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  ANota: TNotaFiscal;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  if StringIsXml(Response.ArquivoRetorno) then
  begin
    DocumentXml := TACBrXmlDocument.Create;

    try
      try
        if Response.ArquivoRetorno = '' then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod203;
          AErro.Descricao := ACBrStr(Desc203);
          Exit
        end;

        DocumentXml.LoadFromXml(Response.ArquivoRetorno);

        ANode := DocumentXml.Root;

        ProcessarMensagemErros(ANode, Response);
        Response.Sucesso := (Response.Erros.Count = 0);

        if Response.Sucesso then
        begin
          with Response do
          begin
            CodVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);
            Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('dataEmissao'), tcDat);
            DataCanc := ObterConteudoTag(ANode.Childrens.FindAnyNs('dataCancelamento'), tcDat);
            DescSituacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('motivoCancelamento'), tcStr);
            NumeroNota := ObterConteudoTag(ANode.Childrens.FindAnyNs('identificacao'), tcStr);
          end;

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(Response.NumeroNota);

          ANota := CarregarXmlNfse(ANota, DocumentXml.Root.OuterXml);
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
      FreeAndNil(DocumentXml);
    end;
  end
  else
  begin
    Document := TACBrJsonObject.Parse(Response.ArquivoRetorno);

    try
      try
        ProcessarMensagemDeErros(Document, Response);
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
end;

procedure TACBrNFSeProviderSoftPlan.PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorCodigoVerificacao:
    begin
      if EstaVazio(Response.InfConsultaNFSe.CodVerificacao) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod117;
        AErro.Descricao := ACBrStr(Desc117);
        Exit;
      end;

      FpPath :=
        '/consultas/notas/codigo' +
        '/' + Response.InfConsultaNFSe.CodVerificacao +
        '/' + OnlyNumber(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.InscMun);
    end;

    tcPorNumero:
    begin
      if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod108;
        AErro.Descricao := ACBrStr(Desc108);
        Exit;
      end;

      FpPath := '/consultas/notas/numero/' + Response.InfConsultaNFSe.NumeroIniNFSe;
    end
  else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod001;
      AErro.Descricao := ACBrStr(Desc001 + #13 + 'Consulta por ' +
                          tpConsultaToStr(Response.InfConsultaNFSe.tpConsulta));
    end;
  end;

  FpMethod := 'GET';
end;

procedure TACBrNFSeProviderSoftPlan.TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  json: TACBrJsonObject;
  idNFSe: Integer;

  procedure LerJson(AJson: TACBrJsonObject);
  begin
    idNFSe := AJson.AsInteger['id'];
    Response.CodVerif := AJson.AsString['cdVerificacao'];
    Response.Data := AJson.AsISODateTime['dataEmissao'];
    Response.DataCanc := AJson.AsISODateTime['dataCancelamento'];
    Response.DescSituacao := AJson.AsString['motivoCancelamento'];
    Response.NumeroNota := AJson.AsString['numero'];
  end;

  procedure DownloadXML;
  begin
    with TACBrNFSeX(FAOwner) do
    begin
      ConsultarDFe(idNFSe);

      if (WebService.ConsultarDFe.Sucesso and (WebService.ConsultarDFe.Erros.Count = 0)) then
      begin
        Response.XmlRetorno := WebService.ConsultarDFe.XmlRetorno;
      end;
    end;
  end;

begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  try
    if (Copy(Response.ArquivoRetorno, 1, 1) <> '{') then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod212;
      AErro.Descricao := ACBrStr(Desc212);
      Exit

//      raise Exception.Create(Response.ArquivoRetorno);
    end;

    json := TACBrJsonObject.Parse(Response.ArquivoRetorno);
    try
      if (json.AsJSONArray['notas'].Count > 0) then
        LerJson(json.AsJSONArray['notas'].ItemAsJSONObject[0])
      else
        LerJson(json);
    finally
      json.Free;
    end;

    DownloadXML;
  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod999;
      AErro.Descricao := ACBrStr(Desc999 + E.Message);
    end;
  end;

  Response.Sucesso := Response.Erros.Count = 0;
end;

procedure TACBrNFSeProviderSoftPlan.PrepararConsultarDFe(Response: TNFSeConsultarDFeResponse);
var
  AErro: TNFSeEventoCollectionItem;
begin
  if Response.NSU = -1 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod128;
    AErro.Descricao := ACBrStr(Desc128);
    Exit;
  end;

  FpPath :=
    '/consultas/notas/xml' +
    '/' + IntToStr(Response.NSU) +
    '/' + OnlyNumber(TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente.InscMun);

  FpMethod := 'GET';
  FpMimeType := 'application/xml';
end;

procedure TACBrNFSeProviderSoftPlan.TratarRetornoConsultarDFe(Response: TNFSeConsultarDFeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  ANota: TNotaFiscal;
  DocumentXml: TACBrXmlDocument;
  ANode: TACBrXmlNode;
begin
  if Response.ArquivoRetorno = '' then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod201;
    AErro.Descricao := ACBrStr(Desc201);
    Exit
  end;

  try
    if (StringIsXml(Response.ArquivoRetorno)) then
    begin
      DocumentXml := TACBrXmlDocument.Create;
      try
        DocumentXml.LoadFromXml(Response.ArquivoRetorno);

        ANode := DocumentXml.Root;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(Response.NumeroNota);
        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);

        SalvarXmlNfse(ANota);
      finally
        DocumentXml.Free;
      end;
    end
    else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod203;
      AErro.Descricao := ACBrStr(Desc203);
//      raise Exception.Create(Response.ArquivoRetorno);
    end;

  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := Cod999;
      AErro.Descricao := ACBrStr(Desc999 + E.Message);
    end;
  end;

  Response.Sucesso := Response.Erros.Count = 0;
end;

{ TACBrNFSeXWebserviceSoftPlan }

procedure TACBrNFSeXWebserviceSoftPlan.SetHeaders(aHeaderReq: THTTPHeader);
var
  Auth: string;
begin
  if (FpMetodo = tmGerarToken) then
  begin
    with TConfiguracoesNFSe(FPConfiguracoes).Geral do
      Auth := Emitente.WSChaveAcesso + ':' + Emitente.WSFraseSecr;
    Auth := 'Basic ' + String(EncodeBase64(AnsiString(Auth)));

    aHeaderReq.AddHeader('Authorization', Auth);
  end
  else
  begin
    Auth := 'Bearer ' + TACBrNFSeX(FPDFeOwner).WebService.GerarToken.Token;

    aHeaderReq.AddHeader('Authorization', Auth);
    aHeaderReq.AddHeader('Connection', 'keep-alive');
    aHeaderReq.AddHeader('Accept', '*/*');
  end;
end;

function TACBrNFSeXWebserviceSoftPlan.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FpMetodo := tmGerar;
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceSoftPlan.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FpMetodo := tmConsultarNFSe;
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceSoftPlan.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FpMetodo := tmCancelarNFSe;
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceSoftPlan.GerarToken(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FpMetodo := tmGerarToken;
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

function TACBrNFSeXWebserviceSoftPlan.ConsultarDFe(ACabecalho, AMSG: string): string;
var
  Request: string;
begin
  FpMetodo := tmConsultarDFe;
  FPMsgOrig := AMSG;

  Request := AMSG;

  Result := Executar('', Request, [], []);
end;

end.
