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

unit SigISS.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnAuxiliar, pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml, ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_SigISS }

  TNFSeW_SigISS = class(TNFSeWClass)
  private
    FpGerarGrupoDadosPrestador: Boolean;
  protected
    procedure Configuracao; override;

    function GerarPrestador: TACBrXmlNode;
    function GerarIdentificacaoRPS: TACBrXmlNode;
  public
    function GerarXml: Boolean; override;

  end;

  { TNFSeW_SigISSA }

  TNFSeW_SigISSA = class(TNFSeW_SigISS)
  protected
    procedure Configuracao; override;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     SigISS
//==============================================================================

{ TNFSeW_SigISS }

procedure TNFSeW_SigISS.Configuracao;
begin
  inherited Configuracao;

  FpGerarGrupoDadosPrestador := True;
end;

function TNFSeW_SigISS.GerarIdentificacaoRPS: TACBrXmlNode;
begin
  Result := CreateElement('DescricaoRps');

  if not FpGerarGrupoDadosPrestador then
  begin
    Result.AppendChild(AddNode(tcStr, '#1', 'ccm', 1, 15, 0,
                                           OnlyNumber(NFSe.Prestador.ccm), ''));

    Result.AppendChild(AddNode(tcStr, '#2', 'cnpj', 1, 14, 1,
                   OnlyNumber(NFSe.Prestador.IdentificacaoPrestador.Cnpj), ''));

    Result.AppendChild(AddNode(tcStr, '#2', 'cpf', 1, 14, 1,
                                                      OnlyNumber(Usuario), ''));

    Result.AppendChild(AddNode(tcStr, '#2', 'senha', 1, 10, 1, Senha, DSC_SENHA));

    Result.AppendChild(AddNode(tcStr, '#2', 'crc', 1, 10, 0,
                                                       NFSe.Prestador.crc, ''));

    Result.AppendChild(AddNode(tcStr, '#2', 'crc_estado', 1, 2, 0,
                                                NFSe.Prestador.crc_estado, ''));

    Result.AppendChild(AddNode(tcDe2, '#2', 'aliquota_simples', 1, 15, 0,
                                          NFSE.Servico.Valores.AliquotaSN, ''));
  end;

  Result.AppendChild(AddNode(tcStr, '#1', 'id_sis_legado', 1, 15, 0,
                                                       NFSe.id_sis_legado, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'servico', 1, 15, 1,
                       OnlyNumber(NFSe.Servico.CodigoTributacaoMunicipio), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'situacao', 1, 2, 1,
                                     SituacaoTribToStr(NFSe.SituacaoTrib), ''));

  Result.AppendChild(AddNode(tcDe2, '#2', 'aliquota', 1, 15, 1,
                                            NFSE.Servico.Valores.Aliquota, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'valor', 1, 15, 1,
                                       NFSe.Servico.Valores.ValorServicos, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'base', 1, 15, 1,
                                         NFSe.Servico.Valores.BaseCalculo, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'retencao_iss', 1, 15, 0,
                                            NFSe.Servico.Valores.ValorIss, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'ir', 1, 15, 0,
                                             NFSe.Servico.Valores.ValorIr, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'pis', 1, 15, 0,
                                            NFSe.Servico.Valores.ValorPis, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'cofins', 1, 15, 0,
                                         NFSe.Servico.Valores.ValorCofins, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'csll', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorCsll, ''));

  Result.AppendChild(AddNode(tcDe4, '#1', 'inss', 1, 15, 0,
                                           NFSe.Servico.Valores.ValorInss, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'descricaoNF', 1, 150, 0,
                                               NFSe.Servico.Discriminacao, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_tipo', 1, 1, 1,
                  TipoPessoaToStr(NFSe.Tomador.IdentificacaoTomador.Tipo), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_cnpj', 1, 15, 1,
                    OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_email', 1, 100, 0,
                                               NFSe.Tomador.Contato.Email, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_ie', 1, 15, 0,
                      NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_im', 1, 15, 0,
                     NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_razao', 1, 100, 1,
                                                 NFSe.Tomador.RazaoSocial, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_fantasia', 1, 100, 0,
                                                 NFSe.Tomador.NomeFantasia, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_endereco', 1, 100, 1,
                                           NFSe.Tomador.Endereco.Endereco, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_numero', 1, 100, 1,
                                           NFSe.Tomador.Endereco.Numero, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_complemento', 1, 50, 0,
                                        NFSe.Tomador.Endereco.Complemento, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_bairro', 1, 100, 1,
                                             NFSe.Tomador.Endereco.Bairro, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_CEP', 1, 8, 1,
                                    OnlyNumber(NFSe.Tomador.Endereco.CEP), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_cod_cidade', 1, 7, 1,
                        OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_fone', 1, 15, 0,
                                            NFSe.Tomador.Contato.Telefone, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_ramal', 1, 15, 0,
                                            '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'tomador_fax', 1, 15, 0,
                                            '', ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'rps_num', 1, 15, 0,
                                 OnlyNumber(NFSe.IdentificacaoRps.Numero), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'rps_serie', 1, 3, 0,
                                              NFSe.IdentificacaoRps.Serie, ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'rps_dia', 1, 2, 0,
                                 FormatDateTime('dd',NFSe.DataEmissaoRps), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'rps_mes', 1, 2, 0,
                                 FormatDateTime('MM',NFSe.DataEmissaoRps), ''));

  Result.AppendChild(AddNode(tcStr, '#1', 'rps_ano', 1, 4, 0,
                               FormatDateTime('yyyy',NFSe.DataEmissaoRps), ''));
end;

function TNFSeW_SigISS.GerarPrestador: TACBrXmlNode;
begin
  Result := CreateElement('DadosPrestador');

  Result.AppendChild(AddNode(tcStr, '#1', 'ccm', 1, 15, 0, Usuario, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'cnpj', 1, 14, 1,
                   OnlyNumber(NFSe.Prestador.IdentificacaoPrestador.Cnpj), ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'senha', 1, 10, 1, Senha, DSC_SENHA));

  Result.AppendChild(AddNode(tcStr, '#2', 'crc', 1, 10, 0,
                                                     NFSe.Prestador.crc, ''));

  Result.AppendChild(AddNode(tcStr, '#2', 'crc_estado', 1, 2, 0,
                                                NFSe.Prestador.crc_estado, ''));

  Result.AppendChild(AddNode(tcDe2, '#2', 'aliquota_simples', 1, 15, 0,
                                          NFSE.Servico.Valores.AliquotaSN, ''));
end;

function TNFSeW_SigISS.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  Configuracao;

  Opcoes.QuebraLinha := FAOwner.ConfigGeral.QuebradeLinha;
  Opcoes.DecimalChar := ',';

  ListaDeAlertas.Clear;

  FDocument.Clear();

  NFSeNode := CreateElement('GerarNota');
  NFSeNode.SetNamespace(FAOwner.ConfigMsgDados.XmlRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  NFSe.InfID.ID := StringOfChar('0', 15) +
                    OnlyNumber(NFSe.IdentificacaoRps.Numero) +
                    NFSe.IdentificacaoRps.Serie;
  NFSe.InfID.ID := copy(NFSe.InfID.ID, length(NFSe.InfID.ID) - 15 + 1, 15);


  if FpGerarGrupoDadosPrestador then
  begin
    xmlNode := GerarPrestador;
    NFSeNode.AppendChild(xmlNode);
  end;

  xmlNode := GerarIdentificacaoRPS;
  NFSeNode.AppendChild(xmlNode);

  Result := True;
end;

{ TNFSeW_SigISSA }

procedure TNFSeW_SigISSA.Configuracao;
begin
  inherited Configuracao;

  FpGerarGrupoDadosPrestador := False;
end;

end.
