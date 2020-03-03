{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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
unit ACBrPAF_S;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type
  TRegistroS3List = class;

  //S2 - Mesa/Conta de Cliente
  TRegistroS2 = class
  private
    FCNPJ: String;             //CNPJ do estabelicimento usu�rio do PAF-ECF
    FDT_ABER: TDateTime;       //Data e Hora da abertura da mesa
    FSITU: String;             //Situa��o da mesa "A" para Aberta, "F" para Fechada
    FNUM_MESA: String;         //N�mero da Mesa/Conta Cliente
    FVL_TOT: Currency;         //Valor total dos produtos
    FCOO_CM: String;           //COO da confer�ncia de mesa
    FNUM_FAB_CM: String;       //N�de fabrica��o do ECF que emitiu a confer�ncia de mesa
    FCOO: String;              //COO do cupom fiscal
    FNUM_FAB: String;          //N�de fabrica��o do ECF
    FRegistroS3: TRegistroS3List;
    fRegistroValido: Boolean;
  public
    constructor Create; virtual;
    destructor Destroy; override; /// Destroy

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property CNPJ: String       read FCNPJ       write FCNPJ;
    property DT_ABER: TDateTime read FDT_ABER    write FDT_ABER;
    property SITU: String       read FSITU       write FSITU;
    property VL_TOT: Currency   read FVL_TOT     write FVL_TOT;
    property COO_CM: String     read FCOO_CM     write FCOO_CM;
    property NUM_FAB_CM: String read FNUM_FAB_CM write FNUM_FAB_CM;
    property COO: String        read FCOO        write FCOO;
    property NUM_FAB: String    read FNUM_FAB    write FNUM_FAB;
    property NUM_MESA: String   read FNUM_MESA   write FNUM_MESA;

    property RegistroS3: TRegistroS3List read FRegistroS3 write FRegistroS3;
  end;

  TRegistroS2List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroS2;
    procedure SetItem(Index: Integer; const Value: TRegistroS2);
  public
    function New: TRegistroS2;
    property Items[Index: Integer]: TRegistroS2 read GetItem write SetItem;
  end;

  //S3 - Itens da Mesa/Conta de cliente
  TRegistroS3 = class
  private
    fCOD_ITEM: string;       //C�digo do produto
    fDESC_ITEM: string;      //Descri��o do produto
    fQTDE_ITEM: Currency;    //Quantidade comercializada
    fUNI_ITEM: string;       //Unidade de medida
    fVL_UNIT: Currency;      //Valor unit�rio
    FNUM_MESA: String;       //N�mero da Mesa/Conta Cliente
    fQTDE_DECIMAL: integer;  //Par�metro de n�mero de casas decimais da quantidade
    fVL_DECIMAL: integer;    //Par�metro de n�mero de casas decimais de valor unit�rio
    fRegistroValido: Boolean;
  public
    constructor Create; virtual;

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property COD_ITEM: String       read fCOD_ITEM   write fCOD_ITEM;
    property DESC_ITEM: string      read fDESC_ITEM  write fDESC_ITEM;
    property QTDE_ITEM: Currency    read fQTDE_ITEM  write fQTDE_ITEM;
    property UNI_ITEM: string       read fUNI_ITEM   write fUNI_ITEM;
    property VL_UNIT: Currency      read fVL_UNIT    write fVL_UNIT;
    property NUM_MESA: String       read FNUM_MESA   write FNUM_MESA;
    property QTDE_DECIMAL: integer read FQTDE_DECIMAL write FQTDE_DECIMAL;
    property VL_DECIMAL: integer read FVL_DECIMAL write FVL_DECIMAL;
  end;

  TRegistroS3List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroS3;
    procedure SetItem(Index: Integer; const Value: TRegistroS3);
  public
    function New: TRegistroS3;
    property Items[Index: Integer]: TRegistroS3 read GetItem write SetItem;
  end;

implementation

{ TRegistroS2 }
constructor TRegistroS2.Create;
begin
  fRegistroValido:= True; 
  fRegistroS3:= TRegistroS3List.Create;
end;

destructor TRegistroS2.Destroy;
begin
  fRegistroS3.Free;
  inherited;
end;

{ TRegistroS2List }
function TRegistroS2List.GetItem(Index: Integer): TRegistroS2;
begin
  Result := TRegistroS2(inherited Items[Index]);
end;

function TRegistroS2List.New: TRegistroS2;
begin
  Result := TRegistroS2.Create;
  Add(Result);
end;

procedure TRegistroS2List.SetItem(Index: Integer;
  const Value: TRegistroS2);
begin  
  Put(Index, Value);
end;

{ TRegistroS3List } 
function TRegistroS3List.GetItem(Index: Integer): TRegistroS3;
begin
  Result := TRegistroS3(inherited Items[Index]);
end;

function TRegistroS3List.New: TRegistroS3;
begin
  Result := TRegistroS3.Create;
  Add(Result);
end;

procedure TRegistroS3List.SetItem(Index: Integer;
  const Value: TRegistroS3);
begin
  Put(Index, Value);
end;

{ TRegistroS3 }

constructor TRegistroS3.Create;
begin
  fRegistroValido:= True;

  fQTDE_DECIMAL:= 0; // Deixado esse padr�o por que no Ato Cotepe a Quantidade est� sem casas decimais
  fVL_DECIMAL:= 2; // Deixado esse padr�o por que no Ato Cotepe o Valor Unit�rio deve ser com 2 casas decimais
end;

end.
