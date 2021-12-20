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

unit ISSLencois.Provider;

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
  TACBrNFSeXWebserviceISSLencois = class(TACBrNFSeXWebserviceSoap12)
  public
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

  end;

  TACBrNFSeProviderISSLencois = class (TACBrNFSeProviderProprio)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    function PrepararRpsParaLote(const aXml: string): string; override;

    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse;
      Params: TNFSeParamsResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = '';
                                     AMessageTag: string = 'Erro'); override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ISSLencois.GravarXml, ISSLencois.LerXml;

{ TACBrNFSeProviderISSLencois }

procedure TACBrNFSeProviderISSLencois.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    UseCertificateHTTP := False;
    ModoEnvio := meUnitario;
    ConsultaNFSe := False;
  end;

  SetXmlNameSpace('NotaFiscal-Geracao.xsd');

  with ConfigMsgDados do
  begin
    with LoteRps do
    begin
      InfElemento := 'InfDeclaracaoPrestacaoServico';
      DocElemento := 'Rps';
    end;

    CancelarNFSe.xmlns := 'NotaFiscal-Cancelamento.xsd';
  end;

  with ConfigSchemas do
  begin
    CancelarNFSe := 'NotaFiscal-Cancelamento.xsd';
    GerarNFSe := 'NotaFiscal-Geracao.xsd';
  end;
end;

function TACBrNFSeProviderISSLencois.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSLencois.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSLencois.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSLencois.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSLencois.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSLencois.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderISSLencois.ProcessarMensagemErros(
  const RootNode: TACBrXmlNode; const Response: TNFSeWebserviceResponse;
  AListTag, AMessageTag: string);
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

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Descricao'), tcStr);
    AErro.Correcao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('AvisoTecnico'), tcStr);

    if AErro.Descricao = '' then
      AErro.Descricao := ANodeArray[I].AsString;
  end;
end;

function TACBrNFSeProviderISSLencois.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderISSLencois.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
begin
  Response.XmlEnvio := Params.Xml;
end;

procedure TACBrNFSeProviderISSLencois.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
//  ANota: NotaFiscal;
  Xml: string;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'Erros', 'Erro');

      Response.Sucesso := (Response.Erros.Count = 0);

      with Response do
      begin
        Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('validacao'), tcStr);
      end;

      Xml := ObterConteudoTag(ANode.Childrens.FindAnyNs('xml'), tcStr);
      {
      ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps();

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
      }
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

procedure TACBrNFSeProviderISSLencois.PrepararCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := Desc110;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := Desc109;
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

  Response.XmlEnvio := '<Nota xmlns="NotaFiscal-Cancelamento.xsd">' +
                         '<Versao>1.1</Versao>' +
                         '<InscricaoMunicipal>' +
                           Trim(Emitente.InscMun) +
                         '</InscricaoMunicipal>' +
                         '<PASNF>' +
                           '<Numero>' +
                             Response.InfCancelamento.NumeroNFSe +
                           '</Numero>' +
                           '<Data>' +
                             FormatDateTime('yyyy-mm-dd', now) +
                           '</Data>' +
                         '</PASNF>' +
                         '<NotaNumero>' +
                           Response.InfCancelamento.NumeroNFSe +
                         '</NotaNumero>' +
                         '<CodigoValidacao>' +
                           Response.InfCancelamento.CodVerificacao +
                         '</CodigoValidacao>' +
                         '<DescricaoCancelamento>' +
                           Response.InfCancelamento.MotCancelamento +
                         '</DescricaoCancelamento>' +
                         '<CodigoCancelamento>' +
                           Response.InfCancelamento.CodCancelamento +
                         '</CodigoCancelamento>' +
                       '</Nota>';
end;

procedure TACBrNFSeProviderISSLencois.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode{, AuxNode}: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response, 'Erros', 'Erro');

      Response.Sucesso := (Response.Erros.Count = 0);

      {
      AuxNode := ANode.Childrens.FindAnyNs('RetornoNota');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          Sucesso := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Resultado'), tcStr);
          NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Nota'), tcStr);
          Link := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('LinkImpressao'), tcStr);
        end;
      end;
     }
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

{ TACBrNFSeXWebserviceISSLencois }

function TACBrNFSeXWebserviceISSLencois.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request, DadosUsuario: string;
begin
  FPMsgOrig := AMSG;

  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    DadosUsuario := '<apl2:inscricaoMunicipal>' + Emitente.InscMun + '</apl2:inscricaoMunicipal>' +
                    '<apl2:validacao>' + Emitente.WSSenha + '</apl2:validacao>';
  end;

  Request := '<apl2:GerarNotaFiscal>';
  Request := Request + DadosUsuario;
  Request := Request + '<apl2:xml>' + XmlToStr(AMSG) + '</apl2:xml>';
  Request := Request + '</apl2:GerarNotaFiscal>';

  Result := Executar('http://apl2.lencoispaulista.sp.gov.br/GerarNotaFiscal',
                     Request,
                     ['GerarNotaFiscalResult'],
                     ['xmlns:apl2="http://apl2.lencoispaulista.sp.gov.br/"']);
end;

function TACBrNFSeXWebserviceISSLencois.Cancelar(ACabecalho, AMSG: String): string;
var
  Request, DadosUsuario: string;
begin
  FPMsgOrig := AMSG;

  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    DadosUsuario := '<apl2:inscricao>' + Emitente.InscMun + '</apl2:inscricao>' +
                    '<apl2:validacao>' + Emitente.WSSenha + '</apl2:validacao>';
  end;

  Request := '<apl2:CancelarNotaFiscal>';
  Request := Request + DadosUsuario;
  Request := Request + '<apl2:xml>' + XmlToStr(AMSG) + '</apl2:xml>';
  Request := Request + '</apl2:CancelarNotaFiscal>';

  Result := Executar('http://apl2.lencoispaulista.sp.gov.br/CancelarNotaFiscal',
                     Request,
                     ['CancelarNotaFiscalResult'],
                     ['xmlns:apl2="http://apl2.lencoispaulista.sp.gov.br/"']);
end;

end.
