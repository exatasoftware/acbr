{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Fabio Junior Borba                              }
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

unit ACBrBALLenkeLK2500;

interface
uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type
  TACBrBALLenkeLK2500 = class( TACBrBALClass )
  public
    constructor Create(AOwner: TComponent);
    procedure SolicitarPeso; override;

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;

  end ;

implementation
Uses ACBrConsts, SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, synaser, Windows{$ENDIF},
     Math, StrUtils;

{ TACBrBALLenkeLK2500 }

constructor TACBrBALLenkeLK2500.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Lenke LK2500' ;
end;

function TACBrBALLenkeLK2500.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
  Resposta : AnsiString ;
  Decimais : Integer ;
  wPosIni, wPosFim: Integer;
begin
  Decimais := 1000 ;

  wPosIni := Pos(STX, aResposta);
  wPosFim := PosEx(CR, aResposta, wPosIni + 1);

  if (wPosFim <= 0) then
    wPosFim := Length(aResposta) + 1;

  wResposta := Copy(aResposta, wPosIni, wPosFim - wPosIni);

  if Pos('MN', wResposta) > 0 then
    Resposta := '-' + Trim(Copy(wResposta, wPosIni, 8))
  else
    Resposta := Trim(Copy(wResposta, wPosIni, 8));

  if Length(Resposta) > 0 then
  begin

    try
      if pos(DecimalSeparator, Resposta) > 0 then
        Result := StrToFloat(Resposta)
      else
        Result := StrToInt(Resposta) / Decimais ;

      case AnsiIndexText(Copy(wResposta, 9, 2), ['MP', 'MN']) of
        0 : Result := -1  ;  { Instavel }
        1 : Result := -2;  { Peso Negativo }
      end;
      if Pos('MN', wResposta) > 0 then
        wResposta := '-' + wResposta;
    except
      Result := 0 ;
    end;
  end
  else
    Result := 0;
end;

procedure TACBrBALLenkeLK2500.SolicitarPeso;
begin
    { Protocolo Lenke
      A balan�a Lenke LK2500 manda leituras continuamente para a COM,
      n�o necessita de um comando para ler o peso.
      Configura��o Padrao de Leitura:
      Baud Rate = 9600, Data Bits = 8, Parity = None, Stop Bits = 1,
      Handshaking = XON/XOFF
      ----------------------}
//  inherited;

  //O "Exit" abaixo � apenas para remover o warning no FixInsight.
  Exit;
end;

end.
