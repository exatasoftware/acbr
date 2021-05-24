{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrNFSeXConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, ACBrNFSeXParametros, ACBrNFSeXConversao;

type

  { TDadosEmitente }

 TDadosEmitente = class(TPersistent)
 private
   FNomeFantasia: String;
   FInscricaoEstadual: String;
   FEndereco: String;
   FNumero: String;
   FCEP: String;
   FBairro: String;
   FComplemento: String;
   FMunicipio: String;
   FUF: String;
   FCodigoMunicipio: String;
   FTelefone: String;
   FEmail: String;

 public
   Constructor Create;
   procedure Assign(Source: TPersistent); override;

 published
   property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
   property InscricaoEstadual: String read FInscricaoEstadual write FInscricaoEstadual;
   property Endereco: String read FEndereco write FEndereco;
   property Numero: String read FNumero write FNumero;
   property CEP: String read FCEP write FCEP;
   property Bairro: String read FBairro write FBairro;
   property Complemento: String read FComplemento write FComplemento;
   property Municipio: String read FMunicipio write FMunicipio;
   property UF: String read FUF write FUF;
   property CodigoMunicipio: String read FCodigoMunicipio write FCodigoMunicipio;
   property Telefone: String read FTelefone write FTelefone;
   property Email: String read FEmail write FEmail;
 end;

 { TEmitenteConfNFSe }

 TEmitenteConfNFSe = class(TPersistent)
 private
   FCNPJ: String;
   FInscMun: String;
   FRazSocial: String;
   FWSUser: String;
   FWSSenha: String;
   FWSFraseSecr: String;
   FWSChaveAcesso: String;
   FWSChaveAutoriz: String;
   FDadosEmitente: TDadosEmitente;

 public
   Constructor Create;
   destructor Destroy; override;
   procedure Assign(Source: TPersistent); override;

 published
   property CNPJ: String           read FCNPJ           write FCNPJ;
   property InscMun: String        read FInscMun        write FInscMun;
   property RazSocial: String      read FRazSocial      write FRazSocial;
   property WSUser: String         read FWSUser         write FWSUser;
   property WSSenha: String        read FWSSenha        write FWSSenha;
   property WSFraseSecr: String    read FWSFraseSecr    write FWSFraseSecr;
   property WSChaveAcesso: String  read FWSChaveAcesso  write FWSChaveAcesso;
   property WSChaveAutoriz: String read FWSChaveAutoriz write FWSChaveAutoriz;

   property DadosEmitente: TDadosEmitente read FDadosEmitente write FDadosEmitente;
 end;

  { TGeralConfNFSe }

  TGeralConfNFSe = class(TGeralConf)
  private
    FPIniParams: TMemIniFile;

    FCodigoMunicipio: Integer;
    FProvedor: TnfseProvedor;
    FxProvedor: String;
    FxMunicipio: String;
    FxUF: String;
    FCNPJPrefeitura: String;
    FConsultaLoteAposEnvio: Boolean;
    FConsultaAposCancelar: Boolean;
    FEmitente: TEmitenteConfNFSe;

    procedure SetCodigoMunicipio(const Value: Integer);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;

    procedure Assign(DeGeralConfNFSe: TGeralConfNFSe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;
    procedure LerParamsMunicipio;
  published
    property CodigoMunicipio: Integer read FCodigoMunicipio write SetCodigoMunicipio;
    property Provedor: TnfseProvedor read FProvedor;
    property xProvedor: String read FxProvedor;
    property xMunicipio: String read FxMunicipio;
    property xUF: String read FxUF;
    property CNPJPrefeitura: String read FCNPJPrefeitura write FCNPJPrefeitura;

    property ConsultaLoteAposEnvio: Boolean read FConsultaLoteAposEnvio write FConsultaLoteAposEnvio default True;
    property ConsultaAposCancelar: Boolean  read FConsultaAposCancelar  write FConsultaAposCancelar default True;

    property Emitente: TEmitenteConfNFSe read FEmitente write FEmitente;
  end;

  { TArquivosConfNFSe }

  TArquivosConfNFSe = class(TArquivosConf)
  private
    FEmissaoPathNFSe: boolean;
    FPathGer: String;
    FPathRPS: String;
    FPathNFSe: String;
    FPathCan: String;
    FNomeLongoNFSe: Boolean;
    FTabServicosExt: Boolean;

    procedure SetTabServicosExt(const Value: Boolean);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeArquivosConfNFSe: TArquivosConfNFSe); reintroduce;

    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathGer(Data: TDateTime = 0; const CNPJ: String = '';
      const IE: String = ''): String;

    function GetPathRPS(Data: TDateTime = 0; const CNPJ: String = '';
      const IE: String = ''): String;

    function GetPathNFSe(Data: TDateTime = 0; const CNPJ: String = '';
      const IE: String = ''): String;

    function GetPathCan(Data: TDateTime = 0; const CNPJ: String = '';
      const IE: String = ''): String;
  published
    property EmissaoPathNFSe: boolean read FEmissaoPathNFSe
      write FEmissaoPathNFSe default False;
    property PathGer: String read FPathGer write FPathGer;
    property PathRPS: String read FPathRPS  write FPathRPS;
    property PathNFSe: String read FPathNFSe write FPathNFSe;
    property PathCan: String read FPathCan write FPathCan;
    property NomeLongoNFSe: Boolean read FNomeLongoNFSe
      write FNomeLongoNFSe default False;
    property TabServicosExt: Boolean read FTabServicosExt
      write SetTabServicosExt default False;
  end;

  { TConfiguracoesNFSe }

  TConfiguracoesNFSe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfNFSe;
    function GetGeral: TGeralConfNFSe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesNFSe: TConfiguracoesNFSe); reintroduce;

  published
    property Geral: TGeralConfNFSe read GetGeral;
    property Arquivos: TArquivosConfNFSe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  DateUtils,
  ACBrUtil, ACBrNFSeX;

{ TEmitenteConfNFSe }

constructor TEmitenteConfNFSe.Create;
begin
  inherited Create;

  FCNPJ           := '';
  FInscMun        := '';
  FRazSocial      := '';
  FWSUser         := '';
  FWSSenha        := '';
  FWSFraseSecr    := '';
  FWSChaveAcesso  := '';
  FWSChaveAutoriz := '';

  FDadosEmitente := TDadosEmitente.Create;
end;

procedure TEmitenteConfNFSe.Assign(Source: TPersistent);
begin
  if Source is TEmitenteConfNFSe then
  begin
    FCNPJ           := TEmitenteConfNFSe(Source).CNPJ;
    FInscMun        := TEmitenteConfNFSe(Source).InscMun;
    FRazSocial      := TEmitenteConfNFSe(Source).RazSocial;
    FWSUser         := TEmitenteConfNFSe(Source).WSUser;
    FWSSenha        := TEmitenteConfNFSe(Source).WSSenha;
    FWSFraseSecr    := TEmitenteConfNFSe(Source).WSFraseSecr;
    FWSChaveAcesso  := TEmitenteConfNFSe(Source).WSChaveAcesso;
    FWSChaveAutoriz := TEmitenteConfNFSe(Source).WSChaveAutoriz;

    FDadosEmitente.Assign(TEmitenteConfNFSe(Source).DadosEmitente);
  end
  else
    inherited Assign(Source);
end;

destructor TEmitenteConfNFSe.Destroy;
begin
  FDadosEmitente.Free;

  inherited;
end;

{ TConfiguracoesNFSe }

constructor TConfiguracoesNFSe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  WebServices.ResourceName := 'ACBrNFSeXServicos';
end;

procedure TConfiguracoesNFSe.Assign(DeConfiguracoesNFSe: TConfiguracoesNFSe);
begin
  Geral.Assign(DeConfiguracoesNFSe.Geral);
  WebServices.Assign(DeConfiguracoesNFSe.WebServices);
  Certificados.Assign(DeConfiguracoesNFSe.Certificados);
  Arquivos.Assign(DeConfiguracoesNFSe.Arquivos);
end;

function TConfiguracoesNFSe.GetArquivos: TArquivosConfNFSe;
begin
  Result := TArquivosConfNFSe(FPArquivos);
end;

function TConfiguracoesNFSe.GetGeral: TGeralConfNFSe;
begin
  Result := TGeralConfNFSe(FPGeral);
end;

procedure TConfiguracoesNFSe.CreateGeralConf;
begin
  FPGeral := TGeralConfNFSe.Create(Self);
end;

procedure TConfiguracoesNFSe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfNFSe.Create(self);
end;

{ TGeralConfNFSe }

constructor TGeralConfNFSe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmitente := TEmitenteConfNFSe.Create;

  FPIniParams := TMemIniFile.Create('');
  FProvedor := proNenhum;

  FConsultaLoteAposEnvio := True;
  FConsultaAposCancelar := True;
end;

destructor TGeralConfNFSe.Destroy;
begin
  FEmitente.Free;

  inherited;
end;

procedure TGeralConfNFSe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'CodigoMunicipio', CodigoMunicipio);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'CNPJPrefeitura', CNPJPrefeitura);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'ConsultaLoteAposEnvio', ConsultaLoteAposEnvio);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'ConsultaAposCancelar', ConsultaAposCancelar);
  // Emitente
  with Emitente do
  begin
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.CNPJ', CNPJ);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.InscMun', InscMun);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.RazSocial', RazSocial);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.WSUser', WSUser);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.WSSenha', WSSenha);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.WSFraseSecr', WSFraseSecr);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.WSChaveAcesso', WSChaveAcesso);
    AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.WSChaveAutoriz', WSChaveAutoriz);
    // Dados do Emitente
    with DadosEmitente do
    begin
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.NomeFantasia', NomeFantasia);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.InscricaoEstadual', InscricaoEstadual);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Endereco', Endereco);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Numero', Numero);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.CEP', CEP);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Bairro', Bairro);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Complemento', Complemento);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Municipio', Municipio);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.UF', UF);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.CodigoMunicipio', CodigoMunicipio);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Telefone', Telefone);
      AIni.WriteString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Email', Email);
    end;
  end;
end;

procedure TGeralConfNFSe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  CodigoMunicipio := AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'CodigoMunicipio', CodigoMunicipio);
  CNPJPrefeitura := AIni.ReadString(fpConfiguracoes.SessaoIni, 'CNPJPrefeitura', CNPJPrefeitura);
  ConsultaLoteAposEnvio := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'ConsultaLoteAposEnvio', ConsultaLoteAposEnvio);
  ConsultaAposCancelar := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'ConsultaAposCancelar', ConsultaAposCancelar);
  // Emitente
  with Emitente do
  begin
    CNPJ := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.CNPJ', CNPJ);
    InscMun := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.InscMun', InscMun);
    RazSocial := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.RazSocial', RazSocial);
    WSUser := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.WSUser', WSUser);
    WSSenha := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.WSSenha', WSSenha);
    WSFraseSecr := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.WSFraseSecr', WSFraseSecr);
    WSChaveAcesso := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.WSChaveAcesso', WSChaveAcesso);
    WSChaveAutoriz := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.WSChaveAutoriz', WSChaveAutoriz);
    // Dados do Emitente
    with DadosEmitente do
    begin
      NomeFantasia := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.NomeFantasia', NomeFantasia);
      InscricaoEstadual := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.InscricaoEstadual', InscricaoEstadual);
      Endereco := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Endereco', Endereco);
      Numero := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Numero', Numero);
      CEP := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.CEP', CEP);
      Bairro := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Bairro', Bairro);
      Complemento := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Complemento', Complemento);
      Municipio := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Municipio', Municipio);
      UF := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.UF', UF);
      CodigoMunicipio := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.CodigoMunicipio', CodigoMunicipio);
      Telefone := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Telefone', Telefone);
      Email := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Emitente.Dados.Email', Email);
    end;
  end;
end;

procedure TGeralConfNFSe.LerParamsMunicipio;
var
  Ok: Boolean;
  CodIBGE: string;
begin
  // ===========================================================================
  // Verifica se o c�digo IBGE consta no arquivo: ACBrNFSeXServicos
  // se encontrar carrega os par�metros definidos.
  // ===========================================================================
  CodIBGE := IntToStr(FCodigoMunicipio);

  FPIniParams.SetStrings(fpConfiguracoes.WebServices.Params);

  FxProvedor := FPIniParams.ReadString(CodIBGE, 'Provedor', '');

  FProvedor := StrToProvedor(Ok, FxProvedor);

  if Assigned(fpConfiguracoes.Owner) then
    TACBrNFSeX(fpConfiguracoes.Owner).SetProvedor;

  if FProvedor = proNenhum then
    raise Exception.Create('C�digo do Municipio [' + CodIBGE + '] n�o Encontrado.');

  FxMunicipio := FPIniParams.ReadString(CodIBGE, 'Nome', '');
  FxUF := FPIniParams.ReadString(CodIBGE, 'UF'  , '');
end;

procedure TGeralConfNFSe.Assign(DeGeralConfNFSe: TGeralConfNFSe);
begin
  inherited Assign(DeGeralConfNFSe);

  FProvedor := DeGeralConfNFSe.Provedor;

  FEmitente.Assign(DeGeralConfNFSe.Emitente);
end;

procedure TGeralConfNFSe.SetCodigoMunicipio(const Value: Integer);
begin
  FCodigoMunicipio := Value;

  if FCodigoMunicipio <> 0 then
    LerParamsMunicipio;
end;

{ TArquivosConfNFSe }

constructor TArquivosConfNFSe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathNFSe := False;
  FPathGer := '';
  FPathRPS := '';
  FPathNFSe := '';
  FPathCan := '';
  FNomeLongoNFSe := False;
  FTabServicosExt := False;
end;

procedure TArquivosConfNFSe.Assign(DeArquivosConfNFSe: TArquivosConfNFSe);
begin
  inherited Assign(DeArquivosConfNFSe);

  EmissaoPathNFSe := DeArquivosConfNFSe.EmissaoPathNFSe;
  PathGer := DeArquivosConfNFSe.PathGer;
  PathRPS := DeArquivosConfNFSe.PathRPS;
  PathNFSe := DeArquivosConfNFSe.PathNFSe;
  PathCan := DeArquivosConfNFSe.PathCan;
  NomeLongoNFSe := DeArquivosConfNFSe.NomeLongoNFSe;
  TabServicosExt := DeArquivosConfNFSe.TabServicosExt;
end;

function TArquivosConfNFSe.GetPathGer(Data: TDateTime = 0;
  const CNPJ: String = ''; const IE: String = ''): String;
begin
  Result := GetPath(FPathGer, 'NFSe', CNPJ, IE, Data);
end;

function TArquivosConfNFSe.GetPathRPS(Data: TDateTime = 0;
  const CNPJ: String = ''; const IE: String = ''): String;
var
  Dir: String;
begin
  if FPathRPS <> '' then
    Result := GetPath(FPathRPS, 'Recibos', CNPJ, IE, Data)
  else
  begin
    Dir := GetPath(FPathGer, 'NFSe', CNPJ, IE, Data);

    Dir := PathWithDelim(Dir) + 'Recibos';

    if not DirectoryExists(Dir) then
      ForceDirectories(Dir);

    Result := Dir;
  end;
end;

procedure TArquivosConfNFSe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathNFSe', EmissaoPathNFSe);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathGer', PathGer);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathRps', PathRPS);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathNFSe', PathNFSe);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathCan', PathCan);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'NomeLongoNFSe', NomeLongoNFSe);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'TabServicosExt', TabServicosExt);
end;

procedure TArquivosConfNFSe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPathNFSe := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathNFSe', EmissaoPathNFSe);
  PathGer := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathGer', PathGer);
  PathRPS := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathRps', PathRPS);
  PathNFSe := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathNFSe', PathNFSe);
  PathCan := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathCan', PathCan);
  NomeLongoNFSe := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'NomeLongoNFSe', NomeLongoNFSe);
  TabServicosExt := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'TabServicosExt', TabServicosExt);
end;

procedure TArquivosConfNFSe.SetTabServicosExt(const Value: Boolean);
begin
  FTabServicosExt := Value;

  if not Assigned(TACBrNFSeX(TConfiguracoesNFSe(Owner).Owner).Provider) then Exit;

  with TACBrNFSeX(TConfiguracoesNFSe(Owner).Owner).Provider.ConfigGeral do
  begin
    TabServicosExt := FTabServicosExt;
  end;
end;

function TArquivosConfNFSe.GetPathNFSe(Data: TDateTime = 0;
  const CNPJ: String = ''; const IE: String = ''): String;
var
  Dir: String;
begin
  if FPathNFSe <> '' then
    Result := GetPath(FPathNFSe, 'Notas', CNPJ, IE, Data)
  else
  begin
    Dir := GetPath(FPathGer, 'NFSe', CNPJ, IE, Data);

    Dir := PathWithDelim(Dir) + 'Notas';

    if not DirectoryExists(Dir) then
      ForceDirectories(Dir);

    Result := Dir;
  end;
end;

function TArquivosConfNFSe.GetPathCan(Data: TDateTime = 0;
  const CNPJ: String = ''; const IE: String = ''): String;
var
  Dir: String;
begin
  if FPathCan <> '' then
    Result := GetPath(FPathCan, 'Can', CNPJ, IE, Data)
  else
  begin
    Dir := GetPath(FPathGer, 'NFSe', CNPJ, IE, Data);

    Dir := PathWithDelim(Dir) + 'Can';

    if not DirectoryExists(Dir) then
      ForceDirectories(Dir);

    Result := Dir;
  end;
end;

{ TDadosEmitente }

procedure TDadosEmitente.Assign(Source: TPersistent);
begin
  if Source is TDownloadConf then
  begin
    FNomeFantasia := TDadosEmitente(Source).NomeFantasia;
    FInscricaoEstadual := TDadosEmitente(Source).InscricaoEstadual;
    FEndereco := TDadosEmitente(Source).Endereco;
    FNumero := TDadosEmitente(Source).Numero;
    FCEP := TDadosEmitente(Source).CEP;
    FBairro := TDadosEmitente(Source).Bairro;
    FComplemento := TDadosEmitente(Source).Complemento;
    FMunicipio := TDadosEmitente(Source).Municipio;
    FUF := TDadosEmitente(Source).UF;
    FCodigoMunicipio := TDadosEmitente(Source).CodigoMunicipio;
    FTelefone := TDadosEmitente(Source).Telefone;
    FEmail := TDadosEmitente(Source).Email;
  end
  else
    inherited Assign(Source);
end;

constructor TDadosEmitente.Create;
begin
  inherited Create;

  FNomeFantasia := '';
  FInscricaoEstadual := '';
  FEndereco := '';
  FNumero := '';
  FCEP := '';
  FBairro := '';
  FComplemento := '';
  FMunicipio := '';
  FUF := '';
  FCodigoMunicipio := '';
  FTelefone := '';
  FEmail := '';
end;

end.
