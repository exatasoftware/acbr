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

unit ACBrMTerSB100;

interface

uses
  Classes, SysUtils,
  ACBrMTerClass, ACBrMTerStxEtx
  {$IfDef NEXTGEN}
   ,ACBrBase
  {$EndIf};

type
  { TACBrMTerSB100 }

  TACBrMTerSB100 = class(TACBrMTerStxEtx)
  public
    constructor Create(aOwner: TComponent);

    procedure ComandoBeep(Comandos: TACBrMTerComandos; const aTempo: Integer = 0);
      override;
    procedure ComandoDeslocarLinha(Comandos: TACBrMTerComandos; aValue: Integer);
      override;
    procedure ComandoEnviarParaParalela(Comandos: TACBrMTerComandos;
      const aDados: AnsiString); override;
    procedure ComandoEnviarTexto(Comandos: TACBrMTerComandos; const aTexto: AnsiString);
      override;
    procedure ComandoOnline(Comandos: TACBrMTerComandos); override;
    procedure ComandoPosicionarCursor(Comandos: TACBrMTerComandos; const aLinha,
      aColuna: Integer); override;
    procedure ComandoLimparDisplay(Comandos: TACBrMTerComandos); override;
  end;

implementation

uses
  math,
  ACBrConsts, ACBrUtil;

{ TACBrMTerSB100 }

constructor TACBrMTerSB100.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'SB100';
  fpRetornaACK := True;
end;

procedure TACBrMTerSB100.ComandoBeep(Comandos: TACBrMTerComandos;
  const aTempo: Integer);
var
  wTempo: Integer;
begin
  // Ajustando tempo m�nimo/m�ximo
  wTempo := min(max(ceil(aTempo/1000),1),9);
  Comandos.New( PrepararCmd('Z', IntToStr(wTempo)), TimeOut );
end;

procedure TACBrMTerSB100.ComandoDeslocarLinha(Comandos: TACBrMTerComandos;
  aValue: Integer);
var
  wLinha: Integer;
begin
  wLinha := min(max(aValue - 1, 0), 3);
  Comandos.New( PrepararCmd('P', IntToStr(wLinha) + '00'), TimeOut );
end;

procedure TACBrMTerSB100.ComandoEnviarParaParalela(Comandos: TACBrMTerComandos;
  const aDados: AnsiString);
begin
  DisparaErroNaoImplementado('ComandoEnviarParaParalela');
end;

procedure TACBrMTerSB100.ComandoEnviarTexto(Comandos: TACBrMTerComandos;
  const aTexto: AnsiString);
begin
  Comandos.New( PrepararCmd('Y', 'n' + aTexto), TimeOut );
end;

procedure TACBrMTerSB100.ComandoOnline(Comandos: TACBrMTerComandos);
begin
  Comandos.New( PrepararCmd('V'), TimeOut );
end;

procedure TACBrMTerSB100.ComandoPosicionarCursor(Comandos: TACBrMTerComandos;
  const aLinha, aColuna: Integer);
var
  wCol, wLinha: Integer;
begin
  wLinha := min(max(aLinha - 1, 0), 3);
  wCol := min(max(aColuna - 1, 0), 39);
  Comandos.New( PrepararCmd('P', IntToStr(wLinha) + IntToStrZero(wCol, 2)), TimeOut );
end;

procedure TACBrMTerSB100.ComandoLimparDisplay(Comandos: TACBrMTerComandos);
begin
  Comandos.New( PrepararCmd('C'), TimeOut );
end;

end.

