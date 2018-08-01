{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Ivan Carlos Martello                   }
{                                       Daniel Simoes de Almeida               }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 17/02/2009: Ivan Carlos Martello
|*  - Primeira Versao ACBrBALUrano
|*
|* 11/10/2016 - Elias C�sar Vieira
|*  - Refatora��o de ACBrBALUranoPOP
******************************************************************************}
{$I ACBr.inc}

unit ACBrBALUranoPOP;

interface

uses
  ACBrBALClass, Classes;

type

  { TACBrBALUranoPOP }

  TACBrBALUranoPOP = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function LePeso(MillisecTimeOut: Integer = 3000): Double; override;

    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
  end;

implementation

uses
  ACBrConsts, SysUtils,
  {$IFDEF COMPILER6_UP}
    DateUtils, StrUtils
  {$ELSE}
    ACBrD5, Windows
  {$ENDIF};

{ TACBrBALGertecSerial }

constructor TACBrBALUranoPOP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Urano';
end;

function TACBrBALUranoPOP.LePeso(MillisecTimeOut : Integer) : Double;
begin
  fpUltimoPesoLido := -1;

  SolicitarPeso;
  Sleep(600);

  LeSerial(MillisecTimeOut);
  Result := fpUltimoPesoLido;
end;

function TACBrBALUranoPOP.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
  wPos, wQtd: Integer;
begin
  Result    := 0;
  wResposta := aResposta;
  wResposta := Copy(wResposta, Pos('PESO L:', wResposta), 16);

  wPos := Pos(':', wResposta);

  if (Length(wResposta) > 1) then
  begin
    wQtd      := (Pos('g', wResposta) - 2);
    wQtd      := wQtd - (wPos + 1);
    wResposta := Copy(wResposta, wPos + 2, wQtd); //123456
  end;

  if (wResposta = EmptyStr) then
    Exit;

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    { J� existe ponto decimal ? }
    if (Pos(DecimalSeparator, wResposta) > 0) then
      Result := StrToFloat(wResposta)
    else
      Result := (StrToInt(wResposta) / 1000);
  except
    case Trim(wResposta)[1] of
      'I': Result := -1;     { Instavel }
      'N': Result := -2;     { Peso Negativo }
      //'S': Result := -10;  { Sobrecarga de Peso }
    else
      Result := 0;
    end;
  end;
end;

end.

