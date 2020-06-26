{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrPOSPGWebAPI;

interface

uses
  Classes, SysUtils, syncobjs,
  ACBrTEFPayGoComum, ACBrBase;

resourcestring
  sErrTransacaoNaoIniciada = 'N�o foi iniciada uma Transa��o TEF';
  sErrTransacaoJaIniciada = 'J� foi iniciada uma Transa��o TEF';
  sErrLibJaInicializada = 'Biblioteca PTI_DLL j� foi inicializada';
  sErrEventoNaoAtribuido = 'Evento %s n�o atribuido';
  sErrSemComprovante = 'N�o h� Comprovante a ser impresso';
  sErrPTIRET_UNKNOWN = 'Erro %d executando %s';
  sErrPTIRET_INVPARAM = 'Par�metro inv�lido informado � fun��o';
  sErrPTIRET_NOCONN = 'O terminal %s est� offline.';
  sErrPTIRET_SOCKETERR = 'Erro ao iniciar a escuta da porta TCP %d.';
  sErrPTIRET_WRITEERR = 'Falha de grava��o no diret�rio %s';
  sErrPTIRET_BUSY = 'O terminal %s est� ocupado processando outro comando.';
  sErrPTIRET_SECURITYERR = 'A fun��o foi rejeitada por quest�es de seguran�a.';
  sErrPTIRET_NOTSUPPORTED = 'Fun��o n�o suportada pelo terminal';
  sErrPTIRET_PRINTERR = 'Erro na impressora.';
  sErrPTIRET_NOPAPER = 'Impressora sem papel.';
  sErrPTIRET_INTERNALERR = 'Erro interno da biblioteca de integra��o.';
  sErrPTIRET_EFTERR = 'A transa��o foi realizada, entretanto falhou';
  sErrPTIRET_BUFOVRFLW = 'O tamanho do dado � maior que o Buffer alocado';


const
  CACBrPOSPGWebAPIName = 'ACBrPOSPGWebAPI';
  CACBrPOSPGWebAPIVersao = '1.0.0';
  CACBrPOSPGWebSubDir = 'POSPGWeb';
  CACBrPOSPGWebColunasDisplay = 20;
  CACBrPOSPGWebColunasImpressora = 40;
  CACBrPOSPGWebPortaTCP = 3433;
  CACBrPOSPGWebMaxTerm = 100;
  CACBrPOSPGWebTempoDesconexao = 30;  // Segundos
  CACBrPOSPGWebEsperaLoop = 500;  // Milissegundos
  CACBrPOSPGWebBoasVindas = 'CONECTADO A '+CACBrPOSPGWebAPIName + ' '+ CACBrPOSPGWebAPIVersao;

  {$IFDEF MSWINDOWS}
   CACBrPOSPGWebLib = 'PTI_DLL.dll';
  {$ELSE}
   CACBrPOSPGWebLib = 'PTI_DLL.so';
  {$ENDIF}

//==========================================================================================
//  Tabela de C�digos de Erro de Retorno da Biblioteca
//==========================================================================================
  PTIRET_OK           = 0;      // Opera��o bem-sucedida
  PTIRET_INVPARAM     = -2001;  // Par�metro inv�lido informado � fun��o.
  PTIRET_NOCONN       = -2002;  // O terminal est� offline
  PTIRET_BUSY         = -2003;  // O terminal est� ocupado processando outro comando.
  PTIRET_TIMEOUT      = -2004;  // Usu�rio falhou ao pressionar uma tecla durante o tempo especificado
  PTIRET_CANCEL       = -2005;  // Usu�rio pressionou a tecla [CANCELA].
  PTIRET_NODATA       = -2006;  // Informa��o requerida n�o dispon�vel
  PTIRET_BUFOVRFLW    = -2007;  // Dados maiores que o tamanho do buffer fornecido
  PTIRET_SOCKETERR    = -2008;  // Impossibilitado de iniciar escuta das portas TCP especificadas
  PTIRET_WRITEERR     = -2009;  // Impossibilitado de utilizar o diret�rio especificado
  PTIRET_EFTERR       = -2010;  // A opera��o financeira foi completada, por�m falhou
  PTIRET_INTERNALERR  = -2011;  // Erro interno da biblioteca de integra��o
  PTIRET_PROTOCOLERR  = -2012;  // Erro de comunica��o entre a biblioteca de integra��o e o terminal
  PTIRET_SECURITYERR  = -2013;  // A fun��o falhou por quest�es de seguran�a
  PTIRET_PRINTERR     = -2014;  // Erro na impressora
  PTIRET_NOPAPER      = -2015;  // Impressora sem papel
  PTIRET_NEWCONN      = -2016;  // Novo terminal conectado
  PTIRET_NONEWCONN    = -2017;  // Sem recebimento de novas conex�es.
  PTIRET_NOTSUPPORTED = -2057;  // Fun��o n�o suportada pelo terminal.
  PTIRET_CRYPTERR     = -2058;  // Erro na criptografia de dados (comunica��o entre a biblioteca de integra��o e o terminal).

//==========================================================================================
// Definicoes das teclas do POS
//==========================================================================================
  PTIKEY_BACKSP  = 8;
  PTIKEY_OK      = 13;
  PTIKEY_CANCEL  = 27;
  PTIKEY_HASH    = 35; // '#'
  PTIKEY_STAR    = 42; // '*'
  PTIKEY_DOT     = 46; // '.'
  PTIKEY_0       = 48;
  PTIKEY_1       = 49;
  PTIKEY_2       = 50;
  PTIKEY_3       = 51;
  PTIKEY_4       = 52;
  PTIKEY_5       = 53;
  PTIKEY_6       = 54;
  PTIKEY_7       = 55;
  PTIKEY_8       = 56;
  PTIKEY_9       = 57;
  PTIKEY_00      = 37; // '00'
  PTIKEY_FUNC0   = 97;
  PTIKEY_FUNC1   = 98;
  PTIKEY_FUNC2   = 99;
  PTIKEY_FUNC3   = 100;
  PTIKEY_FUNC4   = 101;
  PTIKEY_FUNC5	 = 102;
  PTIKEY_FUNC6	 = 103;
  PTIKEY_FUNC7	 = 104;
  PTIKEY_FUNC8	 = 105;
  PTIKEY_FUNC9	 = 106;
  PTIKEY_FUNC10	 = 107;
  PTIKEY_TOUCH   = 126;
  PTIKEY_ALPHA   = 38;

type
  EACBrPOSPGWeb = class(Exception);

  TACBrPOSPGWebOperacao = (
    PWOPER_SALE = 33,      // Pagamento de mercadorias ou servi�os.
    PWOPER_ADMIN = 32,     // Qualquer transa��o que n�o seja um pagamento (estorno, pr�-autoriza��o, consulta, relat�rio, reimpress�o de recibo, etc.).
    PWOPER_SALEVOID = 34); // 22h Estorna uma transa��o de venda que foi previamente realizada e confirmada.

  TACBrPOSPGWebBeep = (
     PTIBEEP_OK,      // 0 Sucesso
     PTIBEEP_WARNING, // 1 Alerta
     PTIBEEP_ERROR);  // 2 Erro

  TACBrPOSPGWebEstadoTerminal = (
     PTISTAT_IDLE,       // 0 Terminal est� on-line e aguardando por comandos.
     PTISTAT_BUSY,       // 1 Terminal est� on-line, por�m ocupado processando um comando.
     PTISTAT_NOCONN,     // 2 Terminal est� offline.
     PTISTAT_WAITRECON); // 3 Terminal est� off-line. A transa��o continua sendo executada e ap�s sua finaliza��o, o terminal tentar� efetuar a reconex�o automaticamente

  TACBrPOSPGWebCodBarras = (
     CODESYMB_128 = 2, // C�digo de barras padr�o 128. Pode-se utilizar aproximadamente 31 caracteres alfanum�ricos.
     CODESYMB_ITF = 3, // C�digo de barras padr�o ITF. Pode-se utilizar aproximadamente 30 caracteres alfanum�ricos.
     CODESYMB_QRCODE = 4); // QR Code. Com aceita��o de aproximadamente 600 caracteres alfanum�ricos.

  TACBrPOSPGWebComprovantes = (
     PTIPRN_NONE,      // 0 - N�o imprimir
     PTIPRN_MERCHANT,  // 1 - Via do estabelecimento
     PTIPRN_CHOLDER,   // 2 - Via do portador do cart�o
     PTIPRN_BOTH);     // 3 - Ambas as Vias

  TACBrPOSPGWebStatusTransacao = (
     PTICNF_SUCCESS = 1,    // Transa��o confirmada.
     PTICNF_PRINTERR = 2,   // Erro na impressora, desfazer a transa��o.
     PTICNF_DISPFAIL = 3,   // Erro com o mecanismo dispensador, desfazer a transa��o.
     PTICNF_OTHERERR = 4);  // Outro erro, desfazer a transa��o.

  TACBrPOSPGWebAPI = class;

  TACBrPOSPGWebNovaConexao = procedure(const TerminalId: String; const Model: String;
      const MAC: String; const SerNo: String) of object;

  TACBrPOSPGWebNovoEstadoTerminal = procedure(const TerminalId: String;
      EstadoAtual, EstadoAnterior: TACBrPOSPGWebEstadoTerminal) of object;

  { TACBrPOSPGWebConexao }

  TACBrPOSPGWebConexao = class(TThread)
    fPOSPGWeb: TACBrPOSPGWebAPI;
    fTerminalId: String;
    fModel: String;
    fMAC: String;
    fSerNo: String;
    fEstado, fEstadoAnterior: TACBrPOSPGWebEstadoTerminal;
    fUltimaLeituraEstado: TDateTime;
  private
    function GetEstado: TACBrPOSPGWebEstadoTerminal;
    procedure SetEstado(AValue: TACBrPOSPGWebEstadoTerminal);
  protected
    procedure Execute; override;
    procedure Terminate;
    procedure AvisarMudancaDeEstado;

  public
    constructor Create(POSPGWeb: TACBrPOSPGWebAPI; const TerminalId: String;
      const Model: String; const MAC: String; const SerNo: String);
    destructor Destroy; override;

    property TerminalId: String read fTerminalId;
    property Model: String read fModel;
    property MAC: String read fMAC;
    property SerNo: String read fSerNo;

    property Estado: TACBrPOSPGWebEstadoTerminal read GetEstado write SetEstado;
  end;

  { TACBrPOSPGWebAPI }

  TACBrPOSPGWebAPI = class
  private
    fOnMudaEstadoTerminal: TACBrPOSPGWebNovoEstadoTerminal;
    fOnNovaConexao: TACBrPOSPGWebNovaConexao;
    fTimerConexao: TACBrThreadTimer;
    fListaConexoes: TThreadList;
    fDadosTransacao: TACBrTEFPGWebAPIParametros;
    fParametrosAdicionais: TACBrTEFPGWebAPIParametros;
    fLogCriticalSection: TCriticalSection;
    fpszTerminalId, fpszModel, fpszMAC, fpszSerNo: PAnsiChar;
    fInicializada: Boolean;
    fEmTransacao: Boolean;
    fEmConnectionLoop: Boolean;
    fCNPJEstabelecimento: String;
    fDiretorioTrabalho: String;
    ffMensagemBoasVindas: String;
    fImprimirViaClienteReduzida: Boolean;
    fNomeAplicacao: String;
    fOnGravarLog: TACBrGravarLog;
    fPathDLL: String;
    fPortaTCP: Word;
    fMaximoTerminaisConectados: Word;
    fTempoDesconexaoAutomatica: Word;
    fMensagemBoasVindas: String;
    fSoftwareHouse: String;
    fSuportaDesconto: Boolean;
    fSuportaSaque: Boolean;
    fSuportaViasDiferenciadas: Boolean;
    fUtilizaSaldoTotalVoucher: Boolean;
    fVersaoAplicacao: String;

    xPTI_Init: procedure( pszPOS_Company: AnsiString; pszPOS_Version: AnsiString;
      pszPOS_Capabilities: AnsiString; pszDataFolder: AnsiString; uiTCP_Port: Word;
      uiMaxTerminals: Word; pszWaitMsg: AnsiString; uiAutoDiscSec: Word;
      var piRet: SmallInt); cdecl;
    xPTI_End: procedure(); cdecl;
    xPTI_ConnectionLoop: procedure(pszTerminalId: PAnsiChar; pszModel: PAnsiChar;
      pszMAC: PAnsiChar; pszSerNo: PAnsiChar; out piRet: SmallInt); cdecl;
    xPTI_CheckStatus: procedure(pszTerminalId: AnsiString; out piStatus: SmallInt;
      pszModel: PAnsiChar; pszMAC: PAnsiChar; pszSerNo: PAnsiChar;
      out piRet: SmallInt); cdecl;
    xPTI_Disconnect: procedure(pszTerminalId: AnsiString; uiPwrDelay: Word;
      out piRet: SmallInt); cdecl;
    xPTI_Display: procedure(pszTerminalId: AnsiString; pszMsg: AnsiString;
      out piRet: SmallInt); cdecl;
    xPTI_WaitKey: procedure(pszTerminalId: AnsiString; uiTimeOutSec: Word;
      out piKey: SmallInt; out piRet: SmallInt); cdecl;
    xPTI_ClearKey: procedure(pszTerminalId: AnsiString; out piRet: SmallInt); cdecl;
    xPTI_GetData: procedure(pszTerminalId: AnsiString; pszPrompt: AnsiString;
      pszFormat: AnsiString; uiLenMin: Word; uiLenMax: Word; fFromLeft: Boolean;
      fAlpha: Boolean; fMask: Boolean; uiTimeOutSec: Word; pszData: PAnsiChar;
      uiCaptureLine: Word; out piRet: SmallInt); cdecl;
    xPTI_StartMenu: procedure(pszTerminalId: AnsiString; out piRet: SmallInt); cdecl;
    xPTI_AddMenuOption: procedure(pszTerminalId: AnsiString; pszOption: AnsiString;
      out piRet: SmallInt); cdecl;
    xPTI_ExecMenu: procedure(pszTerminalId: AnsiString; pszPrompt: AnsiString;
      uiTimeOutSec: Word; var puiSelection: SmallInt; out piRet: SmallInt); cdecl;
    xPTI_Beep: procedure(pszTerminalId: AnsiString; iType: SmallInt;
      out piRet: SmallInt); cdecl;
    xPTI_Print: procedure(pszTerminalId: AnsiString; pszText: AnsiString;
      out piRet: SmallInt); cdecl;
    xPTI_PrnFeed: procedure(pszTerminalId: AnsiString; out piRet: SmallInt); cdecl;
    xPTI_PrnSymbolCode: procedure(pszTerminalId: AnsiString; pszMsg: AnsiString;
      iSymbology: SmallInt; out piRet: SmallInt); cdecl;
    xPTI_EFT_Start: procedure(pszTerminalId: AnsiString; iOper: SmallInt;
      out piRet: SmallInt); cdecl;
    xPTI_EFT_AddParam: procedure(pszTerminalId: AnsiString; iParam: Word;
      pszValue: AnsiString; out piRet: SmallInt); cdecl;
    xPTI_EFT_Exec: procedure(pszTerminalId: AnsiString; out piRet: SmallInt); cdecl;
    xPTI_EFT_GetInfo: procedure(pszTerminalId: AnsiString; iInfo: Word; uiBufLen: Word;
      pszValue: PAnsiChar; out piRet: SmallInt); cdecl;
    xPTI_EFT_PrintReceipt: procedure(pszTerminalId: AnsiString; iCopies: Word;
      out piRet: SmallInt); cdecl;
    xPTI_EFT_Confirm: procedure(pszTerminalId: AnsiString; iStatus: SmallInt;
      out piRet: SmallInt) cdecl;

    procedure SetDiretorioTrabalho(AValue: String);
    procedure SetInicializada(AValue: Boolean);
    procedure SetNomeAplicacao(AValue: String);
    procedure SetPathDLL(AValue: String);
    procedure SetSoftwareHouse(AValue: String);
    procedure SetVersaoAplicacao(AValue: String);

    procedure OnAguardaConexao(Sender: TObject);

  protected
    procedure LoadDLLFunctions;
    procedure UnLoadDLLFunctions;
    procedure ClearMethodPointers;

    procedure DoException( AErrorMsg: String );

    function CalcularCapacidadesDaAutomacao: Integer;
    function FormatarMensagem(const AMsg: String; Colunas: Word): String;
    procedure AvaliarErro(iRet: SmallInt; const TerminalId: String);
    procedure VerificarTransacaoFoiIniciada;
    procedure AjustarEstadoConexao(const TerminalId: String; NovoEstado: TACBrPOSPGWebEstadoTerminal);
    procedure TerminarConexao(const TerminalId: String);

    property ListaConexoes: TThreadList read fListaConexoes;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Inicializar;
    procedure DesInicializar;

    procedure GravarLog(const AString: AnsiString; Traduz: Boolean = False);

    procedure ExibirMensagem(const TerminalId: String; const AMensagem: String);
    procedure LimparTeclado(const TerminalId: String);
    function AguardarTecla(const TerminalId: String; Espera: Word = 0): Integer;
    function ObterDado(const TerminalId: String; const Titulo: String;
      const Mascara: String = ''; uiLenMin: Word = 1; uiLenMax: Word = 20;
      AlinhaAEsqueda: Boolean = False; PermiteAlfa: Boolean = False;
      OcultarDigitacao: Boolean = False; IntervaloMaxTeclas: Word = 30;
      const ValorInicial: String = ''; LinhaCaptura: Word = 2): String;
    function ExecutarMenu(const TerminalId: String; Opcoes: TStrings;
      const Titulo: String = ''; IntervaloMaxTeclas: Word = 30;
      Opcao: SmallInt = 0): SmallInt;
    procedure Beep(const TerminalId: String; TipoBeep: TACBrPOSPGWebBeep = PTIBEEP_OK);
    procedure ImprimirTexto(const TerminalId: String; const ATexto: String);
    procedure AvancarPapel(const TerminalId: String);
    procedure ImprimirCodBarras(const TerminalId: String; const Codigo: String;
      Tipo: TACBrPOSPGWebCodBarras);
    procedure ImprimirComprovantesTEF(const TerminalId: String;
      Tipo: TACBrPOSPGWebComprovantes; IgnoraErroSemComprovante: Boolean = True);
    procedure ObterEstado(const TerminalId: String;
      out EstadoAtual: TACBrPOSPGWebEstadoTerminal;
      out Modelo: String; out MAC: String; out Serial: String); overload;
    function ObterEstado(const TerminalId: String): TACBrPOSPGWebEstadoTerminal; overload;

    procedure ExecutarTransacaoTEF(const TerminalId: String;
      Operacao: TACBrPOSPGWebOperacao;
      Comprovantes: TACBrPOSPGWebComprovantes = PTIPRN_BOTH;
      ParametrosAdicionaisTransacao: TStrings = nil);

    procedure IniciarTransacao(const TerminalId: String;
      Operacao: TACBrPOSPGWebOperacao;
      ParametrosAdicionaisTransacao: TStrings = nil);
    procedure AdicionarParametro(const TerminalId: String; iINFO: Word;
      const AValor: AnsiString); overload;
    procedure AdicionarParametro(const TerminalId: String; AKeyValueStr: String);
      overload;
    function ExecutarTransacao(const TerminalId: String): SmallInt;
    function ObterInfo(const TerminalId: String; iINFO: Word): String;
    function ObterUltimoRetorno(const TerminalId: String): String;
    procedure ObterDadosDaTransacao(const TerminalId: String);
    procedure FinalizarTrancao(const TerminalId: String; Status: TACBrPOSPGWebStatusTransacao);

    function Desconectar(const TerminalId: String; Segundos: Word = 0): Boolean;

    property PathDLL: String read fPathDLL write SetPathDLL;
    property DiretorioTrabalho: String read fDiretorioTrabalho write SetDiretorioTrabalho;
    property Inicializada: Boolean read fInicializada write SetInicializada;
    property EmTransacao: Boolean read fEmTransacao;

    property DadosDaTransacao: TACBrTEFPGWebAPIParametros read fDadosTransacao;

    property SoftwareHouse: String read fSoftwareHouse write SetSoftwareHouse;
    property NomeAplicacao: String read fNomeAplicacao write SetNomeAplicacao ;
    property VersaoAplicacao: String read fVersaoAplicacao write SetVersaoAplicacao ;

    property PortaTCP: Word read fPortaTCP write fPortaTCP;
    property MaximoTerminaisConectados: Word read fMaximoTerminaisConectados write fMaximoTerminaisConectados;
    property TempoDesconexaoAutomatica: Word read fTempoDesconexaoAutomatica write fTempoDesconexaoAutomatica;
    property MensagemBoasVindas: String read fMensagemBoasVindas write ffMensagemBoasVindas;
    property ParametrosAdicionais: TACBrTEFPGWebAPIParametros read fParametrosAdicionais;

    Property SuportaSaque: Boolean read fSuportaSaque write fSuportaSaque;
    Property SuportaDesconto: Boolean read fSuportaDesconto write fSuportaDesconto;
    property ImprimirViaClienteReduzida : Boolean read fImprimirViaClienteReduzida
      write fImprimirViaClienteReduzida;
    property SuportaViasDiferenciadas: Boolean read fSuportaViasDiferenciadas
      write fSuportaViasDiferenciadas;
    property UtilizaSaldoTotalVoucher: Boolean read fUtilizaSaldoTotalVoucher
      write fUtilizaSaldoTotalVoucher;

    property OnGravarLog: TACBrGravarLog read fOnGravarLog write fOnGravarLog;
    property OnNovaConexao: TACBrPOSPGWebNovaConexao read fOnNovaConexao write fOnNovaConexao;
    property OnMudaEstadoTerminal: TACBrPOSPGWebNovoEstadoTerminal read fOnMudaEstadoTerminal
      write fOnMudaEstadoTerminal;
  end;

function PTIRETToString(iRET: SmallInt): String;

implementation

uses
  strutils, math, dateutils,
  ACBrUtil, ACBrConsts;

function PTIRETToString(iRET: SmallInt): String;
begin
  case iRET of
    PTIRET_OK:           Result := 'PTIRET_OK';
    PTIRET_INVPARAM:     Result := 'PTIRET_INVPARAM';
    PTIRET_NOCONN:       Result := 'PTIRET_NOCONN';
    PTIRET_BUSY:         Result := 'PTIRET_BUSY';
    PTIRET_TIMEOUT:      Result := 'PTIRET_TIMEOUT';
    PTIRET_CANCEL:       Result := 'PTIRET_CANCEL';
    PTIRET_NODATA:       Result := 'PTIRET_NODATA';
    PTIRET_BUFOVRFLW:    Result := 'PTIRET_BUFOVRFLW';
    PTIRET_SOCKETERR:    Result := 'PTIRET_SOCKETERR';
    PTIRET_WRITEERR:     Result := 'PTIRET_WRITEERR';
    PTIRET_EFTERR:       Result := 'PTIRET_EFTERR';
    PTIRET_INTERNALERR:  Result := 'PTIRET_INTERNALERR';
    PTIRET_PROTOCOLERR:  Result := 'PTIRET_PROTOCOLERR';
    PTIRET_SECURITYERR:  Result := 'PTIRET_SECURITYERR';
    PTIRET_PRINTERR:     Result := 'PTIRET_PRINTERR';
    PTIRET_NOPAPER:      Result := 'PTIRET_NOPAPER';
    PTIRET_NEWCONN:      Result := 'PTIRET_NEWCONN';
    PTIRET_NONEWCONN:    Result := 'PTIRET_NONEWCONN';
    PTIRET_NOTSUPPORTED: Result := 'PTIRET_NOTSUPPORTED';
    PTIRET_CRYPTERR:     Result := 'PTIRET_CRYPTERR';
  else
    Result := 'PTIRET_'+IntToStr(iRET);
  end;
end;

{ TACBrPOSPGWebConexao }

constructor TACBrPOSPGWebConexao.Create(POSPGWeb: TACBrPOSPGWebAPI;
  const TerminalId: String; const Model: String; const MAC: String;
  const SerNo: String);
begin
  FreeOnTerminate := True;
  inherited Create(False); // CreateSuspended;

  fPOSPGWeb := POSPGWeb;
  fTerminalId := TerminalId;
  fModel := Model;
  fMAC := MAC;
  fSerNo := SerNo;

  fEstado := PTISTAT_NOCONN;
  fEstadoAnterior := PTISTAT_NOCONN;
  fUltimaLeituraEstado := 0;

  fPOSPGWeb.ListaConexoes.Add(Self);
  SetEstado(PTISTAT_IDLE);
end;

destructor TACBrPOSPGWebConexao.Destroy;
begin
  fPOSPGWeb.ListaConexoes.Remove(Self);
  inherited Destroy;
end;

procedure TACBrPOSPGWebConexao.Execute;
begin
  // ATEN��O: Todo o c�digo do Evento OnNovaConexao deve ser Thread Safe
  try
    fPOSPGWeb.OnNovaConexao(fTerminalId, fModel, fMAC, fSerNo);
  finally
    Terminate;
  end;
end;

procedure TACBrPOSPGWebConexao.Terminate;
begin
  try
    fPOSPGWeb.Desconectar(TerminalId);
  except
    { Ignora erros }
  end;

  inherited Terminate;
end;

function TACBrPOSPGWebConexao.GetEstado: TACBrPOSPGWebEstadoTerminal;
var
  NovoEstado: TACBrPOSPGWebEstadoTerminal;
begin
  // For�a a leitura do Estado, se n�o for Idle ou a cada 5 segundos
  if (fEstado <> PTISTAT_IDLE) or (SecondsBetween(fUltimaLeituraEstado, Now) > 5) then
  begin
    fPOSPGWeb.ObterEstado(fTerminalId, NovoEstado, fModel, fMAC, fSerNo);
    SetEstado(NovoEstado);
  end;

  Result := fEstado;
end;

procedure TACBrPOSPGWebConexao.SetEstado(AValue: TACBrPOSPGWebEstadoTerminal);
begin
  if (AValue <> fEstado) then
  begin
    fEstadoAnterior := fEstado;
    fEstado := AValue;
    fUltimaLeituraEstado := Now;
    if Assigned(fPOSPGWeb.OnMudaEstadoTerminal) then
      Synchronize(AvisarMudancaDeEstado);
  end;
end;

procedure TACBrPOSPGWebConexao.AvisarMudancaDeEstado;
begin
  if Assigned(fPOSPGWeb.OnMudaEstadoTerminal) then
    fPOSPGWeb.OnMudaEstadoTerminal(fTerminalId, fEstado, fEstadoAnterior);
end;


{ TACBrPOSPGWebAPI }

constructor TACBrPOSPGWebAPI.Create;
begin
  inherited Create;
  ClearMethodPointers;

  fSuportaViasDiferenciadas := True;
  fUtilizaSaldoTotalVoucher := False;
  fSuportaDesconto := False;
  fSuportaSaque := False;
  fImprimirViaClienteReduzida := False;

  fCNPJEstabelecimento := '';
  fNomeAplicacao := '';
  fSoftwareHouse := '';
  fVersaoAplicacao := '';

  fDiretorioTrabalho := '';
  fPortaTCP := CACBrPOSPGWebPortaTCP;
  fMaximoTerminaisConectados := CACBrPOSPGWebMaxTerm;
  fTempoDesconexaoAutomatica := CACBrPOSPGWebTempoDesconexao;
  fMensagemBoasVindas := CACBrPOSPGWebBoasVindas;
  fPathDLL := '';

  fpszTerminalId := AllocMem(50);
  fpszModel := AllocMem(50);
  fpszMAC := AllocMem(50);
  fpszSerNo := AllocMem(50);
  fEmTransacao := False;
  fEmConnectionLoop := False;
  fInicializada := False;

  fDadosTransacao := TACBrTEFPGWebAPIParametros.Create;
  fParametrosAdicionais := TACBrTEFPGWebAPIParametros.Create;
  fListaConexoes := TThreadList.Create;
  fTimerConexao := TACBrThreadTimer.Create;
  fTimerConexao.Interval := CACBrPOSPGWebEsperaLoop;
  fTimerConexao.Enabled := False;

  fLogCriticalSection := TCriticalSection.Create;
  fOnGravarLog := Nil;
  fOnNovaConexao := Nil;
  fOnMudaEstadoTerminal := Nil;
end;

destructor TACBrPOSPGWebAPI.Destroy;
begin
  DesInicializar;
  Sleep(CACBrPOSPGWebEsperaLoop);  // Aguarda, caso esteja dentro do Evento "OnAguardaConexao"

  Freemem(fpszTerminalId);
  Freemem(fpszModel);
  Freemem(fpszMAC);
  Freemem(fpszSerNo);

  fLogCriticalSection.Free;
  fDadosTransacao.Free;
  fParametrosAdicionais.Free;
  fListaConexoes.Free;
  fTimerConexao.Free;

  inherited Destroy;
end;

procedure TACBrPOSPGWebAPI.DoException(AErrorMsg: String);
begin
  if (Trim(AErrorMsg) = '') then
    Exit;

  GravarLog('EACBrPOSPGWeb: '+AErrorMsg);
  raise EACBrPOSPGWeb.Create(AErrorMsg);
end;

procedure TACBrPOSPGWebAPI.GravarLog(const AString: AnsiString;
  Traduz: Boolean);
Var
  Tratado: Boolean;
  AStringLog: AnsiString;
begin
  if not Assigned(fOnGravarLog) then
    Exit;

  fLogCriticalSection.Acquire;
  try
    if Traduz then
      AStringLog := TranslateUnprintable(AString)
    else
      AStringLog := AString;

    Tratado := False;
    fOnGravarLog(AStringLog, Tratado);
  finally
    fLogCriticalSection.Release;
  end;
end;

procedure TACBrPOSPGWebAPI.Inicializar;
var
  iRet: SmallInt;
  MsgError, AMsgBoasVindas: String;
  POSCapabilities: Integer;
begin
  if fInicializada then
    Exit;

  GravarLog('TACBrPOSPGWebAPI.Inicializar');

  if not Assigned(fOnNovaConexao) then
    DoException(Format(ACBrStr(sErrEventoNaoAtribuido), ['OnNovaConexao']));

  if (fDiretorioTrabalho = '') then
    fDiretorioTrabalho := ApplicationPath  + CACBrPOSPGWebSubDir;

  LoadDLLFunctions;
  if not DirectoryExists(fDiretorioTrabalho) then
    ForceDirectories(fDiretorioTrabalho);

  POSCapabilities := CalcularCapacidadesDaAutomacao;
  AMsgBoasVindas := FormatarMensagem(fMensagemBoasVindas, CACBrPOSPGWebColunasDisplay);

  GravarLog('PTI_Init( '+fSoftwareHouse+', '+
                         fNomeAplicacao+' '+fVersaoAplicacao+', '+
                         IntToStr(POSCapabilities)+', '+
                         fDiretorioTrabalho+', '+
                         IntToStr(fPortaTCP)+', '+
                         IntToStr(fMaximoTerminaisConectados)+', '+
                         AMsgBoasVindas+', '+
                         IntToStr(fTempoDesconexaoAutomatica)+' )', True);

  iRet := 0;
  xPTI_Init( fSoftwareHouse,
             fNomeAplicacao + ' ' + fVersaoAplicacao,
             IntToStr(POSCapabilities),
             fDiretorioTrabalho,
             fPortaTCP, fMaximoTerminaisConectados,
             AMsgBoasVindas,
             fTempoDesconexaoAutomatica,
             iRet );
  GravarLog('  '+PTIRETToString(iRet));
  case iRet of
    PTIRET_OK: MsgError := '';
    PTIRET_INVPARAM: MsgError := sErrPTIRET_INVPARAM;
    PTIRET_SOCKETERR: MsgError := Format(sErrPTIRET_SOCKETERR, [fPortaTCP]);
    PTIRET_WRITEERR: MsgError := Format(sErrPTIRET_WRITEERR, [fDiretorioTrabalho]);
  else
    MsgError := Format(sErrPTIRET_UNKNOWN, [iRet, 'PTI_Init']);
  end;

  if (MsgError <> '') then
    DoException(ACBrStr(MsgError));

  fInicializada := True;
  fTimerConexao.OnTimer := OnAguardaConexao;
  fTimerConexao.Enabled := True;
end;

procedure TACBrPOSPGWebAPI.DesInicializar;
var
  Alist: TList;
  i: Integer;
begin
  if not fInicializada then
    Exit;

  GravarLog('TACBrPOSPGWebAPI.DesInicializar');
  fTimerConexao.Enabled := False;
  fTimerConexao.OnTimer := Nil;

  Alist := fListaConexoes.LockList;
  try
    for i := 0 to Alist.Count-1 do
      TACBrPOSPGWebConexao(Alist[i]).Terminate;
  finally
    fListaConexoes.UnlockList;
  end;

  UnLoadDLLFunctions;
  fInicializada := False;
end;

procedure TACBrPOSPGWebAPI.SetInicializada(AValue: Boolean);
begin
  if (fInicializada = AValue) then
    Exit;

  GravarLog('TACBrPOSPGWebAPI.SetInicializada( '+BoolToStr(AValue, True)+' )');

  if AValue then
    Inicializar
  else
    DesInicializar;
end;

procedure TACBrPOSPGWebAPI.ExibirMensagem(const TerminalId: String;
  const AMensagem: String);
var
  iRet: SmallInt;
  MsgFormatada: String;
begin
  MsgFormatada := FormatarMensagem(AMensagem, CACBrPOSPGWebColunasDisplay);
  GravarLog('PTI_Display( '+TerminalId+', '+MsgFormatada+' )', True);
  xPTI_Display( TerminalId, MsgFormatada, iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.LimparTeclado(const TerminalId: String);
var
  iRet: SmallInt;
begin
  GravarLog('PTI_ClearKey( '+TerminalId+' )');
  xPTI_ClearKey( TerminalId, iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

function TACBrPOSPGWebAPI.AguardarTecla(const TerminalId: String; Espera: Word
  ): Integer;
var
  iRet, iKey: SmallInt;
begin
  GravarLog('PTI_WaitKey( '+TerminalId+', '+IntToStr(Integer(Espera))+' )');
  xPTI_WaitKey( TerminalId, Espera, iKey, iRet);
  GravarLog('  '+PTIRETToString(iRet)+', '+IntToStr(iKey));
  if (iRet = PTIRET_OK) then
    Result := iKey
  else if (iRet = PTIRET_TIMEOUT) then
    Result := 0
  else
    AvaliarErro(iRet, TerminalId);
end;

function TACBrPOSPGWebAPI.ObterDado(const TerminalId: String;
  const Titulo: String; const Mascara: String; uiLenMin: Word; uiLenMax: Word;
  AlinhaAEsqueda: Boolean; PermiteAlfa: Boolean; OcultarDigitacao: Boolean;
  IntervaloMaxTeclas: Word; const ValorInicial: String; LinhaCaptura: Word
  ): String;
var
  iRet: SmallInt;
  pszData: PAnsiChar;
begin
  GravarLog('PTI_GetData( '+TerminalId+', Titulo:'+Titulo+', Mascara:'+Mascara+', '+
                          'TamMin: '+IntToStr(uiLenMin)+', TamMax:'+IntToStr(uiLenMax)+', '+
                          'AlinhaAEsqueda: '+ifthen(AlinhaAEsqueda,'S','N')+', '+
                          'PermiteAlfa: '+ifthen(PermiteAlfa,'S','N')+', '+
                          'OcultarDigitacao: '+ifthen(OcultarDigitacao,'S','N')+', '+
                          'Intervalo: '+IntToStr(IntervaloMaxTeclas)+', '+
                          'Valor: '+ValorInicial+', Linha:'+IntToStr(LinhaCaptura)+' )');

  Result := '';
  pszData := AllocMem(50);
  try
    Move(ValorInicial[1], pszData, Length(ValorInicial)+1 );
    xPTI_GetData( TerminalId,
                  Titulo,
                  Mascara,
                  uiLenMin, uiLenMax,
                  AlinhaAEsqueda, PermiteAlfa, OcultarDigitacao,
                  IntervaloMaxTeclas,
                  pszData,
                  LinhaCaptura,
                  iRet);
    GravarLog('  '+PTIRETToString(iRet)+', '+Result);
    if (iRet = PTIRET_OK) then
      Result := String(pszData)
    else if (iRet <> PTIRET_TIMEOUT) or (iRet <> PTIRET_CANCEL) then
      AvaliarErro(iRet, TerminalId);
  finally
    Freemem(pszData);
  end;
end;

function TACBrPOSPGWebAPI.ExecutarMenu(const TerminalId: String;
  Opcoes: TStrings; const Titulo: String; IntervaloMaxTeclas: Word;
  Opcao: SmallInt): SmallInt;
var
  iRet: SmallInt;
  i: Integer;
  pszPrompt, pszOption: AnsiString;
begin
  Result := -1;
  if (not Assigned(Opcoes)) or (Opcoes.Count < 1) then
    Exit;

  GravarLog('PTI_StartMenu( '+TerminalId+' )');
  xPTI_StartMenu( TerminalId, iRet );
  GravarLog('  '+PTIRETToString(iRet));

  i := 0;
  while (iRet = PTIRET_OK)  and (i < Opcoes.Count) do
  begin
    pszOption := LeftStr(Opcoes[i], 18);
    GravarLog('PTI_AddMenuOption( '+TerminalId+', '+pszOption+' )');
    xPTI_AddMenuOption( TerminalId,
                        pszOption,
                        iRet );
    GravarLog('  '+PTIRETToString(iRet));
    Inc(i);
  end;

  if (iRet = PTIRET_OK) then
  begin
    Opcao := min( max(0, Opcao), Opcoes.Count-1);
    pszPrompt := LeftStr(Titulo,20);
    GravarLog('PTI_ExecMenu( '+TerminalId+', '+pszPrompt+', '+
                              IntToStr(IntervaloMaxTeclas)+', '+
                              IntToStr(Opcao)+' )');
    xPTI_ExecMenu( TerminalId,
                   pszPrompt,
                   IntervaloMaxTeclas,
                   Opcao, iRet );
    GravarLog('  '+PTIRETToString(iRet)+', Opcao: '+IntToStr(Opcao));
  end;

  if (iRet = PTIRET_OK) then
    Result := Opcao
  else if (iRet = PTIRET_TIMEOUT) or (iRet = PTIRET_CANCEL) then
    Result := -1
  else
    AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.Beep(const TerminalId: String;
  TipoBeep: TACBrPOSPGWebBeep);
var
  iRet: SmallInt;
begin
  GravarLog('PTI_Beep( '+TerminalId+', '+IntToStr(Integer(TipoBeep))+' )');
  xPTI_Beep( TerminalId, SmallInt(TipoBeep), iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.ImprimirTexto(const TerminalId: String;
  const ATexto: String);
var
  iRet: SmallInt;
  TextoFormatado: String;
begin
  // Trocando Tag <e> por \v ou #11, para Expandido. Deve ser o Primeiro caracter da Linha
  TextoFormatado := StringReplace(ATexto, '<e>', #11, [rfReplaceAll]);
  TextoFormatado := StringReplace(ATexto, '<E>', #11, [rfReplaceAll]);
  // Formatando no limite de Colunas
  TextoFormatado := FormatarMensagem(TextoFormatado, CACBrPOSPGWebColunasImpressora);

  GravarLog('PTI_Print( '+TerminalId+', '+TextoFormatado+' )', True);
  xPTI_Print( TerminalId,
              TextoFormatado,
              iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.AvancarPapel(const TerminalId: String);
var
  iRet: SmallInt;
begin
  GravarLog('PTI_PrnFeed( '+TerminalId+' )');
  xPTI_PrnFeed( TerminalId, iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.ImprimirCodBarras(const TerminalId: String;
  const Codigo: String; Tipo: TACBrPOSPGWebCodBarras);
var
  iRet: SmallInt;
begin
  GravarLog('PTI_PrnSymbolCode( '+TerminalId+', '+Codigo+', '+IntToStr(SmallInt(Tipo))+' )', True);
  xPTI_PrnSymbolCode( TerminalId,
                      Codigo,
                      SmallInt(Tipo), iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.ImprimirComprovantesTEF(const TerminalId: String;
  Tipo: TACBrPOSPGWebComprovantes; IgnoraErroSemComprovante: Boolean);
var
  iRet: SmallInt;
begin
  if Tipo = PTIPRN_NONE then
    Exit;

  GravarLog('PTI_EFT_PrintReceipt( '+TerminalId+', '+IntToStr(Word(Tipo))+' )');
  xPTI_EFT_PrintReceipt( TerminalId,
                         Word(Tipo),
                         iRet);
  GravarLog('  '+PTIRETToString(iRet));
  if (iRet = PTIRET_NODATA) then
  begin
    if not IgnoraErroSemComprovante then
      DoException( ACBrStr(sErrSemComprovante) );
  end
  else
    AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.ObterEstado(const TerminalId: String; out
  EstadoAtual: TACBrPOSPGWebEstadoTerminal; out Modelo: String; out
  MAC: String; out Serial: String);
var
  iRet, iStatus: SmallInt;
begin
  GravarLog('PTI_CheckStatus( '+TerminalId+' )');
  xPTI_CheckStatus( TerminalId,
                    iStatus, fpszModel, fpszMAC, fpszSerNo,
                    iRet);
  if (iRet = PTIRET_OK) then
  begin
    EstadoAtual := TACBrPOSPGWebEstadoTerminal(iStatus);
    Modelo := String(fpszModel);
    MAC := String(fpszMAC);
    Serial := String(fpszSerNo);

    GravarLog('  '+PTIRETToString(iRet)+', Estado:'+IntToStr(iStatus)+', Model:'+Modelo+', MAC:'+MAC+', SerNo:'+Serial);
  end
  else
    GravarLog('  '+PTIRETToString(iRet));
end;

function TACBrPOSPGWebAPI.ObterEstado(const TerminalId: String): TACBrPOSPGWebEstadoTerminal;
var
  Alist: TList;
  i: Integer;
  AConexao: TACBrPOSPGWebConexao;
begin
  Result := PTISTAT_NOCONN;
  Alist := fListaConexoes.LockList;
  try
    for i := 0 to Alist.Count-1 do
    begin
      AConexao := TACBrPOSPGWebConexao(Alist[i]);
      if (AConexao.TerminalId = TerminalId) then
      begin
        Result := AConexao.Estado;
        Break;
      end;
    end;
  finally
    fListaConexoes.UnlockList;
  end;
end;

procedure TACBrPOSPGWebAPI.ExecutarTransacaoTEF(const TerminalId: String;
  Operacao: TACBrPOSPGWebOperacao; Comprovantes: TACBrPOSPGWebComprovantes;
  ParametrosAdicionaisTransacao: TStrings);
var
  iRet: SmallInt;
begin
  GravarLog('TACBrPOSPGWebAPI.ExecutarTransacaoTEF( '+TerminalId+' )');
  try
    AjustarEstadoConexao(TerminalId, PTISTAT_BUSY);
    IniciarTransacao( TerminalId, Operacao, ParametrosAdicionaisTransacao );
    iRet := ExecutarTransacao( TerminalId );
    if (iRet = PTIRET_OK) then
    begin
      if (Comprovantes <> PTIPRN_NONE) then
      begin
        try
          ImprimirComprovantesTEF( TerminalId, Comprovantes );
        except
          FinalizarTrancao( TerminalId, PTICNF_PRINTERR );
          raise;
        end;
      end;

      FinalizarTrancao( TerminalId, PTICNF_SUCCESS );
    end
    else
      AvaliarErro(iRet, TerminalId);
  finally
    ObterDadosDaTransacao( TerminalId );
    fEmTransacao := False;
    AjustarEstadoConexao(TerminalId, PTISTAT_IDLE);
  end;
end;

procedure TACBrPOSPGWebAPI.IniciarTransacao(const TerminalId: String;
  Operacao: TACBrPOSPGWebOperacao; ParametrosAdicionaisTransacao: TStrings);
var
  iRet: SmallInt;
  i: Integer;
begin
  if fEmTransacao then
    DoException(ACBrStr(sErrTransacaoJaIniciada));

  fEmTransacao := True;
  GravarLog('PTI_EFT_Start( '+TerminalId+', '+PWOPERToString(SmallInt(Operacao))+' )');
  xPTI_EFT_Start( TerminalId,
                  SmallInt(Operacao),
                  iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);

  For i := 0 to ParametrosAdicionais.Count-1 do
    AdicionarParametro(TerminalId, ParametrosAdicionais[i]);

  if Assigned(ParametrosAdicionaisTransacao) then
  begin
    For i := 0 to ParametrosAdicionaisTransacao.Count-1 do
      AdicionarParametro(TerminalId, ParametrosAdicionaisTransacao[i]);
  end;
end;

procedure TACBrPOSPGWebAPI.AdicionarParametro(const TerminalId: String;
  iINFO: Word; const AValor: AnsiString);
var
  iRet: SmallInt;
begin
  VerificarTransacaoFoiIniciada;
  GravarLog('PTI_EFT_AddParam( '+TerminalId+', '+PWINFOToString(iINFO)+', '+AValor+' )', True);
  xPTI_EFT_AddParam( TerminalId,
                     iINFO,
                     AValor,
                     iRet);
  GravarLog('  '+PTIRETToString(iRet));
  AvaliarErro(iRet, TerminalId);
end;

procedure TACBrPOSPGWebAPI.AdicionarParametro(const TerminalId: String;
  AKeyValueStr: String);
var
  AInfo: Integer;
  AInfoStr, AValue: String;
begin
  if ParseKeyValue(AKeyValueStr, AInfoStr, AValue) then
  begin
    AInfo := StrToIntDef(AInfoStr, -1);
    if (AInfo >= 0) then
      AdicionarParametro(TerminalId, AInfo, AValue);
  end;
end;

function TACBrPOSPGWebAPI.ExecutarTransacao(const TerminalId: String): SmallInt;
var
  iRet: SmallInt;
begin
  VerificarTransacaoFoiIniciada;
  GravarLog('PTI_EFT_Exec( '+TerminalId+' )');
  xPTI_EFT_Exec( TerminalId,
                 iRet);
  GravarLog('  '+PTIRETToString(iRet));
  Result := iRet;
end;

function TACBrPOSPGWebAPI.ObterInfo(const TerminalId: String; iINFO: Word
  ): String;
var
  pszValue: PAnsiChar;
  uiBuffLen: LongWord;
  iRet: SmallInt;
  MsgError: String;
begin
  Result := #0;
  uiBuffLen := 10240;   // 10K
  pszValue := AllocMem(uiBuffLen);
  try
    GravarLog('PTI_EFT_GetInfo ( '+TerminalId+', '+ PWINFOToString(iINFO)+' )');
    xPTI_EFT_GetInfo( TerminalId,
                      iINFO, uiBuffLen,
                      pszValue,
                      iRet);
    if (iRet = PTIRET_OK) then
    begin
      Result := String(pszValue);
      GravarLog('  '+Result, True);
    end
    else
    begin
      GravarLog('  '+PTIRETToString(iRet));
      if (iRet <> PTIRET_NODATA) then
        AvaliarErro(iRet, TerminalId);
    end;
  finally
    Freemem(pszValue);
  end;
end;

function TACBrPOSPGWebAPI.ObterUltimoRetorno(const TerminalId: String): String;
begin
  Result := ObterInfo(TerminalId, PWINFO_RESULTMSG);
end;

procedure TACBrPOSPGWebAPI.ObterDadosDaTransacao(const TerminalId: String);
var
  pszValue: PAnsiChar;
  uiBuffLen: LongWord;
  iRet: SmallInt;
  i: Word;
  AData, InfoStr: String;
begin
  GravarLog('TACBrPOSPGWebAPI.ObterDadosDaTransacao');
  fDadosTransacao.Clear;
  uiBuffLen := 10240;   // 10K
  pszValue := AllocMem(uiBuffLen);
  try
    For i := MIN_PWINFO to MAX_PWINFO do
    begin
      InfoStr := PWINFOToString(i);
      if (i <> PWINFO_PPINFO) and  // Ler PWINFO_PPINFO � lento (e desnecess�rio)
         (pos(IntToStr(i), InfoStr) = 0) then  // i equivale a um PWINFO_ conhecido ?
      begin
        xPTI_EFT_GetInfo( TerminalId, i, uiBuffLen, pszValue, iRet);
        if (iRet = PTIRET_OK) then
        begin
          AData := BinaryStringToString(AnsiString(pszValue));
          fDadosTransacao.Add(Format('%d=%s', [i, Adata]));  // Add � mais r�pido que usar "ValueInfo[i]"
          GravarLog('  '+Format('%s=%s', [InfoStr, AData]));
        end;
      end;
    end;
  finally
    Freemem(pszValue);
  end;
end;

procedure TACBrPOSPGWebAPI.FinalizarTrancao(const TerminalId: String;
  Status: TACBrPOSPGWebStatusTransacao);
var
  iRet: SmallInt;
begin
  VerificarTransacaoFoiIniciada;
  GravarLog('PTI_EFT_Confirm( '+TerminalId+', '+IntToStr(SmallInt(Status))+' )');
  xPTI_EFT_Confirm( TerminalId, SmallInt(Status), iRet);
  GravarLog('  '+PTIRETToString(iRet));
  fEmTransacao := False;
  AvaliarErro(iRet, TerminalId);
end;

function TACBrPOSPGWebAPI.Desconectar(const TerminalId: String; Segundos: Word
  ): Boolean;
var
  iRet: SmallInt;
begin
  GravarLog('PTI_Disconnect( '+TerminalId+', '+IntToStr(Segundos)+' )');
  xPTI_Disconnect( TerminalId, Segundos, iRet);
  GravarLog('  '+PTIRETToString(iRet));
  Result := (iRet = PTIRET_OK) or (iRet = PTIRET_NOCONN);
  if not Result then
    AvaliarErro(iRet, TerminalId)
  else
    AjustarEstadoConexao(TerminalId, PTISTAT_NOCONN);
end;

procedure TACBrPOSPGWebAPI.OnAguardaConexao(Sender: TObject);
var
  iRet: SmallInt;
  TerminalId, Model, MAC, SerNo: String;
begin
  fTimerConexao.Enabled := False;
  fEmConnectionLoop := True;

  try
    //GravarLog('PTI_ConnectionLoop');
    xPTI_ConnectionLoop(fpszTerminalId, fpszModel, fpszMAC, fpszSerNo, iRet);
    if (iRet = PTIRET_NEWCONN) then
    begin
      TerminalId := String(fpszTerminalId);
      Model := String(fpszModel);
      MAC := String(fpszMAC);
      SerNo := String(fpszSerNo);

      GravarLog('PTI_ConnectionLoop: '+PTIRETToString(iRet)+', TerminalId:'+TerminalId+', Model:'+Model+', MAC:'+MAC+', SerNo:'+SerNo);

      // Garante que n�o tem outra Conex�o pendente, com o mesmo Terminal //
      TerminarConexao(TerminalId);

      // Cria Thread para receber Nova Conex�o //
      TACBrPOSPGWebConexao.Create(Self, TerminalId, Model, MAC, SerNo);
    end
    else if (iRet <> PTIRET_NONEWCONN) then
      GravarLog('  PTI_ConnectionLoop: '+PTIRETToString(iRet));
  finally
    fEmConnectionLoop := False;
    fTimerConexao.Enabled := True;
  end;
end;

function TACBrPOSPGWebAPI.FormatarMensagem(const AMsg: String; Colunas: Word): String;
var
  LB: String;
begin
  Result := AMsg;
  if (Length(AMsg) > Colunas) then
  begin
    LB := sLineBreak;
    if (LB <> LF) then
      Result := StringReplace(Result, sLineBreak, LF, [rfReplaceAll]);

    if (LB <> CR) then
      Result := StringReplace(Result, CR, LF, [rfReplaceAll]);

    Result := QuebraLinhas(Result, Colunas);
    if (LB <> CR) then
      Result := StringReplace(Result, LB, CR, [rfReplaceAll]);
  end;
end;

procedure TACBrPOSPGWebAPI.AvaliarErro(iRet: SmallInt; const TerminalId: String
  );
var
  MsgError: String;
begin
  case iRet of
    PTIRET_OK:
    begin
      MsgError := '';
      if not fEmTransacao then
        AjustarEstadoConexao(TerminalId, PTISTAT_IDLE);
    end;

    PTIRET_NOCONN:
    begin
      MsgError := Format(sErrPTIRET_NOCONN, [TerminalId]);
      AjustarEstadoConexao(TerminalId, PTISTAT_NOCONN);
    end;

    PTIRET_BUSY:
    begin
      MsgError := Format(sErrPTIRET_BUSY, [TerminalId]);
      AjustarEstadoConexao(TerminalId, PTISTAT_BUSY);
    end;

    PTIRET_INVPARAM: MsgError := sErrPTIRET_INVPARAM;
    PTIRET_SECURITYERR: MsgError := sErrPTIRET_SECURITYERR;
    PTIRET_NOTSUPPORTED: MsgError := sErrPTIRET_NOTSUPPORTED;
    PTIRET_PRINTERR: MsgError := sErrPTIRET_PRINTERR;
    PTIRET_NOPAPER: MsgError := sErrPTIRET_NOPAPER;
    PTIRET_INTERNALERR: MsgError := sErrPTIRET_INTERNALERR;
    PTIRET_EFTERR: MsgError := sErrPTIRET_EFTERR;
    PTIRET_BUFOVRFLW: MsgError := sErrPTIRET_BUFOVRFLW;
  else
    MsgError := Format(sErrPTIRET_UNKNOWN, [iRet]);
  end;

  if (MsgError <> '') then
    DoException( ACBrStr(MsgError) );
end;

procedure TACBrPOSPGWebAPI.VerificarTransacaoFoiIniciada;
begin
  if not fEmTransacao then
    DoException(ACBrStr(sErrTransacaoNaoIniciada));
end;

procedure TACBrPOSPGWebAPI.AjustarEstadoConexao(const TerminalId: String;
  NovoEstado: TACBrPOSPGWebEstadoTerminal);
var
  Alist: TList;
  i: Integer;
  AConexao: TACBrPOSPGWebConexao;
begin
  Alist := fListaConexoes.LockList;
  try
    for i := 0 to Alist.Count-1 do
    begin
      AConexao := TACBrPOSPGWebConexao(Alist[i]);
      if (AConexao.TerminalId = TerminalId) then
      begin
        AConexao.Estado := NovoEstado;
        Break;
      end;
    end;
  finally
    fListaConexoes.UnlockList;
  end;
end;

procedure TACBrPOSPGWebAPI.TerminarConexao(const TerminalId: String);
var
  Alist: TList;
  i: Integer;
  AConexao: TACBrPOSPGWebConexao;
begin
  Alist := fListaConexoes.LockList;
  try
    for i := 0 to Alist.Count-1 do
    begin
      AConexao := TACBrPOSPGWebConexao(Alist[i]);
      if (AConexao.TerminalId = TerminalId) then
      begin
        AConexao.Terminate;
        Break;
      end;
    end;
  finally
    fListaConexoes.UnlockList;
  end;
end;

function TACBrPOSPGWebAPI.CalcularCapacidadesDaAutomacao: Integer;
begin
  Result := 4;            // 4: valor fixo, sempre incluir;
  if fSuportaSaque then
    Inc(Result, 1);       // 1: funcionalidade de troco/saque;
  if fSuportaDesconto then
    Inc(Result, 2);       // 2: funcionalidade de desconto;
  if fSuportaViasDiferenciadas then
    Inc(Result, 8);       // 8: impress�o das vias diferenciadas do comprovante para Cliente/Estabelecimento;
  if fImprimirViaClienteReduzida then
    Inc(Result, 16);      // 16: impress�o do cupom reduzido
  if fUtilizaSaldoTotalVoucher then
    Inc(Result, 32);      // 32: utiliza��o de saldo total do voucher para abatimento do valor da compra
end;

procedure TACBrPOSPGWebAPI.SetDiretorioTrabalho(AValue: String);
begin
  if fDiretorioTrabalho = AValue then
    Exit;

  GravarLog('TACBrPOSPGWebAPI.SetDiretorioTrabalho( '+AValue+' )');

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializada));

  fDiretorioTrabalho := AValue;
end;

procedure TACBrPOSPGWebAPI.SetNomeAplicacao(AValue: String);
begin
  if fNomeAplicacao = AValue then Exit;
  fNomeAplicacao := LeftStr(Trim(AValue),29);
end;

procedure TACBrPOSPGWebAPI.SetPathDLL(AValue: String);
begin
  if fPathDLL = AValue then
    Exit;

  GravarLog('TACBrPOSPGWebAPI.SetPathDLL( '+AValue+' )');

  if fInicializada then
    DoException(ACBrStr(sErrLibJaInicializada));

  fPathDLL := AValue;
end;

procedure TACBrPOSPGWebAPI.SetSoftwareHouse(AValue: String);
begin
  if fSoftwareHouse = AValue then Exit;
  fSoftwareHouse := LeftStr(Trim(AValue),40);
end;

procedure TACBrPOSPGWebAPI.SetVersaoAplicacao(AValue: String);
begin
  if fVersaoAplicacao = AValue then Exit;
  fVersaoAplicacao := LeftStr(Trim(AValue),10);
end;

procedure TACBrPOSPGWebAPI.LoadDLLFunctions;

  procedure PGWebFunctionDetect( FuncName: AnsiString; var LibPointer: Pointer ) ;
  var
    sLibName: string;
  begin
    if not Assigned( LibPointer )  then
    begin
      GravarLog('   '+FuncName);

      // Verifica se exite o caminho das DLLs
      sLibName := '';
      if Length(PathDLL) > 0 then
        sLibName := PathWithDelim(PathDLL);

      // Concatena o caminho se exitir mais o nome da DLL.
      sLibName := sLibName + CACBrPOSPGWebLib;

      if not FunctionDetect( sLibName, FuncName, LibPointer) then
      begin
        LibPointer := NIL ;
        DoException(Format(ACBrStr('Erro ao carregar a fun��o: %s de: %s'),[FuncName, sLibName]));
      end ;
    end ;
  end;

 begin
   if fInicializada then
     Exit;

   GravarLog('TACBrPOSPGWebAPI.LoadDLLFunctions');

   PGWebFunctionDetect('PTI_Init', @xPTI_Init);
   PGWebFunctionDetect('PTI_End', @xPTI_End);
   PGWebFunctionDetect('PTI_ConnectionLoop', @xPTI_ConnectionLoop);
   PGWebFunctionDetect('PTI_CheckStatus', @xPTI_CheckStatus);
   PGWebFunctionDetect('PTI_Disconnect', @xPTI_Disconnect);
   PGWebFunctionDetect('PTI_Display', @xPTI_Display);
   PGWebFunctionDetect('PTI_WaitKey', @xPTI_WaitKey);
   PGWebFunctionDetect('PTI_ClearKey', @xPTI_ClearKey);
   PGWebFunctionDetect('PTI_GetData', @xPTI_GetData);
   PGWebFunctionDetect('PTI_StartMenu', @xPTI_StartMenu);
   PGWebFunctionDetect('PTI_AddMenuOption', @xPTI_AddMenuOption);
   PGWebFunctionDetect('PTI_StartMenu', @xPTI_StartMenu);
   PGWebFunctionDetect('PTI_ExecMenu', @xPTI_ExecMenu);
   PGWebFunctionDetect('PTI_Beep', @xPTI_Beep);
   PGWebFunctionDetect('PTI_Print', @xPTI_Print);
   PGWebFunctionDetect('PTI_PrnFeed', @xPTI_PrnFeed);
   PGWebFunctionDetect('PTI_PrnSymbolCode', @xPTI_PrnSymbolCode);
   PGWebFunctionDetect('PTI_EFT_Start', @xPTI_EFT_Start);
   PGWebFunctionDetect('PTI_EFT_AddParam', @xPTI_EFT_AddParam);
   PGWebFunctionDetect('PTI_EFT_Exec', @xPTI_EFT_Exec);
   PGWebFunctionDetect('PTI_EFT_GetInfo', @xPTI_EFT_GetInfo);
   PGWebFunctionDetect('PTI_EFT_PrintReceipt', @xPTI_EFT_PrintReceipt);
   PGWebFunctionDetect('PTI_EFT_Confirm', @xPTI_EFT_Confirm);
end;

procedure TACBrPOSPGWebAPI.UnLoadDLLFunctions;
var
  sLibName: String;
begin
  if not fInicializada then
    Exit;

  xPTI_End;

  //GravarLog('TACBrPOSPGWebAPI.UnLoadDLLFunctions');

  sLibName := '';
  if Length(PathDLL) > 0 then
     sLibName := PathWithDelim(PathDLL);

  UnLoadLibrary( sLibName + CACBrPOSPGWebLib );
  ClearMethodPointers;
end;

procedure TACBrPOSPGWebAPI.ClearMethodPointers;
begin
  xPTI_Init := Nil;
  xPTI_End := Nil;
  xPTI_ConnectionLoop := Nil;
  xPTI_CheckStatus := Nil;
  xPTI_Disconnect := Nil;
  xPTI_Display := Nil;
  xPTI_WaitKey := Nil;
  xPTI_ClearKey := Nil;
  xPTI_GetData := Nil;
  xPTI_StartMenu := Nil;
  xPTI_AddMenuOption := Nil;
  xPTI_StartMenu := Nil;
  xPTI_ExecMenu := Nil;
  xPTI_Beep := Nil;
  xPTI_Print := Nil;
  xPTI_PrnFeed := Nil;
  xPTI_PrnSymbolCode := Nil;
  xPTI_EFT_Start := Nil;
  xPTI_EFT_AddParam := Nil;
  xPTI_EFT_Exec := Nil;
  xPTI_EFT_GetInfo := Nil;
  xPTI_EFT_PrintReceipt := Nil;
  xPTI_EFT_Confirm := Nil;
end;

end.

