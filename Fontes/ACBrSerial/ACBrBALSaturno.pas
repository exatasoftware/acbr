{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
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
|* 29/03/2016: Wislei de Brito Fernandes
|*  - Primeira Versao ACBrBALSaturno
|*
|* 10/10/2016: Elias C�sar Vieira
|*  - Refatora��o de ACBrBALSaturno
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALSaturno;

interface

uses
  ACBrBALClass, Classes;

type

  { TACBrBALSaturno }

  TACBrBALSaturno = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils,
  {$IFDEF COMPILER6_UP} DateUtils {$ELSE} synaser, Windows{$ENDIF};

{ TACBrBALSaturno }

constructor TACBrBALSaturno.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Saturno';
end;

function TACBrBALSaturno.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wAchouE, wAchouO: Boolean;
  wPosEO: Integer;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  wAchouE := (Pos('E', UpperCase(aResposta)) > 0);
  wAchouO := (Pos('O', UpperCase(aResposta)) > 0);

  // Se encontrar a letra 'E' (Est�vel) ou 'O' (Oscilante), captura o peso da
  // posi��o 1 a 7 da string
  if wAchouE or wAchouO then
  begin
    if wAchouE then
      wPosEO := Pos('E', UpperCase(aResposta))
    else
      wPosEO := Pos('O', UpperCase(aResposta));

    aResposta := Copy(aResposta, 0, wPosEO - 1);

    { Removendo caracteres especiais, caso encontre algum }
    aResposta := StringReplace(aResposta, '�', '0', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '1', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '2', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '3', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '4', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '5', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '6', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '7', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '8', [rfReplaceAll]);
    aResposta := StringReplace(aResposta, '�', '9', [rfReplaceAll]);
  end;

  if (Length(aResposta) > 0) then
  begin
    try
      Result := StrToFloat(aResposta);
    except
      case aResposta[1] of
        'I': Result := -1;   { Instavel }
        'N': Result := -2;   { Peso Negativo }
        'S': Result := -10;  { Sobrecarga de Peso }
      else
        Result := 0;
      end;
    end;
  end
  else
    Result := 0;
end;

end.

