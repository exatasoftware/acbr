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

unit ACBrReinfConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao,
  pcnConversaoReinf;

type
  { TGeralConfReinf }
  TGeralConfReinf = class(TGeralConf)
  private
    FVersaoDF: TVersaoReinf;
    FIdTransmissor: string;
    FIdContribuinte: string;
    FTipoContribuinte: TContribuinte;

    procedure SetVersaoDF(const Value: TVersaoReinf);
    procedure SetTipoContribuinte(const Value: TContribuinte);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfReinf: TGeralConfReinf); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;
  published
    property VersaoDF: TVersaoReinf read FVersaoDF write SetVersaoDF default v1_03_00;
    property IdContribuinte: string read FIdContribuinte write FIdContribuinte;
    property IdTransmissor: string read FIdTransmissor write FIdTransmissor;
    property TipoContribuinte: TContribuinte read FTipoContribuinte write SetTipoContribuinte default tcPessoaJuridica;
  end;

  { TArquivosConfReinf }
  TArquivosConfReinf = class(TArquivosConf)
  private
    FEmissaoPathReinf: Boolean;
    FPathReinf: String;
  public
    constructor Create(AOwner: TConfiguracoes); override;

    procedure Assign(DeArquivosConfReinf: TArquivosConfReinf); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathReinf(Data: TDateTime = 0; const CNPJ: String = ''): String;
  published
    property EmissaoPathReinf: Boolean read FEmissaoPathReinf write FEmissaoPathReinf default False;
    property PathReinf: String read FPathReinf write FPathReinf;
  end;

  { TConfiguracoesReinf }
  TConfiguracoesReinf = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfReinf;
    function GetGeral: TGeralConfReinf;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Assign(DeConfiguracoesReinf: TConfiguracoesReinf); reintroduce;
  published
    property Geral: TGeralConfReinf read GetGeral;
    property Arquivos: TArquivosConfReinf read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrReinf;

{ TConfiguracoesReinf }

constructor TConfiguracoesReinf.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'Reinf';
  WebServices.ResourceName := 'ACBrReinfServicos';
end;

procedure TConfiguracoesReinf.Assign(DeConfiguracoesReinf: TConfiguracoesReinf);
begin
  Geral.Assign(DeConfiguracoesReinf.Geral);
  WebServices.Assign(DeConfiguracoesReinf.WebServices);
  Certificados.Assign(DeConfiguracoesReinf.Certificados);
  Arquivos.Assign(DeConfiguracoesReinf.Arquivos);
end;

function TConfiguracoesReinf.GetArquivos: TArquivosConfReinf;
begin
  Result := TArquivosConfReinf(FPArquivos);
end;

function TConfiguracoesReinf.GetGeral: TGeralConfReinf;
begin
  Result := TGeralConfReinf(FPGeral);
end;

procedure TConfiguracoesReinf.CreateGeralConf;
begin
  FPGeral := TGeralConfReinf.Create(Self);
end;

procedure TConfiguracoesReinf.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfReinf.Create(self);
end;

{ TGeralConfReinf }

constructor TGeralConfReinf.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := v1_03_00;
  FIdTransmissor := '';
  FIdContribuinte := '';
  FTipoContribuinte := tcPessoaJuridica;
end;

procedure TGeralConfReinf.Assign(DeGeralConfReinf: TGeralConfReinf);
begin
  inherited Assign(DeGeralConfReinf);

  VersaoDF := DeGeralConfReinf.VersaoDF;
  IdTransmissor := DeGeralConfReinf.IdTransmissor;
  IdContribuinte := DeGeralConfReinf.IdContribuinte;
  TipoContribuinte := DeGeralConfReinf.TipoContribuinte;
end;

procedure TGeralConfReinf.SetVersaoDF(const Value: TVersaoReinf);
begin
  FVersaoDF := Value;
end;

procedure TGeralConfReinf.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'IdTransmissor', IdTransmissor);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'IdContribuinte', IdContribuinte);
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'TipoContribuinte', Integer(TipoContribuinte));
end;

procedure TGeralConfReinf.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  VersaoDF := TVersaoReinf(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
  IdTransmissor := AIni.ReadString(fpConfiguracoes.SessaoIni, 'IdTransmissor', IdTransmissor);
  IdContribuinte := AIni.ReadString(fpConfiguracoes.SessaoIni, 'IdContribuinte', IdContribuinte);
  TipoContribuinte := TContribuinte(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'TipoContribuinte', Integer(TipoContribuinte)));
end;

procedure TGeralConfReinf.SetTipoContribuinte(const Value: TContribuinte);
begin
  FTipoContribuinte := Value;
end;

{ TArquivosConfReinf }

constructor TArquivosConfReinf.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathReinf := False;
  FPathReinf := '';
end;

procedure TArquivosConfReinf.Assign(
  DeArquivosConfReinf: TArquivosConfReinf);
begin
  inherited Assign(DeArquivosConfReinf);

  EmissaoPathReinf := DeArquivosConfReinf.EmissaoPathReinf;
  PathReinf        := DeArquivosConfReinf.PathReinf;
end;

function TArquivosConfReinf.GetPathReinf(Data: TDateTime;
  const CNPJ: String): String;
begin
  Result := GetPath(PathReinf, ACBRReinf_MODELODF, CNPJ, '', Data, ACBRReinf_MODELODF);
end;

procedure TArquivosConfReinf.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathReinf', EmissaoPathReinf);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathReinf', PathReinf);
end;

procedure TArquivosConfReinf.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  EmissaoPathReinf := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathReinf', EmissaoPathReinf);
  PathReinf := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathReinf', PathReinf);
end;

end.
