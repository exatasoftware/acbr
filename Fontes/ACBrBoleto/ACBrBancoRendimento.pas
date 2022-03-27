{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Denis Cesar Zago, Victor H Gonzales - Pandaaa }
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

unit ACBrBancoRendimento;

interface

uses
  Classes, Contnrs, SysUtils, ACBrBoleto;

type

  { TACBrBancoRendimento }

  TACBrBancoRendimento = class(TACBrBancoClass)
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

    function TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia) : String; override;
    function CodOcorrenciaToTipo(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
    function TipoOCorrenciaToCod(const TipoOcorrencia: TACBrTipoOcorrencia):String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia:TACBrTipoOcorrencia; CodMotivo:Integer): String; override;

    function CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia; override;
  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, ACBrUtil, ACBrBoletoConversao, ACBrUtil.Strings, ACBrUtil.DateTime ;

{ TACBrBancoRendimento }

constructor TACBrBancoRendimento.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 2;
   fpNome                   := 'RENDIMENTO';
   fpNumero                 := 633;
   fpTamanhoMaximoNossoNum  := 11;   
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 7;
   fpTamanhoCarteira        := 2;
end;

function TACBrBancoRendimento.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String;
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

function TACBrBancoRendimento.MontarCodigoBarras ( const ACBrTitulo: TACBrTitulo) : String;
var
  CodigoBarras, FatorVencimento, DigitoCodBarras:String;
begin
   with ACBrTitulo.ACBrBoleto do
   begin
      FatorVencimento := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      CodigoBarras := IntToStr( Numero )+'9'+ FatorVencimento +
                      IntToStrZero(Round(ACBrTitulo.ValorDocumento*100),10) +
                      PadLeft(OnlyNumber(Cedente.Agencia), fpTamanhoAgencia, '0') +
                      ACBrTitulo.Carteira +
                      ACBrTitulo.NossoNumero +
                      PadLeft(RightStr(Cedente.Conta,7),7,'0') + '0';

      DigitoCodBarras := CalcularDigitoCodigoBarras(CodigoBarras);
   end;

   Result:= IntToStr(Numero) + '9'+ DigitoCodBarras + Copy(CodigoBarras,5,39);
end;

function TACBrBancoRendimento.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result:= ACBrTitulo.Carteira+'/'+ACBrTitulo.NossoNumero+'-'+CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoRendimento.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia+'-'+
             ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito+'/'+
             ACBrTitulo.ACBrBoleto.Cedente.Conta+'-'+
             ACBrTitulo.ACBrBoleto.Cedente.ContaDigito;
end;


procedure TACBrBancoRendimento.GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);
var
  wLinha: String;
begin
   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      wLinha:= '0'                                             + // C�digo de Registro
               '1'                                             + // C�digo de Remessa ( 1 - Remessa)
               'REMESSA'                                       + // Literal de Remessa
               '01'                                            + // C�digo do Servi�o
               PadRight( 'COBRANCA', 15 )                      + // Literal d Servi�o
               PadLeft( CodigoCedente, 14, '0')+Space(6)       + // C�digo da Empresa+Espa�o Em Brancos
               PadRight( Nome, 30)                             + // Nome da Empresa
               IntToStr( Numero )+ PadRight(fpNome, 15)        + // C�digo e Nome do Banco(633 - Banco Rendimento)
               FormatDateTime('ddmmyy',Now)  + Space(294)      + // Data de gera��o do arquivo + brancos
               IntToStrZero(1,6);                                // Nr. Sequencial de Remessa + brancos + Contador

      ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TACBrBancoRendimento.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  DigitoNossoNumero, Ocorrencia, aEspecie, aAgencia :String;
  Protesto, TipoSacado, MensagemCedente, aConta, CartTitulo:String;
  aCarteira, wLinha, ANossoNumero: String;
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

        Result := sLineBreak + '20'+ Copy(PadRight(Mensagem[1], 80, ' '), 1, 80); // IDENTIFICA��O DO LAYOUT PARA O REGISTRO // CONTE�DO DA 1� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO

        if Mensagem.Count >= 3 then
           Result := Result + Copy(PadRight(Mensagem[2], 80, ' '), 1, 80)     // CONTE�DO DA 2� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

        if Mensagem.Count >= 4 then
           Result := Result + Copy(PadRight(Mensagem[3], 80, ' '), 1, 80)     // CONTE�DO DA 3� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

        if Mensagem.Count >= 5 then
           Result := Result + Copy(PadRight(Mensagem[4], 80, ' '), 1, 80)     // CONTE�DO DA 4� LINHA DE IMPRESS�O DA �REA "INSTRU��ES� DO BOLETO
        else
           Result := Result + PadRight('', 80, ' ');                          // CONTE�DO DO RESTANTE DAS LINHAS

        Result := Result                                              +       // 001 a 321 - Mensagens
                  space(72)                                           +       // 322 a 394 - BRANCOS
                  IntToStrZero( aRemessa.Count + 2, 6);                       // 395 a 400 - N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO

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

      if (DataProtesto > 0) and (DataProtesto > Vencimento) then
        Protesto := IntToStrZero(DaysBetween(DataProtesto,Vencimento), 2)
      else
        Protesto := '00';

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : TipoSacado := '01';
         pJuridica : TipoSacado := '02';
      else
         TipoSacado := '04'; //04 �CNPJ do sacador
      end;

      { Converte valor em moeda para percentual, pois o arquivo s� permite % }
      if MultaValorFixo then
        if ValorDocumento > 0 then
          aPercMulta := (PercentualMulta / ValorDocumento) * 100
        else
          aPercMulta := 0
      else
        aPercMulta := PercentualMulta;

      case CaracTitulo of
        tcSimples:    CartTitulo := '1';
        tcVinculada:  CartTitulo := '2';
      end;

      with ACBrBoleto do
      begin
         if Mensagem.Text <> '' then
            MensagemCedente:= Mensagem[0];

                  wLinha:= '1'                                            +  // 001 a 001 - ID Registro
                  TipoSacado                                              +  // 002 a 003 Tipo de inscri��o da empresa
                  PadLeft(OnlyNumber(Cedente.CNPJCPF), 14, '0')           +  // 004 a 017 N�mero de inscri��o
                  PadLeft(Cedente.CodigoCedente, 14, '0')                 +  // 018 a 031 C�digo da empresa no banco
                  Space(31)                                               +  // 032 a 062 Uso exclusivo da empresa
                  StringOfChar('0',11)                                    +  // 063 a 073 - Zeros
                  Space(16)                                               +  // 074 a 089
                  IfThen( PercentualMulta > 0, '2', '0')                  +  // 090 a 090 - Indica se exite Multa ou n�o
                  IntToStrZero( round( aPercMulta * 10000 ) , 13)         +  // 091 a 103 - Percentual de Multa formatado com 4 casas decimais
                  ('01')                                                  +  // 104 a 105 - N�mero de dias para Multa.
                  Space(2)                                                +  // 106 a 107 - Brancos
                  CartTitulo                                              +  // 108 a 108 - C�digo da carteira - Tipo : 1 - COBRAN�A SIMPLES , 2 - COBRAN�A VINCULADA
                  Ocorrencia                                              +  // 109 a 110 - C�digo da ocorr�ncia
                  PadRight( NumeroDocumento,  9)+' '                      +  // 111 a 120 - Numero Documento
                  FormatDateTime( 'ddmmyy', Vencimento)                   +  // 121 a 126 - Data Vencimento
                  IntToStrZero( Round( ValorDocumento * 100 ), 13)        +  // 127 a 139 - Valo Titulo
                  IntToStrZero(fpNumero, 3)                               +  // 140 a 142 - C�d. Banco
                  StringOfChar('0',5) + PadRight(aEspecie,2) + 'N'        +  // 143 a 150 - Zeros + Especie do documento + Idntifica��o(valor fixo N)
                  FormatDateTime( 'ddmmyy', DataDocumento )               +  // 151 a 156 - Data de Emiss�o
                  StringOfChar('0',2)                                     +  // 157 a 158 - Zeros
                  StringOfChar('0',2)                                     +  // 159 a 160 - Zeros
                  IntToStrZero( Round(ValorMoraJuros * 100 ), 13)         +  // 161 a 173 - Valor a ser cobrado por dia de atraso
                  IfThen(DataDesconto < EncodeDate(2000,01,01),'000000',
                         FormatDateTime( 'ddmmyy', DataDesconto))         +  // 174 a 179 - Data limite para concess�o desconto
                  IntToStrZero( round( ValorDesconto * 100 ), 13)         +  // 180 a 192 - Valor Desconto
                  IntToStrZero( round( ValorIOF * 100 ), 13)              +  // 193 a 205 - Valor IOF
                  IntToStrZero( round( ValorAbatimento * 100 ), 13)       +  // 206 a 218 - Valor Abatimento
                  TipoSacado + PadLeft(OnlyNumber(Sacado.CNPJCPF),14,'0') +  // 219 a 234 - Tipo de Inscri��o + N�mero de Inscri��o do Pagador
                  PadRight( Sacado.NomeSacado, 40, ' ')                   +  // 235 a 274 - Nome do Pagador
                  PadRight( Sacado.Logradouro + ' ' + Sacado.Numero + ' ' +
                    Sacado.Complemento, 40)                               +  // 275 a 314 - Complemento do sacado
                  PadRight( Sacado.Bairro, 12, ' ')                       +  // 315 a 326 - Bairro do sacado
                  PadRight( Sacado.CEP, 8 )                               +  // 327 a 334 - CEP do sacado
                  PadRight( Sacado.Cidade, 15, ' ')                       +  // 335 a 349 - Cidade do sacado
                  PadRight( Sacado.UF, 2, ' ')                            +  // 350 a 351 - UF do sacado
                  PadRight( Sacado.SacadoAvalista.NomeAvalista,30)        +  // 352 a 381 - Nome do sacador avalista
                  Space(10)                                               +  // 382 a 391 - Brancos
                  PadLeft( Protesto, 2, '0');                                // 392 a 392  Prazo

         wLinha:= wLinha + IntToStrZero(aRemessa.Count + 1, 7);              // N� SEQ�ENCIAL DO REGISTRO NO ARQUIVO
         wLinha := wLinha + DoMontaInstrucoes1;

         aRemessa.Text:= aRemessa.Text + UpperCase(wLinha);
      end;
   end;
end;

procedure TACBrBancoRendimento.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha := '9' + Space(393) + IntToStrZero( ARemessa.Count + 1, 6);// ID Registro // Contador de Registros
   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

Procedure TACBrBancoRendimento.LerRetorno400 ( ARetorno: TStringList );
var
  Titulo: TACBrTitulo;
  ContLinha: Integer;
  CodMotivo: Integer;
  rAgencia: String;
  rConta: String;
  Linha, rCedente, rCNPJCPF: String;
  rCodEmpresa: String;
begin
  if StrToIntDef(Copy(ARetorno.Strings[0], 77, 3), -1) <> fpNumero then
    raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
      ' n�o � um arquivo de retorno do ' + Nome));

  rCodEmpresa  := Trim(Copy(ARetorno[0], 27, 20)); // 027 a 046 - C�digo da Empresa
  rCedente     := Trim(Copy(ARetorno[0], 47, 30)); // 047 a 030 - Nome da Empresa
  rAgencia     := Trim(Copy(ARetorno[0], 27, ACBrBanco.TamanhoAgencia)); // 027 a 30 - Agencia
  rConta       := Trim(Copy(ARetorno[0], 31, ACBrBanco.TamanhoConta)); //  031 a 037 - Conta

  ACBrBanco.ACBrBoleto.NumeroArquivo := StrToIntDef(Copy(ARetorno[0],109,5),0); // 109 a 113 - N�mero Seq�encial

  ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0],95,2)+'/'+
                                                         Copy(ARetorno[0],97,2)+'/'+
                                                         Copy(ARetorno[0],99,2),0, 'DD/MM/YY' ); // 095 a 100 - Data de Grava��o

  case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
    1: rCNPJCPF := Copy(ARetorno[1], 7, 11);
    2: rCNPJCPF := Copy(ARetorno[1], 4, 14);
  else
    rCNPJCPF := Copy(ARetorno[1], 4, 14);
  end;

  //
  with ACBrBanco.ACBrBoleto do
  begin
    if (not LeCedenteRetorno) and (rCodEmpresa <> PadLeft(Cedente.CodigoCedente, 14, '0')) then
      raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido.'));

    case StrToIntDef(Copy(ARetorno[1], 2, 2), 0) of
      1: Cedente.TipoInscricao := pFisica;
      2: Cedente.TipoInscricao := pJuridica;
    else
      Cedente.TipoInscricao := pJuridica;
    end;

    if LeCedenteRetorno then
    begin
      Cedente.CNPJCPF       := rCNPJCPF;
      Cedente.CodigoCedente := rCodEmpresa;
      Cedente.Nome          := rCedente;
      Cedente.Agencia       := rAgencia;
      Cedente.Conta         := rConta;
      //Cedente.ContaDigito   := 0; - N�O EXISTENTE NO ARQUIVO DE RETORNO
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
      SeuNumero               := Copy(Linha, 38, 25);
      NumeroDocumento         := Trim(Copy(Linha, 117, 10)); // 117 a 126 - Seu N�mero
      OcorrenciaOriginal.Tipo := CodOcorrenciaToTipo(StrToIntDef(Copy(Linha, 109, 2), 0)); // 109 a 110 - C�d. Ocorr�ncia
      CodMotivo               := StrToIntDef(Copy(Linha, 378, 8), 0); // 378 a 385 - Retornos Erros

      if CodMotivo > 0 then
      begin
        MotivoRejeicaoComando.Add(Copy(Linha, 378, 8));
        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo, CodMotivo));
      end;

      DataOcorrencia :=
        StringToDateTimeDef(
          Copy(Linha, 111, 2) + '/' +
          Copy(Linha, 113, 2) + '/'+
          Copy(Linha, 115, 2), 0, 'dd/mm/yy'); // 111 a 116 - Data de Ocorr�ncia

      if Copy(Linha, 147, 2) <> '00' then
        Vencimento :=
          StringToDateTimeDef(
            Copy(Linha, 147, 2) + '/' +
            Copy(Linha, 149, 2) + '/'+
            Copy(Linha, 151, 2), 0, 'dd/mm/yy'); // 147 a 152 - Vencimento

      ValorDocumento       := StrToFloatDef(Copy(Linha, 153, 13), 0) / 100; //153 a 165 - Valor do T�tulo
      ValorIOF             := StrToFloatDef(Copy(Linha, 215, 13), 0) / 100; //215 a 227 - Valor do I.O.F.
      ValorAbatimento      := StrToFloatDef(Copy(Linha, 228, 13), 0) / 100; //228 a 240 - Valor Abatimento
      ValorDesconto        := StrToFloatDef(Copy(Linha, 241, 13), 0) / 100; //241 a 253 - Valor do desconto concedido
      ValorMoraJuros       := StrToFloatDef(Copy(Linha, 267, 13), 0) / 100; //267 a 279 - Valor de mora pago pelo sacado
      ValorOutrosCreditos  := StrToFloatDef(Copy(Linha, 280, 13), 0) / 100; //280 a 376 - Zeros
      ValorRecebido        := StrToFloatDef(Copy(Linha, 254, 13), 0) / 100; //254 a 266 - Valor principal pago pelo sacado
      NossoNumero          := Copy(Linha, 63, 9);                           //063 a 073 - Nosso Numero
      Carteira             := Copy(Linha, 108, 1);                          //108 a 108 - carteira
      ValorDespesaCobranca := StrToFloatDef(Copy(Linha, 176, 13), 0) / 100; //176 a 188 - Tarifa de Cobran�a

      if StrToIntDef(Copy(Linha, 296, 6), 0) <> 0 then
        DataCredito :=
          StringToDateTimeDef(
            Copy(Linha, 386, 2) + '/' +
            Copy(Linha, 388, 2) + '/' +
            Copy(Linha, 400, 2), 0, 'dd/mm/yy'); //386 a 391 - Data Grava��o/Data do Cr�dito

    end;
  end;
end;

function TACBrBancoRendimento.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia), 0);

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    05: Result := '05-Campo Livre Alterado';
    06: Result := '06-Liquidacao Normal';
    08: Result := '08-Liquida��o em Cart�rio';
    09: Result := '09-Baixa Autom�tica';
    10: Result := '10-Baixa por ter sido liquidado';
    12: Result := '12-Confirma Abatimento';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Baixa Rejeitada';
    16: Result := '16-Instru��o Rejeitada';
    19: Result := '19-Confirma Recebimento de Ordem de Protesto';
    20: Result := '20-Confirma Recebimento de Ordem de Susta��o';
    22: Result := '22-Seu n�mero alterado';
    23: Result := '23-T�tulo enviado para cart�rio';
    24: Result := '24-Confirma recebimento de ordem de n�o protestar';
    28: Result := '28-D�bito de Tarifas/Custas � Correspondentes';
    40: Result := '40-Tarifa de Entrada (debitada na Liquida��o) ';
    43: Result := '43-Baixado por ter sido protestado';
    96: Result := '96-Tarifa Sobre Instru��es � M�s anterior';
    97: Result := '97-Tarifa Sobre Baixas � M�s Anterior';
    98: Result := '98-Tarifa Sobre Entradas � M�s Anterior';
    99: Result := '99-Tarifa Sobre Instru��es de Protesto/Susta��o � M�s Anterior';
  end;
end;

function TACBrBancoRendimento.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
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
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    23: Result := toRetornoEncaminhadoACartorio;
    40: Result := toRetornoBaixaPorProtesto;
    41: Result := toRetornoLiquidadoAposBaixaOuNaoRegistro;
    42: Result := toRetornoRetiradoDeCartorio;
    43: Result := toRetornoDespesasProtesto;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoRendimento.TipoOcorrenciaToCod ( const TipoOcorrencia: TACBrTipoOcorrencia ) : String;
begin
  case TipoOcorrencia of
    toRetornoRegistroConfirmado                : Result := '02';
    toRetornoRegistroRecusado                  : Result := '03';
    toRetornoLiquidado                         : Result := '06';
    toRetornoLiquidadoParcialmente             : Result := '07';
    toRetornoBaixaAutomatica                   : Result := '09';
    toRetornoBaixadoInstAgencia                : Result := '10';
    toRetornoTituloEmSer                       : Result := '11';
    toRetornoAbatimentoConcedido               : Result := '12';
    toRetornoAbatimentoCancelado               : Result := '13';
    toRetornoVencimentoAlterado                : Result := '14';
    toRetornoLiquidadoEmCartorio               : Result := '15';
    toRetornoBaixadoFrancoPagamento            : Result := '16';
    toRetornoRecebimentoInstrucaoProtestar     : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto: Result := '20';
    toRetornoEncaminhadoACartorio              : Result := '23';
    toRetornoBaixaPorProtesto                  : Result := '40';
    toRetornoLiquidadoAposBaixaOuNaoRegistro   : Result := '41';
    toRetornoRetiradoDeCartorio                : Result := '42';
    toRetornoDespesasProtesto                  : Result := '43';
  else
    Result := '02';
  end;
end;

function TACBrBancoRendimento.COdMotivoRejeicaoToDescricao( const TipoOcorrencia:TACBrTipoOcorrencia ;CodMotivo: Integer) : String;
begin
  if TipoOcorrencia = toRetornoRegistroRecusado then
  begin
   // Entradas Rejeitadas � Ocorr�ncia 03
    case CodMotivo of
      03: Result := '03-CEP inv�lido � N�o temos cobrador � Cobrador n�o Localizado';
      04: Result := '04-Sigla do Estado inv�lida';
      05: Result := '05-Data de Vencimento inv�lida ou fora do prazo m�nimo';
      06: Result := '06-C�digo do Banco inv�lido';
      08: Result := '08-Nome do sacado n�o informado';
      10: Result := '10-Logradouro n�o informado ';
      14: Result := '14-Registro em duplicidade';
      19: Result := '19-Data de desconto inv�lida ou maior que a data de vencimento';
      20: Result := '20-Valor de IOF n�o num�rico';
      21: Result := '21-Movimento para t�tulo n�o cadastrado no sistema';
      22: Result := '22-Valor de desconto + abatimento maior que o valor do t�tulo';
      25: Result := '25-CNPJ ou CPF do sacado inv�lido (aceito com restri��es)';
      26: Result := '26-Esp�cie de documento inv�lida';
      27: Result := '27-Data de emiss�o do t�tulo inv�lida';
      28: Result := '28-Seu n�mero n�o informado';
      29: Result := '29-CEP � igual a espa�o ou zeros; ou n�o num�rico';
      30: Result := '30-Valor do t�tulo n�o num�rico ou inv�lido';
      36: Result := '36-Valor de perman�ncia (mora) n�o num�rico';
      37: Result := '37-Valor de perman�ncia inconsistente, pois, dentro de um m�s, ser� maior que o valor do t�tulo';
      38: Result := '38-Valor de desconto/abatimento n�o num�rico ou inv�lido';
      39: Result := '39-Valor de abatimento n�o num�rico';
      42: Result := '42-T�tulo j� existente em nossos registros. Nosso n�mero n�o aceito';
      43: Result := '43-T�tulo enviado em duplicidade nesse movimento';
      44: Result := '44-T�tulo zerado ou em branco; ou n�o num�rico na remessa';
      46: Result := '46-T�tulo enviado fora da faixa de Nosso N�mero, estipulada para o cliente';
      51: Result := '51-Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido';
      52: Result := '52-Sacador/Avalista n�o informado';
      53: Result := '53-Prazo de vencimento do t�tulo excede ao da contrata��o';
      54: Result := '54-Banco informado n�o � nosso correspondente 140-142';
      55: Result := '55-Banco correspondente informado n�o cobra este CEP ou n�o possui faixas de CEP cadastradas';
      56: Result := '56-Nosso n�mero no correspondente n�o foi informado';
      57: Result := '57-Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido';
      58: Result := '58-Entradas Rejeitadas � Reprovado no Represamento para An�lise';
      60: Result := '60-CNPJ/CPF do sacado inv�lido � t�tulo recusado';
      87: Result := '87-Excede Prazo m�ximo entre emiss�o e vencimento';

    else
      Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
    end;
  end else if TipoOcorrencia = toRetornoLiquidadoEmCartorio then
  begin
    //Baixas Rejeitadas � Ocorr�ncia 15
    case CodMotivo of
      05: Result := '05-Solicita��o de baixa para t�tulo j� baixado ou liquidado';
      06: Result := '06-Solicita��o de baixa para t�tulo n�o registrado no sistema';
      08: Result := '08-Solicita��o de baixa para t�tulo em float';
    else
      Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
    end;
  end else if TipoOcorrencia = toRetornoBaixadoFrancoPagamento then
  begin
    //Instru��es Rejeitadas � Ocorr�ncia 16
    case CodMotivo of
      04: Result := '04-Data de vencimento n�o num�rica ou inv�lida';
      05: Result := '05-Data de Vencimento inv�lida ou fora do prazo m�nimo';
      14: Result := '14-Registro em duplicidade';
      19: Result := '19-Data de desconto inv�lida ou maior que a data de vencimento';
      20: Result := '20-Campo livre n�o informado';
      21: Result := '21-T�tulo n�o registrado no sistema';
      22: Result := '22-T�tulo baixado ou liquidado';
      26: Result := '26-Esp�cie de documento inv�lida ';
      27: Result := '27-Instru��o n�o aceita, por n�o ter sido emitida ordem de protesto ao cart�rio';
      28: Result := '28-T�tulo tem instru��o de cart�rio ativa';
      29: Result := '29-T�tulo n�o tem instru��o de carteira ativa';
      30: Result := '30-Existe instru��o de n�o protestar, ativa para o t�tulo';
      36: Result := '36-Valor de perman�ncia (mora) n�o num�rico';
      37: Result := '37-T�tulo Descontado � Instru��o n�o permitida para a carteira';
      38: Result := 'Valor do abatimento n�o num�rico ou maior que a soma do valor do t�tulo + perman�ncia + multa';
      39: Result := '39-T�tulo em cart�rio';
      40: Result := '40-Instru��o recusada � Reprovado no Represamento para An�lise';
      44: Result := '44-T�tulo zerado ou em branco; ou n�o num�rico na remessa ';
      51: Result := '51-Tipo/N�mero de Inscri��o Sacador/Avalista Inv�lido';
      53: Result := '53-Prazo de vencimento do t�tulo excede ao da contrata��o';
      57: Result := '57-Remessa contendo duas instru��es incompat�veis � n�o protestar e dias de protesto ou prazo para protesto inv�lido';
      99: Result := '99-Ocorr�ncia desconhecida na remessa';
    else
      Result := IntToStrZero(CodMotivo, 3) + ' - Outros Motivos';
    end;
  end;
end;

function TACBrBancoRendimento.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {Pedido de Baixa}
    04 : Result:= toRemessaConcederAbatimento;              {Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {Cancelamento de Abatimento}
    06 : Result:= toRemessaAlterarVencimento;               {Altera��o de vencimento}
    07 : Result:= toRemessaAlterarControleParticipante;     {Altera��o de Campo Livre       (n�o dispon�vel) }
    08 : Result:= toRemessaAlterarNumeroControle;           {Altera��o de Seu N�mero       (n�o dispon�vel) }
    09 : Result:= toRemessaProtestar;                       {Protestar }
    10 : Result:= toRemessaNaoProtestar;                    {Pedido de N�o Protestar }
    18 : Result:= toRemessaCancelarInstrucaoProtestoBaixa;  {Sustar Protesto }
    47 : Result:= toRemessaAlterarValorTitulo;              {Altera��o do Valor Nominal do t�tulo (altera vencimento tamb�m) (para produtos que permitem esta instru��o)  }
  else
     Result:= toRemessaRegistrar;                           {Remessa}
  end;
end;


end.


