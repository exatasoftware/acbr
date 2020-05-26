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

unit ACBrTEFDCliSiTef;

interface

uses
  Classes, SysUtils, ACBrTEFDClass, ACBrTEFCliSiTefComum
  {$IfNDef NOGUI}
    {$If DEFINED(VisualCLX)}
      ,QControls
    {$ElseIf DEFINED(FMX)}
      ,System.UITypes
    {$ElseIf DEFINED(DELPHICOMPILER16_UP)}
      ,System.UITypes
    {$Else}
      ,Controls
    {$IfEnd}
  {$EndIf};


type
  { TACBrTEFDRespCliSiTef }

  TACBrTEFDRespCliSiTef = class( TACBrTEFDResp )
  public
    procedure ConteudoToProperty; override;
    procedure GravaInformacao( const Identificacao : Integer;
      const Informacao : AnsiString );
  end;

  TACBrTEFDCliSiTefExibeMenu = procedure( Titulo : String; Opcoes : TStringList;
    var ItemSelecionado : Integer; var VoltarMenu : Boolean ) of object ;

  TACBrTEFDCliSiTefOperacaoCampo = (tcString, tcDouble, tcCMC7, tcBarCode, tcStringMask) ;

  TACBrTEFDCliSiTefObtemCampo = procedure( Titulo : String;
    TamanhoMinimo, TamanhoMaximo : Integer ;
    TipoCampo : Integer; Operacao : TACBrTEFDCliSiTefOperacaoCampo;
    var Resposta : AnsiString; var Digitado : Boolean; var VoltarMenu : Boolean )
    of object ;

  { TACBrTEFDCliSiTef }

   TACBrTEFDCliSiTef = class( TACBrTEFDClass )
   private
      fExibirErroRetorno: Boolean;
      fIniciouRequisicao: Boolean;
      fReimpressao: Boolean; {Indica se foi selecionado uma reimpress�o no ADM}
      fCancelamento: Boolean; {Indica se foi selecionado Cancelamento no ADM}
      fCodigoLoja : AnsiString;
      fEnderecoIP : AnsiString;
      fNumeroTerminal : AnsiString;
      fCNPJEstabelecimento : AnsiString;
      fCNPJSoftwareHouse : AnsiString;
      fOnExibeMenu : TACBrTEFDCliSiTefExibeMenu;
      fOnObtemCampo : TACBrTEFDCliSiTefObtemCampo;
      fOperacaoADM : Integer;
      fOperacaoATV : Integer;
      fOperacaoCHQ : Integer;
      fOperacaoCNC : Integer;
      fOperacaoCRT : Integer;
      fOperacaoPRE : Integer;
      fOperacaoReImpressao: Integer;
      fOperador : AnsiString;
      fParametrosAdicionais : TStringList;
      fRespostas: TStringList;
      fRestricoes : AnsiString;
      fDocumentoFiscal: AnsiString;
      fDataHoraFiscal: TDateTime;
      fDocumentosProcessados : AnsiString ;
      fPathDLL: string;
      fPortaPinPad: Integer;
      fUsaUTF8: Boolean;
      fArqBackUp: String;

     xConfiguraIntSiTefInterativoEx : function (
                pEnderecoIP: PAnsiChar;
                pCodigoLoja: PAnsiChar;
                pNumeroTerminal: PAnsiChar;
                ConfiguraResultado: smallint;
                pParametrosAdicionais: PAnsiChar): integer;
               {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;

     xIniciaFuncaoSiTefInterativo : function (
                Modalidade: integer;
                pValor: PAnsiChar;
                pNumeroCuponFiscal: PAnsiChar;
                pDataFiscal: PAnsiChar;
                pHorario: PAnsiChar;
                pOperador: PAnsiChar;
                pRestricoes: PAnsiChar ): integer;
                {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;


     xFinalizaFuncaoSiTefInterativo : procedure (
                 pConfirma: SmallInt;
                 pCupomFiscal: PAnsiChar;
                 pDataFiscal: PAnsiChar;
                 pHoraFiscal: PAnsiChar;
                 pParamAdic: PAnsiChar);
                 {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;


     xContinuaFuncaoSiTefInterativo : function (
                var ProximoComando: SmallInt;
                var TipoCampo: LongInt;
                var TamanhoMinimo: SmallInt;
                var TamanhoMaximo: SmallInt;
                pBuffer: PAnsiChar;
                TamMaxBuffer: Integer;
                ContinuaNavegacao: Integer ): integer;
                {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;

     xEscreveMensagemPermanentePinPad: function(Mensagem:PAnsiChar):Integer;
        {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;

     xObtemQuantidadeTransacoesPendentes: function(
        DataFiscal:AnsiString;
        NumeroCupon:AnsiString):Integer;
        {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;

     xEnviaRecebeSiTefDireto : function (
        RedeDestino: SmallInt;
        FuncaoSiTef: SmallInt;
        OffsetCartao: SmallInt;
        DadosTx: AnsiString;
        TamDadosTx: SmallInt;
        DadosRx: PAnsiChar;
        TamMaxDadosRx: SmallInt;
        var CodigoResposta: SmallInt;
        TempoEsperaRx: SmallInt;
        CuponFiscal: AnsiString;
        DataFiscal: AnsiString;
        Horario: AnsiString;
        Operador: AnsiString;
        TipoTransacao: SmallInt): Integer;
        {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF} ;

     xValidaCampoCodigoEmBarras: function(
        Dados: AnsiString;
        var Tipo: SmallInt): Integer;
        {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

     xVerificaPresencaPinPad: function(): Integer
     {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

     xObtemDadoPinPadDiretoEx: function(ChaveAcesso: PAnsiChar; Identificador: PAnsiChar; Entrada: PAnsiChar; var Saida: array of Byte): Integer;
     {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

     procedure AvaliaErro(Sts : Integer);
     function GetDataHoraFiscal: TDateTime;
     function GetDocumentoFiscal: AnsiString;
     procedure LoadDLLFunctions;
     procedure UnLoadDLLFunctions;
     procedure SetParametrosAdicionais(const AValue : TStringList) ;
   protected
     procedure SetNumVias(const AValue : Integer); override;

     Function FazerRequisicao( Funcao : Integer; AHeader : AnsiString = '';
        Valor : Double = 0; Documento : AnsiString = '';
        ListaRestricoes : AnsiString = '') : Integer ;
     Function ContinuarRequisicao( ImprimirComprovantes : Boolean ) : Integer ;

     procedure ProcessarResposta ; override;
     Function ProcessarRespostaPagamento( const IndiceFPG_ECF : String;
        const Valor : Double) : Boolean; override;

     procedure VerificarIniciouRequisicao; override;

     Function SuportaDesconto : Boolean ;
     Function HMS : String ;

     function CopiarResposta: string; override;
   public
     property Respostas : TStringList read fRespostas ;
     property PathDLL: string read fPathDLL write fPathDLL;

     constructor Create( AOwner : TComponent ) ; override;
     destructor Destroy ; override;

     procedure Inicializar ; override;
     procedure DesInicializar ; override;

     procedure AtivarGP ; override;
     procedure VerificaAtivo ; override;

     Procedure ATV ; override;
     Function ADM : Boolean ; override;
     Function CRT( Valor : Double; IndiceFPG_ECF : String;
        DocumentoVinculado : String = ''; Moeda : Integer = 0 ) : Boolean; override;
     Function CHQ( Valor : Double; IndiceFPG_ECF : String;
        DocumentoVinculado : String = ''; CMC7 : String = '';
        TipoPessoa : AnsiChar = 'F'; DocumentoPessoa : String = '';
        DataCheque : TDateTime = 0; Banco   : String = '';
        Agencia    : String = ''; AgenciaDC : String = '';
        Conta      : String = ''; ContaDC   : String = '';
        Cheque     : String = ''; ChequeDC  : String = '';
        Compensacao: String = '' ) : Boolean ; override;
     Procedure NCN(Rede, NSU, Finalizacao : String;
        Valor : Double = 0; DocumentoVinculado : String = ''); override;
     Procedure CNF(Rede, NSU, Finalizacao : String;
        DocumentoVinculado : String = ''); override;
     Function CNC(Rede, NSU : String; DataHoraTransacao : TDateTime;
        Valor : Double) : Boolean; overload; override;
     Function PRE(Valor : Double; DocumentoVinculado : String = '';
        Moeda : Integer = 0) : Boolean; override;
     function CDP(const EntidadeCliente: string; out Resposta: string): Boolean; override;

     Function DefineMensagemPermanentePinPad(Mensagem:AnsiString):Integer;
     Function ObtemQuantidadeTransacoesPendentes(Data:TDateTime;
        CupomFiscal:AnsiString):Integer;
     Function EnviaRecebeSiTefDireto( RedeDestino: SmallInt;
        FuncaoSiTef: SmallInt; OffsetCartao: SmallInt; DadosTx: AnsiString;
        var DadosRx: AnsiString; var CodigoResposta: SmallInt;
        TempoEsperaRx: SmallInt; CuponFiscal: AnsiString;
        Confirmar: Boolean): Integer;
     procedure FinalizarTransacao( Confirma : Boolean;
        DocumentoVinculado : AnsiString; ParamAdic: AnsiString = '');
     function ValidaCampoCodigoEmBarras(Dados: AnsiString;
        var Tipo: SmallInt): Integer;
     function VerificaPresencaPinPad: Boolean;
     function ObtemDadoPinPadDiretoEx(Tipo_Doc: Integer; ChaveAcesso: PAnsiChar; Identificador: PAnsiChar): AnsiString;

   published
     property EnderecoIP: AnsiString                    read fEnderecoIP           write fEnderecoIP;
     property CodigoLoja: AnsiString                    read fCodigoLoja           write fCodigoLoja;
     property NumeroTerminal: AnsiString                read fNumeroTerminal       write fNumeroTerminal;
     property CNPJEstabelecimento: AnsiString           read fCNPJEstabelecimento  write fCNPJEstabelecimento;
     property CNPJSoftwareHouse: AnsiString             read fCNPJSoftwareHouse    write fCNPJSoftwareHouse;
     property Operador: AnsiString                      read fOperador             write fOperador;
     property PortaPinPad: Integer                      read fPortaPinPad          write fPortaPinPad default 0;
     property ParametrosAdicionais: TStringList         read fParametrosAdicionais write SetParametrosAdicionais;
     property Restricoes: AnsiString                    read fRestricoes           write fRestricoes;
     property DocumentoFiscal: AnsiString               read GetDocumentoFiscal    write fDocumentoFiscal;
     property DataHoraFiscal: TDateTime                 read GetDataHoraFiscal     write fDataHoraFiscal;
     property OperacaoATV: Integer                      read fOperacaoATV          write fOperacaoATV default 111;
     property OperacaoADM: Integer                      read fOperacaoADM          write fOperacaoADM default 110;
     property OperacaoCRT: Integer                      read fOperacaoCRT          write fOperacaoCRT default 0;
     property OperacaoCHQ: Integer                      read fOperacaoCHQ          write fOperacaoCHQ default 1;
     property OperacaoCNC: Integer                      read fOperacaoCNC          write fOperacaoCNC default 200;
     property OperacaoPRE: Integer                      read fOperacaoPRE          write fOperacaoPRE default 115;
     property OperacaoReImpressao: Integer              read fOperacaoReImpressao  write fOperacaoReImpressao default 112;
     property OnExibeMenu: TACBrTEFDCliSiTefExibeMenu   read fOnExibeMenu          write fOnExibeMenu;
     property OnObtemCampo: TACBrTEFDCliSiTefObtemCampo read fOnObtemCampo         write fOnObtemCampo;
     property ExibirErroRetorno: Boolean                read fExibirErroRetorno    write fExibirErroRetorno default False;
     property UsaUTF8: Boolean                          read fUsaUTF8              write fUsaUTF8 default False;
   end;

implementation

Uses
  {$IFDEF MSWINDOWS} Windows, {$ENDIF MSWINDOWS}
  strutils, math,
  ACBrTEFD, ACBrUtil, ACBrTEFComum;

{ TACBrTEFDRespCliSiTef }

procedure TACBrTEFDRespCliSiTef.ConteudoToProperty;
begin
  ConteudoToPropertyCliSiTef( Self );
end;

procedure TACBrTEFDRespCliSiTef.GravaInformacao(const Identificacao: Integer;
  const Informacao: AnsiString);
var
  Sequencia: Integer;
begin
  Sequencia := 0;

  case Identificacao of
    141, 142,            // 141 - Data Parcela, 142 - Valor Parcela
    600..607, 611..624:  // Dados do Corresp. Banc�rio
    begin
      Sequencia := 1;

      while (Trim(LeInformacao(Identificacao, Sequencia).AsString) <> '') do
        Inc(Sequencia);
    end;
  end;

  fpConteudo.GravaInformacao( Identificacao, Sequencia,
                              BinaryStringToString(Informacao) ); // Converte #10 para "\x0A"
end;


{ TACBrTEFDClass }

constructor TACBrTEFDCliSiTef.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  fIniciouRequisicao := False;
  fReimpressao       := False;
  fCancelamento      := False;
  ArqReq    := '' ;
  ArqResp   := '' ;
  ArqSTS    := '' ;
  ArqTemp   := '' ;
  GPExeName := '' ;
  fpTipo    := gpCliSiTef;
  Name      := 'CliSiTef' ;

  fEnderecoIP     := '' ;
  fCodigoLoja     := '' ;
  fNumeroTerminal := '' ;
  fCNPJEstabelecimento := '';
  fCNPJSoftwareHouse   := '';
  fOperador       := '' ;
  fRestricoes     := '' ;

  fDocumentoFiscal := '';
  fDataHoraFiscal  := 0;

  fOperacaoATV         := 111 ; // 111 - Teste de comunica��o com o SiTef
  fOperacaoReImpressao := 112 ; // 112 - Menu Re-impress�o
  fOperacaoPRE         := 115 ; // 115 - Pr�-autoriza��o
  fOperacaoADM         := 110 ; // 110 - Abre o leque das transa��es Gerenciais
  fOperacaoCRT         := 0 ;   // A CliSiTef permite que o operador escolha a forma
                                // de pagamento atrav�s de menus
  fOperacaoCHQ         := 1 ;   // Cheque
  fOperacaoCNC         := 200 ; // 200 Cancelamento Normal: Inicia a coleta dos dados
                                // no ponto necess�rio para fazer o cancelamento de uma
                                // transa��o de d�bito ou cr�dito, sem ser necess�rio
                                // passar antes pelo menu de transa��es administrativas
  fDocumentosProcessados := '' ;
  fExibirErroRetorno     := False;
  fUsaUTF8               := False;

  fParametrosAdicionais := TStringList.Create;
  fRespostas            := TStringList.Create;

  xConfiguraIntSiTefInterativoEx      := nil;
  xIniciaFuncaoSiTefInterativo        := nil;
  xContinuaFuncaoSiTefInterativo      := nil;
  xFinalizaFuncaoSiTefInterativo      := nil;
  xEscreveMensagemPermanentePinPad    := nil;
  xObtemQuantidadeTransacoesPendentes := nil;
  xValidaCampoCodigoEmBarras          := nil;
  xEnviaRecebeSiTefDireto             := nil;
  xVerificaPresencaPinPad             := nil;
  xObtemDadoPinPadDiretoEx            := nil;

  fOnExibeMenu  := nil ;
  fOnObtemCampo := nil ;

  if Assigned( fpResp ) then
     fpResp.Free ;

  fpResp := TACBrTEFDRespCliSiTef.Create;
  fpResp.TipoGP := fpTipo;
end;

function TACBrTEFDCliSiTef.DefineMensagemPermanentePinPad(Mensagem:AnsiString):Integer;
begin
   if Assigned(xEscreveMensagemPermanentePinPad) then
      Result := xEscreveMensagemPermanentePinPad(PAnsiChar(Mensagem))
   else
      raise EACBrTEFDErro.Create( ACBrStr( CACBrTEFCliSiTef_NaoInicializado ) ) ;
end;

destructor TACBrTEFDCliSiTef.Destroy;
begin
   fParametrosAdicionais.Free ;
   fRespostas.Free ;

   inherited Destroy;
end;

procedure TACBrTEFDCliSiTef.LoadDLLFunctions ;
 procedure CliSiTefFunctionDetect( FuncName: AnsiString; var LibPointer: Pointer ) ;
 var
 sLibName: string;
 begin
   if not Assigned( LibPointer )  then
   begin
     // Verifica se exite o caminho das DLLs
     sLibName := '';
     if Length(PathDLL) > 0 then
        sLibName := PathWithDelim(PathDLL);

     // Concatena o caminho se exitir mais o nome da DLL.
     sLibName := sLibName + CACBrTEFCliSiTef_Lib;

     if not FunctionDetect( sLibName, FuncName, LibPointer) then
     begin
        LibPointer := NIL ;
        raise EACBrTEFDErro.Create( ACBrStr( 'Erro ao carregar a fun��o:'+FuncName+
                                         ' de: '+CACBrTEFCliSiTef_Lib ) ) ;
     end ;
   end ;
 end ;
begin
   CliSiTefFunctionDetect('ConfiguraIntSiTefInterativoEx', @xConfiguraIntSiTefInterativoEx);
   CliSiTefFunctionDetect('IniciaFuncaoSiTefInterativo', @xIniciaFuncaoSiTefInterativo);
   CliSiTefFunctionDetect('ContinuaFuncaoSiTefInterativo', @xContinuaFuncaoSiTefInterativo);
   CliSiTefFunctionDetect('FinalizaFuncaoSiTefInterativo', @xFinalizaFuncaoSiTefInterativo);
   CliSiTefFunctionDetect('EscreveMensagemPermanentePinPad',@xEscreveMensagemPermanentePinPad);
   CliSiTefFunctionDetect('ObtemQuantidadeTransacoesPendentes',@xObtemQuantidadeTransacoesPendentes);
   CliSiTefFunctionDetect('ValidaCampoCodigoEmBarras',@xValidaCampoCodigoEmBarras);
   CliSiTefFunctionDetect('EnviaRecebeSiTefDireto',@xEnviaRecebeSiTefDireto);
   CliSiTefFunctionDetect('VerificaPresencaPinPad',@xVerificaPresencaPinPad);
   CliSiTefFunctionDetect('ObtemDadoPinPadDiretoEx', @xObtemDadoPinPadDiretoEx);
end ;

procedure TACBrTEFDCliSiTef.UnLoadDLLFunctions;
var
   sLibName: String;
begin
  sLibName := '';
  if Length(PathDLL) > 0 then
     sLibName := PathWithDelim(PathDLL);

  UnLoadLibrary( sLibName + CACBrTEFCliSiTef_Lib );

  xConfiguraIntSiTefInterativoEx      := Nil;
  xIniciaFuncaoSiTefInterativo        := Nil;
  xContinuaFuncaoSiTefInterativo      := Nil;
  xFinalizaFuncaoSiTefInterativo      := Nil;
  xEscreveMensagemPermanentePinPad    := Nil;
  xObtemQuantidadeTransacoesPendentes := Nil;
  xValidaCampoCodigoEmBarras          := Nil;
  xEnviaRecebeSiTefDireto             := Nil;
  xVerificaPresencaPinPad             := Nil;
  xObtemDadoPinPadDiretoEx            := Nil;
end;

procedure TACBrTEFDCliSiTef.SetParametrosAdicionais(const AValue : TStringList
   ) ;
begin
   fParametrosAdicionais.Assign( AValue ) ;
end ;

procedure TACBrTEFDCliSiTef.SetNumVias(const AValue : Integer);
begin
   fpNumVias := 2;
end;

procedure TACBrTEFDCliSiTef.Inicializar;
Var
  Sts : Integer ;
  ParamAdic : AnsiString ;
  Erro : String;
begin
  if Inicializado then exit ;

  if not Assigned( OnExibeMenu ) then
     raise EACBrTEFDErro.Create( ACBrStr('Evento "OnExibeMenu" n�o programado' ) ) ;

  if not Assigned( OnObtemCampo ) then
     raise EACBrTEFDErro.Create( ACBrStr('Evento "OnObtemCampo" n�o programado' ) ) ;

  LoadDLLFunctions;

  // configura��o da porta do pin-pad
  if PortaPinPad > 0 then
  begin
    if ParametrosAdicionais.Values['PortaPinPad'] = '' then
      ParametrosAdicionais.Add('PortaPinPad=' + IntToStr(PortaPinPad))
    else
      ParametrosAdicionais.Values['PortaPinPad'] := IntToStr(PortaPinPad);
  end;

  // cielo premia
  if ParametrosAdicionais.Values['VersaoAutomacaoCielo'] = '' then
  begin
    if SuportaDesconto then
      ParametrosAdicionais.Add('VersaoAutomacaoCielo=' + PadRight( TACBrTEFD(Owner).Identificacao.SoftwareHouse, 8 ) + '10');
  end;

  // acertar quebras de linhas e abertura e fechamento da lista de parametros
  ParamAdic := StringReplace(Trim(ParametrosAdicionais.Text), sLineBreak, ';', [rfReplaceAll]);
  ParamAdic := '['+ ParamAdic + ']';

  if NaoEstaVazio(CNPJEstabelecimento) and NaoEstaVazio(CNPJSoftwareHouse) then
     ParamAdic := ParamAdic + '[ParmsClient=1='+CNPJEstabelecimento+';2='+CNPJSoftwareHouse+']';

  GravaLog( '*** ConfiguraIntSiTefInterativoEx. EnderecoIP: '   +fEnderecoIP+
                                            ' CodigoLoja: '     +fCodigoLoja+
                                            ' NumeroTerminal: ' +fNumeroTerminal+
                                            ' Resultado: 0'     +
                                            ' ParametrosAdicionais: '+ParamAdic ) ;

  Sts := xConfiguraIntSiTefInterativoEx( PAnsiChar(fEnderecoIP),
                                         PAnsiChar(fCodigoLoja),
                                         PAnsiChar(fNumeroTerminal),
                                         0,
                                         PAnsiChar(ParamAdic) );
  Erro := '' ;
  Case Sts of
    1 :	Erro := CACBrTEFCliSiTef_Erro1;
    2 : Erro := CACBrTEFCliSiTef_Erro2;
    3 : Erro := CACBrTEFCliSiTef_Erro3;
    6 : Erro := CACBrTEFCliSiTef_Erro6;
    7 : Erro := CACBrTEFCliSiTef_Erro7;
    8 : Erro := CACBrTEFCliSiTef_Erro8;
   10 : Erro := CACBrTEFCliSiTef_Erro10;
   11 : Erro := CACBrTEFCliSiTef_Erro11;
   12 : Erro := CACBrTEFCliSiTef_Erro12;
   13 : Erro := CACBrTEFCliSiTef_Erro13;
  end;

  if Erro <> '' then
     raise EACBrTEFDErro.Create( ACBrStr( Erro ) ) ;

  GravaLog( Name +' Inicializado CliSiTEF' );

  VerificarTransacoesPendentesClass(True);
  fpInicializado := True;
end;

procedure TACBrTEFDCliSiTef.DesInicializar;
begin
   UnLoadDLLFunctions ;

   inherited DesInicializar;
end;

procedure TACBrTEFDCliSiTef.AtivarGP;
begin
   raise EACBrTEFDErro.Create( ACBrStr( 'CliSiTef n�o pode ser ativado localmente' )) ;
end;

procedure TACBrTEFDCliSiTef.VerificaAtivo;
begin
   {Nada a Fazer}
end;

procedure TACBrTEFDCliSiTef.ATV;
var
   Sts : Integer;
begin
  Sts := FazerRequisicao( fOperacaoATV, 'ATV' ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( CACBrTEFCliSiTef_ImprimeGerencialConcomitante ) ;

  if ( Sts <> 0 ) then
     AvaliaErro( Sts )
  else
     if not CACBrTEFCliSiTef_ImprimeGerencialConcomitante then
        ProcessarResposta;
end;

function TACBrTEFDCliSiTef.ADM: Boolean;
var
   Sts : Integer;
begin
  Sts := FazerRequisicao( fOperacaoADM, 'ADM', 0, '', fRestricoes ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( CACBrTEFCliSiTef_ImprimeGerencialConcomitante ) ;

  Result := ( Sts = 0 ) ;

  if not Result then
     AvaliaErro( Sts )
  else
     if not CACBrTEFCliSiTef_ImprimeGerencialConcomitante then
        ProcessarResposta;
end;

function TACBrTEFDCliSiTef.CRT(Valor: Double; IndiceFPG_ECF: String;
  DocumentoVinculado: String; Moeda: Integer): Boolean;
var
  Sts : Integer;
  Restr : AnsiString ;
begin
  if (Valor <> 0) then
    VerificarTransacaoPagamento( Valor );

  Restr := fRestricoes;
  if Restr = '' then
     Restr := '[10]' ;     // 10 - Cheques

  if DocumentoVinculado = '' then
     DocumentoVinculado := fDocumentoFiscal;

  Sts := FazerRequisicao( fOperacaoCRT, 'CRT', Valor, DocumentoVinculado, Restr ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( False ) ;  { False = NAO Imprimir Comprovantes agora }

  Result := ( Sts = 0 ) ;

  if not Result then
     AvaliaErro( Sts )
  else
     ProcessarRespostaPagamento( IndiceFPG_ECF, Valor );
end;

function TACBrTEFDCliSiTef.CHQ(Valor: Double; IndiceFPG_ECF: String;
  DocumentoVinculado: String; CMC7: String; TipoPessoa: AnsiChar;
  DocumentoPessoa: String; DataCheque: TDateTime; Banco: String;
  Agencia: String; AgenciaDC: String; Conta: String; ContaDC: String;
  Cheque: String; ChequeDC: String; Compensacao: String): Boolean;
var
  Sts : Integer;
  Restr : AnsiString ;

  Function FormataCampo( Campo : AnsiString; Tamanho : Integer ) : AnsiString ;
  begin
    Result := PadLeft( OnlyNumber( Trim( Campo ) ), Tamanho, '0') ;
  end ;

begin
  if (DocumentoVinculado <> '') and (Valor <> 0) then
     VerificarTransacaoPagamento( Valor );

  Respostas.Values['501'] := ifthen(TipoPessoa = 'J','1','0');

  if DocumentoPessoa <> '' then
     Respostas.Values['502'] := OnlyNumber(Trim(DocumentoPessoa));

  if DataCheque <> 0  then
     Respostas.Values['506'] := FormatDateTime('DDMMYYYY',DataCheque) ;

  if CMC7 <> '' then
     Respostas.Values['517'] := '1:'+CMC7
  else
     Respostas.Values['517'] := '0:'+FormataCampo(Compensacao,3)+
                                     FormataCampo(Banco,3)+
                                     FormataCampo(Agencia,4)+
                                     FormataCampo(AgenciaDC,1)+
                                     FormataCampo(Conta,10)+
                                     FormataCampo(ContaDC,1)+
                                     FormataCampo(Cheque,6)+
                                     FormataCampo(ChequeDC,1) ;

  Restr := fRestricoes;
  if Restr = '' then
     Restr := '[15;25]' ;  // 15 - Cart�o Credito; 25 - Cartao Debito

  if DocumentoVinculado = '' then
     DocumentoVinculado := fDocumentoFiscal;

  Sts := FazerRequisicao( fOperacaoCHQ, 'CHQ', Valor, DocumentoVinculado, Restr ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( False ) ;  { False = NAO Imprimir Comprovantes agora }

  Result := ( Sts = 0 ) ;

  if not Result then
     AvaliaErro( Sts )
  else
     ProcessarRespostaPagamento( IndiceFPG_ECF, Valor );
end;

procedure TACBrTEFDCliSiTef.CNF(Rede, NSU, Finalizacao: String;
  DocumentoVinculado: String);
begin
  // CliSiTEF n�o usa Rede, NSU e Finalizacao

  FinalizarTransacao( True, DocumentoVinculado, Finalizacao );
end;

function TACBrTEFDCliSiTef.CNC(Rede, NSU: String; DataHoraTransacao: TDateTime;
  Valor: Double): Boolean;
var
   Sts : Integer;
begin
  Respostas.Values['146'] := FormatFloat('0.00',Valor);
  Respostas.Values['147'] := FormatFloat('0.00',Valor);
  Respostas.Values['515'] := FormatDateTime('DDMMYYYY',DataHoraTransacao) ;
  Respostas.Values['516'] := NSU ;

  Sts := FazerRequisicao( fOperacaoCNC, 'CNC' ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( CACBrTEFCliSiTef_ImprimeGerencialConcomitante ) ;

  Result := ( Sts = 0 ) ;

  if not Result then
     AvaliaErro( Sts )
  else
     if not CACBrTEFCliSiTef_ImprimeGerencialConcomitante then
        ProcessarResposta;
end;

function TACBrTEFDCliSiTef.PRE(Valor: Double; DocumentoVinculado: String;
  Moeda: Integer): Boolean;
var
   Sts : Integer;
begin
  Sts := FazerRequisicao( fOperacaoPRE, 'PRE', Valor, '', fRestricoes ) ;

  if Sts = 10000 then
     Sts := ContinuarRequisicao( CACBrTEFCliSiTef_ImprimeGerencialConcomitante ) ;

  Result := ( Sts = 0 ) ;

  if not Result then
     AvaliaErro( Sts )
  else
     if not CACBrTEFCliSiTef_ImprimeGerencialConcomitante then
        ProcessarResposta;
end;

procedure TACBrTEFDCliSiTef.NCN(Rede, NSU, Finalizacao: String; Valor: Double;
  DocumentoVinculado: String);
begin
  // CliSiTEF n�o usa Rede, NSU, Finalizacao e Valor
  FinalizarTransacao( False, DocumentoVinculado, Finalizacao );
end;

function TACBrTEFDCliSiTef.ObtemDadoPinPadDiretoEx(Tipo_Doc: Integer; ChaveAcesso,
  Identificador: PAnsiChar): AnsiString;
 var
  Saida   : array of Byte;
  Retorno : Integer;
  Caracter: Char;
  sSaida  : string;
  I       : Integer;

 const
  EntradaCelular = '011111NUMERO CELULAR                  CONFIRME NUMERO |(xx) xxxxx-xxxx  ';
  EntradaCPF     = '011111DIGITE O CPF                    CONFIRME O CPF  |xxx.xxx.xxx-xx  ';
  EntradaCNPJ    =                                                             //
   '020808INFORME CNPJ P1                 CONFIRME P1     |xx.xxx.xxx      ' + //
   '0606INFORME CNPJ P2                 CONFIRME P2     |xxxx-xx         ';

 begin
  if Assigned(xObtemDadoPinPadDiretoEx) then
   begin
    Result := '';
    SetLength(Saida, 15);

    case Tipo_Doc of
     1:
      begin
       Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCPF), Saida);
      end;
     2:
      begin
       Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCNPJ), Saida);
      end;
     3:
      begin
       Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCelular), Saida);
      end;
    else
      Retorno := -1;
    end;
    if Retorno = 0 then
     begin
      sSaida := '';
      case Tipo_Doc of
       1:
        begin
         for I := 4 to 14 do
          begin
           Caracter := Char(Saida[I]);
           sSaida   := sSaida + Caracter;
          end;
        end;
       2:
        begin
         for I := 4 to 19 do
          begin
           Caracter := Char(Saida[I]);
           sSaida   := sSaida + Caracter;
          end;
         Delete(sSaida, 9, 2);
        end;
       3:
        begin
         for I := 4 to 14 do
          begin
           Caracter := Char(Saida[I]);
           sSaida   := sSaida + Caracter;
          end;
        end;

      end;
      Result := sSaida;
     end;
    Saida := nil;
   end
  else
   begin
    raise EACBrTEFDErro.Create(ACBrStr(CACBrTEFCliSiTef_NaoInicializado));
   end;
end;

function TACBrTEFDCliSiTef.ObtemQuantidadeTransacoesPendentes(Data:TDateTime;
  CupomFiscal: AnsiString): Integer;
var
  sDate:AnsiString;
begin
   sDate:= FormatDateTime('yyyymmdd',Data);
   if Assigned(xObtemQuantidadeTransacoesPendentes) then
      Result := xObtemQuantidadeTransacoesPendentes(sDate,CupomFiscal)
   else
      raise EACBrTEFDErro.Create( ACBrStr( CACBrTEFCliSiTef_NaoInicializado ) ) ;
end;

function TACBrTEFDCliSiTef.EnviaRecebeSiTefDireto(RedeDestino: SmallInt;
  FuncaoSiTef: SmallInt; OffsetCartao: SmallInt; DadosTx: AnsiString;
  var DadosRx: AnsiString; var CodigoResposta: SmallInt;
  TempoEsperaRx: SmallInt; CuponFiscal: AnsiString; Confirmar: Boolean
  ): Integer;
var
  Buffer: array [0..20000] of AnsiChar;
  ANow: TDateTime;
  DataStr, HoraStr: String;
begin
  ANow    := Now ;
  DataStr := FormatDateTime('YYYYMMDD', ANow );
  HoraStr := FormatDateTime('HHNNSS', ANow );
  Buffer := #0;
  FillChar(Buffer, SizeOf(Buffer), 0);

  GravaLog( 'EnviaRecebeSiTefDireto -> Rede:' +IntToStr(RedeDestino) +', Funcao:'+
            IntToStr(FuncaoSiTef)+', OffSetCartao:'+IntToStr(OffsetCartao)+', DadosTX:'+
            DadosTx+', TimeOut'+IntToStr(TempoEsperaRx)+' Cupom:'+CuponFiscal+', '+
            ifthen(Confirmar,'Confirmar','NAO Confirmar'), True );

  Result := xEnviaRecebeSiTefDireto( RedeDestino,
                           FuncaoSiTef,
                           OffsetCartao,
                           DadosTx,
                           Length(DadosTx)+1,
                           Buffer,
                           SizeOf(Buffer),
                           CodigoResposta,
                           TempoEsperaRx,
                           CuponFiscal, DataStr, HoraStr, fOperador,
                           IfThen(Confirmar,1,0) );

  DadosRx := TrimRight( LeftStr(Buffer,max(Result,0)) ) ;
end;

function TACBrTEFDCliSiTef.FazerRequisicao(Funcao: Integer;
  AHeader: AnsiString; Valor: Double; Documento: AnsiString;
  ListaRestricoes: AnsiString): Integer;
Var
  ValorStr, DataStr, HoraStr : AnsiString;
  DataHora : TDateTime ;
begin
   if not Assigned(xIniciaFuncaoSiTefInterativo) then
      raise EACBrTEFDErro.Create(ACBrStr(CACBrTEFCliSiTef_NaoInicializado));

   if Documento = '' then
      Documento := DocumentoFiscal;

   Req.DocumentoVinculado  := Documento;
   Req.ValorTotal          := Valor;

   if fpAguardandoResposta then
      raise EACBrTEFDErro.Create( ACBrStr( CACBrTEFCliSiTef_NaoConcluido ) ) ;

   if (pos('{TipoTratamento=4}',ListaRestricoes) = 0) and
      (pos(AHeader,'CRT,CHQ') > 0 ) and
      SuportaDesconto then
   begin
      ListaRestricoes := ListaRestricoes + '{TipoTratamento=4}';
   end;

   fIniciouRequisicao := True;

   DataHora := DataHoraFiscal ;
   DataStr  := FormatDateTime('YYYYMMDD', DataHora );
   HoraStr  := FormatDateTime('HHNNSS', DataHora );
   ValorStr := FormatFloatBr( Valor );
   fDocumentosProcessados := '' ;

   GravaLog( '*** IniciaFuncaoSiTefInterativo. Modalidade: '+IntToStr(Funcao)+
                                             ' Valor: '     +ValorStr+
                                             ' Documento: ' +Documento+
                                             ' Data: '      +DataStr+
                                             ' Hora: '      +HoraStr+
                                             ' Operador: '  +fOperador+
                                             ' Restricoes: '+ListaRestricoes ) ;

   Result := xIniciaFuncaoSiTefInterativo( Funcao,
                                           PAnsiChar( ValorStr ),
                                           PAnsiChar( Documento ),
                                           PAnsiChar( DataStr ),
                                           PAnsiChar( HoraStr ),
                                           PAnsiChar( fOperador ),
                                           PAnsiChar( ListaRestricoes ) ) ;

   { Adiciona Campos j� conhecidos em Resp, para processa-los em
     m�todos que manipulam "RespostasPendentes" (usa c�digos do G.P.)  }
   Resp.Clear;

   with TACBrTEFDRespCliSiTef( Resp ) do
   begin
     fpIDSeq := fpIDSeq + 1 ;
     if Documento = '' then
        Documento := IntToStr(fpIDSeq) ;

     Conteudo.GravaInformacao(899,100, AHeader ) ;
     Conteudo.GravaInformacao(899,101, IntToStr(fpIDSeq) ) ;
     Conteudo.GravaInformacao(899,102, Documento ) ;
     Conteudo.GravaInformacao(899,103, IntToStr(Trunc(SimpleRoundTo( Valor * 100 ,0))) );

     Resp.TipoGP := fpTipo;
   end;
end;

function TACBrTEFDCliSiTef.ContinuarRequisicao(ImprimirComprovantes: Boolean
  ): Integer;
var
  Continua, ItemSelecionado, I: Integer;
  ProximoComando,TamanhoMinimo, TamanhoMaximo : SmallInt;
  TipoCampo: LongInt;
  Buffer: array [0..20000] of AnsiChar;
  Mensagem, MensagemOperador, MensagemCliente, CaptionMenu : String ;
  Resposta : AnsiString;
  SL : TStringList ;
  Interromper, Digitado, GerencialAberto, FechaGerencialAberto, ImpressaoOk,
     HouveImpressao, Voltar : Boolean ;
  Est : AnsiChar;

  function ProcessaMensagemTela( AMensagem : String ) : String ;
  begin
    Result := StringReplace( AMensagem, '@', sLineBreak, [rfReplaceAll] );
    Result := StringReplace( Result, '/n', sLineBreak, [rfReplaceAll] );
  end;

begin
   ProximoComando    := 0;
   TipoCampo         := 0;
   TamanhoMinimo     := 0;
   TamanhoMaximo     := 0;
   Continua          := 0;
   Mensagem          := '' ;
   MensagemOperador  := '' ;
   MensagemCliente   := '' ;
   CaptionMenu       := '' ;
   GerencialAberto   := False ;
   ImpressaoOk       := True ;
   HouveImpressao    := False ;
   fIniciouRequisicao:= True ;
   fCancelamento     := False ;
   fReimpressao      := False;
   Interromper       := False;
   fArqBackUp        := '' ;
   Resposta          := '' ;

   fpAguardandoResposta := True ;
   FechaGerencialAberto := True ;

   with TACBrTEFD(Owner) do
   begin
      try
         BloquearMouseTeclado( True );

         repeat
            GravaLog( 'ContinuaFuncaoSiTefInterativo, Chamando: Continua = '+
                      IntToStr(Continua)+' Buffer = '+Resposta ) ;

            Result := xContinuaFuncaoSiTefInterativo( ProximoComando,
                                                      TipoCampo,
                                                      TamanhoMinimo, TamanhoMaximo,
                                                      Buffer, sizeof(Buffer),
                                                      Continua );
            Continua := 0;
            Mensagem := TrimRight( Buffer ) ;
            Resposta := '' ;
            Voltar   := False;
            Digitado := True ;

            if fUsaUTF8 then
              Mensagem := ACBrStrToAnsi(Mensagem);  // Ser� convertido para UTF8 em TACBrTEFD.DoExibeMsg

            GravaLog( 'ContinuaFuncaoSiTefInterativo, Retornos: STS = '+IntToStr(Result)+
                      ' ProximoComando = '+IntToStr(ProximoComando)+
                      ' TipoCampo = '+IntToStr(TipoCampo)+
                      ' Buffer = '+Mensagem +
                      ' Tam.Min = '+IntToStr(TamanhoMinimo) +
                      ' Tam.Max = '+IntToStr(TamanhoMaximo)) ;

            if Result = 10000 then
            begin
              if TipoCampo > 0 then
                 Resposta := fRespostas.Values[IntToStr(TipoCampo)];

              case ProximoComando of
                 0 :
                   begin
                     TACBrTEFDRespCliSiTef( Self.Resp ).GravaInformacao( TipoCampo, Mensagem ) ;

                     case TipoCampo of
                        15 : TACBrTEFDRespCliSiTef( Self.Resp ).GravaInformacao( TipoCampo, 'True') ;//Selecionou Debito;
                        25 : TACBrTEFDRespCliSiTef( Self.Resp ).GravaInformacao( TipoCampo, 'True') ;//Selecionou Credito;
                        29 : TACBrTEFDRespCliSiTef( Self.Resp ).GravaInformacao( TipoCampo, 'True') ;//Cart�o Digitado;
                        {Indica que foi escolhido menu de reimpress�o}
                        56,57,58 : fReimpressao := True;
                        110      : fCancelamento:= True;
                        121, 122 :
                          if ImprimirComprovantes then
                          begin
                             { Impress�o de Gerencial, deve ser Sob demanda }
                             if not HouveImpressao then
                             begin
                                HouveImpressao := True ;
                                fArqBackUp := CopiarResposta;
                             end;

                             SL := TStringList.Create;
                             ImpressaoOk := False ;
                             I := TipoCampo ;
                             try
                                while not ImpressaoOk do
                                begin
                                  try
                                    while I <= TipoCampo do
                                    begin
                                       if FechaGerencialAberto then
                                       begin
                                         Est := EstadoECF;

                                         { Fecha Vinculado ou Gerencial ou Cupom, se ficou algum aberto por Desligamento }
                                         case Est of
                                           'C'         : ComandarECF( opeFechaVinculado );
                                           'G','R'     : ComandarECF( opeFechaGerencial );
                                           'V','P','N' : ComandarECF( opeCancelaCupom );
                                         end;

                                         GerencialAberto      := False ;
                                         FechaGerencialAberto := False ;

                                         if EstadoECF <> 'L' then
                                           raise EACBrTEFDECF.Create( ACBrStr(CACBrTEFD_Erro_ECFNaoLivre) ) ;
                                       end;

                                       Mensagem := Self.Resp.LeInformacao(I).AsString ;
                                       Mensagem := StringToBinaryString( Mensagem ) ;
                                       if Mensagem <> '' then
                                       begin
                                          SL.Text  := StringReplace( Mensagem, #10, sLineBreak, [rfReplaceAll] ) ;

                                          if not GerencialAberto then
                                           begin
                                             ComandarECF( opeAbreGerencial ) ;
                                             GerencialAberto := True ;
                                           end
                                          else
                                           begin
                                             ComandarECF( opePulaLinhas ) ;
                                             DoExibeMsg( opmDestaqueVia,
                                                Format(CACBrTEFD_DestaqueVia, [1]) ) ;
                                           end;

                                          ECFImprimeVia( trGerencial, I-120, SL );

                                          ImpressaoOk := True ;
                                       end;

                                       Inc( I ) ;
                                    end;

                                    if (TipoCampo = 122) and GerencialAberto then
                                    begin
                                       ComandarECF( opeFechaGerencial );
                                       GerencialAberto := False;
                                    end;
                                  except
                                    on EACBrTEFDECF do ImpressaoOk := False ;
                                    else
                                       raise ;
                                  end;

                                  if not ImpressaoOk then
                                  begin
                                    if DoExibeMsg( opmYesNo, CACBrTEFD_Erro_ECFNaoResponde ) <> mrYes then
                                      break ;

                                    I := 121 ;
                                    FechaGerencialAberto := True ;
                                  end;
                                end ;
                             finally
                                if not ImpressaoOk then
                                   Continua := -1 ;

                                SL.Free;
                             end;
                          end ;
                        1, 133, 952:
                        begin
                          fArqBackUp := CopiarResposta;
                        end;
                     end;
                   end;

                 1 :
                   begin
                     MensagemOperador := ProcessaMensagemTela( Mensagem );
                     DoExibeMsg( opmExibirMsgOperador, MensagemOperador, (TipoCampo=5005) ) ;
                   end ;

                 2 :
                   begin
                     MensagemCliente := ProcessaMensagemTela( Mensagem );
                     DoExibeMsg( opmExibirMsgCliente, MensagemCliente, (TipoCampo=5005) ) ;
                   end;

                 3 :
                   begin
                     MensagemOperador := ProcessaMensagemTela( Mensagem );
                     MensagemCliente  := MensagemOperador;
                     DoExibeMsg( opmExibirMsgOperador, MensagemOperador, (TipoCampo=5005) ) ;
                     DoExibeMsg( opmExibirMsgCliente, MensagemCliente, (TipoCampo=5005) ) ;
                   end ;

                 4 : CaptionMenu := ACBrStr( Mensagem ) ;

                 11 :
                   begin
                     MensagemOperador := '' ;
                     DoExibeMsg( opmRemoverMsgOperador, '' ) ;
                   end;

                 12 :
                   begin
                     MensagemCliente := '' ;
                     DoExibeMsg( opmRemoverMsgCliente, '' ) ;
                   end;

                 13 :
                   begin
                     DoExibeMsg( opmRemoverMsgOperador, '' ) ;
                     DoExibeMsg( opmRemoverMsgCliente, '' ) ;
                   end ;

                 14 : CaptionMenu := '' ;
                   {Deve limpar o texto utilizado como cabe�alho na apresenta��o do menu}

                 20 :
                   begin
                     if Mensagem = '' then
                        Mensagem := 'CONFIRMA ?';

                     Resposta := ifThen( (DoExibeMsg( opmYesNo, Mensagem ) = mrYes), '0', '1' ) ;

                     // se a resposta a mensagem for n�o, n�o deixar interromper
                     // voltar ao loop
                     if (TipoCampo = 5013) and (Resposta = '1') then
                       Interromper := False;
                   end ;

                 21 :
                   begin
                     SL := TStringList.Create;
                     try
                        ItemSelecionado := -1 ;
                        SL.Text := StringReplace( Mensagem, ';',
                                                         sLineBreak, [rfReplaceAll] ) ;
                        BloquearMouseTeclado(False);
                        OnExibeMenu( CaptionMenu, SL, ItemSelecionado, Voltar ) ;
                        BloquearMouseTeclado(True);

                        if (not Voltar) then
                        begin
                           if (ItemSelecionado >= 0) and
                              (ItemSelecionado < SL.Count) then
                              Resposta := copy( SL[ItemSelecionado], 1,
                                             pos(':',SL[ItemSelecionado])-1 )
                           else
                              Digitado := False ;
                        end;
                     finally
                        SL.Free ;
                     end ;
                   end;

                 22 :
                   begin
                     if Mensagem = '' then
                        Mensagem := CACBrTEFCliSiTef_PressioneEnter;

                     DoExibeMsg( opmOK, Mensagem );
                   end ;

                 23 :
                   begin
                     Interromper := False ;
                     OnAguardaResp( '23', 0, Interromper ) ;
                     if Interromper then
                        Continua := -1 ;
                   end;

                 30 :
                   begin
                     BloquearMouseTeclado(False);
                     OnObtemCampo( ACBrStr(Mensagem), TamanhoMinimo, TamanhoMaximo,
                                   TipoCampo, tcString, Resposta, Digitado, Voltar) ;
                     {Se o tipo campo for 505 � a quantidade de parcelas}
                     TACBrTEFDRespCliSiTef( Self.Resp ).GravaInformacao( TipoCampo, Resposta ) ;
                     BloquearMouseTeclado(True);
                   end;

                 31 :
                   begin
                     BloquearMouseTeclado(False);
                     OnObtemCampo( ACBrStr(Mensagem), TamanhoMinimo, TamanhoMaximo,
                                   TipoCampo, tcCMC7, Resposta, Digitado, Voltar ) ;
                     BloquearMouseTeclado(True);
                   end;

                 34 :
                   begin
                     BloquearMouseTeclado(False);
                     OnObtemCampo( ACBrStr(Mensagem), TamanhoMinimo, TamanhoMaximo,
                                   TipoCampo, tcDouble, Resposta, Digitado, Voltar ) ;
                     BloquearMouseTeclado(True);

                     // Garantindo que a Resposta � Float //
                     Resposta := FormatFloatBr( StringToFloatDef(Resposta, 0));
                   end;

                 35 :
                   begin
                     BloquearMouseTeclado(False);
                     OnObtemCampo( ACBrStr(Mensagem), TamanhoMinimo, TamanhoMaximo,
                                   TipoCampo, tcBarCode, Resposta, Digitado, Voltar ) ;
                     BloquearMouseTeclado(True);
                   end;

                 41 :
                   begin
                     BloquearMouseTeclado(False);
                     OnObtemCampo( ACBrStr(Mensagem), TamanhoMinimo, TamanhoMaximo,
                                   TipoCampo, tcStringMask, Resposta, Digitado, Voltar ) ;
                     BloquearMouseTeclado(True);
                   end;

              end;
            end
            else
               GravaLog( '*** ContinuaFuncaoSiTefInterativo, Finalizando: STS = '+IntToStr(Result) ) ;

            if Voltar then
               Continua := 1     { Volta para o menu anterior }
            else if (not Digitado) or Interromper then
               Continua := -1 ;  { Cancela operacao }

            if (Voltar and (Result = 10000)) or (not Digitado) then
            begin
              DoExibeMsg( opmRemoverMsgOperador, '' ) ;
              DoExibeMsg( opmRemoverMsgCliente, '' ) ;
            end ;

            StrPCopy(Buffer, Resposta);

         until Result <> 10000;
      finally
         if GerencialAberto then
         try
            ComandarECF( opeFechaGerencial );
         except
            ImpressaoOk := False ;
         end;

         if (fArqBackUp <> '') and FileExists( fArqBackUp ) then
            SysUtils.DeleteFile( fArqBackUp );

         if HouveImpressao or ( ImprimirComprovantes and fCancelamento) then
            FinalizarTransacao( ImpressaoOk, Resp.DocumentoVinculado );

         BloquearMouseTeclado( False );

         { Transfere valore de "Conteudo" para as propriedades }
         if LogDebug then
            GravaLog( Self.Resp.Conteudo.Conteudo.Text );

         TACBrTEFDRespCliSiTef( Self.Resp ).ConteudoToProperty ;

         if (HouveImpressao and fCancelamento) then
            DoExibeMsg( opmOK,
                        Format( CACBrTEFCliSiTef_TransacaoEfetuadaReImprimir,
                                [Resp.NSU]) ) ;

         fpAguardandoResposta := False ;
      end;
   end ;
end;

function TACBrTEFDCliSiTef.CopiarResposta: string;
begin
  if Trim(fArqBackUp) <> '' then
  begin
    if FileExists(fArqBackUp) then
    begin
      if not SysUtils.DeleteFile(fArqBackUp) then
        raise EFilerError.CreateFmt('N�o foi possivel apagar o arquivo "%s" de backup!', [fArqBackUp]);
    end;

    fArqBackUp := '';
  end;

  Result := inherited CopiarResposta;
end;

procedure TACBrTEFDCliSiTef.ProcessarResposta;
var
   RespostaPendente: TACBrTEFDRespCliSiTef;
begin
  GravaLog( Name +' ProcessarResposta: '+Req.Header );

  TACBrTEFD(Owner).EstadoResp := respProcessando;

  if Resp.QtdLinhasComprovante > 0 then
  begin
      { Cria c�pia do Objeto Resp, e salva no ObjectList "RespostasPendentes" }
      RespostaPendente := TACBrTEFDRespCliSiTef.Create ;
      try
         RespostaPendente.Assign( Resp );
         TACBrTEFD(Owner).RespostasPendentes.Add( RespostaPendente );

         ImprimirRelatorio ;

         with TACBrTEFD(Owner) do
         begin
            if Assigned( OnDepoisConfirmarTransacoes ) then
               OnDepoisConfirmarTransacoes( RespostasPendentes );
         end ;
      finally
         TACBrTEFD(Owner).RespostasPendentes.Clear;
      end;
  end ;
end;

procedure TACBrTEFDCliSiTef.FinalizarTransacao(Confirma: Boolean;
  DocumentoVinculado: AnsiString; ParamAdic: AnsiString);
Var
   DataStr, HoraStr : AnsiString;
   Finalizacao : SmallInt;
   AMsg: String;
   Est: AnsiChar;
begin
   fRespostas.Clear;
   fIniciouRequisicao := False;

   { Re-Impress�o n�o precisa de Finaliza��o }
   if fReimpressao then
      exit ;

   { J� Finalizou este Documento por outra Transa��o ? }
   if (pos(DocumentoVinculado, fDocumentosProcessados) > 0) then
      exit;

  fDocumentosProcessados := fDocumentosProcessados + DocumentoVinculado + '|' ;

  if Assigned(Resp) and (Resp.DataHoraTransacaoComprovante > (date - 3)) then
  begin
     // Leu com sucesso o arquivo pendente.
     // Transa��es com mais de tr�s dias s�o finalizadas automaticamente pela SiTef
     DataStr := FormatDateTime('YYYYMMDD',Resp.DataHoraTransacaoComprovante);
     HoraStr := FormatDateTime('HHNNSS',Resp.DataHoraTransacaoComprovante);
  end
  else
  begin
     DataStr := FormatDateTime('YYYYMMDD',Now);
     HoraStr := FormatDateTime('HHNNSS',Now);
  end;

  Finalizacao := ifthen(Confirma or fCancelamento,1,0);

  GravaLog( '*** FinalizaTransacaoSiTefInterativo. Confirma: '+
                                          IfThen(Finalizacao = 1,'SIM','NAO')+
                                          ' Documento: ' +DocumentoVinculado+
                                          ' Data: '      +DataStr+
                                          ' Hora: '      +HoraStr ) ;

  xFinalizaFuncaoSiTefInterativo( Finalizacao,
                                  PAnsiChar( DocumentoVinculado ),
                                  PAnsiChar( DataStr ),
                                  PAnsiChar( HoraStr ),
                                  PAnsiChar( ParamAdic ) ) ;

  if not Confirma then
  begin
     if fCancelamento then
        AMsg := Format( CACBrTEFCliSiTef_TransacaoEfetuadaReImprimir, [Resp.NSU])
     else
     begin
        try
           Est := TACBrTEFD(Owner).EstadoECF;
        except
           Est := 'O' ;
        end;

        if (Est = 'O') then
           AMsg := CACBrTEFCliSiTef_TransacaoNaoEfetuada
        else
           AMsg := CACBrTEFCliSiTef_TransacaoNaoEfetuadaReterCupom;
     end;

     TACBrTEFD(Owner).DoExibeMsg( opmOK, AMsg );
  end;
end;

{ Valores de Retorno:
  0 - se o c�digo estiver correto;
  1 a 4 - Indicando qual o bloco que est� com erro
  5 - Um ou mais blocos com erro

  Tipo: tipo de documento sendo coletado:
        -1: Ainda n�o identificado
        0: Arrecada��o
        1: Titulo
}
function TACBrTEFDCliSiTef.ValidaCampoCodigoEmBarras(Dados: AnsiString;
  var Tipo: SmallInt): Integer;
begin
  GravaLog('ValidaCodigoEmBarras -> Dados:' + Dados, True);

  if Assigned(xValidaCampoCodigoEmBarras) then
    Result := xValidaCampoCodigoEmBarras(Dados,Tipo)
  else
    raise EACBrTEFDErro.Create(ACBrStr(CACBrTEFCliSiTef_NaoInicializado));
end;

procedure TACBrTEFDCliSiTef.AvaliaErro( Sts : Integer );
var
   Erro : String;
begin
   if not fExibirErroRetorno then
     Exit;

   Erro := '' ;
   Case Sts of
        -1 : Erro := 'M�dulo n�o inicializado' ;
        -2 : Erro := 'Opera��o cancelada pelo operador' ;
        -3 : Erro := 'Fornecido um c�digo de fun��o inv�lido' ;
        -4 : Erro := 'Falta de mem�ria para rodar a fun��o' ;
        -5 : Erro := '' ; // 'Sem comunica��o com o SiTef' ; // Comentado pois SiTEF j� envia a msg de Erro
        -6 : Erro := 'Opera��o cancelada pelo usu�rio' ;
        -40: Erro := 'Transa��o negada pelo SiTef';
        -43: Erro := 'Falha no pinpad';
        -50: Erro := 'Transa��o n�o segura';
        -100: Erro := 'Erro interno do m�dulo';
   else
      if Sts < 0 then
         Erro := 'Erros detectados internamente pela rotina ('+IntToStr(Sts)+')'
      else
         Erro := 'Negada pelo autorizador ('+IntToStr(Sts)+')' ;
   end;

   if Erro <> '' then
      TACBrTEFD(Owner).DoExibeMsg( opmOK, Erro );
end ;

function TACBrTEFDCliSiTef.GetDataHoraFiscal: TDateTime;
begin
  if (csDesigning in Owner.ComponentState) then
     Result := fDataHoraFiscal
  else
     if fDataHoraFiscal = 0 then
        Result := Now
     else
        Result := fDataHoraFiscal;
end;

function TACBrTEFDCliSiTef.GetDocumentoFiscal: AnsiString;
begin
  if (csDesigning in Owner.ComponentState) then
     Result := fDocumentoFiscal
  else
     if fDocumentoFiscal = '' then
        Result := HMS
     else
        Result := fDocumentoFiscal;
end;


function TACBrTEFDCliSiTef.ProcessarRespostaPagamento(
  const IndiceFPG_ECF: String; const Valor: Double): Boolean;
var
  ImpressaoOk : Boolean;
  RespostaPendente : TACBrTEFDResp ;
begin
  Result := True ;

  with TACBrTEFD(Owner) do
  begin
     Self.Resp.IndiceFPG_ECF := IndiceFPG_ECF;

     { Cria Arquivo de Backup, contendo Todas as Respostas }

     CopiarResposta ;

     { Cria c�pia do Objeto Resp, e salva no ObjectList "RespostasPendentes" }
     RespostaPendente := TACBrTEFDRespCliSiTef.Create ;
     RespostaPendente.Assign( Resp );
     RespostasPendentes.Add( RespostaPendente );

     if AutoEfetuarPagamento then
     begin
        ImpressaoOk := False ;

        try
           while not ImpressaoOk do
           begin
              try
                 ECFPagamento( IndiceFPG_ECF, Valor );
                 RespostasPendentes.SaldoAPagar  := RoundTo( RespostasPendentes.SaldoAPagar - Valor, -2 ) ;
                 RespostaPendente.OrdemPagamento := RespostasPendentes.Count + 1 ;
                 ImpressaoOk := True ;
              except
                 on EACBrTEFDECF do ImpressaoOk := False ;
                 else
                    raise ;
              end;

              if not ImpressaoOk then
              begin
                 if DoExibeMsg( opmYesNo, CACBrTEFD_Erro_ECFNaoResponde ) <> mrYes then
                 begin
                    try ComandarECF(opeCancelaCupom); except {Exce��o Muda} end ;
                    break ;
                 end;
              end;
           end;
        finally
           if not ImpressaoOk then
              CancelarTransacoesPendentes;
        end;
     end;

     if RespostasPendentes.SaldoRestante <= 0 then
     begin
        if AutoFinalizarCupom then
        begin
           FinalizarCupom( False );  { False n�o desbloqueia o MouseTeclado }
           ImprimirTransacoesPendentes;
        end;
     end ;
  end;
end;

procedure TACBrTEFDCliSiTef.VerificarIniciouRequisicao;
begin
  if not fIniciouRequisicao then
     raise EACBrTEFDErro.Create( ACBrStr( CACBrTEFD_Erro_SemRequisicao ) ) ;
end;

function TACBrTEFDCliSiTef.SuportaDesconto: Boolean;
begin
  with TACBrTEFD(Owner) do
  begin
     Result := (Identificacao.SoftwareHouse <> '') and
               Assigned( OnComandaECFSubtotaliza ) and
               (not AutoEfetuarPagamento) ;
  end;
end;

function TACBrTEFDCliSiTef.HMS: String;
begin
   Result := FormatDateTime('hhmmss',Now);
end;

function TACBrTEFDCliSiTef.VerificaPresencaPinPad: Boolean;
begin
  GravaLog('VerificaPresencaPinpad', True);

  {
   Retornos:
      1: Existe um PinPad operacional conectado ao micro;
      0: Nao Existe um PinPad conectado ao micro;
     -1: Biblioteca de acesso ao PinPad n�o encontrada }

  if Assigned(xVerificaPresencaPinPad) then
    Result := ( xVerificaPresencaPinPad() = 1 )
  else
    raise EACBrTEFDErro.Create(ACBrStr(CACBrTEFCliSiTef_NaoInicializado));
end;


function TACBrTEFDCliSiTef.CDP(const EntidadeCliente: string; out Resposta: string): Boolean;
begin
  raise EACBrTEFDErro.Create( ACBrStr('N�o implementado para SiTef no momento. Use a fun��o "ObtemDadoPinPadDiretoEx".') ) ;
end;

end.
