program ACBrLibBoletoTest;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, printer4lazarus, ACBrLibBoletoTestCase;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

