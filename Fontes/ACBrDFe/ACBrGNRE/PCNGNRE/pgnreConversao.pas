{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                              Claudemir Vitor Pereira                         }
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

unit pgnreConversao;

interface

uses
  SysUtils, Classes,
  pcnConversao;

type
  TStatusACBrGNRE = ( stGNREIdle, stGNRERecepcao, stGNRERetRecepcao,
                      stGNREConsulta, stGNREConsultaConfigUF, stGNREEmail,
                      stEnvioWebService );
                      
  TLayOutGNRE = ( LayGNRERecepcao, LayGNRERetRecepcao, LayGNREConsultaConfigUF );

  TVersaoGNRE = (ve100, ve200);

  TSchemaGNRE = ( schErro, schGNRE, schretGNRE, schprocGNRE, schconsReciGNRE );

  TTipoGNRE = ( tgSimples, tgMultiplosDoc, tgMultiplasReceitas );

function LayOutToServico(const t: TLayOutGNRE): String;
function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutGNRE;

function LayOutToSchema(const t: TLayOutGNRE): TSchemaGNRE;

function SchemaGNREToStr(const t: TSchemaGNRE): String;

function VersaoGNREToStr(const t: TVersaoGNRE): String;
function VersaoGNREToDbl(const t: TVersaoGNRE): Double;
function StrToVersaoGNRe(out ok: Boolean; const s: String): TVersaoGNRE;

function TipoGNREToStr(const t: TTipoGNRE): String;
function StrToTipoGNRE(out ok: Boolean; const s: String): TTipoGNRE;

implementation

uses
  typinfo, ACBrUtil;

function LayOutToServico(const t: TLayOutGNRE): String;
begin
  Result := EnumeradoToStr(t,
    ['GNRERecepcao', 'GNRERetRecepcao', 'GNREConsultaConfigUF'],
    [LayGNRERecepcao, LayGNRERetRecepcao, LayGNREConsultaConfigUF]);
end;

function ServicoToLayOut(out ok: Boolean; const s: String): TLayOutGNRE;
begin
  Result := StrToEnumerado(ok, s,
    ['GNRERecepcao', 'GNRERetRecepcao', 'GNREConsultaConfigUF'],
    [LayGNRERecepcao, LayGNRERetRecepcao, LayGNREConsultaConfigUF]);
end;

function LayOutToSchema(const t: TLayOutGNRE): TSchemaGNRE;
begin
  case t of
    LayGNRERecepcao:         Result := schGNRE;
    LayGNRERetRecepcao:      Result := schretGNRE;
    LayGNREConsultaConfigUF: Result := schconsReciGNRE;
  else
    Result := schErro;
  end;
end;

function SchemaGNREToStr(const t: TSchemaGNRE): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaGNRE), Integer( t ) );
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function VersaoGNREToStr(const t: TVersaoGNRE): String;
begin
  Result := EnumeradoToStr(t, ['1.00', '2.00'], [ve100, ve200]);
end;

function VersaoGNREToDbl(const t: TVersaoGNRE): Double;
begin
  case t of
    ve100: Result := 1.0;
    ve200: Result := 2.0;
  else
    Result := 0;
  end;
end;

function StrToVersaoGNRe(out ok: Boolean; const s: String): TVersaoGNRE;
begin
  Result := StrToEnumerado(ok, s, ['1.00', '2.00'], [ve100, ve200]);
end;

function TipoGNREToStr(const t: TTipoGNRE): String;
begin
  Result := EnumeradoToStr(t,
    ['0', '1', '2'],
    [tgSimples, tgMultiplosDoc, tgMultiplasReceitas]);
end;

function StrToTipoGNRE(out ok: Boolean; const s: String): TTipoGNRE;
begin
  Result := StrToEnumerado(ok, s,
    ['0', '1', '2'],
    [tgSimples, tgMultiplosDoc, tgMultiplasReceitas]);
end;

end.

