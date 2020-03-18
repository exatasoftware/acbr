﻿{******************************************************************************}
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

unit ACBrLibCTeClass;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum, ACBrLibCTeDataModule;

type

  { TACBrLibCTe }

  TACBrLibCTe = class(TACBrLib)
  private
    FCTeDM: TLibCTeDM;

  protected
    procedure Inicializar; override;
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = '');
      override;
    procedure Executar; override;
  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property CTeDM: TLibCTeDM read FCTeDM;
  end;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function CTE_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region CTe}
function CTE_CarregarXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_CarregarINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ObterXml(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_GravarXml(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ObterIni(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_GravarIni(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_CarregarEventoXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_CarregarEventoINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_LimparLista: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_LimparListaEventos: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Assinar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Validar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ValidarRegrasdeNegocios(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_VerificarAssinatura(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_GerarChave(ACodigoUF, ACodigoNumerico, AModelo, ASerie, ANumero, ATpEmi: longint;
  AEmissao, ACNPJCPF: PChar; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_GetPath(ATipo: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_GetPathEvento(ACodEvento: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Servicos}
function CTE_StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Consultar(const eChaveOuCTe: PChar; AExtrairEventos: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Inutilizar(const ACNPJ, AJustificativa: PChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Enviar(ALote: Integer; AImprimir, ASincrono: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConsultarRecibo(ARecibo: PChar;
    const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Cancelar(const eChave, eJustificativa, eCNPJ: PChar; ALote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_EnviarEvento(idLote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
    const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_DistribuicaoDFePorUltNSU(const AcUFAutor: integer; eCNPJCPF, eultNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_DistribuicaoDFePorNSU(const AcUFAutor: integer; eCNPJCPF, eNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_DistribuicaoDFePorChave(const AcUFAutor: integer; eCNPJCPF, echCTe: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_EnviarEmail(const ePara, eChaveCTe: PChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_EnviarEmailEvento(const ePara, eChaveEvento, eChaveCTe: PChar;
  const AEnviaPDF: Boolean; const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_Imprimir(const cImpressora: PChar; nNumCopias: Integer; const cProtocolo,
  bMostrarPreview: PChar): longint; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImprimirPDF: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImprimirEvento(const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImprimirEventoPDF(const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImprimirInutilizacao(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function CTE_ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts, ACBrLibCTeConsts, ACBrLibConfig, ACBrLibResposta,
  ACBrLibConsReciDFe, ACBrLibDistribuicaoDFe, ACBrLibConsultaCadastro,
  ACBrLibCTeConfig, ACBrLibCTeRespostas, ACBrCTe, ACBrMail, ACBrLibCertUtils,
  pcnConversao, pcnAuxiliar, pcteConversaoCTe, blcksock, ACBrUtil, ACBrDFeUtil;

{ TACBrLibCTe }

constructor TACBrLibCTe.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);

  FCTeDM := TLibCTeDM.Create(nil);
end;

destructor TACBrLibCTe.Destroy;
begin
  FCTeDM.Free;

  inherited Destroy;
end;

procedure TACBrLibCTe.Inicializar;
begin
  GravarLog('TACBrLibCTe.Inicializar', logNormal);

  FCTeDM.CriarACBrMail;

  GravarLog('TACBrLibCTe.Inicializar - Feito', logParanoico);

  inherited Inicializar;
end;

procedure TACBrLibCTe.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibCTeConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibCTe.Executar;
begin
  inherited Executar;
  FCTeDM.AplicarConfiguracoes;
end;

{%region CTe}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function CTE_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(eArqConfig, eChaveCrypt);
end;

function CTE_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar;
end;

function CTE_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(sNome, esTamanho);
end;

function CTE_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(sVersao, esTamanho);
end;

function CTE_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(sMensagem, esTamanho);
end;

function CTE_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ImportarConfig(eArqConfig);
end;

function CTE_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(eArqConfig);
end;

function CTE_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(eArqConfig);
end;

function CTE_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(eSessao, eChave, sValor, esTamanho);
end;

function CTE_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(eSessao, eChave, eValor);
end;

{%endregion}

function CTE_CarregarXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuXml := string(eArquivoOuXML);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_CarregarXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_CarregarXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if EhArquivo then
          CTeDM.ACBrCTe1.Conhecimentos.LoadFromFile(ArquivoOuXml)
        else
          CTeDM.ACBrCTe1.Conhecimentos.LoadFromString(ArquivoOuXml);

        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_CarregarINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoOuINI: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuINI := string(eArquivoOuINI);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_CarregarINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_CarregarINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ACBrCTe1.Conhecimentos.LoadFromIni(ArquivoOuINI);
        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ObterXml(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: String;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ObterXml(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ObterXml', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if (AIndex >= CTeDM.ACBrCTe1.Conhecimentos.Count) and (CTeDM.ACBrCTe1.Conhecimentos.Count < 1) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if EstaVazio(CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].XMLOriginal) then
          CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GerarXML;

        Resposta := CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].XMLOriginal;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_GravarXml(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  ANomeArquivo, APathArquivo: String;
begin
  try
    VerificarLibInicializada;
    ANomeArquivo := String(eNomeArquivo);
    APathArquivo := String(ePathArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_GravarXml(' + IntToStr(AIndex) + ',' + ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_GravarXml', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if (AIndex >= CTeDM.ACBrCTe1.Conhecimentos.Count) and (CTeDM.ACBrCTe1.Conhecimentos.Count < 1) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GravarXML(ANomeArquivo, APathArquivo) then
          Result := SetRetorno(ErrOK)
        else
          Result := SetRetorno(ErrGerarXml);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ObterIni(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: String;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ObterIni(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ObterIni', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if (AIndex >= CTeDM.ACBrCTe1.Conhecimentos.Count) and (CTeDM.ACBrCTe1.Conhecimentos.Count < 1) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if EstaVazio(CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].XMLOriginal) then
          CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GerarXML;

        Resposta := CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GerarCTeIni;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_GravarIni(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  ACTeIni, ANomeArquivo, APathArquivo: String;
begin
  try
    VerificarLibInicializada;
    ANomeArquivo := String(eNomeArquivo);
    APathArquivo := String(ePathArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_GravarIni(' + IntToStr(AIndex) + ',' + ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_GravarIni', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if (AIndex >= CTeDM.ACBrCTe1.Conhecimentos.Count) and (CTeDM.ACBrCTe1.Conhecimentos.Count < 1) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        ANomeArquivo := ExtractFileName(ANomeArquivo);

        if EstaVazio(ANomeArquivo) then
          raise EACBrLibException.Create(ErrExecutandoMetodo, 'Nome de arquivo não informado');

        if EstaVazio(APathArquivo) then
          APathArquivo := ExtractFilePath(ANomeArquivo);
        if EstaVazio(APathArquivo) then
          APathArquivo := CTeDM.ACBrCTe1.Configuracoes.Arquivos.PathSalvar;

        APathArquivo := PathWithDelim(APathArquivo);

        if EstaVazio(CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].XMLOriginal) then
          CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GerarXML;

        ACTeIni := CTeDM.ACBrCTe1.Conhecimentos.Items[AIndex].GerarCTeIni;

        if not DirectoryExists(APathArquivo) then
          ForceDirectories(APathArquivo);

        WriteToTXT(APathArquivo + ANomeArquivo, ACTeIni, False, False);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_CarregarEventoXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuXml := string(eArquivoOuXML);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_CarregarEventoXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_CarregarEventoXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        if EhArquivo then
          CTeDM.ACBrCTe1.EventoCTe.LerXML(ArquivoOuXml)
        else
          CTeDM.ACBrCTe1.EventoCTe.LerXMLFromString(ArquivoOuXml);

        Result := SetRetornoEventoCarregados(CTeDM.ACBrCTe1.EventoCTe.Evento.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_CarregarEventoINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoOuINI: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuINI := string(eArquivoOuINI);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_CarregarEventoINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_CarregarEventoINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ACBrCTe1.EventoCTe.LerFromIni(ArquivoOuINI, False);
        Result := SetRetornoEventoCarregados(CTeDM.ACBrCTe1.EventoCTe.Evento.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_LimparLista: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_LimparLista', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ACBrCTe1.Conhecimentos.Clear;
        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_LimparListaEventos: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_LimparListaEventos', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ACBrCTe1.EventoCTe.Evento.Clear;
        Result := SetRetornoEventoCarregados(CTeDM.ACBrCTe1.EventoCTe.Evento.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Assinar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_Assinar', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        try
          CTeDM.ACBrCTe1.Conhecimentos.Assinar;
        except
          on E: EACBrCTeException do
            Result := SetRetorno(ErrAssinarCTe, E.Message);
        end;
        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Validar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_Validar', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        try
          CTeDM.ACBrCTe1.Conhecimentos.Validar;
        except
          on E: EACBrCTeException do
            Result := SetRetorno(ErrValidacaoCTe, E.Message);
        end;
        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ValidarRegrasdeNegocios(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Erros: string;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_ValidarRegrasdeNegocios', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        Erros := '';
        CTeDM.ACBrCTe1.Conhecimentos.ValidarRegrasdeNegocios(Erros);
        MoverStringParaPChar(Erros, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Erros);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_VerificarAssinatura(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Erros: string;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_VerificarAssinatura', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        Erros := '';
        CTeDM.ACBrCTe1.Conhecimentos.VerificarAssinatura(Erros);
        MoverStringParaPChar(Erros, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Erros);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_GerarChave(ACodigoUF, ACodigoNumerico, AModelo, ASerie, ANumero, ATpEmi: longint;
  AEmissao, ACNPJCPF: PChar; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta, CNPJCPF: string;
  Emissao: TDateTime;
begin
  try
    VerificarLibInicializada;

    Emissao := StrToDate(AEmissao);
    CNPJCPF := String(ACNPJCPF);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_GerarChave(' + IntToStr(ACodigoUF) + ',' + IntToStr(ACodigoNumerico) + ',' +
                      IntToStr(AModelo)  + ',' + IntToStr(AModelo) + ',' + IntToStr(ASerie) + ',' +
                      IntToStr(ANumero) + ',' + IntToStr(ATpEmi) + ',' + DateToStr(Emissao) + ',' +
                      CNPJCPF + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_GerarChave', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        Resposta := '';
        Resposta := GerarChaveAcesso(ACodigoUF, Emissao, CNPJCPF, ASerie, ANumero, ATpEmi, ACodigoNumerico, AModelo);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('CTE_ObterCertificados', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        Resposta := '';
        Resposta := ObterCerticados(CTeDM.ACBrCTe1.SSL);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_GetPath(ATipo: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
  ok: Boolean;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_GetPath(' + IntToStr(ATipo) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_GetPath', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        with CTeDM do
        begin
          Resposta := '';

          case ATipo of
            0: Resposta := ACBrCTe1.Configuracoes.Arquivos.GetPathCTe();
            1: Resposta := ACBrCTe1.Configuracoes.Arquivos.GetPathInu();
            2: Resposta := ACBrCTe1.Configuracoes.Arquivos.GetPathEvento(teCCe);
            3: Resposta := ACBrCTe1.Configuracoes.Arquivos.GetPathEvento(teCancelamento);
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_GetPathEvento(ACodEvento: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta, CodEvento: string;
  ok: Boolean;
begin
  try
    VerificarLibInicializada;

    CodEvento := String(ACodEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_GetPathEvento(' + CodEvento +' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_GetPathEvento', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        with CTeDM do
        begin
          Resposta := '';
          Resposta := ACBrCTe1.Configuracoes.Arquivos.GetPathEvento(StrToTpEventoCTe(ok, CodEvento));
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        CTeDM.Destravar;
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

{%region Servicos}
function CTE_StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TStatusServicoResposta;
  Resposta: String;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_StatusServico', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      Resp := TStatusServicoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with CTeDM do
        begin
          ACBrCTe1.WebServices.StatusServico.Executar;
          Resp.Processar(CTeDM.ACBrCTe1);
          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end
      finally
        Resp.Free;
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Consultar(const eChaveOuCTe: PChar; AExtrairEventos: Boolean; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  Resposta, ChaveOuCTe: string;
  Resp: TConsultaCTeResposta;
begin
  try
    VerificarLibInicializada;

    ChaveOuCTe := string(eChaveOuCTe);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_Consultar(' + ChaveOuCTe + ', ' + BoolToStr(AExtrairEventos, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_Consultar', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      EhArquivo := StringEhArquivo(ChaveOuCTe);

      if EhArquivo and not ValidarChave(ChaveOuCTe) then
      begin
        VerificarArquivoExiste(ChaveOuCTe);
        CTeDM.ACBrCTe1.Conhecimentos.LoadFromFile(ChaveOuCTe);
      end;

      if CTeDM.ACBrCTe1.Conhecimentos.Count = 0 then
      begin
        if ValidarChave(ChaveOuCTe) then
          CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave := ChaveOuCTe
        else
          raise EACBrLibException.Create(ErrChaveCTe, Format(SErrChaveInvalida, [ChaveOuCTe]));
      end
      else
        CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave := StringReplace(
          CTeDM.ACBrCTe1.Conhecimentos.Items[CTeDM.ACBrCTe1.Conhecimentos.Count - 1].CTe.infCTe.ID,
          'CTe','',[rfIgnoreCase]);

      CTeDM.ACBrCTe1.WebServices.Consulta.ExtrairEventos := AExtrairEventos;

      Resp := TConsultaCTeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with CTeDM.ACBrCTe1 do
        begin
          WebServices.Consulta.Executar;
          Resp.Processar(CTeDM.ACBrCTe1);

          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        Resp.Free;
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Inutilizar(const ACNPJ, AJustificativa: PChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TInutilizarCTeResposta;
  Resposta, CNPJ, Justificativa: string;
begin
  try
    VerificarLibInicializada;

    Justificativa := string(AJustificativa);
    CNPJ := string(ACNPJ);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_Inutilizar(' + CNPJ + ',' + Justificativa + ',' + IntToStr(Ano) + ',' +
        IntToStr(modelo) + ',' + IntToStr(Serie) +  ',' + IntToStr(NumeroInicial) +  ',' +
        IntToStr(NumeroFinal) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_Inutilizar', logNormal);

    CNPJ := OnlyNumber(CNPJ);

    if not ValidarCNPJ(CNPJ) then
      raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJInvalido, [ACNPJ]));

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      Resp := TInutilizarCTeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with CTeDM.ACBrCTe1.WebServices do
        begin
          Inutilizacao.Clear;
          Inutilizacao.CNPJ := CNPJ;
          Inutilizacao.Justificativa := Justificativa;
          Inutilizacao.Modelo := Modelo;
          Inutilizacao.Serie := Serie;
          Inutilizacao.Ano := Ano;
          Inutilizacao.NumeroInicial := NumeroInicial;
          Inutilizacao.NumeroFinal := NumeroFinal;

          Inutilizacao.Executar;
          Resp.Processar(CTeDM.ACBrCTe1);
          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        Resp.Free;
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Enviar(ALote: Integer; AImprimir, ASincrono: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  RespEnvio: TEnvioResposta;
  RespRetorno: TRetornoResposta;
  ImpResp: TLibImpressaoResposta;
  Resposta: String;
  I, ImpCount: Integer;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_Enviar(' + IntToStr(ALote) + ',' +
                   BoolToStr(AImprimir, 'Imprimir','') + ',' +
                   BoolToStr(ASincrono, 'Sincrono','')+ ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_Enviar', logNormal);

    Resposta := '';
    RespEnvio := nil;
    RespRetorno := nil;
    ImpResp := nil;

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        with CTeDM.ACBrCTe1 do
        begin
          if Conhecimentos.Count <= 0 then
            raise EACBrLibException.Create(ErrEnvio, 'ERRO: Nenhuma CT-e adicionada ao Lote');

          if Conhecimentos.Count > 50 then
            raise EACBrLibException.Create(ErrEnvio, 'ERRO: Conjunto de CT-e transmitidas (máximo de 50 CT-e)' +
                                                     ' excedido. Quantidade atual: ' + IntToStr(Conhecimentos.Count));

          Conhecimentos.Assinar;
          Conhecimentos.Validar;

          if (ALote = 0) then
            WebServices.Enviar.Lote := '1'
          else
            WebServices.Enviar.Lote := IntToStr(ALote);

          WebServices.Enviar.Sincrono := ASincrono;
          WebServices.Enviar.Executar;
          RespEnvio := TEnvioResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            RespEnvio.Processar(CTeDM.ACBrCTe1);
            Resposta := RespEnvio.Gerar;
          finally
            RespEnvio.Free;
          end;

          if not ASincrono or ((NaoEstaVazio(WebServices.Enviar.Recibo)) and (WebServices.Enviar.cStat = 103)) then
          begin
            WebServices.Retorno.Recibo := WebServices.Enviar.Recibo;
            WebServices.Retorno.Executar;

            RespRetorno := TRetornoResposta.Create('CTe', pLib.Config.TipoResposta, pLib.Config.CodResposta);

            try
              RespRetorno.Processar(WebServices.Retorno.CTeRetorno,
                                    WebServices.Retorno.Recibo,
                                    WebServices.Retorno.Msg,
                                    WebServices.Retorno.Protocolo,
                                    WebServices.Retorno.ChaveCTe);

              Resposta := Resposta + sLineBreak + RespRetorno.Gerar;
            finally
              RespRetorno.Free;
            end;
          end;

          if AImprimir then
          begin
            CTeDM.ConfigurarImpressao();

            ImpCount := 0;
            for I := 0 to Conhecimentos.Count - 1 do
            begin
              if Conhecimentos.Items[I].Confirmado then
              begin
                Conhecimentos.Items[I].Imprimir;
                Inc(ImpCount);
              end;
            end;

            if ImpCount > 0 then
            begin
              ImpResp := TLibImpressaoResposta.Create(ImpCount, pLib.Config.TipoResposta, pLib.Config.CodResposta);
              try
                Resposta := Resposta + sLineBreak + ImpResp.Gerar;
              finally
                ImpResp.Free;
              end;
            end;
          end;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ConsultarRecibo(ARecibo: PChar; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TReciboResposta;
  sRecibo, Resposta: string;
begin
  try
    VerificarLibInicializada;

    sRecibo := string(ARecibo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ConsultarRecibo(' + sRecibo + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ConsultarRecibo', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        with CTeDM.ACBrCTe1 do
        begin
          WebServices.Recibo.Recibo := sRecibo;
          WebServices.Recibo.Executar;

          Resp := TReciboResposta.Create('CTe', pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(WebServices.Recibo.CTeRetorno,
            WebServices.Recibo.Recibo);
            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Cancelar(const eChave, eJustificativa, eCNPJ: PChar; ALote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TCancelamentoResposta;
  AChave, AJustificativa, ACNPJ: string;
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    AChave := string(eChave);
    AJustificativa := string(eJustificativa);
    ACNPJ := string(eCNPJ);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_Cancelar(' + AChave + ',' + AJustificativa + ',' +
                        ACNPJ + ',' + IntToStr(ALote) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_Cancelar', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        if not ValidarChave(AChave) then
          raise EACBrLibException.Create(ErrChaveCTe, Format(SErrChaveInvalida, [AChave]))
        else
          CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave := AChave;

        if not CTeDM.ACBrCTe1.WebServices.Consulta.Executar then
          raise EACBrLibException.Create(ErrConsulta, CTeDM.ACBrCTe1.WebServices.Consulta.Msg);

        CTeDM.ACBrCTe1.EventoCTe.Evento.Clear;

        with CTeDM.ACBrCTe1.EventoCTe.Evento.New do
        begin
          Infevento.CNPJ := ACNPJ;

          if Trim(Infevento.CNPJ) = '' then
            Infevento.CNPJ := copy(OnlyNumber(CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave), 7, 14)
          else
          begin
            if not ValidarCNPJouCPF(ACNPJ) then
              raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJ]));
          end;

          Infevento.nSeqEvento := 1;
          InfEvento.tpAmb := CTeDM.ACBrCTe1.Configuracoes.WebServices.Ambiente;
          Infevento.cOrgao := StrToIntDef(copy(OnlyNumber(CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave), 1, 2), 0);
          Infevento.dhEvento := now;
          Infevento.tpEvento := teCancelamento;
          Infevento.chCTe := CTeDM.ACBrCTe1.WebServices.Consulta.CTeChave;
          Infevento.detEvento.nProt := CTeDM.ACBrCTe1.WebServices.Consulta.Protocolo;
          Infevento.detEvento.xJust := AJustificativa;
        end;

        if (ALote = 0) then
            ALote := 1;

        CTeDM.ACBrCTe1.WebServices.EnvEvento.idLote := ALote;
        CTeDM.ACBrCTe1.WebServices.EnvEvento.Executar;
        Resp := TCancelamentoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);

        try
          Resp.Processar(CTeDM.ACBrCTe1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_EnviarEvento(idLote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  i, j: Integer;
  chCTe, Resposta: String;
  Resp: TEventoResposta;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_EnviarEvento(' + IntToStr(idLote) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_EnviarEvento', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      with CTeDM.ACBrCTe1 do
      begin
        if EventoCTe.Evento.Count <= 0 then
          raise EACBrLibException.Create(ErrEnvioEvento, 'ERRO: Nenhum Evento adicionado ao Lote');

        if EventoCTe.Evento.Count > 20 then
          raise EACBrLibException.Create(ErrEnvioEvento,'ERRO: Conjunto de Eventos transmitidos (máximo de 20) ' +
                                                        'excedido. Quantidade atual: ' + IntToStr(EventoCTe.Evento.Count));

        {Atribuir nSeqEvento, CNPJ, Chave e/ou Protocolo quando não especificar}
        for i := 0 to EventoCTe.Evento.Count -1 do
        begin
          if EventoCTe.Evento.Items[i].InfEvento.nSeqEvento = 0 then
            EventoCTe.Evento.Items[i].infEvento.nSeqEvento := 1;

          EventoCTe.Evento.Items[i].InfEvento.tpAmb := Configuracoes.WebServices.Ambiente;

          if Conhecimentos.Count > 0 then
          begin
            chCTe := OnlyNumber(EventoCTe.Evento.Items[i].InfEvento.chCTe);

            // Se tem a chave do CTe no Evento, procure por ela nos conhecimentos carregados //
            if NaoEstaVazio(chCTe) then
            begin
              for j := 0 to Conhecimentos.Count - 1 do
              begin
                if chCTe = Conhecimentos.Items[j].NumID then
                Break;
              end;

              if j = Conhecimentos.Count then
                raise EACBrLibException.Create(ErrEnvioEvento,'Não existe CTe com a chave ['+chCTe+'] carregado');
            end
            else
              j := 0;

            if trim(EventoCTe.Evento.Items[i].InfEvento.CNPJ) = '' then
              EventoCTe.Evento.Items[i].InfEvento.CNPJ := Conhecimentos.Items[j].CTe.Emit.CNPJ;

            if chCTe = '' then
              EventoCTe.Evento.Items[i].InfEvento.chCTe := Conhecimentos.Items[j].NumID;

            if trim(EventoCTe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
            begin
              if EventoCTe.Evento.Items[i].infEvento.tpEvento = teCancelamento then
              begin
                EventoCTe.Evento.Items[i].infEvento.detEvento.nProt := Conhecimentos.Items[j].CTe.procCTe.nProt;

                if trim(EventoCTe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
                begin
                  WebServices.Consulta.CTeChave := EventoCTe.Evento.Items[i].InfEvento.chCTe;

                  if not WebServices.Consulta.Executar then
                    raise EACBrLibException.Create(ErrEnvioEvento, WebServices.Consulta.Msg);

                  EventoCTe.Evento.Items[i].infEvento.detEvento.nProt := WebServices.Consulta.Protocolo;
                end;
              end;
            end;
          end;
        end;

        WebServices.EnvEvento.idLote := idLote;
        WebServices.EnvEvento.Executar;

        Resp := TEventoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
        try
          Resp.Processar(CTeDM.ACBrCTe1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      end;

      CTeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
    const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TConsultaCadastroResposta;
  AUF, ADocumento: string;
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    AUF := string(cUF);
    ADocumento := string(nDocumento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ConsultaCadastro(' + AUF + ',' + ADocumento + ',' + BoolToStr(nIE, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ConsultaCadastro', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.UF   := AUF;
        if nIE then
          CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.IE := ADocumento
        else
        begin
          if Length(ADocumento) > 11 then
            CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.CNPJ := ADocumento
          else
            CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.CPF := ADocumento;
        end;

        CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.Executar;
        Resp := TConsultaCadastroResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
        try
          Resp.Processar(CTeDM.ACBrCTe1.WebServices.ConsultaCadastro.RetConsCad);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_DistribuicaoDFePorUltNSU(const AcUFAutor: integer; eCNPJCPF, eultNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AultNSU, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    VerificarLibInicializada;

    ACNPJCPF := string(eCNPJCPF);
    AultNSU := string(eultNSU);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_DistribuicaoDFePorUltNSU(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + AultNSU + ',' + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_DistribuicaoDFePorUltNSU', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        if not ValidarCNPJ(ACNPJCPF) then
          raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

        with CTeDM do
        begin
          try
            ACBrCTe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
            ACBrCTe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
            ACBrCTe1.WebServices.DistribuicaoDFe.ultNSU   := AultNSU;
            ACBrCTe1.WebServices.DistribuicaoDFe.NSU      := '';
            ACBrCTe1.WebServices.DistribuicaoDFe.chCTe    := '';

            ACBrCTe1.WebServices.DistribuicaoDFe.Executar;

            Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
            try
              Resp.Processar(ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                             ACBrCTe1.WebServices.DistribuicaoDFe.Msg,
                             ACBrCTe1.WebServices.DistribuicaoDFe.NomeArq,
                             ACBrCTe1.WebServices.DistribuicaoDFe.ListaArqs);
              Resposta := Resp.Gerar;
            finally
              Resp.Free;
            end;

            MoverStringParaPChar(Resposta, sResposta, esTamanho);
            Result := SetRetorno(ErrOK, Resposta);
          except
            raise EACBrLibException.Create(ErrRetorno, ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt.xMotivo);
          end;
        end;
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_DistribuicaoDFePorNSU(const AcUFAutor: integer; eCNPJCPF, eNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ANSU, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    VerificarLibInicializada;

    ACNPJCPF := string(eCNPJCPF);
    ANSU := string(eNSU);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_DistribuicaoDFePorNSU(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + ANSU + ',' + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_DistribuicaoDFePorNSU', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
        if not ValidarCNPJ(ACNPJCPF) then
          raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

        with CTeDM do
        begin
          try
            ACBrCTe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
            ACBrCTe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
            ACBrCTe1.WebServices.DistribuicaoDFe.ultNSU   := '';
            ACBrCTe1.WebServices.DistribuicaoDFe.NSU      := ANSU;
            ACBrCTe1.WebServices.DistribuicaoDFe.chCTe    := '';

            ACBrCTe1.WebServices.DistribuicaoDFe.Executar;

            Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
            try
              Resp.Processar(ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                             ACBrCTe1.WebServices.DistribuicaoDFe.Msg,
                             ACBrCTe1.WebServices.DistribuicaoDFe.NomeArq,
                             ACBrCTe1.WebServices.DistribuicaoDFe.ListaArqs);
              Resposta := Resp.Gerar;
            finally
              Resp.Free;
            end;

            MoverStringParaPChar(Resposta, sResposta, esTamanho);
            Result := SetRetorno(ErrOK, Resposta);
          except
            raise EACBrLibException.Create(ErrRetorno, ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt.xMotivo);
          end;
        end;
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_DistribuicaoDFePorChave(const AcUFAutor: integer; eCNPJCPF, echCTe: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AchCTe, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    VerificarLibInicializada;

    ACNPJCPF := string(eCNPJCPF);
    AchCTe := string(echCTe);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_DistribuicaoDFePorChave(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + AchCTe + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_DistribuicaoDFePorChave', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      try
      if not ValidarCNPJ(ACNPJCPF) then
        raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

      if not ValidarChave(AchCTe) then
        raise EACBrLibException.Create(ErrChaveCTe, Format(SErrChaveInvalida, [AchCTe]));

      with CTeDM do
      begin
        try
          ACBrCTe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
          ACBrCTe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
          ACBrCTe1.WebServices.DistribuicaoDFe.ultNSU   := '';
          ACBrCTe1.WebServices.DistribuicaoDFe.NSU      := '';
          ACBrCTe1.WebServices.DistribuicaoDFe.chCTe    := AchCTe;

          ACBrCTe1.WebServices.DistribuicaoDFe.Executar;

          Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                           ACBrCTe1.WebServices.DistribuicaoDFe.Msg,
                           ACBrCTe1.WebServices.DistribuicaoDFe.NomeArq,
                           ACBrCTe1.WebServices.DistribuicaoDFe.ListaArqs);
            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        except
          raise EACBrLibException.Create(ErrRetorno, ACBrCTe1.WebServices.DistribuicaoDFe.retDistDFeInt.xMotivo);
        end;
      end;
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_EnviarEmail(const ePara, eChaveCTe: PChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  APara, AChaveCTe, AAssunto, ACC, AAnexos, AMensagem: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
begin
  try
    VerificarLibInicializada;

    APara := string(ePara);
    AChaveCTe := string(eChaveCTe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_EnviarEmail(' + APara + ',' + AChaveCTe + ',' +
         BoolToStr(AEnviaPDF, 'PDF','') + ',' + AAssunto + ',' + ACC + ',' +
         AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_EnviarEmail', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      with CTeDM.ACBrCTe1 do
      begin
        EhArquivo := StringEhArquivo(AChaveCTe);

        if EhArquivo then
          VerificarArquivoExiste(AChaveCTe);

        if EhArquivo then
          Conhecimentos.LoadFromFile(AchaveCTe);

        if Conhecimentos.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio, Format(SInfCTeCarregados, [Conhecimentos.Count]))
        else
        begin
          slMensagemEmail := TStringList.Create;
          slCC := TStringList.Create;
          slAnexos := TStringList.Create;
          try
            with mail do
            begin
              slMensagemEmail.DelimitedText:= sLineBreak;
              slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

              slCC.DelimitedText:= sLineBreak;
              slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.DelimitedText := sLineBreak;
              slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

              if AEnviaPDF then
                CTeDM.ConfigurarImpressao('', True);

              try
                CTeDM.ACBrCTe1.Conhecimentos.Items[0].EnviarEmail(
                  APara,
                  AAssunto,
                  slMensagemEmail,
                  AEnviaPDF, // Enviar PDF junto
                  slCC,      // Lista com emails que serão enviado cópias - TStrings
                  slAnexos); // Lista de slAnexos - TStrings

                Result := SetRetorno(ErrOK, 'Email enviado com sucesso');
              except
                on E: Exception do
                  raise EACBrLibException.Create(ErrRetorno, 'Erro ao enviar email' + sLineBreak + E.Message);
              end;
            end;
          finally
            slCC.Free;
            slAnexos.Free;
            slMensagemEmail.Free;
          end;
        end;
      end;

      CTeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_EnviarEmailEvento(const ePara, eChaveEvento, eChaveCTe: PChar;
  const AEnviaPDF: Boolean; const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  APara, AChaveEvento, AChaveCTe, AAssunto, ACC, AAnexos, AMensagem,
  ArqPDF: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
begin
  try
    VerificarLibInicializada;

    APara := string(ePara);
    AChaveEvento := string(eChaveEvento);
    AChaveCTe := string(eChaveCTe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_EnviarEmailEvento(' + APara + ',' + AChaveEvento + ',' +
         AChaveCTe + ',' + BoolToStr(AEnviaPDF, 'PDF','') + ',' + AAssunto + ',' +
         ACC + ',' + AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_EnviarEmailEvento', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      with CTeDM.ACBrCTe1 do
      begin
        EventoCTe.Evento.Clear;
        Conhecimentos.Clear;

        EhArquivo := StringEhArquivo(AChaveEvento);

        if EhArquivo then
          VerificarArquivoExiste(AChaveEvento);

        if EhArquivo then
          EventoCTe.LerXML(AChaveEvento);

        EhArquivo := StringEhArquivo(AChaveCTe);

        if EhArquivo then
          VerificarArquivoExiste(AChaveCTe);

        if EhArquivo then
          Conhecimentos.LoadFromFile(AchaveCTe);

        if EventoCTe.Evento.Count = 0 then
          raise EACBrLibException.Create(ErrEnvio,
                  Format(SInfEventosCarregados, [EventoCTe.Evento.Count]))
        else
        begin
          slMensagemEmail := TStringList.Create;
          slCC := TStringList.Create;
          slAnexos := TStringList.Create;
          try
            if AEnviaPDF then
            begin
              try
                CTeDM.ConfigurarImpressao('', True);
                ImprimirEventoPDF;

                ArqPDF := OnlyNumber(EventoCTe.Evento[0].Infevento.id);
                ArqPDF := PathWithDelim(DACTe.PathPDF)+ArqPDF+'-procEventoCTe.pdf';
              except
                raise EACBrLibException.Create(ErrRetorno, 'Erro ao criar o arquivo PDF');
              end;
            end;

            with mail do
            begin
              slMensagemEmail.DelimitedText:= sLineBreak;
              slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

              slCC.DelimitedText:= sLineBreak;
              slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.DelimitedText := sLineBreak;
              slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

              slAnexos.Add(AChaveEvento);

              if AEnviaPDF then
                slAnexos.Add(ArqPDF);

              try
                CTeDM.ACBrCTe1.EnviarEmail(
                  APara,
                  AAssunto,
                  slMensagemEmail,
                  slCC,      // Lista com emails que serão enviado cópias - TStrings
                  slAnexos); // Lista de slAnexos - TStrings

                Result := SetRetorno(ErrOK, 'Email enviado com sucesso');
              except
                on E: Exception do
                  raise EACBrLibException.Create(ErrRetorno, 'Erro ao enviar email' + sLineBreak + E.Message);
              end;
            end;
          finally
            slCC.Free;
            slAnexos.Free;
            slMensagemEmail.Free;
          end;
        end;
      end;

      CTeDM.Destravar;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_Imprimir(const cImpressora: PChar; nNumCopias: Integer; const cProtocolo,
  bMostrarPreview: PChar): longint; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: TLibImpressaoResposta;
  NumCopias: Integer;
  Impressora, Protocolo,
  MostrarPreview: String;
begin
  try
    VerificarLibInicializada;

    Impressora := String(cImpressora);
    Protocolo := String(cProtocolo);
    MostrarPreview := String(bMostrarPreview);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_Imprimir(' + Impressora + ',' + IntToStr(nNumCopias) + ','
        + Protocolo + ',' + MostrarPreview + ')', logCompleto, True)
    else
      pLib.GravarLog('CTE_Imprimir', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      Resposta := TLibImpressaoResposta.Create(CTeDM.ACBrCTe1.Conhecimentos.Count, pLib.Config.TipoResposta,
                                               pLib.Config.CodResposta);

      try
        CTeDM.ConfigurarImpressao(Impressora, False, Protocolo, MostrarPreview);

        NumCopias := CTeDM.ACBrCTe1.DACTE.NumCopias;
        if nNumCopias > 0 then
          CTeDM.ACBrCTe1.DACTE.NumCopias := nNumCopias;

        CTeDM.ACBrCTe1.Conhecimentos.Imprimir;
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        CTeDM.ACBrCTe1.DACTE.NumCopias := NumCopias;
        Resposta.Free;
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ImprimirPDF: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('CTE_ImprimirPDF', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;
      try
        CTeDM.ConfigurarImpressao('', True);
        CTeDM.ACBrCTe1.Conhecimentos.ImprimirPDF;
        Result := SetRetornoCTesCarregados(CTeDM.ACBrCTe1.Conhecimentos.Count);
      finally
        CTeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ImprimirEvento(const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXmlCTe: string;
  AArquivoXmlEvento: string;
begin
  try
    VerificarLibInicializada;

    AArquivoXmlCTe := string(eArquivoXmlCTe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ImprimirEvento(' + AArquivoXmlCTe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ImprimirEvento', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      EhArquivo := StringEhArquivo(AArquivoXmlCTe);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlCTe);

      if EhArquivo then
        CTeDM.ACBrCTe1.Conhecimentos.LoadFromFile(AArquivoXmlCTe);

      EhArquivo := StringEhArquivo(AArquivoXmlEvento);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlEvento);

      if EhArquivo then
        CTeDM.ACBrCTe1.EventoCTe.LerXML(AArquivoXmlEvento);

      CTeDM.ConfigurarImpressao;
      CTeDM.ACBrCTe1.ImprimirEvento;

      Result := SetRetorno(ErrOK);
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ImprimirEventoPDF(const eArquivoXmlCTe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXmlCTe: string;
  AArquivoXmlEvento: string;
begin
  try
    VerificarLibInicializada;

    AArquivoXmlCTe := string(eArquivoXmlCTe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ImprimirEventoPDF(' + AArquivoXmlCTe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ImprimirEventoPDF', logNormal);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      EhArquivo := StringEhArquivo(AArquivoXmlCTe);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlCTe);

      if EhArquivo then
        CTeDM.ACBrCTe1.Conhecimentos.LoadFromFile(AArquivoXmlCTe);

      EhArquivo := StringEhArquivo(AArquivoXmlEvento);

      if EhArquivo then
        VerificarArquivoExiste(AArquivoXmlEvento);

      if EhArquivo then
        CTeDM.ACBrCTe1.EventoCTe.LerXML(AArquivoXmlEvento);

      CTeDM.ConfigurarImpressao('', True);
      CTeDM.ACBrCTe1.ImprimirEventoPDF;

      Result := SetRetorno(ErrOK);
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ImprimirInutilizacao(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXml: string;
begin
  try
    VerificarLibInicializada;

    AArquivoXml := string(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ImprimirInutilizacao(' + AArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ImprimirInutilizacao', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      if EhArquivo then
        CTeDM.ACBrCTe1.InutCTe.LerXML(AArquivoXml);

      CTeDM.ConfigurarImpressao;
      CTeDM.ACBrCTe1.ImprimirInutilizacao;

      Result := SetRetorno(ErrOK);
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function CTE_ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXml: string;
begin
  try
    VerificarLibInicializada;

    AArquivoXml := string(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('CTE_ImprimirInutilizacaoPDF(' + AArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('CTE_ImprimirInutilizacaoPDF', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    with TACBrLibCTe(pLib) do
    begin
      CTeDM.Travar;

      if EhArquivo then
        CTeDM.ACBrCTe1.InutCTe.LerXML(AArquivoXml);

      CTeDM.ConfigurarImpressao('', True);
      CTeDM.ACBrCTe1.ImprimirInutilizacaoPDF;

      Result := SetRetorno(ErrOK);
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

{%endregion}

initialization
  pLibClass := TACBrLibCTe;

end.
