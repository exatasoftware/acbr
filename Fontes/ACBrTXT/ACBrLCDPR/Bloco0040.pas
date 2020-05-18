{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Willian H�bner e Elton Barbosa (EMBarbosa)      }
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
unit Bloco0040;

interface

uses Classes, Contnrs, Registro0040, Registro0045;

type
  TBloco0040 = Class
  private
    FBloco0040: TRegistro0040;
    FBloco0045: TRegistro0045List;
    procedure SetBloco0040(const Value: TRegistro0040);
    procedure SetBloco0045(const Value: TRegistro0045List);
  public
    constructor Create;
    Destructor Destroy; override;
    function Registro0045New : TRegistro0045;
    procedure AddRegistro0045(Registro0045 : TRegistro0045);
    property Bloco0040 : TRegistro0040 read FBloco0040 write SetBloco0040;
    property Bloco0045 : TRegistro0045List read FBloco0045 write SetBloco0045;
  end;

  TBloco0040List = class (TObjectList)
  private
    function GetItem(Index: Integer): TBloco0040;
    procedure SetItem(Index: Integer; const Value: TBloco0040);
  public
    function New: TBloco0040;
    property Items[Index: Integer]: TBloco0040 read GetItem write SetItem; default;
  end;

  TBlocos0040 = Class
  private
    FBlocos: TBloco0040List;
    procedure SetBlocos(const Value: TBloco0040List);
  public
    constructor Create;
    destructor Destroy; override;
    function Bloco0040New : TBloco0040;
    property Blocos : TBloco0040List read FBlocos write SetBlocos;
  End;

implementation

{ TBloco0040 }

procedure TBloco0040.AddRegistro0045(Registro0045: TRegistro0045);
var
  i : integer;
begin
  FBloco0045.Add(TRegistro0045.Create);
  I := FBloco0045.Count -1;
  FBloco0045[I].COD_IMOVEL       := Registro0045.COD_IMOVEL;
  FBloco0045[I].TIPO_CONTRAPARTE := Registro0045.TIPO_CONTRAPARTE;
  FBloco0045[I].ID_CONTRAPARTE  := Registro0045.ID_CONTRAPARTE;
  FBloco0045[I].NOME_CONTRAPARTE := Registro0045.NOME_CONTRAPARTE;
  FBloco0045[I].PERC_CONTRAPARTE := Registro0045.PERC_CONTRAPARTE;
end;

constructor TBloco0040.Create;
begin
  FBloco0040 := TRegistro0040.Create;
  FBloco0045 := TRegistro0045List.Create;
end;

destructor TBloco0040.Destroy;
begin
  FBloco0040.Free;
  FBloco0045.Free;
  inherited;
end;

function TBloco0040.Registro0045New: TRegistro0045;
begin
  Result := TRegistro0045.Create;

  Bloco0045.Add(Result);
end;

procedure TBloco0040.SetBloco0040(const Value: TRegistro0040);
begin
  FBloco0040 := Value;
end;

procedure TBloco0040.SetBloco0045(const Value: TRegistro0045List);
begin
  FBloco0045 := Value;
end;

{ TBlocos0040 }

constructor TBlocos0040.Create;
begin
  FBlocos := TBloco0040List.Create;
end;

destructor TBlocos0040.Destroy;
begin
  FBlocos.Destroy;
  inherited;
end;

function TBlocos0040.Bloco0040New: TBloco0040;
begin
  Result := Blocos.New;
end;

procedure TBlocos0040.SetBlocos(const Value: TBloco0040List);
begin
  FBlocos := Value;
end;

{ TBloco0040List }

function TBloco0040List.GetItem(Index: Integer): TBloco0040;
begin
  Result := TBloco0040(inherited GetItem(Index));

end;

procedure TBloco0040List.SetItem(Index: Integer; const Value: TBloco0040);
begin
  inherited SetItem(Index, Value);
end;

function TBloco0040List.New: TBloco0040;
begin
  Result := TBloco0040.Create;
  Self.Add(Result);
end;

end.
