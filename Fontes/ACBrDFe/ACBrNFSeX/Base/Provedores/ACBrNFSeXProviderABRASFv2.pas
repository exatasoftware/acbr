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

unit ACBrNFSeXProviderABRASFv2;

interface

uses
  SysUtils, Classes,
  ACBrNFSeXClass, ACBrXmlBase, ACBrXmlDocument, ACBrNFSeXLerXml, ACBrNFSeXGravarXml,
  ACBrNFSeXWebserviceBase, ACBrNFSeXProviderBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeProviderABRASFv2 = class(TACBrNFSeXProvider)
  protected
    procedure Configuracao; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure AssinarConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure AssinarConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure AssinarConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure AssinarConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;
    procedure TratarRetornoSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = 'ListaMensagemRetorno';
                                     AMessageTag: string = 'MensagemRetorno'); virtual;

  end;

implementation

uses
  ACBrUtil, ACBrDFeException, ACBrNFSeX, ACBrNFSeXConfiguracoes,
  ACBrNFSeXNotasFiscais, ACBrNFSeXConversao;

{ TACBrNFSeProviderABRASFv2 }

procedure TACBrNFSeProviderABRASFv2.Configuracao;
const
  NameSpace = 'http://www.abrasf.org.br/nfse.xsd';
begin
  inherited Configuracao;

  // Os provedores que seguem a vers�o 2 do layout da ABRASF podem ter at�
  // tr�s servi�os para recepcionar o RPS: ass�ncrono, s�ncrono e unit�rio.
  // Por padr�o vamos adotar o servi�o S�ncrono, caso o provedor n�o tenha
  // esse servi�o na Unit ACBrNFSeProviderxxxx (xxxx = Provedor) devemos
  // configurar o servi�o disponibilizado.
  ConfigGeral.ModoEnvio := meLoteSincrono;

  SetXmlNameSpace(NameSpace);

  with ConfigWebServices do
  begin
    VersaoDados := '2.00';
    VersaoAtrib := '2.00';
    AtribVerLote := 'versao';
  end;

  with ConfigMsgDados do
  begin
    with XmlRps do
    begin
      InfElemento := 'InfDeclaracaoPrestacaoServico';
      DocElemento := 'Rps';
    end;

    DadosCabecalho := '<cabecalho versao="2.00" xmlns="' + NameSpace + '">' +
                      '<versaoDados>2.00</versaoDados></cabecalho>';

    GerarNSLoteRps := False;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararEmitir(Response: TNFSeEmiteResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  Nota: NotaFiscal;
  Versao, IdAttr, NameSpace, NameSpaceLote, ListaRps, xRps,
  TagEnvio, Prestador, Prefixo, PrefixoTS: string;
  I: Integer;
begin
  if TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'ERRO: Nenhum RPS adicionado ao componente';
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > Response.MaxRps then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'ERRO: Conjunto de RPS transmitidos (m�ximo de ' +
                       IntToStr(Response.MaxRps) + ' RPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count);
  end;

  if Response.Erros.Count > 0 then Exit;

  ListaRps := '';
  Prefixo := '';
  PrefixoTS := '';

  case Response.ModoEnvio of
    meLoteSincrono:
    begin
      TagEnvio := ConfigMsgDados.LoteRpsSincrono.DocElemento;

      if EstaVazio(ConfigMsgDados.LoteRpsSincrono.xmlns) then
        NameSpace := ''
      else
      begin
        if ConfigMsgDados.Prefixo = '' then
          NameSpace := ' xmlns="' + ConfigMsgDados.LoteRpsSincrono.xmlns + '"'
        else
        begin
          NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                                   ConfigMsgDados.LoteRpsSincrono.xmlns + '"';
          Prefixo := ConfigMsgDados.Prefixo + ':';
        end;
      end;
    end;

    meUnitario:
    begin
      TagEnvio := ConfigMsgDados.GerarNFSe.DocElemento;

      if EstaVazio(ConfigMsgDados.GerarNFSe.xmlns) then
        NameSpace := ''
      else
      begin
        if ConfigMsgDados.Prefixo = '' then
          NameSpace := ' xmlns="' + ConfigMsgDados.GerarNFSe.xmlns + '"'
        else
        begin
          NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                                   ConfigMsgDados.GerarNFSe.xmlns + '"';
          Prefixo := ConfigMsgDados.Prefixo + ':';
        end;
      end;
    end;
  else
    begin
      TagEnvio := ConfigMsgDados.LoteRps.DocElemento;

      if EstaVazio(ConfigMsgDados.LoteRps.xmlns) then
        NameSpace := ''
      else
      begin
        if ConfigMsgDados.Prefixo = '' then
          NameSpace := ' xmlns="' + ConfigMsgDados.LoteRps.xmlns + '"'
        else
        begin
          NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' +
                                   ConfigMsgDados.LoteRps.xmlns + '"';
          Prefixo := ConfigMsgDados.Prefixo + ':';
        end;
      end;
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.LoteRps.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

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
        Nota.XMLOriginal := FAOwner.SSL.Assinar(ConverteXMLtoUTF8(Nota.XMLOriginal),
                                                PrefixoTS + ConfigMsgDados.XmlRps.DocElemento,
                                                ConfigMsgDados.XmlRps.InfElemento, '', '', '', IdAttr);
      end;
    end;

    SalvarXmlRps(Nota);

    xRps := RemoverDeclaracaoXML(Nota.XMLOriginal);
    xRps := PrepararRpsParaLote(xRps);

    ListaRps := ListaRps + xRps;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  if ConfigMsgDados.GerarNSLoteRps then
    NameSpaceLote := NameSpace
  else
    NameSpaceLote := '';

  if ConfigWebServices.AtribVerLote <> '' then
    Versao := ' ' + ConfigWebServices.AtribVerLote + '="' +
              ConfigWebServices.VersaoDados + '"'
  else
    Versao := '';

  if ConfigGeral.Identificador <> '' then
    IdAttr := ' ' + ConfigGeral.Identificador + '="Lote_' + Response.Lote + '"'
  else
    IdAttr := '';

  if Response.ModoEnvio in [meLoteAssincrono, meLoteSincrono] then
  begin
    if ConfigMsgDados.GerarPrestadorLoteRps then
    begin
      Prestador := '<' + PrefixoTS + 'Prestador>' +
                     '<' + PrefixoTS + 'CpfCnpj>' +
                       GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                     '</' + PrefixoTS + 'CpfCnpj>' +
                     GetInscMunic(Emitente.InscMun, PrefixoTS) +
                   '</' + PrefixoTS + 'Prestador>'
    end
    else
      Prestador := '<' + PrefixoTS + 'CpfCnpj>' +
                     GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                   '</' + PrefixoTS + 'CpfCnpj>' +
                   GetInscMunic(Emitente.InscMun, PrefixoTS);

    Response.XmlEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                           '<' + Prefixo + 'LoteRps' + NameSpaceLote + IdAttr  + Versao + '>' +
                             '<' + PrefixoTS + 'NumeroLote>' + Response.Lote + '</' + PrefixoTS + 'NumeroLote>' +
                             Prestador +
                             '<' + PrefixoTS + 'QuantidadeRps>' +
                                IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count) +
                             '</' + PrefixoTS + 'QuantidadeRps>' +
                             '<' + PrefixoTS + 'ListaRps>' + ListaRps + '</' + PrefixoTS + 'ListaRps>' +
                           '</' + Prefixo + 'LoteRps>' +
                         '</' + Prefixo + TagEnvio + '>';
  end
  else
    Response.XmlEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                            ListaRps +
                         '</' + Prefixo + TagEnvio + '>';
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      Response.Data := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('DataRecebimento'), tcDatHor);
      Response.Protocolo := ProcessarConteudoXml(ANode.Childrens.FindAnyNs('Protocolo'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
begin
  TACBrNFSeX(FAOwner).SetStatus(stNFSeIdle);
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
begin
  raise EACBrDFeException.Create(ERR_NAO_IMP);
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  NameSpace, TagEnvio, Prefixo, PrefixoTS: string;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'Protocolo n�o informado.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarLote.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarLote.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarLote.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarLote.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  TagEnvio := ConfigMsgDados.ConsultarLote.DocElemento;

  Response.XmlEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                         '<' + Prefixo + 'Prestador>' +
                           '<' + PrefixoTS + 'CpfCnpj>' +
                             GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                           '</' + PrefixoTS + 'CpfCnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Prestador>' +
                         '<' + Prefixo + 'Protocolo>' +
                           Response.Protocolo +
                         '</' + Prefixo + 'Protocolo>' +
                       '</' + Prefixo + TagEnvio + '>';
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      Response.Situacao := ProcessarConteudoXml(Document.Root.Childrens.FindAnyNs('Situacao'), tcStr);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Lista de NFSe n�o encontrada! (ListaNfse)';
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');
      if not Assigned(ANodeArray) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

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
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  NameSpace, TagEnvio, Prefixo, PrefixoTS: string;
begin
  if EstaVazio(Response.NumRPS) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'N�mero da RPS n�o informado.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarNFSeRps.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSeRps.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSeRps.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSeRps.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  TagEnvio := ConfigMsgDados.ConsultarNFSeRps.DocElemento;

  Response.XmlEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                         '<' + Prefixo + 'IdentificacaoRps>' +
                           '<' + PrefixoTS + 'Numero>' +
                             Response.NumRPS +
                           '</' + PrefixoTS + 'Numero>' +
                           '<' + PrefixoTS + 'Serie>' +
                             Response.Serie +
                           '</' + PrefixoTS + 'Serie>' +
                           '<' + PrefixoTS + 'Tipo>' +
                             Response.Tipo +
                           '</' + PrefixoTS + 'Tipo>' +
                         '</' + Prefixo + 'IdentificacaoRps>' +
                         '<' + Prefixo + 'Prestador>' +
                           '<' + PrefixoTS + 'CpfCnpj>' +
                             GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                           '</' + PrefixoTS + 'CpfCnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Prestador>' +
                       '</' + Prefixo + TagEnvio + '>';
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('CompNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
        Exit;
      end;

      AuxNode := ANode.Childrens.FindAnyNs('Nfse');

      if AuxNode <> nil then
      begin
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        if Assigned(ANota) then
          ANota.XML := ANode.OuterXml
        else
        begin
          TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
          ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
        end;

        SalvarXmlNfse(ANota);
      end
      else
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
Var
  AErro: TNFSeEventoCollectionItem;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorFaixa: PrepararConsultaNFSeporFaixa(Response);
    tcServicoPrestado: PrepararConsultaNFSeServicoPrestado(Response);
    tcServicoTomado: PrepararConsultaNFSeServicoTomado(Response);
  else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.AssinarConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
Var
  AErro: TNFSeEventoCollectionItem;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorFaixa: AssinarConsultaNFSeporFaixa(Response);
    tcServicoPrestado: AssinarConsultaNFSeServicoPrestado(Response);
    tcServicoTomado: AssinarConsultaNFSeServicoTomado(Response);
  else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
Var
  AErro: TNFSeEventoCollectionItem;
begin
  case Response.InfConsultaNFSe.tpConsulta of
    tcPorFaixa: TratarRetornoConsultaNFSeporFaixa(Response);
    tcServicoPrestado: TratarRetornoConsultaNFSeServicoPrestado(Response);
    tcServicoTomado: TratarRetornoConsultaNFSeServicoTomado(Response);
  else
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XmlConsulta, NameSpace, Prefixo, PrefixoTS: string;
begin
  if Response.InfConsultaNFSe.tpConsulta in [tcPorNumeroURLRetornado] then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarNFSePorFaixa.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSePorFaixa.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSePorFaixa.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSePorFaixa.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  Response.Metodo := tmConsultarNFSePorFaixa;

  XmlConsulta := '<' + Prefixo + 'Faixa>' +
                   '<' + PrefixoTS + 'NumeroNfseInicial>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                   '</' + PrefixoTS + 'NumeroNfseInicial>' +
                   '<' + PrefixoTS + 'NumeroNfseFinal>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroFinNFSe) +
                   '</' + PrefixoTS + 'NumeroNfseFinal>' +
                 '</' + Prefixo + 'Faixa>';

  Response.XmlEnvio := '<' + Prefixo + 'ConsultarNfseFaixaEnvio' + NameSpace + '>' +
                         '<' + Prefixo + 'Prestador>' +
                           '<' + PrefixoTS + 'CpfCnpj>' +
                             GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                           '</' + PrefixoTS + 'CpfCnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Prestador>' +
                         XmlConsulta +
                         '<' + Prefixo + 'Pagina>' +
                            IntToStr(Response.InfConsultaNFSe.Pagina) +
                         '</' + Prefixo + 'Pagina>' +
                       '</' + Prefixo + 'ConsultarNfseFaixaEnvio>';
end;

procedure TACBrNFSeProviderABRASFv2.AssinarConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse);
var
  IdAttr, Prefixo: string;
  AErro: TNFSeEventoCollectionItem;
begin
  if not ConfigAssinar.ConsultarNFSePorFaixa then Exit;

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  if ConfigMsgDados.Prefixo = '' then
    Prefixo := ''
  else
    Prefixo := ConfigMsgDados.Prefixo + ':';

  try
    Response.XmlEnvio := FAOwner.SSL.Assinar(Response.XmlEnvio,
      Prefixo + ConfigMsgDados.ConsultarNFSePorFaixa.DocElemento,
      ConfigMsgDados.ConsultarNFSePorFaixa.InfElemento, '', '', '', IdAttr);
  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := E.Message;
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Lista de NFSe n�o encontrada! (ListaNfse)';
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

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
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XmlConsulta, NameSpace, Prefixo, PrefixoTS: string;
begin
  if Response.InfConsultaNFSe.tpConsulta in [tcPorNumeroURLRetornado] then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarNFSeServicoPrestado.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSeServicoPrestado.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSeServicoPrestado.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSeServicoPrestado.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  Response.Metodo := tmConsultarNFSeServicoPrestado;

  if OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) <> '' then
    XmlConsulta := '<' + Prefixo + 'NumeroNfse>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                   '</' + Prefixo + 'NumeroNfse>'
  else
    XmlConsulta := '';

  if (Response.InfConsultaNFSe.DataInicial > 0) and (Response.InfConsultaNFSe.DataFinal > 0) then
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'PeriodoEmissao>' +
                       '<' + PrefixoTS + 'DataInicial>' +
                          FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataInicial) +
                       '</' + PrefixoTS + 'DataInicial>' +
                       '<' + PrefixoTS + 'DataFinal>' +
                          FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataFinal) +
                       '</' + PrefixoTS + 'DataFinal>' +
                     '</' + Prefixo + 'PeriodoEmissao>';

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJTomador) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'Tomador>' +
                       '<' + PrefixoTS + 'CpfCnpj>' +
                          GetCpfCnpj(Response.InfConsultaNFSe.CNPJTomador, PrefixoTS) +
                       '</' + PrefixoTS + 'CpfCnpj>' +
                       GetInscMunic(Response.InfConsultaNFSe.IMTomador, PrefixoTS) +
                     '</' + Prefixo + 'Tomador>';
  end;

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJInter) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'Intermediario>' +
                       '<' + PrefixoTS + 'CpfCnpj>' +
                          GetCpfCnpj(Response.InfConsultaNFSe.CNPJInter, PrefixoTS) +
                       '</' + PrefixoTS + 'CpfCnpj>' +
                       GetInscMunic(Response.InfConsultaNFSe.IMInter, PrefixoTS) +
                     '</' + Prefixo + 'Intermediario>';
  end;

  Response.XmlEnvio := '<' + Prefixo + 'ConsultarNfseServicoPrestadoEnvio' + NameSpace + '>' +
                         '<' + Prefixo + 'Prestador>' +
                           '<' + PrefixoTS + 'CpfCnpj>' +
                             GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                           '</' + PrefixoTS + 'CpfCnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Prestador>' +
                         XmlConsulta +
                         '<' + Prefixo + 'Pagina>' +
                            IntToStr(Response.InfConsultaNFSe.Pagina) +
                         '</' + Prefixo + 'Pagina>' +
                       '</' + Prefixo + 'ConsultarNfseServicoPrestadoEnvio>';
end;

procedure TACBrNFSeProviderABRASFv2.AssinarConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
var
  IdAttr, Prefixo: string;
  AErro: TNFSeEventoCollectionItem;
begin
  if not ConfigAssinar.ConsultarNFSeServicoPrestado then Exit;

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  if ConfigMsgDados.Prefixo = '' then
    Prefixo := ''
  else
    Prefixo := ConfigMsgDados.Prefixo + ':';

  try
    Response.XmlEnvio := FAOwner.SSL.Assinar(Response.XmlEnvio,
      Prefixo + ConfigMsgDados.ConsultarNFSeServicoPrestado.DocElemento,
      ConfigMsgDados.ConsultarNFSeServicoPrestado.InfElemento, '', '', '', IdAttr);
  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := E.Message;
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Lista de NFSe n�o encontrada! (ListaNfse)';
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

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
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XmlConsulta, NameSpace, Prefixo, PrefixoTS: string;
begin
  if Response.InfConsultaNFSe.tpConsulta in [tcPorNumeroURLRetornado] then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'Consulta n�o disponivel neste provedor.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.ConsultarNFSeServicoTomado.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.ConsultarNFSeServicoTomado.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.ConsultarNFSeServicoTomado.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.ConsultarNFSeServicoTomado.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  Response.Metodo := tmConsultarNFSeServicoTomado;

  if OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) <> '' then
    XmlConsulta := '<' + Prefixo + 'NumeroNfse>' +
                      OnlyNumber(Response.InfConsultaNFSe.NumeroIniNFSe) +
                   '</' + Prefixo + 'NumeroNfse>'
  else
    XmlConsulta := '';

  if (Response.InfConsultaNFSe.DataInicial > 0) and (Response.InfConsultaNFSe.DataFinal > 0) then
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'PeriodoEmissao>' +
                       '<' + PrefixoTS + 'DataInicial>' +
                          FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataInicial) +
                       '</' + PrefixoTS + 'DataInicial>' +
                       '<' + PrefixoTS + 'DataFinal>' +
                          FormatDateTime('yyyy-mm-dd', Response.InfConsultaNFSe.DataFinal) +
                       '</' + PrefixoTS + 'DataFinal>' +
                     '</' + Prefixo + 'PeriodoEmissao>';

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJPrestador) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'Prestador>' +
                       '<' + PrefixoTS + 'CpfCnpj>' +
                          GetCpfCnpj(Response.InfConsultaNFSe.CNPJPrestador, PrefixoTS) +
                       '</' + PrefixoTS + 'CpfCnpj>' +
                       GetInscMunic(Response.InfConsultaNFSe.IMPrestador, PrefixoTS) +
                     '</' + Prefixo + 'Prestador>';
  end;

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJTomador) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'Tomador>' +
                       '<' + PrefixoTS + 'CpfCnpj>' +
                          GetCpfCnpj(Response.InfConsultaNFSe.CNPJTomador, PrefixoTS) +
                       '</' + PrefixoTS + 'CpfCnpj>' +
                       GetInscMunic(Response.InfConsultaNFSe.IMTomador, PrefixoTS) +
                     '</' + Prefixo + 'Tomador>';
  end;

  if NaoEstaVAzio(Response.InfConsultaNFSe.CNPJInter) then
  begin
    XmlConsulta := XmlConsulta +
                     '<' + Prefixo + 'Intermediario>' +
                       '<' + PrefixoTS + 'CpfCnpj>' +
                          GetCpfCnpj(Response.InfConsultaNFSe.CNPJInter, PrefixoTS) +
                       '</' + PrefixoTS + 'CpfCnpj>' +
                       GetInscMunic(Response.InfConsultaNFSe.IMInter, PrefixoTS) +
                     '</' + Prefixo + 'Intermediario>';
  end;

  Response.XmlEnvio := '<' + Prefixo + 'ConsultarNfseServicoTomadoEnvio' + NameSpace + '>' +
                         '<' + Prefixo + 'Consulente>' +
                           '<' + PrefixoTS + 'CpfCnpj>' +
                             GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                           '</' + PrefixoTS + 'CpfCnpj>' +
                           GetInscMunic(Emitente.InscMun, PrefixoTS) +
                         '</' + Prefixo + 'Consulente>' +
                         XmlConsulta +
                         '<' + Prefixo + 'Pagina>' +
                            IntToStr(Response.InfConsultaNFSe.Pagina) +
                         '</' + Prefixo + 'Pagina>' +
                       '</' + Prefixo + 'ConsultarNfseServicoTomadoEnvio>';
end;

procedure TACBrNFSeProviderABRASFv2.AssinarConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
var
  IdAttr, Prefixo: string;
  AErro: TNFSeEventoCollectionItem;
begin
  if not ConfigAssinar.ConsultarNFSeServicoTomado then Exit;

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  if ConfigMsgDados.Prefixo = '' then
    Prefixo := ''
  else
    Prefixo := ConfigMsgDados.Prefixo + ':';

  try
    Response.XmlEnvio := FAOwner.SSL.Assinar(Response.XmlEnvio,
      Prefixo + ConfigMsgDados.ConsultarNFSeServicoTomado.DocElemento,
      ConfigMsgDados.ConsultarNFSeServicoTomado.InfElemento, '', '', '', IdAttr);
  except
    on E:Exception do
    begin
      AErro := Response.Erros.New;
      AErro.Codigo := '999';
      AErro.Descricao := E.Message;
    end;
  end;
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
  I: Integer;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('ListaNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Lista de NFSe n�o encontrada! (ListaNfse)';
        Exit;
      end;

      ANodeArray := ANode.Childrens.FindAllAnyNs('CompNfse');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
        Exit;
      end;

      for I := Low(ANodeArray) to High(ANodeArray) do
      begin
        ANode := ANodeArray[I];
        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('IdentificacaoRps');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');
        NumRps := AuxNode.AsString;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

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
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  InfoCanc: TInfCancelamento;
  IdAttr, NameSpace, NameSpaceCanc, xMotivo, xCodVerif, Prefixo, PrefixoTS,
  xSerie: string;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'N�mero da NFSe n�o informado para cancelamento.';
    Exit;
  end;

  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'C�digo de cancelamento n�o informado para cancelamento.';
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  InfoCanc := Response.InfCancelamento;
  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.CancelarNFSe.xmlns) then
  begin
    NameSpace := '';
    NameSpaceCanc := '';
  end
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.CancelarNFSe.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.CancelarNFSe.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;

    NameSpaceCanc := NameSpace;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.CancelarNFSe.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  if ConfigGeral.Identificador <> '' then
    IdAttr := ' ' + ConfigGeral.Identificador + '="Canc_' +
                    OnlyNumber(Emitente.CNPJ) + OnlyNumber(Emitente.InscMun) +
                    InfoCanc.NumeroNFSe + '"'
  else
    IdAttr := '';

  xSerie := Trim(InfoCanc.SerieNFSe);

  if xSerie <> '' then
    xSerie := '<' + PrefixoTS + 'Serie>' +
                 xSerie +
              '</' + PrefixoTS + 'Serie>';

  xMotivo := Trim(InfoCanc.MotCancelamento);

  if xMotivo <> '' then
    xMotivo := '<' + Prefixo + 'MotivoCancelamento>' +
                 xMotivo +
               '</' + Prefixo + 'MotivoCancelamento>';

  xCodVerif := Trim(InfoCanc.CodVerificacao);

  if xCodVerif <> '' then
    xCodVerif := '<CodigoVerificacao>' + xCodVerif + '</CodigoVerificacao>';

  Response.XmlEnvio := '<' + Prefixo + 'CancelarNfseEnvio' + NameSpace + '>' +
                         '<' + PrefixoTS + 'Pedido>' +
                           '<' + PrefixoTS + 'InfPedidoCancelamento' + IdAttr + NameSpaceCanc + '>' +
                             '<' + PrefixoTS + 'IdentificacaoNfse>' +
                               '<' + PrefixoTS + 'Numero>' +
                                  InfoCanc.NumeroNFSe +
                               '</' + PrefixoTS + 'Numero>' +
                               xSerie +
                               '<' + PrefixoTS + 'CpfCnpj>' +
                                 GetCpfCnpj(Emitente.CNPJ, PrefixoTS) +
                               '</' + PrefixoTS + 'CpfCnpj>' +
                               GetInscMunic(Emitente.InscMun, PrefixoTS) +
                               '<' + PrefixoTS + 'CodigoMunicipio>' +
                                  IntToStr(TACBrNFSeX(FAOwner).Configuracoes.Geral.CodigoMunicipio) +
                               '</' + PrefixoTS + 'CodigoMunicipio>' +
                               xCodVerif +
                             '</' + PrefixoTS + 'IdentificacaoNfse>' +
                             '<' + PrefixoTS + 'CodigoCancelamento>' +
                                InfoCanc.CodCancelamento +
                             '</' + PrefixoTS + 'CodigoCancelamento>' +
                             xMotivo +
                           '</' + PrefixoTS + 'InfPedidoCancelamento>' +
                         '</' + PrefixoTS + 'Pedido>' +
                       '</' + Prefixo + 'CancelarNfseEnvio>';
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  Ret: TRetCancelamento;
  IdAttr: string;
  AErro: TNFSeEventoCollectionItem;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('Cancelamento');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Confirma��o do cancelamento n�o encontrada';
        Exit;
      end;

      ANode := Document.Root.Childrens.FindAnyNs('Confirmacao');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Confirma��o do cancelamento n�o encontrada';
        Exit;
      end;

      Ret :=  Response.RetCancelamento;
      Ret.DataHora := ANode.Childrens.FindAnyNs('DataHoraCancelamento').AsDateTime;

      if ConfigAssinar.IncluirURI then
        IdAttr := ConfigGeral.Identificador
      else
        IdAttr := 'ID';

      ANode := Document.Root.Childrens.FindAnyNs('Pedido').Childrens.FindAnyNs('InfPedidoCancelamento');
      Ret.Pedido.InfID.ID := ANode.Attributes.Items[IdAttr].Content;
      Ret.Pedido.CodigoCancelamento := ANode.Childrens.FindAnyNs('CodigoCancelamento').AsString;

      ANode := Document.Root.Childrens.FindAnyNs('IdentificacaoNfse');
      Ret.Pedido.IdentificacaoNfse.Numero := ANode.Childrens.FindAnyNs('Numero').AsString;
      Ret.Pedido.IdentificacaoNfse.Cnpj := ANode.Childrens.FindAnyNs('Cnpj').AsString;

      AuxNode := ANode.Childrens.FindAnyNs('InscricaoMunicipal');
      if Assigned(AuxNode) then
        Ret.Pedido.IdentificacaoNfse.InscricaoMunicipal := AuxNode.AsString;

      Ret.Pedido.IdentificacaoNfse.CodigoMunicipio := ANode.Childrens.FindAnyNs('CodigoMunicipio').AsString;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.PrepararSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse);
var
  IdAttr, xRps, NameSpace, NumRps, TagEnvio, Prefixo, PrefixoTS: string;
  AErro: TNFSeEventoCollectionItem;
  Nota: NotaFiscal;
begin
  if EstaVazio(Response.PedCanc) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'Pedido de Cancelamento n�o informado.';
    Exit;
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'ERRO: Nenhum RPS adicionado ao componente';
  end;

  if TACBrNFSeX(FAOwner).NotasFiscais.Count > 1 then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := '999';
    AErro.Descricao := 'ERRO: Conjunto de RPS transmitidos (m�ximo de 1 RPS)' +
                       ' excedido. Quantidade atual: ' +
                       IntToStr(TACBrNFSeX(FAOwner).NotasFiscais.Count);
  end;

  if Response.Erros.Count > 0 then Exit;

  Prefixo := '';
  PrefixoTS := '';

  if EstaVazio(ConfigMsgDados.SubstituirNFSe.xmlns) then
    NameSpace := ''
  else
  begin
    if ConfigMsgDados.Prefixo = '' then
      NameSpace := ' xmlns="' + ConfigMsgDados.SubstituirNFSe.xmlns + '"'
    else
    begin
      NameSpace := ' xmlns:' + ConfigMsgDados.Prefixo + '="' + ConfigMsgDados.SubstituirNFSe.xmlns + '"';
      Prefixo := ConfigMsgDados.Prefixo + ':';
    end;
  end;

  if ConfigMsgDados.XmlRps.xmlns <> '' then
  begin
    if ConfigMsgDados.XmlRps.xmlns <> ConfigMsgDados.SubstituirNFSe.xmlns then
    begin
      if ConfigMsgDados.PrefixoTS = '' then
        NameSpace := NameSpace + ' xmlns="' + ConfigMsgDados.XmlRps.xmlns + '"'
      else
      begin
        NameSpace := NameSpace+ ' xmlns:' + ConfigMsgDados.PrefixoTS + '="' +
                                            ConfigMsgDados.XmlRps.xmlns + '"';
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
      end;
    end
    else
    begin
      if ConfigMsgDados.PrefixoTS <> '' then
        PrefixoTS := ConfigMsgDados.PrefixoTS + ':';
    end;
  end;

  Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[0];

  if ConfigAssinar.IncluirURI then
    IdAttr := ConfigGeral.Identificador
  else
    IdAttr := 'ID';

  if EstaVazio(Nota.XMLAssinado) then
  begin
    Nota.GerarXML;
    if ConfigAssinar.RpsSubstituirNFSe then
    begin
      Nota.XMLOriginal := FAOwner.SSL.Assinar(ConverteXMLtoUTF8(Nota.XMLOriginal),
                                              PrefixoTS + ConfigMsgDados.XmlRps.DocElemento,
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

  NumRps := Nota.NFSe.IdentificacaoRps.Numero;

  xRps := RemoverDeclaracaoXML(Nota.XMLOriginal);
  xRps := PrepararRpsParaLote(xRps);

  if ConfigGeral.Identificador <> '' then
    IdAttr := ' ' + ConfigGeral.Identificador + '="Sub_' + OnlyNumber(NumRps) + '"'
  else
    IdAttr := '';

  {
    No servi�o de Substitui��o de NFS-e temos o pedido de cancelamento de uma
    NFS-e mais o RPS que vai ser convertido na NFS-e substituta.

    A NFS-e substituta substitui a NFS-e Cancelada.

    (Response.PedCanc) contem o pedido de cancelamento da NFS-e existente.
    (xRps) contem o RPS que ser� convertido na NFS-e substituta.
  }

  TagEnvio := ConfigMsgDados.SubstituirNFSe.DocElemento;

  Response.XmlEnvio := '<' + Prefixo + TagEnvio + NameSpace + '>' +
                         '<' + Prefixo + 'SubstituicaoNfse' + IdAttr + '>' +
                           Response.PedCanc +
                           xRps +
                         '</' + Prefixo + 'SubstituicaoNfse>' +
                       '</' + Prefixo + TagEnvio + '>';
end;

procedure TACBrNFSeProviderABRASFv2.TratarRetornoSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse);
var
  Document: TACBrXmlDocument;
  ANode, AuxNode: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
  ANota: NotaFiscal;
  NumRps: String;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.XmlRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'WebService retornou um XML vazio.';
        Exit
      end;

      Document.LoadFromXml(Response.XmlRetorno);

      ProcessarMensagemErros(Document.Root, Response);

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root.Childrens.FindAnyNs('RetSubstituicao');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Retorno da Substitui��o n�o encontrada';
        Exit;
      end;

      ANode := ANode.Childrens.FindAnyNs('NfseSubstituida');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Nfse Substituida n�o encontrada';
        Exit;
      end
      else
      begin
        ANode := ANode.Childrens.FindAnyNs('CompNfse');
        if not Assigned(ANode) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := '999';
          AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
          Exit;
        end;

        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');

        if AuxNode <> nil then
        begin
          NumRps := AuxNode.AsString;

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

          if Assigned(ANota) then
            ANota.XML := ANode.OuterXml
          else
          begin
            TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
          end;

          SalvarXmlNfse(ANota);
        end;
      end;

      ANode := Document.Root.Childrens.FindAnyNs('NfseSubstituidora');
      if not Assigned(ANode) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := 'Nfse Substituidora n�o encontrada';
        Exit;
      end
      else
      begin
        ANode := ANode.Childrens.FindAnyNs('CompNfse');
        if not Assigned(ANode) then
        begin
          AErro := Response.Erros.New;
          AErro.Codigo := '999';
          AErro.Descricao := 'N�o foi retornado nenhuma NFSe';
          Exit;
        end;

        AuxNode := ANode.Childrens.FindAnyNs('Nfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('InfNfse');
        AuxNode := AuxNode.Childrens.FindAnyNs('Numero');

        if AuxNode <> nil then
        begin
          NumRps := AuxNode.AsString;

          ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

          if Assigned(ANota) then
            ANota.XML := ANode.OuterXml
          else
          begin
            TACBrNFSeX(FAOwner).NotasFiscais.LoadFromString(ANode.OuterXml, False);
            ANota := TACBrNFSeX(FAOwner).NotasFiscais.Items[TACBrNFSeX(FAOwner).NotasFiscais.Count-1];
          end;

          SalvarXmlNfse(ANota);
        end;
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := '999';
        AErro.Descricao := E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderABRASFv2.ProcessarMensagemErros(const RootNode: TACBrXmlNode;
  const Response: TNFSeWebserviceResponse; AListTag, AMessageTag: string);
var
  I: Integer;
  ANode: TACBrXmlNode;
  ANodeArray: TACBrXmlNodeArray;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('MensagemRetorno');

  {
    Para os servi�os que recepcionam o Lote de Rps tanto no modo ass�ncrono
    quanto no modo s�ncrono do provedor RLZ o nome da tag � diferente.
  }
  if (ANode = nil) then
    ANode := RootNode.Childrens.FindAnyNs('ListaMensagemRetornoLote');

  if (ANode = nil) then Exit;

  ANodeArray := ANode.Childrens.FindAllAnyNs(AMessageTag);
  if not Assigned(ANodeArray) then Exit;

  for I := Low(ANodeArray) to High(ANodeArray) do
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Codigo'), tcStr);
    AErro.Descricao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Mensagem'), tcStr);
    AErro.Correcao := ProcessarConteudoXml(ANodeArray[I].Childrens.FindAnyNs('Correcao'), tcStr);
  end;
end;

end.
