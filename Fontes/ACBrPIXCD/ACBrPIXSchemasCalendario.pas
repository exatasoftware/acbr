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

unit ACBrPIXSchemasCalendario;

interface

uses
  Classes, SysUtils,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrPIXBase;

const
  cCobExpiracaoDefault = 86400;

type

  { TACBrPIXCalendarioBase }

  TACBrPIXCalendarioBase = class(TACBrPIXSchema)
  private
    fapresentacao: TDateTime;
    fcriacao: TDateTime;
    fexpiracao: Integer;
  protected
    property criacao: TDateTime read fcriacao write fcriacao;
    property apresentacao: TDateTime read fapresentacao write fapresentacao;
    property expiracao: Integer read fexpiracao write fexpiracao;
  public
    constructor Create;
    procedure Clear; override;
    procedure Assign(Source: TACBrPIXCalendarioBase);

    procedure WriteToJSon(AJSon: TJsonObject); override;
    procedure ReadFromJSon(AJSon: TJsonObject); override;
  end;

  { TACBrPIXCalendarioCobSolicitada }

  TACBrPIXCalendarioCobSolicitada = class(TACBrPIXCalendarioBase)
  public
    procedure Clear; override;
    property expiracao;
  end;

  { TACBrPIXCalendarioCobGerada }

  TACBrPIXCalendarioCobGerada = class(TACBrPIXCalendarioBase)
  public
    property criacao;
    property expiracao;
  end;

implementation

uses
  ACBrUtil;

{ TACBrPIXCalendarioBase }

constructor TACBrPIXCalendarioBase.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrPIXCalendarioBase.Clear;
begin
  fcriacao := 0;
  fapresentacao := 0;
  fexpiracao := 0;
end;

procedure TACBrPIXCalendarioBase.Assign(Source: TACBrPIXCalendarioBase);
begin
  fcriacao := Source.criacao;
  fapresentacao := Source.apresentacao;
  fexpiracao := Source.expiracao;
end;

procedure TACBrPIXCalendarioBase.WriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (criacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(criacao);
   if (apresentacao <> 0) then
     AJSon.S['apresentacao'] := DateTimeToIso8601(apresentacao);
   if (expiracao > 0) then
     AJSon.I['expiracao'] := expiracao;
  {$Else}
   if (criacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(criacao);
   if (apresentacao <> 0) then
     AJSon['apresentacao'].AsString := DateTimeToIso8601(apresentacao);
   if (expiracao > 0) then
     AJSon['expiracao'].AsInteger := expiracao;
  {$EndIf}
end;

procedure TACBrPIXCalendarioBase.ReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   s := AJSon.S['criacao'];
   if (s <> '') then
     criacao := Iso8601ToDateTime(s);
   s := AJSon.S['apresentacao'];
   if (s <> '') then
     apresentacao := Iso8601ToDateTime(s);
   expiracao := AJSon.I['expiracao'];
  {$Else}
   s := AJSon['criacao'].AsString;
   if (s <> '') then
     criacao := Iso8601ToDateTime(s);
   s := AJSon['apresentacao'].AsString;
   if (s <> '') then
     apresentacao := Iso8601ToDateTime(s);
   expiracao := AJSon['expiracao'].AsInteger;
  {$EndIf}
end;

{ TACBrPIXCalendarioCobSolicitada }

procedure TACBrPIXCalendarioCobSolicitada.Clear;
begin
  inherited Clear;
  expiracao := cCobExpiracaoDefault;
end;

end.

