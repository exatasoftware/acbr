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

unit ACBrETQPpla;

interface

uses
  Classes,
  ACBrETQClass, ACBrDevice
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrETQPpla }

  TACBrETQPpla = class(TACBrETQClass)
  private
    fImprimirReverso: Boolean;

    function AjustarTipoBarras(const aTipo: String; aExibeCodigo: TACBrETQBarraExibeCodigo): String;
    function ConverterMultiplicador(aMultiplicador: Integer): String;
    function ConverterCoordenadas(aVertical, aHorizontal: Integer): String;

    function ConverterUnidade(AValue: Integer): Integer; reintroduce; overload;
    function ConverterOrientacao(aOrientacao: TACBrETQOrientacao): String;
    function ConverterSubFonte(const aFonte: String; aSubFonte: Integer): String;
    function ConverterAlturaBarras(aAlturaBarras: Integer): String;

    function ComandoReverso(aImprimirReverso: Boolean): String;
    function PrefixoComandoLinhaECaixa(aOrientacao: TACBrETQOrientacao): String;
    function ConverterDimensao(aAltura, aLargura: Integer): String;

    function AjustarNomeArquivoImagem( const aNomeImagem: String): String;

    function ConverterVelocidade(Velocidade: Integer): Char;

    function ConverterMultiplicadorImagem(aMultiplicador: Integer): String;
    function ConverterEspessura(aVertical, aHorizontal: Integer): String;

  protected
    function ComandoAbertura: AnsiString; override;
    function ComandoUnidade: AnsiString; override;
    function ComandoTemperatura: AnsiString; override;
    function ComandoResolucao: AnsiString; override;
    function ComandoVelocidade: AnsiString; override;

  public
    constructor Create(AOwner: TComponent);

    function TratarComandoAntesDeEnviar(const aCmd: AnsiString): AnsiString; override;

    function ComandoLimparMemoria: AnsiString; override;
    function ComandoCopias(const NumCopias: Integer): AnsiString; override;
    function ComandoImprimir: AnsiString; override;
    function ComandoAvancarEtiqueta(const aAvancoEtq: Integer): AnsiString; override;

    function ComandosFinalizarEtiqueta(NumCopias: Integer = 1; aAvancoEtq: Integer = 0): AnsiString; override;

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

    function ComandoImprimirLinha(aVertical, aHorizontal, aLargura,
      aAltura: Integer): AnsiString; override;

    function ComandoImprimirCaixa(aVertical, aHorizontal, aLargura, aAltura,
      aEspVertical, aEspHorizontal: Integer): AnsiString; override;

    function ComandoImprimirImagem(aMultImagem, aVertical, aHorizontal: Integer;
      aNomeImagem: String): AnsiString; override;

    function ComandoCarregarImagem(aStream: TStream; aNomeImagem: String;
      aFlipped: Boolean; aTipo: String): AnsiString; override;
    function BMP2HEX(aStream: TStream; Inverter: Boolean): String;
  end;

implementation

uses
  math, sysutils, strutils,
  {$IFNDEF COMPILER6_UP} ACBrD5, Windows, {$ENDIF}
  ACBrUtil, ACBrImage, ACBrConsts, synautil;

{ TACBrETQPpla }

constructor TACBrETQPpla.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Unidade := etqMilimetros;

  fpModeloStr    := 'PPLA';
  fpLimiteCopias := 9999;
  fImprimirReverso := False;
end;

function TACBrETQPpla.ConverterMultiplicador(aMultiplicador: Integer): String;
begin
  // Multiplicador Horizontal, Multiplicador Vertical:
  // - De 0 a 9 e de A at� O representa as escalas de multiplica��o (A=10, B=11, ..., O=24)
  if (aMultiplicador >= 0) and (aMultiplicador < 10) then
    Result := IntToStr(aMultiplicador)
  else if (aMultiplicador < 24) then
    Result := chr(aMultiplicador + 55)  //Ex: 10 + 55 = 65 = A
  else
    raise Exception.Create(ACBrStr('Informe um valor entre 0 e 24'));
end;

function TACBrETQPpla.ConverterVelocidade(Velocidade: Integer): Char;
begin
  case Velocidade of
    1: Result := 'A';
    2: Result := 'B';
    3: Result := 'C';
    4: Result := 'D';
  else
    Result := 'C';
  end;
end;

function TACBrETQPpla.ConverterCoordenadas(aVertical, aHorizontal: Integer
  ): String;
var
  wAuxVert, wAuxHoriz: Integer;
begin
  wAuxVert  := ConverterUnidade(aVertical);
  wAuxHoriz := ConverterUnidade(aHorizontal);

  if (wAuxVert < 0) or (wAuxVert > 9999) then
    raise Exception.Create('Vertical deve ser de 0 a 9999');

  if (wAuxHoriz < 0) or (wAuxHoriz > 9999) then
    raise Exception.Create('Horizontal deve ser de 0 a 9999');

  Result := IntToStrZero(wAuxVert,  4) + IntToStrZero(wAuxHoriz, 4);
end;

function TACBrETQPpla.ConverterOrientacao(aOrientacao: TACBrETQOrientacao
  ): String;
begin
  Result := IntToStr(Integer(aOrientacao) + 1);
end;

function TACBrETQPpla.ConverterSubFonte(const aFonte: String; aSubFonte: Integer
  ): String;
begin
  if (aSubFonte < 0) or (aSubFonte > 999) then
    raise Exception.Create('Subfonte deve ser de 0 a 999');

  // SubFonte � utilizado para acessar fontes diferenciadas. Para mais informa��es
  //  consulte os ap�ndices AC e AD do manual PPLA&PPLB.pdf
  if (aFonte <> '9') then
    Result := '000'
  else
    Result := IntToStrZero(aSubFonte, 3);
end;

function TACBrETQPpla.ConverterEspessura(aVertical, aHorizontal: Integer
  ): String;
begin
  if (aHorizontal < 0) or (aHorizontal > 999) then
    raise Exception.Create('Espessura Horizontal deve ser de 0 a 999');

  if (aVertical < 0) or (aVertical > 999) then
    raise Exception.Create('Espessura Vertical deve ser de 0 a 999');

  Result := IntToStrZero(aHorizontal, 3) + IntToStrZero(aVertical, 3);
end;

function TACBrETQPpla.ConverterDimensao(aAltura, aLargura: Integer): String;
begin
  if (aLargura < 0) or (aLargura > 999) then
    raise Exception.Create('Largura deve ser de 0 a 999');

  if (aAltura < 0) or (aAltura > 999) then
    raise Exception.Create('Altura deve ser de 0 a 999');

  Result := IntToStrZero(aLargura, 3) + IntToStrZero(aAltura, 3);
end;

function TACBrETQPpla.ConverterAlturaBarras(aAlturaBarras: Integer
  ): String;
var
  wAlturaConv: Integer;
begin
  wAlturaConv := ConverterUnidade(aAlturaBarras);

  if (wAlturaConv < 0) or (wAlturaConv > 999) then
    raise Exception.Create('Altura Barras deve ser de 0 a 999');

  Result := IntToStrZero(wAlturaConv, 3);
end;

function TACBrETQPpla.ComandoReverso(aImprimirReverso: Boolean): String;
begin
  Result := IfThen(aImprimirReverso, 'A5', 'A1');
end;

function TACBrETQPpla.PrefixoComandoLinhaECaixa(aOrientacao: TACBrETQOrientacao
  ): String;
begin
  Result := ConverterOrientacao(aOrientacao) + 'X11000';
end;

function TACBrETQPpla.ConverterMultiplicadorImagem(aMultiplicador: Integer
  ): String;
begin
  aMultiplicador := max(aMultiplicador,1);
  if (aMultiplicador > 99) then
    raise Exception.Create('Multiplicador Imagem deve ser de 0 a 99');

  Result := IntToStrZero(aMultiplicador, 2);
end;

function TACBrETQPpla.ComandoTemperatura: AnsiString;
begin
  if (Temperatura < 0) or (Temperatura > 20) then
    raise Exception.Create('Temperatura deve ser de 0 a 20');

  if (Temperatura > 0) then
    Result := 'H' + IntToStrZero(Temperatura, 2)
  else
    Result := EmptyStr;
end;

function TACBrETQPpla.ComandoVelocidade: AnsiString;
begin
  if (Velocidade > 4) then
    raise Exception.Create('Velocidade deve ser de 1 a 4 ');

  if (Velocidade > 0) then
    Result := 'P' + ConverterVelocidade(Velocidade)
  else
    Result := EmptyStr;
end;

function TACBrETQPpla.ComandoCopias(const NumCopias: Integer): AnsiString;
begin
  inherited ComandoCopias(NumCopias);
  Result := 'Q' + IntToStrZero(NumCopias, 4);
end;

function TACBrETQPpla.ComandoImprimir: AnsiString;
begin
  Result := 'E';
end;

function TACBrETQPpla.ComandoAvancarEtiqueta(const aAvancoEtq: Integer
  ): AnsiString;
begin
  if (aAvancoEtq > 0) then
    Result := STX + 'f' + IntToStrZero(aAvancoEtq, 3)
  else
    Result := EmptyStr;
end;

function TACBrETQPpla.ComandoUnidade: AnsiString;
begin
  if (Unidade = etqPolegadas) then
    Result := 'n'
  else
    Result := 'm';

  Result := STX + Result;
end;

function TACBrETQPpla.ComandoResolucao: AnsiString;
begin
  Result := 'D11';  // Fixo em alta resolucao
end;

function TACBrETQPpla.ConverterUnidade(AValue: Integer): Integer;
begin
  if (Unidade = etqDots) then
    Result := inherited ConverterUnidade(etqMilimetros, AValue)
  else
    Result := AValue;

  if (Unidade <> etqDecimoDeMilimetros) then
    Result := AValue * 10;

  if (Unidade = etqPolegadas) then
    Result := Result * 10;
end;

function TACBrETQPpla.AjustarTipoBarras(const aTipo: String;
  aExibeCodigo: TACBrETQBarraExibeCodigo): String;
begin
  // Tipo de C�digo de Barras:
  // - De 'a' at� 't' ... De 'A' at� 'T'

  Result := PadLeft(aTipo, 1, 'a');

  if (aExibeCodigo = becNAO) then
    Result := LowerCase(Result)
  else
    Result := UpperCase(Result);

  if not CharInSet(Result[1], ['a'..'t','A'..'T']) then
    raise Exception.Create('Tipo Cod.Barras deve ser de "A" a "T"');
end;

function TACBrETQPpla.ComandoAbertura: AnsiString;
begin
  Result := STX + 'L';
end;

function TACBrETQPpla.ComandosFinalizarEtiqueta(NumCopias: Integer;
  aAvancoEtq: Integer): AnsiString;
var
  wAvanco: Integer;
begin
  if (aAvancoEtq < 0) or (aAvancoEtq > 779) then
    raise Exception.Create('Avan�o de Etiquetas deve ser de 0 a 779');

  // Valor m�nimo para Back-feed � 220 (Manual "PPLA&PPLB.pdf" ... p�g. 18)
  wAvanco := aAvancoEtq + 220;
  Result  := Inherited ComandosFinalizarEtiqueta(NumCopias, wAvanco);
end;

function TACBrETQPpla.TratarComandoAntesDeEnviar(const aCmd: AnsiString): AnsiString;
begin
  Result := ChangeLineBreak( aCmd, CR );
end;

function TACBrETQPpla.ComandoLimparMemoria: AnsiString;
begin
  Result :=  STX + 'Q';
end;

function TACBrETQPpla.ComandoImprimirTexto(aOrientacao: TACBrETQOrientacao;
  aFonte: String; aMultHorizontal, aMultVertical, aVertical,
  aHorizontal: Integer; aTexto: String; aSubFonte: Integer;
  aImprimirReverso: Boolean): AnsiString;
begin
  if (Length(aTexto) > 255) then
    raise Exception.Create(ACBrStr('Tamanho m�ximo para o texto 255 caracteres'));

  aFonte := PadLeft(aFonte,1,'0');
  if (aFonte < '0') or (aFonte > '9') then
    raise Exception.Create('Fonte deve ser de 0 a 9');

  if aImprimirReverso <> fImprimirReverso then
  begin
    fImprimirReverso := aImprimirReverso;
    Result := ComandoReverso(aImprimirReverso) + sLineBreak
  end
  else
    Result := '';

  Result := Result +
            ConverterOrientacao(aOrientacao) +
            aFonte +
            ConverterMultiplicador(aMultHorizontal) +
            ConverterMultiplicador(aMultVertical) +
            ConverterSubFonte(aFonte, aSubFonte) +
            ConverterCoordenadas(aVertical, aHorizontal) +
            LeftStr(aTexto, 255);
end;

function TACBrETQPpla.ConverterTipoBarras(TipoBarras: TACBrTipoCodBarra
  ): String;
begin
  case TipoBarras of
    barCODE39      : Result := 'A';
    barUPCA        : Result := 'B';
    barINTERLEAVED : Result := 'D';
    barCODE128     : Result := 'E';
    barEAN13       : Result := 'F';
    barEAN8        : Result := 'G';
    barCODABAR     : Result := 'I';
    barCODE93      : Result := 'O';
    barMSI         : Result := 'K';
  else
    Result := '';
  end;
end;

function TACBrETQPpla.ComandoImprimirBarras(aOrientacao: TACBrETQOrientacao;
  aTipoBarras: String; aBarraLarga, aBarraFina, aVertical,
  aHorizontal: Integer; aTexto: String; aAlturaBarras: Integer;
  aExibeCodigo: TACBrETQBarraExibeCodigo): AnsiString;
begin
  // Largura da Barra Larga e Largura da Barra Fina:
  // - De 0 a 9 ... de 'A' at� 'O'

  Result := ConverterOrientacao(aOrientacao) +
            AjustarTipoBarras(aTipoBarras, aExibeCodigo) +
            ConverterMultiplicador(aBarraLarga) +
            ConverterMultiplicador(aBarraFina) +
            ConverterAlturaBarras(aAlturaBarras) +
            ConverterCoordenadas(aVertical, aHorizontal) +
            LeftStr(aTexto, 255);
end;

function TACBrETQPpla.ComandoImprimirQRCode(aVertical, aHorizontal: Integer;
  const aTexto: String; aLarguraModulo: Integer; aErrorLevel: Integer;
  aTipo: Integer): AnsiString;
var
  CeD: AnsiString;
begin
  CeD := ConverterMultiplicador(aLarguraModulo);
  Result := ConverterOrientacao(orNormal) +
            'W1D' +
            CeD + CeD + '000' +
            ConverterCoordenadas(aVertical, aHorizontal) +
            IntToStr(aTipo) + ',' +
            ConverterQRCodeErrorLevel(aErrorLevel) + 'A,' +
            aTexto;
end;

function TACBrETQPpla.ComandoImprimirLinha(aVertical, aHorizontal, aLargura,
  aAltura: Integer): AnsiString;
begin
  Result := PrefixoComandoLinhaECaixa(orNormal) +
            ConverterCoordenadas(aVertical, aHorizontal) +
            'L' +
            ConverterDimensao(aAltura, aLargura);
end;

function TACBrETQPpla.ComandoImprimirCaixa(aVertical, aHorizontal, aLargura,
  aAltura, aEspVertical, aEspHorizontal: Integer): AnsiString;
begin
  Result := PrefixoComandoLinhaECaixa(orNormal) +
            ConverterCoordenadas(aVertical, aHorizontal) +
            'B' +
            ConverterDimensao(aAltura, aLargura) +
            ConverterEspessura(aEspVertical, aEspHorizontal);
end;

function TACBrETQPpla.AjustarNomeArquivoImagem(const aNomeImagem: String): String;
begin
  Result := UpperCase(LeftStr(OnlyAlphaNum(aNomeImagem), 16));
end;

function TACBrETQPpla.ComandoImprimirImagem(aMultImagem, aVertical,
  aHorizontal: Integer; aNomeImagem: String): AnsiString;
begin
  Result := '1Y' +
            ConverterMultiplicadorImagem(aMultImagem) + '000' +
            ConverterCoordenadas(aVertical, aHorizontal) +
            AjustarNomeArquivoImagem(aNomeImagem);
end;

function TACBrETQPpla.ComandoCarregarImagem(aStream: TStream;
  aNomeImagem: String; aFlipped: Boolean; aTipo: String): AnsiString;
var
  Cmd: Char;
  DataImg: AnsiString;
begin
  DataImg := '';
  aStream.Position := 0;

  if (aTipo = '') then
    aTipo := 'BMP'
  else
    aTipo := UpperCase(RightStr(aTipo, 3));

  if (aTipo = 'PCX') then
  begin
    if not IsPCX(aStream, True) then
      raise Exception.Create(ACBrStr(cErrImgPCXMono));

    Cmd := 'p'
  end
  else if (aTipo = 'BMP') then
  begin
    if not IsBMP(aStream, True) then
      raise Exception.Create(ACBrStr(cErrImgBMPMono));

    Cmd := 'F';
    DataImg := BMP2HEX(aStream, aFlipped);
  end
  else if (aTipo = 'IMG') then
    Cmd := 'i'
  else if (aTipo = 'HEX') then
    Cmd := 'F'
  else
    raise Exception.Create(ACBrStr(
      'Formato de Imagem deve ser: BMP, PCX, IMG ou HEX, e Monocrom�tica'));

  if aFlipped then
    Cmd := UpCase(Cmd);

  if (DataImg = '') then
    DataImg := ReadStrFromStream(aStream, aStream.Size);

  Result := STX + 'IA' + Cmd + AjustarNomeArquivoImagem(aNomeImagem) + CR +
            DataImg;
end;

function TACBrETQPpla.BMP2HEX(aStream: TStream; Inverter: Boolean): String;
var
  ARasterImg: AnsiString;
  AHeight, AWidth, i, LenImgHex, BytesPerRow, HexPerRow: Integer;
  ALine, ImgHex: String;
begin
  Result := '';
  AWidth := 0; AHeight := 0; ARasterImg := '';
  BMPMonoToRasterStr(aStream, not Inverter, AWidth, AHeight, ARasterImg);

  ImgHex := AsciiToHex(ARasterImg);
  LenImgHex := Length(ImgHex);
  BytesPerRow := ceil(AWidth / 8);
  HexPerRow := BytesPerRow * 2;
  i := 1;
  while i < LenImgHex do
  begin
    ALine := '80'+IntToHex(BytesPerRow, 2) +
             copy(ImgHex, i, HexPerRow) + CR;
    i := i + HexPerRow;
    Result := ALine + Result;
  end;

  Result := Result + 'FFFF' + CR;
end;

end.
