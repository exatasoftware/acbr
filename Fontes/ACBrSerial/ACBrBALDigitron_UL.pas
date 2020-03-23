{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Adami                                     }
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

unit ACBrBALDigitron_UL;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALDigitron_UL }

  TACBrBALDigitron_UL = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils, Math,
  ACBrConsts, ACBrUtil,
  {$IFDEF COMPILER6_UP}
    DateUtils, StrUtils
  {$ELSE}
    ACBrD5, Windows
  {$ENDIF};

{ TACBrBALDigitron_UL }

constructor TACBrBALDigitron_UL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Digitron_UL';
end;

function TACBrBALDigitron_UL.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
  wDecimais: Integer;
begin
  Result := -9;

  if (aResposta = EmptyStr) then
    Exit;

  //Fonte: "Manual de Opera��o Balan�as dePiso, Balan�a de Bancada e Barra de Pesagem"
  //-- manual digitron_UL.pdf
  //A balan�a pode ser configurada como Modo Contadora ou Modo Pesadora.
  //A string transmitida no Modo Contadora � visualizada no Hyper Terminal como
  // "D00005" (sem aspas)
  //A string transmitida no Modo Pesadora � visualizada no Hyper Terminal como
  // "E1234.5" (sem aspas)

  wDecimais := 100;
  wResposta := Copy(aResposta, 1, 8);

  //TODO: O primeiro byte que est� sendo retirado abaixo al�m de mostrar o modo
  // tamb�m traz o status da balan�a.
  // Mas esse status n�o est� sendo tratado...

  { Retira D }
  if (Copy(wResposta, 1, 1) = 'D') then
    wResposta := Copy(wResposta, 2, Length(wResposta));

  { Retira F }
  if (Copy(wResposta, 1, 1) = 'F') then
    wResposta := Copy(wResposta, 2, Length(wResposta));

  { Retira @ }
  if (Copy(wResposta, 1, 1) = '@') then
    wResposta := Copy(wResposta, 2, Length(wResposta));


  if (wResposta = EmptyStr) then
    Exit;

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    { J� existe ponto decimal ? }
    if (Pos(DecimalSeparator, String(wResposta)) > 0) then
      Result := StrToFloat(wResposta)
    else
      Result := (StrToInt(wResposta) / wDecimais);
  except
    case PadLeft(Trim(wResposta),1)[1] of
      'I': Result := -1;   { Instavel }
      'N': Result := -2;   { Peso Negativo }
      'S': Result := -10;  { Sobrecarga de Peso }
    else
      Result := -9;
    end;
  end;
end;

end.
