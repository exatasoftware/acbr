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
|*  - Primeira Versao ACBrMTerStxEtx
******************************************************************************}

{$I ACBr.inc}

unit ACBrMTerStxEtx;

interface

uses
  Classes, SysUtils, ACBrMTerClass, ACBrConsts, ACBrUtil;

type

  { TACBrMTerStxEtx }

  TACBrMTerStxEtx = class(TACBrMTerClass)
  private
    function PrepararCmd(aCmd: Char; aParams: AnsiString = ''): AnsiString;
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
    function ComandoOnline: AnsiString; override;
    function ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString; override;
    function ComandoLimparDisplay: AnsiString; override;

    function InterpretarResposta(aRecebido: AnsiString): AnsiString; override;
  end;

implementation

{ TACBrMTerStxEtx }

function TACBrMTerStxEtx.PrepararCmd(aCmd: Char; aParams: AnsiString): AnsiString;
begin
  Result := STX + aCmd + aParams + ETX;
end;

constructor TACBrMTerStxEtx.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  fpModeloStr := 'STX-ETX';
end;

function TACBrMTerStxEtx.ComandoBackSpace: AnsiString;
begin
  Result := PrepararCmd('D', BS);
end;

function TACBrMTerStxEtx.ComandoBeep: AnsiString;
begin
  //Result := STX + #90 + '9' + ETX;
  //Result := STX + 'D' + BELL + ETX;
  Result := '';  //TODO:
end;

function TACBrMTerStxEtx.ComandoBoasVindas: AnsiString;
begin
  Result := '';
end;

function TACBrMTerStxEtx.ComandoDeslocarCursor(aValue: Integer): AnsiString;
begin
  Result := '';

  while (aValue > 0) do
  begin
    Result := Result + PrepararCmd('O', DC4);
    aValue := aValue - 1;
  end;
end;

function TACBrMTerStxEtx.ComandoDeslocarLinha(aValue: Integer): AnsiString;
begin
  Result := PrepararCmd('C', '100');
  end;

function TACBrMTerStxEtx.ComandoEnviarParaParalela(aDados: AnsiString): AnsiString;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(aDados) do
    Result := Result + PrepararCmd('P', aDados[I]);
end;

function TACBrMTerStxEtx.ComandoEnviarParaSerial(aDados: AnsiString;
  aSerial: Byte): AnsiString;
var
  wPorta: Char;
  I: Integer;
begin
  Result := '';

  if (aSerial = 1) then
    wPorta := 'R'        // Seleciona porta serial 1
  else
    wPorta := 'S';       // Seleciona porta serial padr�o(0)

  for I := 1 to Length(aDados) do
    Result := Result + PrepararCmd(wPorta, aDados[I]);
end;

function TACBrMTerStxEtx.ComandoEnviarTexto(aTexto: AnsiString): AnsiString;
begin
  Result := PrepararCmd('D', aTexto);
end;

function TACBrMTerStxEtx.ComandoLimparLinha(aLinha: Integer): AnsiString;
begin
  Result := '';
end;

function TACBrMTerStxEtx.ComandoOnline: AnsiString;
begin
  Result := PrepararCmd('T');
end;

function TACBrMTerStxEtx.ComandoPosicionarCursor(aLinha, aColuna: Integer): AnsiString;
var
  wCol, wLinha: Integer;
begin
  wLinha := (aLinha - 1);
  wCol   := (aColuna - 1);
  Result := PrepararCmd('C', IntToStr(wLinha) + IntToStrZero(wCol, 2));
end;

function TACBrMTerStxEtx.ComandoLimparDisplay: AnsiString;
begin
  Result := PrepararCmd('L');
end;

function TACBrMTerStxEtx.InterpretarResposta(aRecebido: AnsiString): AnsiString;
begin
  if (aRecebido[1] = STX) and (aRecebido[Length(aRecebido)] = ETX) then
    Exit;

  Result := aRecebido;
end;

end.

