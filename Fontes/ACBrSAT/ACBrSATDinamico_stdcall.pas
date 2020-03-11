{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Andr� Ferreira Moraes                          }
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

unit ACBrSATDinamico_stdcall ;

interface

uses
  Classes, SysUtils, ACBrSATClass;

type

   { TACBrSATDinamico_stdcall }

   TACBrSATDinamico_stdcall = class( TACBrSATClass )
   private
     xSAT_AssociarAssinatura : function ( numeroSessao : LongInt;
        codigoDeAtivacao, CNPJvalue, assinaturaCNPJs : PAnsiChar ) : PAnsiChar ;
        stdcall;
     xSAT_AtivarSAT : function ( numeroSessao, subComando : LongInt;
        codigoDeAtivacao, CNPJ: PAnsiChar; cUF : LongInt ) : PAnsiChar ; stdcall;
     xSAT_AtualizarSoftwareSAT : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_BloquearSAT : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_CancelarUltimaVenda : function (numeroSessao : LongInt;
        codigoAtivacao, chave, dadosCancelamento : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_ComunicarCertificadoICPBRASIL : function ( numeroSessao : LongInt;
        codigoDeAtivacao, certificado : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_ConfigurarInterfaceDeRede : function ( numeroSessao : LongInt;
        codigoDeAtivacao, dadosConfiguracao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_ConsultarNumeroSessao : function (numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar; cNumeroDeSessao : LongInt) : PAnsiChar ; stdcall;
     xSAT_ConsultarSAT : function ( numeroSessao : LongInt ) : PAnsiChar ; stdcall;
     xSAT_ConsultarStatusOperacional : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_DesbloquearSAT : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_EnviarDadosVenda : function ( numeroSessao : LongInt;
        codigoDeAtivacao, dadosVenda : PAnsiChar) : PAnsiChar ; stdcall;
     xSAT_ExtrairLogs : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar ) : PAnsiChar ; stdcall;
     xSAT_TesteFimAFim : function ( numeroSessao : LongInt;
        codigoDeAtivacao, dadosVenda : PAnsiChar) : PAnsiChar ; stdcall;
     xSAT_TrocarCodigoDeAtivacao : function ( numeroSessao : LongInt;
        codigoDeAtivacao : PAnsiChar; opcao : LongInt; novoCodigo,
        confNovoCodigo : PAnsiChar ) : PAnsiChar ; stdcall;

   protected
     procedure LoadDLLFunctions ; override;
     procedure UnLoadDLLFunctions; override;

   public
     constructor Create( AOwner : TComponent ) ; override;

     function AssociarAssinatura(const CNPJvalue, assinaturaCNPJs : AnsiString ):
       String ; override;
     function AtivarSAT( subComando : Integer; CNPJ: AnsiString; cUF : Integer )
       : String ; override;
     function AtualizarSoftwareSAT : String ; override;
     function BloquearSAT : String ; override;
     function CancelarUltimaVenda( chave, dadosCancelamento : AnsiString ) :
       String ; override;
     function ComunicarCertificadoICPBRASIL( certificado : AnsiString ) :
       String ; override;
     function ConfigurarInterfaceDeRede( dadosConfiguracao : AnsiString ) :
       String ; override;
     function ConsultarNumeroSessao( cNumeroDeSessao : Integer) : String ;
       override;
     function ConsultarSAT : String ; override ;
     function ConsultarStatusOperacional : String ; override;
     function DesbloquearSAT : String ; override;
     function EnviarDadosVenda( dadosVenda : AnsiString ) : String ; override;
     function ExtrairLogs : String ; override;
     function TesteFimAFim( dadosVenda : AnsiString) : String ; override;
     function TrocarCodigoDeAtivacao( codigoDeAtivacaoOuEmergencia: AnsiString;
       opcao : Integer; novoCodigo: AnsiString ) : String ; override;
   end;

implementation

Uses ACBrUtil;

constructor TACBrSATDinamico_stdcall.Create(AOwner : TComponent) ;
begin
  inherited Create(AOwner) ;

  fpModeloStr := 'Emulador_SAT_Dinamico' ;
end ;

function TACBrSATDinamico_stdcall.AssociarAssinatura(const CNPJvalue,
  assinaturaCNPJs : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_AssociarAssinatura(  numeroSessao,
                                    PAnsiChar(codigoDeAtivacao),
                                    PAnsiChar(CNPJvalue),
                                    PAnsiChar(assinaturaCNPJs) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.AtivarSAT(subComando : Integer ;
  CNPJ : AnsiString; cUF : Integer) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_AtivarSAT( numeroSessao, subComando,
                          PAnsiChar(codigoDeAtivacao), PAnsiChar(CNPJ), cUF);
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.AtualizarSoftwareSAT : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_AtualizarSoftwareSAT( numeroSessao, PAnsiChar(codigoDeAtivacao) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.BloquearSAT : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_BloquearSAT( numeroSessao, PAnsiChar(codigoDeAtivacao) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.CancelarUltimaVenda(chave,
  dadosCancelamento : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_CancelarUltimaVenda( numeroSessao, PAnsiChar(codigoDeAtivacao),
                                    PAnsiChar(chave), PAnsiChar(dadosCancelamento) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ComunicarCertificadoICPBRASIL(
  certificado : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ComunicarCertificadoICPBRASIL( numeroSessao,
                  PAnsiChar(codigoDeAtivacao), PAnsiChar(certificado) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ConfigurarInterfaceDeRede(
  dadosConfiguracao : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ConfigurarInterfaceDeRede( numeroSessao,
                 PAnsiChar(codigoDeAtivacao), PAnsiChar(dadosConfiguracao) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ConsultarNumeroSessao(cNumeroDeSessao : Integer
  ) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ConsultarNumeroSessao( numeroSessao, PAnsiChar(codigoDeAtivacao),
                                        cNumeroDeSessao) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ConsultarSAT : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ConsultarSAT( numeroSessao ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ConsultarStatusOperacional : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ConsultarStatusOperacional( numeroSessao, PAnsiChar(codigoDeAtivacao) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.DesbloquearSAT : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_DesbloquearSAT( numeroSessao, PAnsiChar(codigoDeAtivacao) );
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.EnviarDadosVenda(dadosVenda : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_EnviarDadosVenda( numeroSessao, PAnsiChar(codigoDeAtivacao),
                                   PAnsiChar(dadosVenda) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.ExtrairLogs : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_ExtrairLogs( numeroSessao, PAnsiChar(codigoDeAtivacao) ) ;
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.TesteFimAFim(dadosVenda : AnsiString) : String ;
Var
  Resp : PAnsiChar;
begin
  Resp := xSAT_TesteFimAFim( numeroSessao, PAnsiChar(codigoDeAtivacao),
                               PAnsiChar(dadosVenda) );
  Result := String( Resp );
end ;

function TACBrSATDinamico_stdcall.TrocarCodigoDeAtivacao(
  codigoDeAtivacaoOuEmergencia: AnsiString; opcao: Integer; novoCodigo: AnsiString
  ): String;
Var
  Resp : PAnsiChar;
begin
  if codigoDeAtivacaoOuEmergencia = '' then
    codigoDeAtivacaoOuEmergencia := codigoDeAtivacao;

  Resp := xSAT_TrocarCodigoDeAtivacao( numeroSessao,
                                       PAnsiChar(codigoDeAtivacaoOuEmergencia),
                                       opcao,
                                       PAnsiChar(novoCodigo),
                                       PAnsiChar(novoCodigo) ) ;
  Result := String( Resp );
end ;

procedure TACBrSATDinamico_stdcall.LoadDLLFunctions;
begin
  FunctionDetectLibSAT( 'AssociarAssinatura', @xSAT_AssociarAssinatura );
  FunctionDetectLibSAT( 'AtivarSAT', @xSAT_AtivarSAT );
  FunctionDetectLibSAT( 'AtualizarSoftwareSAT', @xSAT_AtualizarSoftwareSAT) ;
  FunctionDetectLibSAT( 'BloquearSAT', @xSAT_BloquearSAT);
  FunctionDetectLibSAT( 'CancelarUltimaVenda', @xSAT_CancelarUltimaVenda);
  FunctionDetectLibSAT( 'ComunicarCertificadoICPBRASIL', @xSAT_ComunicarCertificadoICPBRASIL);
  FunctionDetectLibSAT( 'ConfigurarInterfaceDeRede', @xSAT_ConfigurarInterfaceDeRede);
  FunctionDetectLibSAT( 'ConsultarNumeroSessao', @xSAT_ConsultarNumeroSessao);
  FunctionDetectLibSAT( 'ConsultarSAT', @xSAT_ConsultarSAT);
  FunctionDetectLibSAT( 'ConsultarStatusOperacional', @xSAT_ConsultarStatusOperacional);
  FunctionDetectLibSAT( 'DesbloquearSAT', @xSAT_DesbloquearSAT);
  FunctionDetectLibSAT( 'EnviarDadosVenda', @xSAT_EnviarDadosVenda);
  FunctionDetectLibSAT( 'ExtrairLogs', @xSAT_ExtrairLogs);
  FunctionDetectLibSAT( 'TesteFimAFim', @xSAT_TesteFimAFim) ;
  FunctionDetectLibSAT( 'TrocarCodigoDeAtivacao', @xSAT_TrocarCodigoDeAtivacao);
end;

procedure TACBrSATDinamico_stdcall.UnLoadDLLFunctions;
begin
  inherited UnLoadDLLFunctions;

  xSAT_AssociarAssinatura             := Nil;
  xSAT_AtivarSAT                      := Nil;
  xSAT_AtualizarSoftwareSAT           := Nil;
  xSAT_BloquearSAT                    := Nil;
  xSAT_CancelarUltimaVenda            := Nil;
  xSAT_ComunicarCertificadoICPBRASIL  := Nil;
  xSAT_ConfigurarInterfaceDeRede      := Nil;
  xSAT_ConsultarNumeroSessao          := Nil;
  xSAT_ConsultarSAT                   := Nil;
  xSAT_ConsultarStatusOperacional     := Nil;
  xSAT_DesbloquearSAT                 := Nil;
  xSAT_EnviarDadosVenda               := Nil;
  xSAT_ExtrairLogs                    := Nil;
  xSAT_TesteFimAFim                   := Nil;
  xSAT_TrocarCodigoDeAtivacao         := Nil;
end;

end.

