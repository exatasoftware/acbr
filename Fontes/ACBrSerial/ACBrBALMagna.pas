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

unit ACBrBALMagna;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALMagna }

  TACBrBALMagna = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
    procedure SolicitarPeso; override;
  end;

implementation

uses
  SysUtils,
  ACBrConsts, ACBrUtil,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALGertecSerial }

constructor TACBrBALMagna.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Magna';
end;

function TACBrBALMagna.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wPosIni, wPosFim, wDecimais: Integer;
  wResposta: AnsiString;
begin

  Result    := 0;
  wResposta := Copy(aResposta, PosLast(TAB, aResposta), PosLast(CR, aResposta) - 1);

  wPosIni   := Pos(' ', wResposta);
  wPosFim   := Pos('k', wResposta);
  wDecimais := 1000;

  if (wPosFim = 0) then
    wPosFim := Length(wResposta);

  wResposta := Copy(wResposta, wPosIni, wPosFim - wPosIni);

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
    case PadLeft(Trim(wResposta),1)[1] of
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
