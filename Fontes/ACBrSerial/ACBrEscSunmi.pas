{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrEscSunmi;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson;

const
  cSunmiTimeout = 500;
  cSunmiTimeoutTCP = 1000;

type

  { TACBrEscSunmi }

  TACBrEscSunmi = class(TACBrEscPosEpson)
  public
    constructor Create(AOwner: TACBrPosPrinter);
    procedure Configurar; override;
    function LerInfo: String; override;
    function ComandoFonte(TipoFonte: TACBrPosTipoFonte; Ligar: Boolean): AnsiString;
      override;
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString; override;
    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoLogo: AnsiString; override;
    function ComandoGravarLogoRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
    function ComandoApagarLogo: AnsiString; override;
  end;

implementation

uses
  StrUtils,
  ACBrUtil.Math, ACBrUtil.Strings,
  ACBrConsts;

{ TACBrEscSunmi }

constructor TACBrEscSunmi.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscSunmi';

  {(*}
  with Cmd  do
  begin
    Beep := ESC + GS + BELL + '1' + #2 + #5;
    LigaCondensado := '';
    DesligaCondensado := '';
  end;
  {*)}

  TagsNaoSuportadas.Add( cTagLigaCondensado );
  TagsNaoSuportadas.Add( cTagDesligaCondensado );
  TagsNaoSuportadas.Add( cTagLogotipo );
  TagsNaoSuportadas.Add( cTagLogoKC1 );
  TagsNaoSuportadas.Add( cTagLogoKC2 );
  TagsNaoSuportadas.Add( cTagLogoFatorX );
  TagsNaoSuportadas.Add( cTagLogoFatorY );
end;

procedure TACBrEscSunmi.Configurar;
begin
  inherited Configurar;

  with fpPosPrinter do
  begin
    PaginaDeCodigo := pcUTF8;

  end;
end;

function TACBrEscSunmi.ComandoFonte(TipoFonte: TACBrPosTipoFonte;
  Ligar: Boolean): AnsiString;
var
  NovoFonteStatus: TACBrPosFonte;
  AByte: Integer;
begin
  Result := '';
  NovoFonteStatus := fpPosPrinter.FonteStatus;
  if Ligar then
    NovoFonteStatus := NovoFonteStatus + [TipoFonte]
  else
    NovoFonteStatus := NovoFonteStatus - [TipoFonte];

  if TipoFonte in [ftNegrito, ftExpandido, ftItalico, ftSublinhado, ftAlturaDupla] then
  begin
    AByte := 0;

    if ftNegrito in NovoFonteStatus then
      SetBit(AByte, 3);

    if ftAlturaDupla in NovoFonteStatus then
      SetBit(AByte, 4);

    if ftExpandido in NovoFonteStatus then
      SetBit(AByte, 5);

    if ftItalico in NovoFonteStatus then
      SetBit(AByte, 6);

    if ftSublinhado in NovoFonteStatus then
      SetBit(AByte, 7);

    Result := ESC + '!' + AnsiChr(Byte(AByte));

    // ESC ! desliga Invertido, enviando o comando novamente
    if ftInvertido in NovoFonteStatus then
      Result := Result + Cmd.LigaInvertido;
  end
  else
    Result := inherited ComandoFonte(TipoFonte, Ligar);

end;

function TACBrEscSunmi.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString;
begin
  // Usa sempre UTF8
  Result := FS +'.';   // Cancel Chinese character mode
end;

function TACBrEscSunmi.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  // Gerando RasterStr, sem LF, a cada fatia
  Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight, True)
end;

function TACBrEscSunmi.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
     Result := GS + '(k' + #4 + #0 + '1A' + #0 + #0 +  // Tipo n�o � usado
               GS + '(k' + #3 + #0 + '1C' + AnsiChr(LarguraModulo) +   // Largura Modulo
               GS + '(k' + #3 + #0 + '1E' + AnsiString(IntToStr(ErrorLevel)) + // Error Level
               GS + '(k' + IntToLEStr(length(ACodigo)+3)+'1P0' + ACodigo +  // Codifica
               GS + '(k' + #3 + #0 +'1Q0';  // Imprime
  end;
end;

function TACBrEscSunmi.ComandoLogo: AnsiString;
begin
  Result := '';
end;

function TACBrEscSunmi.ComandoGravarLogoRasterStr(const RasterStr: AnsiString;
  AWidth: Integer; AHeight: Integer): AnsiString;
begin
  Result := '';
end;

function TACBrEscSunmi.ComandoApagarLogo: AnsiString;
begin
  Result := '';
end;

function TACBrEscSunmi.LerInfo: String;
var
  Ret: AnsiString;
  Info: String;
  t: Integer;

  Procedure AddInfo( Titulo: String; AInfo: AnsiString);
  begin
    AInfo := Trim(AInfo);
    if (AInfo = '') then
      Exit;

    if (LeftStr(AInfo,1) = '_') then
      AInfo := copy(AInfo, 2, Length(AInfo));

    Info := Info + Titulo+'='+AInfo + sLineBreak;
  end;

  function BoolToChar(ABool: Boolean): AnsiChar;
  begin
    if ABool then
      Result := '1'
    else
      Result := '0';
  end;

begin
  Info := '';
  Result := '';

  t := cSunmiTimeout;
  if fpPosPrinter.Device.IsTCPPort then
    t := t + cSunmiTimeoutTCP;
  if (fpPosPrinter.Device.TimeOutMilissegundos > t) then
    t := fpPosPrinter.Device.TimeOutMilissegundos;

  try
    // Lendo o Fabricante
    Ret := fpPosPrinter.TxRx( GS + 'IB', 0, t, True );
    AddInfo(cKeyFabricante, Ret);

    // Lendo a vers�o do Firmware
    Ret := fpPosPrinter.TxRx( GS + 'IA', 0, t, True );
    AddInfo(cKeyFirmware, Ret);

    // Lendo o Modelo
    Ret := fpPosPrinter.TxRx( GS + 'IC', 0, t, True );
    AddInfo(cKeyModelo, Ret);

    // Lendo o N�mero Serial
    Ret := fpPosPrinter.TxRx( GS + 'ID', 0, t, True );
    AddInfo('Serial', Ret);
  except
  end;

  AddInfo(cKeyGuilhotina, BoolToChar(True) );
  Result := Info;
end;

end.

