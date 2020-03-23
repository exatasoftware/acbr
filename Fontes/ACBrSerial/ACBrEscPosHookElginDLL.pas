{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrEscPosHookElginDLL;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils,
  ACBrEscPosHook;

const
  ELGIN_LIB_NAME = 'HprtPrinter.dll' ;
  ELGIN_NAME = 'ELGIN';
  //Error Code
  E_SUCCESS = 0;
  E_BAD_HANDLE = -6;

resourcestring
  CERRO_OBJ_PRINT = 'Erro ao criar inst�ncia do Objeto da impressora ELGIN: %d';

type

  { TElginUSBPrinter }

  TElginUSBPrinter = class(TACBrPosPrinterHook)
  private
    FPrinter: Pointer;

    xPrtPrinterCreatorW : function (printer: PPointer; model: WideString): Integer; cdecl;
    xPrtPortOpenW : function (printer: Pointer; portSetting: WideString): Integer; cdecl;
    xPrtPortClose : function (printer:Pointer): Integer; cdecl;
    xPrtDirectIO : function (printer:Pointer;
                             writeData:PByte; writeNum:integer;
                             readData:PByte; readNum:integer;
                             preadedNum:PInteger): Integer; cdecl;

    procedure CreateElginPrinter;
  protected
    function GetInitialized: Boolean; override;

    procedure LoadLibFunctions; override;
    procedure UnLoadLibFunctions; override;
  public
    constructor Create; override;
    procedure Init; override;
    procedure Shutdown; override;

    procedure Open(const APort: String); override;
    procedure Close; override;
    procedure WriteData(const AData: AnsiString); override;
    function ReadData(const NumBytes, ATimeOut: Integer): AnsiString; override;

    class function CanInitilize: Boolean; override;
    class function Brand: String; override;
  end;

implementation

uses
  ACBrUtil;

constructor TElginUSBPrinter.Create;
begin
  inherited Create;

  fpPrinterName := ELGIN_NAME;
  fpLibName := ELGIN_LIB_NAME;
end;

procedure TElginUSBPrinter.Init;
begin
  if Initialized then
    Exit;

  inherited;

  try
    CreateElginPrinter;
  except
    fpInitialized := False;
    raise;
  end;
end;

procedure TElginUSBPrinter.CreateElginPrinter;
var
  errorNo: Integer;
  ModelName: AnsiString;
begin
  FPrinter := Nil;
  ModelName := 'i7';

  errorNo := xPrtPrinterCreatorW(@FPrinter, WideString(ModelName));
  if (errorNo <> E_SUCCESS) then
    raise EACBrPosPrinterHook.CreateFmt(CERRO_OBJ_PRINT, [errorNo]);
end;

procedure TElginUSBPrinter.Shutdown;
begin
  inherited;
  FPrinter := Nil;
end;

procedure TElginUSBPrinter.Open(const APort: String);
var
  errorNo: Integer;
begin
  if Connected then
    Exit;

  inherited Open(APort);

  try
    errorNo := xPrtPortOpenW(FPrinter, WideString(fpPort));
    if (errorNo <> E_SUCCESS) then
      raise Exception.CreateFmt(CERROR_OPEN, [fpPort, fpPrinterName]);
  except
    fpConnected := False;
    fpPort := '';
    raise;
  end;
end;

procedure TElginUSBPrinter.Close;
var
  errorNo: Integer;
begin
  if not Connected then
    Exit;

  errorNo := xPrtPortClose(FPrinter);
  if (errorNo <> E_SUCCESS) then
    raise Exception.CreateFmt(CERROR_CLOSE, [fpPort, fpPrinterName]);

  inherited Close;
end;

procedure TElginUSBPrinter.WriteData(const AData: AnsiString);
begin
  CheckConnected;
  xPrtDirectIO(FPrinter, PByte(AData), Length(AData), Nil, 0, Nil);
end;

function TElginUSBPrinter.ReadData(const NumBytes, ATimeOut: Integer): AnsiString;
var
  ReadNum: Integer;
begin
  CheckConnected;
  Result := Space(1024);
  ReadNum := 0;
  xPrtDirectIO(FPrinter, Nil, 0, PByte(Result), 1024, @ReadNum);
  SetLength(Result, ReadNum);
end;

class function TElginUSBPrinter.CanInitilize: Boolean;
begin
  Result := FileExists(ApplicationPath + ELGIN_LIB_NAME);
end;

class function TElginUSBPrinter.Brand: String;
begin
  Result := ELGIN_NAME;
end;

function TElginUSBPrinter.GetInitialized: Boolean;
begin
  Result := (FPrinter <> Nil);
end;

procedure TElginUSBPrinter.LoadLibFunctions;
begin
  if Initialized then
    Exit;

  FunctionDetectLib( 'PrtPrinterCreatorW', @xPrtPrinterCreatorW );
  FunctionDetectLib( 'PrtPortOpenW', @xPrtPortOpenW );
  FunctionDetectLib( 'PrtPortClose', @xPrtPortClose );
  FunctionDetectLib( 'PrtDirectIO', @xPrtDirectIO );
end;

procedure TElginUSBPrinter.UnLoadLibFunctions;
begin
  inherited;
  xPrtPrinterCreatorW := Nil;
  xPrtPortOpenW := Nil;
  xPrtPortClose := Nil;
  xPrtDirectIO := Nil;
end;

initialization
  RegisterHook(TElginUSBPrinter);

end.

