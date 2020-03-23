{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: La�rcio S Amici                                 }                      
{                              Emerson Virissimo da Silva                      }
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
|* Observacoes
|*
|* 27/05/2014: La�rcio S Amici | Emerson Virissimo da Silva
|*  - Primeira Versao ACBrBALLider
|*
|*      Protocolo Lider   -   Baseado no modelo LD2052
|*      SOH 00000. #32 <E|I> STX
|*
|*      E=Est�vel  I=Inst�vel
|*
|*      A balan�a Lider manda leituras continuamente para a COM, n�o necessita
|*      de um comando para ler o peso.
|*      A id�ia � buscar o �ltimo peso est�vel lido, ent�o a busca deve iniciar
|*      no final do Buffer. Uma outra implementa��o poss�vel seria tentar as 3
|*      �ltimas leituras est�veis pra ver se coincidem, mas no momento n�o vejo
|*      necessidade.
|*
|*      Configura��o de leitura:
|*      Baud Rate = 2400, Data Bits = 8, Parity = None, Stop Bits = 1,
|*                        Handshaking = None
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALLider;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALLider }

  TACBrBALLider = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function LePeso(MillisecTimeOut: Integer = 3000): Double; override;

    procedure LeSerial(MillisecTimeOut: integer = 500); override;
    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;


implementation

// TESTE DE LEITURA UTILIZANDO LOG GERADO NA BALAN�A
// {$DEFINE DEBUG}

uses
  math, SysUtils,
  ACBrConsts,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};


{ Retorna a posi��o da Substr em Str a partir do final }
function RightPos( const ASubstr, AStr: string ): integer;
var
  iLen, iLenSub: integer;
begin
  Result := 0;

  iLen := Length(AStr);
  iLenSub := Length(ASubstr);

  if iLenSub <= iLen then
  begin
    Result := iLen - (iLenSub-1);


    while (Result > 0) and
          (not SameText( ASubstr, Copy(AStr, Result, iLenSub) )) do
      Dec(Result);

  end;
end;


{ TACBrBALLider }

constructor TACBrBALLider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Lider';
end;


function TACBrBALLider.LePeso(MillisecTimeOut: Integer): Double;
begin
  { Balan�a Lider n�o � necess�rio enviar comando de leitura... Portanto... }
  { Utilizar� a fun��o AguardarRespostaPeso com ReenviarSolicita��o = False }
  Result := AguardarRespostaPeso(MillisecTimeOut);
end;

procedure TACBrBALLider.LeSerial(MillisecTimeOut: Integer);
{$IFDEF DEBUG}
var
  StrDebug: TStringList;
{$ENDIF}

begin
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  try
    { Protocolo Lider   -   Baseado no modelo LD2052
      SOH 00000. #32 <E|I> STX

      A balan�a Lider manda leituras continuamente para a COM, n�o necessita de
      um comando para ler o peso. E=Est�vel I=Inst�vel
      A id�ia � buscar o �ltimo peso est�vel lido, ent�o a busca deve iniciar
      no final do Buffer. Uma outra implementa��o poss�vel seria tentar as 3
      �ltimas leituras est�veis pra ver se coincidem, mas no momento n�o vejo
      necessidade.

      Configura��o de leitura:
      Baud Rate = 2400, Data Bits = 8, Parity = None, Stop Bits = 1, Handshaking = None
      ----------------------}
    {$IFDEF DEBUG}
    StrDebug := TStringList.Create;
    StrDebug.LoadFromFile('LiderDebug.txt');
    fpUltimaResposta := StrDebug.Text;
    StrDebug.Free;
    {$ELSE}
    fpUltimaResposta := fpDevice.LeString(MillisecTimeOut);
    GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' RX <- ' + fpUltimaResposta);
    {$ENDIF}

    fpUltimoPesoLido := InterpretarRepostaPeso(fpUltimaResposta);
  except
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;

  GravaLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido) +
           ' , Resposta: ' + fpUltimaResposta);
end;

function TACBrBALLider.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
  StatusPeso: AnsiChar;
  wPos: Integer;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  wResposta := aResposta;

  { Buscar �ltimo peso est�vel no buffer }
  wPos := RightPos('E' + STX, wResposta);

  { Se n�o achou leitura est�ve. buscar �ltimo peso inst�vel no buffer }
  if (wPos = 0) then
    wPos := RightPos('I' + STX, wResposta);

  { Se achou, isolar a leitura }
  if (wPos > 0) then
  begin
    wResposta := Copy(wResposta, 1, wPos + 1);

    wPos := RightPos(SOH, wResposta);

    if (wPos > 0) then
      wResposta := Copy(wResposta, wPos, Length(wResposta));
  end;

  { Retira SOH, STX }
  if (Copy(wResposta, 1, 1) = SOH) then
    wResposta := Copy(wResposta, 2, Length(wResposta));

  if (Copy(wResposta, Length(wResposta), 1) = STX) then
    wResposta := Copy(wResposta, 1, Length(wResposta) - 1);

  { Substituir o espa�o que vem ap�s o ponto }
  wResposta := StringReplace(wResposta, ' ', '0', [rfReplaceAll]);

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    StatusPeso := ' ';
    if (Length(wResposta) >= 1) then
    begin
      StatusPeso := Copy(wResposta, Length(wResposta), 1)[1];

      if (StatusPeso in ['E', 'I']) then
        wResposta := Copy(wResposta, 1, Length(wResposta) - 1);
    end;

    case StatusPeso of
      'I': Result := -1;                     { Instavel }
      'E': Result := StrToFloat(wResposta);  { Est�vel }
    else
      Result := 0;
    end;
  except
    Result := 0;
  end;
end;

end.
