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
|*  - Primeira Versao ACBrMTerVT100
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerVT100;

interface

uses
  Classes, SysUtils, ACBrMTerClass, ACBrConsts;

type

  { TACBrMTerVT100 }

  TACBrMTerVT100 = class(TACBrMTerClass)
  private
    { Private declarations }
  public
    constructor Create(aOwner: TComponent);

    function ComandoBackSpace: AnsiString; override;
    function ComandoBeep: AnsiString; override;
    function ComandoBoasVindas: AnsiString; override;
    function ComandoDeslocarCursor(aValue: Integer): AnsiString; override;
    function ComandoDeslocarLinha(aValue: Integer): AnsiString; override;
    function ComandoEnviarParaParalela(aDados: AnsiString): AnsiString; override;
    function ComandoEnviarParaSerial(aDados: AnsiString; aSerial: Byte = 0): AnsiString; override;
    function ComandoEnviarTexto(aTexto: AnsiString): AnsiString; override;
    function ComandoLimparLinha(aLinha: Integer): AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;
    function ComandoLimparDisplay: AnsiString; override;
  end;

implementation

uses ACBrUtil;

{ TACBrMTerVT100 }

constructor TACBrMTerVT100.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'VT100';
end;

function TACBrMTerVT100.ComandoBackSpace: AnsiString;
begin
  Result := BS;
end;

function TACBrMTerVT100.ComandoBeep: AnsiString;
begin
  Result := ESC + '[TB';
end;

function TACBrMTerVT100.ComandoBoasVindas: AnsiString;
begin
  Result := '';
end;

function TACBrMTerVT100.ComandoDeslocarCursor(aValue: Integer): AnsiString;
var
  I: Integer;
begin
  Result := '';

  if (aValue < 0) then
    raise Exception.Create(ACBrStr('V�lidos apenas n�meros positivos'));

  for I := 1 to aValue do
    Result := Result + ESC + '[C';
end;

function TACBrMTerVT100.ComandoDeslocarLinha(aValue: Integer): AnsiString;
var
  wCmd: String;
  I: Integer;
begin
  Result := '';

  if (aValue > 0) then
    wCmd := LF           // Comando coloca cursor na linha de baixo
  else if (aValue < 0) then
    wCmd := ESC + '[A'   // Comando coloca cursor na linha de cima
  else
    Exit;

  for I := 1 to abs(aValue) do
    Result := Result + wCmd;
end;

function TACBrMTerVT100.ComandoEnviarParaParalela(aDados: AnsiString
  ): AnsiString;
begin
  Result := ESC + '[?24l';  // Seleciona porta paralela

  Result := Result + ESC + '[5i';  // Habilita servi�o de impress�o
  Result := Result + aDados;       // Envia Dados
  Result := Result + ESC + '[4i';  // Desabilita servi�o de impress�o
end;

function TACBrMTerVT100.ComandoEnviarParaSerial(aDados: AnsiString;
  aSerial: Byte): AnsiString;
begin
  if (aSerial = 1) then
    Result := ESC + '[?24r'   // Seleciona porta serial 1
  else
    Result := ESC + '[?24h';  // Seleciona porta serial padr�o(0)

  Result := Result + ESC + '[5i';  // Habilita servi�o de impress�o
  Result := Result + aDados;       // Envia Dados
  Result := Result + ESC + '[4i';  // Desabilita servi�o de impress�o
end;

function TACBrMTerVT100.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
begin
  Result := aTexto;
end;

function TACBrMTerVT100.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  Result := ComandoPosicionarCursor(aLinha, 1) + ESC + '[K';
end;

function TACBrMTerVT100.ComandoPosicionarCursor(aLinha, aColuna: Integer
  ): AnsiString;
var
  wL, wC: String;
begin
  if (aLinha < 1) or (aLinha > 2) then
    raise Exception.Create(ACBrStr('Valores v�lidos para Linhas: 1 ou 2'));
  if (aColuna < 1) or (aColuna > 40) then
    raise Exception.Create(ACBrStr('Valores v�lidos para Colunas: 1 ao 40'));

  wL := IntToStrZero(aLinha, 2);
  wC := IntToStrZero(aColuna, 2);

  Result := ESC + '[' + wL + ';' + wC + 'H';
end;

function TACBrMTerVT100.ComandoLimparDisplay: AnsiString;
begin
  Result := ESC + '[H' + ESC + '[J';
end;

end.

