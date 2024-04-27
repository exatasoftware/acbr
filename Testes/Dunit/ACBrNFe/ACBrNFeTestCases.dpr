program ACBrNFeTestCases;

{
  Esse � um projeto de testes com a ajuda da ACBrTests.Runner.pas
  -------------------------
  Este projeto deve funcionar tanto em DUnit/DUnitX/TestInsight
  Por padr�o ele ir� utilizar DUnit e Interface (GUI)

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
  Para mais informa��es veja o arquivo: ACBrTests.Runner.pas
}

{$I ACBr.inc}

{$IFDEF NOGUI}
{$APPTYPE CONSOLE}
{$ENDIF}

{$IFDEF DUNITX}
  {$STRONGLINKTYPES ON}
{$ENDIF}

{$R *.RES}

uses
  ACBrTests.Util in '..\..\ACBrTests.Util.pas',
  ACBrTests.Runner in '..\..\ACBrTests.Runner.pas',
  ACBrNFeTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeTests.pas',
  ACBrNFeConstantesTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeConstantesTests.pas',
  ACBrNFeAdmCSCTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeAdmCSCTests.pas',
  ACBrNFeConsSitTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeConsSitTests.pas',
  ACBrNFeInutTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeInutTests.pas',
  ACBrNFeEnvEventoTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeEnvEventoTests.pas',
  ACBrNFeRetAdmCSCTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeRetAdmCSCTests.pas',
  ACBrNFeRetConsSitTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeRetConsSitTests.pas',
  ACBrNFeRetInutTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeRetInutTests.pas',
  ACBrNFeRetEnvEventoTests in '..\..\FPCUnit\ACBrNFe\ACBrNFeRetEnvEventoTests.pas';

begin
  ACBrRunTests;
end.
