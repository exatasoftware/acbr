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
|* 20/08/2015: Lutzem Massao Aihara
|*  - Classe reestruturada.
*******************************************************************************}

{$I ACBr.inc}

unit ACBrECFBloco_K;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrECFBlocos;

type
  TRegistroK030List = class;
  TRegistroK155List = class;
  TRegistroK156List = class;
  TRegistroK355List = class;
  TRegistroK356List = class;
  TRegistroK915List = class;
  TRegistroK935List = class;

  /// Registro K001 - Abertura do Bloco K � Saldos das Contas Cont�beis e Referenciais
  TRegistroK001 = class(TOpenBlocos)
  private
    FRegistroK030 :TRegistroK030List;
    FRegistroK915 :TRegistroK915List;
    FRegistroK935 :TRegistroK935List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy

    property RegistroK030: TRegistroK030List read FRegistroK030 write FRegistroK030;
    property RegistroK915: TRegistroK915List read FRegistroK915 write FRegistroK915;
    property RegistroK935: TRegistroK935List read FRegistroK935 write FRegistroK935;
  end;

  /// Registro K030 - Identifica��o dos Per�odos e Formas de Apura��o do IRPJ e da CSLL no Ano-Calend�rio
  TRegistroK030 = class(TBlocos)
  private
    fDT_FIN:   TDateTime;
    fDT_INI:   TDateTime;
    fPER_APUR: string;

    FRegistroK155: TRegistroK155List;
    FRegistroK355: TRegistroK355List;
  public
    constructor Create(); Virtual;/// Create
    destructor Destroy;  override;

    property DT_INI:   TDateTime read fDT_INI write fDT_INI;
    property DT_FIN:   TDateTime read fDT_FIN write fDT_FIN;
    property PER_APUR: string read fPER_APUR write fPER_APUR;

    // registros filhos
    property RegistroK155: TRegistroK155List read FRegistroK155 write FRegistroK155;
    property RegistroK355: TRegistroK355List read FRegistroK355 write FRegistroK355;
  end;

  //  Registro K030 - Lista
  TRegistroK030List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK030;
    procedure SetItem(Index: Integer; const Value: TRegistroK030);
  public
    function New(): TRegistroK030;
    property Items[Index: Integer]: TRegistroK030 read GetItem write SetItem;
  end;

  /// Registro K155 - Detalhes dos Saldos Cont�beis (Depois do
  /// Encerramento do Resultado do Per�odo)
  TRegistroK155 = class(TBlocos)
  private
    fCOD_CTA:        String;
    fCOD_CCUS:       String;
    fIND_VL_SLD_FIN: String;
    fVL_SLD_FIN:     Variant;
    fVL_SLD_INI:     Variant;
    fIND_VL_SLD_INI: String;
    fVL_CRED:        Variant;
    fVL_DEB:         Variant;

    FRegistroK156: TRegistroK156List;
  public
    constructor Create(AOwner: TRegistroK030); /// Create
    destructor Destroy; override; /// Destroy

    property COD_CTA:        String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS:       String read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_INI:     Variant read fVL_SLD_INI write fVL_SLD_INI;
    property IND_VL_SLD_INI: String read fIND_VL_SLD_INI write fIND_VL_SLD_INI;
    property VL_DEB:         Variant read fVL_DEB write fVL_DEB;
    property VL_CRED:        Variant read fVL_CRED write fVL_CRED;
    property VL_SLD_FIN:     Variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: String read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;

    // registros filhos
    property RegistroK156: TRegistroK156List read FRegistroK156 write FRegistroK156;
  end;

  //  Registro K155 - Lista
  TRegistroK155List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK155;
    procedure SetItem(Index: Integer; const Value: TRegistroK155);
  public
    function New(AOwner: TRegistroK030): TRegistroK155;
    property Items[Index: Integer]: TRegistroK155 read GetItem write SetItem;
  end;

  /// Registro K156 - Mapeamento Referencial do Saldo Final
  TRegistroK156 = class(TBlocos)
  private
    fVL_SLD_FIN:     Variant;
    fIND_VL_SLD_FIN: String;
    fVL_SLD_INI:     Variant;
    fIND_VL_SLD_INI: String;
    fVL_CRED:        Variant;
    fVL_DEB:         Variant;
    fCOD_CTA_REF:    String;
  public
    property COD_CTA_REF:    String read fCOD_CTA_REF write fCOD_CTA_REF;
    property VL_SLD_INI:     Variant read fVL_SLD_INI write fVL_SLD_INI;
    property IND_VL_SLD_INI: String read fIND_VL_SLD_INI write fIND_VL_SLD_INI;
    property VL_DEB:         Variant read fVL_DEB write fVL_DEB;
    property VL_CRED:        Variant read fVL_CRED write fVL_CRED;
    property VL_SLD_FIN:     Variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: String read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;
  end;

  //  Registro K156 - Lista
  TRegistroK156List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK156;
    procedure SetItem(Index: Integer; const Value: TRegistroK156);
  public
    function New(): TRegistroK156;
    property Items[Index: Integer]: TRegistroK156 read GetItem write SetItem;
  end;

  /// Registro K355 - Saldos Finais das Contas Cont�beis de Resultado
  /// Antes do Encerramento
  TRegistroK355 = class(TBlocos)
  private
    fCOD_CTA:        String;
    fVL_SLD_FIN:     Variant;
    fCOD_CCUS:       String;
    fIND_VL_SLD_FIN: String;

    FRegistroK356:   TRegistroK356List;
  public
    constructor Create(AOwner: TRegistroK030); /// Create
    destructor Destroy; override; /// Destroy

    property COD_CTA:        String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS:       String read fCOD_CCUS write fCOD_CCUS;
    property VL_SLD_FIN:     Variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: String read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;

    // registros filhos
    property RegistroK356: TRegistroK356List read FRegistroK356 write FRegistroK356;
  end;

  //  Registro K355 - Lista

  TRegistroK355List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK355;
    procedure SetItem(Index: Integer; const Value: TRegistroK355);
  public
    function New(AOwner: TRegistroK030): TRegistroK355;
    property Items[Index: Integer]: TRegistroK355 read GetItem write SetItem;
  end;

  /// Registro K356 - Mapeamento Referencial dos Saldos Finais das
  /// Contas de Resultado Antes do Encerramento
  TRegistroK356 = class(TBlocos)
  private
    fVL_SLD_FIN:     variant;
    fIND_VL_SLD_FIN: string;
    fCOD_CTA_REF:    string;
  public
    property COD_CTA_REF: string read fCOD_CTA_REF write fCOD_CTA_REF;
    property VL_SLD_FIN: variant read fVL_SLD_FIN write fVL_SLD_FIN;
    property IND_VL_SLD_FIN: string read fIND_VL_SLD_FIN write fIND_VL_SLD_FIN;
  end;

  //  Registro K356 - Lista

  TRegistroK356List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK356;
    procedure SetItem(Index: Integer; const Value: TRegistroK356);
  public
    function New(): TRegistroK356;
    property Items[Index: Integer]: TRegistroK356 read GetItem write SetItem;
  end;

  /// Registro K915
  TRegistroK915 = class(TBlocos)
  private
    fPER_APUR : String;
    fCOD_CTA : String;
    fCOD_CCUS : String;
    fID_REGRA : String;
    fVL_SLD_INI_ESP : Variant;
    fIND_VL_SLD_INI_ESP : String;
    fVL_DEB_ESP : Variant;
    fVL_CRED_ESP : Variant;
    fVL_SLD_FIN_ESP : Variant;
    fIND_VL_SLD_FIN_ESP : String;
    fSLD_INI_PRE : Variant;
    fIND_SLD_INI_PRE : String;
    fVL_DEB_PRE : Variant;
    fVL_CRED_PRE : Variant;
    fSLD_FIN_PRE : Variant;
    fIND_SLD_FIN_PRE : String;
    fJUSTIFICATIVA : String;
  public
    property PER_APUR: String read fPER_APUR write fPER_APUR;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property ID_REGRA: String read fID_REGRA write fID_REGRA;
    property VL_SLD_INI_ESP: Variant read fVL_SLD_INI_ESP write fVL_SLD_INI_ESP;
    property IND_VL_SLD_INI_ESP: String read fIND_VL_SLD_INI_ESP write fIND_VL_SLD_INI_ESP;
    property VL_DEB_ESP: Variant read fVL_DEB_ESP write fVL_DEB_ESP;
    property VL_CRED_ESP: Variant read fVL_CRED_ESP write fVL_CRED_ESP;
    property VL_SLD_FIN_ESP: Variant read fVL_SLD_FIN_ESP write fVL_SLD_FIN_ESP;
    property IND_VL_SLD_FIN_ESP: String read fIND_VL_SLD_FIN_ESP write fIND_VL_SLD_FIN_ESP;
    property SLD_INI_PRE: Variant read fSLD_INI_PRE write fSLD_INI_PRE;
    property IND_SLD_INI_PRE: String read fIND_SLD_INI_PRE write fIND_SLD_INI_PRE;
    property VL_DEB_PRE: Variant read fVL_DEB_PRE write fVL_DEB_PRE;
    property VL_CRED_PRE: Variant read fVL_CRED_PRE write fVL_CRED_PRE;
    property SLD_FIN_PRE: Variant read fSLD_FIN_PRE write fSLD_FIN_PRE;
    property IND_SLD_FIN_PRE: String read fIND_SLD_FIN_PRE write fIND_SLD_FIN_PRE;
    property JUSTIFICATIVA: String read fJUSTIFICATIVA write fJUSTIFICATIVA;
  end;

  //  Registro K915 - Lista
  TRegistroK915List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK915;
    procedure SetItem(Index: Integer; const Value: TRegistroK915);
  public
    function New(): TRegistroK915;
    property Items[Index: Integer]: TRegistroK915 read GetItem write SetItem;
  end;

  /// Registro K935
  TRegistroK935 = class(TBlocos)
  private
    fPER_APUR : String;
    fCOD_CTA : String;
    fCOD_CCUS : String;
    fID_REGRA : String;
    fVL_SLD_FIN_ESP : Variant;
    fIND_VL_SLD_FIN_ESP : String;
    fSLD_FIN_PRE : Variant;
    fIND_SLD_FIN_PRE : String;
    fJUSTIFICATIVA : String;
  public
    property PER_APUR: String read fPER_APUR write fPER_APUR;
    property COD_CTA: String read fCOD_CTA write fCOD_CTA;
    property COD_CCUS: String read fCOD_CCUS write fCOD_CCUS;
    property ID_REGRA: String read fID_REGRA write fID_REGRA;
    property VL_SLD_FIN_ESP: Variant read fVL_SLD_FIN_ESP write fVL_SLD_FIN_ESP;
    property IND_VL_SLD_FIN_ESP: String read fIND_VL_SLD_FIN_ESP write fIND_VL_SLD_FIN_ESP;
    property SLD_FIN_PRE: Variant read fSLD_FIN_PRE write fSLD_FIN_PRE;
    property IND_SLD_FIN_PRE: String read fIND_SLD_FIN_PRE write fIND_SLD_FIN_PRE;
    property JUSTIFICATIVA: String read fJUSTIFICATIVA write fJUSTIFICATIVA;
  end;

  //  Registro K935 - Lista
  TRegistroK935List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroK935;
    procedure SetItem(Index: Integer; const Value: TRegistroK935);
  public
    function New(): TRegistroK935;
    property Items[Index: Integer]: TRegistroK935 read GetItem write SetItem;
  end;

  /// Registro K990 - ENCERRAMENTO DO BLOCO K
  TRegistroK990 = class(TCloseBlocos)
    fQTD_LIN: Integer;    /// Quantidade total de linhas do Bloco I
  public
    property QTD_LIN: Integer read FQTD_LIN write FQTD_LIN;
  end;

implementation

{ TRegistroK030List }

function TRegistroK030List.GetItem(Index: Integer): TRegistroK030;
begin
  Result := TRegistroK030(Inherited Items[Index]);
end;

function TRegistroK030List.New(): TRegistroK030;
begin
  Result := TRegistroK030.Create();
  Add(Result);
end;

procedure TRegistroK030List.SetItem(Index: Integer; const Value: TRegistroK030);
begin
  Put(Index, Value);
end;

{ TRegistroK155List }

function TRegistroK155List.GetItem(Index: Integer): TRegistroK155;
begin
  Result := TRegistroK155(Inherited Items[Index]);
end;

function TRegistroK155List.New(AOwner: TRegistroK030): TRegistroK155;
begin
  Result := TRegistroK155.Create(AOwner);
  Add(Result);
end;

procedure TRegistroK155List.SetItem(Index: Integer; const Value: TRegistroK155);
begin
  Put(Index, Value);
end;

{ TRegistroK156List }

function TRegistroK156List.GetItem(Index: Integer): TRegistroK156;
begin
  Result := TRegistroK156(Inherited Items[Index]);
end;

function TRegistroK156List.New(): TRegistroK156;
begin
  Result := TRegistroK156.Create;
  Add(Result);
end;

procedure TRegistroK156List.SetItem(Index: Integer; const Value: TRegistroK156);
begin
  Put(Index, Value);
end;

{ TRegistroK030 }

constructor TRegistroK030.Create();
begin
   inherited Create;
   FRegistroK155 := TRegistroK155List.Create;
   FRegistroK355 := TRegistroK355List.Create;
end;

destructor TRegistroK030.Destroy;
begin
  FRegistroK355.Free;
  FRegistroK155.Free;
  
  inherited;
end;

{ TRegistroK355List }

function TRegistroK355List.GetItem(Index: Integer): TRegistroK355;
begin
  Result := TRegistroK355(Inherited Items[Index]);
end;

function TRegistroK355List.New(AOwner: TRegistroK030): TRegistroK355;
begin
  Result := TRegistroK355.Create(AOwner);
  Add(Result);
end;

procedure TRegistroK355List.SetItem(Index: Integer; const Value: TRegistroK355);
begin
  Put(Index, Value);
end;

{ TRegistroK155 }

constructor TRegistroK155.Create;
begin
   inherited Create;
   FRegistroK156 := TRegistroK156List.Create;
end;

destructor TRegistroK155.Destroy;
begin
   FRegistroK156.Free;
   inherited;
end;

{ TRegistroK356List }

function TRegistroK356List.GetItem(Index: Integer): TRegistroK356;
begin
   Result := TRegistroK356(Inherited Items[Index]);
end;

function TRegistroK356List.New(): TRegistroK356;
begin
  Result := TRegistroK356.Create;
  Add(Result);
end;

procedure TRegistroK356List.SetItem(Index: Integer; const Value: TRegistroK356);
begin
  Put(Index, Value);
end;

{ TRegistroK355 }

constructor TRegistroK355.Create;
begin
   inherited Create;
   FRegistroK356 := TRegistroK356List.Create;
end;

destructor TRegistroK355.Destroy;
begin
   FRegistroK356.Free;
   inherited;
end;

{ TRegistroK915List }

function TRegistroK915List.GetItem(Index: Integer): TRegistroK915;
begin
  Result := TRegistroK915(Inherited Items[Index]);
end;

function TRegistroK915List.New: TRegistroK915;
begin
  Result := TRegistroK915.Create();
  Add(Result);
end;

procedure TRegistroK915List.SetItem(Index: Integer; const Value: TRegistroK915);
begin
  Put(Index, Value);
end;

{ TRegistroK935List }

function TRegistroK935List.GetItem(Index: Integer): TRegistroK935;
begin
  Result := TRegistroK935(Inherited Items[Index]);
end;

function TRegistroK935List.New: TRegistroK935;
begin
  Result := TRegistroK935.Create();
  Add(Result);
end;

procedure TRegistroK935List.SetItem(Index: Integer; const Value: TRegistroK935);
begin
  Put(Index, Value);
end;

{ TRegistroK001 }

constructor TRegistroK001.Create;
begin
  inherited Create;
  FRegistroK030 := TRegistroK030List.Create;
  FRegistroK915 := TRegistroK915List.Create;
  FRegistroK935 := TRegistroK935List.Create;
  //
  IND_DAD := idComDados;;
end;

destructor TRegistroK001.Destroy;
begin
  FRegistroK030.Free;
  FRegistroK915.Free;
  FRegistroK935.Free;
  inherited;
end;

end.
