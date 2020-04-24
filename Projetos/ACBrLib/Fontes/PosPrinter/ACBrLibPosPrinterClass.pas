{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
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

unit ACBrLibPosPrinterClass;

interface

uses
  Classes, SysUtils, typinfo,
  ACBrPosPrinter, ACBrLibComum, ACBrLibPosPrinterDataModule;

type
  PACBrPosPrinter = ^TACBrPosPrinter;

  { TACBrLibPosPrinter }

  TACBrLibPosPrinter = class(TACBrLib)
  private
    FPosDM: TLibPosPrinterDM;

  protected
    procedure Inicializar; override;
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = '');
      override;
    procedure Executar; override;
  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property PosDM: TLibPosPrinterDM read FPosDM;
  end;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function POS_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Inicializada: Boolean;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Ativar}
function POS_Ativar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Desativar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Impressão}
function POS_Imprimir(eString: PChar; PulaLinha, DecodificarTags,
  CodificarPagina: Boolean; Copias: Integer): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirLinha(eString: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirCmd(eComando: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirTags: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirImagemArquivo(aPath: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_GravarLogoArquivo(aPath: PChar; nAKC1, nAKC2: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_ApagarLogo(nAKC1, nAKC2: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};

{%endregion}

{%region Diversos}
function POS_TxRx(eCmd: PChar; BytesToRead: Byte; ATimeOut: Integer; WaitForTerminator: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Zerar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_InicializarPos: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_Reset: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_PularLinhas(NumLinhas: Integer): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_CortarPapel(Parcial: Boolean): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_AbrirGaveta: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerInfoImpressora(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_LerStatusImpressora(Tentativas: Integer; var status: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_RetornarTags(IncluiAjuda: Boolean; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_AcharPortas(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function POS_GetPosPrinter: Pointer;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts, ACBrLibConfig, ACBrLibPosPrinterConfig,
  ACBrLibDeviceUtils;

{ TACBrLibPosPrinter }

constructor TACBrLibPosPrinter.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);
  FPosDM := TLibPosPrinterDM.Create(nil);
end;

destructor TACBrLibPosPrinter.Destroy;
begin
  FPosDM.Free;
  inherited Destroy;
end;

procedure TACBrLibPosPrinter.Inicializar;
begin
  inherited Inicializar;

  GravarLog('TACBrLibPosPrinter.Inicializar - Feito', logParanoico);
end;

procedure TACBrLibPosPrinter.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibPosPrinterConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibPosPrinter.Executar;
begin
  inherited Executar;
  FPosDM.AplicarConfiguracoes;
end;

{%region PosPrinter}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function POS_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(eArqConfig, eChaveCrypt);
end;

function POS_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar;
end;

function POS_Inicializada: Boolean;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicalizada;
end;

function POS_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(sNome, esTamanho);
end;

function POS_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(sVersao, esTamanho);
end;

function POS_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(sMensagem, esTamanho);
end;

function POS_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ImportarConfig(eArqConfig);
end;

function POS_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(eArqConfig);
end;

function POS_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(eArqConfig);
end;

function POS_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(eSessao, eChave, sValor, esTamanho);
end;

function POS_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(eSessao, eChave, eValor);
end;
{%endregion}

{%region Ativar}
function POS_Ativar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Ativar', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.Ativar;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_Desativar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Desativar', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.Desativar;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;
{%endregion}

{%region Impressão}
function POS_Imprimir(eString: PChar; PulaLinha, DecodificarTags,
  CodificarPagina: Boolean; Copias: Integer): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AString: AnsiString;
  UTF8Str: String;
begin
  try
    VerificarLibInicializada;
    AString := AnsiString(eString);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_Imprimir(' + AString + ',' + BoolToStr(PulaLinha, True) + ',' +
        BoolToStr(DecodificarTags, True) + ',' + BoolToStr(CodificarPagina, True) + ',' +
        IntToStr(Copias) +' )', logCompleto, True)
    else
      pLib.GravarLog('POS_Imprimir', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        UTF8Str := ConverterAnsiParaUTF8(AString);
        PosDM.ACBrPosPrinter1.Imprimir(UTF8Str, PulaLinha, DecodificarTags, CodificarPagina, Copias);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ImprimirLinha(eString: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AString: AnsiString;
  UTF8Str: String;
begin
  try
    VerificarLibInicializada;
    AString := AnsiString(eString);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_ImprimirLinha(' + AString + ')', logCompleto, True)
    else
      pLib.GravarLog('POS_ImprimirLinha', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        UTF8Str := ConverterAnsiParaUTF8(AString);
        PosDM.ACBrPosPrinter1.ImprimirLinha(UTF8Str);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ImprimirCmd(eComando: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AComando: AnsiString;
begin
  try
    VerificarLibInicializada;
    AComando := AnsiString(eComando);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_ImprimirCmd(' + AComando + ')', logCompleto, True)
    else
      pLib.GravarLog('POS_ImprimirCmd', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.ImprimirCmd(AComando);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ImprimirTags: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_ImprimirTags', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.ImprimirTags;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ImprimirImagemArquivo(aPath: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Path: AnsiString;
begin
  try
    VerificarLibInicializada;

    Path := AnsiString(aPath);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_ImprimirImagemArquivo(' + Path + ')', logCompleto, True)
    else
      pLib.GravarLog('POS_ImprimirImagemArquivo', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.ImprimirImagemArquivo(Path);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_GravarLogoArquivo(aPath: PChar; nAKC1, nAKC2: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Path: AnsiString;
begin
  try
    VerificarLibInicializada;

    Path := AnsiString(aPath);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_GravarLogoArquivo(' + Path + ',' +
                                                IntToStr(nAKC1) + ',' +
                                                IntToStr(nAKC2) +')', logCompleto, True)
    else
      pLib.GravarLog('POS_GravarLogoArquivo', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.GravarLogoArquivo(Path, nAKC1, nAKC2);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_ImprimirLogo(' + IntToStr(nAKC1) + ','
                                         + IntToStr(nAKC2) + ','
                                         + IntToStr(nFatorX) + ','
                                         + IntToStr(nFatorY) + ')', logCompleto, True)
    else
      pLib.GravarLog('POS_ImprimirLogo', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.ImprimirLogo(nAKC1, nAKC2, nFatorX, nFatorY);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_ApagarLogo(nAKC1, nAKC2: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_ApagarLogo(' + IntToStr(nAKC1) + ','
                                       + IntToStr(nAKC2) + ')', logCompleto, True)
    else
      pLib.GravarLog('POS_ApagarLogo', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.ApagarLogo(nAKC1, nAKC2);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

{%endregion}

{%region Diversos}
function POS_TxRx(eCmd: PChar; BytesToRead: Byte; ATimeOut: Integer; WaitForTerminator: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ACmd, Resposta: AnsiString;
begin
  try
    VerificarLibInicializada;
    ACmd := AnsiString(eCmd);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_TxRx(' + ACmd + ',' + IntToStr(BytesToRead) + ',' +
        IntToStr(ATimeOut) + ',' + BoolToStr(WaitForTerminator, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('POS_TxRx', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        Resposta := '';
        Resposta := PosDM.ACBrPosPrinter1.TxRx(ACmd, BytesToRead, ATimeOut, WaitForTerminator);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_Zerar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Zerar', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.Zerar;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_InicializarPos: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Inicializar', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.Inicializar;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_Reset: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Reset', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.Reset;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_PularLinhas(NumLinhas: Integer): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_PularLinhas(' + IntToStr(NumLinhas) + ' )', logCompleto, True)
    else
      pLib.GravarLog('POS_PularLinhas', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.PularLinhas(NumLinhas);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_CortarPapel(Parcial: Boolean): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_CortarPapel(' + BoolToStr(Parcial, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('POS_CortarPapel', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.CortarPapel(Parcial);
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_AbrirGaveta: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_AbrirGaveta', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        PosDM.ACBrPosPrinter1.AbrirGaveta;
        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_LerInfoImpressora(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
begin
   try
    VerificarLibInicializada;

    pLib.GravarLog('POS_LerInfoImpressora', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        Resposta := '';
        Resposta := PosDM.ACBrPosPrinter1.LerInfoImpressora;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_LerStatusImpressora(Tentativas: Integer; var status: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  RetStatus: TACBrPosPrinterStatus;
  i: TACBrPosTipoStatus;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_LerStatusImpressora(' + IntToStr(Tentativas) + ' )', logCompleto, True)
    else
      pLib.GravarLog('POS_LerStatusImpressora', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      status := 0;
      try
        RetStatus := PosDM.ACBrPosPrinter1.LerStatusImpressora(Tentativas);
        if RetStatus <> [] then
        begin
          for i := Low(TACBrPosTipoStatus) to High(TACBrPosTipoStatus) do
          begin
            if i in RetStatus then
              status := status + (1 << Ord(i));
          end;
        end;

        Result := SetRetorno(ErrOK);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_RetornarTags(IncluiAjuda: Boolean; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Tags: TStringList;
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('POS_RetornarTags(' + BoolToStr(IncluiAjuda, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('POS_RetornarTags', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      Tags := TStringList.Create;
      try
        PosDM.ACBrPosPrinter1.RetornarTags(Tags, IncluiAjuda);
        Resposta := StringReplace(Tags.Text, sLineBreak, '|', [rfReplaceAll]);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Tags.Free;
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_AcharPortas(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
  Portas: TStringList;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_AcharPortas', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;

      Resposta := '';
      Portas := TStringList.Create;
      try
        Resposta := PortasSeriais(PosDM.ACBrPosPrinter1.Device);
        Resposta := Resposta + '|' + PortasUSB(PosDM.ACBrPosPrinter1.Device);
        Resposta := Resposta + '|' + PortasRAW(PosDM.ACBrPosPrinter1.Device);

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Portas.Free;
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function POS_GetPosPrinter: Pointer;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('POS_GetPosPrinter', logNormal);

    with TACBrLibPosPrinter(pLib) do
    begin
      PosDM.Travar;
      try
        Result := PosDM.ACBrPosPrinter1;
        with TACBrPosPrinter(Result) do
          pLib.GravarLog('  '+ClassName+', '+Name, logParanoico);
      finally
        PosDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
    begin
      SetRetorno(E.Erro, E.Message);
      Result := Nil;
    end;

    on E: Exception do
    begin
      SetRetorno(ErrExecutandoMetodo, E.Message);
      Result := Nil;
    end;
  end;
end;

{%endregion}

{%endregion}

end.

