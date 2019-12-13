{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009   Daniel Simoes de Almeida             }
{                                         Isaque Pinheiro                      }
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

{******************************************************************************
|* Historico
|*
|* 29/03/2012: Isaque Pinheiro / R�gys Borges da Silveira
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}
unit uPrincipal;

interface

uses
  Windows, Messages, FileCtrl, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, pngimage,
  uFrameLista, IOUtils, UITypes,
  JclIDEUtils, JclCompilerUtils, ACBrUtil,
  Types, JvComponentBase, JvCreateProcess, JvExControls, JvAnimatedImage,
  JvGIFCtrl, JvWizard, JvWizardRouteMapNodes, CheckLst,
  ACBrInstallDelphiComponentes;

type

  TfrmPrincipal = class(TForm)
    wizPrincipal: TJvWizard;
    wizMapa: TJvWizardRouteMapNodes;
    wizPgConfiguracao: TJvWizardInteriorPage;
    wizPgInstalacao: TJvWizardInteriorPage;
    wizPgFinalizar: TJvWizardInteriorPage;
    wizPgInicio: TJvWizardWelcomePage;
    Label4: TLabel;
    Label5: TLabel;
    edtDelphiVersion: TComboBox;
    edtPlatform: TComboBox;
    Label2: TLabel;
    edtDirDestino: TEdit;
    Label6: TLabel;
    imgLogomarca: TImage;
    lstMsgInstalacao: TListBox;
    pnlTopo: TPanel;
    Label9: TLabel;
    btnSelecDirInstall: TSpeedButton;
    imgGifPropagandaACBrSAC: TJvGIFAnimator;
    Label3: TLabel;
    pgbInstalacao: TProgressBar;
    lblUrlACBrSac1: TLabel;
    lblUrlForum1: TLabel;
    lblUrlACBr1: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label7: TLabel;
    btnInstalarACBr: TSpeedButton;
    btnVisualizarLogCompilacao: TSpeedButton;
    pnlInfoCompilador: TPanel;
    wizPgPacotes: TJvWizardInteriorPage;
    rdgDLL: TRadioGroup;
    ckbCopiarTodasDll: TCheckBox;
    ckbBCB: TCheckBox;
    lbInfo: TListBox;
    Label8: TLabel;
    chkDeixarSomenteLIB: TCheckBox;
    ckbRemoverArquivosAntigos: TCheckBox;
    JvCreateProcess1: TJvCreateProcess;
    Label22: TLabel;
    clbDelphiVersion: TCheckListBox;
    Label23: TLabel;
    ckbRemoveOpenSSL: TCheckBox;
    ckbRemoveCapicom: TCheckBox;
    ckbCargaDllTardia: TCheckBox;
    ckbRemoverCastWarnings: TCheckBox;
    ckbUsarArquivoConfig: TCheckBox;
    framePacotes1: TframePacotes;
    ckbRemoveXMLSec: TCheckBox;

    procedure imgPropaganda1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtDelphiVersionChange(Sender: TObject);
    procedure wizPgInicioNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure URLClick(Sender: TObject);
    procedure btnSelecDirInstallClick(Sender: TObject);
    procedure wizPrincipalCancelButtonClick(Sender: TObject);
    procedure wizPrincipalFinishButtonClick(Sender: TObject);
    procedure wizPgConfiguracaoNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure btnInstalarACBrClick(Sender: TObject);
    procedure wizPgInstalacaoNextButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure btnVisualizarLogCompilacaoClick(Sender: TObject);
    procedure wizPgInstalacaoEnterPage(Sender: TObject;
      const FromPage: TJvWizardCustomPage);
    procedure rdgDLLClick(Sender: TObject);
    procedure clbDelphiVersionClick(Sender: TObject);
  private
    oACBr: TJclBorRADToolInstallations;
    iVersion: Integer;
    tPlatform: TJclBDSPlatform;
    sDirRoot: string;
    sDirLibrary: string;
    sDirPackage: string;
    sDestino   : TDestino;
    sPathBin   : String;
    FPacoteAtual: TFileName;
    procedure BeforeExecute(Sender: TJclBorlandCommandLineTool);
    procedure OutputCallLine(const Text: string);
    procedure SetPlatformSelected;
    procedure GravarConfiguracoesEmArquivoIni;
    procedure LerConfiguracoes;
    function PathApp: String;
    function PathArquivoIni: String;
    function PathArquivoLog: String;
    procedure ExtrairDiretorioPacote(const NomePacote: string);
    procedure MostraDadosVersao;
    function GetPathACBrInc: TFileName;
    procedure ValidarSeExistemPacotesNasPastas(var Stop: Boolean);
    procedure IncrementaBarraProgresso;
    procedure Logar(const AString: String);
    function ProcedeInstalacao: Boolean;
    procedure CompilarPacotes(InstalacaoAtual: TJclBorRADToolInstallation; var
        FCountErros: Integer);
    procedure InstalarPacotes(InstalacaoAtual: TJclBorRADToolInstallation; var
        FCountErros: Integer);
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  ShellApi, IniFiles, StrUtils, Math, Registry;

{$R *.dfm}

procedure TfrmPrincipal.ExtrairDiretorioPacote(const NomePacote: string);

  procedure FindDirPackage(sDir: String; const sPacote: String);
  var
    oDirList: TSearchRec;
//    iRet: Integer;
//    sDirDpk: string;
  begin
    sDir := IncludeTrailingPathDelimiter(sDir);
    if not DirectoryExists(sDir) then
      Exit;

    if SysUtils.FindFirst(sDir + '*.*', faAnyFile, oDirList) = 0 then
    begin
      try
        repeat

          if (oDirList.Name = '.')  or (oDirList.Name = '..') or (oDirList.Name = '__history')
          or (oDirList.Name = '__recovery')then
            Continue;

          //if oDirList.Attr = faDirectory then
          if DirectoryExists(sDir + oDirList.Name) then
            FindDirPackage(sDir + oDirList.Name, sPacote)
          else
          begin
            if UpperCase(oDirList.Name) = UpperCase(sPacote) then
              sDirPackage := IncludeTrailingPathDelimiter(sDir);
          end;

        until SysUtils.FindNext(oDirList) <> 0;
      finally
        SysUtils.FindClose(oDirList);
      end;
    end;
  end;

begin
   sDirPackage := '';
   FindDirPackage(IncludeTrailingPathDelimiter(sDirRoot) + 'Pacotes\Delphi', NomePacote);
end;

// retornar o path do aplicativo
function TfrmPrincipal.PathApp: String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

// retornar o caminho completo para o arquivo .ini de configura��es
function TfrmPrincipal.PathArquivoIni: String;
var
  NomeApp: String;
begin
  NomeApp := ExtractFileName(ParamStr(0));
  Result := PathApp + ChangeFileExt(NomeApp, '.ini');
end;

// retornar o caminho completo para o arquivo de logs
function TfrmPrincipal.PathArquivoLog: String;
begin
  Result := PathApp + 'log_' + StringReplace(edtDelphiVersion.Text, ' ', '_', [rfReplaceAll]) + '.txt';
end;

procedure TfrmPrincipal.rdgDLLClick(Sender: TObject);
begin
  case rdgdll.ItemIndex of
    0 : sDestino := tdSystem;
    1 : sDestino := tdDelphi;
    2 : sDestino := tdNone;
  end;
end;

procedure TfrmPrincipal.ValidarSeExistemPacotesNasPastas(var Stop: Boolean);
var
  I: Integer;
  NomePacote: string;
begin
  // verificar se os pacotes existem antes de seguir para o pr�ximo paso
  for I := 0 to framePacotes1.Pacotes.Count - 1 do
  begin
    if framePacotes1.Pacotes[I].Checked then
    begin
      sDirRoot := IncludeTrailingPathDelimiter(edtDirDestino.Text);
      NomePacote := framePacotes1.Pacotes[I].Caption;
      // Busca diret�rio do pacote
      ExtrairDiretorioPacote(NomePacote);
      if Trim(sDirPackage) = '' then
        raise Exception.Create('N�o foi poss�vel retornar o diret�rio do pacote : ' + NomePacote);
      if IsDelphiPackage(NomePacote) then
      begin
        if not FileExists(IncludeTrailingPathDelimiter(sDirPackage) + NomePacote) then
        begin
          Stop := True;
          Application.MessageBox(PWideChar(Format('Pacote "%s" n�o encontrado, efetue novamente o download do reposit�rio', [NomePacote])), 'Erro.', MB_ICONERROR + MB_OK);
          Break;
        end;
      end;
    end;
  end;
end;

// ler o arquivo .ini de configura��es e setar os campos com os valores lidos
procedure TfrmPrincipal.LerConfiguracoes;
var
  ArqIni: TIniFile;
  I: Integer;
begin
  ArqIni := TIniFile.Create(PathArquivoIni);
  try
    edtDirDestino.Text             := ArqIni.ReadString('CONFIG', 'DiretorioInstalacao', ExtractFilePath(ParamStr(0)));
    edtPlatform.ItemIndex          := 0;
    rdgDLL.ItemIndex               := ArqIni.ReadInteger('CONFIG','DestinoDLL', 0);
    ckbCopiarTodasDll.Checked      := True;
    ckbBCB.Checked                 := ArqIni.ReadBool('CONFIG','C++Builder', False);
    chkDeixarSomenteLIB.Checked    := ArqIni.ReadBool('CONFIG','DexarSomenteLib', False);
    ckbRemoveOpenSSL.Checked       := ArqIni.ReadBool('CONFIG','RemoveOpenSSL', False);
    ckbRemoveCapicom.Checked       := ArqIni.ReadBool('CONFIG','RemoveCapicom', False);
    ckbRemoveXMLSec.Checked        := True;
    ckbCargaDllTardia.Checked      := ArqIni.ReadBool('CONFIG','CargaDllTardia', False);
    ckbRemoverCastWarnings.Checked := ArqIni.ReadBool('CONFIG','RemoverCastWarnings', False);
    ckbUsarArquivoConfig.Checked   := True;

    if Trim(edtDelphiVersion.Text) = '' then
      edtDelphiVersion.ItemIndex := 0;

    edtDelphiVersionChange(edtDelphiVersion);

    for I := 0 to framePacotes1.Pacotes.Count - 1 do
      framePacotes1.Pacotes[I].Checked := ArqIni.ReadBool('PACOTES', framePacotes1.Pacotes[I].Caption, False);
  finally
    ArqIni.Free;
  end;
end;

procedure TfrmPrincipal.MostraDadosVersao;
var
  Cabecalho: string;
begin
  Cabecalho := 'Vers�o do delphi: ' + edtDelphiVersion.Text + ' (' + IntToStr(iVersion) + ')' + edtPlatform.Text + '(' + IntToStr(Integer(tPlatform)) + ')' + sLineBreak +
               'Dir. Instala��o : ' + edtDirDestino.Text + sLineBreak +
               'Dir. Bibliotecas: ' + sDirLibrary;

  WriteToTXT(PathArquivoLog, Cabecalho + sLineBreak, False);

  // mostrar ao usu�rio as informa��es de compila��o
  lbInfo.Clear;
  lbInfo.Items.Add(Cabecalho);
end;

// gravar as configura��es efetuadas pelo usu�rio
procedure TfrmPrincipal.GravarConfiguracoesEmArquivoIni;
var
  ArqIni: TIniFile;
  I: Integer;
begin
  ArqIni := TIniFile.Create(PathArquivoIni);
  try
    ArqIni.WriteString('CONFIG', 'DiretorioInstalacao', edtDirDestino.Text);
    ArqIni.WriteInteger('CONFIG','DestinoDLL', rdgDLL.ItemIndex);
    ArqIni.WriteBool('CONFIG','C++Builder',ckbBCB.Checked);
    ArqIni.WriteBool('CONFIG','DexarSomenteLib', chkDeixarSomenteLIB.Checked);
    ArqIni.WriteBool('CONFIG','RemoveOpenSSL', ckbRemoveOpenSSL.Checked);
    ArqIni.WriteBool('CONFIG','RemoveCapicom', ckbRemoveCapicom.Checked);
    ArqIni.WriteBool('CONFIG','RemoveXmlSec', ckbRemoveXMLSec.Checked);
    ArqIni.WriteBool('CONFIG','CargaDllTardia', ckbCargaDllTardia.Checked);
    ArqIni.WriteBool('CONFIG','RemoverCastWarnings', ckbRemoverCastWarnings.Checked);

    for I := 0 to framePacotes1.Pacotes.Count - 1 do
      ArqIni.WriteBool('PACOTES', framePacotes1.Pacotes[I].Caption, framePacotes1.Pacotes[I].Checked);
  finally
    ArqIni.Free;
  end;
end;

// setar a plataforma de compila��o
procedure TfrmPrincipal.SetPlatformSelected;
var
  sVersao: String;
  sTipo: String;
begin
  iVersion := edtDelphiVersion.ItemIndex;
  sVersao  := AnsiUpperCase(oACBr.Installations[iVersion].VersionNumberStr);
  sDirRoot := IncludeTrailingPathDelimiter(edtDirDestino.Text);

  sTipo := 'Lib\Delphi\';

  if edtPlatform.ItemIndex = 0 then // Win32
  begin
    tPlatform   := bpWin32;
    sDirLibrary := sDirRoot + sTipo + 'Lib' + sVersao;
  end
  else
  if edtPlatform.ItemIndex = 1 then // Win64
  begin
    tPlatform   := bpWin64;
    sDirLibrary := sDirRoot + sTipo + 'Lib' + sVersao + 'x64';
  end;
end;

// Evento disparado a cada a��o do instalador
procedure TfrmPrincipal.OutputCallLine(const Text: string);
begin
  // remover a warnings de convers�o de string (delphi 2010 em diante)
  // as diretivas -W e -H n�o removem estas mensagens
  if (pos('Warning: W1057', Text) <= 0) and ((pos('Warning: W1058', Text) <= 0)) then
    WriteToTXT(PathArquivoLog, Text);
end;

// evento para setar os par�metros do compilador antes de compilar
procedure TfrmPrincipal.BeforeExecute(Sender: TJclBorlandCommandLineTool);
var
  LArquivoCfg: TFilename;
begin
  // limpar os par�metros do compilador
  Sender.Options.Clear;

  // n�o utilizar o dcc32.cfg
  if (oACBr.Installations[iVersion].SupportsNoConfig)and
     // -- Arquivo cfg agora opcional no caso de paths muito extensos
     (not ckbUsarArquivoConfig.Checked) then
    Sender.Options.Add('--no-config');

  // -B = Build all units
  Sender.Options.Add('-B');
  // O+ = Optimization
  Sender.Options.Add('-$O-');
  // W- = Generate stack frames
  Sender.Options.Add('-$W+');
  // Y+ = Symbol reference info
  Sender.Options.Add('-$Y-');
  // -M = Make modified units
  Sender.Options.Add('-M');
  // -Q = Quiet compile
  Sender.Options.Add('-Q');
  // n�o mostrar warnings
  Sender.Options.Add('-H-');
  // n�o mostrar hints
  Sender.Options.Add('-W-');
  // -D<syms> = Define conditionals
  Sender.Options.Add('-DRELEASE');
  // -U<paths> = Unit directories
  Sender.AddPathOption('U', oACBr.Installations[iVersion].LibFolderName[tPlatform]);
  Sender.AddPathOption('U', oACBr.Installations[iVersion].LibrarySearchPath[tPlatform]);
  Sender.AddPathOption('U', sDirLibrary);
  // -I<paths> = Include directories
  Sender.AddPathOption('I', oACBr.Installations[iVersion].LibrarySearchPath[tPlatform]);
  // -R<paths> = Resource directories
  Sender.AddPathOption('R', oACBr.Installations[iVersion].LibrarySearchPath[tPlatform]);
  // -N0<path> = unit .dcu output directory
  Sender.AddPathOption('N0', sDirLibrary);
  Sender.AddPathOption('LE', sDirLibrary);
  Sender.AddPathOption('LN', sDirLibrary);

  // ************ C++ Builder *************** //
  if ckbBCB.Checked then
  begin
     // -JL compila c++ builder
     Sender.AddPathOption('JL', sDirLibrary);
     // -NO compila .dpi output directory c++ builder
     Sender.AddPathOption('NO', sDirLibrary);
     // -NB compila .lib output directory c++ builder
     Sender.AddPathOption('NB', sDirLibrary);
     // -NH compila .hpp output directory c++ builder
     Sender.AddPathOption('NH', sDirLibrary);
  end;
  //
  with oACBr.Installations[iVersion] do
  begin
     // -- Path para instalar os pacotes do Rave no D7, nas demais vers�es
     // -- o path existe.
     if VersionNumberStr = 'd7' then
        Sender.AddPathOption('U', oACBr.Installations[iVersion].RootDir + '\Rave5\Lib');

     // -- Na vers�o XE2 por motivo da nova tecnologia FireMonkey, deve-se adicionar
     // -- os prefixos dos nomes, para identificar se ser� compilado para VCL ou FMX
     if VersionNumberStr = 'd16' then
        Sender.Options.Add('-NSData.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell;System;Xml;Data;Datasnap;Web;Soap;Winapi;System.Win');

     if MatchText(VersionNumberStr, ['d17','d18','d19','d20','d21','d22','d23','d24','d25','d26']) then
        Sender.Options.Add('-NSWinapi;System.Win;Data.Win;Datasnap.Win;Web.Win;Soap.Win;Xml.Win;Bde;System;Xml;Data;Datasnap;Web;Soap;Vcl;Vcl.Imaging;Vcl.Touch;Vcl.Samples;Vcl.Shell');

  end;
  
  if (ckbUsarArquivoConfig.Checked) then
  begin
    LArquivoCfg := ChangeFileExt(FPacoteAtual, '.cfg');
    Sender.Options.SaveToFile(LArquivoCfg);
    Sender.Options.Clear;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  iFor: Integer;
begin
  iVersion    := -1;
  sDirRoot    := '';
  sDirLibrary := '';
  sDirPackage := '';

  oACBr := TJclBorRADToolInstallations.Create;

  // popular o combobox de vers�es do delphi instaladas na m�quina
  for iFor := 0 to oACBr.Count - 1 do
  begin
    if      oACBr.Installations[iFor].VersionNumberStr = 'd3' then
      edtDelphiVersion.Items.Add('Delphi 3')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd4' then
      edtDelphiVersion.Items.Add('Delphi 4')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd5' then
      edtDelphiVersion.Items.Add('Delphi 5')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd6' then
      edtDelphiVersion.Items.Add('Delphi 6')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd7' then
      edtDelphiVersion.Items.Add('Delphi 7')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd9' then
      edtDelphiVersion.Items.Add('Delphi 2005')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd10' then
      edtDelphiVersion.Items.Add('Delphi 2006')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd11' then
      edtDelphiVersion.Items.Add('Delphi 2007')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd12' then
      edtDelphiVersion.Items.Add('Delphi 2009')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd14' then
      edtDelphiVersion.Items.Add('Delphi 2010')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd15' then
      edtDelphiVersion.Items.Add('Delphi XE')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd16' then
      edtDelphiVersion.Items.Add('Delphi XE2')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd17' then
      edtDelphiVersion.Items.Add('Delphi XE3')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd18' then
      edtDelphiVersion.Items.Add('Delphi XE4')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd19' then
      edtDelphiVersion.Items.Add('Delphi XE5')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd20' then
      edtDelphiVersion.Items.Add('Delphi XE6')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd21' then
      edtDelphiVersion.Items.Add('Delphi XE7')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd22' then
      edtDelphiVersion.Items.Add('Delphi XE8')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd23' then
      edtDelphiVersion.Items.Add('Delphi 10 Seattle')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd24' then
      edtDelphiVersion.Items.Add('Delphi 10.1 Berlin')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd25' then
      edtDelphiVersion.Items.Add('Delphi 10.2 Tokyo')
    else if oACBr.Installations[iFor].VersionNumberStr = 'd26' then
      edtDelphiVersion.Items.Add('Delphi 10.3 Rio');

    // -- Evento disparado antes de iniciar a execu��o do processo.
    oACBr.Installations[iFor].DCC32.OnBeforeExecute := BeforeExecute;

    // -- Evento para saidas de mensagens.
    oACBr.Installations[iFor].OutputCallback := OutputCallLine;
  end;
  //
  clbDelphiVersion.Items.Text := edtDelphiVersion.Items.Text;

  if edtDelphiVersion.Items.Count > 0 then
  begin
    edtDelphiVersion.ItemIndex := 0;
    iVersion := 0;
  end;

  LerConfiguracoes;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  oACBr.Free;
end;

function TfrmPrincipal.GetPathACBrInc: TFileName;
begin
  Result := IncludeTrailingPathDelimiter(edtDirDestino.Text) + 'Fontes\ACBrComum\ACBr.inc';
end;

procedure TfrmPrincipal.Logar(const AString: String);
begin
  lstMsgInstalacao.Items.Add(AString);
  lstMsgInstalacao.ItemIndex := lstMsgInstalacao.Count - 1;
  Application.ProcessMessages;

  WriteToTXT(PathArquivoLog, AString);
end;

function TfrmPrincipal.ProcedeInstalacao: Boolean;
var
  ACBrInstaladorAux: TACBrInstallComponentes;
  InstalacaoAtual: TJclBorRADToolInstallation;
  iListaVer: Integer;
  FCountErros: Integer;
begin
  Result := False;
  ACBrInstaladorAux := TACBrInstallComponentes.Create(Application);
  try
    ACBrInstaladorAux.OnProgresso       := IncrementaBarraProgresso;
    ACBrInstaladorAux.OnInformaSituacao := Logar;

    ACBrInstaladorAux.Opcoes.LimparArquivosACBrAntigos := ((ckbRemoverArquivosAntigos.Checked) and
                                  (Application.MessageBox('Voc� optou por limpar arquivos antigos do ACBr do seu computador, essa a��o pode demorar v�rios minutos, deseja realmente continuar com est� a��o?',
                                                          'Limpar', MB_YESNO + MB_DEFBUTTON2) = ID_YES)
                                 );
    ACBrInstaladorAux.Opcoes.DeixarSomentePastasLib    := chkDeixarSomenteLIB.Checked;
    ACBrInstaladorAux.Opcoes.DeveInstalarCapicom       := not ckbRemoveCapicom.Checked;
    ACBrInstaladorAux.Opcoes.DeveInstalarOpenSSL       := not ckbRemoveOpenSSL.Checked;
    ACBrInstaladorAux.Opcoes.DeveCopiarOutrasDLLs      := ckbCopiarTodasDll.Checked;
    ACBrInstaladorAux.Opcoes.DeveInstalarXMLSec        := not ckbRemoveXMLSec.Checked;
    ACBrInstaladorAux.Opcoes.UsarCargaTardiaDLL        := ckbCargaDllTardia.Checked;
    ACBrInstaladorAux.Opcoes.RemoverStringCastWarnings := ckbRemoverCastWarnings.Checked;
    ACBrInstaladorAux.Opcoes.UsarCpp                   := ckbBCB.Checked;

    ACBrInstaladorAux.DesligarDefines(GetPathACBrInc);

    for iListaVer := 0 to clbDelphiVersion.Count - 1 do
    begin
      // s� instala as vers�o marcadas para instalar.
      if clbDelphiVersion.Checked[iListaVer] then
      begin
        // seleciona a vers�o no combobox.
        edtDelphiVersion.ItemIndex := iListaVer;
        edtDelphiVersionChange(edtDelphiVersion);
        // define dados da plataforna selecionada
        SetPlatformSelected;
        // limpar o log
        lstMsgInstalacao.Clear;
        // setar barra de progresso
        pgbInstalacao.Position := 0;
        pgbInstalacao.Max := (framePacotes1.Pacotes.Count * 2) + 6;

        FCountErros := 0;
        MostraDadosVersao;

        InstalacaoAtual := oACBr.Installations[iVersion];

        ACBrInstaladorAux.FazInstalacaoInicial(InstalacaoAtual, tPlatform, sDirRoot, sDirLibrary);
        
        // *************************************************************************
        // compilar os pacotes primeiramente
        // *************************************************************************
        Logar(sLineBreak+'COMPILANDO OS PACOTES...');
        CompilarPacotes(InstalacaoAtual, FCountErros);

        // *************************************************************************
        // instalar os pacotes somente se n�o ocorreu erro na compila��o e plataforma for Win32
        // *************************************************************************
        if FCountErros > 0 then
        begin
          Logar('Abortando... Ocorreram erros na compila��o dos pacotes.');
          Break;
        end
        else
        if ( tPlatform = bpWin32) then
        begin
          Logar(sLineBreak+'INSTALANDO OS PACOTES...');
          InstalarPacotes(InstalacaoAtual, FCountErros);
        end
        else
        begin
          Logar('Para a plataforma de 64 bits os pacotes s�o somente compilados.');
        end;

        ACBrInstaladorAux.InstalarOutrosRequisitos(InstalacaoAtual,tPlatform, sDirRoot, sDirLibrary);
      end;
    end;

    if FCountErros = 0 then
    begin
      ACBrInstaladorAux.FazInstalacaoDLLs(FCountErros, sDestino, edtDirDestino.Text, sPathBin);
    end;

  finally
    ACBrInstaladorAux.Free;
  end;

  if FCountErros = 0 then
  begin
    Result := True;
    Application.MessageBox(PWideChar('Pacotes compilados e instalados com sucesso! ' + sLineBreak +
                                     'Clique em "Pr�ximo" para finalizar a instala��o.'),
                           'Instala��o', MB_ICONINFORMATION + MB_OK);
  end
  else if FCountErros > 0 then
  begin
    if Application.MessageBox(PWideChar('Ocorreram erros durante o processo de instala��o, ' + sLineBreak +
                                        'para maiores informa��es verifique o arquivo de log gerado.' +
                                        sLineBreak + sLineBreak +
                                        'Deseja visualizar o arquivo de log gerado?'),
                              'Instala��o', MB_ICONQUESTION + MB_YESNO) = ID_YES then
    begin
      btnVisualizarLogCompilacao.Click;
    end;
  end;

end;

procedure TfrmPrincipal.CompilarPacotes(InstalacaoAtual: TJclBorRADToolInstallation; var FCountErros: Integer);
var
  iDpk: Integer;
  NomePacote: string;
begin
  for iDpk := 0 to framePacotes1.Pacotes.Count - 1 do
  begin
    NomePacote := framePacotes1.Pacotes[iDpk].Caption;
    // Busca diret�rio do pacote
    ExtrairDiretorioPacote(NomePacote);
    if (IsDelphiPackage(NomePacote)) and (framePacotes1.Pacotes[iDpk].Checked) then
    begin
      WriteToTXT(PathArquivoLog, '');
      FPacoteAtual := sDirPackage + NomePacote;
      if InstalacaoAtual.CompilePackage(sDirPackage + NomePacote, sDirLibrary, sDirLibrary) then
        Logar(Format('Pacote "%s" compilado com sucesso.', [NomePacote]))
      else
      begin
        Inc(FCountErros);
        Logar(Format('Erro ao compilar o pacote "%s".', [NomePacote]));
        // parar no primeiro erro para evitar de compilar outros pacotes que
        // precisam do pacote que deu erro
        Break;
      end;
    end;
    IncrementaBarraProgresso;
  end;
end;

procedure TfrmPrincipal.InstalarPacotes(InstalacaoAtual: TJclBorRADToolInstallation; var FCountErros: Integer);
var
  iDpk: Integer;
  NomePacote: string;
  bRunOnly: Boolean;
begin
  for iDpk := 0 to framePacotes1.Pacotes.Count - 1 do
  begin
    NomePacote := framePacotes1.Pacotes[iDpk].Caption;
    // Busca diret�rio do pacote
    ExtrairDiretorioPacote(NomePacote);
    if IsDelphiPackage(NomePacote) then
    begin
      FPacoteAtual := sDirPackage + NomePacote;
      // instalar somente os pacotes de designtime
      GetDPKFileInfo(sDirPackage + NomePacote, bRunOnly);
      if not bRunOnly then
      begin
        // se o pacote estiver marcado instalar, sen�o desinstalar
        if framePacotes1.Pacotes[iDpk].Checked then
        begin
          WriteToTXT(PathArquivoLog, '');
          if InstalacaoAtual.InstallPackage(sDirPackage + NomePacote, sDirLibrary, sDirLibrary) then
            Logar(Format('Pacote "%s" instalado com sucesso.', [NomePacote]))
          else
          begin
            Inc(FCountErros);
            Logar(Format('Ocorreu um erro ao instalar o pacote "%s".', [NomePacote]));
            Break;
          end;
        end
        else
        begin
          WriteToTXT(PathArquivoLog, '');
          if InstalacaoAtual.UninstallPackage(sDirPackage + NomePacote, sDirLibrary, sDirLibrary) then
            Logar(Format('Pacote "%s" removido com sucesso...', [NomePacote]));
        end;
      end;
    end;
    IncrementaBarraProgresso;
  end;
end;

procedure TfrmPrincipal.IncrementaBarraProgresso;
begin
  pgbInstalacao.Position := pgbInstalacao.Position + 1;
  Application.ProcessMessages;
end;

// bot�o de compila��o e instala��o dos pacotes selecionados no treeview
procedure TfrmPrincipal.btnInstalarACBrClick(Sender: TObject);
var
  Instalou: Boolean;
begin
  Instalou := False;
  btnInstalarACBr.Enabled := False;
  wizPgInstalacao.EnableButton(bkBack, False);
  wizPgInstalacao.EnableButton(bkNext, False);
  wizPgInstalacao.EnableButton(TJvWizardButtonKind(bkCancel), False);
  try
    Instalou := ProcedeInstalacao;
  finally
    btnInstalarACBr.Enabled := True;
    wizPgInstalacao.EnableButton(bkBack, True);
    wizPgInstalacao.EnableButton(bkNext, Instalou);
    wizPgInstalacao.EnableButton(TJvWizardButtonKind(bkCancel), True);
  end;
end;

// chama a caixa de dialogo para selecionar o diret�rio de instala��o
// seria bom que a caixa fosse aquele que possui o bot�o de criar pasta
procedure TfrmPrincipal.btnSelecDirInstallClick(Sender: TObject);
var
  Dir: String;
begin
  if SelectDirectory('Selecione o diret�rio de instala��o', '', Dir, [sdNewFolder, sdNewUI, sdValidateDir]) then
    edtDirDestino.Text := Dir;
end;

// quando trocar a vers�o verificar se libera ou n�o o combo
// da plataforma de compila��o
procedure TfrmPrincipal.clbDelphiVersionClick(Sender: TObject);
begin
  if MatchText(oACBr.Installations[clbDelphiVersion.ItemIndex].VersionNumberStr, ['d3','d4','d5','d6']) then
  begin
    Application.MessageBox(
      'Vers�o do delphi n�o suportada pelo ACBr.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

  if MatchText(oACBr.Installations[clbDelphiVersion.ItemIndex].VersionNumberStr, ['d7','d9','d10','d11']) then
  begin
    Application.MessageBox(
      'Aten��o: Embora o ACBr continue suportando vers�es anteriores do Delphi, incentivamos que voc� atualize o quanto antes para vers�es mais recentes do Delphi ou considere migrar para o Lazarus.',
      'Erro.',
      MB_OK + MB_ICONWARNING
    );
  end;

  // C++ Builder a partir do D2006, vers�es anteriores tem IDE independentes.
  ckbBCB.Enabled := MatchText(oACBr.Installations[iVersion].VersionNumberStr, ['d10','d11','d12','d14','d15','d16','d17','d18','d19','d20','d21','d22','d23','d24','d25','d26']);
  if not ckbBCB.Enabled then
     ckbBCB.Checked := False;
end;

procedure TfrmPrincipal.edtDelphiVersionChange(Sender: TObject);
begin
  iVersion := edtDelphiVersion.ItemIndex;
  sPathBin := IncludeTrailingPathDelimiter(oACBr.Installations[iVersion].BinFolderName);
  // -- Plataforma s� habilita para Delphi XE2
  // -- Desabilita para vers�o diferente de Delphi XE2
  //edtPlatform.Enabled := oACBr.Installations[iVersion].VersionNumber >= 9;
  //if oACBr.Installations[iVersion].VersionNumber < 9 then
  edtPlatform.ItemIndex := 0;
end;

// abrir o endere�o do ACBrSAC quando clicar na propaganda
procedure TfrmPrincipal.imgPropaganda1Click(Sender: TObject);
begin
  // ir para o endere�o do ACBrSAC
  ShellExecute(Handle, 'open', PWideChar(lblUrlACBrSac1.Caption), '', '', 1);
end;

// quando clicar em alguma das urls chamar o link mostrado no caption
procedure TfrmPrincipal.URLClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PWideChar(TLabel(Sender).Caption), '', '', 1);
end;

procedure TfrmPrincipal.wizPgInicioNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  // Verificar se o delphi est� aberto
  {$IFNDEF DEBUG}
  if oACBr.AnyInstanceRunning then
  begin
    Stop := True;
    Application.MessageBox(
      'Feche a IDE do delphi antes de continuar.',
      PWideChar(Application.Title),
      MB_ICONERROR + MB_OK
    );
  end;
  {$ENDIF}
end;

procedure TfrmPrincipal.wizPgInstalacaoEnterPage(Sender: TObject;
  const FromPage: TJvWizardCustomPage);
var
  iFor: Integer;
begin
  // para 64 bit somente compilar
  if tPlatform = bpWin32 then // Win32
    btnInstalarACBr.Caption := 'Instalar'
  else // win64
    btnInstalarACBr.Caption := 'Compilar';

  lbInfo.Clear;
  for iFor := 0 to clbDelphiVersion.Count -1 do
  begin
     // S� pega os dados da 1a vers�o selecionada, para mostrar na tela qual vai iniciar
     if clbDelphiVersion.Checked[iFor] then
     begin
        lbInfo.Items.Add('Instalar : ' + clbDelphiVersion.Items[ifor] + ' ' + edtPlatform.Text);
     end;
  end;
end;

procedure TfrmPrincipal.wizPgInstalacaoNextButtonClick(Sender: TObject;
  var Stop: Boolean);
begin
  if (lstMsgInstalacao.Count <= 0) then
  begin
    Stop := True;
    Application.MessageBox(
      'Clique no bot�o instalar antes de continuar.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

//  N�o deve ser permitido clicar em Next caso tenha havido erros.
//  Assim o c�digo abaixo � desnecess�rio.
//  if (FCountErros > 0) then
//  begin
//    Stop := True;
//    Application.MessageBox(
//      'Ocorreram erros durante a compila��o e instala��o dos pacotes, verifique.',
//      'Erro.',
//      MB_OK + MB_ICONERROR
//    );
//  end;
end;

procedure TfrmPrincipal.wizPgConfiguracaoNextButtonClick(Sender: TObject;
  var Stop: Boolean);
var
  iFor: Integer;
  bChk: Boolean;
begin
  bChk := False;
  for iFor := 0 to clbDelphiVersion.Count -1 do
  begin
     if clbDelphiVersion.Checked[iFor] then
        bChk := True;
  end;

  if not bChk then
  begin
    Stop := True;
    clbDelphiVersion.SetFocus;
    Application.MessageBox(
      'Para continuar escolha a vers�o do Delphi para a qual deseja instalar o ACBr.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

  // verificar se foi informado o diret�rio
  if Trim(edtDirDestino.Text) = EmptyStr then
  begin
    Stop := True;
    edtDirDestino.SetFocus;
    Application.MessageBox(
      'Diret�rio de instala��o n�o foi informado.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

  // prevenir plataforma em branco
  if Trim(edtPlatform.Text) = '' then
  begin
    Stop := True;
    edtPlatform.SetFocus;
    Application.MessageBox(
      'Plataforma de compila��o n�o foi informada.',
      'Erro.',
      MB_OK + MB_ICONERROR
    );
  end;

  if not ckbRemoveXMLSec.Checked then
  begin
    if MessageDlg('Usar XMLSec n�o � recomendado. Sugerimos que marque a op��o "'+
                  ckbRemoveXMLSec.Caption + '" antes de continuar.'+ sLineBreak +
                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
    begin
      Stop := True;
    end;
  end;

//  //Exibir mensagem abaixo apenas se n�o for o Delphi 7..
//  if not ckbRemoverCastWarnings.Checked then
//  begin
//    if MessageDlg('Se n�o estiver resolvendo os Warnings com strings sugerimos marcar a op��o "'+
//                  ckbRemoverCastWarnings.Caption + '" antes de continuar.'+ sLineBreak +
//                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
//    begin
//      Stop := True;
//    end;
//  end;
//
  if not ckbCopiarTodasDll.Checked then
  begin
    if MessageDlg('N�o foi marcado a op��o para copiar as DLLs. Voc� ter� que copiar manualmente. ' + sLineBreak +
                  'Deseja continuar assim mesmo?', mtConfirmation, mbYesNo, 0, mbNo) <> mrYes  then
    begin
      Stop := True;
    end;
  end;

  // Gravar as configura��es em um .ini para utilizar depois
  GravarConfiguracoesEmArquivoIni;

  ValidarSeExistemPacotesNasPastas(Stop);
end;

procedure TfrmPrincipal.btnVisualizarLogCompilacaoClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PWideChar(PathArquivoLog), '', '', 1);
end;

procedure TfrmPrincipal.wizPrincipalCancelButtonClick(Sender: TObject);
begin
  if Application.MessageBox(
    'Deseja realmente cancelar a instala��o?',
    'Fechar',
    MB_ICONQUESTION + MB_YESNO
  ) = ID_YES then
  begin
    Self.Close;
  end;
end;

procedure TfrmPrincipal.wizPrincipalFinishButtonClick(Sender: TObject);
begin
  Self.Close;
end;

end.
