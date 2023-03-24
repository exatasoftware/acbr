  {******************************************************************************}
  { Projeto: Componentes ACBr                                                    }
  {  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
  { mentos de Automa��o Comercial utilizados no Brasil                           }
  {                                                                              }
  { Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
  {                                                                              }
  { Colaboradores nesse arquivo: Victor H Gonzales                               }
  {                                                                              }
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

  //Incluido 22/03/2023

{$I ACBr.inc}
unit ACBrBancoPefisa;

interface

uses
  Classes,
  Contnrs,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoConversao;

type

    { TACBrBancoPefisa }

  TACBrBancoPefisa = class(TACBrBancoClass)
  private
    function ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Double;
    function ConverterTipoPagamento(const ATipoPagamento: TTipo_Pagamento): String;
  protected
    function ConverterDigitoModuloFinal(): String; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;

  public
    Constructor create(AOwner: TACBrBanco);
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String; override;

    procedure GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; ARemessa: TStringList); override;
    function MontaInstrucoesCNAB400(const ACBrTitulo: TACBrTitulo; const nRegistro: Integer): String; override;
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String; override;
    function DefineEspecieDoc(const ACBrTitulo: TACBrTitulo): String; override;
    function CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;

  end;

implementation

uses
  StrUtils,
  ACBrBase,
  ACBrUtil.Strings,
  ACBrUtil.Base;

  { TACBrBancoPefisa }

function TACBrBancoPefisa.ConverterDigitoModuloFinal(): String;
begin
  if Modulo.ModuloFinal = 1 then
    Result := 'P'
  else
    Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoPefisa.DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
var
  LEmissao    : char;
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrTitulo.ACBrBoleto.Cedente;

  case Beneficiario.ResponEmissao of
    tbBancoEmite, tbBancoPreEmite, tbBancoNaoReemite, tbBancoReemite:
      LEmissao := '3'; //3 para cobran�a registrada com emiss�o pelo banco
    else
      LEmissao := '4'; //4 para cobran�a direta com emiss�o pelo cedente
  end;

  Result :=

    PadLeft(OnlyNumber(Beneficiario.CodigoCedente), 12, '0') + PadLeft(ACBrTitulo.NossoNumero, 10, '0') + PadLeft(ACBrTitulo.Carteira, 2, '0') + LEmissao;

end;

function TACBrBancoPefisa.DefineEspecieDoc(const ACBrTitulo: TACBrTitulo): String;
begin
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'DM') then
    Result := '01'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'DS') then
    Result := '02'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'NP') then
    Result := '03'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'NS') then
    Result := '04'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'REC') then
    Result := '05'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'LC') then
    Result := '06'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'FC') then
    Result := '07'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'CN') then
    Result := '08'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'CT') then
    Result := '09'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'CQ') then
    Result := '10'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'CS') then
    Result := '11'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'MS') then
    Result := '12'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'ND') then
    Result := '13'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'DD') then
    Result := '15'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'CPS') then
    Result := '17'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'FT') then
    Result := '31'
  else
  if AnsiSameText(ACBrTitulo.EspecieDoc, 'OU') then
    Result := '99'
  else
    Result := ACBrTitulo.EspecieDoc;
end;

function TACBrBancoPefisa.ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Double;
begin
  if ACBrTitulo.MultaValorFixo then
    if (ACBrTitulo.ValorDocumento > 0) then
      Result := (ACBrTitulo.PercentualMulta / ACBrTitulo.ValorDocumento) * 100
    else
      Result := 0
  else
    Result := ACBrTitulo.PercentualMulta;
end;

function TACBrBancoPefisa.ConverterTipoPagamento(const ATipoPagamento: TTipo_Pagamento): String;
begin
    //1 - Aceita Qualquer valor
    //2 - Aceita entre um m�nimo e m�ximo
    //3 - N�o aceita pagamento com valor divergente
    //4 - Aceita a partir de um m�nimo
  case ATipoPagamento of
    tpAceita_Qualquer_Valor:
      Result := '1';
    tpAceita_Valores_entre_Minimo_Maximo:
      Result := '2';
    tpSomente_Valor_Minimo:
      Result := '4';
    else
      Result := '3';
  end;
end;

constructor TACBrBancoPefisa.create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);
  fpDigito                     := 2;
  fpNome                       := 'PEFISA';
  fpNumero                     := 174;
  fpTamanhoMaximoNossoNum      := 10;
  fpTamanhoAgencia             := 4;
  fpTamanhoConta               := 12;
  fpTamanhoCarteira            := 2;
  fpLayoutVersaoArquivo        := 22;
  fpLayoutVersaoLote           := 0;
  fpDensidadeGravacao          := '';
  fpModuloMultiplicadorInicial := 2;
  fpModuloMultiplicadorFinal   := 7;
  fpCodParametroMovimento      := '';
end;

function TACBrBancoPefisa.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := '0' + 
    ACBrTitulo.Carteira + 
    ACBrTitulo.NossoNumero + 
    ' ' + 
    CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoPefisa.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise Exception.create(ACBrStr('N�o implementado CNAB240'));
end;

procedure TACBrBancoPefisa.GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList);
var
  LLinha      : String;
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;

  LLinha := '0' +                                                               // 001 a 001 - Tipo de Registro
    '1' +                                                                       // 002 a 002 - C�digo Remessa
    'REMESSA' +                                                                 // 003 a 009 - Literal Remessa
    '01' +                                                                      // 010 a 011 - C�digo Servi�o
    PadRight('COBRANCA', 8) +                                                   // 012 a 019 - Literal Cobranca
    Space(7) +                                                                  // 020 a 026 - Uso do Banco Brancos
    PadLeft(Beneficiario.CodigoCedente, 12, '0') +                              // 027 a 038 - C�digo do Cedente
    Space(8) +                                                                  // 039 a 046 - Uso do Banco Brancos
    PadRight(Nome, 30) +                                                        // 047 a 076 - Nome da Empresa
    IntToStrZero(fpNumero, 3) +                                                 // 077 a 079 - C�digo do Banco
    Space(15) +                                                                 // 080 a 094 - Uso do Banco Brancos
    FormatDateTime('ddmmyy', Now) +                                             // 095 a 100 - Data de Grava��o
    Space(8) +                                                                  // 101 a 108 - Uso do Banco Brancos
    PadLeft(Beneficiario.Conta, 12, '0') +                                      // 109 a 120 - Conta Cobran�a Direta
    Space(266) +                                                                // 121 a 386 - Uso do Banco Brancos
    IntToStrZero(NumeroRemessa, 8) +                                            // 387 a 394 - Sequecial de Remessa
    IntToStrZero(1, 6);                                                         // 395 a 400 - Sequencial

  ARemessa.Add(UpperCase(LLinha));
end;

procedure TACBrBancoPefisa.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; ARemessa: TStringList);
var
  LTitulo     : TACBrTitulo;
  Beneficiario: TACBrCedente;
  Pagador     : TACBrSacado;
  LLinha      : String;
begin

  LTitulo      := ACBrTitulo;
  Beneficiario := LTitulo.ACBrBoleto.Cedente;
  Pagador      := LTitulo.Sacado;

  LLinha := '1' +                                                               // 001 a 001 - Tipo de Registro
    PadLeft(DefineTipoInscricao, 2, '0') +                                      // 002 a 003 - Tipo de Inscri��o Empresa
    PadLeft(OnlyNumber(Beneficiario.CNPJCPF), 14, '0') +                        // 004 a 017 - CNPJ Empresa
    PadRight(Beneficiario.Conta, 12) +                                          // 018 a 029 - C�digo da Empresa
    Space(8) +                                                                  // 030 a 037 - Uso do Banco Brancos
    PadRight(LTitulo.NumeroDocumento, 25) +                                     // 038 a 062 - Uso da Empresa
    PadRight(LTitulo.NossoNumero, 12) +                                         // 063 a 074 - Nosso N�mero
    Space(8) +                                                                  // 075 a 082 - Uso do Banco Brancos
    IntToStrZero(fpNumero, 3) +                                                 // 083 a 085 - C�digo do Banco
    Space(21) +                                                                 // 086 a 106 - Uso do Banco Brancos
    PadLeft(LTitulo.Carteira, 2, '0') +                                         // 107 a 108 - C�digo da Carteira
    TipoOcorrenciaToCodRemessa(LTitulo.OcorrenciaOriginal.Tipo) +               // 109 a 110 - C�digo Ocorr�ncia Remessa
    PadRight(LTitulo.SeuNumero, 10) +                                           // 111 a 120 - Seu N�mero
    FormatDateTime('ddmmyy', LTitulo.Vencimento) +                              // 121 a 126 - Data Vencimento
    IntToStrZero(Round(LTitulo.ValorDocumento * 100), 13) +                     // 127 a 139 - Valo Titulo
    Space(8) +                                                                  // 140 a 147 - Uso do Banco Brancos
    DefineEspecieDoc(ACBrTitulo) +                                              // 148 a 149 - Esp�cie do T�tulo
    DefineAceite(LTitulo) +                                                     // 150 a 150 - Aceite
    FormatDateTime('ddmmyy', LTitulo.DataDocumento) +                           // 151 a 156 - Data Emiss�o T�tulo
    InstrucoesProtesto(LTitulo) +                                               // 157 a 158 - Instrucao 1 159 a 160 - Instrucao 2
    IntToStrZero(Round(LTitulo.ValorMoraJuros * 100), 13) +                     // 161 a 173 - Juros ao Dia
    IfThen(LTitulo.DataDesconto < EncodeDate(2000, 01, 01),
        '000000', 
        FormatDateTime('ddmmyy', LTitulo.DataDesconto)) +                       // 174 a 179 - Data Desconto
    IntToStrZero(Round(LTitulo.ValorDesconto * 100), 13) +                      // 180 a 192 - Valor Desconto
    IfThen(LTitulo.DataMulta < EncodeDate(2000, 01, 01), 
        '000000', 
        FormatDateTime('ddmmyy', LTitulo.DataMulta)) +                          // 193 a 198 - Data Multa
    Space(7) +                                                                  // 199 a 205 - Uso do Banco Brancos
    IntToStrZero(Round(LTitulo.ValorAbatimento * 100), 13) +                    // 206 a 218 - Valor Abatimento
    DefineTipoSacado(LTitulo) +                                                 // 219 a 220 - Tipo Sacado
    PadLeft(OnlyNumber(Pagador.CNPJCPF), 14, '0') +                             // 221 a 234 - CNPJ/CPF Sacado
    PadRight(Pagador.NomeSacado, 40) +                                          // 235 a 274 - Nome do Sacado
    PadRight(Pagador.Logradouro + 
        ' ' + 
        Pagador.Numero + 
        ' ' + 
        Pagador.Complemento, 40) +                                              // 275 a 314 - Endere�o Sacado
    PadRight(Pagador.Bairro, 12) +                                              // 315 a 326 - Bairro Sacado
    PadRight(Pagador.CEP, 8) +                                                  // 327 a 334 - CEP Sacado
    PadRight(Pagador.Cidade, 15) +                                              // 335 a 349 - Cidade Sacado
    PadRight(Pagador.UF, 2) +                                                   // 350 a 351 - UF Sacado
    Space(30) +                                                                 // 352 a 381 - Sacador / Mensagem / C�digo CMC7
    IfThen(LTitulo.PercentualMulta > 0, '2', '0') +                             // 382 a 382 - Tipo de Multa
    IntToStrZero(Round(ConverterMultaPercentual(ACBrTitulo)), 2) +              // 383 a 384 - Percentual de Multa
    Space(1) +                                                                  // 385 a 385 - Uso do Banco Brancos
    IfThen(LTitulo.DataMoraJuros < EncodeDate(2000, 01, 01), 
        '000000', 
        FormatDateTime('ddmmyy', LTitulo.DataMoraJuros)) +                      // 386 a 391 - Data Juros Mora
    PadLeft(IntToStr(LTitulo.DiasDeProtesto), 2, '0') +                         // 392 a 393 - Prazo dias para Cart�rio
    Space(1) +                                                                  // 394 a 394 - Uso do Banco Brancos
    IntToStrZero(ARemessa.Count + 1, 6) +                                       // 395 a 400 - Seq�encial

    // [401 a 710] - Campos opcionais
    PadLeft(DefineTipoInscricao, 2, '0') +                                      // 401 a 402 - Tipo Emitente
    PadLeft(OnlyNumber(Beneficiario.CNPJCPF), 14, '0') +                        // 403 a 416 - CNPJ Emitente
    PadRight(Beneficiario.Nome, 40) +                                           // 417 a 456 - Nome Emitente
    PadRight(Beneficiario.Logradouro + 
         ' ' + 
         Beneficiario.NumeroRes + 
         ' ' + 
         Beneficiario.Complemento, 40) +                                        // 457 a 496 - Endere�o Emitente
    PadRight(Beneficiario.Cidade, 15) +                                         // 497 a 511 - Cidade Emitente
    PadRight(Beneficiario.UF, 2) +                                              // 512 a 513 - UF Emitente
    PadRight(Beneficiario.CEP, 8) +                                             // 514 a 521 - CEP Emitente
    PadRight(Pagador.Email, 120) +                                              // 522 a 641 - Email
    IfThen(LTitulo.DataDesconto2 < EncodeDate(2000, 01, 01), 
         '000000', 
         FormatDateTime('ddmmyy', LTitulo.DataDesconto2)) +                     // 642 a 647 - Data Desconto2
    IntToStrZero(Round(LTitulo.ValorDesconto2 * 100), 13) +                     // 648 a 660 - Valor Desconto2
    IfThen(LTitulo.DataDesconto3 < EncodeDate(2000, 01, 01), 
         '000000', 
         FormatDateTime('ddmmyy', LTitulo.DataDesconto3)) +                     // 661 a 666 - Data Desconto3
    IntToStrZero(Round(LTitulo.ValorDesconto3 * 100), 13) +                     // 667 a 679 - Valor Desconto3
    ConverterTipoPagamento(LTitulo.TipoPagamento) +                             // 680 a 680 - Indicativo de Autoriza��o para Recebimento de Valor Divergente
    IfThen(LTitulo.PercentualMinPagamento > 0, 
         'P', 
         'V') +                                                                 // 681 a 681 - Indicativo de valor ou percentual para o range m�nimo e m�ximo de aceita��o do pagamento
    PadLeft(IfThen(LTitulo.ValorMinPagamento > 0, 
         CurrToStr(LTitulo.ValorMinPagamento), 
         CurrToStr(LTitulo.PercentualMinPagamento)), 13, '0') +                 // 682 a 694 - Valor ou Percentual M�nimo para aceita��o do pagamento
    PadLeft(IfThen(LTitulo.ValorMaxPagamento > 0, 
         CurrToStr(LTitulo.ValorMaxPagamento), 
         CurrToStr(LTitulo.PercentualMaxPagamento)), 13, '0') +                 // 695 a 707 - Valor ou Percentual Maximo para aceita��o do pagamento
    Space(1) +                                                                  // 708 a 708 - Uso do Banco Brancos
    IntToStrZero(LTitulo.QtdePagamentoParcial, 2);                              // 709 a 710 - Quantidade de pagamentos parciais

  ARemessa.Add(UpperCase(LLinha));

  LLinha := MontaInstrucoesCNAB400(ACBrTitulo, ARemessa.Count);

  if not (LLinha = EmptyStr) then
    ARemessa.Add(UpperCase(LLinha));
end;

function TACBrBancoPefisa.MontaInstrucoesCNAB400(const ACBrTitulo: TACBrTitulo; const nRegistro: Integer): String;
begin
  Result := '';

  with ACBrTitulo, ACBrBoleto do
  begin

      {Primeira instru��o vai no registro 1}
    if Mensagem.Count <= 1 then
    begin
      Result := '';
      Exit;
    end;

    Result := '2' +                                                             // 001 a 001 IDENTIFICA��O DO LAYOUT PARA O REGISTRO
      Copy(PadRight(Mensagem[ 1 ], 80, ' '), 1, 80);                            // 002 a 081 CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

    if Mensagem.Count >= 3 then
      Result := Result + Copy(PadRight(Mensagem[ 2 ], 80, ' '), 1, 80)          // 082 a 161 CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                 // CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 4 then
      Result := Result + Copy(PadRight(Mensagem[ 3 ], 80, ' '), 1, 80)          // 162 a 241 CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                 // CONTE�DO DO RESTANTE DAS LINHAS

    if Mensagem.Count >= 5 then
      Result := Result + Copy(PadRight(Mensagem[ 4 ], 80, ' '), 1, 80)          // 242 a 321 CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
    else
      Result := Result + PadRight('', 80, ' ');                                 // CONTE�DO DO RESTANTE DAS LINHAS

    Result := Result + Space(44) +                                              // 322 a 365 - Uso do Banco
      PadRight(SeuNumero, 10) +                                                 // 366 a 375 - Seu N�mero
      FormatDateTime('ddmmyy', Vencimento) +                                    // 376 a 381 - Data Vencimento
      IntToStrZero(Round(ValorDocumento * 100), 13) +                           // 382 a 394 - Valo Titulo
      IntToStrZero(nRegistro + 1, 6);                                           // 395 a 400 - Sequencial
  end;
end;

function TACBrBancoPefisa.CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result := toRetornoRegistroConfirmado;
    03 : Result := toRetornoRegistroRecusado;
    04 : Result := toRetornoAlteracaoDadosNovaEntrada;
    05 : Result := toRetornoAlteracaoDadosBaixa;
    06 : Result := toRetornoLiquidado;
    07 : Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
    08 : Result := toRetornoLiquidadoEmCartorio;
    09 : Result := toRetornoBaixaSimples;
    10 : Result := toRetornoBaixadoViaArquivo;
    12 : Result := toRetornoAbatimentoConcedido;
    13 : Result := toRetornoAbatimentoCancelado;
    14 : Result := toRetornoVencimentoAlterado;
    15 : Result := toRetornoBaixaRejeitada;
    16 : Result := toRetornoInstrucaoRejeitada;
    17 : Result := toRetornoAlteracaoDadosRejeitados;
    19 : Result := toRetornoRecebimentoInstrucaoProtestar;
    20 : Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21 : Result := toRetornoConfInstrucaoNaoProtestar;
    23 : Result := toRetornoEncaminhadoACartorio;
    32 : Result := toRetornoBaixaPorProtesto;
    35 : Result := toRetornoAlegacaoDoSacado;
    36 : Result := toRetornoCustasEdital;
    37 : Result := toRetornoCustasSustacaoJudicial;
    38 : Result := toRetornoSustadoJudicial;
    65 : Result := toRetornoChequePendenteCompensacao;
    69 : Result := toRetornoChequeDevolvido;
    71 : Result := toRetornoEstornoProtesto;
    72 : Result := toRetornoBaixaAutomatica;
    74 : Result := toRetornoConfirmacaoCancelamentoBaixaAutomatica;
    75 : Result := toRetornoLiquidadoParcialmente;
    90 : Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    95 : Result := toRetornoAlteracaoUsoCedente;
    96 : Result := toRetornoTarifaExtratoPosicao;
    97 : Result := toRetornoCustasSustacao;
    98 : Result := toRetornoTarifaInstrucao;
    99 : Result := toRetornoCustasProtesto;
    else
      Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoPefisa.TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado:
      Result := '02';
    toRetornoRegistroRecusado:
      Result := '03';
    toRetornoAlteracaoDadosNovaEntrada:  
      Result := '04';
    toRetornoAlteracaoDadosBaixa:  
      Result := '05';
    toRetornoLiquidado:
      Result := '06';
    toRetornoLiquidadoAposBaixaOuNaoRegistro:
      Result := '07';
    toRetornoLiquidadoEmCartorio:
      Result := '08';
    toRetornoBaixaSimples:
      Result := '09';
    toRetornoBaixadoViaArquivo:
      Result := '10';
    toRetornoAbatimentoConcedido:
      Result := '12';
    toRetornoAbatimentoCancelado:
      Result := '13';
    toRetornoVencimentoAlterado:
      Result := '14';
    toRetornoBaixaRejeitada:  
      Result := '15';
    toRetornoInstrucaoRejeitada:  
      Result := '16';
    toRetornoAlteracaoDadosRejeitados:
      Result := '17';
    toRetornoRecebimentoInstrucaoProtestar:
      Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto:
      Result := '20';
    toRetornoConfInstrucaoNaoProtestar:  
      Result := '21';   
    toRetornoEncaminhadoACartorio:
      Result := '23';
    toRetornoBaixaPorProtesto:  
      Result := '32';
    toRetornoAlegacaoDoSacado:
      Result := '35';
    toRetornoCustasEdital:  
      Result := '36';
    toRetornoCustasSustacaoJudicial:  
      Result := '37';
    toRetornoSustadoJudicial:  
      Result := '38';
    toRetornoChequePendenteCompensacao:  
      Result := '65';
    toRetornoChequeDevolvido:  
      Result := '69';
    toRetornoEstornoProtesto:  
      Result := '71';
    toRetornoBaixaAutomatica:  
      Result := '72';
    toRetornoConfirmacaoCancelamentoBaixaAutomatica:  
      Result := '74';
    toRetornoLiquidadoParcialmente:  
      Result := '75';
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente:  
      Result := '90';
    toRetornoAlteracaoUsoCedente:  
      Result := '95';
    toRetornoTarifaExtratoPosicao:  
      Result := '96';
    toRetornoCustasSustacao:  
      Result := '97';
    toRetornoTarifaInstrucao:  
      Result := '98';
    toRetornoCustasProtesto:  
      Result := '99';
    else
      Result := '02';
  end;
end;

function TACBrBancoPefisa.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
  case TipoOcorrencia of
    toRetornoRegistroRecusado: //03
      case CodMotivo of
        9000:
          Result := '9000-Data vencimento menor que o prazo de aceita��o do t�tulo';
        9001:
          Result := '9001-Sacado bloqueado por atraso';
        9002:
          Result := '9002-Registro opcional inv�lido';
        9003:
          Result := '9003-Cep sem pra�a de cobran�a';
        9004:
          Result := '9004-Prazo insuficiente para cobran�a do t�tulo';
        9005:
          Result := '9005-Campo num�rico inv�lido';
        9006:
          Result := '9006-Campo texto inv�lido';
        9007:
          Result := '9007-Campo tipo data inv�lido';
        9008:
          Result := '9008-Caractere inv�lido';
        9009:
          Result := '9009-Cpf/Cnpj do sacado e emitente devem ser diferentes';
        9010:
          Result := '9010-Data vencimento menor que a data de emiss�o';
        9011:
          Result := '9011-Data emiss�o maior que a data atual';
        9012:
          Result := '9012-Uf sacado inv�lido';
        9013:
          Result := '9013-Uf emitente inv�lido';
        9014:
          Result := '9014-Campo obrigat�rio n�o preenchido';
        9015:
          Result := '9015-Cpf do sacado inv�lido';
        9016:
          Result := '9016-Cnpj do sacado inv�lido';
        9017:
          Result := '9017-O nome do sacado enviado n�o confere com o nome do sacado cadastrado no sistema para este Cnpj/Cpf';
        9018:
          Result := '9018-Tipo do sacado inv�lido';
        9019:
          Result := '9019-O sacado est� bloqueado';
        9020:
          Result := '9020-O endere�o do sacado esta com o tamanho esta maior que o permitido';
        9021:
          Result := '9021-Digito do nosso numero inv�lido';
        9022:
          Result := '9022-N�o existe faixa cadastrada para o banco e a conta';
        9023:
          Result := '9023-O nosso numero esta fora da faixa cadastrada para o cedente';
        9081:
          Result := '9081-Prazo insuficiente para cobran�a do t�tulo neste Cep';
        9084:
          Result := '9084-Seu n�mero do registro opcional diferente da linha do registro do t�tulo';
        9085:
          Result := '9085-Data de vencimento do registro opcional diferente da linha do registro do t�tulo';
        9086:
          Result := '9086-Valor do t�tulo no vencimento do registro opcional diferente da linha do registro do t�tulo';
        9087:
          Result := '9087-Os t�tulos de carteira de cobran�a direta s� podem ser enviados para contas de cobrna�a direta. acao: confira a carteira e a conta cobran�a que est� sendo enviada/atribuida ao t�tulo';
        9089:
          Result := '9089-C�digo cmc7 invalido';
        9090:
          Result := '9090-Entrada - nosso n�mero j� est� sendo utilizado para mesmo banco/conta';
        9091:
          Result := '9091-Cep do sacado n�o pertence ao estado da federa��o (Uf) informado';
        9092:
          Result := '9092-Tipo de multa inv�lido';
        9093:
          Result := '9093-Registro opcional de emitente inv�lido';
        9097:
          Result := '9097-O campo Nosso N�mero n�o foi informado ou n�o foi possivel identificar o titulo';
        9098:
          Result := '9098-Foi encontrado mais de um t�tulo para esse nosso n�mero';
        9099:
          Result := '9099-Preencha o campo de "conta de cobran�a" no cadastro de carteira por cedente';
        9100:
          Result := '9100-T�tulo possui registro opcional de emitente e a sua configura��o n�o permite envio de t�tulos de terceiros';
        9101:
          Result := '9101-T�tulo possui emitente, por�m seus dados n�o foram informados';
        9103:
          Result := '9103-Ja existe titulo em aberto cadastrado para este cedente/seu numero/data vencimento/valor e emitente';
        9104:
          Result := '9104-Impedido pela legisla��o vigente';
        9106:
          Result := '9106-Nosso numero nao informado';
        9232:
          Result := '9232-Sacado pertence a empresa do grupo (coligada)';
        9233:
          Result := '9233-Por solicita��o da diretoria de cr�dito/comercial';
        9234:
          Result := '9234-Inexist�ncia de rela��o com o cedente';
        9235:
          Result := '9235-Outros';
        9236:
          Result := '9236-Recusado - Outros Motivos';
        9240:
          Result := '9240-Data multa menor que data de vencimento do t�tulo';
        9250:
          Result := '9250-Tipo de autoriza��o para recebimento de valor divergente inv�lido';
        9251:
          Result := '9251-Indicativo Tipo de valor ou percentual inv�lido';
        9252:
          Result := '9252-Quantidade de pagamento parcial inv�lido';
        9254:
          Result := '9254-M�nimo n�o aceito para o t�tulo';
        9255:
          Result := '9255-M�ximo n�o aceito para o t�tulo';
        9052:
          Result := '9052-Data de desconto 2 inv�lida';
        9230:
          Result := '9230-Valor desconto 2 inv�lido';
        9258:
          Result := '9258-Data de desconto 3 inv�lida';
        9259:
          Result := '9259-Valor desconto 3 inv�lido';
        9260:
          Result := '9260-M�nimo � obrigat�rio quando informado o tipo valor ou percentual';
        9261:
          Result := '9261-Tipo de autoriza��o de recebimento de valor divergente n�o permitio para tipo de t�tulo 31';
        9262:
          Result := '9262-Para especie de t�tulo diferente de fatura de cart�o de cr�dito n�o � poss�vel informar o tipo aceita qualquer valor com range m�nimo e m�ximo  preenchido';
        9263:
          Result := '9263-M�nimo e M�ximo tem que ser informado para o tipo de autoriza��o de valor divergente igual a 2';
        9264:
          Result := '9264-M�nimo e M�ximo n�o devem ser informados para o tipo de autoriza��o de valor divergente igual a 3';
        9265:
          Result := '9265-M�nimo deve ser informado e M�ximo n�o pode ser informado para o tipo de autoriza��o de valor divergente igual a 4';
        9266:
          Result := '9266-Valor n�o permitido para tipo de t�tulo fatura de cart�o de cr�dito';
        9267:
          Result := '9267-N�o � permitido ter juros, multa, abatimento, desconto ou protesto tipo de t�tulo fatura de cart�o de cr�dito';
        9999:
          Result := '9999-Cep do sacado inv�lido';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoLiquidado: //06
      case CodMotivo of
        9105:
          Result := '9105-Cr�dito retido';
        9210:
          Result := '9210-Liquida��o em cheque';
        9216:
          Result := '9216-Liquida��o no guich� de caixa em dinheiro';
        9217:
          Result := '9217-Liquida��o em banco correspondente';
        9218:
          Result := '9218-Liquida��o por compensa��o eletr�nica';
        9219:
          Result := '9219-Liquida��o por conta';
        9223:
          Result := '9223-Liquida��o por STR';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoLiquidadoEmCartorio: //08
      case CodMotivo of
        9201:
          Result := '9201-Liquida��o em cart�rio';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixaSimples: //09
      case CodMotivo of
        9202:
          Result := '9202-Baixa decurso prazo - banco';
        9237:
          Result := '9237-Baixa por outros motivos';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixadoViaArquivo: //10
      case CodMotivo of
        0000:
          Result := '0000-Baixa comandada cliente arquivo';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoAlteracaoDadosRejeitados: //17
      case CodMotivo of
        9104:
          Result := '9104-Impedido pela legisla��o vigente';
        9113:
          Result := '9113-N�o permitimos troca de carteira no evento de Altera��o de Outros Dados';
        9114:
          Result := '9114-N�o permitimos troca de tipo titulo no evento de altera��o de outros dados';
        9250:
          Result := '9250-Tipo de autoriza��o para recebimento de valor divergente inv�lido';
        9251:
          Result := '9251-Indicativo Tipo de valor ou percentual inv�lido';
        9252:
          Result := '9252-Quantidade de pagamento parcial inv�lido';
        9253:
          Result := '9253-Quantidade de pagamento parcial inv�lido, somente � permitido um valor maior ou igual a quantidade de pagamentos j� recebido';
        9254:
          Result := '9254-M�nimo n�o aceito para o t�tulo';
        9255:
          Result := '9255-M�ximo n�o aceito para o t�tulo';
        9052:
          Result := '9052-Data de desconto 2 inv�lida';
        9230:
          Result := '9230-Valor desconto 2 inv�lido';
        9258:
          Result := '9258-Data de desconto 3 inv�lida';
        9259:
          Result := '9259-Valor desconto 3 inv�lido';
        9260:
          Result := '9260-M�nimo � obrigat�rio quando informado o tipo valor ou percentual';
        9261:
          Result := '9261-Tipo de autoriza��o de recebimento de valor divergente n�o permitio para tipo de t�tulo 31';
        9262:
          Result := '9262-Para especie de t�tulo diferente de fatura de cart�o de cr�dito n�o � poss�vel informar o tipo aceita qualquer valor com range m�nimo e m�ximo  preenchido';
        9263:
          Result := '9263-M�nimo e M�ximo tem que ser informado para o tipo de autoriza��o de valor divergente igual a 2';
        9264:
          Result := '9264-M�nimo e M�ximo n�o devem ser informados para o tipo de autoriza��o de valor divergente igual a 3';
        9265:
          Result := '9265-M�nimo deve ser informado e M�ximo n�o pode ser informado para o tipo de autoriza��o de valor divergente igual a 4';
        9266:
          Result := '9266-Valor n�o permitido para tipo de t�tulo fatura de cart�o de cr�dito';
        9267:
          Result := '9267-N�o � permitido ter juros, multa, abatimento, desconto ou protesto tipo de t�tulo fatura de cart�o de cr�dito';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoBaixaPorProtesto: //32
      case CodMotivo of
        9203:
          Result := '9203-Baixa protestado';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoAlegacaoDoSacado: //35
      case CodMotivo of
        9238:
          Result := '9238-Pagador Rejeita Boleto';
        9239:
          Result := '9239-Pagador Aceita Boleto';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoCustasEdital: //36
      case CodMotivo of
        9207:
          Result := '9207-Custas de edital';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoCustasSustacaoJudicial: //37
      case CodMotivo of
        9208:
          Result := '9208-Custas de susta��o de protesto';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoTituloSustadoJudicialmente: //38
      case CodMotivo of
        0000:
          Result := '0000-T�tulo sustado judicialmente';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

    toRetornoLiquidadoParcialmente: //75
      case CodMotivo of
        9105:
          Result := '9105-Cr�dito retido';
        9216:
          Result := '9216-Liquida��o no guich� de caixa em dinheiro';
        9217:
          Result := '9217-Liquida��o em banco correspondente';
        9218:
          Result := '9218-Liquida��o por compensa��o eletr�nica';
        9219:
          Result := '9219-Liquida��o por conta';
        9223:
          Result := '9223-Liquida��o por STR';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente: //90
      case CodMotivo of
        9108:
          Result := '9108-T�tulo pertence a uma esp�cie que n�o pode ser protestada';
        9109:
          Result := '9109-Protesto n�o permitido para t�tulo com moeda diferente de real';
        9110:
          Result := '9110-Cep do sacado n�o atendido pelos cart�rios cadastrados';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoTarifaExtratoPosicao: //96
      case CodMotivo of
        9213:
          Result := '9213-Tarifa de manuten��o de t�tulo vencido';
        9222:
          Result := '9222-Emiss�o extrato mov. carteira';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoDespesasSustacaoProtesto: //97
      case CodMotivo of
        9204:
          Result := '9204-Tarifa de sustacao de protesto';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoDespesasProtesto: //98
      case CodMotivo of
        9205:
          Result := '9205-Tarifa de protesto';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoCustasProtesto: //99
      case CodMotivo of
        9206:
          Result := '9206-Custas de protesto';
        else
          Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    else
      Result := '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
  end;

  if (Result = '0000') then
  begin
    case CodMotivo of
      9024:
        Result := '9024-Identifica��o do t�tulo inv�lida';
      9025:
        Result := '9025-Ocorr�ncia n�o permitida pois o t�tulo esta baixado';
      9026:
        Result := '9026-Ocorr�ncia n�o permitida pois o t�tulo esta liquidado';
      9027:
        Result := '9027-Ocorr�ncia n�o permitida pois o t�tulo esta em protesto';
      9028:
        Result := '9028-N�o � permitida altera��o de vencimento para carteira de desconto';
      9029:
        Result := '9029-Situa��o do t�tulo inv�lida';
      9030:
        Result := '9030-N�o foi poss�vel conceder o abatimento';
      9031:
        Result := '9031-N�o existe abatimento a ser cancelado';
      9032:
        Result := '9032-N�o foi poss�vel prorrogar a data de vencimento do t�tulo';
      9033:
        Result := '9033-Evento n�o permitido para situa��o do t�tulo';
      9034:
        Result := '9034-Evento n�o permitido para cheques';
      9035:
        Result := '9035-O c�digo do registro esta diferente de 1';
      9036:
        Result := '9036-Ag�ncia inv�lida';
      9037:
        Result := '9037-N�mero da Conta Corrente para dep�sito Inv�lido';
      9038:
        Result := '9038-O Cnpj do cedente passado para o arquivo n�o confere com o Cnpj do cedente cadastrado para o arquivo';
      9040:
        Result := '9040-Cnpj do cedente n�o encontrado no cadastro';
      9041:
        Result := '9041-Tipo do emitente inv�lido';
      9042:
        Result := '9042-Cnpj do emitente inv�lido';
      9045:
        Result := '9045-Campo nosso numero deve ter um valor de, no m�ximo , 10 digitos quando a carteira de cobran�a n�o � direta';
      9046:
        Result := '9046-No campo nosso n�mero a identifica��o do t�tulo esta inv�lida';
      9047:
        Result := '9047-Banco e conta de cobran�a direta n�o informados';
      9049:
        Result := '9049-Campo aceite enviado com valor nulo ou inv�lido';
      9050:
        Result := '9050-Data de emis�o inv�lida';
      9051:
        Result := '9051-Data de vencimento inv�lida';
      9052:
        Result := '9052-Data de desconto inv�lida';
      9053:
        Result := '9053-Especie de titulo invalida';
      9054:
        Result := '9054-Especie de titulo n�o encontrada';
      9055:
        Result := '9055-Valor de t�tulo inv�lido';
      9056:
        Result := '9056-Prazo de cartorio invalido';
      9057:
        Result := '9057-Valor de abatimento inv�lido';
      9058:
        Result := '9058-Valor de desconto inv�lido';
      9059:
        Result := '9059-C�digo de ocorr�ncia inv�lida ou inexistente';
      9060:
        Result := '9060-Tipo de mora inv�lido';
      9062:
        Result := '9062-Valor de juros ao dia inv�lido';
      9063:
        Result := '9063-A data de juros mora � anterior � data de vencimento. Favor verificar estes campos';
      9064:
        Result := '9064-A data de juros mora inv�lida';
      9065:
        Result := '9065-N�mero da sequ�ncia diferente do esperado';
      9066:
        Result := '9066-N�mero de sequencia inv�lido';
      9067:
        Result := '9067-Registro inv�lido';
      9068:
        Result := '9068-Cpf do emitente inv�lido';
      9070:
        Result := '9070-Nome do emitente inv�lido';
      9071:
        Result := '9071-Endere�o do emitente inv�lido';
      9072:
        Result := '9072-Cidade do emitente inv�lida';
      9073:
        Result := '9073-Cep do emitente inv�lido';
      9074:
        Result := '9074-Este contrato n�o est� cadastrado para o cedente';
      9075:
        Result := '9075-N�o � permitida a entrada de t�tulos vencidos';
      9078:
        Result := '9078-N�o existe endere�o, uf e cidade para o t�tulo';
      9079:
        Result := '9079-Nosso n�mero inv�lido';
      9083:
        Result := '9083-O cedente n�o pode enviar esse tipo de t�tulo com esta carteira';
      9107:
        Result := '9107-Tamanho m�ximo do nosso n�mero para cobran�a direta � 10 posi��es + digito(layout padrao matera/bradesco)';
      9224:
        Result := '9224-Carteira do Tipo G n�o pode inserir titulos';
      else
        Result := IntToStrZero(CodMotivo, 4) + ' - Outros Motivos';
    end;
  end;
end;

function TACBrBancoPefisa.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRemessaBaixar;                                              //Pedido de Baixa
                                                                
    04 : Result := toRemessaConcederAbatimento;                                 //Concess�o de Abatimento
                                                                 
    05 : Result := toRemessaCancelarAbatimento;                                 //Cancelamento de Abatimento Concedido
                                                                  
    06 : Result := toRemessaAlterarVencimento;                                  //Altera��o Vencimento
                                                                
    07 : Result := toRemessaAlterarUsoEmpresa;                                  //Troca Uso Empresa
                                                                  
    09 : Result := toRemessaProtestar;                                          //Pedido de Protesto
                                                                  
    18 : Result := toRemessaCancelarInstrucaoProtestoBaixa;                     //Sustar Protesto e Baixar o T�ulo
                                                                  
    19 : Result := toRemessaCancelarInstrucaoProtesto;                          //Sustar o Protesto e Manter em Carteira
                                                                  
    31 : Result := toRemessaOutrasAlteracoes;                                   //Altera��o de Outros Dados
                                           
    else
      Result := toRemessaRegistrar;                                             //Remessa
  end;
end;

function TACBrBancoPefisa.TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  case TipoOcorrencia of
    toRemessaBaixar:
      Result := '02';                                                           //Pedido de Baixa
    toRemessaConcederAbatimento:
      Result := '04';                                                           //Concess�o de Abatimento
    toRemessaCancelarAbatimento:
      Result := '05';                                                           //Cancelamento de Abatimento Concedido
    toRemessaAlterarVencimento:
      Result := '06';                                                           //Altera��o Vencimento
    toRemessaAlterarUsoEmpresa:
      Result := '07';                                                           //Troca Uso Empresa
    toRemessaProtestar:
      Result := '09';                                                           //Pedido de Protesto
    toRemessaCancelarInstrucaoProtestoBaixa:
      Result := '18';                                                           //Sustar Protesto e Baixar o T�ulo
    toRemessaCancelarInstrucaoProtesto:
      Result := '19';                                                           //Sustar o Protesto e Manter em Carteira
    toRemessaOutrasAlteracoes:
      Result := '31';                                                           //Altera��o de Outros Dados
    else
      Result := '01';                                                           //Remessa
  end;
end;

end.
