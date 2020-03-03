{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Jo�o Pedro R Costa                              }
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

unit ACBrDeSTDABlocos;

interface

uses
  SysUtils, Classes, DateUtils, ACBrTXTClass, contnrs;

type
  /// Indicador de movimento - TOpenBlocos
  TACBrIndMov = (imComDados, // 0- Bloco com dados informados;
                 imSemDados  // 1- Bloco sem dados informados.
                             );
  TACBrIndicadorMovimento = TACBrIndMov;

  /// Tabela Vers�o do Leiaute - item 3.1.1 - TRegistro0000
  TACBrCodVer = (
    vlVersao2000,  // C�digo 2000 - Vers�o 2.0.0.0 Ato COTEPE 47 2015
    vlVersao2001,  //
    vlVersao2010,  //
    vlVersao2100
  );

  TACBrVersaoLeiaute = TACBrCodVer;

  // Tabela Finalidade do Arquivo - item 3.2.1 - TRegistro0000
  TACBrCodFin           = (raOriginal,     // 0 - Remessa do arquivo original
                           raSubstituto    // 1 - Remessa do arquivo substituto
                             );
  TACBrCodFinalidade = TACBrCodFin;

  // Tabela Conte�do do Arquivo-texto - item 3.2.2 - TRegistro0000
  TACBrConteudoArquivo = (
    cn30 ,      // 30 -  Resumos e informa��es consolidadas
    cnNullo     //    - campo nulo
  );

  // Tabela Qualifica��o de Assinantes - item 3.3.2 - TRegistro0005
  TACBrAssinante =
  (
    asDiretor,                 // 203 - Diretor
    asConsAdm,                 // 204 - Conselheiro de administra��o
    asAdministrador,           // 205 - Administrador
    asAdmGrupo,                // 206 - Administrador de grupo
    asAdmSocFiliada,           // 207 - Administrador de sociedade filiada
    asAdmJudicialPF,           // 220 - Administrador judicial - pessoa f�sica
    asAdmJudicialPJPR,         // 222 - Administrador judicial - pessoa jur�dica/profissional respons�vel
    asAdmJudicialGestor,       // 223 - Administrador judicial - gestor
    asGestorJudicial,          // 226 - Gestor judicial
    asProcurador,              // 309 - Procurador
    asInventariante,           // 312 - Inventariante
    asLiquidante,              // 313 - Liquidante
    asInterventor,             // 315 - Interventor
    asEmpresario,              // 801 - Empres�rio
    asContador,                // 900 - Contador
    asOutros                   // 999 - Outros
  );

  // Indicador de entrada de dados - TRegistro 0030
  TACBrIndEntrada =
  (
    edDigitacao,           // 0 - Digita��o de dados
    edImportacaoArquivo,   // 1 - Importa��o de arquivo-texto
    edAdicaoDoc_ArqTexto,  // 2 - Adi��o de documentos/arquivo-texto
    edExportArquivo        // 3 - Exporta��o de arquivo-texto
  );

  // Indicador do documento contido no arquivo - TRegistro 0030
  TACBrIndDocumentos = (
    dcGuiasInfEconFisc	//7- Guias de informa��es econ�mico-fiscais
  );

  // Indicador de exigibilidade da escritura��o do ISS - TRegistro 0030
  TACBrIndExigISS = (
    exISSSimplificado, // 0 - Sim, no modo simplificado de escritura��o do imposto
    exISSIntegral,     // 2 - Sim, no modo integral de escritura��o do regime normal de apura��o do imposto
    exISSNaoObrigado   // 9 - N�o obrigado a escritura
  );

  // Indicador de exigibilidade da escritura��o do ICMS - TRegistro 0030
  TACBrIndExigICMS = (
    exICMSSimplificado,  // 0 - Sim, no modo simplificado de escritura��o do imposto
    exICMSIntermediario, // 1 - Sim, no modo intermedi�rio de escritura��o do regime normal de apura��o do imposto
    exICMSIntegral,      // 2 - Sim, no modo integral de escritura��o do regime normal de apura��o do imposto
    exICMSNaoObrigado    // 9 - N�o obrigado a escriturar
  );

  //TipoGenerico de Sim e Nao
  TACBrSimNao = (
    snSim, // 0 - Sim
    snNao  // 1 - N�o
  );

  // Indicador de exigibilidade do Registro de Impress�o de Documentos Fiscais - TRegistro 0030
  TACBrIndExigImpDocF = TACBrSimNao;

  // Indicador de exigibilidade do Registro de Utiliza��o de Documentos Fiscais - TRegistro 0030
  TACBrIndExigUtilDocF = TACBrSimNao;

  // Indicador de exigibilidade do Livro de Movimenta��o de Combust�veis - TRegistro 0030
  TACBrIndExigMovComb = TACBrSimNao;

  // Indicador de exigibilidade do Registro de Ve�culos - TRegistro 0030
  TACBrIndExigRegVeic = TACBrSimNao;

  // ndicador de exigibilidade anual do Registro de Invent�rio - TRegistro 0030
  TACBrIndExigRegInv = TACBrSimNao;

  // Indicador de apresenta��o da escritura��o cont�bil - TRegistro 0030
  TACBrIndApresEC =
  (
   ecCompletaEmArquivoDig,       // 1 - Completa registrada em arquivo digital
   ecCompletaRegistradaPapel,    // 2 - Completa registrada em papel, microfilme, fichas avulsas, ou 3 - fichas/folhas cont�nuas
   ecSimplificadaEmArquivoDig,   // 3 - Simplificada registrada em arquivo digital, Simplificada registrada papel, microfilme, fichas avulsas, ou fichas/folhas cont�nuas
   ecLivroCaixaArquivoDig,       // 4 - Livro Caixa registrado em arquivo digital
   ecLivroCaixaRegistradoPapel,  // 5 - Livro Caixa registrado papel, microfilme, fichas avulsas, ou fichas/folhas cont�nuas
   ecNaoObrigado                 // 9 - N�o obrigado a escriturar
  );

  // Indicador de opera��es sujeitas ao ISS - TRegistro 0030
  TACBrIndOpISS = TACBrSimNao;

  // Indicador de opera��es sujeitas � reten��o tribut�ria do ISS, na condi��o de contribuinte-substitu�do - TRegistro 0030
  TACBrIndOpISSRet = TACBrSimNao;

  // Indicador de opera��es sujeitas ao ICMS - TRegistro 0030
  TACBrIndOpICMS = TACBrSimNao;

  // Indicador de opera��es sujeitas � substitui��o tribut�ria do ICMS, na condi��o de contribuinte-substituto - TRegistro 0030
  TACBrIndOpICMSST = TACBrSimNao;

  // Indicador de opera��es sujeitas � antecipa��o tribut�ria do ICMS, nas entradas - TRegistro 0030
  TACBrIndOpICMSAnt = TACBrSimNao;

  // Indicador de opera��es sujeitas ao IPI - TRegistro 0030
  TACBrIndOpIPI = TACBrSimNao;

  // Indicador de apresenta��o avulsa do Registro de Invent�rio - TRegistro 0030
  TACBrIndApresAvlRegInv = TACBrSimNao;

  //  Indicador de conte�do - TRegistro G020
  TACBrIndContGuias =
  (
      igISS,         // 0 - Guia com informa��es de opera��es do ISS
      igICMS,        // 1 - Guia com informa��es de opera��es do ICMS
      igSimples,     // 2 - Guia com informa��es de opera��es do Simples Nacional
      igRecalcICMS,  // 8 - Resultado do rec�lculo do valor adicionado em opera��es do ICMS
      igGuiaSemDados // 9 - Guia sem dados informados
  );

  TACBrIndSitDifAnt =
  (
    dfAntEntAtivoPermanente,  // 0 - Diferencia de al�quota pelas entradas interestaduais para aquisi��o de ativo permanente
    dfAntEntUsoEConsumo,      // 1 - Diferencial de Al�quota pelas entradas interestaduais para aquisi��o de mercadoria para o uso e/ou consumo
    dfAntEntEncerrSemCobICMS, // 2 - Antecipa��o pelas entradas interestaduais com encerramento de fase de tributa��o (sem cobran�a de ICMS nas opera��es subsequentes)
    dfAntEntEncerrComCobICMS  // 3 - Antecipa��o pelas entradas interestaduais sem encerramento de fase de tributa��o (com cobran�a de ICMS nas opera��es subsequentes)
  );

  TACBrIndOper      = (tpEntradaAquisicao, // 0 - Entrada
                       tpSaidaPrestacao    // 1 - Sa�da
                       );
  TACBrTipoOperacao = TACBrIndOper;

  /// Indicador do emitente do documento fiscal
  TACBrIndEmit = (edEmissaoPropria,         // 0 - Emiss�o pr�pria
                  edTerceiros               // 1 - Terceiro
                  );
  TACBrEmitente = TACBrIndEmit;

  TACBrIndTipoST =
  (
    stOpSubsequentes,      // 0 - ICMS ST Opera��es Subsequentes
    stOpAntecedentes,      // 1 - ICMS ST Opera��es Antecedentes
    stServicosTransportes, // 2 - ICMS ST Servi�o de Transporte (opera��es concomitantes)
    stRefCombustiveis      // 3 - ICMS ST Ref. a Combust�veis
  );

  TACBrDeLeiauteArquivos =
  (
    laLFPD, /// Texto fixo "LFPD"
    laLECD  // Texto fixo "LECD"
  );

  TOpenBlocos = class
  private
    FIND_MOV: TACBrIndicadorMovimento;    /// Indicador de movimento: 0- Bloco com dados informados, 1- Bloco sem dados informados.
  public
    property IND_MOV: TACBrIndicadorMovimento read FIND_MOV write FIND_MOV;
  end;

  //Funcoes do ACBrDeSTDABlocos
  function strToCodAssinante( const AValue: string ): TACBrAssinante;
  function codAssinanteToStr( AValue: TACBrAssinante ): string;

implementation



function strToCodAssinante( const AValue: string ): TACBrAssinante;
begin
 if AValue = '203' then Result := asDiretor
 else if AValue = '204' then Result := asConsAdm
 else if AValue = '205' then Result := asAdministrador
 else if AValue = '206' then Result := asAdmGrupo
 else if AValue = '207' then Result := asAdmSocFiliada
 else if AValue = '220' then Result := asAdmJudicialPF
 else if AValue = '222' then Result := asAdmJudicialPJPR
 else if AValue = '223' then Result := asAdmJudicialGestor
 else if AValue = '226' then Result := asGestorJudicial
 else if AValue = '309' then Result := asProcurador
 else if AValue = '312' then Result := asInventariante
 else if AValue = '313' then Result := asLiquidante
 else if AValue = '315' then Result := asInterventor
 else if AValue = '801' then Result := asEmpresario
 else if AValue = '900' then Result := asContador
 else
   Result := asOutros;
end;

function codAssinanteToStr( AValue: TACBrAssinante ): string;
begin
  case AValue of
    asDiretor          : Result := '203';
    asConsAdm          : Result := '204';
    asAdministrador    : Result := '205';
    asAdmGrupo         : Result := '206';
    asAdmSocFiliada    : Result := '207';
    asAdmJudicialPF    : Result := '220';
    asAdmJudicialPJPR  : Result := '222';
    asAdmJudicialGestor: Result := '223';
    asGestorJudicial   : Result := '226';
    asProcurador       : Result := '309';
    asInventariante    : Result := '312';
    asLiquidante       : Result := '313';
    asInterventor      : Result := '315';
    asEmpresario       : Result := '801';
    asContador         : Result := '900';
    asOutros           : Result := '999';
  end;
end;

end.
