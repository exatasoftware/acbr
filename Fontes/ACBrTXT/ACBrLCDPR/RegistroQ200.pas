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
unit RegistroQ200;

interface

uses Classes, Contnrs;

type
  TRegistroQ200 = Class
  private
    FMES: String;
    FSLD_FIN: Double;
    FVL_SAIDA: Double;
    FVL_ENTRADA: Double;
    FNAT_SLD_FIN: String;
    procedure SetMES(const Value: String);
    procedure SetSLD_FIN(const Value: Double);
    procedure SetVL_ENTRADA(const Value: Double);
    procedure SetVL_SAIDA(const Value: Double);
    procedure SetNAT_SLD_FIN(const Value: String);
  public
    property MES : String read FMES write SetMES;
    property VL_ENTRADA : Double read FVL_ENTRADA write SetVL_ENTRADA;
    property VL_SAIDA : Double read FVL_SAIDA write SetVL_SAIDA;
    property SLD_FIN : Double read FSLD_FIN write SetSLD_FIN;
    property NAT_SLD_FIN : String read FNAT_SLD_FIN write SetNAT_SLD_FIN;
    constructor Create;
  End;

  TRegistroQ200List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroQ200;
    procedure SetItem(Index: Integer; const Value: TRegistroQ200);
  public
    function New: TRegistroQ200;
    property Items[Index: Integer]: TRegistroQ200 read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils;

{ TRegistroQ200 }

constructor TRegistroQ200.Create;
begin
  FVL_SAIDA := 0;
  FVL_ENTRADA := 0;
end;

procedure TRegistroQ200.SetMES(const Value: String);
begin
  if Length(Value) > 6 then
    raise Exception.Create('MES - Tamanho m�ximo permitido � 6 caracteres!');

  FMES := Value;
end;

procedure TRegistroQ200.SetNAT_SLD_FIN(const Value: String);
begin
  FNAT_SLD_FIN := Value;
end;

procedure TRegistroQ200.SetSLD_FIN(const Value: Double);
begin
  FSLD_FIN := Value;
end;

procedure TRegistroQ200.SetVL_ENTRADA(const Value: Double);
begin
  FVL_ENTRADA := Value;

  if FVL_ENTRADA > FVL_SAIDA then
    FNAT_SLD_FIN := 'P'
  else
    FNAT_SLD_FIN := 'N';
end;

procedure TRegistroQ200.SetVL_SAIDA(const Value: Double);
begin
  FVL_SAIDA := Value;

  if FVL_ENTRADA > FVL_SAIDA then
    FNAT_SLD_FIN := 'P'
  else
    FNAT_SLD_FIN := 'N';
end;

{ TRegistroQ200List }

function TRegistroQ200List.GetItem(Index: Integer): TRegistroQ200;
begin
  Result := TRegistroQ200(inherited GetItem(Index));
end;

procedure TRegistroQ200List.SetItem(Index: Integer; const Value: TRegistroQ200);
begin
  inherited SetItem(Index, Value);
end;

function TRegistroQ200List.New: TRegistroQ200;
begin
  Result := TRegistroQ200.Create;
  Self.Add(Result);
end;


end.
