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

{$I ACBr.inc}

unit pcesS5003;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnLeitor, ACBrUtil,
  pcesCommon, pcesConversaoeSocial;

type
  TS5003 = class;
  TEvtBasesFGTS = class;

  TS5003 = class(TInterfacedObject, IEventoeSocial)
  private
    FTipoEvento: TTipoEvento;
    FEvtBasesFGTS: TEvtBasesFGTS;

    function GetXml : string;
    procedure SetXml(const Value: string);
    function GetTipoEvento : TTipoEvento;
    procedure SetEvtBasesFGTS(const Value: TEvtBasesFGTS);

  public
    constructor Create;
    destructor Destroy; override;

    function GetEvento : TObject;

  published
    property Xml: String read GetXml write SetXml;
    property TipoEvento: TTipoEvento read GetTipoEvento;
    property EvtBasesFGTS: TEvtBasesFGTS read FEvtBasesFGTS write setEvtBasesFGTS;

  end;

  TEvtBasesFGTS = class(TPersistent)
  private
    FLeitor: TLeitor;
    FId: String;
    FXML: String;

    FIdeEvento: TIdeEvento5;
    FIdeEmpregador: TIdeEmpregador;
    FIdeTrabalhador: TIdeTrabalhador3;

  public
    constructor Create;
    destructor  Destroy; override;

    function LerXML: boolean;
    function SalvarINI: boolean;

    property IdeEvento: TIdeEvento5 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeTrabalhador: TIdeTrabalhador3 read FIdeTrabalhador write FIdeTrabalhador;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Id: String      read FId;
    property XML: String     read FXML;
  end;

implementation

uses
  IniFiles;

{ TS5003 }

constructor TS5003.Create;
begin
  FTipoEvento := teS5003;
  FEvtBasesFGTS := TEvtBasesFGTS.Create;
end;

destructor TS5003.Destroy;
begin
  FEvtBasesFGTS.Free;

  inherited;
end;

function TS5003.GetEvento : TObject;
begin
  Result := self;
end;

function TS5003.GetXml : string;
begin
  Result := FEvtBasesFGTS.XML;
end;

procedure TS5003.SetXml(const Value: string);
begin
  if Value = FEvtBasesFGTS.XML then Exit;

  FEvtBasesFGTS.FXML := Value;
  FEvtBasesFGTS.Leitor.Arquivo := Value;
  FEvtBasesFGTS.LerXML;

end;

function TS5003.GetTipoEvento : TTipoEvento;
begin
  Result := FTipoEvento;
end;

procedure TS5003.SetEvtBasesFGTS(const Value: TEvtBasesFGTS);
begin
  FEvtBasesFGTS.Assign(Value);
end;

{ TEvtBasesFGTS }

constructor TEvtBasesFGTS.Create();
begin
  FLeitor := TLeitor.Create;

  FIdeEvento := TIdeEvento5.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeTrabalhador := TIdeTrabalhador3.Create;
end;

destructor TEvtBasesFGTS.Destroy;
begin
  FLeitor.Free;

  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeTrabalhador.Free;

  inherited;
end;

function TEvtBasesFGTS.LerXML: boolean;
var
  ok: Boolean;
  i, j, k: Integer;
begin
  Result := False;
  try
    FXML := Leitor.Arquivo;

    (* IMPLEMENTAR A LEITURA DO 5003 *)

  except
    Result := False;
  end;
end;

function TEvtBasesFGTS.SalvarINI: boolean;
var
  AIni: TMemIniFile;
  sSecao: String;
  i, j, k: Integer;
begin
  Result := False;

  AIni := TMemIniFile.Create('');
  try
    Result := True;

    with Self do
    begin



    end;
  finally
    AIni.Free;
  end;
end;

end.
