{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Macgayver Armini Apolonio e Rodrigo Buschmann   }
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

unit ACBrEFDBloco_D_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEFDBase,
  ACBrUtil, ACBrSpedFiscal, ACBrEFDBlocos;

type
  TACBrSpedFiscalImportar_BlocoD = class(TACBrSpedFiscalImportar_Base)
  private
  public
    procedure RegD001;
    procedure RegD100;
    procedure RegD190;
    procedure RegD300;
    procedure RegD350;
    procedure RegD500;
    procedure RegD590;
    procedure RegD600;
    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

{ TACBrSpedFiscalImportar_BlocoD }

procedure TACBrSpedFiscalImportar_BlocoD.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'D001') then
    RegD001
  else if (vHead = 'D100') then
    RegD100
  else if (vHead = 'D190') then
    RegD190
  else if (vHead = 'D300') then
    RegD300
  else if (vHead = 'D350') then
    RegD350
  else if (vHead = 'D500') then
    RegD500
  else if (vHead = 'D590') then
    RegD590
  else if (vHead = 'D600') then
    RegD600;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD001;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD100;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD100New do
  begin
    IND_OPER := StrToIndOper(Valor);
    IND_EMIT := StrToIndEmit(Valor);
    COD_PART := Valor;
    COD_MOD := Valor;
    COD_SIT := StrToCodSit(Valor);
    SER := Valor;
    SUB := Valor;
    NUM_DOC := Valor;
    CHV_CTE := Valor;
    DT_DOC := ValorD;
    DT_A_P := ValorD;
    TP_CT_e := Valor;
    CHV_CTE_REF := Valor;
    VL_DOC := ValorF;
    VL_DESC := ValorF;
    IND_FRT := StrToIndFrt(Valor);
    VL_SERV := ValorF;
    VL_BC_ICMS := ValorF;
    VL_ICMS := ValorF;
    VL_NT := ValorF;
    COD_INF := Valor;
    COD_CTA := Valor;
    COD_MUN_ORIG := Valor;
    COD_MUN_DEST := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD190;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD190New do
  begin
    CST_ICMS := Valor;
    CFOP := Valor;
    ALIQ_ICMS := ValorF;
    VL_OPR := ValorF;
    VL_BC_ICMS := ValorF;
    VL_ICMS := ValorF;
    VL_RED_BC := ValorF;
    COD_OBS := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD300;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD300New do
  begin
    COD_MOD := Valor;
    SER := Valor;
    SUB := Valor;
    NUM_DOC_INI := Valor;
    NUM_DOC_FIN := Valor;
    CST_ICMS := Valor;
    CFOP := Valor;
    ALIQ_ICMS := ValorF;
    DT_DOC := ValorD;
    VL_OPR := ValorF;
    VL_DESC := ValorF;
    VL_SERV := ValorF;
    VL_SEG := ValorF;
    VL_OUT_DESP := ValorF;
    VL_BC_ICMS := ValorF;
    VL_ICMS := ValorF;
    VL_RED_BC := ValorF;
    COD_OBS := Valor;
    COD_CTA := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD350;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD350New do
  begin
    COD_MOD := Valor;
    ECF_MOD := Valor;
    ECF_FAB := Valor;
    ECF_CX := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD500;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD500New do
  begin
    IND_OPER := StrToIndOper(Valor);
    IND_EMIT := StrToIndEmit(Valor);
    COD_PART := Valor;
    COD_MOD := Valor;
    COD_SIT := StrToCodSit(Valor);
    SER := Valor;
    SUB := Valor;
    NUM_DOC := Valor;
    DT_DOC := ValorD;
    DT_A_P := ValorD;
    VL_DOC := ValorF;
    VL_DESC := ValorF;
    VL_SERV := ValorF;
    VL_SERV_NT := ValorF;
    VL_TERC := ValorF;
    VL_DA := ValorF;
    VL_BC_ICMS := ValorF;
    VL_ICMS := ValorF;
    COD_INF := Valor;
    VL_PIS := ValorF;
    VL_COFINS := ValorF;
    COD_CTA := Valor;
    TP_ASSINANTE := StrToTpAssinante(Valor);
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD590;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD590New do
  begin
    CST_ICMS      := Valor;
    CFOP          := Valor;
    ALIQ_ICMS     := ValorF;
    VL_OPR        := ValorF;
    VL_BC_ICMS    := ValorF;
    VL_ICMS       := ValorF;
    VL_BC_ICMS_UF := ValorF;
    VL_ICMS_UF    := ValorF;
    VL_RED_BC     := ValorF;
    COD_OBS       := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoD.RegD600;
begin
  with ACBrSpedFiscal.Bloco_D.RegistroD600New do
  begin
{     COD_MOD := Valor;
     COD_MUN := Valor;
     SER := Valor;
     SUB := Valor;
     COD_CONS := Valor;
     QTD_CONS := ValorF;
     DT_DOC := ValorF;
     VL_DOC := ValorF;
     VL_DESC := ValorF;
     VL_SERV :=ValorF;
     VL_SERV_NT := ValorF;
     VL_TERC := ValorF;
     VL_DA := ValorF;
     VL_BC_ICMS := ValorF;
     VL_ICMS := ValorF;
     VL_PIS := ValorF;
     VL_COFINS := ValorF;
 } end;
end;


end.
