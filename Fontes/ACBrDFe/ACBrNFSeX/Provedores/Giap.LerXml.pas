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

unit Giap.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { Provedor com layout pr�prio }
  { TNFSeR_Giap }

  TNFSeR_Giap = class(TNFSeRClass)
  protected

    procedure LerDadosPrestador(const ANode: TACBrXmlNode);
    procedure LerDadosServico(const ANode: TACBrXmlNode);
    procedure LerDadosTomador(const ANode: TACBrXmlNode);
    procedure LerDetalheServico(const ANode: TACBrXmlNode);
    procedure LerItem(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Giap
//==============================================================================

{ TNFSeR_Giap }

procedure TNFSeR_Giap.LerDadosPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('dadosPrestador');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('dataEmissao'), tcDatVcto);
      Competencia := DataEmissao;

      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numeroNota'), tcStr);

      with IdentificacaoRps do
      begin
        Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numeroRps'), tcStr);
        Serie  := '';
        Tipo   := trRPS;
      end;

      CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);

      with Prestador.IdentificacaoPrestador do
      begin
        InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('im'), tcStr);
      end;
    end;
  end;
end;

procedure TNFSeR_Giap.LerDadosServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('dadosServico');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      RazaoSocial := '';
      IdentificacaoPrestador.CpfCnpj := '';

      with Endereco do
      begin
        Endereco    := ObterConteudo(AuxNode.Childrens.FindAnyNs('logradouro'), tcStr);
        Numero      := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
        Bairro      := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
        Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
        xMunicipio  := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
        UF          := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
        CEP         := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
        xPais       := ObterConteudo(AuxNode.Childrens.FindAnyNs('pais'), tcStr);

        with Contato do
          Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
      end;
    end;
  end;
end;

procedure TNFSeR_Giap.LerDadosTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('dadosTomador');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      with Tomador do
      begin
        RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('nomeTomador'), tcStr);

        with IdentificacaoTomador do
        begin
          InscricaoMunicipal := '';
          CpfCnpj            := ObterConteudo(AuxNode.Childrens.FindAnyNs('documento'), tcStr);
          InscricaoEstadual  := ObterConteudo(AuxNode.Childrens.FindAnyNs('ie'), tcStr);
        end;

        with Endereco do
        begin
          TipoLogradouro  := '';
          Endereco        := ObterConteudo(AuxNode.Childrens.FindAnyNs('logradouro'), tcStr);
          Numero          := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
          Complemento     := ObterConteudo(AuxNode.Childrens.FindAnyNs('complemento'), tcStr);
          TipoBairro      := '';
          Bairro          := ObterConteudo(AuxNode.Childrens.FindAnyNs('bairro'), tcStr);
          CodigoMunicipio := '0';
          xMunicipio      := ObterConteudo(AuxNode.Childrens.FindAnyNs('cidade'), tcStr);
          UF              := ObterConteudo(AuxNode.Childrens.FindAnyNs('uf'), tcStr);
          CEP             := ObterConteudo(AuxNode.Childrens.FindAnyNs('cep'), tcStr);
        end;

        with Contato do
        begin
          Email    := ObterConteudo(AuxNode.Childrens.FindAnyNs('email'), tcStr);
          Telefone := '';
        end;
      end;
    end;
  end;
end;

procedure TNFSeR_Giap.LerDetalheServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('detalheServico');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      Aliquota               := ObterConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe3);
      ValorPis               := ObterConteudo(AuxNode.Childrens.FindAnyNs('pisPasep'), tcDe2);
      ValorCofins            := ObterConteudo(AuxNode.Childrens.FindAnyNs('cofins'), tcDe2);
      ValorInss              := ObterConteudo(AuxNode.Childrens.FindAnyNs('inss'), tcDe2);
      ValorIr                := ObterConteudo(AuxNode.Childrens.FindAnyNs('ir'), tcDe2);
      ValorCsll              := ObterConteudo(AuxNode.Childrens.FindAnyNs('csll'), tcDe2);
      ValorDeducoes          := ObterConteudo(AuxNode.Childrens.FindAnyNs('deducaoMaterial'), tcDe2);
      DescontoIncondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('descontoIncondicional'), tcDe2);

      IssRetido := FpAOwner.StrToSituacaoTributaria(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('issRetido'), tcStr));

      AliquotaPIS    := 0;
      AliquotaCOFINS := 0;
      AliquotaINSS   := 0;
      AliquotaIR     := 0;
      AliquotaCSLL   := 0;
    end;

    NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('obs'), tcStr);

    LerItem(AuxNode);

    with NFSe.Servico.Valores do
    begin
      ValorIss         := (ValorServicos * Aliquota) / 100;
      ValorLiquidoNfse := ValorServicos -
        (ValorDeducoes + DescontoCondicionado + DescontoIncondicionado +
                                                                ValorIssRetido);
      BaseCalculo      := ValorLiquidoNfse;
    end;
  end;
end;

procedure TNFSeR_Giap.LerItem(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('item');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      CodigoCnae       := ObterConteudo(AuxNode.Childrens.FindAnyNs('cnae'), tcStr);
      ItemListaServico := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigo'), tcStr);
      Discriminacao    := ObterConteudo(AuxNode.Childrens.FindAnyNs('descricao'), tcStr);

      with Valores do
      begin
        Aliquota      := ObterConteudo(AuxNode.Childrens.FindAnyNs('aliquota'), tcDe3);
        ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('valor'), tcDe2);
      end;
    end;
  end;
end;

function TNFSeR_Giap.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
  xRetorno: string;
begin
  xRetorno := Arquivo;

  if EstaVazio(xRetorno) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(xRetorno);

  if (Pos('notaFiscal', xRetorno) > 0) then
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

function TNFSeR_Giap.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;
  NFSe.SituacaoNfse := snNormal;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('notaFiscal');

  if AuxNode = nil then Exit;

  LerDadosPrestador(AuxNode);

  NFSe.InfID.ID := OnlyNumber(NFSe.Numero);

  LerDadosServico(AuxNode);
  LerDadosTomador(AuxNode);
  LerDetalheServico(AuxNode);
end;

function TNFSeR_Giap.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := LerXmlNfse(ANode);
end;

end.
