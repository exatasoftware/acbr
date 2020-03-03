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
unit Bloco0050;

interface

uses
  Classes, Contnrs, Registro0050;

type
  TBloco0050 = Class
  private
    FCONTAS: TRegistro0050List;
    procedure SetCONTAS(const Value: TRegistro0050List);
  public
    constructor Create;
    destructor Destroy; override;
    function Registro0050New : TRegistro0050;
    procedure AddConta(Registro0050 : TRegistro0050);
    property CONTAS : TRegistro0050List read FCONTAS write SetCONTAS;
  End;

implementation

{ TBloco50 }

procedure TBloco0050.AddConta(Registro0050: TRegistro0050);
var
  i : integer;
begin
  FCONTAS.Add(TRegistro0050.Create);
  I := FCONTAS.Count -1;
  FCONTAS[I].COD_CONTA  := Registro0050.COD_CONTA;
  FCONTAS[I].PAIS_CTA   := Registro0050.PAIS_CTA;
  FCONTAS[I].BANCO      := Registro0050.BANCO;
  FCONTAS[I].NOME_BANCO := Registro0050.NOME_BANCO;
  FCONTAS[I].AGENCIA    := Registro0050.AGENCIA;
  FCONTAS[I].NUM_CONTA  := Registro0050.NUM_CONTA;
end;

constructor TBloco0050.Create;
begin
  FCONTAS := TRegistro0050List.Create;
end;

destructor TBloco0050.Destroy;
begin
  FCONTAS.Free;
  inherited;
end;

function TBloco0050.Registro0050New: TRegistro0050;
begin
  result := TRegistro0050.Create;

  FCONTAS.Add(Result);
end;

procedure TBloco0050.SetCONTAS(const Value: TRegistro0050List);
begin
  FCONTAS := Value;
end;

end.
