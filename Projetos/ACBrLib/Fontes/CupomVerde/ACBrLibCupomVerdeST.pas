{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2025 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                           }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibCupomVerdeST;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum;

function CupomVerde_Inicializar (const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_Finalizar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_Nome (const sNome: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_Versao (const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_UltimoRetorno (const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigImportar (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigExportar (const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigLer (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigGravar (const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigLerValor (const eSessao, eChave: PAnsiChar; sValor: PAnsiChar;
  var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

function CupomVerde_ConfigGravarValor (const eSessao, eChave, eValor: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

implementation

Uses
  ACBrLibConsts, ACBrLibCupomVerdeBase;

function CupomVerde_Inicializar(const eArqConfig, eChaveCrypt: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(pLib, TACBrLibCupomVerde, eArqConfig, eChaveCrypt);
end;

function CupomVerde_Finalizar: Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar(pLib);
  pLib := Nil;
end;

function CupomVerde_Nome(const sNome: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(pLib, sNome, esTamanho);
end;

function CupomVerde_Versao(const sVersao: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(pLib, sVersao, esTamanho);
end;

function CupomVerde_OpenSSLInfo(const sOpenSSLInfo: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_OpenSSLInfo(pLib, sOpenSSLInfo, esTamanho);
end;

function CupomVerde_UltimoRetorno(const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(pLib, sMensagem, esTamanho);
end;

function CupomVerde_ConfigImportar(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigImportar(pLib, eArqConfig);
end;

function CupomVerde_ConfigExportar(const sMensagem: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigExportar(pLib, sMensagem, esTamanho);
end;

function CupomVerde_ConfigLer(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(pLib, eArqConfig);
end;

function CupomVerde_ConfigGravar(const eArqConfig: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(pLib, eArqConfig);
end;

function CupomVerde_ConfigLerValor(const eSessao, eChave: PAnsiChar; sValor: PAnsiChar; var esTamanho: Integer): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(pLib, eSessao, eChave, sValor, esTamanho);
end;

function CupomVerde_ConfigGravarValor(const eSessao, eChave, eValor: PAnsiChar): Integer;
 {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(pLib, eSessao, eChave, eValor);
end;

end.

