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
unit Registro0050;

interface

uses Classes, Contnrs;

type
  TRegistro0050 = Class
  private
    FBANCO: Integer;
    FPAIS_CTA: String;
    FCOD_CONTA: Integer;
    FNOME_BANCO: String;
    FNUM_CONTA: String;
    FAGENCIA: String;
    procedure SetAGENCIA(const Value: String);
    procedure SetBANCO(const Value: Integer);
    procedure SetCOD_CONTA(const Value: Integer);
    procedure SetNOME_BANCO(const Value: String);
    procedure SetNUM_CONTA(const Value: String);
    procedure SetPAIS_CTA(const Value: String);
  public
    property COD_CONTA : Integer read FCOD_CONTA write SetCOD_CONTA;
    property PAIS_CTA : String read FPAIS_CTA write SetPAIS_CTA;
    property BANCO : Integer read FBANCO write SetBANCO;
    property NOME_BANCO : String read FNOME_BANCO write SetNOME_BANCO;
    property AGENCIA : String read FAGENCIA write SetAGENCIA;
    property NUM_CONTA : String read FNUM_CONTA write SetNUM_CONTA;
  End;

  TRegistro0050List = class(TObjectList)
    private
    function GetItem(Index: Integer): TRegistro0050;
    procedure SetItem(Index: Integer; const Value: TRegistro0050);
  public
    function New: TRegistro0050;
    property Items[Index: Integer]: TRegistro0050 read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils;

{ TRegistro0050 }

procedure TRegistro0050.SetAGENCIA(const Value: String);
begin
  if Length(Value) > 4 then
    raise Exception.Create('AGENCIA - Tamanho m�ximo permitido � 4 caracteres!');

  FAGENCIA := Value;
end;

procedure TRegistro0050.SetBANCO(const Value: Integer);
begin
  FBANCO := Value;
end;

procedure TRegistro0050.SetCOD_CONTA(const Value: Integer);
begin
  FCOD_CONTA := Value;
end;

procedure TRegistro0050.SetNOME_BANCO(const Value: String);
begin
  if Length(Value) > 30 then
    raise Exception.Create('NOME_BANCO - Tamanho m�ximo permitido � 30 caracteres!');

  FNOME_BANCO := Value;
end;

procedure TRegistro0050.SetNUM_CONTA(const Value: String);
begin
  FNUM_CONTA := Value;
end;

procedure TRegistro0050.SetPAIS_CTA(const Value: String);
begin
  if Length(Value) > 3 then
    raise Exception.Create('PAIS_CTA - Tamanho m�ximo permitido � 3 caracteres!');

  FPAIS_CTA := Value;
end;

{ TRegistro0050List }

function TRegistro0050List.GetItem(Index: Integer): TRegistro0050;
begin
  Result := TRegistro0050(inherited GetItem(Index));
end;

procedure TRegistro0050List.SetItem(Index: Integer; const Value: TRegistro0050);
begin
  inherited SetItem(Index, Value);
end;

function TRegistro0050List.New: TRegistro0050;
begin
  Result := TRegistro0050.Create;
  Self.Add(Result);
end;

end.
