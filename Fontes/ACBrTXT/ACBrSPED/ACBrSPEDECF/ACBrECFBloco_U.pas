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

unit ACBrECFBloco_U;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  TRegistroU030List = class;
  TRegistroU100List = class;
  TRegistroU150List = class;
  TRegistroU180List = class;
  TRegistroU182List = class;
  /// Registro U001 - Abertura do Bloco U � Imunes e Isentas
  TRegistroU001 = class(TOpenBlocos)
  private
    FRegistroU030 :TRegistroU030List;
  public
    constructor Create; virtual;  /// Create
    destructor Destroy; override; /// Destroy

    property RegistroU030: TRegistroU030List read FRegistroU030 write FRegistroU030;
  end;

  /// Registro U030 - Identifica��o dos Per�odos e Formas de Apura��o do
  /// IPRJ e da CSLL das Empressa Imunes e Isentas

  { TRegistroU030 }

  TRegistroU030 = class(TBlocos)
  private
    fDT_FIN: TDateTime;
    fDT_INI: TDateTime;
    fPER_APUR: string;

    FRegistroU100: TRegistroU100List;
    FRegistroU150: TRegistroU150List;
    FRegistroU180: TRegistroU180List;
    FRegistroU182: TRegistroU182List;
  public
    constructor Create(); /// Create
    destructor Destroy; override; /// Destroy

    property DT_INI: TDateTime read fDT_INI write fDT_INI;
    property DT_FIN: TDateTime read fDT_FIN write fDT_FIN;
    property PER_APUR: string read fPER_APUR write fPER_APUR;

    /// Registros FILHOS
    property RegistroU100: TRegistroU100List read FRegistroU100 write FRegistroU100;
    property RegistroU150: TRegistroU150List read FRegistroU150 write FRegistroU150;
    property RegistroU180: TRegistroU180List read FRegistroU180 write FRegistroU180;
    property RegistroU182: TRegistroU182List read FRegistroU182 write FRegistroU182;
  end;

  TRegistroU030List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroU030;
    procedure SetItem(Index: Integer; const Value: TRegistroU030);
  public
    function New(): TRegistroU030;
    property Items[Index: Integer]: TRegistroU030 read GetItem write SetItem;
  end;


  /// Registro U100 - Balan�o Patrimonial

  { TRegistroU100 }

  TRegistroU100 = class(TBlocos)
  private
    fCODIGO: string;
    fCOD_CTA_SUP: string;
    fCOD_NAT: string;
    fDESCRICAO: string;
    fIND_VAL_CTA_REF_FIN: string;
    fIND_VAL_CTA_REF_INI: string;
    fNIVEL: String;
    fTIPO:  string;
    fVAL_CTA_REF_FIN: variant;
    fVAL_CTA_REF_INI: variant;
    fVAL_CTA_REF_DEB:  Variant;
    fVAL_CTA_REF_CRED: Variant;
  public
    constructor Create(); virtual; /// Create

    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO: string read fTIPO write fTIPO;
    property NIVEL: String read fNIVEL write fNIVEL;
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property COD_CTA_SUP: string read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property VAL_CTA_REF_INI: variant read fVAL_CTA_REF_INI write fVAL_CTA_REF_INI;
    property IND_VAL_CTA_REF_INI: string read fIND_VAL_CTA_REF_INI write fIND_VAL_CTA_REF_INI;
    property VAL_CTA_REF_FIN: variant read fVAL_CTA_REF_FIN write fVAL_CTA_REF_FIN;
    property VAL_CTA_REF_DEB: Variant read fVAL_CTA_REF_DEB write fVAL_CTA_REF_DEB;
    property VAL_CTA_REF_CRED: Variant read fVAL_CTA_REF_CRED write fVAL_CTA_REF_CRED;
    property IND_VAL_CTA_REF_FIN: string read fIND_VAL_CTA_REF_FIN write fIND_VAL_CTA_REF_FIN;
  end;

  TRegistroU100List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroU100;
    procedure SetItem(Index: Integer; const Value: TRegistroU100);
  public
    function New(): TRegistroU100;
    property Items[Index: Integer]: TRegistroU100 read GetItem write SetItem;
  end;

  /// Registro U150 - Demonstra��o do Resultado

  { TRegistroU150 }

  TRegistroU150 = class(TBlocos)
  private
    fCODIGO: string;
    fCOD_CTA_SUP: string;
    fCOD_NAT: string;
    fDESCRICAO: string;
    fIND_VALOR: string;
    fNIVEL: String;
    fTIPO:  string;
    fVALOR: variant;
  public
    constructor Create(); virtual; /// Create

    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property TIPO: string read fTIPO write fTIPO;
    property NIVEL: String read fNIVEL write fNIVEL;
    property COD_NAT: string read fCOD_NAT write fCOD_NAT;
    property COD_CTA_SUP: string read fCOD_CTA_SUP write fCOD_CTA_SUP;
    property VALOR: variant read fVALOR write fVALOR;
    property IND_VALOR: string read fIND_VALOR write fIND_VALOR;
  end;

  TRegistroU150List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroU150;
    procedure SetItem(Index: Integer; const Value: TRegistroU150);
  public
    function New(): TRegistroU150;
    property Items[Index: Integer]: TRegistroU150 read GetItem write SetItem;
  end;

  /// Registro U180 - C�lculo do IRPJ das Empresas Imunes ou Isentas

  { TRegistroU180 }

  TRegistroU180 = class(TBlocos)
  private
    fCODIGO:    string;
    fDESCRICAO: string;
    fVALOR:     variant;
  public
    constructor Create(); virtual; /// Create

    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property VALOR: variant read fVALOR write fVALOR;
  end;

  TRegistroU180List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroU180;
    procedure SetItem(Index: Integer; const Value: TRegistroU180);
  public
    function New(): TRegistroU180;
    property Items[Index: Integer]: TRegistroU180 read GetItem write SetItem;
  end;


  /// Registro U182 - C�lculo da CSLL das Empresas Imunes ou Isentas

  { TRegistroU182 }

  TRegistroU182 = class(TBlocos)
  private
    fCODIGO:    string;
    fDESCRICAO: string;
    fVALOR:     variant;
  public
    constructor Create(); virtual; /// Create

    property CODIGO: string read fCODIGO write fCODIGO;
    property DESCRICAO: string read fDESCRICAO write fDESCRICAO;
    property VALOR: variant read fVALOR write fVALOR;
  end;

  TRegistroU182List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroU182;
    procedure SetItem(Index: Integer; const Value: TRegistroU182);
  public
    function New(): TRegistroU182;
    property Items[Index: Integer]: TRegistroU182 read GetItem write SetItem;
  end;

  /// Registro U990 - ENCERRAMENTO DO BLOCO U
  TRegistroU990 = class(TCloseBlocos)
  private
    fQTD_LIN: Integer;    /// Quantidade total de linhas do Bloco U
  public
    property QTD_LIN: Integer read FQTD_LIN write FQTD_LIN;
  end;

implementation

function TRegistroU030List.GetItem(Index: Integer): TRegistroU030;
begin
  Result := TRegistroU030(Inherited Items[Index]);
end;

function TRegistroU030List.New(): TRegistroU030;
begin
  Result := TRegistroU030.Create();
  Add(Result);
end;

procedure TRegistroU030List.SetItem(Index: Integer; const Value: TRegistroU030);
begin
  Put(Index, Value);
end;

{ TRegistroU180List }

function TRegistroU180List.GetItem(Index: Integer): TRegistroU180;
begin
  Result := TRegistroU180(Inherited Items[Index]);
end;

function TRegistroU180List.New(): TRegistroU180;
begin
  Result := TRegistroU180.Create();
  Add(Result);
end;

procedure TRegistroU180List.SetItem(Index: Integer; const Value: TRegistroU180);
begin
  Put(Index, Value);
end;

{ TRegistroU150List }

function TRegistroU150List.GetItem(Index: Integer): TRegistroU150;
begin
  Result := TRegistroU150(Inherited Items[Index]);
end;

function TRegistroU150List.New(): TRegistroU150;
begin
  Result := TRegistroU150.Create();
  Add(Result);
end;

procedure TRegistroU150List.SetItem(Index: Integer; const Value: TRegistroU150);
begin
  Put(Index, Value);
end;

{ TRegistroU182List }

function TRegistroU182List.GetItem(Index: Integer): TRegistroU182;
begin
  Result := TRegistroU182(Inherited Items[Index]);
end;

function TRegistroU182List.New(): TRegistroU182;
begin
  Result := TRegistroU182.Create();
  Add(Result);
end;

procedure TRegistroU182List.SetItem(Index: Integer; const Value: TRegistroU182);
begin
  Put(Index, Value);
end;

{ TRegistroU100List }

function TRegistroU100List.GetItem(Index: Integer): TRegistroU100;
begin
  Result := TRegistroU100(Inherited Items[Index]);
end;

function TRegistroU100List.New(): TRegistroU100;
begin
  Result := TRegistroU100.Create();
  Add(Result);
end;

procedure TRegistroU100List.SetItem(Index: Integer; const Value: TRegistroU100);
begin
  Put(Index, Value);
end;

{ TRegistroU030 }

constructor TRegistroU030.Create();
begin
   inherited Create;
   FRegistroU100 := TRegistroU100List.Create;
   FRegistroU182 := TRegistroU182List.Create;
   FRegistroU180 := TRegistroU180List.Create;
   FRegistroU150 := TRegistroU150List.Create;
end;

destructor TRegistroU030.Destroy;
begin
   FRegistroU150.Free;
   FRegistroU180.Free;
   FRegistroU182.Free;
   FRegistroU100.Free;
   inherited;
end;

{ TRegistroU001 }

constructor TRegistroU001.Create;
begin
  inherited Create;
  FRegistroU030 := TRegistroU030List.Create;
  //
  IND_DAD := idComDados;;
end;

destructor TRegistroU001.Destroy;
begin
  FRegistroU030.Free;
  inherited;
end;

{ TRegistroU100 }

constructor TRegistroU100.Create();
begin
  inherited Create;
end;

{ TRegistroU150 }

constructor TRegistroU150.Create();
begin
  inherited Create;
end;

{ TRegistroU182 }

constructor TRegistroU182.Create();
begin
  inherited Create;
end;

{ TRegistroU180 }

constructor TRegistroU180.Create();
begin
  inherited Create;
end;

end.
