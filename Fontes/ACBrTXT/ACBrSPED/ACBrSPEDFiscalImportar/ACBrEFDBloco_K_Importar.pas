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

unit ACBrEFDBloco_K_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEFDBase,
  ACBrUtil, ACBrSpedFiscal, ACBrEFDBlocos;

type
  TACBrSpedFiscalImportar_BlocoK = class(TACBrSpedFiscalImportar_Base)
  private
    procedure RegK001;
    procedure RegK100;
    procedure RegK200;
    procedure RegK990;
  public
    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

procedure TACBrSpedFiscalImportar_BlocoK.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'K001') then RegK001
  else if (vHead = 'K100') then RegK100
  else if (vHead = 'K200') then RegK200
  else if (vHead = 'K990') then RegK990;
end;


// abertura do bloco K
procedure TACBrSpedFiscalImportar_BlocoK.RegK001;
begin
  with ACBrSpedFiscal.Bloco_K.RegistroK001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;


procedure TACBrSpedFiscalImportar_BlocoK.RegK100;
begin
  with ACBrSpedFiscal.Bloco_K.RegistroK100New do
  begin
    DT_INI := ValorD;
    DT_FIN := ValorD;
  end;
end;

// dados do inventario
procedure TACBrSpedFiscalImportar_BlocoK.RegK200;
begin
  with ACBrSpedFiscal.Bloco_K.RegistroK200New do
  begin
    DT_EST      := ValorD;
    COD_ITEM    := Valor;
    QTD         := ValorF;
    IND_EST     := StrToIndEst( Valor );
    COD_PART    := Valor;
  end;
end;

procedure TACBrSpedFiscalImportar_BlocoK.RegK990;
begin
  with ACBrSpedFiscal.Bloco_K.RegistroK990 do
  begin
    QTD_LIN_K := ValorI;
  end;
end;

end.
