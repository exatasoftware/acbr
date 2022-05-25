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

unit SigCorp.Provider;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv2,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeXWebserviceSigCorp203 = class(TACBrNFSeXWebserviceSoap11)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function RecepcionarSincrono(ACabecalho, AMSG: String): string; override;
    function GerarNFSe(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorFaixa(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoPrestado(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSeServicoTomado(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
    function SubstituirNFSe(ACabecalho, AMSG: String): string; override;

    function TratarXmlRetornado(const aXML: string): string; override;
  end;

  TACBrNFSeProviderSigCorp203 = class (TACBrNFSeProviderABRASFv2)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
  end;

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ACBrNFSeXNotasFiscais, SigCorp.GravarXml, SigCorp.LerXml;

{ TACBrNFSeProviderSigCorp203 }

procedure TACBrNFSeProviderSigCorp203.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    UseCertificateHTTP := False;
    QuebradeLinha := '|';
  end;

  with ConfigAssinar do
  begin
    Rps := True;
    CancelarNFSe := True;
    RpsGerarNFSe := True;
  end;

  with ConfigWebServices do
  begin
    VersaoDados := '2.03';
    VersaoAtrib := '2.03';
  end;

  ConfigMsgDados.DadosCabecalho := GetCabecalho('');
end;

function TACBrNFSeProviderSigCorp203.CriarGeradorXml(
  const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_SigCorp203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigCorp203.CriarLeitorXml(
  const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_SigCorp203.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderSigCorp203.CriarServiceClient(
  const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceSigCorp203.Create(FAOwner, AMetodo, URL)
  else
  begin
    if ConfigGeral.Ambiente = taProducao then
      raise EACBrDFeException.Create(ERR_SEM_URL_PRO)
    else
      raise EACBrDFeException.Create(ERR_SEM_URL_HOM);
  end;
end;

procedure TACBrNFSeProviderSigCorp203.TratarRetornoEmitir(
  Response: TNFSeEmiteResponse);
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
        AErro.Descricao := Desc201;
        Exit
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ANode := Document.Root;

      ProcessarMensagemErros(ANode, Response);

      with Response do
      begin
        Data := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDatUSA);
        Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
      end;

      if Response.ModoEnvio in [meLoteSincrono, meUnitario] then
      begin
        // Retorno do EnviarLoteRpsSincrono e GerarNfse
        ANode := ANode.Childrens.FindAnyNs('ListaNfse');

        if not Assigned(ANode) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := Cod202;
          AErro.Descricao := Desc202;
          Exit;
        end;

        ProcessarMensagemErros(ANode, Response);

        ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');

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
          AuxNode := ANode.Childrens.FindAnyNs('Nfse');
          AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');

          with Response do
          begin
            NumeroNota := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
            CodVerificacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
          end;

          AuxNode := AuxNode.Childrens.FindAnyNs('DeclaracaoPrestacaoServico');
          AuxNode := AuxNode.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');
          AuxNode := AuxNode.Childrens.FindAnyNs('Rps');
          AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
          NumRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);

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
      end;

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

procedure TACBrNFSeProviderSigCorp203.TratarRetornoCancelaNFSe(
  Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode: TACBrXmlNode;
  Ret: TRetCancelamento;
  IdAttr: string;
  AErro: TNFSeEventoCollectionItem;
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

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('RetCancelamento');

      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod209;
        AErro.Descricao := Desc209;
        Exit;
      end;

      ANode := ANode.Childrens.FindAnyNs('NfseCancelamento');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod210;
        AErro.Descricao := Desc210;
        Exit;
      end;

      ANode := ANode.Childrens.FindAnyNs('Cancelamento');

      ANode := ANode.Childrens.FindAnyNs('Confirmacao');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod204;
        AErro.Descricao := Desc204;
        Exit;
      end;

      Ret :=  Response.RetCancelamento;
      Ret.DataHora := ObterConteudoTag(ANode.Childrens.FindAnyNs('DataHoraCancelamento'), tcDatVcto);

      if ConfigAssinar.IncluirURI then
        IdAttr := ConfigGeral.Identificador
      else
        IdAttr := 'ID';

      ANode := ANode.Childrens.FindAnyNs('Pedido');
      ANode := ANode.Childrens.FindAnyNs('InfPedidoCancelamento');

      Ret.Pedido.InfID.ID := ObterConteudoTag(ANode.Attributes.Items[IdAttr]);
      Ret.Pedido.CodigoCancelamento := ObterConteudoTag(ANode.Childrens.FindAnyNs('CodigoCancelamento'), tcStr);

      ANode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

      with Ret.Pedido.IdentificacaoNfse do
      begin
        Numero := ObterConteudoTag(ANode.Childrens.FindAnyNs('Numero'), tcStr);
        Cnpj := ObterConteudoTag(ANode.Childrens.FindAnyNs('Cnpj'), tcStr);
        InscricaoMunicipal := ObterConteudoTag(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
        CodigoMunicipio := ObterConteudoTag(ANode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
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

{ TACBrNFSeXWebserviceSigCorp203 }

function TACBrNFSeXWebserviceSigCorp203.Recepcionar(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:RecepcionarLoteRps>';

  Result := Executar('http://tempuri.org/RecepcionarLoteRps', Request,
                     ['RecepcionarLoteRpsResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.RecepcionarSincrono(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:RecepcionarLoteRpsSincrono>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:RecepcionarLoteRpsSincrono>';

  Result := Executar('http://tempuri.org/RecepcionarLoteRpsSincrono', Request,
                     ['RecepcionarLoteRpsSincronoResult', 'EnviarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.GerarNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:GerarNfse>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:GerarNfse>';

  Result := Executar('http://tempuri.org/GerarNfse', Request,
                     ['GerarNfseResult', 'GerarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.ConsultarLote(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarLoteRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarLoteRps>';

  Result := Executar('http://tempuri.org/ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResult', 'ConsultarLoteRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.ConsultarNFSePorFaixa(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorFaixa>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfsePorFaixa>';

  Result := Executar('http://tempuri.org/ConsultarNfsePorFaixa', Request,
                     ['ConsultarNfsePorFaixaResult', 'ConsultarNfseFaixaResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.ConsultarNFSePorRps(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfsePorRps>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfsePorRps>';

  Result := Executar('http://tempuri.org/ConsultarNfsePorRps', Request,
                     ['ConsultarNfsePorRpsResult', 'ConsultarNfseRpsResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.ConsultarNFSeServicoPrestado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoPrestado>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfseServicoPrestado>';

  Result := Executar('http://tempuri.org/ConsultarNfseServicoPrestado', Request,
                     ['ConsultarNfseServicoPrestadoResult', 'ConsultarNfseServicoPrestadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.ConsultarNFSeServicoTomado(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:ConsultarNfseServicoTomado>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:ConsultarNfseServicoTomado>';

  Result := Executar('http://tempuri.org/ConsultarNfseServicoTomado', Request,
                     ['ConsultarNfseServicoTomadoResult', 'ConsultarNfseServicoTomadoResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:CancelaNota>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:CancelaNota>';

  Result := Executar('http://tempuri.org/CancelaNota', Request,
                     ['CancelaNotaResult', 'CancelarNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.SubstituirNFSe(ACabecalho,
  AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<tem:SubstituirNfse>';
  Request := Request + '<tem:nfseCabecMsg>' + XmlToStr(ACabecalho) + '</tem:nfseCabecMsg>';
  Request := Request + '<tem:nfseDadosMsg>' + XmlToStr(AMSG) + '</tem:nfseDadosMsg>';
  Request := Request + '</tem:SubstituirNfse>';

  Result := Executar('http://tempuri.org/SubstituirNfse', Request,
                     ['SubstituirNfseResult', 'SubstituirNfseResposta'],
                     ['xmlns:tem="http://tempuri.org/"']);
end;

function TACBrNFSeXWebserviceSigCorp203.TratarXmlRetornado(
  const aXML: string): string;
begin
  Result := inherited TratarXmlRetornado(aXML);

  Result := ParseText(AnsiString(Result), True, False);
  Result := RemoverDeclaracaoXML(Result);
  Result := RemoverCaracteresDesnecessarios(Result);
end;

end.
