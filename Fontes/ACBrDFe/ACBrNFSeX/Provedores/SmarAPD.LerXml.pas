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

unit SmarAPD.LerXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml, ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_SmarAPD }

  TNFSeR_SmarAPD = class(TNFSeRClass)
  protected

    procedure LerItens(const ANode: TACBrXmlNode);
    procedure LerFatura(const ANode: TACBrXmlNode);
    procedure LerFaturas(const ANode: TACBrXmlNode);
    procedure LerServico(const ANode: TACBrXmlNode);
    procedure LerServicos(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

  { TNFSeR_SmarAPDv203 }

  TNFSeR_SmarAPDv203 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

  { TNFSeR_SmarAPDv204 }

  TNFSeR_SmarAPDv204 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     SmarAPD
//==============================================================================

{ TNFSeR_SmarAPD }

procedure TNFSeR_SmarAPD.LerFatura(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tbfatura');

  if AuxNode = nil then Exit;

  LerFaturas(AuxNode);
end;

procedure TNFSeR_SmarAPD.LerFaturas(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  ANodes := ANode.Childrens.FindAllAnyNs('fatura');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.CondicaoPagamento.Parcelas.New;

    with NFSe.CondicaoPagamento.Parcelas[i] do
    begin
      Parcela := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('numfatura'), tcInt);
      DataVencimento := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('vencimentofatura'), tcDatVcto);
      Valor := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('valorfatura'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_SmarAPD.LerItens(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  ANodes := ANode.Childrens.FindAllAnyNs('ITENS');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.Servico.ItemServico.New;

    with NFSe.Servico.ItemServico[i] do
    begin
      if NFSe.Servico.Discriminacao = '' then
        NFSe.Servico.Discriminacao := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('Servico'), tcStr);

      Descricao     := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('Servico'), tcStr);
      Quantidade    := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('Quantidade'), tcDe2);
      ValorUnitario := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('ValorUnitario'), tcDe2);
      ValorTotal    := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('ValorTotal'), tcDe2);
      Aliquota      := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('Aliquota'), tcDe2);
      Tributavel := snSim;
      NFSe.Servico.Valores.ValorServicos := (NFSe.Servico.Valores.ValorServicos +
                                                                  ValorTotal);
    end;
  end;
end;

procedure TNFSeR_SmarAPD.LerServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tbservico');

  if AuxNode = nil then Exit;

  LerServicos(AuxNode);
end;

procedure TNFSeR_SmarAPD.LerServicos(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  aValor: string;
begin
  ANodes := ANode.Childrens.FindAllAnyNs('servico');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.Servico.ItemServico.New;

    with NFSe.Servico.ItemServico[i] do
    begin
      Quantidade := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('quantidade'), tcDe2);
      Descricao := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('descricao'), tcStr);
      CodServ := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('codatividade'), tcStr);
      ValorUnitario := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('valorunitario'), tcDe2);
      Aliquota := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('aliquota'), tcDe2);
      aValor := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('impostoretido'), tcStr);

      if aValor = 'True' then
        NFSe.Servico.Valores.IssRetido := stRetencao
      else
        NFSe.Servico.Valores.IssRetido := stNormal;
    end;
  end;
end;

function TNFSeR_SmarAPD.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
  xRetorno: string;
begin
  xRetorno := TratarRetorno(Arquivo);

  if EstaVazio(xRetorno) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(xRetorno);

  if (Pos('nfdok', xRetorno) > 0) then
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
end;

function TNFSeR_SmarAPD.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
  aValor: string;
  Ok: Boolean;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NFe');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('CompNfse');

  if AuxNode = nil then Exit;

  with NFSe do
  begin
    Numero            := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NumeroNota'), tcStr);
    CodigoVerificacao := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ChaveValidacao'), tcStr);
    DataEmissaoRps    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('DataEmissao'), tcDatHor);
    Competencia       := DataEmissaoRps;
    DataEmissao       := DataEmissaoRps;
    dhRecebimento     := DataEmissaoRps;

    aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NaturezaOperacao'), tcStr);
    NaturezaOperacao := StrToNaturezaOperacao(Ok, aValor);

    Protocolo         := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ChaveValidacao'), tcStr);
    OutrasInformacoes := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Observacao'), tcStr);

    MotivoCancelamento           := '';
    IntermediarioServico.CpfCnpj := '';

    aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('SituacaoNf'), tcStr);

    if aValor = 'Cancelada' then
    begin
      Status    := srCancelado;
      Cancelada := snSim;
      NfseCancelamento.DataHora := DataEmissao;
    end
    else
    begin
      Status    := srNormal;
      Cancelada := snNao;
    end;

    IdentificacaoRps.Numero := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);
    IdentificacaoRps.Tipo   := trRPS;
    InfID.ID                := OnlyNumber(NFSe.Numero);

    with Prestador do
    begin
      RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('TimbreContribuinteLinha1'), tcStr);

      with Endereco do
      begin
        aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('TimbreContribuinteLinha2'), tcStr);
        Endereco := Trim(copy(aValor, 1, pos(',', aValor) -1));
        Numero   := Trim(copy(aValor, pos(',', aValor) +1,
                                     (pos('-', aValor) - pos(',', aValor)) -1));
        Bairro   := Trim(copy(aValor, pos('-', aValor) +1, length(aValor) -1));
        Complemento := '';
        aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('TimbreContribuinteLinha3'), tcStr);
        aValor := Trim(copy(aValor, pos('-', aValor) +1, length(aValor) -1));
        xMunicipio := Trim(copy(aValor, 1, pos('-', aValor) -1));
        UF         := Trim(copy(aValor, pos('-', aValor) +1, length(aValor) -1));

        with Contato do
        begin
          Email    := '';
          Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('TelefoneTomador'), tcStr);
        end;
      end;

      aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('TimbreContribuinteLinha4'), tcStr);

      with IdentificacaoPrestador do
      begin
        InscricaoMunicipal := Trim(copy(aValor, 23, (pos('CPF/CNPJ:', aValor) -24)));
        Cnpj               := Trim(copy(aValor, pos('CPF/CNPJ:', aValor) +10,
                                                            length(aValor) -1));
      end;
    end;

    with Tomador do
    begin
      RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteNomeRazaoSocial'), tcStr);

      with IdentificacaoTomador do
      begin
       InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteInscricaoMunicipal'), tcStr);
       CpfCnpj            := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteCNPJCPF'), tcStr);
      end;

      with Endereco do
      begin
        TipoLogradouro  := '';
        Endereco        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteEndereco'), tcStr);
        Numero          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteNumeroLogradouro'), tcStr);
        Complemento     := '';
        TipoBairro      := '';
        Bairro          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteBairro'), tcStr);
        CodigoMunicipio := '0';
        xMunicipio      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteCidade'), tcStr);
        UF              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteUF'), tcStr);
        CEP             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteCEP'), tcStr);
      end;

      with Contato do
      begin
        Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteEmail'), tcStr);
        Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ClienteFone'), tcStr);
      end;
    end;

    with Servico do
    begin
      CodigoCnae := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoAtividade'), tcStr);
      CodigoMunicipio := '';

      with Valores do
      begin
        Aliquota := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe3);

        aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ImpostoRetido'), tcStr);

        if aValor = 'true' then
        begin
          IssRetido := stRetencao;
          ValorIssRetido := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ISSQNCliente'), tcDe2);
        end
        else
          IssRetido := stNormal;

        ValorPis       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Pis'), tcDe2);
        ValorCofins    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Cofins'), tcDe2);
        ValorInss      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Inss'), tcDe2);
        ValorIr        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Irrf'), tcDe2);
        ValorCsll      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Csll'), tcDe2);
        AliquotaPIS    := 0;
        AliquotaCOFINS := 0;
        AliquotaINSS   := 0;
        AliquotaIR     := 0;
        AliquotaCSLL   := 0;
      end;

      Discriminacao             := '';
      CodigoTributacaoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CodigoAtividade'), tcStr);
    end;

    LerItens(AuxNode);

    with Servico.Valores do
    begin
      ValorIss         := (ValorServicos * Aliquota) /100;
      ValorLiquidoNfse := ValorServicos -
                                      (ValorDeducoes + DescontoCondicionado +
                                       DescontoIncondicionado + ValorIssRetido);
      BaseCalculo      := ValorLiquidoNfse;
    end;
  end;
end;

function TNFSeR_SmarAPD.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  aValor: string;
begin
  Result := True;

  with NFSe do
  begin
    with IdentificacaoRps do
    begin
      Serie := ProcessarConteudo(ANode.Childrens.FindAnyNs('codseriedocumento'), tcStr);
      Numero := ProcessarConteudo(ANode.Childrens.FindAnyNs('numerort'), tcStr);
    end;

    DataEmissaoRps := ProcessarConteudo(ANode.Childrens.FindAnyNs('dataemissaort'), tcDatVcto);
    Competencia := ProcessarConteudo(ANode.Childrens.FindAnyNs('fatorgerador'), tcDatVcto);
    NaturezaOperacao := ProcessarConteudo(ANode.Childrens.FindAnyNs('codnaturezaoperacao'), tcStr);

    with Prestador do
    begin
      with IdentificacaoPrestador do
      begin
        InscricaoMunicipal := ProcessarConteudo(ANode.Childrens.FindAnyNs('inscricaomunicipalemissor'), tcStr);
      end;
    end;

    DataEmissao := ProcessarConteudo(ANode.Childrens.FindAnyNs('dataemissao'), tcDatVcto);

    with Tomador do
    begin
      RazaoSocial := ProcessarConteudo(ANode.Childrens.FindAnyNs('razaotomador'), tcStr);
      NomeFantasia := ProcessarConteudo(ANode.Childrens.FindAnyNs('nomefantasiatomador'), tcStr);

      with IdentificacaoTomador do
      begin
        CpfCnpj := ProcessarConteudo(ANode.Childrens.FindAnyNs('cpfcnpjtomador'), tcStr);
        InscricaoEstadual := ProcessarConteudo(ANode.Childrens.FindAnyNs('inscricaoestadualtomador'), tcStr);
        InscricaoMunicipal := ProcessarConteudo(ANode.Childrens.FindAnyNs('inscricaomunicipaltomador'), tcStr);
      end;

      with Endereco do
      begin
        aValor := ProcessarConteudo(ANode.Childrens.FindAnyNs('tppessoa'), tcStr);

        if aValor = 'O' then
          CodigoMunicipio := '9999999'
        else
          CodigoMunicipio := '0'; // precisa implementar uma fun��o que retorna o
                                  // codigo da cidade informando o nome dela.

        Endereco := ProcessarConteudo(ANode.Childrens.FindAnyNs('enderecotomador'), tcStr);
        Numero := ProcessarConteudo(ANode.Childrens.FindAnyNs('numeroendereco'), tcStr);
        xMunicipio := ProcessarConteudo(ANode.Childrens.FindAnyNs('cidadetomador'), tcStr);
        UF := ProcessarConteudo(ANode.Childrens.FindAnyNs('estadotomador'), tcStr);
        xPais := ProcessarConteudo(ANode.Childrens.FindAnyNs('paistomador'), tcStr);
        CEP := ProcessarConteudo(ANode.Childrens.FindAnyNs('ceptomador'), tcStr);
        Bairro := ProcessarConteudo(ANode.Childrens.FindAnyNs('bairrotomador'), tcStr);
      end;

      with Contato do
      begin
        Telefone := ProcessarConteudo(ANode.Childrens.FindAnyNs('fonetomador'), tcStr);
        Email := ProcessarConteudo(ANode.Childrens.FindAnyNs('emailtomador'), tcStr);
      end;
    end;

    OutrasInformacoes := ProcessarConteudo(ANode.Childrens.FindAnyNs('observacao'), tcStr);

    LerFatura(ANode);
    LerServico(ANode);

    with Transportadora do
    begin
      xNomeTrans := ProcessarConteudo(ANode.Childrens.FindAnyNs('razaotransportadora'), tcStr);
      xCpfCnpjTrans := ProcessarConteudo(ANode.Childrens.FindAnyNs('cpfcnpjtransportadora'), tcStr);
      xEndTrans := ProcessarConteudo(ANode.Childrens.FindAnyNs('enderecotransportadora'), tcStr);
    end;

    with Servico do
    begin
      with Valores do
      begin
        ValorPis := ProcessarConteudo(ANode.Childrens.FindAnyNs('pis'), tcDe2);
        ValorCofins := ProcessarConteudo(ANode.Childrens.FindAnyNs('cofins'), tcDe2);
        ValorCsll := ProcessarConteudo(ANode.Childrens.FindAnyNs('csll'), tcDe2);
        ValorIr := ProcessarConteudo(ANode.Childrens.FindAnyNs('irrf'), tcDe2);
        ValorInss := ProcessarConteudo(ANode.Childrens.FindAnyNs('inss'), tcDe2);
        JustificativaDeducao := ProcessarConteudo(ANode.Childrens.FindAnyNs('descdeducoesconstrucao'), tcStr);
        ValorDeducoes := ProcessarConteudo(ANode.Childrens.FindAnyNs('totaldeducoesconstrucao'), tcDe2);
      end;
    end;
  end;
end;

end.
