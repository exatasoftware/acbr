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

{******************************************************************************
|* Historico
|*
|* --/--/2015: Juliomar Marchetti
|*  - Cria��o.
|* 12/08/2015: Isaque Pinheiro
|*  - Distribui��o da primeira vers�o.
|* 19/08/2015: Lutzem Massao Aihara
|*  - Classe reestruturada.
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_J;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  TRegistroJ050List = class;
  TRegistroJ051List = class;
  TRegistroJ053List = class;
  TRegistroJ100List = class;

  /// Registro J001 - ABERTURA DO BLOCO J
  TRegistroJ001 = class(TOpenBlocos)
  private
    FRegistroJ050 :TRegistroJ050List;
    FRegistroJ100 :TRegistroJ100List;
  public
    constructor Create; virtual;  /// Create
    destructor Destroy; override; /// Destroy

    property RegistroJ050: TRegistroJ050List read FRegistroJ050 write FRegistroJ050;
    property RegistroJ100: TRegistroJ100List read FRegistroJ100 write FRegistroJ100;
  end;

  /// Registro J050 - PLANO DE CONTAS DO CONTRIBUINTE
  TRegistroJ050 = class
  private
    fDT_ALT:      TDateTime; /// Data da inclus�o/altera��o.
    fCOD_NAT:     String;    /// C�digo da natureza da conta/grupo de contas, conforme tabela publicada pelo Sped.
    fIND_CTA:     String;    /// Indicador do tipo de conta: S - Sint�tica (grupo de contas);A - Anal�tica (conta).
    fNIVEL:       String;    /// N�vel da conta anal�tica/sint�tica.
    fCOD_CTA:     String;    /// C�digo da conta anal�tica/sint�tica.
    fCOD_CTA_SUP: String;    /// C�digo da conta sint�tica de n�vel imediatamente superior.
    fCTA:         String;    /// Nome da conta anal�tica/sint�tica.

    FRegistroJ051: TRegistroJ051List;
    FRegistroJ053: TRegistroJ053List;
  public
    constructor Create(); virtual; /// Create
    destructor Destroy; override; /// Destroy

    property DT_ALT:      TDateTime read fDT_ALT write fDT_ALT;
    property COD_NAT:     String read fCOD_NAT write fCOD_NAT;
    property IND_CTA:     String read fIND_CTA write fIND_CTA;
    property NIVEL:       String read fNIVEL write fNIVEL;
    property COD_CTA:     String read fCOD_CTA write fCOD_CTA;
    property COD_CTA_SUP: String read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property CTA:         String read fCTA write fCTA;
    //
    property RegistroJ051: TRegistroJ051List read FRegistroJ051 write FRegistroJ051;
    property RegistroJ053: TRegistroJ053List read FRegistroJ053 write FRegistroJ053;
  end;

  /// Registro I050 - Lista
  TRegistroJ050List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroJ050;
    procedure SetItem(Index: Integer; const Value: TRegistroJ050);
  public
    function New(): TRegistroJ050;
    property Items[Index: Integer]: TRegistroJ050 read GetItem write SetItem;
  end;

  /// Registro J051 - PLANO DE CONTAS REFERENCIAL
  TRegistroJ051 = class
  private
    fCOD_CCUS:    String; /// C�digo do centro de custo.
    fCOD_CTA_REF: String; /// C�digo da conta de acordo com o plano de contas referencial, conforme tabela publicada pelos �rg�os indicados no campo 02- COD_ENT_REF.
  public
    constructor Create(AOwner: TRegistroJ050); virtual; /// Create

    property COD_CCUS:    String read fCOD_CCUS write fCOD_CCUS;
    property COD_CTA_REF: String read fCOD_CTA_REF write fCOD_CTA_REF;
  end;

  /// Registro J051 - Lista

  TRegistroJ051List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroJ051;
    procedure SetItem(Index: Integer; const Value: TRegistroJ051);
  public
    function New(AOwner :TRegistroJ050): TRegistroJ051;
    property Items[Index: Integer]: TRegistroJ051 read GetItem write SetItem;
  end;

  /// Registro J053 - SUBCONTAS CORRELATAS

  TRegistroJ053 = class
  private
    fCOD_CNT_CORR: String; /// C�digo de identifica��o do grupo de conta-subconta(a)
    fNAT_SUB_CNT:  String; /// C�digo da subconta correlata (deve estar no plano de contas e s� pode estar relacionada a um �nico grupo)
    fCOD_IDT:      String; /// Natureza da subconta correlata (conforme tabela de natureza da subconta publicada no Sped )
  public
    constructor Create(AOwner: TRegistroJ050); virtual;

    property COD_IDT:       String read fCOD_IDT write fCOD_CNT_CORR;
    property COD_CNT_CORR: String read fCOD_CNT_CORR write fCOD_CNT_CORR;
    property NAT_SUB_CNT : String read fNAT_SUB_CNT write fNAT_SUB_CNT;
  end;

  /// Registro J053 - Lista

  TRegistroJ053List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroJ053;
    procedure SetItem(Index: Integer; const Value: TRegistroJ053);
  public
    function New(AOwner: TRegistroJ050): TRegistroJ053;
    property Items[Index: Integer]: TRegistroJ053 read GetItem write SetItem;
  end;

  /// Registro J100 - CENTRO DE CUSTOS

  TRegistroJ100 = class
  private
    fDT_ALT:   TdateTime; /// Data da inclus�o/altera��o.
    fCOD_CCUS: String;    /// C�digo do centro de custos.
    fCCUS:     String;    /// Nome do centro de custos.
  public
    constructor Create(AOwner: TRegistroJ001); virtual; /// Create

    property DT_ALT:   TdateTime read fDT_ALT write fDT_ALT;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property CCUS:     String read fCCUS write fCCUS;
  end;

  /// Registro J100 - Lista

  TRegistroJ100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroJ100;
    procedure SetItem(Index: Integer; const Value: TRegistroJ100);
  public
    function New(AOwner: TRegistroJ001): TRegistroJ100;
    property Items[Index: Integer]: TRegistroJ100 read GetItem write SetItem;
  end;

  /// Registro J990 - ENCERRAMENTO DO BLOCO J

  TRegistroJ990 = class
  private
    fQTD_LIN: Integer; /// Quantidade total de linhas do Bloco J
  public
    property QTD_LIN: Integer read FQTD_LIN write FQTD_LIN;
  end;

implementation

constructor TRegistroJ050.Create();
begin
   inherited Create;
   FRegistroJ051 := TRegistroJ051List.Create;
   FRegistroJ053 := TRegistroJ053List.Create;
end;

destructor TRegistroJ050.Destroy;
begin
  FRegistroJ051.Free;
  FRegistroJ053.Free;
  inherited;
end;

{ TRegistroJ050List }

function TRegistroJ050List.GetItem(Index: Integer): TRegistroJ050;
begin
  Result := TRegistroJ050(Inherited Items[Index]);
end;

function TRegistroJ050List.New(): TRegistroJ050;
begin
  Result := TRegistroJ050.Create();
  Add(Result);
end;

procedure TRegistroJ050List.SetItem(Index: Integer; const Value: TRegistroJ050);
begin
  Put(Index, Value);
end;

{ TRegistroJ051List }

function TRegistroJ051List.GetItem(Index: Integer): TRegistroJ051;
begin
  Result := TRegistroJ051(Inherited Items[Index]);
end;

function TRegistroJ051List.New(AOwner :TRegistroJ050): TRegistroJ051;
begin
  Result := TRegistroJ051.Create(AOwner);
  Add(Result);
end;

procedure TRegistroJ051List.SetItem(Index: Integer; const Value: TRegistroJ051);
begin
  Put(Index, Value);
end;


{ TRegistroJ100List }

function TRegistroJ100List.GetItem(Index: Integer): TRegistroJ100;
begin
  Result := TRegistroJ100(Inherited Items[Index]);
end;

function TRegistroJ100List.New(AOwner: TRegistroJ001): TRegistroJ100;
begin
  Result := TRegistroJ100.Create(AOwner);
  Add(Result);
end;

procedure TRegistroJ100List.SetItem(Index: Integer; const Value: TRegistroJ100);
begin
  Put(Index, Value);
end;


{ TRegistroJ053List }

function TRegistroJ053List.GetItem(Index: Integer): TRegistroJ053;
begin
  Result := TRegistroJ053(Inherited Items[Index]);
end;

function TRegistroJ053List.New(AOwner: TRegistroJ050): TRegistroJ053;
begin
  Result := TRegistroJ053.Create(AOwner);
  Add(Result);
end;

procedure TRegistroJ053List.SetItem(Index: Integer; const Value: TRegistroJ053);
begin
  Put(Index, Value);
end;

{ TRegistroJ001 }

constructor TRegistroJ001.Create;
begin
   inherited Create;
   FRegistroJ050 := TRegistroJ050List.Create;
   FRegistroJ100 := TRegistroJ100List.Create;
   //
   IND_DAD := idComDados;;
end;

destructor TRegistroJ001.Destroy;
begin
   FRegistroJ050.Free;
   FRegistroJ100.Free;

  inherited;
end;

{ TRegistroJ051 }

constructor TRegistroJ051.Create(AOwner: TRegistroJ050);
begin
end;

{ TRegistroJ053 }

constructor TRegistroJ053.Create(AOwner: TRegistroJ050);
begin
end;

{ TRegistroJ100 }

constructor TRegistroJ100.Create(AOwner: TRegistroJ001);
begin
end;

end.
