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

unit ACBrGTINConversao;

interface

uses
  SysUtils, StrUtils, Classes,
  ACBrXmlBase;

type
  TVersaoGTIN     = (ve100);

  TLayOutGTIN     = (LayGTINConsulta);

  TSchemaGTIN     = (schErro, schconsGTIN);

  TStatusACBrGTIN = (stGTINIdle, stGTINConsulta, stGTINEnvioWebService);

function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string;
  const AEnumerados: array of variant): variant;
function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;

function LayOutToSchema(const t: TLayOutGTIN): TSchemaGTIN;

function LayOutToServico(const t: TLayOutGTIN): String;
function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutGTIN;

function SchemaGTINToStr(const t: TSchemaGTIN): String;
function StrToSchemaGTIN(const s: String): TSchemaGTIN;

function StrToVersaoGTIN(out ok: Boolean; const s: String): TVersaoGTIN;
function VersaoGTINToStr(const t: TVersaoGTIN): String;

function DblToVersaoGTIN(out ok: Boolean; const d: Double): TVersaoGTIN;
function VersaoGTINToDbl(const t: TVersaoGTIN): Double;

function TipoAmbToStr(const t: TACBrTipoAmbiente): string;
function StrToTipoAmb(out ok: boolean; const s: string): TACBrTipoAmbiente;

implementation

uses
  typinfo;

function StrToEnumerado(out ok: boolean; const s: string; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := -1;

  for i := Low(AString) to High(AString) do
    if AnsiSameText(s, AString[i]) then
      result := AEnumerados[i];

  ok := result <> -1;

  if not ok then
    result := AEnumerados[0];
end;

function EnumeradoToStr(const t: variant; const AString:
  array of string; const AEnumerados: array of variant): variant;
var
  i: integer;
begin
  result := '';

  for i := Low(AEnumerados) to High(AEnumerados) do
    if t = AEnumerados[i] then
      result := AString[i];
end;

function LayOutToSchema(const t: TLayOutGTIN): TSchemaGTIN;
begin
  case t of
    LayGTINConsulta: Result := schconsGTIN;
  else
    Result := schErro;
  end;
end;

function LayOutToServico(const t: TLayOutGTIN): String;
begin
  Result := EnumeradoToStr(t, ['GTINConsulta'],
                              [LayGTINConsulta]);
end;

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutGTIN;
begin
  Result := StrToEnumerado(ok, s, ['GTINConsulta'],
                                  [LayGTINConsulta]);
end;

function SchemaGTINToStr(const t: TSchemaGTIN): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaGTIN), Integer(t));
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaGTIN(const s: String): TSchemaGTIN;
var
  P: Integer;
  SchemaStr: String;
  CodSchema: Integer;
begin
  P := pos('_', s);

  if P > 0 then
    SchemaStr := copy(s, 1, P-1)
  else
    SchemaStr := s;

  if LeftStr(SchemaStr, 3) <> 'sch' then
    SchemaStr := 'sch' + SchemaStr;

  CodSchema := GetEnumValue(TypeInfo(TSchemaGTIN), SchemaStr);

  if CodSchema = -1 then
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaGTIN v�lido.', [SchemaStr]));

  Result := TSchemaGTIN(CodSchema);
end;

function StrToVersaoGTIN(out ok: Boolean; const s: String): TVersaoGTIN;
begin
  Result := StrToEnumerado(ok, s, ['1.00'], [ve100]);
end;

function VersaoGTINToStr(const t: TVersaoGTIN): String;
begin
  Result := EnumeradoToStr(t, ['1.00'], [ve100]);
end;

function DblToVersaoGTIN(out ok: Boolean; const d: Double): TVersaoGTIN;
begin
  ok := True;

  if d = 1.0 then
    Result := ve100
  else
  begin
    Result := ve100;
    ok := False;
  end;
end;

function VersaoGTINToDbl(const t: TVersaoGTIN): Double;
begin
  case t of
    ve100: Result := 1.0;
  else
    Result := 0;
  end;
end;

function TipoAmbToStr(const t: TACBrTipoAmbiente): string;
begin
  result := EnumeradoToStr(t, ['1', '2'],
                              [taProducao, taHomologacao]);
end;

function StrToTipoAmb(out ok: boolean; const s: string): TACBrTipoAmbiente;
begin
  result := StrToEnumerado(ok, s, ['1', '2'],
                                  [taProducao, taHomologacao]);
end;

end.

