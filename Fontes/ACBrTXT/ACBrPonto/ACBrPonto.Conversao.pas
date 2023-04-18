{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Alisson Souza Pereira                           }
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
unit ACBrPonto.Conversao;

interface

uses
  StrUtils,
  SysUtils,
  pcnConversao;

type
  TtpIdtEmpregador = (empCNPJ, empCPF);
  TtpRep = (tpRepC, tpRepA, tpRepP);
  TtpMarc = (marcEntrada, marcSaida,marcDesconsiderada);
  TfonteMarc = (fontOriginal, fontIncluidaManualmente, fontPreAssinalada, fontExcecao,fontOutrasFontes);
  TtipoAusenOuComp = (acDSR, acFaltaNaoJustificada, acMovimentoBancoHoras, acFolgaCompensatoriaFeriado);
  TtpIdtDesenv = (devCNPJ, devCPF);

  function tpIdtEmpregadorToStr(const t: TtpIdtEmpregador ): string;
  function strToTpIdtEmpregador(var ok: boolean; const s: string): TtpIdtEmpregador;

  function tpRepToStr(const t: TtpRep ): string;
  function strToTpRep(var ok: boolean; const s: string): TtpRep;

  function tpMarcToStr(const t: TtpMarc ): string;
  function strToTpMarc(var ok: boolean; const s: string): TtpMarc;

  function fonteMarcToStr(const t: TfonteMarc ): string;
  function strToFonteMarc(var ok: boolean; const s: string): TfonteMarc;

  function tipoAusenOuCompToStr(const t: TtipoAusenOuComp ): string;
  function strToTipoAusenOuComp(var ok: boolean; const s: string): TtipoAusenOuComp;

  function tpIdtDesenvToStr(const t: TtpIdtDesenv ): string;
  function strTotpIdtDesenv(var ok: boolean; const s: string): TtpIdtDesenv;

const
  C_TPIDEMPREGADOR: array[TtpIdtEmpregador] of String = ('1','2');
  C_TPREP: array[TtpRep] of string = ('1','2','3');
  C_TPMARC: array[TtpMarc] of string = ('E','S','D');
  C_FONTEMARCACAO: array[TfonteMarc] of string = ('O','I','P','X','T');
  C_TIPO_AUSENCIA_MARCACAO: array[TtipoAusenOuComp] of string = ('1','2','3','4');
  C_TPIDDESENVOLVEDOR: array[TtpIdtDesenv] of string = ('1','2');

implementation

function tpIdtEmpregadorToStr(const t:TtpIdtEmpregador ): string;
begin
  result := EnumeradoToStr2(t,C_TPIDEMPREGADOR  );
end;

function strToTpIdtEmpregador(var ok: boolean; const s: string): TtpIdtEmpregador;
begin
  result := TtpIdtEmpregador( StrToEnumerado2(ok , s,C_TPIDEMPREGADOR  ));
end;

function tpRepToStr(const t:TtpRep ): string;
begin
  result := EnumeradoToStr2(t,C_TPREP  );
end;

function strToTpRep(var ok: boolean; const s: string): TtpRep;
begin
  result := TtpRep( StrToEnumerado2(ok , s,C_TPREP  ));
end;

function tpMarcToStr(const t:TtpMarc ): string;
begin
  result := EnumeradoToStr2(t,C_TPMARC  );
end;

function strToTpMarc(var ok: boolean; const s: string): TtpMarc;
begin
  result := TtpMarc( StrToEnumerado2(ok , s,C_TPMARC  ));
end;

function fonteMarcToStr(const t:TfonteMarc ): string;
begin
  result := EnumeradoToStr2(t,C_FONTEMARCACAO  );
end;

function strToFonteMarc(var ok: boolean; const s: string): TfonteMarc;
begin
  result := TfonteMarc( StrToEnumerado2(ok , s,C_FONTEMARCACAO  ));
end;

function tipoAusenOuCompToStr(const t:TtipoAusenOuComp ): string;
begin
  result := EnumeradoToStr2(t,C_TIPO_AUSENCIA_MARCACAO  );
end;

function strToTipoAusenOuComp(var ok: boolean; const s: string): TtipoAusenOuComp;
begin
  result := TtipoAusenOuComp( StrToEnumerado2(ok , s,C_TIPO_AUSENCIA_MARCACAO  ));
end;

function tpIdtDesenvToStr(const t:TtpIdtDesenv ): string;
begin
  result := EnumeradoToStr2(t,C_TPIDDESENVOLVEDOR  );
end;

function strTotpIdtDesenv(var ok: boolean; const s: string): TtpIdtDesenv;
begin
  result := TtpIdtDesenv( StrToEnumerado2(ok , s,C_TPIDDESENVOLVEDOR  ));
end;

end.
