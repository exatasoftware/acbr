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

unit ACBrTests.Runner;

(****
  Essa Unit possui m�todos �teis utilizados nos Testes Unit�rios do ACBr.
  -------------------------
  Objetivo: facilitar a cria��o/manuten��o dos arquivos .dpr de projetos de testes.
  O m�todo ACBrRunTests gera um executor para os testes no Delphi,
    permitindo o m�ximo de compatibilidade entre os frameworks
    DUnitX/DUnit, FMX/VCL, CONSOLE/GUI/TestInsight
  
  Para mudar o comportamento, adicione os seguintes "conditional defines" nas
    op��es do projeto (project->options):
    * "NOGUI"       - Transforma os testes em uma aplica��o CONSOLE
    * "DUNITX"      - Passa a usar a DUnitX ao inv�s da Dunit
    * "TESTINSIGHT" - Passa a usar o TestInsight
    * "CI"          - Caso use integra��o continua (por exemplo com o Continua CI ou Jenkins)
                   --/ Geralmente usado em conjunto com NOGUI
    * "FMX"         - Para usar Firemonkey (FMX) ao inv�s de VCL. (Testado apenas com DUnitX)

  ATEN��O: 1) OS defines PRECISAM estar nas op��es do projeto. N�o basta definir no arquivo de projeto.
           2) Fa�a um Build sempre que fizer altera��es de Defines.

  Para um exemplo de um arquivo .dpr usando essa unit: Veja o arquivo ModeloACBrTestsRunnerDpr.dp_

*****)

{$I ACBr.inc}

interface

uses
{$IFDEF TESTINSIGHT}
  {$IFDEF DUNITX}
  TestInsight.DUnitX,
  {$ELSE}
  TestInsight.DUnit,
  {$ENDIF}
{$ENDIF }

{$IFNDEF NOGUI}
  {$IFDEF FMX}
  FMX.Forms,
  {$ELSE}
    {$IFDEF USE_NAMESPACES}
  Vcl.Forms,
    {$ELSE}
  Forms,
    {$ENDIF }
  {$ENDIF }
{$ENDIF }

{$IFDEF DUNITX}
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  {$IFNDEF NOGUI}
    {$IFDEF FMX}
  DUnitX.Loggers.GUIX,
    {$ELSE}
  DUnitX.Loggers.GUI.VCL,
    {$ENDIF}
  {$ENDIF }
  DUnitX.TestFramework,
  DUnitX.DUnitCompatibility,
{$ELSE}
  TestFramework,
  GUITestRunner,
  TextTestRunner,
{$ENDIF}
  SysUtils;

  {Use para chamar a aplica��o que executa os m�todos de testes}
  procedure ACBrRunTests();


implementation

{$IFDEF TESTINSIGHT}
  function IsTestInsightRunning: Boolean;
  var
    TestInsightClient: ITestInsightClient;
  begin
    TestInsightClient := TTestInsightRestClient.Create;
    TestInsightClient.StartedTesting(0);
    Result := not TestInsightClient.HasError;
  end;
{$ELSE}
  {$IFDEF NOGUI}
  procedure PausaSeNaoTiverCI;
  begin
    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    System.Write('Done.. press <Enter> key to quit.');
    System.Readln;
    {$ENDIF}
  end;

    {$IFDEF DUNITX}
    procedure ConsoleDUnitX;
    var
      runner: ITestRunner;
      results: IRunResults;
      logger: ITestLogger;
      nunitLogger : ITestLogger;
    begin
      try
        //Check command line options, will exit if invalid
        TDUnitX.CheckCommandLine;
        //Create the test runner
        runner := TDUnitX.CreateRunner;
        //Tell the runner to use RTTI to find Fixtures
        runner.UseRTTI := True;
        //When true, Assertions must be made during tests;
        runner.FailsOnNoAsserts := False;

        //tell the runner how we will log things
        //Log to the console window if desired
        if TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off then
        begin
          logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
          runner.AddLogger(logger);
        end;
        //Generate an NUnit compatible XML File
        nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
        runner.AddLogger(nunitLogger);

        //Run tests
        results := runner.Execute;
        if not results.AllPassed then
          System.ExitCode := EXIT_ERRORS;

        PausaSeNaoTiverCI;
      except
        on E: Exception do
          System.Writeln(E.ClassName, ': ', E.Message);
      end;
    end;
    {$ELSE}
    procedure ConsoleDUnit;
    begin
      with TextTestRunner.RunRegisteredTests do
        Free;
      PausaSeNaoTiverCI
    end;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

procedure ACBrRunTests();
begin
{$IFDEF TESTINSIGHT}
  if IsTestInsightRunning then
  {$IFDEF DUNITX}
    TestInsight.DUnitX.RunRegisteredTests;
  {$ELSE}
    TestInsight.DUnit.RunRegisteredTests;
  {$ENDIF}
    Exit;
{$ELSE}
  {$IFDEF DUNITX}
    {$IFDEF NOGUI}
      ConsoleDUnitX;
      Exit;
    {$ELSE}
      {$IFDEF FMX}
//      TDUnitX.CheckCommandLine;

      Application.Initialize;
      Application.CreateForm(TGUIXTestRunner, GUIXTestRunner);
      Application.Run;
      {$ELSE}
      DUnitX.Loggers.GUI.VCL.Run;
      {$ENDIF}
      Exit;
    {$ENDIF}
  {$ELSE}
    {$IFDEF NOGUI}
      ConsoleDUnit;
      Exit;
    {$ELSE}
      Application.Initialize;
      GUITestRunner.RunRegisteredTests;
      Exit;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
end;

end.
