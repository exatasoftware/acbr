{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrDCeConversao;

interface

uses
  SysUtils, StrUtils, Classes,
//  ACBrDFeConversao,
  pcnConversao,
  ACBrXmlBase;

type
  TVersaoDCe = (ve100);

  TStatusDCe = (stDCeIdle, stDCeStatusServico, stDCeRecepcao, stDCeRetRecepcao,
                stDCeConsulta, stDCeRecibo, stDCeEmail, stDCeEvento,
                stDCeDistDFeInt, stDCeEnvioWebService);

  TSchemaDCe = (schErroDCe, schDCe, schEventoDCe, schconsReciDCe,
                schconsSitDCe, schconsStatServDCe, schevCancDCe,
                schdistDFeInt);

  TLayOutDCe = (LayDCeRecepcao, LayDCeRetRecepcao, LayDCeConsulta,
                LayDCeStatusServico, LayDCeEvento, LayDCeConsNaoEnc,
                LayDCeDistDFeInt, LayDCeRecepcaoSinc);

  TEmitenteDCe = (teFisco, teMarketplace, teEmissorProprio, teTransportadora);

  TModTrans = (mtCorreios, mtPropria, mtTransportadora);

function StrToVersaoDCe(out ok: Boolean; const s: String): TVersaoDCe;
function VersaoDCeToStr(const t: TVersaoDCe): String;

function DblToVersaoDCe(out ok: Boolean; const d: Double): TVersaoDCe;
function VersaoDCeToDbl(const t: TVersaoDCe): Double;

function SchemaDCeToStr(const t: TSchemaDCe): String;
function StrToSchemaDCe(const s: String): TSchemaDCe;

function LayOutDCeToSchema(const t: TLayOutDCe): TSchemaDCe;

function LayOutDCeToServico(const t: TLayOutDCe): String;
function ServicoToLayOutDCe(out ok: Boolean; const s: String): TLayOutDCe;

function EmitenteDCeToStr(const t: TEmitenteDCe): String;
function StrToEmitenteDCe(out ok: Boolean; const s: String): TEmitenteDCe;

function ModTransToStr(const t: TModTrans): String;
function StrToModTrans(out ok: Boolean; const s: String): TModTrans;

function StrTotpEventoDCe(out ok: boolean; const s: string): TpcnTpEvento;

implementation

uses
  typinfo;

function StrToVersaoDCe(out ok: Boolean; const s: String): TVersaoDCe;
begin
  Result := StrToEnumerado(ok, s, ['1.00'], [ve100]);
end;

function VersaoDCeToStr(const t: TVersaoDCe): String;
begin
  Result := EnumeradoToStr(t, ['1.00'], [ve100]);
end;

function DblToVersaoDCe(out ok: Boolean; const d: Double): TVersaoDCe;
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

function VersaoDCeToDbl(const t: TVersaoDCe): Double;
begin
  case t of
    ve100: Result := 1.0;
  else
    Result := 0;
  end;
end;

function SchemaDCeToStr(const t: TSchemaDCe): String;
begin
  Result := GetEnumName(TypeInfo(TSchemaDCe), Integer(t));
  Result := copy(Result, 4, Length(Result)); // Remove prefixo "sch"
end;

function StrToSchemaDCe(const s: String): TSchemaDCe;
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

  CodSchema := GetEnumValue(TypeInfo(TSchemaDCe), SchemaStr);

  if CodSchema = -1 then
    raise Exception.Create(Format('"%s" n�o � um valor TSchemaDCe v�lido.', [SchemaStr]));

  Result := TSchemaDCe(CodSchema);
end;

function LayOutDCeToSchema(const t: TLayOutDCe): TSchemaDCe;
begin
  case t of
    LayDCeRecepcao,
    LayDCeRecepcaoSinc:  Result := schDCe;
    LayDCeRetRecepcao:   Result := schconsReciDCe;
    LayDCeConsulta:      Result := schconsSitDCe;
    LayDCeStatusServico: Result := schconsStatServDCe;
    LayDCeEvento:        Result := schEventoDCe;
    LayDCeDistDFeInt:    Result := schdistDFeInt;
  else
    Result := schErroDCe;
  end;
end;

function LayOutDCeToServico(const t: TLayOutDCe): String;
begin
  Result := EnumeradoToStr(t,
    ['DCeRecepcao', 'DCeRetRecepcao', 'DCeConsultaProtocolo', 'DCeStatusServico',
     'RecepcaoEvento', 'DCeConsNaoEnc', 'DCeDistDFeInt', 'DCeRecepcaoSinc'],
    [LayDCeRecepcao, LayDCeRetRecepcao, LayDCeConsulta, LayDCeStatusServico,
     LayDCeEvento, LayDCeConsNaoEnc, LayDCeDistDFeInt, LayDCeRecepcaoSinc]);
end;

function ServicoToLayOutDCe(out ok: Boolean; const s: String): TLayOutDCe;
begin
  Result := StrToEnumerado(ok, s,
    ['DCeRecepcao', 'DCeRetRecepcao', 'DCeConsultaProtocolo', 'DCeStatusServico',
     'RecepcaoEvento', 'DCeConsNaoEnc', 'DCeDistDFeInt', 'DCeRecepcaoSinc'],
    [LayDCeRecepcao, LayDCeRetRecepcao, LayDCeConsulta, LayDCeStatusServico,
     LayDCeEvento, LayDCeConsNaoEnc, LayDCeDistDFeInt, LayDCeRecepcaoSinc]);
end;

function EmitenteDCeToStr(const t: TEmitenteDCe): String;
begin
  result := EnumeradoToStr(t,
                           ['0', '1', '2', '3'],
                           [teFisco, teMarketplace, teEmissorProprio,
                            teTransportadora]);
end;

function StrToEmitenteDCe(out ok: Boolean; const s: String): TEmitenteDCe;
begin
  result := StrToEnumerado(ok, s,
                           ['0', '1', '2', '3'],
                           [teFisco, teMarketplace, teEmissorProprio,
                            teTransportadora]);
end;

function ModTransToStr(const t: TModTrans): String;
begin
  Result := EnumeradoToStr(t, ['0', '1', '2'],
                              [mtCorreios, mtPropria, mtTransportadora]);
end;

function StrToModTrans(out ok: Boolean; const s: String): TModTrans;
begin
  Result := StrToEnumerado(ok, s, ['0', '1', '2'],
                                  [mtCorreios, mtPropria, mtTransportadora]);
end;

function StrTotpEventoDCe(out ok: boolean; const s: string): TpcnTpEvento;
begin
  Result := StrToEnumerado(ok, s,
            ['-99999', '110111', '110112', '110114', '110115', '110116',
             '310112', '510620'],
            [teNaoMapeado, teCancelamento, teEncerramento, teInclusaoCondutor,
             teInclusaoDFe, tePagamentoOperacao, teEncerramentoFisco,
             teRegistroPassagemBRId]);
end;

initialization
  RegisterStrToTpEventoDFe(StrTotpEventoDCe, 'DCe');

end.

