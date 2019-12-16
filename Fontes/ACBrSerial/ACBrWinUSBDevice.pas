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
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}
{******************************************************************************
|* 13/12/2019: Primeira Versao: Daniel Simoes de Almeida
|* Fontes:
|* //https://web.archive.org/web/20130126085547/http://peter.skarpetis.com/wiki/index.php/Usbprint.sys
******************************************************************************}

{$I ACBr.inc}

unit ACBrWinUSBDevice;

interface

uses
  Classes, SysUtils, Windows, IniFiles, contnrs
  {$IfDef FPC}
   ,dynlibs
  {$EndIf}
  ,ACBrUtil;

const
  CUSBIDDataBaseResourceName = 'ACBrUSBID';
  CUSBIDDataBaseFileName = 'ACBrUSBID.ini';
  CSecVendors = 'Vendors';

resourcestring
  sErrACBrWinUSBInvalidID = '%S inv�lido [%s]';
  sErrACBrWinUSBBufferSize = '%s: Falha ao obter Tamanho do Buffer. Erro: %s';
  sErrACBrWinUSBBufferRead = '%s: Falha ao Ler Buffer. Erro: %s';
  sErrACBrWinUSBDeviceOutOfRange = 'Device %d n�o existe';

type

  { TACBrUSBIDDataBase - https://www.the-sz.com/products/usbid/index.php }

  TACBrUSBIDDataBase = class
  private
    FIni: TMemIniFile;
    FFileName: String;
    FResourceName: String;
    FLoaded: Boolean;
    function LoadFromFile: Boolean;
    function LoadFromResource: Boolean;
    procedure SetFileName(AValue: String);
  public
    constructor Create(ADataBaseFileName: String = ''; AResourceName: String = '');
    destructor Destroy; override;
    procedure Clear;
    function Load: Boolean;

    property FileName: String read FFileName write SetFileName;
    property ResourceName: String read FResourceName;
    function FindDeviceByID(AVendorID, AProductID: String; out AVendorName: String;
      out AProductModel: String; out AACBrProtocol: Integer): Boolean;
  end;

  TACBrUSBWinDeviceList = class;

  { TACBrUSBWinDevice }

  TACBrUSBWinDevice = class
  private
    FACBrProtocol: Integer;
    FFrendlyName: String;
    FGUID: String;
    FHardwareID: String;
    FOwner: TACBrUSBWinDeviceList;
    FDeviceInterface: String;
    FProductID, FProductModel: String;
    FUSBPort: String;
    FVendorID, FVendorName: String;
    FDescriptionsLoaded: Boolean;

    function GetDeviceName: String;
    function GetProductModel: String;
    function GetVendorName: String;
    procedure SetProductID(AValue: String);
    procedure SetVendorID(AValue: String);
    procedure LoadDescriptions;
  public
    constructor Create(AOwner: TACBrUSBWinDeviceList);
    procedure Clear;

    property DeviceName: String read GetDeviceName;
    property VendorID: String read FVendorID write SetVendorID;
    property VendorName: String read GetVendorName;
    property ProductID: String read FProductID write SetProductID;
    property ProductModel: String read GetProductModel;
    property DeviceInterface: String read FDeviceInterface write FDeviceInterface;
    property USBPort: String read FUSBPort write FUSBPort;
    property GUID: String read FGUID write FGUID;
    property FrendlyName: String read FFrendlyName write FFrendlyName;
    property HardwareID: String read FHardwareID write FHardwareID;
    property ACBrProtocol: Integer read FACBrProtocol write FACBrProtocol;
  end;

  { TACBrUSBWinDeviceList }

  TACBrUSBWinDeviceList = class(TObjectList)
  private
    FDataBase: TACBrUSBIDDataBase;

    function GetItem(Index: Integer): TACBrUSBWinDevice;
  public
    constructor Create(ADataBaseFileName: String = '');
    destructor Destroy; override;

    function New(AVendorID, AProductID: String): TACBrUSBWinDevice;
    property Items[Index: Integer]: TACBrUSBWinDevice read GetItem;
    property Database: TACBrUSBIDDataBase read FDataBase;
  end;


{ SetupAPI Bind }
const
  CSetupAPILibName = 'SetupApi.dll';

  GUID_DEVCLASS_NET : TGUID = '{4D36E972-E325-11CE-BFC1-08002BE10318}';
  GUID_DEVCLASS_PORT : TGUID = '{4D36E978-E325-11CE-BFC1-08002BE10318}';
  GUID_DEVINTERFACE_USBPRINT: TGUID = '{28D78FAD-5A12-11D1-AE5B-0000F803A8C2}';

  DIGCF_PRESENT = $00000002;
  DIGCF_DEVICEINTERFACE = $00000010;

  SPDRP_DEVICEDESC           = $00000000; // DeviceDesc (R/W)
  SPDRP_HARDWAREID           = $00000001; // HardwareID (R/W)
  SPDRP_CLASS                = $00000007; // Class (R--tied to ClassGUID)
  SPDRP_CLASSGUID            = $00000008; // ClassGUID (R/W)
  SPDRP_DRIVER               = $00000009; // Driver (R/W)
  SPDRP_FRIENDLYNAME         = $0000000C; // FriendlyName (R/W)
  SPDRP_LOCATION_INFORMATION = $0000000D; // LocationInformation (R/W)

type
  HDEVINFO = Pointer;

  PSPDevInfoData = ^TSPDevInfoData;

  SP_DEVINFO_DATA = packed record
    cbSize: NativeUInt;
    ClassGuid: TGUID;
    DevInst: DWORD;
    Reserved: ULONG_PTR;
  end;
  TSPDevInfoData = SP_DEVINFO_DATA;

  PSPDeviceInterfaceData = ^TSPDeviceInterfaceData;
  SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: NativeUInt;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;
  TSPDeviceInterfaceData = SP_DEVICE_INTERFACE_DATA;

  PSPDeviceInterfaceDetailData = ^TSPDeviceInterfaceDetailData;
  {$IfDef UNICODE}
   SP_DEVICE_INTERFACE_DETAIL_DATA_W = packed record
     cbSize: DWORD;
     DevicePath: array [0..ANYSIZE_ARRAY - 1] of WideChar;
   end;
   TSPDeviceInterfaceDetailData = SP_DEVICE_INTERFACE_DETAIL_DATA_W;
  {$Else}
   SP_DEVICE_INTERFACE_DETAIL_DATA_A = packed record
     cbSize: DWORD;
     DevicePath: array [0..ANYSIZE_ARRAY - 1] of AnsiChar;
   end;
   TSPDeviceInterfaceDetailData = SP_DEVICE_INTERFACE_DETAIL_DATA_A;
  {$EndIf}

  { TACBrUSBWinSetupAPI }

  TACBrUSBWinSetupAPI = class
  private
    FLoaded: Boolean;
    FDeviceList: TACBrUSBWinDeviceList;
    FUSBHandle: THandle;
    FDeviceIndex: Integer;

    xSetupDiEnumDeviceInfo: function(DeviceInfoSet: HDEVINFO; MemberIndex: DWORD;
      var DeviceInfoData: TSPDevInfoData): BOOL; stdcall;

    xSetupDiGetClassDevsA : function(ClassGuid: PGUID; const AEnumerator: PChar;
      hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall;

    xSetupDiGetDeviceRegistryProperty : function(DeviceInfoSet: HDEVINFO;
      const DeviceInfoData: TSPDevInfoData; Property_: DWORD;
      var PropertyRegDataType: DWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
      var RequiredSize: DWORD): BOOL; stdcall;

    xSetupDiEnumDeviceInterfaces: function(DeviceInfoSet: HDEVINFO;
      DeviceInfoData: PSPDevInfoData; const InterfaceClassGuid: TGUID;
      MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): BOOL; stdcall;

    xSetupDiGetDeviceInterfaceDetail: function(DeviceInfoSet: HDEVINFO;
      DeviceInterfaceData: PSPDeviceInterfaceData;
      DeviceInterfaceDetailData: PSPDeviceInterfaceDetailData;
      DeviceInterfaceDetailDataSize: DWORD; var RequiredSize: DWORD;
      Device: PSPDevInfoData): BOOL; stdcall;

    xSetupDiDestroyDeviceInfoList: function(DeviceInfoSet: HDEVINFO): BOOL; stdcall;

  private
    procedure ExtractVidAndPid( ADeviceInterface: String; out AVid: String; out APid: String);
    function GetActive: Boolean;
    function GetDataBase: TACBrUSBIDDataBase;

    function GetDeviceRegistryPropertyString(DevInfo: HDEVINFO;
      DeviceInfoData: TSPDevInfoData; Prop: DWORD): AnsiString;
    procedure SetDeviceIndex(AValue: Integer);

  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadAPI;
    procedure UnLoadAPI;

    property Loaded: Boolean read FLoaded;
    property DeviceList: TACBrUSBWinDeviceList read FDeviceList;
    property DeviceIndex: Integer read FDeviceIndex write SetDeviceIndex;
    property DataBase: TACBrUSBIDDataBase read GetDataBase;

    property USBHandle: THandle read FUSBHandle;
    property Active: Boolean read GetActive;

    function FindUSBPrinters(ADeviceList: TACBrUSBWinDeviceList = Nil): Integer;
    function FindUSBDevicesByGUID(AGUID: TGUID; ADeviceList: TACBrUSBWinDeviceList = Nil): Integer;

    procedure Open(ADeviceIndex: Integer);
    procedure Close;

  end;

implementation

uses
  Types,
  synautil,
  ACBrConsts;

{$IFDEF FPC}
 {$R ACBrUSBID.rc}
{$ELSE}
 {$R ACBrUSBID.res}
{$ENDIF}


{ TACBrUSBIDDataBase }

procedure TACBrUSBIDDataBase.SetFileName(AValue: String);
begin
  if (FFileName = AValue) then
    Exit;

  if (AValue <> '') and (not FileExists(AValue)) then
    raise Exception.CreateFmt(ACBrStr(cACBrArquivoNaoEncontrado), [AValue]);

  FFileName := AValue;
  Load;
end;

function TACBrUSBIDDataBase.LoadFromFile: Boolean;
var
  SL: TStringList;
begin
  Result := False;
  if (FFileName <> '') and FileExists(FFileName) then
  begin
    FIni.Free;
    FIni.Create(FFileName);

    SL := TStringList.Create;
    try
      SL.LoadFromFile(FFileName);
      FIni.SetStrings(SL);
      Result := True;
    finally
      SL.Free;
    end;
  end;
end;

function TACBrUSBIDDataBase.LoadFromResource: Boolean;
var
  RS: TResourceStream;
  SL: TStringList;
begin
  Result := False;
  RS := TResourceStream.Create(HInstance, FResourceName, Windows.RT_RCDATA);
  SL := TStringList.Create;
  try
    RS.Position := 0;
    SL.LoadFromStream(RS);
    FIni.SetStrings(SL);
    Result := True;
  finally
    RS.Free;
    SL.Free;
  end;
end;

constructor TACBrUSBIDDataBase.Create(ADataBaseFileName: String; AResourceName: String);
begin
  inherited Create;
  FIni := TMemIniFile.Create('');

  if ADataBaseFileName = '' then
    FFileName := ApplicationPath + CUSBIDDataBaseFileName
  else
    FFileName := ADataBaseFileName;

  if AResourceName = '' then
    FResourceName := CUSBIDDataBaseResourceName
  else
    FResourceName := AResourceName;

  Clear;
end;

destructor TACBrUSBIDDataBase.Destroy;
begin
  FIni.Free;
  inherited Destroy;
end;

procedure TACBrUSBIDDataBase.Clear;
begin
  FLoaded := False;
  FIni.Clear;
end;

function TACBrUSBIDDataBase.Load: Boolean;
begin
  Clear;
  Result := LoadFromFile or LoadFromResource;
end;

function TACBrUSBIDDataBase.FindDeviceByID(AVendorID, AProductID: String; out
  AVendorName: String; out AProductModel: String; out AACBrProtocol: Integer): Boolean;

  procedure GetACBrProtocol( var ADescription: String; out ACBrProtocol: Integer);
  var
    p: Integer;
  begin
    p := pos(';', ADescription);
    if (p > 0) then
    begin
      ACBrProtocol := StrToIntDef(copy(ADescription, P+1, Length(ADescription)), 0);
      ADescription := copy(ADescription,1, p-1);
    end
    else
      ACBrProtocol := 0;
  end;

var
  VendorProtocol, ModelProtocol: Integer;
begin
  Result := False;
  AVendorName := '';
  AProductModel := '';
  AACBrProtocol := 0;

  if not StrIsHexa(AVendorID) then
    raise Exception.CreateFmt(ACBrStr(sErrACBrWinUSBInvalidID), ['VendorID', AVendorID]);

  if not StrIsHexa(AProductID) then
    raise Exception.CreateFmt(ACBrStr(sErrACBrWinUSBInvalidID), ['ProductID', AProductID]);

  if not FLoaded then
    Load;

  AVendorName := FIni.ReadString(CSecVendors, AVendorID, '');
  AProductModel := FIni.ReadString(AVendorID, AProductID, '');
  GetACBrProtocol(AVendorName, VendorProtocol);
  GetACBrProtocol(AProductModel, ModelProtocol);
  if (ModelProtocol = 0) then
    AACBrProtocol := VendorProtocol
  else
    AACBrProtocol := ModelProtocol;

  Result := ((AVendorName + AProductModel) <> '');
end;


{ TACBrUSBWinDevice }

constructor TACBrUSBWinDevice.Create(AOwner: TACBrUSBWinDeviceList);
begin
  inherited Create;

  FOwner := AOwner;
  Clear;
end;

procedure TACBrUSBWinDevice.Clear;
begin
  FVendorID := '';
  FProductID := '';
  FVendorName := '';
  FProductModel := '';
  FDeviceInterface := '';
  FUSBPort := '';
  FGUID := '';
  FFrendlyName := '';
  FHardwareID := '';
  FACBrProtocol := 0;
  FDescriptionsLoaded := False;
end;

function TACBrUSBWinDevice.GetDeviceName: String;
begin
  Result := IfEmptyThen( FrendlyName,
                         IfEmptyThen(VendorName, VendorID) + ' - ' +
                         IfEmptyThen(ProductModel, ProductID));
end;

function TACBrUSBWinDevice.GetProductModel: String;
begin
  if not FDescriptionsLoaded then
    LoadDescriptions;

  Result := FProductModel;
end;

function TACBrUSBWinDevice.GetVendorName: String;
begin
  if not FDescriptionsLoaded then
    LoadDescriptions;

  Result := FVendorName;
end;

procedure TACBrUSBWinDevice.SetProductID(AValue: String);
begin
  if FProductID = AValue then
    Exit;
  if not StrIsHexa(AValue) then
    raise Exception.CreateFmt(ACBrStr(sErrACBrWinUSBInvalidID), ['ProductID', AValue]);

  FProductID := AValue;
end;

procedure TACBrUSBWinDevice.SetVendorID(AValue: String);
begin
  if FVendorID = AValue then
    Exit;
  if not StrIsHexa(AValue) then
    raise Exception.CreateFmt(ACBrStr(sErrACBrWinUSBInvalidID), ['VendorID', AValue]);

  FVendorID := AValue;
end;

procedure TACBrUSBWinDevice.LoadDescriptions;
begin
  FVendorName := '';
  FProductModel := '';
  FOwner.Database.FindDeviceByID(FVendorID, FProductID, FVendorName, FProductModel, FACBrProtocol);
  FDescriptionsLoaded := True;
end;


{ TACBrUSBWinDeviceList }

function TACBrUSBWinDeviceList.GetItem(Index: Integer): TACBrUSBWinDevice;
begin
  Result := TACBrUSBWinDevice(inherited Items[Index]);
end;

constructor TACBrUSBWinDeviceList.Create(ADataBaseFileName: String);
begin
  inherited Create(True);
  FDataBase := TACBrUSBIDDataBase.Create(ADataBaseFileName);
end;

destructor TACBrUSBWinDeviceList.Destroy;
begin
  FDataBase.Free;
  inherited Destroy;
end;

function TACBrUSBWinDeviceList.New(AVendorID, AProductID: String
  ): TACBrUSBWinDevice;
begin
  Result := TACBrUSBWinDevice.Create(Self);
  try
    Result.VendorID := AVendorID;
    Result.ProductID := AProductID;
    inherited Add(Result);
  except
    Result.Free;
    raise;
  end;
end;


{ TACBrUSBWinSetupAPI }

constructor TACBrUSBWinSetupAPI.Create;
begin
  inherited Create;

  FDeviceList := TACBrUSBWinDeviceList.Create();
  FLoaded := False;
  FUSBHandle := INVALID_HANDLE_VALUE;

  xSetupDiEnumDeviceInfo := Nil;
  xSetupDiGetClassDevsA := Nil;
  xSetupDiGetDeviceRegistryProperty := Nil;
  xSetupDiEnumDeviceInterfaces := Nil;
  xSetupDiGetDeviceInterfaceDetail := Nil;
  xSetupDiDestroyDeviceInfoList := Nil;
end;

destructor TACBrUSBWinSetupAPI.Destroy;
begin
  UnLoadAPI;
  inherited Destroy;
end;

procedure TACBrUSBWinSetupAPI.LoadAPI;
const
  {$IfDef UNICODE}
   ApiSuffix = 'W';
  {$Else}
   ApiSuffix = 'A';
  {$EndIf}

begin
  if FLoaded then Exit;

  FunctionDetect(CSetupAPILibName, 'SetupDiEnumDeviceInfo', @xSetupDiEnumDeviceInfo);
  FunctionDetect(CSetupAPILibName, 'SetupDiGetClassDevsA', @xSetupDiGetClassDevsA);
  FunctionDetect(CSetupAPILibName, 'SetupDiGetDeviceRegistryProperty'+ApiSuffix, @xSetupDiGetDeviceRegistryProperty);
  FunctionDetect( CSetupAPILibName, 'SetupDiEnumDeviceInterfaces', @xSetupDiEnumDeviceInterfaces);
  FunctionDetect( CSetupAPILibName, 'SetupDiGetDeviceInterfaceDetail'+ApiSuffix, @xSetupDiGetDeviceInterfaceDetail);
  FunctionDetect( CSetupAPILibName, 'SetupDiDestroyDeviceInfoList', @xSetupDiDestroyDeviceInfoList);

  FLoaded := True;
end;

procedure TACBrUSBWinSetupAPI.UnLoadAPI;
begin
  if not FLoaded then Exit;

  UnLoadLibrary( CSetupAPILibName );

  xSetupDiEnumDeviceInfo := Nil;
  xSetupDiGetClassDevsA := Nil;
  xSetupDiGetDeviceRegistryProperty := Nil;
  xSetupDiEnumDeviceInterfaces := Nil;
  xSetupDiGetDeviceInterfaceDetail := Nil;
  xSetupDiDestroyDeviceInfoList := Nil;

  FLoaded := False;
end;

procedure TACBrUSBWinSetupAPI.ExtractVidAndPid(ADeviceInterface: String; out
  AVid: String; out APid: String);
var
  lowInt: String;
  p: Integer;
begin
  AVid := '';
  APid := '';
  lowInt := LowerCase(ADeviceInterface);
  p := pos('vid_', lowInt);
  if (p > 0) then
    AVid := copy(ADeviceInterface, p+4, 4);

  p := pos('pid_', lowInt);
  if (p > 0) then
    APid := copy(ADeviceInterface, p+4, 4);
end;

function TACBrUSBWinSetupAPI.GetActive: Boolean;
begin
  Result := (FUSBHandle <> INVALID_HANDLE_VALUE);
end;

function TACBrUSBWinSetupAPI.GetDeviceRegistryPropertyString(DevInfo: HDEVINFO;
  DeviceInfoData: TSPDevInfoData; Prop: DWORD): AnsiString;
var
  Buffer: PByte;
  RequiredSize, PropertyRegDataTye: DWORD;
  {$IfDef UNICODE}
   AResult: WideString;
  {$Else}
   AResult: AnsiString;
  {$EndIf}
  Err: DWORD;
begin
  // Obtendo o tamanho do Buffer em "RequiredSize"
  PropertyRegDataTye := 0;
  RequiredSize := 0;
  xSetupDiGetDeviceRegistryProperty( DevInfo, DeviceInfoData, Prop,
                                     PropertyRegDataTye, Nil, 0, RequiredSize);
  Err := GetLastError;
  if (Err <> ERROR_INSUFFICIENT_BUFFER) or (RequiredSize < 1) then
    raise Exception.CreateFmt( sErrACBrWinUSBBufferSize, ['SetupDiGetDeviceRegistryProperty',  GetLastErrorAsHexaStr(Err)] );

  Buffer := AllocMem(RequiredSize);
  try
    if not xSetupDiGetDeviceRegistryProperty( DevInfo, DeviceInfoData, Prop,
                                              PropertyRegDataTye, Buffer,
                                              RequiredSize, RequiredSize) then
      raise Exception.CreateFmt( sErrACBrWinUSBBufferRead, ['SetupDiGetDeviceRegistryProperty',  GetLastErrorAsHexaStr] );

    {$IfDef UNICODE}
     SetLength(AResult, Trunc(RequiredSize/2)-1);
    {$Else}
     SetLength(AResult, RequiredSize-1);
    {$EndIf}
    Move(Buffer^, AResult[1], RequiredSize-1);

    Result := Trim(String(AResult));
  finally
    Freemem(Buffer);
  end;
end;

procedure TACBrUSBWinSetupAPI.SetDeviceIndex(AValue: Integer);
begin
  if FDeviceIndex = AValue then Exit;

  if AValue < 0 then
    FDeviceIndex := -1
  else if (AValue > FDeviceList.Count-1) then
    raise Exception.CreateFmt(sErrACBrWinUSBDeviceOutOfRange, [AValue] );

  Close;
  FDeviceIndex := AValue;
end;

function TACBrUSBWinSetupAPI.GetDataBase: TACBrUSBIDDataBase;
begin
  Result := FDeviceList.Database;
end;

function TACBrUSBWinSetupAPI.FindUSBPrinters(ADeviceList: TACBrUSBWinDeviceList
  ): Integer;
var
  ADeviceListToAdd: TACBrUSBWinDeviceList;
begin
  if (ADeviceList <> Nil) then
    ADeviceListToAdd := ADeviceList
  else
    ADeviceListToAdd := FDeviceList;

  ADeviceListToAdd.Clear;

  Result := FindUSBDevicesByGUID( GUID_DEVINTERFACE_USBPRINT, ADeviceListToAdd);
  Result := Result + FindUSBDevicesByGUID( GUID_DEVCLASS_PORT, ADeviceListToAdd);
end;

function TACBrUSBWinSetupAPI.FindUSBDevicesByGUID(AGUID: TGUID;
  ADeviceList: TACBrUSBWinDeviceList): Integer;
var
  DevInfo: HDEVINFO;
  DeviceInterface: TSPDeviceInterfaceData;
  DeviceInfoData: TSPDevInfoData;
  InterfaceDetail: PSPDeviceInterfaceDetailData;
  MemberIndex, RequiredSize: DWORD;
  InterfaceName: {$IfDef UNICODE}WideString{$Else}AnsiString{$EndIf};
  DevInterface, DevClassGUID, DevLocation, DevFrendlyName, DevHardwareID,
    VendorId, ProductId: String;
  ADevice: TACBrUSBWinDevice;
  ADeviceListToAdd: TACBrUSBWinDeviceList;

  function TryGetDeviceRegistryPropertyString(AProp: Cardinal): String;
  begin
    try
      Result := String( GetDeviceRegistryPropertyString(DevInfo, DeviceInfoData, AProp) );
    except
      Result := '';
    end;
  end;

begin
  LoadAPI;
  Result := -1;
  if (ADeviceList <> Nil) then
    ADeviceListToAdd := ADeviceList
  else
    ADeviceListToAdd := FDeviceList;

  DevInfo := xSetupDiGetClassDevsA(@AGUID, nil, 0, DIGCF_PRESENT or DIGCF_DEVICEINTERFACE);
  if (DevInfo = Pointer(INVALID_HANDLE_VALUE)) then
    Exit;

  try
    MemberIndex := 0;
    Result := 0;
    DeviceInterface.cbSize := SizeOf(TSPDeviceInterfaceData);
    while (xSetupDiEnumDeviceInterfaces(DevInfo, Nil, AGUID, MemberIndex, DeviceInterface)) do
    begin
      DevInterface := '';

      RequiredSize := 0;
      xSetupDiGetDeviceInterfaceDetail(DevInfo, @DeviceInterface, Nil, 0, RequiredSize, Nil);
      if (GetLastError = ERROR_INSUFFICIENT_BUFFER) and (RequiredSize > 0) then
      begin
        InterfaceDetail := AllocMem(RequiredSize);
        try
          InterfaceDetail^.cbSize := SizeOf(TSPDeviceInterfaceDetailData);
          DeviceInfoData.cbSize := SizeOf(TSPDevInfoData);
          if xSetupDiGetDeviceInterfaceDetail(DevInfo, @DeviceInterface, InterfaceDetail, RequiredSize, RequiredSize, @DeviceInfoData) then
          begin
            {$IfDef UNICODE}
             SetLength(InterfaceName, Trunc(RequiredSize/2)-1);
            {$Else}
             SetLength(InterfaceName, RequiredSize-1);
            {$EndIf}

            Move(InterfaceDetail^.DevicePath[0], InterfaceName[1], RequiredSize-1);
            DevInterface := Trim(String(InterfaceName));
          end;
        finally
          Freemem(InterfaceDetail);
        end;
      end;

      if (DevInterface <> '') then
      begin
        ExtractVidAndPid( DevInterface, VendorId, ProductId);
        if (VendorId <> '') and (ProductId <> '') then
        begin
          DevClassGUID := TryGetDeviceRegistryPropertyString(SPDRP_CLASSGUID);
          DevLocation := TryGetDeviceRegistryPropertyString(SPDRP_LOCATION_INFORMATION);
          DevHardwareID := TryGetDeviceRegistryPropertyString(SPDRP_HARDWAREID);
          DevFrendlyName := TryGetDeviceRegistryPropertyString(SPDRP_FRIENDLYNAME);

          ADevice := ADeviceListToAdd.New(VendorId, ProductId);
          ADevice.DeviceInterface := DevInterface;
          ADevice.USBPort := DevLocation;
          ADevice.GUID := DevClassGUID;
          ADevice.FrendlyName := DevFrendlyName;
          ADevice.HardwareID := DevHardwareID;
          Inc( Result );
        end;
      end;

      Inc(MemberIndex);
    end;
  finally
    xSetupDiDestroyDeviceInfoList(DevInfo);
  end;
end;

procedure TACBrUSBWinSetupAPI.Open(ADeviceIndex: Integer);
var
  APort: String;
begin
  DeviceIndex := ADeviceIndex;
  APort := FDeviceList.Items[DeviceIndex].DeviceInterface;

  FUSBHandle := CreateFile( LPCSTR(APort),
                            GENERIC_WRITE or GENERIC_READ,
                            FILE_SHARE_READ,
                            Nil,
                            OPEN_ALWAYS,
                            FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN or FILE_FLAG_OVERLAPPED,
                            0);
end;

procedure TACBrUSBWinSetupAPI.Close;
begin
  if Active then
    CloseHandle(FUSBHandle);

  FUSBHandle := INVALID_HANDLE_VALUE;
end;


end.
