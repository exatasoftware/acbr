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

unit Governa.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { Provedor com layout pr�prio }
  { TNFSeR_Governa }

  TNFSeR_Governa = class(TNFSeRClass)
  protected

    procedure LerItensRps(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Governa
//==============================================================================

{ TNFSeR_Governa }

procedure TNFSeR_Governa.LerItensRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
begin
  AuxNode := ANode.Childrens.FindAnyNs('tcItensRps');

  if AuxNode <> nil then
  begin
    ANodes := AuxNode.Childrens.FindAllAnyNs('tcItemRps');

    for i := 0 to Length(ANodes) - 1 do
    begin
      NFSe.Servico.ItemServico.New;

      with NFSe.Servico.ItemServico[i] do
      begin
        Descricao  := ObterConteudo(ANodes[i].Childrens.FindAnyNs('tsDesSvc'), tcStr);
        ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('tsVlrUnt'), tcDe2);
      end;
    end;
  end;
end;

function TNFSeR_Governa.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
  xRetorno: string;
begin
  xRetorno := TratarXmlRetorno(Arquivo);

  if EstaVazio(xRetorno) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(xRetorno);

  if (Pos('tcRps', xRetorno) > 0) then
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

function TNFSeR_Governa.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: integer;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Nfse');

  if AuxNode = nil then Exit;

  with NFSe do
  begin
    Numero            := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumNot'), tcStr);
    CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodVer'), tcStr);
    DataEmissao       := ObterConteudo(AuxNode.Childrens.FindAnyNs('DtemiNfse'), tcDat);
    Competencia       := DataEmissao;
    TipoRecolhimento  := ObterConteudo(AuxNode.Childrens.FindAnyNs('TipRec'), tcStr);
    OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('Obs'), tcStr);

    IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumRps'), tcStr);

    with Prestador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RzSocialPr'), tcStr);

      with IdentificacaoPrestador do
      begin
        CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('CNPJPr'), tcStr);
        InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('IEPr'), tcStr);
        InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodCadBic'), tcStr);
      end;

      with Endereco do
      begin
        Endereco    := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndLogradouroPr'), tcStr);
        Numero      := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndNumeroPr'), tcStr);
        Bairro      := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndBairroPr'), tcStr);
        Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndComplPr'), tcStr);
        xMunicipio  := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndCidadePr'), tcStr);
        CEP         := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndCEPPr'), tcStr);
        UF          := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndUFPr'), tcStr);
      end;
    end;

    with Tomador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomTmd'), tcStr);

      with IdentificacaoTomador do
      begin
        CpfCnpj           := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumDocTmd'), tcStr);
        InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoEstadual'), tcStr);
      end;

      with Endereco do
      begin
        Endereco    := ObterConteudo(AuxNode.Childrens.FindAnyNs('DesEndTmd'), tcStr);
//        Numero      := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndNumeroPr'), tcStr);
        Bairro      := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomBaiTmd'), tcStr);
//        Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('EndComplPr'), tcStr);
        xMunicipio  := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomCidTmd'), tcStr);
        CEP         := ObterConteudo(AuxNode.Childrens.FindAnyNs('CEPTmd'), tcStr);
        UF          := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodEstTmd'), tcStr);
      end;
    end;

    with Servico do
    begin
      CodigoCnae := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodAti'), tcStr);
      Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('DesSvc'), tcStr);
      Descricao := ObterConteudo(AuxNode.Childrens.FindAnyNs('DescricaoServ'), tcStr);

      with Valores do
      begin
        ValorServicos := ObterConteudo(AuxNode.Childrens.FindAnyNs('VlrUnt'), tcDe2);
        ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('VlrPIS'), tcDe2);
        ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('VlrCofins'), tcDe2);
        ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('VlrINSS'), tcDe2);
        ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('VlrIR'), tcDe2);

        ValorLiquidoNfse := 0;

        ANodes := AuxNode.Childrens.FindAllAnyNs('ItemNfse');

        for i := 0 to Length(ANodes) - 1 do
        begin
          ItemServico.New;
          with ItemServico[i] do
          begin
            Descricao     := ObterConteudo(ANodes[i].Childrens.FindAnyNs('DesSvc'), tcStr);
            Quantidade    := ObterConteudo(ANodes[i].Childrens.FindAnyNs('QdeSvc'), tcDe2);
            ValorUnitario := ObterConteudo(ANodes[i].Childrens.FindAnyNs('VlrUnt'), tcDe2);
            ValorTotal    := Quantidade + ValorUnitario;
          end;

          ValorLiquidoNfse := ValorLiquidoNfse + ItemServico[i].ValorTotal;
        end;
      end;
    end;
  end;
end;

function TNFSeR_Governa.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  AuxNode := ANode.Childrens.FindAnyNs('tcInfRps');

  if AuxNode = nil then Exit;

  with NFSe do
  begin
    with IdentificacaoRps do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsNumRps'), tcStr);
    end;

    CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsCodVer'), tcStr);

    with Tomador do
    begin
      with IdentificacaoTomador do
      begin
        CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsNumDocTmd'), tcStr);
        InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsInsEstTmd'), tcStr);
        InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsInsMunTmd'), tcStr);
      end;

      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsNomTmd'), tcStr);

      with Endereco do
      begin
        Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsDesEndTmd'), tcStr);
        Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsNomBaiTmd'), tcStr);
        xMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsNomCidTmd'), tcStr);
        UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsCodEstTmd'), tcStr);
        CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsCEPTmd'), tcStr);
        Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsDesEndTmd'), tcStr);
      end;

      with Contato do
      begin
        Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsEmlTmd'), tcStr);
      end;
    end;

    with Servico do
    begin
      CodigoTributacaoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsCodAti'), tcStr);

      with Valores do
      begin
        Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsPerAlq'), tcDe2);
        ValorRepasse := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrRep'), tcDe2);
        ValorDeducoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrDed'), tcDe2);
        DescontoCondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrDsc'), tcDe2);
        ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrPIS'), tcDe2);
        ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrCOFINS'), tcDe2);
        ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrINSS'), tcDe2);
        ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrIR'), tcDe2);
        ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrCSLL'), tcDe2);
        valorOutrasRetencoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsVlrOtrRtn'), tcDe2);
        DescricaoOutrasRetencoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsDesOtrRtn'), tcStr);
      end;

      UFPrestacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsEstServ'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsMunSvc'), tcStr);
    end;

    RegRec := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsRegRec'), tcStr);
    FrmRec := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsFrmRec'), tcStr);
    DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsDatEmsRps'), tcDat);
    TipoRecolhimento := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsTipRec'), tcStr);
    OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('tsObs'), tcStr);

    LerItensRps(AuxNode);
  end;
end;

end.
