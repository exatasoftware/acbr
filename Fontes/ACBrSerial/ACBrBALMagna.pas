{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Fabio Farias                           }
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
|* 04/10/2005: Fabio Farias  / Daniel Sim�es de Almeida
|*  - Primeira Versao ACBrBALFilizola
|* 05/11/2011: Levindo Damasceno
|*  - Primeira Versao ACBrBALFilizola
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALMagna;

interface

uses ACBrBALClass, Classes;

type

  { TACBrBALMagna }

  TACBrBALMagna = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
    procedure SolicitarPeso; override;
  end;

implementation

uses
  ACBrConsts, SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} ACBrD5, Windows{$ENDIF};

{ TACBrBALGertecSerial }

constructor TACBrBALMagna.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Magna';
end;

function TACBrBALMagna.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wPosIni, wPosFim, wDecimais: Integer;
  wResposta: AnsiString;
begin
  Result    := 0;
  aResposta := Copy(aResposta, 1, Pos(#10, aResposta) - 1);
  wPosIni   := Pos(' ', aResposta);
  wPosFim   := Pos('k', aResposta);
  wDecimais := 1000;

  if (wPosFim = 0) then
    wPosFim := Length(aResposta);

  wResposta := Copy(aResposta, wPosIni, wPosFim - wPosIni);

  if (wResposta = EmptyStr) then
    Exit;

  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    if (Length(wResposta) > 10) then
      Result := (StrToFloat(Copy(wResposta, 1, 6)) / wDecimais)
    else if (Pos(DecimalSeparator, wResposta) > 0) then
      Result := StrToFloat(wResposta)
    else
      Result := (StrToInt(wResposta) / wDecimais);
  except
    case Trim(wResposta)[1] of
    //'I' : Result := -1  ;  { Instavel }
    //'S' : Result := -10 ;  { Sobrecarga de Peso }
      'N' :                  { Peso Negativo }
      begin
        Result    := -2;
        wResposta := ' Peso Negativo ';
      end;
    else
      Result := 0;
    end;
  end
end;

procedure TACBrBALMagna.SolicitarPeso;
begin
  GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' TX -> ' + #80);
  fpDevice.Limpar;
  fpDevice.EnviaString(#80);  { Envia comando Solicitando o Peso }
end;

end.
