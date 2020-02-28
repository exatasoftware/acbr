{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Macgayver Armini Apolonio                       }
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

unit ACBrEPCBloco_A_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEPCBase,
  ACBrUtil, ACBrSpedPisCofins, ACBrEPCBlocos;

type
  TACBrSpedPCImportar_BlocoA = class(TACBrSpedPCImportar_Base)
  private
  public
    procedure RegA001;
    procedure RegA010;
    procedure RegA100;
    procedure RegA110;
    procedure RegA111;
    procedure RegA120;
    procedure RegA170;

    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

{ TACBrSpedPCImportar_BlocoA }

procedure TACBrSpedPCImportar_BlocoA.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'A001') then
    RegA001
  else if (vHead = 'A010') then
    RegA010
  else if (vHead = 'A100') then
    RegA100
  else if (vHead = 'A110') then
    RegA110
  else if (vHead = 'A111') then
    RegA111
  else if (vHead = 'A120') then
    RegA120
  else if (vHead = 'A170') then
    RegA170;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA001;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA010;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA010New do
  begin
    CNPJ := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA100;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA100New do
  begin
    IND_OPER := StrToIndOper(Valor);
    IND_EMIT := StrToIndEmit(Valor);
    COD_PART := Valor;
    COD_SIT := StrToCodSit(Valor);
    SER := Valor;
    SUB := Valor;
    NUM_DOC := Valor;
    CHV_NFSE := Valor;
    DT_DOC := ValorD;
    DT_EXE_SERV := ValorD;
    VL_DOC := ValorF;
    IND_PGTO := StrToIndPgto(Valor);
    VL_DESC := ValorF;
    VL_BC_PIS := ValorF;
    VL_PIS := ValorF;
    VL_BC_COFINS := ValorF;
    VL_COFINS := ValorF;
    VL_PIS_RET := ValorF;
    VL_COFINS_RET := ValorF;
    VL_ISS := ValorF;
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA110;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA110New do
  begin
    COD_INF := Valor;
    TXT_COMPL := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA111;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA111New do
  begin
    NUM_PROC := Valor;
    IND_PROC := StrToOrigemProcesso(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA120;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA120New do
  begin
    VL_TOT_SERV := ValorF;
    VL_BC_PIS := ValorF;
    VL_PIS_IMP := ValorF;
    DT_PAG_PIS := ValorD;
    VL_BC_COFINS := ValorF;
    VL_COFINS_IMP := ValorF;
    DT_PAG_COFINS := ValorD;
    LOC_EXE_SERV := StrToLocalExecServico(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoA.RegA170;
begin
  with ACBrSpedPisCofins.Bloco_A.RegistroA170New do
  begin
    NUM_ITEM := ValorI;
    COD_ITEM := Valor;
    DESCR_COMPL := Valor;
    VL_ITEM := ValorF;
    VL_DESC := ValorF;
    NAT_BC_CRED := StrToNatBcCred(Valor);
    IND_ORIG_CRED := StrToIndOrigCred(Valor);
    CST_PIS := StrToCstPis(Valor);
    VL_BC_PIS := ValorF;
    ALIQ_PIS := ValorF;
    VL_PIS := ValorF;
    CST_COFINS := StrToCstCofins(Valor);
    VL_BC_COFINS := ValorF;
    ALIQ_COFINS := ValorF;
    VL_COFINS := ValorF;
    COD_CTA := Valor;
    COD_CCUS := Valor;
  end;
end;

end.
