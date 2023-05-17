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

unit SigISS.Provider;

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
  TACBrNFSeXWebserviceSigISS = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetSoapAction: string;
  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderSigISS = class (TACBrNFSeProviderProprio)
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

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = 'Erro'); override;

    function AjustarRetorno(const Retorno: string): string;
  end;

  TACBrNFSeXWebserviceSigISS103 = class(TACBrNFSeXWebserviceSigISS)
  public
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderSigISS103 = class (TACBrNFSeProviderSigISS)
  protected
    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
//    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
//    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  SigISS.GravarXml, SigISS.LerXml;

{ TACBrNFSeProviderSigISS }

procedure TACBrNFSeProviderSigISS.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    ModoEnvio := meUnitario;
    NumMaxRpsEnviar := 1;
  end;

  SetXmlNameSpace('urn:sigiss_ws');

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSigISS.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SigISS.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigISS.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SigISS.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigISS.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSigISS.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSigISS.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  Correcao: string;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('Mensagens');

  if (ANode = nil) then
    ANode := RootNode;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('DescricaoErro'), tcStr);

    if Correcao <> 'Sem erros' then
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('id'), tcStr);
      AErro.Descricao := ACBrStr(ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('DescricaoProcesso'), tcStr));
      AErro.Correcao := ACBrStr(Correcao);

      if AErro.Descricao = '' then
        AErro.Descricao := ACBrStr(ANodeArray[I].AsString);
    end;
  end;
end;

function TACBrNFSeProviderSigISS.AjustarRetorno(const Retorno: string): string;
begin
  Result := StringReplace(Retorno, ' xmlns:ns1="urn:sigiss_ws"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="tns:tcDadosNota"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="tns:tcRetornoNota"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="xsd:int"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="xsd:string"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="SOAP-ENC:Array" SOAP-ENC:arrayType="tns:tcEstruturaDescricaoErros[1]"', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' xsi:type="tns:tcEstruturaDescricaoErros"', '', [rfReplaceAll]);

  Result := StringReplace(Result, '&', '&amp;', [rfReplaceAll]);
end;

function TACBrNFSeProviderSigISS.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderSigISS.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Response.ArquivoEnvio := Params.Xml;
end;

procedure TACBrNFSeProviderSigISS.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
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

      Response.ArquivoRetorno := AjustarRetorno(Response.ArquivoRetorno);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'DescricaoErros', 'item');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('RetornoNota');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Resultado'), tcStr);
          Sucesso := (Situacao = '1');
          Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('autenticidade'), tcStr);
          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Nota'), tcStr);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('LinkImpressao'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
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

procedure TACBrNFSeProviderSigISS.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSe;

  Response.ArquivoEnvio := '<ConsultarNotaPrestador xmlns="urn:sigiss_ws">' +
                             '<DadosPrestador>' +
                               '<ccm>' + Trim(Emitente.InscMun) + '</ccm>' +
                               '<cnpj>' + Trim(Emitente.Cnpj) + '</cnpj>' +
                               '<senha>' + Trim(Emitente.WSSenha) + '</senha>' +
                             '</DadosPrestador>' +
                             '<Nota>' +
                               Response.InfConsultaNFSe.NumeroIniNFSe +
                             '</Nota>' +
                           '</ConsultarNotaPrestador>';
end;

procedure TACBrNFSeProviderSigISS.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  NumRps: String;
  ANota: TNotaFiscal;
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

      Response.ArquivoRetorno := AjustarRetorno(Response.ArquivoRetorno);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'DescricaoErros', 'item');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('DadosNota');

      if AuxNode <> nil then
      begin
        NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('num_rps'), tcStr);

        with Response do
        begin
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('StatusNFe'), tcStr);
          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('nota'), tcStr);
          CodigoVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('autenticidade'), tcStr);
          Protocolo := CodigoVerificacao;
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('LinkImpressao'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
          NumeroRps := NumRps;
        end;
      end;

      ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

      ANota := CarregarXmlNfse(ANota, ANode.OuterXml);
      SalvarXmlNfse(ANota);
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

procedure TACBrNFSeProviderSigISS.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
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

  Response.ArquivoEnvio := '<CancelarNota xmlns="urn:sigiss_ws">' +
                             '<DadosCancelaNota>' +
                               '<ccm>' + Trim(Emitente.InscMun) + '</ccm>' +
                               '<cnpj>' + Trim(Emitente.Cnpj) + '</cnpj>' +
                               '<senha>' + Trim(Emitente.WSSenha) + '</senha>' +
                               '<nota>' +
                                 Response.InfCancelamento.NumeroNFSe +
                               '</nota>' +
                               '<motivo>' +
                                 Response.InfCancelamento.MotCancelamento +
                               '</motivo>' +
                               '<email>' +
                                 Response.InfCancelamento.email +
                               '</email>' +
                             '</DadosCancelaNota>' +
                           '</CancelarNota>';
end;

procedure TACBrNFSeProviderSigISS.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
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
        AErro.Descricao := ACBrStr(Desc201);
        Exit
      end;

      Response.ArquivoRetorno := AjustarRetorno(Response.ArquivoRetorno);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'DescricaoErros', 'item');

      Response.Sucesso := (Response.Erros.Count = 0);

      AuxNode := ANode.Childrens.FindAnyNs('RetornoNota');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Resultado'), tcStr);
          Sucesso := (Situacao = '1');
          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Nota'), tcStr);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('LinkImpressao'), tcStr);
          Link := StringReplace(Link, '&amp;', '&', [rfReplaceAll]);
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

{ TACBrNFSeXWebserviceSigISS }

function TACBrNFSeXWebserviceSigISS.GetSoapAction: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.SoapAction
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.SoapAction;
end;

function TACBrNFSeXWebserviceSigISS.GerarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + '#GerarNota', AMSG,
                     [],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      'xmlns:urn="' + SoapAction + '"']);
end;

function TACBrNFSeXWebserviceSigISS.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + '#ConsultarNotaPrestador', AMSG,
                     [],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      'xmlns:urn="' + SoapAction + '"']);
end;

function TACBrNFSeXWebserviceSigISS.Cancelar(ACabecalho, AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + '#CancelarNota', AMSG,
                     [],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      'xmlns:urn="' + SoapAction + '"']);
end;

function TACBrNFSeXWebserviceSigISS.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := string(NativeStringToUTF8(Result));
  Result := RemoverPrefixosDesnecessarios(Result);
end;

{ TACBrNFSeXWebserviceSigISS103 }

function TACBrNFSeXWebserviceSigISS103.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
begin
  FPMsgOrig := AMSG;

  Result := Executar(SoapAction + '#ConsultarNfseServicoPrestado', AMSG,
                     [],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      'xmlns:urn="' + SoapAction + '"']);
end;

{ TACBrNFSeProviderSigISS103 }

function TACBrNFSeProviderSigISS103.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SigISS103.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigISS103.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SigISS103.Create(Self);
  Result.NFSe := ANFSe;
end;

procedure TACBrNFSeProviderSigISS103.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if EstaVazio(Emitente.WSUser) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod119;
    AErro.Descricao := ACBrStr(Desc119);
    Exit;
  end;

  if EstaVazio(Emitente.WSSenha) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod120;
    AErro.Descricao := ACBrStr(Desc120);
    Exit;
  end;

  Response.Metodo := tmConsultarNFSe;

  Response.ArquivoEnvio := '<ConsultarNfseServicoPrestado xmlns="http://iss.londrina.pr.gov.br/ws/v1_03">' +
                         '<ConsultarNfseServicoPrestadoEnvio>' +
                           '<ccm>' + Trim(Emitente.InscMun) + '</ccm>' +
                           '<cnpj>' + Trim(Emitente.Cnpj) + '</cnpj>' +
                           '<cpf>' + Trim(Emitente.WSUser) + '</cpf>' +
                           '<senha>' + Trim(Emitente.WSSenha) + '</senha>' +
                           '<numero_nfse>' +
                             Response.InfConsultaNFSe.NumeroIniNFSe +
                           '</numero_nfse>' +
                         '</ConsultarNfseServicoPrestadoEnvio>' +
                       '</ConsultarNfseServicoPrestado>';
end;

procedure TACBrNFSeProviderSigISS103.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := ACBrStr(Desc108);
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := ACBrStr(Desc109);
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.ArquivoEnvio := '<CancelarNota xmlns="http://iss.londrina.pr.gov.br/ws/v1_03">' +
                             '<DescricaoCancelaNota>' +
                               '<ccm>' + Trim(Emitente.InscMun) + '</ccm>' +
                               '<cnpj>' + Trim(Emitente.Cnpj) + '</cnpj>' +
                               '<cpf>' + Trim(Emitente.WSUser) + '</cpf>' +
                               '<senha>' + Trim(Emitente.WSSenha) + '</senha>' +
                               '<nota>' +
                                 Response.InfCancelamento.NumeroNFSe +
                               '</nota>' +
                               '<cod_cancelamento>' +
                                 Response.InfCancelamento.CodCancelamento +
                               '</cod_cancelamento>' +
                               '<email>' +
                                 Response.InfCancelamento.email +
                               '</email>' +
                             '</DescricaoCancelaNota>' +
                           '</CancelarNota>';
end;

end.
