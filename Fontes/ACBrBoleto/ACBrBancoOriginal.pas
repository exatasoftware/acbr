{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Renato Murilo Pavan                             }
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
unit ACBrBancoOriginal;

interface

uses
  Classes,
  SysUtils,
  Contnrs,
  ACBrBoleto,
  ACBrBoletoConversao;

type
  { TACBrBancoOriginal }
  TACBrBancoOriginal = class(TACBrBancoClass)
  private
    function MontarConvenio: string;
    procedure MontarRegistroMensagem400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
  public
    constructor Create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string; override;
    procedure GerarRegistroHeader400(NumeroRemessa: Integer; aRemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo: TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa: TStringList); override;
    procedure LerRetorno400(ARetorno: TStringList); override;
    function CodOcorrenciaToTipo(const CodOcorrencia: Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): string; override;
  end;

implementation

uses
  ACBrValidador,
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  StrUtils,
  Variants,
  DateUtils;

constructor TACBrBancoOriginal.Create(AOwner: TACBrBanco);
begin
  inherited Create(AOwner);
  fpNome := 'ORIGINAL';
  fpNumero := 212;
  fpDigito := 7;
  fpTamanhoMaximoNossoNum := 10;
  fpTamanhoAgencia := 4;
  fpTamanhoConta := 7;
  fpTamanhoCarteira := 3;
end;

function TACBrBancoOriginal.CalcularDigitoVerificador(
  const ACBrTitulo: TACBrTitulo): string;
begin
  Modulo.FormulaDigito := frModulo10;
  Modulo.MultiplicadorFinal := 1;
  Modulo.MultiplicadorInicial := 2;
  Modulo.Documento :=
    ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.Carteira
    + PadLeft(ACBrTitulo.NossoNumero, fpTamanhoMaximoNossoNum, '0');
  Modulo.Calcular;
  Result := IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoOriginal.MontarCodigoBarras(const ACBrTitulo: TACBrTitulo): string;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras: string;
  CampoLivre: string;
  Boleto: TACBrBoleto;
begin
  Boleto := ACBrTitulo.ACBrBoleto;

  if StrToInt64Def(ACBrTitulo.NossoNumero, 0) = 0 then
    raise Exception.create(ACBrStr('Banco ' + Boleto.Banco.Nome + ':: Nosso N�mero n�o Informado'));

  FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

  CampoLivre := Boleto.Cedente.Agencia
    + ACBrTitulo.Carteira
    + Boleto.Cedente.Operacao
    + ACBrTitulo.NossoNumero
    + CalcularDigitoVerificador(ACBrTitulo);

  CodigoBarras := IntToStrZero(Boleto.Banco.Numero, 3)
    + '9'
    + FatorVencimento
    + IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10)
    + CampoLivre;

  DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);

  Result := copy(CodigoBarras, 1, 4)
    + DigitoCodBarras
    + copy(CodigoBarras, 5, 39);
end;

function TACBrBancoOriginal.MontarCampoNossoNumero(const ACBrTitulo: TACBrTitulo): string;
var
  NossoNr, DV: string;
begin
  NossoNr := PadLeft(ACBrTitulo.NossoNumero, 10, '0');
  DV := CalcularDigitoVerificador(ACBrTitulo);
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/' + ACBrTitulo.Carteira
    + '/' + NossoNr
    + '-' + DV;
end;

function TACBrBancoOriginal.MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): string;
begin
  Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia
    + ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito
    + '/'
    + ACBrTitulo.ACBrBoleto.Cedente.CodigoCedente;
end;

procedure TACBrBancoOriginal.GerarRegistroHeader400(NumeroRemessa: Integer;
  aRemessa: TStringList);
var
  wLinha: string;
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;

  wLinha := '0' + //                        001 a 001 Identifica��o do registro
  '1' + //                                  002 a 002 Identifica��o do arquivo remessa
  'REMESSA' + //                            003 a 009 Literal remessa
  '01' + //                                 010 a 011 C�digo de servi�o
  PadRight('COBRANCA', 15, ' ') + //        012 a 026 Literal servi�o
  PadRight(MontarConvenio, 20, ' ') + //    027 a 046 C�digo da empresa
  PadRight(Beneficiario.Nome, 30, ' ') + // 047 a 076 Nome da empresa
  IntToStrZero(ACBrBanco.Numero, 3) + //    077 a 079 N�mero do Original na c�mara de compensa��o
  PadRight('BANCO ORIGINAL', 15, ' ') + //  080 a 094 Nome do banco por extenso
  FormatDateTime('ddmmyy', Now) + //        095 a 100 Data da grava��o do arquivo
  Space(294) + //                           101 a 394 Brancos
  '000001'; //                              395 a 400 N� sequencial do registro de um em um

  ARemessa.Add(UpperCase(wLinha));
end;

procedure TACBrBancoOriginal.GerarRegistroTransacao400(
  ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  Boleto: TACBrBoleto;
  CodigoMulta: string;
  wLinha: string;
  I: Integer;
  ValorMulta, DiasMulta: Integer;
  Linha: TStringList;
  TipoBoleto: Char;
  EspecieDoc: string;
  DiasProtesto: Integer;
begin
  Boleto := ACBrTitulo.ACBrBoleto;

  CodigoMulta := '0';

  if (ACBrTitulo.PercentualMulta > 0) then
    CodigoMulta := '2' //percentual
  else if (ACBrTitulo.MultaValorFixo) then
    CodigoMulta := '1'; //Valor fixo

  ValorMulta := 0;

  if (ACBrTitulo.PercentualMulta > 0) then
    ValorMulta := Round(ACBrTitulo.PercentualMulta * 100)
  else if (ACBrTitulo.MultaValorFixo) then
    ValorMulta := Round(ACBrTitulo.ValorDocumento * ACBrTitulo.PercentualMulta);

  DiasMulta := 0;

  if ValorMulta > 0 then
    DiasMulta := 1;

  {Pegando Tipo de Boleto}
  case Boleto.Cedente.ResponEmissao of
    tbCliEmite: TipoBoleto := 'D'; //codigo 6 Cobran�a Expressa - Orienta��o do banco enviar D
    tbBancoReemite: TipoBoleto := '1';
    tbBancoEmite: TipoBoleto := '1';
  else
    TipoBoleto := 'D'; //Cobran�a Expressa
  end;

  if ACBrTitulo.EspecieDoc = 'DM' then
    EspecieDoc := '01'
  else if ACBrTitulo.EspecieDoc = 'NP' then
    EspecieDoc := '02'
  else if ACBrTitulo.EspecieDoc = 'CH' then
    EspecieDoc := '03'
  else if ACBrTitulo.EspecieDoc = 'LC' then
    EspecieDoc := '04'
  else if ACBrTitulo.EspecieDoc = 'RC' then
    EspecieDoc := '05'
  else if ACBrTitulo.EspecieDoc = 'AP' then
    EspecieDoc := '08'
  else if ACBrTitulo.EspecieDoc = 'DS' then
    EspecieDoc := '12'
  else
    EspecieDoc := '99';

  DiasProtesto := ACBrTitulo.DiasDeProtesto;

  if DiasProtesto = 0 then
    if ACBrTitulo.DataProtesto > 0 then
      DiasProtesto := DaysBetween(ACBrTitulo.DataProtesto, ACBrTitulo.Vencimento);

  wLinha := '';
  Linha := TStringList.Create;
  try
    Linha.Add('1'); //                                                          001 a 001 Identifica��o do registro de transa��o
    Linha.Add(IfThen(Boleto.Cedente.TipoInscricao = pFisica, '01', '02')); //   002 a 003 Identifica��o do Tipo de Inscri��o da empresa
    Linha.Add(PadLeft(OnlyNumber(Boleto.Cedente.CNPJCPF), 14, '0')); //         004 a 017 N�mero de Inscri��o da Empresa (CNPJ/CPF)
    Linha.Add(PadRight(MontarConvenio, 20, ' ')); //                            018 a 037 Identifica��o da empresa no Original
    Linha.Add(PadRight(ACBrTitulo.SeuNumero, 25, ' ')); //                      038 a 062 Identifica��o do T�tulo na empresa
    Linha.Add(PadLeft(ACBrTitulo.NossoNumero, 10, '0')); //                     063 a 072 Identifica��o do T�tulo no Banco
    Linha.Add(CalcularDigitoVerificador(ACBrTitulo)); //                        073 0 073 DV Nosso N�mero
    Linha.Add(Space(13)); //                                                    074 a 086 Cobran�a Direta T�tulo Correspondente
    Linha.Add(Space(03)); //                                                    087 a 089 Modalidade de Cobran�a com bancos correspondentes
    Linha.Add(CodigoMulta); //                                                  090 a 090 C�digo da Multa 0 - Sem multa 1 - Valor fixo 2 - percentual
    Linha.Add(IntToStrZero(ValorMulta, 13)); //                                 091 a 103 C�digo da Multa 0 - Sem multa 1 - Valor fixo 2 - percentual
    Linha.Add(IntToStrZero(DiasMulta, 2)); //                                   104 a 105 N�mero de Dias Ap�s o Vencimento para aplicar a Multa
    Linha.Add(Space(02)); //                                                    106 a 107 N�mero de Brancos
    Linha.Add(TipoBoleto); //                                                   108 a 108 C�digo da Carteira :: Carteira 6 alterada segundo suporte do banco para carteira D
    Linha.Add('01'); //                                                         109 a 110 Identifica��o da ocorr�ncia 01 REMESSA
    Linha.Add(PadRight(ACBrTitulo.SeuNumero, 10, ' ')); //                      111 a 120 N? documento de Cobran�a (Duplicata, Promiss�ria etc.)
    Linha.Add(FormatDateTime('ddmmyy', ACBrTitulo.Vencimento)); //              121 a 126 Data de vencimento do t�tulo
    Linha.Add(IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 13)); //     127 a 139 Valor do t�tulo
    Linha.Add('212'); //                                                        140 a 142 C�digo do Banco
    Linha.Add(IntToStrZero(0, 4)); //                                           143 a 146  Ag�ncia encarregada da cobran�a ZEROS
    Linha.Add(IntToStrZero(0, 1)); //                                           147 a 147  DV Ag�ncia encarregada da cobran�a ZEROS
    Linha.Add(EspecieDoc); //                                                   148 a 149 Esp�cie do t�tulo
    Linha.Add(IfThen(ACBrTitulo.Aceite = atSim, 'A', 'N')); //                  150 a 150 Aceite (A ou N)
    Linha.Add(FormatDateTime('ddmmyy', ACBrTitulo.DataDocumento)); //           151 a 156 Data da emiss�o do t�tulo
    Linha.Add(IfThen(DiasProtesto > 0, '00', '10')); //                         157 a 158 Instru��o 1 - Se �INSTRO1 ou INSTRO2 = 10�, o Sistema entender� que o cedente n�o deseja, de forma alguma, que ao t�tulo seja anexada a informa��o de DIAS DE PROTESTO.
    Linha.Add('00'); //                                                         159 a 160 Instru��o 2
    Linha.Add(IntToStrZero(Round(ACBrTitulo.ValorMoraJuros * 100), 13)); //     161 a 173 Valor de mora por dia de atraso
    Linha.Add(IfThen(ACBrTitulo.DataDocumento > 0,
      FormatDateTime('ddmmyy', ACBrTitulo.DataDesconto), '000000')); //         174 a 179 Data Limite para concess�o de desconto
    Linha.Add(IntToStrZero(Round(ACBrTitulo.ValorDesconto * 100), 13)); //      180 a 192 Valor do desconto a ser concedido
    Linha.Add(IntToStrZero(0, 13)); //                                          193 a 205 Valor do I.O.F. a ser recolhido pelo Banco no caso de seguro
    Linha.Add(IntToStrZero(Round(ACBrTitulo.ValorAbatimento * 100), 13)); //    206 a 218 Valor do abatimento a ser concedido
    Linha.Add(IfThen(ACBrTitulo.Sacado.Pessoa = pFisica, '01', '02')); //       219 a 220 Identifica��o do tipo de inscri��o do sacado
    Linha.Add(PadLeft(OnlyNumber(ACBrTitulo.Sacado.CNPJCPF), 14, '0')); //      221 a 234 N�mero de Inscri��o do Sacado
    Linha.Add(PadRight(TiraAcentos(ACBrTitulo.Sacado.NomeSacado), 30, ' ')); // 234 a 264 Nome do Sacado
    Linha.Add(Space(10)); //                                                    265 a 274 Complementa��o do Registro - Brancos
    Linha.Add(PadRight(TiraAcentos(ACBrTitulo.Sacado.Logradouro) + ' ' +
      ACBrTitulo.Sacado.Numero + ' ' +
      ACBrTitulo.Sacado.Complemento, 40, ' ')); //                              275 a 314 Rua, N�mero e Complemento do Sacado
    Linha.Add(PadRight(TiraAcentos(ACBrTitulo.Sacado.Bairro), 12, ' ')); //     315 a 326 Bairro do Sacado
    Linha.Add(PadLeft(OnlyNumber(ACBrTitulo.Sacado.CEP), 8, '0')); //           327 a 334 CEP do Sacado
    Linha.Add(PadRight(TiraAcentos(ACBrTitulo.Sacado.Cidade), 15, ' ')); //     335 a 349 Cidade do Sacado
    Linha.Add(PadRight(TiraAcentos(ACBrTitulo.Sacado.UF), 2, ' ')); //          350 a 351 Bairro do Sacado
    linha.Add(Space(30)); //                                                    352 a 381 Nome do Sacador ou Avalista
    linha.Add(Space(10)); //                                                    382 a 391 Complementa��o do Registro - Brancos
    Linha.Add(IfThen(DiasProtesto > 0, IntToStrZero(DiasProtesto, 2), '00')); //392 a 393 Quantidade de dias para in�cio da A��o de Protesto
    Linha.Add('0'); //                                                          394 a 394 Moeda 0 ou 1 Moeda Corrente Nacional
    Linha.Add(IntToStrZero(ARemessa.Count + 1, 6)); //                          395 a 400 N�mero Seq�encial do Registro no Arquivo

    for I := 0 to Pred(Linha.Count) do
      wLinha := wLinha + Linha[I];
  finally
    ARemessa.Add(UpperCase(wLinha));
    MontarRegistroMensagem400(ACBrTitulo, aRemessa);
    FreeAndNil(Linha);
  end;
end;

procedure TACBrBancoOriginal.GerarRegistroTrailler400(
  ARemessa: TStringList);
var
  wLinha: string;
begin
  wLinha := '9' + //                      001 a 001 Identifica��o registro
  Space(393) + //                         002 a 394 Branco
  IntToStrZero(ARemessa.Count + 1, 6); // 395 a 400 N�mero sequencial de registro

  ARemessa.Add(UpperCase(wLinha));
end;

function TACBrBancoOriginal.MontarConvenio: string;
var
  Beneficiario: TACBrCedente;
begin
  Beneficiario := ACBrBanco.ACBrBoleto.Cedente;
  Result := '090';
  Result := Result + PadLeft(Beneficiario.Agencia, 4, '0');
  Result := Result + PadLeft(Beneficiario.AgenciaDigito, 1, '0');
  Result := Result + PadLeft(Beneficiario.Operacao, 7, '0');
end;

procedure TACBrBancoOriginal.MontarRegistroMensagem400(
  ACBrTitulo: TACBrTitulo; aRemessa: TStringList);
var
  Mensagem: array[0..4] of string;
  i: integer;
  wLinha: string;
begin
  wLinha := EmptyStr;
  //5 linhas de mensagens
  for i := 0 to Pred(ACBrTitulo.Informativo.Count) do
  begin
    if i > 4 then Break;
    Mensagem[i] := ACBrTitulo.Informativo[i];
  end;

  //Cobran�a garantida, Original exige uma mensagem informativa
  //Pedimos que seja inclu�da a mensagem abaixo, por tratar-se de Cobran�a com garantia de duplicatas:
  //T�TULO CEDIDO AO BANCO ORIGINAL S/A. FICA VEDADO PAGTO DE QUALQUER OUTRA FORMA QUE N�O ATRAV�S DO PRESENTE

  if NaoEstaVazio(ACBrTitulo.Informativo.Text) then
  begin
    wLinha := '2' + //                          001 a 001 Identifica��o registro
    '0' + //                                    002 a 002 Zero
    PadRight(TiraAcentos(Mensagem[0]), 69) + // 003 a 071 Mensagem Livre 1 69 posi��es
    PadRight(TiraAcentos(Mensagem[1]), 69) + // 072 a 140 Mensagem Livre 2 69 posi��es
    PadRight(TiraAcentos(Mensagem[2]), 69) + // 141 a 209 Mensagem Livre 3 69 posi��es
    PadRight(TiraAcentos(Mensagem[3]), 69) + // 210 a 278 Mensagem Livre 4 69 posi��es
    PadRight(TiraAcentos(Mensagem[4]), 69) + // 279 a 347 Mensagem Livre 5 69 posi��es
    Space(47) + //                              280 a 394 Brancos
    IntToStrZero(ARemessa.Count + 1, 6); //     395 a 400 N�mero sequencial de registro

    ARemessa.Add(UpperCase(wLinha));
  end;
end;

procedure TACBrBancoOriginal.LerRetorno400(ARetorno: TStringList);
var
  ContLinha: Integer;
  Linha: string;
  Titulo: TACBrTitulo;
  Boleto: TACBrBoleto;
begin
  Boleto := ACBrBanco.ACBrBoleto;

  if (StrToIntDef(copy(ARetorno.Strings[0], 77, 3), -1) <> Numero) then
    raise Exception.create(ACBrStr(Boleto.NomeArqRetorno + 'n�o � um arquivo de retorno do ' + Nome));

  Boleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2)
    + '/'
    + Copy(ARetorno[0], 97, 2)
    + '/'
    + Copy(ARetorno[0], 99, 2), 0, 'DD/MM/YY');

  Boleto.Cedente.Nome := Trim(Copy(ARetorno[0], 47, 30));
  Boleto.Cedente.CNPJCPF := Trim(Copy(ARetorno[1], 4, 14));
  Boleto.Cedente.Operacao := Trim(Copy(ARetorno[1], 26, 12));

  case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
    01: Boleto.Cedente.TipoInscricao := pFisica;
  else
    Boleto.Cedente.TipoInscricao := pJuridica;
  end;

  Boleto.ListadeBoletos.Clear;

  for ContLinha := 1 to ARetorno.Count - 2 do
  begin
    Linha := ARetorno[ContLinha];

    if (Copy(Linha, 1, 1) <> '1') then
      Continue;

    Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

    case StrToInt(copy(Linha, 108, 1)) of
      1: Titulo.CaracTitulo := tcSimples;
      2: Titulo.CaracTitulo := tcVinculada;
      3: Titulo.CaracTitulo := tcCaucionada;
      4: Titulo.CaracTitulo := tcDescontada;
    end;

    Titulo.SeuNumero := copy(Linha, 117, 10);
    Titulo.NumeroDocumento := copy(Linha, 38, 25);
    Titulo.Carteira := copy(Linha, 83, 3);

    Titulo.OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 109, 2), 0));

    if Titulo.OcorrenciaOriginal.Tipo in [toRetornoRegistroRecusado,
      toRetornoBaixaRejeitada, toRetornoInstrucaoRejeitada] then
      Titulo.DescricaoMotivoRejeicaoComando.Add('C�digo do erro - Tabela 2.3 do manual:' + Trim(copy(Linha, 378, 2)));

    Titulo.DataOcorrencia := StringToDateTimeDef(Copy(Linha, 111, 2) + '/' + Copy(Linha, 113, 2) + '/' + Copy(Linha, 115, 2), 0, 'DD/MM/YY');

    case StrToIntDef(Copy(Linha, 174, 2), 0) of
      01: Titulo.EspecieDoc := 'DM';
      02: Titulo.EspecieDoc := 'NP';
      03: Titulo.EspecieDoc := 'CH';
      04: Titulo.EspecieDoc := 'LC';
      05: Titulo.EspecieDoc := 'RC';
      08: Titulo.EspecieDoc := 'AS';
      12: Titulo.EspecieDoc := 'DS';
      31: Titulo.EspecieDoc := 'CC';
      99: Titulo.EspecieDoc := 'Outros';
    end;

    if (StrToIntDef(Copy(Linha, 147, 6), 0) <> 0) then
      Titulo.Vencimento := StringToDateTimeDef(Copy(Linha, 147, 2)
        + '/'
        + Copy(Linha, 149, 2)
        + '/'
        + Copy(Linha, 151, 2), 0, 'DD/MM/YY');

    Titulo.ValorDocumento       := StrToFloatDef(Copy(Linha, 153, 13), 0) / 100;
    Titulo.ValorRecebido        := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100;
    Titulo.ValorAbatimento      := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100;
    Titulo.ValorDesconto        := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100;
    Titulo.ValorMoraJuros       := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100;
    Titulo.ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100;

    Titulo.NossoNumero := Copy(Linha, 63, 11);
    if (StrToIntDef(Copy(Linha, 386, 6), 0) <> 0) then
      Titulo.DataCredito := StringToDateTimeDef(Copy(Linha, 386, 2)
        + '/'
        + Copy(Linha, 388, 2)
        + '/'
        + Copy(Linha, 390, 2), 0, 'DD/MM/YY');
  end;
end;

function TACBrBancoOriginal.CodOcorrenciaToTipo(
  const CodOcorrencia: Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    01: Result := toRetornoEntradaConfirmadaNaCip;
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    05: Result := toRetornoDadosAlterados;
    06: Result := toRetornoLiquidado;
    08: Result := toRetornoLiquidadoEmCartorio;
    09: Result := toRetornoBaixaAutomatica;
    10: Result := toRetornoBaixaPorTerSidoLiquidado;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoBaixaRejeitada;
    16: Result := toRetornoInstrucaoRejeitada;
    19: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    20: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
    22: Result := toRetornoAlteracaoSeuNumero;
    23: Result := toRetornoEncaminhadoACartorio;
    24: Result := toRetornoRecebimentoInstrucaoNaoProtestar;
    40: Result := toRetornoDebitoTarifas;
    43: Result := toRetornoBaixaPorProtesto;
    96: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    97: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    98: Result := toRetornoDebitoMensalTarifasOutrasInstrucoes;
    99: Result := toRetornoDebitoMensalTarifasSustacaoProtestos;
  else
    Result := toTipoOcorrenciaNenhum;
  end;
end;

function TACBrBancoOriginal.TipoOcorrenciaToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia): string;
begin
  case TipoOcorrencia of
    toRetornoEntradaConfirmadaNaCip                      : Result := '01-Confirma Entrada T�tulo na CIP';
    toRetornoRegistroConfirmado                          : Result := '02�Entrada Confirmada';
    toRetornoRegistroRecusado                            : Result := '03�Entrada Rejeitada';
    toRetornoDadosAlterados                              : Result := '05-Campo Livre Alterado';
    toRetornoLiquidado                                   : Result := '06-Liquida��o Normal';
    toRetornoLiquidadoEmCartorio                         : Result := '08-Liquida��o em Cart�rio';
    toRetornoBaixaAutomatica                             : Result := '09-Baixa Autom�tica';
    toRetornoBaixaPorTerSidoLiquidado                    : Result := '10-Baixa por ter sido liquidado';
    toRetornoAbatimentoConcedido                         : Result := '12-Confirma Abatimento';
    toRetornoAbatimentoCancelado                         : Result := '13-Abatimento Cancelado';
    toRetornoVencimentoAlterado                          : Result := '14-Vencimento Alterado';
    toRetornoBaixaRejeitada                              : Result := '15-Baixa Rejeitada';
    toRetornoInstrucaoRejeitada                          : Result := '16-Instru��o Rejeitadas';
    toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente : Result := '19-Confirma Recebimento de Ordem de Protesto';
    toRetornoAlteracaoSeuNumero                          : Result := '22-Seu n�mero alterado';
    toRetornoEncaminhadoACartorio                        : Result := '23-T�tulo enviado para cart�rio';
    toRetornoRecebimentoInstrucaoNaoProtestar            : Result := '24-Confirma recebimento de ordem de n�o protestar';
    toRetornoDebitoTarifas                               : Result := '40-Tarifa de Entrada (debitada na Liquida��o)';
    toRetornoBaixaPorProtesto                            : Result := '43-Baixado por ter sido protestado';
    toRetornoDebitoMensalTarifasOutrasInstrucoes         : Result := '96, 97 e 98-Tarifas - M�s Anterior';
    toRetornoDebitoMensalTarifasSustacaoProtestos        : Result := '99-Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior';
  else
    Result := 'Outras ocorr�ncias';
  end;
end;

end.

