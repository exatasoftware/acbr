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

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXUtil;

interface

uses
  Classes, SysUtils,
  ACBrPIXBase;

resourcestring
  sErroTxIdMuitoLonga = 'Chave TxId excede 25 Caracteres';
  sErroTxIdInvalido = 'Caracteres inv�lidos no TxId';

function DetectarTipoChave(const AChave: String): TACBrPIXTipoChave;
function ValidarTxId(const ATxId: String): String;
function FormatarQRCodeId(AId: Byte; const ValorId: String): String;
function FormatarValorPIX(AValor: Double): String;
function Crc16PIX(const AString: String): String;

implementation

uses
  ACBrValidador, ACBrUtil, ACBrConsts;

function DetectarTipoChave(const AChave: String): TACBrPIXTipoChave;
var
  s, e: String;
  l: Integer;
begin
  s := trim(AChave);
  l := Length(s);
  Result := tcNenhuma;

  if (l = 11) then
  begin
    e := ACBrValidador.ValidarCPF(s);
    if (e = '') then
      Result := tcCPF;
  end
  else if (l = 14) then
  begin
    if copy(s,1,3) = '+55' then  // Fone BR
    begin
      if StrIsNumber(copy(s,4,l)) then
        Result := tcCelular;
    end
    else
    begin
      e := ACBrValidador.ValidarCNPJ(s);
      if (e = '') then
        Result := tcCNPJ;
    end;
  end
  else if (l = 36) then
  begin
    if (copy(s,09,1) = '-') and
       (copy(s,14,1) = '-') and
       (copy(s,19,1) = '-') and
       (copy(s,24,1) = '-') and
       StrIsAlphaNum(StringReplace(s,'-','',[rfReplaceAll])) then
      Result := tcAleatoria;
  end;
end;

function ValidarTxId(const ATxId: String): String;
var
  e, s: String;
  l: Integer;
begin
  e := '';
  s := Trim(ATxId);
  l := Length(s);

  if (l > 25) then
    e := sErroTxIdMuitoLonga
  else
  begin
    if not StrIsAlpha(s) then
      e := sErroTxIdInvalido;
  end;

  Result := e;
end;

function FormatarQRCodeId(AId: Byte; const ValorId: String): String;
var
  s: String;
  l: Integer;
begin
  s := Trim(ValorId);
  l := Length(s);
  if (l > 0) then
    Result := IntToStrZero(AId, 2) + IntToStrZero(l, 2) + s
  else
    Result := '';
end;

function FormatarValorPIX(AValor: Double): String;
var
  s: String;
begin
  s := FormatFloatBr(AValor, FloatMask(2,False));
  Result := StringReplace(s, DecimalSeparator, '.', []);
end;

// Fonte: https://github.com/bacen/pix-api/issues/189#issuecomment-783712221
function Crc16PIX(const AString: String): String;
const
  polynomial = $1021;
var
  crc: WORD;
  i, j: Integer;
  b: Byte;
  bit, c15: Boolean;
begin
  crc := $FFFF;
  for i := 1 to length(AString) do
  begin
    b := Byte(AString[i]);
    for j := 0 to 7 do
    begin
      bit := (((b shr (7 - j)) and 1) = 1);
      c15 := (((crc shr 15) and 1) = 1);
      crc := crc shl 1;
      if (c15 xor bit) then
        crc := crc xor polynomial;
    end;
  end;
  crc := crc and $FFFF;

  Result := IntToHex(crc, 4);
end;

end.

