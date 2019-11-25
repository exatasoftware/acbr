{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ivan Carlos Martello                                                 }
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

{******************************************************************************
|* Historico
|*
|* 30/07/2019: Daniel Sonda
|*  - Primeira vers�o
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALWeightechWT1000;

interface

uses
  ACBrBALClass, Classes;

type

  { TACBrBALWeightechWT1000 }

  TACBrBALWeightechWT1000 = class(TACBrBALClass)
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

{ TACBrBALWeightechWT1000 }

constructor TACBrBALWeightechWT1000.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Weightech WT1000';
end;

function TACBrBALWeightechWT1000.LePeso(MillisecTimeOut : Integer) : Double;
begin
  Result := AguardarRespostaPeso(MillisecTimeOut, True);
end;

function TACBrBALWeightechWT1000.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: String;
  wPos: integer;
begin
  Result    := 0;
  wResposta := aResposta;

  { S , B B B . B B B , T T T . T T T , L L L . L L L CR LF

    S: Flag de estabilidade e pode assumir os seguintes valores:
      0: Peso est�vel;
      1: Peso inst�vel.
    B: 7 bytes de peso bruto incluindo o ponto decimal e sinal de peso negativo;
    T: 7 bytes de peso tara incluindo o ponto decimal e sinal de peso negativo;
    L: 7 bytes de peso l�quido incluindo o ponto decimal e sinal de peso negativo;
    CR Carriage return (0X0D)
    LF Line feed (0x0A) }

  // quando em transmiss�o cont�nua, pode concatenar v�rios envios na resposta
  wPos := Pos(LF, wResposta);
  if (wPos > 0) then
    wResposta := Copy(wResposta, wPos + 1, 25);

  if Length(wResposta) <> 25 then
    Exit;

  if wResposta[1] = '1' then
  begin
    // inst�vel
    Result := -1;
    Exit; 
  end;

  wResposta := Copy(wResposta, 19, 7); // peso l�quido

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  Result := StrToFloatDef(wResposta, 0);
end;

end.

