{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit pnfsNFSeW_Giap;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrConsts,
  pnfsNFSeW, pcnAuxiliar, pcnConversao, pcnGerador, pnfsNFSe, pnfsConversao;

type

  { TNFSeW_Giap }

  TNFSeW_Giap = class(TNFSeWClass)
  private
  protected

    procedure GerarIdentificacaoRPS;
    procedure GerarRPSSubstituido;

    procedure GerarPrestador;
    procedure GerarTomador;
    procedure GerarIntermediarioServico;

    procedure GerarServicoValores;
    procedure GerarListaServicos;
    procedure GerarValoresServico;

    procedure GerarConstrucaoCivil;
    procedure GerarCondicaoPagamento;

    procedure GerarTransportadora;

    procedure GerarXML_Giap;

  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil;

{ TNFSeW_Giap }

constructor TNFSeW_Giap.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

procedure TNFSeW_Giap.GerarCondicaoPagamento;
begin
end;

procedure TNFSeW_Giap.GerarConstrucaoCivil;
begin
end;

procedure TNFSeW_Giap.GerarIdentificacaoRPS;
begin
end;

procedure TNFSeW_Giap.GerarIntermediarioServico;
begin
end;

procedure TNFSeW_Giap.GerarListaServicos;
begin
  Gerador.wGrupoNFSe('item');
  Gerador.wCampoNFSe(tcDe2, '', 'aliquota'      , 01, 015, 1, FNFSe.Servico.Valores.Aliquota, '');
  Gerador.wCampoNFSe(tcStr, '', 'cnae'          , 01, 08, 1, OnlyNumber(FNFSe.Servico.CodigoCnae), '');
  Gerador.wCampoNFSe(tcStr, '', 'codigo'     , 01, 04, 1, OnlyNumber(FNFSe.Servico.ItemListaServico), '');
  Gerador.wCampoNFSe(tcStr, '', 'descricao'  , 01, 4000, 1, StringReplace( NFSe.Servico.Discriminacao, ';', FQuebradeLinha, [rfReplaceAll, rfIgnoreCase] ), '');
  Gerador.wCampoNFSe(tcDe2, '', 'valor' , 01, 015, 1, FNFSe.Servico.Valores.ValorServicos, '');
  Gerador.wGrupoNFSe('/item');
end;

procedure TNFSeW_Giap.GerarPrestador;
begin
  Gerador.wGrupoNFSe('dadosPrestador');
  Gerador.wCampoNFSe(tcDatVcto, '', 'dataEmissao', 01, 21, 1, FNFSe.DataEmissaoRps, '');
  Gerador.wCampoNFSe(tcStr,     '', 'im', 01, 11, 1, FNFSe.Prestador.InscricaoMunicipal, '');
  Gerador.wCampoNFSe(tcStr,     '', 'numeroRps', 01, 11, 1, FNFSe.IdentificacaoRps.Numero, '');
  if Trim(FNFSe.Numero) <> EmptyStr then
    Gerador.wCampoNFSe(tcStr,     '', 'numeroNota', 01, 11, 1, FNFSe.Numero, '');

  if Trim(FNFSe.CodigoVerificacao) <> EmptyStr then
    Gerador.wCampoNFSe(tcStr,     '', 'codigoVerificacao', 01, 11, 1, FNFSe.CodigoVerificacao, '');

  if Trim(FNFSe.Link) <> EmptyStr then
    Gerador.wCampoNFSe(tcStr,     '', 'link', 01, 11, 1, FNFSe.Link, '');

  Gerador.wGrupoNFSe('/dadosPrestador');
  Gerador.wGrupoNFSe('dadosServico');
  Gerador.wCampoNFSe(tcStr,     '', 'bairro', 01, 25, 1, FNFSe.PrestadorServico.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr,     '', 'cep', 01, 09, 1, OnlyNumber(FNFSe.PrestadorServico.Endereco.CEP), '');
  Gerador.wCampoNFSe(tcStr,     '', 'cidade', 01, 30, 1, FNFSe.PrestadorServico.Endereco.xMunicipio, '');
  Gerador.wCampoNFSe(tcStr,     '', 'complemento', 01, 30, 1, FNFSe.PrestadorServico.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr,     '', 'logradouro', 01, 50, 1, FNFSe.PrestadorServico.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr,     '', 'numero', 01, 10, 1, FNFSe.PrestadorServico.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr,     '', 'pais', 01, 09, 1, FNFSe.PrestadorServico.Endereco.xPais, '');
  Gerador.wCampoNFSe(tcStr,     '', 'uf', 01, 02, 1, FNFSe.PrestadorServico.Endereco.UF, '');
  Gerador.wGrupoNFSe('/dadosServico');
end;

procedure TNFSeW_Giap.GerarRPSSubstituido;
begin
end;

procedure TNFSeW_Giap.GerarServicoValores;
begin
  Gerador.wGrupoNFSe('detalheServico');
  Gerador.wCampoNFSe(tcDe2, '', 'cofins', 01, 02, 1, FNFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampoNFSe(tcDe2, '', 'csll', 01, 02, 1, FNFSe.Servico.Valores.ValorCsll, '');
  Gerador.wCampoNFSe(tcDe2, '', 'deducaoMaterial', 01, 02, 1, FNFSe.Servico.Valores.ValorDeducoes, '');
  Gerador.wCampoNFSe(tcDe2, '', 'descontoIncondicional', 01, 02, 1, FNFSe.Servico.Valores.DescontoIncondicionado, '');
  Gerador.wCampoNFSe(tcDe2, '', 'inss', 01, 02, 1, FNFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampoNFSe(tcDe2, '', 'ir', 01, 02, 1, FNFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampoNFSe(tcDe2, '', 'issRetido', 01, 02, 1, FNFSe.Servico.Valores.ValorIssRetido, '');
  GerarListaServicos;
  Gerador.wCampoNFSe(tcStr, '', 'obs', 01, 4000, 1, FNFSe.OutrasInformacoes, '');
  Gerador.wCampoNFSe(tcDe2, '', 'pisPasep', 01, 02, 1, FNFSe.Servico.Valores.ValorPis, '');
  Gerador.wGrupoNFSe('/detalheServico');
end;

procedure TNFSeW_Giap.GerarTomador;
begin
  Gerador.wGrupoNFSe('dadosTomador');
  Gerador.wCampoNFSe(tcStr, '', 'bairro',             01,  50, 1, FNFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'cep',                01,  09, 1, OnlyNumber(FNFSe.Tomador.Endereco.CEP), '');
  if FNFSe.Tomador.Endereco.CodigoMunicipio = '9999999' then
    Gerador.wCampoNFSe(tcStr, '', 'cidade', 01, 50, 1, FNFSe.Tomador.Endereco.xMunicipio, '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'cidade', 01, 50, 1, CodCidadeToCidade(StrToInt64Def(FNFSe.Tomador.Endereco.CodigoMunicipio, 0)), '');
  Gerador.wCampoNFSe(tcStr, '', 'complemento',               01,  60, 1, FNFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'documento',            01,  14, 1, OnlyNumber(FNFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
  Gerador.wCampoNFSe(tcStr, '', 'email',              01,  60, 1, FNFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'ie',  01,  14, 1, OnlyNumber(FNFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), '');
  Gerador.wCampoNFSe(tcStr, '', 'logradouro',           01,  50, 1, FNFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nomeTomador', 01, 120, 1, FNFSe.Tomador.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'numero',            01,  50, 1, FNFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'pais',               01,  50, 1, FNFSe.Tomador.Endereco.xPais, '');
  if length(OnlyNumber(FNFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 11 then
    Gerador.wCampoNFSe(tcStr, '', 'tipoDoc', 01, 120, 1, 'F', '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'tipoDoc', 01, 120, 1, 'J', '');
  Gerador.wCampoNFSe(tcStr, '', 'uf',             01,  50, 1, FNFSe.Tomador.Endereco.UF, '');
  Gerador.wGrupoNFSe('/dadosTomador');
end;

procedure TNFSeW_Giap.GerarTransportadora;
begin
end;

procedure TNFSeW_Giap.GerarValoresServico;
begin
end;

function TNFSeW_Giap.GerarXml: Boolean;
//Var
//  Gerar: boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.Prefixo := FPrefixo4;

  Gerador.Opcoes.DecimalChar := '.';
  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  Atributo := '';

  Gerador.wGrupo('notaFiscal');
  FNFSe.InfID.ID := OnlyNumber(FNFSe.IdentificacaoRps.Numero) + FNFSe.IdentificacaoRps.Serie;
  GerarXML_Giap;
  Gerador.wGrupo('/notaFiscal');

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TNFSeW_Giap.GerarXML_Giap;
begin
  GerarPrestador;
  GerarTomador;
  GerarServicoValores;
end;

function TNFSeW_Giap.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

end.
