{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou                                 }
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

unit ACBrBancoBradesco;

interface

uses
  Classes, Contnrs, SysUtils, ACBrBoleto;

type

  { TACBrBancoBradesco }

  TACBrBancoBradesco = class(TACBrBancoClass)
  private
  protected
  public
    Constructor create(AOwner: TACBrBanco);
    function CalcularDigitoVerificador(const ACBrTitulo:TACBrTitulo): String; override;
    function MontarCodigoBarras(const ACBrTitulo : TACBrTitulo): String; override;
    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    function MontarCampoCodigoCedente(const ACBrTitulo: TACBrTitulo): String; override;
    procedure GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList); override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;
    procedure GerarRegistroTrailler400(ARemessa:TStringList);  override;
    Procedure LerRetorno400(ARetorno:TStringList); override;

    Procedure LerRetorno240(ARetorno:TStringList); override; // incluido
    function  GerarRegistroHeader240(NumeroRemessa: Integer): String; override;
    function  GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String; override;
    function  GerarRegistroTrailler240(ARemessa: TStringList): String; override;


    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo:Integer): String; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils,
  ACBrUtil ;

{ TACBrBancoBradesco }

constructor TACBrBancoBradesco.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 2;
   fpNome                   := 'Bradesco';
   fpNumero                 := 237;
   fpTamanhoMaximoNossoNum  := 11;   
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 7;
   fpTamanhoCarteira        := 2;
end;

function TACBrBancoBradesco.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String;
begin
   Modulo.CalculoPadrao;
   Modulo.MultiplicadorFinal := 7;
   Modulo.Documento := ACBrTitulo.Carteira + ACBrTitulo.NossoNumero;
   Modulo.Calcular;

   if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoBradesco.MontarCodigoBarras ( const ACBrTitulo: TACBrTitulo) : String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras:String;
begin
   with ACBrTitulo.ACBrBoleto do
   begin
      FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      CodigoBarras := IntToStr( Numero )+'9'+ FatorVencimento +
                      IntToStrZero(Round(ACBrTitulo.ValorDocumento*100),10) +
                      // DONE -oJacinto Junior: Ajustar para utilizar o tamanho definido em fpTamanhoAgencia.
//                      PadLeft(OnlyNumber(Cedente.Agencia),4,'0') +
                      PadLeft(OnlyNumber(Cedente.Agencia), fpTamanhoAgencia, '0') +
                      ACBrTitulo.Carteira +
                      ACBrTitulo.NossoNumero +
                      PadLeft(RightStr(Cedente.Conta,7),7,'0') + '0';

      DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
   end;

   Result:= IntToStr(Numero) + '9'+ DigitoCodBarras + Copy(CodigoBarras,5,39);
end;

function TACBrBancoBradesco.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result:= ACBrTitulo.Carteira+'/'+ACBrTitulo.NossoNumero+'-'+CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoBradesco.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia+'-'+
             ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito+'/'+
             ACBrTitulo.ACBrBoleto.Cedente.Conta+'-'+
             ACBrTitulo.ACBrBoleto.Cedente.ContaDigito;
end;

function TACBrBancoBradesco.GerarRegistroHeader240(NumeroRemessa: Integer): String;
var
  ATipoInscricao: string;
  aContaDigito:String;
begin
  With ACBrBanco.ACBrBoleto.Cedente do
  begin
    case TipoInscricao of
           pFisica  : ATipoInscricao := '1';
           pJuridica: ATipoInscricao := '2';
    end;

    aContaDigito:='';
    if Length( ContaDigito)  > 1  then
      aContaDigito:=  copy(ContaDigito,length(ContaDigito ),1) ;

    { GERAR REGISTRO-HEADER DO ARQUIVO }
    Result:=
    IntToStrZero(ACBrBanco.Numero, 3)                + //1 a 3 - C�digo do banco
    '0000'                                           + //4 a 7 - Lote de servi�o
    '0'                                              + //8 - Tipo de registro - Registro header de arquivo
    PadRight('', 9, ' ')                             + //9 a 17 Uso exclusivo FEBRABAN/CNAB
    ATipoInscricao                                   + //18 - Tipo de inscri��o do cedente
    PadLeft(OnlyNumber(CNPJCPF), 14, '0')            + //19 a 32 -N�mero de inscri��o do cedente
    PadLeft(Convenio,20, '0')                        + //33 a 52 - C�digo do conv�nio no banco-Alfa
    PadLeft(OnlyNumber(Agencia), 5, '0')             + //53 a 57 - C�digo da ag�ncia do cedente-Numero
    PadRight(AgenciaDigito, 1 , ' ')                 + //58 - D�gito da ag�ncia do cedente -Alfa
    Padleft(Conta, 12 , '0')                         + //59-70 - N�mero da Conta Corrente -Numero
    copy(ContaDigito,length(ContaDigito)-1,1)        + //71-71 -D�gito Verificador da Conta -Alfa
    ' '                                              + //BANCO RETORNOU QUE DEVE GRAVAR VAZIO CONTRARIO AO LAYOUT
    //copy(ContaDigito,length(ContaDigito),1)        + //72-72 -D�gito Verificador da Conta  -Alfa
    PadRight(nome, 30, ' ')                          + //73 102 - Nome da Empresa-Alfa
    PadRight('BRADESCO', 30, ' ')                    + //103 a 132 -Nome do banco-Alfa
    PadRight('', 10, ' ')                            + //133 a 142 - Uso exclusivo FEBRABAN/CNAB  -Alfa
    '1'                                              + //143 - C�digo de Remessa (1) / Retorno (2)
    FormatDateTime('ddmmyyyy', Now)                  + //144 a 151 - Data do de gera��o do arquivo
    FormatDateTime('hhmmss', Now)                    + //152 a 157 - Hora de gera��o do arquivo
    PadLeft(IntToStr(NumeroRemessa), 6, '0')         + //158 a 163 - N�mero seq�encial do arquivo
    '084'                                            + //164 a 166 - N�mero da vers�o do layout do arquivo
    '06250'                                          + //167 a 171 - Densidade de grava��o do arquivo (BPI)  fixo 06250
    Space(20)                                        + // 172 a 191 - Uso reservado do banco
    PadRight('REMESSA-PRODUCAO', 20, ' ')            + // 192 a 211 - Uso reservado da empresa
    PadRight('', 29, ' ');                        // 212 a 240 - Uso Exclusivo FEBRABAN / CNAB
    { GERAR REGISTRO HEADER DO LOTE }

    Result:= Result + sLineBreak +
    IntToStrZero(ACBrBanco.Numero, 3)          + //1 a 3 - C�digo do banco
    '0001'                                     + //4 a 7 - Lote de servi�o
    '1'                                        + //8 - Tipo de registro - Registro header de arquivo
    'R'                                        + //9 - Tipo de opera��o 'R')
    '01'                                       + //10 a 11 - Tipo de servi�o: 01 (Cobran�a)
    '  '                                       + //12 a 13 - Uso Exclusivo FEBRABAN/CNAB /Alfa
    '042'                                      + //14 a 16 - N�mero da vers�o do layout do lote
    ' '                                        + //17 - Uso exclusivo FEBRABAN/CNAB
    ATipoInscricao                             + //18 - Tipo de inscri��o do cedente
    PadLeft(OnlyNumber(CNPJCPF), 15, '0')      + //19 a 33 -N�mero de inscri��o do cedente
    PadLeft(Convenio,20, '0')                  + //33 a 52 - C�digo do conv�nio no banco-Alfa
    Padleft(Agencia, 5, '0')                   + //54 a 58 - Ag�ncia Mantenedora da Conta
    PadLeft(OnlyNumber(AgenciaDigito), 1, '0') + //59 - D�gito da ag�ncia do cedente
    Padleft(Conta, 12 , '0')                   + //60 -71 N�mero da Conta Corrente
    Padleft(copy(ContaDigito,length(ContaDigito )-1,1),1,'0')+ //72 a 72 - D�gito Verificador da Conta
    Padleft(aContaDigito,1,' ')                + //73 a 73 - D�gito Verificador da Ag/Conta
    PadRight(Nome, 30, ' ')                    + //74 a 103 - Nome do cedente
    PadRight('', 40, ' ')                      + //104 a 143 - Mensagem 1
    PadRight('', 40, ' ')                      + //144 a 183 - Mensagen 2
    PadLeft(IntToStr(NumeroRemessa), 8, '0')   + //184 a 191 - N�mero seq�encial do registro no lote
    FormatDateTime('ddmmyyyy', date)           +// 192 a 199 Data de Grava��o Remessa/Retorno
    Padleft('0', 8 , '0')                      + //200 -207 Data do Cr�dito
    PadRight('', 33, ' ');                      //208 a 240 - Uso exclusivo FEBRABAN/CNAB
  end;


end;

procedure TACBrBancoBradesco.GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);
var
  wLinha: String;
begin
   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      wLinha:= '0'                                             + // ID do Registro
               '1'                                             + // ID do Arquivo( 1 - Remessa)
               'REMESSA'                                       + // Literal de Remessa
               '01'                                            + // C�digo do Tipo de Servi�o
               PadRight( 'COBRANCA', 15 )                      + // Descri��o do tipo de servi�o
               PadLeft( CodigoCedente, 20, '0')                + // Codigo da Empresa no Banco
               PadRight( Nome, 30)                             + // Nome da Empresa
               IntToStr( Numero )+ PadRight('BRADESCO', 15)    + // C�digo e Nome do Banco(237 - Bradesco)
               FormatDateTime('ddmmyy',Now)  + Space(08)+'MX'  + // Data de gera��o do arquivo + brancos
               IntToStrZero(NumeroRemessa,7) + Space(277)      + // Nr. Sequencial de Remessa + brancos
               IntToStrZero(1,6);                                // Nr. Sequencial de Remessa + brancos + Contador

      ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
   end;
end;

function TACBrBancoBradesco.GerarRegistroTransacao240(ACBrTitulo: TACBrTitulo): String;
var
  ATipoOcorrencia,
  ATipoBoleto,
  ADataMoraJuros,
  ACodigoMoraJuros,
  ACodigoDesconto: String;
  ADataDesconto,
  ADataMulta,
  ANossoNumero,
  ATipoAceite,
  AEspecieDoc: String;
  TipoMovimento:string;

  Fsequencia:Integer;
  FdigitoNossoNumero:String;
  FcodCarteira:string;
  ACodProtesto:Char;

begin
  Fsequencia     :=3 * ACBrTitulo.ACBrBoleto.ListadeBoletos.IndexOf(ACBrTitulo);
  TipoMovimento  :='1';

  case ACBrTitulo.CaracTitulo of
    tcSimples     :FcodCarteira:='1';
    tcVinculada   : FcodCarteira:='2';
    tcCaucionada  :FcodCarteira:='3';
    tcDescontada  :FcodCarteira:='4';
    tcVendor      :FcodCarteira:='5';
  end;


  with ACBrTitulo do
  begin

    ANossoNumero := MontarCampoNossoNumero (ACBrTitulo);

    {C�digo para Protesto}
    case TipoDiasProtesto of
       diCorridos       : ACodProtesto := '1';
       diUteis          : ACodProtesto := '2';
    else
       ACodProtesto := '3';
    end;

    {Pegando o Tipo de Ocorrencia}
    case OcorrenciaOriginal.Tipo of
      toRemessaBaixar                        : ATipoOcorrencia := '02';
      toRemessaConcederAbatimento            : ATipoOcorrencia := '04';
      toRemessaCancelarAbatimento            : ATipoOcorrencia := '05';
      toRemessaAlterarVencimento             : ATipoOcorrencia := '06';
      toRemessaConcederDesconto              : ATipoOcorrencia := '07';
      toRemessaCancelarDesconto              : ATipoOcorrencia := '08';
      toRemessaProtestar                     : ATipoOcorrencia := '09';
      toRemessaCancelarInstrucaoProtestoBaixa: ATipoOcorrencia := '10';
      toRemessaCancelarInstrucaoProtesto     : ATipoOcorrencia := '11';
      toRemessaDispensarJuros                : ATipoOcorrencia := '13';
      toRemessaAlterarNomeEnderecoSacado     : ATipoOcorrencia := '31';
      toRemessaDispensarMulta                   : ATipoOcorrencia := '15';
      toRemessaNegativacaoSemProtesto           : ATipoOcorrencia := '45';
      toRemessaBaixaTituloNegativadoSemProtesto : ATipoOcorrencia := '46';
    else
      ATipoOcorrencia := '01';
    end;
    { Pegando o Aceite do Titulo }
    case Aceite of
       atSim :  ATipoAceite := 'A';
       atNao :  ATipoAceite := 'N';
    end;

    if AnsiSameText(EspecieDoc, 'CH') then
      AEspecieDoc := '01'
    else
    if AnsiSameText(EspecieDoc, 'DM') then
      AEspecieDoc := '02'
    else
    if AnsiSameText(EspecieDoc, 'DMI') then
      AEspecieDoc := '03'
    else
    if AnsiSameText(EspecieDoc, 'DS') then
      AEspecieDoc := '04'
    else
    if AnsiSameText(EspecieDoc, 'DSI') then
      AEspecieDoc := '05'
    else
    if AnsiSameText(EspecieDoc, 'DR') then
      AEspecieDoc := '06'
    else
    if AnsiSameText(EspecieDoc, 'LC') then
      AEspecieDoc := '07'
    else
    if AnsiSameText(EspecieDoc, 'NCC') then
      AEspecieDoc := '08'
    else
    if AnsiSameText(EspecieDoc, 'NCE') then
      AEspecieDoc := '09'
    else
    if AnsiSameText(EspecieDoc, 'NCI') then
      AEspecieDoc := '10'
    else
    if AnsiSameText(EspecieDoc, 'NCR') then
      AEspecieDoc := '11'
    else
    if AnsiSameText(EspecieDoc, 'NP') then
      AEspecieDoc := '12'
    else
    if AnsiSameText(EspecieDoc, 'NPR') then
      AEspecieDoc := '13'
    else
    if AnsiSameText(EspecieDoc, 'TM') then
      AEspecieDoc := '14'
    else
    if AnsiSameText(EspecieDoc, 'TS') then
      AEspecieDoc := '15'
    else
    if AnsiSameText(EspecieDoc, 'NS') then
      AEspecieDoc := '16'
    else
    if AnsiSameText(EspecieDoc, 'RC') then
      AEspecieDoc := '17'
    else
    if AnsiSameText(EspecieDoc, 'FAT') then
      AEspecieDoc := '18'
    else
    if AnsiSameText(EspecieDoc, 'ND') then
      AEspecieDoc := '19'
    else
    if AnsiSameText(EspecieDoc, 'AP') then
      AEspecieDoc := '20'
    else
    if AnsiSameText(EspecieDoc, 'ME') then
      AEspecieDoc := '21'
    else
    if AnsiSameText(EspecieDoc, 'PC') then
      AEspecieDoc := '22'
    else
    if AnsiSameText(EspecieDoc, 'NF') then
      AEspecieDoc := '23'
    else
    if AnsiSameText(EspecieDoc, 'DD') then
      AEspecieDoc := '24'
    else
    if AnsiSameText(EspecieDoc, 'CPR') then
      AEspecieDoc := '25'
    else
      AEspecieDoc := '99';
    {Pegando Tipo de Boleto} //Quem emite e quem distribui o boleto?
    case ACBrBoleto.Cedente.ResponEmissao of
       tbBancoEmite      : ATipoBoleto :=  '1';
       tbCliEmite        : ATipoBoleto :=  '2';
       tbBancoReemite    : ATipoBoleto := '4';
       tbBancoNaoReemite : ATipoBoleto := '5';
    end;

    {Mora Juros}
    if (CodigoMora <> '') then begin
      ACodigoMoraJuros := CodigoMora;
    end
    else
    begin
      if (ValorMoraJuros > 0) then
        ACodigoMoraJuros := '1'
      else 
        ACodigoMoraJuros := '3';      
    end;

    if (ValorMoraJuros > 0) then
    begin
      if DataMoraJuros > 0 then
        ADataMoraJuros := FormatDateTime('ddmmyyyy', DataMoraJuros)
      else
        ADataMoraJuros := PadRight('', 8, '0');
    end
    else
      ADataMoraJuros := PadRight('', 8, '0');

    {Descontos}
    if (ValorDesconto > 0) then
     begin
       if (DataDesconto > 0) then
          ADataDesconto := FormatDateTime('ddmmyyyy', DataDesconto)
       else
          ADataDesconto := PadRight('', 8, '0');

       case TipoDesconto of
         tdValorFixoAteDataInformada : ACodigoDesconto := '1';
         tdPercentualAteDataInformada: ACodigoDesconto := '2';
       else
         ACodigoDesconto := '1';
       end; 
     end
    else
    begin
      ADataDesconto := PadRight('', 8, '0');
      ACodigoDesconto := '0';
    end;

    {Multa}
    if (PercentualMulta > 0) then
    begin
        ADataMulta := IfThen(DataMulta > 0,FormatDateTime('ddmmyyyy', DataMulta),FormatDateTime('ddmmyyyy', Vencimento + 1))
    end
    else
    begin
      ADataMulta := PadLeft('', 8, '0');
    end;
    FdigitoNossoNumero:=CalcularDigitoVerificador(ACBrTitulo);

    {REGISTRO P}
    Result:=
    IntToStrZero(ACBrBanco.Numero, 3)                    + //1 a 3 - C�digo do banco
    '0001'                                               + //4 a 7 - Lote de servi�o
    '3'                                                  + //8 - Tipo do registro: Registro detalhe
    IntToStrZero(Fsequencia+1,5)                         + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
    'P'                                                  + //14 - C�digo do segmento do registro detalhe
    ' '                                                  + //15 - Uso exclusivo FEBRABAN/CNAB: Branco
    ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
    PadLeft(OnlyNumber(ACBrTitulo.ACBrBoleto.Cedente.Agencia), 5, '0')                            + //18 a 22 - Ag�ncia mantenedora da conta
    PadRight(ACBrBoleto.Cedente.AgenciaDigito, 1 , '0')  + //23 -D�gito verificador da ag�ncia
    PadLeft(ACBrBoleto.Cedente.conta, 12, '0')           + //24 a 35 - N�mero da Conta Corrente
    Padleft(ACBrBoleto.Cedente.ContaDigito, 1 , '0')     + //36 a 36 D�gito Verificador da Conta Alfa *G011
    ' '                                                  + //Retornaram que deve gravar vazio .. contrario ao layout
    //PadLeft(Copy(Fconta,Length(Fconta) ,1 ),1, ' ')     + //37-37D�gito Verificador da Ag/Conta 37 37 1 - Alfa *G012
    PadLeft(ACBrTitulo.Carteira, 3, '0')                 + //38-40 Identifica��o do Produto 38 40 3 Num *G069
    PadLeft('0', 5, '0')                                 + //Zeros 41 45 5 Num *G069
    PadLeft(NossoNumero, 11, '0')                        + //Nosso N�mero 46 56 11 Num *G069
    PadLeft(FdigitoNossoNumero,1,'0')                    + //Digito do nosso N�mero 57 57 1 Num *G069
    PadLeft(FcodCarteira,1,'0' )                         + //C�digo da Carteira 58 58 1 - Num *C006
    '1'                                                  + //Forma de Cadastr. do T�tulo no Banco 59 59 1 - Num *C007   1-cobran�a Registrada
    '1'                                                  + //Tipo de Documento 60 60 1 - Alfa C008    -1-Tradicional
    ATipoBoleto                                          + //Identifica��o da Emiss�o do Bloqueto 61 61 1 - Num *C009
    ATipoBoleto                                          +//Identifica��o da Distribui��o 62 62 1 - Alfa C010  -Quem emite que distribua...
    PadRight(NumeroDocumento, 15, ' ')                   + //N�mero do Documento de Cobran�a 63 77 15 - Alfa *C011
    FormatDateTime('ddmmyyyy', Vencimento)               + //Data de Vencimento do T�tulo 78 85 8 - Num *C012
    IntToStrZero( round( ValorDocumento * 100), 15)      + //Valor Nominal do T�tulo 86 100 13 2 Num *G070
    Padleft('0', 5, '0')                                 + //Ag�ncia Encarregada da Cobran�a 101 105 5 - Num *C014
    '0'                                                  + //D�gito Verificador da Ag�ncia 106 106 1 - Alfa *G009
    PadRight(AEspecieDoc, 2)                             + //Esp�cie do T�tulo 107 108 2 - Num *C015
    ATipoAceite                                          + //Identific. de T�tulo Aceito/N�o Aceito 109 109 1 - Alfa C016
    FormatDateTime('ddmmyyyy', DataDocumento)            + //Data da Emiss�o do T�tulo 110 117 8 - Num G071

    ACodigoMoraJuros                                     + //C�digo do Juros de Mora 118 118 1 - Num *C018  '1' = Valor por Dia'2' = Taxa Mensal '3' = Isento
    ADataMoraJuros                                       + //Data do Juros de Mora 119 126 8 - Num *C019

    IfThen(ValorMoraJuros > 0, IntToStrZero(round(ValorMoraJuros * 100), 15),PadRight('', 15, '0')) + //juros de Mora por Dia/Taxa 127 141 13 2 Num C020

    ACodigoDesconto                                      + //C�digo do Desconto 1 142 142 1 - Num *C021
    ADataDesconto                                        + //Data do Desconto 1 143 150 8 - Num C022

    IfThen(ValorDesconto > 0, IntToStrZero(
    round(ValorDesconto * 100), 15),PadRight('', 15, '0'))
                                                         + //Valor/Percentual a ser Concedido 151 165 13 2 Num C023
    IntToStrZero( round(ValorIOF * 100), 15)             + //Valor do IOF a ser Recolhido 166 180 13 2 Num C024
    IntToStrZero( round(ValorAbatimento * 100), 15)      + //Valor do Abatimento 181 195 13 2 Num G045

    PadRight(IfThen(SeuNumero<> '',SeuNumero,NumeroDocumento), 25, ' ')                + //Identifica��o do T�tulo na Empresa 196 220 25 - Alfa G072

    IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0), ACodProtesto, '3')            + //C�digo para Protesto 221 221 1 - Num C026

    IfThen((DataProtesto <> 0) and (DiasDeProtesto > 0),
                    PadLeft(IntToStr(DiasDeProtesto), 2, '0'), '00')                   + //N�mero de Dias para Protesto 222 223 2 - Num C027

    IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento), '1', '2')                    + //C�digo para Baixa/Devolu��o 224 224 1 - Num C028

    IfThen((DataBaixa <> 0) and (DataBaixa > Vencimento),PadLeft(IntToStr(DaysBetween(DataBaixa, Vencimento)), 3, '0'), '000') + //N�mero de Dias para Baixa/Devolu��o 225 227 3 - Alfa C029

    '09'                                                + //C�digo da Moeda 228 229 2 - Num *G065   '09' = Real
    PadRight('', 10 , '0')                              + //N� do Contrato da Opera��o de Cr�d. 230 239 10 - Num C030
    ' ';                                                 //240 - Uso exclusivo FEBRABAN/CNAB

    {SEGMENTO Q}
    Result:= Result +sLineBreak+
    IntToStrZero(ACBrBanco.Numero, 3)                   + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
    '0001'                                              + //Lote Lote de Servi�o 4 7 4 - Num *G002
    '3'                                                 + //Tipo de Registro 8 8 1 - Num �3� *G003
    IntToStrZero(Fsequencia+ 2 ,5)                      + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
    'Q'                                                 + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �Q� *G039
    ' '                                                 + //Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
    ATipoOcorrencia                                     + //C�digo de Movimento Remessa 16 17 2 - Num *C004

    {Dados do sacado}
    IfThen(Sacado.Pessoa = pJuridica,'2','1')           + //Tipo Tipo de Inscri��o 18 18 1 - Num *G005
    PadLeft(OnlyNumber(Sacado.CNPJCPF), 15, '0')        + //N�mero N�mero de Inscri��o 19 33 15 - Num *G006
    PadRight(Sacado.NomeSacado, 40, ' ')                + //Nome 34 73 40 - Alfa G013
    PadRight(Sacado.Logradouro + ' ' + Sacado.Numero +' ' + Sacado.Complemento , 40, ' ') + //Endere�o 74 113 40 - Alfa G032
    PadRight(Sacado.Bairro, 15, ' ')                    + //Bairro 114 128 15 - Alfa G032
    PadLeft(copy(OnlyNumber(ACBrTitulo.Sacado.CEP),0,5), 5, '0')                     + //CEP 129 133 5 - Num G034
    PadRight(copy(OnlyNumber(ACBrTitulo.Sacado.CEP),length(OnlyNumber(ACBrTitulo.Sacado.CEP))-2,3), 3, ' ')       + //Sufixo do CEP 134 136 3 - Num G035
    PadRight(Sacado.Cidade, 15, ' ')                    + // Cidade 137 151 15 - Alfa G033
    PadRight(Sacado.UF, 2, ' ')                         + //Unidade da Federa��o 152 153 2 - Alfa G036

    {Dados do sacador/avalista}
    '0'                                                 + // 154 a 154 - Tipo de Inscri��o 154 154 1 - Num *G005
    PadRight('', 15, '0')                               + // N�mero de Inscri��o 155 169 15 - Num *G006
    PadRight('', 40, ' ')                               + // Nome do Pagadorr/Avalista 170 209 40 - Alfa G013
    PadRight('0', 3, '0')                               + // C�d. Bco. Corresp. na Compensa��o 210 212 3 - Num *C031
    PadRight('',20, ' ')                                + // Nosso N� no Banco Correspondente 213 232 20 - Alfa *C032
    PadRight('', 8, ' ');                                 // FEBRABAN/CNAB 233 240 8 - Alfa Brancos G004

  {SEGMENTO R OPCIONAL }
    Result:= Result + sLineBreak+
    IntToStrZero(ACBrBanco.Numero, 3)                    + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
    '0001'                                               + //Lote de Servi�o 4 7 4 - Num *G002
    '3'                                                  + //Tipo de Registro 8 8 1 - Num �3� *G003
    IntToStrZero(Fsequencia+ 3 ,5)                       + //N� Sequencial do Registro no Lote 9 13 5 - Num *G038
    'R'                                                  + //C�d. Segmento do Registro Detalhe 14 14 1 - Alfa �R� *G039
    ' '                                                  + //CNAB Uso Exclusivo FEBRABAN/CNAB 15 15 1 - Alfa Brancos G004
    ATipoOcorrencia                                      + //C�digo de Movimento Remessa 16 17 2 - Num *C004
    PadLeft('', 1,  '0')                                 + //C�digo do Desconto 2 18 18 1 - Num *C021
    PadLeft('', 8,  '0')                                 + //Data do Desconto 2 19 26 8 - Num C022
    PadLeft('', 15, '0')                                 + //Valor/Percentual a ser Concedido 27 41 13 2 Num C023
    PadLeft('', 1,  '0')                                 + //C�digo do Desconto 3 42 42 1 - Num *C021
    PadLeft('', 8,  '0')                                 + //Data do Desconto 3 43 50 8 - Num C022
    PadLeft('', 15, '0')                                 + //Valor/Percentual a Ser Concedido 51 65 13 2 Num C023

    IfThen((PercentualMulta > 0), '2', '0')                     + //C�digo da Multa 66 66 1 - Alfa G073

    ADataMulta                                                  + //Data da Multa 67 74 8 - Num G074

    IfThen(PercentualMulta > 0,
      IntToStrZero(round(PercentualMulta * 100), 15),
      PadRight('', 15, '0'))                             + //Multa Valor/Percentual a Ser Aplicado 75 89 13 2 Num G075

    PadRight('', 10, ' ')                                + //Informa��o ao Pagador Informa��o ao Pagador 90 99 10 - Alfa *C036
    PadRight('', 40, ' ')                                + //Informa��o 3 Mensagem 3 100 139 40 - Alfa *C037
    PadRight('', 40, ' ')                                + //Mensagem 4 140 179 40 - Alfa *C037
    PadRight('', 20, ' ')                                + //CNAB Uso Exclusivo FEBRABAN/CNAB 180 199 20 - Alfa Brancos G004

    PadLeft('', 8, '0')                                  +//C�d. Ocor. do Pagador 200 207 8 - Num *C038
    PadLeft('', 3, '0')                                  +//C�d. do Banco na Conta do D�bito 208 210 3 - Num G001
    PadLeft('', 5, '0')                                  +//C�digo da Ag�ncia do D�bito 211 215 5 - Num *G008
    PadLeft('', 1, ' ')                                  +//D�gito Verificador da Ag�ncia 216 216 1 - Alfa *G009
    PadLeft('', 12, '0')                                 +//Corrente para D�bito 217 228 12 - Num *G010
    PadLeft('', 1, ' ')                                  +//D�gito Verificador da Conta 229 229 1 - Alfa *G011
    PadLeft('', 1, ' ')                                  +//DV D�gito Verificador Ag/Conta 230 230 1 - Alfa *G012
    PadLeft('', 1, '3')                                  +//Ident. da Emiss�o do Aviso D�b. Aviso para D�bito Autom�tico 231 231 1 - Num *C039
    PadLeft('',9, ' ');                                  //CNAB Uso Exclusivo FEBRABAN/CNAB 232 240 9 - Alfa Brancos G004
    ;
  End;


end;

procedure TACBrBancoBradesco.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  DigitoNossoNumero, Ocorrencia, aEspecie, aAgencia :String;
  Protesto, TipoSacado, MensagemCedente, aConta, aDigitoConta     :String;
  aCarteira, wLinha, ANossoNumero: String;
  TipoBoleto :Char;
  aPercMulta: Double;

  function DoMontaInstrucoes1: string;
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

        Result := sLineBreak +
                  '2'               +                                    // IDENTIFICA��O DO LAYOUT PARA O REGISTRO
                  Copy(PadRight(Mensagem[1], 80, ' '), 1, 80);               // CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

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


        Result := Result                                              +       // 001 a 321 - Mensagens
                  PadLeft('', 6,  '0')                                +       // 322 a 327 - Data limite para concess�o de Desconto 2
                  PadLeft('', 13, '0')                                +       // 328 a 340 - Valor do Desconto 2
                  PadLeft('', 6,  '0')                                +       // 341 a 346 - Data limite para concess�o de Desconto 3
                  PadLeft('', 13, '0')                                +       // 347 a 359 - Valor do Desconto 3
                  space(7)                                            +       // 360 a 366 - Reserva
                  aCarteira                                           +
                  aAgencia                                            +
                  aConta                                              +
                  aDigitoConta                                        +
                  ANossoNumero + DigitoNossoNumero                    +
                  IntToStrZero( aRemessa.Count + 2, 6);                  // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
     end;
  end;

begin

   with ACBrTitulo do
   begin
      ANossoNumero := PadLeft(OnlyNumber(ACBrTitulo.NossoNumero),11, '0');

      if (ACBrBoleto.Cedente.ResponEmissao = tbBancoEmite) and (StrToInt64Def(ANossoNumero,0) = 0) then
        DigitoNossoNumero := '0'
      else
      begin
        ANossoNumero      := ACBrTitulo.NossoNumero;
      DigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);
      end;


      aAgencia := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia),0),5);
      aConta   := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta),0),7);
      aCarteira:= IntToStrZero(StrToIntDef(trim(Carteira),0), 3);
      aDigitoConta := PadLeft(trim(ACBrBoleto.Cedente.ContaDigito),1,'0');

      {Pegando C�digo da Ocorrencia}
      case OcorrenciaOriginal.Tipo of
         toRemessaBaixar                         : Ocorrencia := '02'; {Pedido de Baixa}
         toRemessaProtestoFinsFalimentares       : Ocorrencia := '03'; {Pedido de Protesto Falimentar}
         toRemessaConcederAbatimento             : Ocorrencia := '04'; {Concess�o de Abatimento}
         toRemessaCancelarAbatimento             : Ocorrencia := '05'; {Cancelamento de Abatimento concedido}
         toRemessaAlterarVencimento              : Ocorrencia := '06'; {Altera��o de vencimento}
         toRemessaAlterarControleParticipante    : Ocorrencia := '07'; {Altera��o do controle do participante}
         toRemessaAlterarNumeroControle          : Ocorrencia := '08'; {Altera��o de seu n�mero}
         toRemessaProtestar                      : Ocorrencia := '09'; {Pedido de protesto}
         toRemessaCancelarInstrucaoProtestoBaixa : Ocorrencia := '18'; {Sustar protesto e baixar}
         toRemessaCancelarInstrucaoProtesto      : Ocorrencia := '19'; {Sustar protesto e manter na carteira}
         toRemessaAlterarValorTitulo             : Ocorrencia := '20'; {Altera��o de valor}
         toRemessaTransferenciaCarteira          : Ocorrencia := '23'; {Transfer�ncia entre carteiras}
         toRemessaDevTransferenciaCarteira       : Ocorrencia := '24'; {Dev. Transfer�ncia entre carteiras}
         toRemessaOutrasOcorrencias              : Ocorrencia := '31'; {Altera��o de Outros Dados}
      else
         Ocorrencia := '01';                                           {Remessa}
      end;

      {Pegando Tipo de Boleto}
      if CarteiraEnvio = tceCedente then
         TipoBoleto := '2'
      else 
         TipoBoleto := '1'; 

      if NossoNumero = EmptyStr then
        DigitoNossoNumero := '0';

      {Pegando Especie}
      if trim(EspecieDoc) = 'DM' then
         aEspecie:= '01'
      else if trim(EspecieDoc) = 'NP' then
         aEspecie:= '02'
      else if trim(EspecieDoc) = 'NS' then
         aEspecie:= '03'
      else if trim(EspecieDoc) = 'CS' then
         aEspecie:= '04'
      else if trim(EspecieDoc) = 'ND' then
         aEspecie:= '11'
      else if trim(EspecieDoc) = 'DS' then
         aEspecie:= '12'
      else if trim(EspecieDoc) = 'OU' then
         aEspecie:= '99'
      else
         aEspecie := EspecieDoc;

      {Pegando campo Intru��es}
      if ((DataProtesto > 0) and (DataProtesto > Vencimento)) then
         Protesto := IfThen(PadLeft(trim(Instrucao1),2,'0') = '00','06',PadLeft(trim(Instrucao1),2,'0'))
                   + IntToStrZero(DaysBetween(DataProtesto,Vencimento),2)
      else if Ocorrencia = '31' then
         Protesto := '9999'
      else if ((DataBaixa > 0) and (DataBaixa > Vencimento)) then
         Protesto := PadLeft(trim(Instrucao2),2,'0') + IntToStrZero(DaysBetween(DataBaixa,Vencimento),2)
      else
         Protesto := PadLeft(trim(Instrucao1),2,'0') + PadLeft(trim(Instrucao2),2,'0');

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : TipoSacado := '01';
         pJuridica : TipoSacado := '02';
      else
         TipoSacado := '99';
      end;
      { Converte valor em moeda para percentual, pois o arquivo s� permite % }
      if MultaValorFixo then
        if ValorDocumento > 0 then
          aPercMulta := (PercentualMulta / ValorDocumento) * 100
        else
          aPercMulta := 0
      else
        aPercMulta := PercentualMulta;

      with ACBrBoleto do
      begin
         if Mensagem.Text <> '' then
            MensagemCedente:= Mensagem[0];
         
         
                  wLinha:= '1'                                                     +  // 001 a 001 - ID Registro
                  StringOfChar( '0', 19)                                  +  // 002 a 020 - Dados p/ D�bito Autom�tico
                  '0'+ aCarteira                                          +
                  aAgencia                                                +
                  aConta                                                  +
                  aDigitoConta                                            +
                  PadRight( SeuNumero,25,' ')+'000'                       +  // 038 a 062 - Numero de Controle do Participante                                                   +  // 063 a 065 - C�digo do Banco
                  IfThen( PercentualMulta > 0, '2', '0')                  +  // 066 a 066 - Indica se exite Multa ou n�o
                  IntToStrZero( round( aPercMulta * 100 ) , 4)            +  // 067 a 070 - Percentual de Multa formatado com 2 casas decimais
                  ANossoNumero + DigitoNossoNumero                        +  // 071 a 082 - Identifica��o do Titulo + Digito de auto conferencia de n�mero banc�rio
                  IntToStrZero( round( ValorDescontoAntDia * 100), 10)    +  // 083 a 092 - Desconto Bonifica��o por dia
                  TipoBoleto + ' ' + Space(10)                            +  // 093 a 104 - Tipo Boleto(Quem emite) + Identifica��o se emite boleto para d�bito autom�tico +  Identifica��o Opera��o do Banco
                  ' ' + '2' + '  ' + Ocorrencia                           +  // 105 a 110 - Ind. Rateio de Credito + Aviso de Debito Aut.: 2=N�o emite aviso + BRANCO + Ocorr�ncia
                  PadRight( NumeroDocumento,  10)                         +  // 111 a 120 - Numero Documento
                  FormatDateTime( 'ddmmyy', Vencimento)                   +  // 121 a 126 - Data Vencimento
                  IntToStrZero( Round( ValorDocumento * 100 ), 13)        +  // 127 a 139 - Valo Titulo
                  StringOfChar('0',8) + PadRight(aEspecie,2) + 'N'        +  // 140 a 150 - Zeros + Especie do documento + Idntifica��o(valor fixo N)
                  FormatDateTime( 'ddmmyy', DataDocumento )               +  // 151 a 156 - Data de Emiss�o
                  Protesto                                                +  //
                  IntToStrZero( round(ValorMoraJuros * 100 ), 13)         +  // 161 a 173 - Valor a ser cobrado por dia de atraso
                  IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
                         FormatDateTime( 'ddmmyy', DataDesconto))         +  // 174 a 179 - Data limite para concess�o desconto
                  IntToStrZero( round( ValorDesconto * 100 ), 13)         +  // 180 a 192 - Valor Desconto
                  IntToStrZero( round( ValorIOF * 100 ), 13)              +  // 193 a 205 - Valor IOF
                  IntToStrZero( round( ValorAbatimento * 100 ), 13)       +  // 206 a 218 - Valor Abatimento
                  TipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0') +  // 219 a 234 - Tipo de Inscri��o + N�mero de Inscri��o do Pagador
                  PadRight( Sacado.NomeSacado, 40, ' ')                   +  // 235 a 274 - Nome do Pagador
                  PadRight(Sacado.Logradouro + ' ' + Sacado.Numero + ' '  +
                    Sacado.Complemento, 40)                               +  // 275 a 314
                  space(12) + PadRight( Sacado.CEP, 8 )                   +  // 315 a 334 - 1� Mensagem + CEP
                  PadRight( MensagemCedente, 60 );                           // 335 a 394 - 2� Mensagem


         wLinha:= wLinha + IntToStrZero(aRemessa.Count + 1, 6); // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
         wLinha := wLinha + DoMontaInstrucoes1;

         aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
      end;
   end;
end;

function TACBrBancoBradesco.GerarRegistroTrailler240(ARemessa: TStringList): String;
var
  wQTDTitulos: Integer;
  wlinha:string;
begin
   result:='';
   wQTDTitulos := ARemessa.Count - 1;
   {REGISTRO TRAILER DO LOTE}
   wlinha:=IntToStrZero(ACBrBanco.Numero, 3)                          + //C�digo do Banco na Compensa��o 1 3 3 - Num G001
            '0001'                                                     + //Lote Lote de Servi�o 4 7 4 - Num *G002
            '5'                                                        + //Tipo de Registro 8 8 1 - Num �5� *G003
            Space(9)                                                   + //CNAB Uso Exclusivo FEBRABAN/CNAB 9 17 9 - Alfa Brancos G004
            IntToStrZero((3* wQTDTitulos + 2 ), 6)                     + //Qtde de Registros Quantidade de Registros no Lote 18 23 6 - Num *G057
             {Totaliza��o da Cobran�a simples}
            IntToStrZero((0), 6)                                       + //Quantidade de T�tulos em Cobran�a 24 29 6 - Num *C070  INFORMAR ZERO SEGUNDO O BANCO
            IntToStrZero( 0, 17)                                       + //Valor Total dosT�tulos em Carteiras 30 46 15 2 Num *C071     //ZERO SEGUNDO O BANCO
            {Totaliza��o da Cobran�a vinculada -N�O IMPLEMENTADO }
            PadRight('', 6, '0')                                       + //Quantidade de T�tulos em Cobran�a 47 52 6 - Num *C070
            PadRight('',17, '0')                                       + //Valor Total dosT�tulos em Carteiras 53 69 15 2 Num *C071
            {Totaliza��o da Cobran�a caucionada -N�O IMPLEMENTAO  }
            PadRight('',6,  '0')                                       + //Quantidade de T�tulos em Cobran�a 70 75 6 - Num *C070
            PadRight('',17, '0')                                       + //Quantidade de T�tulos em Carteiras 76 92 15 2 Num *C071
           {Totaliza��o da Cobran�a Descontada -N�O IMPLEMENTAO }
            PadRight('',6,  '0')                                       + //Quantidade de T�tulos em Cobran�a 93 98 6 - Nim *C070
            PadRight('',17, '0')                                       + //Valor Total dosT�tulos em Carteiras 99 115 15 2 Num *C071
           {aviso de lancamento  }
            PadRight('',8, ' ')                                        + //N�mero do Aviso de Lan�amento 116 123 8 - Alfa *C072
            PadRight('',117,' ')                                       ; //Uso Exclusivo FEBRABAN/CNAB 124 240 117 - Alfa Brancos G004

   {GERAR REGISTRO TRAILER DO ARQUIVO}
   wlinha:= wlinha + sLineBreak+
            IntToStrZero(ACBrBanco.Numero, 3)                          + //C�digo do banco
            '9999'                                                     + //Lote de servi�o
            '9'                                                        + //Tipo do registro: Registro trailer do arquivo
            PadRight('',9,' ')                                         + //Uso exclusivo FEBRABAN/CNAB}
            '000001'                                                   + //Quantidade de lotes do arquivo (Registros P,Q,R, header e trailer do lote e do arquivo)
            IntToStrZero((3* wQTDTitulos)+4, 6)                        + //Quantidade de registros do arquivo, inclusive este registro que est� sendo criado agora}
            Padleft('0',6,'0')                                         + //Uso exclusivo FEBRABAN/CNAB}
            PadRight('',205,' ');                                            //Uso exclusivo FEBRABAN/CNAB}

  result:=wlinha ;

end;

procedure TACBrBancoBradesco.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha := '9' + Space(393)                     + // ID Registro
             IntToStrZero( ARemessa.Count + 1, 6);  // Contador de Registros

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

Procedure TACBrBancoBradesco.LerRetorno400 ( ARetorno: TStringList );
var
  Titulo : TACBrTitulo;
  ContLinha, CodOcorrencia  :Integer;
  CodMotivo, i, MotivoLinha :Integer;
  CodMotivo_19, rAgencia    :String;
  rConta, rDigitoConta      :String;
  Linha, rCedente, rCNPJCPF :String;
  rCodEmpresa               :String;
begin
   if StrToIntDef(copy(ARetorno.Strings[0],77,3),-1) <> Numero then
      raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno do '+ Nome));

   rCodEmpresa:= trim(Copy(ARetorno[0],27,20));
   rCedente   := trim(Copy(ARetorno[0],47,30));

   // DONE -oJacinto Junior: Ajustar para fazer a leitura do c�digo da ag�ncia a partir da posi��o 26.
   // A leitura dever� ser feita a partir da posi��o 26 devido ao fato de n�o
   // existirem ag�ncias banc�rias com mais de 4 (quatro) algarismos.
//   rAgencia := trim(Copy(ARetorno[1], 25, ACBrBanco.TamanhoAgencia));
   rAgencia := trim(Copy(ARetorno[1], 26, ACBrBanco.TamanhoAgencia));
   rConta   := trim(Copy(ARetorno[1], 30, ACBrBanco.TamanhoConta));

   rDigitoConta := Copy(ARetorno[1],37,1);

   ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],109,5),0);

   ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],95,2)+'/'+            //|
                                                           Copy(ARetorno[0],97,2)+'/'+            //|Implementado por Carlos Fitl - 27/12/2010
                                                           Copy(ARetorno[0],99,2),0, 'DD/MM/YY' );//|

   ACBrBanco.ACBrBoleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[0],380,2)+'/'+            //|
                                                               Copy(ARetorno[0],382,2)+'/'+            //|Implementado por Carlos Fitl - 27/12/2010
                                                               Copy(ARetorno[0],384,2),0, 'DD/MM/YY' );//|

   case StrToIntDef(Copy(ARetorno[1],2,2),0) of
      11: rCNPJCPF := Copy(ARetorno[1],7,11);
      14: rCNPJCPF := Copy(ARetorno[1],4,14);
   else
     rCNPJCPF := Copy(ARetorno[1],4,14);
   end;

   ValidarDadosRetorno(rAgencia, rConta);
   with ACBrBanco.ACBrBoleto do
   begin
      if (not LeCedenteRetorno) and (rCodEmpresa <> PadLeft(Cedente.CodigoCedente, 20, '0')) then
         raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido'));

      case StrToIntDef(Copy(ARetorno[1],2,2),0) of
         11: Cedente.TipoInscricao:= pFisica;
         14: Cedente.TipoInscricao:= pJuridica;
      else
         Cedente.TipoInscricao := pJuridica;
      end;

      if LeCedenteRetorno then
      begin
         try
           Cedente.CNPJCPF := rCNPJCPF;
         except
           // Retorno quando � CPF est� vindo errado por isso ignora erro na atribui��o
         end;

         Cedente.CodigoCedente:= rCodEmpresa;
         Cedente.Nome         := rCedente;
         Cedente.Agencia      := rAgencia;
         Cedente.AgenciaDigito:= '0';
         Cedente.Conta        := rConta;
         Cedente.ContaDigito  := rDigitoConta;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha] ;

      if Copy(Linha,1,1)<> '1' then
         Continue;

      Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      with Titulo do
      begin
         SeuNumero                   := copy(Linha,38,25);
         NumeroDocumento             := copy(Linha,117,10);
         OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(
                                        copy(Linha,109,2),0));

         CodOcorrencia := StrToIntDef(IfThen(copy(Linha,109,2) = '00','00',copy(Linha,109,2)),0);

         //-|Se a ocorrencia for igual a 19 - Confirma��o de Receb. de Protesto
         //-|Verifica o motivo na posi��o 295 - A = Aceite , D = Desprezado
         if(CodOcorrencia = 19)then
          begin
            CodMotivo_19:= copy(Linha,295,1);
            if(CodMotivo_19 = 'A')then
             begin
               MotivoRejeicaoComando.Add(copy(Linha,295,1));
               DescricaoMotivoRejeicaoComando.Add('A - Aceito');
             end
            else
             begin
               MotivoRejeicaoComando.Add(copy(Linha,295,1));
               DescricaoMotivoRejeicaoComando.Add('D - Desprezado');
             end;
          end
         else
          begin
            MotivoLinha := 319;
            for i := 0 to 4 do
            begin
               CodMotivo := StrToInt(IfThen(copy(Linha,MotivoLinha,2) = '00','00',copy(Linha,MotivoLinha,2)));

               {Se for o primeiro motivo}
               if (i = 0) then
                begin
                  {Somente estas ocorrencias possuem motivos 00}
                  if(CodOcorrencia in [02, 06, 09, 10, 15, 17])then
                   begin
                     MotivoRejeicaoComando.Add(IfThen(copy(Linha,MotivoLinha,2) = '00','00',copy(Linha,MotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,CodMotivo));
                   end
                  else
                   begin
                     if(CodMotivo = 0)then
                      begin
                        MotivoRejeicaoComando.Add('00');
                        DescricaoMotivoRejeicaoComando.Add('Sem Motivo');
                      end
                     else
                      begin
                        MotivoRejeicaoComando.Add(IfThen(copy(Linha,MotivoLinha,2) = '00','00',copy(Linha,MotivoLinha,2)));
                        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,CodMotivo));
                      end;
                   end;
                end
               else
                begin
                  //Apos o 1� motivo os 00 significam que n�o existe mais motivo
                  if CodMotivo <> 0 then
                  begin
                     MotivoRejeicaoComando.Add(IfThen(copy(Linha,MotivoLinha,2) = '00','00',copy(Linha,MotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,CodMotivo));
                  end;
                end;

               MotivoLinha := MotivoLinha + 2; //Incrementa a coluna dos motivos
            end;
          end;

         DataOcorrencia := StringToDateTimeDef( Copy(Linha,111,2)+'/'+
                                                Copy(Linha,113,2)+'/'+
                                                Copy(Linha,115,2),0, 'DD/MM/YY' );
         if Copy(Linha,147,2)<>'00' then
            Vencimento := StringToDateTimeDef( Copy(Linha,147,2)+'/'+
                                               Copy(Linha,149,2)+'/'+
                                               Copy(Linha,151,2),0, 'DD/MM/YY' );

         ValorDocumento       := StrToFloatDef(Copy(Linha,153,13),0)/100;
         ValorIOF             := StrToFloatDef(Copy(Linha,215,13),0)/100;
         ValorAbatimento      := StrToFloatDef(Copy(Linha,228,13),0)/100;
         ValorDesconto        := StrToFloatDef(Copy(Linha,241,13),0)/100;
         ValorMoraJuros       := StrToFloatDef(Copy(Linha,267,13),0)/100;
         ValorOutrosCreditos  := StrToFloatDef(Copy(Linha,280,13),0)/100;
         ValorRecebido        := StrToFloatDef(Copy(Linha,254,13),0)/100;
         NossoNumero          := Copy(Linha,71,11);
         Carteira             := Copy(Linha,22,3);
         ValorDespesaCobranca := StrToFloatDef(Copy(Linha,176,13),0)/100;
         ValorOutrasDespesas  := StrToFloatDef(Copy(Linha,189,13),0)/100;

         if StrToIntDef(Copy(Linha,296,6),0) <> 0 then
            DataCredito:= StringToDateTimeDef( Copy(Linha,296,2)+'/'+
                                               Copy(Linha,298,2)+'/'+
                                               Copy(Linha,300,2),0, 'DD/MM/YY' );
      end;
   end;
end;

function TACBrBancoBradesco.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result := '';
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      04: Result := '04-Transfer�ncia de Carteira/Entrada';
      05: Result := '05-Transfer�ncia de Carteira/Baixa';
      07: Result := '07-Confirma��o do Recebimento da Instru��o de Desconto';
      08: Result := '08-Confirma��o do Recebimento do Cancelamento do Desconto';
      15: Result := '15-Franco de Pagamento';
      24: Result := '24-Retirada de Cart�rio e Manuten��o em Carteira';
      25: Result := '25-Protestado e Baixado';
      26: Result := '26-Instru��o Rejeitada';
      27: Result := '27-Confirma��o do Pedido de Altera��o de Outros Dados';
      33: Result := '33-Confirma��o da Altera��o dos Dados do Rateio de Cr�dito';
      34: Result := '34-Confirma��o do Cancelamento dos Dados do Rateio de Cr�dito';
      36: Result := '36-Confirma��o de Envio de E-mail/SMS';
      37: Result := '37-Envio de E-mail/SMS Rejeitado';
      38: Result := '38-Confirma��o de Altera��o do Prazo Limite de Recebimento';
      39: Result := '39-Confirma��o de Dispensa de Prazo Limite de Recebimento';
      40: Result := '40-Confirma��o da Altera��o do N�mero do T�tulo Dado pelo Beneficiario';
      41: Result := '41-Confirma��o da Altera��o do N�mero Controle do Participante';
      42: Result := '42-Confirma��o da Altera��o dos Dados do Pagador';
      43: Result := '43-Confirma��o da Altera��o dos Dados do Sacador/Avalista';
      44: Result := '44-T�tulo Pago com Cheque Devolvido';
      45: Result := '45-T�tulo Pago com Cheque Compensado';
      46: Result := '46-Instru��o para Cancelar Protesto Confirmada';
      47: Result := '47-Instru��o para Protesto para Fins Falimentares Confirmada';
      48: Result := '48-Confirma��o de Instru��o de Transfer�ncia de Carteira/Modalidade de Cobran�a';
      49: Result := '49-Altera��o de Contrato de Cobran�a';
      50: Result := '50-T�tulo Pago com Cheque Pendente de Liquida��o';
      51: Result := '51-T�tulo DDA Reconhecido pelo Pagador';
      52: Result := '52-T�tulo DDA n�o Reconhecido pelo Pagador';
      53: Result := '53-T�tulo DDA recusado pela CIP';
      54: Result := '54-Confirma��o da Instru��o de Baixa de T�tulo Negativado sem Protesto';
    end;
  end
  else
  begin
    case CodOcorrencia of
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
  end;

  if (Result <> '') then
    Exit;

  case CodOcorrencia of
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
end;

function TACBrBancoBradesco.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  Result := toTipoOcorrenciaNenhum;

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case CodOcorrencia of
      04: Result := toRetornoTransferenciaCarteiraEntrada;
      05: Result := toRetornoTransferenciaCarteiraBaixa;
      07: Result := toRetornoRecebimentoInstrucaoConcederDesconto;
      08: Result := toRetornoRecebimentoInstrucaoCancelarDesconto;
      15: Result := toRetornoBaixadoFrancoPagamento;
      24: Result := toRetornoRetiradoDeCartorio;
      25: Result := toRetornoBaixaPorProtesto;
      26: Result := toRetornoComandoRecusado;
      27: Result := toRetornoRecebimentoInstrucaoAlterarDados;
      33: Result := toRetornoAcertoDadosRateioCredito;
      34: Result := toRetornoCancelamentoDadosRateio;
      36: Result := toRetornoConfirmacaoEmailSMS;
      37: Result := toRetornoEmailSMSRejeitado;
      38: Result := toRetornoAlterarPrazoLimiteRecebimento;
      39: Result := toRetornoDispensarPrazoLimiteRecebimento;
      40: Result := toRetornoAlteracaoSeuNumero;
      41: Result := toRetornoAcertoControleParticipante;
      42: Result := toRetornoRecebimentoInstrucaoAlterarNomeSacado;
      43: Result := toRetornoAlterarSacadorAvalista;
      44: Result := toRetornoChequeDevolvido;
      45: Result := toRetornoChequeCompensado;
      46: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
      47: Result := toRetornoProtestoImediatoFalencia;
      48: Result := toRemessaTransferenciaCarteira;
      49: Result := toRetornoTipoCobrancaAlterado;
      50: Result := toRetornoChequePendenteCompensacao;
      51: Result := toRetornoTituloDDAReconhecidoPagador;
      52: Result := toRetornoTituloDDANaoReconhecidoPagador;
      53: Result := toRetornoTituloDDARecusadoCIP;
      54: Result := toRetornoBaixaTituloNegativadoSemProtesto;
    end;
  end
  else
  begin
    case CodOcorrencia of
      10: Result := toRetornoBaixadoInstAgencia;
      15: Result := toRetornoLiquidadoEmCartorio;
      16: Result := toRetornoTituloPagoEmCheque;
      18: Result := toRetornoAcertoDepositaria;
      21: Result := toRetornoAcertoControleParticipante;
      22: Result := toRetornoTituloPagamentoCancelado;
      24: Result := toRetornoEntradaRejeitaCEPIrregular;
      25: Result := toRetornoProtestoImediatoFalencia;
      27: Result := toRetornoBaixaRejeitada;
      32: Result := toRetornoComandoRecusado;
      33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
      34: Result := toRetornoRetiradoDeCartorio;
      40: Result := toRetornoEstornoPagamento;
      55: Result := toRetornoTituloSustadoJudicialmente;
      68: Result := toRetornoAcertoDadosRateioCredito;
      69: Result := toRetornoCancelamentoDadosRateio;
      74: Result := toRetornoConfirmacaoPedidoExclNegativacao;
    end;
  end;

  if (Result <> toTipoOcorrenciaNenhum) then
    Exit;

  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    11: Result := toRetornoTituloEmSer;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    17: Result := toRetornoLiquidadoAposBaixaouNaoRegistro;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    23: Result := toRetornoEncaminhadoACartorio;
    28: Result := toRetornoDebitoTarifas;
    29: Result := toRetornoOcorrenciasdoSacado;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    35: Result := toRetornoDesagendamentoDebitoAutomatico;
    73: Result := toRetornoConfirmacaoRecebPedidoNegativacao;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoBradesco.TipoOcorrenciaToCod ( const TipoOcorrencia: TACBrTipoOcorrencia ) : String;
begin
  Result := '';

  if (ACBrBanco.ACBrBoleto.LayoutRemessa = c240) then
  begin
    case TipoOcorrencia of
      toRetornoTransferenciaCarteiraEntrada                 : Result := '04';
      toRetornoTransferenciaCarteiraBaixa                   : Result := '05';
      toRetornoRecebimentoInstrucaoConcederDesconto         : Result := '07';
      toRetornoRecebimentoInstrucaoCancelarDesconto         : Result := '08';
      toRetornoBaixadoFrancoPagamento                       : Result := '15';
      toRetornoRetiradoDeCartorio                           : Result := '24';
      toRetornoBaixaPorProtesto                             : Result := '25';
      toRetornoComandoRecusado                              : Result := '26';
      toRetornoRecebimentoInstrucaoAlterarDados             : Result := '27';
      toRetornoAcertoDadosRateioCredito                     : Result := '33';
      toRetornoCancelamentoDadosRateio                      : Result := '34';
      toRetornoConfirmacaoEmailSMS                          : Result := '36';
      toRetornoEmailSMSRejeitado                            : Result := '37';
      toRetornoAlterarPrazoLimiteRecebimento                : Result := '38';
      toRetornoDispensarPrazoLimiteRecebimento              : Result := '39';
      toRetornoAlteracaoSeuNumero                           : Result := '40';
      toRetornoAcertoControleParticipante                   : Result := '41';
      toRetornoRecebimentoInstrucaoAlterarNomeSacado        : Result := '42';
      toRetornoAlterarSacadorAvalista                       : Result := '43';
      toRetornoChequeDevolvido                              : Result := '44';
      toRetornoChequeCompensado                             : Result := '45';
      toRetornoRecebimentoInstrucaoSustarProtesto           : Result := '46';
      toRetornoProtestoImediatoFalencia                     : Result := '47';
      toRemessaTransferenciaCarteira                        : Result := '48';
      toRetornoTipoCobrancaAlterado                         : Result := '49';
      toRetornoChequePendenteCompensacao                    : Result := '50';
      toRetornoTituloDDAReconhecidoPagador                  : Result := '51';
      toRetornoTituloDDANaoReconhecidoPagador               : Result := '52';
      toRetornoTituloDDARecusadoCIP                         : Result := '53';
      toRetornoBaixaTituloNegativadoSemProtesto             : Result := '54';
    end;
  end
  else
  begin
    case TipoOcorrencia of
      toRetornoBaixadoInstAgencia                           : Result := '10';
      toRetornoLiquidadoEmCartorio                          : Result := '15';
      toRetornoTituloPagoEmCheque                           : Result := '16';
      toRetornoAcertoDepositaria                            : Result := '18';
      toRetornoAcertoControleParticipante                   : Result := '21';
      toRetornoTituloPagamentoCancelado                     : Result := '22';
      toRetornoEntradaRejeitaCEPIrregular                   : Result := '24';
      toRetornoProtestoImediatoFalencia                     : Result := '25';
      toRetornoBaixaRejeitada                               : Result := '27';
      toRetornoComandoRecusado                              : Result := '32';
      toRetornoRecebimentoInstrucaoAlterarDados             : Result := '33';
      toRetornoRetiradoDeCartorio                           : Result := '34';
      toRetornoEstornoPagamento                             : Result := '40';
      toRetornoTituloSustadoJudicialmente                   : Result := '55';
      toRetornoAcertoDadosRateioCredito                     : Result := '68';
      toRetornoCancelamentoDadosRateio                      : Result := '69';
      toRetornoConfirmacaoPedidoExclNegativacao             : Result := '74';
    end;
  end;

  if (Result <> '') then
    Exit;

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                             : Result := '02';
    toRetornoRegistroRecusado                               : Result := '03';
    toRetornoLiquidado                                      : Result := '06';
    toRetornoBaixadoViaArquivo                              : Result := '09';
    toRetornoTituloEmSer                                    : Result := '11';
    toRetornoAbatimentoConcedido                            : Result := '12';
    toRetornoAbatimentoCancelado                            : Result := '13';
    toRetornoVencimentoAlterado                             : Result := '14';
    toRetornoLiquidadoAposBaixaouNaoRegistro                : Result := '17';
    toRetornoRecebimentoInstrucaoProtestar                  : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto             : Result := '20';
    toRetornoEncaminhadoACartorio                           : Result := '23';
    toRetornoDebitoTarifas                                  : Result := '28';
    toRetornoOcorrenciasdoSacado                            : Result := '29';
    toRetornoAlteracaoOutrosDadosRejeitada                  : Result := '30';
    toRetornoDesagendamentoDebitoAutomatico                 : Result := '35';
    toRetornoConfirmacaoRecebPedidoNegativacao              : Result := '73';
  else
    Result := '02';
  end;
end;

function TACBrBancoBradesco.COdMotivoRejeicaoToDescricao( const TipoOcorrencia:TACBrTipoOcorrencia ;CodMotivo: Integer) : String;
begin
   case TipoOcorrencia of
      toRetornoRegistroConfirmado:
      case CodMotivo  of
         00: Result := '00-Ocorrencia aceita';
         01: Result := '01-Codigo de banco inv�lido';
         04: Result := '04-Cod. movimentacao nao permitido p/ a carteira';
         15: Result := '15-Caracteristicas de Cobranca Imcompativeis';
         17: Result := '17-Data de vencimento anterior a data de emiss�o';
         21: Result := '21-Esp�cie do T�tulo inv�lido';
         24: Result := '24-Data da emiss�o inv�lida';
         38: Result := '38-Prazo para protesto inv�lido';
         39: Result := '39-Pedido para protesto n�o permitido para t�tulo';
         43: Result := '43-Prazo para baixa e devolu��o inv�lido';
         45: Result := '45-Nome do Sacado inv�lido';
         46: Result := '46-Tipo/num. de inscri��o do Sacado inv�lidos';
         47: Result := '47-Endere�o do Sacado n�o informado';
         48: Result := '48-CEP invalido';
         50: Result := '50-CEP referente a Banco correspondente';
         53: Result := '53-N� de inscri��o do Sacador/avalista inv�lidos (CPF/CNPJ)';
         54: Result := '54-Sacador/avalista n�o informado';
         67: Result := '67-D�bito autom�tico agendado';
         68: Result := '68-D�bito n�o agendado - erro nos dados de remessa';
         69: Result := '69-D�bito n�o agendado - Sacado n�o consta no cadastro de autorizante';
         70: Result := '70-D�bito n�o agendado - Cedente n�o autorizado pelo Sacado';
         71: Result := '71-D�bito n�o agendado - Cedente n�o participa da modalidade de d�bito autom�tico';
         72: Result := '72-D�bito n�o agendado - C�digo de moeda diferente de R$';
         73: Result := '73-D�bito n�o agendado - Data de vencimento inv�lida';
         75: Result := '75-D�bito n�o agendado - Tipo do n�mero de inscri��o do sacado debitado inv�lido';
         76: Result := '76-Pagador Eletr�nico DDA (NOVO)- Esse motivo somente ser� disponibilizado no arquivo retorno para as empresas cadastradas nessa condi��o';
         86: Result := '86-Seu n�mero do documento inv�lido';
         89: Result := '89-Email sacado nao enviado - Titulo com debito automatico';
         90: Result := '90-Email sacado nao enviado - Titulo com cobranca sem registro';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoRegistroRecusado:
      case CodMotivo of
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
         46: Result:= 'Tipo/numero inscricao sacado invalido';
         47: Result:= 'Endereco sacado nao informado';
         48: Result:= 'CEP invalido';
         50: Result:= 'CEP irregular - Banco correspondente';
         63: Result:= 'Entrada para titulo ja cadastrado';
         65: Result:= 'Limite excedido';
         66: Result:= 'Numero autorizacao inexistente';
         68: Result:= 'Debito nao agendado - Erro nos dados da remessa';
         69: Result:= 'Debito nao agendado - Sacado nao consta no cadastro de autorizante';
         70: Result:= 'Debito nao agendado - Cedente nao autorizado pelo sacado';
         71: Result:= 'Debito nao agendado - Cedente nao participa de debito automatico';
         72: Result:= 'Debito nao agendado - Codigo de moeda diferente de R$';
         73: Result:= 'Debito nao agendado - Data de vencimento invalida';
         74: Result:= 'Debito nao agendado - Conforme seu pedido titulo nao registrado';
         75: Result:= 'Debito nao agendado - Tipo de numero de inscricao de debitado invalido';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoLiquidado:
      case CodMotivo of
         00: Result:= '00-Titulo pago com dinheiro';
         15: Result:= '15-Titulo pago com cheque';
         42: Result:= '42-Rateio nao efetuado';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoBaixadoViaArquivo:
      case CodMotivo of
         00: Result:= '00-Ocorrencia aceita';
         10: Result:= '10=Baixa comandada pelo cliente';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
      toRetornoBaixadoInstAgencia:
         case CodMotivo of
            00: Result:= '00-Baixado conforme instrucoes na agencia';
            14: Result:= '14-Titulo protestado';
            15: Result:= '15-Titulo excluido';
            16: Result:= '16-Titulo baixado pelo banco por decurso de prazo';
            20: Result:= '20-Titulo baixado e transferido para desconto';
         else
            Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
         end;
      toRetornoLiquidadoAposBaixaouNaoRegistro:
      case CodMotivo of
         00: Result:= '00-Pago com dinheiro';
         15: Result:= '15-Pago com cheque';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoLiquidadoEmCartorio:
      case CodMotivo of
         00: Result:= '00-Pago com dinheiro';
         15: Result:= '15-Pago com cheque';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoEntradaRejeitaCEPIrregular:
      case CodMotivo of
         48: Result:= '48-CEP invalido';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoBaixaRejeitada:
      case CodMotivo of
         04: Result:= '04-Codigo de ocorrencia nao permitido para a carteira';
         07: Result:= '07-Agencia\Conta\Digito invalidos';
         08: Result:= '08-Nosso numero invalido';
         10: Result:= '10-Carteira invalida';
         15: Result:= '15-Carteira\Agencia\Conta\NossoNumero invalidos';
         40: Result:= '40-Titulo com ordem de protesto emitido';
         42: Result:= '42-Codigo para baixa/devolucao via Telebradesco invalido';
         60: Result:= '60-Movimento para titulo nao cadastrado';
         77: Result:= '70-Transferencia para desconto nao permitido para a carteira';
         85: Result:= '85-Titulo com pagamento vinculado';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoDebitoTarifas:
      case CodMotivo of
         02: Result:= '02-Tarifa de perman�ncia t�tulo cadastrado';
         03: Result:= '03-Tarifa de susta��o';
         04: Result:= '04-Tarifa de protesto';
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
         55: Result:='55-BIFAX';
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
         110: Result:='110-Tarifa reg/pagto Bradesco Expresso';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoOcorrenciasdoSacado:
      case CodMotivo of
         78 : Result:= '78-Sacado alega que faturamento e indevido';
         116: Result:= '116-Sacado aceita/reconhece o faturamento';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoALteracaoOutrosDadosRejeitada:
      case CodMotivo of
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
         46: Result:= '46-Tipo/n�mero de inscri��o do sacado inv�lidos';
         48: Result:= '48-Cep Inv�lido';
         53: Result:= '53-Tipo/N�mero de inscri��o do sacador/avalista inv�lidos';
         54: Result:= '54-Sacador/avalista n�o informado';
         57: Result:= '57-C�digo da multa inv�lido';
         58: Result:= '58-Data da multa inv�lida';
         60: Result:= '60-Movimento para T�tulo n�o cadastrado';
         79: Result:= '79-Data de Juros de mora Inv�lida';
         80: Result:= '80-Data do desconto inv�lida';
         85: Result:= '85-T�tulo com Pagamento Vinculado.';
         88: Result:= '88-E-mail Sacado n�o lido no prazo 5 dias';
         91: Result:= '91-E-mail sacado n�o recebido';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoComandoRecusado:
      case CodMotivo of
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
         45 : Result:= '45-Nome do Sacado n�o informado';
         46 : Result:= '46-Tipo/n�mero de inscri��o do Sacado inv�lidos';
         47 : Result:= '47-Endere�o do Sacado n�o informado';
         48 : Result:= '48-CEP Inv�lido';
         50 : Result:= '50-CEP referente a um Banco correspondente';
         53 : Result:= '53-Tipo de inscri��o do sacador avalista inv�lidos';
         60 : Result:= '60-Movimento para T�tulo n�o cadastrado';
         85 : Result:= '85-T�tulo com pagamento vinculado';
         86 : Result:= '86-Seu n�mero inv�lido';
         94 : Result:= '94-T�tulo Penhorado � Instru��o N�o Liberada pela Ag�ncia';

      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;

      toRetornoDesagendamentoDebitoAutomatico:
      case CodMotivo of
         81 : Result:= '81-Tentativas esgotadas, baixado';
         82 : Result:= '82-Tentativas esgotadas, pendente';
         83 : Result:= '83-Cancelado pelo Sacado e Mantido Pendente, conforme negocia��o';
         84 : Result:= '84-Cancelado pelo sacado e baixado, conforme negocia��o';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
   else
      Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
   end;
end;


procedure TACBrBancoBradesco.LerRetorno240(ARetorno: TStringList);   // MONTANDO A LEITURA DO ARQUIVO DE RETORNO AQUI.... CLAUDIO
var
  Titulo: TACBrTitulo;
  TempData, Linha, rCedente, rCNPJCPF: String;
  ContLinha : Integer;
  idxMotivo: Integer;
  rConvenioCedente: String;
begin
   // informa��o do Header
   // Verifica se o arquivo pertence ao banco
   if StrToIntDef(copy(ARetorno.Strings[0], 1, 3),-1) <> Numero then
      raise Exception.create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o' + '� um arquivo de retorno do ' + Nome));

   ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],144,2)+'/'+
                                                           Copy(ARetorno[0],146,2)+'/'+
                                                           Copy(ARetorno[0],148,4),0, 'DD/MM/YYYY' );

   ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],158,6),0);

   rCedente         := trim(copy(ARetorno[0], 73, 30));
   rCNPJCPF         := OnlyNumber( copy(ARetorno[0], 19, 14) );
   rConvenioCedente := Trim(Copy(ARetorno[0], 33, 20));

   ValidarDadosRetorno('', '', rCNPJCPF);
   with ACBrBanco.ACBrBoleto do
   begin

      if LeCedenteRetorno then
      begin
        Cedente.Nome     := rCedente;
        Cedente.CNPJCPF  := rCNPJCPF;
        Cedente.Convenio := rConvenioCedente;
      end;

      case StrToIntDef(copy(ARetorno[0], 18, 1), 0) of
        01:
          Cedente.TipoInscricao := pFisica;
        else
          Cedente.TipoInscricao := pJuridica;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

//   ACBrBanco.TamanhoMaximoNossoNum := 11;
   Linha := '';
   Titulo := nil;

   for ContLinha := 1 to ARetorno.Count - 2 do
   begin
      Linha := ARetorno[ContLinha];

      if copy(Linha, 8, 1) <> '3' then // verifica se o registro (linha) � um registro detalhe (segmento J)
         Continue;

      if copy(Linha, 14, 1) = 'T' then // se for segmento T cria um novo titulo
         Titulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      if Assigned(Titulo) then
      with Titulo do
      begin
         if copy(Linha, 14, 1) = 'T' then
          begin
            SeuNumero := copy(Linha, 106, 25);
            NumeroDocumento := copy(Linha, 59, 15);
            Carteira := copy(Linha, 58, 1);

            TempData := copy(Linha, 74, 2) + '/'+copy(Linha, 76, 2)+'/'+copy(Linha, 78, 4);
            if TempData<>'00/00/0000' then
               Vencimento := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');

            ValorDocumento := StrToFloatDef(copy(Linha, 82, 15), 0) / 100;

            NossoNumero := copy(Linha, 46, 11);
            ValorDespesaCobranca := StrToFloatDef(copy(Linha, 199, 15), 0) / 100;

            OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(copy(Linha, 16, 2), 0));

            IdxMotivo := 214;

            while (IdxMotivo < 223) do
            begin
               if (trim(Copy(Linha, IdxMotivo, 2)) <> '') then
               begin
                  MotivoRejeicaoComando.Add(Copy(Linha, IdxMotivo, 2));
                  DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, StrToIntDef(Copy(Linha, IdxMotivo, 2), 0)));
               end;
               Inc(IdxMotivo, 2);
            end;

          end
         else // segmento U
          begin
            ValorIOF            := StrToFloatDef(copy(Linha, 63, 15), 0) / 100;
            ValorAbatimento     := StrToFloatDef(copy(Linha, 48, 15), 0) / 100;
            ValorDesconto       := StrToFloatDef(copy(Linha, 33, 15), 0) / 100;
            ValorMoraJuros      := StrToFloatDef(copy(Linha, 18, 15), 0) / 100;
            ValorOutrosCreditos := StrToFloatDef(copy(Linha, 123, 15), 0) / 100;
            ValorOutrasDespesas := StrToFloatDef(copy(Linha, 108, 15), 0) / 100;
            ValorRecebido       := StrToFloatDef(copy(Linha, 78, 15), 0) / 100;

            TempData            := copy(Linha, 138, 2)+'/'+copy(Linha, 140, 2)+'/'+copy(Linha, 142, 4);
            if TempData<>'00/00/0000' then
                DataOcorrencia  := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');

            TempData := copy(Linha, 146, 2)+'/'+copy(Linha, 148, 2)+'/'+copy(Linha, 150, 4);
            if TempData<>'00/00/0000' then
                DataCredito     := StringToDateTimeDef(TempData, 0, 'DDMMYYYY');
          end;
      end;
   end;

   //ACBrBanco.TamanhoMaximoNossoNum := 10;
end;
function TACBrBancoBradesco.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
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


end.


