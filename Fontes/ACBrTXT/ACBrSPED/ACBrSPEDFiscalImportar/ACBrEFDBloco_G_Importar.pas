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

unit ACBrEFDBloco_G_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEFDBase,
  ACBrUtil, ACBrSpedFiscal, ACBrEFDBlocos;

type
  TACBrSpedFiscalImportar_BlocoG = class(TACBrSpedFiscalImportar_Base)
  private
    procedure RegG001;
    procedure RegG110;
    procedure RegG125;
    procedure RegG126;
    procedure RegG130;
    procedure RegG140;
    Procedure RegG990; 
  public
    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

procedure TACBrSpedFiscalImportar_BlocoG.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'G001') then RegG001
  else if (vHead = 'G110') then RegG110
  else if (vHead = 'G125') then RegG125
  else if (vHead = 'G126') then RegG126
  else if (vHead = 'G130') then RegG130
  else if (vHead = 'G140') then RegG140
  else if (vHead = 'G990') then RegG990;
end;

// abertura do bloco G
procedure TACBrSpedFiscalImportar_BlocoG.RegG001;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG110;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG110New do
  begin
    SALDO_IN_ICMS := ValorF;
    SOM_PARC     := ValorF;   
    VL_TRIB_EXP  := ValorF;
    VL_TOTAL     := ValorF;   
    IND_PER_SAI  := ValorF;
    ICMS_APROP   := ValorF; 
    SOM_ICMS_OC  := ValorF;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG125;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG125New do
  begin
    COD_IND_BEM      := Valor;         
    DT_MOV           := ValorD;           
    TIPO_MOV         := StrMovimentoBens(Valor);
    VL_IMOB_ICMS_OP  := ValorF;   
    VL_IMOB_ICMS_ST  := ValorF;   
    VL_IMOB_ICMS_FRT := ValorF;  
    VL_IMOB_ICMS_DIF := ValorF;  
    NUM_PARC         := ValorFV;
    VL_PARC_PASS     := ValorF;      
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG126;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG126New do
  begin
    DT_INI        := ValorD;
    DT_FIN        := ValorD;
    NUM_PARC      := ValorI;
    VL_PARC_PASS  := ValorF;
    VL_TRIB_OC    := ValorF;
    VL_TOTAL      := ValorF;
    IND_PER_SAI   := ValorF;
    VL_PARC_APROP := ValorF;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG130;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG130New do
  begin
    IND_EMIT    := StrToIndEmit(Valor);
    COD_PART    := Valor;      
    COD_MOD     := Valor;       
    SERIE       := Valor;
    NUM_DOC     := Valor;
    CHV_NFE_CTE := Valor;
    DT_DOC      := ValorD;
    NUM_DA      := Valor;        
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG140;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG140New do
  begin
    NUM_ITEM             := Valor;
    COD_ITEM             := Valor;
    QTDE                 := ValorF;
    UNID                 := valor;
    VL_ICMS_OP_APLICADO  := ValorF;
    VL_ICMS_ST_APLICADO  := ValorF;
    VL_ICMS_FRT_APLICADO := ValorF;
    VL_ICMS_DIF_APLICADO := ValorF;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoG.RegG990;
begin
  with ACBrSpedFiscal.Bloco_G.RegistroG990 do
  begin
    QTD_LIN_G := ValorI;
  end;
end;

end.
