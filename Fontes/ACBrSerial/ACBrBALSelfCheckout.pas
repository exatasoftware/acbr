{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Elias C�sar Vieira                              }
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

unit ACBrBALSelfCheckout;

interface

uses
  Classes, SysUtils, ACBrBALClass;
  
type

  { TACBrBALSelfCheckout }

  TACBrBALSelfCheckout = class(TACBrBALClass)
  protected
    function CorrigirRespostaPeso(const aResposta: AnsiString): AnsiString;
  public
    procedure AtivarTara;
    procedure DesativarTara;
    procedure ZerarDispositivo;
    procedure LigarDisplay;
    procedure DesligarDisplay;
  end;

implementation

{ TACBrBALSelfCheckout }

function TACBrBALSelfCheckout.CorrigirRespostaPeso(const aResposta: AnsiString): AnsiString;
begin
  Result := Trim(aResposta);

  if (Result = EmptyStr) then
    Exit;

  { Linha Self-Checkout possui retorno diferente:
    [ STX ] [ +PPP,PPP ] [ ETX ]  - Peso Est�vel;
    [ STX ] [ +III,III ] [ ETX ]  - Peso Inst�vel;
    [ STX ] [ -III,III ] [ ETX ]  - Peso Negativo;
    [ STX ] [ +SSS,SSS ] [ ETX ]  - Peso Acima (Sobrecarga) }

  Result := StringReplace(Result, '+III,III', 'IIIII', [rfReplaceAll]);
  Result := StringReplace(Result, '-III,III', 'NNNNN', [rfReplaceAll]);
  Result := StringReplace(Result, '+SSS,SSS', 'SSSSS', [rfReplaceAll]);
  Result := StringReplace(Result, '+', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
end;

procedure TACBrBALSelfCheckout.AtivarTara;
begin
  fpDevice.EnviaString('T');
  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' Ativar Tara');
end;

procedure TACBrBALSelfCheckout.DesativarTara;
begin
  fpDevice.EnviaString('T');
  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' Desativar Tara');
end;

procedure TACBrBALSelfCheckout.ZerarDispositivo;
begin
  fpDevice.EnviaString('Z');
  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' Zerar Dispositivo');
end;

procedure TACBrBALSelfCheckout.LigarDisplay;
begin
  fpDevice.EnviaString('L');
  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' LigarDisplay');
end;

procedure TACBrBALSelfCheckout.DesligarDisplay;
begin
  fpDevice.EnviaString('L');
  GravarLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' DesligarDisplay');
end;

end.

