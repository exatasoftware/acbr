{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti e Isaque Pinheiro            }
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

{******************************************************************************
|* Historico
|*
|* 11/09/2015 - Ariel Guareschi - Identar no padrao utilizado pela ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_Q_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_Q, ACBrECFBlocos,
  ACBrTXTClass, ACBrECFBloco_0_Class;

type
  { TBloco_Q }

  TBloco_Q = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;
    FRegistroQ001: TRegistroQ001;
    FRegistroQ990: TRegistroQ990;
    FRegistroQ100: TRegistroQ100List;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;

    procedure WriteRegistroQ001;
    procedure WriteRegistroQ100;
    procedure WriteRegistroQ990;

    constructor Create;
    destructor Destroy; override;
    procedure LimpaRegistros; override;

    function RegistroQ001New : TRegistroQ001;
    function RegistroQ100New : TRegistroQ100;

    property RegistroQ001: TRegistroQ001 read FRegistroQ001 write FRegistroQ001;
    property RegistroQ100: TRegistroQ100List read FRegistroQ100 write FRegistroQ100;
    property RegistroQ990: TRegistroQ990 read FRegistroQ990 write FRegistroQ990;
  end;


implementation

uses
  ACBrTXTUtils, StrUtils;

{ TBloco_Q }

constructor TBloco_Q.Create;
begin
  inherited;

  FRegistroQ001 := TRegistroQ001.Create;
  FRegistroQ100 := TRegistroQ100List.Create;
  FRegistroQ990 := TRegistroQ990.Create;
end;

procedure TBloco_Q.CriaRegistros;
begin
  inherited;

  FRegistroQ001 := TRegistroQ001.Create;
  FRegistroQ100 := TRegistroQ100List.Create;
  FRegistroQ990 := TRegistroQ990.Create;

  FRegistroQ990.QTD_LIN := 0;
end;

destructor TBloco_Q.Destroy;
begin
  FRegistroQ001.Free;
  FRegistroQ100.Free;
  FRegistroQ990.Free;

  inherited;
end;

procedure TBloco_Q.LiberaRegistros;
begin
  inherited;
  
  FRegistroQ001.Free;
  FRegistroQ100.Free;
  FRegistroQ990.Free;
end;

procedure TBloco_Q.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

function TBloco_Q.RegistroQ001New: TRegistroQ001;
begin
  Result := FRegistroQ001;
end;

function TBloco_Q.RegistroQ100New: TRegistroQ100;
begin
  Result := RegistroQ100.New;
  if FRegistroQ001.RegistroQ100=nil then
    FRegistroQ001.RegistroQ100:=TRegistroQ100List.Create;
  FRegistroQ001.RegistroQ100.Add(Result);
end;

procedure TBloco_Q.WriteRegistroQ001;
begin
  if Assigned(FRegistroQ001) then
  begin
    with FRegistroQ001 do
    begin
      Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(Q-Q001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');
      Add(LFill('Q001') +
          LFill( Integer(IND_DAD), 1));
      FRegistroQ990.QTD_LIN:= FRegistroQ990.QTD_LIN + 1;
      WriteRegistroQ100;
    end;
  end;
end;

procedure TBloco_Q.WriteRegistroQ100;
var
  intFor: integer;
begin
  if Assigned(FRegistroQ100) then
  begin
    for intFor := 0 to FRegistroQ100.Count - 1 do
    begin
      with FRegistroQ100.Items[intFor] do
      begin
        Add(LFill('Q100') +
            LFill(DATA) +
            LFill(NUM_DOC) +
            LFill(HIST) +
            LFill(VL_ENTRADA, 19, 2) +
            LFill(VL_SAIDA, 19, 2) +
            LFill(SLD_FIN, 19, 2));
      end;

      FRegistroQ990.QTD_LIN := FRegistroQ990.QTD_LIN + 1;
    end;
  end;
end;

procedure TBloco_Q.WriteRegistroQ990;
begin
  if Assigned(FRegistroQ990) then
  begin
    with FRegistroQ990 do
    begin
      QTD_LIN := QTD_LIN + 1;

      Add(LFill('Q990') +
          LFill(QTD_LIN, 0));
    end;
  end;
end;

end.

