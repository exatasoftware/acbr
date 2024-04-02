{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Pandaaa                     }
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

{$I ACBr.inc}
//incluido em 20/03/2024

unit ACBrBancoBocomBBM;

interface

uses
  ACBrBoleto,
  ACBrBancoBradesco,
  ACBrBoletoConversao,
  Classes;

type

  { TACBrBancoBBM }

  TACBrBancoBocomBBM = class(TACBrBancoBradesco)
  private
    function GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Integer;
  protected
    function MontaInstrucoesCNAB400(const ACBrTitulo :TACBrTitulo; const nRegistro: Integer ): String; override;
    function GerarLinhaRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList): String;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String; override;
    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList);override;
    Procedure LerRetorno240(ARetorno:TStringList);override;
  public
    constructor create(AOwner: TACBrBanco);
  end;

implementation

uses
  ACBrUtil.Base,
  SysUtils,
  StrUtils,
  ACBrUtil.Strings;

{ TACBrBancoBocomBBM }

constructor TACBrBancoBocomBBM.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpNumeroCorrespondente   := 107;
   fpNumero                 := 237;
   fpDensidadeGravacao      := '01600000';
   fpOrientacoesBanco.Clear;
   fpOrientacoesBanco.Add(ACBrStr('Cr�dito cedido ao BANCO BOCOM BBM S/A. Pagamento somente por este boleto.'));
end;

function TACBrBancoBocomBBM.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  LCodigoOcorrencia: Integer;
begin
  Result := '';
  LCodigoOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

  case LCodigoOcorrencia of
    10: Result := '10-Baixado Conforme Instru��es da Ag�ncia';
    15: Result := '15-Liquida��o em Cart�rio';
    16: Result := '16-Titulo Pago em Cheque - Vinculado';
    18: Result := '18-Acerto de Deposit�ria';
    21: Result := '21-Acerto do Controle do Participante';
    22: Result := '22-Titulo com Pagamento Cancelado';
    24: Result := '24-Entrada Rejeitada por CEP Irregular';
    25: Result := '25-Confirma��o Recebimento Instru��o de Protesto Falimentar';
    27: Result := '27-Baixa Rejeitada';
    32: Result := '32-Instru��o Rejeitada';
    33: Result := '33-Confirma��o Pedido Altera��o Outros Dados';
    34: Result := '34-Retirado de Cart�rio e Manuten��o Carteira';
    40: Result := '40-Estorno de Pagamento';
    55: Result := '55-Sustado Judicial';
    68: Result := '68-Acerto dos Dados do Rateio de Cr�dito';
    69: Result := '69-Cancelamento dos Dados do Rateio';
    74: Result := '74-Confirma��o Pedido de Exclus�o de Negatativa��o';
  end;

  if (Result <> '') then
  begin
    Result := ACBrSTr(Result);
    Exit;
  end;

  case LCodigoOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquida��o Normal';
    09: Result := '09-Baixado Automaticamente via Arquivo';
    11: Result := '11-Em Ser - Arquivo de T�tulos Pendentes';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    17: Result := '17-Liquida��o ap�s baixa ou T�tulo n�o registrado';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o Susta��o de Protesto';
    23: Result := '23-Entrada do T�tulo em Cart�rio';
    28: Result := '28-D�bito de tarifas/custas';
    29: Result := '29-Ocorr�ncias do Pagador';
    30: Result := '30-Altera��o de Outros Dados Rejeitados';
    35: Result := '35-Desagendamento do d�bito autom�tico';
    73: Result := '73-Confirma��o Recebimento Pedido de Negativa��o';
  end;

  Result := ACBrSTr(Result);
end;

function TACBrBancoBocomBBM.CodOcorrenciaToTipo(const CodOcorrencia: Integer ) : TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    10: Result := toRetornoBaixadoInstAgencia;
    15: Result := toRetornoLiquidadoEmCartorio;
    17: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
    24: Result := toRetornoEntradaRejeitaCEPIrregular;
    27: Result := toRetornoBaixaRejeitada;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasdoSacado;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    32: Result := toRetornoInstrucaoRejeitada;
    35: Result := toRetornoDesagendamentoDebitoAutomatico;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoBocomBBM.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                  : Result := '02';
    toRetornoRegistroRecusado                    : Result := '03';
    toRetornoLiquidado                           : Result := '06';
    toRetornoBaixadoViaArquivo                   : Result := '09';
    toRetornoBaixadoInstAgencia                  : Result := '10';
    toRetornoLiquidadoEmCartorio                 : Result := '15';
    toRetornoLiquidadoAposBaixaOuNaoRegistro     : Result := '17';
    toRetornoEntradaRejeitaCEPIrregular          : Result := '24';
    toRetornoBaixaRejeitada                      : Result := '27';
    toRetornoDebitoTarifas                       : Result := '28';
    toRetornoOcorrenciasdoSacado                 : Result := '29';
    toRetornoAlteracaoOutrosDadosRejeitada       : Result := '30';
    toRetornoInstrucaoRejeitada                  : Result := '32';
    toRetornoDesagendamentoDebitoAutomatico      : Result := '35';
  end;
end;

function TACBrBancoBocomBBM.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String;
begin
   case TipoOcorrencia of
     toRetornoRegistroConfirmado:
        case StrToIntDef(CodMotivo,999) of
          00: Result := '00-Ocorrencia aceita';
          01: Result := '01-Codigo de banco inv�lido';
          04: Result := '04-C�digo do movimentacao nao permitido para a carteira';
          15: Result := '15-Caracteristicas de Cobranca Imcompativeis';
          17: Result := '17-Data de vencimento anterior a data de emiss�o';
          21: Result := '21-Esp�cie do T�tulo inv�lido';
          24: Result := '24-Data da emiss�o inv�lida';
          38: Result := '38-Prazo para protesto inv�lido';
          39: Result := '39-Pedido para protesto n�o permitido para t�tulo';
          43: Result := '43-Prazo para baixa e devolu��o inv�lido';
          45: Result := '45-Nome do Pagador inv�lido';
          46: Result := '46-Tipo/num. de inscri��o do Pagador inv�lidos';
          47: Result := '47-Endere�o do Pagador n�o informado';
          48: Result := '48-CEP invalido';
          50: Result := '50-CEP referente a Banco correspondente';
          53: Result := '53-N� de inscri��o do Benefici�rio Final inv�lidos (CPF/CNPJ)';
          54: Result := '54-Benefici�rio Final n�o informado';
          67: Result := '67-D�bito autom�tico agendado';
          68: Result := '68-D�bito n�o agendado - erro nos dados de remessa';
          69: Result := '69-D�bito n�o agendado - Pagador n�o consta no cadastro de autorizante';
          70: Result := '70-D�bito n�o agendado - Cedente n�o autorizado pelo Pagador';
          71: Result := '71-D�bito n�o agendado - Cedente n�o participa da modalidade de d�bito autom�tico';
          72: Result := '72-D�bito n�o agendado - C�digo de moeda diferente de R$';
          73: Result := '73-D�bito n�o agendado - Data de vencimento inv�lida';
          75: Result := '75-D�bito n�o agendado - Tipo do n�mero de inscri��o do pagador debitado inv�lido';
          76: Result := '76-Pagador Eletr�nico DDA (NOVO)- Esse motivo somente ser� disponibilizado no arquivo retorno para as empresas cadastradas nessa condi��o';
          86: Result := '86-Seu n�mero do documento inv�lido';
          89: Result := '89-Email pagador nao enviado - Titulo com debito automatico';
          90: Result := '90-Email pagador nao enviado - Titulo com cobranca sem registro';
          else
            Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoRegistroRecusado:
        case StrToIntDef(CodMotivo,999) of
          02: Result:= '02-Codigo do registro detalhe invalido';
          03: Result:= '03-Codigo da Ocorrencia Invalida';
          04: Result:= '04-Codigo da Ocorrencia nao permitida para a carteira';
          05: Result:= '05-Codigo de Ocorrencia nao numerico';
          07: Result:= 'Agencia\Conta\Digito invalido';
          08: Result:= 'Nosso numero invalido';
          09: Result:= 'Nosso numero duplicado';
          10: Result:= 'Carteira invalida';
          13: Result:= 'Idetificacao da emissao do boleto invalida';
          16: Result:= 'Data de vencimento invalida';
          18: Result:= 'Vencimento fora do prazo de operacao';
          20: Result:= 'Valor do titulo invalido';
          21: Result:= 'Especie do titulo invalida';
          22: Result:= 'Especie nao permitida para a carteira';
          24: Result:= 'Data de emissao invalida';
          28: Result:= 'Codigo de desconto invalido';
          38: Result:= 'Prazo para protesto invalido';
          44: Result:= 'Agencia cedente nao prevista';
          45: Result:= 'Nome cedente nao informado';
          46: Result:= 'Tipo/numero inscricao pagador invalido';
          47: Result:= 'Endereco pagador nao informado';
          48: Result:= 'CEP invalido';
          50: Result:= 'CEP irregular - Banco correspondente';
          63: Result:= 'Entrada para titulo ja cadastrado';
          65: Result:= 'Limite excedido';
          66: Result:= 'Numero autorizacao inexistente';
          68: Result:= 'Debito nao agendado - Erro nos dados da remessa';
          69: Result:= 'Debito nao agendado - Pagador nao consta no cadastro de autorizante';
          70: Result:= 'Debito nao agendado - Cedente nao autorizado pelo pagador';
          71: Result:= 'Debito nao agendado - Cedente nao participa de debito automatico';
          72: Result:= 'Debito nao agendado - Codigo de moeda diferente de R$';
          73: Result:= 'Debito nao agendado - Data de vencimento invalida';
          74: Result:= 'Debito nao agendado - Conforme seu pedido titulo nao registrado';
          75: Result:= 'Debito nao agendado - Tipo de numero de inscricao de debitado invalido';
        else
           Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoLiquidado:
        case StrToIntDef(CodMotivo,999) of
           00: Result:= '00-Titulo pago com dinheiro';
           15: Result:= '15-Titulo pago com cheque';
           42: Result:= '42-Rateio n�o efetuado';
        else
           Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoBaixadoViaArquivo:
        case StrToIntDef(CodMotivo,999) of
           00: Result:= '00-Ocorrencia aceita';
           10: Result:= '10-Baixa comandada pelo cliente';
        else
           Result:= CodMotivo +' - Outros Motivos';
        end;
      toRetornoBaixadoInstAgencia:
        case StrToIntDef(CodMotivo,999) of
          00: Result:= '00-Baixado conforme instrucoes na agencia';
          14: Result:= '14-Titulo protestado';
          15: Result:= '15-Titulo excluido';
          16: Result:= '16-Titulo baixado pelo banco por decurso de prazo';
          20: Result:= '20-Titulo baixado e transferido para desconto';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;
     toRetornoLiquidadoEmCartorio:
        case StrToIntDef(CodMotivo,999) of
          00: Result:= '00-Pago com dinheiro';
          15: Result:= '15-Pago com cheque';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoLiquidadoAposBaixaouNaoRegistro:
        case StrToIntDef(CodMotivo,999) of
          00: Result:= '00-Pago com dinheiro';
          15: Result:= '15-Pago com cheque';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoEntradaRejeitaCEPIrregular:
        case StrToIntDef(CodMotivo,999) of
          48: Result:= '48-CEP invalido';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoBaixaRejeitada:
        case StrToIntDef(CodMotivo,999) of
          04: Result:= '04-Codigo de ocorrencia nao permitido para a carteira';
          07: Result:= '07-Agencia/Conta/Digito invalidos';
          08: Result:= '08-Nosso numero invalido';
          10: Result:= '10-Carteira invalida';
          15: Result:= '15-Carteira/Agencia/Conta/Nosso Numero invalidos';
          40: Result:= '40-Titulo com ordem de protesto emitido';
          42: Result:= '42-Codigo para baixa/devolucao via Telebradesco invalido';
          60: Result:= '60-Movimento para titulo nao cadastrado';
          77: Result:= '70-Transferencia para desconto nao permitido para a carteira';
          85: Result:= '85-Titulo com pagamento vinculado';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoDebitoTarifas:
        case StrToIntDef(CodMotivo,999) of
          02: Result:= '02-Tarifa de perman�ncia t�tulo cadastrado';
          03: Result:= '03-Tarifa de susta��o/Excl Negativa��o';
          04: Result:= '04-Tarifa de protesto/Incl Negativa��o';
          05: Result:= '05-Tarifa de outras instrucoes';
          06: Result:= '06-Tarifa de outras ocorr�ncias';
          08: Result:= '08-Custas de protesto';
          12: Result:= '12-Tarifa de registro';
          13: Result:= '13-Tarifa titulo pago no Bradesco';
          14: Result:= '14-Tarifa titulo pago compensacao';
          15: Result:= '15-Tarifa t�tulo baixado n�o pago';
          16: Result:= '16-Tarifa alteracao de vencimento';
          17: Result:= '17-Tarifa concess�o abatimento';
          18: Result:= '18-Tarifa cancelamento de abatimento';
          19: Result:= '19-Tarifa concess�o desconto';
          20: Result:= '20-Tarifa cancelamento desconto';
          21: Result:= '21-Tarifa t�tulo pago cics';
          22: Result:= '22-Tarifa t�tulo pago Internet';
          23: Result:= '23-Tarifa t�tulo pago term. gerencial servi�os';
          24: Result:= '24-Tarifa t�tulo pago P�g-Contas';
          25: Result:= '25-Tarifa t�tulo pago Fone F�cil';
          26: Result:= '26-Tarifa t�tulo D�b. Postagem';
          27: Result:= '27-Tarifa impress�o de t�tulos pendentes';
          28: Result:= '28-Tarifa t�tulo pago BDN';
          29: Result:= '29-Tarifa t�tulo pago Term. Multi Funcao';
          30: Result:= '30-Impress�o de t�tulos baixados';
          31: Result:= '31-Impress�o de t�tulos pagos';
          32: Result:= '32-Tarifa t�tulo pago Pagfor';
          33: Result:= '33-Tarifa reg/pgto � guich� caixa';
          34: Result:= '34-Tarifa t�tulo pago retaguarda';
          35: Result:= '35-Tarifa t�tulo pago Subcentro';
          36: Result:= '36-Tarifa t�tulo pago Cartao de Credito';
          37: Result:= '37-Tarifa t�tulo pago Comp Eletr�nica';
          38: Result:= '38-Tarifa t�tulo Baix. Pg. Cartorio';
          39: Result:='39-Tarifa t�tulo baixado acerto BCO';
          40: Result:='40-Baixa registro em duplicidade';
          41: Result:='41-Tarifa t�tulo baixado decurso prazo';
          42: Result:='42-Tarifa t�tulo baixado Judicialmente';
          43: Result:='43-Tarifa t�tulo baixado via remessa';
          44: Result:='44-Tarifa t�tulo baixado rastreamento';
          45: Result:='45-Tarifa t�tulo baixado conf. Pedido';
          46: Result:='46-Tarifa t�tulo baixado protestado';
          47: Result:='47-Tarifa t�tulo baixado p/ devolucao';
          48: Result:='48-Tarifa t�tulo baixado franco pagto';
          49: Result:='49-Tarifa t�tulo baixado SUST/RET/CART�RIO';
          50: Result:='50-Tarifa t�tulo baixado SUS/SEM/REM/CART�RIO';
          51: Result:='51-Tarifa t�tulo transferido desconto';
          52: Result:='52-Cobrado baixa manual';
          53: Result:='53-Baixa por acerto cliente';
          54: Result:='54-Tarifa baixa por contabilidade';
          55: Result:='55-Tarifa tentativa cons deb aut';
          56: Result:='56-Consulta informa��es via internet';
          57: Result:='57-Arquivo retorno via internet';
          58: Result:='58-Tarifa emiss�o Papeleta';
          59: Result:='59-Tarifa fornec papeleta semi preenchida';
          60: Result:='60-Acondicionador de papeletas (RPB)S';
          61: Result:='61-Acond. De papelatas (RPB)s PERSONAL';
          62: Result:='62-Papeleta formul�rio branco';
          63: Result:='63-Formul�rio A4 serrilhado';
          64: Result:='64-Fornecimento de softwares transmiss';
          65: Result:='65-Fornecimento de softwares consulta';
          66: Result:='66-Fornecimento Micro Completo';
          67: Result:='67-Fornecimento MODEN';
          68: Result:='68-Fornecimento de m�quina FAX';
          69: Result:='69-Fornecimento de maquinas oticas';
          70: Result:='70-Fornecimento de Impressoras';
          71: Result:='71-Reativa��o de t�tulo';
          72: Result:='72-Altera��o de produto negociado';
          73: Result:='73-Tarifa emissao de contra recibo';
          74: Result:='74-Tarifa emissao 2� via papeleta';
          75: Result:='75-Tarifa regrava��o arquivo retorno';
          76: Result:='76-Arq. T�tulos a vencer mensal';
          77: Result:='77-Listagem auxiliar de cr�dito';
          78: Result:='78-Tarifa cadastro cartela instru��o permanente';
          79: Result:='79-Canaliza��o de Cr�dito';
          80: Result:='80-Cadastro de Mensagem Fixa';
          81: Result:='81-Tarifa reapresenta��o autom�tica t�tulo';
          82: Result:='82-Tarifa registro t�tulo d�b. Autom�tico';
          83: Result:='83-Tarifa Rateio de Cr�dito';
          84: Result:='84-Emiss�o papeleta sem valor';
          85: Result:='85-Sem uso';
          86: Result:='86-Cadastro de reembolso de diferen�a';
          87: Result:='87-Relat�rio fluxo de pagto';
          88: Result:='88-Emiss�o Extrato mov. Carteira';
          89: Result:='89-Mensagem campo local de pagto';
          90: Result:='90-Cadastro Concession�ria serv. Publ.';
          91: Result:='91-Classif. Extrato Conta Corrente';
          92: Result:='92-Contabilidade especial';
          93: Result:='93-Realimenta��o pagto';
          94: Result:='94-Repasse de Cr�ditos';
          95: Result:='95-Tarifa reg. pagto Banco Postal';
          96: Result:='96-Tarifa reg. Pagto outras m�dias';
          97: Result:='97-Tarifa Reg/Pagto � Net Empresa';
          98: Result:='98-Tarifa t�tulo pago vencido';
          99: Result:='99-TR T�t. Baixado por decurso prazo';
          100: Result:='100-Arquivo Retorno Antecipado';
          101: Result:='101-Arq retorno Hora/Hora';
          102: Result:='102-TR. Agendamento D�b Aut';
          103: Result:='103-TR. Tentativa cons D�b Aut';
          104: Result:='104-TR Cr�dito on-line';
          105: Result:='105-TR. Agendamento rat. Cr�dito';
          106: Result:='106-TR Emiss�o aviso rateio';
          107: Result:='107-Extrato de protesto';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoOcorrenciasdoSacado:
        case StrToIntDef(CodMotivo,999) of
          78 : Result:= '78-Pagador alega que faturamento e indevido';
          116: Result:= '116-Pagador aceita/reconhece o faturamento';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoALteracaoOutrosDadosRejeitada:
        case StrToIntDef(CodMotivo,999) of
          01: Result:= '01-C�digo do Banco inv�lido';
          04: Result:= '04-C�digo de ocorr�ncia n�o permitido para a carteira';
          05: Result:= '05-C�digo da ocorr�ncia n�o num�rico';
          08: Result:= '08-Nosso n�mero inv�lido';
          15: Result:= '15-Caracter�stica da cobran�a incompat�vel';
          16: Result:= '16-Data de vencimento inv�lido';
          17: Result:= '17-Data de vencimento anterior a data de emiss�o';
          18: Result:= '18-Vencimento fora do prazo de opera��o';
          24: Result:= '24-Data de emiss�o Inv�lida';
          26: Result:= '26-C�digo de juros de mora inv�lido';
          27: Result:= '27-Valor/taxa de juros de mora inv�lido';
          28: Result:= '28-C�digo de desconto inv�lido';
          29: Result:= '29-Valor do desconto maior/igual ao valor do T�tulo';
          30: Result:= '30-Desconto a conceder n�o confere';
          31: Result:= '31-Concess�o de desconto j� existente ( Desconto anterior )';
          32: Result:= '32-Valor do IOF inv�lido';
          33: Result:= '33-Valor do abatimento inv�lido';
          34: Result:= '34-Valor do abatimento maior/igual ao valor do T�tulo';
          38: Result:= '38-Prazo para protesto inv�lido';
          39: Result:= '39-Pedido de protesto n�o permitido para o T�tulo';
          40: Result:= '40-T�tulo com ordem de protesto emitido';
          42: Result:= '42-C�digo para baixa/devolu��o inv�lido';
          46: Result:= '46-Tipo/n�mero de inscri��o do pagador inv�lidos';
          48: Result:= '48-Cep Inv�lido';
          53: Result:= '53-Tipo/N�mero de inscri��o do benefici�rio final inv�lidos';
          54: Result:= '54-Benefici�rio Final n�o informado';
          57: Result:= '57-C�digo da multa inv�lido';
          58: Result:= '58-Data da multa inv�lida';
          60: Result:= '60-Movimento para T�tulo n�o cadastrado';
          79: Result:= '79-Data de Juros de mora Inv�lida';
          80: Result:= '80-Data do desconto inv�lida';
          85: Result:= '85-T�tulo com Pagamento Vinculado.';
          88: Result:= '88-E-mail Pagador n�o lido no prazo 5 dias';
          91: Result:= '91-E-mail Pagador n�o recebido';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      (*Dados chave do boleto � n�o pass�veis de altera��o:
       Tipo de pessoa do benefici�rio original, CPF ou CNPJ do benefici�rio original,
       Nome ou raz�o social do benefici�rio original, Tipo de pessoa do cliente pagador,
       CPF ou CNPJ do cliente pagador, C�digo da moeda, Identifica��o do nosso n�mero,
       Data de emiss�o, Indicador de pagamento parcial.*)

      toRetornoComandoRecusado:
        case StrToIntDef(CodMotivo,999) of
          01 : Result:= '01-C�digo do Banco inv�lido';
          02 : Result:= '02-C�digo do registro detalhe inv�lido';
          04 : Result:= '04-C�digo de ocorr�ncia n�o permitido para a carteira';
          05 : Result:= '05-C�digo de ocorr�ncia n�o num�rico';
          07 : Result:= '07-Ag�ncia/Conta/d�gito inv�lidos';
          08 : Result:= '08-Nosso n�mero inv�lido';
          10 : Result:= '10-Carteira inv�lida';
          15 : Result:= '15-Caracter�sticas da cobran�a incompat�veis';
          16 : Result:= '16-Data de vencimento inv�lida';
          17 : Result:= '17-Data de vencimento anterior a data de emiss�o';
          18 : Result:= '18-Vencimento fora do prazo de opera��o';
          20 : Result:= '20-Valor do t�tulo inv�lido';
          21 : Result:= '21-Esp�cie do T�tulo inv�lida';
          22 : Result:= '22-Esp�cie n�o permitida para a carteira';
          24 : Result:= '24-Data de emiss�o inv�lida';
          28 : Result:= '28-C�digo de desconto via Telebradesco inv�lido';
          29 : Result:= '29-Valor do desconto maior/igual ao valor do T�tulo';
          30 : Result:= '30-Desconto a conceder n�o confere';
          31 : Result:= '31-Concess�o de desconto - J� existe desconto anterior';
          33 : Result:= '33-Valor do abatimento inv�lido';
          34 : Result:= '34-Valor do abatimento maior/igual ao valor do T�tulo';
          36 : Result:= '36-Concess�o abatimento - J� existe abatimento anterior';
          38 : Result:= '38-Prazo para protesto inv�lido';
          39 : Result:= '39-Pedido de protesto n�o permitido para o T�tulo';
          40 : Result:= '40-T�tulo com ordem de protesto emitido';
          41 : Result:= '41-Pedido cancelamento/susta��o para T�tulo sem instru��o de protesto';
          42 : Result:= '42-C�digo para baixa/devolu��o inv�lido';
          45 : Result:= '45-Nome do Pagador n�o informado';
          46 : Result:= '46-Tipo/n�mero de inscri��o do Pagador inv�lidos';
          47 : Result:= '47-Endere�o do Pagador n�o informado';
          48 : Result:= '48-CEP Inv�lido';
          50 : Result:= '50-CEP referente a um Banco correspondente';
          53 : Result:= '53-Tipo de inscri��o do Benefici�rio Final inv�lidos';
          60 : Result:= '60-Movimento para T�tulo n�o cadastrado';
          85 : Result:= '85-T�tulo com pagamento vinculado';
          86 : Result:= '86-Seu n�mero inv�lido';
          94 : Result:= '94-T�tulo Penhorado � Instru��o N�o Liberada pela Ag�ncia';
          97 : Result:= '97-Instru��o n�o permitida t�tulo negativado';
          98 : Result:= '98-Inclus�o Bloqueada face a determina��o Judicial';
          99 : Result:= '99-Telefone benefici�rio n�o informado / inconsistente';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;

      toRetornoDesagendamentoDebitoAutomatico:
        case StrToIntDef(CodMotivo,999) of
          81 : Result:= '81-Tentativas esgotadas, baixado';
          82 : Result:= '82-Tentativas esgotadas, pendente';
          83 : Result:= '83-Cancelado pelo Pagador e Mantido Pendente, conforme negocia��o';
          84 : Result:= '84-Cancelado pelo Pagador e baixado, conforme negocia��o';
        else
          Result:= CodMotivo +' - Outros Motivos';
        end;
   else
     Result:= CodMotivo +' - Outros Motivos';
   end;

   Result := ACBrSTr(Result);
end;

function TACBrBancoBocomBBM.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    03 : Result:= toRemessaProtestoFinsFalimentares;        {Pedido de Protesto Falimentar}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarControleParticipante;     {Altera��o do controle do participante}
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Pedido de protesto}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar protesto e baixar}
    19 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar protesto e manter na carteira}
    22 : Result:= toRemessaTransfCessaoCreditoIDProd10;     {Transfer�ncia Cess�o cr�dito ID. Prod.10}
    23 : Result:= toRemessaTransferenciaCarteira;           {Transfer�ncia entre Carteiras}
    24 : Result:= toRemessaDevTransferenciaCarteira;        {Dev. Transfer�ncia entre Carteiras}
    31 : Result:= toRemessaOutrasOcorrencias;               {Altera��o de Outros Dados}
    68 : Result:= toRemessaAcertarRateioCredito;            {Acerto nos dados do rateio de Cr�dito}
    69 : Result:= toRemessaCancelarRateioCredito;           {Cancelamento do rateio de cr�dito.}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;

end;

function TACBrBancoBocomBBM.TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
    case TipoOcorrencia of
      toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
      toRemessaProtestoFinsFalimentares       : Result := '03'; {Pedido de Protesto Falimentar}
      toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento              : Result := '06'; {Altera��o de vencimento}
      toRemessaAlterarControleParticipante    : Result := '07'; {Altera��o do controle do participante}
      toRemessaAlterarNumeroControle          : Result := '08'; {Altera��o de seu n�mero}
      toRemessaProtestar                      : Result := '09'; {Pedido de protesto}
      toRemessaCancelarInstrucaoProtestoBaixa : Result := '18'; {Sustar protesto e baixar}
      toRemessaCancelarInstrucaoProtesto      : Result := '19'; {Sustar protesto e manter na carteira}
      toRemessaAlterarValorTitulo             : Result := '20'; {Altera��o de valor}
      toRemessaTransferenciaCarteira          : Result := '23'; {Transfer�ncia entre carteiras}
      toRemessaDevTransferenciaCarteira       : Result := '24'; {Dev. Transfer�ncia entre carteiras}
      toRemessaOutrasOcorrencias              : Result := '31'; {Altera��o de Outros Dados}
      else
        Result := '01';                                           {Remessa}
    end;
end;

function TACBrBancoBocomBBM.ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Integer;
var LValor : Double;
begin
  if ACBrTitulo.MultaValorFixo then
  begin
    if (ACBrTitulo.ValorDocumento > 0) then
      LValor := (ACBrTitulo.PercentualMulta / ACBrTitulo.ValorDocumento) * 100
    else
      LValor := 0;
  end else
    LValor := ACBrTitulo.PercentualMulta;
  Result := Round(LValor * 100);
end;

function TACBrBancoBocomBBM.MontaInstrucoesCNAB400(const ACBrTitulo: TACBrTitulo; const nRegistro: Integer): String;
var LNossoNumero,LDigitoNossoNumero : String;
begin
  Result := '';

  ValidaNossoNumeroResponsavel(LNossoNumero, LDigitoNossoNumero, ACBrTitulo);
  {Primeira instru��o vai no registro tipo 1}
  if ACBrTitulo.Mensagem.Count <= 1 then
  begin
    Result := '';
    Exit;
  end;

  Result := '2'               +                                                                                                // 001-001 IDENTIFICA��O DO LAYOUT PARA O REGISTRO
            Copy(PadRight(ACBrTitulo.Mensagem[1], 80, ' '), 1, 80);                                                            // 002-081 CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

  if ACBrTitulo.Mensagem.Count >= 3 then
    Result := Result +
              Copy(PadRight(ACBrTitulo.Mensagem[2], 80, ' '), 1, 80)                                                           // 082-161 CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
  else
    Result := Result + PadRight('', 80, ' ');                                                                                  // 082-161 CONTE�DO DO RESTANTE DAS LINHAS

  if ACBrTitulo.Mensagem.Count >= 4 then
    Result := Result +
              Copy(PadRight(ACBrTitulo.Mensagem[3], 80, ' '), 1, 80)                                                           // 162-241 CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
  else
    Result := Result + PadRight('', 80, ' ');                                                                                 // 162-241 CONTE�DO DO RESTANTE DAS LINHAS

  if ACBrTitulo.Mensagem.Count >= 5 then
    Result := Result +
              Copy(PadRight(ACBrTitulo.Mensagem[4], 80, ' '), 1, 80)                                                          // 242-321 CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
  else
    Result := Result + PadRight('', 80, ' ');                                                                                 // 242-321 CONTE�DO DO RESTANTE DAS LINHAS


  Result := Result
            + IfThen(ACBrTitulo.DataDesconto2 > 0,FormatDateTime( 'ddmmyy', ACBrTitulo.DataDesconto2),PadLeft('', 6, '0'))   // 322-327 Data limite para concess�o de Desconto 2
            + IntToStrZero( round( ACBrTitulo.ValorDesconto2 * 100 ), 13)                                                    // 328-340 Valor do Desconto 2
            + IfThen(ACBrTitulo.DataDesconto3 > 0, FormatDateTime( 'ddmmyy', ACBrTitulo.DataDesconto3) ,PadLeft('', 6, '0')) // 341-346 Data limite para concess�o de Desconto 3
            + IntToStrZero( round( ACBrTitulo.ValorDesconto3 * 100 ), 13)                                                    // 347-359 Valor do Desconto 3
            + space(7)                                                                                                       // 360-366 Filler
            + IntToStrZero(StrToIntDef(trim(ACBrTitulo.Carteira), 0), 3)                                                     // 367-369 Num. da Carteira
            + IntToStrZero(StrToIntDef(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 0), 5)                             // 370-374 C�digo da Ag�ncia Benefici�rio
            + IntToStrZero(StrToIntDef(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Conta)  , 0), 7)                             // 375-381 Num. da Conta-Corrente
            + ACBrTitulo.ACBrBoleto.Cedente.ContaDigito                                                                      // 382-382 DAC C/C
            + LNossoNumero                                                                                                   // 383-393 Nosso N�mero
            + LDigitoNossoNumero                                                                                             // 394-394 DAC Nosso N�mero
            + IntToStrZero( nRegistro + 1, 6);                                                                               // 395-400 Num. Sequencial do Registro
end;

function TACBrBancoBocomBBM.MontarCampoNossoNumero (const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result:= ACBrTitulo.Carteira+'/'+ACBrTitulo.NossoNumero+'-'+CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoBocomBBM.GerarRegistroHeader240(NumeroRemessa: Integer): String;
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;

procedure TACBrBancoBocomBBM.GerarRegistroHeader400(NumeroRemessa: Integer; ARemessa: TStringList);
var
  LLinha, LEmpresa: String;
  LDataArquivo: TDateTime;
begin

  LDataArquivo := ACBrBanco.ACBrBoleto.DataArquivo;

  if LDataArquivo = 0 then
    LDataArquivo := Now;

  if (ACBrBanco.ACBrBoleto.ListadeBoletos.Count > 0) and
     (ACBrBanco.ACBrBoleto.ListadeBoletos[0].Sacado.SacadoAvalista.NomeAvalista <> '') then
    LEmpresa := ACBrBanco.ACBrBoleto.ListadeBoletos[0].Sacado.SacadoAvalista.NomeAvalista
  else
    LEmpresa := ACBrBanco.ACBrBoleto.Cedente.Nome;

  LLinha:= '0'                                                                  +  //001 a 001  ID do Registro
           '1'                                                                  +  //002 a 002  1 - Remessa
           'REMESSA'                                                            +  //003 a 009  Literal de Remessa
           '01'                                                                 +  //010 a 011  C�digo do Tipo de Servi�o
           PadRight('COBRANCA', 15)                                             +  //012 a 026  Literal do tipo de servi�o
           PadLeft(ACBrBanco.ACBrBoleto.Cedente.CodigoCedente, 20, '0')         +  //027 a 046  Codigo da Empresa no Banco
           PadRight(LEmpresa, 30)                                               +  //047 a 076  Nome da Empresa - Como � FIDC precisa passar como Avalista, caso contr�rio ir� sair o nome padr�o do cedente
           IntToStrZero(fpNumero, 3)                                            +  //077 a 079  C�digo do Banco na CIP 237
           PadRight(fpNome, 15)                                                 +  //080 a 094  Nome do Banco Bradesco
           FormatDateTime('ddmmyy', LDataArquivo)                               +  //095 a 100  Data de gera��o do arquivo
           Space(08)                                                            +  //101 a 108  brancos
           PadLeft(fpCodParametroMovimento, 2 )                                 +  //109 a 110  C�d. Par�m. Movimento MX
           IntToStrZero(NumeroRemessa, 7)                                       +  //111 a 117  Nr. Sequencial de Remessa
           Space(277)                                                           +  //118 a 394  brancos
           IntToStrZero(1, 6);                                                     //395 a 400  Nr. Sequencial de Remessa

  ARemessa.Add(UpperCase(LLinha));
end;

function TACBrBancoBocomBBM.GerarLinhaRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList): String;
var
  LOcorrencia, LEspecie, LAgencia,
  LProtesto, LTipoInscricao, LConta, LDigitoConta,
  LCarteira, LLinha, LNossoNumero, LDigitoNossoNumero, LCondicaoEmissao, LChaveNFE,
  LSeuNumero, LNumeroDocumento  : String;
  LValorPercentualMulta: Integer;
  LBoleto : TACBrBoleto;
begin
   Result := '';
   ValidaNossoNumeroResponsavel(LNossoNumero, LDigitoNossoNumero, ACBrTitulo);

   LBoleto := ACBrTitulo.ACBrBoleto;

   LAgencia := IntToStrZero(StrToIntDef(OnlyNumber(LBoleto.Cedente.Agencia),0),5);
   LConta   := IntToStrZero(StrToIntDef(OnlyNumber(LBoleto.Cedente.Conta),0),7);
   LCarteira:= IntToStrZero(StrToIntDef(trim(ACBrTitulo.Carteira),0), 3);
   LDigitoConta := PadLeft(trim(LBoleto.Cedente.ContaDigito),1,'0');

   {C�digo da Ocorrencia Original do Titulo}
   LOcorrencia:= TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);

   {Tipo de Boleto}
   LCondicaoEmissao := DefineTipoBoleto(ACBrTitulo);

   {Especie}
   LEspecie:= DefineEspecieDoc(ACBrTitulo);

   {Intru��es}
   LProtesto:= InstrucoesProtesto(ACBrTitulo);

   {Tipo de Pagador}
   LTipoInscricao := DefineTipoSacado(ACBrTitulo);

   { Converte valor em moeda para percentual, pois o arquivo s� permite % }
   LValorPercentualMulta := ConverterMultaPercentual(ACBrTitulo);

   {Chave da NFe Vinculada}
   if ACBrTitulo.ListaDadosNFe.Count > 0 then
     LChaveNFe := ACBrTitulo.ListaDadosNFe[0].ChaveNFe
   else
     LChaveNFe := '';

   LSeuNumero := IfThen(ACBrTitulo.SeuNumero = '',ACBrTitulo.NumeroDocumento,ACBrTitulo.SeuNumero);
   LNumeroDocumento := IfThen(ACBrTitulo.NumeroDocumento = '',ACBrTitulo.SeuNumero,ACBrTitulo.NumeroDocumento);

   LLinha:= '1'                                                                 +  // 001 a 001 - 1 Fixo
   Poem_Zeros('0', 19)                                                          +  // 002 a 020 - Dados D�bito Autom�tico (Opcional)
   '0'                                                                          +  // 021 a 021 - 0 Fixo
   LCarteira                                                                    +  // 022 a 024 - Carteira 009
   LAgencia                                                                     +  // 025 a 029 - C�digo da Agencia 02373 Sem DV
   LConta                                                                       +  // 030 a 036 - C�digo da Conta Sem DV
   LDigitoConta                                                                 +  // 037 a 037 - DV da Conta
   PadRight( LSeuNumero ,25,' ')                                                +  // 038 a 062 - Numero de Controle do Participante
   '237'                                                                        +  // 063 a 065 - C�digo do Banco
   IfThen( ACBrTitulo.PercentualMulta > 0, '2', '0')                            +  // 066 a 066 - Indica se exite Multa ou n�o
   IntToStrZero( LValorPercentualMulta , 4)                                     +  // 067 a 070 - Percentual de Multa formatado com 2 casas decimais
   LNossoNumero                                                                 +  // 071 a 081 - N�mero banc�rio da cobran�a
   LDigitoNossoNumero                                                           +  // 072 a 082 - DV N�mero banc�rio da cobran�a
   IntToStrZero( round( ACBrTitulo.ValorDescontoAntDia * 100), 10)              +  // 083 a 092 - Desconto Bonifica��o por dia
   LCondicaoEmissao                                                             +  // 093 a 093 - Tipo Boleto(Quem emite)
   'N'                                                                          +  // 094 a 094 - Fixo N
   Space(10)                                                                    +  // 095 a 104 - Brancos
   Space(1)                                                                     +  // 105 a 105 - Indicador de Rateio (Brancos)
   Space(1)                                                                     +  // 106 a 106 - Endere�amento de D�bito Automatico (Brancos)
   Space(2)                                                                     +  // 107 a 108 - Quantidade de Pagamentos (Brancos)
   LOcorrencia                                                                  +  // 109 a 110 - C�digo da Ocorr�ncia
   PadRight( LNumeroDocumento ,  10)                                            +  // 111 a 120 - Numero Documento
   FormatDateTime( 'ddmmyy', ACBrTitulo.Vencimento)                             +  // 121 a 126 - Data Vencimento
   IntToStrZero( Round( ACBrTitulo.ValorDocumento * 100 ), 13)                  +  // 127 a 139 - Valor do Titulo
   StringOfChar('0',3)                                                          +  // 140 a 142 - Banco encarregado pela cobran�a (Zeros)
   StringOfChar('0',5)                                                          +  // 143 a 147 - Agencia deposit�ria (Zeros)
   PadRight(LEspecie,2)                                                         +  // 148 a 149 - Especie do Titulo
   'N'                                                                          +  // 150 a 150 - Identifica��o (Fixo N)
   FormatDateTime( 'ddmmyy', ACBrTitulo.DataDocumento )                         +  // 151 a 156 - Data de Emiss�o
   LProtesto                                                                    +  // 157 a 160 - Intru��es de Protesto
   IntToStrZero( round(ACBrTitulo.ValorMoraJuros * 100 ), 13)                   +  // 161 a 173 - Valor a ser cobrado por dia de atraso
   IfThen(ACBrTitulo.DataDesconto < EncodeDate(2000,01,01),'000000',
          FormatDateTime( 'ddmmyy', ACBrTitulo.DataDesconto))                   +  // 174 a 179 - Data limite para concess�o desconto
   IntToStrZero( round( ACBrTitulo.ValorDesconto * 100 ), 13)                   +  // 180 a 192 - Valor Desconto
   IntToStrZero( round( ACBrTitulo.ValorIOF * 100 ), 13)                        +  // 193 a 205 - Valor IOF
   IntToStrZero( round( ACBrTitulo.ValorAbatimento * 100 ), 13)                 +  // 206 a 218 - Valor Abatimento
   LTipoInscricao                                                               +  // 219 a 220 - Tipo de Inscri��o do Pagador
   PadLeft(OnlyNumber(ACBrTitulo.Sacado.CNPJCPF),14,'0')                        +  // 221 a 234 - CPF / CNPJ do Pagador (Antigo Sacado)
   PadRight( ACBrTitulo.Sacado.NomeSacado, 40, ' ')                             +  // 235 a 274 - Nome do Pagador
   PadRight(ACBrTitulo.Sacado.Logradouro
           + Space(1)
           + ACBrTitulo.Sacado.Numero
           + Space(1)
           + ACBrTitulo.Sacado.Complemento
           + Space(1)
           + ACBrTitulo.Sacado.Bairro, 40)                                      +  // 275 a 314 - Endere�o completo do pagador
   PadRight( ACBrTitulo.Sacado.Mensagem, 12, ' ')                               +  // 315 a 326 - 1� Mensagem
   PadRight( ACBrTitulo.Sacado.CEP, 8 )                                         +  // 327 a 334 - CEP
   PadLeft(OnlyNumber(ACBrTitulo.Sacado.SacadoAvalista.CNPJCPF), 15, '0')       +  // 335 a 349 - CNPJ do benefici�rio final
   Space(2)                                                                     +  // 350 a 351 - Brancos
   PadRight(ACBrTitulo.Sacado.SacadoAvalista.NomeAvalista, 43)                  +  // 352 a 394 - Nome do benefici�rio final
   IntToStrZero(aRemessa.Count + 1, 6)                                          +  // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
   LChaveNFe;                                                                     // 401 a 444 Chave NFe

   Result := UpperCase(LLinha);
end;

procedure TACBrBancoBocomBBM.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  LLinha, LNossoNumero, LDigitoNossoNumero : String;
begin
  aRemessa.Add(UpperCase(GerarLinhaRegistroTransacao400(ACBrTitulo, aRemessa)));
  LLinha := MontaInstrucoesCNAB400(ACBrTitulo, aRemessa.Count );

  if not(LLinha = EmptyStr) then
    aRemessa.Add(UpperCase(LLinha));

  if (ACBrTitulo.Sacado.SacadoAvalista.NomeAvalista <> '') then
  begin
    ValidaNossoNumeroResponsavel(LNossoNumero, LDigitoNossoNumero, ACBrTitulo);
    LLinha := '7'                                                                + // 001 a 001 - Identifica��o do registro detalhe (7)
    PadRight(Trim(ACBrTitulo.Sacado.SacadoAvalista.Logradouro + ' ' +
                  ACBrTitulo.Sacado.SacadoAvalista.Numero     + ' ' +
                  ACBrTitulo.Sacado.SacadoAvalista.Bairro)  , 45, ' ')           + // 002 a 046 - Endere�o Beneficiario Final
    PadRight(OnlyNumber(ACBrTitulo.Sacado.CEP), 8, '0' )                         + // 047 a 054 - CEP + Sufixo do CEP
    PadRight(ACBrTitulo.Sacado.SacadoAvalista.Cidade, 20, ' ')                   + // 055 a 074 - Cidade
    PadRight(ACBrTitulo.Sacado.SacadoAvalista.UF, 2, ' ')                        + // 075 a 076 - UF
    PadRight('', 290, ' ')                                                       + // 077 a 366 - Reserva Filer
    PadLeft(ACBrTitulo.Carteira, 3, '0')                                         + // 367 a 369 - Carteira
    PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 5, '0')           + // 370 a 374 - Ag�ncia mantenedora da conta
    PadLeft(ACBrTitulo.ACBrBoleto.Cedente.Conta, 7, '0')                         + // 375 a 381 - N�mero da Conta Corrente
    Padleft(ACBrTitulo.ACBrBoleto.Cedente.ContaDigito, 1 , ' ')                  + // 382 a 382 - D�gito Verificador da Conta DAC
    PadLeft(LNossoNumero, 11, '0')                                               + // 383 a 393 - Nosso N�mero
    PadLeft(LDigitoNossoNumero ,1,' ')                                           + // 394 a 394 - Digito Nosso N�mero
    IntToStrZero( ARemessa.Count + 1, 6);                                          // 395 a 400 - N�mero sequencial do registro

    ARemessa.Add(UpperCase(LLinha));
  end;
end;
procedure TACBrBancoBocomBBM.LerRetorno240(ARetorno: TStringList);
begin
  raise Exception.Create( ACBrStr('N�o permitido para o layout deste banco.') );
end;

procedure TACBrBancoBocomBBM.LerRetorno400(ARetorno: TStringList);
var LNome : String;
begin
  LNome      := fpNome;
  fpNome     := 'BoComBBM';
  fpNumero   := 107;
  inherited;
  fpNome     := LNome;
  fpNumero   := 237;
end;

end.
