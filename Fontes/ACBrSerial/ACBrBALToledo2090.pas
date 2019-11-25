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
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBALToledo2090;

interface

uses
  Classes, ACBrBALClass;

type

  { TACBrBALToledo2090 }

  TACBrBALToledo2090 = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    procedure SolicitarPeso; override;

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  SysUtils, Math, ACBrConsts,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALToledo2090 }

constructor TACBrBALToledo2090.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Toledo 2090';
end;

procedure TACBrBALToledo2090.SolicitarPeso;
begin
  GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' TX -> ' + #05);
  //fpDevice.Limpar;          { Limpa a Porta }
  fpDevice.EnviaString(#05);  { Envia comando solicitando o Peso }
end;

function TACBrBALToledo2090.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
  wStrListDados: TStringList;
  wDecimais: Integer;
begin
  Result := -9;

  if (aResposta = EmptyStr) then
    Exit;

  wResposta := '';
  wDecimais := 100;

  wStrListDados := TStringList.Create;
  try
    wStrListDados.Text := StringReplace(aResposta, #$D, #13, [rfReplaceAll, rfIgnoreCase]);

    { PACOTE DE DADOS INVALIDO PARA PROCESSAR }
    if ((Copy(wStrListDados[1], 2, 1) <> #2) and (Copy(wStrListDados[1], 1, 1) <> #2)) or
       ((Length(wStrListDados[1]) <> 17) and (Length(wStrListDados[1]) <> 16)) then
      Exit;

    if (Length(wStrListDados[1]) = 16) then
      wDecimais := 1000;

    {APENAS BLOCO PROCESSADO}
//    wResposta := wStrListDados[1];
    wResposta := Copy(wStrListDados[1], 5, 7);

    if (Length(wResposta) <= 0) then
      Exit;

    { Ajustando o separador de Decimal corretamente }
    wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
    wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);
    try
      { J� existe ponto decimal ? }
      if (Pos(DecimalSeparator, wResposta) > 0)then
        Result := StrToFloat(wResposta)
      else
        Result := (StrToInt(wResposta) / wDecimais);

      case AnsiIndexText(Copy(wStrListDados[1], 3, 1), ['x','r','s']) of
        0: {Result := Result};         { Instavel }
        1: Result := Result * (-1);  { Peso Negativo }
        2: Result := -10;            { Sobrecarga de Peso }
      end;
    except
      Result := -9;
    end;
  finally
    wStrListDados.Free;
  end;
end;

end.
