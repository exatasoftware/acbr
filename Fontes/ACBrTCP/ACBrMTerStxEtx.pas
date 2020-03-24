{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Elias C�sar Vieira                             }
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

unit ACBrMTerStxEtx;

interface

uses
  Classes, SysUtils,
  ACBrMTerClass
  {$IfDef NEXTGEN}
   ,ACBrBase
  {$EndIf};

type

  { TACBrMTerStxEtx }

  TACBrMTerStxEtx = class(TACBrMTerClass)
  protected
    fpRetornaACK: Boolean;

    function PrepararCmd(aCmd: Char; const aParams: AnsiString = ''): AnsiString;
    function TimeOutDef: Integer;
  public
    constructor Create(aOwner: TComponent);

    procedure ComandoBeep(Comandos: TACBrMTerComandos; const aTempo: Integer = 0);
      override;
    procedure ComandoDeslocarCursor(Comandos: TACBrMTerComandos; const aValue: Integer);
      override;
    procedure ComandoDeslocarLinha(Comandos: TACBrMTerComandos; aValue: Integer);
      override;
    procedure ComandoEnviarParaParalela(Comandos: TACBrMTerComandos;
      const aDados: AnsiString); override;
    procedure ComandoEnviarParaSerial(Comandos: TACBrMTerComandos;
      const aDados: AnsiString; aSerial: Byte = 0); override;
    procedure ComandoEnviarTexto(Comandos: TACBrMTerComandos; const aTexto: AnsiString);
      override;
    procedure ComandoOnline(Comandos: TACBrMTerComandos); override;
    procedure ComandoPosicionarCursor(Comandos: TACBrMTerComandos; const aLinha,
      aColuna: Integer); override;
    procedure ComandoLimparDisplay(Comandos: TACBrMTerComandos); override;
  end;

implementation

uses
   ACBrConsts, ACBrUtil;

{ TACBrMTerStxEtx }

function TACBrMTerStxEtx.PrepararCmd(aCmd: Char; const aParams: AnsiString): AnsiString;
begin
  Result := STX + aCmd + aParams + ETX;
end;

function TACBrMTerStxEtx.TimeOutDef: Integer;
begin
  if fpRetornaACK then
    Result := TimeOut
  else
    Result := 0;
end;

constructor TACBrMTerStxEtx.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'STX-ETX';
  fpRetornaACK := False;
end;

procedure TACBrMTerStxEtx.ComandoBeep(Comandos: TACBrMTerComandos;
  const aTempo: Integer);
begin
  //TODO::
  //Result := STX + #90 + '9' + ETX;
  //Result := STX + 'D' + BELL + ETX;
end;

procedure TACBrMTerStxEtx.ComandoDeslocarCursor(Comandos: TACBrMTerComandos;
  const aValue: Integer);
var
  wValor: Integer;
begin
  wValor := aValue;
  while (wValor > 0) do
  begin
    Comandos.New( PrepararCmd('O', DC4), TimeOutDef );
    Dec( wValor );
  end;
end;

procedure TACBrMTerStxEtx.ComandoDeslocarLinha(Comandos: TACBrMTerComandos;
  aValue: Integer);
begin
  Comandos.New( PrepararCmd('C', '100'), TimeOutDef );       // TODO::
end;

procedure TACBrMTerStxEtx.ComandoEnviarParaParalela(
  Comandos: TACBrMTerComandos; const aDados: AnsiString);
begin
  Comandos.New( PrepararCmd('P', aDados), TimeOutDef );
end;

procedure TACBrMTerStxEtx.ComandoEnviarParaSerial(Comandos: TACBrMTerComandos;
  const aDados: AnsiString; aSerial: Byte);
var
  wPorta: Char;
begin
  if (aSerial = 2) then
    wPorta := 'R'        // Seleciona porta serial 2
  else
    wPorta := 'S';       // Seleciona porta serial padr�o(0)

  Comandos.New( PrepararCmd(wPorta, aDados), TimeOutDef );
end;

procedure TACBrMTerStxEtx.ComandoEnviarTexto(Comandos: TACBrMTerComandos;
  const aTexto: AnsiString);
begin
  Comandos.New( PrepararCmd('D', aTexto), TimeOutDef );
end;

procedure TACBrMTerStxEtx.ComandoOnline(Comandos: TACBrMTerComandos);
begin
  Comandos.New( PrepararCmd('T'), TimeOut );
end;

procedure TACBrMTerStxEtx.ComandoPosicionarCursor(Comandos: TACBrMTerComandos;
  const aLinha, aColuna: Integer);
begin
  Comandos.New( PrepararCmd('C', IntToStr(aLinha-1) + IntToStrZero(aColuna-1, 2)), TimeOutDef );
end;

procedure TACBrMTerStxEtx.ComandoLimparDisplay(Comandos: TACBrMTerComandos);
begin
  Comandos.New( PrepararCmd('L'), TimeOutDef );
end;

end.

