VERSION 5.00
Object = "{86CF1D34-0C5F-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCT2.OCX"
Begin VB.Form FrmMain 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "ACBrLibBal Demo"
   ClientHeight    =   4200
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   5895
   BeginProperty Font 
      Name            =   "Tahoma"
      Size            =   8.25
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "FrmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4200
   ScaleWidth      =   5895
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdUltimoPeso 
      Caption         =   "Ultimo Peso Lido"
      Height          =   450
      Left            =   3960
      TabIndex        =   6
      Top             =   2040
      Width           =   1815
   End
   Begin VB.CommandButton cmdSolicitarPeso 
      Caption         =   "Solicitar Peso"
      Height          =   450
      Left            =   3960
      TabIndex        =   5
      Top             =   1560
      Width           =   1815
   End
   Begin VB.CommandButton cmdLerPeso 
      Caption         =   "LerPeso"
      Height          =   450
      Left            =   3960
      TabIndex        =   4
      Top             =   1080
      Width           =   1815
   End
   Begin VB.CommandButton cmdAtivar 
      Caption         =   "Ativar"
      Height          =   450
      Left            =   3960
      TabIndex        =   3
      Top             =   120
      Width           =   1815
   End
   Begin VB.TextBox txtPesoLido 
      Alignment       =   1  'Right Justify
      BackColor       =   &H00C0FFFF&
      Enabled         =   0   'False
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   15.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   3960
      TabIndex        =   1
      Text            =   "0,00"
      Top             =   3600
      Width           =   1815
   End
   Begin VB.Frame FraConfiguracao 
      Caption         =   "Configura��o"
      Height          =   3975
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   3735
      Begin VB.ComboBox ComData 
         Height          =   315
         Left            =   1440
         Style           =   2  'Dropdown List
         TabIndex        =   31
         Top             =   1680
         Width           =   1095
      End
      Begin VB.CheckBox chkSoftFlow 
         Caption         =   "SoftFlow"
         Height          =   195
         Left            =   1920
         TabIndex        =   30
         Top             =   3600
         Width           =   1095
      End
      Begin VB.CheckBox chkHardFlow 
         Caption         =   "HardFlow"
         Height          =   195
         Left            =   1920
         TabIndex        =   29
         Top             =   3360
         Width           =   1095
      End
      Begin VB.ComboBox ComHandShake 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   28
         Top             =   3480
         Width           =   1695
      End
      Begin MSComCtl2.UpDown updSendBytesInterval 
         Height          =   285
         Left            =   3360
         TabIndex        =   26
         Top             =   2880
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   503
         _Version        =   393216
         AutoBuddy       =   -1  'True
         BuddyControl    =   "txtSendBytesInterval"
         BuddyDispid     =   196619
         OrigLeft        =   3240
         OrigTop         =   3360
         OrigRight       =   3495
         OrigBottom      =   3735
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin VB.TextBox txtSendBytesInterval 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   2520
         TabIndex        =   25
         Text            =   "0"
         Top             =   2880
         Width           =   840
      End
      Begin MSComCtl2.UpDown updSendBytesCount 
         Height          =   285
         Left            =   2160
         TabIndex        =   24
         Top             =   2880
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   503
         _Version        =   393216
         AutoBuddy       =   -1  'True
         BuddyControl    =   "txtSendBytesCount"
         BuddyDispid     =   196620
         OrigLeft        =   2280
         OrigTop         =   3600
         OrigRight       =   2535
         OrigBottom      =   3975
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin VB.TextBox txtSendBytesCount 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   1320
         TabIndex        =   23
         Text            =   "0"
         Top             =   2880
         Width           =   840
      End
      Begin MSComCtl2.UpDown updMaxBandwidth 
         Height          =   285
         Left            =   960
         TabIndex        =   22
         Top             =   2880
         Width           =   255
         _ExtentX        =   450
         _ExtentY        =   503
         _Version        =   393216
         AutoBuddy       =   -1  'True
         BuddyControl    =   "txtMaxBandwidth"
         BuddyDispid     =   196621
         OrigLeft        =   960
         OrigTop         =   3000
         OrigRight       =   1215
         OrigBottom      =   3255
         Max             =   99999
         SyncBuddy       =   -1  'True
         BuddyProperty   =   0
         Enabled         =   -1  'True
      End
      Begin VB.TextBox txtMaxBandwidth 
         Alignment       =   1  'Right Justify
         Height          =   285
         Left            =   120
         TabIndex        =   21
         Text            =   "0"
         Top             =   2880
         Width           =   840
      End
      Begin VB.ComboBox ComStop 
         Height          =   315
         Left            =   1920
         Style           =   2  'Dropdown List
         TabIndex        =   17
         Top             =   2280
         Width           =   1695
      End
      Begin VB.ComboBox ComParity 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   15
         Top             =   2280
         Width           =   1695
      End
      Begin VB.ComboBox ComBaud 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   12
         Top             =   1680
         Width           =   1215
      End
      Begin VB.ComboBox ComPorta 
         Height          =   315
         Left            =   120
         TabIndex        =   10
         Text            =   "ComPorta"
         Top             =   1080
         Width           =   3495
      End
      Begin VB.ComboBox ComModelo 
         Height          =   315
         Left            =   120
         Style           =   2  'Dropdown List
         TabIndex        =   8
         Top             =   480
         Width           =   3495
      End
      Begin VB.Label lblHandShake 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "HandShake"
         Height          =   195
         Left            =   120
         TabIndex        =   27
         Top             =   3240
         Width           =   810
      End
      Begin VB.Label lblInterval 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Intervalo"
         Height          =   195
         Left            =   2520
         TabIndex        =   20
         Top             =   2640
         Width           =   660
      End
      Begin VB.Label lblBytesCount 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Bytes Count"
         Height          =   195
         Left            =   1320
         TabIndex        =   19
         Top             =   2640
         Width           =   885
      End
      Begin VB.Label lblMaxBand 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Max. Band."
         Height          =   195
         Left            =   120
         TabIndex        =   18
         Top             =   2640
         Width           =   825
      End
      Begin VB.Label lblStopByte 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Stop Byte"
         Height          =   195
         Left            =   1920
         TabIndex        =   16
         Top             =   2040
         Width           =   705
      End
      Begin VB.Label lblParity 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Parity"
         Height          =   195
         Left            =   120
         TabIndex        =   14
         Top             =   2040
         Width           =   420
      End
      Begin VB.Label lblData 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Data"
         Height          =   195
         Left            =   1440
         TabIndex        =   13
         Top             =   1440
         Width           =   345
      End
      Begin VB.Label lblBaud 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Baud"
         Height          =   195
         Left            =   120
         TabIndex        =   11
         Top             =   1440
         Width           =   360
      End
      Begin VB.Label lblPorta 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Porta"
         Height          =   195
         Left            =   120
         TabIndex        =   9
         Top             =   840
         Width           =   390
      End
      Begin VB.Label lblModelo 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Modelo"
         Height          =   195
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   510
      End
   End
   Begin VB.Label lblPesoLido 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Peso Lido"
      BeginProperty Font 
         Name            =   "Tahoma"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   435
      Left            =   3960
      TabIndex        =   2
      Top             =   3000
      Width           =   1725
   End
End
Attribute VB_Name = "FrmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim bal As ACBrBAL

Private Sub cmdAtivar_Click()
  On Error GoTo catch_error
        
    If cmdAtivar.Caption = "Ativar" Then
        SaveConfig
        
        bal.Ativar
        cmdAtivar.Caption = "Desativar"
    Else
        bal.Desativar
        cmdAtivar.Caption = "Ativar"
    End If

    Exit Sub
catch_error:
    MsgBox Err.Description, vbExclamation + vbOKOnly, "Application Error"
    Exit Sub
End Sub

Private Sub cmdLerPeso_Click()
  On Error GoTo catch_error
    
    Dim peso As Double
    
    peso = bal.LePeso
    txtPesoLido.Text = CStr(peso)

    Exit Sub
catch_error:
    MsgBox Err.Description, vbExclamation + vbOKOnly, "Application Error"
    Exit Sub
End Sub

Private Sub cmdSolicitarPeso_Click()
  On Error GoTo catch_error
    
    bal.SolicitarPeso

    Exit Sub
catch_error:
    MsgBox Err.Description, vbExclamation + vbOKOnly, "Application Error"
    Exit Sub
End Sub

Private Sub cmdUltimoPeso_Click()
  On Error GoTo catch_error
  
    Dim peso As Double
    
    peso = bal.UltimoPesoLido
    
    txtPesoLido.Text = CStr(peso)
    
    Exit Sub
catch_error:
    MsgBox Err.Description, vbExclamation + vbOKOnly, "Application Error"
    Exit Sub
End Sub

Private Sub Form_Load()
  ComModelo.AddItem "balNenhum", 0
  ComModelo.AddItem "balFilizola", 1
  ComModelo.AddItem "balToledo", 2
  ComModelo.AddItem "balToledo2090", 3
  ComModelo.AddItem "balToledo2180", 4
  ComModelo.AddItem "balUrano", 5
  ComModelo.AddItem "balLucasTec", 6
  ComModelo.AddItem "balMagna", 7
  ComModelo.AddItem "balDigitron", 8
  ComModelo.AddItem "balMagellan", 9
  ComModelo.AddItem "balUranoPOP", 10
  ComModelo.AddItem "balLider", 11
  ComModelo.AddItem "balRinnert", 12
  ComModelo.AddItem "balMuller", 13
  ComModelo.AddItem "balSaturno", 14
  ComModelo.AddItem "balAFTS", 15
  ComModelo.AddItem "balGenerica", 16
  ComModelo.AddItem "balLibratek", 17
  ComModelo.AddItem "balMicheletti", 18
  ComModelo.AddItem "balAlfa", 19
  ComModelo.AddItem "balToledo9091_8530_8540", 20
  ComModelo.AddItem "balWeightechWT1000", 21
  ComModelo.AddItem "balMarelCG62XL", 22
  ComModelo.AddItem "balWeightechWT3000_ABS", 23
  ComModelo.AddItem "balToledo2090N", 24
  ComModelo.AddItem "balToledoBCS21", 25
  ComModelo.AddItem "balPrecision", 26
  ComModelo.AddItem "balDigitron_UL", 27
  
  ComModelo.ListIndex = 0
  
  ComPorta.AddItem "COM1"
  ComPorta.AddItem "COM2"
  ComPorta.AddItem "LPT1"
  ComPorta.AddItem "LPT2"
  
  ComPorta.ListIndex = 0
  
  ComBaud.AddItem "110"
  ComBaud.AddItem "300"
  ComBaud.AddItem "600"
  ComBaud.AddItem "1200"
  ComBaud.AddItem "2400"
  ComBaud.AddItem "4800"
  ComBaud.AddItem "9600"
  ComBaud.AddItem "14400"
  ComBaud.AddItem "19200"
  ComBaud.AddItem "38400"
  ComBaud.AddItem "56000"
  ComBaud.AddItem "57600"
  ComBaud.AddItem "115200"
  
  ComBaud.ListIndex = 6
  
  ComData.AddItem "5"
  ComData.AddItem "6"
  ComData.AddItem "7"
  ComData.AddItem "8"
  
  ComData.ListIndex = ComData.ListCount - 1
  
  ComParity.AddItem "pNone", 0
  ComParity.AddItem "pOdd", 1
  ComParity.AddItem "pEven", 2
  ComParity.AddItem "pMark", 3
  ComParity.AddItem "pSpace", 4
  
  ComParity.ListIndex = 0
  
  ComStop.AddItem "s1", 0
  ComStop.AddItem "s1eMeio", 1
  ComStop.AddItem "s2", 2
  
  ComStop.ListIndex = 0
  
  ComHandShake.AddItem "hsNenhum", 0
  ComHandShake.AddItem "hsXON_XOFF", 1
  ComHandShake.AddItem "hsRTS_CTS", 2
  ComHandShake.AddItem "hsDTR_DSR", 3
  
  ComHandShake.ListIndex = 0
  
  Dim LogPath As String
      
  LogPath = App.Path & "\Docs\"
  If Not DirExists(LogPath) Then
    MkDir LogPath
  End If
  
  
  Set bal = CreateBAL(App.Path & "\ACBrLib.ini", "")
  bal.ConfigGravarValor SESSAO_PRINCIPAL, "LogNivel", "4"
  bal.ConfigGravarValor SESSAO_PRINCIPAL, "LogPath", LogPath
  bal.ConfigGravar
  
  LoadConfig

End Sub

Private Sub Form_Terminate()
    Dim retorno As Long
    retorno = bal.FinalizarLib()
    CheckResult retorno
End Sub

Private Sub LoadConfig()
  
  bal.ConfigLer
  ComModelo.ListIndex = CLng(bal.ConfigLerValor(SESSAO_BAL, "Modelo"))
  ComPorta.Text = bal.ConfigLerValor(SESSAO_BAL, "Porta")
  ComBaud.Text = bal.ConfigLerValor(SESSAO_BAL_DEVICE, "Baud")
  ComData.Text = bal.ConfigLerValor(SESSAO_BAL_DEVICE, "Data")
  ComParity.ListIndex = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "Parity"))
  ComStop.ListIndex = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "Stop"))
  updMaxBandwidth.Value = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "MaxBandwidth"))
  updSendBytesCount.Value = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "SendBytesCount"))
  updSendBytesInterval.Value = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "SendBytesInterval"))
  ComHandShake.ListIndex = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "HandShake"))
  chkSoftFlow.Value = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "SoftFlow"))
  chkHardFlow.Value = CLng(bal.ConfigLerValor(SESSAO_BAL_DEVICE, "HardFlow"))
End Sub

Public Sub SaveConfig()
    bal.ConfigGravarValor SESSAO_BAL, "Modelo", CStr(ComModelo.ListIndex)
    bal.ConfigGravarValor SESSAO_BAL, "Porta", ComPorta.Text
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "Baud", ComBaud.Text
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "Data", ComDataText
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "Parity", CStr(ComParity.ListIndex)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "Stop", CStr(ComStop.ListIndex)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "MaxBandwidth", CStr(updMaxBandwidth.Value)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "SendBytesCount", CStr(updSendBytesCount.Value)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "SendBytesInterval", CStr(updSendBytesInterval.Value)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "HandShake", CStr(ComHandShake.ListIndex)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "SoftFlow", CStr(chkSoftFlow.Value)
    bal.ConfigGravarValor SESSAO_BAL_DEVICE, "HardFlow", CStr(chkHardFlow.Value)
    bal.ConfigGravar
End Sub
