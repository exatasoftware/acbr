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

unit ACBrEscElgin;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscBematech, ACBrConsts
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrEscElgin }

  TACBrEscElgin = class(TACBrEscBematech)
  private
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoGaveta(NumGaveta: Integer = 1): AnsiString; override;
    procedure LerStatus(var AStatus: TACBrPosPrinterStatus); override;
  end;


implementation

Uses
  math,
  ACBrUtil;

{ TACBrEscElgin }

constructor TACBrEscElgin.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscElgin';
end;

function TACBrEscElgin.ComandoGaveta(NumGaveta: Integer): AnsiString;
var
  Tempo: Integer;
begin
  with fpPosPrinter.ConfigGaveta do
  begin
    Tempo := max(TempoON, TempoOFF);
    Result := ESC + 'v' + 'n' + AnsiChr( Tempo );
  end;
end;

procedure TACBrEscElgin.LerStatus(var AStatus: TACBrPosPrinterStatus);
var
  B: Byte;
  Ret: AnsiString;
begin
  try
    Ret := fpPosPrinter.TxRx(ENQ, 1, 500);
    B := Ord(Ret[1]);

    if not TestBit(B, 0) then
      AStatus := AStatus + [stOffLine];

    if TestBit(B, 1) then
      AStatus := AStatus + [stSemPapel];

    if TestBit(B, 2) then
      AStatus := AStatus + [stGavetaAberta];

    if not TestBit(B, 3) then
      AStatus := AStatus + [stTampaAberta];

    if TestBit(B, 4) then
      AStatus := AStatus + [stPoucoPapel];
  except
    AStatus := AStatus + [stErroLeitura];
  end;
end;

function TACBrEscElgin.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
var
  Quality: AnsiChar;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
    Result := GS + 'o' + #0 +             // Set parameters of QRCODE barcode
              AnsiChr(LarguraModulo) +    // Basic element width
              #0 +                        // Language mode: 0:Chinese 1:Japanese
              AnsiChr(Tipo) ;             // Symbol type: 1:Original type 2:Enhanced type(Recommended)

    case ErrorLevel of
      1: Quality := 'M';
      2: Quality := 'Q';
      3: Quality := 'H';
    else
      Quality := 'L';
    end;

    Result := Result +
              GS  + 'k' + // Bar Code
              #11 +       // Type = QRCode. Number of Characters: 4-928
              Quality +
              'A,' +      // Data input mode Range: A-automatic (Recommended). M-manual
              ACodigo +
              #0;
  end;
end;

end.

