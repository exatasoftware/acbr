{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2016 Daniel Simoes de Almeida               }
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
|* 31/03/2016: Paulo Henrique de Castro
|*  - Primeira Versao ACBrBALSaturno
|*
|* 10/10/2016: Elias C�sar Vieira
|*  - Refatora��o de ACBrBALAFTS
******************************************************************************}
{$I ACBr.inc}

unit ACBrBALAFTS;

interface

uses
  ACBrBALClass, ACBrConsts, Classes;

type
          
  { TACBrBALAFTS }

  TACBrBALAFTS = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
  end;

implementation

Uses
  SysUtils, Math,
  {$IFDEF COMPILER6_UP}
  DateUtils, StrUtils
  {$ELSE}
  ACBrD5, Windows
  {$ENDIF};

{ TACBrBALAFTS }

constructor TACBrBALAFTS.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'AFTS';
end;

function TACBrBALAFTS.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wPesoAFTS, wResposta, wResultado: AnsiString;
  I: Integer;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  wResultado  := EmptyStr;
  wResposta   := Copy(aResposta, 1, 10);
  wResposta   := Trim(Copy(wResposta, 2, 7));

  wPesoAFTS := wResposta;
  for I := Length(wPesoAFTS) downto 1 do
    wResultado := wResultado + wPesoAFTS[I];

  wResposta := wResultado;

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    Result := StrToFloat(wResposta);

  except
    case wResposta[1] of
      'I' : Result := -1;   { Instavel }
      'N' : Result := -2;   { Peso Negativo }
      'S' : Result := -10;  { Sobrecarga de Peso }
    else
      Result := 0;
    end;
  end;
end;

end.
