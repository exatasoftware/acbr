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

unit GeisWeb.Provider;

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
  TACBrNFSeXWebserviceGeisWeb = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNameSpace: string;
    function GetSoapAction: string;
    function GetAliasCidade: string;
  public
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;

    property NameSpace: string read GetNameSpace;
    property SoapAction: string read GetSoapAction;
    property AliasCidade: string read GetAliasCidade;
  end;

  TACBrNFSeProviderGeisWeb = class (TACBrNFSeProviderProprio)
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

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = '';
                                     const AMessageTag: string = 'Erro'); override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  GeisWeb.GravarXml, GeisWeb.LerXml;

{ TACBrNFSeProviderGeisWeb }

procedure TACBrNFSeProviderGeisWeb.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    ModoEnvio := meLoteSincrono;
  end;

  ConfigAssinar.Rps := True;

  SetXmlNameSpace('http://www.geisweb.net.br/xsd/envio_lote_rps.xsd');

  with ConfigMsgDados do
  begin
    UsarNumLoteConsLote := True;

    with XmlRps do
    begin
      DocElemento := 'Rps';
      InfElemento := 'Rps';
    end;
  end;

  with ConfigSchemas do
  begin
    RecepcionarSincrono := 'envio_lote_rps.xsd';
    ConsultarLote := 'consulta_lote_rps.xsd';
    ConsultarNFSe := 'consulta_nfse.xsd';
    CancelarNFSe := 'cancela_nfse.xsd';
  end;
end;

function TACBrNFSeProviderGeisWeb.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_GeisWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGeisWeb.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_GeisWeb.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderGeisWeb.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceGeisWeb.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderGeisWeb.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag, AMessageTag: string);
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
    AErro.Codigo := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Erro'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('Status'), tcStr);
    AErro.Correcao := '';
  end;
end;

function TACBrNFSeProviderGeisWeb.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := '<Rps xmlns="http://www.geisweb.net.br/xsd/envio_lote_rps.xsd">' +
            SeparaDados(aXml, 'Rps') + '</Rps>';
end;

procedure TACBrNFSeProviderGeisWeb.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    Response.ArquivoEnvio := '<EnviaLoteRps' + NameSpace + '>' +
                           '<CnpjCpf>' +
                             OnlyNumber(Emitente.CNPJ) +
                           '</CnpjCpf>' +
                           '<NumeroLote>' +
                             Response.Lote +
                           '</NumeroLote>' +
                           Xml +
                         '</EnviaLoteRps>';
  end;
end;

procedure TACBrNFSeProviderGeisWeb.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANodeArray: TACBrXmlNodeArray;
  ANode, AuxNode: TACBrXmlNode;
  i: Integer;
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
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'Msg');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := ANode.Childrens.FindAllAnyNs('Nfse');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

        if AuxNode <> nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XmlNfse := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
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

procedure TACBrNFSeProviderGeisWeb.PrepararConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.Lote) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod111;
    AErro.Descricao := Desc111;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.ArquivoEnvio := '<ConsultaLoteRps>' +
                         '<CnpjCpf>' +
                           OnlyNumber(Emitente.CNPJ) +
                         '</CnpjCpf>' +
                         '<Consulta>' +
                           '<CnpjCpfPrestador>' +
                             OnlyNumber(Emitente.CNPJ) +
                           '</CnpjCpfPrestador>' +
                           '<NumeroLote>' +
                             Response.Lote +
                           '</NumeroLote>' +
                         '</Consulta>' +
                       '</ConsultaLoteRps>';
end;

procedure TACBrNFSeProviderGeisWeb.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANodeArray: TACBrXmlNodeArray;
  ANode, AuxNode: TACBrXmlNode;
  i: Integer;
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
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'Msg');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := ANode.Childrens.FindAllAnyNs('Rps');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod208;
        AErro.Descricao := Desc208;
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

        if AuxNode <> nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XmlNfse := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
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

procedure TACBrNFSeProviderGeisWeb.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XmlConsulta: string;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSe;

  if OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) =
     OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) then
    Response.InfConsultaNFSe.NumeroFinNFSe := '';

  XmlConsulta := '';

  if (OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) <> '') and
     (OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) = '') and
     (Response.InfConsultaNFSe.DataInicial = 0) and
     (Response.InfConsultaNFSe.DataFinal = 0) then
    XmlConsulta := '<NumeroNfse>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                   '</NumeroNfse>' +
                   '<DtInicial/>' +
                   '<DtFinal/>' +
                   '<NumeroInicial/>' +
                   '<NumeroFinal/>';

  if (OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) <> '') and
     (OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) <> '') and
     (Response.InfConsultaNFSe.DataInicial = 0) and
     (Response.InfConsultaNFSe.DataFinal = 0) then
    XmlConsulta := '<NumeroNfse/>' +
                   '<DtInicial/>' +
                   '<DtFinal/>' +
                   '<NumeroInicial>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                   '</NumeroInicial>' +
                   '<NumeroFinal>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) +
                   '</NumeroFinal>';

  if (OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) = '') and
     (OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) = '') and
     (Response.InfConsultaNFSe.DataInicial > 0) and
     (Response.InfConsultaNFSe.DataFinal > 0) then
    XmlConsulta := '<NumeroNfse/>' +
                   '<DtInicial>' +
                      FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataInicial) +
                   '</DtInicial>' +
                   '<DtFinal>' +
                      FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataFinal) +
                   '</DtFinal>' +
                   '<NumeroInicial/>' +
                   '<NumeroFinal/>';

  Response.ArquivoEnvio := '<ConsultaNfse>' +
                         '<CnpjCpf>' +
                            OnlyNumber(Emitente.CNPJ) +
                         '</CnpjCpf>' +
                         '<Consulta>' +
                           '<CnpjCpfPrestador>' +
                              OnlyNumber(Emitente.CNPJ) +
                           '</CnpjCpfPrestador>' +
                           XmlConsulta +
                           '<Pagina>' +
                              IntToStr(Response.InfConsultaNFSe.Pagina) +
                           '</Pagina>' +
                         '</Consulta>' +
                       '</ConsultaNfse>';
end;

procedure TACBrNFSeProviderGeisWeb.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANodeArray: TACBrXmlNodeArray;
  ANode, AuxNode: TACBrXmlNode;
  i: Integer;
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
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'Msg');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := ANode.Childrens.FindAllAnyNs('Nfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

        if AuxNode <> nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XmlNfse := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
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

procedure TACBrNFSeProviderGeisWeb.PrepararCancelaNFSe(
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

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.ArquivoEnvio := '<CancelaNfse>' +
                         '<CnpjCpf>' +
                            OnlyNumber(Emitente.CNPJ) +
                         '</CnpjCpf>' +
                         '<Cancela>' +
                           '<CnpjCpfPrestador>' +
                              OnlyNumber(Emitente.CNPJ) +
                           '</CnpjCpfPrestador>' +
                           '<NumeroNfse>' +
                              Response.InfCancelamento.NumeroNFSe +
                           '</NumeroNfse>' +
                         '</Cancela>' +
                       '</CancelaNfse>';
end;

procedure TACBrNFSeProviderGeisWeb.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  I: Integer;
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
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, '', 'Msg');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      Response.Lote := ObterConteudoTag(ANode.Childrens.FindAnyNs('NumeroLote'), tcStr);

      ANodeArray := ANode.Childrens.FindAllAnyNs('Nfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

        if AuxNode <> nil then
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XmlNfse := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
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

{ TACBrNFSeXWebserviceGeisWeb }

function TACBrNFSeXWebserviceGeisWeb.GetAliasCidade: string;
begin
  Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigGeral.Params.ValorParametro('AliasCidade');
end;

function TACBrNFSeXWebserviceGeisWeb.GetNameSpace: string;
var
  ambiente: string;
begin
  if TACBrNFSeX(FPDFeOwner).Configuracoes.WebServices.AmbienteCodigo = 1 then
    ambiente := 'producao/' + AliasCidade
  else
    ambiente := 'homologacao/modelo';

  Result := 'xmlns:geis="urn:https://www.geisweb.net.br/' + ambiente +
            '/webservice/GeisWebServiceImpl.php"';
end;

function TACBrNFSeXWebserviceGeisWeb.GetSoapAction: string;
var
  ambiente: string;
begin
  if TACBrNFSeX(FPDFeOwner).Configuracoes.WebServices.AmbienteCodigo = 1 then
    ambiente := 'producao/' + AliasCidade
  else
    ambiente := 'homologacao/modelo';

  Result := 'urn:https://www.geisweb.net.br/' + ambiente +
            '/webservice/GeisWebServiceImpl.php#';
end;

function TACBrNFSeXWebserviceGeisWeb.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<geis:EnviaLoteRps soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">';
  Request := Request + '<EnviaLoteRps xsi:type="xsd:string">' +
                          XmlToStr(AMSG) +
                       '</EnviaLoteRps>';
  Request := Request + '</geis:EnviaLoteRps>';

  Result := Executar(SoapAction + 'EnviaLoteRps', Request,
                     ['EnviaLoteRpsResposta', 'EnviaLoteRpsResposta'],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      NameSpace]);
end;

function TACBrNFSeXWebserviceGeisWeb.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<geis:ConsultaLoteRps soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">';
  Request := Request + '<ConsultaLoteRps xsi:type="xsd:string">' +
                          XmlToStr(AMSG) +
                       '</ConsultaLoteRps>';
  Request := Request + '</geis:ConsultaLoteRps>';

  Result := Executar(SoapAction + 'ConsultaLoteRps', Request,
                     ['ConsultaLoteRpsResposta', 'ConsultaLoteRpsResposta'],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      NameSpace]);
end;

function TACBrNFSeXWebserviceGeisWeb.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<geis:ConsultaNfse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">';
  Request := Request + '<ConsultaNfse xsi:type="xsd:string">' +
                          XmlToStr(AMSG) +
                       '</ConsultaNfse>';
  Request := Request + '</geis:ConsultaNfse>';

  Result := Executar(SoapAction + 'ConsultaNfse', Request,
                     ['ConsultaNfseResposta', 'ConsultaNfseResposta'],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      NameSpace]);
end;

function TACBrNFSeXWebserviceGeisWeb.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<geis:CancelaNfse soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">';
  Request := Request + '<CancelaNfse xsi:type="xsd:string">' +
                          XmlToStr(AMSG) +
                       '</CancelaNfse>';
  Request := Request + '</geis:CancelaNfse>';

  Result := Executar(SoapAction + 'CancelaNfse', Request,
                     ['CancelaNfseResposta', 'CancelaNfseResposta'],
                     ['xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"',
                      'xmlns:xsd="http://www.w3.org/2001/XMLSchema"',
                      NameSpace]);
end;

function TACBrNFSeXWebserviceGeisWeb.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := StrToXml(Result);
  Result := string(NativeStringToUTF8(Result));
end;

end.
