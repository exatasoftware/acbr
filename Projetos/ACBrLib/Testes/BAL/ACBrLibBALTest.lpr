program ACBrLibBALTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, ACBrLibBALTestCase;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

