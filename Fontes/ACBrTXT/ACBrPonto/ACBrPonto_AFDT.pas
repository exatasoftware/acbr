{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Albert Eije                                     }
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

unit ACBrPonto_AFDT;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type
  // Registro tipo �1� - Cabe�alho
  TCabecalho = class
  private
    FCampo01: String; // Seq�encial do registro no arquivo.
    FCampo02: String; // Tipo do registro, �1�.
    FCampo03: String; // Tipo de identificador do empregador, �1� para CNPJ ou �2� para CPF.
    FCampo04: String; // CNPJ ou CPF do empregador.
    FCampo05: String; // CEI do empregador, quando existir.
    FCampo06: String; // Raz�o social ou nome do empregador.
    FCampo07: String; // Data inicial dos registros no arquivo, no formato �ddmmaaaa�.
    FCampo08: String; // Data final dos registros no arquivo, no formato �ddmmaaaa�.
    FCampo09: String; // Data de gera��o do arquivo, no formato �ddmmaaaa�.
    FCampo10: String; // Hor�rio da gera��o do arquivo, no formato �hhmm�.

    FRegistroValido: Boolean;

  public
    constructor Create; virtual; 
    destructor Destroy; override;

    property RegistroValido: Boolean read FRegistroValido write FRegistroValido default True;
    property Campo01: String read FCampo01 write FCampo01;
    property Campo02: String read FCampo02 write FCampo02;
    property Campo03: String read FCampo03 write FCampo03;
    property Campo04: String read FCampo04 write FCampo04;
    property Campo05: String read FCampo05 write FCampo05;
    property Campo06: String read FCampo06 write FCampo06;
    property Campo07: String read FCampo07 write FCampo07;
    property Campo08: String read FCampo08 write FCampo08;
    property Campo09: String read FCampo09 write FCampo09;
    property Campo10: String read FCampo10 write FCampo10;
  end;

  // Registro DETALHE - Registro de inclus�o ou altera��o da identifica��o da empresa no REP
  TRegistro2 = class
  private
    FCampo01: String; // Seq�encial do registro no arquivo.
    FCampo02: String; // Tipo do registro, �2�.
    FCampo03: String; // Data da marca��o do ponto, no formato �ddmmaaaa�.
    FCampo04: String; // Hor�rio da marca��o do ponto, no formato �hhmm�.
    FCampo05: String; // N�mero do PIS do empregado.
    FCampo06: String; // N�mero de fabrica��o do REP onde foi feito o registro.
    FCampo07: String; // Tipo de marca��o, �E� para ENTRADA, �S� para SA�DA ou �D� para registro a ser DESCONSIDERADO.
    FCampo08: String; // N�mero seq�encial por empregado e jornada para o conjunto Entrada/Sa�da. Vide observa��o.
    FCampo09: String; // Tipo de registro: �O� para registro eletr�nico ORIGINAL, �I� para registro INCLU�DO por digita��o, �P� para intervalo PR�-ASSINALADO.
    FCampo10: String; // Motivo: Campo a ser preenchido se o campo 7 for �D� ou se o campo 9 for �I�.

    FRegistroValido: boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property Campo01: String read FCampo01 write FCampo01;
    property Campo02: String read FCampo02 write FCampo02;
    property Campo03: String read FCampo03 write FCampo03;
    property Campo04: String read FCampo04 write FCampo04;
    property Campo05: String read FCampo05 write FCampo05;
    property Campo06: String read FCampo06 write FCampo06;
    property Campo07: String read FCampo07 write FCampo07;
    property Campo08: String read FCampo08 write FCampo08;
    property Campo09: String read FCampo09 write FCampo09;
    property Campo10: String read FCampo10 write FCampo10;
  end;

  // Registro 2 - Lista
  TRegistro2List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro2;
    procedure SetItem(Index: Integer; const Value: TRegistro2);
  public
    function New: TRegistro2;
    property Items[Index: Integer]: TRegistro2 read GetItem write SetItem;
  end;

  // Registro Trailer
  TTrailer = class
  private
    FCampo01: String; // Seq�encial do registro no arquivo.
    FCampo02: String; // Tipo do registro, �9�.

    FRegistroValido: boolean;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property Campo01: String read FCampo01 write FCampo01;
    property Campo02: String read FCampo02 write FCampo02;
  end;

implementation

{ TCabecalho }

constructor TCabecalho.Create;
begin
  FRegistroValido := True;
end;

destructor TCabecalho.Destroy;
begin
  inherited;
end;

{ TRegistro2List }

function TRegistro2List.GetItem(Index: Integer): TRegistro2;
begin
  Result := TRegistro2(inherited GetItem(Index));
end;

function TRegistro2List.New: TRegistro2;
begin
  Result := TRegistro2.Create;
  Add(Result);
end;

procedure TRegistro2List.SetItem(Index: Integer; const Value: TRegistro2);
begin
  Put(Index, Value);
end;

{ TRegistro2 }

constructor TRegistro2.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistro2.Destroy;
begin
  inherited;
end;

{ TTrailer }

constructor TTrailer.Create;
begin
  FRegistroValido := True;
end;

destructor TTrailer.Destroy;
begin
  inherited;
end;

end.
