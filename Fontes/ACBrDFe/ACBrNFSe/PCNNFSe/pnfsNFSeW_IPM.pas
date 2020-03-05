{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit pnfsNFSeW_IPM;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrConsts,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSeW, pnfsNFSe, pnfsConversao, pnfsConsts;

type
  { TNFSeW_IPM }

  TNFSeW_IPM = class(TNFSeWClass)
  private
    FSituacao: String;
    FTipoRecolhimento: String;
  protected
    procedure GerarIdentificacaoHomologacao;
    procedure GerarIdentificacaoRPS;

    procedure GerarPrestador;
    procedure GerarTomador;

    procedure GerarListaServicos;
    procedure GerarValoresServico;

    procedure GerarCondicaoPagamento;

    procedure GerarXML_IPM;

  public
    Homologacao : Boolean;
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;

    property Situacao: String         read FSituacao;
    property TipoRecolhimento: String read FTipoRecolhimento;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout da IPM.                                                               }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_IPM }

procedure TNFSeW_IPM.GerarIdentificacaoHomologacao;
begin
  if NFSe.Producao = snNao then
    Gerador.wCampoNFSe(tcStr, '', 'nfse_teste', 1, 1, 1, 1, '1');
end;

procedure TNFSeW_IPM.GerarIdentificacaoRPS;
begin
  if( StrToIntDef( NFSe.IdentificacaoRps.Numero, 0 ) > 0 )then
  begin
    Gerador.wGrupoNFSe('rps');

    Gerador.wCampoNFSe(tcStr, '', 'nro_recibo_provisorio', 1, 12, 1, NFSe.IdentificacaoRps.Numero, DSC_NUMRPS);
    Gerador.wCampoNFSe(tcStr, '', 'serie_recibo_provisorio', 1, 02, 1, NFSe.IdentificacaoRps.Serie, DSC_SERIERPS);
    Gerador.wCampoNFSe(tcStr, '', 'data_emissao_recibo_provisorio', 1, 10, 1, FormatDateTimeBr(NFSe.DataEmissaoRps, 'dd/mm/yyyy'), DSC_DEMI);
    Gerador.wCampoNFSe(tcStr, '', 'hora_emissao_recibo_provisorio', 1, 8, 1, FormatDateTimeBr(NFSe.DataEmissaoRps, 'hh:mm:ss'), DSC_HEMI);

    Gerador.wGrupoNFSe('/rps');
  end;
end;

procedure TNFSeW_IPM.GerarPrestador;
begin
  Gerador.wGrupoNFSe('prestador');
  Gerador.wCampoNFSe(tcStr, '', 'cpfcnpj', 11, 14, 1, OnlyNumber(NFSe.Prestador.Cnpj), DSC_CNPJ);
  Gerador.wCampoNFSe(tcStr, '', 'cidade', 1, 9, 1, NFSe.PrestadorServico.Endereco.CodigoMunicipio, '');
  Gerador.wGrupoNFSe('/prestador');
end;

procedure TNFSeW_IPM.GerarTomador;
begin
  Gerador.wGrupoNFSe('tomador');

  if( NFSe.Status <> srCancelado )then
  begin
    if (NFSe.Tomador.Endereco.EnderecoInformado) then
      Gerador.wCampoNFSe(tcStr, '', 'endereco_informado', 1, 1, 0, 'S', '')
    else
      Gerador.wCampoNFSe(tcStr, '', 'endereco_informado', 1, 1, 0, 'N', '');
  end;

  if Trim(NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro) <> '' then
  begin
    Gerador.wCampoNFSe(tcStr, '', 'identificador', 1, 20, 1, Trim(NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro), '');
    Gerador.wCampoNFSe(tcStr, '', 'tipo', 1, 1, 1, 'E', '');
    Gerador.wCampoNFSe(tcStr, '', 'estado', 1, 100, 1, '', '');
    Gerador.wCampoNFSe(tcStr, '', 'pais', 1, 100, 1, NFSe.Tomador.Endereco.xPais, '');
  end
  else
  begin
    if Trim(NFSe.Tomador.IdentificacaoTomador.Tipo) = '' then
      Gerador.wCampoNFSe(tcStr, '', 'tipo', 1, 1, 1, IfThen(Length(OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj)) = 14, 'J', 'F'), '')
    else
      Gerador.wCampoNFSe(tcStr, '', 'tipo', 1, 1, 1, Trim(NFSe.Tomador.IdentificacaoTomador.Tipo));
  end;

  Gerador.wCampoNFSe(tcStr, '', 'cpfcnpj', 1, 14, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), DSC_CNPJ);
  Gerador.wCampoNFSe(tcStr, '', 'ie', 0, 16, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), DSC_IE);
  Gerador.wCampoNFSe(tcStr, '', 'nome_razao_social', 1, 100, 1, NFSe.Tomador.RazaoSocial, DSC_XNOME);
  Gerador.wCampoNFSe(tcStr, '', 'sobrenome_nome_fantasia', 0, 100, 1, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'logradouro', 1, 70, 0, NFSe.Tomador.Endereco.Endereco, DSC_XLGR);
  Gerador.wCampoNFSe(tcStr, '', 'email', 1, 100, 0, NFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'numero_residencia', 1, 8, 0, NFSe.Tomador.Endereco.Numero, DSC_NRO);
  Gerador.wCampoNFSe(tcStr, '', 'complemento', 0, 50, 0, NFSe.Tomador.Endereco.Complemento, DSC_XCPL);
  Gerador.wCampoNFSe(tcStr, '', 'ponto_referencia', 0, 100, 0, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'bairro', 0, 30, 0, NFSe.Tomador.Endereco.Bairro, DSC_XBAIRRO);
  Gerador.wCampoNFSe(tcStr, '', 'cidade', 1, 09, 0, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'cep', 1, 08, 0, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampoNFSe(tcStr, '', 'ddd_fone_comercial', 0, 3, 0, NFSe.Tomador.Contato.DDD, DSC_DDD);
  Gerador.wCampoNFSe(tcStr, '', 'fone_comercial', 0, 09, 0, NFSe.Tomador.Contato.Telefone, '');
  Gerador.wCampoNFSe(tcStr, '', 'ddd_fone_residencial', 0, 03, 0, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'fone_residencial', 0, 09, 0, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'ddd_fax', 0, 03, 0, '', '');
  Gerador.wCampoNFSe(tcStr, '', 'fone_fax', 0, 09, 0, '', '');
  Gerador.wGrupoNFSe('/tomador');
end;

procedure TNFSeW_IPM.GerarListaServicos;
var
  i: Integer;
begin
  Gerador.wGrupoNFSe('itens');

  for I := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Gerador.wGrupoNFSe('lista');

    if EstaVazio(NFSe.Servico.CodigoTributacaoMunicipio) then
    begin
      if (NFSe.PrestadorServico.Endereco.CodigoMunicipio <> IntToStr(NFSe.Servico.MunicipioIncidencia)) then
        // N�o Tributa no Municipio do prestador
        Gerador.wCampoNFSe(tcStr, '', 'tributa_municipio_prestador', 1, 1, 1, '0', '')
      else
        // Tributa no Municipio do Prestador
        Gerador.wCampoNFSe(tcStr, '', 'tributa_municipio_prestador', 1, 1, 1, '1', '');
    end
    else
      Gerador.wCampoNFSe(tcStr, '', 'tributa_municipio_prestador', 1, 1, 1, NFSe.Servico.CodigoTributacaoMunicipio, '');

    Gerador.wCampoNFSe(tcStr, '', 'codigo_local_prestacao_servico', 1, 9, 1, NFSe.Servico.CodigoMunicipio, '');
    Gerador.wCampoNFSe(tcStr, '', 'unidade_codigo', 1, 9, 0, TUnidadeToStr(NFSe.Servico.ItemServico[I].TipoUnidade), '');
    Gerador.wCampoNFSe(tcDe3, '', 'unidade_quantidade', 1, 15, 0, NFSe.Servico.ItemServico[I].Quantidade, '');
    Gerador.wCampoNFSe(tcDe6, '', 'unidade_valor_unitario', 1, 30, 0, NFSe.Servico.ItemServico[I].ValorUnitario, '');
    Gerador.wCampoNFSe(tcStr, '', 'codigo_item_lista_servico', 1, 9, 1, OnlyNumber(NFSe.Servico.ItemServico[I].ItemListaServico), '');
    Gerador.wCampoNFSe(tcStr, '', 'descritivo', 1, 1000, 1, IfThen(NFSe.Servico.ItemServico[I].Descricao = '', NFSe.Servico.Discriminacao, NFSe.Servico.ItemServico[I].Descricao));

    if NFSe.Servico.ItemServico[I].Aliquota = 0 then
      Gerador.wCampoNFSe(tcDe2, '', 'aliquota_item_lista_servico', 1, 15, 1, NFSe.Servico.Valores.Aliquota, '')
    else
      Gerador.wCampoNFSe(tcDe2, '', 'aliquota_item_lista_servico', 1, 15, 1, NFSe.Servico.ItemServico[I].Aliquota, '');

    // At� me provem o contario a gera��o dessa tag vai ficara dessa forma, conforme
    // consta na postagem de: Cleyton
    // https://www.projetoacbr.com.br/forum/topic/48762-nfse-ipm-arauc%C3%A1ria-modo-teste/
    Gerador.wCampoNFSe(tcStr, '', 'situacao_tributaria', 1, 4, 1, NaturezaOperacaoToStr( NFSe.NaturezaOperacao), '');

    Gerador.wCampoNFSe(tcDe2, '', 'valor_tributavel', 1, 15, 1, NFSe.Servico.ItemServico[I].ValorServicos, '');
    Gerador.wCampoNFSe(tcDe2, '', 'valor_deducao', 1, 15, 0, NFSe.Servico.ItemServico[I].ValorDeducoes, '');

    if NFSe.Servico.Valores.ValorIssRetido > 0 then
      Gerador.wCampoNFSe(tcDe2, '', 'valor_issrf', 1, 15, 0, NFSe.Servico.ItemServico[I].ValorIss, DSC_VISS )
    else
      Gerador.wCampoNFSe(tcDe2, '', 'valor_issrf', 1, 15, 0, 0, DSC_VISS );

    Gerador.wGrupoNFSe('/lista');
  end;

  Gerador.wGrupoNFSe('/itens');
end;

procedure TNFSeW_IPM.GerarValoresServico;
begin
  Gerador.wGrupoNFSe('nf');

  if NFSe.Status = srCancelado then
  begin
    Gerador.wCampoNFSe(tcStr, '', 'situacao', 1, 1, 1, 'C', '');
    Gerador.wCampoNFSe(tcStr, '', 'numero', 0, 9, 1, NFSe.Numero, '')
  end;

  Gerador.wCampoNFSe(tcDe2, '', 'valor_total', 1, 15,   1, NFSe.Servico.Valores.ValorServicos, DSC_VSERVICO);
  Gerador.wCampoNFSe(tcDe2, '', 'valor_desconto', 1, 15,   0, NFSe.Servico.Valores.DescontoIncondicionado, DSC_VDESC);
  Gerador.wCampoNFSe(tcDe2, '', 'valor_ir', 1, 15,   0, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampoNFSe(tcDe2, '', 'valor_inss', 1, 15,   0, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampoNFSe(tcDe2, '', 'valor_contribuicao_social', 1, 15,   0, NFSe.Servico.Valores.ValorCsll, '');
  Gerador.wCampoNFSe(tcDe2, '', 'valor_rps', 1, 15,   0, 0, '');
  Gerador.wCampoNFSe(tcDe2, '', 'valor_pis', 1, 15,   0, NFSe.Servico.Valores.ValorPis, DSC_VPIS);
  Gerador.wCampoNFSe(tcDe2, '', 'valor_cofins', 1, 15,   0, NFSe.Servico.Valores.ValorCofins, DSC_VCOFINS);
  Gerador.wCampoNFSe(tcStr, '', 'observacao', 1, 1000, 0, NFSe.OutrasInformacoes, DSC_OUTRASINF);

  Gerador.wGrupoNFSe('/nf');
end;

procedure TNFSeW_IPM.GerarCondicaoPagamento;
var
  i: Integer;
  codFp : String;
begin
  Gerador.wGrupoNFSe('forma_pagamento');
  codFp := EnumeradoToStr(NFSe.CondicaoPagamento.Condicao,
                          ['1', '3', '2', '4', '5'],
                          [cpAVista, cpNaApresentacao, cpAPrazo, cpCartaoDebito,cpCartaoCredito]);
  Gerador.wCampoNFSe(tcStr, '', 'tipo_pagamento', 1, 9, 1, codFp, '');


  if (NFSe.CondicaoPagamento.QtdParcela > 0) then
  begin
    Gerador.wGrupoNFSe('parcelas');
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
    begin
      Gerador.wGrupoNFSe('parcela');
      Gerador.wCampoNFSe(tcInt, '#55', 'numero', 01, 03, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, '');
      Gerador.wCampoNFSe(tcDatVcto, '#55', 'data_vencimento', 10, 10, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, '');
      Gerador.wCampoNFSe(tcDe2, '#55', 'valor', 01, 18, 1, NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, '');
      Gerador.wGrupoNFSe('/parcela');
    end;
    Gerador.wGrupoNFSe('/parcelas');
  end;

  Gerador.wGrupoNFSe('/forma_pagamento');
end;

procedure TNFSeW_IPM.GerarXML_IPM;
begin
  Gerador.Opcoes.DecimalChar := ',';

  Gerador.Prefixo := '';

  Gerador.wGrupoNFSe('nfse ' + FIdentificador + '="' + FNFSe.InfID.ID + '"');
  GerarIdentificacaoHomologacao;
  GerarIdentificacaoRPS;
  GerarValoresServico;
  GerarPrestador;
  GerarTomador;
  GerarListaServicos;

  if NFSe.Status = srNormal then
     GerarCondicaoPagamento;

  Gerador.wGrupoNFSe('/nfse');
end;

constructor TNFSeW_IPM.Create(ANFSeW: TNFSeW);
begin
  Homologacao := False;
  inherited Create(ANFSeW);
end;

function TNFSeW_IPM.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_IPM.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  FNFSe.InfID.ID := FNFSe.IdentificacaoRps.Numero;

  GerarXML_IPM;

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
