{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Elton Barbosa                                   }
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

unit ACBrTests.Util;

{
  Esse Unit possui m�todos �teis utilizados nos Testes Unit�rios do ACBr.
  -------------------------
  Esses m�todos tem objetivo de permitir o m�ximo de compatibilidade entre os frameworks
    DUnitX/DUnit/FPCunit, FMX/VCL, CONSOLE/GUI/TestInsight
  No momento os testes precisam ser desenvolvidos como se estivessem no Dunit ou na FPCUnit.
  Assim, com ajuda dessa unit, consguimos manter a compatibilidade mencionada.

}

{$I ACBr.inc}

interface

uses
 SysUtils,
  {$ifdef FPC}
  fpcunit,{testutils,} testregistry
  {$else}
   {$IFDEF DUNITX}
    DUnitX.TestFramework, DUnitX.DUnitCompatibility
   {$ELSE}
    TestFramework
   {$ENDIF}
  {$endif};

type
  {$ifdef FPC}
  TTestCase = fpcunit.TTestCase;
  {$else}
   {$IFDEF DUNITX}
  TTestCase = DUnitX.DUnitCompatibility.TTestCase;
   {$ELSE}
  TTestCase = TestFramework.TTestCase;
   {$ENDIF}
  {$endif}

    { Registra uma classe de testes. Use para manter compatibilidade entre DUnitX/DUnit/FPCunit.
      @param ATesteName � um nome para o Teste. Pode ser passado vazio.
      @param ATestClass � a classe de teste }
 procedure _RegisterTest(ATesteName: String; ATestClass: TClass);


implementation

procedure _RegisterTest(ATesteName: String; ATestClass: TClass);
begin
  {$IfDef DUNITX}
   TDUnitX.RegisterTestFixture(ATestClass, ATesteName + ATestClass.ClassName);
  {$ELSE}
   RegisterTest(ATesteName, TTestCaseClass(ATestClass){$IfNDef FPC}.Suite{$EndIf} );
  {$EndIf}
end;



end.
