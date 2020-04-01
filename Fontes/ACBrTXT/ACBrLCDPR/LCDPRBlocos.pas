{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Willian H�bner e Elton Barbosa (EMBarbosa)      }
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
unit LCDPRBlocos;

interface

uses
  SysUtils, StrUtils, Classes;

type
  TCodVer    = (Versao001, Versao011, Versao013);
  TIndInicio = (indRegular, indAbertura, indInicioObriga);
  TIndSitEsp = (iseNormal, iseFalecimento, iseEspolio, iseSaidaDefinitiva);
  TFormaApur       = (faLivroCaixa, faApurLucro);
  TTipoExploracao  = (teExploracaoInd, teCondominio, teImovelArrendado, teParceria, teComodato, teOutro);
  TTipoContraparte = (tpcCondomino, tpcArrendante, tpcParceiro, tpcComodatario, tpcOutro);
  TTipoDoc  = (tdNotaFiscal, tdFatura, tdRecibo, tdContrato, tdFolhaPagamento, tdOutros);
  TTipoLanc = (tlReceitaRural, tlDespesaCusteio, tlProdEntregue);

function StrToEnumerado(out ok: boolean; const s: string; const AString: array of string;
  const AEnumerados: array of variant): variant;

//C�digo da vers�o do leiaute.
function CodVerToStr(CodVer : TCodVer) : String;
function StrtoCodVer(out ok: boolean; const s: string): TCodVer;

//Indicador do In�cio do Per�odo:
function IndInicioToStr(IndInicio : TIndInicio) : String;
function StrtoIndInicio(out ok: boolean; const s: string): TIndInicio;

function IndSitEspToStr(IndSitEsp : TIndSitEsp) : String;
function IndFormaApurToStr(IndFormaApur : TFormaApur) : String;
function TipoExploracaoToStr(TipoExploracao : TTipoExploracao) : String;
function TipoContraparteToStr(TipoContraparte : TTipoContraparte) : String;
function TipoDocToStr(TipoDoc : TTipoDoc) : String;
function TipoLancToStr(TipoLanc : TTipoLanc) : String;

implementation

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

// C�digo da vers�o do leiaute.
function CodVerToStr(CodVer : TCodVer) : String;
begin
  case CodVer of
    Versao001 : Result := '0001';
    Versao011 : Result := '0011';
    Versao013 : Result := '0013';
  end;
end;

function StrtoCodVer(out ok: boolean; const s: string): TCodVer;
begin
   result := StrToEnumerado(ok, s, ['0', '1','2'], [Versao001, Versao011, Versao013]);
end;

//Indicador do In�cio do Per�odo:
function IndInicioToStr(IndInicio : TIndInicio) : String;
begin
  case IndInicio of
    indRegular      : Result := '0';
    indAbertura     : Result := '1';
    indInicioObriga : Result := '2';
  end;
end;

function StrtoIndInicio(out ok: boolean; const s: string): TIndInicio;
begin
  result := StrToEnumerado(ok, s, ['0', '1','2'], [indRegular, indAbertura, indInicioObriga]);
end;


function IndSitEspToStr(IndSitEsp : TIndSitEsp) : String;
begin
  case IndSitEsp of
    iseNormal           : Result := '0';
    iseFalecimento      : Result := '1';
    iseEspolio          : Result := '2';
    iseSaidaDefinitiva  : Result := '3';
  end;
end;

function IndFormaApurToStr(IndFormaApur : TFormaApur) : String;
begin
  case IndFormaApur of
    faLivroCaixa  : Result := '1';
    faApurLucro   : Result := '2';
  end;
end;

function TipoExploracaoToStr(TipoExploracao : TTipoExploracao) : String;
begin
  case TipoExploracao of
    teExploracaoInd   : Result := '1';
    teCondominio      : Result := '2';
    teImovelArrendado : Result := '3';
    teParceria        : Result := '4';
    teComodato        : Result := '5';
    teOutro           : Result := '6';
  end;
end;

function TipoContraparteToStr(TipoContraparte : TTipoContraparte) : String;
begin
  case TipoContraparte of
    tpcCondomino    : Result := '1';
    tpcArrendante   : Result := '2';
    tpcParceiro     : Result := '3';
    tpcComodatario  : Result := '4';
    tpcOutro        : Result := '5';
  end;
end;

function TipoDocToStr(TipoDoc : TTipoDoc) : String;
begin
  case TipoDoc of
    tdNotaFiscal    : Result := '1';
    tdFatura        : Result := '2';
    tdRecibo        : Result := '3';
    tdContrato      : Result := '4';
    tdFolhaPagamento: Result := '5';
    tdOutros        : Result := '6';
  end;
end;

function TipoLancToStr(TipoLanc : TTipoLanc) : String;
begin
  case TipoLanc of
    tlReceitaRural        : Result := '1';
    tlDespesaCusteio      : Result := '2';
    tlProdEntregue        : Result := '3';
  end;
end;

end.
