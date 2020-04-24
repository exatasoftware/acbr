{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Andrews Ricardo Bejatto                       }
{                                Anderson Rogerio Bejatto                      }
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

unit ACBrETQEpl2;

interface

uses
  Classes,
  ACBrETQClass, ACBrDevice
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrETQEPL2 }

  TACBrETQEpl2 = class(TACBrETQClass)
  private
    function ConverterOrientacao(aOrientacao: TACBrETQOrientacao): String;
    function ConverterMultiplicador(aMultiplicador: Integer): String;
    function ConverterCoordenadas(aVertical, aHorizontal: Integer): String;
    function ConverterFonte(const aFonte: String; var aTexto: String): String;
    function ConverterReverso(aImprimirReverso: Boolean): String;
    function ConverterLarguraBarras(aBarraLarga, aBarraFina: Integer): String;
    function ConverterUnidadeAlturaBarras(aAlturaBarras: Integer): String;
    function ConverterPaginaDeCodigo(aPaginaDeCodigo: TACBrETQPaginaCodigo): String;

    function FormatarTexto(const aTexto: String): String;

    procedure VerificarTipoBarras(const aTipo: String; aBarraFina: Integer);
    function ConverterExibeCodigo(aExibeCodigo: TACBrETQBarraExibeCodigo): String;

    function CalcularEspessuraLinha(aVertical, aHorizontal: Integer): String;

    function AjustarNomeArquivoImagem( const aNomeImagem: String): String;
  public
    constructor Create(AOwner: TComponent);

    function ComandoLimparMemoria: AnsiString; override;
    function ComandoAbertura: AnsiString; override;
    function ComandoBackFeed: AnsiString; override;
    function ComandoTemperatura: AnsiString; override;
    function ComandoPaginaDeCodigo: AnsiString; override;
    function ComandoOrigemCoordenadas: AnsiString; override;
    function ComandoVelocidade: AnsiString; override;

    function ComandoCopias(const NumCopias: Integer): AnsiString; override;

    function ComandoImprimirTexto(aOrientacao: TACBrETQOrientacao; aFonte: String;
      aMultHorizontal, aMultVertical, aVertical, aHorizontal: Integer; aTexto: String;
      aSubFonte: Integer = 0; aImprimirReverso: Boolean = False): AnsiString; override;

    function ConverterTipoBarras(TipoBarras: TACBrTipoCodBarra): String; override;
    function ComandoImprimirBarras(aOrientacao: TACBrETQOrientacao; aTipoBarras: String;
      aBarraLarga, aBarraFina, aVertical, aHorizontal: Integer; aTexto: String;
      aAlturaBarras: Integer; aExibeCodigo: TACBrETQBarraExibeCodigo = becPadrao
      ): AnsiString; override;
    function ComandoImprimirQRCode(aVertical, aHorizontal: Integer;
      const aTexto: String; aLarguraModulo: Integer; aErrorLevel: Integer;
      aTipo: Integer): AnsiString; override;

    function ComandoImprimirLinha(aVertical, aHorizontal, aLargura, aAltura: Integer
      ): AnsiString; override;

    function ComandoImprimirCaixa(aVertical, aHorizontal, aLargura, aAltura,
      aEspVertical, aEspHorizontal: Integer): AnsiString; override;

    function ComandoImprimirImagem(aMultImagem, aVertical, aHorizontal: Integer;
      aNomeImagem: String): AnsiString; override;

    function ComandoCarregarImagem(aStream: TStream; aNomeImagem: String;
      aFlipped: Boolean; aTipo: String): AnsiString; override;
  end;

implementation

uses
  math, SysUtils,
  {$IFDEF COMPILER6_UP} StrUtils {$ELSE} ACBrD5, Windows{$ENDIF},
  ACBrUtil, ACBrImage, ACBrConsts, synautil;

{ TACBrETQEpl2 }

constructor TACBrETQEpl2.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Unidade := etqDots;

  fpModeloStr    := 'EPL2';
  fpLimiteCopias := 65535;
end;

function TACBrETQEpl2.FormatarTexto(const aTexto: String): String;
begin
  Result := aTexto;

  if (LeftStr(Result, 1) = '"') then  // Usu�rio j� faz os ajustes ?
    Exit;

  // Ajustando o TEXTO com caraceteres especiais //
  Result := StringReplace(Result, '\', '\\"', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := '"' + Result + '"';
end;

function TACBrETQEpl2.ConverterFonte(const aFonte: String; var aTexto: String
  ): String;
var
  cFonte: Char;
begin
  cFonte := PadLeft(aFonte,1,'3')[1];
  if not CharInSet(cFonte, ['0'..'5']) then
    raise Exception.Create('Fonte deve ser de "0" a "5"');

  if (cFonte = '0') then
    cFonte := '3'
  else if (cFonte = '5') then
    aTexto := UpperCase(aTexto); // Fonte 5 s� funciona com caracteres mai�sculos

  Result := cFonte;
end;

function TACBrETQEpl2.ConverterMultiplicador(aMultiplicador: Integer): String;
begin
  if (aMultiplicador < 1) or (aMultiplicador > 24) then
    raise Exception.Create('Multiplicador deve ser de 1 a 24');

  Result := IntToStr(aMultiplicador);
end;

function TACBrETQEpl2.ConverterCoordenadas(aVertical, aHorizontal: Integer
  ): String;
begin
  Result := IntToStr(ConverterUnidade(etqDots, aHorizontal)) + ',' +
            IntToStr(ConverterUnidade(etqDots, aVertical));
end;

function TACBrETQEpl2.CalcularEspessuraLinha(aVertical, aHorizontal: Integer
  ): String;
var
  wEspessura: Integer;
begin
  wEspessura := Max(aHorizontal, aVertical);
  wEspessura := ConverterUnidade(etqDots, wEspessura);

  Result := IntToStr(max(wEspessura,1));
end;

function TACBrETQEpl2.AjustarNomeArquivoImagem(const aNomeImagem: String): String;
begin
  Result := '"' + UpperCase(LeftStr(OnlyAlphaNum(aNomeImagem), 16)) + '"';
end;

function TACBrETQEpl2.ConverterUnidadeAlturaBarras(aAlturaBarras: Integer
  ): String;
begin
  Result := IntToStr(ConverterUnidade(etqDots, aAlturaBarras));
end;

function TACBrETQEpl2.ConverterPaginaDeCodigo(
  aPaginaDeCodigo: TACBrETQPaginaCodigo): String;
begin
  case aPaginaDeCodigo of
    pce437 : Result := '8,0,001';
    pce850 : Result := '8,1,001';
    pce852 : Result := '8,2,001';
    pce860 : Result := '8,3,001';
    pce1250: Result := '8,B,001';
    pce1252: Result := '8,A,001';
  else
    Result := '';
  end;
end;

function TACBrETQEpl2.ConverterOrientacao(aOrientacao: TACBrETQOrientacao
  ): String;
begin
  case aOrientacao of
    or270: Result := '3';  // 270
    or180: Result := '2';  // 180
    or90:  Result := '1';  // 90
  else
    Result := '0';  // Normal
  end;
end;

procedure TACBrETQEpl2.VerificarTipoBarras(const aTipo: String; aBarraFina: Integer);
var
  MinBarraFina, MaxBarraFina: Integer;
begin
  MinBarraFina := 1;
  MaxBarraFina := 10;

  if (pos(aTipo,'E80;E82;E85;E30;E32;E35;UA0;UA2;UA5;UE0;UE2;UE5;2G') > 0) then
  begin
    MaxBarraFina := 4;
    MinBarraFina := 2;
    if aTipo = '2G' then
      MinBarraFina := 3;
  end;

  if (aBarraFina < MinBarraFina) or (aBarraFina > MaxBarraFina) then
    raise Exception.CreateFmt('Barra Fina para o Cod.Barras %s deve ser de %d a %d',
                              [aTipo, MinBarraFina, MaxBarraFina]);
end;

function TACBrETQEpl2.ConverterExibeCodigo(
  aExibeCodigo: TACBrETQBarraExibeCodigo): String;
begin
  if (aExibeCodigo = becSIM) then
    Result := 'B'
  else
    Result := 'N';
end;

function TACBrETQEpl2.ConverterLarguraBarras(aBarraLarga, aBarraFina: Integer): String;
begin
  if (aBarraFina < 1) or (aBarraFina > 10) then
    raise Exception.Create('Barra Fina deve ser de 1 a 10');

  if (aBarraLarga < 2) or (aBarraLarga > 30) then
    raise Exception.Create('Barra Larga deve ser de 2 a 30');

  if (aBarraFina > aBarraLarga) then
    raise Exception.Create('Barra Fina deve ser inferior ou Igual a Barra Larga');

  Result := IntToStr(aBarraFina) + ',' + IntToStr(aBarraLarga);
end;

function TACBrETQEpl2.ConverterReverso(aImprimirReverso: Boolean): String;
begin
  If aImprimirReverso then
    Result := 'R'
  else
    Result := 'N';
end;

function TACBrETQEpl2.ComandoOrigemCoordenadas: AnsiString;
begin
  if (fpOrigem = ogTop) then
    Result := 'ZT'
  else
    Result := 'ZB';  // ACBr Default
end;

function TACBrETQEpl2.ComandoLimparMemoria: AnsiString;
begin
  Result := 'N';
end;

function TACBrETQEpl2.ComandoTemperatura: AnsiString;
begin
  Result := EmptyStr;

  if (Temperatura < 0) or (Temperatura > 15) then
    raise Exception.Create('Temperatura deve ser de 0 a 15');

  Result := 'D' + IntToStr(Temperatura);
end;

function TACBrETQEpl2.ComandoPaginaDeCodigo: AnsiString;
begin
  Result := 'I'+ConverterPaginaDeCodigo(PaginaDeCodigo);
end;

function TACBrETQEpl2.ComandoVelocidade: AnsiString;
begin
  Result := EmptyStr;
  if Velocidade < 0 then
     Exit;

  if (Velocidade > 6) then
    raise Exception.Create('Velocidade deve ser de 0 a 6');

  Result := 'S' + IntToStr(Velocidade);
end;

function TACBrETQEpl2.ComandoCopias(const NumCopias: Integer): AnsiString;
begin
  inherited ComandoCopias(NumCopias);
  Result := 'P' + IntToStr(NumCopias);
end;

function TACBrETQEpl2.ComandoBackFeed: AnsiString;
begin
  case fpBackFeed of
    bfOn : Result := 'JF';
    bfOff: Result := 'JB';
  else
    Result := EmptyStr;
  end;
end;

function TACBrETQEpl2.ComandoAbertura: AnsiString;
begin
  Result := 'R0,0';
end;

function TACBrETQEpl2.ComandoImprimirTexto(aOrientacao: TACBrETQOrientacao;
  aFonte: String; aMultHorizontal, aMultVertical, aVertical,
  aHorizontal: Integer; aTexto: String; aSubFonte: Integer;
  aImprimirReverso: Boolean): AnsiString;
begin
  Result := 'A' +
            ConverterCoordenadas(aVertical, aHorizontal) + ',' +
            ConverterOrientacao(aOrientacao)             + ',' +
            ConverterFonte(aFonte, aTexto)               + ',' +
            ConverterMultiplicador(aMultHorizontal)      + ',' +
            ConverterMultiplicador(aMultVertical)        + ',' +
            ConverterReverso(aImprimirReverso)           + ',' +
            FormatarTexto(aTexto);
end;

function TACBrETQEpl2.ConverterTipoBarras(TipoBarras: TACBrTipoCodBarra
  ): String;
begin
  case TipoBarras of
    barEAN13      : Result := 'E30';
    barEAN8       : Result := 'E80';
    barINTERLEAVED: Result := '2';
    barCODE128    : Result := '1';
    barCODE39     : Result := '3';
    barCODE93     : Result := '9';
    barUPCA       : Result := 'UA0';
    barCODABAR    : Result := 'K';
    barMSI        : Result := 'L';
  else
    Result := '';
  end;
end;

function TACBrETQEpl2.ComandoImprimirBarras(aOrientacao: TACBrETQOrientacao;
  aTipoBarras: String; aBarraLarga, aBarraFina, aVertical,
  aHorizontal: Integer; aTexto: String; aAlturaBarras: Integer;
  aExibeCodigo: TACBrETQBarraExibeCodigo): AnsiString;
begin
  VerificarTipoBarras(aTipoBarras, aBarraFina);

  Result := 'B' +
            ConverterCoordenadas(aVertical, aHorizontal)    + ',' +
            ConverterOrientacao(aOrientacao)                + ',' +
            aTipoBarras                                     + ',' +
            ConverterLarguraBarras(aBarraLarga, aBarraFina) + ',' +
            ConverterUnidadeAlturaBarras(aAlturaBarras)     + ',' +
            ConverterExibeCodigo(aExibeCodigo)              + ',' +
            FormatarTexto(aTexto);
end;

function TACBrETQEpl2.ComandoImprimirQRCode(aVertical, aHorizontal: Integer;
  const aTexto: String; aLarguraModulo: Integer; aErrorLevel: Integer;
  aTipo: Integer): AnsiString;
begin
  Result := 'b' +
            ConverterCoordenadas(aVertical, aHorizontal) + ',' +
            'Q'                                          + ',' +
            'm'+IntToStr(aTipo)                          + ',' +
            's'+IntToStr(aLarguraModulo)                 + ',' +
            'e'+ConverterQRCodeErrorLevel(aErrorLevel)   + ',' +
            'iA'                                         + ',' +
            FormatarTexto(aTexto);
end;

function TACBrETQEpl2.ComandoImprimirLinha(aVertical, aHorizontal, aLargura,
  aAltura: Integer): AnsiString;
begin
  Result := 'LO' +
            ConverterCoordenadas(aVertical, aHorizontal) + ',' +
            ConverterCoordenadas(aAltura, aLargura);
end;

function TACBrETQEpl2.ComandoImprimirCaixa(aVertical, aHorizontal, aLargura,
  aAltura, aEspVertical, aEspHorizontal: Integer): AnsiString;
begin
  Result := 'X' +
            ConverterCoordenadas(aVertical, aHorizontal)     + ',' +
            CalcularEspessuraLinha(aEspVertical, aEspHorizontal) + ',' +
            ConverterCoordenadas(aVertical+aAltura, aHorizontal+aLargura);
end;

function TACBrETQEpl2.ComandoImprimirImagem(aMultImagem, aVertical,
  aHorizontal: Integer; aNomeImagem: String): AnsiString;
begin
  Result := 'GG' +
            ConverterCoordenadas(aVertical, aHorizontal) + ',' +
            AjustarNomeArquivoImagem(aNomeImagem);
end;

function TACBrETQEpl2.ComandoCarregarImagem(aStream: TStream;
  aNomeImagem: String; aFlipped: Boolean; aTipo: String): AnsiString;
var
  ImgData: AnsiString;
begin
  Result := EmptyStr;

  if (aTipo = '') then
     aTipo := 'PCX'
  else
    aTipo := UpperCase(RightStr(aTipo, 3));

  if (aTipo <> 'PCX') or (not IsPCX(aStream, True)) then
    raise Exception.Create(ACBrStr(cErrImgPCXMono));

  aStream.Position := 0;
  ImgData := ReadStrFromStream(aStream, aStream.Size);
  aNomeImagem := AjustarNomeArquivoImagem(aNomeImagem);

  Result := 'GK' + aNomeImagem     + LF +    // deletes graphic "NomeImagem" - Required
            'GK' + aNomeImagem     + LF +    // second delete graphic - Required
            'GM' + aNomeImagem     +         // Prepares printer to receive graphic "NomeImagem";
            IntToStr(aStream.Size) + LF +    // The Data Size
            ImgData;                         // The Image Data
end;

end.
