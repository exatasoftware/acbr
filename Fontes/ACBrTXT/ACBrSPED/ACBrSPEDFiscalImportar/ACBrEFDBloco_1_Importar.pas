{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2010   Macgayver Armini Apolonio            }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{******************************************************************************
|* Hist�rico
|*
|* 15/09/2019: Marcelo Silva - Apollo Sistemas - Cria��o
*******************************************************************************}

unit ACBrEFDBloco_1_Importar;

interface

uses
  Classes,
  SysUtils,
  ACBrEFDBase,
  ACBrUtil,
  ACBrSpedFiscal,
  ACBrEFDBlocos;

type
  TACBrSpedFiscalImportar_Bloco1 = class(TACBrSpedFiscalImportar_Base)
  private
    procedure Reg1001;
    procedure Reg1010;
    procedure Reg1600;
  public
    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

{ TACBrSpedFiscalImportar_Bloco1 }

procedure TACBrSpedFiscalImportar_Bloco1.AnalisaRegistro(
  const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;

  vHead := Head;

  if vHead = '1001' then
    Reg1001
  else if vHead = '1010' then
    Reg1010
  else if vHead = '1600' then
    Reg1600;
end;

procedure TACBrSpedFiscalImportar_Bloco1.Reg1001;
begin
  with ACBrSpedFiscal.Bloco_1.Registro1001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

procedure TACBrSpedFiscalImportar_Bloco1.Reg1010;
begin
  with ACBrSpedFiscal.Bloco_1.Registro1010New do
  begin
    IND_EXP   := Valor;
    IND_CCRF  := Valor;
    IND_COMB  := Valor;
    IND_USINA := Valor;
    IND_VA    := Valor;
    IND_EE    := Valor;
    IND_CART  := Valor;
    IND_FORM  := Valor;
    IND_AER   := Valor;
    IND_GIAF1 := Valor;
    IND_GIAF3 := Valor;
    IND_GIAF4 := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_Bloco1.Reg1600;
begin
  with ACBrSpedFiscal.Bloco_1.Registro1600New do
  begin
    COD_PART    := Valor;
    TOT_CREDITO := ValorF;
    TOT_DEBITO  := ValorF;
  end;
end;

end.
