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

unit ACBrEscPosStar;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson
  {$IfDef NEXTGEN}
   ,ACBrBase
  {$EndIf};

type

  { TACBrEscPosStar }

  TACBrEscPosStar = class(TACBrEscPosEpson)

  public
    constructor Create(AOwner: TACBrPosPrinter);
    function ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo): AnsiString; override;
    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
    function ComandoImprimirImagemRasterStr(const RasterStr: AnsiString; AWidth: Integer;
      AHeight: Integer): AnsiString; override;
  end;

implementation

uses
  math,
  ACBrConsts, ACBrUtil;

{ TACBrEscPosStar }

constructor TACBrEscPosStar.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscPosStar';

  with Cmd  do
  begin
    Beep := ESC + GS + BELL + #1 + #2 + #5;
  end;
end;

function TACBrEscPosStar.ComandoPaginaCodigo(APagCodigo: TACBrPosPaginaCodigo
  ): AnsiString;
//var
//  CmdPag: Integer;
begin
  Result := inherited ComandoPaginaCodigo(APagCodigo);

  // pc850, n�o funcinou corretamente no G800.
  //case APagCodigo of
  //  pc437: CmdPag := 1;
  //  pc850, pc852: CmdPag := 5;
  //  pc860: CmdPag := 6;
  //  pc1252: CmdPag := 32;
  //else
  //  CmdPag := 0;
  //end;
  //
  //Result := ESC + GS + 't' + AnsiChr( CmdPag );
end;

function TACBrEscPosStar.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
begin
  Result := inherited ComandoQrCode(ACodigo);

  // Comando padr�o da Star, n�o funcinou corretamente no G800.
  //with fpPosPrinter.ConfigQRCode do
  //begin
  //  Result := ESC + GS + 'yS0'+ AnsiChr(Tipo) +
  //            ESC + GS + 'yS1'+ AnsiChr(ErrorLevel) +
  //            ESC + GS + 'yS2'+ AnsiChr(min(LarguraModulo,8)) +
  //            ESC + GS + 'yD10'+ IntToLEStr(length(ACodigo)) + ACodigo +  // Codifica
  //            ESC + GS + 'yP';  // Imprime
  //end;
end;

function TACBrEscPosStar.ComandoImprimirImagemRasterStr(
  const RasterStr: AnsiString; AWidth: Integer; AHeight: Integer): AnsiString;
begin
  // Gerando RasterStr, sem LF, a cada fatia
  Result := ComandoImprimirImagemColumnStr(fpPosPrinter, RasterStr, AWidth, AHeight, False)
end;

end.

