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

unit ACBrPonto_ACJEF;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type
  // Registro tipo �1� - Cabe�alho
  TCabecalho = class
  private
    FCampo01: String; // �000000000�.
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

  // Registro 2 - Hor�rios Contratuais
  TRegistro2 = class
  private
    FCampo01: String; // NSR.
    FCampo02: String; // Tipo do registro, �2�.
    FCampo03: String; // C�digo do Hor�rio (CH), no formato �nnnn�.
    FCampo04: String; // Entrada, no formato �hhmm�.
    FCampo05: String; // Sa�da, no formato �hhmm�.
    FCampo06: String; // In�cio intervalo, no formato �hhmm�.
    FCampo07: String; // Fim intervalo, no formato �hhmm�.

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

  // Registro 3 - Detalhe
  TRegistro3 = class
  private
    FCampo01: String; // NSR.
    FCampo02: String; // tipo do registro, �3�.
    FCampo03: String; // N�mero do PIS do empregado.
    FCampo04: String; // Data de in�cio da jornada, no formato �ddmmaaaa�.
    FCampo05: String; // Primeiro hor�rio de entrada da jornada, no formato �hhmm�.
    FCampo06: String; // C�digo do hor�rio (CH) previsto para a jornada, no formato �nnnn�.
    FCampo07: String; // Horas diurnas n�o extraordin�rias, no formato �hhmm�.
    FCampo08: String; // Horas noturnas n�o extraordin�rias, no formato �hhmm�.
    FCampo09: String; // Horas extras 1, no formato �hhmm�.
    FCampo10: String; // Percentual do adicional de horas extras 1, onde as 3 primeiras posi��es indicam a parte inteira e a seguinte a fra��o decimal.
    FCampo11: String; // Modalidade da hora extra 1, assinalado com �D� se as horas extras forem diurnas e �N� se forem noturnas.
    FCampo12: String; // Horas extras 2, no formato �hhmm�.
    FCampo13: String; // Percentual do adicional de horas extras 2, onde as 3 primeiras posi��es indicam a parte inteira e a seguinte a fra��o decimal.
    FCampo14: String; // Modalidade da hora extra 2, assinalado com �D� se as horas extras forem diurnas e �N� se forem noturnas.
    FCampo15: String; // Horas extras 3, no formato �hhmm�.
    FCampo16: String; // Percentual do adicional de horas extras 3, onde as 3 primeiras posi��es indicam a parte inteira e a seguinte a fra��o decimal.
    FCampo17: String; // Modalidade da hora extra 3, assinalado com �D� se as horas extras forem diurnas e �N� se forem noturnas.
    FCampo18: String; // Horas extras 4, no formato �hhmm�.
    FCampo19: String; // Percentual do adicional de horas extras 4, onde as 3 primeiras posi��es indicam a parte inteira e a seguinte a fra��o decimal.
    FCampo20: String; // Modalidade da hora extra 4, assinalado com �D� se as horas extras forem diurnas e �N� se forem noturnas.
    FCampo21: String; // Horas de faltas e/ou atrasos.
    FCampo22: String; // Sinal de horas para compensar. �1� se for horas a maior e �2� se for horas a menor.
    FCampo23: String; // Saldo de horas para compensar no formato �hhmm�.

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
    property Campo11: String read FCampo11 write FCampo11;
    property Campo12: String read FCampo12 write FCampo12;
    property Campo13: String read FCampo13 write FCampo13;
    property Campo14: String read FCampo14 write FCampo14;
    property Campo15: String read FCampo15 write FCampo15;
    property Campo16: String read FCampo16 write FCampo16;
    property Campo17: String read FCampo17 write FCampo17;
    property Campo18: String read FCampo18 write FCampo18;
    property Campo19: String read FCampo19 write FCampo19;
    property Campo20: String read FCampo20 write FCampo20;
    property Campo21: String read FCampo21 write FCampo21;
    property Campo22: String read FCampo22 write FCampo22;
    property Campo23: String read FCampo23 write FCampo23;
  end;

  // Registro 3 - Lista
  TRegistro3List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistro3;
    procedure SetItem(Index: Integer; const Value: TRegistro3);
  public
    function New: TRegistro3;
    property Items[Index: Integer]: TRegistro3 read GetItem write SetItem;
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

{ TRegistro3List }

function TRegistro3List.GetItem(Index: Integer): TRegistro3;
begin
  Result := TRegistro3(inherited GetItem(Index));
end;

function TRegistro3List.New: TRegistro3;
begin
  Result := TRegistro3.Create;
  Add(Result);
end;

procedure TRegistro3List.SetItem(Index: Integer; const Value: TRegistro3);
begin
  Put(Index, Value);
end;

{ TRegistro3 }

constructor TRegistro3.Create;
begin
  FRegistroValido := True;
end;

destructor TRegistro3.Destroy;
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
