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
|* 01/03/2016: Guilherme Costa
|*  - Altera��es para valida��o com o XSD
******************************************************************************}
{$I ACBr.inc}

unit pcesS2220;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador, ACBrUtil,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2220Collection = class;
  TS2220CollectionItem = class;
  TevtMonit = class;
  TAso = class;
  TExameColecaoItem = class;
  TExameColecao = class;
  TRespMonit = class;
  TMedico = class;
  TCrm = class;
  TIdeServSaude = class;
  
  TS2220Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2220CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2220CollectionItem);
  public
    function Add: TS2220CollectionItem;
    property Items[Index: Integer]: TS2220CollectionItem read GetItem write SetItem; default;
  end;

  TS2220CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FevtMonit: TevtMonit;

    procedure setevtMonit(const Value: TevtMonit);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property evtMonit: TevtMonit read FevtMonit write setevtMonit;
  end;

  TevtMonit = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo: TIdeVinculo;
    FAso: TAso;
    FACBreSocial: TObject;

    procedure GerarExame;
    procedure GerarMedico;
    procedure GerarCRM;
    procedure GerarAso;
    procedure GerarIdeServSaude;
    procedure GerarRespMonit(pRespMonit: TRespMonit);
  public
    constructor Create(AACBreSocial: TObject); overload;
    destructor Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;
    property Aso: TAso read FAso write FAso;
  end;

  TAso = class(TPersistent)
  private
    FDtAso: TDateTime;
    FtpAso: tpTpAso;
    FResAso: tpResAso;
    FExame: TExameColecao;
    FIdeServSaude: TIdeServSaude;
  public
    constructor create;
    destructor destroy; override;

    property DtAso: TDateTime read FDtAso write FDtAso;
    property tpAso: tpTpAso read FtpAso write FtpAso;
    property ResAso: tpResAso read FResAso write FResAso;
    property Exame: TExameColecao read FExame write FExame;
    property IdeServSaude: TIdeServSaude read FIdeServSaude write FIdeServSaude;
  end;

  TExameColecaoItem = class(TCollectionItem)
  private
    FDtExm: TDateTime;
    FProcRealizado: integer;
    FObsProc: string;
    FInterprExm: tpInterprExm;
    FOrdExame: tpOrdExame;
    FDtIniMonit: TDateTime;
    FDtFimMonit: TDateTime;
    FIndResult: tpIndResult;
    FRespMonit: TRespMonit;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property DtExm: TDateTime read FDtExm write FDtExm;
    property ProcRealizado: integer read FProcRealizado write FProcRealizado;
    property obsProc: string read FObsProc write FObsProc;
    property interprExm: tpInterprExm read FInterprExm write FInterprExm;
    property ordExame: tpOrdExame read FOrdExame write FOrdExame;
    property dtIniMonit: TDateTime read FDtIniMonit write FDtIniMonit;
    property dtFimMonit: TDateTime read FDtFimMonit write FDtFimMonit;
    property indResult: tpIndResult read FIndResult write FIndResult;
    property respMonit: TRespMonit read FRespMonit write FRespMonit;
  end;

  TExameColecao = class(TCollection)
  private
    function GetItem(Index: Integer): TExameColecaoItem;
    procedure SetItem(Index: Integer; const Value: TExameColecaoItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TExameColecaoItem;
    property Items[Index: Integer]: TExameColecaoItem read GetItem write SetItem;
  end;

  TRespMonit = class
  private
    FNisResp: string;
    FNrConsClasse: string;
    FUfConsClasse: tpuf;
  public
    property NisResp: string read FNisResp write FNisResp;
    property NrConsClasse: string read FNrConsClasse write FNrConsClasse;
    property UfConsClasse: tpuf read FUfConsClasse write FUfConsClasse;
  end;

  TIdeServSaude = class
  private
    FCodCNES: string;
    FFrmCtt: string;
    FEmail: string;
    FMedico: TMedico;
  public
    constructor create;
    destructor destroy; override;
  published
    property CodCNES: string read FCodCNES write FCodCNES;
    property FrmCtt: string read FFrmCtt write FFrmCtt;
    property Email: string read FEmail write FEmail;
    property Medico: TMedico read FMedico write FMedico;
  end;

  TCrm = class
  private
    FNrCRM: string;
    FUfCRM: tpuf;
  published
    property NrCRM: string read FNrCRM write FNrCRM;
    property UfCRM: tpuf read FUfCRM write FUfCRM;
  end;

  TMedico = class
  private
    FNmMed: string;
    FCRM: TCRM;
  public
    constructor create;
    destructor destroy; override;
  public
    property NmMed: string read FNmMed write FNmMed;
    property CRM: TCRM read FCRM write FCRM;
  end;

implementation

uses
  IniFiles,
  ACBreSocial;

{ TS2220Collection }

function TS2220Collection.Add: TS2220CollectionItem;
begin
  Result := TS2220CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2220Collection.GetItem(Index: Integer): TS2220CollectionItem;
begin
  Result := TS2220CollectionItem(inherited GetItem(Index));
end;

procedure TS2220Collection.SetItem(Index: Integer;
  Value: TS2220CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2220CollectionItem }

constructor TS2220CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2220;
  FevtMonit     := TevtMonit.Create(AOwner);
end;

destructor TS2220CollectionItem.Destroy;
begin
  FevtMonit.Free;

  inherited;
end;

procedure TS2220CollectionItem.setevtMonit(const Value: TevtMonit);
begin
  FevtMonit.Assign(Value);
end;

{ TAso }

constructor TAso.create;
begin
  inherited;

  FExame := TExameColecao.Create(self);
  FIdeServSaude := TIdeServSaude.create;
end;

destructor TAso.destroy;
begin
  FExame.Free;
  FIdeServSaude.Free;

  inherited;
end;

{ TExameColecao }

function TExameColecao.Add: TExameColecaoItem;
begin
  Result := TExameColecaoItem(inherited Add);
  Result.Create;
end;

constructor TExameColecao.Create(AOwner: TPersistent);
begin
  inherited Create(TExameColecaoItem);
end;

function TExameColecao.GetItem(Index: Integer): TExameColecaoItem;
begin
  Result := TExameColecaoItem(inherited GetItem(Index));
end;

procedure TExameColecao.SetItem(Index: Integer;
  const Value: TExameColecaoItem);
begin
  inherited SetItem(Index, Value);
end;

{ TExameColecaoItem }

constructor TExameColecaoItem.Create;
begin
  FRespMonit := TRespMonit.Create;
end;

destructor TExameColecaoItem.Destroy;
begin
  FRespMonit.Free;

  inherited;
end;

{ TMedico }

constructor TMedico.create;
begin
  FCRM := TCRM.Create;
end;

destructor TMedico.destroy;
begin
  FCRM.Free;

  inherited;
end;

{ TIdeServSaude }

constructor TIdeServSaude.create;
begin
  FMedico := TMedico.create;
end;

destructor TIdeServSaude.destroy;
begin
  FMedico.Free;

  inherited;
end;

{ TevtMonit }

constructor TevtMonit.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo := TIdeVinculo.Create;
  FAso := TAso.Create;
end;

destructor TevtMonit.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeVinculo.Free;
  FAso.Free;

  inherited;
end;

procedure TevtMonit.GerarAso;
begin
  Gerador.wGrupo('aso');

  Gerador.wCampo(tcDat, '', 'dtAso',  10, 10, 1, self.Aso.DtAso);
  Gerador.wCampo(tcStr, '', 'tpAso',   1,  1, 1, eSTpAsoToStr(self.Aso.tpAso));
  Gerador.wCampo(tcStr, '', 'resAso',  1,  1, 1, eSResAsoToStr(self.Aso.ResAso));

  GerarExame;
  GerarIdeServSaude;

  Gerador.wGrupo('/aso');
end;

procedure TevtMonit.GerarCRM;
begin
  Gerador.wGrupo('crm');

  Gerador.wCampo(tcStr, '', 'nrCRM', 1, 8, 1, self.Aso.IdeServSaude.Medico.CRM.NrCRM);
  Gerador.wCampo(tcStr, '', 'ufCRM', 2, 2, 1, eSufToStr(self.Aso.IdeServSaude.Medico.CRM.UfCRM));

  Gerador.wGrupo('/crm');
end;

procedure TevtMonit.GerarExame;
var
  i: integer;
begin
  for i:= 0 to self.Aso.Exame.Count-1 do
  begin
    Gerador.wGrupo('exame');

    Gerador.wCampo(tcDat, '', 'dtExm',         10,  10, 1, self.Aso.Exame.Items[i].dtExm);
    Gerador.wCampo(tcStr, '', 'procRealizado',  1,   8, 0, self.Aso.Exame.Items[i].procRealizado);
    Gerador.wCampo(tcStr, '', 'obsProc',        1, 200, 0, self.Aso.Exame.Items[i].obsProc);
    Gerador.wCampo(tcInt, '', 'interprExm',     1,   1, 1, eSInterprExmToStr(self.Aso.Exame.Items[i].interprExm));
    Gerador.wCampo(tcInt, '', 'ordExame',       1,   1, 1, eSOrdExameToStr(self.Aso.Exame.Items[i].ordExame));
    Gerador.wCampo(tcDat, '', 'dtIniMonit',    10,  10, 1, self.Aso.Exame.Items[i].dtIniMonit);
    Gerador.wCampo(tcDat, '', 'dtFimMonit',    10,  10, 0, self.Aso.Exame.Items[i].dtFimMonit);
    Gerador.wCampo(tcInt, '', 'indResult',      1,   1, 0, eSIndResultToStr(self.Aso.Exame.Items[i].indResult));

    GerarRespMonit(self.Aso.Exame.Items[i].respMonit);

    Gerador.wGrupo('/exame');
  end;

  if self.Aso.Exame.Count > 99 then
    Gerador.wAlerta('', 'exame', 'Lista de Exames', ERR_MSG_MAIOR_MAXIMO + '99');
end;

procedure TevtMonit.GerarIdeServSaude;
begin
  Gerador.wGrupo('ideServSaude');

  Gerador.wCampo(tcStr, '', 'codCNES', 1,   7, 0, self.Aso.IdeServSaude.CodCNES);
  Gerador.wCampo(tcStr, '', 'frmCtt',  1, 100, 1, self.Aso.IdeServSaude.FrmCtt);
  Gerador.wCampo(tcStr, '', 'email',   1,  60, 0, self.Aso.IdeServSaude.Email);

  GerarMedico;

  Gerador.wGrupo('/ideServSaude');
end;

procedure TevtMonit.GerarMedico;
begin
  Gerador.wGrupo('medico');

  Gerador.wCampo(tcStr, '', 'nmMed', 1, 70, 1, self.Aso.IdeServSaude.Medico.NmMed);

  GerarCRM;

  Gerador.wGrupo('/medico');
end;

procedure TevtMonit.GerarRespMonit(pRespMonit: TRespMonit);
begin
  Gerador.wGrupo('respMonit');

  Gerador.wCampo(tcStr, '', 'nisResp',      1, 11, 1, pRespMonit.nisResp);
  Gerador.wCampo(tcStr, '', 'nrConsClasse', 1,  8, 1, pRespMonit.NrConsClasse);

  if (eSufToStr(pRespMonit.UfConsClasse) <> '') then
    Gerador.wCampo(tcStr, '', 'ufConsClasse', 2, 2, 0, eSufToStr(pRespMonit.UfConsClasse));

  Gerador.wGrupo('/respMonit');
end;

function TevtMonit.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtMonit');
    Gerador.wGrupo('evtMonit Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeVinculo(self.IdeVinculo);
    GerarAso;

    Gerador.wGrupo('/evtMonit');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtMonit');

    Validar(schevtMonit);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TevtMonit.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I: Integer;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      sSecao := 'evtMonit';
      Id         := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial := INIRec.ReadInteger(sSecao, 'Sequencial', 0);

      sSecao := 'ideEvento';
      ideEvento.indRetif    := eSStrToIndRetificacao(Ok, INIRec.ReadString(sSecao, 'indRetif', '1'));
      ideEvento.NrRecibo    := INIRec.ReadString(sSecao, 'nrRecibo', EmptyStr);
      ideEvento.TpAmb       := eSStrTotpAmb(Ok, INIRec.ReadString(sSecao, 'tpAmb', '1'));
      ideEvento.ProcEmi     := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc     := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideVinculo';
      ideVinculo.CpfTrab   := INIRec.ReadString(sSecao, 'cpfTrab', EmptyStr);
      ideVinculo.NisTrab   := INIRec.ReadString(sSecao, 'nisTrab', EmptyStr);
      ideVinculo.Matricula := INIRec.ReadString(sSecao, 'matricula', EmptyStr);

      sSecao := 'aso';
      aso.DtAso  := StringToDateTime(INIRec.ReadString(sSecao, 'dtAso', '0'));
      aso.tpAso  := eSStrToTpAso(Ok, INIRec.ReadString(sSecao, 'tpAso', '0'));
      aso.ResAso := eSStrToResAso(Ok, INIRec.ReadString(sSecao, 'resAso', '1'));

      I := 1;
      while true do
      begin
        // de 01 at� 99
        sSecao := 'exame' + IntToStrZero(I, 2);
        sFim   := INIRec.ReadString(sSecao, 'dtExm', 'FIM');

        if (sFim = 'FIM') or (Length(sFim) <= 0) then
          break;

        with aso.exame.Add do
        begin
          dtExm         := StringToDateTime(sFim);
          ProcRealizado := INIRec.ReadInteger(sSecao, 'procRealizado', 0);
          obsProc       := INIRec.ReadString(sSecao, 'obsProc', EmptyStr);
          interprExm    := eSStrToInterprExm(Ok, INIRec.ReadString(sSecao, 'interprExm', '1'));
          ordExame      := eSStrToOrdExame(Ok, INIRec.ReadString(sSecao, 'ordExame', '1'));
          dtIniMonit    := StringToDateTime(INIRec.ReadString(sSecao, 'dtIniMonit', '0'));
          dtFimMonit    := StringToDateTime(INIRec.ReadString(sSecao, 'dtFimMonit', '0'));
          indResult     := eSStrToIndResult(Ok, INIRec.ReadString(sSecao, 'indResult', '1'));

          sSecao := 'respMonit' + IntToStrZero(I, 2);
          respMonit.NisResp      := INIRec.ReadString(sSecao, 'nisResp', EmptyStr);
          respMonit.NrConsClasse := INIRec.ReadString(sSecao, 'nrConsClasse', EmptyStr);
          respMonit.UfConsClasse := eSStrTouf(Ok, INIRec.ReadString(sSecao, 'ufConsClasse', 'SP'));
        end;

        Inc(I);
      end;

      sSecao := 'ideServSaude';
      Aso.ideServSaude.CodCNES := INIRec.ReadString(sSecao, 'codCNES', EmptyStr);
      Aso.ideServSaude.FrmCtt  := INIRec.ReadString(sSecao, 'frmCtt', EmptyStr);
      Aso.ideServSaude.Email   := INIRec.ReadString(sSecao, 'email', EmptyStr);

      sSecao := 'medico';
      Aso.ideServSaude.medico.NmMed     := INIRec.ReadString(sSecao, 'nmMed', EmptyStr);
      Aso.ideServSaude.medico.CRM.NrCRM := INIRec.ReadString(sSecao, 'nrCRM', EmptyStr);
      Aso.ideServSaude.medico.CRM.UfCRM := eSStrTouf(Ok, INIRec.ReadString(sSecao, 'ufCRM', 'SP'));
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

end.

