{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
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

unit uVendaClass;

interface

uses
  Classes, SysUtils, contnrs, IniFiles;

const
  cPagamentos: array[0..4] of array [0..1] of String =
     ( ('01','Dinheiro'),
       ('02','Cheque'),
       ('03','Cart�o de Cr�dito'),
       ('04','Cart�o de D�bito'),
       ('99','Outros') );

type
  TStatusVenda = (stsLivre, stsIniciada, stsEmPagamento, stsFinalizada, stsCancelada, stsAguardandoTEF);

  { TPagamento }

  TPagamento = class
  private
    FConfirmada: Boolean;
    FDesconto: Double;
    FHora: TDateTime;
    FNomeAdministradora: String;
    FNSU: String;
    FRede: String;
    FTipoPagamento: String;
    FValor: Currency;

  public
    constructor Create;
    procedure Clear;

    property TipoPagamento: String read FTipoPagamento write FTipoPagamento;
    property Valor: Currency read FValor write FValor;
    property Hora: TDateTime read FHora write FHora;
    property NSU: String read FNSU write FNSU;
    property Rede: String read FRede write FRede;
    property NomeAdministradora: String read FNomeAdministradora write FNomeAdministradora;
    property Desconto: Double read FDesconto write FDesconto;
    property Confirmada: Boolean read FConfirmada write FConfirmada;
  end;

  { TListaPagamentos }

  TListaPagamentos = class(TObjectList)
  private
    function GetTotalPago: Double;
  protected
    procedure SetObject(Index: Integer; Item: TPagamento);
    function GetObject(Index: Integer): TPagamento;
  public
    function New: TPagamento;
    function Add(Obj: TPagamento): Integer;
    procedure Insert(Index: Integer; Obj: TPagamento);
    property Objects[Index: Integer]: TPagamento read GetObject write SetObject; default;

    property TotalPago: Double read GetTotalPago;
  end;

  { TVenda }

  TVenda = class
  private
    FArqVenda: String;
    FDHInicio: TDateTime;
    FNumOperacao: Integer;
    FStatus: TStatusVenda;
    FValorInicial: Currency;
    FTotalAcrescimo: Currency;
    FTotalDesconto: Currency;
    FPagamentos: TListaPagamentos;
    function GetTotalVenda: Currency;
    function GetTotalPago: Currency;
    function GetTroco: Currency;

    function SecPag(i: integer): String;
  public
    constructor Create(const ArqVenda: String);
    destructor Destroy; override;
    procedure Clear;

    procedure Gravar;
    procedure Ler;

    property NumOperacao: Integer read FNumOperacao write FNumOperacao;
    property DHInicio: TDateTime read FDHInicio write FDHInicio;
    property Status: TStatusVenda read FStatus write FStatus;

    property ValorInicial: Currency read FValorInicial write FValorInicial;
    property TotalDesconto: Currency read FTotalDesconto write FTotalDesconto;
    property TotalAcrescimo: Currency read FTotalAcrescimo write FTotalAcrescimo;
    property TotalVenda: Currency read GetTotalVenda;

    property Pagamentos: TListaPagamentos read FPagamentos;
    property TotalPago: Currency read GetTotalPago;
    property Troco: Currency read GetTroco;
  end;


Function DescricaoTipoPagamento(const ATipoPagamento: String): String;

implementation

uses
  math,
  ACBrUtil;

function DescricaoTipoPagamento(const ATipoPagamento: String): String;
var
  l, i: Integer;
begin
  Result := '';
  l := Length(cPagamentos)-1;
  For i := 0 to l do
  begin
    if ATipoPagamento = cPagamentos[i,0] then
    begin
      Result := cPagamentos[i,1];
      Break;
    end;
  end;
end;

{ TPagamento }

constructor TPagamento.Create;
begin
  inherited;
  Clear;
end;

procedure TPagamento.Clear;
begin
  FTipoPagamento := cPagamentos[0,0];
  FHora := 0;
  FValor := 0;
  FNSU := '';
  FRede := '';
  FConfirmada := False;
  FNomeAdministradora := '';
  FDesconto := 0;
end;

{ TListaPagamentos }

function TListaPagamentos.GetTotalPago: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Count-1 do
  begin
    with Objects[I] do
      Result := Result + Valor;
  end;

  Result := RoundTo(Result, -2);
end;

procedure TListaPagamentos.SetObject(Index: Integer; Item: TPagamento);
begin
  inherited SetItem(Index, Item);
end;

function TListaPagamentos.GetObject(Index: Integer): TPagamento;
begin
  Result := inherited GetItem(Index) as TPagamento;
end;

function TListaPagamentos.New: TPagamento;
begin
  Result := TPagamento.Create;
  Result.Hora := Now;
  Add(Result);
end;

function TListaPagamentos.Add(Obj: TPagamento): Integer;
begin
  Result := inherited Add(Obj);
end;

procedure TListaPagamentos.Insert(Index: Integer; Obj: TPagamento);
begin
  inherited Insert(Index, Obj);
end;

{ TVenda }

constructor TVenda.Create(const ArqVenda: String);
begin
  FArqVenda := ArqVenda;
  FPagamentos := TListaPagamentos.Create;
  Clear;
end;

destructor TVenda.Destroy;
begin
  FPagamentos.Free;
  inherited Destroy;
end;

procedure TVenda.Clear;
begin
  FNumOperacao := 0;
  FStatus := stsLivre;
  FDHInicio := 0;
  FValorInicial := 0;
  FTotalAcrescimo := 0;
  FTotalDesconto := 0;
  FPagamentos.Clear;
end;

function TVenda.SecPag(i: integer): String;
begin
  Result := 'Pagto'+FormatFloat('000',i);
end;

procedure TVenda.Gravar;
var
  Ini: TMemIniFile;
  ASecPag: String;
  i: Integer;
begin
  Ini := TMemIniFile.Create(FArqVenda);
  try
    Ini.Clear;
    Ini.WriteInteger('Venda','NumOperacao', FNumOperacao);
    Ini.WriteDateTime('Venda','DHInicio', FDHInicio);
    Ini.WriteInteger('Venda','Status', Integer(FStatus));
    Ini.WriteFloat('Valores','ValorInicial', FValorInicial);
    Ini.WriteFloat('Valores','TotalAcrescimo', FTotalAcrescimo);
    Ini.WriteFloat('Valores','TotalDesconto', FTotalDesconto);

    i := 0;
    while i < Pagamentos.Count do
    begin
      ASecPag := SecPag(i);
      Ini.WriteString(ASecPag,'TipoPagamento',Pagamentos[i].TipoPagamento);
      Ini.WriteFloat(ASecPag,'Valor', Pagamentos[i].Valor);
      Ini.WriteDateTime(ASecPag,'Hora', Pagamentos[i].Hora);
      Ini.WriteString(ASecPag,'NSU', Pagamentos[i].NSU);
      Ini.WriteString(ASecPag,'Rede', Pagamentos[i].Rede);
      Ini.WriteString(ASecPag,'NomeAdministradora', Pagamentos[i].NomeAdministradora);
      Ini.WriteFloat(ASecPag,'Desconto', Pagamentos[i].Desconto);
      Ini.WriteBool(ASecPag,'Confirmada', Pagamentos[i].Confirmada);
      Inc(i);
    end;
  finally
    Ini.Free;
  end;
end;

procedure TVenda.Ler;
var
  Ini: TMemIniFile;
  i: Integer;
  APag: TPagamento;
  ASecPag: String;
begin
  Clear;
  Ini := TMemIniFile.Create(FArqVenda);
  try
    FNumOperacao := Ini.ReadInteger('Venda','NumOperacao', 0);
    FDHInicio := Ini.ReadDateTime('Venda','DHInicio', Now);
    FStatus := TStatusVenda(Ini.ReadInteger('Venda','Status', 0));
    FValorInicial := Ini.ReadFloat('Valores','ValorInicial', 0);
    FTotalAcrescimo := Ini.ReadFloat('Valores','TotalAcrescimo', 0);
    FTotalDesconto := Ini.ReadFloat('Valores','TotalDesconto', 0);

    i := 1;
    ASecPag := SecPag(i);
    while Ini.SectionExists(ASecPag) do
    begin
      APag := TPagamento.Create;
      APag.TipoPagamento := Ini.ReadString(ASecPag,'TipoPagamento','99');
      APag.Valor := Ini.ReadFloat(ASecPag,'Valor', 0);
      APag.Hora := Ini.ReadDateTime(ASecPag,'Hora', 0);
      APag.NSU := Ini.ReadString(ASecPag,'NSU', '');
      APag.Rede := Ini.ReadString(ASecPag,'Rede', '');
      APag.NomeAdministradora := Ini.ReadString(ASecPag,'NomeAdministradora', '');
      APag.Desconto := Ini.ReadFloat(ASecPag,'Desconto', 0);
      APag.Confirmada := Ini.ReadBool(ASecPag,'Confirmada', False);

      Pagamentos.Add(APag);

      Inc(i);
      ASecPag := SecPag(i);
    end;
  finally
    Ini.Free;
  end;
end;

function TVenda.GetTotalPago: Currency;
begin
  Result := Pagamentos.TotalPago;
end;

function TVenda.GetTroco: Currency;
begin
  Result := TotalPago - TotalVenda;
end;

function TVenda.GetTotalVenda: Currency;
begin
  Result := FValorInicial - FTotalDesconto + FTotalAcrescimo;
end;

end.

