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

unit EL.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnAuxiliar, pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml, ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_EL }

  TNFSeW_EL = class(TNFSeWClass)
  protected
    function GerarIdentificacaoRPS: TACBrXmlNode;
    function GerarDadosPrestador: TACBrXmlNode;
    function GerarIdentificaoPrestador: TACBrXmlNode;
    function GerarEnderecoPrestador: TACBrXmlNode;
    function GerarContatoPrestador: TACBrXmlNode;

    function GerarDadosTomador: TACBrXmlNode;
    function GerarIdentificaoTomador: TACBrXmlNode;
    function GerarEnderecoTomador: TACBrXmlNode;
    function GerarContatoTomador: TACBrXmlNode;

    function GerarIntermediarioServico: TACBrXmlNode;
    function GerarServicos: TACBrXmlNode;
    function GerarServico: TACBrXmlNodeArray;
    function GerarValores: TACBrXmlNode;
    function GerarRpsSubstituido: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

  end;

  { TNFSeW_ELv2 }

  TNFSeW_ELv2 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     EL
//==============================================================================

{ TNFSeW_EL }

function TNFSeW_EL.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
  LocPrest: string;
begin
  Configuracao;

  Opcoes.QuebraLinha := FAOwner.ConfigGeral.QuebradeLinha;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('Rps');

  FDocument.Root := NFSeNode;

  NFSe.InfID.ID := StringOfChar('0', 15) +
                    OnlyNumber(NFSe.IdentificacaoRps.Numero) +
                    NFSe.IdentificacaoRps.Serie;
  NFSe.InfID.ID := copy(NFSe.InfID.ID, length(NFSe.InfID.ID) - 15 + 1, 15);

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Id', 1, 15, 1, NFSe.InfID.ID, ''));

  LocPrest := '2';
  if NFSe.NaturezaOperacao = no2 then
    LocPrest := '1';

  // C�digo para identifica��o do local de presta��o do servi�o:
  // 1-Fora do munic�pio 2-No munic�pio
  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'LocalPrestacao', 1, 1, 1,
                                                                 LocPrest, ''));

  // IssRetido no provedor EL � ao contrario (1 = normal, 2 retido)
  // por isso n�o da de usar SituacaoTributariaToStr
  if NFSe.Servico.Valores.IssRetido = stRetencao then
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'IssRetido', 1, 1, 1, '2', ''))
  else
    NFSeNode.AppendChild(AddNode(tcStr, '#1', 'IssRetido', 1, 1, 1, '1', ''));

  NFSeNode.AppendChild(AddNode(tcDatHor, '#1', 'DataEmissao', 19, 19, 1,
                                                   NFSe.DataEmissao, DSC_DEMI));

  xmlNode := GerarIdentificacaoRPS;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDadosPrestador;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDadosTomador;
  NFSeNode.AppendChild(xmlNode);

  if (NFSe.IntermediarioServico.RazaoSocial<>'') or
     (NFSe.IntermediarioServico.CpfCnpj <> '') then
  begin
    xmlNode := GerarIntermediarioServico;
    NFSeNode.AppendChild(xmlNode);
  end;

  xmlNode := GerarServicos;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarValores;
  NFSeNode.AppendChild(xmlNode);

  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    xmlNode := GerarRpsSubstituido;
    NFSeNode.AppendChild(xmlNode);
  end;

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Observacao', 1, 255, 0,
                                                   NFSe.OutrasInformacoes, ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'Status', 1, 1, 1,
                                              StatusRPSToStr(NFSe.Status), ''));

  NFSeNode.AppendChild(AddNode(tcStr, '#1', 'CodigoMunicipioPrestacao', 7, 7, 0,
                      OnlyNumber(NFSe.Prestador.Endereco.CodigoMunicipio), ''));

  Result := True;
end;

function TNFSeW_EL.GerarContatoPrestador: TACBrXmlNode;
begin
  Result := CreateElement('Contato');

  Result.AppendChild(AddNode(tcStr, '#1', 'Telefone', 1, 11, 0,
                              OnlyNumber(NFSe.Prestador.Contato.Telefone), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Email', 1, 80, 1,
                                             NFSe.Prestador.Contato.Email, ''));
end;

function TNFSeW_EL.GerarContatoTomador: TACBrXmlNode;
begin
  Result := CreateElement('Contato');

  Result.AppendChild(AddNode(tcStr, '#1', 'Telefone', 1, 11, 0,
                                OnlyNumber(NFSe.Tomador.Contato.Telefone), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Email', 1, 80, 1,
                                               NFSe.Tomador.Contato.Email, ''));
end;

function TNFSeW_EL.GerarDadosPrestador: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  Result := CreateElement('DadosPrestador');

  xmlNode := GerarIdentificaoPrestador;
  Result.AppendChild(xmlNode);

  Result.AppendChild(AddNode(tcStr, '#1', 'RazaoSocial', 1, 115, 0,
                                               NFSe.Prestador.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NomeFantasia', 1, 115, 0,
                                              NFSe.Prestador.NomeFantasia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IncentivadorCultural', 1, 1, 1,
                                   SimNaoToStr(NFSe.IncentivadorCultural), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'OptanteSimplesNacional', 1, 1, 1,
                                 SimNaoToStr(NFSe.OptanteSimplesNacional), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NaturezaOperacao', 1, 1, 1,
                             NaturezaOperacaoToStr(NFSe.NaturezaOperacao), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'RegimeEspecialTributacao', 1, 1, 0,
             RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), ''));

  xmlNode := GerarEnderecoPrestador;
  Result.AppendChild(xmlNode);

  xmlNode := GerarContatoPrestador;
  Result.AppendChild(xmlNode);
end;

function TNFSeW_EL.GerarDadosTomador: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  Result := CreateElement('DadosTomador');

  xmlNode := GerarIdentificaoTomador;
  Result.AppendChild(xmlNode);

  Result.AppendChild(AddNode(tcStr, '#1', 'RazaoSocial', 1, 115, 0,
                                                 NFSe.Tomador.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'NomeFantasia', 1, 115, 0,
                                                NFSe.Tomador.NomeFantasia, ''));

  xmlNode := GerarEnderecoTomador;
  Result.AppendChild(xmlNode);

  xmlNode := GerarContatoTomador;
  Result.AppendChild(xmlNode);
end;

function TNFSeW_EL.GerarEnderecoPrestador: TACBrXmlNode;
var
  xMun: String;
begin
  Result := CreateElement('Endereco');

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroTipo', 1, 125, 0,
                                   NFSe.Prestador.Endereco.TipoLogradouro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Logradouro', 1, 125, 0,
                                         NFSe.Prestador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroNumero', 1, 10, 0,
                                           NFSe.Prestador.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroComplemento', 1, 60, 0,
                                      NFSe.Prestador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 0,
                                           NFSe.Prestador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoMunicipio', 7, 7, 0,
                      OnlyNumber(NFSe.Prestador.Endereco.CodigoMunicipio), ''));

  if (Trim(NFSe.Prestador.Endereco.xMunicipio) = '') then
  begin
    xMun := CodIBGEToCidade(StrToIntDef(NFSe.Prestador.Endereco.CodigoMunicipio, 0));
    xMun := Copy(xMun,1,Length(xMun)-3);

    Result.AppendChild(AddNode(tcStr, '#1', 'Municipio', 1, 100, 0,
                                                          UpperCase(xMun), ''));
  end
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'Municipio', 1, 100, 0,
                                       NFSe.Prestador.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Uf', 2, 2, 0,
                                               NFSe.Prestador.Endereco.UF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 0,
                                  OnlyNumber(NFSe.Prestador.Endereco.CEP), ''));
end;

function TNFSeW_EL.GerarEnderecoTomador: TACBrXmlNode;
var
  xMun: String;
begin
  Result := CreateElement('Endereco');

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroTipo', 1, 125, 0,
                                     NFSe.Tomador.Endereco.TipoLogradouro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Logradouro', 1, 125, 0,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroNumero', 1, 10, 0,
                                             NFSe.Tomador.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'LogradouroComplemento', 1, 60, 0,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Bairro', 1, 60, 0,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CodigoMunicipio', 7, 7, 0,
                        OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), ''));

  if (Trim(NFSe.Tomador.Endereco.xMunicipio) = '') then
  begin
    xMun := CodIBGEToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio, 0));
    xMun := Copy(xMun,1,Length(xMun)-3);

    Result.AppendChild(AddNode(tcStr, '#1', 'Municipio', 1, 100, 0,
                                                          UpperCase(xMun), ''));
  end
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'Municipio', 1, 100, 0,
                                NFSe.Tomador.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Uf', 2, 2, 0,
                                        NFSe.Tomador.Endereco.UF, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'Cep', 8, 8, 0,
                           OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));
end;

function TNFSeW_EL.GerarIdentificacaoRPS: TACBrXmlNode;
begin
  Result := CreateElement('IdentificacaoRps');

  Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                         OnlyNumber(NFSe.IdentificacaoRps.Numero), DSC_NUMRPS));

  Result.AppendChild(AddNode(tcStr, '#1', 'Serie', 1, 5, 1,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

  Result.AppendChild(AddNode(tcStr, '#1', 'Tipo', 1, 1, 1,
                        TipoRPSToStr(NFSe.IdentificacaoRps.Tipo), DSC_TIPORPS));
end;

function TNFSeW_EL.GerarIdentificaoPrestador: TACBrXmlNode;
begin
  Result := CreateElement('IdentificacaoPrestador');

  Result.AppendChild(AddNode(tcStr, '#1', 'CpfCnpj', 11, 14, 1,
                   OnlyNumber(NFSe.Prestador.IdentificacaoPrestador.Cnpj), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'IndicacaoCpfCnpj', 1, 1, 1,
                                                                      '2', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipal', 1, 15, 0,
                 NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, ''));
end;

function TNFSeW_EL.GerarIdentificaoTomador: TACBrXmlNode;
begin
  Result := CreateElement('IdentificacaoTomador');

  Result.AppendChild(AddNode(tcStr, '#1', 'CpfCnpj', 11, 14, 1,
                    OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), ''));

  if Length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) <= 11 then
    Result.AppendChild(AddNode(tcStr, '#1', 'IndicacaoCpfCnpj', 1, 1, 1,
                                                                       '1', ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'IndicacaoCpfCnpj', 1, 1, 1,
                                                                      '2', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipal', 1, 15, 0,
                     NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, ''));

//  Result.AppendChild(AddNode(tcStr, '#1', 'InscricaoEstadual', 1, 15, 0,
//                      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, ''));
end;

function TNFSeW_EL.GerarIntermediarioServico: TACBrXmlNode;
begin
  Result := CreateElement('IntermediarioServico');

  Result.AppendChild(AddNode(tcStr, '#1', 'RazaoSocial', 1, 115, 0,
                                    NFSe.IntermediarioServico.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'CpfCnpj', 14, 14, 1,
                            OnlyNumber(NFSe.IntermediarioServico.CpfCnpj), ''));

  if Length(OnlyNumber(NFSe.IntermediarioServico.CpfCnpj)) <= 11 then
    Result.AppendChild(AddNode(tcStr, '#1', 'IndicacaoCpfCnpj', 1, 1, 1,
                                                                       '1', ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'IndicacaoCpfCnpj', 1, 1, 1,
                                                                      '2', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'InscricaoMunicipal', 1, 15, 0,
                             NFSe.IntermediarioServico.InscricaoMunicipal, ''));
end;

function TNFSeW_EL.GerarRpsSubstituido: TACBrXmlNode;
begin
  Result := CreateElement('RpsSubstituido');

  Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                        OnlyNumber(NFSe.RpsSubstituido.Numero), DSC_NUMRPSSUB));

  Result.AppendChild(AddNode(tcStr, '#1', 'Serie', 1, 5, 1,
                                   NFSe.RpsSubstituido.Serie, DSC_SERIERPSSUB));

  Result.AppendChild(AddNode(tcStr, '#1', 'Tipo', 1, 1, 1,
                       TipoRPSToStr(NFSe.RpsSubstituido.Tipo), DSC_TIPORPSSUB));
end;

function TNFSeW_EL.GerarServico: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.ItemServico.Count);

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Result[i] := CreateElement('Servico');

    Result[i].AppendChild(AddNode(tcStr, '#', 'CodigoCnae', 1, 07, 0,
                                                  NFSe.Servico.CodigoCnae, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'CodigoServico116', 1, 5, 1,
                                    NFSe.Servico.ItemServico[i].CodLCServ, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'CodigoServicoMunicipal', 1, 20, 1,
                                      NFSe.Servico.ItemServico[i].CodServ, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'Quantidade', 1, 5, 1,
                                   NFSe.Servico.ItemServico[i].Quantidade, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'Unidade', 1, 20, 1,
                                      NFSe.Servico.ItemServico[i].Unidade, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'Descricao', 1, 255, 1,
                                NFSe.Servico.ItemServico[i].Descricao, ''));

    Result[i].AppendChild(AddNode(tcDe4, '#', 'Aliquota', 1, 5, 1,
                               NFSe.Servico.ItemServico[i].Aliquota / 100, ''));

    Result[i].AppendChild(AddNode(tcDe4, '#', 'ValorServico', 1, 15, 1,
                                NFSe.Servico.ItemServico[i].ValorTotal, ''));

    Result[i].AppendChild(AddNode(tcDe4, '#', 'ValorIssqn', 1, 15, 1,
                                     NFSe.Servico.ItemServico[i].ValorIss, ''));

    Result[i].AppendChild(AddNode(tcDe2, '#', 'ValorDesconto', 1, 15, 0,
                                NFSe.Servico.ItemServico[i].ValorDeducoes, ''));

    Result[i].AppendChild(AddNode(tcStr, '#', 'NumeroAlvara', 1, 15, 0,
                                                                       '', ''));
  end;

  if NFSe.Servico.ItemServico.Count > 10 then
    wAlerta('#', 'Servico', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

function TNFSeW_EL.GerarServicos: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('Servicos');

  nodeArray := GerarServico;
  if nodeArray <> nil then
  begin
    for i := 0 to Length(nodeArray) - 1 do
    begin
      Result.AppendChild(nodeArray[i]);
    end;
  end;
end;

function TNFSeW_EL.GerarValores: TACBrXmlNode;
begin
  Result := CreateElement('Valores');

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorServicos', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorDeducoes', 1, 15, 0,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorPis', 1, 15, 0,
                                            NFSe.Servico.Valores.ValorPis, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorCofins', 1, 15, 0,
                                         NFSe.Servico.Valores.ValorCofins, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorInss', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorInss, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorIr', 1, 15, 0,
                                             NFSe.Servico.Valores.ValorIr, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorCsll', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorCsll, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorIss', 1, 15, 0,
                                            NFSe.Servico.Valores.ValorIss, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorOutrasRetencoes', 1, 15, 0,
                                     NFSe.Servico.Valores.OutrasRetencoes, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorLiquidoNfse', 1, 15, 0,
                                    NFSe.Servico.Valores.ValorLiquidoNfse, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ValorIssRetido', 1, 15, 0,
                                      NFSe.Servico.Valores.ValorIssRetido, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'OutrosDescontos', 1, 15, 0,
                                     NFSe.Servico.Valores.OutrosDescontos, ''));
end;

{ TNFSeW_ELv2 }

procedure TNFSeW_ELv2.Configuracao;
begin
  inherited Configuracao;

  FormatoAliq := tcDe2;
  NrOcorrInformacoesComplemetares := 0;
  NrOcorrCepTomador := 1;
  NrOcorrCodigoPaisServico := 0;
  NrOcorrCodigoPaisTomador := -1;

  TagTomador := 'TomadorServico';
end;

end.
