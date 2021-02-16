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
                               '000', '000', '000', '000',
                               '000', '000', '409'],
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
                               'Safra Bradesco', 'Banco Cecred', 'Unibanco'],
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
                            '000', '000', '000', '000', '000', '000', '409'],
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

end.

