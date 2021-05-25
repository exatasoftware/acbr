{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

// https://elgindevelopercommunity.github.io/

{$I ACBr.inc}

unit ACBrPosPrinterElginE1Lib;

interface

uses
  Classes, SysUtils,
  FMX.Graphics,
  Androidapi.JNI.GraphicsContentViewText,
  ACBrConsts, ACBrDevice, ACBrBase, ACBrPosPrinter,
  Elgin.JNI.E1;

resourcestring
  cErroImpressoraSemPapapel = 'Impressora sem Papel';
  cErroImpressoraNaoPronta = 'Impressora n�o pronta';
  cErroImpressora = 'Erro na Impressora';

const
  cTagBR = '<br>';

  // Essas Tags ser�o interpretadas no momento da Impress�o, pois usam comandos
  // espec�ficos da Biblioteca E1
  CTAGS_POST_PROCESS: array[0..25] of string = (
    cTagPulodeLinha, cTagPuloDeLinhas, cTagBR,
    cTagLigaExpandido, cTagDesligaExpandido,
    cTagLigaAlturaDupla, cTagDesligaAlturaDupla,
    cTagLigaNegrito, cTagDesligaNegrito,
    cTagLigaSublinhado, cTagDesligaSublinhado,
    cTagLigaCondensado, cTagDesligaCondensado,
    cTagLigaItalico, cTagDesligaItalico,
    cTagLigaInvertido, cTagDesligaInvertido,
    cTagFonteNormal,
    cTagFonteA, cTagFonteB,
    cTagFonteAlinhadaDireita, cTagFonteAlinhadaEsquerda, cTagfonteAlinhadaCentro,
    cTagBeep,
    cTagZera, cTagReset );

  CBLOCK_POST_PROCESS: array[0..16] of string = (
    cTagBarraEAN8, cTagBarraEAN13, cTagBarraInter,
    cTagBarraCode39, cTagBarraCode93,
    cTagBarraCode128,
    cTagBarraUPCA, cTagBarraUPCE, cTagBarraCodaBar,
    cTagBMP,
    cTagBarraMostrar, cTagBarraLargura, cTagBarraAltura,
    cTagQRCode, cTagQRCodeTipo, cTagQRCodeLargura, cTagQRCodeError );

  CTAGS_AVANCO: array[0..2] of string =
    (cTagCorte, cTagCorteParcial, cTagCorteTotal);

type

  TE1LibPrinter = class
  private
    fEstiloFonte: TACBrPosFonte;
    fAlinhamento: TACBrPosTipoAlinhamento;
    fImprimindo: Boolean;
    fEspacoLinha: Integer;
    fTamanhoTexto: Integer;

    procedure SetEspacoLinha(const Value: Integer);
    procedure SetTamanhoTexto(const Value: Integer);
    function GetTermicaClass: JTermicaClass;
    procedure VerificarErro(CodErro: Integer; Metodo: String);
    function AlinhamentoToPosicao: Integer;
  public
    constructor Create;
    procedure Restaurar;

    property Imprimindo: Boolean read fImprimindo;

    procedure IniciarImpressao;
    procedure FinalizarImpressao;

    procedure PularLinhas(Linhas: Integer);
    procedure ImprimirTexto(Texto: String);
    procedure ImprimirImagem(BitMap: TBitmap);
    procedure ImprimirCodBarras(Tipo: Integer; Conteudo: String;
      Altura, Largura: Integer; hri: Boolean);
    procedure ImprimirQRCode(Conteudo: String; LarguraModulo: Integer;
      nivelCorrecao: Integer= 2);

    procedure AjustarAlinhamento;

    function Status(Sensor: Integer): Integer;

    property TermicaClass: JTermicaClass read GetTermicaClass;

    property EstiloFonte: TACBrPosFonte read fEstiloFonte write fEstiloFonte
      default [];
    property Alinhamento: TACBrPosTipoAlinhamento read fAlinhamento write fAlinhamento
      default TACBrPosTipoAlinhamento.alEsquerda;
    property EspacoLinha: Integer read fEspacoLinha write SetEspacoLinha
      default 10;
    property TamanhoTexto: Integer read fTamanhoTexto write SetTamanhoTexto
      default 17;
  end;

  { TACBrPosPrinterElginE1Lib }

  TACBrPosPrinterElginE1Lib = class(TACBrPosPrinterClass)
  private
    fE1LibPrinter: TE1LibPrinter;
    fE1LibTagProcessor: TACBrTagProcessor;

    procedure E1LibTraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString);
    procedure E1LibAdicionarBlocoResposta(const ConteudoBloco: AnsiString);
    procedure E1LibTraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString);

    procedure ProcessarComandoBMP(ConteudoBloco: AnsiString);
  protected
    procedure ImprimirE1Lib(const LinhasImpressao: String; var Tratado: Boolean);

  public
    constructor Create(AOwner: TACBrPosPrinter);
    destructor Destroy; override;

    procedure Configurar; override;
    function TraduzirTag(const ATag: AnsiString; var TagTraduzida: AnsiString): Boolean;
      override;
    function TraduzirTagBloco(const ATag, ConteudoBloco: AnsiString;
      var BlocoTraduzido: AnsiString): Boolean; override;
    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
  end;

Function BitmapToJBitmap(const ABitmap: TBitmap): JBitmap;

implementation

uses
  System.Threading,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  AndroidApi.JNI.Media,
  FMX.Helpers.Android,
  FMX.Surfaces,
  StrUtils, Math,
  synacode,
  ACBrUtil, ACBrImage;

//https://forums.embarcadero.com/thread.jspa?threadID=245452&tstart=0
Function BitmapToJBitmap(const ABitmap: TBitmap): JBitmap;
var
  LSurface: TBitmapSurface;
  LBitmap : JBitmap;
begin
  Result := nil;
  LSurface := TBitmapSurface.Create;
  try
    LSurface.Assign(ABitmap);
    LBitmap := TJBitmap.JavaClass.createBitmap( LSurface.Width,
                                                LSurface.Height,
                                                TJBitmap_Config.JavaClass.ARGB_8888);
    if SurfaceToJBitmap(LSurface, LBitmap) then
      Result := LBitmap;
  finally
    LSurface.Free;
  end;
end;

procedure AndroidBeep(ADuration: Integer);
begin
  // https://stackoverflow.com/questions/30938946/how-do-i-make-a-beep-sound-in-android-using-delphi-and-the-api
  TJToneGenerator.JavaClass.init( TJAudioManager.JavaClass.ERROR,
                                  TJToneGenerator.JavaClass.MAX_VOLUME)
    .startTone( TJToneGenerator.JavaClass.TONE_DTMF_0,
                ADuration );
end;

{ TE1LibPrinter }

constructor TE1LibPrinter.Create;
begin
  fImprimindo := False;
  Restaurar;
end;

procedure TE1LibPrinter.Restaurar;
begin
  fEstiloFonte := [];
  fAlinhamento := TACBrPosTipoAlinhamento.alEsquerda;
  fEspacoLinha := 10;
  fTamanhoTexto := 17;
end;

procedure TE1LibPrinter.IniciarImpressao;
begin
  if fImprimindo then
    Exit;

  // Tipo: 1 	USB, 2 	RS232, 3 	TCP/IP, 4 	Bluetooth, 5 	SmartPOS, 6 Mini PDV M8
  VerificarErro( TJTermica.JavaClass.AbreConexaoImpressora(6 , StringToJString('M8'),StringToJString('USB'), 0),
                 'AbreConexaoImpressora');
  fImprimindo := True;
end;

procedure TE1LibPrinter.FinalizarImpressao;
begin
  try
    VerificarErro( TJTermica.JavaClass.FechaConexaoImpressora,
                   'FechaConexaoImpressora' );
  finally
    fImprimindo := False;
  end;
end;

function TE1LibPrinter.GetTermicaClass: JTermicaClass;
begin
  Result := TJTermica.JavaClass;
end;

procedure TE1LibPrinter.VerificarErro(CodErro: Integer; Metodo: String);
begin
  if CodErro = 0 then
    Exit;

  raise EPosPrinterException.Create('Error %d executando %s');
end;

procedure TE1LibPrinter.SetEspacoLinha(const Value: Integer);
begin
  fEspacoLinha := max(Value, 1);
end;

procedure TE1LibPrinter.SetTamanhoTexto(const Value: Integer);
begin
  fTamanhoTexto := min(max(Value, 5), 100);
end;

function TE1LibPrinter.AlinhamentoToPosicao: Integer;
begin
  case Alinhamento of
    alCentro: Result := 1;
    alDireita: Result := 2;
  else
    Result := 0;
  end;
end;

procedure TE1LibPrinter.AjustarAlinhamento;
begin
  TermicaClass.DefinePosicao(AlinhamentoToPosicao);
end;

procedure TE1LibPrinter.PularLinhas(Linhas: Integer);
begin
  IniciarImpressao;
  Linhas := max(1, min(999, Linhas));
  VerificarErro( TJTermica.JavaClass.AvancaPapel(Linhas),
                 'AvancaPapel' );
end;

procedure TE1LibPrinter.ImprimirTexto(Texto: String);
var
  stilo, tamanho: Integer;
begin
  IniciarImpressao;

  if Texto.Trim.IsEmpty then
  begin
    PularLinhas(1);
    Exit;
  end;

  // Definindo Estilos
  stilo := 0; // Normal
  if (ftCondensado in EstiloFonte) or (ftFonteB in EstiloFonte) then
    Inc(stilo, 1);
  if (ftSublinhado in EstiloFonte) then
    Inc(stilo, 2);
  if (ftInvertido in EstiloFonte) then
    Inc(stilo, 4);
  if (ftNegrito in EstiloFonte) then
    Inc(stilo, 8);

  // Ajustando Largura e Altura do Texto
  tamanho := 0;
  if (ftAlturaDupla in EstiloFonte) then
    Inc(tamanho, 1);
  if (ftExpandido in EstiloFonte) then
    Inc(tamanho, 16);

   VerificarErro( TermicaClass.ImpressaoTexto( StringToJString(Texto),
                                               AlinhamentoToPosicao,
                                               stilo, tamanho),
                  'ImpressaoTexto' );
   PularLinhas(1);
end;

procedure TE1LibPrinter.ImprimirCodBarras(Tipo: Integer; Conteudo: String;
  Altura, Largura: Integer; hri: Boolean);
begin
  // UPC_A = 0; UPC_E = 1; EAN_13 = 2; EAN_8 = 3; CODE_39 = 4; ITF = 5;
  // CODE_BAR = 6; CODE_93 = 7; CODE_128 = 8;
  // HRI: 1 - Acima do c�digo, 2 - Abaixo do c�digo, 3 - Ambos, 4 - N�o impresso.

  if Conteudo.IsEmpty then
    Exit;

  IniciarImpressao;
  AjustarAlinhamento;
  VerificarErro( TermicaClass.ImpressaoCodigoBarras( Tipo,
                                                     StringToJString(Conteudo),
                                                     Altura, Largura,
                                                     ifthen(hri, 2, 4) ),
                 'ImpressaoCodigoBarras');
end;

procedure TE1LibPrinter.ImprimirQRCode(Conteudo: String;
  LarguraModulo, nivelCorrecao: Integer);
begin
  if Conteudo.IsEmpty then
    Exit;

  IniciarImpressao;
  AjustarAlinhamento;
  VerificarErro( TermicaClass.ImpressaoQRCode( StringToJString(Conteudo),
                                               LarguraModulo, nivelCorrecao),
                 'ImpressaoQRCode' );
end;

procedure TE1LibPrinter.ImprimirImagem(BitMap: TBitmap);
begin
  IniciarImpressao;
  AjustarAlinhamento;
  VerificarErro( TermicaClass.ImprimeBitmap(BitmapToJBitmap(bitmap)),
                 'ImprimeBitmap' );
end;

function TE1LibPrinter.Status(Sensor: Integer): Integer;
var
  S: Integer;
begin
  Result := TermicaClass.StatusImpressora(Sensor);
end;

{ TACBrPosPrinterElginE1Lib }

constructor TACBrPosPrinterElginE1Lib.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'E1LibPrinter';

  TagsNaoSuportadas.Add( cTagLogotipo );
  TagsNaoSuportadas.Add( cTagLogoImprimir );
  TagsNaoSuportadas.Add( cTagBarraStd );
  TagsNaoSuportadas.Add( cTagBarraCode11 );
  TagsNaoSuportadas.Add( cTagBarraMSI );

  fE1LibTagProcessor := TACBrTagProcessor.Create;
  fE1LibTagProcessor.AddTags(CTAGS_POST_PROCESS, [],  False);
  fE1LibTagProcessor.AddTags(CBLOCK_POST_PROCESS, [], True);

  fE1LibTagProcessor.OnTraduzirTag := E1LibTraduzirTag;
  fE1LibTagProcessor.OnAdicionarBlocoResposta := E1LibAdicionarBlocoResposta;
  fE1LibTagProcessor.OnTraduzirTagBloco := E1LibTraduzirTagBloco;

  fE1LibPrinter := TE1LibPrinter.Create;
end;

destructor TACBrPosPrinterElginE1Lib.Destroy;
begin
  fE1LibTagProcessor.Free;
  fE1LibPrinter.Free;

  inherited;
end;

procedure TACBrPosPrinterElginE1Lib.Configurar;
begin
  fpPosPrinter.Porta := 'NULL';
  fpPosPrinter.OnEnviarStringDevice := ImprimirE1Lib;
  fpPosPrinter.PaginaDeCodigo := TACBrPosPaginaCodigo.pcUTF8;
end;

function TACBrPosPrinterElginE1Lib.TraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString): Boolean;
begin
  TagTraduzida := '';
  Result := True;
  if MatchText(ATag, CTAGS_POST_PROCESS) then
    TagTraduzida := ATag
  else if MatchText(ATag, CTAGS_AVANCO) then
    TagTraduzida := cTagPuloDeLinhas
  else if (ATag = cTagRetornoDeCarro) then
    TagTraduzida := cTagBR
  else
    Result := False;  // Deixa ACBrPosPrinter traduzir...
end;

function TACBrPosPrinterElginE1Lib.TraduzirTagBloco(const ATag,
  ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString): Boolean;

  function RemontaBloco(const ATag, ConteudoBloco: AnsiString): String;
  begin
    Result := ATag + ConteudoBloco + '</'+ copy(ATag, 2, Length(ATag));
  end;

begin
  BlocoTraduzido := '';
  Result := False;    // Deixa ACBrPosPrinter traduzir...

  if (ATag = cTagBarraCode128) or (ATag = cTagBarraCode128a) or
     (ATag = cTagBarraCode128b) or (ATag = cTagBarraCode128c) then
  begin
    BlocoTraduzido := RemontaBloco(cTagBarraCode128, ConteudoBloco);
    Result := True;
  end

  else if MatchText(ATag, CBLOCK_POST_PROCESS) then
  begin
    BlocoTraduzido := RemontaBloco(ATag, ConteudoBloco);
    Result := True;
  end;
end;

procedure TACBrPosPrinterElginE1Lib.ImprimirE1Lib(const LinhasImpressao: String;  var Tratado: Boolean);
var
  TextoAImprimir, Linha: string;
  SL: TStringList;
  i: Integer;
begin
  if LinhasImpressao.IsEmpty then
    Exit;

  fE1LibPrinter.IniciarImpressao;
  try
    TextoAImprimir := '';
    SL := TStringList.Create;
    try
      SL.Text := LinhasImpressao;
      for i := 0 to SL.Count-1 do
      begin
        Linha := TrimRight(SL[i]);
        if (Linha = '') then
          Linha := ' ';

        TextoAImprimir := TextoAImprimir + Linha + cTagBR;
      end;
    finally
      SL.Free;
    end;

    fE1LibTagProcessor.DecodificarTagsFormatacao(TextoAImprimir);
  finally
    fE1LibPrinter.FinalizarImpressao;
  end;
end;

procedure TACBrPosPrinterElginE1Lib.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  S: Integer;
begin
  AStatus := []; // OK
  S := fE1LibPrinter.Status(1);  // 1 - Status da Gaveta
  if (S = 1) then
    AStatus := AStatus + [stGavetaAberta];

  S := fE1LibPrinter.Status(3);  // 3 - Status do Papel
  if (S < 0) then
    AStatus := AStatus + [stErro];

  case S of
    6: AStatus := AStatus + [stPoucoPapel];
    7: AStatus := AStatus + [stSemPapel];
  end;
end;

procedure TACBrPosPrinterElginE1Lib.E1LibAdicionarBlocoResposta(const ConteudoBloco: AnsiString);
begin
  fE1LibPrinter.ImprimirTexto(ConteudoBloco);
end;

procedure TACBrPosPrinterElginE1Lib.E1LibTraduzirTag(const ATag: AnsiString;
  var TagTraduzida: AnsiString);
begin
  TagTraduzida := '';

  with fE1LibPrinter do
  begin
    if (ATag = cTagLigaExpandido) then
      EstiloFonte := EstiloFonte + [ftExpandido]
    else if (ATag = cTagDesligaExpandido) then
      EstiloFonte := EstiloFonte - [ftExpandido]
    else if (ATag = cTagLigaAlturaDupla) then
      EstiloFonte := EstiloFonte + [ftAlturaDupla]
    else if (ATag = cTagDesligaAlturaDupla) then
      EstiloFonte := EstiloFonte - [ftAlturaDupla]
    else if (ATag = cTagLigaNegrito) then
      EstiloFonte := EstiloFonte + [ftNegrito]
    else if (ATag = cTagDesligaNegrito) then
      EstiloFonte := EstiloFonte - [ftNegrito]
    else if (ATag = cTagLigaSublinhado) then
      EstiloFonte := EstiloFonte + [ftSublinhado]
    else if (ATag = cTagDesligaSublinhado) then
      EstiloFonte := EstiloFonte - [ftSublinhado]
    else if (ATag = cTagLigaCondensado) then
      EstiloFonte := EstiloFonte + [ftCondensado]
    else if (ATag = cTagDesligaCondensado) then
      EstiloFonte := EstiloFonte - [ftCondensado]
    else if (ATag = cTagLigaItalico) then
      EstiloFonte := EstiloFonte + [ftItalico]
    else if (ATag = cTagDesligaItalico) then
      EstiloFonte := EstiloFonte - [ftItalico]
    else if (ATag = cTagLigaInvertido) then
      EstiloFonte := EstiloFonte + [ftInvertido]
    else if (ATag = cTagDesligaInvertido) then
      EstiloFonte := EstiloFonte - [ftInvertido]
    else if (ATag = cTagFonteA) then
      EstiloFonte := EstiloFonte - [ftFonteB]
    else if (ATag = cTagFonteB) then
      EstiloFonte := EstiloFonte + [ftFonteB]
    else if (ATag = cTagFonteNormal) then
      EstiloFonte := EstiloFonte - [ftCondensado, ftExpandido, ftAlturaDupla,
                                    ftNegrito, ftSublinhado, ftItalico, ftInvertido,
                                    ftFonteB]
    else if (ATag = cTagZera) or (ATag = cTagReset) then
    begin
      fE1LibPrinter.Restaurar;
      fE1LibPrinter.EspacoLinha := IfThen(fpPosPrinter.EspacoEntreLinhas = 0, 10, fpPosPrinter.EspacoEntreLinhas);
      EstiloFonte := EstiloFonte - [ftCondensado, ftExpandido, ftAlturaDupla,
                                    ftNegrito, ftSublinhado, ftItalico, ftInvertido];
    end
    else if (ATag = cTagBR) then
      TagTraduzida := ''  // N�o faz nada aqui...
    else if (ATag = cTagPulodeLinha) then
      PularLinhas(1)
    else if (ATag = cTagPuloDeLinhas) then
      PularLinhas(fpPosPrinter.LinhasEntreCupons)
    else if (ATag = cTagBeep) then
      AndroidBeep(200)
    else if (ATag = cTagFonteAlinhadaEsquerda) then
      Alinhamento := TACBrPosTipoAlinhamento.alEsquerda
    else if (ATag = cTagFonteAlinhadaDireita) then
      Alinhamento := TACBrPosTipoAlinhamento.alDireita
    else if (ATag = cTagfonteAlinhadaCentro) then
      Alinhamento := TACBrPosTipoAlinhamento.alCentro;
  end;
end;

procedure TACBrPosPrinterElginE1Lib.E1LibTraduzirTagBloco(const ATag,
  ConteudoBloco: AnsiString; var BlocoTraduzido: AnsiString);
var
  ACodBar: String;
  barCodeType: Integer;
  A, L, E: Integer;
begin
  BlocoTraduzido := '';
  if (ATag = cTagBMP) then
    ProcessarComandoBMP(ConteudoBloco)

  else if (ATag = cTagQRCode) then
  begin
    L := max(min(fpPosPrinter.ConfigQRCode.LarguraModulo,6),1);
    if (fpPosPrinter.ConfigQRCode.LarguraModulo = 0) then
      E := 2
    else
      E := max(min(fpPosPrinter.ConfigQRCode.LarguraModulo, 4), 1);

    fE1LibPrinter.ImprimirQRCode(ConteudoBloco, L, E);
  end

  else if (ATag = cTagQRCodeLargura) then
    fpPosPrinter.ConfigQRCode.LarguraModulo := StrToIntDef(
       ConteudoBloco, fpPosPrinter.ConfigQRCode.LarguraModulo)

  else if (ATag = cTagQRCodeTipo) or (ATag = cTagQRCodeError) then
    BlocoTraduzido := ''

  else if (ATag = cTagBarraMostrar) then
    BlocoTraduzido := ''

  else if (ATag = cTagBarraLargura) then
    fpPosPrinter.ConfigBarras.LarguraLinha := StrToIntDef(
       ConteudoBloco, fpPosPrinter.ConfigBarras.LarguraLinha)

  else if (ATag = cTagBarraAltura) then
    fpPosPrinter.ConfigBarras.Altura := StrToIntDef(
       ConteudoBloco, fpPosPrinter.ConfigBarras.Altura)

  else if (AnsiIndexText(ATag, CBLOCK_POST_PROCESS) >= 0) then
  begin
    ACodBar := fpPosPrinter.AjustarCodBarras(ConteudoBloco, ATag);

    // UPC_A = 0; UPC_E = 1; EAN_13 = 2; EAN_8 = 3; CODE_39 = 4; ITF = 5;
    // CODE_BAR = 6; CODE_93 = 7; CODE_128 = 8;
    // HRI: 1 - Acima do c�digo, 2 - Abaixo do c�digo, 3 - Ambos, 4 - N�o impresso.

    if (ATag = cTagBarraEAN8) then
      barCodeType := 3
    else if (ATag = cTagBarraEAN13) then
      barCodeType := 2
    else if (ATag = cTagBarraInter) then
      barCodeType := 5
    else if (ATag = cTagBarraCode39) then
      barCodeType := 4
    else if (ATag = cTagBarraCode93) then
      barCodeType := 7
    else if (ATag = cTagBarraCode128) then
      barCodeType := 8
    else if (ATag = cTagBarraUPCA) then
      barCodeType := 0
    else if (ATag = cTagBarraUPCE) then
      barCodeType := 1
    else if (ATag = cTagBarraCodaBar) then
      barCodeType := 6
    else
      barCodeType := 7;

    A := max(min(fpPosPrinter.ConfigBarras.Altura,255),1);
    L := max(min(fpPosPrinter.ConfigBarras.LarguraLinha,6),1);
    fE1LibPrinter.ImprimirCodBarras( barCodeType, ACodBar, A, L,
                                     fpPosPrinter.ConfigBarras.MostrarCodigo );
  end;
end;

procedure TACBrPosPrinterElginE1Lib.ProcessarComandoBMP(ConteudoBloco: AnsiString);
var
  ABitMap: TBitmap;
  ARasterStr: AnsiString;
  AHeight, AWidth: Integer;
  SL: TStringList;
  AData: String;
  MS: TMemoryStream;
  SS: TStringStream;
begin
  AData := Trim(ConteudoBloco);
  if (AData = '') then
    Exit;

  ABitMap := TBitmap.Create;
  try
    if StrIsBinary(LeftStr(AData,10)) then           // AscII Art
    begin
      SL := TStringList.Create;
      MS := TMemoryStream.Create;
      try
        SL.Text := AData;
        AWidth := 0; AHeight := 0; ARasterStr := '';
        AscIIToRasterStr(SL, AWidth, AHeight, ARasterStr);
        RasterStrToBMPMono(ARasterStr, AWidth, False, MS);
        MS.Position := 0;
        ABitMap.LoadFromStream(MS);
      finally
        SL.Free;
        MS.Free;
      end;
    end

    else if StrIsBase64(AData) then
    begin
      SS := TStringStream.Create(DecodeBase64(AData));
      try
        SS.Position := 0;
        ABitMap.LoadFromStream(SS);
      finally
        SS.Free;
      end;
    end

    else
      ABitMap.LoadFromFile(AData);

    fE1LibPrinter.ImprimirImagem(ABitMap);
  finally
    ABitMap.Free;
  end;
end;

end.

