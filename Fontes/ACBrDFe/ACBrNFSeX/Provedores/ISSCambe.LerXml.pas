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

unit ISSCambe.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { TNFSeR_ISSCambe }

  TNFSeR_ISSCambe = class(TNFSeRClass)
  protected

    function LerCompetencia(const ANode: TACBrXmlNode): TDateTime;

    procedure SetxItemListaServico(Codigo: string);

    procedure LerDemaisDados(const ANode: TACBrXmlNode);
    procedure LerDadosTomador(const ANode: TACBrXmlNode);
    procedure LerDadosPrestador(const ANode: TACBrXmlNode);
    procedure LerDadosNFSe2(const ANode: TACBrXmlNode);
    procedure LerSubstituicaoNFSe(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoNFSe(const ANode: TACBrXmlNode);
    procedure LerNFSe(const ANode: TACBrXmlNode);
    procedure LerEspelhoXML(const ANode: TACBrXmlNode);
    procedure LerDadosNFSe(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     ISSCambe
//==============================================================================

{ TNFSeR_ISSCambe }

function TNFSeR_ISSCambe.LerCompetencia(const ANode: TACBrXmlNode): TDateTime;
var
  Competencia: string;
begin
  Competencia := ObterConteudo(ANode.Childrens.FindAnyNs('anoCompetencia'), tcStr) +
                 ObterConteudo(ANode.Childrens.FindAnyNs('mesCompetencia'), tcStr);

  if length(Competencia) > 0 then
    Result := EncodeDataHora(Competencia, 'YYYY/MM/DD')
  else
    Result := 0;
end;

procedure TNFSeR_ISSCambe.SetxItemListaServico(Codigo: string);
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

procedure TNFSeR_ISSCambe.LerDemaisDados(const ANode: TACBrXmlNode);
var
   AuxNode: TACBrXmlNode;
   aValor: string;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('demaisDados');

  if not Assigned(AuxNode) or (AuxNode = nil) then Exit;

  //codigoObra
  //ART

  aValor:=  ObterConteudo(AuxNode.Childrens.FindAnyNs('optanteSimplesNacional'), tcStr);

  if aValor = 'true' then
    NFSe.OptanteSimplesNacional := snSim
  else
    NFSe.OptanteSimplesNacional := snNao;

  aValor:=  ObterConteudo(AuxNode.Childrens.FindAnyNs('incentivoFiscal'), tcStr);

  if aValor = 'true' then
    NFSe.IncentivadorCultural := snSim
  else
    NFSe.IncentivadorCultural := snNao;

  aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('servicoISS'), tcStr);

  SetxItemListaServico(aValor);

  NFSe.Servico.Discriminacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('servicoDiscriminacao'), tcStr);

  with NFSe.ValoresNfse do
  begin
    ValorLiquidoNfse := ObterConteudo(AuxNode.Childrens.FindAnyNs('servicoValor'), tcDe2);
    //tipoDeducao

    BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorBaseCalculo'), tcDe2);
    Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('aliquota'), tcDe2) * 100;
    ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorISS'), tcDe2);
  end;

  with NFSe.Servico.Valores do
  begin
    ValorDeducoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorDeducao'), tcDe2);

    ValorServicos := NFSe.ValoresNfse.ValorLiquidoNfse;
    BaseCalculo := NFSe.ValoresNfse.BaseCalculo;
    Aliquota := NFSe.ValoresNfse.Aliquota;
    ValorIss := NFSe.ValoresNfse.ValorIss;
    ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorIR'), tcDe2);
    ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorPIS'), tcDe2);
    ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorCOFINS'), tcDe2);
    ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorCSLL'), tcDe2);
    ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorINSS'), tcDe2);

    aValor := ObterConteudo(AuxNode.Childrens.FindAnyNs('ISSRetido'), tcStr);

    if aValor = 'false' then
      IssRetido := stNormal
    else
      IssRetido := stRetencao;

    ValorLiquidoNfse := ObterConteudo(AuxNode.Childrens.FindAnyNs('valorLiquidoNFSe'), tcDe2);
  end;

  NFSe.Servico.CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('municipioPrestacao'), tcStr);
  //IssDevido;
  //paisPrestacao
  NFSe.Servico.MunicipioIncidencia := ObterConteudo(AuxNode.Childrens.FindAnyNs('municipioIncidencia'), tcStr);
  NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('outrasInformacoes'), tcStr);

  with NFSe.OrgaoGerador do
  begin
    CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('municipioOrgaoGerador'), tcStr);
    Uf := ObterConteudo(AuxNode.Childrens.FindAnyNs('UFOrgaoGerador'), tcStr);
  end;
end;

procedure TNFSeR_ISSCambe.LerDadosTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('dadosTomador');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.IdentificacaoTomador do
    begin
      Tipo := FpAOwner.StrToTipoPessoa(ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('tipoTomador'), tcStr));
      CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorCPFCNPJ'), tcStr);
      InscricaoEstadual := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorInscricaoEstadual'), tcStr);
      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorCMC'), tcStr);
    end;

    NFSe.Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorRazaoSocial'), tcStr);

    with NFSe.Tomador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorLogradouro'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorNumero'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorComplemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorBairro'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorCEP'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorMunicipio'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorUF'), tcStr);
      xMunicipio := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
      CodigoPais := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorPais'), tcInt);
    end;

    NFSe.Servico.CodigoMunicipio := NFSe.Tomador.Endereco.CodigoMunicipio;
    NFSe.Tomador.Contato.Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('tomadorEmail'), tcStr);
  end;
end;

procedure TNFSeR_ISSCambe.LerDadosPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('dadosPrestador');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador do
    begin
      IdentificacaoPrestador.InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorCMC'), tcStr);
      IdentificacaoPrestador.CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorCNPJ'), tcStr);
      RazaoSocial  := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorRazaoSocial'), tcStr);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorNomeFantasia'), tcStr);
    end;

    with NFSe.Prestador.Endereco do
    begin
      Endereco := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorLogradouro'), tcStr);
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorNumero'), tcStr);
      Complemento := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorComplemento'), tcStr);
      Bairro := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorBairro'), tcStr);
      CEP := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorCEP'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorMunicipio'), tcStr);
      UF := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorUF'), tcStr);
      xMunicipio := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
    end;

    with NFSe.Prestador.Contato do
    begin
      Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorTelefone'), tcStr);
      Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('prestadorEmail'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ISSCambe.LerDadosNFSe2(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('dadosNFSe');

  if AuxNode <> nil then
  begin
    LerDadosPrestador(AuxNode);
    LerDadosTomador(AuxNode);
    // RPS
  end;
end;

procedure TNFSeR_ISSCambe.LerSubstituicaoNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('substituicaoNFSe');

  if AuxNode <> nil then
  begin
    NFSe.NfseSubstituidora := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFSeSubstituta'), tcStr);
    NFSe.NfseSubstituida := ObterConteudo(AuxNode.Childrens.FindAnyNs('NFSeSubstituida'), tcStr);
  end;
end;

procedure TNFSeR_ISSCambe.LerIdentificacaoNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('identificacaoNFSe');

  if AuxNode <> nil then
  begin
    NFSe.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('numero'), tcStr);
    NFSe.CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('codigoVerificacao'), tcStr);
    NFSe.Link := ObterConteudo(AuxNode.Childrens.FindAnyNs('linkImpressao'), tcStr);
    NFSe.Link := StringReplace(NFSe.Link, '&amp;', '&', [rfReplaceAll]);
    NFSe.DataEmissao := ObterConteudo(AuxNode.Childrens.FindAnyNs('dataEmissao'), tcDatHor);
    NFSe.Competencia := LerCompetencia(AuxNode);

    NFSe.dhRecebimento := Now;
    NFSe.SituacaoNfse := snNormal;
  end;
end;

procedure TNFSeR_ISSCambe.LerNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NFSe');

  if AuxNode <> nil then
  begin
    LerIdentificacaoNFSe(AuxNode);
    LerSubstituicaoNFSe(AuxNode);
    LerDadosNFSe2(AuxNode);
    LerDemaisDados(AuxNode);
  end;
end;

procedure TNFSeR_ISSCambe.LerEspelhoXML(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('EspelhoXML');

  if AuxNode <> nil then
  begin
    LerNFSe(AuxNode);

    // NFSeHash
    // dataHoraConsulta
  end;
end;

procedure TNFSeR_ISSCambe.LerDadosNFSe(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('DadosNFSe');

  if AuxNode <> nil then
    LerEspelhoXML(AuxNode);
end;

function TNFSeR_ISSCambe.LerXml: Boolean;
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

  if (Pos('DadosNFSe', xRetorno) > 0) then
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

function TNFSeR_ISSCambe.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ListaDadosNFSeInfo');

  LerDadosNFSe(AuxNode);
end;

function TNFSeR_ISSCambe.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  {
    Implementar a leitura do XML do Rps
  }
end;

end.
