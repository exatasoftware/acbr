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

unit Infisc.LerXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils, DateUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { Provedor com layout pr�prio }
  { TNFSeR_Infisc }

  TNFSeR_Infisc = class(TNFSeRClass)
  protected

    // vers�o 1.0
    procedure LerId(const ANode: TACBrXmlNode);
    procedure LerEmitente(const ANode: TACBrXmlNode);
    procedure LerEnderecoEmitente(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerServicos(const ANode: TACBrXmlNode);
    procedure LerTotal(const ANode: TACBrXmlNode);
    procedure LerFatura(const ANode: TACBrXmlNode);
    procedure LerISS(const ANode: TACBrXmlNode);
    procedure LerCobranca(const ANode: TACBrXmlNode);
    procedure LerObservacoes(const ANode: TACBrXmlNode);
    procedure LerReembolso(const ANode: TACBrXmlNode);
    procedure LerISSST(const ANode: TACBrXmlNode);
    // vers�o 1.1
    procedure LerDespesas(const ANode: TACBrXmlNode);
    procedure LerRetencao(const ANode: TACBrXmlNode);
    procedure LerTransportadora(const ANode: TACBrXmlNode);
    procedure LerFaturas(const ANode: TACBrXmlNode);
    procedure LerInformacoesAdic(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

  { TNFSeR_Infiscv2 }

  TNFSeR_Infiscv2 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Infisc
//==============================================================================

{ TNFSeR_Infisc }

procedure TNFSeR_Infisc.LerCobranca(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('cobr');

  if AuxNode <> nil then
  begin
    // Cobran�a - Falta implementar
  end;
end;

procedure TNFSeR_Infisc.LerDespesas(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: integer;
begin
  ANodes := ANode.Childrens.FindAllAnyNs('despesas');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.Despesa.New;
    with NFSe.Despesa.Items[i] do
    begin
      nItemDesp := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('nItemDesp'), tcStr);
      xDesp     := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('xDesp'), tcStr);
      dDesp     := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('dDesp'), tcDat);
      vDesp     := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('vDesp'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerEmitente(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('emit');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('prest');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      RazaoSocial  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);
      NomeFantasia := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xFant'), tcStr);

      with IdentificacaoPrestador do
      begin
        Cnpj               := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CNPJ'), tcStr);
        InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);

        // vers�o 1.1
        InscricaoEstadual := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IE'), tcStr);
      end;
    end;

    LerEnderecoEmitente(AuxNode);

    // versao 1.1
    aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('regimeTrib'), tcStr);

    case StrToIntDef(aValor, 1) of
      1: NFSe.RegimeEspecialTributacao := retSimplesNacional;
      2: NFSe.RegimeEspecialTributacao := retMicroempresarioEmpresaPP;
    else
      NFSe.RegimeEspecialTributacao := retLucroReal;
    end;

    with NFSe.Prestador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xEmail'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerEnderecoEmitente(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('end');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      Endereco        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
      UF              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
      CEP             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      // vers�o 1.1
      CodigoPais := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcInt);
      xPais      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xPais'), tcStr);
    end;

    with NFSe.Prestador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xEmail'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('ender');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xLgr'), tcStr);
      Numero          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('nro'), tcStr);
      Complemento     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xCpl'), tcStr);
      Bairro          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xBairro'), tcStr);
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cMun'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
      UF              := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('UF'), tcStr);
      CEP             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CEP'), tcStr);

      // vers�o 1.1
      CodigoPais := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cPais'), tcInt);
      xPais      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xPais'), tcStr);
    end;

    with NFSe.Tomador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xEmail'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerFatura(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('fat');

  if AuxNode <> nil then
  begin
    // Fatura - Falta implementar
  end;
end;

procedure TNFSeR_Infisc.LerFaturas(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  AuxNode := ANode.Childrens.FindAnyNs('faturas');

  if AuxNode <> nil then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('fat');

    for i := 0 to Length(ANodes) - 1 do
    begin
      NFSe.CondicaoPagamento.Parcelas.New;
      with NFSe.CondicaoPagamento.Parcelas[i] do
      begin
        Parcela        := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('nFat'), tcStr);
        DataVencimento := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('dVenc'), tcDat);
        Valor          := ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('vFat'), tcDe2);
      end;
    end;
  end;
end;

procedure TNFSeR_Infisc.LerId(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
  hEmi, aValor: string;
  Ano, Mes, Dia: Word;
  Hora, Minuto: Integer;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Id');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      CodigoVerificacao := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cNFS-e'), tcStr);
      NaturezaOperacao  := StrToNaturezaOperacao(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('natOp'), tcStr));
      SeriePrestacao    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('serie'), tcStr);
      Numero            := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('nNFS-e'), tcStr);
      Competencia       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('dEmi'), tcDat);
      refNF             := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('refNF'), tcStr);

      InfID.ID := OnlyNumber(CodigoVerificacao);

      hEmi   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('hEmi'), tcStr);
      Hora   := strToInt(Copy(hEmi, 1 , 2));
      Minuto := strToInt(copy(hEmi, 4 , 2));

      Ano := YearOf(Competencia);
      Mes := MonthOf(Competencia);
      Dia := DayOf(Competencia);

      DataEmissao := EncodeDateTime( ano, mes, dia, hora, minuto, 0, 0);

      aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('anulada'), tcStr);

      Status := StrToEnumerado(Ok, aValor, ['N','S'], [srNormal, srCancelado]);

      Servico.CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cMunFG'), tcStr);

      Servico.MunicipioIncidencia := StrToIntDef(Servico.CodigoMunicipio, 0);
      // vers�o 1.1
      ModeloNFSe := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('mod'), tcStr);

      aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cancelada'), tcStr);
      Cancelada := StrToSimNaoInFisc(Ok, aValor);

      MotivoCancelamento := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('motCanc'), tcStr);

      aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('ambienteEmi'), tcStr);
      Producao := StrToSimNaoInFisc(Ok, aValor);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerInformacoesAdic(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  NFSe.OutrasInformacoes := '';

  ANodes := ANode.Childrens.FindAllAnyNs('infAdic');

  for i := 0 to Length(ANodes) - 1 do
  begin
    NFSe.OutrasInformacoes := NFSe.OutrasInformacoes +
                  ProcessarConteudo(ANodes[i].Childrens.FindAnyNs('infAdic'), tcStr);
  end;
end;

procedure TNFSeR_Infisc.LerISS(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('ISS');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      BaseCalculo    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vBCISS'), tcDe2);
      ValorIss       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vISS'), tcDe2);
      ValorIssRetido := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vSTISS'), tcDe2);

      if ValorIssRetido > 0 then
      begin
        IssRetido := stRetencao;
        NFSe.Servico.MunicipioIncidencia := StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0);
      end;
    end;
  end;
end;

procedure TNFSeR_Infisc.LerISSST(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('ISSST');

  if AuxNode <> nil then
  begin
    // ISS Substitui��o Tribut�ria - Falta Implementar
  end;
end;

procedure TNFSeR_Infisc.LerObservacoes(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Observacoes');

  if AuxNode <> nil then
    NFSe.OutrasInformacoes := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xInf'), tcStr);
end;

procedure TNFSeR_Infisc.LerReembolso(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('reemb');

  if AuxNode <> nil then
  begin
    // Reembolso - Falta Implementar
  end;
end;

procedure TNFSeR_Infisc.LerRetencao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Ret');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorIr     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetIR'), tcDe2);
      ValorPis    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetPISPASEP'), tcDe2);
      ValorCofins := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetCOFINS'), tcDe2);
      ValorCsll   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetCSLL'), tcDe2);
      ValorInss   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetINSS'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerServicos(const ANode: TACBrXmlNode);
var
  ANodes: TACBrXmlNodeArray;
  i: integer;
  AuxNode: TACBrXmlNode;
  AuxNodeItem: TACBrXmlNode;
begin
  NFSe.Servico.MunicipioIncidencia := 0;

  ANodes := ANode.Childrens.FindAllAnyNs('det');

  for i := 0 to Length(ANodes) - 1 do
  begin
    AuxNode := ANodes[i].Childrens.FindAnyNs('serv');

    if AuxNode <> nil then
    begin
      NFSe.Servico.ItemServico.New;
      with NFSe.Servico.ItemServico[i] do
      begin
        CodServ       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cServ'), tcStr);
        Descricao     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xServ'), tcStr);
        Descricao     := CodServ + ' - ' + Descricao;
        Quantidade    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('qTrib'), tcDe4);
        ValorUnitario := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vUnit'), tcDe3);
        ValorTotal    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vServ'), tcDe2);

        DescontoIncondicionado := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vDesc'), tcDe2);

        Aliquota    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('pISS'), tcDe2);
        ValorIss    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vISS'), tcDe2);
        BaseCalculo := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vBCISS'), tcDe2);

        ValorIr  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetIRF'), tcDe2);
        ValorPis := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetLei10833-PIS-PASEP'), tcDe2);

        if ValorPis = 0 then
          ValorPis := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetPISPASEP'), tcDe2);

        ValorCofins := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetLei10833-COFINS'), tcDe2);

        if ValorCofins = 0 then
          ValorCofins := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetCOFINS'), tcDe2);

        ValorCsll := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetLei10833-CSLL'), tcDe2);

        if ValorCsll = 0 then
          ValorCsll := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetCSLL'), tcDe2);

        ValorInss := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vRetINSS'), tcDe2);

        // vers�o 1.1
        CodLCServ := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cLCServ'), tcStr);
        ValorTotal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vServ'), tcDe3);

        AuxNodeItem := AuxNode.Childrens.FindAnyNs('ISSST');

        if AuxNodeItem <> nil then
        begin
          AliquotaISSST := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('pISSST'), tcDe2);
          ValorISSST    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vISSST'), tcDe2);
        end;
      end;

      // vers�o 1.1
      if NFSe.Servico.MunicipioIncidencia = 0 then
        NFSe.Servico.MunicipioIncidencia := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('localTributacao'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('TomS');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador do
    begin
      RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xNome'), tcStr);

      with IdentificacaoTomador do
      begin
        CpfCnpj            := ProcessarCNPJCPF(AuxNode);
        InscricaoMunicipal := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IM'), tcStr);
        InscricaoEstadual  := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('IE'), tcStr);
      end;
    end;

    LerEnderecoTomador(AuxNode);

    with NFSe.Tomador.Contato do
    begin
      Telefone := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('fone'), tcStr);
      Email    := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xEmail'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Infisc.LerTotal(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('total');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorServicos          := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vServ'), tcDe2);
      DescontoIncondicionado := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vDesc'), tcDe2);
      ValorLiquidoNfse       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vtLiq'), tcDe2);

      // vers�o 1.1
      ValorDespesasNaoTributaveis := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vtDespesas'), tcDe2);
    end;

    LerFatura(AuxNode);
    LerISS(AuxNode);
    LerRetencao(AuxNode);
  end;
end;

procedure TNFSeR_Infisc.LerTransportadora(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('transportadora');

  if AuxNode <> nil then
  begin
    with NFSe.Transportadora do
    begin
      xNomeTrans      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xNomeTrans'), tcStr);
      xCpfCnpjTrans   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xCpfCnpjTrans'), tcStr);
      xInscEstTrans   := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xInscEstTrans'), tcStr);
      xPlacaTrans     := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xPlacaTrans'), tcStr);
      xEndTrans       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xEndTrans'), tcStr);
      cMunTrans       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cMunTrans'), tcStr);
      xMunTrans       := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xMunTrans'), tcStr);
      xUFTrans        := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('xUfTrans'), tcStr);
      cPaisTrans      := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('cPaisTrans'), tcStr);
      vTipoFreteTrans := StrToTipoFrete(Ok, ProcessarConteudo(AuxNode.Childrens.FindAnyNs('vTipoFreteTrans'), tcStr));
    end;
  end;
end;

function TNFSeR_Infisc.LerXml: Boolean;
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

  if (Pos('NFS-e', xRetorno) > 0) then
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

function TNFSeR_Infisc.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NFS-e');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('infNFSe');

  if AuxNode = nil then Exit;

  LerId(AuxNode);
  LerEmitente(AuxNode);
  LerTomador(AuxNode);
  LerServicos(AuxNode);
  LerTotal(AuxNode);
  LerCobranca(AuxNode);
  LerObservacoes(AuxNode);
  LerReembolso(AuxNode);
  LerISSST(AuxNode);

  // vers�o 1.1
  LerDespesas(AuxNode);
  LerTransportadora(AuxNode);
  LerFaturas(AuxNode);
  LerInformacoesAdic(AuxNode);
end;

function TNFSeR_Infisc.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := LerXmlNfse(ANode);
end;

end.
