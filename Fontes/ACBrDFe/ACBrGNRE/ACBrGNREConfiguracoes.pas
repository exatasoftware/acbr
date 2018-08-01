{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
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
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit ACBrGNREConfiguracoes;

interface

uses
  Classes, SysUtils, ACBrDFeConfiguracoes, pcnConversao, pgnreConversao;

type

  { TGeralConfGNRE }

  TGeralConfGNRE = class(TGeralConf)
  private
    FVersaoDF: TVersaoGNRE;

    procedure SetVersaoDF(const Value: TVersaoGNRE);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfGNRE: TGeralConfGNRE); reintroduce;

  published
    property VersaoDF: TVersaoGNRE read FVersaoDF write SetVersaoDF default ve100;
  end;

  { TArquivosConfGNRE }

  TArquivosConfGNRE = class(TArquivosConf)
  private
    FEmissaoPathGNRE: boolean;
    FSalvarApenasGNREProcessadas: boolean;
    FPathGNRE: String;
    FPathArqTXT:String;
    FSalvarTXT:Boolean;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeArquivosConfGNRE: TArquivosConfGNRE); reintroduce;

    function GetPathGNRE(Data: TDateTime = 0; CNPJ: String = ''): String;
  published
    property EmissaoPathGNRE: boolean read FEmissaoPathGNRE
      write FEmissaoPathGNRE default False;
    property SalvarApenasGNREProcessadas: boolean
      read FSalvarApenasGNREProcessadas write FSalvarApenasGNREProcessadas default False;
    property PathGNRE: String read FPathGNRE write FPathGNRE;
    property PathArqTXT: String read FPathArqTXT  write FPathArqTXT ;
    property SalvarTXT: Boolean read FSalvarTXT write FSalvarTXT default false;

  end;

  { TConfiguracoesGNRE }

  TConfiguracoesGNRE = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfGNRE;
    function GetGeral: TGeralConfGNRE;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesGNRE: TConfiguracoesGNRE); reintroduce;

  published
    property Geral: TGeralConfGNRE read GetGeral;
    property Arquivos: TArquivosConfGNRE read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil,
  DateUtils;

{ TGeralConfGNRE }

constructor TGeralConfGNRE.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FVersaoDF := ve100;
end;

procedure TGeralConfGNRE.Assign(DeGeralConfGNRE: TGeralConfGNRE);
begin
  inherited Assign(DeGeralConfGNRE);

  VersaoDF := DeGeralConfGNRE.VersaoDF;
end;

procedure TGeralConfGNRE.SetVersaoDF(const Value: TVersaoGNRE);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfGNRE }

constructor TArquivosConfGNRE.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FEmissaoPathGNRE := False;
  FSalvarApenasGNREProcessadas := False;
  FPathGNRE := '';
end;

procedure TArquivosConfGNRE.Assign(DeArquivosConfGNRE: TArquivosConfGNRE);
begin
  inherited Assign(DeArquivosConfGNRE);

  EmissaoPathGNRE             := DeArquivosConfGNRE.EmissaoPathGNRE;
  SalvarApenasGNREProcessadas := DeArquivosConfGNRE.SalvarApenasGNREProcessadas;
  PathGNRE                    := DeArquivosConfGNRE.PathGNRE;
end;

function TArquivosConfGNRE.GetPathGNRE(Data: TDateTime;
  CNPJ: String): String;
begin
  Result := GetPath(FPathGNRE, 'GNRE', CNPJ, Data);
end;

{ TConfiguracoesGNRE }

constructor TConfiguracoesGNRE.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  WebServices.ResourceName := 'ACBrGNREServicos';
end;

procedure TConfiguracoesGNRE.Assign(DeConfiguracoesGNRE: TConfiguracoesGNRE);
begin
  Geral.Assign(DeConfiguracoesGNRE.Geral);
  WebServices.Assign(DeConfiguracoesGNRE.WebServices);
  Certificados.Assign(DeConfiguracoesGNRE.Certificados);
  Arquivos.Assign(DeConfiguracoesGNRE.Arquivos);
end;

function TConfiguracoesGNRE.GetArquivos: TArquivosConfGNRE;
begin
  Result := TArquivosConfGNRE(FPArquivos);
end;

function TConfiguracoesGNRE.GetGeral: TGeralConfGNRE;
begin
  Result := TGeralConfGNRE(FPGeral);
end;

procedure TConfiguracoesGNRE.CreateGeralConf;
begin
  FPGeral := TGeralConfGNRE.Create(Self);
end;

procedure TConfiguracoesGNRE.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfGNRE.Create(Self);
end;

end.
