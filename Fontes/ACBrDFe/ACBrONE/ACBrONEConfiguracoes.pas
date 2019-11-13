{******************************************************************************}
{ Projeto: Componente ACBrONE                                                  }
{  Operador Nacional dos Estados - ONE                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2019                                        }
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

{*******************************************************************************
|* Historico
|*
|* 14/10/2019: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrONEConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao, pcnConversaoONE;

type

  { TGeralConfONE }

  TGeralConfONE = class(TGeralConf)
  private
    FVersaoDF: TVersaoONE;
    FverAplic: String;
    FCNPJOper: String;

    procedure SetVersaoDF(const Value: TVersaoONE);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfONE: TGeralConfONE); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

  published
    property VersaoDF: TVersaoONE read FVersaoDF write SetVersaoDF default ve200;
    property verAplic: String     read FverAplic write FverAplic;
    property CNPJOper: String     read FCNPJOper write FCNPJOper;
  end;

  { TArquivosConfONE }

  TArquivosConfONE = class(TArquivosConf)
  private
    FEmissaoPathONE: Boolean;
    FPathONE: String;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfONE: TArquivosConfONE); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathONE(Data: TDateTime = 0; const CNPJ: String = ''): String;
  published
    property EmissaoPathONE: Boolean read FEmissaoPathONE
      write FEmissaoPathONE default False;
    property PathONE: String read FPathONE write FPathONE;
  end;

  { TConfiguracoesONE }

  TConfiguracoesONE = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfONE;
    function GetGeral: TGeralConfONE;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesONE: TConfiguracoesONE); reintroduce;

  published
    property Geral: TGeralConfONE read GetGeral;
    property Arquivos: TArquivosConfONE read GetArquivos;
    property WebServices;
    property Certificados;
    property RespTec;
  end;

implementation

uses
  ACBrUtil, ACBrONE,
  DateUtils;

{ TConfiguracoesONE }

constructor TConfiguracoesONE.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'ONE';
  WebServices.ResourceName := 'ACBrONEServicos';
end;

procedure TConfiguracoesONE.Assign(DeConfiguracoesONE: TConfiguracoesONE);
begin
  Geral.Assign(DeConfiguracoesONE.Geral);
  WebServices.Assign(DeConfiguracoesONE.WebServices);
  Certificados.Assign(DeConfiguracoesONE.Certificados);
  Arquivos.Assign(DeConfiguracoesONE.Arquivos);
  RespTec.Assign(DeConfiguracoesONE.RespTec);
end;

function TConfiguracoesONE.GetArquivos: TArquivosConfONE;
begin
  Result := TArquivosConfONE(FPArquivos);
end;

function TConfiguracoesONE.GetGeral: TGeralConfONE;
begin
  Result := TGeralConfONE(FPGeral);
end;

procedure TConfiguracoesONE.CreateGeralConf;
begin
  FPGeral := TGeralConfONE.Create(Self);
end;

procedure TConfiguracoesONE.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfONE.Create(self);
end;

{ TGeralConfONE }

constructor TGeralConfONE.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve200;
end;

procedure TGeralConfONE.Assign(DeGeralConfONE: TGeralConfONE);
begin
  inherited Assign(DeGeralConfONE);

  VersaoDF := DeGeralConfONE.VersaoDF;
end;

procedure TGeralConfONE.SetVersaoDF(const Value: TVersaoONE);
begin
  FVersaoDF := Value;
end;

procedure TGeralConfONE.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
end;

procedure TGeralConfONE.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  VersaoDF := TVersaoONE(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
end;

{ TArquivosConfONE }

constructor TArquivosConfONE.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathONE := False;
  FPathONE := '';
end;

destructor TArquivosConfONE.Destroy;
begin

  inherited;
end;

procedure TArquivosConfONE.Assign(DeArquivosConfONE: TArquivosConfONE);
begin
  inherited Assign(DeArquivosConfONE);

  FEmissaoPathONE             := DeArquivosConfONE.EmissaoPathONE;
  FPathONE                    := DeArquivosConfONE.PathONE;
end;

function TArquivosConfONE.GetPathONE(Data: TDateTime = 0; const CNPJ: String = ''): String;
begin
  Result := GetPath(FPathONE, ModeloDF, CNPJ, '', Data, ModeloDF);
end;

procedure TArquivosConfONE.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathONE', EmissaoPathONE);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathONE', PathONE);
end;

procedure TArquivosConfONE.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPathONE := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathONE', EmissaoPathONE);
  PathONE := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathONE', PathONE);
end;

end.
