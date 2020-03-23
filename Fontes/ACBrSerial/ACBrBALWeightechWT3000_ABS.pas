{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Andre Adami                                   }
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

unit ACBrBALWeightechWT3000_ABS;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrBALWeightechWT3000_ABS }

  TACBrBALWeightechWT3000_ABS = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function LePeso(MillisecTimeOut: Integer = 3000): Double; override;

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils, ACBrConsts,
  {$IFDEF COMPILER6_UP}
   DateUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALWeightechWT3000_ABS }

constructor TACBrBALWeightechWT3000_ABS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Weightech WT3000_ABS';
end;

function TACBrBALWeightechWT3000_ABS.LePeso(MillisecTimeOut : Integer) : Double;
begin
  Result := AguardarRespostaPeso(MillisecTimeOut, True);
end;

function TACBrBALWeightechWT3000_ABS.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: String;
  wPos: integer;
begin
  Result    := 0;
  wResposta := aResposta;

  {
  Exemplo:  +0.876kg quando o peso estiver est�vel e valor de peso l�quido
  S T , N T , +   0 . 8 7 6 k g 0D 0A

   1 2    3   4 5     6     7 8 9 10 11 12 13 14     15 16    17   18
  HEAD1   ,   HEAD2   ,             DATA            UNIDADE   CR   LF


  HEAD1 ( 2 BYTES )
   OL  -   Sobrecarga , Subcarga
   ST  -   Display est� est�vel
   US  -   Display est� inst�vel

  HEAD2 ( 2 BYTES )
   NT  -   Modo NET (L�quido)
   GS  -   Modo GROSS (Bruto)
   }

  // quando em transmiss�o cont�nua, pode concatenar v�rios envios na resposta
  wPos := Pos(LF, wResposta);
  if (wPos > 0) then
    wResposta := Copy(wResposta, wPos + 1, 16);

  if Length(wResposta) <> 16 then
    Exit;

  if wResposta[1] = '1' then
  begin
    // inst�vel
    Result := -1;
    Exit;
  end;

  wResposta := Copy(wResposta, 8, 7); // peso l�quido

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  Result := StrToFloatDef(wResposta, 0);
end;

end.

