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

{$I ACBr.inc}

unit ACBrECFBloco_Q;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  TRegistroQ100List = class;

  /// Registro Q001 - Abertura do Bloco Q � Livro Caixa
  TRegistroQ001 = class(TOpenBlocos)
  private
    FRegistroQ100         : TRegistroQ100List; // NIVEL 2
  public
    property RegistroQ100: TRegistroQ100List read FRegistroQ100 write FRegistroQ100;
  end;

  /// Registro Q100 - Demonstrativo do Livro Caixa

  { TRegistroQ100 }

  TRegistroQ100 = class(TBlocos)
  private
    fVL_SAIDA: Variant;
    fNUM_DOC: String;
    fHIST: String;
    fVL_ENTRADA: Variant;
    fDATA: TDateTime;
    fSLD_FIN: Variant;
  public
    property DATA: TDateTime read fDATA write fDATA;
    property NUM_DOC: String read fNUM_DOC write fNUM_DOC;
    property HIST: String read fHIST write fHIST;
    property VL_ENTRADA: Variant read fVL_ENTRADA write fVL_ENTRADA;
    property VL_SAIDA: Variant read fVL_SAIDA write fVL_SAIDA;
    property SLD_FIN: Variant read fSLD_FIN write fSLD_FIN;
  end;

  /// Registro Q100 - Lista

  TRegistroQ100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroQ100;
    procedure SetItem(Index: Integer; const Value: TRegistroQ100);
  public
    function New: TRegistroQ100;
    property Items[Index: Integer]: TRegistroQ100 read GetItem write SetItem;
  end;

  /// Registro Q990 - ENCERRAMENTO DO Bloco Q
  TRegistroQ990 = class(TCloseBlocos)
  end;

implementation

{ TRegistroQ100List }

function TRegistroQ100List.GetItem(Index: Integer): TRegistroQ100;
begin
   Result := TRegistroQ100(Inherited Items[Index]);
end;

function TRegistroQ100List.New: TRegistroQ100;
begin
  Result := TRegistroQ100.Create;
  Add(Result);
end;

procedure TRegistroQ100List.SetItem(Index: Integer; const Value: TRegistroQ100);
begin
  Put(Index, Value);
end;


end.

