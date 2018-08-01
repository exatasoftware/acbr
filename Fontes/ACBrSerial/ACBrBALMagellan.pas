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

unit ACBrBALMagellan;

interface

uses
  ACBrBALClass, Classes;

type

  { TACBrBALMagellan }

  TACBrBALMagellan = class(TACBrBALClass)
  private
    fpDecimais: Integer;
    function InterpretarProtocoloA(aResposta: AnsiString): AnsiString;
    function InterpretarProtocoloB(aResposta: AnsiString): AnsiString;
    function InterpretarProtocoloC(aResposta: AnsiString): AnsiString;
  public
    constructor Create(AOwner: TComponent);

    procedure SolicitarPeso; override;

    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
  end;

implementation

uses
  ACBrUtil, ACBrConsts, SysUtils,
  {$IFDEF COMPILER6_UP} DateUtils, StrUtils {$ELSE} ACBrD5, synaser, Windows{$ENDIF};

{ TACBrBALGertecSerial }

function TACBrBALMagellan.InterpretarProtocoloA(aResposta: AnsiString): AnsiString;
var
  wStatus2: AnsiChar;
begin
  { Protocolo A
  [ STX ] [ S1 ] [ PPPPPP ] [ S2 ] [ TTTTTT ] [ UUUUUU ] [ CR ] [ CS ]
  S1 = 1 byte - Status 1
  PPPPPP = 6 bytes - peso
  S2 = 1 byte - Status 2
  TTTTTT = 6 bytes - Pre�o Total
  UUUUUU = 6 bytes - Pre�o/kg
  CS = 1 byte - Checksum. O c�lculo do checksum � feito pelo complemento
     de 2 da soma de todos os bytes transmitidos de STX, incluindo o CR.

  S1 - STATUS 1
  bit 0 = motion flag
  bit 1 = print flag
  bit 2 = data do sistema ( 0 = pesagem e 1 = data )
  bit 3 = out of range
  bit 4 = tipo de balan�a ( 0 = Prix II/ Prix III e 1 = Prix I )
  bit 5 = n�mero de casas decimais ( 0 = 2 casas e 1 = 0 casas )
  bit 6 = autoriza��o de totaliza��o ( 0 = n�o e 1 = sim totaliza )

  S2 - STATUS 2
  bit 0 = s�timo d�gito no pre�o total ( 0 = sem 1 = com )
  bit 1 = reservado
  bit 2 = reservado
  bit 3 = casas decimais no peso ( 0 = 3 casas e 1 = 2 casas )
  bit 4 = reservado
  bit 5 = reservado
  bit 6 = opera��o com tara ( 0 = sem tara e 1 = com tara ) deve
          imprimir peso l�quido         }

  wStatus2 := aResposta[9];

  if TestBit(Ord(wStatus2), 3) then  { Bit 3 de wStatus2 ligado = 2 casas decimais }
    fpDecimais := 100;

  Result := Trim(Copy(aResposta, 3, 6));
end;

function TACBrBALMagellan.InterpretarProtocoloB(aResposta: AnsiString): AnsiString;
var
  wPosIni, wPosFim: Integer;
begin
  { Protocolo B = [ ENQ ] [ STX ] [ PESO ] [ ETX ]
  Linha Automacao = [ STX ] [ PPPPP ] [ ETX ]  - Peso Est�vel;
                    [ STX ] [ IIIII ] [ ETX ]  - Peso Inst�vel;
                    [ STX ] [ NNNNN ] [ ETX ]  - Peso Negativo;
                    [ STX ] [ SSSSS ] [ ETX ]  - Peso Acima (Sobrecarga)}
  wPosIni := Pos(STX, aResposta);
  wPosFim := Pos(ETX, aResposta);

  if (wPosFim = 0) then  // N�o achou? ...Usa a String inteira
    wPosFim := Length(aResposta) + 1;

  Result := Trim(Copy(aResposta, wPosIni + 1, wPosFim - wPosIni - 1));
end;

function TACBrBALMagellan.InterpretarProtocoloC(aResposta: AnsiString): AnsiString;
var
  wPosIni, wPosFim: Integer;
begin
  { Protocolo C = [ STX ] [ PESO ] [ CR ]
  Linha Automacao = [ STX ] [ PPPPP ] [ ETX ]  - Peso Est�vel;
                    [ STX ] [ IIIII ] [ ETX ]  - Peso Inst�vel;
                    [ STX ] [ NNNNN ] [ ETX ]  - Peso Negativo;
                    [ STX ] [ SSSSS ] [ ETX ]  - Peso Acima (Sobrecarga) }
  wPosIni := Pos(STX, aResposta);
  wPosFim := Pos(CR , aResposta);

  if (wPosFim = 0) then  // Usa a String inteira
    wPosFim := Length(aResposta) + 1;

  Result := Trim(Copy(aResposta, wPosIni + 1, wPosFim - wPosIni - 1));
end;

constructor TACBrBALMagellan.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpDecimais  := 1000;
  fpModeloStr := 'Magellan';
end;

procedure TACBrBALMagellan.SolicitarPeso;
begin
  GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' TX -> ' + #87);
  fpDevice.Limpar;
  fpDevice.EnviaString(#87);
end;

function TACBrBALMagellan.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
begin
  Result := 0;

  if (Length(aResposta) > 20) then
    wResposta := InterpretarProtocoloA(aResposta)
  else if (Pos(ETX, aResposta) > 0) then
    wResposta := InterpretarProtocoloB(aResposta)
  else
    wResposta := InterpretarProtocoloC(aResposta);

  if (wResposta = EmptyStr) then
    Exit;

  { Ajustando o separador de Decimal corretamente }
  aResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);

  try
    if (Pos(DecimalSeparator, aResposta) > 0) then  { J� existe ponto decimal ? }
      Result := StrToFloat(aResposta)
    else
      Result := (StrToInt(aResposta) / fpDecimais);
  except
    case aResposta[1] of
      'I' : Result := -1;  { Instavel }
      'N' : Result := -2;  { Peso Negativo }
      'S' : Result := -10;  { Sobrecarga de Peso }
    else
      Result := 0;
    end;
  end;
end;

end.
