{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:   Juliana Rodrigues Prado                       }
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

{$I ACBr.inc}

unit ACBrBancoUnicredES;

interface

uses
  Classes, SysUtils, ACBrBoleto;

type

  { TACBrBancoUnicredES }

  TACBrBancoUnicredES = class(TACBrBancoClass)
  private
    function CodMultaToStr(const pCodigoMulta : TACBrCodigoMulta): String;
    function CodJurosToStr(const pCodigoJuros : TACBrCodigoJuros; ValorMoraJuros : Currency): String;
    function CodTipoOcorrenciaToStr(const pTipoOcorrencia : TACBrTipoOcorrencia): String;
    function CodDescontoToStr(const pCodigoDesconto : TACBrCodigoDesconto): String;
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
  StrUtils,
  ACBrUtil ;

{ TACBrBancoUnicredES }

constructor TACBrBancoUnicredES.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 8;
   fpNome                   := 'Unicred';
   fpNumero                 := 136;
   fpTamanhoMaximoNossoNum  := 10;
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 10;
   fpTamanhoCarteira        := 2;
end;

function TACBrBancoUnicredES.CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo ): String;
begin
   Modulo.CalculoPadrao;
   Modulo.MultiplicadorFinal := 9;
   Modulo.Documento := ACBrTitulo.NossoNumero;
   Modulo.Calcular;

   if Modulo.ModuloFinal = 1 then
      Result:= 'P'
   else
      Result:= IntToStr(Modulo.DigitoFinal);
end;

function TACBrBancoUnicredES.MontarCodigoBarras ( const ACBrTitulo: TACBrTitulo) : String;
var
  sCodigoBarras   : String;
  sFatorVencimento: String;
  sDigitoCodBarras: String;
begin
   with ACBrTitulo.ACBrBoleto do
   begin
      sFatorVencimento  := CalcularFatorVencimento(ACBrTitulo.Vencimento);

      sCodigoBarras     := IntToStrZero(Numero, 3) +                                              { Institui��o Financ }
                           '9' +                                                                  { C�d. Moeda = Real }
                           sFatorVencimento +                                                     { Fator Vencimento }
                           IntToStrZero(Round(ACBrTitulo.ValorDocumento * 100), 10) +             { Valor Nominal }
                           PadLeft(OnlyNumber(Cedente.Agencia), fpTamanhoAgencia, '0') +          { Campo Livre 1 - Ag�ncia }
                           PadLeft(RightStr(Cedente.Conta + Cedente.ContaDigito, 10), 10, '0') +  { Campo Livre 2 - Conta }
                           ACBrTitulo.NossoNumero +                                               { Campo Livre 3 - Nosso N�m }
                           CalcularDigitoVerificador(ACBrTitulo);                                 {                C/ D�gito }

      sDigitoCodBarras  := CalcularDigitoCodigoBarras(sCodigoBarras);
   end;

   { Insere o digito verificador calculado no c�digo de barras }
   Result := IntToStrZero(Numero, 3) + '9' + sDigitoCodBarras + Copy(sCodigoBarras, 5, 39);
end;

function TACBrBancoUnicredES.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.NossoNumero + '-'+ CalcularDigitoVerificador(ACBrTitulo);
end;

function TACBrBancoUnicredES.MontarCampoCodigoCedente (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.ACBrBoleto.Cedente.Agencia        + '-' +
             ACBrTitulo.ACBrBoleto.Cedente.AgenciaDigito  + '/' +
             ACBrTitulo.ACBrBoleto.Cedente.Conta          + '-' +
             ACBrTitulo.ACBrBoleto.Cedente.ContaDigito;
end;

procedure TACBrBancoUnicredES.GerarRegistroHeader400(NumeroRemessa : Integer; ARemessa:TStringList);
var
  wLinha: String;
begin
   with ACBrBanco.ACBrBoleto.Cedente do
   begin
      wLinha:= '0'                                                +  { Identifica��o do Registro (001 a 001) }
               '1'                                                +  { Identifica��o do Arquivo Remessa  ( 1 - Remessa) (002 a 002  ) }
               'Remessa'                                          +  { Literal Remessa   }
               '01'                                               +  { C�digo de Servi�o   }
               PadRight('COBRANCA', 15)                           +  { Literal Servi�o   }
               PadLeft(CodigoCedente, 20, '0')                    +  { C�digo do Benefici�rio  }
               PadRight(Nome, 30)                                 +  { Nome da Empresa BENEFICI�RIO }
               IntToStrZero(136, 3)                               +  { N�mero da UNICRED na C�mara de Compensa��o }
               PadRight('UNICRED', 15)                            +  { Nome do Banco por Extenso }
               FormatDateTime('ddmmyy',Now)                       +  { Data da Grava��o do Arquivo }
               Space(07)                                          +  { Branco   }
               '000'                                              +  { C�digo da Varia��o carteira da UNICRED }
               IntToStrZero(NumeroRemessa, 7)                     +  { N� Sequencial do Arquivo }
               Space(277)                                         +  { Branco }
               IntToStrZero(1, 6);                                   { N� Sequencial do Registro }

      ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
   end;
end;

procedure TACBrBancoUnicredES.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  sDigitoNossoNumero, sAgencia : String;
  sTipoSacado, sConta    : String;
  sCarteira, sLinha, sNossoNumero, sNumContrato, sTipoMulta : String;
  iTamNossoNum: Integer;
begin

   with ACBrTitulo do
   begin
      sNossoNumero := ACBrTitulo.NossoNumero;

      iTamNossoNum := CalcularTamMaximoNossoNumero(ACBrTitulo.Carteira,
                                                   ACBrTitulo.NossoNumero);

      if (ACBrBoleto.Cedente.ResponEmissao = tbBancoEmite) then
      begin
        sNossoNumero      := StringOfChar('0', iTamNossoNum);
        sDigitoNossoNumero := '0';
      end
      else
      begin
        sNossoNumero      := ACBrTitulo.NossoNumero;
        sDigitoNossoNumero := CalcularDigitoVerificador(ACBrTitulo);
      end;

      sAgencia      := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia), 0), 5);
      sConta        := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta)  , 0), 7);
      sCarteira     := IntToStrZero(StrToIntDef(trim(Carteira), 0), 3);
      sNumContrato  := sAgencia + sConta + ACBrBoleto.Cedente.ContaDigito;



      {Pegando Tipo de Boleto}
      if (ACBrBoleto.Cedente.ResponEmissao <> tbCliEmite) then
      begin
        if NossoNumero = EmptyStr then
          sDigitoNossoNumero := '0';
      end;

      {Pegando Tipo de Sacado}
      case Sacado.Pessoa of
         pFisica   : sTipoSacado := '01';
         pJuridica : sTipoSacado := '02';
      else
         sTipoSacado := '99';
      end;

      with ACBrBoleto do
      begin
         (*if Mensagem.Text <> '' then
            sMensagemCedente:= Mensagem[0]; *)

         if PercentualMulta > 0 then
           sTipoMulta := CodMultaToStr(CodigoMulta)
         else
           sTipoMulta := '3';

         sLinha:= '1'                                                           +//'|'+  { 001 a 001  	Identifica��o do Registro }
                  sAgencia                                                      +//'|'+  { 002 a 006  	Ag�ncia do BENEFICI�RIO na UNICRED }
                  Cedente.AgenciaDigito                                         +//'|'+  { 007 a 007  	D�gito da Ag�ncia  	001 }
                  PadLeft(sConta, 12, '0')                                      +//'|'+  { 008 a 019  	Conta Corrente  	012 }
                  Cedente.ContaDigito                                           +//'|'+  { 020 a 020  	D�gito da Conta Corrente  	001 }
                  '0'                                                           +//'|'+  { 021 a 021  	Zero  	001  	Zero }
                  sCarteira                                                     +//'|'+  { 022 a 024  	C�digo da Carteira  	003 }
                  StringOfChar('0', 13)                                         +//'|'+  { 025 a 037  	Zeros	013  	Zeros }
                  PadRight(ACBrTitulo.SeuNumero, 25, ' ')                       +//'|'+  { 038 a 062	  N� Controle do Participante (Uso da empresa) 	025 }
                  '136'                                                         +//'|'+  { 063 a 065	  C�digo do Banco na C�mara de Compensa��o	003	136 }
                  StringOfChar('0', 2)                                          +//'|'+  { 066 a 067	  Zeros	002	Zeros }
                  Space(25)                                                     +//'|'+  { 068 a 092	  Branco	025	Branco}
                  '0'                                                           +//'|'+  { 093 a 093	  Filler	001	Zeros}
                  sTipoMulta                                                    +//'|'+  { 094 a 094	  C�digo da Multa	001}
                  IntToStrZero(Round(PercentualMulta * 100), 10)                +//'|'+  { 095 a 104	  Valor/Percentual da Multa	010 }
                  CodJurosToStr(CodigoMoraJuros,ValorMoraJuros)                 +//'|'+  { 105 a 105	  Tipo de Valor Mora	001}
                  '0'                                                           +//'|'+  { 106 a 106	  Filler	001 }
                  Space(2)                                                      +//'|'+  { 107 a 108	  Branco	002	Branco }
                  CodTipoOcorrenciaToStr(OcorrenciaOriginal.Tipo)               +//'|'+  { 109 a 110	  Identifica��o da Ocorr�ncia	002 }
                  PadRight(ACBrTitulo.SeuNumero, 10)                            +//'|'+  { 111 a 120	  N� do Documento (Seu n�mero)	010 }
                  FormatDateTime( 'ddmmyy', Vencimento)                         +//'|'+  { 121 a 126	  Data de vencimento do T�tulo	006 }
                  IntToStrZero(Round(ValorDocumento * 100 ), 13)                +//'|'+  { 127 a 139	  Valor do T�tulo	013 }
                  StringOfChar('0', 3)                                          +//'|'+  { 140 a 142	  Filler	003}
                  StringOfChar('0', 5)                                          +//'|'+  { 143 a 147	  Filler	005	Zeros}
                  StringOfChar('0', 2)                                          +//'|'+  { 148 a 149	  Filler	002	Zeros}
                  CodDescontoToStr(CodigoDesconto)                              +//'|'+  { 150 a 150	  C�digo do desconto	001}
                  FormatDateTime('ddmmyy', DataDocumento)                       +//'|'+  { 151 a 156	  Data de emiss�o do T�tulo	006 }
                  StringOfChar('0', 4)                                          +//'|'+  { 157 a 160	  Filler	004 }
                  IntToStrZero(Round(ValorMoraJuros * 100), 13)                 +//'|'+  { 161 a 173  	Valor de Mora  	013 }
                  IfThen(DataDesconto < EncodeDate(2000,01,01), '000000',
                         FormatDateTime('ddmmyy', DataDesconto))                +//'|'+  { 174 a 179  	Data Limite P/Concess�o de Desconto  	006 }
                  IntToStrZero(Round(ValorDescontoAntDia * 100), 13)            +//'|'+  { 180 a 192  	Valor do Desconto  	013 }
                  PadLeft(sNossoNumero + sDigitoNossoNumero, 11, '0')           +//'|'+  { 193 a 203  	Nosso N�mero na UNICRED  	011 }
                  StringOfChar('0', 2)                                          +//'|'+  { 204 a 205  	Zeros  	002 }
                  ifthen(CodTipoOcorrenciaToStr(OcorrenciaOriginal.Tipo) <> '04',
                  StringOfChar('0', 13),
                  IntToStrZero(Round(ValorAbatimento * 100), 13))               +//'|'+  { 206 a 218  	Valor do Abatimento a ser concedido   	013 }
                  sTipoSacado                                                   +//'|'+  { 219 a 220	  Tipo de inscri��o do Pagador 01 � CPF 02 - CNPJ }
                  PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                  +//'|'+  { 221 a 234  	N� Inscri��o do Pagador  	014 }
                  PadRight(Sacado.NomeSacado, 40, ' ')                          +//'|'+  { 235 a 274  	Nome/Raz�o Social do Pagador  	040   }
                  PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40)         +//'|'+  { 275 a 314  	Endere�o do Pagador  	040 }
                  PadRight(Sacado.Bairro, 12, ' ')                              +//'|'+  { 315 a 326  	Bairro do Pagador  	012 }
                  PadRight(Sacado.CEP, 8, ' ')                                  +//'|'+  { 327 a 334  	CEP do Pagador  	008 }
                  PadRight(Sacado.Cidade, 20, ' ')                              +//'|'+  { 335 a 354  	Cidade do Pagador  	020 }
                  PadRight(Sacado.UF, 2, ' ')                                   +//'|'+  { 355 a 356  	UF do Pagador  	002 }
                  Space(38)                                                     +//'|'+  { 357 a 394  	Pagador/Avalista   	038 }
                  IntToStrZero(aRemessa.Count + 1, 6)                           ;  { 395 a 400  	N� Sequencial do Registro  	006  	N� Sequencial do Registro }

         //sLinha := sLinha + DoMontaInstrucoes1;
                           
         aRemessa.Text := aRemessa.Text + UpperCase(sLinha);
      end;
   end;
end;

procedure TACBrBancoUnicredES.GerarRegistroTrailler400( ARemessa:TStringList );
var
  wLinha: String;
begin
   wLinha := '9' + Space(393)                     +  { ID Registro }
             IntToStrZero( ARemessa.Count + 1, 6);   { Contador de Registros }

   ARemessa.Text:= ARemessa.Text + UpperCase(wLinha);
end;

Procedure TACBrBancoUnicredES.LerRetorno400 ( ARetorno: TStringList );
var
  vTitulo                     : TACBrTitulo;
  iContLinha, iCodOcorrencia  : Integer;
  iCodMotivo, i, iMotivoLinha : Integer;
  sCodMotivo_19, sAgencia     : String;
  sConta, sDigitoConta        : String;
  sLinha, sCedente, sCNPJCPF  : String;
  sCodEmpresa                 : String;
begin
   if (StrToIntDef(Copy(ARetorno.Strings[0], 77, 3), -1) <> Numero) then
      raise Exception.Create(ACBrStr(ACBrBanco.ACBrBoleto.NomeArqRetorno +
                             'n�o � um arquivo de retorno da ' + Nome));

   sCodEmpresa  := Trim(Copy(ARetorno[0], 27, 20));
   sCedente     := Trim(Copy(ARetorno[0], 47, 30));
   sAgencia     := Trim(Copy(ARetorno[1], 25, ACBrBanco.TamanhoAgencia));
   sConta       := Trim(Copy(ARetorno[1], 30, ACBrBanco.TamanhoConta));
   sDigitoConta :=      Copy(ARetorno[1], 42, 1);

   ACBrBanco.ACBrBoleto.NumeroArquivo := 0;//StrToIntDef(Copy(ARetorno[0], 109, 5), 0);

   ACBrBanco.ACBrBoleto.DataArquivo := StringToDateTimeDef(Copy(ARetorno[0], 95, 2) + '/' +
                                                           Copy(ARetorno[0], 97, 2) + '/' +
                                                           Copy(ARetorno[0], 99, 2), 0, 'DD/MM/YY' );
                                                           
   if StrToIntDef( Copy(ARetorno[0], 380, 6 ), 0) <> 0 then
      ACBrBanco.ACBrBoleto.DataCreditoLanc := StringToDateTimeDef(Copy(ARetorno[0], 380, 2) + '/' +
                                                               Copy(ARetorno[0], 382, 2) + '/' +
                                                               Copy(ARetorno[0], 384, 2), 0, 'DD/MM/YY');

   case StrToIntDef(Copy(ARetorno[1],2,2),0) of
      11: sCNPJCPF := Copy(ARetorno[1],7,11);
      14: sCNPJCPF := Copy(ARetorno[1],4,14);
   else
     sCNPJCPF := Copy(ARetorno[1],4,14);
   end;

   with ACBrBanco.ACBrBoleto do
   begin
      if (not LeCedenteRetorno) and (sCodEmpresa <> PadLeft(Cedente.CodigoCedente, 20, '0')) then
         raise Exception.Create(ACBrStr('C�digo da Empresa do arquivo inv�lido'));

      if (not LeCedenteRetorno) and ((sAgencia <> OnlyNumber(Cedente.Agencia)) or
         (sConta <> RightStr(OnlyNumber(Cedente.Conta),Length(sConta)))) then
         raise Exception.Create(ACBrStr('Agencia\Conta do arquivo inv�lido'));

      case StrToIntDef(Copy(ARetorno[1],2,2),0) of
         11: Cedente.TipoInscricao:= pFisica;
         14: Cedente.TipoInscricao:= pJuridica;
      else
         Cedente.TipoInscricao := pJuridica;
      end;

      if LeCedenteRetorno then
      begin
         try
           Cedente.CNPJCPF := sCNPJCPF;
         except
           // Retorno quando � CPF est� vindo errado por isso ignora erro na atribui��o
         end;

         Cedente.CodigoCedente:= sCodEmpresa;
         Cedente.Nome         := sCedente;
         Cedente.Agencia      := sAgencia;
         Cedente.AgenciaDigito:= '0';
         Cedente.Conta        := sConta;
         Cedente.ContaDigito  := sDigitoConta;
      end;

      ACBrBanco.ACBrBoleto.ListadeBoletos.Clear;
   end;

   for iContLinha := 1 to ARetorno.Count - 2 do
   begin
      sLinha := ARetorno[iContLinha] ;

      if Copy(sLinha,1,1)<> '1' then
         Continue;

      vTitulo := ACBrBanco.ACBrBoleto.CriarTituloNaLista;

      with vTitulo do
      begin
         SeuNumero                   := copy(sLinha,38,25);
         NumeroDocumento             := copy(sLinha,117,10);
         OcorrenciaOriginal.Tipo     := CodOcorrenciaToTipo(StrToIntDef(
                                        copy(sLinha,109,2),0));

         iCodOcorrencia := StrToInt(IfThen(copy(sLinha,109,2) = '00','00',copy(sLinha,109,2)));

         //-|Se a ocorrencia for igual a 19 - Confirma��o de Receb. de Protesto
         //-|Verifica o motivo na posi��o 295 - A = Aceite , D = Desprezado
         if(iCodOcorrencia = 19)then
          begin
            sCodMotivo_19:= copy(sLinha,295,1);
            if(sCodMotivo_19 = 'A')then
             begin
               MotivoRejeicaoComando.Add(copy(sLinha,295,1));
               DescricaoMotivoRejeicaoComando.Add('A - Aceito');
             end
            else
             begin
               MotivoRejeicaoComando.Add(copy(sLinha,295,1));
               DescricaoMotivoRejeicaoComando.Add('D - Desprezado');
             end;
          end
         else
          begin
            iMotivoLinha := 319;
            for i := 0 to 4 do
            begin
               iCodMotivo := StrToInt(IfThen(trim(copy(sLinha,iMotivoLinha,2)) = '','00',copy(sLinha,iMotivoLinha,2)));
               {Se for o primeiro motivo}
               if (i = 0) then
                begin
                  {Somente estas ocorrencias possuem motivos 00}
                  if(iCodOcorrencia in [02, 06, 09, 10, 15, 17])then
                   begin
                     MotivoRejeicaoComando.Add(IfThen(trim(copy(sLinha,iMotivoLinha,2)) = '','00',copy(sLinha,iMotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                   end
                  else
                   begin
                     if(iCodMotivo = 0)then
                      begin
                        MotivoRejeicaoComando.Add('00');
                        DescricaoMotivoRejeicaoComando.Add('Sem Motivo');
                      end
                     else
                      begin
                        MotivoRejeicaoComando.Add(IfThen(trim(copy(sLinha,iMotivoLinha,2)) = '','00',copy(sLinha,iMotivoLinha,2)));
                        DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                      end;
                   end;
                end
               else
                begin
                  //Apos o 1� motivo os 00 significam que n�o existe mais motivo
                  if iCodMotivo <> 0 then
                  begin
                     MotivoRejeicaoComando.Add(IfThen(trim(copy(sLinha,iMotivoLinha,2)) = '','00',copy(sLinha,iMotivoLinha,2)));
                     DescricaoMotivoRejeicaoComando.Add(CodMotivoRejeicaoToDescricao(OcorrenciaOriginal.Tipo,iCodMotivo));
                  end;
                end;

               iMotivoLinha := iMotivoLinha + 2; //Incrementa a coluna dos motivos
            end;
          end;

         if  (Copy(sLinha,111,2)<>'00')
         and (Copy(sLinha,111,2)<>'  ') then
           DataOcorrencia := StringToDateTimeDef( Copy(sLinha,111,2)+'/'+
                                                  Copy(sLinha,113,2)+'/'+
                                                  Copy(sLinha,115,2),0, 'DD/MM/YY' );

         if Copy(sLinha,147,2)<>'00' then
            Vencimento := StringToDateTimeDef( Copy(sLinha,147,2)+'/'+
                                               Copy(sLinha,149,2)+'/'+
                                               Copy(sLinha,151,2),0, 'DD/MM/YY' );

         ValorDocumento       := StrToFloatDef(Copy(sLinha,153,13),0)/100;
         ValorIOF             := StrToFloatDef(Copy(sLinha,215,13),0)/100;
         ValorAbatimento      := StrToFloatDef(Copy(sLinha,228,13),0)/100;
         ValorDesconto        := StrToFloatDef(Copy(sLinha,241,13),0)/100;
         ValorMoraJuros       := StrToFloatDef(Copy(sLinha,267,13),0)/100;
         ValorOutrosCreditos  := StrToFloatDef(Copy(sLinha,280,13),0)/100;
         ValorRecebido        := StrToFloatDef(Copy(sLinha,254,13),0)/100;
         NossoNumero          := Copy(sLinha,71,11);
         Carteira             := Copy(sLinha,22,3);
         ValorDespesaCobranca := StrToFloatDef(Copy(sLinha,176,13),0)/100;
         ValorOutrasDespesas  := StrToFloatDef(Copy(sLinha,189,13),0)/100;

         if StrToIntDef(Copy(sLinha,296,6),0) <> 0 then
            DataCredito:= StringToDateTimeDef( Copy(sLinha,296,2)+'/'+
                                               Copy(sLinha,298,2)+'/'+
                                               Copy(sLinha,300,2),0, 'DD/MM/YY' );
      end;
   end;
end;

function TACBrBancoUnicredES.TipoOcorrenciaToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia): String;
var
  CodOcorrencia: Integer;
begin
  Result        := EmptyStr;
  CodOcorrencia := StrToIntDef(TipoOCorrenciaToCod(TipoOcorrencia),0);

  case CodOcorrencia of
    02: Result := '02-Entrada Confirmada';
    03: Result := '03-Entrada Rejeitada';
    06: Result := '06-Liquida��o Normal';
    09: Result := '09-Baixado Automaticamente via Arquivo';
    10: Result := '10-Baixado conforme instru��es da Ag�ncia';
    12: Result := '12-Abatimento Concedido';
    13: Result := '13-Abatimento Cancelado';
    14: Result := '14-Vencimento Alterado';
    15: Result := '15-Liquida��o em Cart�rio';
    19: Result := '19-Confirma��o Recebimento Instru��o de Protesto';
    20: Result := '20-Confirma��o Recebimento Instru��o Susta��o de Protesto';
    21: Result := '21-Confirma Recebimento de Instru��o de N�o Protestar';
    24: Result := '24-Entrada rejeitada por CEP Irregular';
    27: Result := '27-Baixa Rejeitada';
    30: Result := '30-Altera��o de Outros Dados Rejeitados';
    32: Result := '32-Instru��o Rejeitada';
    33: Result := '33-Confirma��o Pedido Altera��o Outros Dados';
  end;
end;

function TACBrBancoUnicredES.CodOcorrenciaToTipo(const CodOcorrencia:
   Integer ) : TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02: Result := toRetornoRegistroConfirmado;
    03: Result := toRetornoRegistroRecusado;
    06: Result := toRetornoLiquidado;
    09: Result := toRetornoBaixadoViaArquivo;
    10: Result := toRetornoBaixadoInstAgencia;
    12: Result := toRetornoAbatimentoConcedido;
    13: Result := toRetornoAbatimentoCancelado;
    14: Result := toRetornoVencimentoAlterado;
    15: Result := toRetornoLiquidadoEmCartorio;
    19: Result := toRetornoRecebimentoInstrucaoProtestar;
    20: Result := toRetornoRecebimentoInstrucaoSustarProtesto;
    21: Result := toRetornoAcertoControleParticipante;
    24: Result := toRetornoEntradaRejeitaCEPIrregular;
    27: Result := toRetornoBaixaRejeitada;
    30: Result := toRetornoAlteracaoOutrosDadosRejeitada;
    32: Result := toRetornoInstrucaoRejeitada;
    33: Result := toRetornoRecebimentoInstrucaoAlterarDados;
  else
    Result := toRetornoOutrasOcorrencias;
  end;
end;

function TACBrBancoUnicredES.TipoOcorrenciaToCod ( const TipoOcorrencia: TACBrTipoOcorrencia ) : String;
begin
  Result := '';

  case TipoOcorrencia of
    toRetornoRegistroConfirmado                             : Result := '02';
    toRetornoRegistroRecusado                               : Result := '03';
    toRetornoLiquidado                                      : Result := '06';
    toRetornoBaixadoViaArquivo                              : Result := '09';
    toRetornoBaixadoInstAgencia                             : Result := '10';
    toRetornoAbatimentoConcedido                            : Result := '12';
    toRetornoAbatimentoCancelado                            : Result := '13';
    toRetornoVencimentoAlterado                             : Result := '14';
    toRetornoLiquidadoEmCartorio                            : Result := '15';
    toRetornoRecebimentoInstrucaoProtestar                  : Result := '19';
    toRetornoRecebimentoInstrucaoSustarProtesto             : Result := '20';
    toRetornoAcertoControleParticipante                     : Result := '21';
    toRetornoEntradaRejeitaCEPIrregular                     : Result := '24';
    toRetornoBaixaRejeitada                                 : Result := '27';
    toRetornoAlteracaoOutrosDadosRejeitada                  : Result := '30';
    toRetornoInstrucaoRejeitada                             : Result := '32';
    toRetornoRecebimentoInstrucaoAlterarDados               : Result := '33';
  else
    Result := '02';
  end;
end;

function TACBrBancoUnicredES.CodDescontoToStr(
  const pCodigoDesconto: TACBrCodigoDesconto): String;
begin
  case pCodigoDesconto of
    cdSemDesconto : Result := '0';
    cdValorFixo : Result := '1';
  end;
end;

function TACBrBancoUnicredES.CodJurosToStr(const pCodigoJuros : TACBrCodigoJuros; ValorMoraJuros : Currency): String;
begin
  if ValorMoraJuros = 0 then
  Begin
    result := '5';
  End
  else
  Begin
  case pCodigoJuros of
    cjValorDia: result := '1';
    cjTaxaMensal: result := '2';
    cjValorMensal: result := '3';
    cjTaxaDiaria: result := '4';
    cjIsento: result := '5';
  end;
  End;
end;

function TACBrBancoUnicredES.COdMotivoRejeicaoToDescricao( const TipoOcorrencia:TACBrTipoOcorrencia ;CodMotivo: Integer) : String;
begin
   case TipoOcorrencia of
     toRetornoRegistroConfirmado:
       case CodMotivo  of
         00: Result := '00-Ocorrencia aceita';
       else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
       end;
    toRetornoRegistroRecusado:
      case CodMotivo of
         02: Result := '02-Codigo do registro detalhe invalido';
         03: Result := '03-Codigo da Ocorrencia Invalida';
         04: Result := '04-Codigo da Ocorrencia nao permitida para a carteira';
         05: Result := '05-Codigo de Ocorrencia nao numerico';
         07: Result := '07-Agencia\Conta\Digito invalido';
         08: Result := '08-Nosso numero invalido';
         09: Result := '09-Nosso numero duplicado';
         10: Result := '10-Carteira invalida';
         16: Result := '16-Data de vencimento invalida';
         18: Result := '18-Vencimento fora do prazo de operacao';
         20: Result := '20-Valor do titulo invalido';
         21: Result := '21-Especie do titulo invalida';
         22: Result := '22-Especie nao permitida para a carteira';
         24: Result := '24-Data de emissao invalida';
         38: Result := '38-Prazo para protesto invalido';
         44: Result := '44-Agencia cedente nao prevista';
         45: Result := '45-Nome Sacado nao informado';
         46: Result := '46-Tipo/numero inscricao sacado invalido';
         47: Result := '47-Endereco sacado nao informado';
         48: Result := '48-CEP invalido';
         63: Result := '63-Entrada para titulo ja cadastrado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoLiquidado:
      case CodMotivo of
         00: Result := '00-Titulo pago com dinheiro';
         15: Result := '15-Titulo pago com cheque';
         42: Result := '42-Rateio nao efetuado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixadoViaArquivo:
      case CodMotivo of
         00: Result := '00-Ocorrencia aceita';
         10: Result := '10=Baixa comandada pelo cliente';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixadoInstAgencia:
         case CodMotivo of
            00: Result := '00-Baixado comandada';
         else
            Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
         end;
    toRetornoLiquidadoEmCartorio:
      case CodMotivo of
         00: Result := '00-Pago com dinheiro';
         15: Result := '15-Pago com cheque';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoEntradaRejeitaCEPIrregular:
      case CodMotivo of
         00: Result := '00-CEP invalido';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoBaixaRejeitada:
      case CodMotivo of
         04: Result := '04-Codigo de ocorrencia nao permitido para a carteira';
         07: Result := '07-Agencia\Conta\Digito invalidos';
         08: Result := '08-Nosso numero invalido';
         10: Result := '10-Carteira invalida';
         15: Result := '15-Carteira\Agencia\Conta\NossoNumero invalidos';
         40: Result := '40-Titulo com ordem de protesto emitido';
         60: Result := '60-Movimento para titulo nao cadastrado';
         77: Result := '70-Transferencia para desconto nao permitido para a carteira';
         85: Result := '85-Titulo com pagamento vinculado';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoALteracaoOutrosDadosRejeitada:
      case CodMotivo of
         01: Result := '01-C�digo do Banco inv�lido';
         04: Result := '04-C�digo de ocorr�ncia n�o permitido para a carteira';
         05: Result := '05-C�digo da ocorr�ncia n�o num�rico';
         08: Result := '08-Nosso n�mero inv�lido';
         15: Result := '15-Caracter�stica da cobran�a incompat�vel';
         16: Result := '16-Data de vencimento inv�lido';
         17: Result := '17-Data de vencimento anterior a data de emiss�o';
         18: Result := '18-Vencimento fora do prazo de opera��o';
         24: Result := '24-Data de emiss�o Inv�lida';
         29: Result := '29-Valor do desconto maior/igual ao valor do T�tulo';
         30: Result := '30-Desconto a conceder n�o confere';
         31: Result := '31-Concess�o de desconto j� existente ( Desconto anterior )';
         33: Result := '33-Valor do abatimento inv�lido';
         34: Result := '34-Valor do abatimento maior/igual ao valor do T�tulo';
         38: Result := '38-Prazo para protesto inv�lido';
         39: Result := '39-Pedido de protesto n�o permitido para o T�tulo';
         40: Result := '40-T�tulo com ordem de protesto emitido';
         42: Result := '42-C�digo para baixa/devolu��o inv�lido';
         60: Result := '60-Movimento para T�tulo n�o cadastrado';
         85: Result := '85-T�tulo com Pagamento Vinculado.';
      else
         Result := IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoInstrucaoRejeitada:
      case CodMotivo of
         01 : Result := '01-C�digo do Banco inv�lido';
         02 : Result := '02-C�digo do registro detalhe inv�lido';
         04 : Result := '04-C�digo de ocorr�ncia n�o permitido para a carteira';
         05 : Result := '05-C�digo de ocorr�ncia n�o num�rico';
         07 : Result := '07-Ag�ncia/Conta/d�gito inv�lidos';
         08 : Result := '08-Nosso n�mero inv�lido';
         10 : Result := '10-Carteira inv�lida';
         15 : Result := '15-Caracter�sticas da cobran�a incompat�veis';
         16 : Result := '16-Data de vencimento inv�lida';
         17 : Result := '17-Data de vencimento anterior a data de emiss�o';
         18 : Result := '18-Vencimento fora do prazo de opera��o';
         20 : Result := '20-Valor do t�tulo inv�lido';
         21 : Result := '21-Esp�cie do T�tulo inv�lida';
         22 : Result := '22-Esp�cie n�o permitida para a carteira';
         24 : Result := '24-Data de emiss�o inv�lida';
         28 : Result := '28-C�digo de desconto inv�lido';
         29 : Result := '29-Valor do desconto maior/igual ao valor do T�tulo';
         30 : Result := '30-Desconto a conceder n�o confere';
         31 : Result := '31-Concess�o de desconto - J� existe desconto anterior';
         33 : Result := '33-Valor do abatimento inv�lido';
         34 : Result := '34-Valor do abatimento maior/igual ao valor do T�tulo';
         36 : Result := '36-Concess�o abatimento - J� existe abatimento anterior';
         38 : Result := '38-Prazo para protesto inv�lido';
         39 : Result := '39-Pedido de protesto n�o permitido para o T�tulo';
         40 : Result := '40-T�tulo com ordem de protesto emitido';
         41 : Result := '41-Pedido cancelamento/susta��o para T�tulo sem instru��o de protesto';
         42 : Result := '42-C�digo para baixa/devolu��o inv�lido';
         45 : Result := '45-Nome do Sacado n�o informado';
         46 : Result := '46-Tipo/n�mero de inscri��o do Sacado inv�lidos';
         47 : Result := '47-Endere�o do Sacado n�o informado';
         48 : Result := '48-CEP Inv�lido';
         60 : Result := '60-Movimento para T�tulo n�o cadastrado';
         85 : Result := '85-T�tulo com pagamento vinculado';
         86 : Result := '86-Seu n�mero inv�lido';
      else
         Result:= IntToStrZero(CodMotivo,2) +' - Outros Motivos';
      end;
    toRetornoDesagendamentoDebitoAutomatico:
         Result := IntToStrZero(CodMotivo,2) + ' - Outros Motivos';
   else
      Result := IntToStrZero(CodMotivo,2) + ' - Outros Motivos';
   end;
end;

function TACBrBancoUnicredES.CodMultaToStr(const pCodigoMulta: TACBrCodigoMulta): String;
begin
  case pCodigoMulta of
    cmValorFixo : result := '1';
    cmPercentual : result := '2';
  else
    result := '3';
  end;

end;

function TACBrBancoUnicredES.CodOcorrenciaToTipoRemessa(const CodOcorrencia:Integer): TACBrTipoOcorrencia;
begin
  case CodOcorrencia of
    02 : Result:= toRemessaBaixar;                          {02 - Pedido de Baixa }
    04 : Result:= toRemessaConcederAbatimento;              {04 - Concess�o de Abatimento}
    05 : Result:= toRemessaCancelarAbatimento;              {05 - Cancelamento de Abatimento }
    06 : Result:= toRemessaAlterarVencimento;               {06 - Altera��o de vencimento }
    08 : Result:= toRemessaAlterarNumeroControle;           {08- Altera��o de Seu N�mero }
    31 : Result:= toRemessaOutrasOcorrencias;               {31 - Altera��o de outros dados (Altera��o de dados do pagador)}
  else
     Result:= toRemessaRegistrar;                           {01 - Remessa }
  end;
end;


function TACBrBancoUnicredES.CodTipoOcorrenciaToStr(const pTipoOcorrencia: TACBrTipoOcorrencia): String;
begin
  {Pegando C�digo da Ocorrencia}
  case pTipoOcorrencia of
     toRemessaBaixar                         : Result := '02'; {Pedido de Baixa}
     toRemessaConcederAbatimento             : Result := '04'; {Concess�o de Abatimento}
     toRemessaCancelarAbatimento             : Result := '05'; {Cancelamento de Abatimento concedido}
     toRemessaAlterarVencimento              : Result := '06'; {Altera��o de vencimento}
     toRemessaAlterarNumeroControle          : Result := '08'; {Altera��o de seu n�mero}
     toRemessaProtestar                      : Result := '09'; {Pedido de protesto}
     toRemessaNaoProtestar                   : Result := '10'; {N�o Protestar}
     toRemessaCancelarInstrucaoProtestoBaixa : Result := '18'; {Sustar protesto e baixar}
     toRemessaCancelarInstrucaoProtesto      : Result := '19'; {Sustar protesto e manter na carteira}
     toRemessaOutrasOcorrencias              : Result := '31'; {Altera��o de Outros Dados}
  else
     Result := '01';                                           {Remessa}
  end;
end;

end.


