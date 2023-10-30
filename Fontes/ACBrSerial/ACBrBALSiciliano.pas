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

unit ACBrBALSiciliano;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALSiciliano }

  TACBrBALSiciliano = class(TACBrBALClass)
  private
    fpProtocolo: AnsiString;

    function ProtocoloIP09Detectado(const wPosIni: Integer; const aResposta: AnsiString): Boolean;
    function ProtocoloIP10Detectado(const wPosIni: Integer; const aResposta: AnsiString): Boolean;
    function InterpretarProtocoloIP09(const aResposta: AnsiString): AnsiString;
    function InterpretarProtocoloIP10(const aResposta: AnsiString): AnsiString;
  public
    constructor Create(AOwner: TComponent);

    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override;

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  {$IFDEF COMPILER6_UP}
  DateUtils, StrUtils,
  {$ELSE}
  ACBrD5, Windows,
  {$ENDIF}
  SysUtils,
  ACBrConsts,
  ACBrUtil.Compatibilidade,
  ACBrUtil.Math,
  ACBrUtil.Strings,
  ACBrUtil.Base;

{ TACBrBALSiciliano }

function TACBrBALSiciliano.ProtocoloIP09Detectado(const  wPosIni:Integer; const aResposta: AnsiString): Boolean;
var
  l_posini, l_posfim: Integer;
begin
  // detecta o padr�o IP09 na string.
  //                    1   234  5          678901  23 4        5    6    7
  // Protocolo IP09 = [STX] SIC " " ou "-" [PPPPPP] kg B ou T [ETX] [CS] [LF]
  if  (aresposta[1] = STX) and (aresposta[15] = ETX) then
      // primeiro caracter da string � STX e o 15 � ETX
    Result := True
  else
  begin
    // pode ocorrer da string ser lida quebrada, assim procura o primeiro CR, depois do primeiro STX
    l_posini := Pos(STX, aResposta);
    l_posfim := PosEX(ETX, aResposta, l_posini + 1);
    if  l_posfim = 0 then
      l_posfim := Length(aResposta) + 1;

    Result := l_posfim - l_posini = 14;
  end;
end;

function TACBrBALSiciliano.ProtocoloIP10Detectado(const  wPosIni:Integer; const aResposta: AnsiString): Boolean;
var
  l_posini, l_posfim: Integer;
begin
  // detecta o padr�o IP09 na string.
  //                    1   23  4          567890  12 34  5          678901  23   4    5    6
  // Protocolo IP09 = [STX] BR " " ou "-" [BBBBBB] kg TR " " ou "-" [TTTTTT] kg [ETX] [CS] [LF]
  if  (aresposta[1] = STX) and (aresposta[24] = ETX) then
      // primeiro caracter da string � STX e o 24 � ETX
    Result := True
  else
  begin
    // pode ocorrer da string ser lida quebrada, assim procura o primeiro CR, depois do primeiro STX
    l_posini := Pos(STX, aResposta);
    l_posfim := PosEX(ETX, aResposta, l_posini + 1);
    if  l_posfim = 0 then
      l_posfim := Length(aResposta) + 1;

    Result := l_posfim - l_posini = 23;
  end;
end;

//aqui

function TACBrBALSiciliano.InterpretarProtocoloIP09(const aResposta: AnsiString): AnsiString;
var
  l_strpso: string;
  l_posini, l_posfim: Integer;
begin
  fpProtocolo := 'Protocolo IP09';
  // localiza o primeiro STX, e depois procura pelo CR para obter a string do peso
  l_posini := Pos(STX, aResposta);
  l_posfim := PosEX(ETX, aResposta, l_posini + 1);
  if  l_posfim = 0 then
      l_posfim := Length(aResposta);
  // Separa a primeira string contendo o peso
  l_strpso := Copy(aResposta, l_posini, l_posfim - l_posini + 1);


  // obtem o peso da string lida
  if Copy(l_strpso, 5, 1) = '-' then
    Result := 'N'
  else
    Result := Copy(l_strpso, 6, 6);
end;

function TACBrBALSiciliano.InterpretarProtocoloIP10(const aResposta: AnsiString): AnsiString;
var
  l_strpso: string;
  PesoL, PesoB, PesoT: Double;
  l_posini, l_posfim: Integer;
begin
  fpProtocolo := 'Protocolo IP10';
  // localiza o primeiro STX, e depois procura pelo CR para obter a string do peso
  l_posini := Pos(STX, aResposta);
  l_posfim := PosEX(ETX, aResposta, l_posini + 1);
  if  l_posfim = 0 then
      l_posfim := Length(aResposta);
  // Separa a primeira string contendo o peso
  l_strpso := Copy(aResposta, l_posini, l_posfim - l_posini + 1);


  if (Length(l_strpso) > 1) then
  begin

    PesoT := StrToFloat(Copy(l_strpso, 16, 6));
    PesoB := StrToFloat(Copy(l_strpso, 5, 6));
    PesoL := PesoB-PesoT;

    if (PesoT > PesoB) then
    begin
      Result    := 'N';
    end
    else if Copy(l_strpso, 4, 1) = '-' then
      Result := 'N'
    else if (PesoL > 0) then
      Result := FloatToStr(PesoL)
    else
      Result := FloatToStr(PesoB);
  end;
end;

constructor TACBrBALSiciliano.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Siciliano';
  fpProtocolo := 'N�o Definido';
end;

procedure TACBrBALSiciliano.LeSerial(MillisecTimeOut: Integer);
begin
  // Reescreve LeSerial para incluir Protocolo no Log
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  try
    fpUltimaResposta := fpDevice.LeString(MillisecTimeOut);
    GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' RX <- ' + fpUltimaResposta);

    fpUltimoPesoLido := InterpretarRepostaPeso(fpUltimaResposta);
  except
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;

  GravarLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido) +
           ' - Resposta: ' + fpUltimaResposta + ' - Protocolo: ' + fpProtocolo);
end;

function TACBrBALSiciliano.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wPosIni: Integer;
  wResposta: AnsiString;
begin
  Result  := 0;
  wPosIni := PosLast(STX, aResposta);

  if ProtocoloIP09Detectado(wPosIni, aResposta) then
    wResposta := InterpretarProtocoloIP09(aResposta)
  else
    wResposta := InterpretarProtocoloIP10(aResposta);

  if  (aResposta = EmptyStr) then Exit;

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
      Result := StrToFloat(wResposta)
  except
    case PadLeft(Trim(wResposta),1)[1] of
      'I': Result := -1;   { Instavel }
      'N': Result := -2;   { Peso Negativo }
      'S': Result := -10;  { Sobrecarga de Peso }
    else
      Result := 0;
    end;
  end;
end;

end.
