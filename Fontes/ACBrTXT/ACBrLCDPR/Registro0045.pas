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
unit Registro0045;

interface

uses Classes, Contnrs, LCDPRBlocos;

type
  TRegistro0045 = Class
  private
    FNOME_CONTRAPARTE: String;
    FTIPO_CONTRAPARTE: TTipoContraparte;
    FCOD_IMOVEL: Integer;
    FPERC_CONTRAPARTE: Double;
    FCPF_CONTRAPARTE: String;
    procedure SetCOD_IMOVEL(const Value: Integer);
    procedure SetCPF_CONTRAPARTE(const Value: String);
    procedure SetNOME_CONTRAPARTE(const Value: String);
    procedure SetPERC_CONTRAPARTE(const Value: Double);
    procedure SetTIPO_CONTRAPARTE(const Value: TTipoContraparte);
  public
    property COD_IMOVEL : Integer read FCOD_IMOVEL write SetCOD_IMOVEL;
    property TIPO_CONTRAPARTE : TTipoContraparte read FTIPO_CONTRAPARTE write SetTIPO_CONTRAPARTE;
    property CPF_CONTRAPARTE : String read FCPF_CONTRAPARTE write SetCPF_CONTRAPARTE;
    property NOME_CONTRAPARTE : String read FNOME_CONTRAPARTE write SetNOME_CONTRAPARTE;
    property PERC_CONTRAPARTE : Double read FPERC_CONTRAPARTE write SetPERC_CONTRAPARTE;
  End;

  TRegistro0045List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro0045;
    procedure SetItem(Index: Integer; const Value: TRegistro0045);
  public
    function New: TRegistro0045;
    property Items[Index: Integer]: TRegistro0045 read GetItem write SetItem; default;
  end;

implementation

uses
  SysUtils, ACBrUtil;

{ TRegistro0045 }

procedure TRegistro0045.SetCOD_IMOVEL(const Value: Integer);
begin
  FCOD_IMOVEL := Value;
end;

procedure TRegistro0045.SetCPF_CONTRAPARTE(const Value: String);
var
  TempDoc: string;
begin
  TempDoc := OnlyNumber(Value);
  if Length(TempDoc) > 11 then
    raise Exception.Create('CPF_CONTRAPARTE - Tamanho m�ximo permitido � 11 caracteres!');

  FCPF_CONTRAPARTE := TempDoc;
end;

procedure TRegistro0045.SetNOME_CONTRAPARTE(const Value: String);
begin
  if Length(Value) > 50 then
    raise Exception.Create('NOME_CONTRAPARTE - Tamanho m�ximo permitido � 50 caracteres!');

  FNOME_CONTRAPARTE := Value;
end;

procedure TRegistro0045.SetPERC_CONTRAPARTE(const Value: Double);
begin
  FPERC_CONTRAPARTE := Value;
end;

procedure TRegistro0045.SetTIPO_CONTRAPARTE(const Value: TTipoContraparte);
begin
  FTIPO_CONTRAPARTE := Value;
end;

{ TRegistro0045List }

function TRegistro0045List.GetItem(Index: Integer): TRegistro0045;
begin
  Result := TRegistro0045(inherited GetItem(Index));
end;

function TRegistro0045List.New: TRegistro0045;
begin
  Result := TRegistro0045.Create;
  Self.Add(Result);
end;

procedure TRegistro0045List.SetItem(Index: Integer;
  const Value: TRegistro0045);
begin
  inherited SetItem(Index, Value);
end;

end.
