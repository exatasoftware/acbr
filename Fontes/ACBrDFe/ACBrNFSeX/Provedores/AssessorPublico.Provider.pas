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

unit AssessorPublico.Provider;

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
  TACBrNFSeXWebserviceAssessorPublico = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetDadosUsuario: string;
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property DadosUsuario: string read GetDadosUsuario;
  end;

  TACBrNFSeProviderAssessorPublico = class (TACBrNFSeProviderProprio)
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

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = '';
                                     AMessageTag: string = 'Erro'); override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, SynaCode,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  AssessorPublico.GravarXml, AssessorPublico.LerXml;

{ TACBrNFSeProviderAssessorPublico }

procedure TACBrNFSeProviderAssessorPublico.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    ModoEnvio := meLoteAssincrono;
  end;

  ConfigMsgDados.UsarNumLoteConsLote := True;

  SetXmlNameSpace('');

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderAssessorPublico.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_AssessorPublico.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderAssessorPublico.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_AssessorPublico.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderAssessorPublico.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceAssessorPublico.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderAssessorPublico.ProcessarMensagemErros(
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
    AErro.Codigo := '';
    AErro.Descricao := ObterConteudoTag(ANodeArray[I].Childrens.FindAnyNs('ERRO'), tcStr);
    AErro.Correcao := '';
  end;
end;

function TACBrNFSeProviderAssessorPublico.PrepararRpsParaLote(
  const aXml: string): string;
begin
  Result := '<NOTA>' + SeparaDados(aXml, 'NOTA') + '</NOTA>';
end;

procedure TACBrNFSeProviderAssessorPublico.GerarMsgDadosEmitir(
  Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  with Params do
  begin
    Response.ArquivoEnvio := '<NFSE>' +
                           '<IDENTIFICACAO>' +
                             '<MESCOMP>' +
                                FormatDateTime('MM', Now) +
                             '</MESCOMP>' +
                             '<ANOCOMP>' +
                                FormatDateTime('yyyy', Now) +
                             '</ANOCOMP>' +
                             '<INSCRICAO>' +
                                Emitente.InscMun +
                             '</INSCRICAO>' +
                             '<VERSAO>1.00</VERSAO>' +
                           '</IDENTIFICACAO>' +
                           '<NOTAS>' +
                             Xml +
                           '</NOTAS>' +
                         '</NFSE>';
  end;
end;

procedure TACBrNFSeProviderAssessorPublico.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  Inconsistencia: Boolean;
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

      Inconsistencia := (Pos('<INCONSISTENCIA>', Response.ArquivoRetorno) > 0);

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      if Inconsistencia then
      begin
        ANode := ANode.Childrens.FindAnyNs('Mensagem');

        ProcessarMensagemErros(ANode, Response, 'NFSE', 'INCONSISTENCIA');
      end
      else
        Response.Protocolo := Trim(ObterConteudoTag(ANode.Childrens.FindAnyNs('Mensagem'), tcStr));

      Response.Sucesso := (Response.Erros.Count = 0);
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

procedure TACBrNFSeProviderAssessorPublico.PrepararConsultaLoteRps(
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

  Response.ArquivoEnvio := '<NFSE>' +
                         '<IDENTIFICACAO>' +
                           '<INSCRICAO>' +
                              Emitente.InscMun +
                           '</INSCRICAO>' +
                           '<LOTE>' +
                              Response.Lote +
                           '</LOTE>' +
                         '</IDENTIFICACAO>' +
                       '</NFSE>';
end;

procedure TACBrNFSeProviderAssessorPublico.TratarRetornoConsultaLoteRps(
  Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  i: Integer;
  NumNFSe: String;
  ANota: NotaFiscal;
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

      ANode := ANode.Childrens.FindAnyNs('Mensagem');

      ProcessarMensagemErros(ANode, Response, 'NFSE', 'INCONSISTENCIA');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := ANode.Childrens.FindAnyNs('NFSE');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('NOTA');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for i := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[i];

        NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('COD'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
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

procedure TACBrNFSeProviderAssessorPublico.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.InfConsultaNFSe.NumeroLote) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod111;
    AErro.Descricao := Desc111;
    Exit;
  end;

  if EstaVazio(Response.InfConsultaNFSe.NumeroIniNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSe;

  Response.ArquivoEnvio := '<NFSE>' +
                         '<IDENTIFICACAO>' +
                           '<INSCRICAO>' +
                              Emitente.InscMun +
                           '</INSCRICAO>' +
                           '<LOTE>' +
                              Response.InfConsultaNFSe.NumeroLote +
                           '</LOTE>' +
                           '<SEQUENCIA>' +
                              Response.InfConsultaNFSe.NumeroIniNFSe +
                           '</SEQUENCIA>' +
                         '</IDENTIFICACAO>' +
                       '</NFSE>';
end;

procedure TACBrNFSeProviderAssessorPublico.TratarRetornoConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  i: Integer;
  NumNFSe: String;
  ANota: NotaFiscal;
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

      ANode := ANode.Childrens.FindAnyNs('Mensagem');

      ProcessarMensagemErros(ANode, Response, 'NFSE', 'INCONSISTENCIA');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := ANode.Childrens.FindAnyNs('NFSE');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('NOTA');

      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod203;
        AErro.Descricao := Desc203;
        Exit;
      end;

      for i := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[i];

        NumNFSe := ObterConteudoTag(ANode.Childrens.FindAnyNs('COD'), tcStr);

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumNFSe);

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
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

procedure TACBrNFSeProviderAssessorPublico.PrepararCancelaNFSe(
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

  if EstaVazio(Response.InfCancelamento.NumeroLote) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod111;
    AErro.Descricao := Desc111;
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := Desc110;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.ArquivoEnvio := '<NFSE>' +
                         '<IDENTIFICACAO>' +
                           '<INSCRICAO>' +
                              Emitente.InscMun +
                           '</INSCRICAO>' +
                           '<LOTE>' +
                              Response.InfCancelamento.NumeroLote +
                           '</LOTE>' +
                           '<SEQUENCIA>' +
                              Response.InfCancelamento.NumeroNFSe +
                           '</SEQUENCIA>' +
                           '<OBSERVACAO>' +
                              Response.InfCancelamento.MotCancelamento +
                           '</OBSERVACAO>' +
                         '</IDENTIFICACAO>' +
                       '</NFSE>';
end;

procedure TACBrNFSeProviderAssessorPublico.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
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

      ANode := Document.Root.Childrens.FindAnyNs('NFSE');

      if ANode <> nil then
      begin
        ProcessarMensagemErros(ANode, Response, '', 'INCONSISTENCIA');

        Response.Sucesso := (Response.Erros.Count = 0);
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

{ TACBrNFSeXWebserviceAssessorPublico }

function TACBrNFSeXWebserviceAssessorPublico.GetDadosUsuario: string;
begin
  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    Result := '<nfse:Usuario>' + Emitente.WSUser + '</nfse:Usuario>' +
              '<nfse:Senha>' +
                LowerCase(AsciiToHex(MD5(AnsiString(Emitente.WSSenha)))) +
              '</nfse:Senha>';
  end;
end;

function TACBrNFSeXWebserviceAssessorPublico.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:Nfse.Execute>';
  Request := Request + '<nfse:Operacao>1</nfse:Operacao>';
  Request := Request + DadosUsuario;
  Request := Request + '<nfse:Webxml>' + XmlToStr(AMSG) + '</nfse:Webxml>';
  Request := Request + '</nfse:Nfse.Execute>';

  Result := Executar('nfseaction/ANFSE.Execute', Request, [''], ['xmlns:nfse="nfse"']);
end;

function TACBrNFSeXWebserviceAssessorPublico.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:Nfse.Execute>';
  Request := Request + '<nfse:Operacao>3</nfse:Operacao>';
  Request := Request + DadosUsuario;
  Request := Request + '<nfse:Webxml>' + XmlToStr(AMSG) + '</nfse:Webxml>';
  Request := Request + '</nfse:Nfse.Execute>';

  Result := Executar('nfseaction/ANFSE.Execute', Request, [''], ['xmlns:nfse="nfse"']);
end;

function TACBrNFSeXWebserviceAssessorPublico.ConsultarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:Nfse.Execute>';
  Request := Request + '<nfse:Operacao>4</nfse:Operacao>';
  Request := Request + DadosUsuario;
  Request := Request + '<nfse:Webxml>' + XmlToStr(AMSG) + '</nfse:Webxml>';
  Request := Request + '</nfse:Nfse.Execute>';

  Result := Executar('nfseaction/ANFSE.Execute', Request, [''], ['xmlns:nfse="nfse"']);
end;

function TACBrNFSeXWebserviceAssessorPublico.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfse:Nfse.Execute>';
  Request := Request + '<nfse:Operacao>2</nfse:Operacao>';
  Request := Request + DadosUsuario;
  Request := Request + '<nfse:Webxml>' + XmlToStr(AMSG) + '</nfse:Webxml>';
  Request := Request + '</nfse:Nfse.Execute>';

  Result := Executar('nfseaction/ANFSE.Execute', Request, [''], ['xmlns:nfse="nfse"']);
end;

end.
