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

unit ACBrPagForArquivo;

interface

uses
  Classes, Sysutils, Dialogs, Forms, Contnrs,
  ACBrPagForClass, ACBrPagForGravarTxt, ACBrPagForLerTxt,
  ACBrPagForConversao, ACBrPagForConfiguracoes;

type
  TRegistro = class(TObject)
  private
    FPagFor: TPagFor;
    FPagForTXT: String;
    FNomeArq: String;

    function GetPagForTXT: String;
    function CarregarArquivo(const ACaminhoArquivo: String): String;
  public
    constructor Create;
    destructor Destroy; override;

    function Gravar(const CaminhoArquivo: String = ''): boolean;
    function Ler(const AArquivoTXT: String; ACarregarArquivo: Boolean): boolean;

    property PagFor: TPagFor read FPagFor write FPagFor;
    property PagForTXT: String read GetPagForTXT write FPagForTXT;
    property NomeArq: String read FNomeArq write FNomeArq;
  end;

  TArquivos = class(TObjectList)
  private
    FConfiguracoes: TConfiguracoes;
    FACBrPagFor: TComponent;

    function GetItem(Index: Integer): TRegistro;
    procedure SetItem(Index: Integer; const Value: TRegistro);
  public
    constructor Create(AACBrPagFor: TPersistent);

    function New: TRegistro;
    function Last: TRegistro;

    function GerarPagFor(const ANomeArquivo: String = ''): Boolean;
    function GetNamePath: string;
    function Gravar(const PathArquivo: string = ''): boolean;
    procedure Ler(const AArquivoTXT: String; ACarregarArquivo: Boolean);

    property Items[Index: Integer]: TRegistro read GetItem  write SetItem;
    property Configuracoes: TConfiguracoes read FConfiguracoes  write FConfiguracoes;
    property ACBrPagFor: TComponent read FACBrPagFor;
  end;

implementation

uses
  ACBrPagFor;

{ TRegistro }

function TRegistro.CarregarArquivo(const ACaminhoArquivo: String): String;
var
  mArquivoTXT : TStringList;
begin
  if (Trim(ACaminhoArquivo) = EmptyStr) or (not FileExists(ACaminhoArquivo)) then
    raise EACBrPagForException.Create('ERRO: Arquivo n�o localizado.');

  mArquivoTXT := TStringList.Create;

  try
    FNomeArq := ExtractFileName(ACaminhoArquivo);
    mArquivoTXT.LoadFromFile(ACaminhoArquivo);
    Result := mArquivoTXT.Text;
  finally
    mArquivoTXT.Free;
  end;
end;

constructor TRegistro.Create;
begin
  inherited Create;

  FPagFor := TPagFor.Create;
end;

destructor TRegistro.Destroy;
begin
  FPagFor.Free;

  inherited;
end;

function TRegistro.GetPagForTXT: String;
var
  APagForW: TPagForW;
begin
  APagForW := TPagForW.Create(Self.PagFor);

  try
    Result := APagForW.GerarTXT;
  finally
    APagForW.Free;
  end;
end;

function TRegistro.Gravar(const CaminhoArquivo: String): boolean;
var
  ArquivoGerado: TStringList;
  APagForW: TPagForW;
  LocPagForTxt: String;
begin
  APagForW := TPagForW.Create(PagFor);

  try
    LocPagForTxt := APagForW.GerarTXT;
    ArquivoGerado := TStringList.Create;
    try
      ArquivoGerado.Add(LocPagForTxt);
      ArquivoGerado.SaveToFile(CaminhoArquivo);
      Result := True;
    finally
      ArquivoGerado.Free;
    end;
  finally
    APagForW.Free;
  end;
end;

function TRegistro.Ler(const AArquivoTXT: String; ACarregarArquivo: Boolean): boolean;
var
  APagForR : TPagForR;
begin
  APagForR := TPagForR.Create( FPagFor );

  try
    if ACarregarArquivo then
      Result := APagForR.LerTXT( CarregarArquivo(AArquivoTXT) )
    else
      Result := APagForR.LerTXT( AArquivoTXT );
  finally
    APagForR.Free;
  end;
end;

{ TArquivos }

function TArquivos.New: TRegistro;
begin
  Result := TRegistro.Create;
  Add(Result);
end;

constructor TArquivos.Create(AACBrPagFor: TPersistent);
begin
  if not (AACBrPagFor is TACBrPagFor ) then
    raise EACBrPagForException.Create( 'AACBrPagFor deve ser do tipo TACBrPagFor');

  inherited Create;

  FACBrPagFor := TACBrPagFor( AACBrPagFor );
end;

function TArquivos.GerarPagFor(const ANomeArquivo: String): Boolean;
var
  i: Integer;
begin
  for i:= 0 to Self.Count-1 do
    TACBrPagFor( FACBrPagFor ).Arquivos.Items[i].Gravar(ANomeArquivo);

  Result := True;
end;

function TArquivos.GetItem(Index: Integer): TRegistro;
begin
  Result := TRegistro(inherited GetItem(Index));
end;

function TArquivos.Last: TRegistro;
begin
  Result := TRegistro(inherited Last);
end;

function TArquivos.GetNamePath: string;
begin
  Result := 'TRegistro';
end;

function TArquivos.Gravar(const PathArquivo: string): boolean;
var
  i: Integer;
  CaminhoArquivo: String;
begin
  Result := True;

  try
    for i:= 0 to TACBrPagFor( FACBrPagFor ).Arquivos.Count-1 do
    begin
      CaminhoArquivo := PathArquivo;
      TACBrPagFor( FACBrPagFor ).Arquivos.Items[i].Gravar(CaminhoArquivo);
    end;
  except
    Result := False;
  end;
end;

procedure TArquivos.Ler(const AArquivoTXT: String; ACarregarArquivo: Boolean);
begin
  TACBrPagFor(FACBrPagFor).Arquivos.New;
  TACBrPagFor(FACBrPagFor).Arquivos.Last.Ler(AArquivoTXT, ACarregarArquivo);
end;

procedure TArquivos.SetItem(Index: Integer; const Value: TRegistro);
begin
  inherited SetItem(Index, Value);
end;

end.
