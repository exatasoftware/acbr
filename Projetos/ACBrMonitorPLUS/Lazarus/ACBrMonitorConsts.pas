unit ACBrMonitorConsts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

ResourceString
  SErrArqConfNaoEncontrado = 'Arquivo de configuração não encontrado';
  SErrArqConfigNaoDefinido = 'Arquivo de configuração não definido';
  SErrDiretorioInvalido = 'Diretório Invalido: %s';
  SErroNaoImplementado = 'Metodo não Implementado';

  SErroNFeAbrir = 'Erro ao abrir o arquivo da Nota Fiscal: %s';
  SErroNFeCarregar = 'Erro ao carregar Nota Fiscal';

  SErrocteAbrir = 'Erro ao abrir o arquivo do Conhecimento: %s';
  SErroCTeCarregar = 'Erro ao carregar Conhecimento';

  SErroGNReAbrir = 'Erro ao abrir o arquivo da GNRe: %s';
  SErroGNReCarregar = 'Erro ao carregar GNRe';

  SErroMDFeCarregar = 'Erro ao carregar MDFe';
  SErroArqNaoEncontado = 'Arquivo %s nao encontrado.';
  SErroMDFeAbrir = 'Erro ao abrir o arquivo do Manifesto: %s';

  SErroeSocialCarregar = 'Erro ao carregar eSocial';
  SErroeSocialAbrir = 'Erro ao abrir o arquivo do eSocial: %s';
  SMsgeSocialEventoAdicionado = 'Evento Adicionado: %s';
  SMsgeSocialLimparLista = 'Lista de Eventos Limpas com Sucesso';
  SErroeSocialNenhumEvento = 'Erro: Nenhum evento na lista';
  SErroIDEmpregadorTransmissor = 'ID do Empregador/Transmissor Inválido.';

  SErroReinfCarregar = 'Erro ao carregar Reinf';
  SErroReinfAbrir = 'Erro ao abrir o arquivo do Reinf: %s';
  SMsgReinfEventoAdicionado = 'Evento Adicionado: %s';
  SMsgReinfLimparLista = 'Lista de Eventos Limpas com Sucesso';
  SErroReinfNenhumEvento = 'Erro: Nenhum evento na lista';
  SErroIDContribuinteTransmissor = 'ID do Contribuinte/Transmissor Inválido.';


const
  CMonitorIni = 'ACBrMonitor.ini';
  _C = 'tYk*5W@';

  CACBrNFeServicosIni =                'ACBrNFeServicos.ini';
  CACBrCTeServicosIni =                'ACBrCTeServicos.ini';
  CACBrMDFeServicosIni =               'ACBrMDFeServicos.ini';
  CACBrGNREServicosIni =               'ACBrGNREServicos.ini';
  CACBreSocialServicosIni =            'ACBreSocialServicos.ini';
  CACBrReinfServicosIni =              'ACBrReinfServicos.ini';

  CMetodoSATAtivar =                   'ativar';
  CMetodoInicializar =                 'inicializar';
  CMetodoDesInicializar =              'desinicializar';
  CMetodoAssociarAssinatura =          'associarassinatura';
  CMetodoBloquear =                    'bloquear';
  CMetodoDesbloquear =                 'desbloquear';
  CMetodotrocarcodigoativacao =        'trocarcodigoativacao';
  CMetodoConsultarSat =                'consultarsat';
  CMetodoConsultarStatusOperacional =  'consultarstatusoperacional';
  CMetodoConsultarSessao =             'consultarsessao';
  CMetodoConsultarNumeroSessao =       'consultarnumerosessao';
  CMetodoAtualizaSoftware =            'atualizasoftware';
  CMetodoAtualizarSoftwareSAT =        'atualizarsoftwaresat';
  CMetodoComunicarCertificado =        'comunicarcertificado';
  CMetodoComunicarCertificadoICPBrasil='comunicarcertificadoicpbrasil';
  CMetodoCarregarDadosVenda =          'carregardadosvenda';
  CMetodoCarregarDadosCancelamento =   'carregardadoscancelamento';
  CMetodoCriarCFe =                    'criarcfe';
  CMetodoCriarEnviarCFe =              'criarenviarcfe';
  CMetodoEnviarCFe =                   'enviarcfe';
  CMetodoCancelarCFe =                 'cancelarcfe';
  CMetodoImprimirExtratoVenda =        'imprimirextratovenda';
  CMetodoImprimirExtratoResumido =     'imprimirextratoresumido';
  CMetodoImprimirExtratoCancelamento = 'imprimirextratocancelamento';
  CMetodoGerarImpressaoFiscalMFe =     'gerarimpressaofiscalmfe';
  CMetodoGerarPDFExtratoVenda =        'gerarpdfextratovenda';
  CMetodoExtrairLogs =                 'extrairlogs';
  CMetodoTesteFimaFim =                'testefimafim';
  CMetodoSetNumeroSessao =             'setnumerosessao';
  CMetodoSetlogomarcaSAT =             'setlogomarca';

  CMetodostatusservico =               'statusservico';
  CMetodoValidarmdfe =                 'validarmdfe';
  CMetodoAssinarmdfe =                 'assinarmdfe';
  CMetodoConsultarmdfe =               'consultarmdfe';
  CMetodoCancelarmdfe =                'cancelarmdfe';
  CMetodoEncerrarmdfe =                'encerrarmdfe';
  CMetodoConsultamdfenaoenc =          'consultamdfenaoenc';
  CMetodoImprimirdamdfe =              'imprimirdamdfe';
  CMetodoImprimirdamdfepdf =           'imprimirdamdfepdf';
  CMetodoImprimirevento =              'imprimirevento';
  CMetodoImprimireventopdf =           'imprimireventopdf';
  CMetodoEnviarmdfe =                  'enviarmdfe';
  CMetodoCriarmdfe =                   'criarmdfe';
  CMetodoCriarenviarmdfe =             'criarenviarmdfe';
  CMetodoAdicionarmdfe =               'adicionarmdfe';
  CMetodoEnviarlotemdfe =              'enviarlotemdfe';
  CMetodoRecibomdfe =                  'recibomdfe';
  CMetodoInutilizarmdfe =              'inutilizarmdfe';
  CMetodoConsultacadastro =            'consultacadastro';
  CMetodoEnviaremail =                 'enviaremail';
  CMetodoSetambiente =                 'setambiente';
  CMetodoSetlogomarca =                'setlogomarca';
  CMetodoSetformaemissao =             'setformaemissao';
  CMetodoSetTipoImpressao =            'settipoimpressao';
  CMetodoSetversaodf =                 'setversaodf';
  CMetodoLermdfe =                     'lermdfe';
  CMetodoMdfetotxt =                   'mdfetotxt';
  CMetodoFileexist =                   'fileexist';
  CMetodoCertificadodatavencimento =   'certificadodatavencimento';
  CMetodoGerarchave =                  'gerarchave';
  CMetodoVersao =                      'versao';
  CMetodoSavetofile =                  'savetofile';
  CMetodoLoadfromfile =                'loadfromfile';
  CMetodoLerini =                      'lerini';
  CMetodoSetcertificado =              'setcertificado';
  CMetodoRestaurar =                   'restaurar';
  CMetodoOcultar =                     'ocultar';
  CMetodoEncerrarmonitor =             'encerrarmonitor';
  CMetodoAtivo =                       'ativo';
  CMetodoDatahora =                    'datahora';
  CMetodoData =                        'data';
  CMetodoHora =                        'hora';
  CMetodoExit =                        'exit';
  CMetodoBye  =                        'bye';
  CMetodoFim  =                        'fim';
  CMetodoSair =                        'sair';

  CMetodoValidarnfe =                  'validarnfe';
  CMetodoAssinarnfe =                  'assinarnfe';
  CMetodoConsultarnfe =                'consultarnfe';
  CMetodoCancelarnfe =                 'cancelarnfe';
  CMetodoImprimirdanfe =               'imprimirdanfe';
  CMetodoImprimirdanfepdf =            'imprimirdanfepdf';
  CMetodoEnviarnfe =                   'enviarnfe';
  CMetodoCriarnfe =                    'criarnfe';
  CMetodoCriarenviarnfe =              'criarenviarnfe';
  CMetodoAdicionarnfe =                'adicionarnfe';
  CMetodoEnviarlotenfe =               'enviarlotenfe';
  CMetodoRecibonfe =                   'recibonfe';
  CMetodoInutilizarnfe =               'inutilizarnfe';
  CMetodoLernfe =                      'lernfe';
  CMetodonfetotxt =                    'nfetotxt';
  CMetodoValidarRegrasNegocios =       'validarnferegranegocios';
  CMetodoImprimirInutilizacao =        'imprimirinutilizacao';
  CMetodoImprimirInutilizacaoPDF =     'imprimirinutilizacaopdf';
  CMetodoEnviarEvento =                'enviarevento';
  CMetodoCartaCorrecao =               'cartadecorrecao';
  CMetodoXMLEnviarEvento =             'xmlenviarevento';
  CMetodoDistribuicaoDFeporChaveNFe =  'distribuicaodfeporchavenfe';
  CMetodoDistribuicaoDFeporNSU =       'distribuicaodfepornsu';
  CMetodoDistribuicaoDFeporUltNSU =    'distribuicaodfeporultnsu';
  CMetodoEnviaremailEvento =           'enviaremailevento';
  CMetodoEnviaremailInutilizacao =     'enviaremailinutilizacao';
  CMetodoSetModeloDF =                 'setmodelodf';
  CMetodoSetToken =                    'settoken';
  CMetodoSetCSC =                      'setcsc';
  CMetodoSetIdToken =                  'setidtoken';
  CMetodoSetIdCSC =                    'setidcsc';
  CMetodoGerarININFe =                 'gerarininfe';
  CMetodoCNPJCertificado =             'cnpjcertificado';
  CMetodoGetPathNFe =                  'getpathnfe';
  CMetodoGetPathCCe =                  'getpathcce';
  CMetodoGetPathCan =                  'getpathcan';
  CMetodoGetPathEvento =               'getpathevento';
  CMetodoGetPathInu =                  'getpathinu';
  CMetodoImprimirRelatorio =           'imprimirrelatorio';
  CMetodoCriarNFeSEFAZ =               'criarnfesefaz';
  CMetodoCriarEnviarNFeSEFAZ =         'criarenviarnfesefaz';
  CMetodoAdicionarNFeSEFAZ =           'adicionarnfesefaz';
  CMetodoDistribuicaoDFe =             'distribuicaodfe';
  CMetodoDataVencimentoCertificado =   'datavencimentocertificado';

  CMetodoValidarCTe =                  'validarcte';
  CMetodoAssinarCTe =                  'assinarcte';
  CMetodoConsultarCTe =                'consultarcte';
  CMetodoCancelarCTe =                 'cancelarcte';
  CMetodoImprimirDACTe =               'imprimirdacte';
  CMetodoImprimirDACTePDF =            'imprimirdactepdf';

  CMetodoEnviarCTe =                   'enviarcte';
  CMetodoCriarCTe =                    'criarcte';
  CMetodoCriarEnviarCTe =              'criarenviarcte';
  CMetodoAdicionarCTe =                'adicionarcte';
  CMetodoEnviarLoteCTe =               'enviarlotecte';
  CMetodoReciboCTe =                   'recibocte';
  CMetodoInutilizarCTe =               'inutilizarcte';
  CMetodoLerCTe =                      'lercte';
  CMetodoCTetotxt =                    'ctetotxt';
  CMetodoDistribuicaoDFeporChaveCTe =  'distribuicaodfeporchavecte';
  CMetodoGerarINICTe =                 'gerarinicte';
  CMetodoGetPathCTe =                  'getpathcte';

  CMetodoCriarEventoeSocial =          'criareventoesocial';
  CMetodoCriarEnviareSocial =          'criarenviaresocial';
  CMetodoEnviareSocial =               'enviaresocial';
  CMetodoConsultareSocial =            'consultaresocial';
  CMetodoLimpareSocial =               'limparesocial';
  CMetodoCarregarXMLEventoeSocial =    'carregarxmleventoesocial';
  CMetodoSetIDEmpregadoreSocial =      'setidempregador';
  CMetodoSetIDTransmissoresocial =     'setidtransmissor';

  CMetodoCriarEventoReinf =          'criareventoreinf';
  CMetodoCriarEnviarReinf =          'criarenviarreinf';
  CMetodoEnviarReinf =               'enviarreinf';
  CMetodoConsultarReinf =            'consultarreinf';
  CMetodoLimparReinf =               'limparreinf';
  CMetodoCarregarXMLEventoReinf =    'carregarxmleventoreinf';
  CMetodoSetIDContribuinteReinf =    'setidcontribuinte';
  CMetodoSetIDTransmissorReinf =     'setidtransmissor';

  CMetodoConfigurarDados =           'configurardados';
  CMetodoLimparLista =               'limparlista';
  CMetodoTotalTitulosLista =         'totaltituloslista';
  CMetodoImprimir =                  'imprimir';
  CMetodoGerarPDF =                  'gerarpdf';
  CMetodoGerarHTML =                 'gerarhtml';
  CMetodoGerarRemessa =              'gerarremessa';
  CMetodoLerRetorno =                'lerretorno';
  CMetodoIncluirTitulos =            'incluirtitulos';
  CMetodoSetDiretorioArquivo =       'setdiretorioarquivo';
  CMetodoListaBancos =               'listabancos';
  CMetodoListaCaractTitulo =         'listacaracttitulo';
  CMetodoListaOcorrencias =          'listaocorrencias';
  CMetodoTamNossoNumero =            'tamnossonumero';
  CMetodoCodigosMoraAceitos =        'codigosmoraaceitos';
  CMetodoSelecionaBanco =            'selecionabanco';

  CMetodoAtivar =               'ativar';
  CMetodoDesativar =            'desativar';
  CMetodoModeloStr =            'modelostr';
  CMetodoModelo =               'modelo';
  CMetodoPorta =                'porta';
  CMetodoIntervalo =            'intervalo';
  CMetodoSetIntervalo =         'setintervalor';
  CMetodoLePeso =               'lepeso';
  CMetodoUltimoPesoLido =       'ultimopesolido';
  CMetodoUltimaResposta =       'ultimaresposta';
  CMetodoMonitorarBalanca =     'monitorarbalanca';

  CMetodoNovo =                 'novo';
  CMetodoAdicionaPara =         'adicionapara';
  CMetodoAdicionaResponderA =   'adicionarespondera';
  CMetodoAdicionaCC =           'adicionacc';
  CMetodoAdicionaBCC =          'adicionabcc';
  CMetodoAssunto =              'assunto';
  CMetodoConfirmarLeitura =     'confirmarleitura';
  CMetodoUsarHTML =             'usarhtml';
  CMetodoTentativasEnvio =      'tentativasenvio';
  CMetodoSetPrioridade =        'setprioridade';
  CMetodoSetCodificacao =       'setcodificacao';
  CMetodoTextoMensagem =        'textomensagem';
  CMetodoTextoAlternativo =     'textoalternativo';
  CMetodoAdicionaAnexo =        'adicionaanexo';
  CMetodoEnviar =               'enviar';

  CMetodoBuscarPorCEP =         'buscarporcep';
  CMetodoBuscarPorLogradouro =  'buscarporlogradouro';

  CMetodoChequePronto    = 'chequepronto';
  CMetodoBanco           = 'banco';
  CMetodoSetBanco        = 'setbanco';
  CMetodoCidade          = 'cidade';
  CMetodoSetCidade       = 'setcidade';
  CMetodoFavorecido      = 'favorecido';
  CMetodoSetFavorecido   = 'setfavorecido';
  CMetodoObservacao      = 'observacao';
  CMetodoSetObservacao   = 'setobservacao';
  CMetodoValor           = 'valor';
  CMetodoSetValor        = 'setvalor';
  CMetodoSetData         = 'setdata';
  CMetodoBomPara         = 'bompara';
  CMetodoSetBomPara      = 'setbompara';
  CMetodoImprimirCheque  = 'imprimircheque';
  CMetodoTravarCheque    = 'travarcheque';
  CMetodoDestravarCheque = 'destravarcheque';
  CMetodoCMC7            = 'cmc7';
  CMetodoImprimirLinha   = 'imprimirlinha';
  CMetodoImprimirVerso   = 'imprimirverso';

  CMetodoAbreGaveta           = 'abregaveta';
  CMetodoGavetaAberta         = 'gavetaaberta';
  CMetodoStrComando           = 'strcomando';
  CMetodoSetStrComando        = 'setstrcomando';
  CMetodoAberturaIntervalo    = 'aberturaintervalo';
  CMetodoSetAberturaIntervalo = 'setaberturaintervalo';
  CMetodoAberturaAntecipada   = 'aberturaantecipada';

  CMetodoBuscarPorCodigo = 'buscarporcodigo';
  CMetodoBuscarPorNome   = 'buscarpornome';

  CMetodoValidar      = 'validar';
  CMetodoBaixarLista  = 'baixarlista';
  CMetodoDescricaoNCM = 'descricaoncm';

  CExtensaoXML =                     '.xml';

  CExtensaoXmlNFe =                  '-nfe.xml';
  CExtensaoXmlNFeEve =               '-eve.xml';
  CExtensaoXmlNFeInu =               '-inu.xml';

  CExtensaoXmlCTe =                  '-cte.xml';
  CExtensaoXmlCTeEve =               '-eve.xml';
  CExtensaoXmlCTeInu =               '-inu.xml';

  CExtensaoXmlMdfe =                 '-mdfe.xml';
  CExtensaoXmlMdfeEve =              '-eve.xml';
  CExtensaoXmlGNRe =                 '-gnre.xml';

  CPathLogs =                        'Logs';

  CSecACBrMonitor =                  'ACBrMonitor';
  CKeyModo_TCP =                     'Modo_TCP';
  CKeyModo_TXT =                     'Modo_TXT';
  CKeyMonitorarPasta =               'MonitorarPasta';
  CKeyTCP_Porta =                    'TCP_Porta';
  CKeyTCP_TimeOut =                  'TCP_TimeOut';
  CKeyConverte_TCP_Ansi =            'Converte_TCP_Ansi';
  CKeyTXT_Entrada =                  'TXT_Entrada';
  CKeyTXT_Saida =                    'TXT_Saida';
  CKeyConverte_TXT_Entrada_Ansi =    'Converte_TXT_Entrada_Ansi';
  CKeyConverte_TXT_Saida_Ansi =      'Converte_TXT_Saida_Ansi';
  CKeyIntervalo =                    'Intervalo';
  CKeyGravar_Log =                   'Gravar_Log';
  CKeyArquivo_Log =                  'Arquivo_Log';
  CKeyLinhas_Log =                   'Linhas_Log';
  CKeyComandos_Remotos =             'Comandos_Remotos';
  CKeyUma_Instancia =                'Uma_Instancia';
  CKeyMostraAbas =                   'MostraAbas';
  CKeyMostrarNaBarraDeTarefas =      'MostrarNaBarraDeTarefas';
  CKeyRetirarAcentosNaResposta =     'RetirarAcentosNaResposta';
  CKeyMostraLogEmRespostasEnviadas = 'MostraLogEmRespostasEnviadas';
  CKeyHashSenha =                    'HashSenha';
  CKeyMonitorSenha =                 'Senha';
  CKeyVersaoSSL =                    'VersaoSSL';

  CSecECF =                          'ECF';
  CKeyModelo =                       'Modelo';
  CKeyPorta =                        'Porta';
  CKeySerialParams =                 'SerialParams';
  CKeyTimeout =                      'Timeout';
  CKeyIntervaloAposComando =         'IntervaloAposComando';
  CKeyMaxLinhasBuffer =              'MaxLinhasBuffer';
  CKeyPaginaCodigo =                 'PaginaCodigo';
  CKeyLinhasEntreCupons =            'LinhasEntreCupons';
  CKeyArredondamentoPorQtd =         'ArredondamentoPorQtd';
  CKeyArredondamentoItemMFD =        'ArredondamentoItemMFD';
  CKeyDescricaoGrande =              'DescricaoGrande';
  CKeyGavetaSinalInvertido =         'GavetaSinalInvertido';
  CKeyIgnorarTagsFormatacao =        'IgnorarTagsFormatacao';
  CKeyControlePorta =                'ControlePorta';
  CKeyArqLog =                       'ArqLog';

  CSecCHQ =                          'CHQ';
  CKeyCHQModelo =                    'Modelo';
  CKeyCHQPorta =                     'Porta';
  CKeyCHQSerialParams =              'SerialParams';
  CKeyCHQVerificaFormulario =        'VerificaFormulario';
  CKeyCHQFavorecido =                'Favorecido';
  CKeyCHQCidade =                    'Cidade';
  CKeyCHQPathBemafiINI =             'PathBemafiINI';

  CSecGAV =                          'GAV';
  CKeyGAVModelo =                    'Modelo';
  CKeyGAVPorta =                     'Porta';
  CKeyGAVStringAbertura =            'StringAbertura';
  CKeyGAVAberturaIntervalo =         'AberturaIntervalo';
  CKeyGAVAcaoAberturaAntecipada =    'AcaoAberturaAntecipada';

  CSecDIS =                          'DIS';
  CKeyDISModelo =                    'Modelo';
  CKeyDISPorta =                     'Porta';
  CKeyDISIntervalo =                 'Intervalo';
  CKeyDISPassos =                    'Passos';
  CKeyDISIntervaloEnvioBytes =       'IntervaloEnvioBytes';

  CSecLCB =                          'LCB';
  CKeyLCBPorta =                     'Porta';
  CKeyLCBIntervalo =                 'Intervalo';
  CKeyLCBSufixoLeitor =              'SufixoLeitor';
  CKeyLCBExcluirSufixo =             'ExcluirSufixo';
  CKeyLCBPrefixoAExcluir =           'PrefixoAExcluir';
  CKeyLCBSufixoIncluir =             'SufixoIncluir';
  CKeyLCBDispositivo =               'Dispositivo';
  CKeyLCBTeclado =                   'Teclado';
  CKeyLCBDevice =                    'Device';

  CSecRFD =                          'RFD';
  CKeyRFDGerarRFD =                  'GerarRFD';
  CKeyRFDDirRFD =                    'DirRFD';
  CKeyRFDIgnoraECF_MFD =             'IgnoraECF_MFD';

  CSecBAL =                          'BAL';
  CKeyBALModelo =                    'Modelo';
  CKeyBALPorta =                     'Porta';
  CKeyBALIntervalo =                 'Intervalo';
  CKeyBALArqLog =                    'ArqLog';
  CKeyBALDevice =                    'Device';

  CSecETQ =                          'ETQ';
  CKeyETQModelo =                    'Modelo';
  CKeyETQPorta =                     'Porta';
  CKeyETQDPI =                       'DPI';
  CKeyETQLimparMemoria =             'LimparMemoria';
  CKeyETQTemperatura =               'Temperatura';
  CKeyETQVelocidade =                'Velocidade';
  CKeyETQBackFeed =                  'BackFeed';
  CKeyETQMargemEsquerda =            'MargemEsquerda';
  CKeyETQOrigem =                    'Origem';
  CKeyETQCopias =                    'Copias';
  CKeyETQUnidade =                   'Unidade';

  CSecCEP =                          'CEP';
  CKeyCEPWebService =                'WebService';
  CKeyCEPChave_BuscarCEP =           'Chave_BuscarCEP';
  CKeyCEPProxy_Host =                'Proxy_Host';
  CKeyCEPProxy_Port =                'Proxy_Port';
  CKeyCEPProxy_User =                'Proxy_User';
  CKeyCEPProxy_Pass =                'Proxy_Pass';
  CKeyCEPIBGEAcentos =               'IBGEAcentos';
  CKeyCEPIBGEUTF8 =                  'IBGEUTF8';

  CSecTC =                           'TC';
  CKeyTCModelo =                     'Modelo';
  CKeyTCTCP_Porta =                  'TCP_Porta';
  CKeyTCArq_Precos =                 'Arq_Precos';
  CKeyTCNao_Econtrado =              'Nao_Econtrado';

  CSecSEDEX =                        'SEDEX';
  CKeyContratoSEDEX =                'Contrato';
  CKeySenhaSEDEX =                   'SenhaSedex';

  CSecNCM =                          'NCM';
  CKeyDirNCMSalvar =                 'DirNCMSalvar';

  CSecCertificado =                  'Certificado';
  CKeySSLLib =                       'SSLLib';
  CKeyCryptLib =                     'CryptLib';
  CKeyHttpLib =                      'HttpLib';
  CKeyXmlSignLib =                   'XmlSignLib';
  CKeySSLType =                      'SSLType';
  CKeyArquivoPFX =                   'ArquivoPFX';
  CKeyNumeroSerie =                  'NumeroSerie';
  CKeySenha =                        'Senha';
  CKeyExibeRazaoSocialCertificado =  'ExibeRazaoSocialCertificado';
  CKeyVerificarValidade =            'VerificarValidade';


  CSecACBrNFeMonitor =                'ACBrNFeMonitor';
  CKeyIgnorarComandoModoEmissao =     'IgnorarComandoModoEmissao';
  CKeyModoXML =                       'ModoXML';
  CKeyRetirarAcentos =                'RetirarAcentos';
  CKeyGravar_Log_Comp =               'Gravar_Log_Comp';
  CKeyArquivo_Log_Comp =              'Arquivo_Log_Comp';
  CKeyLinhas_Log_Comp =               'Linhas_Log_Comp';
  CKeyArquivoWebServices =            'ArquivoWebServices';
  CKeyArquivoWebServicesCTe =         'ArquivoWebServicesCTe';
  CKeyArquivoWebServicesMDFe =        'ArquivoWebServicesMDFe';
  CKeyArquivoWebServicesGNRe =        'ArquivoWebServicesGNRe';
  CKeyArquivoWebServiceseSocial =     'ArquivoWebServiceseSocial';
  CKeyArquivoWebServicesReinf =       'ArquivoWebServicesReinf';
  CKeyValidarDigest =                 'ValidarDigest';
  CKeyTimeoutWebService =             'TimeoutWebService';

  CSecGeral =                        'Geral';
  CKeyDANFE =                        'DANFE';
  CKeyFormaEmissao =                 'FormaEmissao';
  CKeyLogomarca =                    'Logomarca';
  CKeyLogoMarcaNFCeSAT =             'LogoMarcaNFCeSAT';
  CKeySalvar =                       'Salvar';
  CKeyPathSalvar =                   'PathSalvar';
  CKeyImpressora =                   'Impressora';

  CSecWebService =                   'WebService';
  CKeyVersao =                       'Versao';
  CKeyVersaoCTe =                    'VersaoCTe';
  CKeyVersaoMDFe =                   'VersaoMDFe';
  CKeyVersaoeSocial =                'VersaoeSocial';
  CKeyVersaoReinf =                  'VersaoReinf';
  CKeyVersaoQRCode =                 'VersaoQRCode';
  CKeyFormaEmissaoCTe =              'FormaEmissaoCTe';
  CKeyFormaEmissaoNFe =              'FormaEmissaoNFe';
  CKeyFormaEmissaoMDFe =             'FormaEmissaoMDFe';
  CKeyFormaEmissaoGNRe =             'FormaEmissaoGNRe';
  CKeyUF =                           'UF';
  CKeyAmbiente =                     'Ambiente';
  CKeyAjustarAut =                   'AjustarAut';
  CKeyAguardar =                     'Aguardar';
  CKeyTentativas =                   'Tentativas';
  CKeyWebServiceIntervalo =          'Intervalo';
  CKeyTimeZoneMode =                 'TimeZoneMode';
  CKeyTimeZoneStr =                  'TimeZoneStr';
  CKeyCamposFatObrig =               'CamposFatObrig';

  CKeyIdEmpregador =                 'IdEmpregador';
  CKeyIdTransmissor =                'IdTransmissor';
  CKeyTipoEmpregador =               'TipoEmpregador';
  CKeyIdContribuinte =               'IdContribuinte';
  CKeyTipoContribuinte =             'TipoContribuinte';

  CSecProxy =                        'Proxy';
  CKeyProxyHost =                    'Host';
  CKeyProxyPorta =                   'Porta';
  CKeyProxyUser =                    'User';
  CKeyProxyPass =                    'Pass';

  CSecEmail =                        'Email';
  CKeyEmailNomeExibicao =            'NomeExibicao';
  CKeyEmailEndereco =                'Endereco';
  CKeyEmail =                        'Email';
  CKeyEmailUsuario =                 'Usuario';
  CKeyEmailSenha =                   'Senha';
  CKeyEmailPorta =                   'Porta';
  CKeyEmailExigeSSL =                'ExigeSSL';
  CKeyEmailExigeTLS =                'ExigeTLS';
  CKeyEmailConfirmacao =             'Confirmacao';
  CKeyEmailSegundoPlano =            'SegundoPlano';
  CKeyEmailCodificacao =             'Codificacao';
  CKeyMensagemNFe =                  'MensagemNFe';
  CKeyMensagemCTe =                  'MensagemCTe';
  CKeyMensagemMDFe =                 'MensagemMDFe';
  CKeyAssuntoNFe =                   'AssuntoNFe';
  CKeyAssuntoCTe =                   'AssuntoCTe';
  CKeyAssuntoMDFe =                  'AssuntoMDFe';

  CSecNFe =                          'NFe';
  CKeyNFeCNPJContador =              'CNPJContador';

  CSecNFCe =                           'NFCe';
  CKeyNFCeIdToken =                    'IdToken';
  CKeyNFCeToken =                      'Token';
  CKeyNFCeTagQrCode =                  'TagQrCode';
  CKeyNFCeModelo =                     'Modelo';
  CKeyNFCeModoImpressaoEvento =        'ModoImpressaoEvento';
  CKeyNFCeImprimirItem1Linha =         'ImprimirItem1Linha';
  CKeyNFCeImprimirDescAcresItem =      'ImprimirDescAcresItem';
  CKeyNFCeImpressoraPadrao =           'ImpressoraPadrao';
  CKeyNFCeQRCodeLateral =              'QRCodeLateral';
  CKeyNFCeUsaCodigoEanImpressao =      'UsaCodigoEanImpressao';
  CKeyNFCeImprimeNomeFantasia =        'ImprimeNomeFantasia';
  CKeyNFCeUsarIntegrador =             'UsarIntegrador';

  CSecDANFE =                          'DANFE';
  CKeyDANFEModelo =                    'Modelo';
  CKeyDANFETamanhoPapel =              'TamanhoPapel';
  CKeyDANFESite =                      'Site';
  CKeyDANFEEmail =                     'Email';
  CKeyDANFEFax =                       'Fax';
  CKeyDANFEImpDescPorc =               'ImpDescPorc';
  CKeyDANFEMostrarPreview =            'MostrarPreview';
  CKeyDANFECopias =                    'Copias';
  CKeyDANFELarguraCodigoProduto =      'LarguraCodigoProduto';
  CKeyDANFEEspessuraBorda =            'EspessuraBorda';
  CKeyDANFEFonteRazao =                'FonteRazao';
  CKeyDANFEFonteEndereco =             'FonteEndereco';
  CKeyDANFEFonteCampos =               'FonteCampos';
  CKeyDANFEAlturaCampos =              'AlturaCampos';
  CKeyDANFEMargem =                    'Margem';
  CKeyDANFEMargemSup =                 'MargemSup';
  CKeyDANFEMargemDir =                 'MargemDir';
  CKeyDANFEMargemEsq  =                'MargemEsq';
  CKeyDANFEPathPDF =                   'PathPDF';
  CKeyDANFEDecimaisQTD =               'DecimaisQTD';
  CKeyDANFEDecimaisValor =             'DecimaisValor';
  CKeyDANFEExibeResumo =               'ExibeResumo';
  CKeyDANFEImprimirTributosItem =      'ImprimirTributosItem';
  CKeyDANFEImprimirValLiq =            'ImprimirValLiq';
  CKeyDANFEUNComercialETributavel =    'UNComercialETributavel';
  CKeyDANFEPreImpresso =               'PreImpresso';
  CKeyDANFEMostrarStatus =             'MostrarStatus';
  CKeyDANFEExibirEAN =                 'ExibirEAN';
  CKeyDANFEExibirCampoFatura =         'ExibirCampoFatura';
  CKeyDANFEExpandirLogo =              'ExpandirLogo';
  CKeyDANFEFonte =                     'Fonte';
  CKeyDANFELocalCanhoto =              'LocalCanhoto';
  CKeyDANFEQuebrarLinhasDetalheItens =     'QuebrarLinhasDetalheItens';
  CKeyDANFEImprimirDetalhamentoEspecifico ='ImprimirDetalhamentoEspecifico';
  CKeyDANFEImprimirDadosDocReferenciados = 'ImprimirDadosDocReferenciados';
  CKeyDANFEExibirBandInforAdicProduto =    'ExibirBandInforAdicProduto';
  CKeyDANFELogoEmCima =                    'LogoEmCima';

  CSecDANFCe =                         'DANFCe';
  CKeyDANFCeMargemInf =                'MargemInf';
  CKeyDANFCeMargemSup =                'MargemSup';
  CKeyDANFCeMargemDir =                'MargemDir';
  CKeyDANFCeMargemEsq =                'MargemEsq';
  CKeyDANFCeLarguraBobina =            'LarguraBobina';

  CSecDACTE =                          'DACTE';
  CKeyDACTETamanhoPapel =              'TamanhoPapel';

  CSecArquivos =                            'Arquivos';
  CKeyArquivosSalvar =                      'Salvar';
  CKeyArquivosPastaMensal =                 'PastaMensal';
  CKeyArquivosAddLiteral=                   'AddLiteral';
  CKeyArquivosEmissaoPathNFe =              'EmissaoPathNFe';
  CKeyArquivosSalvarCCeCanPathEvento =      'SalvarCCeCanPathEvento';
  CKeyArquivosSepararPorCNPJ =              'SepararPorCNPJ';
  CKeyArquivosSepararPorModelo =            'SepararPorModelo';
  CKeyArquivosSalvarApenasNFesAutorizadas = 'SalvarApenasNFesAutorizadas';
  CKeyArquivosAtualizarXMLCancelado =       'AtualizarXMLCancelado';
  CKeyArquivosNormatizarMunicipios =        'NormatizarMunicipios';
  CKeyArquivosUsarSeparadorPathPDF =        'UsarSeparadorPathPDF';
  CKeyArquivosPathNFe =                     'PathNFe';
  CKeyArquivosPathInu =                     'PathInu';
  CKeyArquivosPathDPEC =                    'PathDPEC';
  CKeyArquivosPathEvento =                  'PathEvento';
  CKeyArquivosPathArqTXT =                  'PathArqTXT';

  CSeceSocial =                             'eSocial';
  CSecReinf =                               'Reinf';
  CKey =                                    'Host';

  CSecSAT =                                 'SAT';
  CKeySATModelo =                           'Modelo';
  CKeySATArqLog =                           'ArqLog';
  CKeySATNomeDLL =                          'NomeDLL';
  CKeySATCodigoAtivacao =                   'CodigoAtivacao';
  CKeySATCodigoUF =                         'CodigoUF';
  CKeySATNumeroCaixa =                      'NumeroCaixa';
  CKeySATAmbiente =                         'Ambiente';
  CKeySATPaginaDeCodigo =                   'PaginaDeCodigo';
  CKeySATversaoDadosEnt =                   'versaoDadosEnt';
  CKeySATFormatarXML =                      'FormatarXML';
  CKeySATPathCFe =                          'PathCFe';
  CKeySATSalvarCFe =                        'SalvarCFe';
  CKeySATSalvarCFeCanc =                    'SalvarCFeCanc';
  CKeySATSalvarEnvio =                      'SalvarEnvio';
  CKeySATSepararPorCNPJ =                   'SepararPorCNPJ';
  CKeySATSepararPorMES =                    'SepararPorMES';

  CSecSATExtrato =                          'SATExtrato';
  CKeySATExtParamsString =                  'ParamsString';
  CKeySATExtImprimeDescAcrescItem =         'ImprimeDescAcrescItem';
  CKeySATExtImprimeEmUmaLinha =             'ImprimeEmUmaLinha';
  CKeySATExtImprimeChaveEmUmaLinha =        'ImprimeChaveEmUmaLinha';
  CKeySATExtUsaCodigoEanImpressao =         'UsaCodigoEanImpressao';

  CSecSATEmit =                             'SATEmit';
  CKeySATEmitCNPJ =                         'CNPJ';
  CKeySATEmitIE =                           'IE';
  CKeySATEmitIM =                           'IM';
  CKeySATEmitRegTributario =                'RegTributario';
  CKeySATEmitRegTribISSQN =                 'RegTribISSQN';
  CKeySATEmitIndRatISSQN =                  'IndRatISSQN';

  CSecSATFortes =                           'SATFortes';
  CKeySATFortesUsarFortes =                 'UsarFortes';
  CKeySATFortesLargura =                    'Largura';
  CKeySATFortesMargemTopo =                 'MargemTopo';
  CKeySATFortesMargemFundo =                'MargemFundo';
  CKeySATFortesMargemEsquerda =             'MargemEsquerda';
  CKeySATFortesMargemDireita =              'MargemDireita';
  CKeySATFortesPreview =                    'Preview';

  CSecSATRede =                             'SATRede';
  CKeySATRedetipoInter =                    'tipoInter';
  CKeySATRedetipoLan =                      'tipoLan';
  CKeySATRedeSSID =                         'SSID';
  CKeySATRedeseg =                          'seg';
  CKeySATRedecodigo =                       'codigo';
  CKeySATRedelanIP =                        'lanIP';
  CKeySATRedelanMask =                      'lanMask';
  CKeySATRedelanGW =                        'lanGW';
  CKeySATRedelanDNS1 =                      'lanDNS1';
  CKeySATRedelanDNS2 =                      'lanDNS2';
  CKeySATRedeusuario =                      'usuario';
  CKeySATRedesenha =                        'senha';
  CKeySATRedeproxy =                        'proxy';
  CKeySATRedeproxy_ip =                     'proxy_ip';
  CKeySATRedeproxy_porta =                  'proxy_porta';
  CKeySATRedeproxy_user =                   'proxy_user';
  CKeySATRedeproxy_senha =                  'proxy_senha';

  CSecSATPrinter =                          'SATPrinter';
  CKeySATPrinterName =                      'Name';

  CSecSATSwH =                              'SATSwH';
  CKeySATSwHCNPJ =                          'CNPJ';
  CKeySATSwHAssinatura =                    'Assinatura';

  CSecSATIntegrador =                       'SATIntegrador';
  CKeySATIntegradorInput =                  'Input';
  CKeySATIntegradorOutput =                 'Output';
  CKeySATIntegradorTimeout =                'Timeout';

  CSecPosPrinter =                          'PosPrinter';
  CKeyPosPrinterModelo =                    'Modelo';
  CKeyPosPrinterPorta =                     'Porta';
  CKeyPosPrinterColunas =                   'Colunas';
  CKeyPosPrinterEspacoEntreLinhas =         'EspacoEntreLinhas';
  CKeyPosPrinterLinhasBuffer =              'LinhasBuffer';
  CKeyPosPrinterLinhasPular =               'LinhasPular';
  CKeyPosPrinterPaginaDeCodigo =            'PaginaDeCodigo';
  CKeyPosPrinterControlePorta =             'ControlePorta';
  CKeyPosPrinterCortarPapel =               'CortarPapel';
  CKeyPosPrinterTraduzirTags =              'TraduzirTags';
  CKeyPosPrinterIgnorarTags =               'IgnorarTags';
  CKeyPosPrinterArqLog =                    'ArqLog';
  CKeyPosPrinterSerialParams =              'SerialParams';

  CSecBarras =                              'Barras';
  CKeyBarrasLargura =                       'Largura';
  CKeyBarrasAltura =                        'Altura';
  CKeyBarrasHRI =                           'HRI';

  CSecQRCode =                              'QRCode';
  CKeyQRCodeTipo =                          'Tipo';
  CKeyQRCodeLarguraModulo =                 'LarguraModulo';
  CKeyQRCodeErrorLevel =                    'ErrorLevel';

  CSecLogo =                                'Logo';
  CKeyLogoImprimir =                        'Imprimir';
  CKeyLogoKC1 =                             'KC1';
  CKeyLogoKC2 =                             'KC2';
  CKeyLogoFatorX =                          'FatorX';
  CKeyLogoFatorY =                          'FatorY';

  CSecGaveta =                              'Gaveta';
  CKeyGavetaTempoON =                       'TempoON';
  CKeyGavetaTempoOFF =                      'TempoOFF';
  CKeyGavSinalInvertido =                   'SinalInvertido';

  CSecBOLETO =                              'BOLETO';
  CKeyBOLETONome =                          'Nome';
  CKeyBOLETOCNPJCPF =                       'CNPJCPF';
  CKeyBOLETOLogradouro =                    'Logradouro';
  CKeyBOLETONumero =                        'Numero';
  CKeyBOLETOBairro =                        'Bairro';
  CKeyBOLETOCidade =                        'Cidade';
  CKeyBOLETOCEP =                           'CEP';
  CKeyBOLETOComplemento =                   'Complemento';
  CKeyBOLETOUF =                            'UF';
  CKeyBOLETORespEmis =                      'RespEmis';
  CKeyBOLETOPessoa =                        'Pessoa';
  CKeyBOLETOCodTransmissao =                'CodTransmissao';
  CKeyBOLETOModalidade =                    'Modalidade';
  CKeyBOLETOConvenio =                      'Convenio';
  CKeyBOLETOBanco =                         'Banco';
  CKeyBOLETOConta =                         'Conta';
  CKeyBOLETODigitoConta =                   'DigitoConta';
  CKeyBOLETOAgencia =                       'Agencia';
  CKeyBOLETODigitoAgencia =                 'DigitoAgencia';
  CKeyBOLETOCodCedente =                    'CodCedente';
  CKeyBOLETOLocalPagamento =                'LocalPagamento';
  CKeyBOLETODirLogos =                      'DirLogos';
  CKeyBOLETOCopias =                        'Copias';
  CKeyBOLETOPreview =                       'Preview';
  CKeyBOLETOProgresso =                     'Progresso';
  CKeyBOLETOSetup =                         'Setup';
  CKeyBOLETOLayout =                        'Layout';
  CKeyBOLETOFiltro =                        'Filtro';
  CKeyBOLETODirArquivoBoleto =              'DirArquivoBoleto';
  CKeyBOLETODirArquivoRemessa =             'DirArquivoRemessa';
  CKeyBOLETODirArquivoRetorno =             'DirArquivoRetorno';
  CKeyBOLETOCNAB =                          'CNAB';
  CKeyBOLETOLerCedenteRetorno =             'LerCedenteRetorno';
  CKeyBOLETOMostraPreviewRelRetorno =       'MostraPreviewRelRetorno';
  CKeyBOLETOLogoEmpresa =                   'LogoEmpresa';
  CKeyBOLETOEmailAssuntoBoleto =            'EmailAssuntoBoleto';
  CKeyBOLETOEmailMensagemBoleto =           'EmailMensagemBoleto';
  CKeyBOLETOImpressora =                    'Impressora';
  //Manter Compatibilidade
  CKeyBOLETOCedenteNome =                   'Cedente.Nome';
  CKeyBOLETOCedenteCNPJCPF =                'Cedente.CNPJCPF';
  CKeyBOLETOCedenteLogradouro =             'Cedente.Logradouro';
  CKeyBOLETOCedenteNumero =                 'Cedente.Numero';
  CKeyBOLETOCedenteBairro =                 'Cedente.Bairro';
  CKeyBOLETOCedenteCidade =                 'Cedente.Cidade';
  CKeyBOLETOCedenteCEP =                    'Cedente.CEP';
  CKeyBOLETOCedenteComplemento =            'Cedente.Complemento';
  CKeyBOLETOCedenteUF =                     'Cedente.UF';
  CKeyBOLETOCedenteRespEmis =               'Cedente.RespEmis';
  CKeyBOLETOCedentePessoa =                 'Cedente.Pessoa';
  CKeyBOLETOCedenteCodTransmissao =         'Cedente.CodTransmissao';
  CKeyBOLETOCedenteModalidade =             'Cedente.Modalidade';
  CKeyBOLETOCedenteConvenio =               'Cedente.Convenio';

  CValueTipoEmpregador =                    'tePessoaJuridica';
  CValueTipoContribuinte =                  'tcPessoaJuridica';
  CvalueVersaoeSocial =                     '02_04_02';
  CvalueVersaoReinf =                       '1_03_02';
  CvalueVersaoQRCode =                      '0';


implementation

end.

