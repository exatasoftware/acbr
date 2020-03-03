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
unit RegistroQ100;

interface

uses Classes, Contnrs, LCDPRBlocos;

type
  TRegistroQ100 = Class
  private
    FHISTORICO: String;
    FCOD_CONTA: Integer;
    FCOD_IMOVEL: Integer;
    FTIPO_DOC: TTipoDoc;
    FNUM_DOC: String;
    FDATA: TDateTime;
    FID_PARTIC: String;
    FTIPO_LANC: TTipoLanc;
    FSLD_FIN: Double;
    FVL_SAIDA: Double;
    FVL_ENTRADA: Double;
    FNAT_SLD_FIN: String;
    procedure SetCOD_CONTA(const Value: Integer);
    procedure SetCOD_IMOVEL(const Value: Integer);
    procedure SetDATA(const Value: TDateTime);
    procedure SetHISTORICO(const Value: String);
    procedure SetNUM_DOC(const Value: String);
    procedure SetTIPO_DOC(const Value: TTipoDoc);
    procedure SetID_PARTIC(const Value: String);
    procedure SetSLD_FIN(const Value: Double);
    procedure SetTIPO_LANC(const Value: TTipoLanc);
    procedure SetVL_ENTRADA(const Value: Double);
    procedure SetVL_SAIDA(const Value: Double);
    procedure SetNAT_SLD_FIN(const Value: String);
  public
    property DATA : TDateTime read FDATA write SetDATA;
    property COD_IMOVEL : Integer read FCOD_IMOVEL write SetCOD_IMOVEL;
    property COD_CONTA : Integer read FCOD_CONTA write SetCOD_CONTA;
    property NUM_DOC : String read FNUM_DOC write SetNUM_DOC;
    property TIPO_DOC : TTipoDoc read FTIPO_DOC write SetTIPO_DOC;
    property HISTORICO : String read FHISTORICO write SetHISTORICO;
    property ID_PARTIC : String read FID_PARTIC write SetID_PARTIC;
    property TIPO_LANC : TTipoLanc read FTIPO_LANC write SetTIPO_LANC;
    property VL_ENTRADA : Double read FVL_ENTRADA write SetVL_ENTRADA;
    property VL_SAIDA : Double read FVL_SAIDA write SetVL_SAIDA;
    property SLD_FIN : Double read FSLD_FIN write SetSLD_FIN;
    property NAT_SLD_FIN : String read FNAT_SLD_FIN write SetNAT_SLD_FIN;
    constructor Create;
  End;

  TRegistroQ100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroQ100;
    procedure SetItem(Index: Integer; const Value: TRegistroQ100);
  public
    function New: TRegistroQ100;
    property Items[Index: Integer]: TRegistroQ100 read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils, ACBrUtil;

{ TRegistroQ100 }

constructor TRegistroQ100.Create;
begin
  FVL_SAIDA := 0;
  FVL_ENTRADA := 0;
end;

procedure TRegistroQ100.SetCOD_CONTA(const Value: Integer);
begin
  FCOD_CONTA := Value;
end;

procedure TRegistroQ100.SetCOD_IMOVEL(const Value: Integer);
begin
  FCOD_IMOVEL := Value;
end;

procedure TRegistroQ100.SetDATA(const Value: TDateTime);
begin
  FDATA := Value;
end;

procedure TRegistroQ100.SetHISTORICO(const Value: String);
begin
  FHISTORICO := Value;
end;

procedure TRegistroQ100.SetID_PARTIC(const Value: String);
var
  TempIdPart: string;
begin
  TempIdPart := OnlyNumber(Value);
  if Length(TempIdPart) > 14 then
    raise Exception.Create('ID_PARTIC - Tamanho m�ximo permitido � 14 caracteres!');

  FID_PARTIC := TempIdPart;
end;

procedure TRegistroQ100.SetNAT_SLD_FIN(const Value: String);
begin
  FNAT_SLD_FIN := Value;
end;

procedure TRegistroQ100.SetNUM_DOC(const Value: String);
begin
  FNUM_DOC := Value;
end;

procedure TRegistroQ100.SetSLD_FIN(const Value: Double);
begin
  FSLD_FIN := Value;
end;

procedure TRegistroQ100.SetTIPO_DOC(const Value: TTipoDoc);
begin
  FTIPO_DOC := Value;
end;

procedure TRegistroQ100.SetTIPO_LANC(const Value: TTipoLanc);
begin
  FTIPO_LANC := Value;
end;

procedure TRegistroQ100.SetVL_ENTRADA(const Value: Double);
begin
  FVL_ENTRADA := Value;

  if (FVL_ENTRADA > FVL_SAIDA) then
    FNAT_SLD_FIN := 'P'
  else
    FNAT_SLD_FIN := 'N';
end;

procedure TRegistroQ100.SetVL_SAIDA(const Value: Double);
begin
  FVL_SAIDA := Value;

  if (FVL_ENTRADA > FVL_SAIDA) then
    FNAT_SLD_FIN := 'P'
  else
    FNAT_SLD_FIN := 'N';
end;

{ TRegistroQ100List }

function TRegistroQ100List.GetItem(Index: Integer): TRegistroQ100;
begin
  Result := TRegistroQ100(inherited GetItem(Index));
end;

procedure TRegistroQ100List.SetItem(Index: Integer; const Value: TRegistroQ100);
begin
  inherited SetItem(Index, Value);
end;

function TRegistroQ100List.New: TRegistroQ100;
begin
  Result := TRegistroQ100.Create;
  Self.Add(Result);
end;

end.
