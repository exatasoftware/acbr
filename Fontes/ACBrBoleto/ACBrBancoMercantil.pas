  {******************************************************************************}
  { Projeto: Componentes ACBr                                                    }
  {  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
  { mentos de Automa��o Comercial utilizados no Brasil                           }
  {                                                                              }
  { Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
  {                                                                              }
  { Colaboradores nesse arquivo:   Juliana Rodrigues Prado                       }
  {                            :   Agnaldo Pedroni                               }
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
unit ACBrBancoMercantil;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoConversao;

type

    { TACBrBancoMercantil }

  TACBrBancoMercantil = class(TACBrBancoClass)
  private
    function FormataNossoNumero(const ACBrTitulo: TACBrTitulo): String;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;
  public
    Constructor create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(aRemessa: TStringList); override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
  end;

implementation

uses
{$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

  { TACBrBancoMercantil }

function TACBrBancoMercantil.CodOcorrenciaToTipoRemessa(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02:
      Result := toRemessaBaixar; {Pedido de Baixa}
    04:
      Result := toRemessaConcederAbatimento; {Concess�o de Abatimento}
    05:
      Result := toRemessaCancelarAbatimento; {Cancelamento de Abatimento concedido}
    06:
      Result := toRemessaAlterarVencimento; {Prorroga��o}
    07:
      Result := toRemessaAlterarUsoEmpresa; {Troca Uso da Empresa}
    09:
      Result := toRemessaProtestar; {Protestar}
    10:
      Result := toRemessaNaoProtestar; {N�o Protestar}
    18:
      Result := toRemessaCancelarInstrucaoProtestoBaixa; {Sustar Protesto e Baixar T�tulo}
    19:
      Result := toRemessaCancelarInstrucaoProtesto; {Sustar o Protesto e Manter em Carteira}
    31:
      Result := toRemessaOutrasOcorrencias; {Altera��o de Outros Dados}
    34:
      Result := toRemessaBaixaporPagtoDiretoCedente; {Baixa por ter sido pago Diretamente ao Cedente}
    90:
      Result := toRemessaOutrasAlteracoes; {Troca de emitente}
    else
      Result := toRemessaRegistrar; {Remessa}
  end;
end;

constructor TACBrBancoMercantil.create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);
  fpDigito                := 1;
  fpNome                  := 'Banco Mercantil';
  fpNumero                := 389;
  fpTamanhoMaximoNossoNum := 6;
  fpTamanhoCarteira       := 2;
end;

function TACBrBancoMercantil.FormataNossoNumero(const ACBrTitulo: TACBrTitulo): String;
var
  ANossoNumero: string;
  aModalidade : String;
begin
  aModalidade := IfThen(Length(trim(ACBrTitulo.ACBrBoleto.Cedente.Modalidade)) = 2, ACBrTitulo.ACBrBoleto.Cedente.Modalidade, '22');

  ANossoNumero := PadRight(ACBrTitulo.ACBrBoleto.Cedente.Agencia, 4, '0') + //4
    aModalidade + //6
    ACBrTitulo.Carteira + //8
    PadRight(ACBrTitulo.NossoNumero, 6, '0') + //14
    CalcularDigitoVerificador(ACBrTitulo); //15

  Result := ANossoNumero;
end;

function TACBrBancoMercantil.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): String;
var
  aModalidade: String;
begin
  Modulo.CalculoPadrao;
  Modulo.MultiplicadorAtual := 2;

  aModalidade := IfThen(Length(trim(ACBrTitulo.ACBrBoleto.Cedente.Modalidade)) = 2, ACBrTitulo.ACBrBoleto.Cedente.Modalidade, '22');

  Modulo.Documento := ACBrTitulo.ACBrBoleto.Cedente.Agencia + aModalidade + ACBrTitulo.Carteira + PadRight(ACBrTitulo.NossoNumero, 6, '0');

  Modulo.Calcular;
  Result := IntToStr(Modulo.DigitoFinal);

end;

function TACBrBancoMercantil.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): String;
var
  FatorVencimento, DigitoCodBarras, CpObrigatorio, CpLivre: String;
begin

  with ACBrTitulo.ACBrBoleto do
  begin
    FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      // comum a todos bancos
    CpObrigatorio := IntToStr(Numero) + //4
      '9' + //5
      FatorVencimento + //9
      IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10); //19

      // AG+22+01+123456
    CpLivre := FormataNossoNumero(ACBrTitulo) + //34
      PadRight(Cedente.CodigoCedente, 9, '0') + //43
      IfThen(ACBrTitulo.ValorDesconto > 0, '0', '2'); // ?? indicador Desconto 2-Sem 0-Com  // 44

    DigitoCodBarras := CalcularDigitoCodigoBarras(CpObrigatorio + CpLivre);

  end;

  Result := IntToStr(Numero) + '9' + DigitoCodBarras + Copy((CpObrigatorio + CpLivre), 5, 39);

end;

function TACBrBancoMercantil.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := Copy(FormataNossoNumero(ACBrTitulo), 5, 11);
end;

  // usado no carn�
function TACBrBancoMercantil.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia + '-' + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito + '/' + ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

procedure TACBrBancoMercantil.GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList);
var
  wLinha: String;
begin
  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    wLinha := '0' + // ID do Registro
      '1' + // ID do Arquivo( 1 - Remessa)
      'REMESSA' + // Literal de Remessa
      '01' + // C�digo do Tipo de Servi�o
      PadRight('COBRANCA', 15) + // Descri��o do tipo de servi�o
      PadRight(OnlyNumber(Agencia), 4) + // agencia origem
      PadLeft(OnlyNumber(CNPJCPF), 15, '0') + // CNPJ/CPF CEDENTE
      ' ' + // BRANCO
      PadRight(Nome, 30) + // Nome da Empresa
      '389' + // ID BANCO
      'BANCO MERCANTIL' + // nome banco
      FormatDateTime('ddmmyy', Now) + // data gera��o
      Space(281) + // espa�os branco
      '01600   ' + // densidade da grava��o
      IntToStrZero(NumeroRemessa, 5) + // nr. sequencial remessa
      IntToStrZero(1, 6); // Nr. Sequencial de Remessa

    aRemessa.Text := aRemessa.Text + UpperCase(wLinha);
  end;
end;

procedure TACBrBancoMercantil.GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  Ocorrencia, wLinha     : String;
  TipoSacado, ATipoAceite: String;
begin

  with ACBrTitulo do
  begin
      {Pegando C�digo da Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar:
        Ocorrencia := '02'; {Pedido de Baixa}
      toRemessaConcederAbatimento:
        Ocorrencia := '04'; {Concess�o de Abatimento}
      toRemessaCancelarAbatimento:
        Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
      toRemessaAlterarVencimento:
        Ocorrencia := '06'; {Altera��o de vencimento}
      toRemessaAlterarNumeroControle:
        Ocorrencia := '08'; {Altera��o de seu n�mero}
      toRemessaProtestar:
        Ocorrencia := '09'; {Pedido de protesto}
      toRemessaCancelarInstrucaoProtestoBaixa:
        Ocorrencia := '18'; {Sustar protesto e baixar}
      toRemessaCancelarInstrucaoProtesto:
        Ocorrencia := '19'; {Sustar protesto e manter na carteira}
      toRemessaOutrasOcorrencias:
        Ocorrencia := '31'; {Altera��o de Outros Dados}
      else
        Ocorrencia := '01'; {Remessa}
    end;

      {Pegando Tipo de Sacado}
    case Sacado.Pessoa of
      pFisica:
        TipoSacado := '01';
      pJuridica:
        TipoSacado := '02';
      else
        TipoSacado := '99';
    end;

      { Pegando o Aceite do Titulo }
    case Aceite of
      atSim:
        ATipoAceite := 'S';
      atNao:
        ATipoAceite := 'N';
    end;

    with ACBrBoleto do
    begin
      wLinha := '1' + // ID Registro
        IfThen(PercentualMulta > 0, '092', '000') + // Indica se exite Multa ou n�o
        IntToStrZero(Round(PercentualMulta * 100), 13) + // Percentual de Multa formatado com 2 casas decimais
        FormatDateTime('ddmmyy', Vencimento + 1) + // data Multa
        Space(5) + PadLeft(Cedente.CodigoCedente, 9, '0') + // numero do contrato ???
        PadLeft(SeuNumero, 25, '0') + // Numero de Controle do Participante
        FormataNossoNumero(ACBrTitulo) + Space(5) + PadLeft(OnlyNumber(Cedente.CNPJCPF), 15, '0') + IntToStrZero(Round(ValorDocumento * 100), 10) + // qtde de moeda
        '1' + // Codigo Opera��o 1- Cobran�a Simples
        Ocorrencia + PadRight(NumeroDocumento, 10) + // numero titulo atribuido pelo cliente
        FormatDateTime('ddmmyy', Vencimento) + IntToStrZero(Round(ValorDocumento * 100), 13) + // valor nominal do titulo
        '389' + // banco conbrador
        '00000' + // agencia cobradora
        '01' + // codigo da especie, duplicata mercantil
        ATipoAceite + // N
        FormatDateTime('ddmmyy', DataDocumento) + // Data de Emiss�o
        PadRight(Instrucao1, 2, '0') + // instru�oes de cobran�a
        PadRight(Instrucao2, 2, '0') + // instru�oes de cobran�a
        IntToStrZero(Round(ValorMoraJuros * 100), 13) + // juros mora 11.2
        IfThen(DataDesconto > 0, FormatDateTime('ddmmyy', DataDesconto), PadRight('', 6, '0')) + // data limite desconto
        IntToStrZero(Round(ValorDesconto * 100), 13) + // valor desconto
        StringOfChar('0', 13) + // iof - caso seguro
        StringOfChar('0', 13) + // valor abatimento ?????
        TipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0') + PadRight(Sacado.NomeSacado, 40, ' ') + PadRight(Sacado.Logradouro + Sacado.Numero, 40) +
        PadRight(Sacado.Bairro, 12) + PadRight(Sacado.CEP, 8, '0') + PadRight(Sacado.Cidade, 15) + PadRight(Sacado.UF, 2) + PadRight(Sacado.Avalista, 30) + // Avalista
        Space(12) + '1' + // codigo moeda
        IntToStrZero(aRemessa.Count + 1, 6);

      aRemessa.Text := aRemessa.Text + UpperCase(wLinha);
    end;
  end;
end;

procedure TACBrBancoMercantil.GerarRegistroTrailler400(aRemessa: TStringList);
var
  wLinha: String;
begin
  wLinha := '9' + Space(393) + // ID Registro
    IntToStrZero(aRemessa.Count + 1, 6); // Contador de Registros

  aRemessa.Text := aRemessa.Text + UpperCase(wLinha);
end;

function TACBrBancoMercantil.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result        := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    02 : Result := 'Entrada confirmada';
    03 : Result := 'Entrada rejeitada';
    04 : Result := 'Transfer�ncia de contrato';
    06 : Result := 'Liquidado';
    09 : Result := 'Baixa Autom�tica';
    10 : Result := 'Baixa pedido do cedente';
    12 : Result := 'Abatimento/Desconto concedido';
    13 : Result := 'Abatimento/Desconto cancelado';
    14 : Result := 'Altera��o de vencimento';
    15 : Result := 'Liquidado em cart�rio';
    16 : Result := 'Liquidado com cheque a compensar';
    19 : Result := 'Altera��o de instru��o protesto';
    22 : Result := 'Altera��o de seu n�mero';
    23 : Result := 'Liquidado por d�bito em conta';
    24 : Result := 'Liquidado pelo Banco Correspondente';
    31 : Result := 'Baixa franco de pagamento';
    55 : Result := 'Instru��o codificada';
    56 : Result := 'Sustar protesto e manter em carteira';
    65 : Result := 'Emiss�o de Segunda via de aviso';
    //67 : Result := toRetorno;
    83 : Result := 'Cobran�a autom�tica de tarifas';
    //84 : Result := toRetorno;
    85 : Result := 'Baixa de t�tulo protestado';
  end;
  Result := Poem_Zeros(CodOcorrencia,2) + '-' + Result;
end;

function TACBrBancoMercantil.CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;

  case CodOcorrencia of
    02 : Result := toRetornoRegistroConfirmado;
    03 : Result := toRetornoRegistroRecusado;
    04 : Result := toRetornoBaixaTransferenciaParaDesconto;
    06 : Result := toRetornoLiquidado;
    09 : Result := toRetornoBaixaAutomatica;
    10 : Result := toRetornoBaixadoViaArquivo;
    12 : Result := toRetornoAbatimentoConcedido;
    13 : Result := toRetornoAbatimentoCancelado;
    14 : Result := toRetornoVencimentoAlterado;
    15 : Result := toRetornoLiquidadoEmCartorio;
    16 : Result := toRetornoChequePendenteCompensacao;
    19 : Result := toRetornoProtestado;
    22 : Result := toRetornoAlteracaoSeuNumero;
    23 : Result := toRetornoDebitoEmConta;
    24 : Result := toRetornoLiquidadoPorConta;
    31 : Result := toRetornoBaixadoFrancoPagamento;
    55 : Result := toRetornoAlteracaoInstrucao;
    56 : Result := toRetornoSustacaoSolicitada;
    65 : Result := toRetornoSegundaViaInstrumentoProtesto;
    //67 : Result := toRetorno;
    83 : Result := toRetornoTarifaInstrucao;
    //84 : Result := toRetorno;
    85 : Result := toRetornoBaixaPorProtesto;
  end;
end;

function TACBrBancoMercantil.TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

  case TipoOcorrencia of
    toRetornoRegistroConfirmado:
      Result := '02';
    toRetornoRegistroRecusado:
      Result := '03';
    toRetornoBaixaTransferenciaParaDesconto:
      Result := '04';
    toRetornoLiquidado:
      Result := '06';
    toRetornoBaixaAutomatica:
      Result := '09';
    toRetornoBaixadoViaArquivo:
      Result := '10';
    toRetornoAbatimentoConcedido:
      Result := '12';
    toRetornoAbatimentoCancelado:
      Result := '13';
    toRetornoVencimentoAlterado:
      Result := '14';
    toRetornoLiquidadoEmCartorio:
      Result := '15';
    toRetornoChequePendenteCompensacao:
      Result := '16';
    toRetornoProtestado:
      Result := '19';
    toRetornoAlteracaoSeuNumero:
      Result := '22';
    toRetornoDebitoEmConta:
      Result := '23';
    toRetornoLiquidadoPorConta:
      Result := '24';
    toRetornoBaixadoFrancoPagamento:
      Result := '31';
    toRetornoAlteracaoInstrucao:
      Result := '55';
    toRetornoSustacaoSolicitada:
      Result := '56';
    toRetornoSegundaViaInstrumentoProtesto:
      Result := '65';
      //67 : Result := toRetorno;
    toRetornoTarifaInstrucao:
      Result := '83';
      //84 : Result := toRetorno;
    toRetornoBaixaPorProtesto:
      Result := '85';
  end;
end;

end.
