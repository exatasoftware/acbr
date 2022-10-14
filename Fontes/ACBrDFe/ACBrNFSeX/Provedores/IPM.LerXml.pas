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

unit IPM.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { Provedor com layout pr�prio }
  { TNFSeR_IPM }

  TNFSeR_IPM = class(TNFSeRClass)
  private

  protected
    procedure LerRps(const ANode: TACBrXmlNode);
    procedure LerNota(const ANode: TACBrXmlNode);
    procedure LerPrestador(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
    procedure LerItens(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

  { TNFSeR_IPM101 }

  TNFSeR_IPM101 = class(TNFSeR_IPM)

  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     IPM
//==============================================================================

{ TNFSeR_IPM }

procedure TNFSeR_IPM.LerItens(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  aValor: string;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('itens');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      Valores.ValorIssRetido := 0;
      Valores.BaseCalculo := 0;
      Valores.ValorIss := 0;

      ANodes := AuxNode.Childrens.FindAllAnyNs('lista');

      if ANodes = nil then
        ANodes := AuxNode.Childrens.FindAllAnyNs('item');

      for i := 0 to Length(ANodes) - 1 do
      begin
        ItemServico.New;
        with ItemServico[i] do
        begin
          TribMunPrestador := FpAOwner.StrToSimNao(Ok, ObterConteudo(ANodes[i].Childrens.FindAnyNs('tributa_municipio_prestador'), tcStr));
          CodMunPrestacao := CodTOMToCodIBGE(ObterConteudo(ANodes[i].Childrens.FindAnyNs('codigo_local_prestacao_servico'), tcStr));

          aValor := ObterConteudo(ANodes[i].Childrens.FindAnyNs('codigo_item_lista_servico'), tcStr);
          ItemListaServico := PadLeft(aValor, 4, '0');

          aValor := ObterConteudo(ANodes[i].Childrens.FindAnyNs('unidade_codigo'), tcStr);
          TipoUnidade := StrToUnidade(Ok, aValor);

          aValor := ObterConteudo(ANodes[i].Childrens.FindAnyNs('codigo_atividade'), tcStr);
          CodigoCnae := PadLeft(aValor, 9, '0');

          Quantidade := ObterConteudo(ANodes[i].Childrens.FindAnyNs('unidade_quantidade'), tcDe3);
          ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('unidade_valor_unitario'), tcDe2);
          Descricao := ObterConteudo(ANodes[i].Childrens.FindAnyNs('descritivo'), tcStr);
          Aliquota := ObterConteudo(ANodes[i].Childrens.FindAnyNs('aliquota_item_lista_servico'), tcDe2);

          SituacaoTributaria := ObterConteudo(ANodes[i].Childrens.FindAnyNs('situacao_tributaria'), tcInt);

          ValorTotal := ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor_tributavel'), tcDe2);
          ValorDeducoes := ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor_deducao'), tcDe2);
          BaseCalculo := ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor_tributavel'), tcDe2);
          ValorIssRetido := ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor_issrf'), tcDe2);
          ValorISS := BaseCalculo * Aliquota / 100;

          Valores.ValorIssRetido := Valores.ValorIssRetido +
              ObterConteudo(ANodes[i].Childrens.FindAnyNs('valor_issrf'), tcDe2);
          Valores.BaseCalculo := Valores.BaseCalculo + BaseCalculo;
          Valores.ValorIss := Valores.ValorIss + ValorISS;
        end;
      end;
    end;
  end;
end;

procedure TNFSeR_IPM.LerNota(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('nf');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
      CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigo_autenticidade'), tcStr);

      if Trim(CodigoVerificacao) = '' then
        CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('cod_verificador_autenticidade'), tcStr);

      Link := ObterConteudo(AuxNode.Childrens.FindAnyNs('link_nfse'), tcStr);

      // campos presentes ao baixar do site da prefeitura
      if Numero = '' then
      begin
        Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero_nfse'), tcStr);
        SeriePrestacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('serie_nfse'), tcStr);

        aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('data_nfse'), tcStr);
        aValor := aValor + ' ' +
                  ObterConteudo(AuxNode.Childrens.FindAnyNs('hora_nfse'), tcStr);

        DataEmissao := StrToDateTimeDef(aValor, 0);
      end;

      SituacaoNfse := StrToStatusNFSe(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('situacao_codigo_nfse'), tcStr));
      aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('situacao'), tcStr);

      OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('observacao'), tcStr);

      with Servico.Valores do
      begin
        ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_total'), tcDe2);
        ValorIr       := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_ir'), tcDe2);
        ValorInss     := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_inss'), tcDe2);
        ValorCsll     := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_contribuicao_social'), tcDe2);
        ValorPis      := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_pis'), tcDe2);
        ValorCofins   := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_cofins'), tcDe2);

        DescontoIncondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor_desconto'), tcDe2);

        ValorLiquidoNfse := ValorServicos -
                            (ValorPis + ValorCofins + ValorInss + ValorIr +
                             ValorCsll + ValorDeducoes + DescontoCondicionado +
                             DescontoIncondicionado + ValorIssRetido);
      end;
    end;
  end;
end;

procedure TNFSeR_IPM.LerPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('prestador');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      with Prestador.IdentificacaoPrestador do
      begin
        CpfCnpj := OnlyNumber(ObterConteudo(AuxNode.Childrens.FindAnyNs('cpfcnpj'), tcStr));
        CpfCnpj := PadLeft(CpfCnpj, 14, '0');
      end;

      with Prestador.Endereco do
      begin
        CodigoMunicipio := CodTOMToCodIBGE(ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr));
      end;
    end;
  end;
end;

procedure TNFSeR_IPM.LerRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('rps');

  if AuxNode <> nil then
  begin
    aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('data_emissao_recibo_provisorio'), tcStr);
    aValor := aValor + ' ' +
              ObterConteudo(AuxNode.Childrens.FindAnyNs('hora_emissao_recibo_provisorio'), tcStr);

    NFSe.DataEmissao := StrToDateTimeDef(aValor, 0);
    NFSe.DataEmissaoRps := StrToDateTimeDef(aValor, 0);

    with NFSe.IdentificacaoRps do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('nro_recibo_provisorio'), tcStr);
      Serie  := ObterConteudo(AuxNode.Childrens.FindAnyNs('serie_recibo_provisorio'), tcStr);
    end;
  end;
end;

procedure TNFSeR_IPM.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tomador');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nome_razao_social'), tcStr);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('sobrenome_nome_fantasia'), tcStr);

      with Endereco do
      begin
        Endereco        := ObterConteudo(AuxNode.Childrens.FindAnyNs('logradouro'), tcStr);
        Numero          := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero_residencia'), tcStr);
        Complemento     := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
        Bairro          := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
        CodigoMunicipio := CodTOMToCodIBGE(ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr));
        CEP             := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
      end;

      with IdentificacaoTomador do
      begin
        CpfCnpj := OnlyNumber(ObterConteudo(AuxNode.Childrens.FindAnyNs('cpfcnpj'), tcStr));
        aValor  := ObterConteudo(AuxNode.Childrens.FindAnyNs('tipo'), tcStr);

        if ((aValor = 'J') or (aValor = '2')) then
        begin
          CpfCnpj := PadLeft(CpfCnpj, 14, '0');

          if Endereco.CodigoMunicipio = NFSe.Prestador.Endereco.CodigoMunicipio then
            Tipo := tpPJdoMunicipio
          else
            Tipo := tpPJforaMunicipio;
        end
        else
        begin
          CpfCnpj := PadLeft(CpfCnpj, 11, '0');
          Tipo    := tpPF;
        end;

        InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('ie'), tcStr);
      end;

      with Contato do
      begin
        aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('ddd_fone_comercial'), tcStr);
        aValor := aValor +
                  ObterConteudo(AuxNode.Childrens.FindAnyNs('fone_comercial'), tcStr);

        Telefone := aValor;
        Email    := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
      end;
    end;
  end;
end;

function TNFSeR_IPM.LerXml: Boolean;
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

  if (Pos('nfse', Arquivo) > 0) then
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

function TNFSeR_IPM.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('nfse');

  if AuxNode = nil then
    AuxNode := ANode;

  LerRps(AuxNode);
  LerNota(AuxNode);
  LerPrestador(AuxNode);
  LerTomador(AuxNode);
  LerItens(AuxNode);
end;

function TNFSeR_IPM.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := LerXmlNfse(ANode);
end;

end.
