{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2016 Elias C�sar Vieira                     }
{                                                                              }
{ Colaboradores nesse arquivo: Daniel Sim�es de Almeida                        }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
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
|* 17/05/2016: Elias C�sar Vieira
|*  - Primeira Versao ACBrMTerSB100
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerSB100;

interface

uses
  Classes, SysUtils,
  ACBrMTerClass;

type
  { TACBrMTerSB100 }

  TACBrMTerSB100 = class(TACBrMTerClass)
  private
    function PrepararCmd(const aCmd: Char; const aParams: AnsiString = ''): AnsiString;
  public
    constructor Create(aOwner: TComponent);

    function ComandoBackSpace: AnsiString; override;
    function ComandoBeep(aTempo: Integer = 0): AnsiString; override;
    function ComandoBoasVindas: AnsiString; override;
    function ComandoDeslocarCursor(aValue: Integer): AnsiString; override;
    function ComandoDeslocarLinha(aValue: Integer): AnsiString; override;
    function ComandoEnviarParaParalela(const aDados: AnsiString): AnsiString; override;
    function ComandoEnviarParaSerial(const aDados: AnsiString; aSerial: Byte = 0): AnsiString; override;
    function ComandoEnviarTexto(const aTexto: AnsiString): AnsiString; override;
    function ComandoOnline: AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;
    function ComandoLimparDisplay: AnsiString; override;
  end;

implementation

uses
  ACBrConsts, ACBrUtil;

{ TACBrMTerSB100 }

function TACBrMTerSB100.PrepararCmd(const aCmd: Char; const aParams: AnsiString): AnsiString;
begin
  Result := STX + aCmd + aParams + ETX;
end;

constructor TACBrMTerSB100.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'SB100';
end;

function TACBrMTerSB100.ComandoBackSpace: AnsiString;
begin
  Result := ComandoEnviarTexto(BS);
end;

function TACBrMTerSB100.ComandoBeep(aTempo: Integer): AnsiString;
var
  wTempo: Integer;
begin
  // Ajustando tempo m�nimo/m�ximo
  wTempo := aTempo;
  if (wTempo < 1) then
    wTempo := 1
  else if (wTempo > 9) then
    wTempo := 9;

  Result := PrepararCmd('Z', IntToStr(wTempo));
end;

function TACBrMTerSB100.ComandoBoasVindas: AnsiString;
begin
  Result := '';
end;

function TACBrMTerSB100.ComandoDeslocarCursor(aValue: Integer): AnsiString;
begin
  Result := '';

  while (aValue > 0) do
  begin
    Result := Result + PrepararCmd('O', DC4);
    aValue := aValue - 1;
  end;
end;

function TACBrMTerSB100.ComandoDeslocarLinha(aValue: Integer): AnsiString;
var
  wLinha: Integer;
begin
  // Validando valores m�ximos/m�nimos
  wLinha := (aValue - 1);
  if (wLinha < 0) then
    wLinha := 0
  else if (wLinha > 3) then
    wLinha := 3;

  Result := PrepararCmd('P', IntToStr(wLinha) + '00');
end;

function TACBrMTerSB100.ComandoEnviarParaParalela(const aDados: AnsiString): AnsiString;
begin
  Result := '';
end;

function TACBrMTerSB100.ComandoEnviarParaSerial(const aDados: AnsiString;
  aSerial: Byte): AnsiString;
var
  wPorta: Char;
  I: Integer;
begin
  Result := '';

  if (aSerial = 2) then
    wPorta := 'R'        // Seleciona porta serial 2
  else
    wPorta := 'S';       // Seleciona porta serial padr�o(0)

  for I := 1 to Length(aDados) do
    Result := Result + PrepararCmd(wPorta, aDados[I]);
end;

function TACBrMTerSB100.ComandoEnviarTexto(const aTexto: AnsiString): AnsiString;
begin
  Result := PrepararCmd('Y', 'n' + aTexto);
end;

function TACBrMTerSB100.ComandoOnline: AnsiString;
begin
  Result := PrepararCmd('V');
end;

function TACBrMTerSB100.ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString;
var
  wCol, wLinha: Integer;
begin
  wLinha := (aLinha - 1);
  if (wLinha < 0) then
    wLinha := 0
  else if (wLinha > 3) then
    wLinha := 3;

  wCol := (aColuna - 1);
  if (wCol < 0) then
    wCol := 0
  else if (wCol > 40) then
    wCol := 40;

  Result := PrepararCmd('P', IntToStr(wLinha) + IntToStrZero(wCol, 2));
end;

function TACBrMTerSB100.ComandoLimparDisplay: AnsiString;
begin
  Result := PrepararCmd('C');
end;

end.

