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

unit ACBrMTerVT100;

interface

uses
  Classes, SysUtils,
  ACBrMTerClass
  {$IfDef NEXTGEN}
   ,ACBrBase
  {$EndIf};

type

  { TACBrMTerVT100 }

  TACBrMTerVT100 = class(TACBrMTerClass)
  private
    { Private declarations }
  public
    constructor Create(aOwner: TComponent);

    procedure ComandoBackSpace(Comandos: TACBrMTerComandos); override;
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
    procedure ComandoLimparLinha(Comandos: TACBrMTerComandos; const aLinha: Integer);
      override;
    procedure ComandoPosicionarCursor(Comandos: TACBrMTerComandos; const aLinha,
      aColuna: Integer); override;
    procedure ComandoLimparDisplay(Comandos: TACBrMTerComandos); override;
  end;

implementation

uses
  ACBrUtil, ACBrConsts;

{ TACBrMTerVT100 }

constructor TACBrMTerVT100.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'VT100';
end;

procedure TACBrMTerVT100.ComandoBackSpace(Comandos: TACBrMTerComandos);
begin
  Comandos.New( BS );
end;

procedure TACBrMTerVT100.ComandoBeep(Comandos: TACBrMTerComandos;
  const aTempo: Integer);
begin
  Comandos.New( ESC + '[TB' );
end;

procedure TACBrMTerVT100.ComandoDeslocarCursor(Comandos: TACBrMTerComandos;
  const aValue: Integer);
var
  wValor: Integer;
begin
  wValor := aValue;
  while (wValor > 0) do
  begin
    Comandos.New( ESC + '[C' );
    Dec( wValor );
  end;
end;

procedure TACBrMTerVT100.ComandoDeslocarLinha(Comandos: TACBrMTerComandos;
  aValue: Integer);
var
  wCmd: String;
  I: Integer;
begin
  if (aValue > 0) then
    wCmd := LF           // Comando coloca cursor na linha de baixo
  else if (aValue < 0) then
    wCmd := ESC + '[A'   // Comando coloca cursor na linha de cima
  else
    Exit;

  for I := 1 to abs(aValue) do
    Comandos.New( wCmd );
end;

procedure TACBrMTerVT100.ComandoEnviarParaParalela(Comandos: TACBrMTerComandos;
  const aDados: AnsiString);
begin
  Comandos.New( ESC + '[?24l' );  // Seleciona porta paralela
  Comandos.New( ESC + '[5i' );  // Habilita servi�o de impress�o
  Comandos.New( aDados );       // Envia Dados
  Comandos.New( ESC + '[4i' );  // Desabilita servi�o de impress�o
end;

procedure TACBrMTerVT100.ComandoEnviarParaSerial(Comandos: TACBrMTerComandos;
  const aDados: AnsiString; aSerial: Byte);
begin
  if (aSerial = 2) then
    Comandos.New( ESC + '[?24r' )   // Seleciona porta serial 2
  else
    Comandos.New( ESC + '[?24h' );  // Seleciona porta serial padr�o(0)

  Comandos.New( ESC + '[5i' +   // Habilita servi�o de impress�o
                aDados      +   // Envia Dados
                ESC + '[4i' );  // Desabilita servi�o de impress�o
end;

procedure TACBrMTerVT100.ComandoEnviarTexto(Comandos: TACBrMTerComandos;
  const aTexto: AnsiString);
begin
  Comandos.New(aTexto);
end;

procedure TACBrMTerVT100.ComandoLimparLinha(Comandos: TACBrMTerComandos;
  const aLinha: Integer);
begin
  ComandoPosicionarCursor(Comandos, aLinha, 1);
  Comandos.New(ESC + '[K');
end;

procedure TACBrMTerVT100.ComandoPosicionarCursor(Comandos: TACBrMTerComandos;
  const aLinha, aColuna: Integer);
var
  wL, wC: AnsiString;
begin
  wL := IntToStrZero(aLinha, 2);
  wC := IntToStrZero(aColuna, 2);

  Comandos.New( ESC + '[' + wL + ';' + wC + 'H' );
end;

procedure TACBrMTerVT100.ComandoLimparDisplay(Comandos: TACBrMTerComandos);
begin
  Comandos.New( ESC + '[H' + ESC + '[J' );
end;

end.

