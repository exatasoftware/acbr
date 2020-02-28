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
|* --/--/2015: Juliomar Marchetti
|*  - Cria��o.
|* 12/08/2015: Isaque Pinheiro
|*  - Distribui��o da primeira vers�o.
|* 18/08/2015: Ariel Guareschi
|*  - Alterado a gera��o do arquivo.
|* 19/08/2015: Lutzem Massao Aihara
|*  - Reestrurada a gera��o do arquivo e implementado fun��es "RegistroJXXXNew".
|* 11/09/2015 - Ariel Guareschi - Identar no padrao utilizado pela ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_J_Class;

interface

uses
  SysUtils, Classes, DateUtils, ACBrSped, ACBrECFBloco_J, ACBrECFBlocos,
  ACBrECFBloco_0_Class;

type
  /// TBloco_J -
  TBloco_J = class(TACBrSPED)
  private
    FBloco_0: TBloco_0;

    FRegistroJ001: TRegistroJ001; /// BLOCO J - RegistroJ001
    FRegistroJ990: TRegistroJ990; /// BLOCO J - RegistroJ990

    FRegistroJ050Count: Integer;
    FRegistroJ051Count: Integer;
    FRegistroJ053Count: Integer;
    FRegistroJ100Count: Integer;

    procedure WriteRegistroJ050(RegJ001: TRegistroJ001);
    procedure WriteRegistroJ051(RegJ050: TRegistroJ050);
    procedure WriteRegistroJ053(RegJ050: TRegistroJ050);
    procedure WriteRegistroJ100(RegJ001: TRegistroJ001);

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;           /// Create
    destructor Destroy; override; /// Destroy
    procedure LimpaRegistros; override;

    function RegistroJ001New: TRegistroJ001;
    function RegistroJ050New: TRegistroJ050;
    function RegistroJ051New: TRegistroJ051;
    function RegistroJ053New: TRegistroJ053;
    function RegistroJ100New: TRegistroJ100;

    procedure WriteRegistroJ001;
    procedure WriteRegistroJ990;

    property Bloco_0: TBloco_0 read FBloco_0 write FBloco_0;
    property RegistroJ001: TRegistroJ001 read FRegistroJ001 write FRegistroJ001;
    property RegistroJ990: TRegistroJ990 read FRegistroJ990 write FRegistroJ990;

    property RegistroJ050Count: Integer read FRegistroJ050Count write FRegistroJ050Count;
    property RegistroJ051Count: Integer read FRegistroJ051Count write FRegistroJ051Count;
    property RegistroJ053Count: Integer read FRegistroJ053Count write FRegistroJ053Count;
    property RegistroJ100Count: Integer read FRegistroJ100Count write FRegistroJ100Count;
  end;

implementation

{ TBloco_J }

constructor TBloco_J.Create;
begin
  inherited;
  CriaRegistros;
end;

destructor TBloco_J.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TBloco_J.CriaRegistros;
begin
  FRegistroJ001 := TRegistroJ001.Create;
  FRegistroJ990 := TRegistroJ990.Create;

  FRegistroJ050Count := 0;
  FRegistroJ051Count := 0;
  FRegistroJ053Count := 0;
  FRegistroJ100Count := 0;

  FRegistroJ990.QTD_LIN := 0;
end;


procedure TBloco_J.LiberaRegistros;
begin
  FRegistroJ001.Free;
  FRegistroJ990.Free;
end;

procedure TBloco_J.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

function TBloco_J.RegistroJ001New: TRegistroJ001;
begin
  Result := FRegistroJ001;
end;

function TBloco_J.RegistroJ050New: TRegistroJ050;
begin
  Result := FRegistroJ001.RegistroJ050.New();
end;

function TBloco_J.RegistroJ051New: TRegistroJ051;
var
  UJ050: TRegistroJ050;
  UJ050Count: Integer;
begin
  UJ050Count := FRegistroJ001.RegistroJ050.Count -1;
  if UJ050Count = -1 then
    raise Exception.Create('O registro J051 deve ser filho do registro J050, e n�o existe nenhum J050 pai!');

  UJ050  := FRegistroJ001.RegistroJ050.Items[UJ050Count];
  Result := UJ050.RegistroJ051.New(UJ050);
end;

function TBloco_J.RegistroJ053New: TRegistroJ053;
var
  UJ050: TRegistroJ050;
  UJ050Count: Integer;
begin
   UJ050Count := FRegistroJ001.RegistroJ050.Count -1;
   if UJ050Count = -1 then
      raise Exception.Create('O registro J053 deve ser filho do registro J050, e n�o existe nenhum J050 pai!');

   UJ050  := FRegistroJ001.RegistroJ050.Items[UJ050Count];
   Result := UJ050.RegistroJ053.New(UJ050);
end;

function TBloco_J.RegistroJ100New: TRegistroJ100;
begin
   Result := FRegistroJ001.RegistroJ100.New(FRegistroJ001);
end;

procedure TBloco_J.WriteRegistroJ001;
begin
  if Assigned(RegistroJ001) then
  begin
    with RegistroJ001 do
    begin
      Check(((IND_DAD = idComDados) or (IND_DAD = idSemDados)), '(J-J001) Na abertura do bloco, deve ser informado o n�mero 0 ou 1!');

      Add(LFill('J001') +
          LFill( Integer(IND_DAD), 1));

      if (IND_DAD = idComDados) then
      begin
        WriteRegistroJ050(RegistroJ001);
        WriteRegistroJ100(RegistroJ001);
      end;

      FRegistroJ990.QTD_LIN:= FRegistroJ990.QTD_LIN + 1;
    end;
  end;
end;


procedure TBloco_J.WriteRegistroJ050(RegJ001: TRegistroJ001);
var
  intFor: integer;
begin
  if Assigned(RegJ001.RegistroJ050) then
  begin
    for intFor := 0 to RegJ001.RegistroJ050.Count - 1 do
    begin
      with RegJ001.RegistroJ050.Items[intFor] do
      begin
        Add( LFill('J050') +
             LFill(DT_ALT) +
             LFill(COD_NAT, 2) +
             LFill(IND_CTA, 1) +
             LFill(NIVEL) +
             LFill(COD_CTA) +
             LFill(COD_CTA_SUP) +
             LFill(CTA) );

      end;

      WriteRegistroJ051(RegJ001.RegistroJ050.Items[intFor] );
      WriteRegistroJ053(RegJ001.RegistroJ050.Items[intFor] );

      RegistroJ990.QTD_LIN := RegistroJ990.QTD_LIN + 1;
    end;

    FRegistroJ050Count := FRegistroJ050Count + RegJ001.RegistroJ050.Count;
  end;

end;

procedure TBloco_J.WriteRegistroJ051(RegJ050: TRegistroJ050);
var
  intFor: integer;
begin
  if Assigned(RegJ050.RegistroJ051) then
  begin
    for intFor := 0 to RegJ050.RegistroJ051.Count - 1 do
    begin
      with RegJ050.RegistroJ051.Items[intFor] do
      begin
        Add( LFill('J051') +
             LFill(COD_CCUS) +
             LFill(COD_CTA_REF) );
      end;

      FRegistroJ990.QTD_LIN := FRegistroJ990.QTD_LIN + 1;
    end;

    FRegistroJ051Count := FRegistroJ051Count + RegJ050.RegistroJ051.Count;
  end;
end;

procedure TBloco_J.WriteRegistroJ053(RegJ050: TRegistroJ050);
var
  intFor: integer;
begin
  if Assigned(RegJ050.RegistroJ053) then
  begin
    for intFor := 0 to RegJ050.RegistroJ053.Count - 1 do
    begin
      with RegJ050.RegistroJ053.Items[intFor] do
      begin
        Add( LFill('J053') +
             LFill(COD_IDT) +
             LFill(COD_CNT_CORR) +
             LFill(NAT_SUB_CNT) );
      end;

      FRegistroJ990.QTD_LIN := FRegistroJ990.QTD_LIN + 1;
    end;

    FRegistroJ053Count := FRegistroJ053Count + RegJ050.RegistroJ053.Count;
  end;
end;

procedure TBloco_J.WriteRegistroJ100(RegJ001: TRegistroJ001);
var
  intFor: integer;
begin
  if Assigned(RegJ001.RegistroJ100) then
  begin
    for intFor := 0 to RegJ001.RegistroJ100.Count - 1 do
    begin
      with RegJ001.RegistroJ100.Items[intFor] do
      begin
        Add( LFill('J100') +
             LFill(DT_ALT) +
             LFill(COD_CCUS) +
             LFill(CCUS) );
      end;

      FRegistroJ990.QTD_LIN := FRegistroJ990.QTD_LIN + 1;
    end;

    FRegistroJ100Count := FRegistroJ100Count + RegJ001.RegistroJ100.Count;
  end;
end;


procedure TBloco_J.WriteRegistroJ990;
begin
  if Assigned(FRegistroJ990) then
  begin
    with FRegistroJ990 do
    begin
      QTD_LIN := QTD_LIN + 1;
      ///
      Add( LFill('J990') +
           LFill(QTD_LIN, 0) );
    end;
  end;
end;

end.
