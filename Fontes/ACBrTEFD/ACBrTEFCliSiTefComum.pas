{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrTEFCliSiTefComum;

interface

uses
  Classes, SysUtils,
  ACBrTEFComum;

const
  CACBrTEFCliSiTef_ImprimeGerencialConcomitante = False;
  CACBrTEFCliSiTef_PressioneEnter = 'PRESSIONE <ENTER>';
  CACBrTEFCliSiTef_TransacaoNaoEfetuada = 'Transação não efetuada.';
  CACBrTEFCliSiTef_TransacaoNaoEfetuadaReterCupom =
    'Transação não efetuada.' + sLineBreak + 'Favor reter o Cupom';
  CACBrTEFCliSiTef_TransacaoEfetuadaReImprimir =
    'Transação TEF efetuada.' + sLineBreak +
    'Favor reimprimir último Cupom.' + sLineBreak +
    '%s' + sLineBreak +
    '(Para Cielo utilizar os 6 últimos dígitos.)';
  CACBrTEFCliSiTef_NaoInicializado = 'CliSiTEF não inicializado';
  CACBrTEFCliSiTef_NaoConcluido = 'Requisição anterior não concluida';
  CACBrTEFCliSiTef_Erro1 = 'Endereço IP inválido ou não resolvido';
  CACBrTEFCliSiTef_Erro2 = 'Código da loja inválido';
  CACBrTEFCliSiTef_Erro3 = 'Código de terminal inválido';
  CACBrTEFCliSiTef_Erro6 = 'Erro na inicialização do TCP/IP';
  CACBrTEFCliSiTef_Erro7 = 'Falta de memória';
  CACBrTEFCliSiTef_Erro8 = 'Não encontrou a CliSiTef ou ela está com problemas';
  CACBrTEFCliSiTef_Erro10 = 'Erro de acesso na pasta CliSiTef (possível falta de permissão para escrita) ' + sLineBreak +
    'ou o PinPad não está devidamente configurado no arquivo CliSiTef.ini ' + sLineBreak +
    'ou parâmetros IdLoja e IdTerminal inválidos';
  CACBrTEFCliSiTef_Erro11 = 'Dados inválidos passados pela automação.';
  CACBrTEFCliSiTef_Erro12 = 'Modo seguro não ativo (possível falta de configuração no servidor SiTef do arquivo .cha).';
  CACBrTEFCliSiTef_Erro13 = 'Caminho da DLL inválido (o caminho completo das bibliotecas está muito grande).';

{$IFDEF LINUX}
  CACBrTEFCliSiTef_Lib = 'libclisitef.so';
{$ELSE}
  CACBrTEFCliSiTef_Lib = 'CliSiTef32I.dll';
{$ENDIF}


type

  TACBrTEFRespHack = class(TACBrTEFResp);    // Hack para acessar conteudo Protected

  { TACBrTEFRespCliSiTef }

  TACBrTEFRespCliSiTef = class(TACBrTEFResp)
  public
    procedure ConteudoToProperty; override;
    procedure GravaInformacao(const Identificacao: Integer; const Informacao: AnsiString);
  end;

  { TACBrTEFCliSiTefAPI }

  TACBrTEFCliSiTefAPI = class
  private
    fInicializada: Boolean;
    fPathDLL: string;

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

    xObtemDadoPinPadDiretoEx: function(ChaveAcesso: PAnsiChar;
       Identificador: PAnsiChar; Entrada: PAnsiChar; Saida: PAnsiChar): Integer;
    {$IFDEF LINUX} cdecl {$ELSE} stdcall {$ENDIF};

    procedure SetInicializada(AValue: Boolean);

    procedure LoadDLLFunctions;
    procedure UnLoadDLLFunctions;
  public
    constructor Create;
    destructor Destroy; override;

    function TraduzirErro(Sts : Integer): String;

    function ConfiguraIntSiTefInterativo(
               pEnderecoIP: PAnsiChar;
               pCodigoLoja: PAnsiChar;
               pNumeroTerminal: PAnsiChar;
               ConfiguraResultado: smallint;
               pParametrosAdicionais: PAnsiChar): integer;

    function IniciaFuncaoSiTefInterativo(
               Modalidade: integer;
               pValor: PAnsiChar;
               pNumeroCuponFiscal: PAnsiChar;
               pDataFiscal: PAnsiChar;
               pHorario: PAnsiChar;
               pOperador: PAnsiChar;
               pRestricoes: PAnsiChar ): integer;

    function ContinuaFuncaoSiTefInterativo(
               var ProximoComando: SmallInt;
               var TipoCampo: LongInt;
               var TamanhoMinimo: SmallInt;
               var TamanhoMaximo: SmallInt;
               pBuffer: PAnsiChar;
               TamMaxBuffer: Integer;
               ContinuaNavegacao: Integer ): integer;

    procedure FinalizaFuncaoSiTefInterativo(
                pConfirma: SmallInt;
                pCupomFiscal: PAnsiChar;
                pDataFiscal: PAnsiChar;
                pHoraFiscal: PAnsiChar;
                pParamAdic: PAnsiChar);

    Function DefineMensagemPermanentePinPad(Mensagem:AnsiString):Integer;
    Function ObtemQuantidadeTransacoesPendentes(Data:TDateTime;
       CupomFiscal:AnsiString):Integer;
    function EnviaRecebeSiTefDireto(RedeDestino: SmallInt; FuncaoSiTef: SmallInt;
      OffsetCartao: SmallInt; DadosTx: AnsiString; var DadosRx: AnsiString;
      var CodigoResposta: SmallInt; TempoEsperaRx: SmallInt;
      CupomFiscal: AnsiString; Confirmar: Boolean; Operador: AnsiString): Integer;
    function ValidaCampoCodigoEmBarras(Dados: AnsiString;
       var Tipo: SmallInt): Integer;
    function VerificaPresencaPinPad: Boolean;
    function ObtemDadoPinPadDiretoEx(TipoDocumento: Integer; ChaveAcesso,
      Identificador: AnsiString): AnsiString;

    property PathDLL: string read fPathDLL write fPathDLL;
    property Inicializada: Boolean read fInicializada write SetInicializada;
  end;

procedure ConteudoToPropertyCliSiTef(AACBrTEFResp: TACBrTEFResp);

implementation

uses
  strutils, Math, dateutils,
  ACBrUtil;

procedure ConteudoToPropertyCliSiTef(AACBrTEFResp: TACBrTEFResp);
var
  I, wTipoOperacao, wNumCB: Integer;
  wTotalParc, wValParc: Double;
  Parc: TACBrTEFRespParcela;
  Linha: TACBrTEFLinha;
  CB: TACBrTEFRespCB;
  LinStr: AnsiString;
begin
  with TACBrTEFRespHack(AACBrTEFResp) do     // Hack para acessar conteudo Protected
  begin
    fpValorTotal := 0;
    fpImagemComprovante1aVia.Clear;
    fpImagemComprovante2aVia.Clear;
    fpDebito := False;
    fpCredito := False;
    fpDigitado := False;

    for I := 0 to Conteudo.Count - 1 do
    begin
      Linha := Conteudo.Linha[I];
      LinStr := StringToBinaryString(Linha.Informacao.AsString);

      case Linha.Identificacao of
        29: fpDigitado := (LinStr = 'True');
        // TODO: Mapear mais propriedades do CliSiTef //
        100:
        begin
          fpModalidadePagto := LinStr;

          case StrToIntDef(Copy(fpModalidadePagto, 1, 2), 0) of
            01: fpDebito := True;
            02: fpCredito := True;
          end;

          wTipoOperacao := StrToIntDef(Copy(fpModalidadePagto, 3, 2), 0);
          {Tipo de Parcelamento}
          case wTipoOperacao of
            02: fpParceladoPor := parcLoja;
            03: fpParceladoPor := parcADM;
          end;

          case wTipoOperacao of
            00: fpTipoOperacao := opAvista;
            01: fpTipoOperacao := opPreDatado;
            02, 03: fpTipoOperacao := opParcelado;
          else
            fpTipoOperacao := opOutras;
          end;
        end;

        101: fpModalidadePagtoExtenso := LinStr;
        102: fpModalidadePagtoDescrita := LinStr;
        105:
        begin
          fpDataHoraTransacaoComprovante := Linha.Informacao.AsTimeStampSQL;
          fpDataHoraTransacaoHost := fpDataHoraTransacaoComprovante;
          fpDataHoraTransacaoLocal := fpDataHoraTransacaoComprovante;
        end;

        120: fpAutenticacao := LinStr;
        121: fpImagemComprovante1aVia.Text := ChangeLineBreak(LinStr, sLineBreak);
        122: fpImagemComprovante2aVia.Text := ChangeLineBreak(LinStr, sLineBreak);
        123: fpTipoTransacao := Linha.Informacao.AsInteger;
        130:
        begin
          fpSaque := Linha.Informacao.AsFloat;
          fpValorTotal := fpValorTotal + fpSaque;
        end;

        131: fpInstituicao := LinStr;
        132: fpCodigoBandeiraPadrao := LinStr;
        135: fpCodigoAutorizacaoTransacao := LinStr;
        134: fpNSU := LinStr;
        136: fpBin := LinStr;
        139: fpValorEntradaCDC := Linha.Informacao.AsFloat;
        140: fpDataEntradaCDC := Linha.Informacao.AsDate;
        156: fpRede := LinStr;
        501: fpTipoPessoa := AnsiChar(IfThen(Linha.Informacao.AsInteger = 0, 'J', 'F')[1]);
        502: fpDocumentoPessoa := LinStr;
        504: fpTaxaServico := Linha.Informacao.AsFloat;
        505: fpQtdParcelas := Linha.Informacao.AsInteger;
        506: fpDataPreDatado := Linha.Informacao.AsDate;
        511: fpQtdParcelas := Linha.Informacao.AsInteger;  {Parcelas CDC - Neste caso o campo 505 não é retornado}
        515: fpDataHoraTransacaoCancelada := Linha.Informacao.AsDate;
        516: fpNSUTransacaoCancelada := LinStr;
        527: fpDataVencimento := Linha.Informacao.AsDate;         { Data Vencimento do Cheque }
        589: fpCodigoOperadoraCelular := LinStr;                  { Código da Operadora de Celular }
        590: fpNomeOperadoraCelular := LinStr;                    { Nome da Operadora de Celular }
        591: fpValorRecargaCelular := Linha.Informacao.AsFloat;   { Valor selecionado para a Recarga }
        592: fpNumeroRecargaCelular := LinStr;                    { Numero de Celular informado para Recarda }

        607:  // Indice do Correspondente Bancário
        begin
          wNumCB := Linha.Informacao.AsInteger;

          if (wNumCB = 1) then
            fpCorrespBancarios.Clear;

          CB := TACBrTEFRespCB.Create;
          CB.DataVencimento := LeInformacao(600, wNumCB).AsDate;   { Data Vencimento do título - CB }
          CB.ValorPago := LeInformacao(601, wNumCB).AsFloat;       { Valor Pago do título - CB }
          CB.ValorOriginal := LeInformacao(602, wNumCB).AsFloat;   { Valor Original do título - CB }
          CB.Acrescimo := LeInformacao(603, wNumCB).AsFloat;       { Valor do Acréscimo - CB }
          CB.Desconto := LeInformacao(604, wNumCB).AsFloat;        { Valor do Desconto - CB }
          CB.DataPagamento := LeInformacao(605, wNumCB).AsDate;    { Data contábil do Pagamento - CB }
          CB.NSUTransacaoCB := LeInformacao(611, wNumCB).AsString; { NSU da Transação CB }
          CB.TipoDocumento := LeInformacao(612, wNumCB).AsInteger; { Tipo Docto CB - 0:Arrecadação/ 1:Título/ 2:Tributo }
          CB.NSUCancelamento := LeInformacao(623, wNumCB).AsString;{ NSU para cancelamento - CB }
          CB.Documento := LeInformacao(624, wNumCB).AsString;      { Linha Digitável/Código de Barras do documento pago}

          fpCorrespBancarios.Add(CB);
        end;

        609: fpCorrespBancarios.TotalTitulos := Linha.Informacao.AsFloat;       { Valor total dos títulos efetivamente pagos no caso de pagamento em lote }
        610: fpCorrespBancarios.TotalTitulosNaoPago := Linha.Informacao.AsFloat;{ Valor total dos títulos NÃO pagos no caso de pagamento em lote }
        613:
        begin
          fpCheque := copy(LinStr, 21, 6);
          fpCMC7 := LinStr;
        end;

        626: fpBanco := LinStr;
        627: fpAgencia := LinStr;
        628: fpAgenciaDC := LinStr;
        629: fpConta := LinStr;
        630: fpContaDC := LinStr;

        // dados de retorno da NFC-e/SAT
        950: fpNFCeSAT.CNPJCredenciadora := LinStr;
        951: fpNFCeSAT.Bandeira := LinStr;
        952: fpNFCeSAT.Autorizacao := LinStr;
        953: fpNFCeSAT.CodCredenciadora := LinStr;
        1002: fpNFCeSAT.DataExpiracao := LinStr;
        1003: fpNFCeSAT.DonoCartao := LinStr;
        1190: fpNFCeSAT.UltimosQuatroDigitos := LinStr;
        4029:
        begin
          fpDesconto := Linha.Informacao.AsFloat;
          fpValorTotal := fpValorTotal - fpDesconto;
        end;
      else
        ProcessarTipoInterno(Linha);
      end;
    end;

    fpQtdLinhasComprovante := max(fpImagemComprovante1aVia.Count, fpImagemComprovante2aVia.Count);

    // leitura de parcelas conforme nova documentação
    // 141 e 142 foram removidos em Setembro de 2014
    fpParcelas.Clear;
    if (fpQtdParcelas > 0) then
    begin
      wValParc := RoundABNT((fpValorTotal / fpQtdParcelas), -2);
      wTotalParc := 0;

      for I := 1 to fpQtdParcelas do
      begin
        Parc := TACBrTEFRespParcela.Create;
        if I = 1 then
        begin
          Parc.Vencimento := LeInformacao(140, I).AsDate;
          Parc.Valor := LeInformacao(524, I).AsFloat;
        end
        else
        begin
          Parc.Vencimento := IncDay(LeInformacao(140, I).AsDate, LeInformacao(508, I).AsInteger);
          Parc.Valor := LeInformacao(525, I).AsFloat;
        end;

        // caso não retorne os dados acima prencher com os defaults
        if Trim(Parc.NSUParcela) = '' then
          Parc.NSUParcela := NSU;

        if Parc.Vencimento <= 0 then
          Parc.Vencimento := IncDay(fpDataHoraTransacaoHost, I * 30);

        if Parc.Valor <= 0 then
        begin
          if (I = fpQtdParcelas) then
            wValParc := fpValorTotal - wTotalParc
          else
            wTotalParc := wTotalParc + wValParc;

          Parc.Valor := wValParc;
        end;

        fpParcelas.Add(Parc);
      end;
    end;
  end;
end;

{ TACBrTEFRespCliSiTef }

procedure TACBrTEFRespCliSiTef.ConteudoToProperty;
begin
  ConteudoToPropertyCliSiTef(Self);
end;

procedure TACBrTEFRespCliSiTef.GravaInformacao(const Identificacao: Integer; const Informacao: AnsiString);
var
  Sequencia: Integer;
  AsString: String;
begin
  Sequencia := 0;

  { Os Tipos abaixo, devem ter a Sequencia incrementada, se já foram salvos antes,
    pois o SiTef retorna o mesmo Tipo, para várias ocorrências do campo }
  case Identificacao of
    141, 142,            // 141 - Data Parcela, 142 - Valor Parcela
    600..607, 611..624:  // Dados do Corresp. Bancário
    begin
      Sequencia := 1;
      while (Trim(LeInformacao(Identificacao, Sequencia).AsString) <> '') do
        Inc(Sequencia);
    end;
  end;

  AsString := BinaryStringToString(Informacao);  // Converte #10 para "\x0A"
  fpConteudo.GravaInformacao(Identificacao, Sequencia, AsString);
end;


{ TACBrTEFCliSiTefAPI }

constructor TACBrTEFCliSiTefAPI.Create;
begin
  inherited;

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
end;

destructor TACBrTEFCliSiTefAPI.Destroy;
begin
  UnLoadDLLFunctions;
  inherited Destroy;
end;

procedure TACBrTEFCliSiTefAPI.SetInicializada(AValue: Boolean);
begin
  if fInicializada = AValue then
    Exit;

  if AValue then
    LoadDLLFunctions
  else
    UnLoadDLLFunctions;
end;

procedure TACBrTEFCliSiTefAPI.LoadDLLFunctions ;
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
       raise EACBrTEFErro.Create( ACBrStr( 'Erro ao carregar a função:'+FuncName+
                                           ' de: '+CACBrTEFCliSiTef_Lib ) ) ;
     end ;
   end ;
 end ;
begin
  if fInicializada then
    Exit;

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

  fInicializada := True;
end ;

procedure TACBrTEFCliSiTefAPI.UnLoadDLLFunctions;
var
   sLibName: String;
begin
  if not fInicializada then
    Exit;

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

  fInicializada := False;
end;

function TACBrTEFCliSiTefAPI.TraduzirErro(Sts: Integer): String;
begin
   Result := '' ;
   Case Sts of
     -1 : Result := 'Módulo não inicializado' ;
     -2 : Result := 'Operação cancelada pelo operador' ;
     -3 : Result := 'Fornecido um código de função inválido' ;
     -4 : Result := 'Falta de memória para rodar a função' ;
     -5 : Result := '' ; // 'Sem comunicação com o SiTef' ; // Comentado pois SiTEF já envia a msg de Result
     -6 : Result := 'Operação cancelada pelo usuário' ;
     -40: Result := 'Transação negada pelo SiTef';
     -43: Result := 'Falha no pinpad';
     -50: Result := 'Transação não segura';
     -100: Result := 'Result interno do módulo';
   else
     if Sts < 0 then
       Result := 'Erros detectados internamente pela rotina ('+IntToStr(Sts)+')'
     else
       Result := 'Negada pelo autorizador ('+IntToStr(Sts)+')' ;
   end;
end ;

function TACBrTEFCliSiTefAPI.ConfiguraIntSiTefInterativo(
  pEnderecoIP: PAnsiChar; pCodigoLoja: PAnsiChar; pNumeroTerminal: PAnsiChar;
  ConfiguraResultado: smallint; pParametrosAdicionais: PAnsiChar): integer;
begin
  LoadDLLFunctions;
  if Assigned(xConfiguraIntSiTefInterativoEx) then
    Result := xConfiguraIntSiTefInterativoEx( pEnderecoIP, pCodigoLoja, pNumeroTerminal,
                               ConfiguraResultado, pParametrosAdicionais)
  else
    Result := -1;
end;

function TACBrTEFCliSiTefAPI.IniciaFuncaoSiTefInterativo(Modalidade: integer;
  pValor: PAnsiChar; pNumeroCuponFiscal: PAnsiChar; pDataFiscal: PAnsiChar;
  pHorario: PAnsiChar; pOperador: PAnsiChar; pRestricoes: PAnsiChar): integer;
begin
  LoadDLLFunctions;
  if Assigned(xIniciaFuncaoSiTefInterativo) then
    Result := xIniciaFuncaoSiTefInterativo( Modalidade, pValor, pNumeroCuponFiscal,
                               pDataFiscal, pHorario, pOperador, pRestricoes)
  else
    Result := -1;
end;

function TACBrTEFCliSiTefAPI.ContinuaFuncaoSiTefInterativo(
  var ProximoComando: SmallInt; var TipoCampo: LongInt;
  var TamanhoMinimo: SmallInt; var TamanhoMaximo: SmallInt; pBuffer: PAnsiChar;
  TamMaxBuffer: Integer; ContinuaNavegacao: Integer): integer;
begin
  LoadDLLFunctions;
  if Assigned(xContinuaFuncaoSiTefInterativo) then
    Result := xContinuaFuncaoSiTefInterativo( ProximoComando, TipoCampo, TamanhoMinimo,
                               TamanhoMaximo, pBuffer, TamMaxBuffer, ContinuaNavegacao)
  else
    Result := -1;
end;

procedure TACBrTEFCliSiTefAPI.FinalizaFuncaoSiTefInterativo(
  pConfirma: SmallInt; pCupomFiscal: PAnsiChar; pDataFiscal: PAnsiChar;
  pHoraFiscal: PAnsiChar; pParamAdic: PAnsiChar);
begin
 LoadDLLFunctions;
 if Assigned(xFinalizaFuncaoSiTefInterativo) then
   xFinalizaFuncaoSiTefInterativo( pConfirma, pCupomFiscal, pDataFiscal,
                                   pHoraFiscal, pParamAdic);
end;

function TACBrTEFCliSiTefAPI.DefineMensagemPermanentePinPad(Mensagem:AnsiString):Integer;
begin
  LoadDLLFunctions;
  if Assigned(xEscreveMensagemPermanentePinPad) then
    Result := xEscreveMensagemPermanentePinPad(PAnsiChar(Mensagem))
  else
    Result := -1;
end;


function TACBrTEFCliSiTefAPI.ObtemQuantidadeTransacoesPendentes(Data:TDateTime;
  CupomFiscal: AnsiString): Integer;
var
  sDate:AnsiString;
begin
  LoadDLLFunctions;
  sDate:= FormatDateTime('yyyymmdd',Data);
  if Assigned(xObtemQuantidadeTransacoesPendentes) then
    Result := xObtemQuantidadeTransacoesPendentes(sDate,CupomFiscal)
  else
    Result := -1;
end;

function TACBrTEFCliSiTefAPI.EnviaRecebeSiTefDireto(RedeDestino: SmallInt;
  FuncaoSiTef: SmallInt; OffsetCartao: SmallInt; DadosTx: AnsiString;
  var DadosRx: AnsiString; var CodigoResposta: SmallInt;
  TempoEsperaRx: SmallInt; CupomFiscal: AnsiString; Confirmar: Boolean;
  Operador: AnsiString): Integer;
var
  Buffer: array [0..20000] of AnsiChar;
  ANow: TDateTime;
  DataStr, HoraStr: String;
begin
  LoadDLLFunctions;
  ANow    := Now ;
  DataStr := FormatDateTime('YYYYMMDD', ANow );
  HoraStr := FormatDateTime('HHNNSS', ANow );
  Buffer := #0;
  FillChar(Buffer, SizeOf(Buffer), 0);

  if Assigned(xEnviaRecebeSiTefDireto) then
    Result := xEnviaRecebeSiTefDireto( RedeDestino,
                             FuncaoSiTef,
                             OffsetCartao,
                             DadosTx,
                             Length(DadosTx)+1,
                             Buffer,
                             SizeOf(Buffer),
                             CodigoResposta,
                             TempoEsperaRx,
                             CupomFiscal, DataStr, HoraStr, Operador,
                             IfThen(Confirmar,1,0) )
    else
      Result := -1;

  DadosRx := TrimRight( LeftStr(Buffer,max(Result,0)) ) ;
end;

function TACBrTEFCliSiTefAPI.ValidaCampoCodigoEmBarras(Dados: AnsiString;
  var Tipo: SmallInt): Integer;
begin
  { Valores de Retorno:
    0 - se o código estiver correto;
    1 a 4 - Indicando qual o bloco que está com erro
    5 - Um ou mais blocos com erro

    Tipo: tipo de documento sendo coletado:
          -1: Ainda não identificado
          0: Arrecadação
          1: Titulo
  }
  LoadDLLFunctions;
  if Assigned(xValidaCampoCodigoEmBarras) then
    Result := xValidaCampoCodigoEmBarras(Dados,Tipo)
  else
    Result := -1;
end;

function TACBrTEFCliSiTefAPI.VerificaPresencaPinPad: Boolean;
begin
  {
   Retornos:
      1: Existe um PinPad operacional conectado ao micro;
      0: Nao Existe um PinPad conectado ao micro;
     -1: Biblioteca de acesso ao PinPad não encontrada }

  LoadDLLFunctions;
  if Assigned(xVerificaPresencaPinPad) then
    Result := ( xVerificaPresencaPinPad() = 1 )
  else
    Result := False;
end;

function TACBrTEFCliSiTefAPI.ObtemDadoPinPadDiretoEx(TipoDocumento: Integer; ChaveAcesso,
  Identificador: AnsiString): AnsiString;
var
  Saida: array [0..22] of AnsiChar;
  Retorno: Integer;
  DocLen: Integer;
const
  EntradaCPF      = '011111DIGITE O CPF                    CONFIRME O CPF  |xxx.xxx.xxx-xx  ';
  EntradaCNPJ     = '020808INFORME CNPJ P1                 CONFIRME P1     |xx.xxx.xxx      '+
                      '0606INFORME CNPJ P2                 CONFIRME P2     |xxxx-xx         ';
  EntradaCelular  = '011111NUMERO CELULAR                  CONFIRME NUMERO |(xx) xxxxx-xxxx  ';
begin
  Result := '';

  if Assigned(xObtemDadoPinPadDiretoEx) then
  begin
    case TipoDocumento of
      1: Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCPF), Saida);
      2: Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCNPJ), Saida);
      3: Retorno := xObtemDadoPinPadDiretoEx(PAnsiChar(ChaveAcesso), PAnsiChar(Identificador), PAnsiChar(EntradaCelular), Saida);
    else
      Retorno := -1;
    end;

    if Retorno = 0 then
    begin
      if TipoDocumento = 2 then
        DocLen := 19
      else
        DocLen := 14;

      Result := copy(TrimRight(Saida), 5, DocLen);
    end;
  end;
end;

end.



