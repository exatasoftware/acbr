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

unit Simple.Provider;

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
  TACBrNFSeXWebserviceSimple = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetDadosUsuario: string;
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property DadosUsuario: string read GetDadosUsuario;
  end;

  TACBrNFSeProviderSimple = class (TACBrNFSeProviderProprio)
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

    procedure PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = '';
                                     AMessageTag: string = ''); override;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  Simple.GravarXml, Simple.LerXml;

{ TACBrNFSeProviderSimple }

procedure TACBrNFSeProviderSimple.Configuracao;
begin
  inherited Configuracao;

  ConfigGeral.ModoEnvio := meLoteAssincrono;

  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderSimple.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_Simple.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimple.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_Simple.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSimple.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSimple.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

procedure TACBrNFSeProviderSimple.ProcessarMensagemErros(
  const RootNode: TACBrXmlNode; const Response: TNFSeWebserviceResponse;
  AListTag, AMessageTag: string);
var
  I: Integer;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANodeArray := RootNode.Childrens.FindAllAnyNs('Nota');

  if ANodeArray = nil then
    ANodeArray := RootNode.Childrens.FindAllAnyNs('CancelamentoNota');

  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '';
    AErro.Descricao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('sRetorno'), tcStr);

    if AErro.Descricao = '' then
      AErro.Descricao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('sRetornoCanc'), tcStr);

    AErro.Correcao := '';
  end;
end;

procedure TACBrNFSeProviderSimple.PrepararEmitir(Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Nota: NotaFiscal;
  IdAttr, ListaRps, xRps: string;
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
    AErro.Descricao := 'Conjunto de RPS transmitidos (m�ximo de ' +
                       IntToStr(Response.MaxRps) + ' RPS)' +
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

    if EstaVazio(Nota.XMLAssinado) then
    begin
      Nota.GerarXML;
      if ConfigAssinar.Rps or ConfigAssinar.RpsGerarNFSe then
      begin
        Nota.XMLOriginal := FAOwner.SSL.Assinar(ConverteXMLtoUTF8(Nota.XMLOriginal), ConfigMsgDados.XmlRps.DocElemento,
                                                ConfigMsgDados.XmlRps.InfElemento, '', '', '', IdAttr);
      end;
    end;

    if FAOwner.Configuracoes.Arquivos.Salvar then
    begin
      if NaoEstaVazio(Nota.NomeArqRps) then
        TACBrNFSeX(FAOwner).Gravar(Nota.NomeArqRps, Nota.XMLOriginal)
      else
      begin
        Nota.NomeArqRps := Nota.CalcularNomeArquivoCompleto(Nota.NomeArqRps, '');
        TACBrNFSeX(FAOwner).Gravar(Nota.NomeArqRps, Nota.XMLOriginal);
      end;
    end;

    xRps := RemoverDeclaracaoXML(Nota.XMLOriginal);

    ListaRps := ListaRps + xRps;
  end;

  ListaRps := ChangeLineBreak(ListaRps, '');

  Response.XmlEnvio := '<tNota>' +
                          ListaRps +
                       '</tNota>';
end;

procedure TACBrNFSeProviderSimple.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  AuxNode: TACBrXmlNode;
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

      ProcessarMensagemErros(Document.Root, Response, 'Nota');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Nota');

      if AuxNode <> nil then
      begin
        {
        with Response do
        begin
          Sucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);

          AuxNode := AuxNode.Childrens.FindAnyNs('InformacoesLote');

          if AuxNode <> nil then
          begin
            with InformacoesLote do
            begin
              NumeroLote := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('NumeroLote'), tcStr);
              InscricaoPrestador := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);

              AuxNodeCPFCNPJ := AuxNode.Childrens.FindAnyNs('CPFCNPJRemetente');

              if AuxNodeCPFCNPJ <> nil then
              begin
                CPFCNPJRemetente := ProcessarConteudoXml(AuxNodeCPFCNPJ.Childrens.FindAnyNs('CNPJ'), tcStr);

                if CPFCNPJRemetente = '' then
                  CPFCNPJRemetente := ProcessarConteudoXml(AuxNodeCPFCNPJ.Childrens.FindAnyNs('CPF'), tcStr);
              end;

              DataEnvioLote := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('DataEnvioLote'), tcDatHor);
              QtdNotasProcessadas := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('QtdNotasProcessadas'), tcInt);
              TempoProcessamento := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('TempoProcessamento'), tcInt);
              ValorTotalServico := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('ValorTotalServicos'), tcDe2);
            end;
          end;
        end;
        }
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderSimple.PrepararConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  if EstaVazio(Response.NumRPS) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod102;
    AErro.Descricao := Desc102;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.XmlEnvio := '<iRPS>' + Response.NumRPS + '</iRPS>' +
                       '<sCPFCNPJ>' + OnlyNumber(Emitente.CNPJ) + '</sCPFCNPJ>' +
                       '<dDataRecibo>' + '</dDataRecibo>';end;

procedure TACBrNFSeProviderSimple.TratarRetornoConsultaNFSeporRps(
  Response: TNFSeConsultaNFSeporRpsResponse);
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
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'Nota');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := ANode.Childrens.FindAllAnyNs('Nota');
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
        NumNFSe := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('iNota'), tcStr);

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
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderSimple.PrepararConsultaNFSe(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorPeriodo,
    tcPorFaixa: PrepararConsultaNFSeporFaixa(Response);
  else
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

      Response.XmlEnvio := '<iNota>' + Response.InfConsultaNFSe.NumeroIniNFSe + '</iNota>' +
                           '<sCPFCNPJ>' + OnlyNumber(Emitente.CNPJ) + '</sCPFCNPJ>';
    end;
  end;
end;

procedure TACBrNFSeProviderSimple.TratarRetornoConsultaNFSe(
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
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorPeriodo,
    tcPorFaixa: TratarRetornoConsultaNFSeporFaixa(Response);
  else
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

          ProcessarMensagemErros(Document.Root, Response, 'Nota');

          Response.Sucesso := (Response.Erros.Count = 0);

          ANode := Document.Root;

          ANodeArray := ANode.Childrens.FindAllAnyNs('Nota');
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
            NumNFSe := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('iNota'), tcStr);

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
            AErro.Descricao := E.Message;
          end;
        end;
      finally
        FreeAndNil(Document);
      end;
    end;
  end;
end;

procedure TACBrNFSeProviderSimple.PrepararConsultaNFSeporFaixa(
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

  if Response.InfConsultaNFSe.DataFinal = 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod116;
    AErro.Descricao := Desc116;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  Response.Metodo := tmConsultarNFSePorFaixa;

  Response.XmlEnvio := '<dDataInicial>' +
                         FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataInicial) +
                       '</dDataInicial>' +
                       '<dDataFinal>' +
                         FormatDateTime('YYYY-MM-DD', Response.InfConsultaNFSe.DataFinal) +
                       '</dDataFinal>' +
                       '<sCPFCNPJ>' + OnlyNumber(Emitente.CNPJ) + '</sCPFCNPJ>';
end;

procedure TACBrNFSeProviderSimple.TratarRetornoConsultaNFSeporFaixa(
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
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'Nota');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      ANodeArray := ANode.Childrens.FindAllAnyNs('Nota');
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
        NumNFSe := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('iNota'), tcStr);

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
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderSimple.PrepararCancelaNFSe(
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

  if EstaVazio(Response.InfCancelamento.SerieNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod112;
    AErro.Descricao := Desc112;
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

  Response.XmlEnvio := '<tCancelamentoNota>' +
                         '<CancelamentoNota>' +
                           '<sRetornoCanc>' + '</sRetornoCanc>' +
                           '<sContribuinteCanc>' +
                             OnlyNumber(Emitente.CNPJ) +
                           '</sContribuinteCanc>' +
                           '<iNotaCanc>' +
                             Response.InfCancelamento.NumeroNFSe +
                           '</iNotaCanc>' +
                           '<sSerieCanc>' +
                             Response.InfCancelamento.SerieNFSe +
                           '</sSerieCanc>' +
                           '<dDataCancelamento>' +
                             FormatDateTime('YYYY-MM-DD', Date) +
                           '</dDataCancelamento>' +
                           '<sMotivoCanc>' +
                             Response.InfCancelamento.MotCancelamento +
                           '</sMotivoCanc>' +
                         '</CancelamentoNota>' +
                       '</tCancelamentoNota>';
end;

procedure TACBrNFSeProviderSimple.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
  xSucesso: string;
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

      ProcessarMensagemErros(Document.Root, Response, 'CancelamentoNota');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;

      AuxNode := ANode.Childrens.FindAnyNs('Cabecalho');

      if AuxNode <> nil then
      begin
        with Response do
        begin
          xSucesso := ProcessarConteudoXml(AuxNode.Childrens.FindAnyNs('Sucesso'), tcStr);
          Sucesso := not (xSucesso = 'N');
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

{ TACBrNFSeXWebserviceSimple }

function TACBrNFSeXWebserviceSimple.GetDadosUsuario: string;
begin
  with TACBrNFSeX(FPDFeOwner).Configuracoes.Geral do
  begin
    Result := '<iCMC>' + Emitente.InscMun + '</iCMC>' +
              '<sLogin>' + Emitente.WSUser + '</sLogin>' +
              '<sSenha>' + Emitente.WSSenha + '</sSenha>';
  end;
end;

function TACBrNFSeXWebserviceSimple.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:LeRPSeGravaNota xmlns:tem="http://tempuri.org">';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</tem:LeRPSeGravaNota>';

  Result := Executar('', Request, ['LeRPSeGravaNotaResult'], []);
end;

function TACBrNFSeXWebserviceSimple.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultaNotaporRPS xmlns:tem="http://tempuri.org">';
  Request := Request + DadosUsuario;
  Request := Request + AMSG;
  Request := Request + '</tem:ConsultaNotaporRPS>';

  Result := Executar('', Request, ['ConsultaNotaporRPSResult'], []);
end;

function TACBrNFSeXWebserviceSimple.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultaNota xmlns:tem="http://tempuri.org">';
  Request := Request + DadosUsuario;
  Request := Request + AMSG;
  Request := Request + '</tem:ConsultaNota>';

  Result := Executar('', Request, ['ConsultaNotaResult'], []);
end;

function TACBrNFSeXWebserviceSimple.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ListarNotas xmlns:tem="http://tempuri.org">';
  Request := Request + DadosUsuario;
  Request := Request + AMSG;
  Request := Request + '</tem:ListarNotas>';

  Result := Executar('', Request, ['ListarNotasResult'], []);
end;

function TACBrNFSeXWebserviceSimple.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelarNota xmlns:tem="http://tempuri.org">';
  Request := Request + AMSG;
  Request := Request + DadosUsuario;
  Request := Request + '</tem:CancelarNota>';

  Result := Executar('', Request, ['CancelarNotaResult'], []);
end;

end.
