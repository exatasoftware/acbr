{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Marciano da Rocha                               }
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
unit ACBrBALLibratek;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  TACBrBALLibratek = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);
    function LePeso(MillisecTimeOut: Integer = 3000): Double; override;
    procedure LeSerial(MillisecTimeOut: Integer = 500); override;
  end;

implementation

Uses
  SysUtils, Math,
  ACBrConsts,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALLibratek }

constructor TACBrBALLibratek.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Libratek';
  fpPosIni := 7;
  fpPosFim := 9;
end;

function TACBrBALLibratek.LePeso(MillisecTimeOut: Integer): Double;
Var
  TempoFinal: TDateTime;
begin
  Result := 0;
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';
  TempoFinal := IncMilliSecond(now, MillisecTimeOut);

  while (Result <= 0) and (TempoFinal > now) do
  begin
    MillisecTimeOut := MilliSecondsBetween(now, TempoFinal);

    LeSerial(MillisecTimeOut);

    Result := fpUltimoPesoLido;
  end;
end;

procedure TACBrBALLibratek.LeSerial(MillisecTimeOut: Integer);
Var
  Resposta: AnsiString;
begin
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  Try
    fpUltimaResposta := fpDevice.LeString(MillisecTimeOut);
    GravaLog('- ' + FormatDateTime('hh:nn:ss:zzz', now) + ' RX <- ' + fpUltimaResposta);

    Resposta := Trim(Copy(fpUltimaResposta, fpPosIni, fpPosFim));

    { Ajustando o separador de Decimal corretamente }
    Resposta := StringReplace(Resposta, '.', DecimalSeparator, [rfReplaceAll]);
    Resposta := StringReplace(Resposta, ',', DecimalSeparator, [rfReplaceAll]);

    case AnsiIndexStr(Copy(fpUltimaResposta, 1, 2), ['ST', 'OL', 'US']) of
      0:
        fpUltimoPesoLido := StrToFloat(Resposta); // Est�vel
      1:
        if fpUltimaResposta[7] = '-' then
          fpUltimoPesoLido := -2 // Peso negativo
        else
          fpUltimoPesoLido := -10; // Sobrecarga de peso
      2:
        fpUltimoPesoLido := -1; // Inst�vel
    end;
  except
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;

  GravaLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido) + ' , Resposta: ' + Resposta);
end;

end.
