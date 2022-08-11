{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXSchemasProblema;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrBase, ACBrPIXBase;

type

  { TACBrPIXViolacao }

  TACBrPIXViolacao = class(TACBrPIXSchema)
  private
    fpropriedade: String;
    frazao: String;
    fvalor: String;
  protected
    procedure AssignSchema(ASource: TACBrPIXSchema); override;
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXViolacao);

    property razao: String read frazao write frazao;
    property propriedade: String read fpropriedade write fpropriedade;
    property valor: String read fvalor write fvalor;
  end;

  { TACBrPIXViolacoes }

  TACBrPIXViolacoes = class(TACBrPIXSchemaArray)
  private
    function GetItem(Index: Integer): TACBrPIXViolacao;
    procedure SetItem(Index: Integer; Value: TACBrPIXViolacao);
  protected
    function NewSchema: TACBrPIXSchema; override;
  public
    Function Add(AViolacao: TACBrPIXViolacao): Integer;
    Procedure Insert(Index: Integer; AViolacao: TACBrPIXViolacao);
    function New: TACBrPIXViolacao;
    property Items[Index: Integer]: TACBrPIXViolacao read GetItem write SetItem; default;
  end;

  { TACBrPIXProblema }

  TACBrPIXProblema = class(TACBrPIXSchema)
  private
    fcorrelationId: String;
    fdetail: String;
    fstatus: Integer;
    ftitle: String;
    ftype_uri: String;
    fviolacoes: TACBrPIXViolacoes;
  protected
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String = ''); override;
    destructor Destroy; override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXProblema);

    property type_uri: String read ftype_uri write ftype_uri;
    property title: String read ftitle write ftitle;
    property status: Integer read fstatus write fstatus;
    property detail: String read fdetail write fdetail;
    property correlationId: String read fcorrelationId write fcorrelationId;
    property violacoes: TACBrPIXViolacoes read fviolacoes;
  end;

implementation

{ TACBrPIXViolacao }

constructor TACBrPIXViolacao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXViolacao.Clear;
begin
  fpropriedade := '';
  frazao := '';
  fvalor := '';
end;

function TACBrPIXViolacao.IsEmpty: Boolean;
begin
  Result := (fpropriedade = '') and (frazao = '') and (fvalor = '');
end;

procedure TACBrPIXViolacao.AssignSchema(ASource: TACBrPIXSchema);
begin
  if (ASource is TACBrPIXViolacao) then
    Assign(TACBrPIXViolacao(ASource));
end;

procedure TACBrPIXViolacao.Assign(Source: TACBrPIXViolacao);
begin
  fpropriedade := Source.propriedade;
  frazao := Source.razao;
  fvalor := Source.valor;
end;

procedure TACBrPIXViolacao.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  AJSon
    .AddPair('razao', frazao, False)
    .AddPair('propriedade', fpropriedade, False)
    .AddPair('valor', fvalor, False);
end;

procedure TACBrPIXViolacao.DoReadFromJSon(AJSon: TACBrJSONObject);
begin
  AJSon
    .Value('razao', frazao)
    .Value('propriedade', fpropriedade)
    .Value('valor', fvalor);
end;

{ TACBrPIXViolacoes }

function TACBrPIXViolacoes.GetItem(Index: Integer): TACBrPIXViolacao;
begin
  Result := TACBrPIXViolacao(inherited Items[Index]);
end;

procedure TACBrPIXViolacoes.SetItem(Index: Integer; Value: TACBrPIXViolacao);
begin
  inherited Items[Index] := Value;
end;

function TACBrPIXViolacoes.NewSchema: TACBrPIXSchema;
begin
  Result := New;
end;

function TACBrPIXViolacoes.Add(AViolacao: TACBrPIXViolacao): Integer;
begin
  Result := inherited Add(AViolacao);
end;

procedure TACBrPIXViolacoes.Insert(Index: Integer; AViolacao: TACBrPIXViolacao);
begin
  inherited Insert(Index, AViolacao);
end;

function TACBrPIXViolacoes.New: TACBrPIXViolacao;
begin
  Result := TACBrPIXViolacao.Create('');
  Self.Add(Result);
end;

{ TACBrPIXProblema }

constructor TACBrPIXProblema.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  fviolacoes := TACBrPIXViolacoes.Create('violacoes');
  Clear;
end;

destructor TACBrPIXProblema.Destroy;
begin
  fviolacoes.Free;
  inherited Destroy;
end;

procedure TACBrPIXProblema.Clear;
begin
  fcorrelationId := '';
  fdetail := '';
  fstatus := 0;
  ftitle := '';
  ftype_uri := '';
  fviolacoes.Clear;
end;

function TACBrPIXProblema.IsEmpty: Boolean;
begin
  Result := (fcorrelationId = '') and
            (fdetail = '') and
            (fstatus = 0) and
            (ftitle = '') and
            (ftype_uri = '') and
            fviolacoes.IsEmpty;
end;

procedure TACBrPIXProblema.Assign(Source: TACBrPIXProblema);
begin
  fcorrelationId := Source.correlationId;
  fdetail := Source.detail;
  fstatus := Source.status;
  ftitle := Source.title;
  ftype_uri := Source.type_uri;
  fviolacoes.Assign(Source.violacoes);
end;

procedure TACBrPIXProblema.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  AJSon
    .AddPair('type', ftype_uri)
    .AddPair('title', ftitle)
    .AddPair('status', fstatus)
    .AddPair('detail', fdetail, False)
    .AddPair('correlationId', fcorrelationId, False);
  fviolacoes.WriteToJSon(AJSon);
end;

procedure TACBrPIXProblema.DoReadFromJSon(AJSon: TACBrJSONObject);
begin
  AJSon
    .Value('type', ftype_uri)
    .Value('title', ftitle)
    .Value('status', fstatus)
    .Value('detail', fdetail)
    .Value('correlationId', fcorrelationId);
  fviolacoes.ReadFromJSon(AJSon);
end;

end.

