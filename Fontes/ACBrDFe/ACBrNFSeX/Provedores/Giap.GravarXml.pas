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

unit Giap.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnAuxiliar,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml, ACBrNFSeXConversao;

type
  { TNFSeW_Giap }

  TNFSeW_Giap = class(TNFSeWClass)
  protected
    function GerarDadosPrestador: TACBrXmlNode;
    function GerarDadosServico: TACBrXmlNode;
    function GerarDadosTomador: TACBrXmlNode;
    function GerarDetalheServico: TACBrXmlNode;
    function GerarItem: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Giap
//==============================================================================

{ TNFSeW_Giap }

function TNFSeW_Giap.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  Configuracao;

  Opcoes.DecimalChar := '.';
  Opcoes.QuebraLinha := FAOwner.ConfigGeral.QuebradeLinha;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('notaFiscal');

  FDocument.Root := NFSeNode;

  NFSe.InfID.ID := OnlyNumber(NFSe.IdentificacaoRps.Numero) + NFSe.IdentificacaoRps.Serie;

  xmlNode := GerarDadosPrestador;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDadosServico;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDadosTomador;
  NFSeNode.AppendChild(xmlNode);

  xmlNode := GerarDetalheServico;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

function TNFSeW_Giap.GerarDadosPrestador: TACBrXmlNode;
begin
  Result := CreateElement('dadosPrestador');

  Result.AppendChild(AddNode(tcDatVcto, '#1', 'dataEmissao', 1, 21, 1,
                                                      NFSe.DataEmissaoRps, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'im', 1, 11, 1,
                 NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'numeroRps', 1, 11, 1,
                                             NFSe.IdentificacaoRps.Numero, ''));

  if Trim(NFSe.Numero) <> EmptyStr then
    Result.AppendChild(AddNode(tcStr, '#1', 'numeroNota', 1, 11, 1,
                                                              NFSe.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'codigoVerificacao', 1, 11, 0,
                                                   NFSe.CodigoVerificacao, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'link', 1, 11, 0, NFSe.Link, ''));
end;

function TNFSeW_Giap.GerarDadosServico: TACBrXmlNode;
begin
  Result := CreateElement('dadosServico');

  Result.AppendChild(AddNode(tcStr, '#1', 'bairro', 1, 25, 1,
                                           NFSe.Prestador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cep', 1, 9, 1,
                                  OnlyNumber(NFSe.Prestador.Endereco.CEP), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 30, 1,
                                       NFSe.Prestador.Endereco.xMunicipio, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'complemento', 1, 30, 1,
                                      NFSe.Prestador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'logradouro', 1, 50, 1,
                                         NFSe.Prestador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'numero', 1, 10, 1,
                               OnlyNumber(NFSe.Prestador.Endereco.Numero), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'pais', 1, 9, 1,
                                            NFSe.Prestador.Endereco.xPais, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'uf', 1, 2, 1,
                                               NFSe.Prestador.Endereco.UF, ''));
end;

function TNFSeW_Giap.GerarDadosTomador: TACBrXmlNode;
begin
  Result := CreateElement('dadosTomador');

  Result.AppendChild(AddNode(tcStr, '#1', 'bairro', 1, 25, 1,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cep', 1, 9, 1,
                                    OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));

  if NFSe.Tomador.Endereco.CodigoMunicipio = '9999999' then
    Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 50, 1,
                                          NFSe.Tomador.Endereco.xMunicipio, ''))
  else
  Result.AppendChild(AddNode(tcStr, '#1', 'cidade', 1, 30, 1,
    CodCidadeToCidade(StrToInt64Def(NFSe.Tomador.Endereco.CodigoMunicipio, 0)), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'complemento', 1, 30, 1,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'documento', 1, 14, 1,
                    OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'email', 1, 14, 1,
                                               NFSe.Tomador.Contato.Email, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'ie', 1, 14, 1,
          OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'logradouro', 1, 50, 1,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'nomeTomador', 1, 120, 1,
                                                 NFSe.Tomador.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'numero', 1, 10, 1,
                                 OnlyNumber(NFSe.Tomador.Endereco.Numero), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'pais', 1, 9, 1,
                                              NFSe.Tomador.Endereco.xPais, ''));

  if length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 11 then
    Result.AppendChild(AddNode(tcStr, '#1', 'tipoDoc', 1, 1, 1, 'F', ''))
  else
    Result.AppendChild(AddNode(tcStr, '#1', 'tipoDoc', 1, 1, 1, 'J', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'uf', 1, 2, 1,
                                                 NFSe.Tomador.Endereco.UF, ''));
end;

function TNFSeW_Giap.GerarDetalheServico: TACBrXmlNode;
var
  xmlNode: TACBrXmlNode;
begin
  Result := CreateElement('detalheServico');

  Result.AppendChild(AddNode(tcDe2, '#1', 'cofins', 1, 15, 1,
                                         NFSe.Servico.Valores.ValorCofins, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'csll', 1, 15, 1,
                                           NFSe.Servico.Valores.ValorCsll, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'deducaoMaterial', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorDeducoes, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'descontoIncondicional', 1, 15, 1,
                              NFSe.Servico.Valores.DescontoIncondicionado, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'inss', 1, 15, 1,
                                           NFSe.Servico.Valores.ValorInss, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'ir', 1, 15, 1,
                                             NFSe.Servico.Valores.ValorIr, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'issRetido', 1, 15, 1,
                                      NFSe.Servico.Valores.ValorIssRetido, ''));

  xmlNode := GerarItem;
  Result.AppendChild(xmlNode);

  Result.AppendChild(AddNode(tcStr, '#1', 'obs', 1, 4000, 1,
                                                   NFSe.OutrasInformacoes, ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'pisPasep', 1, 15, 1,
                                            NFSe.Servico.Valores.ValorPis, ''));
end;

function TNFSeW_Giap.GerarItem: TACBrXmlNode;
begin
  Result := CreateElement('item');

  Result.AppendChild(AddNode(tcDe2, '#1', 'aliquota', 1, 15, 1,
                                            NFSe.Servico.Valores.Aliquota, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'cnae', 1, 8, 1,
                                      OnlyNumber(NFSe.Servico.CodigoCnae), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'codigo', 1, 4, 1,
                                OnlyNumber(NFSe.Servico.ItemListaServico), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'descricao', 1, 4000, 1,
    StringReplace(NFSe.Servico.Discriminacao, ';', FAOwner.ConfigGeral.QuebradeLinha,
                                           [rfReplaceAll, rfIgnoreCase] ), ''));

  Result.AppendChild(AddNode(tcDe2, '#1', 'valor', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));
end;

end.
