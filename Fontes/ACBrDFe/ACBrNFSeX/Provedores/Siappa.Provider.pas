{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Tanchela Rubinho                         }
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

unit Siappa.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSiappa = class(TACBrNFSeXWebserviceSoap11)
  public
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function GerarToken(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderSiappa = class (TACBrNFSeProviderProprio)
  private
    function GetOpcExecucao: string;
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararGerarToken(Response: TNFSeGerarTokenResponse); override;
    procedure TratarRetornoGerarToken(Response: TNFSeGerarTokenResponse); override;

    function AplicarLineBreak(AXMLRps: String; const ABreak: String): String; override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = ''); override;
  public
    property DadosOpcExecucao: string read GetOpcExecucao;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Siappa.GravarXml, Siappa.LerXml, ACBrNFSeXProviderBase;

{ TACBrNFSeProviderSiappa }

function TACBrNFSeProviderSiappa.GetOpcExecucao: string;
begin
  // (T)estes ou (D)efinitivo
  if ConfigGeral.Ambiente = taHomologacao then
    Result := 'T'
  else
    Result := 'D';
end;

procedure TACBrNFSeProviderSiappa.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meLoteSincrono;
  end;
                               
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSiappa.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Siappa.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiappa.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Siappa.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSiappa.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSiappa.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSiappa.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
var
  I: Integer;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  vDescricao: string;
  vRetorno: string;
begin
  ANodeArray := RootNode.Childrens.FindAllAnyNs(AListTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    // O AMessageTag recebe o prefixo das tags de retorno, pois eles variam entre os m�todos
    vDescricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs(AMessageTag + '_out_msg_retorno'), tcStr);

    vRetorno := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs(AMessageTag + '_out_status_retorno'), tcStr);

    // Se o retorno estiver em branco, verifica se � o token foi gerado
    if vRetorno = '' then
    begin
      vRetorno := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs(AMessageTag + '_out_token'), tcStr);

      if vRetorno = '' then
        vRetorno := 'N';
    end;

    if (vRetorno = 'N') then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs(AMessageTag + '_out_codigo_retorno'), tcStr);
      AErro.Descricao := vDescricao;
      AErro.Correcao := '';
    end;
  end;
end;

function TACBrNFSeProviderSiappa.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderSiappa.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := Params.Xml;
end;

procedure TACBrNFSeProviderSiappa.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
  xSucesso: string;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'Sdt_ws_001_out_gera_nfse_token', 'ws_001');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Sdt_ws_001_out_gera_nfse_token');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          xSucesso := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_001_out_status_retorno'), tcStr);
          Sucesso := (xSucesso = 'S');

          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_001_out_nfse_numero'), tcStr);
          Data := EncodeDataHora( ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_001_out_nfse_data_hora'), tcStr),
                                  'DD/MM/YYYY HH:NN:SS' );
          CodVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_001_out_nfse_cod_validacao'), tcStr);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_001_out_nfse_url_emissao'), tcStr);
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

procedure TACBrNFSeProviderSiappa.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if Response.InfConsultaNFSe.DataInicial = 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod115;
    AErro.Descricao := Desc115;
    Exit;
  end;

  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
    Exit;
  end;

  if EstaVazio(Response.InfConsultaNFSe.CodServ) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod123;
    AErro.Descricao := Desc123;
    Exit;
  end;

  if EstaVazio(Response.InfConsultaNFSe.CodVerificacao) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod117;
    AErro.Descricao := Desc117;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSe;

  // Aten��o: Neste xml apenas o "Sdt_" da tag raiz deve ter o primeiro "S" em mai�sculo
  Response.ArquivoEnvio := '<Sdt_ws_003_in_cons_nfse_token>' +
                           '<ws_003_in_prest_insc_seq>' +
                           Emitente.WSUser +
                           '</ws_003_in_prest_insc_seq>' +
                           '<ws_003_in_prest_cnpj>' +
                           OnlyNumber(Emitente.CNPJ) +
                           '</ws_003_in_prest_cnpj>' +
                           '<ws_003_in_prest_ws_senha>' +
                           Emitente.WSSenha +
                           '</ws_003_in_prest_ws_senha>' +
                           '<ws_003_in_prest_ws_token>' +
                           Emitente.WSChaveAutoriz +
                           '</ws_003_in_prest_ws_token>' +
                           '<ws_003_in_nfse_ano>' +
                           FormatDateTime('YYYY', Response.InfConsultaNFSe.DataInicial) +
                           '</ws_003_in_nfse_ano>' +
                           '<ws_003_in_nfse_mes>' +
                           FormatDateTime('MM', Response.InfConsultaNFSe.DataInicial) +
                           '</ws_003_in_nfse_mes>' +
                           '<ws_003_in_nfse_numero>' +
                           Response.InfConsultaNFSe.NumeroIniNFSe +
                           '</ws_003_in_nfse_numero>' +
                           '<ws_003_in_nfse_cod_especie>' +
                           '10' +
                           '</ws_003_in_nfse_cod_especie>' +
                           '<ws_003_in_nfse_cod_atividade>' +
                           Response.InfConsultaNFSe.CodServ +
                           '</ws_003_in_nfse_cod_atividade>' +
                           '<ws_003_in_nfse_cod_validacao>' +
                           Response.InfConsultaNFSe.CodVerificacao +
                           '</ws_003_in_nfse_cod_validacao>' +
                           '<ws_003_in_nfse_opcao_envio_e_mail>' +
                           'N' +
                           '</ws_003_in_nfse_opcao_envio_e_mail>' +
                           '<ws_003_in_opcao_execucao>' +
                           DadosOpcExecucao +
                           '</ws_003_in_opcao_execucao>' +
                           '</Sdt_ws_003_in_cons_nfse_token>';
end;

procedure TACBrNFSeProviderSiappa.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  i: Integer;
  NumNFSe: String;
  ANota: TNotaFiscal;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'Sdt_ws_003_out_cons_nfse_token', 'ws_003');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := nil;
      
      if Assigned(ANode) then
        ANodeArray := ANode.Childrens.FindAllAnyNs('Sdt_ws_003_out_cons_nfse_token');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + 'Webservice n�o retornou informa��es';
        Exit;
      end;

      for i := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[i];

        NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('ws_003_out_nfse_numero'), tcStr);
        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        ANota := CarregarXmlNfse(ANota, ANode.OuterXml);

        with Response do
        begin
          NumeroNota := NumNFSe;
          Data := EncodeDataHora( ObterConteudoTag(ANode.Childrens.FindAnyNs('ws_003_out_nfse_data_hora'), tcStr),
                                  'DD/MM/YYYY HH:NN:SS' );
          Link := ObterConteudoTag(ANode.Childrens.FindAnyNs('ws_003_out_nfse_url_emissao'), tcStr);
        end;

        if Assigned(ANota) then
        begin
          if ANota.NFSe.Numero = '' then
            ANota.NFSe.Numero := Response.NumeroNota;

          if ANota.NFSe.Link = '' then
            ANota.NFSe.Link := Response.Link;

          if ANota.NFSe.CodigoVerificacao = '' then
            ANota.NFSe.CodigoVerificacao := ObterConteudoTag(ANode.Childrens.FindAnyNs('ws_003_out_nfse_cod_validacao'), tcStr);

          ANota.NFSe.StatusRps := srNormal;
          ANota.NFSe.SituacaoNfse := snNormal;

          if Pos('nfs-e de teste est� cancelada', ObterConteudoTag(ANode.Childrens.FindAnyNs('ws_003_out_msg_retorno'), tcStr)) > 0 then
          begin
            ANota.NFSe.StatusRps := srCancelado;
            ANota.NFSe.SituacaoNfse := snCancelado;
          end;
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

procedure TACBrNFSeProviderSiappa.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if Response.InfCancelamento.DataEmissaoNFSe = 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod122;
    AErro.Descricao := Desc122;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodServ) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod123;
    AErro.Descricao := Desc123;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodVerificacao) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod117;
    AErro.Descricao := Desc117;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  // Aten��o: Neste xml apenas o "Sdt_" da tag raiz deve ter o primeiro "S" em mai�sculo
  Response.ArquivoEnvio := '<Sdt_ws_002_in_canc_nfse_token>' +
                           '<ws_002_in_prest_insc_seq>' +
                           Emitente.WSUser +
                           '</ws_002_in_prest_insc_seq>' +
                           '<ws_002_in_prest_cnpj>' +
                           OnlyNumber(Emitente.CNPJ) +
                           '</ws_002_in_prest_cnpj>' +
                           '<ws_002_in_prest_ws_senha>' +
                           Emitente.WSSenha +
                           '</ws_002_in_prest_ws_senha>' +
                           '<ws_002_in_prest_ws_token>' +
                           Emitente.WSChaveAutoriz +
                           '</ws_002_in_prest_ws_token>' +
                           '<ws_002_in_nfse_ano>' +
                           FormatDateTime('YYYY', Response.InfCancelamento.DataEmissaoNFSe) +
                           '</ws_002_in_nfse_ano>' +
                           '<ws_002_in_nfse_mes>' +
                           FormatDateTime('MM', Response.InfCancelamento.DataEmissaoNFSe) +
                           '</ws_002_in_nfse_mes>' +
                           '<ws_002_in_nfse_numero>' +
                           Response.InfCancelamento.NumeroNFSe +
                           '</ws_002_in_nfse_numero>' +
                           '<ws_002_in_nfse_cod_especie>' +
                           '10' +
                           '</ws_002_in_nfse_cod_especie>' +
                           '<ws_002_in_nfse_cod_atividade>' +
                           Response.InfCancelamento.CodServ +
                           '</ws_002_in_nfse_cod_atividade>' +
                           '<ws_002_in_nfse_cod_validacao>' +
                           Response.InfCancelamento.CodVerificacao +
                           '</ws_002_in_nfse_cod_validacao>' +
                           '<ws_002_in_opcao_execucao>' +
                           DadosOpcExecucao +
                           '</ws_002_in_opcao_execucao>' +
                           '</Sdt_ws_002_in_canc_nfse_token>';
end;

procedure TACBrNFSeProviderSiappa.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
  xSucesso: string;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'Sdt_ws_002_out_canc_nfse_token', 'ws_002');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('Sdt_ws_002_out_canc_nfse_token');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + 'Webservice n�o retornou informa��es';
        Exit;
      end;

      if AuxNode <> nil then
      begin
        with Response do
        begin
          xSucesso := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_002_out_status_retorno'), tcStr);
          Sucesso := (xSucesso = 'S');

          RetCancelamento.MsgCanc := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('ws_002_out_msg_retorno'), tcStr);

          if Sucesso then
            RetCancelamento.DataHora := Date;
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

procedure TACBrNFSeProviderSiappa.PrepararGerarToken(
  Response: TNFSeGerarTokenResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Response.Clear;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  // Aten��o: Neste xml todos os "Ws_" do in�cio das tags devem ter o primeiro "W" em mai�sculo
  Response.ArquivoEnvio := '<Ws_000_in_prest_insc_seq>' +
                           Emitente.WSUser +
                           '</Ws_000_in_prest_insc_seq>' +
                           '<Ws_000_in_prest_cnpj>' +
                           OnlyNumber(Emitente.CNPJ) +
                           '</Ws_000_in_prest_cnpj>' +
                           '<Ws_000_in_prest_ws_senha>' +
                           Emitente.WSSenha +
                           '</Ws_000_in_prest_ws_senha>' +
                           '<Ws_000_in_opc_execucao>' +
                           DadosOpcExecucao +
                           '</Ws_000_in_opc_execucao>';
end;

procedure TACBrNFSeProviderSiappa.TratarRetornoGerarToken(
  Response: TNFSeGerarTokenResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml('<retorno>' +
                           Response.ArquivoRetorno +
                           '</retorno>');

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'ws_gera_token.ExecuteResponse', 'Ws_000');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('ws_gera_token.ExecuteResponse');

      if not Assigned(AuxNode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Token := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Ws_000_out_token'), tcStr);

          DataExpiracao := EncodeDataHora( ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Ws_000_out_data_expiracao'), tcStr),
                                           'DD/MM/YYYY HH:NN' );

          Sucesso := (Token <> '');
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

function TACBrNFSeProviderSiappa.AplicarLineBreak(AXMLRps: String;
  const ABreak: String): String;
begin
  Result := AXMLRps;
  if Trim(Result) <> '' then
  begin
    Result := ChangeLineBreak(AXMLRps, '&#10;');
    Result := StringReplace(Result, '&amp;#10;', '&#10;', [rfReplaceAll]);
  end;
end;

{ TACBrNFSeXWebserviceSiappa }

function TACBrNFSeXWebserviceSiappa.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws_gera_nfse_token.Execute xmlns="issqnwebev3v2">';
  Request := Request + AMSG;
  Request := Request + '</ws_gera_nfse_token.Execute>';

  Result := Executar('', Request, ['ws_gera_nfse_token.ExecuteResponse'], []);
end;

function TACBrNFSeXWebserviceSiappa.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws_consulta_nfse_token.Execute xmlns="issqnwebev3v2">';
  Request := Request + AMSG;
  Request := Request + '</ws_consulta_nfse_token.Execute>';

  Result := Executar('', Request, ['ws_consulta_nfse_token.ExecuteResponse'], []);
end;

function TACBrNFSeXWebserviceSiappa.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws_cancela_nfse_token.Execute xmlns="issqnwebev3v2">';
  Request := Request + AMSG;
  Request := Request + '</ws_cancela_nfse_token.Execute>';

  Result := Executar('', Request, ['ws_cancela_nfse_token.ExecuteResponse'], []);
end;

function TACBrNFSeXWebserviceSiappa.GerarToken(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<ws_gera_token.Execute xmlns="issqnwebev3v2">';
  Request := Request + AMSG;
  Request := Request + '</ws_gera_token.Execute>';

  Result := Executar('', Request, ['ws_gera_token.ExecuteResponse'], []);
end;

function TACBrNFSeXWebserviceSiappa.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := RemoverIdentacao(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
end;

end.
