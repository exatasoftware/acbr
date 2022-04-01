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

  TBanco = (pagNenhum,
     pagBancodoBrasil, pagBancoDigito, pagNuBank,
     pagPagSeguro, pagMercadoPago, pagBradesco, pagSofisaDireto, pagInter, pagItau,
     pagCaixaEconomica, pagSantander, pagOriginal, pagBanCooB, pagVotorantim,
     pagBanrisul, pagSafra, pagBRB, pagUnicredCooperativa, pagBancoRibeiraoPreto,
     pagCetelem, pagSemear, pagPlannerCorretora, pagB3, pagRabobank, pagSicredi,
     pagBNPParibasBrasil, pagUnicredCentralRS, pagKirtonBank, pagPortoCred,
     pagKebHanaBrasil, pagXPInvestimentos, pagBancoXP, pagSuperPagamentos,
     pagGerencianetPagamentos, pagUniprimeNortedoParana, pagCapitalMarkets,
     pagMorganStanley, pagUBSBrasilCCTVM, pagTrevisoCC, pagHipercardBancoMultiplo,
     pagJSafra, pagUniprimeCentral, pagAlfa, pagABNAmro, pagCargill, pagServiCoop,
     pagBradescard, pagNovaFutura, pagGoldmanSachsBrasil, pagCCCNoroesteBrasileiro,
     pagCCMDespTransSCeRS, pagInbursa, pagBancodaAmazonia, pagConfidenceCC,
     pagBancodoEstadodoPara, pagCasaCredito, pagAlbatrossCCV, pagBancoCECRED,
     pagCooperativaCreditoEspiritoSanto, pagBancoBBI, pagBradescoFinanciamentos,
     pagBancoDoNordeste, pagCCBBrasil, pagHSFinanceira, pagLeccaCFI,
     pagKDBBrasil, pagTopazio, pagCCROuro, pagPolocred, pagCCRSaoMigueldoOeste,
     pagICAPBrasil, pagSocred, pagNatixisBrasil, pagCaruana,
     pagCodepeCVC, pagOriginalAgronegocio, pagBancoBrasileiroNegocios,
     pagStandardChartered, pagCresol, pagAgibank, pagBancodaChinaBrasil,
     pagGetMoneyCC, pagBANDEPE, pagConfidenceCambio, pagFinaxis, pagSenff,
     pagMultiMoneyCC, pagBRK, pagBancodoEstadodeSergipe, pagBEXSBancodeCambio,
     pagBRPartners, pagBPP, pagBRLTrustDTVM, pagWesternUniondoBrasil,
     pagParanaBanco, pagBariguiCH, pagBOCOMBBM, pagCapital, pagWooriBank, pagFacta,
     pagStone, pagBrokerBrasilCC, pagMercantil, pagItauBBA, pagTriangulo,
     pagSenso, pagICBCBrasil, pagVipsCC, pagUBSBrasil, pagMSBank, pagMarmetal,
     pagVortx, pagCommerzbank, pagAvista, pagGuittaCC, pagCCRPrimaveraDoLeste,
     pagDacasaFinanceira, pagGenial, pagIBCCTVM, pagBANESTES, pagABCBrasil,
     pagScotiabankBrasil, pagBTGPactual, pagModal, pagClassico, pagGuanabara,
     pagIndustrialdoBrasil, pagCreditSuisse, pagFairCC, pagLaNacionArgentina,
     pagCitibankNA, pagCedula, pagBradescoBERJ, pagJPMorgan, pagCaixaGeralBrasil,
     pagCitibank, pagRodobens, pagFator, pagBNDES, pagAtivaInvestimentos,
     pagBGCLiquidez, pagAlvorada, pagItauConsignado, pagMaxima,
     pagHaitongBi, pagOliveiraTrust, pagBNYMellonBanco, pagPernambucabasFinanc,
     pagLaProvinciaBuenosAires, pagBrasilPlural, pagJPMorganChaseBank, pagAndbank,
     pagINGBankNV, pagBCV, pagLevycamCCV, pagRepOrientalUruguay, pagBEXSCC,
     pagHSBC, pagArbi, pagIntesaSanPaolo, pagTricury, pagInterCap, pagFibra,
     pagLusoBrasileiro, pagPAN, pagBradescoCartoes, pagItauBank, pagMUFGBrasil,
     pagSumitomoMitsui, pagOmniBanco, pagItauUnibancoHolding, pagIndusval,
     pagCrefisa, pagMizuhodoBrasil, pagInvestcredUni, pagBMG, pagFicsa,
     pagSagiturCC, pagSocieteGeneraleBrasil, pagMagliano, pagTullettPrebon,
     pagCreditSuisseHedgingGriffo, pagPaulista, pagBankofAmericaMerrillLynch,
     pagCCRRegMogiana, pagPine, pagEasynvest, pagDaycoval, pagCarol,
     pagRenascenca, pagDeutscheBank, pagCifra, pagGuide, pagRendimento, pagBS2,
     pagBS2DistribuidoraTitulos, pagOleBonsucessoConsignado, pagLastroRDV,
     pagFrenteCC, pagBTCC, pagNovoBancoContinental, pagCreditAgricoleBrasil,
     pagBancoSistema, pagCredialianca, pagVR, pagBancoOurinvest, pagCredicoamo,
     pagRBCapitalInvestimentos, pagJohnDeere, pagAdvanced, pagC6, pagDigimais);
     {
  pagABCBrasil, pagAgibank, pagAlfa, pagAndbank, pagB3, pagBancodaAmazonia, pagBancodaChinaBrasil,
    pagBancodoBrasil, pagBancodoEstadodeSergipe, pagBancodoEstadodoPara, pagBanrisul, pagBancoDoNordeste, pagBANDEPE,
    pagBANESTES, pagBankofAmericaMerrillLynch, pagBCV, pagBEXSBancodeCambio, pagBMG, pagBNPParibasBrasil, pagBNYMellonBanco,
    pagBOCOMBBM, pagBradescard, pagBradesco, pagBRB, pagBS2, pagBTGPactual, pagC6Consignado, pagCaixaEconomica,
    pagCaixaGeralBrasil, pagCargill, pagCetelem, pagChinaConstructionBank, pagCifra, pagCitibankNA, pagCitibank,
    pagCreditAgricoleBrasil, pagCreditSuisse, pagDaycoval, pagDeutscheBank, pagDigimais, pagFibra, pagFinaxis, pagGenial,
    pagGuanabara, pagHipercardBancoMultiplo, pagHSBC, pagInbursa, pagIndustrialdoBrasil, pagINGBankNV, pagInter,
    pagInvestcredUni, pagItau, pagJPMorgan, pagJSafra, pagJohnDeere, pagJPMorganChaseBank, pagNationalAssociation,
    pagKirtonBank, pagLetsbank, pagLusoBrasileiro, pagMaster, pagMercantil, pagMizuhodoBrasil, pagModal, pagMSBank,
    pagMUFGBrasil, pagOleBonsucessoConsignado, pagOriginal, pagPAN, pagParanaBanco, pagPaulista, pagPine, pagRabobank,
    pagRendimento, pagRodobens, pagSafra, pagSantander, pagScotiabankBrasil, pagSemear, pagSenff, pagSicoob, pagSicredi,
    pagSocieteGeneraleBrasil, pagSorocred, pagStateStreetBrasil, pagSumitomoMitsui, pagTopazio, pagTravelex, pagTriangulo,
    pagUBSBrasil, pagVoiter, pagVotorantim, pagVR, pagWesternUniondoBrasil, pagXP, pagBancoCECRED);
    }
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
                      flTributoGNRe, flPIXTransferencia, flPIXQRCode, flNenhum);

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

  TTipoChavePix = (tcpNenhum, tcpTelefone, tcpEmail, tcpCPFCNPJ, tcpAleatoria);


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
function StrToIndTributo(var ok: boolean; const s:string): TIndTributo;

function TpOperacaoToStr(const t: TTipoOperacao): String;
function StrToTpOperacao(var ok: boolean; const s:string): TTipoOperacao;

function TpMovimentoPagtoToStr(const t: TTipoMovimentoPagto): String;
function StrToTpMovimentoPagto(var ok:boolean; const s:string): TTipoMovimentoPagto;

function CodigoPagamentoGpsToStr(const t: TCodigoPagamentoGps): String;
function StrToCodigoPagamentoGps(var ok: boolean; const s: string): TCodigoPagamentoGps;

function TipoChavePixToStr(const t: TTipoChavePIX): String;
function StrToTipoChavePIX(var ok:boolean; const s: string): TTipoChavePIX;

function TpTributoToStr(const t: TTipoTributo): String;

function LinhaDigitavelParaBarras(const linha:string):string;

function DescricaoRetornoItau(ADesc: string): string;

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

function BancoToStr(const t: TBanco): String;
begin
  result := EnumeradoToStr(t,
    ['000',
     '001', '335', '260', '290', '323', '237', '637', '077', '341', '104',
     '033', '212', '756', '655', '041', '422', '070', '136', '741', '739',
     '743', '100', '096', '747', '748', '752', '091', '399', '108', '757',
     '102', '348', '340', '364', '084', '180', '066', '015', '143', '062',
     '074', '099', '025', '075', '040', '190', '063', '191', '064', '097',
     '016', '012', '003', '060', '037', '159', '172', '085', '114', '036',
     '394', '004', '320', '189', '105', '076', '082', '286', '093', '273',
     '157', '183', '014', '130', '127', '079', '081', '118', '133', '121',
     '083', '138', '024', '095', '094', '276', '137', '092', '047', '144',
     '126', '301', '173', '119', '254', '268', '107', '412', '124', '149',
     '197', '142', '389', '184', '634', '545', '132', '298', '129', '128',
     '194', '310', '163', '280', '146', '279', '182', '278', '271', '021',
     '246', '751', '208', '746', '241', '612', '604', '505', '196', '300',
     '477', '266', '122', '376', '473', '745', '120', '265', '007', '188',
     '134', '641', '029', '243', '078', '111', '017', '174', '495', '125',
     '488', '065', '492', '250', '145', '494', '253', '269', '213', '139',
     '018', '630', '224', '600', '623', '204', '479', '456', '464', '613',
     '652', '653', '069', '370', '249', '318', '626', '270', '366', '113',
     '131', '011', '611', '755', '089', '643', '140', '707', '288', '101',
     '487', '233', '117', '633', '218', '292', '169', '293', '285', '080',
     '753', '222', '754', '098', '610', '712', '010', '283', '217', '117',
     '336', '654'],
    [pagNenhum,
     pagBancodoBrasil, pagBancoDigito, pagNuBank,
     pagPagSeguro, pagMercadoPago, pagBradesco, pagSofisaDireto, pagInter, pagItau,
     pagCaixaEconomica, pagSantander, pagOriginal, pagBanCooB, pagVotorantim,
     pagBanrisul, pagSafra, pagBRB, pagUnicredCooperativa, pagBancoRibeiraoPreto,
     pagCetelem, pagSemear, pagPlannerCorretora, pagB3, pagRabobank, pagSicredi,
     pagBNPParibasBrasil, pagUnicredCentralRS, pagKirtonBank, pagPortoCred,
     pagKebHanaBrasil, pagXPInvestimentos, pagBancoXP, pagSuperPagamentos,
     pagGerencianetPagamentos, pagUniprimeNortedoParana, pagCapitalMarkets,
     pagMorganStanley, pagUBSBrasilCCTVM, pagTrevisoCC, pagHipercardBancoMultiplo,
     pagJSafra, pagUniprimeCentral, pagAlfa, pagABNAmro, pagCargill, pagServiCoop,
     pagBradescard, pagNovaFutura, pagGoldmanSachsBrasil, pagCCCNoroesteBrasileiro,
     pagCCMDespTransSCeRS, pagInbursa, pagBancodaAmazonia, pagConfidenceCC,
     pagBancodoEstadodoPara, pagCasaCredito, pagAlbatrossCCV, pagBancoCECRED,
     pagCooperativaCreditoEspiritoSanto, pagBancoBBI, pagBradescoFinanciamentos,
     pagBancoDoNordeste, pagCCBBrasil, pagHSFinanceira, pagLeccaCFI,
     pagKDBBrasil, pagTopazio, pagCCROuro, pagPolocred, pagCCRSaoMigueldoOeste,
     pagICAPBrasil, pagSocred, pagNatixisBrasil, pagCaruana,
     pagCodepeCVC, pagOriginalAgronegocio, pagBancoBrasileiroNegocios,
     pagStandardChartered, pagCresol, pagAgibank, pagBancodaChinaBrasil,
     pagGetMoneyCC, pagBANDEPE, pagConfidenceCambio, pagFinaxis, pagSenff,
     pagMultiMoneyCC, pagBRK, pagBancodoEstadodeSergipe, pagBEXSBancodeCambio,
     pagBRPartners, pagBPP, pagBRLTrustDTVM, pagWesternUniondoBrasil,
     pagParanaBanco, pagBariguiCH, pagBOCOMBBM, pagCapital, pagWooriBank, pagFacta,
     pagStone, pagBrokerBrasilCC, pagMercantil, pagItauBBA, pagTriangulo,
     pagSenso, pagICBCBrasil, pagVipsCC, pagUBSBrasil, pagMSBank, pagMarmetal,
     pagVortx, pagCommerzbank, pagAvista, pagGuittaCC, pagCCRPrimaveraDoLeste,
     pagDacasaFinanceira, pagGenial, pagIBCCTVM, pagBANESTES, pagABCBrasil,
     pagScotiabankBrasil, pagBTGPactual, pagModal, pagClassico, pagGuanabara,
     pagIndustrialdoBrasil, pagCreditSuisse, pagFairCC, pagLaNacionArgentina,
     pagCitibankNA, pagCedula, pagBradescoBERJ, pagJPMorgan, pagCaixaGeralBrasil,
     pagCitibank, pagRodobens, pagFator, pagBNDES, pagAtivaInvestimentos,
     pagBGCLiquidez, pagAlvorada, pagItauConsignado, pagMaxima,
     pagHaitongBi, pagOliveiraTrust, pagBNYMellonBanco, pagPernambucabasFinanc,
     pagLaProvinciaBuenosAires, pagBrasilPlural, pagJPMorganChaseBank, pagAndbank,
     pagINGBankNV, pagBCV, pagLevycamCCV, pagRepOrientalUruguay, pagBEXSCC,
     pagHSBC, pagArbi, pagIntesaSanPaolo, pagTricury, pagInterCap, pagFibra,
     pagLusoBrasileiro, pagPAN, pagBradescoCartoes, pagItauBank, pagMUFGBrasil,
     pagSumitomoMitsui, pagOmniBanco, pagItauUnibancoHolding, pagIndusval,
     pagCrefisa, pagMizuhodoBrasil, pagInvestcredUni, pagBMG, pagFicsa,
     pagSagiturCC, pagSocieteGeneraleBrasil, pagMagliano, pagTullettPrebon,
     pagCreditSuisseHedgingGriffo, pagPaulista, pagBankofAmericaMerrillLynch,
     pagCCRRegMogiana, pagPine, pagEasynvest, pagDaycoval, pagCarol,
     pagRenascenca, pagDeutscheBank, pagCifra, pagGuide, pagRendimento, pagBS2,
     pagBS2DistribuidoraTitulos, pagOleBonsucessoConsignado, pagLastroRDV,
     pagFrenteCC, pagBTCC, pagNovoBancoContinental, pagCreditAgricoleBrasil,
     pagBancoSistema, pagCredialianca, pagVR, pagBancoOurinvest, pagCredicoamo,
     pagRBCapitalInvestimentos, pagJohnDeere, pagAdvanced, pagC6, pagDigimais]);
end;

function BancoToDesc(const t: TBanco): String;
begin
  result := EnumeradoToStr(t,
    ['Nenhum',
     'BANCO DO BRASIL S.A', 'Banco Digito S.A', 'NU PAGAMENTOS S.A',
     'Pagseguro Internet S.A', 'Mercado Pago', 'BANCO SOFISA S.A', 'BANCO INTER S.A',
     'ITAU UNIBANCO S.A', 'CAIXA ECONOMICA FEDERAL', 'BANCO SANTANDER BRASIL S.A',
     'BANCO ORIGINAL S.A', 'BANCOOB', 'BANCO VOTORANTIM S.A', 'BANRISUL',
     'BRADESCO S.A', 'BANCO SAFRA S.A', 'BANCO DE BRASILIA',
     'UNICRED COOPERATIVA', 'BANCO RIBEIRAO PRETO', 'BANCO CETELEM S.A',
     'BANCO SEMEAR S.A', 'PLANNER CORRETORA DE VALORES S.A', 'BANCO B3 S.A',
     'RABOBANK INTERNACIONAL DO BRASIL S.A', 'SICREDI S.A', 'BNP PARIBAS BRASIL S.A',
     'UNICRED CENTRAL RS', 'KIRTON BANK', 'PORTOCRED S.A',
     'BANCO KEB HANA DO BRASIL S.A', 'XP INVESTIMENTOS S.A', 'BANCO XP S/A',
     'SUPER PAGAMENTOS S/A', 'GERENCIANET PAGAMENTOS DO BRASIL',
     'UNIPRIME NORTE DO PARANA', 'CM CAPITAL MARKETS CCTVM LTDA',
     'BANCO MORGAN STANLEY S.A', 'UBS BRASIL CCTVM S.A', 'TREVISO CC S.A',
     'HIPERCARD BM S.A', 'BCO. J.SAFRA S.A', 'UNIPRIME CENTRAL CCC LTDA',
     'BANCO ALFA S.A.', 'BCO ABN AMRO S.A', 'BANCO CARGILL S.A', 'SERVICOOP',
     'BANCO BRADESCARD', 'NOVA FUTURA CTVM LTDA', 'GOLDMAN SACHS DO BRASIL BM S.A',
     'CCC NOROESTE BRASILEIRO LTDA', 'CCM DESP TRANS SC E RS', 'BANCO INBURSA',
     'BANCO DA AMAZONIA S.A', 'CONFIDENCE CC S.A', 'BANCO DO ESTADO DO PARA S.A',
     'CASA CREDITO S.A', 'ALBATROSS CCV S.A', 'COOP CENTRAL AILOS',
     'CENTRAL COOPERATIVA DE CREDITO NO ESTADO DO ESPIRITO SANTO',
     'BANCO BBI S.A', 'BANCO BRADESCO FINANCIAMENTOS S.A',
     'BANCO DO NORDESTE DO BRASIL S.A.', 'BANCO CCB BRASIL S.A', 'HS FINANCEIRA',
     'LECCA CFI S.A', 'BANCO KDB BRASIL S.A.', 'BANCO TOPAZIO S.A', 'CCR DE OURO',
     'POLOCRED SCMEPP LTDA', 'CCR DE SAO MIGUEL DO OESTE',
     'ICAP DO BRASIL CTVM LTDA', 'SOCRED S.A', 'NATIXIS BRASIL S.A', 'CARUANA SCFI',
     'CODEPE CVC S.A', 'BANCO ORIGINAL DO AGRONEGOCIO S.A',
     'BBN BANCO BRASILEIRO DE NEGOCIOS S.A', 'STANDARD CHARTERED BI S.A',
     'CRESOL CONFEDERACAO', 'BANCO AGIBANK S.A', 'BANCO DA CHINA BRASIL S.A',
     'GET MONEY CC LTDA', 'BCO BANDEPE S.A', 'BANCO CONFIDENCE DE CAMBIO S.A',
     'BANCO FINAXIS', 'SENFF S.A', 'MULTIMONEY CC LTDA', 'BRK S.A',
     'BANCO BCO DO ESTADO DE SERGIPE S.A', 'BEXS BANCO DE CAMBIO S.A.',
     'BR PARTNERS BI', 'BPP INSTITUICAO DE PAGAMENTOS S.A', 'BRL TRUST DTVM SA',
     'BANCO WESTERN UNION', 'PARANA BANCO S.A', 'BARIGUI CH', 'BANCO BOCOM BBM S.A',
     'BANCO CAPITAL S.A', 'BANCO WOORI BANK DO BRASIL S.A', 'FACTA S.A. CFI',
     'STONE PAGAMENTOS S.A', 'BROKER BRASIL CC LTDA', 'BANCO MERCANTIL DO BRASIL S.A.',
     'BANCO ITAU BBA S.A', 'BANCO TRIANGULO S.A', 'SENSO CCVM S.A',
     'ICBC DO BRASIL BM S.A', 'VIPS CC LTDA', 'UBS BRASIL BI S.A',
     'MS BANK S.A BANCO DE CAMBIO', 'PARMETAL DTVM LTDA', 'VORTX DTVM LTDA',
     'COMMERZBANK BRASIL S.A', 'AVISTA S.A', 'GUITTA CC LTDA',
     'CCR DE PRIMAVERA DO LESTE', 'DACASA FINANCEIRA S/A',
     'GENIAL INVESTIMENTOS CVM S.A', 'IB CCTVM LTDA', 'BANCO BANESTES S.A',
     'BANCO ABC BRASIL S.A', 'SCOTIABANK BRASIL', 'BANCO BTG PACTUAL S.A',
     'BANCO MODAL S.A', 'BANCO CLASSICO S.A', 'BANCO GUANABARA S.A',
     'BANCO INDUSTRIAL DO BRASIL S.A', 'BANCO CREDIT SUISSE (BRL) S.A',
     'BANCO FAIR CC S.A', 'BANCO LA NACION ARGENTINA', 'CITIBANK N.A',
     'BANCO CEDULA S.A', 'BANCO BRADESCO BERJ S.A', 'BANCO J.P. MORGAN S.A',
     'BANCO CAIXA GERAL BRASIL S.A', 'BANCO CITIBANK S.A', 'BANCO RODOBENS S.A',
     'BANCO FATOR S.A', 'BNDES', 'ATIVA S.A INVESTIMENTOS', 'BGC LIQUIDEZ DTVM LTDA',
     'BANCO ALVORADA S.A', 'BANCO ITAU CONSIGNADO S.A', 'BANCO MAXIMA S.A',
     'HAITONG BI DO BRASIL S.A', 'BANCO OLIVEIRA TRUST DTVM S.A',
     'BNY MELLON BANCO S.A', 'PERNAMBUCANAS FINANC S.A',
     'LA PROVINCIA BUENOS AIRES BANCO', 'BRASIL PLURAL S.A BANCO',
     'JPMORGAN CHASE BANK', 'BANCO ANDBANK S.A', 'ING BANK N.V', 'BANCO BCV',
     'LEVYCAM CCV LTDA', 'BANCO REP ORIENTAL URUGUAY', 'BEXS CC S.A',
     'HSBC BANCO DE INVESTIMENTO', 'BCO ARBI S.A', 'INTESA SANPAOLO BRASIL S.A',
     'BANCO TRICURY S.A', 'BANCO INTERCAP S.A', 'BANCO FIBRA S.A',
     'BANCO LUSO BRASILEIRO S.A', 'BANCO PAN', 'BANCO BRADESCO CARTOES S.A',
     'BANCO ITAUBANK S.A', 'BANCO MUFG BRASIL S.A',
     'BANCO SUMITOMO MITSUI BRASIL S.A', 'OMNI BANCO S.A',
     'ITAU UNIBANCO HOLDING BM S.A', 'BANCO INDUSVAL S.A', 'BANCO CREFISA S.A',
     'BANCO MIZUHO S.A', 'BANCO INVESTCRED UNIBANCO S.A', 'BANCO BMG S.A',
     'BANCO FICSA S.A', 'SAGITUR CC LTDA', 'BANCO SOCIETE GENERALE BRASIL',
     'MAGLIANO S.A', 'TULLETT PREBON BRASIL CVC LTDA',
     'C.SUISSE HEDGING-GRIFFO CV S.A', 'BANCO PAULISTA',
     'BOFA MERRILL LYNCH BM S.A', 'CCR REG MOGIANA', 'BANCO PINE S.A',
     'EASYNVEST � TITULO CV S.A', 'BANCO DAYCOVAL S.A', 'CAROL DTVM LTDA',
     'RENASCENCA DTVM LTDA', 'DEUTSCHE BANK S.A', 'BANCO CIFRA', 'GUIDE',
     'BANCO RENDIMENTO S.A', 'BANCO BS2 S.A',
     'BS2 DISTRIBUIDORA DE TITULOS E INVESTIMENTOS',
     'BANCO OLE BONSUCESSO CONSIGNADO S.A', 'LASTRO RDV DTVM LTDA',
     'FRENTE CC LTDA', 'B&T CC LTDA', 'NOVO BANCO CONTINENTAL S.A',
     'BANCO CREDIT AGRICOLE BR S.A', 'BANCO SISTEMA', 'CREDIALIANCA CCR',
     'BANCO VR S.A', 'BANCO OURINVEST S.A', 'CREDICOAMO',
     'RB CAPITAL INVESTIMENTOS DTVM LTDA', 'BANCO JOHN DEERE S.A',
     'ADVANCED CC LTDA', 'BANCO C6 S.A', 'BANCO DIGIMAIS S.A'],
    [pagNenhum,
     pagBancodoBrasil, pagBancoDigito, pagNuBank, pagPagSeguro, pagMercadoPago,
     pagSofisaDireto, pagInter, pagItau, pagCaixaEconomica, pagSantander,
     pagOriginal, pagBanCooB, pagVotorantim, pagBanrisul, pagBradesco, pagSafra,
     pagBRB, pagUnicredCooperativa, pagBancoRibeiraoPreto, pagCetelem, pagSemear,
     pagPlannerCorretora, pagB3, pagRabobank, pagSicredi, pagBNPParibasBrasil,
     pagUnicredCentralRS, pagKirtonBank, pagPortoCred, pagKebHanaBrasil,
     pagXPInvestimentos, pagBancoXP, pagSuperPagamentos,
     pagGerencianetPagamentos, pagUniprimeNortedoParana, pagCapitalMarkets,
     pagMorganStanley, pagUBSBrasilCCTVM, pagTrevisoCC, pagHipercardBancoMultiplo,
     pagJSafra, pagUniprimeCentral, pagAlfa, pagABNAmro, pagCargill, pagServiCoop,
     pagBradescard, pagNovaFutura, pagGoldmanSachsBrasil, pagCCCNoroesteBrasileiro,
     pagCCMDespTransSCeRS, pagInbursa, pagBancodaAmazonia, pagConfidenceCC,
     pagBancodoEstadodoPara, pagCasaCredito, pagAlbatrossCCV, pagBancoCECRED,
     pagCooperativaCreditoEspiritoSanto, pagBancoBBI, pagBradescoFinanciamentos,
     pagBancoDoNordeste, pagCCBBrasil, pagHSFinanceira, pagLeccaCFI,
     pagKDBBrasil, pagTopazio, pagCCROuro, pagPolocred, pagCCRSaoMigueldoOeste,
     pagICAPBrasil, pagSocred, pagNatixisBrasil, pagCaruana,
     pagCodepeCVC, pagOriginalAgronegocio, pagBancoBrasileiroNegocios,
     pagStandardChartered, pagCresol, pagAgibank, pagBancodaChinaBrasil,
     pagGetMoneyCC, pagBANDEPE, pagConfidenceCambio, pagFinaxis, pagSenff,
     pagMultiMoneyCC, pagBRK, pagBancodoEstadodeSergipe, pagBEXSBancodeCambio,
     pagBRPartners, pagBPP, pagBRLTrustDTVM, pagWesternUniondoBrasil,
     pagParanaBanco, pagBariguiCH, pagBOCOMBBM, pagCapital, pagWooriBank, pagFacta,
     pagStone, pagBrokerBrasilCC, pagMercantil, pagItauBBA, pagTriangulo,
     pagSenso, pagICBCBrasil, pagVipsCC, pagUBSBrasil, pagMSBank, pagMarmetal,
     pagVortx, pagCommerzbank, pagAvista, pagGuittaCC, pagCCRPrimaveraDoLeste,
     pagDacasaFinanceira, pagGenial, pagIBCCTVM, pagBANESTES, pagABCBrasil,
     pagScotiabankBrasil, pagBTGPactual, pagModal, pagClassico, pagGuanabara,
     pagIndustrialdoBrasil, pagCreditSuisse, pagFairCC, pagLaNacionArgentina,
     pagCitibankNA, pagCedula, pagBradescoBERJ, pagJPMorgan, pagCaixaGeralBrasil,
     pagCitibank, pagRodobens, pagFator, pagBNDES, pagAtivaInvestimentos,
     pagBGCLiquidez, pagAlvorada, pagItauConsignado, pagMaxima,
     pagHaitongBi, pagOliveiraTrust, pagBNYMellonBanco, pagPernambucabasFinanc,
     pagLaProvinciaBuenosAires, pagBrasilPlural, pagJPMorganChaseBank, pagAndbank,
     pagINGBankNV, pagBCV, pagLevycamCCV, pagRepOrientalUruguay, pagBEXSCC,
     pagHSBC, pagArbi, pagIntesaSanPaolo, pagTricury, pagInterCap, pagFibra,
     pagLusoBrasileiro, pagPAN, pagBradescoCartoes, pagItauBank, pagMUFGBrasil,
     pagSumitomoMitsui, pagOmniBanco, pagItauUnibancoHolding, pagIndusval,
     pagCrefisa, pagMizuhodoBrasil, pagInvestcredUni, pagBMG, pagFicsa,
     pagSagiturCC, pagSocieteGeneraleBrasil, pagMagliano, pagTullettPrebon,
     pagCreditSuisseHedgingGriffo, pagPaulista, pagBankofAmericaMerrillLynch,
     pagCCRRegMogiana, pagPine, pagEasynvest, pagDaycoval, pagCarol,
     pagRenascenca, pagDeutscheBank, pagCifra, pagGuide, pagRendimento, pagBS2,
     pagBS2DistribuidoraTitulos, pagOleBonsucessoConsignado, pagLastroRDV,
     pagFrenteCC, pagBTCC, pagNovoBancoContinental, pagCreditAgricoleBrasil,
     pagBancoSistema, pagCredialianca, pagVR, pagBancoOurinvest, pagCredicoamo,
     pagRBCapitalInvestimentos, pagJohnDeere, pagAdvanced, pagC6, pagDigimais]);
end;

function StrToBanco(var ok: boolean; const s: String): TBanco;
begin
  Result := StrToEnumerado(ok, s,
    ['000',
     '001', '335', '260', '290', '323', '237', '637', '077', '341', '104',
     '033', '212', '756', '655', '041', '422', '070', '136', '741', '739',
     '743', '100', '096', '747', '748', '752', '091', '399', '108', '757',
     '102', '348', '340', '364', '084', '180', '066', '015', '143', '062',
     '074', '099', '025', '075', '040', '190', '063', '191', '064', '097',
     '016', '012', '003', '060', '037', '159', '172', '085', '114', '036',
     '394', '004', '320', '189', '105', '076', '082', '286', '093', '273',
     '157', '183', '014', '130', '127', '079', '081', '118', '133', '121',
     '083', '138', '024', '095', '094', '276', '137', '092', '047', '144',
     '126', '301', '173', '119', '254', '268', '107', '412', '124', '149',
     '197', '142', '389', '184', '634', '545', '132', '298', '129', '128',
     '194', '310', '163', '280', '146', '279', '182', '278', '271', '021',
     '246', '751', '208', '746', '241', '612', '604', '505', '196', '300',
     '477', '266', '122', '376', '473', '745', '120', '265', '007', '188',
     '134', '641', '029', '243', '078', '111', '017', '174', '495', '125',
     '488', '065', '492', '250', '145', '494', '253', '269', '213', '139',
     '018', '630', '224', '600', '623', '204', '479', '456', '464', '613',
     '652', '653', '069', '370', '249', '318', '626', '270', '366', '113',
     '131', '011', '611', '755', '089', '643', '140', '707', '288', '101',
     '487', '233', '117', '633', '218', '292', '169', '293', '285', '080',
     '753', '222', '754', '098', '610', '712', '010', '283', '217', '117',
     '336', '654'],
    [pagNenhum,
     pagBancodoBrasil, pagBancoDigito, pagNuBank,
     pagPagSeguro, pagMercadoPago, pagBradesco, pagSofisaDireto, pagInter, pagItau,
     pagCaixaEconomica, pagSantander, pagOriginal, pagBanCooB, pagVotorantim,
     pagBanrisul, pagSafra, pagBRB, pagUnicredCooperativa, pagBancoRibeiraoPreto,
     pagCetelem, pagSemear, pagPlannerCorretora, pagB3, pagRabobank, pagSicredi,
     pagBNPParibasBrasil, pagUnicredCentralRS, pagKirtonBank, pagPortoCred,
     pagKebHanaBrasil, pagXPInvestimentos, pagBancoXP, pagSuperPagamentos,
     pagGerencianetPagamentos, pagUniprimeNortedoParana, pagCapitalMarkets,
     pagMorganStanley, pagUBSBrasilCCTVM, pagTrevisoCC, pagHipercardBancoMultiplo,
     pagJSafra, pagUniprimeCentral, pagAlfa, pagABNAmro, pagCargill, pagServiCoop,
     pagBradescard, pagNovaFutura, pagGoldmanSachsBrasil, pagCCCNoroesteBrasileiro,
     pagCCMDespTransSCeRS, pagInbursa, pagBancodaAmazonia, pagConfidenceCC,
     pagBancodoEstadodoPara, pagCasaCredito, pagAlbatrossCCV, pagBancoCECRED,
     pagCooperativaCreditoEspiritoSanto, pagBancoBBI, pagBradescoFinanciamentos,
     pagBancoDoNordeste, pagCCBBrasil, pagHSFinanceira, pagLeccaCFI,
     pagKDBBrasil, pagTopazio, pagCCROuro, pagPolocred, pagCCRSaoMigueldoOeste,
     pagICAPBrasil, pagSocred, pagNatixisBrasil, pagCaruana,
     pagCodepeCVC, pagOriginalAgronegocio, pagBancoBrasileiroNegocios,
     pagStandardChartered, pagCresol, pagAgibank, pagBancodaChinaBrasil,
     pagGetMoneyCC, pagBANDEPE, pagConfidenceCambio, pagFinaxis, pagSenff,
     pagMultiMoneyCC, pagBRK, pagBancodoEstadodeSergipe, pagBEXSBancodeCambio,
     pagBRPartners, pagBPP, pagBRLTrustDTVM, pagWesternUniondoBrasil,
     pagParanaBanco, pagBariguiCH, pagBOCOMBBM, pagCapital, pagWooriBank, pagFacta,
     pagStone, pagBrokerBrasilCC, pagMercantil, pagItauBBA, pagTriangulo,
     pagSenso, pagICBCBrasil, pagVipsCC, pagUBSBrasil, pagMSBank, pagMarmetal,
     pagVortx, pagCommerzbank, pagAvista, pagGuittaCC, pagCCRPrimaveraDoLeste,
     pagDacasaFinanceira, pagGenial, pagIBCCTVM, pagBANESTES, pagABCBrasil,
     pagScotiabankBrasil, pagBTGPactual, pagModal, pagClassico, pagGuanabara,
     pagIndustrialdoBrasil, pagCreditSuisse, pagFairCC, pagLaNacionArgentina,
     pagCitibankNA, pagCedula, pagBradescoBERJ, pagJPMorgan, pagCaixaGeralBrasil,
     pagCitibank, pagRodobens, pagFator, pagBNDES, pagAtivaInvestimentos,
     pagBGCLiquidez, pagAlvorada, pagItauConsignado, pagMaxima,
     pagHaitongBi, pagOliveiraTrust, pagBNYMellonBanco, pagPernambucabasFinanc,
     pagLaProvinciaBuenosAires, pagBrasilPlural, pagJPMorganChaseBank, pagAndbank,
     pagINGBankNV, pagBCV, pagLevycamCCV, pagRepOrientalUruguay, pagBEXSCC,
     pagHSBC, pagArbi, pagIntesaSanPaolo, pagTricury, pagInterCap, pagFibra,
     pagLusoBrasileiro, pagPAN, pagBradescoCartoes, pagItauBank, pagMUFGBrasil,
     pagSumitomoMitsui, pagOmniBanco, pagItauUnibancoHolding, pagIndusval,
     pagCrefisa, pagMizuhodoBrasil, pagInvestcredUni, pagBMG, pagFicsa,
     pagSagiturCC, pagSocieteGeneraleBrasil, pagMagliano, pagTullettPrebon,
     pagCreditSuisseHedgingGriffo, pagPaulista, pagBankofAmericaMerrillLynch,
     pagCCRRegMogiana, pagPine, pagEasynvest, pagDaycoval, pagCarol,
     pagRenascenca, pagDeutscheBank, pagCifra, pagGuide, pagRendimento, pagBS2,
     pagBS2DistribuidoraTitulos, pagOleBonsucessoConsignado, pagLastroRDV,
     pagFrenteCC, pagBTCC, pagNovoBancoContinental, pagCreditAgricoleBrasil,
     pagBancoSistema, pagCredialianca, pagVR, pagBancoOurinvest, pagCredicoamo,
     pagRBCapitalInvestimentos, pagJohnDeere, pagAdvanced, pagC6, pagDigimais]);
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
                           '44', '50', '60', '70', '71', '72', '73', '91', '45', '47', '  '],
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
                          flTributoGNRe, flPIXTransferencia, flPIXQRCode, flNenhum]);
end;

function FmLancamentoToStr(const t: TFormaLancamento): String;
begin
 result := EnumeradoToStr(t,
                          ['01', '02', '03', '04', '05', '06', '07', '10', '11', '13',
                           '16', '17', '18', '19', '20', '21', '22', '23', '24', '25',
                           '26', '27', '30', '31', '32', '33', '35', '40', '41', '43',
                           '44', '50', '60', '70', '71', '72', '73', '91', '45', '47', '  '],
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
                          flTributoGNRe, flPIXTransferencia, flPIXQRCode, flNenhum]);
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

function StrToIndTributo(var ok: boolean; const s:string): TIndTributo;
begin
  result := StrToEnumerado(ok, s,
                           ['00', '16', '18', '17', '21', '25', '26', '27'],
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

function TipoChavePixToStr(const t: TTipoChavePIX): String;
begin
  result := EnumeradoToStr(t, ['  ', '01', '02', '03', '04'],
                  [tcpnenhum, tcpTelefone, tcpEmail, tcpCPFCNPJ, tcpAleatoria]);
end;

function StrToTipoChavePIX(var ok:boolean; const s: string): TTipoChavePIX;
begin
  result := StrToEnumerado(ok, s, ['', '  ', '01', '02', '03', '04'],
       [tcpNenhum, tcpNenhum, tcpTelefone, tcpEmail, tcpCPFCNPJ, tcpAleatoria]);
end;

function TpTributoToStr(const t: TTipoTributo): String;
begin
  Result := EnumeradoToStr(t, ['01', '02', '03', '04', '05', '07', '08', '', '11'],
                            [ttGPS, ttDARFNormal, ttDARFSimples, ttDARJ, ttGareICMS,
                             ttIPVA, ttDPVAT, ttLicenciamento, ttFGTS])
end;

function LinhaDigitavelParaBarras(const linha:string):string;
begin
  if length(linha) <> 47 then
    raise Exception.Create('O tamanho da string n�o corresponde a uma linha digit�vel!')
  else
    Result := copy(linha, 01, 01) + copy(linha, 02, 03) + copy(linha, 33, 01) +
           copy(linha, 34, 04) + copy(linha, 38, 10) + copy(linha, 05, 05) +
           copy(linha, 11, 10) + copy(linha, 22, 10);
end;

function DescricaoRetornoItau(ADesc: string): string;

  function GetOcorrencia(Codigo:string): string;
  begin
    if Codigo = '00' then
      Result := 'PAGAMENTO EFETUADO'
    else if Codigo = 'AE' then
      Result := 'DATA DE PAGAMENTO ALTERADA'
    else if Codigo = 'AG' then
      Result := 'N�MERO DO LOTE INV�LIDO'
    else if Codigo = 'AH' then
      Result := 'N�MERO SEQUENCIAL DO REGISTRO NO LOTE INV�LIDO'
    else if Codigo = 'AI' then
      Result := 'PRODUTO DEMONSTRATIVO DE PAGAMENTO N�O CONTRATADO'
    else if Codigo = 'AJ' then
      Result := 'TIPO DE MOVIMENTO INV�LIDO'
    else if Codigo = 'AL' then
      Result := 'C�DIGO DO BANCO FAVORECIDO INV�LIDO'
    else if Codigo = 'AM' then
      Result := 'AG�NCIA DO FAVORECIDO INV�LIDA'
    else if Codigo = 'AN' then
      Result := 'CONTA CORRENTE DO FAVORECIDO INV�LIDA / CONTA INVESTIMENTO EXTINTA EM 30/04/2011'
    else if Codigo = 'AO' then
      Result := 'NOME DO FAVORECIDO INV�LIDO'
    else if Codigo = 'AP' then
      Result := 'DATA DE PAGAMENTO / DATA DE VALIDADE / HORA DE LAN�AMENTO / ARRECADA��O / APURA��O INV�LIDA'
    else if Codigo = 'AQ' then
      Result := 'QUANTIDADE DE REGISTROS MAIOR QUE 999999'
    else if Codigo = 'AR' then
      Result := 'VALOR ARRECADADO / LAN�AMENTO INV�LIDO'
    else if Codigo = 'BC' then
      Result := 'NOSSO N�MERO INV�LIDO'
    else if Codigo = 'BD' then
      Result := 'PAGAMENTO AGENDADO'
    else if Codigo = 'BDCI' then
      Result := 'PAGAMENTO ACATADO, POR�M O CPF/CNPJ � INV�LIDO.'
    else if Codigo = 'BDCD' then
      Result := 'PAGAMENTO ACATADO, POR�M O CPF/CNPJ INFORMADO N�O � O MESMO QUE EST� CADASTRADO PARA A AG�NCIA CONTA CREDITADA'
    else if Codigo = 'BDCN' then
      Result := 'PAGAMENTO ACATADO, POR�M A AG�NCIA/CONTA INFORMADA (AINDA) N�O EXISTE'
    else if Codigo = 'BE' then
      Result := 'PAGAMENTO AGENDADO COM FORMA ALTEARADA PARA OP'
    else if Codigo = 'BI' then
      Result := 'CNPJ/CPF DO BENEFICI�RIO INV�LIDO NO SEGMENTO J-52 ou B INV�LIDO'
    else if Codigo = 'BL' then
      Result := 'VALOR DA PARCELA INV�LIDO'
    else if Codigo = 'CD' then
      Result := 'CNPJ / CPF INFORMADO DIVERGENTE DO CADASTRADO'
    else if Codigo = 'CE' then
      Result := 'PAGAMENTO CANCELADO'
    else if Codigo = 'CF' then
      Result := 'VALOR DO DOCUMENTO INV�LIDO'
    else if Codigo = 'CG' then
      Result := 'VALOR DO ABATIMENTO INV�LIDO'
    else if Codigo = 'CH' then
      Result := 'VALOR DO DESCONTO INV�LIDO'
    else if Codigo = 'CI' then
      Result := 'CNPJ / CPF / IDENTIFICADOR / INSCRI��O ESTADUAL / INSCRI��O NO CAD / ICMS INV�LIDO'
    else if Codigo = 'CJ' then
      Result := 'VALOR DA MULTA INV�LIDO'
    else if Codigo = 'CK' then
      Result := 'TIPO DE INSCRI��O INV�LIDA'
    else if Codigo = 'CL' then
      Result := 'VALOR DO INSS INV�LIDO'
    else if Codigo = 'CM' then
      Result := 'VALOR DO COFINS INV�LIDO'
    else if Codigo = 'CN' then
      Result := 'CONTA N�O CADASTRADA'
    else if Codigo = 'CO' then
      Result := 'VALOR DE OUTRAS ENTIDADES INV�LIDO'
    else if Codigo = 'CP' then
      Result := 'CONFIRMA��O DE OP CUMPRIDA'
    else if Codigo = 'CQ' then
      Result := 'SOMA DAS FATURAS DIFERE DO PAGAMENTO'
    else if Codigo = 'CR' then
      Result := 'VALOR DO CSLL INV�LIDO'
    else if Codigo = 'CS' then
      Result := 'DATA DE VENCIMENTO DA FATURA INV�LIDA'
    else if Codigo = 'DA' then
      Result := 'N�MERO DE DEPEND. SAL�RIO FAMILIA INVALIDO'
    else if Codigo = 'DB' then
      Result := 'N�MERO DE HORAS SEMANAIS INV�LIDO'
    else if Codigo = 'DC' then
      Result := 'SAL�RIO DE CONTRIBUI��O INSS INV�LIDO'
    else if Codigo = 'DD' then
      Result := 'SAL�RIO DE CONTRIBUI��O FGTS INV�LIDO'
    else if Codigo = 'DE' then
      Result := 'VALOR TOTAL DOS PROVENTOS INV�LIDO'
    else if Codigo = 'DF' then
      Result := 'VALOR TOTAL DOS DESCONTOS INV�LIDO'
    else if Codigo = 'DG' then
      Result := 'VALOR L�QUIDO N�O NUM�RICO'
    else if Codigo = 'DH' then
      Result := 'VALOR LIQ. INFORMADO DIFERE DO CALCULADO'
    else if Codigo = 'DI' then
      Result := 'VALOR DO SAL�RIO-BASE INV�LIDO'
    else if Codigo = 'DJ' then
      Result := 'BASE DE C�LCULO IRRF INV�LIDA'
    else if Codigo = 'DK' then
      Result := 'BASE DE C�LCULO FGTS INV�LIDA'
    else if Codigo = 'DL' then
      Result := 'FORMA DE PAGAMENTO INCOMPAT�VEL COM HOLERITE'
    else if Codigo = 'DM' then
      Result := 'E-MAIL DO FAVORECIDO INV�LIDO'
    else if Codigo = 'DV' then
      Result := 'DOC / TED DEVOLVIDO PELO BANCO FAVORECIDO'
    else if Codigo = 'D0' then
      Result := 'FINALIDADE DO HOLERITE INV�LIDA'
    else if Codigo = 'D1' then
      Result := 'M�S DE COMPETENCIA DO HOLERITE INV�LIDA'
    else if Codigo = 'D2' then
      Result := 'DIA DA COMPETENCIA DO HOLETITE INV�LIDA'
    else if Codigo = 'D3' then
      Result := 'CENTRO DE CUSTO INV�LIDO'
    else if Codigo = 'D4' then
      Result := 'CAMPO NUM�RICO DA FUNCIONAL INV�LIDO'
    else if Codigo = 'D5' then
      Result := 'DATA IN�CIO DE F�RIAS N�O NUM�RICA'
    else if Codigo = 'D6' then
      Result := 'DATA IN�CIO DE F�RIAS INCONSISTENTE'
    else if Codigo = 'D7' then
      Result := 'DATA FIM DE F�RIAS N�O NUM�RICO'
    else if Codigo = 'D8' then
      Result := 'DATA FIM DE F�RIAS INCONSISTENTE'
    else if Codigo = 'D9' then
      Result := 'N�MERO DE DEPENDENTES IR INV�LIDO'
    else if Codigo = 'EM' then
      Result := 'CONFIRMA��O DE OP EMITIDA'
    else if Codigo = 'EX' then
      Result := 'DEVOLU��O DE OP N�O SACADA PELO FAVORECIDO'
    else if Codigo = 'E0' then
      Result := 'TIPO DE MOVIMENTO HOLERITE INV�LIDO'
    else if Codigo = 'E1' then
      Result := 'VALOR 01 DO HOLERITE / INFORME INV�LIDO'
    else if Codigo = 'E2' then
      Result := 'VALOR 02 DO HOLERITE / INFORME INV�LIDO'
    else if Codigo = 'E3' then
      Result := 'VALOR 03 DO HOLERITE / INFORME INV�LIDO'
    else if Codigo = 'E4' then
      Result := 'VALOR 04 DO HOLERITE / INFORME INV�LIDO'
    else if Codigo = 'FC' then
      Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO COMPROR'
    else if Codigo = 'FD' then
      Result := 'PAGAMENTO EFETUADO ATRAV�S DE FINANCIAMENTO DESCOMPROR'
    else if Codigo = 'HA' then
      Result := 'ERRO NO HEADER DE ARQUIVO'
    else if Codigo = 'HM' then
      Result := 'ERRO NO HEADER DE LOTE'
    else if Codigo = 'IB' then
      Result := 'VALOR E/OU DATA DO DOCUMENTO INV�LIDO'
    else if Codigo = 'IC' then
      Result := 'VALOR DO ABATIMENTO INV�LIDO'
    else if Codigo = 'ID' then
      Result := 'VALOR DO DESCONTO INV�LIDO'
    else if Codigo = 'IE' then
      Result := 'VALOR DA MORA INV�LIDO'
    else if Codigo = 'IF' then
      Result := 'VALOR DA MULTA INV�LIDO'
    else if Codigo = 'IG' then
      Result := 'VALOR DA DEDU��O INV�LIDO'
    else if Codigo = 'IH' then
      Result := 'VALOR DO ACR�SCIMO INV�LIDO'
    else if Codigo = 'II' then
      Result := 'DATA DE VENCIMENTO INV�LIDA'
    else if Codigo = 'IJ' then
      Result := 'COMPET�NCIA / PER�ODO REFER�NCIA / PARCELA INV�LIDA'
    else if Codigo = 'IK' then
      Result := 'TRIBUTO N�O LIQUID�VEL VIA SISPAG OU N�O CONVENIADO COM ITA�'
    else if Codigo = 'IL' then
      Result := 'C�DIGO DE PAGAMENTO / EMPRESA /RECEITA INV�LIDO'
    else if Codigo = 'IM' then
      Result := 'TIPO X FORMA N�O COMPAT�VEL'
    else if Codigo = 'IN' then
      Result := 'BANCO/AGENCIA N�O CADASTRADOS'
    else if Codigo = 'IO' then
      Result := 'DAC / VALOR / COMPET�NCIA / IDENTIFICADOR DO LACRE INV�LIDO'
    else if Codigo = 'IP' then
      Result := 'DAC DO C�DIGO DE BARRAS INV�LIDO'
    else if Codigo = 'IQ' then
      Result := 'D�VIDA ATIVA OU N�MERO DE ETIQUETA INV�LIDO'
    else if Codigo = 'IR' then
      Result := 'PAGAMENTO ALTERADO'
    else if Codigo = 'IS' then
      Result := 'CONCESSION�RIA N�O CONVENIADA COM ITA�'
    else if Codigo = 'IT' then
      Result := 'VALOR DO TRIBUTO INV�LIDO'
    else if Codigo = 'IU' then
      Result := 'VALOR DA RECEITA BRUTA ACUMULADA INV�LIDO'
    else if Codigo = 'IV' then
      Result := 'N�MERO DO DOCUMENTO ORIGEM / REFER�NCIA INV�LIDO'
    else if Codigo = 'IX' then
      Result := 'C�DIGO DO PRODUTO INV�LIDO'
    else if Codigo = 'LA' then
      Result := 'DATA DE PAGAMENTO DE UM LOTE ALTERADA'
    else if Codigo = 'LC' then
      Result := 'LOTE DE PAGAMENTOS CANCELADO'
    else if Codigo = 'NA' then
      Result := 'PAGAMENTO CANCELADO POR FALTA DE AUTORIZA��O'
    else if Codigo = 'NB' then
      Result := 'IDENTIFICA��O DO TRIBUTO INV�LIDA'
    else if Codigo = 'NC' then
      Result := 'EXERC�CIO (ANO BASE) INV�LIDO'
    else if Codigo = 'ND' then
      Result := 'C�DIGO RENAVAM N�O ENCONTRADO/INV�LIDO'
    else if Codigo = 'NE' then
      Result := 'UF INV�LIDA'
    else if Codigo = 'NF' then
      Result := 'C�DIGO DO MUNIC�PIO INV�LIDO'
    else if Codigo = 'NG' then
      Result := 'PLACA INV�LIDA'
    else if Codigo = 'NH' then
      Result := 'OP��O/PARCELA DE PAGAMENTO INV�LIDA'
    else if Codigo = 'NI' then
      Result := 'TRIBUTO J� FOI PAGO OU EST� VENCIDO'
    else if Codigo = 'NR' then
      Result := 'OPERA��O N�O REALIZADA'
    else if Codigo = 'PD' then
      Result := 'AQUISI��O CONFIRMADA (EQUIVALE A OCORR�NCIA 02 NO LAYOUT DE RISCO SACADO)'
    else if Codigo = 'RJ' then
      Result := 'REGISTRO REJEITADO'
    else if Codigo = 'RS' then
      Result := 'PAGAMENTO DISPON�VEL PARA ANTECIPA��O NO RISCO SACADO � MODALIDADE RISCO SACADO P�S AUTORIZADO'
    else if Codigo = 'SS' then
      Result := 'PAGAMENTO CANCELADO POR INSUFICI�NCIA DE SALDO/LIMITE DI�RIO DE PAGTO'
    else if Codigo = 'TA' then
      Result := 'LOTE N�O ACEITO - TOTAIS DO LOTE COM DIFEREN�A'
    else if Codigo = 'TI' then
      Result := 'TITULARIDADE INV�LIDA'
    else if Codigo = 'X1' then
      Result := 'FORMA INCOMPAT�VEL COM LAYOUT 010'
    else if Codigo = 'X2' then
      Result := 'N�MERO DA NOTA FISCAL INV�LIDO'
    else if Codigo = 'X3' then
      Result := 'IDENTIFICADOR DE NF/CNPJ INV�LIDO'
    else if Codigo = 'X4' then
      Result := 'FORMA 32 INV�LIDA'
    else
      Result := 'RETORNO N�O IDENTIFICADO'
  end;

begin
  // O c�digo de ocorrencia pode ter at� 5 c�digos de 2 d�gitos cada
  while length(ADesc) > 0 do
  begin
    Result := Result + '/' + GetOcorrencia(Copy(ADesc, 1, 2));
    Delete(ADesc, 1, 2);
  end;

  if Result <> '' then
    Delete(Result, 1, 1);
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

