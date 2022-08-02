{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrPagForConfiguracoes;

interface

uses
  Classes, Forms, SysUtils,
  ACBrPagForConversao;

type
  TConfiguracoes = class;

  { TDadosConta }

  TDadosConta = class(TPersistent)
  private
    FAgenciaCodigo: Integer;
    FAgenciaDV: String;
    FContaNumero: Int64;
    FContaDV: String;
    FDV: String;
    FTipoConta: Integer;
  public
    Constructor Create;

    procedure Assign(Source: TPersistent); override;
  published
    property AgenciaCodigo: Integer read FAgenciaCodigo write FAgenciaCodigo;
    property AgenciaDV: String read FAgenciaDV write FAgenciaDV;
    property ContaNumero: Int64 read FContaNumero write FContaNumero;
    property ContaDV: String read FContaDV write FContaDV;
    property DV: String read FDV write FDV;
    property TipoConta: Integer read FTipoConta write FTipoConta;
  end;

  { TDadosEndereco }

  TDadosEndereco = class(TPersistent)
  private
    FLogradouro: String;
    FNumero: string;
    FComplemento: String;
    FCidade: String;
    FCEP: Integer;
    FEstado: String;
  public
    Constructor Create;

    procedure Assign(Source: TPersistent); override;
  published
    property Logradouro: String read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: String read FComplemento write FComplemento;
    property Cidade: String read FCidade write FCidade;
    property CEP: Integer read FCEP write FCEP;
    property Estado: String read FEstado write FEstado;
  end;

  { TEmpresaConfNFSe }

  TEmpresaConfNFSe = class(TPersistent)
  private
    FTipoInscricao: TTipoInscricao;
    FNumeroInscricao: String;
    FConvenio: String;
    FNome: String;
    FConta: TDadosConta;
    FEndereco: TDadosEndereco;
  public
    Constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
  published
    property TipoInscricao: TTipoInscricao read FTipoInscricao write FTipoInscricao;
    property NumeroInscricao: String read FNumeroInscricao write FNumeroInscricao;
    property Convenio: String read FConvenio write FConvenio;
    property Nome: String read FNome write FNome;

    property Conta: TDadosConta read FConta write FConta;
    property Endereco: TDadosEndereco read FEndereco write FEndereco;
  end;

  TGeralConf = class(TComponent)
  private
    FBanco: TBanco;
    FCodigoBanco: String;
    FSubstitutaBanco: TBanco;
    FCodigoSubstBanco: String;
    FEmpresa: TEmpresaConfNFSe;
    FUsarDadosConfig: Boolean;

    procedure SetBanco(const Value: TBanco);
    procedure SetSubstitutaBanco(const Value: TBanco);
  protected
    fpConfiguracoes: TConfiguracoes;
  public
    constructor Create(AConfiguracoes: TConfiguracoes); reintroduce; overload; virtual;
    destructor Destroy; override;

    procedure Assign(DeGeralConf: TGeralConf); reintroduce; virtual;
  published
    property Banco: TBanco read FBanco write SetBanco default pagNenhum;
    property CodigoBanco: String read FCodigoBanco;
    property SubstitutaBanco: TBanco read FSubstitutaBanco
      write SetSubstitutaBanco default pagNenhum;
    property CodigoSubstBanco: String read FCodigoSubstBanco;

    property Empresa: TEmpresaConfNFSe read FEmpresa write FEmpresa;
    property UsarDadosConfig: Boolean read FUsarDadosConfig
      write FUsarDadosConfig default False;
  end;

  TArquivosConf = class(TComponent)
  private
    FSalvar: Boolean;
    FSepararPorCNPJ: Boolean;
    FSepararPorMes: Boolean;
    FAdicionarLiteral: Boolean;
    FPathSalvar: String;

    function GetPathSalvar: String;
  protected
    fpConfiguracoes: TConfiguracoes;
  public
    constructor Create(AConfiguracoes: TConfiguracoes); reintroduce; overload; virtual;
    destructor Destroy; override;

    procedure Assign(DeArquivosConf: TArquivosConf); reintroduce; virtual;

    function GetPath(const APath, ALiteral, CNPJ: String; Data: TDateTime): String; virtual;
  published
    property PathSalvar: String read GetPathSalvar write FPathSalvar;
    property Salvar: Boolean read FSalvar write FSalvar default False;
    property AdicionarLiteral: Boolean read FAdicionarLiteral write FAdicionarLiteral default False;
    property SepararPorCNPJ: Boolean read FSepararPorCNPJ write FSepararPorCNPJ default False;
    property SepararPorMes: Boolean read FSepararPorMes write FSepararPorMes default False;
  end;

  TConfiguracoes = class(TComponent)
  protected
    FPGeral: TGeralConf;
    FPArquivos: TArquivosConf;

    procedure CreateGeralConf; virtual;
    procedure CreateArquivosConf; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Assign(DeConfiguracoes: TConfiguracoes); reintroduce; virtual;

    procedure Limpar;
  published
    property Geral: TGeralConf read FPGeral;
    property Arquivos: TArquivosConf read FPArquivos;
  end;

implementation

uses
  Math, StrUtils, DateUtils,
  ACBrUtil.Base, ACBrUtil.FilesIO,
  ACBrPagFor;

{ TConfiguracoes }

procedure TConfiguracoes.Assign(DeConfiguracoes: TConfiguracoes);
begin
  Geral.Assign(DeConfiguracoes.Geral);
  Arquivos.Assign(DeConfiguracoes.Arquivos);
end;

constructor TConfiguracoes.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  CreateGeralConf;
  FPGeral.Name  := 'GeralConf';
  {$IFDEF COMPILER6_UP}
   FPGeral.SetSubComponent( true );{ para gravar no DFM/XFM }
  {$ENDIF}

  CreateArquivosConf;
  FPArquivos.Name  := 'ArquivosConf';
  {$IFDEF COMPILER6_UP}
   FPArquivos.SetSubComponent( true );{ para gravar no DFM/XFM }
  {$ENDIF}
end;

procedure TConfiguracoes.CreateArquivosConf;
begin
  FPArquivos := TArquivosConf.Create(self);
end;

procedure TConfiguracoes.CreateGeralConf;
begin
  FPGeral := TGeralConf.Create(Self);
end;

destructor TConfiguracoes.Destroy;
begin
  FPGeral.Free;
  FPArquivos.Free;

  inherited;
end;

procedure TConfiguracoes.Limpar;
begin
  FPGeral.FBanco := pagNenhum;
  FPGeral.FSubstitutaBanco := pagNenhum;

  FPArquivos.FSalvar := False;
  FPArquivos.FSepararPorCNPJ := False;
  FPArquivos.FSepararPorMes := False;
  FPArquivos.FAdicionarLiteral := False;
  FPArquivos.FPathSalvar := '';
end;

{ TGeralConf }

procedure TGeralConf.Assign(DeGeralConf: TGeralConf);
begin
  Banco := DeGeralConf.Banco;
  FCodigoBanco := DeGeralConf.CodigoBanco;
  SubstitutaBanco := DeGeralConf.SubstitutaBanco;
  FCodigoSubstBanco := DeGeralConf.CodigoSubstBanco;
end;

constructor TGeralConf.Create(AConfiguracoes: TConfiguracoes);
begin
  inherited Create(AConfiguracoes);

  fpConfiguracoes := AConfiguracoes;

  FBanco := pagNenhum;
  FCodigoBanco := '000';
  FSubstitutaBanco := pagNenhum;
  FCodigoSubstBanco := '000';

  FEmpresa := TEmpresaConfNFSe.Create;

  FUsarDadosConfig := False;
end;

destructor TGeralConf.Destroy;
begin
  FEmpresa.Free;

  inherited;
end;

procedure TGeralConf.SetBanco(const Value: TBanco);
begin
  FBanco := Value;
  FCodigoBanco := BancoToStr(FBanco);

  if Assigned(fpConfiguracoes.Owner) then
    TACBrPagFor(fpConfiguracoes.Owner).SetProvider;

  if FBanco = pagNenhum then
    raise Exception.Create('Banco n�o Encontrado.');
end;

procedure TGeralConf.SetSubstitutaBanco(const Value: TBanco);
begin
  FSubstitutaBanco := Value;
  FCodigoSubstBanco := BancoToStr(FSubstitutaBanco);
end;

{ TArquivosConf }

procedure TArquivosConf.Assign(DeArquivosConf: TArquivosConf);
begin
  PathSalvar := DeArquivosConf.PathSalvar;
  Salvar := DeArquivosConf.Salvar;
  AdicionarLiteral := DeArquivosConf.AdicionarLiteral;
  SepararPorCNPJ := DeArquivosConf.SepararPorCNPJ;
  SepararPorMes := DeArquivosConf.SepararPorMes;
end;

constructor TArquivosConf.Create(AConfiguracoes: TConfiguracoes);
begin
  inherited Create(AConfiguracoes);

  fpConfiguracoes := AConfiguracoes;
  FSalvar := True;
  FPathSalvar := '';
  FSepararPorMes := False;
  FAdicionarLiteral := False;
  FSepararPorCNPJ := False;
end;

destructor TArquivosConf.Destroy;
begin

  inherited;
end;

function TArquivosConf.GetPathSalvar: String;
begin
  if FPathSalvar = '' then
    FPathSalvar := ExtractFilePath(Application.ExeName);

  FPathSalvar := PathWithDelim(Trim(FPathSalvar));
  Result := FPathSalvar;
end;

function TArquivosConf.GetPath(const APath, ALiteral, CNPJ: String;
  Data: TDateTime): String;
var
  wDia, wMes, wAno: word;
  Dir, AnoMes, UmCNPJ: String;
  LenLiteral: integer;
begin
  if APath = '' then
    Dir := PathSalvar
  else
    Dir := APath;

  if SepararPorCNPJ then
  begin
    UmCNPJ := CNPJ;
    if UmCNPJ = '' then
      UmCNPJ := TConfiguracoes(Self.Owner).Geral.Empresa.NumeroInscricao;

    if UmCNPJ <> '' then
      Dir := PathWithDelim(Dir) + UmCNPJ;
  end;

  if SepararPorMes then
  begin
    if Data = 0 then
      Data := Now;

    DecodeDate(Data, wAno, wMes, wDia);
    AnoMes := IntToStr(wAno) + IntToStrZero(wMes, 2);

    if Pos(AnoMes, Dir) <= 0 then
      Dir := PathWithDelim(Dir) + AnoMes;
  end;

  LenLiteral := Length(ALiteral);
  if AdicionarLiteral and (LenLiteral > 0) then
  begin
    if RightStr(Dir, LenLiteral) <> ALiteral then
      Dir := PathWithDelim(Dir) + ALiteral;
  end;

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  Result := Dir;
end;

{ TEmpresaConfNFSe }

procedure TEmpresaConfNFSe.Assign(Source: TPersistent);
begin
  if Source is TEmpresaConfNFSe then
  begin
    FTipoInscricao := TEmpresaConfNFSe(Source).TipoInscricao;
    FNumeroInscricao := TEmpresaConfNFSe(Source).NumeroInscricao;
    FConvenio := TEmpresaConfNFSe(Source).Convenio;
    FNome := TEmpresaConfNFSe(Source).Nome;

    FConta.Assign(TEmpresaConfNFSe(Source).Conta);
    FEndereco.Assign(TEmpresaConfNFSe(Source).Endereco);
  end
  else
    inherited Assign(Source);
end;

constructor TEmpresaConfNFSe.Create;
begin
  inherited Create;

  FTipoInscricao := tiIsento;
  FNumeroInscricao := '';
  FConvenio := '';
  FNome := '';

  FConta := TDadosConta.Create;
  FEndereco := TDadosEndereco.Create;
end;

destructor TEmpresaConfNFSe.Destroy;
begin
  FConta.Free;
  FEndereco.Free;

  inherited;
end;

{ TDadosConta }

procedure TDadosConta.Assign(Source: TPersistent);
begin
  if Source is TDadosConta then
  begin
    FAgenciaCodigo := TDadosConta(Source).AgenciaCodigo;
    FAgenciaDV := TDadosConta(Source).AgenciaDV;
    FContaNumero := TDadosConta(Source).ContaNumero;
    FContaDV := TDadosConta(Source).ContaDV;
    FDV := TDadosConta(Source).DV;
    FTipoConta := TDadosConta(Source).TipoConta;
  end
  else
    inherited Assign(Source);
end;

constructor TDadosConta.Create;
begin
  inherited Create;

  FAgenciaCodigo := 0;
  FAgenciaDV := '';
  FContaNumero := 0;
  FContaDV := '';
  FDV := '';
  FTipoConta := 0;
end;

{ TDadosEndereco }

procedure TDadosEndereco.Assign(Source: TPersistent);
begin
  if Source is TDadosEndereco then
  begin
    FLogradouro := TDadosEndereco(Source).Logradouro;
    FNumero := TDadosEndereco(Source).Numero;
    FComplemento := TDadosEndereco(Source).Complemento;
    FCidade := TDadosEndereco(Source).Cidade;
    FCEP := TDadosEndereco(Source).CEP;
    FEstado := TDadosEndereco(Source).Estado;
  end
  else
    inherited Assign(Source);
end;

constructor TDadosEndereco.Create;
begin
  inherited Create;

  FLogradouro := '';
  FNumero := '';
  FComplemento :='';
  FCidade := '';
  FCEP := 0;
  FEstado := '';
end;

end.
