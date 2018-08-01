{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 29/02/2016: Guilherme Costa
|*  - Alterado os atributos que n�o estavam de acordo com o leiaute/xsd
******************************************************************************}
{$I ACBr.inc}

unit pcesS5012;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnLeitor, ACBrUtil,
  pcesCommon, pcesConversaoeSocial;

type
  TS5012 = class;
  TInfoIRRF = class;
  TInfoCRContribCollection = class;
  TInfoCRContribCollectionItem = class;

  TEvtIrrf = class;

  TS5012 = class(TInterfacedObject, IEventoeSocial)
  private
    FTipoEvento: TTipoEvento;
    FEvtIrrf: TEvtIrrf;

    function GetXml : string;
    procedure SetXml(const Value: string);
    function GetTipoEvento : TTipoEvento;
    procedure SetEvtIrrf(const Value: TEvtIrrf);

  public
    constructor Create;
    destructor Destroy; override;

    function GetEvento : TObject;

  published
    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
    property EvtIrrf: TEvtIrrf read FEvtIrrf write setEvtIrrf;

  end;

  TInfoCRContribCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoCRContribCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCRContribCollectionItem);
  public
    constructor Create; reintroduce;
    function Add: TInfoCRContribCollectionItem;
    property Items[Index: Integer]: TInfoCRContribCollectionItem read GetItem write SetItem;
  end;

  TInfoCRContribCollectionItem = class(TCollectionItem)
  private
    FtpCR: String;
    FvrCR: Double;
  public
    property tpCR: String read FtpCR;
    property vrCR: Double read FvrCR;
  end;

  TInfoIRRF = class(TPersistent)
  private
    FnrRecArqBase: String;
    FindExistInfo: Integer;
    FInfoCRContrib: TInfoCRContribCollection;

    procedure SetInfoCRContrib(const Value: TInfoCRContribCollection);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property nrRecArqBase: String read FnrRecArqBase;
    property indExistInfo: Integer read FindExistInfo;
    property InfoCRContrib: TInfoCRContribCollection read FInfoCRContrib write SetInfoCRContrib;
  end;

  TEvtIrrf = class(TPersistent)
  private
    FLeitor: TLeitor;
    FId: String;
    FXML: String;

    FIdeEvento: TIdeEvento5;
    FIdeEmpregador: TIdeEmpregador;
    FInfoIRRF: TInfoIRRF;
  public
    constructor Create;
    destructor  Destroy; override;

    function LerXML: Boolean;
    function SalvarINI: boolean;

    property IdeEvento: TIdeEvento5 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property InfoIRRF: TInfoIRRF read FInfoIRRF write FInfoIRRF;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Id: String      read FId;
    property XML: String     read FXML;
  end;

implementation

uses
  IniFiles;

{ TS5012 }

constructor TS5012.Create;
begin
  FTipoEvento := teS5012;
  FEvtIrrf := TEvtIrrf.Create;
end;

destructor TS5012.Destroy;
begin
  FEvtIrrf.Free;

  inherited;
end;

function TS5012.GetEvento : TObject;
begin
  Result := self;
end;

function TS5012.GetXml : string;
begin
  Result := FEvtIrrf.XML;
end;

procedure TS5012.SetXml(const Value: string);
begin
  if Value = FEvtIrrf.XML then Exit;

  FEvtIrrf.FXML := Value;
  FEvtIrrf.Leitor.Arquivo := Value;
  FEvtIrrf.LerXML;

end;

function TS5012.GetTipoEvento : TTipoEvento;
begin
  Result := FTipoEvento;
end;

procedure TS5012.SetEvtIrrf(const Value: TEvtIrrf);
begin
  FEvtIrrf.Assign(Value);
end;

{ TEvtIrrf }

constructor TEvtIrrf.Create;
begin
  FLeitor := TLeitor.Create;

  FIdeEvento := TIdeEvento5.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FInfoIRRF := TInfoIRRF.Create;
end;

destructor TEvtIrrf.Destroy;
begin
  FLeitor.Free;

  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FInfoIRRF.Free;

  inherited;
end;

{ TInfoCRContribCollection }

function TInfoCRContribCollection.Add: TInfoCRContribCollectionItem;
begin
  Result := TInfoCRContribCollectionItem(inherited Add);
end;

constructor TInfoCRContribCollection.Create;
begin
  inherited create(TInfoCRContribCollectionItem);
end;

function TInfoCRContribCollection.GetItem(
  Index: Integer): TInfoCRContribCollectionItem;
begin
  Result := TInfoCRContribCollectionItem(inherited GetItem(Index));
end;

procedure TInfoCRContribCollection.SetItem(Index: Integer;
  Value: TInfoCRContribCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TInfoIRRF }

constructor TInfoIRRF.Create;
begin
   FInfoCRContrib := TInfoCRContribCollection.Create;
end;

destructor TInfoIRRF.Destroy;
begin
  FInfoCRContrib.Free;

  inherited;
end;

procedure TInfoIRRF.SetInfoCRContrib(const Value: TInfoCRContribCollection);
begin
  FInfoCRContrib := Value;
end;

function TEvtIrrf.LerXML: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    FXML := Leitor.Arquivo;

    if leitor.rExtrai(1, 'evtIrrf') <> '' then
    begin
      FId := Leitor.rAtributo('Id=');

      if leitor.rExtrai(2, 'ideEvento') <> '' then
        IdeEvento.perApur := leitor.rCampo(tcStr, 'perApur');

      if leitor.rExtrai(2, 'ideEmpregador') <> '' then
      begin
        IdeEmpregador.TpInsc := eSStrToTpInscricao(ok, leitor.rCampo(tcStr, 'tpInsc'));
        IdeEmpregador.NrInsc := leitor.rCampo(tcStr, 'nrInsc');
      end;

      if leitor.rExtrai(2, 'infoIRRF') <> '' then
      begin
        infoIRRF.FnrRecArqBase := leitor.rCampo(tcStr, 'nrRecArqBase');
        infoIRRF.FindExistInfo := leitor.rCampo(tcInt, 'indExistInfo');

        i := 0;
        while Leitor.rExtrai(3, 'infoCRContrib', '', i + 1) <> '' do
        begin
          infoIRRF.infoCRContrib.Add;
          infoIRRF.infoCRContrib.Items[i].FtpCR := leitor.rCampo(tcStr, 'tpCR');
          infoIRRF.infoCRContrib.Items[i].FvrCR := leitor.rCampo(tcDe2, 'vrCR');
          inc(i);
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TEvtIrrf.SalvarINI: boolean;
var
  AIni: TMemIniFile;
  sSecao: String;
  i: Integer;
begin
  Result := False;

  AIni := TMemIniFile.Create('');
  try
    Result := True;

    with Self do
    begin
      sSecao := 'evtIrrf';
      AIni.WriteString(sSecao, 'Id', Id);

      sSecao := 'ideEvento';
      AIni.WriteString(sSecao, 'perApur', IdeEvento.perApur);

      sSecao := 'ideEmpregador';
      AIni.WriteString(sSecao, 'tpInsc', eSTpInscricaoToStr(IdeEmpregador.TpInsc));
      AIni.WriteString(sSecao, 'nrInsc', IdeEmpregador.nrInsc);

      sSecao := 'infoIRRF';
      AIni.WriteString(sSecao, 'nrRecArqBase',  infoIRRF.nrRecArqBase);
      AIni.WriteInteger(sSecao, 'indExistInfo', infoIRRF.indExistInfo);

      for i := 0 to infoIRRF.InfoCRContrib.Count -1 do
      begin
        sSecao := 'InfoCRContrib' + IntToStrZero(I, 1);

        with infoIRRF.InfoCRContrib.Items[i] do
        begin
          AIni.WriteString(sSecao, 'tpCR', tpCR);
          AIni.WriteFloat(sSecao, 'vrCR',  vrCR);
        end;
      end;
    end;
  finally
    AIni.Free;
  end;
end;

end.

