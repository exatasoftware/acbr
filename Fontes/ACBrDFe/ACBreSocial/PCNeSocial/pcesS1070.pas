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
|* 01/03/2015: Guilherme Costa
|*  - Ao gerar o per�odo a tag deve se chamar "novaValidade"
******************************************************************************}
{$I ACBr.inc}

unit pcesS1070;

interface

uses
  SysUtils, Classes, ACBrUtil,
  pcnConversao, pcnGerador,
  pcesCommon, pcesConversaoeSocial, pcesGerador;


type
  TS1070Collection = class;
  TS1070CollectionItem = class;
  TEvtTabProcesso = class;
  TDadosProcJud = class;
  TDadosProc = class;
  TInfoProcesso = class;
  TIdeProcesso = class;


  TS1070Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS1070CollectionItem;
    procedure SetItem(Index: Integer; Value: TS1070CollectionItem);
  public
    function Add: TS1070CollectionItem;
    property Items[Index: Integer]: TS1070CollectionItem read GetItem write SetItem; default;
  end;

  TS1070CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtTabProcesso: TEvtTabProcesso;
    procedure setEvtTabProcesso(const Value: TEvtTabProcesso);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor  Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtTabProcesso: TEvtTabProcesso read FEvtTabProcesso write setEvtTabProcesso;
  end;

  TIdeProcesso = class(TPersistent)
  private
    FTpProc : tpTpProc;
    FNrProc : string;
    FIniValid: string;
    FFimValid: string;
  published
    property tpProc :tpTpProc read FTpProc write FTpProc;
    property nrProc :string read FNrProc write FNrProc;
    property iniValid: string read FIniValid write FIniValid;
    property fimValid: string read FFimValid write FFimValid;
  end;

  TEvtTabProcesso = class(TESocialEvento)
  private
    FModoLancamento: TModoLancamento;
    fIdeEvento: TIdeEvento;
    fIdeEmpregador: TIdeEmpregador;
    fInfoProcesso: TInfoProcesso;
    FACBreSocial: TObject;

    {Geradores espec�ficos da classe}
    procedure GerarIdeProcesso;
    procedure GerarDadosProcJud;
    procedure GerarDadosProc;
    procedure GerarDadosInfoSusp;
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property ModoLancamento: TModoLancamento read FModoLancamento write FModoLancamento;
    property IdeEvento: TIdeEvento read fIdeEvento write fIdeEvento;
    property IdeEmpregador: TIdeEmpregador read fIdeEmpregador write fIdeEmpregador;
    property InfoProcesso: TInfoProcesso read fInfoProcesso write fInfoProcesso;
  end;

  TInfoSuspCollectionItem = class(TCollectionItem)
  private
    FCodSusp: String;
    FIndSusp: tpIndSusp;
    FDTDecisao: TDateTime;
    FIndDeposito: tpSimNao;
  public
    constructor create; reintroduce;

    property codSusp: String read FCodSusp write FCodSusp;
    property indSusp: tpIndSusp read FIndSusp write FIndSusp;
    property dtDecisao: TDateTime read FDTDecisao write FDTDecisao;
    property indDeposito: tpSimNao read FIndDeposito write FIndDeposito;
  end;

  TInfoSuspCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoSuspCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoSuspCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TInfoSuspCollectionItem;
    property Items[Index: Integer]: TInfoSuspCollectionItem read GetItem write SetItem; default;
  end;

  TDadosProcJud = class(TPersistent)
  private
    FUfVara: string;
    FCodMunic: integer;
    FIdVara: string;
  public
    property UfVara: string read FUfVara write FUfVara;
    property codMunic: integer read FCodMunic write FCodMunic;
    property idVara: string read FIdVara write FIdVara;
  end;

  TDadosProc = class(TPersistent)
  private
    FIndAutoria: tpindAutoria;
    FIndMatProc: tpIndMatProc;
    Fobservacao: String;
    FDadosProcJud : TDadosProcJud;
    FInfoSusp: TInfoSuspCollection;

    function getDadosProcJud: TDadosProcJud;
    function getInfoSusp(): TInfoSuspCollection;
  public
    constructor create;
    destructor Destroy; override;

    function dadosProcJudInst(): Boolean;
    function infoSuspInst(): Boolean;

    property indAutoria: tpindAutoria read FIndAutoria write FIndAutoria;
    property indMatProc: tpIndMatProc read FIndMatProc write FIndMatProc;
    property observacao: String read Fobservacao write Fobservacao;

    property DadosProcJud: TDadosProcJud read getDadosProcJud write FDadosProcJud;
    property infoSusp: TInfoSuspCollection read getInfoSusp write FInfoSusp;
  end;

  TInfoProcesso = class
  private
    FIdeProcesso: TIdeProcesso;
    FDadosProc: TDadosProc;
    FNovaValidade: TIdePeriodo;

    function getDadosProc(): TDadosProc;
    function getNovaValidade(): TIdePeriodo;
  public
    constructor create;
    destructor Destroy; override;

    function dadosProcsInst(): Boolean;
    function novaValidadeInst(): Boolean;

    property ideProcesso: TIdeProcesso read FIdeProcesso write FIdeProcesso;
    property dadosProc: TDadosProc read getDadosProc write FDadosProc;
    property novaValidade: TIdePeriodo read getNovaValidade write FNovaValidade;
  end;

implementation

uses
  IniFiles,
  ACBreSocial;

{ TS1070Collection }

function TS1070Collection.Add: TS1070CollectionItem;
begin
  Result := TS1070CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS1070Collection.GetItem(Index: Integer): TS1070CollectionItem;
begin
  Result := TS1070CollectionItem(inherited GetItem(Index));
end;

procedure TS1070Collection.SetItem(Index: Integer;
  Value: TS1070CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS1070CollectionItem }

constructor TS1070CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS1070;
  FEvtTabProcesso := TEvtTabProcesso.Create(AOwner);
end;

destructor TS1070CollectionItem.Destroy;
begin
  FEvtTabProcesso.Free;
  inherited;
end;

procedure TS1070CollectionItem.setEvtTabProcesso(
  const Value: TEvtTabProcesso);
begin
  FEvtTabProcesso.Assign(Value);
end;

{ TInfoSuspCollection }

function TInfoSuspCollection.Add: TInfoSuspCollectionItem;
begin
  Result := TInfoSuspCollectionItem(inherited Add());
  Result.Create;
end;

constructor TInfoSuspCollection.create(AOwner: TPersistent);
begin
  inherited create(TInfoSuspCollectionItem);
end;

function TInfoSuspCollection.GetItem(
  Index: Integer): TInfoSuspCollectionItem;
begin
  Result := TInfoSuspCollectionItem(Inherited GetItem(Index));
end;

procedure TInfoSuspCollection.SetItem(Index: Integer;
  Value: TInfoSuspCollectionItem);
begin
  Inherited SetItem(Index, Value);
end;

{ TInfoSuspCollectionItem }

constructor TInfoSuspCollectionItem.create;
begin

end;

{ TDadosProc }

constructor TDadosProc.create;
begin
  fDadosProcJud := nil;
  FInfoSusp := nil;
end;

function TDadosProc.dadosProcJudInst: Boolean;
begin
  Result := Assigned(fDadosProcJud);
end;

destructor TDadosProc.destroy;
begin
  FreeAndNil(fDadosProcJud);
  FreeAndNil(FInfoSusp);
  inherited;
end;

function TDadosProc.getDadosProcJud: TDadosProcJud;
begin
  if Not(Assigned(fDadosProcJud)) then
    fDadosProcJud := TDadosProcJud.Create;
  Result := fDadosProcJud;
end;

function TDadosProc.getInfoSusp: TInfoSuspCollection;
begin
  if Not(Assigned(FInfoSusp)) then
    FInfoSusp := TInfoSuspCollection.Create(FInfoSusp);
  Result := FInfoSusp;
end;

function TDadosProc.infoSuspInst: Boolean;
begin
  Result := Assigned(FInfoSusp);
end;

{ TInfoProcesso }

constructor TInfoProcesso.create;
begin
  FIdeProcesso := TIdeProcesso.Create;
  FDadosProc := nil;
  FNovaValidade := nil;
end;

function TInfoProcesso.dadosProcsInst: Boolean;
begin
  Result := Assigned(FDadosProc);
end;

destructor TInfoProcesso.destroy;
begin
  FIdeProcesso.Free;
  FreeAndNil(FDadosProc);
  FreeAndNil(FNovaValidade);
  inherited;
end;

function TInfoProcesso.getDadosProc: TdadosProc;
begin
  if Not(Assigned(FDadosProc)) then
    FdadosProc := TDadosProc.create;
  Result := FDadosProc;
end;

function TInfoProcesso.getNovaValidade: TIdePeriodo;
begin
  if Not(Assigned(FNovaValidade)) then
    FNovaValidade := TIdePeriodo.Create;
  Result := FNovaValidade;
end;

function TInfoProcesso.novaValidadeInst: Boolean;
begin
  Result := Assigned(FNovaValidade);
end;

{ TEvtTabProcesso }

constructor TEvtTabProcesso.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  fIdeEvento := TIdeEvento.Create;
  fIdeEmpregador := TIdeEmpregador.Create;
  fInfoProcesso := TInfoProcesso.Create;
end;

destructor TEvtTabProcesso.Destroy;
begin
  fIdeEvento.Free;
  fIdeEmpregador.Free;
  fInfoProcesso.Free;
  inherited;
end;

procedure TEvtTabProcesso.GerarDadosInfoSusp;
var
  i: Integer;
begin
  if InfoProcesso.dadosProc.infoSuspInst() then
  begin
    for i := 0 to InfoProcesso.dadosProc.infoSusp.Count - 1 do
    begin
      Gerador.wGrupo('infoSusp');

      Gerador.wCampo(tcStr, '', 'codSusp',      1, 14, 1, InfoProcesso.dadosProc.infoSusp.GetItem(i).codSusp);
      Gerador.wCampo(tcStr, '', 'indSusp',      2,  2, 1, eSIndSuspToStr(InfoProcesso.dadosProc.infoSusp.GetItem(i).indSusp));
      Gerador.wCampo(tcDat, '', 'dtDecisao',   10, 10, 1, InfoProcesso.dadosProc.infoSusp.GetItem(i).dtDecisao);
      Gerador.wCampo(tcStr, '', 'indDeposito',  1,  1, 1, eSSimNaoToStr(InfoProcesso.dadosProc.infoSusp.GetItem(i).indDeposito));

      Gerador.wGrupo('/infoSusp');
    end;

    if InfoProcesso.dadosProc.infoSusp.Count > 99 then
      Gerador.wAlerta('', 'infoSusp', 'Lista de Informa��es de Suspens�o', ERR_MSG_MAIOR_MAXIMO + '99');
  end;
end;

procedure TEvtTabProcesso.GerarDadosProc;
begin
  Gerador.wGrupo('dadosProc');

  if self.InfoProcesso.ideProcesso.tpProc = tpJudicial then
    Gerador.wCampo(tcInt, '', 'indAutoria', 1, 1, 1, eSindAutoriaToStr(InfoProcesso.dadosProc.indAutoria));

  Gerador.wCampo(tcInt, '', 'indMatProc', 1, 2, 1, eSTpIndMatProcToStr(InfoProcesso.dadosProc.indMatProc));

  if VersaoDF >= ve02_04_02 then
    Gerador.wCampo(tcStr, '', 'observacao', 1, 255, 0, InfoProcesso.dadosProc.observacao);

  GerarDadosProcJud;
  GerarDadosInfoSusp;

  Gerador.wGrupo('/dadosProc');
end;

procedure TEvtTabProcesso.GerarDadosProcJud;
begin
  if (InfoProcesso.dadosProc.dadosProcJudInst()) then
  begin
    Gerador.wGrupo('dadosProcJud');

    Gerador.wCampo(tcStr, '', 'ufVara',   2, 2, 1, self.InfoProcesso.dadosProc.DadosProcJud.ufVara);
    Gerador.wCampo(tcStr, '', 'codMunic', 7, 7, 1, self.InfoProcesso.dadosProc.DadosProcJud.codMunic);
    Gerador.wCampo(tcStr, '', 'idVara',   1, 4, 1, self.InfoProcesso.dadosProc.DadosProcJud.idVara);

    Gerador.wGrupo('/dadosProcJud');
  end;
end;

procedure TEvtTabProcesso.GerarIdeProcesso;
begin
  Gerador.wGrupo('ideProcesso');

  Gerador.wCampo(tcStr, '', 'tpProc',   1,  1, 1, eSTpProcessoToStr(self.InfoProcesso.ideProcesso.tpProc));
  Gerador.wCampo(tcStr, '', 'nrProc',   1, 21, 1, self.InfoProcesso.ideProcesso.nrProc);
  Gerador.wCampo(tcStr, '', 'iniValid', 7,  7, 1, self.InfoProcesso.ideProcesso.iniValid);
  Gerador.wCampo(tcStr, '', 'fimValid', 7,  7, 0, self.InfoProcesso.ideProcesso.fimValid);

  Gerador.wGrupo('/ideProcesso');
end;

function TEvtTabProcesso.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtTabProcesso');
    Gerador.wGrupo('evtTabProcesso Id="' + Self.Id + '"');

    GerarIdeEvento(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);

    Gerador.wGrupo('infoProcesso');

    GerarModoAbertura(Self.ModoLancamento);
    GerarIdeProcesso;

    if Self.ModoLancamento <> mlExclusao then
    begin
      GerarDadosProc;

      if Self.ModoLancamento = mlAlteracao then
        if (InfoProcesso.novaValidadeInst()) then
          GerarIdePeriodo(self.InfoProcesso.NovaValidade,'novaValidade');
    end;

    GerarModoFechamento(Self.ModoLancamento);

    Gerador.wGrupo('/infoProcesso');
    Gerador.wGrupo('/evtTabProcesso');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtTabProcesso');

    Validar(schevtTabProcesso);
  except on e:exception do
    raise Exception.Create('ID: ' + Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtTabProcesso.LerArqIni(const AIniString: String): Boolean;
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
      sSecao := 'evtTabProcesso';
      Id             := INIRec.ReadString(sSecao, 'Id', '');
      Sequencial     := INIRec.ReadInteger(sSecao, 'Sequencial', 0);
      ModoLancamento := eSStrToModoLancamento(Ok, INIRec.ReadString(sSecao, 'ModoLancamento', 'inclusao'));

      sSecao := 'ideEvento';
      ideEvento.TpAmb   := eSStrTotpAmb(Ok, INIRec.ReadString(sSecao, 'tpAmb', '1'));
      ideEvento.ProcEmi := eSStrToProcEmi(Ok, INIRec.ReadString(sSecao, 'procEmi', '1'));
      ideEvento.VerProc := INIRec.ReadString(sSecao, 'verProc', EmptyStr);

      sSecao := 'ideEmpregador';
      ideEmpregador.OrgaoPublico := (TACBreSocial(FACBreSocial).Configuracoes.Geral.TipoEmpregador = teOrgaoPublico);
      ideEmpregador.TpInsc       := eSStrToTpInscricao(Ok, INIRec.ReadString(sSecao, 'tpInsc', '1'));
      ideEmpregador.NrInsc       := INIRec.ReadString(sSecao, 'nrInsc', EmptyStr);

      sSecao := 'ideProcesso';
      infoProcesso.ideProcesso.tpProc   := eSStrToTpProcesso(Ok, INIRec.ReadString(sSecao, 'tpProc', '1'));
      infoProcesso.ideProcesso.nrProc   := INIRec.ReadString(sSecao, 'nrProc', EmptyStr);
      infoProcesso.ideProcesso.IniValid := INIRec.ReadString(sSecao, 'iniValid', EmptyStr);
      infoProcesso.ideProcesso.FimValid := INIRec.ReadString(sSecao, 'fimValid', EmptyStr);

      if (ModoLancamento <> mlExclusao) then
      begin
        sSecao := 'dadosProc';
        infoProcesso.dadosProc.indAutoria := eSStrToindAutoria(Ok, INIRec.ReadString(sSecao, 'indAutoria', '1'));
        infoProcesso.dadosProc.indMatProc := eSStrToTpIndMatProc(Ok, INIRec.ReadString(sSecao, 'indMatProc', '1'));

        sSecao := 'dadosProcJud';
        if INIRec.ReadString(sSecao, 'UfVara', '') <> '' then
        begin
          infoProcesso.dadosProc.DadosProcJud.UfVara   := INIRec.ReadString(sSecao, 'UfVara', '');
          infoProcesso.dadosProc.DadosProcJud.codMunic := INIRec.ReadInteger(sSecao, 'codMunic', 0);
          infoProcesso.dadosProc.DadosProcJud.idVara   := INIRec.ReadString(sSecao, 'idVara', '');
        end;

        I := 1;
        while true do
        begin
          // de 01 at� 99
          sSecao := 'infoSusp' + IntToStrZero(I, 2);
          sFim   := INIRec.ReadString(sSecao, 'codSusp', 'FIM');

          if (sFim = 'FIM') or (Length(sFim) <= 0) then
            break;

          with infoProcesso.dadosProc.infoSusp.Add do
          begin
            codSusp     := sFim;
            indSusp     := eSStrToIndSusp(Ok, INIRec.ReadString(sSecao, 'indSusp', '01'));
            dtDecisao   := StringToDateTime(INIRec.ReadString(sSecao, 'dtDecisao', '0'));
            indDeposito := eSStrToSimNao(Ok, INIRec.ReadString(sSecao, 'indDeposito', 'S'));
          end;

          Inc(I);
        end;

        if ModoLancamento = mlAlteracao then
        begin
          sSecao := 'novaValidade';
          infoProcesso.novaValidade.IniValid := INIRec.ReadString(sSecao, 'iniValid', EmptyStr);
          infoProcesso.novaValidade.FimValid := INIRec.ReadString(sSecao, 'fimValid', EmptyStr);
        end;
      end;
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

end.
