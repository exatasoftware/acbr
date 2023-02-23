{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{																			   }
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

unit ACBrBALAndroidFr;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Actions,
  System.ImageList,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.TabControl,
  FMX.StdCtrls,
  FMX.Gestures,
  FMX.ImgList,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Edit,
  FMX.EditBox,
  FMX.SpinBox,
  FMX.Layouts,
  FMX.ListBox,
  FMX.ActnList,
  FMX.VirtualKeyboard,
  FMX.Controls.Presentation,
  FMX.Memo.Types,
  ACBrBase, ACBrBAL;

type
  TBALAndroidTesteForm = class(TForm)
    GestureManager1: TGestureManager;
    tabsPrincipal: TTabControl;
    tabConfig: TTabItem;
    ToolBar1: TToolBar;
    lblTituloConfig: TLabel;
    tabTeste: TTabItem;
    ToolBar2: TToolBar;
    lblTituloTestes: TLabel;
    btnBack: TSpeedButton;
    ListBox1: TListBox;
    lbPortas: TListBoxItem;
    lbModelos: TListBoxItem;
    cbxPorta: TComboBox;
    btnProcurarBth: TCornerButton;
    ListBoxGroupHeader2: TListBoxGroupHeader;
    Layout1: TLayout;
    SpeedButton1: TSpeedButton;
    btnAtivar: TCornerButton;
    lbBotoes: TListBoxItem;
    GridPanelLayout2: TGridPanelLayout;
    btLerConfig: TCornerButton;
    btSalvarConfig: TCornerButton;
    GridPanelLayout4: TGridPanelLayout;
    btnImprimir: TCornerButton;
    btnLimpar: TCornerButton;
    ImageList1: TImageList;
    StyleBook1: TStyleBook;
    chbTodasBth: TCheckBox;
    cbxModelo: TComboBox;
    ListBoxGroupHeader5: TListBoxGroupHeader;
    ACBrBAL1: TACBrBAL;
    ListBoxGroupHeader1: TListBoxGroupHeader;
    lbSerialConfig: TListBoxItem;
    GridPanelLayout1: TGridPanelLayout;
    Layout2: TLayout;
    cbxDataBits: TComboBox;
    Label1: TLabel;
    Layout3: TLayout;
    cbxBaudRate: TComboBox;
    Label2: TLabel;
    Layout4: TLayout;
    cbxParity: TComboBox;
    Label3: TLabel;
    Layout5: TLayout;
    cbxStopBits: TComboBox;
    S: TLabel;
    Layout6: TLayout;
    cbxHandshaking: TComboBox;
    Label5: TLabel;
    Layout7: TLayout;
    Label4: TLabel;
    sbTimeOut: TSpinBox;
    GridPanelLayout3: TGridPanelLayout;
    Layout8: TLayout;
    Label6: TLabel;
    mMsgs: TMemo;
    Layout9: TLayout;
    Label7: TLabel;
    mLog: TMemo;
    procedure GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure btnAtivarClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnProcurarBthClick(Sender: TObject);
    procedure btLerConfigClick(Sender: TObject);
    procedure btSalvarConfigClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure ACBrBAL1LePeso(Peso: Double; Resposta: AnsiString);
    procedure ACBrBAL1GravarLog(const ALogLine: string; var Tratado: Boolean);
  private
    { Private declarations }
    FVKService: IFMXVirtualKeyboardService;
    fLeituras: Integer;

    function CalcularNomeArqINI: String;
    procedure CarregarModelos;
    procedure CarregarPortas;

    procedure LerConfiguracao;
    procedure SalvarConfiguracao;
    procedure AplicarConfiguracao;

    procedure IrParaTestes;
    procedure LimparLogs;

    function PedirPermissoes: Boolean;
  public
    { Public declarations }
  end;

var
  BALAndroidTesteForm: TBALAndroidTesteForm;

implementation

uses
  System.typinfo,
  System.IniFiles,
  System.StrUtils,
  System.Permissions,
  {$IfDef ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.Os,
  Androidapi.JNI.JavaTypes,
  {$EndIf}
  FMX.DialogService,
  FMX.Platform,
  ACBrUtil.FilesIO,
  ACBrConsts,
  ACBrDeviceSerial,
  ACBrUtil.Strings,
  ACBrUtil.Base;

{$R *.fmx}

procedure TBALAndroidTesteForm.FormCreate(Sender: TObject);
var
  m : TACBrBALModelo ;
begin
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FVKService));

  CarregarModelos;

  { This defines the default active tab at runtime }
  tabsPrincipal.First;
  tabsPrincipal.TabPosition := TTabPosition.None;

  btnProcurarBthClick(Sender);
  if (cbxPorta.Items.Count > 0) then
    cbxPorta.ItemIndex := 0;

  LerConfiguracao;
end;

function TBALAndroidTesteForm.PedirPermissoes: Boolean;
begin
  Result := ACBrBAL1.Device.PedirPermissoesBlueTooth;
end;

procedure TBALAndroidTesteForm.btLerConfigClick(Sender: TObject);
begin
  LerConfiguracao;
end;

procedure TBALAndroidTesteForm.btnAtivarClick(Sender: TObject);
begin
  AplicarConfiguracao;
  ACBrBAL1.Ativar;
  IrParaTestes
end;

procedure TBALAndroidTesteForm.btnBackClick(Sender: TObject);
begin
  ACBrBAL1.Desativar;
  tabsPrincipal.Previous;
end;

procedure TBALAndroidTesteForm.btnImprimirClick(Sender: TObject);
begin
   ACBrBAL1.LePeso( ACBrBAL1.Device.TimeOut );
end;

procedure TBALAndroidTesteForm.btnLimparClick(Sender: TObject);
begin
  LimparLogs;
end;

procedure TBALAndroidTesteForm.btnProcurarBthClick(Sender: TObject);
var
  sl: TStringList;
begin
  if not PedirPermissoes then
    exit;

  CarregarPortas;
end;

procedure TBALAndroidTesteForm.btSalvarConfigClick(Sender: TObject);
begin
  SalvarConfiguracao;
end;

function TBALAndroidTesteForm.CalcularNomeArqINI: String;
begin
  Result := ApplicationPath + 'ACBrBALDemo.ini';
end;

procedure TBALAndroidTesteForm.CarregarModelos;
var
  m: TACBrBALModelo;
begin
  cbxModelo.Items.Clear;
  For m := Low(TACBrBALModelo) to High(TACBrBALModelo) do
     cbxModelo.Items.Add( GetEnumName(TypeInfo(TACBrBALModelo), integer(m) ) );
end;


procedure TBALAndroidTesteForm.CarregarPortas;
var
  sl: TStringList;
begin
  cbxPorta.Items.Clear;
  try
    //ACBrBAL1.Device.AcharPortasSeriais( cbxPorta.Items, 10 );
    ACBrBAL1.Device.AcharPortasBlueTooth( cbxPorta.Items, chbTodasBth.IsChecked );
  except
  end;

  sl := TStringList.Create;
  try
    ACBrUtil.FilesIO.FindFiles('/dev/tty*', sl, True );
    cbxPorta.Items.AddStrings(sl);
  finally
    sl.Free;
  end;
end;

procedure TBALAndroidTesteForm.ACBrBAL1GravarLog(const ALogLine: string;
  var Tratado: Boolean);
begin
  mLog.Lines.Add( TranslateUnprintable(ALogLine) );
  mLog.GoToTextEnd;
  Tratado := True;
end;

procedure TBALAndroidTesteForm.ACBrBAL1LePeso(Peso: Double;
  Resposta: AnsiString);
var
  valid : integer;
begin
  Inc(fLeituras);
  mMsgs.Lines.Add('');
  mMsgs.Lines.Add('-- '+FormatDateTime('hh:nn:ss.zzz', now)+' - Leitura '+IntToStr(fLeituras)+' --');

  if (Peso > 0) then
  begin
     mMsgs.Lines.Add('* Leitura OK !');
     mMsgs.Lines.Add('Peso Lido: '+FormatFloatBr(Peso, FloatMask(4) ));
  end
  else
  begin
    valid := Trunc(ACBrBAL1.UltimoPesoLido);
    case valid of
       0 : mMsgs.Lines.Add('* TimeOut !'+sLineBreak+
                           'Coloque o produto sobre a Balan�a!');
      -1 : mMsgs.Lines.Add('* Peso Instavel ! ' +sLineBreak+
                           'Tente Nova Leitura');
      -2 : mMsgs.Lines.Add('* Peso Negativo !');
     -10 : mMsgs.Lines.Add('* Sobrepeso !');
    end;
  end;

//  mMsgs.ScrollToTop(False);
  mMsgs.GoToTextEnd;
end;

procedure TBALAndroidTesteForm.AplicarConfiguracao;
begin
  if not PedirPermissoes then
    exit;

  ACBrBAL1.Desativar;
  if Assigned(cbxModelo.Selected) then
    ACBrBAL1.Modelo := TACBrBALModelo(cbxModelo.ItemIndex)
  else
    ACBrBAL1.Modelo := balFilizola;

  if Assigned(cbxPorta.Selected) then
    ACBrBAL1.Porta := cbxPorta.Selected.Text;

  if Assigned(cbxDataBits.Selected) then
    ACBrBAL1.Device.Data := StrToInt( cbxDataBits.Selected.Text );

  if Assigned(cbxBaudRate.Selected) then
    ACBrBAL1.Device.Baud := StrToInt( cbxBaudRate.Selected.Text );

  ACBrBAL1.Device.HandShake := TACBrHandShake( cbxHandshaking.ItemIndex );
  ACBrBAL1.Device.Parity := TACBrSerialParity( cbxParity.ItemIndex );
  ACBrBAL1.Device.Stop := TACBrSerialStop( cbxStopBits.ItemIndex );
  ACBrBAL1.Device.TimeOut := Trunc(sbTimeOut.Value);
end;

procedure TBALAndroidTesteForm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if (FVKService <> nil) then
    begin
      if TVirtualKeyboardState.Visible in FVKService.VirtualKeyboardState then
      begin
        FVKService.HideVirtualKeyboard;
        Key := 0;
        Exit
      end;
    end;

    if (tabsPrincipal.ActiveTab = tabTeste) then
    begin
      tabsPrincipal.Previous;
      Key := 0;
    end;
  end;
end;

procedure TBALAndroidTesteForm.GestureDone(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  case EventInfo.GestureID of
    sgiLeft:
      begin
        if tabsPrincipal.ActiveTab <> tabsPrincipal.Tabs[tabsPrincipal.TabCount - 1] then
          tabsPrincipal.Next;
        Handled := True;
      end;

    sgiRight:
      begin
        if tabsPrincipal.ActiveTab <> tabsPrincipal.Tabs[0] then
          tabsPrincipal.Previous;
        Handled := True;
      end;
  end;
end;

procedure TBALAndroidTesteForm.IrParaTestes;
begin
  lblTituloTestes.Text := 'Testes em: '+ACBrBAL1.ModeloStr+', Porta:'+ACBrBAL1.Porta;
  LimparLogs;
  tabsPrincipal.Next;
end;

procedure TBALAndroidTesteForm.LerConfiguracao;
Var
  ArqINI : String ;
  INI : TIniFile ;
begin
  ArqINI := CalcularNomeArqINI;

  INI := TIniFile.Create(ArqINI);
  try
    cbxModelo.ItemIndex := INI.ReadInteger('Balanca','Modelo', 1);
    cbxPorta.ItemIndex := cbxPorta.Items.IndexOf(INI.ReadString('Balanca','Porta',''));
    cbxBaudRate.ItemIndex := INI.ReadInteger('Serial','BaudRate', 6);
    cbxDataBits.ItemIndex := INI.ReadInteger('Serial','DataBits', 3);
    cbxParity.ItemIndex := INI.ReadInteger('Serial','Parity', 0);
    cbxStopBits.ItemIndex := INI.ReadInteger('Serial','StopBits', 0);
    cbxHandshaking.ItemIndex := INI.ReadInteger('Serial','Handshaking', 0);
    sbTimeOut.Value := INI.ReadInteger('Serial','TimeOut', 2000);
  finally
    INI.Free ;
  end;
end;

procedure TBALAndroidTesteForm.LimparLogs;
begin
  mMsgs.Lines.Clear;
  mLog.Lines.Clear;
  fLeituras := 0;
end;

procedure TBALAndroidTesteForm.SalvarConfiguracao;
Var
  ArqINI : String ;
  INI : TIniFile ;
begin
  ArqINI := CalcularNomeArqINI;

  INI := TIniFile.Create(ArqINI);
  try
    INI.WriteInteger('Balanca','Modelo', cbxModelo.ItemIndex);
    if Assigned(cbxPorta.Selected) then
      INI.WriteString('Balanca','Porta', cbxPorta.Selected.Text);

    INI.WriteInteger('Serial','BaudRate', cbxBaudRate.ItemIndex);
    INI.WriteInteger('Serial','DataBits', cbxDataBits.ItemIndex);
    INI.WriteInteger('Serial','Parity', cbxParity.ItemIndex);
    INI.WriteInteger('Serial','StopBits', cbxStopBits.ItemIndex);
    INI.WriteInteger('Serial','Handshaking', cbxHandshaking.ItemIndex);
    INI.WriteInteger('Serial','TimeOut', Trunc(sbTimeOut.Value));
  finally
    INI.Free ;
  end ;
end;

end.

