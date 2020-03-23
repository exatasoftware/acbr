{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Wislei de Brito Fernandes                     }
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

unit ACBrBALSaturno;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALSaturno }

  TACBrBALSaturno = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils, ACBrUtil,
  {$IFDEF COMPILER6_UP}
   DateUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALSaturno }

constructor TACBrBALSaturno.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Saturno';
end;

function TACBrBALSaturno.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wAchouE, wAchouO: Boolean;
  wPosEO: Integer;
  wResposta: AnsiString;
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

    wResposta := Copy(aResposta, 0, wPosEO - 1);

    { Removendo caracteres especiais, caso encontre algum }
    wResposta := StringReplace(wResposta, '�', '0', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '1', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '2', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '3', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '4', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '5', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '6', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '7', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '8', [rfReplaceAll]);
    wResposta := StringReplace(wResposta, '�', '9', [rfReplaceAll]);
  end;

  if (Length(wResposta) > 0) then
  begin
    try
      Result := StrToFloat(wResposta);
    except
      case PadLeft(Trim(wResposta),1)[1] of
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

