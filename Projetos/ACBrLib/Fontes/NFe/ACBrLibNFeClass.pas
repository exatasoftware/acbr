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

unit ACBrLibNFeClass;

interface

uses
  Classes, SysUtils, Forms,
  ACBrLibComum, ACBrLibNFeDataModule;

type

  { TACBrLibNFe }

  TACBrLibNFe = class(TACBrLib)
  private
    FNFeDM: TLibNFeDM;

  protected
    procedure Inicializar; override;
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    procedure Executar; override;
  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property NFeDM: TLibNFeDM read FNFeDM;
  end;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function NFE_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region NFe}
function NFE_CarregarXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_CarregarINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ObterXml(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_GravarXml(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ObterIni(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_GravarIni(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_CarregarEventoXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_CarregarEventoINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_LimparLista: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_LimparListaEventos: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Assinar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Validar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ValidarRegrasdeNegocios(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_VerificarAssinatura(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_GerarChave(ACodigoUF, ACodigoNumerico, AModelo, ASerie, ANumero, ATpEmi: longint;
  AEmissao, ACNPJCPF: PChar; const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_GetPath(ATipo: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_GetPathEvento(ACodEvento: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Servicos}
function NFE_StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Consultar(const eChaveOuNFe: PChar; AExtrairEventos: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Inutilizar(const ACNPJ, AJustificativa: PChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Enviar(ALote: Integer; AImprimir, ASincrono, AZipado: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConsultarRecibo(ARecibo: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Cancelar(const eChave, eJustificativa, eCNPJCPF: PChar; ALote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_EnviarEvento(idLote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_DistribuicaoDFePorUltNSU(const AcUFAutor: integer; eCNPJCPF, eultNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_DistribuicaoDFePorNSU(const AcUFAutor: integer; eCNPJCPF, eNSU: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_DistribuicaoDFePorChave(const AcUFAutor: integer; eCNPJCPF, echNFe: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_EnviarEmail(const ePara, eChaveNFe: PChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_EnviarEmailEvento(const ePara, eChaveEvento, eChaveNFe: PChar;
  const AEnviaPDF: Boolean; const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_Imprimir(const cImpressora: PChar; nNumCopias: Integer; const cProtocolo,
  bMostrarPreview, cMarcaDagua, bViaConsumidor, bSimplificado: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImprimirPDF: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImprimirEvento(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImprimirEventoPDF(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImprimirInutilizacao(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function NFE_ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrLibConsts, ACBrLibNFeConsts, ACBrLibConfig,
  ACBrLibResposta, ACBrLibDistribuicaoDFe, ACBrLibConsReciDFe,
  ACBrLibConsultaCadastro, ACBrLibNFeConfig, ACBrLibNFeRespostas,
  ACBrDFeUtil, ACBrNFe, ACBrMail, ACBrUtil, ACBrLibCertUtils,
  pcnConversao, pcnConversaoNFe, pcnAuxiliar, blcksock;

{ TACBrLibNFe }

constructor TACBrLibNFe.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);
  FNFeDM := TLibNFeDM.Create(nil);
end;

destructor TACBrLibNFe.Destroy;
begin
  FNFeDM.Free;

  inherited Destroy;
end;

procedure TACBrLibNFe.Inicializar;
begin
  GravarLog('TACBrLibNFe.Inicializar', logNormal);

  FNFeDM.CriarACBrMail;
  FNFeDM.CriarACBrPosPrinter;

  GravarLog('TACBrLibNFe.Inicializar - Feito', logParanoico);

  inherited Inicializar;
end;

procedure TACBrLibNFe.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibNFeConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibNFe.Executar;
begin
  inherited Executar;
  FNFeDM.AplicarConfiguracoes;
end;

{%region NFe}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}

function NFE_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(eArqConfig, eChaveCrypt);
end;

function NFE_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar;
end;

function NFE_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(sNome, esTamanho);
end;

function NFE_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(sVersao, esTamanho);
end;

function NFE_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(sMensagem, esTamanho);
end;

function NFE_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ImportarConfig(eArqConfig);
end;

function NFE_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(eArqConfig);
end;

function NFE_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(eArqConfig);
end;

function NFE_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(eSessao, eChave, sValor, esTamanho);
end;

function NFE_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(eSessao, eChave, eValor);
end;

{%endregion}

function NFE_CarregarXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuXml := string(eArquivoOuXML);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_CarregarXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_CarregarXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if EhArquivo then
          NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(ArquivoOuXml)
        else
          NFeDM.ACBrNFe1.NotasFiscais.LoadFromString(ArquivoOuXml);

        Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_CarregarINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoOuINI: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuINI := string(eArquivoOuINI);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_CarregarINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_CarregarINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromIni(ArquivoOuINI);
        Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ObterXml(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: String;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_ObterXml(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_ObterXml', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
          NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

        Resposta := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_GravarXml(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  ANomeArquivo, APathArquivo: String;
begin
  try
    VerificarLibInicializada;
    ANomeArquivo := String(eNomeArquivo);
    APathArquivo := String(ePathArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_GravarXml(' + IntToStr(AIndex) + ',' + ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_GravarXml', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GravarXML(ANomeArquivo, APathArquivo) then
          Result := SetRetorno(ErrOK)
        else
          Result := SetRetorno(ErrGerarXml);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ObterIni(AIndex: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: String;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_ObterIni(' + IntToStr(AIndex) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_ObterIni', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
          NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

        Resposta := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarNFeIni;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_GravarIni(AIndex: longint; const eNomeArquivo, ePathArquivo: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  ANFeIni, ANomeArquivo, APathArquivo: String;
begin
  try
    VerificarLibInicializada;
    ANomeArquivo := String(eNomeArquivo);
    APathArquivo := String(ePathArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_GravarIni(' + IntToStr(AIndex) + ',' + ANomeArquivo + ',' + APathArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_GravarIni', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if (NFeDM.ACBrNFe1.NotasFiscais.Count < 1) or (AIndex < 0) or (AIndex >= NFeDM.ACBrNFe1.NotasFiscais.Count) then
          raise EACBrLibException.Create(ErrIndex, Format(SErrIndex, [AIndex]));

        ANomeArquivo := ExtractFileName(ANomeArquivo);

        if EstaVazio(ANomeArquivo) then
          raise EACBrLibException.Create(ErrExecutandoMetodo, 'Nome de arquivo não informado');

        if EstaVazio(APathArquivo) then
          APathArquivo := ExtractFilePath(ANomeArquivo);
        if EstaVazio(APathArquivo) then
          APathArquivo := NFeDM.ACBrNFe1.Configuracoes.Arquivos.PathSalvar;

        APathArquivo := PathWithDelim(APathArquivo);

        if EstaVazio(NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].XMLOriginal) then
          NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarXML;

        ANFeIni := NFeDM.ACBrNFe1.NotasFiscais.Items[AIndex].GerarNFeIni;

        if not DirectoryExists(APathArquivo) then
          ForceDirectories(APathArquivo);

        WriteToTXT(APathArquivo + ANomeArquivo, ANFeIni, False, False);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_CarregarEventoXML(const eArquivoOuXML: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  ArquivoOuXml: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuXml := string(eArquivoOuXML);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_CarregarEventoXML(' + ArquivoOuXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_CarregarEventoXML', logNormal);

    EhArquivo := StringEhArquivo(ArquivoOuXml);
    if EhArquivo then
      VerificarArquivoExiste(ArquivoOuXml);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        if EhArquivo then
          NFeDM.ACBrNFe1.EventoNFe.LerXML(ArquivoOuXml)
        else
          NFeDM.ACBrNFe1.EventoNFe.LerXMLFromString(ArquivoOuXml);

        Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_CarregarEventoINI(const eArquivoOuINI: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoOuINI: string;
begin
  try
    VerificarLibInicializada;
    ArquivoOuINI := string(eArquivoOuINI);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_CarregarEventoINI(' + ArquivoOuINI + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_CarregarEventoINI', logNormal);

    if StringEhArquivo(ArquivoOuINI) then
      VerificarArquivoExiste(ArquivoOuINI);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        NFeDM.ACBrNFe1.EventoNFe.LerFromIni(ArquivoOuINI, False);
        Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_LimparLista: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_LimparLista', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        NFeDM.ACBrNFe1.NotasFiscais.Clear;
        Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_LimparListaEventos: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_LimparListaEventos', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        NFeDM.ACBrNFe1.EventoNFe.Evento.Clear;
        Result := SetRetornoEventoCarregados(NFeDM.ACBrNFe1.EventoNFe.Evento.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Assinar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFe_Assinar', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        try
          NFeDM.ACBrNFe1.NotasFiscais.Assinar;
        except
          on E: EACBrNFeException do
            Result := SetRetorno(ErrAssinarNFe, E.Message);
        end;
        Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Validar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_Validar', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        try
          NFeDM.ACBrNFe1.NotasFiscais.Validar;
        except
          on E: EACBrNFeException do
            Result := SetRetorno(ErrValidacaoNFe, E.Message);
        end;
        Result := SetRetornoNFeCarregadas(NFeDM.ACBrNFe1.NotasFiscais.Count);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ValidarRegrasdeNegocios(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Erros: string;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_ValidarRegrasdeNegocios', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        Erros := '';
        NFeDM.ACBrNFe1.NotasFiscais.ValidarRegrasdeNegocios(Erros);
        MoverStringParaPChar(Erros, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Erros);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_VerificarAssinatura(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Erros: string;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_VerificarAssinatura', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        Erros := '';
        NFeDM.ACBrNFe1.NotasFiscais.VerificarAssinatura(Erros);
        MoverStringParaPChar(Erros, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Erros);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_GerarChave(ACodigoUF, ACodigoNumerico, AModelo, ASerie, ANumero, ATpEmi: longint;
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
      pLib.GravarLog('NFE_GerarChave(' + IntToStr(ACodigoUF) + ',' + IntToStr(ACodigoNumerico) + ',' +
                      IntToStr(AModelo)  + ',' + IntToStr(AModelo) + ',' + IntToStr(ASerie) + ',' +
                      IntToStr(ANumero) + ',' + IntToStr(ATpEmi) + ',' + DateToStr(Emissao) + ',' +
                      CNPJCPF + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_GerarChave', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        Resposta := '';
        Resposta := GerarChaveAcesso(ACodigoUF, Emissao, CNPJCPF, ASerie, ANumero, ATpEmi, ACodigoNumerico, AModelo);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ObterCertificados(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('NFE_ObterCertificados', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        Resposta := '';
        Resposta := ObterCerticados(NFeDM.ACBrNFe1.SSL);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_GetPath(ATipo: longint; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: string;
  ok: Boolean;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_GetPath(' + IntToStr(ATipo) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_GetPath', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        with NFeDM do
        begin
          Resposta := '';

          case ATipo of
            0: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathNFe();
            1: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathInu();
            2: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(teCCe);
            3: Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(teCancelamento);
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_GetPathEvento(ACodEvento: PChar; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta, CodEvento: string;
  ok: Boolean;
begin
  try
    VerificarLibInicializada;

    CodEvento := String(ACodEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_GetPathEvento(' + CodEvento +' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_GetPathEvento', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        with NFeDM do
        begin
          Resposta := '';
          Resposta := ACBrNFe1.Configuracoes.Arquivos.GetPathEvento(StrToTpEventoNFe(ok, CodEvento));
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
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

function NFE_StatusServico(const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TStatusServicoResposta;
  Resposta: String;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFE_StatusServico', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.ValidarIntegradorNFCe;
      NFeDM.Travar;
      Resp := TStatusServicoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with NFeDM.ACBrNFe1 do
        begin
          WebServices.StatusServico.Executar;

          Resp.Processar(NFeDM.ACBrNFe1);
          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        Resp.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Consultar(const eChaveOuNFe: PChar; AExtrairEventos: Boolean; const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  ChaveOuNFe: string;
  Resp: TConsultaNFeResposta;
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    ChaveOuNFe := string(eChaveOuNFe);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_Consultar(' + ChaveOuNFe + ', ' + BoolToStr(AExtrairEventos, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_Consultar', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      EhArquivo := StringEhArquivo(ChaveOuNFe);

      if EhArquivo and not ValidarChave(ChaveOuNFe) then
      begin
        VerificarArquivoExiste(ChaveOuNFe);
        NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(ChaveOuNFe);
      end;

      if NFeDM.ACBrNFe1.NotasFiscais.Count = 0 then
      begin
        if ValidarChave(ChaveOuNFe) then
          NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := ChaveOuNFe
        else
          raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [ChaveOuNFe]));
      end
      else
        NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := NFeDM.ACBrNFe1.NotasFiscais.Items[NFeDM.ACBrNFe1.NotasFiscais.Count - 1].NumID;

      NFeDM.ACBrNFe1.WebServices.Consulta.ExtrairEventos := AExtrairEventos;
      Resp := TConsultaNFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with NFeDM.ACBrNFe1 do
        begin
          WebServices.Consulta.Executar;
          Resp.Processar(NFeDM.ACBrNFe1);

          Resposta := Resp.Gerar;
          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        Resp.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Inutilizar(const ACNPJ, AJustificativa: PChar;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TInutilizarNFeResposta;
  Resposta, CNPJ, Justificativa: string;
begin
  try
    VerificarLibInicializada;

    Justificativa := string(AJustificativa);
    CNPJ := string(ACNPJ);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_InutilizarNFe(' + CNPJ + ',' + Justificativa + ',' + IntToStr(Ano) + ',' +
        IntToStr(modelo) + ',' + IntToStr(Serie) +  ',' + IntToStr(NumeroInicial) +  ',' +
        IntToStr(NumeroFinal) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_InutilizarNFe', logNormal);

    CNPJ := OnlyNumber(CNPJ);

    if not ValidarCNPJ(CNPJ) then
       raise EACBrNFeException.Create('CNPJ: ' + CNPJ + ', inválido.');

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resp := TInutilizarNFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        with NFeDM.ACBrNFe1 do
        begin
          with WebServices do
          begin
            Inutilizacao.CNPJ := CNPJ;
            Inutilizacao.Justificativa := Justificativa;
            Inutilizacao.Modelo := Modelo;
            Inutilizacao.Serie := Serie;
            Inutilizacao.Ano := Ano;
            Inutilizacao.NumeroInicial := NumeroInicial;
            Inutilizacao.NumeroFinal := NumeroFinal;

            Inutilizacao.Executar;
            Resp.Processar(NFeDM.ACBrNFe1);
            Resposta := Resp.Gerar;
            MoverStringParaPChar(Resposta, sResposta, esTamanho);
            Result := SetRetorno(ErrOK, Resposta);
          end;
        end;
      finally
        Resp.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Enviar(ALote: Integer; AImprimir, ASincrono, AZipado: Boolean;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: String;
  RespEnvio: TEnvioResposta;
  RespRetorno: TRetornoResposta;
  ImpResp: TLibImpressaoResposta;
  i, ImpCount: Integer;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_Enviar(' + IntToStr(ALote) + ',' +
                     BoolToStr(AImprimir, 'Imprimir','') +
                     BoolToStr(ASincrono, 'Sincrono','') +
                     BoolToStr(AZipado, 'Zipado','') + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_Enviar', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        with NFeDM.ACBrNFe1 do
        begin
          if NotasFiscais.Count <= 0 then
            raise EACBrLibException.Create(ErrEnvio, 'ERRO: Nenhuma NF-e adicionada ao Lote');

          if NotasFiscais.Count > 50 then
            raise EACBrLibException.Create(ErrEnvio, 'ERRO: Conjunto de NF-e transmitidas (máximo de 50 NF-e)' +
              ' excedido. Quantidade atual: ' + IntToStr(NotasFiscais.Count));

          NFeDM.ValidarIntegradorNFCe;

          Resposta := '';
          WebServices.Enviar.Clear;
          WebServices.Retorno.Clear;

          NotasFiscais.Assinar;
          NotasFiscais.Validar;

          if (ALote = 0) then
            WebServices.Enviar.Lote := '1'
          else
            WebServices.Enviar.Lote := IntToStr(ALote);

          WebServices.Enviar.Sincrono := ASincrono;
          WebServices.Enviar.Zipado := AZipado;
          WebServices.Enviar.Executar;

          RespEnvio := TEnvioResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            RespEnvio.Processar(NFeDM.ACBrNFe1);
            Resposta := RespEnvio.Gerar;
          finally
            RespEnvio.Free;
          end;

          if not ASincrono or ((NaoEstaVazio(WebServices.Enviar.Recibo)) and (WebServices.Enviar.cStat = 103)) then
          begin
            WebServices.Retorno.Recibo := WebServices.Enviar.Recibo;
            WebServices.Retorno.Executar;

            RespRetorno := TRetornoResposta.Create('NFe', pLib.Config.TipoResposta, pLib.Config.CodResposta);
            try
              RespRetorno.Processar(WebServices.Retorno.NFeRetorno,
                                    WebServices.Retorno.Recibo,
                                    WebServices.Retorno.Msg,
                                    WebServices.Retorno.Protocolo,
                                    WebServices.Retorno.ChaveNFe);

              Resposta := Resposta + sLineBreak + RespRetorno.Gerar;
            finally
              RespRetorno.Free;
            end;
          end;

          if AImprimir then
          begin
            NFeDM.ConfigurarImpressao();

            ImpCount := 0;
            for I := 0 to NotasFiscais.Count - 1 do
            begin
              if NotasFiscais.Items[I].Confirmada then
              begin
                NotasFiscais.Items[I].Imprimir;
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

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ConsultarRecibo(ARecibo: PChar; const sResposta: PChar; var esTamanho: longint): longint;
var
  Resp: TReciboResposta;
  sRecibo, Resposta: string;
begin
  try
    VerificarLibInicializada;

    sRecibo := string(ARecibo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFE_ConsultarRecibo(' + sRecibo + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_ConsultarRecibo', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        with NFeDM.ACBrNFe1 do
        begin
          WebServices.Recibo.Recibo := sRecibo;
          WebServices.Recibo.Executar;

          Resp := TReciboResposta.Create('NFe', pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(WebServices.Recibo.NFeRetorno,
                           WebServices.Recibo.Recibo);

            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Cancelar(const eChave, eJustificativa, eCNPJCPF: PChar; ALote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AChave, AJustificativa, ACNPJCPF: string;
  Resp: TCancelamentoResposta;
  Resposta: string;
begin
  try
    VerificarLibInicializada;

    AChave := string(eChave);
    AJustificativa := string(eJustificativa);
    ACNPJCPF := string(eCNPJCPF);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_Cancelar(' + AChave + ',' + AJustificativa + ',' +
                        ACNPJCPF + ',' + IntToStr(ALote) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_Cancelar', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        if not ValidarChave(AChave) then
          raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [AChave]))
        else
          NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave := AChave;

        if not NFeDM.ACBrNFe1.WebServices.Consulta.Executar then
          raise EACBrLibException.Create(ErrConsulta, NFeDM.ACBrNFe1.WebServices.Consulta.Msg);

        NFeDM.ACBrNFe1.EventoNFe.Evento.Clear;

        with NFeDM.ACBrNFe1.EventoNFe.Evento.New do
        begin
          Infevento.CNPJ := ACNPJCPF;
          if Trim(Infevento.CNPJ) = '' then
            Infevento.CNPJ := copy(OnlyNumber(NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave), 7, 14)
          else
          begin
            if not ValidarCNPJouCPF(ACNPJCPF) then
              raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));
          end;

          Infevento.nSeqEvento := 1;
          InfEvento.tpAmb := NFeDM.ACBrNFe1.Configuracoes.WebServices.Ambiente;
          Infevento.cOrgao := StrToIntDef(copy(OnlyNumber(NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave), 1, 2), 0);
          Infevento.dhEvento := now;
          Infevento.tpEvento := teCancelamento;
          Infevento.chNFe := NFeDM.ACBrNFe1.WebServices.Consulta.NFeChave;
          Infevento.detEvento.nProt := NFeDM.ACBrNFe1.WebServices.Consulta.Protocolo;
          Infevento.detEvento.xJust := AJustificativa;
        end;

        if (ALote = 0) then
            ALote := 1;

        NFeDM.ACBrNFe1.WebServices.EnvEvento.idLote := ALote;
        NFeDM.ACBrNFe1.WebServices.EnvEvento.Executar;

        Resp := TCancelamentoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
        try
          Resp.Processar(NFeDM.ACBrNFe1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_EnviarEvento(idLote: Integer;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  i, j: integer;
  Resp: TEventoResposta;
  Resposta, chNfe: String;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_EnviarEvento(' + IntToStr(idLote) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_EnviarEvento', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        with NFeDM.ACBrNFe1 do
        begin
          if EventoNFe.Evento.Count = 0 then
            raise EACBrLibException.Create(ErrEnvioEvento, 'ERRO: Nenhum Evento adicionado ao Lote');

          if EventoNFe.Evento.Count > 20 then
            raise EACBrLibException.Create(ErrEnvioEvento, 'ERRO: Conjunto de Eventos transmitidos (máximo de 20) ' +
                                                           'excedido. Quantidade atual: ' +
                                                           IntToStr(EventoNFe.Evento.Count));

          {Atribuir nSeqEvento, CNPJ, Chave e/ou Protocolo quando não especificar}
          for i := 0 to EventoNFe.Evento.Count - 1 do
          begin
            if EventoNFe.Evento.Items[i].InfEvento.nSeqEvento = 0 then
              EventoNFe.Evento.Items[i].infEvento.nSeqEvento := 1;

            EventoNFe.Evento.Items[i].InfEvento.tpAmb := Configuracoes.WebServices.Ambiente;

            if NotasFiscais.Count > 0 then
            begin
              chNfe := OnlyNumber(EventoNFe.Evento.Items[i].InfEvento.chNfe);

              // Se tem a chave da NFe no Evento, procure por ela nas notas carregadas //
              if NaoEstaVazio(chNfe) then
              begin
                For j := 0 to NotasFiscais.Count - 1 do
                begin
                  if chNfe = NotasFiscais.Items[j].NumID then
                  Break;
                end ;

                if j = NotasFiscais.Count then
                  raise EACBrLibException.Create(ErrEnvioEvento, 'Não existe NFe com a chave ['+chNfe+'] carregada');
              end
              else
              j := 0;

              if trim(EventoNFe.Evento.Items[i].InfEvento.CNPJ) = '' then
                EventoNFe.Evento.Items[i].InfEvento.CNPJ := NotasFiscais.Items[j].NFe.Emit.CNPJCPF;

              if chNfe = '' then
                EventoNFe.Evento.Items[i].InfEvento.chNfe := NotasFiscais.Items[j].NumID;

              if trim(EventoNFe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
              begin
                if EventoNFe.Evento.Items[i].infEvento.tpEvento = teCancelamento then
                begin
                  EventoNFe.Evento.Items[i].infEvento.detEvento.nProt := NotasFiscais.Items[j].NFe.procNFe.nProt;

                  if trim(EventoNFe.Evento.Items[i].infEvento.detEvento.nProt) = '' then
                  begin
                    WebServices.Consulta.NFeChave := EventoNFe.Evento.Items[i].InfEvento.chNfe;

                    if not WebServices.Consulta.Executar then
                      raise EACBrLibException.Create(ErrEnvioEvento, WebServices.Consulta.Msg);

                    EventoNFe.Evento.Items[i].infEvento.detEvento.nProt := WebServices.Consulta.Protocolo;
                  end;
                end;
              end;
            end;
          end;

          if (idLote = 0) then
            idLote := 1;

          WebServices.EnvEvento.idLote := idLote;
          WebServices.EnvEvento.Executar;
        end;

        try
          Resp := TEventoResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          Resp.Processar(NFeDM.ACBrNFe1);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);
    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ConsultaCadastro(cUF, nDocumento: PChar; nIE: boolean;
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
      pLib.GravarLog('NFE_ConsultaCadastro(' + AUF + ',' + ADocumento + ',' + BoolToStr(nIE, True) + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFE_ConsultaCadastro', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.UF   := AUF;
        if nIE then
          NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.IE := ADocumento
        else
        begin
          if Length(ADocumento) > 11 then
            NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.CNPJ := ADocumento
          else
            NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.CPF := ADocumento;
        end;

        NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.Executar;
        Resp := TConsultaCadastroResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
        try
          Resp.Processar(NFeDM.ACBrNFe1.WebServices.ConsultaCadastro.RetConsCad);
          Resposta := Resp.Gerar;
        finally
          Resp.Free;
        end;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_DistribuicaoDFePorUltNSU(const AcUFAutor: integer; eCNPJCPF, eultNSU: PChar;
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
      pLib.GravarLog('NFe_DistribuicaoDFePorUltNSU(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + AultNSU + ')', logCompleto, True)
    else
      pLib.GravarLog('NFe_DistribuicaoDFePorUltNSU', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        if not ValidarCNPJ(ACNPJCPF) then
          raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

        with NFeDM do
        begin
          ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
          ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
          ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU   := AultNSU;
          ACBrNFe1.WebServices.DistribuicaoDFe.NSU      := '';
          ACBrNFe1.WebServices.DistribuicaoDFe.chNFe    := '';

          ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

          Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                           ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                           ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                           ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_DistribuicaoDFePorNSU(const AcUFAutor: integer; eCNPJCPF, eNSU: PChar;
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
      pLib.GravarLog('NFe_DistribuicaoDFePorNSU(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + ANSU + ')', logCompleto, True)
    else
      pLib.GravarLog('NFe_DistribuicaoDFePorNSU', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        if not ValidarCNPJ(ACNPJCPF) then
          raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

        with NFeDM do
        begin
          ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
          ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
          ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU   := '';
          ACBrNFe1.WebServices.DistribuicaoDFe.NSU      := ANSU;
          ACBrNFe1.WebServices.DistribuicaoDFe.chNFe    := '';

          ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

          Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                           ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                           ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                           ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_DistribuicaoDFePorChave(const AcUFAutor: integer; eCNPJCPF, echNFe: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  AchNFe, ACNPJCPF: string;
  Resposta: string;
  Resp: TDistribuicaoDFeResposta;
begin
  try
    VerificarLibInicializada;

    ACNPJCPF := string(eCNPJCPF);
    AchNFe := string(echNFe);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_DistribuicaoDFePorChave(' + IntToStr(AcUFAutor) + ',' +
                     ACNPJCPF + ',' + AchNFe + ')', logCompleto, True)
    else
      pLib.GravarLog('NFe_DistribuicaoDFePorChave', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;

      try
        if not ValidarCNPJ(ACNPJCPF) then
          raise EACBrLibException.Create(ErrCNPJ, Format(SErrCNPJCPFInvalido, [ACNPJCPF]));

        if not ValidarChave(AchNFe) then
          raise EACBrLibException.Create(ErrChaveNFe, Format(SErrChaveInvalida, [AchNFe]));

        with NFeDM do
        begin
          ACBrNFe1.WebServices.DistribuicaoDFe.cUFAutor := AcUFAutor;
          ACBrNFe1.WebServices.DistribuicaoDFe.CNPJCPF  := ACNPJCPF;
          ACBrNFe1.WebServices.DistribuicaoDFe.ultNSU   := '';
          ACBrNFe1.WebServices.DistribuicaoDFe.NSU      := '';
          ACBrNFe1.WebServices.DistribuicaoDFe.chNFe    := AchNFe;

          ACBrNFe1.WebServices.DistribuicaoDFe.Executar;

          Resp := TDistribuicaoDFeResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(ACBrNFe1.WebServices.DistribuicaoDFe.retDistDFeInt,
                           ACBrNFe1.WebServices.DistribuicaoDFe.Msg,
                           ACBrNFe1.WebServices.DistribuicaoDFe.NomeArq,
                           ACBrNFe1.WebServices.DistribuicaoDFe.ListaArqs);
            Resposta := Resp.Gerar;
          finally
            Resp.Free;
          end;

          MoverStringParaPChar(Resposta, sResposta, esTamanho);
          Result := SetRetorno(ErrOK, Resposta);
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
     Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_EnviarEmail(const ePara, eChaveNFe: PChar; const AEnviaPDF: Boolean;
  const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta, APara, AChaveNFe, AAssunto, ACC, AAnexos, AMensagem: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
  Resp: TLibNFeResposta;
begin
  try
    VerificarLibInicializada;

    APara := string(ePara);
    AChaveNFe := string(eChaveNFe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_EnviarEmail(' + APara + ',' + AChaveNFe + ',' +
         BoolToStr(AEnviaPDF, 'PDF','') + ',' + AAssunto + ',' + ACC + ',' +
         AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_EnviarEmail', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        with NFeDM do
        begin
          EhArquivo := StringEhArquivo(AChaveNFe);

          if EhArquivo then
            VerificarArquivoExiste(AChaveNFe);

          if EhArquivo then
            ACBrNFe1.NotasFiscais.LoadFromFile(AchaveNFe);

          if ACBrNFe1.NotasFiscais.Count = 0 then
            raise EACBrLibException.Create(ErrEnvio, Format(SInfNFeCarregadas, [ACBrNFe1.NotasFiscais.Count]))
          else
          begin
            slMensagemEmail := TStringList.Create;
            slCC := TStringList.Create;
            slAnexos := TStringList.Create;
            Resp := TLibNFeResposta.Create('EnviaEmail', pLib.Config.TipoResposta, pLib.Config.CodResposta);
            try
              with ACBrNFe1 do
              begin
                slMensagemEmail.DelimitedText:= sLineBreak;
                slMensagemEmail.Text := StringReplace(AMensagem, ';', sLineBreak, [rfReplaceAll]);

                slCC.DelimitedText:= sLineBreak;
                slCC.Text := StringReplace(ACC, ';', sLineBreak, [rfReplaceAll]);

                slAnexos.DelimitedText := sLineBreak;
                slAnexos.Text := StringReplace(AAnexos, ';', sLineBreak, [rfReplaceAll]);

                if(AEnviaPDF) then
                  NFeDM.ConfigurarImpressao('', True);

                NotasFiscais.Items[0].EnviarEmail(
                    APara,
                    AAssunto,
                    slMensagemEmail,
                    AEnviaPDF, // Enviar PDF junto
                    slCC,      // Lista com emails que serão enviado cópias - TStrings
                    slAnexos); // Lista de slAnexos - TStrings

                Resp.Msg := 'Email enviado com sucesso';
                Resposta := Resp.Gerar;

                Result := SetRetorno(ErrOK, Resposta);
              end;
            finally
              Resp.Free;
              slCC.Free;
              slAnexos.Free;
              slMensagemEmail.Free;
            end;
          end;
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_EnviarEmailEvento(const ePara, eChaveEvento, eChaveNFe: PChar;
  const AEnviaPDF: Boolean; const eAssunto, eCC, eAnexos, eMensagem: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  APara, AChaveEvento, AChaveNFe, AAssunto, ACC, AAnexos, AMensagem,
  ArqPDF: string;
  slMensagemEmail, slCC, slAnexos: TStringList;
  EhArquivo: boolean;
  Resposta: TLibNFeResposta;
begin
  try
    VerificarLibInicializada;

    APara := string(ePara);
    AChaveEvento := string(eChaveEvento);
    AChaveNFe := string(eChaveNFe);
    AAssunto := string(eAssunto);
    ACC := string(eCC);
    AAnexos := string(eAnexos);
    AMensagem := string(eMensagem);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_EnviarEmailEvento(' + APara + ',' + AChaveEvento + ',' +
         AChaveNFe + ',' + BoolToStr(AEnviaPDF, 'PDF','') + ',' + AAssunto + ',' +
         ACC + ',' + AAnexos + ',' + AMensagem + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_EnviarEmailEvento', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      try
        with NFeDM.ACBrNFe1 do
        begin
          EventoNFe.Evento.Clear;
          NotasFiscais.Clear;

          EhArquivo := StringEhArquivo(AChaveEvento);

          if EhArquivo then
            VerificarArquivoExiste(AChaveEvento);

          if EhArquivo then
            EventoNFe.LerXML(AChaveEvento);

          EhArquivo := StringEhArquivo(AChaveNFe);

          if EhArquivo then
            VerificarArquivoExiste(AChaveNFe);

          if EhArquivo then
            NotasFiscais.LoadFromFile(AchaveNFe);

          if EventoNFe.Evento.Count = 0 then
            raise EACBrLibException.Create(ErrEnvio,
                    Format(SInfEventosCarregados, [EventoNFe.Evento.Count]))
          else
          begin
            slMensagemEmail := TStringList.Create;
            slCC := TStringList.Create;
            slAnexos := TStringList.Create;
            Resposta := TLibNFeResposta.Create('EnviaEmail', pLib.Config.TipoResposta, pLib.Config.CodResposta);
            try
              if AEnviaPDF then
              begin
                try
                  NFeDM.ConfigurarImpressao('', True);
                  ImprimirEventoPDF;

                  ArqPDF := OnlyNumber(EventoNFe.Evento[0].Infevento.id);
                  ArqPDF := PathWithDelim(DANFe.PathPDF)+ArqPDF+'-procEventoNFe.pdf';
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
                  NFeDM.ACBrNFe1.EnviarEmail(
                    APara,
                    AAssunto,
                    slMensagemEmail,
                    slCC,      // Lista com emails que serão enviado cópias - TStrings
                    slAnexos); // Lista de slAnexos - TStrings

                  Resposta.Msg := 'Email enviado com sucesso';
                  Result := SetRetorno(ErrOK, Resposta.Gerar);
                except
                  on E: Exception do
                    raise EACBrLibException.Create(ErrRetorno, 'Erro ao enviar email' + sLineBreak + E.Message);
                end;
              end;
            finally
              Resposta.Free;
              slCC.Free;
              slAnexos.Free;
              slMensagemEmail.Free;
            end;
          end;
        end;
      finally
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_Imprimir(const cImpressora: PChar; nNumCopias: Integer; const cProtocolo,
  bMostrarPreview, cMarcaDagua, bViaConsumidor, bSimplificado: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: TLibImpressaoResposta;
  NumCopias: Integer;
  Impressora, Protocolo,
  MostrarPreview, MarcaDagua,
  ViaConsumidor, Simplificado: String;
begin
  try
    VerificarLibInicializada;

    Impressora := String(cImpressora);
    Protocolo := String(cProtocolo);
    MostrarPreview := String(bMostrarPreview);
    MarcaDagua := String(cMarcaDagua);
    ViaConsumidor := String(bViaConsumidor);
    Simplificado := String(bSimplificado);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_Imprimir(' + Impressora + ',' + IntToStr(nNumCopias) + ','
        + Protocolo + ',' + MostrarPreview + ',' + MarcaDagua + ','
        + ViaConsumidor + ',' + Simplificado + ')', logCompleto, True)
    else
      pLib.GravarLog('NFe_Imprimir', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.NotasFiscais.Count, pLib.Config.TipoResposta,
                                               pLib.Config.CodResposta);
      try
        NFeDM.ConfigurarImpressao(Impressora, False, Protocolo, MostrarPreview,
          MarcaDagua, ViaConsumidor, Simplificado);
        NumCopias := NFeDM.ACBrNFe1.DANFE.NumCopias;
        if nNumCopias > 0 then
          NFeDM.ACBrNFe1.DANFE.NumCopias := nNumCopias;
        NFeDM.ACBrNFe1.NotasFiscais.Imprimir;
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        NFeDM.ACBrNFe1.DANFE.NumCopias := NumCopias;
        Resposta.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ImprimirPDF: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  Resposta: TLibImpressaoResposta;
begin
  try
    VerificarLibInicializada;
    pLib.GravarLog('NFe_ImprimirPDF', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.NotasFiscais.Count, pLib.Config.TipoResposta,
                                               pLib.Config.CodResposta);
      try
        NFeDM.ConfigurarImpressao('', True);
        NFeDM.ACBrNFe1.NotasFiscais.ImprimirPDF;

        Resposta.Msg := NFeDM.ACBrNFe1.DANFE.ArquivoPDF;
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        Resposta.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ImprimirEvento(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXmlNFe: string;
  AArquivoXmlEvento: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    VerificarLibInicializada;

    AArquivoXmlNFe := string(eArquivoXmlNFe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_ImprimirEvento(' + AArquivoXmlNFe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_ImprimirEvento', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.EventoNFe.Evento.Count, pLib.Config.TipoResposta,
                                               pLib.Config.CodResposta);
      try
        EhArquivo := StringEhArquivo(AArquivoXmlNFe);

        if EhArquivo then
          VerificarArquivoExiste(AArquivoXmlNFe);

        if EhArquivo then
          NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(AArquivoXmlNFe);

        EhArquivo := StringEhArquivo(AArquivoXmlEvento);

        if EhArquivo then
          VerificarArquivoExiste(AArquivoXmlEvento);

        if EhArquivo then
          NFeDM.ACBrNFe1.EventoNFe.LerXML(AArquivoXmlEvento);

        NFeDM.ConfigurarImpressao;
        NFeDM.ACBrNFe1.ImprimirEvento;

        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        Resposta.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ImprimirEventoPDF(const eArquivoXmlNFe, eArquivoXmlEvento: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXmlNFe: string;
  AArquivoXmlEvento: string;
  Resposta: TLibImpressaoResposta;
begin
  try
    VerificarLibInicializada;

    AArquivoXmlNFe := string(eArquivoXmlNFe);
    AArquivoXmlEvento := string(eArquivoXmlEvento);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_ImprimirEventoPDF(' + AArquivoXmlNFe + ',' + AArquivoXmlEvento + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_ImprimirEventoPDF', logNormal);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibImpressaoResposta.Create(NFeDM.ACBrNFe1.EventoNFe.Evento.Count, pLib.Config.TipoResposta,
                                               pLib.Config.CodResposta);
      try
        EhArquivo := StringEhArquivo(AArquivoXmlNFe);

        if EhArquivo then
          VerificarArquivoExiste(AArquivoXmlNFe);

        if EhArquivo then
          NFeDM.ACBrNFe1.NotasFiscais.LoadFromFile(AArquivoXmlNFe);

        EhArquivo := StringEhArquivo(AArquivoXmlEvento);

        if EhArquivo then
          VerificarArquivoExiste(AArquivoXmlEvento);

        if EhArquivo then
          NFeDM.ACBrNFe1.EventoNFe.LerXML(AArquivoXmlEvento);

        NFeDM.ConfigurarImpressao('', True);
        NFeDM.ACBrNFe1.ImprimirEventoPDF;

        Resposta.Msg := NFeDM.ACBrNFe1.DANFE.ArquivoPDF;
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        Resposta.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ImprimirInutilizacao(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXml: string;
  Resposta: TLibNFeResposta;
begin
  try
    VerificarLibInicializada;

    AArquivoXml := string(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_ImprimirInutilizacao(' + AArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_ImprimirInutilizacao', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibNFeResposta.Create('Imprimir', pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try

        if EhArquivo then
          NFeDM.ACBrNFe1.InutNFe.LerXML(AArquivoXml);

        NFeDM.ConfigurarImpressao;
        NFeDM.ACBrNFe1.ImprimirInutilizacao;

        Resposta.Msg := 'Danfe Impresso com sucesso';
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        Resposta.Free;
        NFeDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function NFE_ImprimirInutilizacaoPDF(const eArquivoXml: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  EhArquivo: boolean;
  AArquivoXml: string;
  Resposta: TLibNFeResposta;
begin
  try
    VerificarLibInicializada;

    AArquivoXml := string(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('NFe_ImprimirInutilizacaoPDF(' + AArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('NFe_ImprimirInutilizacaoPDF', logNormal);

    EhArquivo := StringEhArquivo(AArquivoXml);

    if EhArquivo then
      VerificarArquivoExiste(AArquivoXml);

    with TACBrLibNFe(pLib) do
    begin
      NFeDM.Travar;
      Resposta := TLibNFeResposta.Create('Imprimir', pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        if EhArquivo then
          NFeDM.ACBrNFe1.InutNFe.LerXML(AArquivoXml);

        NFeDM.ConfigurarImpressao('', True);
        NFeDM.ACBrNFe1.ImprimirInutilizacaoPDF;

        Resposta.Msg := NFeDM.ACBrNFe1.DANFE.ArquivoPDF;
        Result := SetRetorno(ErrOK, Resposta.Gerar);
      finally
        Resposta.Free;
        NFeDM.Destravar;
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

end.
