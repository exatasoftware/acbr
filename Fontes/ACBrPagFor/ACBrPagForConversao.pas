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

unit ACBrPagForConversao;

interface

uses
  SysUtils, StrUtils,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  Classes;

type
  TVersaoLayout = (ve084);

  TBanco = (pagNenhum, pagBancoDoBrasil, pagSantander, pagCaixaEconomica,
            pagCaixaSicob, pagBradesco, pagItau, pagBancoMercantil, pagSicred,
            pagBancoob, pagBanrisul, pagBanestes, pagHSBC, pagBancoDoNordeste,
            pagBRB, pagBicBanco, pagBradescoSICOOB, pagBancoSafra,
            pagSafraBradesco, pagBancoCECRED, pagUnibanco);

  TTipoInscricao = (tiIsento, tiCPF, tiCNPJ, tiPISPASEP, tiOutros);

  TTipoArquivo = (taRemessa, taRetorno);

  TTipoServico = (tsCobranca, tsBloquetoEletronico, tsConciliacaoBancaria,
                  tsDebitos, tsCustodiaCheques, tsGestaoCaixa,
                  tsConsultaMargem, tsAverbacaoConsignacao,
                  tsPagamentoDividendos, tsManutencaoConsignacao,
                  tsConsignacaoParcelas, tsGlosaConsignacao,
                  tsConsultaTributosaPagar, tsDebentures, tsPagamentoFornecedor,
                  tsPagamentoContas, tsCompror, tsComprorRotativo,
                  tsAlegacaoSacado, tsPagamentoSalarios,
                  tsPagamentoHonorarios, tsPagamentoBolsaAuxilio,
                  tsPagamentoPrebenda, tsVendor, tsVendoraTermo,
                  tsPagamentoSinistrosSegurado, tsPagamentoDespesaViagem,
                  tsPagamentoAutorizado, tsPagamentoCredenciados,
                  tsPagamentoRemuneracao, tsPagamentoRepresentantes,
                  tsPagamentoBeneficios, tsPagamentosDiversos, tsNenhum);

  TFormaLancamento = (flCreditoContaCorrente, flChequePagamento, flDocTed,
                      flCartaoSalario, flCreditoContaPoupanca, flCreditoContaCorrenteMesmaTitularidade, flDocMesmaTitularidade, flOPDisposicao,
                      flPagamentoContas, flPagamentoConcessionarias, flTributoDARFNormal, flTributoGPS,
                      flTributoDARFSimples, flTributoIPTU,
                      flPagamentoAutenticacao, flTributoDARJ,
                      flTributoGARESPICMS, flTributoGARESPDR,
                      flTributoGARESPITCMD, flTributoIPVA,
                      flTributoLicenciamento, flTributoDPVAT,
                      flLiquidacaoTitulosProprioBanco,
                      flLiquidacaoTitulosOutrosBancos, flLiberacaoTitulosNotaFiscalEletronica,
                      flLiquidacaoParcelasNaoRegistrada, flFGTSGFIP,
                      flExtratoContaCorrente, flTEDOutraTitularidade,
                      flTEDMesmaTitularidade, flTEDTransferencia,
                      flDebitoContaCorrente, flExtratoGestaoCaixa,
                      flDepositoJudicialContaCorrente, flCartaoSalarioItau,
                      flDepositoJudicialPoupanca, flExtratoContaInvestimento,
                      flTributoGNRe, flNenhum);

  TTipoMovimento = (tmInclusao, tmConsulta, tmEstorno, tmAlteracao,
                    tmLiquidacao, tmExclusao);

  TInstrucaoMovimento = (imInclusaoRegistroDetalheLiberado,
                         imInclusaoRegistroDetalheBloqueado,
                         imAltecacaoPagamentoLiberadoparaBloqueio,
                         imAlteracaoPagamentoBloqueadoparaLiberado,
                         imAlteracaoValorTitulo,
                         imAlteracaoDataPagamento,
                         imPagamentoDiretoFornecedor,
                         imManutencaoemCarteira,
                         imRetiradadeCarteira,
                         imEstornoDevolucaoCamaraCentralizadora,
                         imAlegacaoSacado,
                         imExclusaoRegistro);

  TTipoMoeda = (tmBonusTesouroNacional, tmReal, tmDolarAmericano,
                tmEscudoPortugues, tmFrancoFrances, tmFrancoSuico,
                tmIenJapones, tmIndiceGeralPrecos, tmIndiceGeralPrecosMercado,
                tmLibraEsterlina, tmMarcoAlemao, tmTaxaReferencialDiaria,
                tmUnidadePadraoCapital, tmUnidadePadraoFinanciamento,
                tmUnidadeFiscalReferencia, tmUnidadeMonetariaEuropeia);

  TTipoTributo = (ttGPS, ttDARFNormal, ttDARFSimples, ttDARJ, ttGareICMS,
                  ttIPVA, ttDPVAT, ttLicenciamento, ttFGTS);

  TIndTributo = (itNenhum, itDANFNormal, itDARFSimples, itGPS, itDARJ,
                 itIPVA, itLicenciamento, itDPVAT);

  TTipoOperacao = (toCredito, toDebito, toExtrato, toGestao,
                   toInformacao, toRemessa, toRetorno);

  TTipoMovimentoPagto = (tmpCredito,
                         tmpDebito,
                         tmpAcumulado,
                         tmpRendimentoTributavelDeducaoIRRF,
                         tmpRendimentoIsentoNaoTributavel,
                         tmpRendimentoSujeitoTributacaoExclusiva,
                         tmpRendimentoRecebidoAcumuladamente,
                         tmpInformacaoComplementar);

  TCodigoPagamentoGps = (cpgContribuinteIndividualRecolhimentoMensal,     //NIT PIS PASEP
                         cpgContribuinteIndividualRecolhimentoTrimestral, //NIT PIS PASEP
                         cpgSecuradoFacultativoRecolhimentoMensal,        //NIT PIS PASEP
                         cpgSecuradoFacultativoRecolhimentoTrimestral,    //NIT PIS PASEP
                         cpgSecuradoEspecialRecolhimentoMensal,           //NIT PIS PASEP
                         cpgSecuradoEspecialRecolhimentoTrimestral,       //NIT PIS PASEP
                         cpgEmpresasOptantesSimplesCNPJ,
                         cpgEmpresasGeralCNPJ,
                         cpgEmpresasGeralCEI,
                         cpgContribuicaoRetidaSobreNfFaturaEmpresaPrestadoraServicoCNPJ,
                         ReclamatoriaTrabalhistaCNPJ);

function StrToEnumerado(var ok: boolean; const s: string; const AString: array of string; const AEnumerados: array of variant): variant;
function EnumeradoToStr(const t: variant; const AString: array of string; const AEnumerados: array of variant): variant;

function BancoToStr(const t: TBanco): String;
function BancoToDesc(const t: TBanco): String;
function StrToBanco(var ok: boolean; const s: String): TBanco;

function TpInscricaoToStr(const t: TTipoInscricao): String;
function StrToTpInscricao(var ok: boolean; const s: string): TTipoInscricao;

function TpArquivoToStr(const t: TTipoArquivo): String;
function StrToTpArquivo(var ok: boolean; const s: String): TTipoArquivo;

function TpServicoToStr(const t: TTipoServico): String;
function StrToTpServico(var ok: boolean; const s: String): TTipoServico;

function FmLancamentoToStr(const t: TFormaLancamento): String;
function StrToFmLancamento(var ok: boolean; const s: String): TFormaLancamento;

function TpMovimentoToStr(const t: TTipoMovimento): String;
function StrToTpMovimento(var ok:boolean; const s: string): TTipoMovimento;

function InMovimentoToStr(const t: TInstrucaoMovimento): String;
function StrToInMovimento(var ok: boolean; const s: string): TInstrucaoMovimento;

function TpMoedaToStr(const t: TTipoMoeda): String;

function TpIndTributoToStr(const t: TIndTributo): String;

function TpOperacaoToStr(const t: TTipoOperacao): String;
function StrToTpOperacao(var ok: boolean; const s:string): TTipoOperacao;

function TpMovimentoPagtoToStr(const t: TTipoMovimentoPagto): String;
function StrToTpMovimentoPagto(var ok:boolean; const s:string): TTipoMovimentoPagto;

function CodigoPagamentoGpsToStr(const t: TCodigoPagamentoGps): String;
function StrToCodigoPagamentoGps(var ok: boolean; const s: string): TCodigoPagamentoGps;

function TpTributoToStr(const t: TTipoTributo): String;

function DescricaoRetornoItau(const ADesc: string): string;

function DescricaoRetornoSantander(const ADesc: string): string;

function DescricaoRetornoBancoDoBrasil(const ADesc: string): string;

implementation

function StrToEnumerado(var ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;
  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];
  ok := result <> -1;
  if not ok then
    result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';
  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

///////////////////////////////////////////////////////////////////////////////
(*
 cbBancos.Items.Add('246-D - Banco ABC Brasil S.A.');
 cbBancos.Items.Add('025-D - Banco Alfa S.A.');
 cbBancos.Items.Add('641-D - Banco Alvorada S.A.');
 cbBancos.Items.Add('029-D - Banco Banerj S.A.');
 cbBancos.Items.Add('000-D - Banco Bankpar S.A.');
 cbBancos.Items.Add('740-D - Banco Barclays S.A.');
 cbBancos.Items.Add('107-D - Banco BBM S.A.');
 cbBancos.Items.Add('031-D - Banco Beg S.A.');
 cbBancos.Items.Add('739-D - Banco BGN S.A.');
 cbBancos.Items.Add('096-D - Banco BM&F de Servi�os de Liquida��o e Cust�dia S.A');
 cbBancos.Items.Add('318-D - Banco BMG S.A.');
 cbBancos.Items.Add('752-D - Banco BNP Paribas Brasil S.A.');
 cbBancos.Items.Add('248-D - Banco Boavista Interatl�ntico S.A.');
 cbBancos.Items.Add('218-D - Banco Bonsucesso S.A.');
 cbBancos.Items.Add('036-D - Banco Bradesco BBI S.A.');
 cbBancos.Items.Add('204-D - Banco Bradesco Cart�es S.A.');
 cbBancos.Items.Add('394-D - Banco Bradesco Financiamentos S.A.');
 cbBancos.Items.Add('225-D - Banco Brascan S.A.');
 cbBancos.Items.Add('208-D - Banco BTG Pactual S.A.');
 cbBancos.Items.Add('044-D - Banco BVA S.A.');
 cbBancos.Items.Add('263-D - Banco Cacique S.A.');
 cbBancos.Items.Add('473-D - Banco Caixa Geral - Brasil S.A.');
 cbBancos.Items.Add('040-D - Banco Cargill S.A.');
 cbBancos.Items.Add('745-D - Banco Citibank S.A.');
 cbBancos.Items.Add('215-D - Banco Comercial e de Investimento Sudameris S.A.');
 cbBancos.Items.Add('748-D - Banco Cooperativo Sicredi S.A.');
 cbBancos.Items.Add('222-D - Banco Credit Agricole Brasil S.A.');
 cbBancos.Items.Add('505-D - Banco Credit Suisse (Brasil) S.A.');
 cbBancos.Items.Add('229-D - Banco Cruzeiro do Sul S.A.');
 cbBancos.Items.Add('003-D - Banco da Amaz�nia S.A.');
 cbBancos.Items.Add('083-3 - Banco da China Brasil S.A.');
 cbBancos.Items.Add('707-D - Banco Daycoval S.A.');
 cbBancos.Items.Add('024-D - Banco de Pernambuco S.A. - BANDEPE');
 cbBancos.Items.Add('456-D - Banco de Tokyo-Mitsubishi UFJ Brasil S.A.');
 cbBancos.Items.Add('214-D - Banco Dibens S.A.');
 cbBancos.Items.Add('047-D - Banco do Estado de Sergipe S.A.');
 cbBancos.Items.Add('037-D - Banco do Estado do Par� S.A.');
 cbBancos.Items.Add('041-D - Banco do Estado do Rio Grande do Sul S.A.');
 cbBancos.Items.Add('004-D - Banco do Nordeste do Brasil S.A.');
 cbBancos.Items.Add('265-D - Banco Fator S.A.');
 cbBancos.Items.Add('224-D - Banco Fibra S.A.');
 cbBancos.Items.Add('626-D - Banco Ficsa S.A.');
 cbBancos.Items.Add('233-D - Banco GE Capital S.A.');
 cbBancos.Items.Add('612-D - Banco Guanabara S.A.');
 cbBancos.Items.Add('063-D - Banco Ibi S.A. Banco M�ltiplo');
 cbBancos.Items.Add('604-D - Banco Industrial do Brasil S.A.');
 cbBancos.Items.Add('320-D - Banco Industrial e Comercial S.A.');
 cbBancos.Items.Add('653-D - Banco Indusval S.A.');
 cbBancos.Items.Add('630-D - Banco Intercap S.A.');
 cbBancos.Items.Add('249-D - Banco Investcred Unibanco S.A.');
 cbBancos.Items.Add('184-D - Banco Ita� BBA S.A.');
 cbBancos.Items.Add('479-D - Banco Ita�Bank S.A');
 cbBancos.Items.Add('376-D - Banco J. P. Morgan S.A.');
 cbBancos.Items.Add('074-D - Banco J. Safra S.A.');
 cbBancos.Items.Add('217-D - Banco John Deere S.A.');
 cbBancos.Items.Add('065-D - Banco Lemon S.A.');
 cbBancos.Items.Add('600-D - Banco Luso Brasileiro S.A.');
 cbBancos.Items.Add('755-D - Banco Merrill Lynch de Investimentos S.A.');
 cbBancos.Items.Add('746-D - Banco Modal S.A.');
 cbBancos.Items.Add('045-D - Banco Opportunity S.A.');
 cbBancos.Items.Add('623-D - Banco Panamericano S.A.');
 cbBancos.Items.Add('611-D - Banco Paulista S.A.');
 cbBancos.Items.Add('643-D - Banco Pine S.A.');
 cbBancos.Items.Add('638-D - Banco Prosper S.A.');
 cbBancos.Items.Add('747-D - Banco Rabobank International Brasil S.A.');
 cbBancos.Items.Add('633-D - Banco Rendimento S.A.');
 cbBancos.Items.Add('072-D - Banco Rural Mais S.A.');
 cbBancos.Items.Add('453-D - Banco Rural S.A.');
 cbBancos.Items.Add('422-D - Banco Safra S.A.');
 cbBancos.Items.Add('250-D - Banco Schahin S.A.');
 cbBancos.Items.Add('749-D - Banco Simples S.A.');
 cbBancos.Items.Add('366-D - Banco Soci�t� G�n�rale Brasil S.A.');
 cbBancos.Items.Add('637-D - Banco Sofisa S.A.');
 cbBancos.Items.Add('012-D - Banco Standard de Investimentos S.A.');
 cbBancos.Items.Add('464-D - Banco Sumitomo Mitsui Brasileiro S.A.');
 cbBancos.Items.Add('082-5 - Banco Top�zio S.A.');
 cbBancos.Items.Add('634-D - Banco Tri�ngulo S.A.');
 cbBancos.Items.Add('655-D - Banco Votorantim S.A.');
 cbBancos.Items.Add('610-D - Banco VR S.A.');
 cbBancos.Items.Add('370-D - Banco WestLB do Brasil S.A.');
 cbBancos.Items.Add('021-D - BANESTES S.A. Banco do Estado do Esp�rito Santo');
 cbBancos.Items.Add('719-D - Banif-Banco Internacional do Funchal (Brasil)S.A.');
 cbBancos.Items.Add('073-D - BB Banco Popular do Brasil S.A.');
 cbBancos.Items.Add('078-D - BES Investimento do Brasil S.A.-Banco de Investimento');
 cbBancos.Items.Add('069-D - BPN Brasil Banco M�ltiplo S.A.');
 cbBancos.Items.Add('070-D - BRB - Banco de Bras�lia S.A.');
 cbBancos.Items.Add('477-D - Citibank N.A.');
 cbBancos.Items.Add('081-7 - Conc�rdia Banco S.A.');
 cbBancos.Items.Add('487-D - Deutsche Bank S.A. - Banco Alem�o');
 cbBancos.Items.Add('751-D - Dresdner Bank Brasil S.A. - Banco M�ltiplo');
 cbBancos.Items.Add('064-D - Goldman Sachs do Brasil Banco M�ltiplo S.A.');
 cbBancos.Items.Add('062-D - Hipercard Banco M�ltiplo S.A.');
 cbBancos.Items.Add('399-D - HSBC Bank Brasil S.A. - Banco M�ltiplo');
 cbBancos.Items.Add('492-D - ING Bank N.V.');
 cbBancos.Items.Add('652-D - Ita� Unibanco Holding S.A.');
 cbBancos.Items.Add('341-D - Ita� Unibanco S.A.');
 cbBancos.Items.Add('488-D - JPMorgan Chase Bank');
 cbBancos.Items.Add('409-D - UNIBANCO - Uni�o de Bancos Brasileiros S.A.');
 cbBancos.Items.Add('230-D - Unicard Banco M�ltiplo S.A.');
*)
function BancoToStr(const t: TBanco): String;
begin
  result := EnumeradoToStr(t, ['000', '001', '033', '104',
                               '000', '237', '341', '389', '748',
                               '756', '000', '000', '399', '000',
                               '000', '000', '000', '422',
                               '000', '085', '409'],
           [pagNenhum, pagBancoDoBrasil, pagSantander, pagCaixaEconomica,
            pagCaixaSicob, pagBradesco, pagItau, pagBancoMercantil, pagSicred,
            pagBancoob, pagBanrisul, pagBanestes, pagHSBC, pagBancoDoNordeste,
            pagBRB, pagBicBanco, pagBradescoSICOOB, pagBancoSafra,
            pagSafraBradesco, pagBancoCECRED, pagUnibanco]);
end;

function BancoToDesc(const t: TBanco): String;
begin
  result := EnumeradoToStr(t, ['Nenhum', 'Banco do Brasil', 'Santander',
                               'Caixa Economica Federal', 'Caixa Sicob',
                               'Bradesco', 'Itau', 'Banco Mercantil',
                               'Sicred', 'Bancoob', 'Banrisul', 'Banestes',
                               'HSBC', 'Banco do Nordeste', 'BRB',
                               'Bic Banco', 'Bradesco Sicob', 'Banco Safra',
                               'Safra Bradesco', 'Ailos', 'Unibanco'],
           [pagNenhum, pagBancoDoBrasil, pagSantander, pagCaixaEconomica,
            pagCaixaSicob, pagBradesco, pagItau, pagBancoMercantil, pagSicred,
            pagBancoob, pagBanrisul, pagBanestes, pagHSBC, pagBancoDoNordeste,
            pagBRB, pagBicBanco, pagBradescoSICOOB, pagBancoSafra,
            pagSafraBradesco, pagBancoCECRED, pagUnibanco]);
end;

function StrToBanco(var ok: boolean; const s: String): TBanco;
begin
  Result := StrToEnumerado(ok, s,
                           ['000', '001', '033', '104', '000', '237', '341',
                            '389', '748', '756', '000', '000', '399', '000',
                            '000', '000', '000', '422', '000', '085', '409'],
                           [pagNenhum, pagBancoDoBrasil, pagSantander, pagCaixaEconomica,
                            pagCaixaSicob, pagBradesco, pagItau, pagBancoMercantil, pagSicred,
                            pagBancoob, pagBanrisul, pagBanestes, pagHSBC, pagBancoDoNordeste,
                            pagBRB, pagBicBanco, pagBradescoSICOOB, pagBancoSafra,
                            pagSafraBradesco, pagBancoCECRED, pagUnibanco]);
end;

function TpInscricaoToStr(const t: TTipoInscricao): String;
begin
 result := EnumeradoToStr(t, ['0', '1', '2', '3', '9'],
                             [tiIsento, tiCPF, tiCNPJ, tiPISPASEP, tiOutros]);
end;

function StrToTpInscricao(var ok: boolean; const s: string): TTipoInscricao;
begin
 result := StrToEnumerado(ok, s, ['0', '1', '2', '3', '9'],
                                 [tiIsento, tiCPF, tiCNPJ, tiPISPASEP, tiOutros]);
end;

function TpArquivoToStr(const t: TTipoArquivo): String;
begin
 result := EnumeradoToStr(t, ['1', '2'], [taRemessa, taRetorno]);
end;

function StrToTpArquivo(var ok: boolean; const s: String): TTipoArquivo;
begin
 result := StrToEnumerado(ok, s, ['1', '2'], [taRemessa, taRetorno]);
end;

function TpServicoToStr(const t: TTipoServico): String;
begin
 result := EnumeradoToStr(t, ['01', '03', '04', '05', '06', '07', '08',
                           '09', '10', '11', '12', '13', '14', '15', '20', '22', '25',
                           '26', '29', '30', '32', '33', '34', '40', '41', '50',
                           '60', '70', '75', '77', '80', '90', '98', '  '],
                       [tsCobranca, tsBloquetoEletronico, tsConciliacaoBancaria,
                        tsDebitos, tsCustodiaCheques, tsGestaoCaixa,
                        tsConsultaMargem, tsAverbacaoConsignacao,
                        tsPagamentoDividendos, tsManutencaoConsignacao,
                        tsConsignacaoParcelas, tsGlosaConsignacao,
                        tsConsultaTributosaPagar, tsDebentures,
                        tsPagamentoFornecedor,
                        tsPagamentoContas, tsCompror, tsComprorRotativo,
                        tsAlegacaoSacado, tsPagamentoSalarios,
                        tsPagamentoHonorarios, tsPagamentoBolsaAuxilio,
                        tsPagamentoPrebenda, tsVendor, tsVendoraTermo,
                        tsPagamentoSinistrosSegurado, tsPagamentoDespesaViagem,
                        tsPagamentoAutorizado, tsPagamentoCredenciados,
                        tsPagamentoRemuneracao, tsPagamentoRepresentantes,
                        tsPagamentoBeneficios, tsPagamentosDiversos,
                        tsNenhum]);
end;

function StrToTpServico(var ok: boolean; const s: String): TTipoServico;
begin
  result := StrToEnumerado(ok, s,
                           ['01', '03', '04', '05', '06', '07', '08',
                           '09', '10', '11', '12', '13', '14', '15', '20', '22', '25',
                           '26', '29', '30', '32', '33', '34', '40', '41', '50',
                           '60', '70', '75', '77', '80', '90', '98', '  '],
                       [tsCobranca, tsBloquetoEletronico, tsConciliacaoBancaria,
                        tsDebitos, tsCustodiaCheques, tsGestaoCaixa,
                        tsConsultaMargem, tsAverbacaoConsignacao,
                        tsPagamentoDividendos, tsManutencaoConsignacao,
                        tsConsignacaoParcelas, tsGlosaConsignacao,
                        tsConsultaTributosaPagar, tsDebentures,
                        tsPagamentoFornecedor,
                        tsPagamentoContas, tsCompror, tsComprorRotativo,
                        tsAlegacaoSacado, tsPagamentoSalarios,
                        tsPagamentoHonorarios, tsPagamentoBolsaAuxilio,
                        tsPagamentoPrebenda, tsVendor, tsVendoraTermo,
                        tsPagamentoSinistrosSegurado, tsPagamentoDespesaViagem,
                        tsPagamentoAutorizado, tsPagamentoCredenciados,
                        tsPagamentoRemuneracao, tsPagamentoRepresentantes,
                        tsPagamentoBeneficios, tsPagamentosDiversos,
                        tsNenhum]);
end;

function StrToFmLancamento(var ok: boolean; const s: String): TFormaLancamento;
begin
 result := StrToEnumerado(ok, s,
                          ['01', '02', '03', '04', '05', '06', '07', '10', '11', '13',
                           '16', '17', '18', '19', '20', '21', '22', '23', '24', '25',
                           '26', '27', '30', '31', '32', '33', '35', '40', '41', '43',
                           '44', '50', '60', '70', '71', '72', '73', '91', '  '],
                         [flCreditoContaCorrente, flChequePagamento, flDocTed,
                          flCartaoSalario, flCreditoContaPoupanca, flCreditoContaCorrenteMesmaTitularidade, flDocMesmaTitularidade, flOPDisposicao,
                          flPagamentoContas, flPagamentoConcessionarias, flTributoDARFNormal, flTributoGPS,
                          flTributoDARFSimples, flTributoIPTU,
                          flPagamentoAutenticacao, flTributoDARJ,
                          flTributoGARESPICMS, flTributoGARESPDR,
                          flTributoGARESPITCMD, flTributoIPVA,
                          flTributoLicenciamento, flTributoDPVAT,
                          flLiquidacaoTitulosProprioBanco,
                          flLiquidacaoTitulosOutrosBancos, flLiberacaoTitulosNotaFiscalEletronica,
                          flLiquidacaoParcelasNaoRegistrada, flFGTSGFIP,
                          flExtratoContaCorrente, flTEDOutraTitularidade,
                          flTEDMesmaTitularidade, flTEDTransferencia,
                          flDebitoContaCorrente, flCartaoSalarioItau,
                          flExtratoGestaoCaixa, flDepositoJudicialContaCorrente,
                          flDepositoJudicialPoupanca, flExtratoContaInvestimento,
                          flTributoGNRe, flNenhum]);
end;

function FmLancamentoToStr(const t: TFormaLancamento): String;
begin
 result := EnumeradoToStr(t,
                          ['01', '02', '03', '04', '05', '06', '07', '10', '11', '13',
                           '16', '17', '18', '19', '20', '21', '22', '23', '24', '25',
                           '26', '27', '30', '31', '32', '33', '35', '40', '41', '43',
                           '44', '50', '60', '70', '71', '72', '73', '91', '  '],
                         [flCreditoContaCorrente, flChequePagamento, flDocTed,
                          flCartaoSalario, flCreditoContaPoupanca, flCreditoContaCorrenteMesmaTitularidade, flDocMesmaTitularidade, flOPDisposicao,
                          flPagamentoContas, flPagamentoConcessionarias, flTributoDARFNormal, flTributoGPS,
                          flTributoDARFSimples, flTributoIPTU,
                          flPagamentoAutenticacao, flTributoDARJ,
                          flTributoGARESPICMS, flTributoGARESPDR,
                          flTributoGARESPITCMD, flTributoIPVA,
                          flTributoLicenciamento, flTributoDPVAT,
                          flLiquidacaoTitulosProprioBanco,
                          flLiquidacaoTitulosOutrosBancos, flLiberacaoTitulosNotaFiscalEletronica,
                          flLiquidacaoParcelasNaoRegistrada, flFGTSGFIP,
                          flExtratoContaCorrente, flTEDOutraTitularidade,
                          flTEDMesmaTitularidade, flTEDTransferencia,
                          flDebitoContaCorrente, flCartaoSalarioItau,
                          flExtratoGestaoCaixa, flDepositoJudicialContaCorrente,
                          flDepositoJudicialPoupanca, flExtratoContaInvestimento,
                          flTributoGNRe, flNenhum]);
end;

function TpMovimentoToStr(const t: TTipoMovimento): String;
begin
 result := EnumeradoToStr(t, ['0', '1', '2', '3', '5', '7', '9'],
                              [tmInclusao, tmConsulta, tmEstorno, tmAlteracao,
                               tmLiquidacao, tmExclusao]);
end;

function StrToTpMovimento(var ok:boolean; const s: string): TTipoMovimento;
begin
 result := StrToEnumerado(ok, s,
                              ['0', '1', '2', '3', '5', '7', '9'],
                              [tmInclusao, tmConsulta, tmEstorno, tmAlteracao,
                               tmLiquidacao, tmExclusao]);
end;

function InMovimentoToStr(const t: TInstrucaoMovimento): String;
begin
 result := EnumeradoToStr(t, ['00', '09', '10', '11', '17', '19', '23',
                                       '25', '27', '33', '40', '99'],
                              [imInclusaoRegistroDetalheLiberado,
                               imInclusaoRegistroDetalheBloqueado,
                               imAltecacaoPagamentoLiberadoparaBloqueio,
                               imAlteracaoPagamentoBloqueadoparaLiberado,
                               imAlteracaoValorTitulo,
                               imAlteracaoDataPagamento,
                               imPagamentoDiretoFornecedor,
                               imManutencaoemCarteira,
                               imRetiradadeCarteira,
                               imEstornoDevolucaoCamaraCentralizadora,
                               imAlegacaoSacado,
                               imExclusaoRegistro]);
end;

function StrToInMovimento(var ok: boolean; const s: string): TInstrucaoMovimento;
begin
 result := StrToEnumerado(ok, s, ['00', '09', '10', '11', '17', '19',
                                  '23', '25', '27', '33', '40', '99'],
                                 [imInclusaoRegistroDetalheLiberado,
                                  imInclusaoRegistroDetalheBloqueado,
                                  imAltecacaoPagamentoLiberadoparaBloqueio,
                                  imAlteracaoPagamentoBloqueadoparaLiberado,
                                  imAlteracaoValorTitulo,
                                  imAlteracaoDataPagamento,
                                  imPagamentoDiretoFornecedor,
                                  imManutencaoemCarteira,
                                  imRetiradadeCarteira,
                                  imEstornoDevolucaoCamaraCentralizadora,
                                  imAlegacaoSacado,
                                  imExclusaoRegistro]);
end;

function TpMoedaToStr(const t: TTipoMoeda): String;
begin
  result := EnumeradoToStr(t, ['BTN', 'BRL', 'USD', 'PTE', 'FRF', 'CHF', 'JPY',
                               'IGP', 'IGM', 'GBP', 'ITL', 'DEM', 'TRD', 'UPC',
                               'UPF', 'UFR', 'XEU'],
                   [tmBonusTesouroNacional, tmReal, tmDolarAmericano,
                    tmEscudoPortugues, tmFrancoFrances, tmFrancoSuico,
                    tmIenJapones, tmIndiceGeralPrecos, tmIndiceGeralPrecosMercado,
                    tmLibraEsterlina, tmMarcoAlemao, tmTaxaReferencialDiaria,
                    tmUnidadePadraoCapital, tmUnidadePadraoFinanciamento,
                    tmUnidadeFiscalReferencia, tmUnidadeMonetariaEuropeia]);
end;

function TpIndTributoToStr(const t: TIndTributo): String;
begin
  result := EnumeradoToStr(t, ['00', '16', '18', '17', '21', '25', '26', '27'],
                          [itNenhum, itDANFNormal, itDARFSimples, itGPS, itDARJ,
                           itIPVA, itLicenciamento, itDPVAT]);
end;

function TpOperacaoToStr(const t: TTipoOperacao): String;
begin
  result := EnumeradoToStr(t, ['C', 'D', 'E', 'G', 'I', 'R', 'T'],
                            [toCredito, toDebito, toExtrato, toGestao,
                             toInformacao, toRemessa, toRetorno]);
end;

function StrToTpOperacao(var ok: boolean; const s:string): TTipoOperacao;
begin
  result := StrToEnumerado(ok, s,
                           ['C', 'D', 'E', 'G', 'I', 'R', 'T'],
                           [toCredito, toDebito, toExtrato, toGestao,
                            toInformacao, toRemessa, toRetorno]);
end;

function TpMovimentoPagtoToStr(const t: TTipoMovimentoPagto): String;
begin
  result := EnumeradoToStr(t, ['1', '2', '3', '4', '5', '6', '7', '9'],
                            [tmpCredito,
                             tmpDebito,
                             tmpAcumulado,
                             tmpRendimentoTributavelDeducaoIRRF,
                             tmpRendimentoIsentoNaoTributavel,
                             tmpRendimentoSujeitoTributacaoExclusiva,
                             tmpInformacaoComplementar,
                             tmpRendimentoRecebidoAcumuladamente]);
end;

function StrToTpMovimentoPagto(var ok:boolean; const s:string): TTipoMovimentoPagto;
begin
  result := StrToEnumerado(ok, s,
                               ['1', '2', '3', '4', '5', '6', '7', '9'],
                               [tmpCredito, tmpDebito, tmpAcumulado, tmpRendimentoTributavelDeducaoIRRF,
                                tmpRendimentoIsentoNaoTributavel, tmpRendimentoSujeitoTributacaoExclusiva,
                                tmpInformacaoComplementar, tmpRendimentoRecebidoAcumuladamente]);
end;

function CodigoPagamentoGpsToStr(const t: TCodigoPagamentoGps): String;
begin
  result := EnumeradoToStr(t, ['1007', '1104', '1406', '1457', '1503', '1554', '2003', '2100', '2208', '2631', '2909'],
                            [cpgContribuinteIndividualRecolhimentoMensal,     //NIT PIS PASEP
                             cpgContribuinteIndividualRecolhimentoTrimestral, //NIT PIS PASEP
                             cpgSecuradoFacultativoRecolhimentoMensal,        //NIT PIS PASEP
                             cpgSecuradoFacultativoRecolhimentoTrimestral,    //NIT PIS PASEP
                             cpgSecuradoEspecialRecolhimentoMensal,           //NIT PIS PASEP
                             cpgSecuradoEspecialRecolhimentoTrimestral,       //NIT PIS PASEP
                             cpgEmpresasOptantesSimplesCNPJ,
                             cpgEmpresasGeralCNPJ,
                             cpgEmpresasGeralCEI,
                             cpgContribuicaoRetidaSobreNfFaturaEmpresaPrestadoraServicoCNPJ,
                             ReclamatoriaTrabalhistaCNPJ]);
end;

function StrToCodigoPagamentoGps(var ok: boolean; const s: string): TCodigoPagamentoGps;
begin
  result := StrToEnumerado(ok, s, ['1007', '1104', '1406', '1457', '1503', '1554', '2003', '2100', '2208', '2631', '2909'],
                                  [cpgContribuinteIndividualRecolhimentoMensal,     //NIT PIS PASEP
                                   cpgContribuinteIndividualRecolhimentoTrimestral, //NIT PIS PASEP
                                   cpgSecuradoFacultativoRecolhimentoMensal,        //NIT PIS PASEP
                                   cpgSecuradoFacultativoRecolhimentoTrimestral,    //NIT PIS PASEP
                                   cpgSecuradoEspecialRecolhimentoMensal,           //NIT PIS PASEP
                                   cpgSecuradoEspecialRecolhimentoTrimestral,       //NIT PIS PASEP
                                   cpgEmpresasOptantesSimplesCNPJ,
                                   cpgEmpresasGeralCNPJ,
                                   cpgEmpresasGeralCEI,
                                   cpgContribuicaoRetidaSobreNfFaturaEmpresaPrestadoraServicoCNPJ,
                                   ReclamatoriaTrabalhistaCNPJ]);
end;

function TpTributoToStr(const t: TTipoTributo): String;
begin
  Result := EnumeradoToStr(t, ['01', '02', '03', '04', '05', '07', '08', '', '11'],
                            [ttGPS, ttDARFNormal, ttDARFSimples, ttDARJ, ttGareICMS,
                             ttIPVA, ttDPVAT, ttLicenciamento, ttFGTS])
end;

function DescricaoRetornoItau(const ADesc: string): string;
begin
  if ADesc = '00' then
    Result := 'PAGAMENTO EFETUADO'
  else if ADesc = 'AE' then
    Result := 'DATA DE PAGAMENTO ALTERADA'
  else if ADesc = 'AG' then
    Result := 'N�MERO DO LOTE INV�LIDO'
  else if ADesc = 'AH' then
    Result := 'N�MERO SEQUENCIAL DO REGISTRO NO LOTE INV�LIDO'
  else if ADesc = 'AI' then
    Result := 'PRODUTO DEMONSTRATIVO DE PAGAMENTO N�O CONTRATADO'
  else if ADesc = 'AJ' then
    Result := 'TIPO DE MOVIMENTO INV�LIDO'
  else if ADesc = 'AL' then
    Result := 'C�DIGO DO BANCO FAVORECIDO INV�LIDO'
  else if ADesc = 'AM' then
    Result := 'AG�NCIA DO FAVORECIDO INV�LIDA'
  else if ADesc = 'AN' then
    Result := 'CONTA CORRENTE DO FAVORECIDO INV�LIDA / CONTA INVESTIMENTO EXTINTA EM 30/04/2011'
  else if ADesc = 'AO' then
    Result := 'NOME DO FAVORECIDO INV�LIDO'
  else if ADesc = 'AP' then
    Result := 'DATA DE PAGAMENTO / DATA DE VALIDADE / HORA DE LAN�AMENTO / ARRECADA��O / APURA��O INV�LIDA'
  else if ADesc = 'AQ' then
    Result := 'QUANTIDADE DE REGISTROS MAIOR QUE 999999'
  else if ADesc = 'AR' then
    Result := 'VALOR ARRECADADO / LAN�AMENTO INV�LIDO'
  else if ADesc = 'BC' then
    Result := 'NOSSO N�MERO INV�LIDO'
  else if ADesc = 'BD' then
    Result := 'PAGAMENTO AGENDADO'
  else if ADesc = 'BDCI' then
    Result := 'PAGAMENTO ACATADO, POR�M O CPF/CNPJ � INV�LIDO.'
  else if ADesc = 'BDCD' then
    Result := 'PAGAMENTO ACATADO, POR�M O CPF/CNPJ INFORMADO N�O � O MESMO QUE EST� CADASTRADO PARA A AG�NCIA CONTA CREDITADA'
  else if ADesc = 'BDCN' then
    Result := 'PAGAMENTO ACATADO, POR�M A AG�NCIA/CONTA INFORMADA (AINDA) N�O EXISTE'
  else if ADesc = 'BE' then
    Result := 'PAGAMENTO AGENDADO COM FORMA ALTEARADA PARA OP'
  else if ADesc = 'BI' then
    Result := 'CNPJ/CPF DO BENEFICI�RIO INV�LIDO NO SEGMENTO J-52 ou B INV�LIDO'
  else if ADesc = 'BL' then
    Result := 'VALOR DA PARCELA INV�LIDO'
  else if ADesc = 'CD' then
    Result := 'CNPJ / CPF INFORMADO DIVERGENTE DO CADASTRADO'
  else if ADesc = 'CE' then
    Result := 'PAGAMENTO CANCELADO'
  else if ADesc = 'CF' then
    Result := 'VALOR DO DOCUMENTO INV�LIDO'
  else if ADesc = 'CG' then
    Result := 'VALOR DO ABATIMENTO INV�LIDO'
  else if ADesc = 'CH' then
    Result := 'VALOR DO DESCONTO INV�LIDO'
  else if ADesc = 'CI' then
    Result := 'CNPJ / CPF / IDENTIFICADOR / INSCRI��O ESTADUAL / INSCRI��O NO CAD / ICMS INV�LIDO'
  else if ADesc = 'CJ' then
    Result := 'VALOR DA MULTA INV�LIDO'
  else if ADesc = 'CK' then
    Result := 'TIPO DE INSCRI��O INV�LIDA'
  else if ADesc = 'CL' then
    Result := 'VALOR DO INSS INV�LIDO'
  else if ADesc = 'CM' then
    Result := 'VALOR DO COFINS INV�LIDO'
  else if ADesc = 'CN' then
    Result := 'CONTA N�O CADASTRADA'
  else if ADesc = 'CO' then
    Result := 'VALOR DE OUTRAS ENTIDADES INV�LIDO'
  else if ADesc = 'CP' then
    Result := 'CONFIRMA��O DE OP CUMPRIDA'
  else if ADesc = 'CQ' then
    Result := 'SOMA DAS FATURAS DIFERE DO PAGAMENTO'
  else if ADesc = 'CR' then
    Result := 'VALOR DO CSLL INV�LIDO'
  else if ADesc = 'CS' then
    Result := 'DATA DE VENCIMENTO DA FATURA INV�LIDA'
  else if ADesc = 'DA' then
    Result := 'N�MERO DE DEPEND. SAL�RIO FAMILIA INVALIDO'
  else if ADesc = 'DB' then
    Result := 'N�MERO DE HORAS SEMANAIS INV�LIDO'
  else if ADesc = 'DC' then
    Result := 'SAL�RIO DE CONTRIBUI��O INSS INV�LIDO'
  else if ADesc = 'DD' then
    Result := 'SAL�RIO DE CONTRIBUI��O FGTS INV�LIDO'
  else if ADesc = 'DE' then
    Result := 'VALOR TOTAL DOS PROVENTOS INV�LIDO'
  else if ADesc = 'DF' then
    Result := 'VALOR TOTAL DOS DESCONTOS INV�LIDO'
  else if ADesc = 'DG' then
    Result := 'VALOR L�QUIDO N�O NUM�RICO'
  else if ADesc = 'DH' then
    Result := 'VALOR LIQ. INFORMADO DIFERE DO CALCULADO'
  else if ADesc = 'DI' then
    Result := 'VALOR DO SAL�RIO-BASE INV�LIDO'
  else if ADesc = 'DJ' then
    Result := 'BASE DE C�LCULO IRRF INV�LIDA'
  else if ADesc = 'DK' then
    Result := 'BASE DE C�LCULO FGTS INV�LIDA'
  else if ADesc = 'DL' then
    Result := 'FORMA DE PAGAMENTO INCOMPAT�VEL COM HOLERITE'
  else if ADesc = 'DM' then
    Result := 'E-MAIL DO FAVORECIDO INV�LIDO'
  else if ADesc = 'DV' then
    Result := 'DOC / TED DEVOLVIDO PELO BANCO FAVORECIDO'
  else if ADesc = 'D0' then
    Result := 'FINALIDADE DO HOLERITE INV�LIDA'
  else if ADesc = 'D1' then
    Result := 'M�S DE COMPETENCIA DO HOLERITE INV�LIDA'
  else if ADesc = 'D2' then
    Result := 'DIA DA COMPETENCIA DO HOLETITE INV�LIDA'
  else if ADesc = 'D3' then
    Result := 'CENTRO DE CUSTO INV�LIDO'
  else if ADesc = 'D4' then
    Result := 'CAMPO NUM�RICO DA FUNCIONAL INV�LIDO'
  else if ADesc = 'D5' then
    Result := 'DATA IN�CIO DE F�RIAS N�O NUM�RICA'
  else if ADesc = 'D6' then
    Result := 'DATA IN�CIO DE F�RIAS INCONSISTENTE'
  else if ADesc = 'D7' then
    Result := 'DATA FIM DE F�RIAS N�O NUM�RICO'
  else if ADesc = 'D8' then
    Result := 'DATA FIM DE F�RIAS INCONSISTENTE'
  else if ADesc = 'D9' then
    Result := 'N�MERO DE DEPENDENTES IR INV�LIDO'
  else if ADesc = 'EM' then
    Result := 'CONFIRMA��O DE OP EMITIDA'
  else if ADesc = 'EX' then
    Result := 'DEVOLU��O DE OP N�O SACADA PELO FAVORECIDO'
  else if ADesc = 'E0' then
    Result := 'TIPO DE MOVIMENTO HOLERITE INV�LIDO'
  else if ADesc = 'E1' then
    Result := 'VALOR 01 DO HOLERITE / INFORME INV�LIDO'
  else if ADesc = 'E2' then
    Result := 'VALOR 02 DO HOLERITE / INFORME INV�LIDO'
  else if ADesc = 'E3' then
    Result := 'VALOR 03 DO HOLERITE / INFORME INV�LIDO'
  else if ADesc = 'E4' then
    Result := 'VALOR 04 DO HOLERITE / INFORME INV�LIDO'
  else if ADesc = 'FC' then
    Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO COMPROR'
  else if ADesc = 'FD' then
    Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO DESCOMPROR'
  else if ADesc = 'HA' then
    Result := 'ERRO NO HEADER DE ARQUIVO'
  else if ADesc = 'HM' then
    Result := 'ERRO NO HEADER DE LOTE'
  else if ADesc = 'IB' then
    Result := 'VALOR E/OU DATA DO DOCUMENTO INV�LIDO'
  else if ADesc = 'IC' then
    Result := 'VALOR DO ABATIMENTO INV�LIDO'
  else if ADesc = 'ID' then
    Result := 'VALOR DO DESCONTO INV�LIDO'
  else if ADesc = 'IE' then
    Result := 'VALOR DA MORA INV�LIDO'
  else if ADesc = 'IF' then
    Result := 'VALOR DA MULTA INV�LIDO'
  else if ADesc = 'IG' then
    Result := 'VALOR DA DEDU��O INV�LIDO'
  else if ADesc = 'IH' then
    Result := 'VALOR DO ACR�SCIMO INV�LIDO'
  else if ADesc = 'II' then
    Result := 'DATA DE VENCIMENTO INV�LIDA'
  else if ADesc = 'IJ' then
    Result := 'COMPET�NCIA / PER�ODO REFER�NCIA / PARCELA INV�LIDA'
  else if ADesc = 'IK' then
    Result := 'TRIBUTO N�O LIQUID�VEL VIA SISPAG OU N�O CONVENIADO COM ITA�'
  else if ADesc = 'IL' then
    Result := 'C�DIGO DE PAGAMENTO / EMPRESA /RECEITA INV�LIDO'
  else if ADesc = 'IM' then
    Result := 'TIPO X FORMA N�O COMPAT�VEL'
  else if ADesc = 'IN' then
    Result := 'BANCO/AGENCIA N�O CADASTRADOS'
  else if ADesc = 'IO' then
    Result := 'DAC / VALOR / COMPET�NCIA / IDENTIFICADOR DO LACRE INV�LIDO'
  else if ADesc = 'IP' then
    Result := 'DAC DO C�DIGO DE BARRAS INV�LIDO'
  else if ADesc = 'IQ' then
    Result := 'D�VIDA ATIVA OU N�MERO DE ETIQUETA INV�LIDO'
  else if ADesc = 'IR' then
    Result := 'PAGAMENTO ALTERADO'
  else if ADesc = 'IS' then
    Result := 'CONCESSION�RIA N�O CONVENIADA COM ITA�'
  else if ADesc = 'IT' then
    Result := 'VALOR DO TRIBUTO INV�LIDO'
  else if ADesc = 'IU' then
    Result := 'VALOR DA RECEITA BRUTA ACUMULADA INV�LIDO'
  else if ADesc = 'IV' then
    Result := 'N�MERO DO DOCUMENTO ORIGEM / REFER�NCIA INV�LIDO'
  else if ADesc = 'IX' then
    Result := 'C�DIGO DO PRODUTO INV�LIDO'
  else if ADesc = 'LA' then
    Result := 'DATA DE PAGAMENTO DE UM LOTE ALTERADA'
  else if ADesc = 'LC' then
    Result := 'LOTE DE PAGAMENTOS CANCELADO'
  else if ADesc = 'NA' then
    Result := 'PAGAMENTO CANCELADO POR FALTA DE AUTORIZA��O'
  else if ADesc = 'NB' then
    Result := 'IDENTIFICA��O DO TRIBUTO INV�LIDA'
  else if ADesc = 'NC' then
    Result := 'EXERC�CIO (ANO BASE) INV�LIDO'
  else if ADesc = 'ND' then
    Result := 'C�DIGO RENAVAM N�O ENCONTRADO/INV�LIDO'
  else if ADesc = 'NE' then
    Result := 'UF INV�LIDA'
  else if ADesc = 'NF' then
    Result := 'C�DIGO DO MUNIC�PIO INV�LIDO'
  else if ADesc = 'NG' then
    Result := 'PLACA INV�LIDA'
  else if ADesc = 'NH' then
    Result := 'OP��O/PARCELA DE PAGAMENTO INV�LIDA'
  else if ADesc = 'NI' then
    Result := 'TRIBUTO J� FOI PAGO OU EST� VENCIDO'
  else if ADesc = 'NR' then
    Result := 'OPERA��O N�O REALIZADA'
  else if ADesc = 'PD' then
    Result := 'AQUISI��O CONFIRMADA (EQUIVALE A OCORR�NCIA 02 NO LAYOUT DE RISCO SACADO)'
  else if ADesc = 'RJ' then
    Result := 'REGISTRO REJEITADO'
  else if ADesc = 'RS' then
    Result := 'PAGAMENTO DISPON�VEL PARA ANTECIPA��O NO RISCO SACADO � MODALIDADE RISCO SACADO P�S AUTORIZADO'
  else if ADesc = 'SS' then
    Result := 'PAGAMENTO CANCELADO POR INSUFICI�NCIA DE SALDO/LIMITE DI�RIO DE PAGTO'
  else if ADesc = 'TA' then
    Result := 'LOTE N�O ACEITO - TOTAIS DO LOTE COM DIFEREN�A'
  else if ADesc = 'TI' then
    Result := 'TITULARIDADE INV�LIDA'
  else if ADesc = 'X1' then
    Result := 'FORMA INCOMPAT�VEL COM LAYOUT 010'
  else if ADesc = 'X2' then
    Result := 'N�MERO DA NOTA FISCAL INV�LIDO'
  else if ADesc = 'X3' then
    Result := 'IDENTIFICADOR DE NF/CNPJ INV�LIDO'
  else if ADesc = 'X4' then
    Result := 'FORMA 32 INV�LIDA'
  else
    Result := 'RETORNO N�O IDENTIFICADO'
end;

function DescricaoRetornoSantander(const ADesc: string): string;
begin
  if ADesc = '00' then
    Result := 'Cr�dito ou D�bito Efetivado'
  else if ADesc = '01' then
    Result := 'Insufici�ncia de Fundos - D�bito N�o Efetuado'
  else if ADesc = '02' then
    Result := 'Cr�dito ou D�bito Cancelado pelo Pagador/Credor'
  else if ADesc = '03' then
    Result := 'D�bito Autorizado pela Ag�ncia - Efetuado'
  else if ADesc = 'AA' then
    Result := 'Controle Inv�lido'
  else if ADesc = 'AB' then
    Result := 'Tipo de Opera��o Inv�lido'
  else if ADesc = 'AC' then
    Result := 'Tipo de Servi�o Inv�lido'
  else if ADesc = 'AD' then
    Result := 'Forma de Lan�amento Inv�lida'
  else if ADesc = 'AE' then
    Result := 'Tipo/N�mero de Inscri��o Inv�lido (gerado na cr�tica ou para informar rejei��o)'
  else if ADesc = 'AF' then
    Result := 'C�digo de Conv�nio Inv�lido'
  else if ADesc = 'AG' then
    Result := 'Ag�ncia/Conta Corrente/DV Inv�lido'
  else if ADesc = 'AH' then
    Result := 'N�mero Seq�encial do Registro no Lote Inv�lido'
  else if ADesc = 'AI' then
    Result := 'C�digo de Segmento de Detalhe Inv�lido'
  else if ADesc = 'AJ' then
    Result := 'Tipo de Movimento Inv�lido'
  else if ADesc = 'AK' then
    Result := 'C�digo da C�mara de Compensa��o do Banco do Favorecido/Deposit�rio Inv�lido'
  else if ADesc = 'AL' then
    Result := 'C�digo do Banco do Favorecido, Institui��o de Pagamento ou Deposit�rio Inv�lido'
  else if ADesc = 'AM' then
    Result := 'Ag�ncia Mantenedora da Conta Corrente do Favorecido Inv�lida'
  else if ADesc = 'AN' then
    Result := 'Conta Corrente/DV /Conta de Pagamento do Favorecido Inv�lido'
  else if ADesc = 'AO' then
    Result := 'Nome do Favorecido n�o Informado'
  else if ADesc = 'AP' then
    Result := 'Data Lan�amento Inv�lida/Vencimento Inv�lido/Data de Pagamento n�o permitda.'
  else if ADesc = 'AQ' then
    Result := 'Tipo/Quantidade da Moeda Inv�lido'
  else if ADesc = 'AR' then
    Result := 'Valor do Lan�amento Inv�lido/Divergente'
  else if ADesc = 'AS' then
    Result := 'Aviso ao Favorecido - Identifica��o Inv�lida'
  else if ADesc = 'AT' then
    Result := 'Tipo/N�mero de Inscri��o do Favorecido/Contribuinte Inv�lido'
  else if ADesc = 'AU' then
    Result := 'Logradouro do Favorecido n�o Informado'
  else if ADesc = 'AV' then
    Result := 'N�mero do Local do Favorecido n�o Informado'
  else if ADesc = 'AW' then
    Result := 'Cidade do Favorecido n�o Informada'
  else if ADesc = 'AX' then
    Result := 'CEP/Complemento do Favorecido Inv�lido'
  else if ADesc = 'AY' then
    Result := 'Sigla do Estado do Favorecido Inv�lido'
  else if ADesc = 'AZ' then
    Result := 'C�digo/Nome do Banco Deposit�rio Inv�lido'
  else if ADesc = 'BA' then
    Result := 'C�digo/Nome da Ag�ncia Deposit�rio n�o Informado'
  else if ADesc = 'BB' then
    Result := 'N�mero do Documento Inv�lido(Seu N�mero)'
  else if ADesc = 'BC' then
    Result := 'Nosso N�mero Invalido'
  else if ADesc = 'BD' then
    Result := 'Inclus�o Efetuada com Sucesso'
  else if ADesc = 'BE' then
    Result := 'Altera��o Efetuada com Sucesso'
  else if ADesc = 'BF' then
    Result := 'Exclus�o Efetuada com Sucesso'
  else if ADesc = 'BG' then
    Result := 'Ag�ncia/Conta Impedida Legalmente'
  else if ADesc = 'B1' then
    Result := 'Bloqueado Pendente de Autoriza��o'
  else if ADesc = 'B3' then
    Result := 'Bloqueado pelo cliente'
  else if ADesc = 'B4' then
    Result := 'Bloqueado pela captura de titulo da cobran�a'
  else if ADesc = 'B8' then
    Result := 'Bloqueado pela Valida��o de Tributos'
  else if ADesc = 'CA' then
    Result := 'C�digo de barras - C�digo do Banco Inv�lido'
  else if ADesc = 'CB' then
    Result := 'C�digo de barras - C�digo da Moeda Inv�lido'
  else if ADesc = 'CC' then
    Result := 'C�digo de barras - D�gito Verificador Geral Inv�lido'
  else if ADesc = 'CD' then
    Result := 'C�digo de barras - Valor do T�tulo Inv�lido'
  else if ADesc = 'CE' then
    Result := 'C�digo de barras - Campo Livre Inv�lido'
  else if ADesc = 'CF' then
    Result := 'Valor do Documento/Principal/menor que o minimo Inv�lido'
  else if ADesc = 'CH' then
    Result := 'Valor do Desconto Inv�lido'
  else if ADesc = 'CI' then
    Result := 'Valor de Mora Inv�lido'
  else if ADesc = 'CJ' then
    Result := 'Valor da Multa Inv�lido'
  else if ADesc = 'CK' then
    Result := 'Valor do IR Inv�lido'
  else if ADesc = 'CL' then
    Result := 'Valor do ISS Inv�lido'
  else if ADesc = 'CG' then
    Result := 'Valor do Abatimento inv�lido'
  else if ADesc = 'CM' then
    Result := 'Valor do IOF Inv�lido'
  else if ADesc = 'CN' then
    Result := 'Valor de Outras Dedu��es Inv�lido'
  else if ADesc = 'CO' then
    Result := 'Valor de Outros Acr�scimos Inv�lido'
  else if ADesc = 'HA' then
    Result := 'Lote N�o Aceito'
  else if ADesc = 'HB' then
    Result := 'Inscri��o da Empresa Inv�lida para o Contrato'
  else if ADesc = 'HC' then
    Result := 'Conv�nio com a Empresa Inexistente/Inv�lido para o Contrato'
  else if ADesc = 'HD' then
    Result := 'Ag�ncia/Conta Corrente da Empresa Inexistente/Inv�lida para o Contrato'
  else if ADesc = 'HE' then
    Result := 'Tipo de Servi�o Inv�lido para o Contrato'
  else if ADesc = 'HF' then
    Result := 'Conta Corrente da Empresa com Saldo Insuficiente'
  else if ADesc = 'HG' then
    Result := 'Lote de Servi�o fora de Seq��ncia'
  else if ADesc = 'HH' then
    Result := 'Lote de Servi�o Inv�lido'
  else if ADesc = 'HI' then
    Result := 'Arquivo n�o aceito'
  else if ADesc = 'HJ' then
    Result := 'Tipo de Registro Inv�lido'
  else if ADesc = 'HL' then
    Result := 'Vers�o de Layout Inv�lida'
  else if ADesc = 'HU' then
    Result := 'Hora de Envio Inv�lida'
  else if ADesc = 'IA' then
    Result := 'Pagamento exclusivo em Cart�rio.'
  else if ADesc = 'IJ' then
    Result := 'Compet�ncia ou Per�odo de Referencia ou Numero da Parcela invalido'
  else if ADesc = 'IL' then
    Result := 'Codigo Pagamento / Receita n�o num�rico ou com zeros'
  else if ADesc = 'IM' then
    Result := 'Munic�pio Invalido'
  else if ADesc = 'IN' then
    Result := 'Numero Declara��o Invalido'
  else if ADesc = 'IO' then
    Result := 'Numero Etiqueta invalido'
  else if ADesc = 'IP' then
    Result := 'Numero Notifica��o invalido'
  else if ADesc = 'IQ' then
    Result := 'Inscri��o Estadual invalida'
  else if ADesc = 'IR' then
    Result := 'Divida Ativa Invalida'
  else if ADesc = 'IS' then
    Result := 'Valor Honor�rios ou Outros Acr�scimos invalido'
  else if ADesc = 'IT' then
    Result := 'Per�odo Apura��o invalido'
  else if ADesc = 'IU' then
    Result := 'Valor ou Percentual da Receita invalido'
  else if ADesc = 'IV' then
    Result := 'Numero Referencia invalida'
  else if ADesc = 'SC' then
    Result := 'Valida��o parcial'
  else if ADesc = 'TA' then
    Result := 'Lote n�o Aceito - Totais do Lote com Diferen�a'
  else if ADesc = 'XB' then
    Result := 'N�mero de Inscri��o do Contribuinte Inv�lido'
  else if ADesc = 'XC' then
    Result := 'C�digo do Pagamento ou Compet�ncia ou N�mero de Inscri��o Inv�lido'
  else if ADesc = 'XF' then
    Result := 'C�digo do Pagamento ou Compet�ncia n�o Num�rico ou igual � zeros'
  else if ADesc = 'YA' then
    Result := 'T�tulo n�o Encontrado'
  else if ADesc = 'YB' then
    Result := 'Identifica��o Registro Opcional Inv�lido'
  else if ADesc = 'YC' then
    Result := 'C�digo Padr�o Inv�lido'
  else if ADesc = 'YD' then
    Result := 'C�digo de Ocorr�ncia Inv�lido'
  else if ADesc = 'YE' then
    Result := 'Complemento de Ocorr�ncia Inv�lido'
  else if ADesc = 'YF' then
    Result := 'Alega��o j� Informada'
  else if ADesc = 'ZA' then
    Result := 'Transferencia Devolvida'
  else if ADesc = 'ZB' then
    Result := 'Transferencia mesma titularidade n�o permitida'
  else if ADesc = 'ZC' then
    Result := 'C�digo pagamento Tributo inv�lido'
  else if ADesc = 'ZD' then
    Result := 'Compet�ncia Inv�lida'
  else if ADesc = 'ZE' then
    Result := 'T�tulo Bloqueado na base'
  else if ADesc = 'ZF' then
    Result := 'Sistema em Conting�ncia � Titulo com valor maior que refer�ncia'
  else if ADesc = 'ZG' then
    Result := 'Sistema em Conting�ncia � T�tulo vencido'
  else if ADesc = 'ZH' then
    Result := 'Sistema em conting�ncia - T�tulo indexado'
  else if ADesc = 'ZI' then
    Result := 'Benefici�rio divergente'
  else if ADesc = 'ZJ' then
    Result := 'Limite de pagamentos parciais excedido'
  else if ADesc = 'ZK' then
    Result := 'T�tulo j� liquidado'
  else if ADesc = 'ZT' then
    Result := 'Valor outras entidades inv�lido'
  else if ADesc = 'ZU' then
    Result := 'Sistema Origem Inv�lido'
  else if ADesc = 'ZW' then
    Result := 'Banco Destino n�o recebe DOC'
  else if ADesc = 'ZX' then
    Result := 'Banco Destino inoperante para DOC'
  else if ADesc = 'ZY' then
    Result := 'C�digo do Hist�rico de Credito Invalido'
  else if ADesc = 'ZV' then
    Result := 'Autoriza��o iniciada no Internet Banking'
  else if ADesc = 'Z0' then
    Result := 'Conta com bloqueio'
  else if ADesc = 'Z1' then
    Result := 'Conta fechada. � necess�rio ativar a conta'
  else if ADesc = 'Z2' then
    Result := 'Conta com movimento controlado'
  else if ADesc = 'Z3' then
    Result := 'Conta cancelada'
  else if ADesc = 'Z4' then
    Result := 'Registro inconsistente (T�tulo)'
  else
    Result := 'RETORNO N�O IDENTIFICADO';
end;

function DescricaoRetornoBancoDoBrasil(const ADesc: string): string;
var
  vDesc: string;
  i: integer;
begin
  result := '';
  i := 0;
  repeat
    inc(i);
    vDesc := copy(ADesc + '   ', i * 2 - 1, 2);
    if VDesc = '00' then
      Result := Result + IfThen(i = 1, '', '/') + 'Este c�digo indica que o pagamento foi confirmado'
    else if VDesc = '01' then
      Result := Result + IfThen(i = 1, '', '/') + 'Insufici�ncia de Fundos - D�bito N�o Efetuado'
    else if VDesc = '02' then
      Result := Result + IfThen(i = 1, '', '/') + 'Cr�dito ou D�bito Cancelado pelo Pagador/Credor'
    else if VDesc = '03' then
      Result := Result + IfThen(i = 1, '', '/') + 'D�bito Autorizado pela Ag�ncia - Efetuado'
    else if VDesc = 'AA' then
      Result := Result + IfThen(i = 1, '', '/') + 'Controle Inv�lido'
    else if VDesc = 'AB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo de Opera��o Inv�lido'
    else if VDesc = 'AC' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo de Servi�o Inv�lido'
    else if VDesc = 'AD' then
      Result := Result + IfThen(i = 1, '', '/') + 'Forma de Lan�amento Inv�lida'
    else if VDesc = 'AE' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo/N�mero de Inscri��o Inv�lido'
    else if VDesc = 'AF' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Conv�nio Inv�lido'
    else if VDesc = 'AG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Ag�ncia/Conta Corrente/DV Inv�lido'
    else if VDesc = 'AH' then
      Result := Result + IfThen(i = 1, '', '/') + 'N� Seq�encial do Registro no Lote Inv�lido'
    else if VDesc = 'AI' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Segmento de Detalhe Inv�lido'
    else if VDesc = 'AJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo de Movimento Inv�lido'
    else if VDesc = 'AK' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo da C�mara de Compensa��o do Banco Favorecido/Deposit�rio Inv�lido'
    else if VDesc = 'AL' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo do Banco Favorecido ou Deposit�rio Inv�lido'
    else if VDesc = 'AM' then
      Result := Result + IfThen(i = 1, '', '/') + 'Ag�ncia Mantenedora da Conta Corrente do Favorecido Inv�lida'
    else if VDesc = 'AN' then
      Result := Result + IfThen(i = 1, '', '/') + 'Conta Corrente/DV do Favorecido Inv�lido'
    else if VDesc = 'AO' then
      Result := Result + IfThen(i = 1, '', '/') + 'Nome do Favorecido N�o Informado'
    else if VDesc = 'AP' then
      Result := Result + IfThen(i = 1, '', '/') + 'Data Lan�amento Inv�lido'
    else if VDesc = 'AQ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo/Quantidade da Moeda Inv�lido'
    else if VDesc = 'AR' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do Lan�amento Inv�lido'
    else if VDesc = 'AS' then
      Result := Result + IfThen(i = 1, '', '/') + 'Aviso ao Favorecido - Identifica��o Inv�lida'
    else if VDesc = 'AT' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo/N�mero de Inscri��o do Favorecido Inv�lido'
    else if VDesc = 'AU' then
      Result := Result + IfThen(i = 1, '', '/') + 'Logradouro do Favorecido N�o Informado'
    else if VDesc = 'AV' then
      Result := Result + IfThen(i = 1, '', '/') + 'N� do Local do Favorecido N�o Informado'
    else if VDesc = 'AW' then
      Result := Result + IfThen(i = 1, '', '/') + 'Cidade do Favorecido N�o Informada'
    else if VDesc = 'AX' then
      Result := Result + IfThen(i = 1, '', '/') + 'CEP/Complemento do Favorecido Inv�lido'
    else if VDesc = 'AY' then
      Result := Result + IfThen(i = 1, '', '/') + 'Sigla do Estado do Favorecido Inv�lida'
    else if VDesc = 'AZ' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo/Nome do Banco Deposit�rio Inv�lido'
    else if VDesc = 'BA' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo/Nome da Ag�ncia Deposit�ria N�o Informado'
    else if VDesc = 'BB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Seu N�mero Inv�lido'
    else if VDesc = 'BC' then
      Result := Result + IfThen(i = 1, '', '/') + 'Nosso N�mero Inv�lido'
    else if VDesc = 'BD' then
      Result := Result + IfThen(i = 1, '', '/') + 'Inclus�o Efetuada com Sucesso'
    else if VDesc = 'BE' then
      Result := Result + IfThen(i = 1, '', '/') + 'Altera��o Efetuada com Sucesso'
    else if VDesc = 'BF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Exclus�o Efetuada com Sucesso'
    else if VDesc = 'BG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Ag�ncia/Conta Impedida Legalmente'
    else if VDesc = 'BH' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empresa n�o pagou sal�rio'
    else if VDesc = 'BI' then
      Result := Result + IfThen(i = 1, '', '/') + 'Falecimento do mutu�rio'
    else if VDesc = 'BJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empresa n�o enviou remessa do mutu�rio'
    else if VDesc = 'BK' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empresa n�o enviou remessa no vencimento'
    else if VDesc = 'BL' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor da parcela inv�lida'
    else if VDesc = 'BM' then
      Result := Result + IfThen(i = 1, '', '/') + 'Identifica��o do contrato inv�lida'
    else if VDesc = 'BN' then
      Result := Result + IfThen(i = 1, '', '/') + 'Opera��o de Consigna��o Inclu�da com Sucesso'
    else if VDesc = 'BO' then
      Result := Result + IfThen(i = 1, '', '/') + 'Opera��o de Consigna��o Alterada com Sucesso'
    else if VDesc = 'BP' then
      Result := Result + IfThen(i = 1, '', '/') + 'Opera��o de Consigna��o Exclu�da com Sucesso'
    else if VDesc = 'BQ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Opera��o de Consigna��o Liquidada com Sucesso'
    else if VDesc = 'BR' then
      Result := Result + IfThen(i = 1, '', '/') + 'Reativa��o Efetuada com Sucesso'
    else if VDesc = 'BS' then
      Result := Result + IfThen(i = 1, '', '/') + 'Suspens�o Efetuada com Sucesso'
    else if VDesc = 'CA' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Barras - C�digo do Banco Inv�lido'
    else if VDesc = 'CB' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Barras - C�digo da Moeda Inv�lido'
    else if VDesc = 'CC' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Barras - D�gito Verificador Geral Inv�lido'
    else if VDesc = 'CD' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Barras - Valor do T�tulo Inv�lido'
    else if VDesc = 'CE' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Barras - Campo Livre Inv�lido'
    else if VDesc = 'CF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do Documento Inv�lido'
    else if VDesc = 'CG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do Abatimento Inv�lido'
    else if VDesc = 'CH' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do Desconto Inv�lido'
    else if VDesc = 'CI' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor de Mora Inv�lido'
    else if VDesc = 'CJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor da Multa Inv�lido'
    else if VDesc = 'CK' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do IR Inv�lido'
    else if VDesc = 'CL' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do ISS Inv�lido'
    else if VDesc = 'CM' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do IOF Inv�lido'
    else if VDesc = 'CN' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor de Outras Dedu��es Inv�lido'
    else if VDesc = 'CO' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor de Outros Acr�scimos Inv�lido'
    else if VDesc = 'CP' then
      Result := Result + IfThen(i = 1, '', '/') + 'Valor do INSS Inv�lido'
    else if VDesc = 'HA' then
      Result := Result + IfThen(i = 1, '', '/') + 'Lote N�o Aceito'
    else if VDesc = 'HB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Inscri��o da Empresa Inv�lida para o Contrato'
    else if VDesc = 'HC' then
      Result := Result + IfThen(i = 1, '', '/') + 'Conv�nio com a Empresa Inexistente/Inv�lido para o Contrato'
    else if VDesc = 'HD' then
      Result := Result + IfThen(i = 1, '', '/') + 'Ag�ncia/Conta Corrente da Empresa Inexistente/Inv�lido para o Contrato'
    else if VDesc = 'HE' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo de Servi�o Inv�lido para o Contrato'
    else if VDesc = 'HF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Conta Corrente da Empresa com Saldo Insuficiente'
    else if VDesc = 'HG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Lote de Servi�o Fora de Seq��ncia'
    else if VDesc = 'HH' then
      Result := Result + IfThen(i = 1, '', '/') + 'Lote de Servi�o Inv�lido'
    else if VDesc = 'HI' then
      Result := Result + IfThen(i = 1, '', '/') + 'Arquivo n�o aceito'
    else if VDesc = 'HJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo de Registro Inv�lido'
    else if VDesc = 'HK' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo Remessa / Retorno Inv�lido'
    else if VDesc = 'HL' then
      Result := Result + IfThen(i = 1, '', '/') + 'Vers�o de layout inv�lida'
    else if VDesc = 'HM' then
      Result := Result + IfThen(i = 1, '', '/') + 'Mutu�rio n�o identificado'
    else if VDesc = 'HN' then
      Result := Result + IfThen(i = 1, '', '/') + 'Tipo do beneficio n�o permite empr�stimo'
    else if VDesc = 'HO' then
      Result := Result + IfThen(i = 1, '', '/') + 'Beneficio cessado/suspenso'
    else if VDesc = 'HP' then
      Result := Result + IfThen(i = 1, '', '/') + 'Beneficio possui representante legal'
    else if VDesc = 'HQ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Beneficio � do tipo PA (Pens�o aliment�cia)'
    else if VDesc = 'HR' then
      Result := Result + IfThen(i = 1, '', '/') + 'Quantidade de contratos permitida excedida'
    else if VDesc = 'HS' then
      Result := Result + IfThen(i = 1, '', '/') + 'Beneficio n�o pertence ao Banco informado'
    else if VDesc = 'HT' then
      Result := Result + IfThen(i = 1, '', '/') + 'In�cio do desconto informado j� ultrapassado'
    else if VDesc = 'HU' then
      Result := Result + IfThen(i = 1, '', '/') + 'N�mero da parcela inv�lida'
    else if VDesc = 'HV' then
      Result := Result + IfThen(i = 1, '', '/') + 'Quantidade de parcela inv�lida'
    else if VDesc = 'HW' then
      Result := Result + IfThen(i = 1, '', '/') + 'Margem consign�vel excedida para o mutu�rio dentro do prazo do contrato'
    else if VDesc = 'HX' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo j� cadastrado'
    else if VDesc = 'HY' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo inexistente'
    else if VDesc = 'HZ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo j� encerrado'
    else if VDesc = 'H1' then
      Result := Result + IfThen(i = 1, '', '/') + 'Arquivo sem trailer'
    else if VDesc = 'H2' then
      Result := Result + IfThen(i = 1, '', '/') + 'Mutu�rio sem cr�dito na compet�ncia'
    else if VDesc = 'H3' then
      Result := Result + IfThen(i = 1, '', '/') + 'N�o descontado � outros motivos'
    else if VDesc = 'H4' then
      Result := Result + IfThen(i = 1, '', '/') + 'Retorno de Cr�dito n�o pago'
    else if VDesc = 'H5' then
      Result := Result + IfThen(i = 1, '', '/') + 'Cancelamento de empr�stimo retroativo'
    else if VDesc = 'H6' then
      Result := Result + IfThen(i = 1, '', '/') + 'Outros Motivos de Glosa'
    else if VDesc = 'H7' then
      Result := Result + IfThen(i = 1, '', '/') + 'Margem consign�vel excedida para o mutu�rio acima do prazo do contrato'
    else if VDesc = 'H8' then
      Result := Result + IfThen(i = 1, '', '/') + 'Mutu�rio desligado do empregador'
    else if VDesc = 'H9' then
      Result := Result + IfThen(i = 1, '', '/') + 'Mutu�rio afastado por licen�a'
    else if VDesc = 'IA' then
      Result := Result + IfThen(i = 1, '', '/') + 'Primeiro nome do mutu�rio diferente do primeiro nome do movimento do censo ou diferente da base de Titular do Benef�cio'
    else if VDesc = 'IB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio suspenso/cessado pela APS ou Sisobi'
    else if VDesc = 'IC' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio suspenso por depend�ncia de c�lculo'
    else if VDesc = 'ID' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio suspenso/cessado pela inspetoria/auditoria'
    else if VDesc = 'IE' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio bloqueado para empr�stimo pelo benefici�rio'
    else if VDesc = 'IF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio bloqueado para empr�stimo por TBM'
    else if VDesc = 'IG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio est� em fase de concess�o de PA ou desdobramento'
    else if VDesc = 'IH' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio cessado por �bito'
    else if VDesc = 'II' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio cessado por fraude'
    else if VDesc = 'IJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio cessado por concess�o de outro benef�cio'
    else if VDesc = 'IK' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benef�cio cessado: estatut�rio transferido para �rg�o de origem'
    else if VDesc = 'IL' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo suspenso pela APS'
    else if VDesc = 'IM' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo cancelado pelo banco'
    else if VDesc = 'IN' then
      Result := Result + IfThen(i = 1, '', '/') + 'Cr�dito transformado em PAB'
    else if VDesc = 'IO' then
      Result := Result + IfThen(i = 1, '', '/') + 'T�rmino da consigna��o foi alterado'
    else if VDesc = 'IP' then
      Result := Result + IfThen(i = 1, '', '/') + 'Fim do empr�stimo ocorreu durante per�odo de suspens�o ou concess�o'
    else if VDesc = 'IQ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Empr�stimo suspenso pelo banco'
    else if VDesc = 'IR' then
      Result := Result + IfThen(i = 1, '', '/') + 'N�o averba��o de contrato � quantidade de parcelas/compet�ncias informadas ultrapassou a data limite da extin��o de cota do dependente titular de benef�cios'
    else if VDesc = 'TA' then
      Result := Result + IfThen(i = 1, '', '/') + 'Lote N�o Aceito - Totais do Lote com Diferen�a'
    else if VDesc = 'YA' then
      Result := Result + IfThen(i = 1, '', '/') + 'T�tulo N�o Encontrado'
    else if VDesc = 'YB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Identificador Registro Opcional Inv�lido'
    else if VDesc = 'YC' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo Padr�o Inv�lido'
    else if VDesc = 'YD' then
      Result := Result + IfThen(i = 1, '', '/') + 'C�digo de Ocorr�ncia Inv�lido'
    else if VDesc = 'YE' then
      Result := Result + IfThen(i = 1, '', '/') + 'Complemento de Ocorr�ncia Inv�lido'
    else if VDesc = 'YF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Alega��o j� Informada'
    else if VDesc = 'ZA' then
      Result := Result + IfThen(i = 1, '', '/') + 'Ag�ncia / Conta do Favorecido Substitu�da Observa��o: As ocorr�ncias iniciadas ''ZA'' tem car�ter informativo para o cliente'
    else if VDesc = 'ZB' then
      Result := Result + IfThen(i = 1, '', '/') + 'Diverg�ncia entre o primeiro e �ltimo nome do benefici�rio versus primeiro e �ltimo nome na Receita Federal'
    else if VDesc = 'ZC' then
      Result := Result + IfThen(i = 1, '', '/') + 'Confirma��o de Antecipa��o de Valor'
    else if VDesc = 'ZD' then
      Result := Result + IfThen(i = 1, '', '/') + 'Antecipa��o parcial de valor'
    else if VDesc = 'ZE' then
      Result := Result + IfThen(i = 1, '', '/') + 'T�tulo bloqueado na base'
    else if VDesc = 'ZF' then
      Result := Result + IfThen(i = 1, '', '/') + 'Sistema em conting�ncia � t�tulo valor maior que refer�ncia'
    else if VDesc = 'ZG' then
      Result := Result + IfThen(i = 1, '', '/') + 'Sistema em conting�ncia � t�tulo vencido'
    else if VDesc = 'ZH' then
      Result := Result + IfThen(i = 1, '', '/') + 'Sistema em conting�ncia � t�tulo indexado'
    else if VDesc = 'ZI' then
      Result := Result + IfThen(i = 1, '', '/') + 'Benefici�rio divergente'
    else if VDesc = 'ZJ' then
      Result := Result + IfThen(i = 1, '', '/') + 'Limite de pagamentos parciais excedido'
    else if VDesc = 'ZK' then
      Result := Result + IfThen(i = 1, '', '/') + 'Boleto j� liquidado'
    else if Length(trim(VDesc)) <> 0 then
      Result := Result + IfThen(i = 1, '', '/') + 'RETORNO N�O IDENTIFICADO';
  until Length(trim(VDesc)) = 0;
end;

end.

