{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit ACBrDebitoAutomaticoProviderBase;

interface

uses
  SysUtils, Classes,
  ACBrDebitoAutomaticoInterface, ACBrDebitoAutomaticoClass, ACBrDebitoAutomaticoConversao,
  ACBrDebitoAutomaticoLerTxt, ACBrDebitoAutomaticoGravarTxt,
  ACBrDebitoAutomaticoArquivo, ACBrDebitoAutomaticoParametros;

type
  TACBrDebitoAutomaticoProvider = class(TInterfacedObject, IACBrDebitoAutomaticoProvider)
  private
    FConfigGeral: TConfigGeral;

    function GetConfigGeral: TConfigGeral;
  protected
    FAOwner: TComponent;

    function CriarGeradorTxt(const aDebitoAutomatico: TDebitoAutomatico): TArquivoWClass; virtual; abstract;
    function CriarLeitorTxt(const aDebitoAutomatico: TDebitoAutomatico): TArquivoRClass; virtual; abstract;

    procedure Configuracao; virtual;

    procedure GerarArquivo(const aNomeArq: string); virtual; abstract;

    procedure SalvarTxt(const aNomeArq, aArquivoTxt: string);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    function GerarTxt(const aDebitoAutomatico: TDebitoAutomatico; var aTxt, aAlerts: string): Boolean; virtual;
    function LerTxt(const aTxt: String; var aDebitoAutomatico: TDebitoAutomatico): Boolean; virtual;

    procedure Gerar(const aNomeArq: string); virtual;
    procedure Ler; virtual;

    property ConfigGeral: TConfigGeral read GetConfigGeral;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.FilesIO,
  ACBrDFeException,
  ACBrDebitoAutomatico, ACBrDebitoAutomaticoConfiguracoes;

{ TACBrDebitoAutomaticoProvider }

procedure TACBrDebitoAutomaticoProvider.Configuracao;
begin
  with TACBrDebitoAutomatico(FAOwner).Configuracoes.Geral do
  begin
    ConfigGeral.CNPJEmpresa := CNPJEmpresa;
  end;
end;

constructor TACBrDebitoAutomaticoProvider.Create(AOwner: TComponent);
begin
  inherited Create;

  FAOwner := AOwner;
  if not Assigned(FAOwner) then
    raise EACBrDFeException.Create('Componente ACBrDebitoAutomatico n�o informado');

  FConfigGeral := TConfigGeral.Create;

  Configuracao;
end;

destructor TACBrDebitoAutomaticoProvider.Destroy;
begin
  FConfigGeral.Free;

  inherited Destroy;
end;

function TACBrDebitoAutomaticoProvider.GerarTxt(const aDebitoAutomatico: TDebitoAutomatico; var aTxt,
  aAlerts: string): Boolean;
var
  AWriter: TArquivoWClass;
begin
  AWriter := CriarGeradorTxt(aDebitoAutomatico);

  try
    AWriter.Banco := TACBrDebitoAutomatico(FAOwner).Configuracoes.Geral.Banco;

    Result := AWriter.GerarTxt;

    aTxt := AWriter.ConteudoTxt;
  finally
    AWriter.Destroy;
  end;
end;

function TACBrDebitoAutomaticoProvider.GetConfigGeral: TConfigGeral;
begin
  Result := FConfigGeral;
end;

function TACBrDebitoAutomaticoProvider.LerTxt(const aTxt: String; var aDebitoAutomatico: TDebitoAutomatico): Boolean;
var
  AReader: TArquivoRClass;
begin
  AReader := CriarLeitorTxt(aDebitoAutomatico);
  AReader.Arquivo := aTxt;

  try
    AReader.Banco := TACBrDebitoAutomatico(FAOwner).Configuracoes.Geral.Banco;

    Result := AReader.LerTxt;
  finally
    AReader.Destroy;
  end;
end;

procedure TACBrDebitoAutomaticoProvider.SalvarTxt(const aNomeArq, aArquivoTxt: string);
var
  NomeArq: string;
  ArquivoGerado: TStringList;
begin
  NomeArq := Trim(aNomeArq);

  if EstaVazio(NomeArq) then
    NomeArq := PathWithDelim(TACBrDebitoAutomatico(FAOwner).Configuracoes.Arquivos.PathSalvar) +
               '\Cpg'+FormatDateTime('DDMM', now) + '-' +
               BancoToStr(TACBrDebitoAutomatico(FAOwner).Configuracoes.Geral.Banco) +
               '.seq';

  ArquivoGerado := TStringList.Create;
  try
    ArquivoGerado.Text := aArquivoTxt;

    // remove todas as linhas em branco do arquivo
    RemoveEmptyLines(ArquivoGerado);


    ArquivoGerado.SaveToFile(aNomeArq);
  finally
    ArquivoGerado.Free;
  end;
end;

procedure TACBrDebitoAutomaticoProvider.Gerar(const aNomeArq: string);
begin
  GerarArquivo(aNomeArq);
end;

procedure TACBrDebitoAutomaticoProvider.Ler;
begin
  // Implementar
end;

end.
