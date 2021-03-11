{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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
  Classes, Forms, SysUtils, ACBrPagForConversao, ACBrUtil;

type
  TGeralConf = class(TComponent)
  private
    FBanco: TBanco;
    FCodigoBanco: String;
    FSubstitutaBanco: TBanco;
    FCodigoSubstBanco: String;
    FCNPJ: String;
    FVersaoLayout: TVersaoLayout;

    procedure SetBanco(const Value: TBanco);
    procedure SetSubstitutaBanco(const Value: TBanco);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Banco: TBanco read FBanco write SetBanco default pagNenhum;
    property CodigoBanco: String read FCodigoBanco;
    property SubstitutaBanco: TBanco read FSubstitutaBanco write SetSubstitutaBanco default pagNenhum;
    property CodigoSubstBanco: String read FCodigoSubstBanco;
    property CNPJ: String read FCNPJ write FCNPJ;
    property VersaoLayout: TVersaoLayout read FVersaoLayout write FVersaoLayout default ve084;
  end;

  TArquivosConf = class(TComponent)
  private
    FSalvar: Boolean;
    FSepararCNPJ: Boolean;
    FSepararPorMes: Boolean;
    FAdicionarLiteral: Boolean;
    FPathSalvar: String;

    function GetPathSalvar: String;
  public
    constructor Create(AOwner: TComponent); override;
    function GetPath(const APath, ALiteral, CNPJ: String; Data: TDateTime): String; virtual;
  published
    property PathSalvar: String read GetPathSalvar write FPathSalvar;
    property Salvar: Boolean read FSalvar write FSalvar default False;
    property AdicionarLiteral: Boolean read FAdicionarLiteral write FAdicionarLiteral default False;
    property SepararPorCNPJ: Boolean read FSepararCNPJ write FSepararCNPJ default False;
    property SepararPorMes: Boolean read FSepararPorMes write FSepararPorMes default False;
  end;

  TConfiguracoes = class(TComponent)
  private
    FGeral: TGeralConf;
    FArquivos: TArquivosConf;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Limpar;
  published
    property Geral: TGeralConf read FGeral;
    property Arquivos: TArquivosConf read FArquivos;
  end;

implementation

uses
  ACBrPagFor, Math, StrUtils, DateUtils;

{ TConfiguracoes }

constructor TConfiguracoes.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  FGeral       := TGeralConf.Create(Self);
  FGeral.Name  := 'GeralConf';
  {$IFDEF COMPILER6_UP}
   FGeral.SetSubComponent( true );{ para gravar no DFM/XFM }
  {$ENDIF}

  FArquivos := TArquivosConf.Create(self);
  FArquivos.Name  := 'ArquivosConf';
  {$IFDEF COMPILER6_UP}
   FArquivos.SetSubComponent( true );{ para gravar no DFM/XFM }
  {$ENDIF}
end;

destructor TConfiguracoes.Destroy;
begin
  FGeral.Free;
  FArquivos.Free;

  inherited;
end;

procedure TConfiguracoes.Limpar;
begin
  FGeral.FBanco := pagNenhum;
  FGeral.FSubstitutaBanco := pagNenhum;
  FGeral.FCNPJ := EmptyStr;
  FGeral.FVersaoLayout := ve084;
  FArquivos.FSalvar := False;
  FArquivos.FSepararCNPJ := False;
  FArquivos.FSepararPorMes := False;
  FArquivos.FAdicionarLiteral := False;
  FArquivos.FPathSalvar := EmptyStr;
end;

{ TGeralConf }

constructor TGeralConf.Create(AOwner: TComponent);
begin
  Inherited Create( AOwner );

  FBanco := pagNenhum;
  FCodigoBanco := '000';
  FSubstitutaBanco := pagNenhum;
  FCodigoSubstBanco := '000';
end;

procedure TGeralConf.SetBanco(const Value: TBanco);
begin
  FBanco := Value;
  FCodigoBanco := BancoToStr(FBanco);
end;

procedure TGeralConf.SetSubstitutaBanco(const Value: TBanco);
begin
  FSubstitutaBanco := Value;
  FCodigoSubstBanco := BancoToStr(FSubstitutaBanco);
end;

{ TArquivosConf }

constructor TArquivosConf.Create(AOwner: TComponent);
begin
  inherited;
//  FPathSalvar := '';
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
      UmCNPJ := TConfiguracoes(Self.Owner).Geral.CNPJ;

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

end.
