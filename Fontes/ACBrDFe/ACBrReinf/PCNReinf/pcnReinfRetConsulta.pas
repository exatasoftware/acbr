{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Leivio Ramos de Fontenele                       }
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

unit pcnReinfRetConsulta;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrUtil, pcnAuxiliar, pcnConversao, pcnLeitor,
  pcnCommonReinf, pcnConversaoReinf;

type
  TRetConsulta = class;
  TEvtTotalContrib = class;
  TInfoRecEv = class;
  TInfoTotalContrib = class;
  TRTomCollection = class;
  TRTomCollectionItem = class;
  TRPrestCollection = class;
  TRPrestCollectionItem = class;
  TRRecRepADCollection = class;
  TRRecRepADCollectionItem = class;
  TRComlCollection = class;
  TRComlCollectionItem = class;
  TRCPRBCollection = class;
  TRCPRBCollectionItem = class;
  TinfoCRTomCollection = class;
  TinfoCRTomCollectionItem = class;
  TRetornoEventosCollection = class;
  TRetornoEventosCollectionItem = class;

  TInfoRecEv = class(TObject)
  private
    FnrProtEntr: String;
    FdhProcess: TDateTime;
    FtpEv: String;
    FidEv: String;
    Fhash: String;
  public
    property nrProtEntr: String read FnrProtEntr;
    property dhProcess: TDateTime read FdhProcess;
    property tpEv: String read FtpEv;
    property idEv: String read FidEv;
    property hash: String read Fhash;
  end;

  TInfoTotalContrib = class(TObject)
  private
    FnrRecArqBase: String;
    FindExistInfo: TindExistInfo;
    FRTom: TRTomCollection;
    FRPrest: TRPrestCollection;
    FRRecRepAD: TRRecRepADCollection;
    FRComl: TRComlCollection;
    FRCPRB: TRCPRBCollection;

    procedure SetRComl(const Value: TRComlCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property nrRecArqBase: String read FnrRecArqBase;
    property indExistInfo: TindExistInfo read FindExistInfo;
    property RTom: TRTomCollection read FRTom;
    property RPrest: TRPrestCollection read FRPrest;
    property RRecRepAD: TRRecRepADCollection read FRRecRepAD;
    property RComl: TRComlCollection read FRComl write SetRComl;
    property RCPRB: TRCPRBCollection read FRCPRB;
  end;

  TinfoCRTomCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfoCRTomCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfoCRTomCollectionItem);
  public
    function Add: TinfoCRTomCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TinfoCRTomCollectionItem;

    property Items[Index: Integer]: TinfoCRTomCollectionItem read GetItem write SetItem;
  end;

  TinfoCRTomCollectionItem = class(TObject)
  private
    FCRTom: string;
    FVlrCRTom: Double;
    FVlrCRTomSusp: Double;
  public
    property CRTom: string read FCRTom;
    property VlrCRTom: Double read FVlrCRTom;
    property VlrCRTomSusp: Double read FVlrCRTomSusp;
  end;

  TRTomCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRTomCollectionItem;
    procedure SetItem(Index: Integer; Value: TRTomCollectionItem);
  public
    function Add: TRTomCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRTomCollectionItem;

    property Items[Index: Integer]: TRTomCollectionItem read GetItem write SetItem;
  end;

  TRTomCollectionItem = class(TObject)
  private
    FcnpjPrestador: String;
    FvlrTotalBaseRet: Double;
    FvlrTotalRetPrinc: Double;
    FvlrTotalRetAdic: Double;
    FvlrTotalNRetPrinc: Double;
    FvlrTotalNRetAdic: Double;
    FinfoCRTom: TinfoCRTomCollection;

    procedure SetinfoCRTom(const Value: TinfoCRTomCollection); // ????
  public
    constructor Create;
    destructor Destroy; override;

    property cnpjPrestador: String read FcnpjPrestador;
    property vlrTotalBaseRet: Double read FvlrTotalBaseRet;
    property vlrTotalRetPrinc: Double read FvlrTotalRetPrinc;
    property vlrTotalRetAdic: Double read FvlrTotalRetAdic;
    property vlrTotalNRetPrinc: Double read FvlrTotalNRetPrinc;
    property vlrTotalNRetAdic: Double read FvlrTotalNRetAdic;
    property infoCRTom: TinfoCRTomCollection read FinfoCRTom write SetinfoCRTom;
  end;

  TRPrestCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRPrestCollectionItem;
    procedure SetItem(Index: Integer; Value: TRPrestCollectionItem);
  public
    function Add: TRPrestCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRPrestCollectionItem;

    property Items[Index: Integer]: TRPrestCollectionItem read GetItem write SetItem;
  end;

  TRPrestCollectionItem = class(TObject)
  private
    FtpInscTomador: TtpInsc;
    FnrInscTomador: String;
    FvlrTotalBaseRet: Double;
    FvlrTotalRetPrinc: Double;
    FvlrTotalRetAdic: Double;
    FvlrTotalNRetPrinc: Double;
    FvlrTotalNRetAdic: Double;
  public
    property tpInscTomador: TtpInsc read FtpInscTomador;
    property nrInscTomador: String read FnrInscTomador;
    property vlrTotalBaseRet: Double read FvlrTotalBaseRet;
    property vlrTotalRetPrinc: Double read FvlrTotalRetPrinc;
    property vlrTotalRetAdic: Double read FvlrTotalRetAdic;
    property vlrTotalNRetPrinc: Double read FvlrTotalNRetPrinc;
    property vlrTotalNRetAdic: Double read FvlrTotalNRetAdic;
  end;

  TRRecRepADCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRRecRepADCollectionItem;
    procedure SetItem(Index: Integer; Value: TRRecRepADCollectionItem);
  public
    function Add: TRRecRepADCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRRecRepADCollectionItem;

    property Items[Index: Integer]: TRRecRepADCollectionItem read GetItem write SetItem;
  end;

  TRRecRepADCollectionItem = class(TObject)
  private
    FcnpjAssocDesp: string;
    FvlrTotalRep: Double;
    FvlrTotalRet: Double;
    FvlrTotalNRet: Double;
    FCRRecRepAD: String;
    FvlrCRRecRepAD: Double;
    FvlrCRRecRepADSusp: Double;
  public
    property cnpjAssocDesp: string read FcnpjAssocDesp;
    property vlrTotalRep: Double read FvlrTotalRep;
    property vlrTotalRet: Double read FvlrTotalRet;
    property vlrTotalNRet: Double read FvlrTotalNRet;
    property CRRecRepAD: String read FCRRecRepAD;
    property vlrCRRecRepAD: Double read FvlrCRRecRepAD;
    property vlrCRRecRepADSusp: Double read FvlrCRRecRepADSusp;
  end;

  TRComlCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRComlCollectionItem;
    procedure SetItem(Index: Integer; Value: TRComlCollectionItem);
  public
    function Add: TRComlCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRComlCollectionItem;

    property Items[Index: Integer]: TRComlCollectionItem read GetItem write SetItem;
  end;

  TRComlCollectionItem = class(TObject)
  private
    FvlrCPApur: Double;
    FvlrRatApur: Double;
    FvlrSenarApur: Double;
    FvlrCPSusp: Double;
    FvlrRatSusp: Double;
    FvlrSenarSusp: Double;
    FCRComl: String;
    FvlrCRComl: Double;
    FvlrCRComlSusp: Double;
  public
    property vlrCPApur: Double read FvlrCPApur;
    property vlrRatApur: Double read FvlrRatApur;
    property vlrSenarApur: Double read FvlrSenarApur;
    property vlrCPSusp: Double read FvlrCPSusp;
    property vlrRatSusp: Double read FvlrRatSusp;
    property vlrSenarSusp: Double read FvlrSenarSusp;
    property CRComl: String read FCRComl;
    property vlrCRComl: Double read FvlrCRComl;
    property vlrCRComlSusp: Double read FvlrCRComlSusp;
  end;

  TRCPRBCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRCPRBCollectionItem;
    procedure SetItem(Index: Integer; Value: TRCPRBCollectionItem);
  public
    function Add: TRCPRBCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRCPRBCollectionItem;

    property Items[Index: Integer]: TRCPRBCollectionItem read GetItem write SetItem;
  end;

  TRCPRBCollectionItem = class(TObject)
  private
    FcodRec: Integer;
    FvlrCPApurTotal: Double;
    FvlrCPRBSusp: Double;
    FCRCPRB: String;
    FvlrCRCPRB: Double;
    FvlrCRCPRBSusp: Double;
  public
    property codRec: Integer read FcodRec;
    property vlrCPApurTotal: Double read FvlrCPApurTotal;
    property vlrCPRBSusp: Double read FvlrCPRBSusp;
    property CRCPRB: String read FCRCPRB;
    property vlrCRCPRB: Double read FvlrCRCPRB;
    property vlrCRCPRBSusp: Double read FvlrCRCPRBSusp;
  end;

  TRetornoEventosCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetornoEventosCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetornoEventosCollectionItem);
  public
    function Add: TRetornoEventosCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetornoEventosCollectionItem;

    property Items[Index: Integer]: TRetornoEventosCollectionItem read GetItem write SetItem;
  end;

  TRetornoEventosCollectionItem = class(TObject)
  private
    FId: String;
    FnrRecibo: String;
    FdtHoraRecebimento: String;
    FsituacaoEvento: String;
    FaplicacaoRecepcao: String;
    FiniValid: String;
  public
    property id: String read FId write FId;
    property dtHoraRecebimento: String read FdtHoraRecebimento write FdtHoraRecebimento;
    property nrRecibo: String read FnrRecibo write FnrRecibo;
    property situacaoEvento: String read FsituacaoEvento write FsituacaoEvento;
    property aplicacaoRecepcao: String read FaplicacaoRecepcao write FaplicacaoRecepcao;
    property iniValid: String read FiniValid write FiniValid;
  end;

  TEvtTotalContrib = class(TObject)
  private
    FId: String;

    FIdeEvento: TIdeEvento1;
    FIdeContri: TIdeContrib;
    FIdeStatus: TIdeStatus;
    FInfoRecEv: TInfoRecEv;
    FInfoTotalContrib: TInfoTotalContrib;
    FRetornoEventos: TRetornoEventosCollection;
  public
    constructor Create;
    destructor  Destroy; override;

    property Id: String read FId write FId;
    property IdeEvento: TIdeEvento1 read FIdeEvento write FIdeEvento;
    property IdeContri: TIdeContrib read FIdeContri write FIdeContri;
    property IdeStatus: TIdeStatus read FIdeStatus write FIdeStatus;
    property InfoRecEv: TInfoRecEv read FInfoRecEv write FInfoRecEv;
    property InfoTotalContrib: TInfoTotalContrib read FInfoTotalContrib write FInfoTotalContrib;
    property RetornoEventos: TRetornoEventosCollection read FRetornoEventos write FRetornoEventos;
  end;

  TRetConsulta = class(TObject)
  private
    FLeitor: TLeitor;
    FevtTotalContrib: TEvtTotalContrib;
    FXML: String;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: boolean;
    function SalvarINI: boolean;

    property Leitor: TLeitor read FLeitor write FLeitor;
    property evtTotalContrib: TEvtTotalContrib read FevtTotalContrib write FevtTotalContrib;
    property XML: String read FXML;
  end;

implementation

uses
  IniFiles, DateUtils;

{ TRTomCollection }

function TRTomCollection.Add: TRTomCollectionItem;
begin
  Result := Self.New;
end;

function TRTomCollection.GetItem(Index: Integer): TRTomCollectionItem;
begin
  Result := TRTomCollectionItem(inherited Items[Index]);
end;

function TRTomCollection.New: TRTomCollectionItem;
begin
  Result := TRTomCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRTomCollection.SetItem(Index: Integer;
  Value: TRTomCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRTomCollectionItem }

constructor TRTomCollectionItem.Create;
begin
  FinfoCRTom := TinfoCRTomCollection.Create;
end;

destructor TRTomCollectionItem.Destroy;
begin
  FinfoCRTom.Free;

  inherited;
end;

procedure TRTomCollectionItem.SetinfoCRTom(const Value: TinfoCRTomCollection);
begin
  FinfoCRTom := Value;
end;

{ TRPrestCollection }

function TRPrestCollection.Add: TRPrestCollectionItem;
begin
  Result := Self.New;
end;

function TRPrestCollection.GetItem(Index: Integer): TRPrestCollectionItem;
begin
  Result := TRPrestCollectionItem(inherited Items[Index]);
end;

function TRPrestCollection.New: TRPrestCollectionItem;
begin
  Result := TRPrestCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRPrestCollection.SetItem(Index: Integer;
  Value: TRPrestCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRRecRepADCollection }

function TRRecRepADCollection.Add: TRRecRepADCollectionItem;
begin
  Result := Self.New;
end;

function TRRecRepADCollection.GetItem(
  Index: Integer): TRRecRepADCollectionItem;
begin
  Result := TRRecRepADCollectionItem(inherited Items[Index]);
end;

function TRRecRepADCollection.New: TRRecRepADCollectionItem;
begin
  Result := TRRecRepADCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRRecRepADCollection.SetItem(Index: Integer;
  Value: TRRecRepADCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRCPRBCollection }

function TRCPRBCollection.Add: TRCPRBCollectionItem;
begin
  Result := Self.New;
end;

function TRCPRBCollection.GetItem(Index: Integer): TRCPRBCollectionItem;
begin
  Result := TRCPRBCollectionItem(inherited Items[Index]);
end;

function TRCPRBCollection.New: TRCPRBCollectionItem;
begin
  Result := TRCPRBCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRCPRBCollection.SetItem(Index: Integer;
  Value: TRCPRBCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRComlCollection }

function TRComlCollection.Add: TRComlCollectionItem;
begin
  Result := Self.New;
end;

function TRComlCollection.GetItem(Index: Integer): TRComlCollectionItem;
begin
  Result := TRComlCollectionItem(inherited Items[Index]);
end;

function TRComlCollection.New: TRComlCollectionItem;
begin
  Result := TRComlCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRComlCollection.SetItem(Index: Integer; Value: TRComlCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TinfoCRTomCollection }

function TinfoCRTomCollection.Add: TinfoCRTomCollectionItem;
begin
  Result := Self.New;
end;

function TinfoCRTomCollection.GetItem(
  Index: Integer): TinfoCRTomCollectionItem;
begin
  Result := TinfoCRTomCollectionItem(inherited Items[Index]);
end;

function TinfoCRTomCollection.New: TinfoCRTomCollectionItem;
begin
  Result := TinfoCRTomCollectionItem.Create;
  Self.Add(Result);
end;

procedure TinfoCRTomCollection.SetItem(Index: Integer;
  Value: TinfoCRTomCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TInfoTotalContrib }

constructor TInfoTotalContrib.Create;
begin
  FRTom      := TRTomCollection.Create;
  FRPrest    := TRPrestCollection.Create;
  FRRecRepAD := TRRecRepADCollection.Create;
  FRComl     := TRComlCollection.Create;
  FRCPRB     := TRCPRBCollection.Create;
end;

destructor TInfoTotalContrib.Destroy;
begin
  FRTom.Free;
  FRPrest.Free;
  FRRecRepAD.Free;
  FRComl.Free;
  FRCPRB.Free;

  inherited;
end;

procedure TInfoTotalContrib.SetRComl(const Value: TRComlCollection);
begin
  FRComl := Value;
end;

{ TEvtTotalContrib }

constructor TEvtTotalContrib.Create;
begin
  FIdeEvento        := TIdeEvento1.Create;
  FIdeContri        := TIdeContrib.Create;
  FIdeStatus        := TIdeStatus.Create;
  FInfoRecEv        := TInfoRecEv.Create;
  FInfoTotalContrib := TInfoTotalContrib.Create;
  FRetornoEventos   := TRetornoEventosCollection.Create;
end;

destructor TEvtTotalContrib.Destroy;
begin
  FIdeEvento.Free;
  FIdeContri.Free;
  FIdeStatus.Free;
  FInfoRecEv.Free;
  FInfoTotalContrib.Free;
  FRetornoEventos.Free;

  inherited;
end;

{ TRetConsulta }

constructor TRetConsulta.Create;
begin
  FLeitor := TLeitor.Create;
  FevtTotalContrib := TEvtTotalContrib.Create;
end;

destructor TRetConsulta.Destroy;
begin
  FLeitor.Free;
  FevtTotalContrib.Free;

  inherited;
end;

{ TRetornoEventosCollection }

function TRetornoEventosCollection.Add: TRetornoEventosCollectionItem;
begin
  Result := Self.New;
end;

function TRetornoEventosCollection.GetItem(Index: Integer): TRetornoEventosCollectionItem;
begin
  Result := TRetornoEventosCollectionItem(inherited Items[Index]);
end;

function TRetornoEventosCollection.New: TRetornoEventosCollectionItem;
begin
  Result := TRetornoEventosCollectionItem.Create;
  Self.Add(Result);
end;

procedure TRetornoEventosCollection.SetItem(Index: Integer; Value: TRetornoEventosCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetConsulta.LerXml: boolean;
var
  i, j: Integer;
  Ok: Boolean;
begin
  Result := True;
  try
    Leitor.Grupo := Leitor.Arquivo;

    FXML := Leitor.Arquivo;

    if (leitor.rExtrai(1, 'evtTotalContrib') <> '') then
    begin
      with evtTotalContrib do
      begin
        FId := Leitor.rAtributo('id=');

        if leitor.rExtrai(2, 'ideEvento') <> '' then
          IdeEvento.perApur := leitor.rCampo(tcStr, 'perApur');

        if leitor.rExtrai(2, 'ideContri') <> '' then
        begin
          IdeContri.TpInsc := StrToTpInscricao(Ok, leitor.rCampo(tcStr, 'tpInsc'));
          IdeContri.NrInsc := leitor.rCampo(tcStr, 'nrInsc');
        end;

        if leitor.rExtrai(2, 'ideRecRetorno') <> '' then
        begin
          if leitor.rExtrai(3, 'ideStatus') <> '' then
          begin
            IdeStatus.cdRetorno   := leitor.rCampo(tcStr, 'cdRetorno');
            IdeStatus.descRetorno := leitor.rCampo(tcStr, 'descRetorno');

            i := 0;
            while Leitor.rExtrai(4, 'regOcorrs', '', i + 1) <> '' do
            begin
              IdeStatus.regOcorrs.New;
              IdeStatus.regOcorrs.Items[i].tpOcorr        := leitor.rCampo(tcInt, 'tpOcorr');
              IdeStatus.regOcorrs.Items[i].localErroAviso := leitor.rCampo(tcStr, 'localErroAviso');
              IdeStatus.regOcorrs.Items[i].codResp        := leitor.rCampo(tcStr, 'codResp');
              IdeStatus.regOcorrs.Items[i].dscResp        := leitor.rCampo(tcStr, 'dscResp');

              inc(i);
            end;
          end;
        end;

        if leitor.rExtrai(2, 'infoRecEv') <> '' then
        begin
          infoRecEv.FnrProtEntr := leitor.rCampo(tcStr, 'nrProtEntr');
          infoRecEv.FdhProcess  := leitor.rCampo(tcDatHor, 'dhProcess');
          infoRecEv.FtpEv       := leitor.rCampo(tcStr, 'tpEv');
          infoRecEv.FidEv       := leitor.rCampo(tcStr, 'idEv');
          infoRecEv.Fhash       := leitor.rCampo(tcStr, 'hash');
        end;

        if leitor.rExtrai(2, 'infoTotalContrib') <> '' then
        begin
          with infoTotalContrib do
          begin
            FnrRecArqBase := leitor.rCampo(tcStr, 'nrRecArqBase');
            FindExistInfo := StrToindExistInfo(Ok, leitor.rCampo(tcStr, 'indExistInfo'));

            i := 0;
            while Leitor.rExtrai(3, 'RTom', '', i + 1) <> '' do
            begin
              RTom.New;

              RTom.Items[i].FcnpjPrestador     := leitor.rCampo(tcStr, 'cnpjPrestador');
              RTom.Items[i].FvlrTotalBaseRet   := leitor.rCampo(tcDe2, 'vlrTotalBaseRet');
              RTom.Items[i].FvlrTotalRetPrinc  := leitor.rCampo(tcDe2, 'vlrTotalRetPrinc');
              RTom.Items[i].FvlrTotalRetAdic   := leitor.rCampo(tcDe2, 'vlrTotalRetAdic');
              RTom.Items[i].FvlrTotalNRetPrinc := leitor.rCampo(tcDe2, 'vlrTotalNRetPrinc');
              RTom.Items[i].FvlrTotalNRetAdic  := leitor.rCampo(tcDe2, 'vlrTotalNRetAdic');

              // Vers�o 1.03.02
              j := 0;
              while Leitor.rExtrai(4, 'infoCRTom', '', j + 1) <> '' do
              begin
                RTom.Items[i].infoCRTom.New;

                RTom.Items[i].infoCRTom.Items[j].FCRTom        := leitor.rCampo(tcStr, 'CRTom');
                RTom.Items[i].infoCRTom.Items[j].FVlrCRTom     := leitor.rCampo(tcDe2, 'VlrCRTom');
                RTom.Items[i].infoCRTom.Items[j].FVlrCRTomSusp := leitor.rCampo(tcDe2, 'VlrCRTomSusp');

                inc(j);
              end;

              inc(i);
            end;

            i := 0;
            while Leitor.rExtrai(3, 'RPrest', '', i + 1) <> '' do
            begin
              RPrest.New;

              RPrest.Items[i].FtpInscTomador     := StrToTpInscricao(Ok, leitor.rCampo(tcStr, 'tpInscTomador'));
              RPrest.Items[i].FnrInscTomador     := leitor.rCampo(tcStr, 'nrInscTomador');
              RPrest.Items[i].FvlrTotalBaseRet   := leitor.rCampo(tcDe2, 'vlrTotalBaseRet');
              RPrest.Items[i].FvlrTotalRetPrinc  := leitor.rCampo(tcDe2, 'vlrTotalRetPrinc');
              RPrest.Items[i].FvlrTotalRetAdic   := leitor.rCampo(tcDe2, 'vlrTotalRetAdic');
              RPrest.Items[i].FvlrTotalNRetPrinc := leitor.rCampo(tcDe2, 'vlrTotalNRetPrinc');
              RPrest.Items[i].FvlrTotalNRetAdic  := leitor.rCampo(tcDe2, 'vlrTotalNRetAdic');

              inc(i);
            end;

            i := 0;
            while Leitor.rExtrai(3, 'RRecRepAD', '', i + 1) <> '' do
            begin
              RRecRepAD.New;

              RRecRepAD.Items[i].FcnpjAssocDesp := leitor.rCampo(tcStr, 'cnpjAssocDesp');
              RRecRepAD.Items[i].FvlrTotalRep   := leitor.rCampo(tcDe2, 'vlrTotalRep');
              RRecRepAD.Items[i].FvlrTotalRet   := leitor.rCampo(tcDe2, 'vlrTotalRet');
              RRecRepAD.Items[i].FvlrTotalNRet  := leitor.rCampo(tcDe2, 'vlrTotalNRet');

              // Vers�o 1.03.02
              RRecRepAD.Items[i].FCRRecRepAD        := leitor.rCampo(tcStr, 'CRRecRepAD');
              RRecRepAD.Items[i].FvlrCRRecRepAD     := leitor.rCampo(tcDe2, 'vlrCRRecRepAD');
              RRecRepAD.Items[i].FvlrCRRecRepADSusp := leitor.rCampo(tcDe2, 'vlrCRRecRepADSusp');

              inc(i);
            end;

            i := 0;
            while Leitor.rExtrai(3, 'RComl', '', i + 1) <> '' do
            begin
              RComl.New;
              RComl.Items[i].FvlrCPApur    := leitor.rCampo(tcDe2, 'vlrCPApur');
              RComl.Items[i].FvlrRatApur   := leitor.rCampo(tcDe2, 'vlrRatApur');
              RComl.Items[i].FvlrSenarApur := leitor.rCampo(tcDe2, 'vlrSenarApur');
              RComl.Items[i].FvlrCPSusp    := leitor.rCampo(tcDe2, 'vlrCPSusp');
              RComl.Items[i].FvlrRatSusp   := leitor.rCampo(tcDe2, 'vlrRatSusp');
              RComl.Items[i].FvlrSenarSusp := leitor.rCampo(tcDe2, 'vlrSenarSusp');

              // Vers�o 1.03.02
              RComl.Items[i].FCRComl        := leitor.rCampo(tcStr, 'CRComl');
              RComl.Items[i].FvlrCRComl     := leitor.rCampo(tcDe2, 'vlrCRComl');
              RComl.Items[i].FvlrCRComlSusp := leitor.rCampo(tcDe2, 'vlrCRComlSusp');

              inc(i);
            end;

            i := 0;
            while Leitor.rExtrai(3, 'RCPRB', '', i + 1) <> '' do
            begin
              RCPRB.New;

              RCPRB.Items[i].FcodRec         := leitor.rCampo(tcInt, 'codRec');
              RCPRB.Items[i].FvlrCPApurTotal := leitor.rCampo(tcDe2, 'vlrCPApurTotal');
              RCPRB.Items[i].FvlrCPRBSusp    := leitor.rCampo(tcDe2, 'vlrCPRBSusp');

              // Vers�o 1.03.02
              RCPRB.Items[i].FCRCPRB        := leitor.rCampo(tcStr, 'CRCPRB');
              RCPRB.Items[i].FvlrCRCPRB     := leitor.rCampo(tcDe2, 'vlrCRCPRB');
              RCPRB.Items[i].FvlrCRCPRBSusp := leitor.rCampo(tcDe2, 'vlrCRCPRBSusp');

              inc(i);
            end;
          end;
        end;
      end;
    end
    else
    if (leitor.rExtrai(1, 'Reinf') <> '') then
    begin
      with evtTotalContrib do
      begin
        if leitor.rExtrai(2, 'ideStatus') <> '' then
        begin
          IdeStatus.cdRetorno   := leitor.rCampo(tcStr, 'cdRetorno');
          IdeStatus.descRetorno := leitor.rCampo(tcStr, 'descRetorno');

          i := 0;
          while Leitor.rExtrai(3, 'regOcorrs', '', i + 1) <> '' do
          begin
            IdeStatus.regOcorrs.New;
            IdeStatus.regOcorrs.Items[i].tpOcorr        := leitor.rCampo(tcInt, 'tpOcorr');
            IdeStatus.regOcorrs.Items[i].localErroAviso := leitor.rCampo(tcStr, 'localErroAviso');
            IdeStatus.regOcorrs.Items[i].codResp        := leitor.rCampo(tcStr, 'codResp');
            IdeStatus.regOcorrs.Items[i].dscResp        := leitor.rCampo(tcStr, 'dscResp');

            inc(i);
          end;
        end;

        if leitor.rExtrai(2, 'retornoEventos') <> '' then
        begin
          i := 0;
          while Leitor.rExtrai(3, 'evento', '', i + 1) <> '' do
          begin
            with RetornoEventos.New do
            begin
              id                := Leitor.rAtributo('id=');
              iniValid          := leitor.rCampo(tcStr, 'iniValid');
              dtHoraRecebimento := leitor.rCampo(tcStr, 'dtHoraRecebimento');
              nrRecibo          := leitor.rCampo(tcStr, 'nrRecibo');
              situacaoEvento    := leitor.rCampo(tcStr, 'situacaoEvento');
              aplicacaoRecepcao := leitor.rCampo(tcStr, 'aplicacaoRecepcao');

              inc(i);
            end;
          end;
        end;
      end;
    end;
  except
    Result := False;
  end;
end;

function TRetConsulta.SalvarINI: boolean;
var
  AIni: TMemIniFile;
  sSecao: String;
  i, j: Integer;
begin
  Result := True;

  AIni := TMemIniFile.Create('');
  try
    with Self do
    begin
      with evtTotalContrib do
      begin
        sSecao := 'evtTotalContrib';
        AIni.WriteString(sSecao, 'Id', Id);

        sSecao := 'ideEvento';
        AIni.WriteString(sSecao, 'perApur', IdeEvento.perApur);

        sSecao := 'ideContri';
        AIni.WriteString(sSecao, 'tpInsc', TpInscricaoToStr(IdeContri.TpInsc));
        AIni.WriteString(sSecao, 'nrInsc', IdeContri.nrInsc);

        sSecao := 'ideStatus';
        AIni.WriteString(sSecao, 'cdRetorno', ideStatus.cdRetorno);
        AIni.WriteString(sSecao, 'descRetorno', ideStatus.descRetorno);

        for i := 0 to ideStatus.regOcorrs.Count -1 do
        begin
          sSecao := 'regOcorrs' + IntToStrZero(I, 3);

          AIni.WriteInteger(sSecao, 'tpOcorr',       ideStatus.regOcorrs.Items[i].tpOcorr);
          AIni.WriteString(sSecao, 'localErroAviso', ideStatus.regOcorrs.Items[i].localErroAviso);
          AIni.WriteString(sSecao, 'codResp',        ideStatus.regOcorrs.Items[i].codResp);
          AIni.WriteString(sSecao, 'dscResp',        ideStatus.regOcorrs.Items[i].dscResp);
        end;

        sSecao := 'infoRecEv';
        AIni.WriteString(sSecao, 'nrProtEntr', infoRecEv.nrProtEntr);
        AIni.WriteString(sSecao, 'dhProcess',  DateToStr(infoRecEv.dhProcess));
        AIni.WriteString(sSecao, 'tpEv',       infoRecEv.tpEv);
        AIni.WriteString(sSecao, 'idEv',       infoRecEv.idEv);
        AIni.WriteString(sSecao, 'hash',       infoRecEv.hash);

        sSecao := 'infoTotalContrib';
        AIni.WriteString(sSecao, 'nrRecArqBase', infoTotalContrib.nrRecArqBase);
        AIni.WriteString(sSecao, 'indExistInfo', indExistInfoToStr(infoTotalContrib.indExistInfo));

        with infoTotalContrib do
        begin
          for i := 0 to RTom.Count -1 do
          begin
            sSecao := 'RTom' + IntToStrZero(I, 3);

            AIni.WriteString(sSecao, 'cnpjPrestador',    RTom.Items[i].cnpjPrestador);
            AIni.WriteFloat(sSecao, 'vlrTotalBaseRet',   RTom.Items[i].vlrTotalBaseRet);
            AIni.WriteFloat(sSecao, 'vlrTotalRetPrinc',  RTom.Items[i].vlrTotalRetPrinc);
            AIni.WriteFloat(sSecao, 'vlrTotalRetAdic',   RTom.Items[i].vlrTotalRetAdic);
            AIni.WriteFloat(sSecao, 'vlrTotalNRetPrinc', RTom.Items[i].vlrTotalNRetPrinc);
            AIni.WriteFloat(sSecao, 'vlrTotalNRetAdic',  RTom.Items[i].vlrTotalNRetAdic);

            // Vers�o 1.03.02
            for j := 0 to RTom.Items[i].infoCRTom.Count -1 do
            begin
              sSecao := 'infoCRTom' + IntToStrZero(I, 3) + IntToStrZero(J, 1);

              AIni.WriteString(sSecao, 'CRTom',    RTom.Items[i].infoCRTom.Items[J].CRTom);
              AIni.WriteFloat(sSecao, 'VlrCRTom',   RTom.Items[i].infoCRTom.Items[J].VlrCRTom);
              AIni.WriteFloat(sSecao, 'VlrCRTomSusp',  RTom.Items[i].infoCRTom.Items[J].VlrCRTomSusp);
            end;
          end;

          for i := 0 to RPrest.Count -1 do
          begin
            sSecao := 'RPrest' + IntToStrZero(I, 3);

            AIni.WriteString(sSecao, 'tpInscTomador',    TpInscricaoToStr(RPrest.Items[i].tpInscTomador));
            AIni.WriteString(sSecao, 'nrInscTomador',    RPrest.Items[i].nrInscTomador);
            AIni.WriteFloat(sSecao, 'vlrTotalBaseRet',   RPrest.Items[i].vlrTotalBaseRet);
            AIni.WriteFloat(sSecao, 'vlrTotalRetPrinc',  RPrest.Items[i].vlrTotalRetPrinc);
            AIni.WriteFloat(sSecao, 'vlrTotalRetAdic',   RPrest.Items[i].vlrTotalRetAdic);
            AIni.WriteFloat(sSecao, 'vlrTotalNRetPrinc', RPrest.Items[i].vlrTotalNRetPrinc);
            AIni.WriteFloat(sSecao, 'vlrTotalNRetAdic',  RPrest.Items[i].vlrTotalNRetAdic);
          end;

          for i := 0 to RRecRepAD.Count -1 do
          begin
            sSecao := 'RRecRepAD' + IntToStrZero(I, 3);

            AIni.WriteString(sSecao, 'cnpjAssocDesp', RRecRepAD.Items[i].cnpjAssocDesp);
            AIni.WriteFloat(sSecao, 'vlrTotalRep',    RRecRepAD.Items[i].vlrTotalRep);
            AIni.WriteFloat(sSecao, 'vlrTotalRet',    RRecRepAD.Items[i].vlrTotalRet);
            AIni.WriteFloat(sSecao, 'vlrTotalNRet',   RRecRepAD.Items[i].vlrTotalNRet);
          end;

          for i := 0 to RComl.Count -1 do
          begin
            sSecao := 'RComl' + IntToStrZero(I, 1);

            AIni.WriteFloat(sSecao, 'vlrCPApur',    RComl.Items[i].vlrCPApur);
            AIni.WriteFloat(sSecao, 'vlrRatApur',   RComl.Items[i].vlrRatApur);
            AIni.WriteFloat(sSecao, 'vlrSenarApur', RComl.Items[i].vlrSenarApur);
            AIni.WriteFloat(sSecao, 'vlrCPSusp',    RComl.Items[i].vlrCPSusp);
            AIni.WriteFloat(sSecao, 'vlrRatSusp',   RComl.Items[i].vlrRatSusp);
            AIni.WriteFloat(sSecao, 'vlrSenarSusp', RComl.Items[i].vlrSenarSusp);

            // Vers�o 1.03.02
            AIni.WriteString(sSecao, 'CRComl',       RComl.Items[i].CRComl);
            AIni.WriteFloat(sSecao, 'vlrCRComl',     RComl.Items[i].vlrCRComl);
            AIni.WriteFloat(sSecao, 'vlrCRComlSusp', RComl.Items[i].vlrCRComlSusp);
          end;

          for i := 0 to RCPRB.Count -1 do
          begin
            sSecao := 'RCPRB' + IntToStrZero(I, 1);

            AIni.WriteInteger(sSecao, 'codRec',       RCPRB.Items[i].codRec);
            AIni.WriteFloat(sSecao, 'vlrCPApurTotal', RCPRB.Items[i].vlrCPApurTotal);
            AIni.WriteFloat(sSecao, 'vlrCPRBSusp',    RCPRB.Items[i].vlrCPRBSusp);

            // Vers�o 1.03.02
            AIni.WriteString(sSecao, 'CRCPRB',       RCPRB.Items[i].CRCPRB);
            AIni.WriteFloat(sSecao, 'vlrCRCPRB',     RCPRB.Items[i].vlrCRCPRB);
            AIni.WriteFloat(sSecao, 'vlrCRCPRBSusp', RCPRB.Items[i].vlrCRCPRBSusp);
          end;
        end;
      end;
    end;
  finally
    AIni.Free;
  end;
end;

end.
