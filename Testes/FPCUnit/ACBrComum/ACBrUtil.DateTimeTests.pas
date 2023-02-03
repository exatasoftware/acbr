unit ACBrUtil.DateTimeTests;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  {$ifdef FPC}
  LConvEncoding,
  {$endif}
  ACBrTests.Util;

type

  { WorkingDaysBetweenTest }

  WorkingDaysBetweenTest = class(TTestCase)
  published
    procedure WorkingDaysBetween_DataMesmaSemana;
    procedure WorkingDaysBetween_DataPosSemana;
    procedure WorkingDaysBetween_DataInicioSabado;
    procedure WorkingDaysBetween_DataInicioDomingo;
    procedure WorkingDaysBetween_DataFinalSabado;
    procedure WorkingDaysBetween_DataFinalDomingo;
    procedure WorkingDaysBetween_DataFinalMenor;
    procedure WorkingDaysBetween_DataZero;
    procedure WorkingDaysBetween_DataInicialZero;
    procedure WorkingDaysBetween_DataFinalZero;
  end;

   { IncWorkingDayTest }

  IncWorkingDayTest = class(TTestCase)
  private
  published
    procedure IncWorkingDayTest_DataInicioSabado;
    procedure IncWorkingDayTest_DataInicioDomingo;
    procedure IncWorkingDayTest_PosSemana;
    procedure IncWorkingDayTest_DiaFinalSabado;
    procedure IncWorkingDayTest_DiaFinalDomingo;
    procedure IncWorkingDayTest_ZeroDiaSabado;
    procedure IncWorkingDayTest_ZeroDiaDomingo;
    procedure IncWorkingDayTest_ZeroDiaSemana;
    procedure IncWorkingDayTest_DiaNegativo;
    procedure IncWorkingDayTest_DiaNegativoInicioSabado;
    procedure IncWorkingDayTest_DiaNegativoInicioDomingo;
  end;

  { FormatDateBrTest }

  FormatDateBrTest = class(TTestCase)
  published
   procedure Normal;
   procedure Bissesto;
   procedure ComMascara;
  end;

  { FormatDateTimeBrTest }

  FormatDateTimeBrTest = class(TTestCase)
  published
   procedure Normal;
   procedure BissestoMeiaNoite;
   procedure ComMascara;
  end;

  { StringToDateTimeTest }

  StringToDateTimeTest = class(TTestCase)
  published
   procedure DataAno4Digitos;
   procedure DataAno2Digitos;
   procedure Hora;
   procedure DataEHora;
   procedure ComFormatSettingsDiferente;
  end;

  { StringToDateTimeDefTest }

  StringToDateTimeDefTest = class(TTestCase)
  published
   procedure Data;
   procedure Hora;
   procedure DataEHora;
   procedure ValorDefault;
  end;

  { StoDTest }

  StoDTest = class(TTestCase)
  published
   procedure Normal;
   procedure DataSemHora;
   procedure DataInvalida;
  end;

  { DtoSTest }

  DtoSTest = class(TTestCase)
  published
   procedure Data;
  end;

  { DTtoSTest }

  DTtoSTest = class(TTestCase)
  published
   procedure DataEHora;
   procedure DataSemHora;
  end;

  { DateTimeToIso8601Test }

  DateTimeToIso8601Test = class(TTestCase)
  published
    procedure ConverteDataEHora_Sucesso;
  end;

  { Iso8601ToDateTimeTest }

  Iso8601ToDateTimeTest = class(TTestCase)
  published
    procedure ConverteString_DataEHoraSemMilisegundosSemFuso_Sucesso;
  end;



implementation

uses
  dateutils,
  ACBrConsts, ACBrUtil.DateTime;

{ IncWorkingDayTest }

procedure IncWorkingDayTest.IncWorkingDayTest_DataInicioSabado;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,17);
  WorkingDays  := 11;
  ADateResult  := EncodeDate(2017,07,03);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DataInicioDomingo;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,18);
  WorkingDays  := 11;
  ADateResult  := EncodeDate(2017,07,03);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_PosSemana;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,23);
  WorkingDays  := 10;
  ADateResult  := EncodeDate(2017,07,07);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DiaFinalSabado;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,22);
  WorkingDays  := 2;
  ADateResult  := EncodeDate(2017,06,26);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DiaFinalDomingo;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,23);
  WorkingDays  := 1;
  ADateResult  := EncodeDate(2017,06,26);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_ZeroDiaSabado;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,24);
  WorkingDays  := 0;
  ADateResult  := EncodeDate(2017,06,26);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_ZeroDiaDomingo;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,25);
  WorkingDays  := 0;
  ADateResult  := EncodeDate(2017,06,26);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_ZeroDiaSemana;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,26);
  WorkingDays  := 0;
  ADateResult  := EncodeDate(2017,06,26);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DiaNegativo;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,19);
  WorkingDays  := -3;
  ADateResult  := EncodeDate(2017,06,14);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DiaNegativoInicioSabado;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,24);
  WorkingDays  := -6;
  ADateResult  := EncodeDate(2017,06,16);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

procedure IncWorkingDayTest.IncWorkingDayTest_DiaNegativoInicioDomingo;
var
  ADateIni, ADateResult: TDateTime;
  WorkingDays: Integer;
begin
  ADateIni     := EncodeDate(2017,06,25);
  WorkingDays  := -6;
  ADateResult  := EncodeDate(2017,06,16);

  CheckEquals(ADateResult, IncWorkingDay(ADateIni,WorkingDays));
end;

{ WorkingDaysBetweenTest }

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataMesmaSemana;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,26);
  ADateEnd := EncodeDate(2017,06,30);
  CheckEquals(4, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataPosSemana;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,26);
  ADateEnd := EncodeDate(2017,07,07);
  CheckEquals(9, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataInicioSabado;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,24);
  ADateEnd := EncodeDate(2017,07,03);
  CheckEquals(6, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataInicioDomingo;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,25);
  ADateEnd := EncodeDate(2017,07,03);
  CheckEquals(6, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataFinalSabado;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,25);
  ADateEnd := EncodeDate(2017,07,08);
  CheckEquals(10, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataFinalDomingo;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,06,25);
  ADateEnd := EncodeDate(2017,07,09);
  CheckEquals(10, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataFinalMenor;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,07,10);
  ADateEnd := EncodeDate(2017,07,09);
  CheckEquals(0, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataZero;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := 0;
  ADateEnd := 0;
  CheckEquals(0, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataInicialZero;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := 0;
  ADateEnd := EncodeDate(2017,07,09);
  CheckEquals(0, WorkingDaysBetween(ADateIni,ADateEnd));
end;

procedure WorkingDaysBetweenTest.WorkingDaysBetween_DataFinalZero;
var
  ADateIni, ADateEnd: TDateTime;
begin
  ADateIni := EncodeDate(2017,07,09);
  ADateEnd := 0;
  CheckEquals(0, WorkingDaysBetween(ADateIni,ADateEnd));
end;

{ FormatDateTimeBrTest }

procedure FormatDateTimeBrTest.Normal;
Var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(1971,08,14,12,13,14,0);
  CheckEquals('14/08/1971 12:13:14', FormatDateTimeBr(ADateTime));
end;

procedure FormatDateTimeBrTest.BissestoMeiaNoite;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2012,02,29,23,59,59,0);
  CheckEquals('29/02/2012 23:59:59', FormatDateTimeBr(ADateTime));
end;

procedure FormatDateTimeBrTest.ComMascara;
Var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(1971,08,14,12,3,4,0);
  CheckEquals('08/14/1971 12:03', FormatDateTimeBr(ADateTime, 'MM/DD/YYYY hh:nn'));
  CheckEquals('14/08/71 12:3:4', FormatDateTimeBr(ADateTime, 'DD/MM/YY h:n:s'));
end;

{ FormatDateBrTest }

procedure FormatDateBrTest.Normal;
Var
  ADate: TDateTime;
begin
  ADate := EncodeDate(1971,08,14);
  CheckEquals('14/08/1971', FormatDateBr(ADate));
end;

procedure FormatDateBrTest.Bissesto;
var
  ADate: TDateTime;
begin
  ADate := EncodeDate(2012,02,29);
  CheckEquals('29/02/2012', FormatDateBr(ADate));
end;

procedure FormatDateBrTest.ComMascara;
Var
  ADate: TDateTime;
begin
  ADate := EncodeDate(1971,08,14);
  CheckEquals('08/14/1971', FormatDateBr(ADate, 'MM/DD/YYYY'));
  CheckEquals('14/08/71', FormatDateBr(ADate, 'DD/MM/YY'));
end;

{ DTtoSTest }

procedure DTtoSTest.DataEHora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2015,01,14,12,51,49,0);
  CheckEquals('20150114125149', DTtoS(ADateTime));;
end;

procedure DTtoSTest.DataSemHora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,01,14);
  CheckEquals('20150114000000', DTtoS(ADateTime));
end;

{ DtoSTest }

procedure DtoSTest.Data;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,01,14);
  CheckEquals('20150114', DtoS(ADateTime));
end;

{ StoDTest }

procedure StoDTest.Normal;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2015,01,14,16,28,12,0);
  CheckEquals(ADateTime, StoD('20150114162812'));
end;

procedure StoDTest.DataSemHora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,01,14);
  CheckEquals(ADateTime, StoD('20150114'));
end;

procedure StoDTest.DataInvalida;
begin
  CheckEquals(0, StoD('DataInvalida'));
end;

{ StringToDateTimeDefTest }

procedure StringToDateTimeDefTest.Data;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,01,02);
  CheckEquals(ADateTime, StringToDateTimeDef('02/01/2015', Now, 'd/m/yyyy'));
end;

procedure StringToDateTimeDefTest.Hora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeTime(12,45,12,0);
  CheckEquals(ADateTime, StringToDateTimeDef('12:45:12', Now, 'h:n:s'));
end;

procedure StringToDateTimeDefTest.DataEHora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2015,01,14,12,45,12,0);
  CheckEquals(ADateTime, StringToDateTimeDef('14/01/2015 12:45:12', Now, 'd/m/yyyy h:n:s'));
end;

procedure StringToDateTimeDefTest.ValorDefault;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2015,01,14,12,45,12,0);
  // Data Errada
  CheckEquals(ADateTime, StringToDateTimeDef('30/02/2001 00:01:12', ADateTime));
  // Hora Errada
  CheckEquals(ADateTime, StringToDateTimeDef('03/02/2001 10:61:12', ADateTime));
  // Tudo Errado
  CheckEquals(ADateTime, StringToDateTimeDef('Erro', ADateTime));
end;

{ StringToDateTimeTest }

procedure StringToDateTimeTest.DataAno4Digitos;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,02,03);
  CheckEquals(ADateTime, StringToDateTime('03/02/2015', 'd/m/yyyy'));
  CheckEquals(ADateTime, StringToDateTime('03/02/2015', 'dd/mm/yyyy'));
  CheckEquals(ADateTime, StringToDateTime('03/02/2015', 'dd-mm-yyyy'));
end;

procedure StringToDateTimeTest.DataAno2Digitos;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDate(2015,02,28);
  CheckEquals(ADateTime, StringToDateTime('28/02/15', 'd/m/yyyy'));
  CheckEquals(ADateTime, StringToDateTime('28/02/15', 'dd/mm/yy'));
  CheckEquals(ADateTime, StringToDateTime('28/02/15', 'dd-mm-yy'));
end;

procedure StringToDateTimeTest.Hora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeTime(12,45,12,0);
  CheckEquals(ADateTime, StringToDateTime('12:45:12'));
end;

procedure StringToDateTimeTest.DataEHora;
var
  ADateTime: TDateTime;
begin
  ADateTime := EncodeDateTime(2015,01,14,12,45,12,0);
  CheckEquals(ADateTime, StringToDateTime('14/01/2015 12:45:12', 'd/m/yyyy h:n:s'));
end;

procedure StringToDateTimeTest.ComFormatSettingsDiferente;
var
  OldDateSeprator, OldTimeSeparator: Char ;
  ADateTime: TDateTime;
begin
  OldDateSeprator := DateSeparator ;
  OldTimeSeparator := TimeSeparator;
  try
    DateSeparator := '-';
    TimeSeparator := ';';

    ADateTime := EncodeDateTime(2015,01,14,12,45,12,0);
    CheckEquals(ADateTime, StringToDateTime('14-01-2015 12;45;12', 'd/m/yyyy h:n:s'));
    CheckEquals(ADateTime, StringToDateTime('14/01/2015 12:45:12', 'd/m/yyyy h:n:s'));
  finally
    DateSeparator := OldDateSeprator;
    TimeSeparator := OldTimeSeparator;
  end ;
end;


{ DateTimeToIso8601Test }

procedure DateTimeToIso8601Test.ConverteDataEHora_Sucesso;
var
  UmaDataHora: TDateTime;
  DataEmString: string;
begin
  UmaDataHora  := EncodeDate(2017,06,17) + EncodeTime(12,11,10,0);
  DataEmString := '2017-06-17T12:11:10.000Z';
  CheckEquals(DataEmString, DateTimeToIso8601(UmaDataHora))
end;

{ Iso8601ToDateTimeTest }

procedure Iso8601ToDateTimeTest.ConverteString_DataEHoraSemMilisegundosSemFuso_Sucesso;
var
  UmaDataHora: TDateTime;
  DataEmString: string;
begin
  UmaDataHora  := EncodeDate(2017,06,17) + EncodeTime(12,11,10,0);
  DataEmString := '2017-06-17T12:11:10.000Z';
  CheckEquals(UmaDataHora, Iso8601ToDateTime(DataEmString))
end;





initialization

  _RegisterTest('ACBrComum.ACBrUtil.DateTime', WorkingDaysBetweenTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', IncWorkingDayTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', FormatDateBrTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', FormatDateTimeBrTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', StringToDateTimeTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', StringToDateTimeDefTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', StoDTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', DtoSTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', DTtoSTest);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', DateTimeToIso8601Test);
  _RegisterTest('ACBrComum.ACBrUtil.DateTime', Iso8601ToDateTimeTest);

end.
