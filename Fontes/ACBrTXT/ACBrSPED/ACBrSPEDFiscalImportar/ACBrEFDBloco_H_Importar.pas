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

unit ACBrEFDBloco_H_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEFDBase,
  ACBrUtil, ACBrSpedFiscal, ACBrEFDBlocos;

type
  TACBrSpedFiscalImportar_BlocoH = class(TACBrSpedFiscalImportar_Base)
  private
    procedure RegH001;
    procedure RegH005;
    procedure RegH010;
    procedure RegH020;
    procedure RegH990; 
  public
    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

procedure TACBrSpedFiscalImportar_BlocoH.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'H001') then RegH001
  else if (vHead = 'H005') then RegH005
  else if (vHead = 'H010') then RegH010
  else if (vHead = 'H020') then RegH020
  else if (vHead = 'H990') then RegH990;
end;


// abertura do bloco H
procedure TACBrSpedFiscalImportar_BlocoH.RegH001;
begin
  with ACBrSpedFiscal.Bloco_H.RegistroH001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

// dados totais do inventario
procedure TACBrSpedFiscalImportar_BlocoH.RegH005;
begin
  with ACBrSpedFiscal.Bloco_H.RegistroH005New do
  begin
    DT_INV := ValorD;
    VL_INV := ValorF;
    MOT_INV := StrToMotInv(Valor);
  end;
end;

// dados do inventario
procedure TACBrSpedFiscalImportar_BlocoH.RegH010;
begin
  with ACBrSpedFiscal.Bloco_H.RegistroH010New do
  begin
    COD_ITEM    := Valor;
    UNID        := Valor;
    QTD         := ValorF;
    VL_UNIT     := ValorF;
    VL_ITEM     := ValorF;
    IND_PROP    := StrToIndProp( Valor );
    COD_PART    := Valor;
    TXT_COMPL   := Valor;
    COD_CTA     := Valor;
    VL_ITEM_IR  := ValorF;
  end;
end;

// dados de informacoes complementares do invetario
procedure TACBrSpedFiscalImportar_BlocoH.RegH020;
begin
  with ACBrSpedFiscal.Bloco_H.RegistroH020New do
  begin
    CST_ICMS := Valor;
    BC_ICMS := ValorF;
    VL_ICMS := ValorF;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoH.RegH990;
begin
  with ACBrSpedFiscal.Bloco_H.RegistroH990 do
  begin
    QTD_LIN_H := ValorI;
  end;
end;

end.
