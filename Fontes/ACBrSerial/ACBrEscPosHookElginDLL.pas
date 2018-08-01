{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/gpl-license.php                           }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 20/07/2018:  Daniel Sim�es de Almeida
|*   Inicio do desenvolvimento
******************************************************************************}

{*
                 **** Como usar o ACBrDevice.Hook ? ****

- Configure a porta com "USB" ou "DLL"  (sem aspas)

- Voc� deve programas os eventos abaixo, na sua aplica��o
     ACBrDevice.HookAtivar,
     ACBrDevice.HookDesativar,
     ACBrDevice.HookEnviaString
     ACBrDevice.HookLeString

- Instancie a classe abaixo na sua aplica��o e use a mesma, nos eventos de Hook...
  Exemplos:

procedure TFrPosPrinterTeste.FormCreate(Sender: TObject);
begin
  FElginUSB := TElginUSBPrinter.Create;
end;

procedure TFrPosPrinterTeste.FormDestroy(Sender: TObject);
begin
  FElginUSB.Free;
end;

procedure TFrPosPrinterTeste.ACBrDeviceHookAtivar(const APort: String;
  Params: String);
begin
  FElginUSB.Open(APort);
end;

procedure TFrPosPrinterTeste.ACBrDeviceHookDesativar(const APort: String);
begin
  FElginUSB.Close;
end;

procedure TFrPosPrinterTeste.ACBrDeviceHookEnviaString(const cmd: AnsiString);
begin
  FElginUSB.WriteData(cmd);
end;

procedure TFrPosPrinterTeste.ACBrDeviceHookLeString(const NumBytes,
  ATimeOut: Integer; var Retorno: AnsiString);
begin
  Retorno := FElginUSB.ReadData;
end;

- Para acessar outras marcas/modelos por comunica��o por DLL...
  Crie uma classe semelhante a dessa Unit...

*}

unit ACBrEscPosHookElginDLL;

{$I ACBr.inc}

interface

uses
  Classes, SysUtils;

const
  LIB_NAME = 'HprtPrinter.dll' ;
  //Error Code
  E_SUCCESS = 0;
  E_BAD_HANDLE = -6;

type

  { TElginUSBPrinter }

  TElginUSBPrinter = class
  private
    xPrtPrinterCreatorW : function (printer: PPointer; model: WideString): Integer; cdecl;
    xPrtPortOpenW : function (printer: Pointer; portSetting: WideString): Integer; cdecl;
    xPrtPortClose : function (printer:Pointer): Integer; cdecl;
    xPrtDirectIO : function (printer:Pointer;
                             writeData:PByte; writeNum:integer;
                             readData:PByte; readNum:integer;
                             preadedNum:PInteger): Integer; cdecl;

    procedure UnLoadDLLFunctions;
  private
    FPrinter: Pointer;
    FPort: String;

  public
    procedure LoadDLLFunctions;

    procedure Init;
    procedure Shutdown;

    procedure Open(APort: String);
    procedure Close;
    procedure WriteData(AData: AnsiString);
    function ReadData: AnsiString;
    function Connected: Boolean;
  end;

implementation

uses
  ACBrUtil;

procedure FunctionDetectLib(FuncName : String ;
  var LibPointer : Pointer) ;
var
  sLibName: String;
begin
  if not FunctionDetect( LIB_NAME, FuncName, LibPointer) then
  begin
     LibPointer := NIL ;
     raise Exception.Create( Format(ACBrStr('Erro ao carregar a fun��o: %s na Biblioteca: %s'), [FuncName,sLibName]) ) ;
  end ;
end ;

procedure TElginUSBPrinter.Init;
var
  errorNo: Integer;
  ModelName: AnsiString;
begin
  if (FPrinter <> Nil) then
    Exit;

  LoadDLLFunctions;

  FPrinter := Nil;
  FPort := '';
  ModelName := 'i7';

  errorNo := xPrtPrinterCreatorW(@FPrinter, WideString(ModelName));
  if (errorNo <> E_SUCCESS) then
    raise Exception.Create('Erro ao criar a impressora Elgin: '+IntToStr(errorNo));
end;

procedure TElginUSBPrinter.Shutdown;
begin
  UnLoadDLLFunctions;
  FPrinter := Nil;
end;

procedure TElginUSBPrinter.Open(APort: String);
var
  errorNo: Integer;
begin
  Init;

  if (UpperCase(APort) = 'DLL') then
    APort := 'USB';

  FPort := APort;
  errorNo := xPrtPortOpenW(FPrinter, WideString(FPort));
  if (errorNo <> E_SUCCESS) then
    raise Exception.Create('Erro ao Abrir a impressora Elgin em: '+FPort);
end;

procedure TElginUSBPrinter.Close;
var
  errorNo: Integer;
begin
  if (FPrinter = Nil) then
    Exit;

  errorNo := xPrtPortClose(FPrinter);
  if (errorNo <> E_SUCCESS) then
    raise Exception.Create('Erro ao Fechar a Porta da impressora Elgin');

  FPort := '';
end;

procedure TElginUSBPrinter.WriteData(AData: AnsiString);
begin
  xPrtDirectIO(FPrinter, PByte(AData), Length(AData), Nil, 0, Nil);
end;

function TElginUSBPrinter.ReadData: AnsiString;
var
  ReadNum: Integer;
begin
  Result := Space(1024);
  ReadNum := 0;
  xPrtDirectIO(FPrinter, Nil, 0, PByte(Result), 1024, @ReadNum);
  SetLength(Result, ReadNum);
end;

function TElginUSBPrinter.Connected: Boolean;
begin
  Result := (FPrinter <> Nil);
end;

procedure TElginUSBPrinter.LoadDLLFunctions;
begin
  FunctionDetectLib( 'PrtPrinterCreatorW', @xPrtPrinterCreatorW );
  FunctionDetectLib( 'PrtPortOpenW', @xPrtPortOpenW );
  FunctionDetectLib( 'PrtPortClose', @xPrtPortClose );
  FunctionDetectLib( 'PrtDirectIO', @xPrtDirectIO );
end;

procedure TElginUSBPrinter.UnLoadDLLFunctions;
begin
  UnLoadLibrary( LIB_NAME );

  xPrtPrinterCreatorW := Nil;
  xPrtPortOpenW := Nil;
end;

end.

