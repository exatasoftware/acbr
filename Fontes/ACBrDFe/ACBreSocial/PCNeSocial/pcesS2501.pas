{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 28/08/2017: Leivio Fontenele - leivio@yahoo.com.br
|*  - Implementa��o comunica��o, envelope, status e retorno do componente com webservice.
******************************************************************************}

{$I ACBr.inc}

unit pcesS2501;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$ELSE}
   Contnrs,
  {$IFEND}
  ACBrBase, pcnConversao, pcnConsts,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2501Collection = class;
  TS2501CollectionItem = class;
  TEvtContProc = class;
  TIdeProc = class;
  TIdeTrabCollection = class;
  TIdeTrabCollectionItem = class;
  TCalcTribCollection = class;
  TCalcTribCollectionItem = class;
  TInfoCRContribCollection = class;
  TInfoCRContribCollectionItem = class;
  TInfoCRIRRFCollection = class;
  TInfoCRIRRFCollectionItem = class;

  TS2501Collection = class(TeSocialCollection)
  private
    function GetItem(Index: Integer): TS2501CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2501CollectionItem);
  public
    function New: TS2501CollectionItem;
    property Items[Index: Integer]: TS2501CollectionItem read GetItem write SetItem; default;
  end;

  TS2501CollectionItem = class(TObject)
  private
    FTipoEvento: TTipoEvento;
    FEvtContProc: TEvtContProc;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtContProc: TEvtContProc read FEvtContProc write FEvtContProc;
  end;

  TEvtContProc = class(TESocialEvento)
  private
    FideEvento: TIdeEvento2;
    FideEmpregador: TIdeEmpregador;
    FideProc: TIdeProc;
    FideTrab: TIdeTrabCollection;

    procedure GerarIdeProc(obj: TIdeProc);
    procedure GerarIdeTrab(obj: TIdeTrabCollection);
    procedure GerarCalcTrib(obj: TCalcTribCollection);
    procedure GerarInfoCRIRRF(obj: TInfoCRIRRFCollection);
    procedure GerarInfoCRContrib(obj: TInfoCRContribCollection);
  public
    constructor Create(AACBreSocial: TObject); override;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property ideEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property ideEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property ideProc: TIdeProc read FideProc write FideProc;
    property ideTrab: TIdeTrabCollection read FideTrab write FideTrab;
  end;

  TIdeProc = class(TObject)
  private
    FnrProcTrab: string;
    FperApurPgto: string;
    Fobs: string;
  public
    property nrProcTrab: string read FnrProcTrab write FnrProcTrab;
    property perApurPgto: string read FperApurPgto write FperApurPgto;
    property obs: string read Fobs write Fobs;
  end;

  TIdeTrabCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TIdeTrabCollectionItem;
    procedure SetItem(Index: Integer; Value: TIdeTrabCollectionItem);
  public
    function New: TIdeTrabCollectionItem;
    property Items[Index: Integer]: TIdeTrabCollectionItem read GetItem write SetItem; default;
  end;

  TIdeTrabCollectionItem = class(TObject)
  private
    FcpfTrab: string;
    FcalcTrib: TCalcTribCollection;
    FinfoCRIRRF: TInfoCRIRRFCollection;

    function getCalcTrib(): TCalcTribCollection;
    function getInfoCRIRRF(): TInfoCRIRRFCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function instCalcTrib(): boolean;
    function instInfoCRIRRF(): boolean;

    property cpfTrab: string read FcpfTrab write FcpfTrab;
    property calcTrib: TCalcTribCollection read getCalcTrib write FcalcTrib;
    property infoCRIRRF: TInfoCRIRRFCollection read getInfoCRIRRF write FinfoCRIRRF;
  end;

  TCalcTribCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TCalcTribCollectionItem;
    procedure SetItem(Index: Integer; Value: TCalcTribCollectionItem);
  public
    function New: TCalcTribCollectionItem;
    property Items[Index: Integer]: TCalcTribCollectionItem read GetItem write SetItem; default;
  end;

  TCalcTribCollectionItem = class(TObject)
  private
    FperRef: string;
    FvrBcCpMensal: double;
    FvrBcCp13: double;
    FvrRendIRRF: double;
    FvrRendIRRF13: double;
    FinfoCRContrib: TInfoCRContribCollection;

    function getInfoCRContrib(): TInfoCRContribCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    function instInfoCRContrib(): boolean;

    property perRef: string read FperRef write FperRef;
    property vrBcCpMensal: double read FvrBcCpMensal write FvrBcCpMensal;
    property vrBcCp13: double read FvrBcCp13 write FvrBcCp13;
    property vrRendIRRF: double read FvrRendIRRF write FvrRendIRRF;
    property vrRendIRRF13: double read FvrRendIRRF13 write FvrRendIRRF13;
    property infoCRContrib: TInfoCRContribCollection read getInfoCRContrib write FinfoCRContrib;
  end;

  TInfoCRContribCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoCRContribCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCRContribCollectionItem);
  public
    function New: TInfoCRContribCollectionItem;
    property Items[Index: Integer]: TInfoCRContribCollectionItem read GetItem write SetItem; default;
  end;

  TInfoCRContribCollectionItem = class(TObject)
  private
    FtpCR: string;
    FvrCR: double;
  public
    property tpCR: string read FtpCR write FtpCR;
    property vrCR: double read FvrCR write FvrCR;
  end;

  TInfoCRIRRFCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfoCRIRRFCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCRIRRFCollectionItem);
  public
    function New: TInfoCRIRRFCollectionItem;
    property Items[Index: Integer]: TInfoCRIRRFCollectionItem read GetItem write SetItem; default;
  end;

  TInfoCRIRRFCollectionItem = class(TObject)
  private
    FtpCR: string;
    FvrCR: double;
  public
    property tpCR: string read FtpCR write FtpCR;
    property vrCR: double read FvrCR write FvrCR;
  end;

implementation

uses
  IniFiles,
  ACBrUtil.FilesIO,
  ACBreSocial;

{ TS2501Collection }

function TS2501Collection.GetItem(Index: Integer): TS2501CollectionItem;
begin
  Result := TS2501CollectionItem(inherited Items[Index]);
end;

procedure TS2501Collection.SetItem(Index: Integer;
  Value: TS2501CollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TS2501Collection.New: TS2501CollectionItem;
begin
  Result := TS2501CollectionItem.Create(FACBreSocial);
  Self.Add(Result);
end;

{ TS2501CollectionItem }

constructor TS2501CollectionItem.Create(AOwner: TComponent);
begin
  inherited Create;

  FTipoEvento  := teS2501;
  FEvtContProc := TEvtContProc.Create(AOwner);
end;

destructor TS2501CollectionItem.Destroy;
begin
  FEvtContProc.Free;

  inherited;
end;

{ TIdeTrabCollection }

function TIdeTrabCollection.GetItem(Index: Integer): TIdeTrabCollectionItem;
begin
  Result := TIdeTrabCollectionItem(inherited Items[Index]);
end;

procedure TIdeTrabCollection.SetItem(Index: Integer; Value: TIdeTrabCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TIdeTrabCollection.New: TIdeTrabCollectionItem;
begin
  Result := TIdeTrabCollectionItem.Create;
  Self.Add(Result);
end;

{ TIdeTrabCollectionItem }

constructor TIdeTrabCollectionItem.Create;
begin
  inherited Create;

  FcalcTrib   := nil;
  FinfoCRIRRF := nil;
end;

destructor TIdeTrabCollectionItem.Destroy;
begin
  if instCalcTrib() then
    FreeAndNil(FcalcTrib);
  if instInfoCRIRRF() then
    FreeAndNil(FInfoCRIRRF);

  inherited;
end;

function TIdeTrabCollectionItem.getCalcTrib(): TCalcTribCollection;
begin
  if not Assigned(FcalcTrib) then
    FcalcTrib := TCalcTribCollection.Create;
  Result := FcalcTrib;
end;

function TIdeTrabCollectionItem.getInfoCRIRRF(): TInfoCRIRRFCollection;
begin
  if not Assigned(FInfoCRIRRF) then
    FInfoCRIRRF := TInfoCRIRRFCollection.Create;
  Result := FInfoCRIRRF;
end;

function TIdeTrabCollectionItem.instCalcTrib(): boolean;
begin
  Result := Assigned(FcalcTrib);
end;

function TIdeTrabCollectionItem.instInfoCRIRRF(): boolean;
begin
  Result := Assigned(FInfoCRIRRF);
end;

{ TCalcTribCollection }

function TCalcTribCollection.GetItem(Index: Integer): TCalcTribCollectionItem;
begin
  Result := TCalcTribCollectionItem(inherited Items[Index]);
end;

procedure TCalcTribCollection.SetItem(Index: Integer; Value: TCalcTribCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TCalcTribCollection.New: TCalcTribCollectionItem;
begin
  Result := TCalcTribCollectionItem.Create;
  Self.Add(Result);
end;

{ TCalcTribCollectionItem }

constructor TCalcTribCollectionItem.Create;
begin
  inherited Create;

  FinfoCRContrib := nil;
end;

destructor TCalcTribCollectionItem.Destroy;
begin
  if instInfoCRContrib() then
    FreeAndNil(FinfoCRContrib);

  inherited;
end;

function TCalcTribCollectionItem.getInfoCRContrib(): TInfoCRContribCollection;
begin
  if not Assigned(FinfoCRContrib) then
    FinfoCRContrib := TInfoCRContribCollection.Create;
  Result := FinfoCRContrib;
end;

function TCalcTribCollectionItem.instInfoCRContrib(): boolean;
begin
  Result := Assigned(FInfoCRContrib);
end;

{ TInfoCRContribCollection }

function TInfoCRContribCollection.GetItem(Index: Integer): TInfoCRContribCollectionItem;
begin
  Result := TInfoCRContribCollectionItem(inherited Items[Index]);
end;

procedure TInfoCRContribCollection.SetItem(Index: Integer; Value: TInfoCRContribCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoCRContribCollection.New: TInfoCRContribCollectionItem;
begin
  Result := TInfoCRContribCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfoCRIRRFCollection }

function TInfoCRIRRFCollection.GetItem(Index: Integer): TInfoCRIRRFCollectionItem;
begin
  Result := TInfoCRIRRFCollectionItem(inherited Items[Index]);
end;

procedure TInfoCRIRRFCollection.SetItem(Index: Integer; Value: TInfoCRIRRFCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfoCRIRRFCollection.New: TInfoCRIRRFCollectionItem;
begin
  Result := TInfoCRIRRFCollectionItem.Create;
  Self.Add(Result);
end;

{ TEvtContProc }

constructor TEvtContProc.Create(AACBreSocial: TObject);
begin
  inherited Create(AACBreSocial);

  FideEvento     := TideEvento2.Create;
  FideEmpregador := TideEmpregador.Create;
  FideProc       := TIdeProc.Create;
  FideTrab       := TIdeTrabCollection.Create;
end;

destructor TEvtContProc.Destroy;
begin
  FideEvento.Free;
  FideEmpregador.Free;
  FideProc.Free;
  FideTrab.Free;

  inherited;
end;

procedure TEvtContProc.GerarIdeTrab(obj: TIdeTrabCollection);
var
  i: integer;
begin
  for i := 0 to obj.Count - 1 do
  begin
    Gerador.wGrupo('ideTrab');

    Gerador.wCampo(tcStr, '', 'cpfTrab',  11, 11, 1, obj.Items[i].cpfTrab);

    if obj.Items[i].instCalcTrib() then
      GerarCalcTrib(obj.Items[i].calcTrib);

    if obj.Items[i].instInfoCRIRRF() then
      GerarInfoCRIRRF(obj.items[i].infoCRIRRF);

    Gerador.wGrupo('/ideTrab');
  end;
end;

procedure TEvtContProc.GerarInfoCRContrib(obj: TInfoCRContribCollection);
var
  i: integer;
begin
  for i := 0 to obj.Count - 1 do
  begin
    Gerador.wGrupo('infoCRContrib');

    Gerador.wCampo(tcStr, '', 'tpCR', 6,  6, 1, obj.Items[i].tpCR);
    Gerador.wCampo(tcDe2, '', 'vrCR', 1, 14, 1, obj.Items[i].vrCR);

    Gerador.wGrupo('/infoCRContrib');
  end;
end;

procedure TEvtContProc.GerarCalcTrib(obj: TCalcTribCollection);
var
  i: integer;
begin
  for i := 0 to obj.Count - 1 do
  begin
    Gerador.wGrupo('calcTrib');

    Gerador.wCampo(tcStr, '', 'perRef',       7,  7, 1, obj.Items[i].perRef);
    Gerador.wCampo(tcDe2, '', 'vrBcCpMensal', 1, 14, 1, obj.Items[i].vrBcCpMensal);
    Gerador.wCampo(tcDe2, '', 'vrBcCp13',     1, 14, 1, obj.Items[i].vrBcCp13);
    Gerador.wCampo(tcDe2, '', 'vrRendIRRF',   1, 14, 1, obj.Items[i].vrRendIRRF);
    Gerador.wCampo(tcDe2, '', 'vrRendIRRF13', 1, 14, 1, obj.Items[i].vrRendIRRF13);

    if obj.Items[i].instInfoCRContrib() then
      GerarInfoCRContrib(obj.Items[i].infoCrContrib);

    Gerador.wGrupo('/calcTrib');
  end;
end;

procedure TEvtContProc.GerarInfoCRIRRF(obj: TInfoCRIRRFCollection);
var
  i: integer;
begin
  for i := 0 to obj.Count - 1 do
  begin
    Gerador.wGrupo('infoCRIRRF');

    Gerador.wCampo(tcStr, '', 'tpCR', 6,  6, 1, obj.Items[i].tpCR);
    Gerador.wCampo(tcDe2, '', 'vrCR', 1, 14, 1, obj.Items[i].vrCR);

    Gerador.wGrupo('/infoCRIRRF');
  end;
end;

procedure TEvtContProc.GerarIdeProc(obj: TIdeProc);
begin
  Gerador.wGrupo('ideProc');

  Gerador.wCampo(tcStr, '', 'nrProcTrab',  15,  20, 1, obj.nrProcTrab);
  Gerador.wCampo(tcStr, '', 'perApurPgto',  7,   7, 1, obj.perApurPgto);

  if obj.obs <> '' then
    Gerador.wCampo(tcStr, '', 'obs',        0, 999, 0, obj.obs);

  Gerador.wGrupo('/ideProc');
end;

function TEvtContProc.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;

    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtContProc');
    Gerador.wGrupo('evtContProc Id="' + Self.Id + '"');

    GerarIdeEvento2(self.ideEvento);
    GerarIdeEmpregador(self.ideEmpregador);
    GerarIdeProc(self.ideProc);
    GerarIdeTrab(self.ideTrab);

    Gerador.wGrupo('/evtContProc');

    GerarRodape;

    FXML := Gerador.ArquivoFormatoXML;
//    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtContProc');

//    Validar(schevtContProc);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtContProc.LerArqIni(const AIniString: String): Boolean;
begin
  Result := True;
end;

end.
