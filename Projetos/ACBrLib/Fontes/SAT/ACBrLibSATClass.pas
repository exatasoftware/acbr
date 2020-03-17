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

unit ACBrLibSATClass;

interface

uses
  Classes, SysUtils, typinfo,
  ACBrLibComum, ACBrLibSATDataModule;

type

  { TACBrLibSAT }

  TACBrLibSAT = class(TACBrLib)
  private
    FSatDM: TLibSatDM;

  protected
    procedure Inicializar; override;
    procedure CriarConfiguracao(ArqConfig: string = ''; ChaveCrypt: ansistring = '');
      override;
    procedure Executar; override;

  public
    constructor Create(ArqConfig: string = ''; ChaveCrypt: ansistring = ''); override;
    destructor Destroy; override;

    property SatDM: TLibSatDM read FSatDM;
  end;

{%region Declaração da funções}

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function SAT_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Finalizar: longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Nome(const sNome: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_Versao(const sVersao: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ImportarConfig(const eArqConfig: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigLer(const eArqConfig: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigGravar(const eArqConfig: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
    {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Ativar}
function SAT_InicializarSAT: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_DesInicializar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Funções SAT}
function SAT_AssociarAssinatura(CNPJvalue, assinaturaCNPJs: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_BloquearSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_DesbloquearSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_TrocarCodigoDeAtivacao(codigoDeAtivacaoOuEmergencia: PChar;
  opcao: integer; novoCodigo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarStatusOperacional(const sResposta: PChar;
  var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ConsultarNumeroSessao(cNumeroDeSessao: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_AtualizarSoftwareSAT(const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ComunicarCertificadoICPBRASIL(certificado: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ExtrairLogs(eArquivo: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_TesteFimAFim(eArquivoXmlVenda: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarAssinaturaSAT(eCNPJSHW, eCNPJEmitente: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region CFe}
function SAT_CriarCFe(eArquivoIni: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_CriarEnviarCFe(eArquivoIni: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_EnviarCFe(eArquivoXml: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_CancelarCFe(eArquivoXml: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%region Impressão}
function SAT_ImprimirExtratoVenda(eArqXMLVenda, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ImprimirExtratoResumido(eArqXMLVenda, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_ImprimirExtratoCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarImpressaoFiscalMFe(eArqXMLVenda: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarPDFExtratoVenda(eArqXMLVenda, eNomeArquivo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_GerarPDFCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeArquivo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
function SAT_EnviarEmail(eArqXMLVenda, sPara, sAssunto, eNomeArquivo, sMensagem,
  sCC, eAnexos: PChar): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
{%endregion}

{%endregion}

implementation

uses
  ACBrUtil, ACBrLibConsts, ACBrLibSATConsts, ACBrLibConfig, ACBrLibSATConfig,
  ACBrLibResposta, ACBrLibSATRespostas, ACBrMail, ACBrDFeSSL, ACBrValidador,
  ACBrSATExtratoESCPOS;

{ TACBrLibSAT }
constructor TACBrLibSAT.Create(ArqConfig: string; ChaveCrypt: ansistring);
begin
  inherited Create(ArqConfig, ChaveCrypt);
  FSatDM := TLibSatDM.Create(nil);
end;

destructor TACBrLibSAT.Destroy;
begin
  FSatDM.Free;
  inherited Destroy;
end;

procedure TACBrLibSAT.Inicializar;
begin
  GravarLog('TACBrLibSAT.Inicializar', logNormal);

  FSatDM.CriarACBrMail;
  FSatDM.CriarACBrPosPrinter;

  inherited Inicializar;

  GravarLog('TACBrLibSAT.Inicializar - Feito', logParanoico);
end;

procedure TACBrLibSAT.CriarConfiguracao(ArqConfig: string; ChaveCrypt: ansistring);
begin
  fpConfig := TLibSATConfig.Create(Self, ArqConfig, ChaveCrypt);
end;

procedure TACBrLibSAT.Executar;
begin
  inherited Executar;
  FSatDM.AplicarConfiguracoes;
end;

{ ACBrLibSAT }

{%region Redeclarando Métodos de ACBrLibComum, com nome específico}
function SAT_Inicializar(const eArqConfig, eChaveCrypt: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Inicializar(eArqConfig, eChaveCrypt);
end;

function SAT_Finalizar: longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Finalizar;
end;

function SAT_Nome(const sNome: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Nome(sNome, esTamanho);
end;

function SAT_Versao(const sVersao: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_Versao(sVersao, esTamanho);
end;

function SAT_UltimoRetorno(const sMensagem: PChar; var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_UltimoRetorno(sMensagem, esTamanho);
end;

function SAT_ImportarConfig(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ImportarConfig(eArqConfig);
end;

function SAT_ConfigLer(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLer(eArqConfig);
end;

function SAT_ConfigGravar(const eArqConfig: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravar(eArqConfig);
end;

function SAT_ConfigLerValor(const eSessao, eChave: PChar; sValor: PChar;
  var esTamanho: longint): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigLerValor(eSessao, eChave, sValor, esTamanho);
end;

function SAT_ConfigGravarValor(const eSessao, eChave, eValor: PChar): longint;
  {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  Result := LIB_ConfigGravarValor(eSessao, eChave, eValor);
end;

{%endregion}

{%region Ativar}
function SAT_InicializarSAT: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('POS_Ativar', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      try
        if SatDM.ACBrSAT1.Inicializado then
        begin
          Result := SetRetorno(-8, 'SAT já inicializado');
        end
        else
        begin
          SatDM.ACBrSAT1.Inicializar;
          Result := SetRetorno(ErrOK);
        end;
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_DesInicializar: longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_DesInicializar', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      try
        if not SatDM.ACBrSAT1.Inicializado then
        begin
          Result := SetRetorno(-8, 'SAT não inicializado');
        end
        else
        begin
          SatDM.ACBrSAT1.DesInicializar;
          Result := SetRetorno(ErrOK);
        end;
      finally
        SatDM.Destravar;
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

{%region Funções SAT}
function SAT_AssociarAssinatura(CNPJvalue, assinaturaCNPJs: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  CNPJ, Assinatura, Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;
    CNPJ := ansistring(CNPJvalue);
    Assinatura := ansistring(assinaturaCNPJs);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_AssociarAssinatura(' + CNPJ + ',' + Assinatura + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_AssociarAssinatura', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.AssociarAssinatura(CNPJ, Assinatura);
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_BloquearSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_BloquearSAT', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.BloquearSAT;
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_DesbloquearSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_DesbloquearSAT', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.DesbloquearSAT;
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_TrocarCodigoDeAtivacao(codigoDeAtivacaoOuEmergencia: PChar;
  opcao: integer; novoCodigo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint; {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  CodigoAtivacao, NovoCodigoAtv, Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;
    CodigoAtivacao := ansistring(codigoDeAtivacaoOuEmergencia);
    NovoCodigoAtv := ansistring(novoCodigo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_TrocarCodigoDeAtivacao(' + CodigoAtivacao +
        ',' + IntToStr(opcao) + ',' + NovoCodigoAtv +
        ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_TrocarCodigoDeAtivacao', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.TrocarCodigoDeAtivacao(CodigoAtivacao, opcao, NovoCodigoAtv);
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ConsultarSAT(const sResposta: PChar; var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_ConsultarSAT', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);

      try
        Resposta := '';
        SatDM.ACBrSAT1.ConsultarSAT;
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ConsultarStatusOperacional(const sResposta: PChar;
  var esTamanho: longint): longint;
        {$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
  Resp: TRetornoStatusSAT;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_ConsultarStatusOperacional', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      Resp := TRetornoStatusSAT.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.ConsultarStatusOperacional;
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;

        if (SatDM.ACBrSAT1.Resposta.codigoDeRetorno = 10000) then
        begin
          Resp.Processar(SatDM.ACBrSAT1);
          Resposta := Resposta + sLineBreak + Resp.Gerar;
        end;

        Resposta := Resposta + SatDM.RespostaIntegrador;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ConsultarNumeroSessao(cNumeroDeSessao: integer;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
  Resp: TRetornoConsultarSessao;
  RespCanc: TRetornoConsultarSessaoCancelado;
begin
  try
    VerificarLibInicializada;

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ConsultarNumeroSessao(' + IntToStr(cNumeroDeSessao) + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ConsultarNumeroSessao', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);

      try
        Resposta := '';
        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ACBrSAT1.CFeCanc.Clear;

        SatDM.ACBrSAT1.ConsultarNumeroSessao(cNumeroDeSessao);
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;

        if SatDM.ACBrSAT1.Resposta.codigoDeRetorno = 6000 then
        begin
          Resp := TRetornoConsultarSessao.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            Resp.Processar(SatDM.ACBrSAT1);
            Resposta := Resposta + sLineBreak + Resp.Gerar;
          finally
            Resp.Free;
          end;
        end;

        if SatDM.ACBrSAT1.Resposta.codigoDeRetorno = 7000 then
        begin
          RespCanc := TRetornoConsultarSessaoCancelado.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
          try
            RespCanc.Processar(SatDM.ACBrSAT1);
            Resposta := Resposta + sLineBreak + RespCanc.Gerar;
          finally
            RespCanc.Free;
          end;
        end;

        Resposta := Resposta + SatDM.RespostaIntegrador;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_AtualizarSoftwareSAT(const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;

    pLib.GravarLog('SAT_AtualizarSoftwareSAT', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.AtualizarSoftwareSAT;
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ComunicarCertificadoICPBRASIL(certificado: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  cCertificado, Resposta: ansistring;
  RespSat: TACBrLibSATResposta;
begin
  try
    VerificarLibInicializada;
    cCertificado := ansistring(certificado);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ComunicarCertificadoICPBRASIL(' + cCertificado +
        ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ComunicarCertificadoICPBRASIL', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      RespSat := TACBrLibSATResposta.Create(pLib.Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.ComunicarCertificadoICPBRASIL(cCertificado);
        RespSat.Processar(SatDM.ACBrSAT1);
        Resposta := RespSat.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        RespSat.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ExtrairLogs(eArquivo: PChar): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  cArquivo: ansistring;
begin
  try
    VerificarLibInicializada;
    cArquivo := ansistring(eArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ExtrairLogs(' + cArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ExtrairLogs', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        SatDM.ACBrSAT1.ExtrairLogs(cArquivo);
        Result := SetRetorno(ErrOK);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_TesteFimAFim(eArquivoXmlVenda: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoXmlVenda: ansistring;
  Resposta: String;
  Resp: TRetornoTesteFimaFim;
begin
  try
    VerificarLibInicializada;
    ArquivoXmlVenda := ansistring(eArquivoXmlVenda);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_TesteFimAFim(' + ArquivoXmlVenda + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_TesteFimAFim', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TRetornoTesteFimaFim.Create(Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        Resp.Resultado := SatDM.ACBrSAT1.TesteFimAFim(ArquivoXmlVenda);
        Resp.Processar(SatDM.ACBrSAT1);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_GerarAssinaturaSAT(eCNPJSHW, eCNPJEmitente: PChar;
  const sResposta: PChar; var esTamanho: longint): longint;
{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
Var
  cCNPJShw, cCNPJEmitente, cCodigoVinculacao, Resposta: String;
begin
  try
    VerificarLibInicializada;
    cCNPJShw := OnlyNumber(StrPas(eCNPJSHW));
    cCNPJEmitente := OnlyNumber(StrPas(eCNPJEmitente));

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_GerarAssinaturaSAT(' + cCNPJShw + ', ' + cCNPJEmitente + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_GerarAssinaturaSAT', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        Resposta := '';

        Resposta := Trim(ACBrValidador.ValidarCNPJ(cCNPJShw));
        if NaoEstaVazio(Resposta) then
          raise EACBrLibException.Create(ErrCNPJInvalido, Format(SErrLibSATCNPJSwHouseInvalido, [Resposta]));

        Resposta := Trim(ACBrValidador.ValidarCNPJ(cCNPJEmitente));
        if NaoEstaVazio(Resposta) then
          raise EACBrLibException.Create(ErrCNPJInvalido, Format(SErrLibSATCNPJEmitenteInvalido, [Resposta]));

        cCodigoVinculacao := cCNPJShw + cCNPJEmitente;
        Resposta := SatDM.ACBrSAT1.SSL.CalcHash(cCodigoVinculacao, dgstSHA256, outBase64, True);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        SatDM.Destravar;
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

{%region CFe}
function SAT_CriarCFe(eArquivoIni: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TRetornoCriarCFe;
  Resposta: Ansistring;
  ArquivoIni: String;
begin
   try
    VerificarLibInicializada;
    ArquivoIni := String(eArquivoIni);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_CriarCFe(' + ArquivoIni + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_CriarCFe', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TRetornoCriarCFe.Create(Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ACBrSAT1.InicializaCFe;
        SatDM.ACBrSAT1.CFe.LoadFromIni(ArquivoIni);
        SatDM.ACBrSAT1.CFe.GerarXML(True);
        Resp.Processar(SatDM.ACBrSAT1);
        Resposta := Resp.Gerar;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_CriarEnviarCFe(eArquivoIni: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TRetornoEnvio;
  Resposta: Ansistring;
  ArquivoIni: String;
begin
   try
    VerificarLibInicializada;
    ArquivoIni := String(eArquivoIni);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_CriarEnviarCFe(' + ArquivoIni + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_CriarEnviarCFe', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TRetornoEnvio.Create(Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ACBrSAT1.InicializaCFe;
        SatDM.ACBrSAT1.CFe.LoadFromIni(ArquivoIni);

        Resp.Resultado := SatDM.ACBrSAT1.EnviarDadosVenda;
        Resp.Processar(SatDM.ACBrSAT1);
        Resposta := Resp.Gerar;
        Resposta := Resposta + SatDM.RespostaIntegrador;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_EnviarCFe(eArquivoXml: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TRetornoEnvio;
  Resposta: Ansistring;
  ArquivoXml: Ansistring;
begin
   try
    VerificarLibInicializada;
    ArquivoXml := Ansistring(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_EnviarCFe(' + ArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_EnviarCFe', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TRetornoEnvio.Create(Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ACBrSAT1.InicializaCFe;
        SatDM.CarregarDadosVenda(ArquivoXml);

        Resp.Resultado := SatDM.ACBrSAT1.EnviarDadosVenda;
        Resp.Processar(SatDM.ACBrSAT1);

        Resposta := Resp.Gerar;
        Resposta := Resposta + SatDM.RespostaIntegrador;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_CancelarCFe(eArquivoXml: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TRetornoCancelarCFe;
  Resposta: Ansistring;
  ArquivoXml: String;
begin
   try
    VerificarLibInicializada;
    ArquivoXml := String(eArquivoXml);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_CancelarCFe(' + ArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_CancelarCFe', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TRetornoCancelarCFe.Create(Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';

        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ACBrSAT1.InicializaCFe;
        SatDM.CarregarDadosVenda(ArquivoXml);

        Resp.Resultado := SatDM.ACBrSAT1.CancelarUltimaVenda;
        Resp.Processar(SatDM.ACBrSAT1);
        Resposta := Resp.Gerar;
        Resposta := Resposta + SatDM.RespostaIntegrador;
        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
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
function SAT_ImprimirExtratoVenda(eArqXMLVenda, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoXml, NomeImpressora: String;
begin
   try
    VerificarLibInicializada;
    ArquivoXml := String(eArqXMLVenda);
    NomeImpressora := String(eNomeImpressora);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ImprimirExtratoVenda(' + ArquivoXml + ',' + NomeImpressora + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ImprimirExtratoVenda', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        SatDM.ACBrSAT1.CFe.Clear;
        SatDM.ConfigurarImpressao(NomeImpressora);
        SatDM.CarregarDadosVenda(ArquivoXml);
        SatDM.ACBrSAT1.ImprimirExtrato;
        SatDM.ACBrSAT1.Extrato := nil;
        Result := SetRetorno(ErrOK);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ImprimirExtratoResumido(eArqXMLVenda, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoXml, NomeImpressora: String;
begin
   try
    VerificarLibInicializada;
    ArquivoXml := String(eArqXMLVenda);
    NomeImpressora := String(eNomeImpressora);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ImprimirExtratoResumido(' + ArquivoXml + ',' + NomeImpressora + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ImprimirExtratoResumido', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        SatDM.ConfigurarImpressao(NomeImpressora);
        SatDM.CarregarDadosVenda(ArquivoXml);
        SatDM.ACBrSAT1.ImprimirExtratoResumido;
        SatDM.ACBrSAT1.Extrato := nil;
        Result := SetRetorno(ErrOK);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_ImprimirExtratoCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeImpressora: PChar)
  : longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArqXMLVenda, ArqXMLCancelamento, NomeImpressora: String;
begin
   try
    VerificarLibInicializada;
    ArqXMLVenda := String(eArqXMLVenda);
    ArqXMLCancelamento := String(eArqXMLCancelamento);
    NomeImpressora := String(eNomeImpressora);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_ImprimirExtratoCancelamento(' + ArqXMLVenda + ',' + ArqXMLCancelamento +
        ',' + NomeImpressora + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_ImprimirExtratoCancelamento', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        SatDM.ConfigurarImpressao(NomeImpressora);
        SatDM.CarregarDadosVenda(ArqXMLVenda);
        SatDM.CarregarDadosCancelamento(ArqXMLCancelamento);
        SatDM.ACBrSAT1.ImprimirExtratoCancelamento;
        SatDM.ACBrSAT1.Extrato := nil;
        Result := SetRetorno(ErrOK);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_GerarImpressaoFiscalMFe(eArqXMLVenda: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArquivoXml,  Resposta: String;
begin
   try
    VerificarLibInicializada;
    ArquivoXml := String(eArqXMLVenda);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_GerarImpressaoFiscalMFe(' + ArquivoXml + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_GerarImpressaoFiscalMFe', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      try
        Resposta := '';

        SatDM.CarregarDadosVenda(ArquivoXml);
        Resposta := SatDM.ACBrSATExtratoESCPOS1.GerarImpressaoFiscalMFe(SatDM.ACBrSAT1.CFe);
        MoverStringParaPChar(Resposta, sResposta, esTamanho);

        Result := SetRetorno(ErrOK, Resposta);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_GerarPDFExtratoVenda(eArqXMLVenda, eNomeArquivo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TPadraoSATResposta;
  ArqXMLVenda, NomeArquivo, Resposta: String;
begin
   try
    VerificarLibInicializada;
    ArqXMLVenda := String(eArqXMLVenda);
    NomeArquivo := String(eNomeArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_GerarPDFExtratoVenda(' + ArqXMLVenda + ',' + NomeArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_GerarPDFExtratoVenda', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TPadraoSATResposta.Create('CFe', Config.TipoResposta, pLib.Config.CodResposta);
      try
        Resposta := '';
        SatDM.ConfigurarImpressao('', True);
        SatDM.CarregarDadosVenda(ArqXMLVenda, NomeArquivo);

        SatDM.ACBrSAT1.ImprimirExtrato;

        Resp.Arquivo:= SatDM.ACBrSAT1.Extrato.NomeDocumento;
        Resp.XML:= SatDM.ACBrSAT1.CFe.XMLOriginal;
        Resposta := Resp.Gerar;

        SatDM.ACBrSAT1.Extrato := nil;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        Resp.Free;
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_GerarPDFCancelamento(eArqXMLVenda, eArqXMLCancelamento, eNomeArquivo: PChar; const sResposta: PChar;
  var esTamanho: longint): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  Resp: TPadraoSATResposta;
  ArqXMLVenda, ArqXMLCancelamento, NomeArquivo, Resposta: String;
begin
   try
    VerificarLibInicializada;
    ArqXMLVenda := String(eArqXMLVenda);
    ArqXMLCancelamento := String(eArqXMLCancelamento);
    NomeArquivo := String(eNomeArquivo);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_GerarPDFCancelamento(' + ArqXMLVenda + ',' + ArqXMLCancelamento +
        ',' + NomeArquivo + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_GerarPDFCancelamento', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;
      Resp := TPadraoSATResposta.Create('CFe', Config.TipoResposta, pLib.Config.CodResposta);
      try
       Resposta := '';
        SatDM.ConfigurarImpressao('', True);
        SatDM.CarregarDadosVenda(ArqXMLVenda);
        SatDM.CarregarDadosCancelamento(ArqXMLCancelamento, NomeArquivo);

        SatDM.ACBrSAT1.ImprimirExtratoCancelamento;

        Resp.Arquivo:= SatDM.ACBrSAT1.Extrato.NomeDocumento;
        Resp.XML:= SatDM.ACBrSAT1.CFeCanc.XMLOriginal;
        Resposta := Resp.Gerar;

        SatDM.ACBrSAT1.Extrato := nil;

        MoverStringParaPChar(Resposta, sResposta, esTamanho);
        Result := SetRetorno(ErrOK, Resposta);
      finally
        SatDM.Destravar;
      end;
    end;
  except
    on E: EACBrLibException do
      Result := SetRetorno(E.Erro, E.Message);

    on E: Exception do
      Result := SetRetorno(ErrExecutandoMetodo, E.Message);
  end;
end;

function SAT_EnviarEmail(eArqXMLVenda, sPara, sAssunto, eNomeArquivo, sMensagem,
  sCC, eAnexos: PChar): longint;{$IfDef STDCALL} stdcall{$Else} cdecl{$EndIf};
var
  ArqXMLVenda, Para, Assunto, NomeArquivo, Mensagem, CC, Anexos: String;
  slMensagem, slCC, slAnexos: TStrings;
begin
   try
    VerificarLibInicializada;
    ArqXMLVenda := String(eArqXMLVenda);
    Para := String(sPara);
    Assunto := String(sAssunto);
    NomeArquivo := String(eNomeArquivo);
    Mensagem := String(sMensagem);
    CC := String(sCC);
    Anexos := String(eAnexos);

    if pLib.Config.Log.Nivel > logNormal then
      pLib.GravarLog('SAT_EnviarEmail(' + ArqXMLVenda + ',' + Para + ',' + Assunto
      + ',' + NomeArquivo + ',' + Mensagem + ',' + CC + ',' + Anexos + ' )', logCompleto, True)
    else
      pLib.GravarLog('SAT_EnviarEmail', logNormal);

    with TACBrLibSAT(pLib) do
    begin
      SatDM.Travar;

      slMensagem := TStringList.Create;
      slCC := TStringList.Create;
      slAnexos := TStringList.Create;
      try
        slMensagem.Text := Mensagem;
        slCC.Text := CC;
        slAnexos.Text := Anexos;

        SatDM.ConfigurarImpressao;
        SatDM.CarregarDadosVenda(ArqXMLVenda, NomeArquivo);
        SatDM.ACBrSAT1.EnviarEmail(Para, Assunto, slMensagem, slCC, slAnexos);
        Result := SetRetorno(ErrOK);
      finally
        slMensagem.Free;
        slCC.Free;
        slAnexos.Free;
        SatDM.Destravar;
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

{%endregion}
end.
