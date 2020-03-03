{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrPAF_L_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass,
     ACBrPAF_L;

type

  { TPAF_L }

  TPAF_L = class(TACBrTXTClass)
  private
    FRegistroL2: TRegistroL2List;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LimpaRegistros;

    procedure WriteRegistroL2;

    property RegistroL2: TRegistroL2List read FRegistroL2 write FRegistroL2;
  end;

implementation

{ TPAF_L }
constructor TPAF_L.Create;
begin
  inherited;
  CriaRegistros;
end;

procedure TPAF_L.CriaRegistros;
begin
  FRegistroL2 := TRegistroL2List.Create;
end;

destructor TPAF_L.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_L.LiberaRegistros;
begin
  FRegistroL2.Free;
end;

procedure TPAF_L.LimpaRegistros;
begin
  //Limpa os Registros
  LiberaRegistros;
  //Recriar os Registros Limpos
  CriaRegistros;
end;

function OrdenarL2(const ARegistro1, ARegistro2: Pointer): Integer;
var
  Reg1, Reg2: String;
begin
  Reg1 :=
    TRegistroL2(ARegistro1).CNPJ +
    Format('%-8s', [TRegistroL2(ARegistro1).ID_LINHA]) +
    FormatDateTime('yyyymmddhhmmss', TRegistroL2(ARegistro1).DT_VIA) +
    Format('%-20s', [TRegistroL2(ARegistro1).NUM_FAB]) +
    Format('%6.6d', [TRegistroL2(ARegistro1).GNF]) +
    Format('%6.6d', [TRegistroL2(ARegistro1).GRG]) +
    Format('%6.6d', [TRegistroL2(ARegistro1).COO]);

  Reg2 :=
    TRegistroL2(ARegistro2).CNPJ +
    Format('%-8s', [TRegistroL2(ARegistro2).ID_LINHA]) +
    FormatDateTime('yyyymmddhhmmss', TRegistroL2(ARegistro2).DT_VIA) +
    Format('%-20s', [TRegistroL2(ARegistro2).NUM_FAB]) +
    Format('%6.6d', [TRegistroL2(ARegistro2).GNF]) +
    Format('%6.6d', [TRegistroL2(ARegistro2).GRG]) +
    Format('%6.6d', [TRegistroL2(ARegistro2).COO]);

  Result := AnsiCompareText(Reg1, Reg2);
end;

procedure TPAF_L.WriteRegistroL2;
var
  intFor: integer;
begin
  if Assigned(FRegistroL2) then
  begin
    FRegistroL2.Sort(@OrdenarL2);

    for intFor := 0 to FRegistroL2.Count - 1 do
    begin
      with FRegistroL2.Items[intFor] do
      begin
        Add( LFill('L2') +
             LFill(CNPJ, 14) +
             RFill(IE, 14) +
             RFill(IM, 14) +
             RFill(NUM_FAB, 20) +
             RFill(MF_ADICIONAL, 1) +
             RFill(TIPO_ECF, 7) +
             RFill(MARCA_ECF, 20) +
             RFill(MODELO_ECF, 20) +
             LFill(NUM_USU, 2) +
             LFill(COO, 6) +
             LFill(GNF, 6) +
             LFill(GRG, 6) +
             LFill(DT_EMI, 'yyyymmddhhmmss') +
             LFill(COD_MOD, 2) +
             LFill(COD_CAT, 2) +
             RFill(ID_LINHA, 8) +
             RFill(COD_ORIG, 20) +
             RFill(COD_DEST, 20) +
             LFill(COD_TSER, 2) +
             LFill(DT_VIA, 'yyyymmddhhmmss') +
             LFill(TIP_VIA, 2) +
             LFill(POLTRONA, 7) +
             RFill(PLATAFORMA,15) +
             LFill(COD_DESC, 2) +
             LFill(VL_TARIFA, 8, 2) +
             LFill(VL_PEDAGIO, 8, 2) +
             LFill(VL_TAXA, 8, 2) +
             LFill(VL_TOTAL, 8, 2) +
             LFill(FORM_PAG, 2) +
             LFill(VL_PAGO, 8, 2) +
             RFill(NOME_PAS, 50) +
             RFill(NDOC_PAS, 20) +
             RFill(SAC, 10) +
             RFill(AGENCIA, 30) );
      end;
    end;
  end;

end;

end.
 
