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

unit ACBrBALPrecision;

interface
uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type
  TACBrBALPrecision = class( TACBrBALClass )
  public
    constructor Create(AOwner: TComponent);
    procedure SolicitarPeso; override;

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;

  end ;

implementation
Uses ACBrConsts, SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, synaser, Windows{$ENDIF},
     Math, StrUtils;

{ TACBrBALPrecision }

constructor TACBrBALPrecision.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Precision' ;
end;

function TACBrBALPrecision.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
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
    wPosFim := Length(aResposta) + 1;  // N�o achou? ...Usa a String inteira

  // Contem a String inteira
  wResposta := Copy(aResposta, wPosIni, wPosFim - wPosIni);

  // Contem somente o Peso
  if (wResposta[1] in ['H', 'T', 'M', 'L', 'I']) then
    Resposta := '-' + Trim(Copy(wResposta, wPosIni + 2, 6))
  else
    Resposta := Trim(Copy(wResposta, wPosIni + 2, 6));

  if Length(Resposta) > 0 then
  begin
    { Ajustando o separador de Decimal corretamente }
    {Resposta := StringReplace(Resposta, '.', DecimalSeparator, [rfReplaceAll]);
    Resposta := StringReplace(Resposta, ',', DecimalSeparator, [rfReplaceAll]);}

    try
      if pos(DecimalSeparator, Resposta) > 0 then  { J� existe ponto decimal ? }
        Result := StrToFloat(Resposta)
      else
        Result := StrToInt(Resposta) / Decimais ;

      case AnsiIndexText(Copy(wResposta, 1, 1), ['G','F','A','@','H', 'T','M','L','I']) of
        0 : Result := 0 ;  { Aguardando Peso }
        1 : Result := 0 ;  { Aguardando Peso }
        2 : Result := -1  ;  { Instavel }
        3 : Result := -1  ;  { Instavel }
        { Peso Negativo }
        4 : Result := -2;
        5 : Result := -2;
        6 : Result := -2;
        7 : Result := -2;
        8 : Result := -2;
      end;
      if (wResposta[1] in ['H', 'T', 'M', 'L', 'I']) then
        wResposta := '-' + wResposta;
    except
      Result := 0 ;
    end;
  end
  else
    Result := 0;
end;

procedure TACBrBALPrecision.SolicitarPeso;
begin
    { Protocolo Precision
      A balan�a Precision manda leituras continuamente para a COM,
      n�o necessita de um comando para ler o peso.
      Configura��o Padrao de Leitura:
      Baud Rate = 1200, Data Bits = 8, Parity = None, Stop Bits = 1,
      Handshaking = None
      ----------------------}
//  inherited;

  //O "Exit" abaixo � apenas para remover o warning no FixInsight.
  Exit;
end;

end.
