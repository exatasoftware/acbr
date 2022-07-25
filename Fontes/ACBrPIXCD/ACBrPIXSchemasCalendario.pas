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

type

  { TACBrPIXCalendarioCobBase }

  TACBrPIXCalendarioCobBase = class(TACBrPIXSchema)
  private
    fapresentacao: TDateTime;
    fapresentacao_Bias: Integer;
    fcriacao: TDateTime;
    fcriacao_Bias: Integer;
    fexpiracao: Integer;
  protected
    property criacao: TDateTime read fcriacao write fcriacao;
    property criacao_Bias: Integer read fcriacao_Bias write fcriacao_Bias;
    property apresentacao: TDateTime read fapresentacao write fapresentacao;
    property apresentacao_Bias: Integer read fapresentacao_Bias write fapresentacao_Bias;
    property expiracao: Integer read fexpiracao write fexpiracao;

    procedure DoWriteToJSon(AJSon: TJsonObject); override;
    procedure DoReadFromJSon(AJSon: TJsonObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXCalendarioCobBase);
  end;

  { TACBrPIXCalendarioCobSolicitada }

  TACBrPIXCalendarioCobSolicitada = class(TACBrPIXCalendarioCobBase)
  public
    property expiracao;
  end;

  { TACBrPIXCalendarioCobGerada }

  TACBrPIXCalendarioCobGerada = class(TACBrPIXCalendarioCobBase)
  public
    property criacao;
    property criacao_Bias;
    property expiracao;
  end;

implementation

uses
  ACBrUtil.DateTime;

{ TACBrPIXCalendarioCobBase }

constructor TACBrPIXCalendarioCobBase.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXCalendarioCobBase.Clear;
begin
  fapresentacao := 0;
  fapresentacao_Bias := 0;
  fcriacao := 0;
  fcriacao_Bias := 0;
  fexpiracao := 0;
end;

function TACBrPIXCalendarioCobBase.IsEmpty: Boolean;
begin
  Result := (fcriacao = 0) and (fcriacao_Bias = 0) and (fapresentacao = 0) and
            (fapresentacao_Bias = 0) and (fexpiracao = 0);
end;

procedure TACBrPIXCalendarioCobBase.Assign(Source: TACBrPIXCalendarioCobBase);
begin
  fcriacao := Source.criacao;
  fcriacao_Bias := Source.criacao_Bias;
  fapresentacao := Source.apresentacao;
  fapresentacao_Bias := Source.apresentacao_Bias;
  fexpiracao := Source.expiracao;
end;

procedure TACBrPIXCalendarioCobBase.DoWriteToJSon(AJSon: TJsonObject);
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   if (fcriacao <> 0) then
     AJSon.S['criacao'] := DateTimeToIso8601(fcriacao, BiasToTimeZone(fcriacao_Bias));
   if (fapresentacao <> 0) then
     AJSon.S['apresentacao'] := DateTimeToIso8601(fapresentacao, BiasToTimeZone(fapresentacao_Bias));
   if (fexpiracao > 0) then
     AJSon.I['expiracao'] := fexpiracao;
  {$Else}
   if (fcriacao <> 0) then
     AJSon['criacao'].AsString := DateTimeToIso8601(fcriacao, BiasToTimeZone(fcriacao_Bias));
   if (fapresentacao <> 0) then
     AJSon['apresentacao'].AsString := DateTimeToIso8601(fapresentacao, BiasToTimeZone(fapresentacao_Bias));
   if (fexpiracao > 0) then
     AJSon['expiracao'].AsInteger := fexpiracao;
  {$EndIf}
end;

procedure TACBrPIXCalendarioCobBase.DoReadFromJSon(AJSon: TJsonObject);
var
  s: String;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   s := AJSon.S['criacao'];
   if (s <> '') then
   begin
     fcriacao := Iso8601ToDateTime(s);
     fcriacao_Bias := TimeZoneToBias(s);
   end;
   s := AJSon.S['apresentacao'];
   if (s <> '') then
   begin
     fapresentacao := Iso8601ToDateTime(s);
     fapresentacao_Bias := TimeZoneToBias(s);
   end;
   fexpiracao := AJSon.I['expiracao'];
  {$Else}
   s := AJSon['criacao'].AsString;
   if (s <> '') then
   begin
     fcriacao := Iso8601ToDateTime(s);
     fcriacao_Bias := TimeZoneToBias(s);
   end;
   s := AJSon['apresentacao'].AsString;
   if (s <> '') then
   begin
     fapresentacao := Iso8601ToDateTime(s);
     fapresentacao_Bias := TimeZoneToBias(s);
   end;
   fexpiracao := AJSon['expiracao'].AsInteger;
  {$EndIf}
end;

end.

