{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou, Andr� Ferreira de Moraes,      }
{ Jos� M S Junior                                                              }
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

unit ACBrBancoC6;

interface

uses
  Classes, Contnrs, SysUtils, ACBrBoleto, ACBrBoletoConversao;

type

  { TACBrBancoC6 }

  TACBrBancoC6 = class(TACBrBancoClass)
  private
    function ConverterMultaPercentual(const ACBrTitulo: TACBrTitulo): Double;
  protected
    function ConverterDigitoModuloFinal(): String; override;
    function DefineCampoLivreCodigoBarras(const ACBrTitulo: TACBrTitulo): String; override;

  public
    Constructor create(AOwner: TACBrBanco);
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;

    procedure GerarRegistroHeader400(NumeroRemessa: Integer;  ARemessa: TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    function MontaInstrucoesCNAB400(const ACBrTitulo :TACBrTitulo; const nRegistro: Integer ): String; override;
//    function  GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo:Integer): String; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOcorrenciaToCodRemessa(const TipoOcorrencia: TACBrTipoOcorrencia): String; override;

  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime ;

{ TACBrBancoC6 }
//p
function TACBrBancoC6.ConverterDigitoModuloFinal(): String;
begin
  if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;
//p
function TACBrBancoC6.DefineCampoLivreCodigoBarras(
  const ACBrTitulo: TACBrTitulo): String;
var LEmissao : char;
begin
  with ACBrTitulo.ACBrBoleto do
  begin

    case ACBrTitulo.ACBrBoleto.Cedente.ResponEmissao of
      tbBancoEmite,
      tbBancoPreEmite,
      tbBancoNaoReemite,
      tbBancoReemite      : LEmissao := '3'; //3 para cobran�a registrada com emiss�o pelo banco
      else
        LEmissao := '4'; //4 para cobran�a direta com emiss�o pelo cedente
    end;

    Result := PadLeft(OnlyNumber(Cedente.CodigoCedente), 12, '0') +
              ACBrTitulo.NossoNumero +
              ACBrTitulo.Carteira +
              LEmissao;
  end;
end;
//ok
function TACBrBancoC6.ConverterMultaPercentual(
  const ACBrTitulo: TACBrTitulo): Double;
begin
  with ACBrTitulo do
  begin
    if MultaValorFixo then
        if (ValorDocumento > 0) then
          Result := (PercentualMulta / ValorDocumento) * 100
        else
          Result := 0
      else
        Result := PercentualMulta;
  end;
end;
//ok
constructor TACBrBancoC6.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 2;
   fpNome                   := 'C6BANK';
   fpNumero                 := 336;
   fpTamanhoMaximoNossoNum  := 10;
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 7;
   fpTamanhoCarteira        := 2;
   fpLayoutVersaoArquivo    := 22;
   fpLayoutVersaoLote       := 0;
   fpDensidadeGravacao      := '';//'06250';
   fpModuloMultiplicadorInicial:= 2;
   fpModuloMultiplicadorFinal:= 7;
   fpCodParametroMovimento:= '';//'MX';
end;
//ok
function TACBrBancoC6.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   //Result:= ACBrTitulo.Carteira+'/'+ACBrTitulo.NossoNumero+'-'+CalcularDigitoVerificador(ACBrTitulo);
   Result:= '0' + ACBrTitulo.Carteira + ACBrTitulo.NossoNumero + CalcularDigitoVerificador(ACBrTitulo);
   //Result:= ACBrTitulo.NossoNumero;
end;
//ok
//function TACBrBancoC6.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String;
//var
//  ATipoOcorrencia,
//  ATipoBoleto,
//  ADataMoraJuros,
//  ACodigoMoraJuros,
//  ACodigoDesconto: String;
//  ADataDesconto,
//  ACodigoMulta,
//  ADataMulta,
//  ATipoAceite,
//  AEspecieDoc: String;
//
//  Fsequencia:Integer;
//  FdigitoNossoNumero: String;
//  FcodCarteira: String;
//  ACodProtesto: String;
//  ListTransacao: TStringList;
//
//begin
//  Fsequencia     := 3 * ACBrTitulo.ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo);
//
//  //Caracteristica T�tulo
//  FcodCarteira := DefineCaracTitulo(ACBrTitulo);
//
//  //Digito Nosso N�mero
//  FdigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);
//
//  {C�digo para Protesto}
//  ACodProtesto := DefineTipoDiasProtesto(ACBrTitulo);
//
//  {Tipo de Ocorrencia}
//  ATipoOcorrencia := TipoOcorrenciaToCodRemessa(ACBrTitulo.OcorrenciaOriginal.Tipo);
//
//  {Aceite do Titulo }
//  ATipoAceite := DefineAceite(ACBrTitulo);
//
//  {Especie Documento}
//  AEspecieDoc := DefineEspecieDoc(ACBrTitulo);
//
//  {Responsavel Emiss�o}
//  ATipoBoleto := DefineResponsEmissao;
//
//  {C�digo Mora}
//  ACodigoMoraJuros := DefineCodigoMoraJuros(ACBrTitulo);
//
//  {Data Mora}
//  ADataMoraJuros := DefineDataMoraJuros(ACBrTitulo);
//
//  {C�digo Desconto}
//  ACodigoDesconto := DefineCodigoDesconto(ACBrTitulo);
//
//  {Data Desconto}
//  ADataDesconto := DefineDataDesconto(ACBrTitulo);
//
//  {C�digo Multa}
//  ACodigoMulta := DefineCodigoMulta(ACBrTitulo);
//
//  {Data Multa}
//  ADataMulta := DefineDataMulta(ACBrTitulo);
//
//  ListTransacao:= TStringList.Create;
//  try
//
//    with ACBrTitulo do
//    begin
//      {REGISTRO P}
//      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)    + //1 a 3 - C�digo do banco
//        '0001'                                               + //4 a 7 - Lote de servi�o
//        '3'                                                  + //8 - Tipo do registro: Registro detalhe
//        IntToStrZero(Fsequencia+1,5)                         + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
//        'P'                                                  + //14 - C�digo do segmento do registro detalhe
//        ' '                                                  + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
//        ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
//        PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 5, '0') + //18 a 22 - Ag�ncia mantenedora da conta
//        PadRight(ACBrBoleto.Cedente.AgenciaDigito, 1 , '0')  + //23 -D�gito verificador da ag�ncia
//        PadLeft(ACBrBoleto.Cedente.conta, 12, '0')           + //24 a 35 - N�mero da Conta Corrente
//        Padleft(ACBrBoleto.Cedente.ContaDigito, 1 , '0')     + //36 a 36 D�gito Verificador da Conta Alfa *G011
//        ' '                                                  + //Retornaram que deve gravar vazio .. contrario ao layout
//        //PadLeft(Copy(Fconta,Length(Fconta) ,1 ),1, ' ')    + //37-37D�gito Verificador da Ag/Conta 37 37 1 - Alfa *G012
//        PadLeft(ACBrTitulo.Carteira, 3, '0')                 + //38-40 Identifica��o do Produto 38 40 3 Num *G069
//        PadLeft('0', 5, '0')                                 + //Zeros 41 45 5 Num *G069
//        PadLeft(NossoNumero, 11, '0')                        + //Nosso N�mero 46 56 11 Num *G069
//        PadLeft(FdigitoNossoNumero,1,'0')                    + //Digito do nosso N�mero 57 57 1 Num *G069
//        PadLeft(FcodCarteira,1,'0' )                         + //C�digo da Carteira 58 58 1 - Num *C006
//        '1'                                                  + //Forma de Cadastr. do T�tulo no Banco 59 59 1 - Num *C007   1-cobran�a Registrada
//        '1'                                                  + //Tipo de Documento 60 60 1 - Alfa C008    -1-Tradicional
//        ATipoBoleto                                          + //Identifica��o da Emiss�o do Bloqueto 61 61 1 - Num *C009
//        ATipoBoleto                                          +//Identifica��o da Distribui��o 62 62 1 - Alfa C010  -Quem emite que distribua...
//        PadRight(NumeroDocumento, 15, ' ')                   + //N�mero do Documento de Cobran�a 63 77 15 - Alfa *C011
//        FormatDateTime('ddmmyyyy', Vencimento)               + //Data de Vencimento do T�tulo 78 85 8 - Num *C012
//        IntToStrZero( round( ValorDocumento * 100), 15)      + //Valor Nominal do T�tulo 86 100 13 2 Num *G070
//        Padleft('0', 5, '0')                                 + //Ag�ncia Encarregada da Cobran�a 101 105 5 - Num *C014
//        '0'                                                  + //D�gito Verificador da Ag�ncia 106 106 1 - Alfa *G009
//        PadRight(AEspecieDoc, 2)                             + //Esp�cie do T�tulo 107 108 2 - Num *C015
//        ATipoAceite                                          + //Identific. de T�tulo Aceito/N�o Aceito 109 109 1 - Alfa C016
//        FormatDateTime('ddmmyyyy', DataDocumento)            + //Data da Emiss�o do T�tulo 110 117 8 - Num G071
//        ACodigoMoraJuros                                     + //C�digo do Juros de Mora 118 118 1 - Num *C018  '1' = Valor por Dia'2' = Taxa Mensal '3' = Isento
//        ADataMoraJuros                                       + //Data do Juros de Mora 119 126 8 - Num *C019
//        IfThen(ValorMoraJuros > 0, IntToStrZero(round(ValorMoraJuros * 100), 15),PadRight('', 15, '0')) + //juros de Mora por Dia/Taxa 127 141 13 2 Num C020
//        ACodigoDesconto                                      + //C�digo do Desconto 1 142 142 1 - Num *C021
//        ADataDesconto                                        + //Data do Desconto 1 143 150 8 - Num C022
//        IfThen(ValorDesconto > 0, IntToStrZero(
//        round(ValorDesconto * 100), 15),PadRight('', 15, '0'))
//                                                             + //Valor/Percentual a ser Concedido 151 165 13 2 Num C023
//        IntToStrZero( round(ValorIOF * 100), 15)             + //Valor do IOF a ser Recolhido 166 180 13 2 Num C024
//        IntToStrZero( round(ValorAbatimento * 100), 15)      + //Valor do Abatimento 181 195 13 2 Num G045
//
//        PadRight(IfThen(SeuNumero <> '',SeuNumero,NumeroDocumento), 25, ' ')                + //Identifica��o do T�tulo na Empresa 196 220 25 - Alfa G072
//
//        IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0), ACodProtesto, '3')            + //C�digo para Protesto 221 221 1 - Num C026
//
//        IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0),
//                        PadLeft(IntToStr(DiasDeProtesto), 2, '0'), '00')                   + //N�mero de Dias para Protesto 222 223 2 - Num C027
//
//        IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '2')                    + //C�digo para Baixa/Devolu��o 224 224 1 - Num C028
//
//        IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento),PadLeft(IntToStr(DaysBetween(DataBaixa, Vencimento)), 3, '0'), '000') + //N�mero de Dias para Baixa/Devolu��o 225 227 3 - Alfa C029
//        '09'                                                + //C�digo da Moeda 228 229 2 - Num *G065   '09' = Real
//        PadRight('', 10 , '0')                              + //N� do Contrato da Opera��o de Cr�d. 230 239 10 - Num C030
//        ' ');                                                 //240 - Uso exclusivo FEBRABAN/CNAB
//
//      {SEGMENTO Q}
//      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3) + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
//        '0001'                                              + //Lote Lote de Servi�o 4 7 4 - Num *G002
//        '3'                                                 + //Tipo de Registro 8 8 1 - Num �3� *G003
//        IntToStrZero(Fsequencia+ 2 ,5)                      + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
//        'Q'                                                 + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �Q� *G039
//        ' '                                                 + //Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
//        ATipoOcorrencia                                     + //C�digo de Movimento Remessa 16 17 2 - Num *C004
//
//        {Dados do sacado}
//        IfThen(Sacado.Pessoa = pJuridica,'2','1')           + //Tipo Tipo de Inscri��o 18 18 1 - Num *G005
//        PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')        + //N�mero N�mero de Inscri��o 19 33 15 - Num *G006
//        PadRight(Sacado.NomeSacado, 40, ' ')                + //Nome 34 73 40 - Alfa G013
//        PadRight(Sacado.Logradouro + ' ' + Sacado.Numero +' ' + Sacado.Complemento , 40, ' ') + //Endere�o 74 113 40 - Alfa G032
//        PadRight(Sacado.Bairro, 15, ' ')                    + //Bairro 114 128 15 - Alfa G032
//        PadLeft(copy(OnlyNumber(ACBrTitulo.Sacado.CEP),0,5), 5, '0')                     + //CEP 129 133 5 - Num G034
//        PadRight(copy(OnlyNumber(ACBrTitulo.Sacado.CEP),length(OnlyNumber(ACBrTitulo.Sacado.CEP))-2,3), 3, ' ')       + //Sufixo do CEP 134 136 3 - Num G035
//        PadRight(Sacado.Cidade, 15, ' ')                    + // Cidade 137 151 15 - Alfa G033
//        PadRight(Sacado.UF, 2, ' ')                         + //Unidade da Federa��o 152 153 2 - Alfa G036
//        {Dados do sacador/avalista}
//        '0'                                                 + // 154 a 154 - Tipo de Inscri��o 154 154 1 - Num *G005
//        PadRight('', 15, '0')                               + // N�mero de Inscri��o 155 169 15 - Num *G006
//        PadRight('', 40, ' ')                               + // Nome do Pagadorr/Avalista 170 209 40 - Alfa G013
//        PadRight('0', 3, '0')                               + // C�d. Bco. Corresp. na Compensa��o 210 212 3 - Num *C031
//        PadRight('',20, ' ')                                + // Nosso N� no Banco Correspondente 213 232 20 - Alfa *C032
//        PadRight('', 8, ' '));                                 // FEBRABAN/CNAB 233 240 8 - Alfa Brancos G004
//
//    {SEGMENTO R OPCIONAL }
//      ListTransacao.Add(IntToStrZero(ACBrBanco.Numero, 3)    + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
//        '0001'                                               + //Lote de Servi�o 4 7 4 - Num *G002
//        '3'                                                  + //Tipo de Registro 8 8 1 - Num �3� *G003
//        IntToStrZero(Fsequencia+ 3 ,5)                       + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
//        'R'                                                  + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �R� *G039
//        ' '                                                  + //CNAB Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
//        ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
//        PadLeft('', 1,  '0')                                 + //C�digo do Desconto 2 18 18 1 - Num *C021
//        PadLeft('', 8,  '0')                                 + //Data do Desconto 2 19 26 8 - Num C022
//        PadLeft('', 15, '0')                                 + //Valor/Percentual a ser Concedido 27 41 13 2 Num C023
//        PadLeft('', 1,  '0')                                 + //C�digo do Desconto 3 42 42 1 - Num *C021
//        PadLeft('', 8,  '0')                                 + //Data do Desconto 3 43 50 8 - Num C022
//        PadLeft('', 15, '0')                                 + //Valor/Percentual a Ser Concedido 51 65 13 2 Num C023
//        ACodigoMulta                                         + //C�digo da Multa 66 66 1 - Alfa G073
//        ADataMulta                                           + //Data da Multa 67 74 8 - Num G074
//        IfThen(PercentualMulta > 0,
//          IntToStrZero(round(PercentualMulta * 100), 15),
//        PadRight('', 15, '0'))                               + //Multa Valor/Percentual a Ser Aplicado 75 89 13 2 Num G075
//        PadRight('', 10, ' ')                                + //Informa��o ao Pagador Informa��o ao Pagador 90 99 10 - Alfa *C036
//        PadRight('', 40, ' ')                                + //Informa��o 3 Mensagem 3 100 139 40 - Alfa *C037
//        PadRight('', 40, ' ')                                + //Mensagem 4 140 179 40 - Alfa *C037
//        PadRight('', 20, ' ')                                + //CNAB Uso Exclusivo FEBRABAN/CNAB 180 199 20 - Alfa Brancos G004
//        PadLeft('', 8, '0')                                  +//C�d. Ocor. do Pagador 200 207 8 - Num *C038
//        PadLeft('', 3, '0')                                  +//C�d. do Banco na Conta do D�bito 208 210 3 - Num G001
//        PadLeft('', 5, '0')                                  +//C�digo da Ag�ncia do D�bito 211 215 5 - Num *G008
//        PadLeft('', 1, ' ')                                  +//D�gito Verificador da Ag�ncia 216 216 1 - Alfa *G009
//        PadLeft('', 12, '0')                                 +//Corrente para D�bito 217 228 12 - Num *G010
//        PadLeft('', 1, ' ')                                  +//D�gito Verificador da Conta 229 229 1 - Alfa *G011
//        PadLeft('', 1, ' ')                                  +//DV D�gito Verificador Ag/Conta 230 230 1 - Alfa *G012
//        PadLeft('', 1, '3')                                  +//Ident. da Emiss�o do Aviso D�b. Aviso para D�bito Autom�tico 231 231 1 - Num *C039
//        PadLeft('',9, ' '));                                  //CNAB Uso Exclusivo FEBRABAN/CNAB 232 240 9 - Alfa Brancos G004
//
//    end;
//    Result := RemoverQuebraLinhaFinal(ListTransacao.Text);
//  finally
//    ListTransacao.Free;
//  end;
//end;
//ok
procedure TACBrBancoC6.GerarRegistroHeader400(NumeroRemessa: Integer;
  ARemessa: TStringList);
var
  wLinha: String;
begin
  //ErroAbstract('GerarRemessa400');

  with ACBrBanco.ACBrBoleto.Cedente do
  begin
    wLinha:= '0'                                                +  // 001 a 001 - Tipo de Registro
             '1'                                                +  // 002 a 002 - C�digo Remessa
             'REMESSA'                                          +  // 003 a 009 - Literal Remessa
             '01'                                               +  // 010 a 011 - C�digo Servi�o
             PadRight('COBRANCA', 8)                            +  // 012 a 019 - Literal Cobranca
             Space(7)                                           +  // 020 a 026 - Uso do Banco
             PadLeft(CodigoCedente, 12, '0')                    +  // 027 a 038 - C�digo do Cedente
             Space(8)                                           +  // 039 a 046 - Uso do Banco
             PadRight(Nome, 30)                                 +  // 047 a 076 - Nome da Empresa
             IntToStrZero(fpNumero, 3)                          +  // 077 a 079 - C�digo do Banco
             Space(15)                                          +  // 080 a 094 - Uso do Banco
             FormatDateTime('ddmmyy',Now)                       +  // 095 a 100 - Data de Grava��o
             Space(8)                                           +  // 101 a 108 - Uso do Banco
             PadLeft(Conta, 12, '0')                            +  // 109 a 120 - Conta Cobran�a Direta
             Space(266)                                         +  // 121 a 386 - Uso do Banco
             IntToStrZero(NumeroRemessa, 8)                     +  // 387 a 394 - Sequecial de Remessa
             IntToStrZero(1, 6);                                   // 395 a 400 - Sequencial

    ARemessa.Add(UpperCase(wLinha));
  end;
end;
//ok
procedure TACBrBancoC6.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  aPercMulta: Double;
  sOcorrencia, sEspecie{, aAgencia}: String;
  sProtesto, sTipoSacado{, MensagemCedente, aConta, aDigitoConta}: String;
  {aCarteira,} wLinha, {sNossoNumero,} sDigitoNossoNumero{, sTipoBoleto}: String;
begin
   with ACBrTitulo do begin
//     ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);
      sDigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);
//     aAgencia := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia),0),5);
//     aConta   := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta),0),7);
//     aCarteira:= IntToStrZero(StrToIntDef(trim(Carteira),0), 3);
//     aDigitoConta := PadLeft(trim(ACBrBoleto.Cedente.ContaDigito),1,'0');

     {C�digo da Ocorrencia}
     sOcorrencia:= TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo);

     {Tipo de Boleto}
//     sTipoBoleto:= DefineTipoBoleto(ACBrTitulo);

     {Especie}
     sEspecie:= DefineEspecieDoc(ACBrTitulo);

     {Intru��es}
     sProtesto:= InstrucoesProtesto(ACBrTitulo);

     {Tipo de Sacado}
     sTipoSacado := DefineTipoSacado(ACBrTitulo);

     { Converte valor em moeda para percentual, pois o arquivo s� permite % }
     aPercMulta := ConverterMultaPercentual(ACBrTitulo);

     with ACBrBoleto do begin
//       if Mensagem.Text <> '' then
//          MensagemCedente:= Mensagem[0];

       wLinha:= '1'                                             +  // 001 a 001 - ID Registro
       //Cedente.TipoInscricao                             +  // 002 a 003 - Tipo Inscri��o Empresa
       '0' + DefineTipoInscricao                                +  // 002 a 003 - Tipo Inscri��o Empresa
       //Cedente.CNPJCPF                                   +  // 004 a 017 - CNPJ Empresa
       PadLeft(OnlyNumber(Cedente.CNPJCPF), 14, '0')            +  // 004 a 017 - CNPJ Empresa
       //Cedente.Conta                                     +  // 018 a 029 - C�digo da Empresa
//       IntToStrZero(StrToIntDef(OnlyNumber(Cedente.Conta),0),7) +  // 018 a 029 - C�digo da Empresa
       PadRight(Cedente.Conta, 12)                              +  // 018 a 029 - C�digo da Empresa
       Space(8)                                                 +  // 030 a 037 - Uso do Banco
       //SeuNumero                                         +  // 038 a 062 - Uso da Empresa
//       PadRight(SeuNumero, 25)                                  +  // 038 a 062 - Uso da Empresa
       PadRight(NumeroDocumento, 25)                            +  // 038 a 062 - Uso da Empresa
       '0' + NossoNumero + sDigitoNossoNumero                   +  // 063 a 074 - Nosso N�mero Completo
//       PadRight(NossoNumero, 12)                                +  // 063 a 074 - Nosso N�mero Completo
       Space(8)                                                 +  // 075 a 082 - Uso do Banco
       IntToStrZero(fpNumero, 3)                                +  // 083 a 085 - C�digo do Banco
       Space(21)                                                +  // 086 a 106 - Uso do Banco
       //Carteira                                          +  // 107 a 108 - C�digo da Carteira
//       IntToStrZero(StrToIntDef(OnlyNumber(Carteira),0), 2)     +  // 107 a 108 - C�digo da Carteira
       PadLeft(Carteira, 2, '0')                                +  // 107 a 108 - C�digo da Carteira
       sOcorrencia                                              +  // 109 a 110 - C�digo Ocorr�ncia Remessa
       //NumeroDocumento                                   +  // 111 a 120 - Seu N�mero
//       PadRight(NumeroDocumento, 10)                            +  // 111 a 120 - Seu N�mero
       PadRight(SeuNumero, 10)                                  +  // 111 a 120 - Seu N�mero
       FormatDateTime('ddmmyy', Vencimento)                     +  // 121 a 126 - Data Vencimento
       IntToStrZero(Round(ValorDocumento * 100 ), 13)           +  // 127 a 139 - Valo Titulo
       Space(8)                                                 +  // 140 a 147 - Uso do Banco
       sEspecie                                                 +  // 148 a 149 - Esp�cie do T�tulo
       'N'                                                      +  // 150 a 150 - Aceite
       FormatDateTime('ddmmyy', DataDocumento)                  +  // 151 a 156 - Data Emiss�o T�tulo
       sProtesto                                                +  // 157 a 160 - Intru��o 1 e 2
       IntToStrZero(Round(ValorMoraJuros * 100 ), 13)           +  // 161 a 173 - Juros ao Dia
       IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
              FormatDateTime('ddmmyy', DataDesconto))           +  // 174 a 179 - Data Desconto
       IntToStrZero(Round(ValorDesconto * 100 ), 13)            +  // 180 a 192 - Valor Desconto
       IfThen(DataMulta < EncodeDate(2000,01,01),'000000',
              FormatDateTime('ddmmyy', DataMulta))              +  // 193 a 198 - Data Multa
       Space(7)                                                 +  // 199 a 205 - Uso do Banco
       IntToStrZero(Round(ValorAbatimento * 100 ), 13)          +  // 206 a 218 - Valor Abatimento
       sTipoSacado                                              +  // 219 a 220 - Tipo Sacado
       PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')             +  // 221 a 234 - CNPJ/CPF Sacado
       PadRight(Sacado.NomeSacado, 40)                          +  // 235 a 274 - Nome do Sacado
       PadRight(Sacado.Logradouro + ' ' +
                Sacado.Numero + ' '  + Sacado.Complemento, 40)  +  // 275 a 314 - Endere�o Sacado
       PadRight(Sacado.Bairro, 12)                              +  // 315 a 326 - Bairro Sacado
       PadRight(Sacado.CEP, 8)                                  +  // 327 a 334 - CEP Sacado
       PadRight(Sacado.Cidade, 15)                              +  // 335 a 349 - Cidade Sacado
       PadRight(Sacado.UF, 2)                                   +  // 350 a 351 - UF Sacado
       Space(30)                                                +  // 352 a 381 - Sacador / Mensagem / C�digo CMC7
       IfThen(PercentualMulta > 0, '2', '0')                    +  // 382 a 382 - Tipo de Multa
//       IntToStrZero(Round(aPercMulta * 100), 2)                 +  // 383 a 384 - Percentual de Multa
       IntToStrZero(Round(aPercMulta), 2)                       +  // 383 a 384 - Percentual de Multa
       Space(1)                                                 +  // 385 a 385 - Uso do Banco
       IfThen(DataMoraJuros < EncodeDate(2000,01,01),'000000',
              FormatDateTime('ddmmyy', DataMoraJuros))          +  // 386 a 391 - Data Juros Mora
       PadLeft(IntToStr(DiasDeProtesto), 2, '0')                +  // 392 a 393 - Prazo dias para Cart�rio
       Space(1)                                                 +  // 394 a 394 - Uso do Banco
       IntToStrZero(aRemessa.Count + 1, 6);                        // 395 a 400 - Seq�encial
       // 401 a 710 - Campos opcionais

       aRemessa.Add(UpperCase(wLinha));
       wLinha := MontaInstrucoesCNAB400(ACBrTitulo, aRemessa.Count);

       if not(wLinha = EmptyStr) then
         aRemessa.Add(UpperCase(wLinha));
      end;
   end;
end;

function TACBrBancoC6.MontaInstrucoesCNAB400(const ACBrTitulo: TACBrTitulo;
  const nRegistro: Integer): String;
begin
   Result := '';

   with ACBrTitulo, ACBrBoleto do begin

      {Primeira instru��o vai no registro 1}
      if Mensagem.Count <= 1 then begin
         Result := '';
         Exit;
      end;

      Result := '2'               +                                         // IDENTIFICA��O DO LAYOUT PARA O REGISTRO
                Copy(PadRight(Mensagem[1], 80, ' '), 1, 80);                // CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

      if Mensagem.Count >= 3 then
         Result := Result +
                   Copy(PadRight(Mensagem[2], 80, ' '), 1, 80)              // CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
      else
         Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

      if Mensagem.Count >= 4 then
         Result := Result +
                   Copy(PadRight(Mensagem[3], 80, ' '), 1, 80)              // CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
      else
         Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

      if Mensagem.Count >= 5 then
         Result := Result +
                   Copy(PadRight(Mensagem[4], 80, ' '), 1, 80)              // CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
      else
         Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS


     Result := Result                                           +
               Space(44)                                        +  // 322 a 365 - Uso do Banco
               PadRight(SeuNumero, 10)                          +  // 366 a 375 - Seu N�mero
               FormatDateTime('ddmmyy', Vencimento)             +  // 376 a 381 - Data Vencimento
               IntToStrZero(Round(ValorDocumento * 100 ), 13)   +  // 382 a 394 - Valo Titulo
               IntToStrZero(nRegistro + 1, 6);                     // 395 a 400 - Seq�encial
  end;
end;

//ok
function TACBrBancoC6.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOcorrenciaToCod(TipoOcorrencia),0);

//  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
//  begin
//    case CodOcorrencia of
//      04: Result := '04-Transfer�ncia de Carteira/Entrada';
//      05: Result := '05-Transfer�ncia de Carteira/Baixa';
//      07: Result := '07-Confirma��o do Recebimento da Instru��o de Desconto';
//      08: Result := '08-Confirma��o do Recebimento do Cancelamento do Desconto';
//      15: Result := '15-Franco de Pagamento';
//      24: Result := '24-Retirada de Cart�rio e Manuten��o em Carteira';
//      25: Result := '25-Protestado e Baixado';
//      26: Result := '26-Instru��o Rejeitada';
//      27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
//      33: Result := '33-Confirma��o da Altera��o dos Dados do Rateio de Cr�dito';
//      34: Result := '34-Confirma��o do Cancelamento dos Dados do Rateio de Cr�dito';
//      36: Result := '36-Confirma��o de Envio de E-mail/SMS';
//      37: Result := '37-Envio de E-mail/SMS Rejeitado';
//      38: Result := '38-Confirma��o de Altera��o do Prazo Limite de Recebimento';
//      39: Result := '39-Confirma��o de Dispensa de Prazo Limite de Recebimento';
//      40: Result := '40-Confirma��o da Altera��o do N�mero do T�tulo Dado pelo Beneficiario';
//      41: Result := '41-Confirma��o da Altera��o do N�mero Controle do Participante';
//      42: Result := '42-Confirma��o da Altera��o dos Dados do Pagador';
//      43: Result := '43-Confirma��o da Altera��o dos Dados do Sacador/Avalista';
//      44: Result := '44-T�tulo Pago com Cheque Devolvido';
//      45: Result := '45-T�tulo Pago com Cheque Compensado';
//      46: Result := '46-Instru��o para Cancelar Protesto Confirmada';
//      47: Result := '47-Instru��o para Protesto para Fins Falimentares Confirmada';
//      48: Result := '48-Confirma��o de Instru��o de Transfer�ncia de Carteira/Modalidade de Cobran�a';
//      49: Result := '49-Altera��o de Contrato de Cobran�a';
//      50: Result := '50-T�tulo Pago com Cheque Pendente de Liquida��o';
//      51: Result := '51-T�tulo DDA Reconhecido pelo Pagador';
//      52: Result := '52-T�tulo DDA n�o Reconhecido pelo Pagador';
//      53: Result := '53-T�tulo DDA recusado pela CIP';
//      54: Result := '54-Confirma��o da Instru��o de Baixa de T�tulo Negativado sem Protesto';
//    end;
//  end
//  else
//  begin
    case CodOcorrencia of
      04: Result := '04-Altera��o de Dados (Entrada)';
      05: Result := '05-Altera��o de Dados (Baixa)';
      07: Result := '07-Liquida��o ap�s Baixa';
      08: Result := '08-Liquida��o em Cart�rio';
      10: Result := '10-Baixa comandada do cliente arquivo';
      15: Result := '15-Baixa rejeitada';
      16: Result := '16-Instru��o rejeitada';
      //18: Result := '18-Acerto de Deposit�ria';
      21: Result := '21-Confirma instru��o de n�o protestar';
      //22: Result := '22-Titulo com Pagamento Cancelado';
      //24: Result := '24-Entrada Rejeitada por CEP Irregular';
      //25: Result := '25-Confirma��o Recebimento Instru��o de Protesto Falimentar';
      //27: Result := '27-Baixa Rejeitada';
      32: Result := '32-Baixa por ter sido protestado';
      //33: Result := '33-Confirma��o Pedido Altera��o Outros Dados';
      //34: Result := '34-Retirado de Cart�rio e Manuten��o Carteira';
      36: Result := '36-Custas de Edital';
      37: Result := '37-Custas de susta��o judicial';
      38: Result := '38-T�tulo sustado judicialmente';
      //40: Result := '40-Estorno de Pagamento';
      //55: Result := '55-Sustado Judicial';
      65: Result := '65-Pagamento com Cheque - Aguardando compensa��o';
      //68: Result := '68-Acerto dos Dados do Rateio de Cr�dito';
      69: Result := '69-Cancelamento de Liquida��o por Cheque Devolvido';
      71: Result := '71-Protesto cancelado pelo Cart�rio';
//p      72: Result := '72-Baixa Operacional';
//p      74: Result := '74-Cancelamento da Baixa Operacional';
      75: Result := '75-Pagamento Parcial';
      90: Result := '90-Instru��o de Protesto Rejeitada';
      95: Result := '95-Troca Uso Empresa';
      96: Result := '96-Emiss�o Extrato Mov. Carteira';
      97: Result := '97-Tarifa de susta��o de protesto';
      98: Result := '98-Tarifa de protesto';
      99: Result := '99-Custas de protesto';
    end;
//  end;

  if (Result <> '') then
    Exit;

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquida��o Normal';
    09: Result := '09-Baixa Simples';
    //11: Result := '11-Em Ser - Arquivo de T�tulos Pendentes';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    17: Result := '17-Altera��es de dados rejeitados';
    19: Result := '19-Confirma instru��o de protesto';
    20: Result := '20-Confirma instru�o de susta��o de protesto';
    23: Result := '23-Protesto enviado a cart�rio';
    //28: Result := '28-D�bito de tarifas/custas';
//p    29: Result := '29-Sacado n�o retirou boleto eletronicamente';
    //30: Result := '30-Altera��o de Outros Dados Rejeitados';
    35: Result := '35-Alega��es do sacado';
    //73: Result := '73-Confirma��o Recebimento Pedido de Negativa��o';
  end;
end;
//ok
function TACBrBancoC6.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;

//  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
//  begin
//    case CodOcorrencia of
//      04: Result := toRetornoTransferenciaCarteiraEntrada;
//      05: Result := toRetornoTransferenciaCarteiraBaixa;
//      07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
//      08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
//      15: Result := toRetornoBaixadoFrancoPagamento;
//      24: Result := toRetornoRetiradoDeCartorio;
//      25: Result := toRetornoBaixaPorProtesto;
//      26: Result := toRetornoComandoRecusado;
//      27: Result := toRetornoRecebimentoInstrucaoAlterarDados;
//      33: Result := toRetornoAcertoDadosRateioCredito;
//      34: Result := toRetornoCancelamentoDadosRateio;
//      36: Result := toRetornoConfirmacaoEmailSMS;
//      37: Result := toRetornoEmailSMSRejeitado;
//      38: Result := toRetornoAlterarPrazoLimiteRecebimento;
//      39: Result := toRetornoDispensarPrazoLimiteRecebimento;
//      40: Result := toRetornoAlteracaoSeuNumero;
//      41: Result := toRetornoAcertoControleParticipante;
//      42: Result := toRetornoRecebimentoInstrucaoAlterarNomeSacado;
//      43: Result := toRetornoAlterarSacadorAvalista;
//      44: Result := toRetornoChequeDevolvido;
//      45: Result := toRetornoChequeCompensado;
//      46: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
//      47: Result := toRetornoProtestoImediatoFalencia;
//      48: Result := toRemessaTransferenciaCarteira;
//      49: Result := toRetornoTipoCobrancaAlterado;
//      50: Result := toRetornoChequePendenteCompensacao;
//      51: Result := toRetornoTituloDDAReconhecidoPagador;
//      52: Result := toRetornoTituloDDANaoReconhecidoPagador;
//      53: Result := toRetornoTituloDDARecusadoCIP;
//      54: Result := toRetornoBaixaTituloNegativadoSemProtesto;
//    end;
//  end
//  else
//  begin
    case CodOcorrencia of
      04: Result := toRetornoAlteracaoDadosNovaEntrada;
      05: Result := toRetornoAlteracaoDadosBaixa;
      07: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
      08: Result := toRetornoLiquidadoEmCartorio;
      10: Result := toRetornoBaixadoViaArquivo; //toRetornoBaixadoInstAgencia;
      15: Result := toRetornoBaixaRejeitada; //toRetornoLiquidadoEmCartorio;
      16: Result := toRetornoInstrucaoRejeitada; //toRetornoTituloPagoEmCheque;
      //18: Result := toRetornoAcertoDepositaria;
      21: Result := toRetornoRecebimentoInstrucaoNaoProtestar; //toRetornoAcertoControleParticipante;
      //22: Result := toRetornoTituloPagamentoCancelado;
      //24: Result := toRetornoEntradaRejeitaCEPIrregular;
      //25: Result := toRetornoProtestoImediatoFalencia;
      //27: Result := toRetornoBaixaRejeitada;
      32: Result := toRetornoBaixaPorProtesto; //toRetornoComandoRecusado;
      //33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
      //34: Result := toRetornoRetiradoDeCartorio;
      36: Result := toRetornoCustasEdital;
      37: Result := toRetornoCustasSustacaoJudicial;
      38: Result := toRetornoTituloSustadoJudicialmente;
      //40: Result := toRetornoEstornoPagamento;
      //55: Result := toRetornoTituloSustadoJudicialmente;
      65: Result := toRetornoChequePendenteCompensacao;
      //68: Result := toRetornoAcertoDadosRateioCredito;
      69: Result := toRetornoChequeDevolvido; //toRetornoCancelamentoDadosRateio;
      71: Result := toRetornoDevolvidoPeloCartorio;
//p      72: Result :=
//p      74: Result :=  //toRetornoConfirmacaoPedidoExclNegativacao;
      75: Result := toRetornoLiquidadoParcialmente;
      90: Result := toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente;
      95: Result := toRetornoAlteracaoUsoCedente;
      96: Result := toRetornoTarifaExtratoPosicao;
      97: Result := toRetornoDespesasSustacaoProtesto;
      98: Result := toRetornoDespesasProtesto;
      99: Result := toRetornoCustasProtesto;
    end;
//  end;

  if (Result <> toTipoOcorrenciaNenhum) then
    Exit;

  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixaSimples;//toRetornoBaixadoViaArquivo;
    //11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    17: Result := toRetornoAlteracaoDadosRejeitados;//toRetornoLiquidadoAposBaixaouNaoRegistro;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    23: Result := toRetornoEncaminhadoACartorio;
    //28: Result := toRetornoDebitoTarifas;
//p    29: Result :=  //toRetornoOcorrenciasdoSacado;
    //30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    35: Result := toRetornoAlegacaoDoSacado;//toRetornoDesagendamentoDebitoAutomatico;
    //73: Result := toRetornoConfirmacaoRecebPedidoNegativacao;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;
//ok
function TACBrBancoC6.TipoOcorrenciaToCod(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  Result := '';

//  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
//  begin
//    case TipoOcorrencia of
//      toRetornoTransferenciaCarteiraEntrada                 : Result := '04';
//      toRetornoTransferenciaCarteiraBaixa                   : Result := '05';
//      toRetornoRecebimentoInstrucaoConcederDesconto         : Result := '07';
//      toRetornoRecebimentoInstrucaoCancelarDesconto         : Result := '08';
//      toRetornoBaixadoFrancoPagamento                       : Result := '15';
//      toRetornoRetiradoDeCartorio                           : Result := '24';
//      toRetornoBaixaPorProtesto                             : Result := '25';
//      toRetornoComandoRecusado                              : Result := '26';
//      toRetornoRecebimentoInstrucaoAlterarDados             : Result := '27';
//      toRetornoAcertoDadosRateioCredito                     : Result := '33';
//      toRetornoCancelamentoDadosRateio                      : Result := '34';
//      toRetornoConfirmacaoEmailSMS                          : Result := '36';
//      toRetornoEmailSMSRejeitado                            : Result := '37';
//      toRetornoAlterarPrazoLimiteRecebimento                : Result := '38';
//      toRetornoDispensarPrazoLimiteRecebimento              : Result := '39';
//      toRetornoAlteracaoSeuNumero                           : Result := '40';
//      toRetornoAcertoControleParticipante                   : Result := '41';
//      toRetornoRecebimentoInstrucaoAlterarNomeSacado        : Result := '42';
//      toRetornoAlterarSacadorAvalista                       : Result := '43';
//      toRetornoChequeDevolvido                              : Result := '44';
//      toRetornoChequeCompensado                             : Result := '45';
//      toRetornoRecebimentoInstrucaoSustarProtesto           : Result := '46';
//      toRetornoProtestoImediatoFalencia                     : Result := '47';
//      toRemessaTransferenciaCarteira                        : Result := '48';
//      toRetornoTipoCobrancaAlterado                         : Result := '49';
//      toRetornoChequePendenteCompensacao                    : Result := '50';
//      toRetornoTituloDDAReconhecidoPagador                  : Result := '51';
//      toRetornoTituloDDANaoReconhecidoPagador               : Result := '52';
//      toRetornoTituloDDARecusadoCIP                         : Result := '53';
//      toRetornoBaixaTituloNegativadoSemProtesto             : Result := '54';
//    end;
//  end
//  else
//  begin
    case TipoOcorrencia of
      toRetornoAlteracaoDadosNovaEntrada                    : Result := '04';
      toRetornoAlteracaoDadosBaixa                          : Result := '05';
      toRetornoLiquidadoAposBaixaOuNaoRegistro              : Result := '07';
      toRetornoLiquidadoEmCartorio                          : Result := '08';
      toRetornoBaixadoViaArquivo                            : Result := '10';
      toRetornoBaixaRejeitada                               : Result := '15';
      toRetornoInstrucaoRejeitada                           : Result := '16';
      //toRetornoAcertoDepositaria                            : Result := '18';
      toRetornoRecebimentoInstrucaoNaoProtestar             : Result := '21';
      //toRetornoTituloPagamentoCancelado                     : Result := '22';
      //toRetornoEntradaRejeitaCEPIrregular                   : Result := '24';
      //toRetornoProtestoImediatoFalencia                     : Result := '25';
      //toRetornoBaixaRejeitada                               : Result := '27';
      toRetornoBaixaPorProtesto                             : Result := '32';
      //toRetornoRecebimentoInstrucaoAlterarDados             : Result := '33';
      //toRetornoRetiradoDeCartorio                           : Result := '34';
      toRetornoCustasEdital                                 : Result := '36';
      toRetornoCustasSustacaoJudicial                       : Result := '37';
      toRetornoTituloSustadoJudicialmente                   : Result := '38';
      //toRetornoEstornoPagamento                             : Result := '40';
      //toRetornoTituloSustadoJudicialmente                   : Result := '55';
      toRetornoChequePendenteCompensacao                    : Result := '65';
      //toRetornoAcertoDadosRateioCredito                     : Result := '68';
      toRetornoChequeDevolvido                              : Result := '69';
      toRetornoDevolvidoPeloCartorio                        : Result := '71';
//p      : Result := '72';
//p      toRetornoConfirmacaoPedidoExclNegativacao             : Result := '74';
      toRetornoLiquidadoParcialmente                        : Result := '75';
      toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente  : Result := '90';
      toRetornoAlteracaoUsoCedente                          : Result := '95';
      toRetornoTarifaExtratoPosicao                         : Result := '96';
      toRetornoDespesasSustacaoProtesto                     : Result := '97';
      toRetornoDespesasProtesto                             : Result := '98';
      toRetornoCustasProtesto                               : Result := '99';
    end;
//  end;

  if (Result <> '') then
    Exit;

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                             : Result := '02';
    toRetornoRegistroRecusado                               : Result := '03';
    toRetornoLiquidado                                      : Result := '06';
    toRetornoBaixaSimples                                   : Result := '09';
    //toRetornoTituloEmSer                                    : Result := '11';
    toRetornoAbatimentoConcedido                            : Result := '12';
    toRetornoAbatimentoCancelado                            : Result := '13';
    toRetornoVencimentoAlterado                             : Result := '14';
    toRetornoAlteracaoDadosRejeitados                       : Result := '17';
    toRetornoRecebimentoInstrucaoProtestar                  : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto             : Result := '20';
    toRetornoEncaminhadoACartorio                           : Result := '23';
    //toRetornoDebitoTarifas                                  : Result := '28';
//p    toRetornoOcorrenciasdoSacado                            : Result := '29';
    //toRetornoAlteracaoOutrosDadosRejeitada                  : Result := '30';
    toRetornoAlegacaoDoSacado                               : Result := '35';
    //toRetornoConfirmacaoRecebPedidoNegativacao              : Result := '73';
  else
    Result := '02';
  end;
end;
//ok
function TACBrBancoC6.CodMotivoRejeicaoToDescricao(
  const TipoOcorrencia: TACBrTipoOcorrencia; CodMotivo: Integer): String;
begin
   case TipoOcorrencia of
      toRetornoRegistroRecusado: //03
      case CodMotivo  of
         9000: Result := '9000-Data vencimento menor que o prazo de aceita��o do t�tulo';
         9001: Result := '9001-Sacado bloqueado por atraso';
         9002: Result := '9002-Registro opcional inv�lido';
         9003: Result := '9003-Cep sem pra�a de cobran�a';
         9004: Result := '9004-Prazo insuficiente para cobran�a do t�tulo';
         9005: Result := '9005-Campo num�rico inv�lido';
         9006: Result := '9006-Campo texto inv�lido';
         9007: Result := '9007-Campo tipo data inv�lido';
         9008: Result := '9008-Caractere inv�lido';
         9009: Result := '9009-Cpf/Cnpj do sacado e emitente devem ser diferentes';
         9010: Result := '9010-Data vencimento menor que a data de emiss�o';
         9011: Result := '9011-Data emiss�o maior que a data atual';
         9012: Result := '9012-Uf sacado inv�lido';
         9013: Result := '9013-Uf emitente inv�lido';
         9014: Result := '9014-Campo obrigat�rio n�o preenchido';
         9015: Result := '9015-Cpf do sacado inv�lido';
         9016: Result := '9016-Cnpj do sacado inv�lido';
         9017: Result := '9017-O nome do sacado enviado n�o confere com o nome do sacado cadastrado no sistema para este Cnpj/Cpf';
         9018: Result := '9018-Tipo do sacado inv�lido';
         9019: Result := '9019-O sacado est� bloqueado';
         9020: Result := '9020-O endere�o do sacado esta com o tamanho esta maior que o permitido';
         9021: Result := '9021-Digito do nosso numero inv�lido';
         9022: Result := '9022-N�o existe faixa cadastrada para o banco e a conta';
         9023: Result := '9023-O nosso numero esta fora da faixa cadastrada para o cedente';
         9081: Result := '9081-Prazo insuficiente para cobran�a do t�tulo neste Cep';
         9084: Result := '9084-Seu n�mero do registro opcional diferente da linha do registro do t�tulo';
         9085: Result := '9085-Data de vencimento do registro opcional diferente da linha do registro do t�tulo';
         9086: Result := '9086-Valor do t�tulo no vencimento do registro opcional diferente da linha do registro do t�tulo';
         9087: Result := '9087-Os t�tulos de carteira de cobran�a direta s� podem ser enviados para contas de cobrna�a direta. acao: confira a carteira e a conta cobran�a que est� sendo enviada/atribuida ao t�tulo';
         9089: Result := '9089-C�digo cmc7 invalido';
         9090: Result := '9090-Entrada - nosso n�mero j� est� sendo utilizado para mesmo banco/conta';
         9091: Result := '9091-Cep do sacado n�o pertence ao estado da federa��o (Uf) informado';
         9092: Result := '9092-Tipo de multa inv�lido';
         9093: Result := '9093-Registro opcional de emitente inv�lido';
         9097: Result := '9097-O campo Nosso N�mero n�o foi informado ou n�o foi possivel identificar o titulo';
         9098: Result := '9098-Foi encontrado mais de um t�tulo para esse nosso n�mero';
         9099: Result := '9099-Preencha o campo de "conta de cobran�a" no cadastro de carteira por cedente';
         9100: Result := '9100-T�tulo possui registro opcional de emitente e a sua configura��o n�o permite envio de t�tulos de terceiros';
         9101: Result := '9101-T�tulo possui emitente, por�m seus dados n�o foram informados';
         9103: Result := '9103-Ja existe titulo em aberto cadastrado para este cedente/seu numero/data vencimento/valor e emitente';
         9104: Result := '9104-Impedido pela legisla��o vigente';
         9106: Result := '9106-Nosso numero nao informado';
         9232: Result := '9232-Sacado pertence a empresa do grupo (coligada)';
         9233: Result := '9233-Por solicita��o da diretoria de cr�dito/comercial';
         9234: Result := '9234-Inexist�ncia de rela��o com o cedente';
         9235: Result := '9235-Outros';
         9236: Result := '9236-Recusado - Outros Motivos';
         9240: Result := '9240-Data multa menor que data de vencimento do t�tulo';
         9250: Result := '9250-Tipo de autoriza��o para recebimento de valor divergente inv�lido';
         9251: Result := '9251-Indicativo Tipo de valor ou percentual inv�lido';
         9252: Result := '9252-Quantidade de pagamento parcial inv�lido';
         9254: Result := '9254-M�nimo n�o aceito para o t�tulo';
         9255: Result := '9255-M�ximo n�o aceito para o t�tulo';
         9052: Result := '9052-Data de desconto 2 inv�lida';
         9230: Result := '9230-Valor desconto 2 inv�lido';
         9258: Result := '9258-Data de desconto 3 inv�lida';
         9259: Result := '9259-Valor desconto 3 inv�lido';
         9260: Result := '9260-M�nimo � obrigat�rio quando informado o tipo valor ou percentual';
         9261: Result := '9261-Tipo de autoriza��o de recebimento de valor divergente n�o permitio para tipo de t�tulo 31';
         9262: Result := '9262-Para especie de t�tulo diferente de fatura de cart�o de cr�dito n�o � poss�vel informar o tipo aceita qualquer valor com range m�nimo e m�ximo  preenchido';
         9263: Result := '9263-M�nimo e M�ximo tem que ser informado para o tipo de autoriza��o de valor divergente igual a 2';
         9264: Result := '9264-M�nimo e M�ximo n�o devem ser informados para o tipo de autoriza��o de valor divergente igual a 3';
         9265: Result := '9265-M�nimo deve ser informado e M�ximo n�o pode ser informado para o tipo de autoriza��o de valor divergente igual a 4';
         9266: Result := '9266-Valor n�o permitido para tipo de t�tulo fatura de cart�o de cr�dito';
         9267: Result := '9267-N�o � permitido ter juros, multa, abatimento, desconto ou protesto tipo de t�tulo fatura de cart�o de cr�dito';
         9999: Result := '9999-Cep do sacado inv�lido';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoLiquidado: //06
      case CodMotivo of
         9105: Result := '9105-Cr�dito retido';
         9210: Result := '9210-Liquida��o em cheque';
         9216: Result := '9216-Liquida��o no guich� de caixa em dinheiro';
         9217: Result := '9217-Liquida��o em banco correspondente';
         9218: Result := '9218-Liquida��o por compensa��o eletr�nica';
         9219: Result := '9219-Liquida��o por conta';
         9223: Result := '9223-Liquida��o por STR';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoLiquidadoEmCartorio: //08
      case CodMotivo of
         9201: Result:= '9201-Liquida��o em cart�rio';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoBaixaSimples: //09
      case CodMotivo of
         9202: Result:= '9202-Baixa decurso prazo - banco';
         9237: Result:= '9237-Baixa por outros motivos';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoBaixadoViaArquivo: //10
      case CodMotivo of
         0000: Result:= '0000-Baixa comandada cliente arquivo';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoAlteracaoDadosRejeitados: //17
      case CodMotivo of
         9104: Result:= '9104-Impedido pela legisla��o vigente';
         9113: Result:= '9113-N�o permitimos troca de carteira no evento de Altera��o de Outros Dados';
         9114: Result:= '9114-N�o permitimos troca de tipo titulo no evento de altera��o de outros dados';
         9250: Result:= '9250-Tipo de autoriza��o para recebimento de valor divergente inv�lido';
         9251: Result:= '9251-Indicativo Tipo de valor ou percentual inv�lido';
         9252: Result:= '9252-Quantidade de pagamento parcial inv�lido';
         9253: Result:= '9253-Quantidade de pagamento parcial inv�lido, somente � permitido um valor maior ou igual a quantidade de pagamentos j� recebido';
         9254: Result:= '9254-M�nimo n�o aceito para o t�tulo';
         9255: Result:= '9255-M�ximo n�o aceito para o t�tulo';
         9052: Result:= '9052-Data de desconto 2 inv�lida';
         9230: Result:= '9230-Valor desconto 2 inv�lido';
         9258: Result:= '9258-Data de desconto 3 inv�lida';
         9259: Result:= '9259-Valor desconto 3 inv�lido';
         9260: Result:= '9260-M�nimo � obrigat�rio quando informado o tipo valor ou percentual';
         9261: Result:= '9261-Tipo de autoriza��o de recebimento de valor divergente n�o permitio para tipo de t�tulo 31';
         9262: Result:= '9262-Para especie de t�tulo diferente de fatura de cart�o de cr�dito n�o � poss�vel informar o tipo aceita qualquer valor com range m�nimo e m�ximo  preenchido';
         9263: Result:= '9263-M�nimo e M�ximo tem que ser informado para o tipo de autoriza��o de valor divergente igual a 2';
         9264: Result:= '9264-M�nimo e M�ximo n�o devem ser informados para o tipo de autoriza��o de valor divergente igual a 3';
         9265: Result:= '9265-M�nimo deve ser informado e M�ximo n�o pode ser informado para o tipo de autoriza��o de valor divergente igual a 4';
         9266: Result:= '9266-Valor n�o permitido para tipo de t�tulo fatura de cart�o de cr�dito';
         9267: Result:= '9267-N�o � permitido ter juros, multa, abatimento, desconto ou protesto tipo de t�tulo fatura de cart�o de cr�dito';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
//p      : //29
//      case CodMotivo of
//         1818: Result:= '1818-Boleto n�o retirado pelo sacado. reenviado pelo correio para carteiras com emiss�o pelo banco';
//      else
//         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
//      end;
      toRetornoBaixaPorProtesto: //32
      case CodMotivo of
         9203: Result:= '9203-Baixa protestado';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoAlegacaoDoSacado: //35
      case CodMotivo of
         9238: Result:= '9238-Pagador Rejeita Boleto';
         9239: Result:= '9239-Pagador Aceita Boleto';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoCustasEdital: //36
      case CodMotivo of
         9207: Result:= '9207-Custas de edital';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoCustasSustacaoJudicial: //37
      case CodMotivo of
         9208 : Result:= '9208-Custas de susta��o de protesto';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoTituloSustadoJudicialmente: //38
      case CodMotivo of
         0000 : Result:= '0000-T�tulo sustado judicialmente';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
//p      : //72
//      case CodMotivo of
//         9242: Result:= '9242-Baixa integral interbanc�ria';
//         9243: Result:= '9243-Baixa integral intrabanc�ria';
//         9244: Result:= '9244-Baixa parcial intrabanc�ria';
//         9245: Result:= '9245-Baixa parcial interbanc�ria';
//      else
//         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
//      end;
      toRetornoLiquidadoParcialmente: //75
      case CodMotivo of
         9105: Result:= '9105-Cr�dito retido';
         9216: Result:= '9216-Liquida��o no guich� de caixa em dinheiro';
         9217: Result:= '9217-Liquida��o em banco correspondente';
         9218: Result:= '9218-Liquida��o por compensa��o eletr�nica';
         9219: Result:= '9219-Liquida��o por conta';
         9223: Result:= '9223-Liquida��o por STR';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoInstrucaoProtestoRejeitadaSustadaOuPendente: //90
      case CodMotivo of
         9108: Result:= '9108-T�tulo pertence a uma esp�cie que n�o pode ser protestada';
         9109: Result:= '9109-Protesto n�o permitido para t�tulo com moeda diferente de real';
         9110: Result:= '9110-Cep do sacado n�o atendido pelos cart�rios cadastrados';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoTarifaExtratoPosicao: //96
      case CodMotivo of
         9213: Result:= '9213-Tarifa de manuten��o de t�tulo vencido';
         9222: Result:= '9222-Emiss�o extrato mov. carteira';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoDespesasSustacaoProtesto: //97
      case CodMotivo of
         9204: Result:= '9204-Tarifa de sustacao de protesto';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoDespesasProtesto: //98
      case CodMotivo of
         9205: Result:= '9205-Tarifa de protesto';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoCustasProtesto: //99
      case CodMotivo of
         9206: Result:= '9206-Custas de protesto';
      else
         Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
   else
      Result:= '0000'; //IntToStrZero(CodMotivo,2) +' - Outros Motivos';
   end;

   if (Result = '0000') then begin
      case CodMotivo of
         9024: Result:= '9024-Identifica��o do t�tulo inv�lida';
         9025: Result:= '9025-Ocorr�ncia n�o permitida pois o t�tulo esta baixado';
         9026: Result:= '9026-Ocorr�ncia n�o permitida pois o t�tulo esta liquidado';
         9027: Result:= '9027-Ocorr�ncia n�o permitida pois o t�tulo esta em protesto';
         9028: Result:= '9028-N�o � permitida altera��o de vencimento para carteira de desconto';
         9029: Result:= '9029-Situa��o do t�tulo inv�lida';
         9030: Result:= '9030-N�o foi poss�vel conceder o abatimento';
         9031: Result:= '9031-N�o existe abatimento a ser cancelado';
         9032: Result:= '9032-N�o foi poss�vel prorrogar a data de vencimento do t�tulo';
         9033: Result:= '9033-Evento n�o permitido para situa��o do t�tulo';
         9034: Result:= '9034-Evento n�o permitido para cheques';
         9035: Result:= '9035-O c�digo do registro esta diferente de 1';
         9036: Result:= '9036-Ag�ncia inv�lida';
         9037: Result:= '9037-N�mero da Conta Corrente para dep�sito Inv�lido';
         9038: Result:= '9038-O Cnpj do cedente passado para o arquivo n�o confere com o Cnpj do cedente cadastrado para o arquivo';
         9040: Result:= '9040-Cnpj do cedente n�o encontrado no cadastro';
         9041: Result:= '9041-Tipo do emitente inv�lido';
         9042: Result:= '9042-Cnpj do emitente inv�lido';
         9045: Result:= '9045-Campo nosso numero deve ter um valor de, no m�ximo , 10 digitos quando a carteira de cobran�a n�o � direta';
         9046: Result:= '9046-No campo nosso n�mero a identifica��o do t�tulo esta inv�lida';
         9047: Result:= '9047-Banco e conta de cobran�a direta n�o informados';
         9049: Result:= '9049-Campo aceite enviado com valor nulo ou inv�lido';
         9050: Result:= '9050-Data de emis�o inv�lida';
         9051: Result:= '9051-Data de vencimento inv�lida';
         9052: Result:= '9052-Data de desconto inv�lida';
         9053: Result:= '9053-Especie de titulo invalida';
         9054: Result:= '9054-Especie de titulo n�o encontrada';
         9055: Result:= '9055-Valor de t�tulo inv�lido';
         9056: Result:= '9056-Prazo de cartorio invalido';
         9057: Result:= '9057-Valor de abatimento inv�lido';
         9058: Result:= '9058-Valor de desconto inv�lido';
         9059: Result:= '9059-C�digo de ocorr�ncia inv�lida ou inexistente';
         9060: Result:= '9060-Tipo de mora inv�lido';
         9062: Result:= '9062-Valor de juros ao dia inv�lido';
         9063: Result:= '9063-A data de juros mora � anterior � data de vencimento. Favor verificar estes campos';
         9064: Result:= '9064-A data de juros mora inv�lida';
         9065: Result:= '9065-N�mero da sequ�ncia diferente do esperado';
         9066: Result:= '9066-N�mero de sequencia inv�lido';
         9067: Result:= '9067-Registro inv�lido';
         9068: Result:= '9068-Cpf do emitente inv�lido';
         9070: Result:= '9070-Nome do emitente inv�lido';
         9071: Result:= '9071-Endere�o do emitente inv�lido';
         9072: Result:= '9072-Cidade do emitente inv�lida';
         9073: Result:= '9073-Cep do emitente inv�lido';
         9074: Result:= '9074-Este contrato n�o est� cadastrado para o cedente';
         9075: Result:= '9075-N�o � permitida a entrada de t�tulos vencidos';
         9078: Result:= '9078-N�o existe endere�o, uf e cidade para o t�tulo';
         9079: Result:= '9079-Nosso n�mero inv�lido';
         9083: Result:= '9083-O cedente n�o pode enviar esse tipo de t�tulo com esta carteira';
         9107: Result:= '9107-Tamanho m�ximo do nosso n�mero para cobran�a direta � 10 posi��es + digito(layout padrao matera/bradesco)';
         9224: Result:= '9224-Carteira do Tipo G n�o pode inserir titulos';
      else
         Result:= IntToStrZero(CodMotivo, 4) +' - Outros Motivos';
      end;
   end;
end;
//ok
function TACBrBancoC6.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    //03 : Result:= toRemessaProtestoFinsFalimentares;        {Pedido de Protesto Falimentar}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento concedido}
    06 : Result:= toRemessaAlterarVencimento;               {Prorroga��o}
    07 : Result:= toRemessaAlterarUsoEmpresa;               {Troca Uso da Empresa}
    //08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de seu n�mero}
    09 : Result:= toRemessaProtestar;                       {Protestar}
    10 : Result:= toRemessaNaoProtestar;                    {N�o Protestar}
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar Protesto e Baixar T�tulo}
    19 : Result:= toRemessaCancelarInstrucaoProtesto;       {Sustar o Protesto e Manter em Carteira}
    //22 : Result:= toRemessaTransfCessaoCreditoIDProd10;     {Transfer�ncia Cess�o cr�dito ID. Prod.10}
    //23 : Result:= toRemessaTransferenciaCarteira;           {Transfer�ncia entre Carteiras}
    //24 : Result:= toRemessaDevTransferenciaCarteira;        {Dev. Transfer�ncia entre Carteiras}
    31 : Result:= toRemessaOutrasOcorrencias;               {Altera��o de Outros Dados}
    34 : Result:= toRemessaBaixaporPagtoDiretoCedente;      {Baixa por ter sido pago Diretamente ao Cedente}
    //68 : Result:= toRemessaAcertarRateioCredito;            {Acerto nos dados do rateio de Cr�dito}
    //69 : Result:= toRemessaCancelarRateioCredito;           {Cancelamento do rateio de cr�dito.}
    90 : Result:= toRemessaOutrasAlteracoes;                {Troca de emitente}
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;
//ok
function TACBrBancoC6.TipoOcorrenciaToCodRemessa(
  const TipoOcorrencia: TACBrTipoOcorrencia): String;
begin
//  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
//  begin
//    case TipoOcorrencia of
//        toRemessaBaixar                           : Result := '02';
//        toRemessaConcederAbatimento               : Result := '04';
//        toRemessaCancelarAbatimento               : Result := '05';
//        toRemessaAlterarVencimento                : Result := '06';
//        toRemessaConcederDesconto                 : Result := '07';
//        toRemessaCancelarDesconto                 : Result := '08';
//        toRemessaProtestar                        : Result := '09';
//        toRemessaCancelarInstrucaoProtestoBaixa   : Result := '10';
//        toRemessaCancelarInstrucaoProtesto        : Result := '11';
//        toRemessaDispensarJuros                   : Result := '13';
//        toRemessaAlterarNomeEnderecoSacado        : Result := '31';
//        toRemessaDispensarMulta                   : Result := '15';
//        toRemessaNegativacaoSemProtesto           : Result := '45';
//        toRemessaBaixaTituloNegativadoSemProtesto : Result := '46';
//      else
//        Result := '01';
//    end;
//  end
//  else
//  begin
    case TipoOcorrencia of
        toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
        //toRemessaProtestoFinsFalimentares       : Result := '03'; {Pedido de Protesto Falimentar}
        toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
        toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento}
        toRemessaAlterarVencimento              : Result := '06'; {Prorroga��o}
        toRemessaAlterarUsoEmpresa              : Result := '07'; {Troca Uso da Empresa}
        //toRemessaAlterarNumeroControle          : Result := '08'; {Altera��o de seu n�mero}
        toRemessaProtestar                      : Result := '09'; {Protestar}
        toRemessaNaoProtestar                   : Result := '10'; {N�o Protestar}
        toRemessaCancelarInstrucaoProtestoBaixa : Result := '18'; {Sustar Protesto e Baixar o T�ulo}
        toRemessaCancelarInstrucaoProtesto      : Result := '19'; {Sustar o Protesto e Manter em Carteira}
        //toRemessaAlterarValorTitulo             : Result := '20'; {Altera��o de valor}
        //toRemessaTransferenciaCarteira          : Result := '23'; {Transfer�ncia entre carteiras}
        //toRemessaDevTransferenciaCarteira       : Result := '24'; {Dev. Transfer�ncia entre carteiras}
        toRemessaOutrasOcorrencias              : Result := '31'; {Altera��o de Outros Dados}
        toRemessaBaixaporPagtoDiretoCedente     : Result := '34'; {Baixa por ter sido pago Diretamente ao Cedente}
        toRemessaOutrasAlteracoes               : Result := '90'; {Troca de emitente}
      else
        Result := '01';                                           {Remessa}
    end;
//  end;
end;

end.


