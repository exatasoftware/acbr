{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

unit ACBrPIXSchemasLocation;

interface

uses
  Classes, SysUtils,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrPIXBase;

type

  { TACBrPIXLocationBase }

  TACBrPIXLocationBase = class(TACBrPIXSchema)
  private
    fcriacao: TDateTime;
    fid: Integer;
    flocation: String;
    ftipoCob: TACBrPIXTipoCobranca;
    ftxId: String;
    procedure SetTxId(AValue: String);
  protected
    property id: Integer read fid write fid;
    property txId: String read ftxId write SetTxId;
    property location: String read flocation;
    property criacao: TDateTime read fcriacao;

    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXLocationBase);

    property tipoCob: TACBrPIXTipoCobranca read ftipoCob write ftipoCob;
  end;

  { TACBrPIXLocationCobSolicitada }

  TACBrPIXLocationCobSolicitada = class(TACBrPIXLocationBase)
  public
    property id;
  end;

  { TACBrPIXLocation }

  TACBrPIXLocation = class(TACBrPIXLocationBase)
  public
    property id;
    property location;
    property criacao;
  end;

  { TACBrPIXLocationCompleta }

  TACBrPIXLocationCompleta = class(TACBrPIXLocationBase)
  public
    property id;
    property txId;
    property location;
    property criacao;
  end;

implementation

uses
  ACBrUtil, ACBrPIXUtil;

{ TACBrPIXLocationBase }

constructor TACBrPIXLocationBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXLocationBase.Clear;
begin
  fcriacao := 0;
  fid := 0;
  flocation := '';
  ftipoCob := tcoNenhuma;
  ftxId := '';
end;

function TACBrPIXLocationBase.IsEmpty: Boolean;
begin
  Result := (fcriacao = 0) and
            (fid = 0) and
            (flocation = '') and
            (ftipoCob = tcoNenhuma) and
            (ftxId = '');
end;

procedure TACBrPIXLocationBase.Assign(Source: TACBrPIXLocationBase);
begin
  fcriacao := Source.criacao;
  fid := Source.id;
  flocation := Source.location;
  ftipoCob := Source.tipoCob;
  ftxId := Source.txId;
end;

procedure TACBrPIXLocationBase.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fid <> 0) then
     AJSon.I['id'] := fid;
   if (ftxId <> '') then
     AJSon.S['txid'] := ftxId;
   if (flocation <> '') then
     AJSon.S['location'] := flocation;
   if (ftipoCob <> tcoNenhuma) then
     AJSon.S['tipoCob'] := PIXTipoCobrancaToString(ftipoCob);
   if (fcriacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(fcriacao);
  {$Else}
   if (fid <> 0) then
     AJSon['id'].AsInteger := fid;
   if (ftxId <> '') then
     AJSon['txid'].AsString := ftxId;
   if (flocation <> '') then
     AJSon['location'].AsString := flocation;
   if (ftipoCob <> tcoNenhuma) then
     AJSon['tipoCob'].AsString := PIXTipoCobrancaToString(ftipoCob);
   if (fcriacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(fcriacao);
  {$EndIf}
end;

procedure TACBrPIXLocationBase.DoReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   fid := AJSon.I['id'];
   ftxId := AJSon.S['txid'];
   flocation := AJSon.S['location'];
   ftipoCob := StringToPIXTipoCobranca(AJSon.S['tipoCob']);
   s := AJSon.S['criacao'];
   if (s <> '') then
     fcriacao := Iso8601ToDateTime(s);
  {$Else}
   fid := AJSon['id'].AsInteger;
   ftxId := AJSon['txid'].AsString;
   flocation := AJSon['location'].AsString;
   ftipoCob := StringToPIXTipoCobranca(AJSon['tipoCob'].AsString);
   s := AJSon['criacao'].AsString;
   if (s <> '') then
     fcriacao := Iso8601ToDateTime(s);
  {$EndIf}
end;

procedure TACBrPIXLocationBase.SetTxId(AValue: String);
var
  s, e: String;
begin
  if ftxid = AValue then
    Exit;

  s := Trim(AValue);
  if (s <> '') then
  begin
    e := ValidarTxId(s, 35, 26);
    if (e <> '') then
      raise EACBrPixException.Create(ACBrStr(e));
  end;

  fTxId := s;
end;

end.

