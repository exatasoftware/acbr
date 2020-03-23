{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ivan Carlos Martello                                                }
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

{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Jo�o Paulo, Ivan Carlos Martello                }
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

unit ACBrBALLucasTec;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALLucasTec }

  TACBrBALLucasTec = class(TACBrBALClass)
  private
    function StrToPeso(const StrPeso, aResposta: AnsiString): Double;

  public
    constructor Create(AOwner: TComponent);

    procedure LeSerial(MillisecTimeOut: Integer = 500); override;
    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils,
  ACBrConsts,
  {$IFDEF COMPILER6_UP}
    DateUtils, StrUtils
  {$ELSE}
    ACBrD5, Windows
  {$ENDIF};

{ TACBrBALGertecSerial }

function TACBrBALLucasTec.StrToPeso(const StrPeso, aResposta: AnsiString): Double;
var
  I, wPos: Integer;
  wStr: String;
begin
  Result := 0;
  wPos   := Pos(UpperCase(StrPeso), UpperCase(aResposta));

  if (wPos > 0) then
  begin
    wStr := Trim(Copy(aResposta, 1, wPos - 1));

    for I := Length(wStr) downto 1 do
    begin
      if (wStr[I] = ' ') then
      begin
        wStr := RightStr(wStr, Length(wStr) - I + 1);

        { Ajustando o separador de Decimal corretamente }
        wStr := StringReplace(wStr, '.', DecimalSeparator, [rfReplaceAll]);
        wStr := StringReplace(wStr, ',', DecimalSeparator, [rfReplaceAll]);
        try
          if (Pos(DecimalSeparator, wStr) > 0) then  { J� existe ponto decimal ? }
            Result := StrToFloat(wStr)
          else
            Result := (StrToInt(wStr) / 1000);
        except
          Result := 0;
        end;

        Break;
      end;
    end
  end;
end;

constructor TACBrBALLucasTec.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'LucasTec';
end;

procedure TACBrBALLucasTec.LeSerial(MillisecTimeOut: Integer);
var
  Pesos: array[1..4] of Double;
  I: Integer;
begin
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  try
    for I := 1 to 4 do
    begin
      fpUltimaResposta := fpDevice.LeString(MillisecTimeOut, 0, #13);
      GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' RX <- ' + fpUltimaResposta);

      Pesos[I] := InterpretarRepostaPeso(fpUltimaResposta);
    end;

    if (Pesos[2] = Pesos[3]) and (Pesos[3] = Pesos[4]) then
      fpUltimoPesoLido := Pesos[4]
    else
      fpUltimoPesoLido := -1;

  except
    { Peso n�o foi recebido (TimeOut) }
    On E: Exception do
    begin
      fpUltimoPesoLido := -9;
      fpUltimaResposta := E.Message;
    end;
  end;

  GravaLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido)+' , Resposta: ' + fpUltimaResposta);
end;

function TACBrBALLucasTec.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  PesoL, PesoB, PesoT: Double;
  wResposta: AnsiString;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  //aResposta := #2+'0000 000001 20/06/05 50.00 kg B  0.60 kg T  49.40 kg L'+#13#180;
  wResposta := Copy(aResposta, Pos(#2, aResposta) + 1, Length(aResposta));
  Result    := 0;

  if not (Pos('kg B ', wResposta) > 0) then
    wResposta := 'I';

  if (Length(wResposta) > 1) then
  begin
    PesoL := StrToPeso('kg L', wResposta);
    PesoT := StrToPeso('kg T', wResposta);
    PesoB := StrToPeso('kg B', wResposta);

    if (PesoT > PesoB) then
    begin
      Result    := -2;
      wResposta := 'N';
    end
    else if (PesoL > 0) then
      Result := PesoL
    else
      Result := PesoB;
  end;
end;

end.

