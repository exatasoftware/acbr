{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Gabriel Baltazar                               }
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

unit ACBrOpenDeliverySchema;

interface

uses
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrBase,
  ACBrJSON,
  pcnConversaoOD,
  Classes,
  SysUtils,
  TypInfo;

resourcestring
  sErroMetodoNaoImplementado = 'M�todo %s n�o implementado para Classe %s';

type
  TACBrJSONObject = ACBrJSON.TACBrJSONObject;
  TACBrJSONArray = ACBrJSON.TACBrJSONArray;

  EACBrOpenDeliveryException = class(EACBrException);

  TACBrOpenDeliverySchema = class
  private
    function GetAsJSON: String;
    procedure SetAsJSON(const AValue: String);

    function GetJSONContext(AJson: TACBrJSONObject): TACBrJSONObject;
  protected
    FObjectName: String;

    procedure DoWriteToJSon(AJson: TACBrJSONObject); virtual;
    procedure DoReadFromJSon(AJson: TACBrJSONObject); virtual;

  public
    constructor Create(const AObjectName: string = ''); virtual;
    procedure Clear; virtual;
    function IsEmpty: Boolean; virtual;
    procedure WriteToJSon(AJson: TACBrJSONObject);
    procedure ReadFromJSon(AJson: TACBrJSONObject);

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

  TACBrOpenDeliverySchemaArray = class(TACBrObjectList)
  private
    function GetAsJSON: String;
    procedure SetAsJSON(const AValue: String);
  protected
    FArrayName: String;

    function NewSchema: TACBrOpenDeliverySchema; virtual;
  public
    constructor Create(const AArrayName: String);
    procedure Clear; override;
    function IsEmpty: Boolean; virtual;

    function ToJSonArray: TACBrJSONArray;

    procedure WriteToJSon(AJSon: TACBrJSONObject); virtual;
    procedure ReadFromJSon(AJSon: TACBrJSONObject); virtual;

    property AsJSON: String read GetAsJSON write SetAsJSON;
  end;

implementation

{ TACBrOpenDeliverySchema }

procedure TACBrOpenDeliverySchema.Clear;
begin

end;

constructor TACBrOpenDeliverySchema.Create(const AObjectName: string);
begin
  inherited Create;
  FObjectName := AObjectName;
end;

procedure TACBrOpenDeliverySchema.DoReadFromJSon(AJson: TACBrJSONObject);
begin

end;

procedure TACBrOpenDeliverySchema.DoWriteToJSon(AJson: TACBrJSONObject);
begin

end;

function TACBrOpenDeliverySchema.GetAsJSON: String;
var
  LJSON: TACBrJSONObject;
begin
  LJSON := TACBrJSONObject.Create;
  try
    WriteToJSon(LJSON);
    LJSON.OwnerJSON := True;
    Result := LJSON.ToJSON;
  finally
    LJSON.Free;
  end;
end;

function TACBrOpenDeliverySchema.GetJSONContext(AJson: TACBrJSONObject): TACBrJSONObject;
begin
  Result := AJson;
  if (FObjectName <> '') then
    Result := AJSon.AsJSONObject[FObjectName]
end;

function TACBrOpenDeliverySchema.IsEmpty: Boolean;
begin
  Result := False;
end;

procedure TACBrOpenDeliverySchema.ReadFromJSon(AJson: TACBrJSONObject);
var
  LJSON: TACBrJSONObject;
begin
  Clear;
  LJSON := GetJSONContext(AJson);
  if Assigned(LJSON) then
    DoReadFromJSon(LJSON);
end;

procedure TACBrOpenDeliverySchema.SetAsJSON(const AValue: String);
var
  LJSON: TACBrJSONObject;
begin
  Clear;
  LJSON := TACBrJSONObject.Parse(AValue);
  try
    ReadFromJSon(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TACBrOpenDeliverySchema.WriteToJSon(AJson: TACBrJSONObject);
var
  LJSON: TACBrJSONObject;
begin
  LJSON := GetJSONContext(AJson);
  if not Assigned(LJSON) then
  begin
    AJson.AddPair(FObjectName, TACBrJSONObject.Create);
    LJSON := GetJSONContext(AJson);
  end;
  if Assigned(LJSON) then
    DoWriteToJSon(LJSON);
end;

{ TACBrOpenDeliverySchemaArray }

procedure TACBrOpenDeliverySchemaArray.Clear;
begin
  inherited Clear;
end;

constructor TACBrOpenDeliverySchemaArray.Create(const AArrayName: String);
begin
  inherited Create(True);
  FArrayName := AArrayName;
end;

function TACBrOpenDeliverySchemaArray.GetAsJSON: String;
var
  LJSON: TACBrJSONArray;
begin
  LJSON := Self.ToJSonArray;
  try
    Result := LJSON.ToJSON;
  finally
    LJSON.Free;
  end;
end;

function TACBrOpenDeliverySchemaArray.IsEmpty: Boolean;
begin
  Result := (Count < 1);
end;

function TACBrOpenDeliverySchemaArray.NewSchema: TACBrOpenDeliverySchema;
begin
  {$IfDef FPC}Result := Nil;{$EndIf}
  raise EACBrOpenDeliveryException
    .CreateFmt(ACBrStr(sErroMetodoNaoImplementado), ['NewSchema', ClassName]);
end;

procedure TACBrOpenDeliverySchemaArray.ReadFromJSon(AJSon: TACBrJSONObject);
var
  LJSonArray: TACBrJSONArray;
  LJSON: TACBrJSONObject;
  I: Integer;
begin
  Clear;
  LJSonArray := AJSon.AsJSONArray[FArrayName];
  if Assigned(LJSonArray) then
    for I := 0 to Pred(LJSonArray.Count) do
    begin
      LJSON := LJSonArray.ItemAsJSONObject[I];
      NewSchema.DoReadFromJSon(LJSON);
    end;
end;

procedure TACBrOpenDeliverySchemaArray.SetAsJSON(const AValue: String);
var
  LJSON: TACBrJSONArray;
  I: Integer;
begin
  Clear;
  LJSON := TACBrJSONArray.Parse(AValue);
  try
    for I := 0 to Pred(LJSON.Count) do
      NewSchema.DoReadFromJSon(LJSON.ItemAsJSONObject[I]);
  finally
    LJSON.Free;
  end;
end;

function TACBrOpenDeliverySchemaArray.ToJSonArray: TACBrJSONArray;
var
  I: Integer;
begin
  Result := TACBrJSONArray.Create;
  try
    for I := 0 to Pred(Count) do
      Result.AddElementJSONString(TACBrOpenDeliverySchema(Items[I]).AsJSON);
  except
    Result.Free;
    raise;
  end;
end;

procedure TACBrOpenDeliverySchemaArray.WriteToJSon(AJSon: TACBrJSONObject);
var
  LJSonArray: TACBrJSONArray;
  I: Integer;
begin
  if IsEmpty then
    Exit;

  LJSonArray := TACBrJSONArray.Create;
  try
    for I := 0 to Pred(Count) do
      LJSonArray.AddElementJSONString(TACBrOpenDeliverySchema(Items[I]).AsJSON);

    AJSon.AddPair(FArrayName, LJSonArray);
  except
    LJSonArray.Free;
    raise;
  end;
end;

end.
