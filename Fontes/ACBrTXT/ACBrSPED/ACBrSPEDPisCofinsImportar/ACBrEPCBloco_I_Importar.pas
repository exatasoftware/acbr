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


unit ACBrEPCBloco_I_Importar;

interface

uses
  Classes,
  SysUtils,

  ACBrEPCBase,
  ACBrUtil, ACBrSpedPisCofins, ACBrEPCBlocos;

type
  TACBrSpedPCImportar_BlocoI = class(TACBrSpedPCImportar_Base)
  private
  public
    procedure RegI001;
    procedure RegI010;
    procedure RegI100;
    procedure RegI199;
    procedure RegI200;
    procedure RegI299;
    procedure RegI300;
    procedure RegI399;

    procedure AnalisaRegistro(const inDelimitador: TStrings); override;
  end;

implementation

{ TACBrSpedPCImportar_BlocoI }

procedure TACBrSpedPCImportar_BlocoI.AnalisaRegistro(const inDelimitador: TStrings);
var
  vHead: string;
begin
  inherited;
  vHead := Head;
  if (vHead = 'I001') then
    RegI001
  else if (vHead = 'I010') then
    RegI010
  else if (vHead = 'I100') then
    RegI100
  else if (vHead = 'I199') then
    RegI199
  else if (vHead = 'I200') then
    RegI200
  else if (vHead = 'I299') then
    RegI299
  else if (vHead = 'I300') then
    RegI300
  else if (vHead = 'I399') then
    RegI399;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI001;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI001New do
  begin
    IND_MOV := StrToIndMov(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI010;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI010New do
  begin
    CNPJ := Valor;
    INFO_COMPL := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI100;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI100New do
  begin
    VL_REC := ValorF;
    CST_PIS_COFINS := StrToCstPisCofins(Valor);
    VL_TOT_DED_GER := ValorF;
    VL_TOT_DED_ESP := ValorF;
    VL_BC_PIS := ValorF;
    ALIQ_PIS := ValorF;
    VL_PIS := ValorF;
    VL_BC_COFINS := ValorF;
    ALIQ_COFINS := ValorF;
    VL_COFINS := ValorF;
    INFO_COMPL := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI199;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI199New do
  begin
    NUM_PROC := Valor;
    IND_PROC := StrToOrigemProcesso(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI200;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI200New do
  begin
    NUM_CAMPO := Valor;
    COD_DET := Valor;
    DET_VALOR := ValorF;
    COD_CTA := Valor;
    INFO_COMPL := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI299;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI299New do
  begin
    NUM_PROC := Valor;
    IND_PROC := StrToOrigemProcesso(Valor);
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI300;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI300New do
  begin
    COD_COMP := Valor;
    DET_VALOR := ValorF;
    COD_CTA := Valor;
    INFO_COMPL := Valor;
  end;
end;

procedure TACBrSpedPCImportar_BlocoI.RegI399;
begin
  with ACBrSpedPisCofins.Bloco_I.RegistroI399New do
  begin
    NUM_PROC := Valor;
    IND_PROC := StrToOrigemProcesso(Valor);
  end;
end;

end.
