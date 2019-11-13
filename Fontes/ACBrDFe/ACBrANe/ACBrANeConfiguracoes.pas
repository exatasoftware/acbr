{******************************************************************************}
{ Projeto: Componente ACBrANe                                                  }
{  Biblioteca multiplataforma de componentes Delphi                            }
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

{*******************************************************************************
|* Historico
|*
|* 24/02/2016: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrANeConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao, pcaConversao;

type

  { TGeralConfANe }

  TGeralConfANe = class(TGeralConf)
  private
    FVersaoDF: TVersaoANe;
    FTipoDoc: TTipoDoc;
    FUsuario: String;
    FSenha: String;
    FCodATM: String;
    FCNPJEmitente: String;
    FSeguradora: TSeguradora;

    procedure SetVersaoDF(const Value: TVersaoANe);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfANe: TGeralConfANe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

  published
    property TipoDoc: TTipoDoc read FTipoDoc write FTipoDoc;
    property VersaoDF: TVersaoANe read FVersaoDF write SetVersaoDF default ve200;
    property Usuario: String read FUsuario write FUsuario;
    property Senha: String read FSenha write FSenha;
    property CodATM: String read FCodATM write FCodATM;
    property CNPJEmitente: String read FCNPJEmitente write FCNPJEmitente;
    property Seguradora: TSeguradora read FSeguradora write FSeguradora default tsATM;
  end;

  { TArquivosConfANe }

  TArquivosConfANe = class(TArquivosConf)
  private
    FEmissaoPathANe: boolean;
    FPathANe: String;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfANe: TArquivosConfANe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathANe(Data: TDateTime = 0; const CNPJ: String = ''): String;
  published
    property EmissaoPathANe: boolean read FEmissaoPathANe
      write FEmissaoPathANe default False;
    property PathANe: String read FPathANe write FPathANe;
  end;

  { TConfiguracoesANe }

  TConfiguracoesANe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfANe;
    function GetGeral: TGeralConfANe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesANe: TConfiguracoesANe); reintroduce;

  published
    property Geral: TGeralConfANe read GetGeral;
    property Arquivos: TArquivosConfANe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil, DateUtils;

{ TConfiguracoesANe }

constructor TConfiguracoesANe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  WebServices.ResourceName := 'ACBrANeServicos';
end;

function TConfiguracoesANe.GetArquivos: TArquivosConfANe;
begin
  Result := TArquivosConfANe(FPArquivos);
end;

function TConfiguracoesANe.GetGeral: TGeralConfANe;
begin
  Result := TGeralConfANe(FPGeral);
end;

procedure TConfiguracoesANe.CreateGeralConf;
begin
  FPGeral := TGeralConfANe.Create(Self);
end;

procedure TConfiguracoesANe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfANe.Create(self);
end;

procedure TConfiguracoesANe.Assign(DeConfiguracoesANe: TConfiguracoesANe);
begin
  Geral.Assign(DeConfiguracoesANe.Geral);
  WebServices.Assign(DeConfiguracoesANe.WebServices);
  Certificados.Assign(DeConfiguracoesANe.Certificados);
  Arquivos.Assign(DeConfiguracoesANe.Arquivos);
end;

{ TGeralConfANe }

procedure TGeralConfANe.Assign(DeGeralConfANe: TGeralConfANe);
begin
  inherited Assign(DeGeralConfANe);

  FVersaoDF := DeGeralConfANe.VersaoDF;
end;

constructor TGeralConfANe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve200;
  FTipoDoc := tdCTe;
  FUsuario := '';
  FSenha := '';
  FCodATM := '';
  FCNPJEmitente := '';
  FSeguradora := tsATM;
end;

procedure TGeralConfANe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'TipoDoc', Integer(TipoDoc));
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Usuario', Usuario);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Senha', Senha);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'CodATM', CodATM);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'CNPJEmitente', CNPJEmitente);
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'Seguradora', Integer(Seguradora));
end;

procedure TGeralConfANe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  TipoDoc := TTipoDoc(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'TipoDoc', Integer(TipoDoc)));
  VersaoDF := TVersaoANe(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
  Usuario := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Usuario', Usuario);
  Senha := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Senha', Senha);
  CodATM := AIni.ReadString(fpConfiguracoes.SessaoIni, 'CodATM', CodATM);
  CNPJEmitente := AIni.ReadString(fpConfiguracoes.SessaoIni, 'CNPJEmitente', CNPJEmitente);
  Seguradora := TSeguradora(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'Seguradora', Integer(Seguradora)));
end;

procedure TGeralConfANe.SetVersaoDF(const Value: TVersaoANe);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfANe }

procedure TArquivosConfANe.Assign(DeArquivosConfANe: TArquivosConfANe);
begin
  inherited Assign(DeArquivosConfANe);

  FEmissaoPathANe := DeArquivosConfANe.EmissaoPathANe;
  FPathANe        := DeArquivosConfANe.PathANe;
end;

constructor TArquivosConfANe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathANe := False;
  FPathANe := '';
end;

destructor TArquivosConfANe.Destroy;
begin

  inherited;
end;

function TArquivosConfANe.GetPathANe(Data: TDateTime = 0; const CNPJ: String = ''): String;
begin
  Result := GetPath(FPathANe, 'ANe', CNPJ, '', Data);
end;

procedure TArquivosConfANe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathANe', EmissaoPathANe);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathANe', PathANe);
end;

procedure TArquivosConfANe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPathANe := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathANe', EmissaoPathANe);
  PathANe := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathANe', PathANe);
end;

end.
