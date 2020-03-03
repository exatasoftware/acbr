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
unit ACBrPAF_U_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrTXTUtils,
     ACBrPAF_U;

type

  { TPAF_U }

  TPAF_U = class(TACBrTXTClass)
  private
    FRegistroU1: TRegistroU1;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override; 
    procedure LimpaRegistros;
    
    procedure WriteRegistroU1;

    property RegistroU1: TRegistroU1 read FRegistroU1 write FRegistroU1;
  end;
  
implementation

{ TPAF_U }
constructor TPAF_U.Create;
begin
  inherited;
  CriaRegistros;
end;

procedure TPAF_U.CriaRegistros;
begin
  FRegistroU1 := TRegistroU1.Create;
end;

destructor TPAF_U.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPAF_U.LiberaRegistros;
begin
  FRegistroU1.Free;
end;

procedure TPAF_U.LimpaRegistros;
begin
  //Limpa os Registros
  LiberaRegistros;
  //Recriar os Registros Limpos
  CriaRegistros;
end;

procedure TPAF_U.WriteRegistroU1;
begin
  if Assigned(FRegistroU1) then
  begin
    with FRegistroU1 do
    begin
      Check(funChecaCNPJ(CNPJ), '(U1) ESTABELECIMENTO: O CNPJ "%s" digitado � inv�lido!', [CNPJ]);

      Add(LFill('U1') +
          LFill(CNPJ, 14) +
          RFill(IE, 14) +
          RFill(IM, 14) +
          RFill(RAZAOSOCIAL, 50, ifThen(not InclusaoExclusao, ' ', '?')));
    end;
  end;
end;

end.
