{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou, Jos� M S Junior                }
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

unit ACBrBancoUnicredES;

interface

uses
  Classes, SysUtils, ACBrBoleto, ACBrBancoUnicredRS;

type

  { TACBrBancoUnicredES }

  TACBrBancoUnicredES = class(TACBrBancoUnicredRS)
  private
    function CodMultaToStr(const pCodigoMulta : TACBrCodigoMulta): String;
    function CodJurosToStr(const pCodigoJuros : TACBrCodigoJuros; ValorMoraJuros : Currency): String;
    function CodDescontoToStr(const pCodigoDesconto : TACBrCodigoDesconto): String;
  protected
    function DefineNumeroDocumentoModulo(const ACBrTitulo: TACBrTitulo): String; override;
  public
    Constructor create(AOwner: TACBrBanco);

    function MontarCampoNossoNumero(const ACBrTitulo :TACBrTitulo): String; override;
    procedure GerarRegistroTransacao400(ACBrTitulo : TACBrTitulo; aRemessa: TStringList); override;

  end;

implementation

uses {$IFDEF COMPILER6_UP} dateutils {$ELSE} ACBrD5 {$ENDIF},
  StrUtils, ACBrUtil ;

{ TACBrBancoUnicredES }

constructor TACBrBancoUnicredES.create(AOwner: TACBrBanco);
begin
   inherited create(AOwner);
   fpDigito                 := 8;
   fpNome                   := 'UNICRED';
   fpNumero                 := 136;
   fpTamanhoMaximoNossoNum  := 10;
   fpTamanhoAgencia         := 4;
   fpTamanhoConta           := 10;
   fpTamanhoCarteira        := 2;
   fpCodParametroMovimento  := '000';
   fpModuloMultiplicadorFinal := 9;
end;

function TACBrBancoUnicredES.MontarCampoNossoNumero (
   const ACBrTitulo: TACBrTitulo ) : String;
begin
   Result := ACBrTitulo.NossoNumero + '-'+ CalcularDigitoVerificador(ACBrTitulo);
end;

procedure TACBrBancoUnicredES.GerarRegistroTransacao400(ACBrTitulo :TACBrTitulo; aRemessa: TStringList);
var
  sDigitoNossoNumero, sAgencia : String;
  sTipoSacado, sConta, sProtesto    : String;
  sCarteira, sLinha, sNossoNumero, sTipoMulta : String;
begin

  with ACBrTitulo do
  begin
    ValidaNossoNumeroResponsavel(sNossoNumero, sDigitoNossoNumero, ACBrTitulo);

    sAgencia      := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Agencia), 0), 5);
    sConta        := IntToStrZero(StrToIntDef(OnlyNumber(ACBrBoleto.Cedente.Conta)  , 0), 7);
    sCarteira     := IntToStrZero(StrToIntDef(trim(Carteira), 0), 3);

    sTipoSacado := DefineTipoSacado(ACBrTitulo);

    {Pegando campo Intru��es}
    sProtesto:= InstrucoesProtesto(ACBrTitulo);

    with ACBrBoleto do
    begin

       sTipoMulta := IfThen( PercentualMulta > 0, CodMultaToStr(CodigoMulta), '3');

       sLinha:= '1'                                                           +{ 001 a 001  	Identifica��o do Registro }
                sAgencia                                                      +{ 002 a 006  	Ag�ncia do BENEFICI�RIO na UNICRED }
                Cedente.AgenciaDigito                                         +{ 007 a 007  	D�gito da Ag�ncia  	001 }
                PadLeft(sConta, 12, '0')                                      +{ 008 a 019  	Conta Corrente  	012 }
                Cedente.ContaDigito                                           +{ 020 a 020  	D�gito da Conta Corrente  	001 }
                '0'                                                           +{ 021 a 021  	Zero  	001  	Zero }
                sCarteira                                                     +{ 022 a 024  	C�digo da Carteira  	003 }
                StringOfChar('0', 13)                                         +{ 025 a 037  	Zeros	013  	Zeros }
                PadRight(ACBrTitulo.SeuNumero, 25, ' ')                       +{ 038 a 062	  N� Controle do Participante (Uso da empresa) 	025 }
                '136'                                                         +{ 063 a 065	  C�digo do Banco na C�mara de Compensa��o	003	136 }
                StringOfChar('0', 2)                                          +{ 066 a 067	  Zeros	002	Zeros }
                Space(25)                                                     +{ 068 a 092	  Branco	025	Branco}
                '0'                                                           +{ 093 a 093	  Filler	001	Zeros}
                sTipoMulta                                                    +{ 094 a 094	  C�digo da Multa	001}
                IntToStrZero(Round(PercentualMulta * 100), 10)                +{ 095 a 104	  Valor/Percentual da Multa	010 }
                CodJurosToStr(CodigoMoraJuros,ValorMoraJuros)                 +{ 105 a 105	  Tipo de Valor Mora	001}
                '0'                                                           +{ 106 a 106	  Filler	001 }
                Space(2)                                                      +{ 107 a 108	  Branco	002	Branco }
                TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo)           +{ 109 a 110	  Identifica��o da Ocorr�ncia	002 }
                PadRight(ACBrTitulo.SeuNumero, 10)                            +{ 111 a 120	  N� do Documento (Seu n�mero)	010 }
                FormatDateTime( 'ddmmyy', Vencimento)                         +{ 121 a 126	  Data de vencimento do T�tulo	006 }
                IntToStrZero(Round(ValorDocumento * 100 ), 13)                +{ 127 a 139	  Valor do T�tulo	013 }
                StringOfChar('0', 3)                                          +{ 140 a 142	  Filler	003}
                StringOfChar('0', 5)                                          +{ 143 a 147	  Filler	005	Zeros}
                StringOfChar('0', 2)                                          +{ 148 a 149	  Filler	002	Zeros}
                CodDescontoToStr(CodigoDesconto)                              +{ 150 a 150	  C�digo do desconto	001}
                FormatDateTime('ddmmyy', DataDocumento)                       +{ 151 a 156	  Data de emiss�o do T�tulo	006 }
                sProtesto                                                     +{ 157 a 160	  Filler	004 }
                IntToStrZero(Round(ValorMoraJuros * 100), 13)                 +{ 161 a 173  	Valor de Mora  	013 }
                IfThen(DataDesconto < EncodeDate(2000,01,01), '000000',
                       FormatDateTime('ddmmyy', DataDesconto))                +{ 174 a 179  	Data Limite P/Concess�o de Desconto  	006 }
                IntToStrZero(Round(ValorDescontoAntDia * 100), 13)            +{ 180 a 192  	Valor do Desconto  	013 }
                PadLeft(sNossoNumero + sDigitoNossoNumero, 11, '0')           +{ 193 a 203  	Nosso N�mero na UNICRED  	011 }
                StringOfChar('0', 2)                                          +{ 204 a 205  	Zeros  	002 }
                ifthen(TipoOcorrenciaToCodRemessa(OcorrenciaOriginal.Tipo) <> '04',
                       StringOfChar('0', 13),
                       IntToStrZero(Round(ValorAbatimento * 100), 13))        +{ 206 a 218  	Valor do Abatimento a ser concedido   	013 }
                sTipoSacado                                                   +{ 219 a 220	  Tipo de inscri��o do Pagador 01 � CPF 02 - CNPJ }
                PadLeft(OnlyNumber(Sacado.CNPJCPF), 14, '0')                  +{ 221 a 234  	N� Inscri��o do Pagador  	014 }
                PadRight(Sacado.NomeSacado, 40, ' ')                          +{ 235 a 274  	Nome/Raz�o Social do Pagador  	040   }
                PadRight(Sacado.Logradouro + ' ' + Sacado.Numero, 40)         +{ 275 a 314  	Endere�o do Pagador  	040 }
                PadRight(Sacado.Bairro, 12, ' ')                              +{ 315 a 326  	Bairro do Pagador  	012 }
                PadRight(Sacado.CEP, 8, ' ')                                  +{ 327 a 334  	CEP do Pagador  	008 }
                PadRight(Sacado.Cidade, 20, ' ')                              +{ 335 a 354  	Cidade do Pagador  	020 }
                PadRight(Sacado.UF, 2, ' ')                                   +{ 355 a 356  	UF do Pagador  	002 }
                Space(38)                                                     +{ 357 a 394  	Pagador/Avalista   	038 }
                IntToStrZero(aRemessa.Count + 1, 6)                           ;{ 395 a 400  	N� Sequencial do Registro  	006  	N� Sequencial do Registro }

       aRemessa.Add(UpperCase(sLinha));
    end;
  end;
end;

function TACBrBancoUnicredES.CodDescontoToStr(
  const pCodigoDesconto: TACBrCodigoDesconto): String;
begin
  case pCodigoDesconto of
    cdValorFixo : Result := '1';
  else
    Result := '0';
  end;
end;

function TACBrBancoUnicredES.DefineNumeroDocumentoModulo(
  const ACBrTitulo: TACBrTitulo): String;
begin
  Result:= ACBrTitulo.NossoNumero;
end;

function TACBrBancoUnicredES.CodJurosToStr(const pCodigoJuros : TACBrCodigoJuros; ValorMoraJuros : Currency): String;
begin
  if ValorMoraJuros = 0 then
    result := '5'
  else
  begin
    case pCodigoJuros of
      cjValorDia: result := '1';
      cjTaxaMensal: result := '2';
      cjValorMensal: result := '3';
      cjTaxaDiaria: result := '4';
    else
      result := '5';
    end;
  End;
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

end.


