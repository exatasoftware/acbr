{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Fabio Farias                                    }
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

unit ACBrSINLaurenti;

interface

uses
  Classes,
  ACBrSINClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type

  { TACBrBALFilizola }

  TACBrSINLaurenti = class(TACBrSINClass)
  public
    constructor Create(AOwner: TComponent);

    procedure defineLed(const ALed: TACBrCorLed); override ;
  end;

implementation

uses
  SysUtils, strutils,
  ACBrConsts, ACBrUtil.Strings,
  {$IFDEF COMPILER6_UP}
    DateUtils
  {$ELSE}
    ACBrD5, Windows
  {$ENDIF};

{ TACBrBALGertecSerial }

constructor TACBrSINLaurenti.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Laurenti';
end;

procedure TACBrSINLaurenti.defineLed(const ALed: TACBrCorLed);
var
  cmd : string;
begin
//  TACBrCorLed = (corNenhuma, corVerde, corAmarelo, corVermelho);
  if ALed = corNenhuma then
    cmd := '0'
  else if ALed = corVerde then
    cmd := '1'
  else if ALed = corAmarelo then
    cmd := '2'
  else if ALed = corVermelho then
    cmd := '3';

  enviarSerial(cmd);
end;

end.
