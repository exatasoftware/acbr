{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Paulo H. Ribeiro,                      }
{                                       Jackeline Bellon,                      }
{                                       Juliomar Marchetti e                   }
{                                       Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Andr� Ferreira de Moraes                       }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrBancoSafra;

interface

uses Classes, SysUtils, StrUtils, ACBrBoleto;

type

  { TACBrBancoSafra }
  TACBrBancoSafra = class(TACBrBancoClass)
  private
  protected
    FNumeroRemessa: Integer;
  public
    constructor Create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;
    procedure GerarRegistroHeader400(NumeroRemessa: integer;
      ARemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo;
      aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;

    function TipoOcorrenciaToDescricao(
      const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
    function CodOcorrenciaToTipo(const CodOcorrencia: integer): TACBrTipoOcorrencia;
      override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): string;
      override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia;
      CodMotivo: integer): string; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
  end;

implementation

uses ACBrUtil;

var
  aTotal: Extended;
  aCount: Integer;

{ TACBrBancoSafra }

constructor TACBrBancoSafra.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpDigito                := 7;
  fpNome                  := 'Banco Safra';
  fpNumero                := 422;
  fpTamanhoAgencia        := 4;
  fpTamanhoConta          := 8;
  fpTamanhoCarteira       := 1;
  fpTamanhoMaximoNossoNum := 9;
end;

function TACBrBancoSafra.CalcularDigitoVerificador(
  const ACBrTitulo: TACBrTitulo): string;
begin
  Modulo.CalculoPadrao;
  Modulo.Documento := ACBrTitulo.NossoNumero;
  Modulo.Calcular;
  if Modulo.ModuloFinal = 0 then
    Result := '1'
  else
    Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoSafra.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: integer): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroRecusado:
      case CodMotivo of
        001: Result := '001-MOEDA INV�LIDA';
        002: Result := '002-MOEDA INV�LIDA PARA CARTEIRA';
        003: Result := '003-CARTEIRA TR�S INV�LIDA PARA TIPO DE MOEDA';
        004: Result := '004-TIPO DE IOF. INV�LIDO PARA CPBRAN�A DE SEGUROS';
        005: Result := '005-TIPO DE IOF. INV�LIDO PARA VALOR DE IOF (SEGUROS)';
        006: Result := '006-VALOR DE IOF INV�LIDO (SEGUROS)';
        007: Result := '007-CEP N�O CORRESPONDE UF';
        008: Result := '008-VALOR JUROS AO DIA MAIOR QUE 5% DO VALOR DO T�TULO';
        009: Result := '009-USO EXCLUSIVO N�O NUM�RICO PARA COBRAN�A EXPRESS';
        010: Result := '010-SEU N�MERO - N�O NUM�RICO PARA CHEQUE';
        011: Result := '011-NOSSO N�MERO FORA DA FAIXA';
        012: Result := '012-CEP DE CIDADE INEXISTENTE';
        013: Result := '013 - CEP FORA DE FAIXA DA CIDADE';
        014: Result := '014 - UF INVALIDO PARA CEP DA CIDADE';
        015: Result := '015 - CEP ZERADO';
        016: Result := '016 - CEP N�O CONSTA NA TABELA SAFRA';
        017: Result := '017 - CEP N�O CONSTA TABELA BCO. CORRESPONDENTE';
        018: Result := '018 - DADOS DO CHEQUE N�O NUM�RICO';
        019: Result := '019 - PROTESTO IMPRATIC�VEL';
        020: Result := '020 - PRIMEIRA INSTRU��O DE COBRAN�A INVALIDA';
        021: Result := '021 - SEGUNDA INSTRU��O DE COBRAN�A INV�LIDA';
        022: Result := '022 - SEGUNDA INSTR. (10) E TERCEIRA INSTR. INVALIDA';
        023: Result := '023 - TERCEIRA INSTRU��O DE COBRAN�A INV�LIDA';
        024: Result := '024 - DIGITO VERIFICADOR C1 INV�LIDO';
        025: Result := '025 - DIGITO VERIFICADOR C2 INV�LIDO';
        026: Result := '026 - C�DIGO DE OPERA��O/OCORR�NCIA INV�LIDO';
        027: Result := '027 - OPERA��O INV�LIDA PARA O CLIENTE';
        028: Result := '028 - NOSSO N�MERO N�O NUM�RICO OU ZERADO';
        029: Result := '029 - NOSSO N�MERO COM D�GITO DE CONTROLE ERRADO';
        030: Result := '030 - VALOR DO ABATIMENTO N�O NUM�RICO OU ZERADO';
        031: Result := '031 - SEU N�MERO EM BRANCO';
        032: Result := '032 - C�DIGO DA CARTEIRA INV�LIDO';
        033: Result := '033 - DIGITO VERIFICADOR C3 INV�LIDO';
        034: Result := '034 - C�DIGO DO T�TULO INV�LIDO';
        035: Result := '035 - DATA DE MOVIMENTO INV�LIDA';
        036: Result := '036 - DATA DE EMISS�O INV�LIDA';
        037: Result := '037 - DATA DE VENCIMENTO INV�LIDA';
        038: Result := '038 - DEPOSIT�RIA INV�LIDA';
        039: Result := '039 - DEPOSIT�RIA INV�LIDA PARA O CLIENTE';
        040: Result := '040 - DEPOSIT�RIA N�O CADASTRADA NO BANCO';
        041: Result := '041 - C�DIGO DE ACEITE INV�LIDO';
        042: Result := '042 - ESP�CIE DE T�TULO INV�LIDO';
        043: Result := '043 - INSTRU��O DE COBRAN�A INV�LIDA';
        044: Result := '044 - VALOR DO T�TULO N�O NUM�RICO OU ZERADO';
        045: Result := '045 - DATA DE OPERA��O INVALIDA';
        046: Result := '046 - VALOR DE JUROS N�O NUM�RICO OU ZERADO';
        047: Result := '047 - DATA LIMITE PARA DESCONTO INV�LIDA';
        048: Result := '048 - VALOR DO DESCONTO INV�LIDO';
        049: Result := '049 - VALOR IOF. N�O NUM�RICO OU ZERADO (SEGUROS)';
        050: Result := '050 - ABATIMENTO COM VALOR PARA OPERA��O "01" (Entrada de T�tulo)';
        051: Result := '051 - C�DIGO DE INSCRI��O DO SACADO INV�LIDO';
        052: Result := '052 - C�DIGO DE INSCRI��O / N�MERO DE INSCRI��O DO SACADO INV�LIDO';
        053: Result := '053 - N�MERO DE INSCRI��O DO SACADO N�O NUM�RICO OU D�GITO ERRADO';
        054: Result := '054 - NOME DO SACADO EM BRANCO';
        055: Result := '055 - ENDERE�O DO SACADO EM BRANCO';
        056: Result := '056 - CLIENTE N�O RECADASTRADO';
        057: Result := '057 - CLIENTE BLOQUEADO (quando opera��o de desconto e cliente sem n�mero; de border� dispon�vel)';
        058: Result := '058 - PROCESSO DE CART�RIO INV�LIDO';
        059: Result := '059 - ESTADO DO SACADO INV�LIDO';
        060: Result := '060 - CEP / ENDERE�O DIVERGEM DO CORREIO';
        061: Result := '061 - INSTRU��O AGENDADA PARA AG�NCIA';
        062: Result := '062 - OPERA��O INV�LIDA PARA A CARTEIRA';
        063: Result := '063 - Carteira inv�lida para Cobran�a Direta';
        064: Result := '064 - T�TULO INEXISTENTE (TFC)';
        065: Result := '065 - OPERA��O / T�tulo J� EXISTENTE';
        066: Result := '066 - T�TULO J� EXISTE (TFC)';
        067: Result := '067 - DATA DE VENCIMENTO INV�LIDA PARA PROTESTO';
        068: Result := '068 - CEP DO SACADO N�O CONSTA NA TABELA';
        069: Result := '069 - PRA�A N�O ATENDIDA PELO SERVI�O CART�RIO';
        070: Result := '070 - AG�NCIA INV�LIDA';
        071: Result := '071 - CLIENTE N�O CADASTRADO';
        072: Result := '072 - T�TULO J� EXISTE (COB)';
        073: Result := '073 - TAXA OPERA��O N�O NUM�RICA OU ZERADA (VENDOR)';
        074: Result := '074 - T�TULO FORA DE SEQ��NCIA';
        075: Result := '075 - TAXA DE OPERA��O ZERADA (VENDOR)';
        076: Result := '076 - EQUALIZA��O N�O NUM�RICA OU INV�LIDA (VENDOR)';
        077: Result := '077 - TAXA NEGOCIADA N�O NUM�RICA OU ZERADA (VENDOR)';
        078: Result := '078 - T�TULO INEXISTENTE (COB)';
        079: Result := '079 - OPERA��O N�O CONCLU�DA';
        080: Result := '080 - T�TULO J� Baixado';
        081: Result := '081 - T�TULO N�O DESCONTADO';
        082: Result := '082 - INTERVALO ENTRE DATA DE OPERA��O E DATA VCTO MENOR QUE UM DIA';
        083: Result := '083 - PRORROGA��O / ALTERA��O DE VENCIMENTO INV�LIDA';
        084: Result := '084 - MOVIMENTO IGUAL AO CADASTRO DE EXIST�NCIA DO COB';
        085: Result := '085 - C�DIGO OPERA��O COM PCB INV�LIDO (OPERA��O INV�LIDA P/ CARTEIRA)';
        086: Result := '086 - ABATIMENTO MAIOR QUE VALOR DO T�TULO';
        087: Result := '087 - ALTERA��O DE CART�RIO INV�LIDA';
        088: Result := '088 - T�TULO RECUSADO COMO GARANTIA (Sacado / Novo / Exclusivo Al�ada comit�)';
        089: Result := '089 - ALTERA��O DE DATA DE PROTESTO INV�LIDA';
        090: Result := '090 - MODALIDADE DE VENDOR INVALIDO';
        091: Result := '091 - PCB CTO INVALIDA';
        092: Result := '092 - DATA DE OPERA��O CTO INV�LIDA';
        093: Result := '093 - BAIXA DE T�TULO DE OUTRA AG�NCIA';
        094: Result := '094 - ENTRADA T�TULO COBRAN�A DIRETA INV�LIDA';
        095: Result := '095 - BAIXA T�TULO COBRAN�A DIRETA INV�LIDA';
        096: Result := '096 - VALOR DO T�TULO INV�LIDO';
        097: Result := '097 - MOEDA INV�LIDA PARA BANCO CORRESPONDENTE';
        098: Result := '098 - PCB DO TFC DIVERGEM DA PCB DO COB';
        099: Result := '099 - INCLUS�O DE TERCEIRA MOEDA INV�LIDA';
        100: Result := '115 - ESP�CIE DOC INV�LIDO PARA MODAL/RAMO DE ATIVIDADE (RESERVADO CTO)';
        else
          Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
      end;
  end;
end;

function TACBrBancoSafra.CodOcorrenciaToTipo(const CodOcorrencia: integer):
TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    04: Result := toRetornoTransferenciaCarteiraEntrada;
    05: Result := toRetornoTransferenciaCarteiraBaixa;
    06: Result := toRetornoLiquidado;
    07: Result := toRetornoLiquidadoParcialmente;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixadoInstAgencia;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    16: Result := toRetornoBaixadoFrancoPagamento;
    17: Result := toRetornoEntradaBorderoManual;
    18: Result := toRetornoAlteracaoUsoCedente;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoTransferenciaCedente;
    23: Result := toRetornoEncaminhadoACartorio;
    40: Result := toRetornoBaixaPorProtesto;
    41: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
    42: Result := toRetornoRetiradoDeCartorio;
    43: Result := toRetornoDespesaCartorio;
    44: Result := toRetornoDebitoDiretoAutorizado;
    45: Result := toRetornoDebitoDiretoNaoAutorizado;
    51: Result := toRetornoRecebimentoInstrucaoAlterarValorTitulo;
    52: Result := toRetornoAlteracaoDataEmissao;
    53: Result := toRetornoAlteracaoEspecie;
    54: Result := toRetornoAlteracaoSeuNumero;
    60: Result := toRetornoEqualizacaoVendor;
    77: Result := toRetornoRecebimentoInstrucaoAlterarJuros;
    else
      Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoSafra.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarExclusivoCliente;         {Altera��o "Uso Exclusivo do Cliente"}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    10 : Result:= toRemessaNaoProtestar;                    {N�o Protestar}
    11 : Result:= toRemessaNaoCobrarJurosMora;              {N�o Cobrar Juros de Mora}
    16 : Result:= toRemessaCobrarJurosMora;                 {Cobrar Juros de Mora}
    31 : Result:= toRemessaAlterarValorTitulo;              {Altera��o do Valor do T�tulo}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;

procedure TACBrBancoSafra.GerarRegistroHeader400(NumeroRemessa: integer;
  ARemessa: TStringList);
var wLinha: String;
begin
  aTotal := 0;
  aCount := 0;
  FNumeroRemessa := NumeroRemessa;

  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    wLinha := '0'                             + // ID do Registro Header
              '1'                             + // ID do Arquivo de Remessa
              'REMESSA'                       + // Literal de Remessa
              '01'                            + // C�digo do Tipo de Servi�o
              PadRight('COBRANCA', 15)        + // Descri��o do tipo de servi�o + "brancos"
              PadLeft(CodigoCedente, 14, '0') + // Codigo da Empresa no Banco
              Space(6)                        + // "brancos"
              PadRight(Nome, 30)              + // Nome da Empresa
              IntToStr(Numero)                + // C�digo do Banco - 237
              PadRight('BANCO SAFRA', 15)     + // Nome do Banco - BANCO SAFRA + "brancos"
              FormatDateTime('ddmmyy', Now)   + // Data de gera��o do arquivo
              Space(291)                      + // "brancos"
              IntToStrZero(NumeroRemessa, 3)  + // Nr. Sequencial de Gera��o do Arquivo
              IntToStrZero(1, 6);               // Nr. Sequencial do Registro no Arquivo

    ARemessa.Text := ARemessa.Text + UpperCase(wLinha);
  end;

end;

procedure TACBrBancoSafra.GerarRegistroTrailler400(ARemessa: TStringList);
var
  wLinha: String;
begin
  wLinha := '9'                               + // Identifica��o do Registro do Trailler
  Space(367)                                  + // "Branc"
  PadLeft(IntToStr(aCount), 8, '0')           + // Quantidade de t�tulos no arquivo
  FormatCurr('000000000000000', aTotal * 100) + // Valor total dos t�tulos
  IntToStrZero(FNumeroRemessa, 3)             + // Nr. Sequencial de Gera��o do Arquivo
  IntToStrZero(ARemessa.Count + 1, 6);          // N�mero Sequencial do Registro do Arquivo

  ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);

end;

procedure TACBrBancoSafra.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo;
  aRemessa: TStringList);
var
  wLinha, tipoInscricao, aAgencia, aConta: String;
  Ocorrencia, aEspecie, aAceite, aInstrucao2: String;
  aTipoSacado, sDataDesconto:String;
begin
  with ACBrTitulo do
  begin
    if ACBrBoleto.Cedente.TipoInscricao = pFisica then
      tipoInscricao := '01'
    else
      tipoInscricao := '02';

    aAgencia := PadLeft(ACBrBoleto.Cedente.Agencia, 4, '0') +
                PadLeft(ACBrBoleto.Cedente.AgenciaDigito, 1, '0');

    aConta := PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') +
              PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');

    {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                 : Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento     : Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento     : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento      : Ocorrencia := '06'; {Altera��o de vencimento}
      toRemessaAlterarExclusivoCliente: Ocorrencia := '07'; {Altera��o "Uso Exclusivo do Cliente"}
      toRemessaAlterarNumeroControle  : Ocorrencia := '08'; {Altera��o de seu n�mero}
      toRemessaProtestar              : Ocorrencia := '09'; {Pedido de protesto}
      toRemessaNaoProtestar           : Ocorrencia := '10'; {N�o Protestar}
      toRemessaNaoCobrarJurosMora     : Ocorrencia := '11'; {N�o Cobrar Juros de Mora}
      toRemessaCobrarJurosMora        : Ocorrencia := '16'; {Cobrar Juros de Mora}
      toRemessaAlterarValorTitulo     : Ocorrencia := '31'; {Altera��o do Valor do T�tulo}
      else
        Ocorrencia := '01'; {Remessa}
    end;

    {Pegando Especie}
    if trim(EspecieDoc) = 'DM' then
      aEspecie := '01'
    else if trim(EspecieDoc) = 'NP' then
      aEspecie := '02'
    else if trim(EspecieDoc) = 'NS' then
      aEspecie := '03'
    else if trim(EspecieDoc) = 'RC' then
      aEspecie := '05'
    else if Trim(EspecieDoc) = 'DS' then
      aEspecie := '09'
    else
      aEspecie := EspecieDoc;

    if Aceite = atSim then
      aAceite := 'A'
    else
      aAceite := 'N';

    if StrToIntDef(Instrucao3,0) > 0 then
      aInstrucao2 := '10'
    else
      aInstrucao2 := PadLeft(trim(Instrucao2), 2, '0');

    if Sacado.Pessoa = pFisica then
      aTipoSacado := '01'
    else if Sacado.Pessoa = pJuridica then
      aTipoSacado := '02'
    else
      aTipoSacado := '03';

    if DataDesconto = 0 then
      sDataDesconto := '000000'
    else
      sDataDesconto := FormatDateTime('ddmmyy', DataDesconto);

    wLinha := '1'                                                                            + //   1 a   1 - Identifica��o do Registro de Transa��o
              tipoInscricao                                                                  + //   2 a   3 - Tipo de Inscri��o da Empresa
              PadLeft(OnlyNumber(ACBrBoleto.Cedente.CNPJCPF), 14, '0')                       + //   4 a  17 - N�mero da Inscri��o da Empresa
              aAgencia + aConta                                                              + //  18 a  31 - Identifica��o da Empresa no Banco
              Space(6)                                                                       + //  32 a  37 - "Brancos"
              Space(25)                                                                      + //  38 a  62 - Uso exclusivo da Empresa
              IfThen(NossoNumero = '000000000', '000000000',
                                 PadLeft(RightStr(NossoNumero,8),8,'0') +
                                 CalcularDigitoVerificador(ACBrTitulo)) +                      //  63 a  71 - N�mero do t�tulo no banco
              Space(30)                                                                      + //  72 a 101 - "Brancos"
              '0'                                                                            + // 102 a 102 - C�digo de IOF sobre Opera��es de Seguro
              '00'                                                                           + // 103 a 104 - Identifica��o do Tipo de Moeda, 00=Real
              Space(1)                                                                       + // 105 a 105 - "Branco"
              IntToStrZero(StrToIntDef(Instrucao3,0), 2)                                     + // 106 a 107 - Terceira Instru��o de Cobran�a. Utilizar somente quando Instru��o2 � igual a 10
              Carteira                                                                       + // 108 a 108 - Identifica��o do Tipo de Carteira
              Ocorrencia                                                                     + // 109 a 110 - Identifica��o do Tipo de Ocorr�ncia
              PadRight(SeuNumero, 10)                                                        + // 111 a 120 - Identifica��o do T�tulo da Empresa
              FormatDateTime('ddmmyy', Vencimento)                                           + // 121 a 126 - Data de Vencimento do T�tulo
              IntToStrZero(Round(ValorDocumento * 100), 13)                                  + // 127 a 139 - Valor Nominal do T�tulo
              IntToStr(ACBrBoleto.Banco.Numero)                                              + // 140 a 142 - C�digo do Banco encarregado da cobra�a
              '00000'                                                                        + // 143 a 147 - Ag�ncia Encarregada da Cobran�a
              aEspecie                                                                       + // 148 a 149 - Esp�cie do T�tulo
              aAceite                                                                        + // 150 a 150 - Identifica��o do Aceite do T�tulo
              FormatDateTime('ddmmyy', DataDocumento)                                        + // 151 a 156 - Data de Emiss�o do T�tulo
              PadLeft(trim(Instrucao1), 2, '0')                                              + // 157 a 158 - Primeira Instru��o de Cobran�a
              aInstrucao2                                                                    + // 159 a 160 - Segunda Instru��o de Cobran�a
              IntToStrZero(round(ValorMoraJuros * 100), 13)                                  + // 161 a 173 - Juros de Mora Por Dia de Atraso
              sDataDesconto                                                                  + // 174 a 179 - Data Limite para Desconto
              IntToStrZero(round(ValorDesconto * 100), 13)                                   + // 180 a 192 - Valor Do Desconto Concedido
              IntToStrZero(round(ValorIOF * 100), 13)                                        + // 193 a 205 - Valor De Iof Opera��es Deseguro

              IfThen( ((Ocorrencia = '01') and (Copy(Instrucao1, 1, 2) = '16')),
                (FormatDateTime('ddmmyy', DataMulta) +                                         // 206 a 211 a data a partir da qual a multa deve ser cobrada
                IntToStrZero(round(PercentualMulta * 100), 4) +                                // 212 a 215 o percentual referente � multa no formato 99v99
                '000'),                                                                        // 216 a 218 zeros
                IntToStrZero(round(ValorAbatimento * 100), 13)  )                            + // Valor Do Abatimento Concedido Ou Cancelado / Multa

              aTipoSacado                                                                    + // 219 a 220 - C�digo De Inscri��o Do Sacado
              PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                                   + // 221 a 234 - N�mero de Inscri��o do Sacado
              PadRight(Sacado.NomeSacado, 40, ' ')                                           + // 235 a 274 - Nome Do Sacado
              PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40, ' ')                     + // 275 a 314 - Endere�o Do Sacado
              PadRight(Sacado.Bairro, 10, ' ')                                               + // 315 a 324 - Bairro Do Sacado
              Space(2)                                                                       + // 325 a 326 - Brancos
              PadRight(Sacado.CEP, 8)                                                        + // 327 a 334 - CEP do Sacado
              PadRight(Sacado.Cidade, 15)                                                    + // 335 a 349 - Cidade do Sacado
              PadRight(Sacado.UF, 2)                                                         + // 350 a 351 - UF do Sacado
              PadRight(Sacado.SacadoAvalista.NomeAvalista, 30)                               + // 352 a 381 - Nome do Sacador Avalista / Mensagem espec�fica vide nota 6.1.9 conforme manual do banco
              Space(7)                                                                       + // 382 a 388 - "Brancos"
              '422'                                                                          + // 389 a 391 - Banco Emitente do Boleto
              copy(aRemessa.Text, 392, 3)                                                    + // 392 a 394 - Numero Seq�encial Gera��o Arquivo Remessa
              IntToStrZero(ARemessa.Count + 1, 6);                                             // 395 a 400 - N�mero Sequencial De Registro De Arquivo

    aTotal := aTotal + ValorDocumento;
    Inc(aCount);
    aRemessa.Text := aRemessa.Text + wLinha;
  end;
end;

procedure TACBrBancoSafra.LerRetorno400(ARetorno: TStringList);
var
  rCodEmpresa, rCedente, rAgencia, rDigitoAgencia: String;
  rConta, rDigitoConta, rCNPJCPF, Linha: String;
  ContLinha, CodOcorrencia: Integer;
  Titulo: TACBrTitulo;
begin
  if StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                           'n�o � um arquivo de retorno do ' + Nome));

  rCodEmpresa    := trim(Copy(ARetorno[0], 27, 14));
  rCedente       := trim(Copy(ARetorno[0], 47, 30));
  rAgencia       := trim(Copy(ARetorno[1], 18, ACBrBanco.TamanhoAgencia));
  rDigitoAgencia := trim(Copy(ARetorno[1], 22, 1));
  rConta         := trim(Copy(ARetorno[1], 23, ACBrBanco.TamanhoConta));
  rDigitoConta   := Copy(ARetorno[1], 31, 1);

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                                                          Copy(ARetorno[0], 97, 2) + '/' +
                                                          Copy(ARetorno[0], 99, 2), 0,
                                                          'DD/MM/YY');

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0], 392, 3), 0);

  ValidarDadosRetorno(rAgencia, rConta);
  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCodEmpresa <>
        PadLeft(Cedente.CodigoCedente, 14, '0')) then
      raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido'));

    case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
      01: Cedente.TipoInscricao := pFisica;
      02: Cedente.TipoInscricao := pJuridica;
      else
        Cedente.TipoInscricao := pJuridica;
    end;

    rCNPJCPF := Copy(ARetorno[1], 4, 14);

    if LeCedenteRetorno then
    begin
      try
        Cedente.CNPJCPF := rCNPJCPF;
      except
      end;

      Cedente.CodigoCedente := rCodEmpresa;
      Cedente.Nome          := rCedente;
      Cedente.Agencia       := rAgencia;
      Cedente.AgenciaDigito := rDigitoAgencia;
      Cedente.Conta         := rConta;
      Cedente.ContaDigito   := rDigitoConta;
    end;

    ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
  end;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if Copy(Linha, 1, 1) <> '1' then
      Continue;

    Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    with Titulo do
    begin

      NossoNumero := Copy(Linha, 63, 8);
      OcorrenciaOriginal.Tipo :=
        CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 109, 2), 0));

      Carteira := copy(Linha, 108, 1);

      CodOcorrencia  := StrToIntDef(copy(Linha, 109, 2),0);
      DataOcorrencia := StringToDateTimeDef(copy(Linha, 111, 2) + '/' +
                                            copy(Linha, 113, 2) + '/' +
                                            copy(Linha, 115, 2), 0, 'DD/MM/YY');

      if CodOcorrencia = 03 then // entrada rejeitada
      begin
        MotivoRejeicaoComando.Add(copy(Linha, 105, 3));
        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(
          toRetornoRegistroRecusado, StrToIntDef(copy(Linha, 105, 3),0)));
      end;
      SeuNumero := copy(Linha, 117, 10);

      if Copy(Linha, 147, 2) <> '00' then
        Vencimento := StringToDateTimeDef(copy(Linha, 147, 2) + '/' +
                                          copy(Linha, 149, 2) + '/' +
                                          copy(Linha, 151, 2), 0, 'DD/MM/YY');

      ValorDocumento       := StrToFloatDef(copy(Linha, 153, 13), 0) / 100;
      EspecieDoc           := copy(Linha, 174, 2);
      ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100;
      ValorOutrasDespesas  := StrToFloatDef(Copy(Linha, 189, 13), 0) / 100;
      ValorIOF             := StrToFloatDef(Copy(Linha, 215, 13), 0) / 100;
      ValorAbatimento      := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100;
      ValorDesconto        := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100;
      ValorRecebido        := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100;
      ValorMoraJuros       := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100;
      ValorOutrosCreditos  := StrToFloatDef(Copy(Linha, 280, 13), 0) / 100;

      if Copy(Linha, 296, 2) <> '00' then
        DataCredito := StringToDateTimeDef(copy(Linha, 296, 2) + '/' +
                                           copy(Linha, 298, 2) + '/' +
                                           copy(Linha, 300, 2), 0, 'DD/MM/YY');
    end;
  end;
end;

function TACBrBancoSafra.MontarCampoCodigoCedente(
  const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo.ACBrBoleto.Cedente do
  begin
    Result := PadLeft(Agencia, 4, '0') + PadLeft(AgenciaDigito, 1, '0') + '/' + PadLeft(ACBrBoleto.Cedente.Conta, 8, '0') + PadLeft(ACBrBoleto.Cedente.ContaDigito, 1, '0');
  end;
end;

function TACBrBancoSafra.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
begin
  with ACBrTitulo do
  begin
    Result := PadLeft(RightStr(NossoNumero,8),8,'0') + '-' + CalcularDigitoVerificador(ACBrTitulo);
  end;
end;

function TACBrBancoSafra.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras: string;
begin
  with ACBrTitulo.ACBrBoleto do
  begin
    FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

    CodigoBarras := IntToStr(Banco.Numero) + '9' + FatorVencimento +
                    IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +
                    '7' + Cedente.Agencia + Cedente.AgenciaDigito + Cedente.Conta + Cedente.ContaDigito +
                    PadLeft(RightStr(ACBrTitulo.NossoNumero,8),8,'0') + CalcularDigitoVerificador(ACBrTitulo) + '2';

    DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
  end;

  Result := IntToStr(Numero) + '9' + DigitoCodBarras + Copy(CodigoBarras, 5, 39);
end;

function TACBrBancoSafra.TipoOCorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                    : Result := '02';
    toRetornoRegistroRecusado                      : Result := '03';
    toRetornoTransferenciaCarteiraEntrada          : Result := '04';
    toRetornoTransferenciaCarteiraBaixa            : Result := '05';
    toRetornoLiquidado                             : Result := '06';
    toRetornoLiquidadoParcialmente                 : Result := '07';
    toRetornoBaixaAutomatica                       : Result := '09';
    toRetornoBaixadoInstAgencia                    : Result := '10';
    toRetornoTituloEmSer                           : Result := '11';
    toRetornoAbatimentoConcedido                   : Result := '12';
    toRetornoAbatimentoCancelado                   : Result := '13';
    toRetornoVencimentoAlterado                    : Result := '14';
    toRetornoLiquidadoEmCartorio                   : Result := '15';
    toRetornoBaixadoFrancoPagamento                : Result := '16';
    toRetornoEntradaBorderoManual                  : Result := '17';
    toRetornoAlteracaoUsoCedente                   : Result := '18';
    toRetornoRecebimentoInstrucaoProtestar         : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto    : Result := '20';
    toRetornoTransferenciaCedente                  : Result := '21';
    toRetornoEncaminhadoACartorio                  : Result := '23';
    toRetornoBaixaPorProtesto                      : Result := '40';
    toRetornoLiquidadoAposBaixaOuNaoRegistro       : Result := '41';
    toRetornoRetiradoDeCartorio                    : Result := '42';
    toRetornoDespesaCartorio                       : Result := '43';
    toRetornoDebitoDiretoAutorizado                : Result := '44';
    toRetornoDebitoDiretoNaoAutorizado             : Result := '45';
    toRetornoRecebimentoInstrucaoAlterarValorTitulo: Result := '51';
    toRetornoAlteracaoDataEmissao                  : Result := '52';
    toRetornoAlteracaoEspecie                      : Result := '53';
    toRetornoAlteracaoSeuNumero                    : Result := '54';
    toRetornoEqualizacaoVendor                     : Result := '60';
    toRetornoRecebimentoInstrucaoAlterarJuros      : Result := '77';
    else
      Result := '02';
  end;
end;

function TACBrBancoSafra.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
var
  CodOcorrencia: integer;
begin
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    02: Result := '02-ENTRADA CONFIRMADA';
    03: Result := '03-ENTRADA REJEITADA';
    04: Result := '04-TRANSFER�NCIA DE CARTEIRA (ENTRADA)';
    05: Result := '05-TRANSFER�NCIA DE CARTEIRA (BAIXA)';
    06: Result := '06-LIQUIDA��O NORMAL';
    07: Result := '07-LIQUIDA��O PARCIAL';
    09: Result := '09-BAIXADO AUTOMATICAMENTE';
    10: Result := '10-BAIXADO CONFORME INSTRU��ES';
    11: Result := '11-T�TULOS EM SER (PARA ARQUIVO MENSAL)';
    12: Result := '12-ABATIMENTO CONCEDIDO';
    13: Result := '13-ABATIMENTO CANCELADO';
    14: Result := '14-VENCIMENTO ALTERADO';
    15: Result := '15-LIQUIDA��O EM CART�RIO';
    16: Result := '16-BAIXADO POR ENTREGA FRANCO DE PAGAMENTO';
    17: Result := '17-ENTRADA POR BORDERO MANUAL';
    18: Result := '18-ALTERACAO DE USO DO CEDENTE';
    19: Result := '19-CONFIRMA��O DE INSTRU��O DE PROTESTO';
    20: Result := '20-CONFIRMA��O DE SUSTAR PROTESTO';
    21: Result := '21-TRANSFER�NCIA DE CEDENTE';
    23: Result := '23-T�TULO ENVIADO A CART�RIO';
    40: Result := '40-BAIXA DE T�TULO PROTESTADO';
    41: Result := '41-LIQUIDA��O DE T�TULO BAIXADO';
    42: Result := '42-T�TULO RETIRADO DO CART�RIO';
    43: Result := '43-DESPESA DE CART�RIO';
    44: Result := '44-ACEITE DO T�TULO DDA PELO SACADO';
    45: Result := '45-N�O ACEITE DO T�TULO DDA PELO SACADO';
    51: Result := '51-VALOR DO T�TULO ALTERADO';
    52: Result := '52-ACERTO DE DATA DE EMISSAO';
    53: Result := '53-ACERTO DE COD ESPECIE DOCTO';
    54: Result := '54-ALTERACAO DE SEU NUMERO';
    60: Result := '60-EQUALIZACAO VENDOR';
    77: Result := '77-ALT. INSTR. COBR. - JUROS';
  end;
end;

end.
