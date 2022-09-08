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

unit ISSSaoPaulo.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_ISSSaoPaulo }

  TNFSeR_ISSSaoPaulo = class(TNFSeRClass)
  protected

    procedure SetxItemListaServico(Codigo: string);

    procedure LerChaveNFe(const ANode: TACBrXmlNode);
    procedure LerChaveRPS(const ANode: TACBrXmlNode);
    procedure LerCPFCNPJPrestador(const ANode: TACBrXmlNode);
    procedure LerEnderecoPrestador(const ANode: TACBrXmlNode);
    procedure LerCPFCNPJTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerCPFCNPJIntermediario(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrDFeUtil;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     ISSSaoPaulo
//==============================================================================

{ TNFSeR_ISSSaoPaulo }

procedure TNFSeR_ISSSaoPaulo.LerChaveNFe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('ChaveNFe');

  if AuxNode <> nil then
  begin
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);

    NFSe.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroNFe'), tcStr);
    NFSe.CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
  end;
end;

procedure TNFSeR_ISSSaoPaulo.LerChaveRPS(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('ChaveRPS');

  if AuxNode <> nil then
  begin
    NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoPrestador'), tcStr);

    NFSe.IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroRPS'), tcStr);
    NFSe.IdentificacaoRps.Serie := ObterConteudo(AuxNode.Childrens.FindAnyNs('SerieRPS'), tcStr);
    NFSe.IdentificacaoRps.Tipo := trRPS;

    if NFSe.InfID.ID = '' then
      NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) +
                       NFSe.IdentificacaoRps.Serie;
  end;
end;

procedure TNFSeR_ISSSaoPaulo.LerCPFCNPJIntermediario(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('CPFCNPJIntermediario');

  if AuxNode <> nil then
  begin
    NFSe.Intermediario.Identificacao.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CNPJ'), tcStr);

    if NFSe.Intermediario.Identificacao.CpfCnpj = '' then
      NFSe.Intermediario.Identificacao.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CPF'), tcStr);
  end;
end;

procedure TNFSeR_ISSSaoPaulo.LerCPFCNPJPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('CPFCNPJPrestador');

  if AuxNode <> nil then
  begin
    NFSe.Prestador.IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CNPJ'), tcStr);

    if NFSe.Prestador.IdentificacaoPrestador.CpfCnpj = '' then
      NFSe.Prestador.IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CPF'), tcStr);
  end;
end;

procedure TNFSeR_ISSSaoPaulo.LerCPFCNPJTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('CPFCNPJTomador');

  if AuxNode <> nil then
    NFSe.Tomador.IdentificacaoTomador.CpfCnpj := ObterCNPJCPF(AuxNode);
end;

procedure TNFSeR_ISSSaoPaulo.LerEnderecoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  CodigoIBGE: Integer;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('EnderecoPrestador');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      TipoLogradouro  := ObterConteudo(AuxNode.Childrens.FindAnyNs('TipoLogradouro'), tcStr);
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('Logradouro'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroEndereco'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('ComplementoEndereco'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      CodigoIBGE := StrToIntDef(CodigoMunicipio, 0);

      if CodigoIBGE > 0 then
        xMunicipio := ObterNomeMunicipio(CodigoIBGE, xUF);

      if UF = '' then
        UF := xUF;
    end;
  end;
end;

procedure TNFSeR_ISSSaoPaulo.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  CodigoIBGE: Integer;
  xUF: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('EnderecoTomador');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      TipoLogradouro  := ObterConteudo(AuxNode.Childrens.FindAnyNs('TipoLogradouro'), tcStr);
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('Logradouro'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroEndereco'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('ComplementoEndereco'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cidade'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      CodigoIBGE := StrToIntDef(CodigoMunicipio, 0);

      if CodigoIBGE > 0 then
        xMunicipio := ObterNomeMunicipio(CodigoIBGE, xUF);

      if UF = '' then
        UF := xUF;
    end;

    NFSe.Servico.CodigoMunicipio := NFSe.Tomador.Endereco.CodigoMunicipio;
  end;
end;

function TNFSeR_ISSSaoPaulo.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  Arquivo := NormatizarXml(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  if (Pos('NFe', Arquivo) > 0) then
    tpXML := txmlNFSe
  else
    tpXML := txmlRPS;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_ISSSaoPaulo.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
  aValor: string;
  Ok :Boolean;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode;

  NFSe.dhRecebimento := Now;
  NFSe.SituacaoNfse := snNormal;
  NFSe.NumeroLote := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroLote'), tcStr);
  NFSe.DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('DataEmissaoNFe'), tcDatHor);
  NFSe.DataEmissaoRps := ObterConteudo(AuxNode.Childrens.FindAnyNs('DataEmissaoRPS'), tcDat);
  NFSe.Competencia := NFSe.DataEmissao;

  aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('StatusNFe'), tcStr);

  if aValor = 'C' then
    NFSe.SituacaoNfse := snCancelado;

  NFSe.TipoTributacaoRPS := StrToTipoTributacaoRPS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('TributacaoNFe'), tcStr));

  aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('OpcaoSimples'), tcStr);

  if aValor = '0' then
    NFSe.OptanteSimplesNacional := snNao
  else
    NFSe.OptanteSimplesNacional := snSim;

  aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoServico'), tcStr);

  SetxItemListaServico(aValor);

  NFSe.Servico.Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('Discriminacao'), tcStr);

  aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('ISSRetido'), tcStr);

  with NFSe.Servico.Valores do
  begin
    ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorServicos'), tcDe2);
    BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorServicos'), tcDe2);
    Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaServicos'), tcDe2);
    ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorISS'), tcDe2);
    ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorPIS'), tcDe2);
    ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorCOFINS'), tcDe2);
    ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorINSS'), tcDe2);
    ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorIR'), tcDe2);
    ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorCSLL'), tcDe2);

    if aValor = 'false' then
      IssRetido := stNormal
    else
      IssRetido := stRetencao;

    ValorLiquidoNfse := ValorServicos -
                        (ValorPis + ValorCofins + ValorInss + ValorIr + ValorCsll +
                         ValorDeducoes + DescontoCondicionado +
                         DescontoIncondicionado + ValorIssRetido);
  end;

  with NFSe.ValoresNfse do
  begin
    ValorLiquidoNfse := NFSe.Servico.Valores.ValorLiquidoNfse;
    BaseCalculo := NFSe.Servico.Valores.BaseCalculo;
    Aliquota := NFSe.Servico.Valores.Aliquota;
    ValorIss := NFSe.Servico.Valores.ValorIss;
    Aliquota := (NFSe.ValoresNfse.Aliquota * 100);
  end;

  NFSe.Prestador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocialPrestador'), tcStr);
  NFSe.Prestador.Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('EmailPrestador'), tcStr);

  NFSe.Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocialTomador'), tcStr);
  NFSe.Tomador.Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('EmailTomador'), tcStr);

  LerChaveNFe(AuxNode);
  LerChaveRPS(AuxNode);
  LerCPFCNPJPrestador(AuxNode);
  LerEnderecoPrestador(AuxNode);
  LerCPFCNPJTomador(AuxNode);
  LerEnderecoTomador(AuxNode);
end;

function TNFSeR_ISSSaoPaulo.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  aValor: string;
begin
  Result := True;

  with NFSe do
  begin
    Assinatura := ObterConteudo(ANode.Childrens.FindAnyNs('Assinatura'), tcStr);
    DataEmissao := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcDat);

    aValor := ObterConteudo(ANode.Childrens.FindAnyNs('StatusRPS'), tcStr);

    if aValor = 'N' then
      StatusRps := srNormal
    else
      StatusRps := srCancelado;

    TipoTributacaoRPS := ObterConteudo(ANode.Childrens.FindAnyNs('TributacaoRPS'), tcStr);

    LerChaveRPS(ANode);

    with Servico do
    begin
      ItemListaServico := ObterConteudo(ANode.Childrens.FindAnyNs('CodigoServico'), tcStr);
      Discriminacao := ObterConteudo(ANode.Childrens.FindAnyNs('Discriminacao'), tcStr);
      ValorCargaTributaria := ObterConteudo(ANode.Childrens.FindAnyNs('ValorCargaTributaria'), tcDe2);
      PercentualCargaTributaria := ObterConteudo(ANode.Childrens.FindAnyNs('PercentualCargaTributaria'), tcDe4);
      FonteCargaTributaria := ObterConteudo(ANode.Childrens.FindAnyNs('FonteCargaTributaria'), tcStr);
      MunicipioIncidencia := ObterConteudo(ANode.Childrens.FindAnyNs('MunicipioPrestacao'), tcInt);

      with Valores do
      begin
        ValorServicos := ObterConteudo(ANode.Childrens.FindAnyNs('ValorServicos'), tcDe2);
        ValorDeducoes := ObterConteudo(ANode.Childrens.FindAnyNs('ValorDeducoes'), tcDe2);
        ValorPis := ObterConteudo(ANode.Childrens.FindAnyNs('ValorPIS'), tcDe2);
        ValorCofins := ObterConteudo(ANode.Childrens.FindAnyNs('ValorCOFINS'), tcDe2);
        ValorInss := ObterConteudo(ANode.Childrens.FindAnyNs('ValorINSS'), tcDe2);
        ValorIr := ObterConteudo(ANode.Childrens.FindAnyNs('ValorIR'), tcDe2);
        ValorCsll := ObterConteudo(ANode.Childrens.FindAnyNs('ValorCSLL'), tcDe2);
        Aliquota := ObterConteudo(ANode.Childrens.FindAnyNs('AliquotaServicos'), tcDe4);

        aValor := ObterConteudo(ANode.Childrens.FindAnyNs('ISSRetido'), tcStr);

        if aValor = 'true' then
          IssRetido := stRetencao
        else
          IssRetido := stNormal;
      end;
    end;

    LerCPFCNPJTomador(ANode);

    with Tomador do
    begin
      RazaoSocial := ObterConteudo(ANode.Childrens.FindAnyNs('RazaoSocialTomador'), tcStr);

      with IdentificacaoTomador do
      begin
        InscricaoMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipalTomador'), tcStr);
        InscricaoEstadual := ObterConteudo(ANode.Childrens.FindAnyNs('InscricaoEstadualTomador'), tcStr);
      end;

      with Contato do
      begin
        Email := ObterConteudo(ANode.Childrens.FindAnyNs('EmailTomador'), tcStr);
      end;
    end;

    LerEnderecoTomador(ANode);
    LerCPFCNPJIntermediario(ANode);

    with Intermediario do
    begin
      Identificacao.InscricaoMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipalIntermediario'), tcStr);
      Contato.EMail := ObterConteudo(ANode.Childrens.FindAnyNs('EmailIntermediario'), tcStr);

      aValor := ObterConteudo(ANode.Childrens.FindAnyNs('ISSRetidoIntermediario'), tcStr);

      if aValor = 'true' then
        IssRetido := stRetencao
      else
        IssRetido := stNormal;
    end;

    with ConstrucaoCivil do
    begin
      nCei := ObterConteudo(ANode.Childrens.FindAnyNs('CodigoCEI'), tcStr);
      nMatri := ObterConteudo(ANode.Childrens.FindAnyNs('MatriculaObra'), tcStr);
      nNumeroEncapsulamento := ObterConteudo(ANode.Childrens.FindAnyNs('NumeroEncapsulamento'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ISSSaoPaulo.SetxItemListaServico(Codigo: string);
var
  Item: Integer;
  ItemServico: string;
begin
  NFSe.Servico.ItemListaServico := Codigo;

  Item := StrToIntDef(OnlyNumber(Nfse.Servico.ItemListaServico), 0);
  if Item < 100 then
    Item := Item * 100 + 1;

  ItemServico := FormatFloat('0000', Item);

  NFSe.Servico.ItemListaServico := Copy(ItemServico, 1, 2) + '.' +
                                     Copy(ItemServico, 3, 2);

  if FpAOwner.ConfigGeral.TabServicosExt then
    NFSe.Servico.xItemListaServico := ObterDescricaoServico(ItemServico)
  else
    NFSe.Servico.xItemListaServico := CodItemServToDesc(ItemServico);
end;

end.
