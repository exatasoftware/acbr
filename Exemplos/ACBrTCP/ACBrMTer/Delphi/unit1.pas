{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit Unit1;

interface

uses
  Classes, SysUtils, db, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, CheckLst, Spin, ComCtrls, DBGrids,
  ACBrMTer, ACBrSocket, ACBrConsts, blcksock, DBClient, ACBrBase,
  Grids, ACBrBAL;

type

  { TForm1 }
  TForm1 = class(TForm)
    ACBrMTer1: TACBrMTer;
    btBackSpace: TButton;
    btBeep: TButton;
    btDeslocarCursor: TButton;
    btDeslocarLinha: TButton;
    btEnviarParalela: TButton;
    btEnviarSerial: TButton;
    btEnviarTexto: TButton;
    btFluxoVendas: TButton;
    btLimparDisplay: TButton;
    btLimparLinha: TButton;
    btLimparLinha1: TButton;
    btPosicionarCursor: TButton;
    dbgComandas: TDBGrid;
    dbgTerminais: TDBGrid;
    dsComandas: TDataSource;
    dsTerminais: TDataSource;
    edDesLinha: TSpinEdit;
    edEnviarParalela: TEdit;
    edEnviarSerial: TEdit;
    edEnviarTexto: TEdit;
    edLimparLinha: TSpinEdit;
    edPosColuna: TSpinEdit;
    edPosLinha: TSpinEdit;
    edQtdPosicao: TSpinEdit;
    edSerial: TSpinEdit;
    gbComandas: TGroupBox;
    lbDesLinha: TLabel;
    lbLimparLinha: TLabel;
    lbPosColuna: TLabel;
    lbPosLinha: TLabel;
    lbQtdPosicoes: TLabel;
    lbSerial: TLabel;
    PageControl2: TPageControl;
    pnAtivarFluxo: TPanel;
    pnComandas: TPanel;
    pnComandos: TPanel;
    pnLegenda: TPanel;
    pnTerminais: TPanel;
    tsComandos: TTabSheet;
    tsFluxoVendas: TTabSheet;
    memComandas: TClientDataSet;
    memTerminais: TClientDataSet;
    ACBrBAL1: TACBrBAL;
    pLeft: TPanel;
    pnConectados: TPanel;
    Splitter1: TSplitter;
    clbConectados: TCheckListBox;
    mOutput: TMemo;
    pgConfigs: TPageControl;
    tsConfig: TTabSheet;
    lbPorta: TLabel;
    lbModelo: TLabel;
    Label1: TLabel;
    lbEchoMode: TLabel;
    btAtivarDesativar: TButton;
    edPorta: TEdit;
    cbModelo: TComboBox;
    btAtualizar: TButton;
    cbEchoMode: TComboBox;
    tsBalanca: TTabSheet;
    Label2: TLabel;
    Label4: TLabel;
    cbBalanca: TComboBox;
    edSerialPeso: TSpinEdit;
    btSolicitarPeso: TButton;
    Splitter2: TSplitter;
    lbTerminador: TLabel;
    edTerminador: TComboBox;
    lbTerminador1: TLabel;
    edTerminadorBalanca: TComboBox;
    seTimeout: TSpinEdit;
    Label3: TLabel;
    seWait: TSpinEdit;
    procedure ACBrMTer1Conecta(const IP: String);
    procedure ACBrMTer1Desconecta(const IP: String; Erro: Integer;
      ErroDesc: String);
    procedure btAtualizarClick(Sender: TObject);
    procedure btBackSpaceClick(Sender: TObject);
    procedure btBeepClick(Sender: TObject);
    procedure btAtivarDesativarClick(Sender: TObject);
    procedure btDeslocarCursorClick(Sender: TObject);
    procedure btDeslocarLinhaClick(Sender: TObject);
    procedure btEnviarParalelaClick(Sender: TObject);
    procedure btEnviarSerialClick(Sender: TObject);
    procedure btEnviarTextoClick(Sender: TObject);
    procedure btLimparDisplayClick(Sender: TObject);
    procedure btLimparLinha1Click(Sender: TObject);
    procedure btLimparLinhaClick(Sender: TObject);
    procedure btPosicionarCursorClick(Sender: TObject);
    procedure btFluxoVendasClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEchoModeChange(Sender: TObject);
    procedure btSolicitarPesoClick(Sender: TObject);
    procedure ACBrMTer1RecebePeso(const IP: String;
      const PesoRecebido: Double);
    procedure edTerminadorChange(Sender: TObject);
    procedure edTerminadorBalancaChange(Sender: TObject);
    procedure seWaitChange(Sender: TObject);
    procedure ACBrMTer1RecebeOnLine(const IP: String;
      const Conectado: Boolean; const RepostaOnLine: String);
    procedure ACBrMTer1RecebeDados(const IP, Recebido: String;
      var EchoMode: TACBrMTerEchoMode);
  private
    procedure AtualizarConexoes;
    procedure VerificaSelecionado;

    procedure CarregarTerminais;
    procedure IniciarFluxoVendas;
    function AlterarEstadoTerminal(aIP: String; aEstado: Integer): Boolean;

    procedure AvaliarRespostaTerminal(aIP: AnsiString; aResposta: AnsiString);
    procedure IncluirComanda(aComanda: String);
    procedure AdicionaItem(aComanda: String);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  strutils, typinfo,
  ACBrUtil;

{$R *.dfm}

{ TForm1 }

procedure TForm1.ACBrMTer1Conecta(const IP: String);
begin
  mOutput.Lines.Add('Conectou IP: ' + IP);

  ACBrMTer1.LimparDisplay(IP);
  ACBrMTer1.EnviarTexto(IP, 'Seja bem vindo');

  AtualizarConexoes;
end;

procedure TForm1.ACBrMTer1Desconecta(const IP: String; Erro: Integer;
  ErroDesc: String);
begin
  mOutput.Lines.Add('Desconectou IP: ' + IP);
  mOutput.Lines.Add('  - Erro: ' + IntToStr(Erro) + ' - ' + ErroDesc);

  AtualizarConexoes;
end;

procedure TForm1.btAtualizarClick(Sender: TObject);
begin
  AtualizarConexoes;
end;

procedure TForm1.btBackSpaceClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.BackSpace(clbConectados.Items[I]);  // Envia Comando usando IP
end;

procedure TForm1.btBeepClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.Beep(clbConectados.Items[I]);
end;

procedure TForm1.btAtivarDesativarClick(Sender: TObject);
begin
  if btAtivarDesativar.Caption = 'Ativar' then
  begin
    btAtivarDesativar.Caption := 'Desativar';
    with ACBrMTer1 do
    begin
      Modelo     := TACBrMTerModelo(cbModelo.ItemIndex);
      Port       := edPorta.Text;
      EchoMode   := TACBrMTerEchoMode(cbEchoMode.ItemIndex);
      Terminador := edTerminador.Text;
      TerminadorBalanca := edTerminadorBalanca.Text;
      TimeOut    := seTimeout.Value;
      WaitInterval := seWait.Value;
      Ativar;
    end;
    mOutput.Lines.Add('Escutando porta: ' + edPorta.Text);
  end
  else
  begin
    btAtivarDesativar.Caption := 'Ativar';
    ACBrMTer1.Desativar;
    mOutput.Lines.Add('Desativada porta: ' + edPorta.Text);
  end;
end;

procedure TForm1.btDeslocarCursorClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.DeslocarCursor(clbConectados.Items[I], edQtdPosicao.Value);
end;

procedure TForm1.btDeslocarLinhaClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.DeslocarLinha(clbConectados.Items[I], edDesLinha.Value);
end;

procedure TForm1.btEnviarParalelaClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.EnviarParaParalela(clbConectados.Items[I], edEnviarParalela.Text);
end;

procedure TForm1.btEnviarSerialClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.EnviarParaSerial(clbConectados.Items[I], edEnviarSerial.Text, edSerial.Value);
end;

procedure TForm1.btEnviarTextoClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.EnviarTexto(clbConectados.Items[I], edEnviarTexto.Text);
end;

procedure TForm1.btLimparDisplayClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.LimparDisplay(clbConectados.Items[I]);
end;

procedure TForm1.btLimparLinha1Click(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.VerificarOnline(clbConectados.Items[I]);
end;

procedure TForm1.btLimparLinhaClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.LimparLinha(clbConectados.Items[I], edLimparLinha.Value);
end;

procedure TForm1.btPosicionarCursorClick(Sender: TObject);
var
  I: Integer;
begin
  VerificaSelecionado;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      ACBrMTer1.PosicionarCursor(clbConectados.Items[I], edPosLinha.Value, edPosColuna.Value);
end;

procedure TForm1.btFluxoVendasClick(Sender: TObject);
begin
  IniciarFluxoVendas;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: TACBrBALModelo;
  J: TACBrMTerModelo;
  K: TACBrMTerEchoMode;
begin
  cbBalanca.Items.Clear;
  // Preenchendo ComboBox de Modelos de Balan�a
  for I := Low(TACBrBALModelo) to High(TACBrBALModelo) do
    cbBalanca.Items.Add(GetEnumName(TypeInfo(TACBrBALModelo), Integer(I)));

  cbModelo.Items.Clear;
  // Preenchendo ComboBox de Modelos de Balan�a
  for J := Low(TACBrMTerModelo) to High(TACBrMTerModelo) do
    cbModelo.Items.Add(GetEnumName(TypeInfo(TACBrMTerModelo), Integer(J)));

  cbEchoMode.Items.Clear;
  // Preenchendo ComboBox de Modelos de Balan�a
  for K := Low(TACBrMTerEchoMode) to High(TACBrMTerEchoMode) do
    cbEchoMode.Items.Add(GetEnumName(TypeInfo(TACBrMTerEchoMode), Integer(K)));


  edTerminador.Items.Clear;
  edTerminador.Items.Add('');
  edTerminador.Items.Add('#13 | CR');
  edTerminador.Items.Add('#10 | LF');
  edTerminador.Items.Add('#13,#10 | CR+LF');
  edTerminador.Items.Add('#3 | ETX');

  edTerminadorBalanca.Items.Assign(edTerminador.Items);
  edTerminadorBalanca.ItemIndex := 4;

  cbModelo.ItemIndex := 0;
  cbEchoMode.ItemIndex := 0;

  pgConfigs.ActivePageIndex := 0;
  PageControl2.ActivePageIndex := 0;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  ACBrMTer1.Desativar;
end;

procedure TForm1.PageControl2Change(Sender: TObject);
begin
  if (PageControl2.TabIndex = 1) then
    CarregarTerminais;

  clbConectados.Visible := (PageControl2.TabIndex = 0);
  Splitter1.Visible     := (clbConectados.Visible);
end;

procedure TForm1.AtualizarConexoes;
var
  I: Integer;
begin
  clbConectados.Clear;

  with ACBrMTer1.TCPServer.ThreadList.LockList do
  try
    for I := 0 to Count - 1 do
    begin
      with TACBrTCPServerThread(Items[I]) do
        if Active then
          clbConectados.Items.Add(TCPBlockSocket.GetRemoteSinIP);
    end;
  finally
    ACBrMTer1.TCPServer.ThreadList.UnlockList;
  end;

  Application.ProcessMessages;
end;

procedure TForm1.VerificaSelecionado;
var
  wSel: Boolean;
  I: Integer;
begin
  wSel := False;

  for I := 0 to clbConectados.Count - 1 do
    if clbConectados.Checked[I] then
      wSel := True;

  if (not wSel) then
    if (clbConectados.Count > 0) then
      clbConectados.Checked[0] := True;
end;

procedure TForm1.CarregarTerminais;
var
  I: Integer;
begin
  memComandas.EmptyDataSet;
  memComandas.Open;
  memTerminais.EmptyDataSet;
  memTerminais.Open;

  with ACBrMTer1.TCPServer.ThreadList.LockList do
  try
    for I := 0 to Count - 1 do
      with TACBrTCPServerThread(Items[I]) do
        if Active then
        begin
          memTerminais.Insert;
          memTerminais.FieldByName('IP_TERMINAL').AsString := TCPBlockSocket.GetRemoteSinIP;
          memTerminais.FieldByName('COMANDA').AsString     := '';
          memTerminais.FieldByName('RESPOSTA').AsString    := '';
          memTerminais.FieldByName('STATUS').AsInteger     :=  0;
          memTerminais.Post;
        end;
  finally
    ACBrMTer1.TCPServer.ThreadList.UnlockList;
  end;

  Application.ProcessMessages;
end;

procedure TForm1.IniciarFluxoVendas;
begin
  if memTerminais.IsEmpty then
  begin
    ShowMessage('Nenhum terminal dispon�vel');
    Exit;
  end;

  with memTerminais do
  begin
    DisableControls;
    try
      First;
      while (not EOF) do
      begin
        Edit;
        if AlterarEstadoTerminal(Fields[0].AsString, 1) then
          FieldByName('STATUS').AsInteger := 1
        else
          FieldByName('STATUS').AsInteger := -1;
        Post;

        Next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

function TForm1.AlterarEstadoTerminal(aIP: String; aEstado: Integer): Boolean;
begin
  Result := True;

  try
    ACBrMTer1.LimparDisplay(aIP);

    case aEstado of
      0: Exit;                                               // Indefinido
      1: ACBrMTer1.EnviarTexto(aIP, 'Informe a Comanda: ');  // Pede Comanda
      2: ACBrMTer1.EnviarTexto(aIP, 'Informe o Item: ');     // Pede Item
    end;
  except
    Result := False;
  end;
end;

procedure TForm1.AvaliarRespostaTerminal(aIP: AnsiString; aResposta: AnsiString);
var
  aString: String;
begin
  aString := aResposta;
  with memTerminais do
  begin
    DisableControls;
    try
      if Locate('IP_TERMINAL', aIP, []) then
      begin
        if (aString[1] <> #13) then
        begin
          // Grava Resposta
          Edit;
          FieldByName('RESPOSTA').AsString := FieldByName('RESPOSTA').AsString + aString;
          Post;

          Exit;
        end;

        aString := '';
        case FieldByName('STATUS').AsInteger of
          1:
          begin
            Edit;
            FieldByName('COMANDA').AsString  := FieldByName('RESPOSTA').AsString;
            FieldByName('RESPOSTA').AsString := '';

            if AlterarEstadoTerminal(aIP, 2) then  // Muda estado para pedir Item
              FieldByName('STATUS').AsInteger := 2
            else
              FieldByName('STATUS').AsInteger := -1;
            Post;

            IncluirComanda(FieldByName('COMANDA').AsString);
          end;

          2:
          begin
            AdicionaItem(FieldByName('COMANDA').AsString);

            Edit;
            FieldByName('COMANDA').AsString  := '';
            FieldByName('RESPOSTA').AsString := '';

            if AlterarEstadoTerminal(aIP, 1) then
              FieldByName('STATUS').AsInteger := 1
            else
              FieldByName('STATUS').AsInteger := -1;
            Post;
          end;
        end;
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure TForm1.IncluirComanda(aComanda: String);
begin
  with memComandas do
  begin
    DisableControls;
    try
      First;
      while (not EOF) do
      begin
        if (FieldByName('CODCOMANDA').AsString = aComanda) then
          Exit;   // Comanda j� existe? ...Sai

        Next;
      end;

      Insert;
      FieldByName('CODCOMANDA').AsString := aComanda;
      FieldByName('QTD_ITENS').AsInteger := 0;
      Post;
    finally
      EnableControls;
    end;
  end;
end;

procedure TForm1.AdicionaItem(aComanda: String);
begin
  with memComandas do
  begin
    DisableControls;
    try
      First;
      while (not EOF) do
      begin
        if (FieldByName('CODCOMANDA').AsString = aComanda) then
        begin
          Edit;
          FieldByName('QTD_ITENS').AsInteger := FieldByName('QTD_ITENS').AsInteger + 1;
          Post;

          Exit;
        end;

        Next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  memComandas.CreateDataSet;
  memTerminais.CreateDataSet;
  memTerminais.Open;
  memComandas.Open;
end;

procedure TForm1.cbEchoModeChange(Sender: TObject);
begin
  ACBrMTer1.EchoMode := TACBrMTerEchoMode(cbEchoMode.ItemIndex);
end;

procedure TForm1.btSolicitarPesoClick(Sender: TObject);
var
  I: Integer;
  wIP: String;
begin
  VerificaSelecionado;

  if (cbBalanca.ItemIndex = 0) then
  begin
    MessageDlg('Selecione o Modelo', mtError, [mbOK], 0);
    cbBalanca.DroppedDown := True;
    Exit;
  end;

  ACBrBAL1.Modelo := TACBrBALModelo(cbBalanca.ItemIndex);

  for I := 0 to clbConectados.Count - 1 do
  begin
    wIP := clbConectados.Items[I];

    if clbConectados.Checked[I] then
      ACBrMTer1.SolicitarPeso(wIP, edSerialPeso.Value);
  end;    
end;

procedure TForm1.ACBrMTer1RecebePeso(const IP: String;
  const PesoRecebido: Double);
begin
  mOutput.Lines.Add('IP: '+IP+' - Peso: '+ FormatFloat('##0.000', PesoRecebido)); 
end;

procedure TForm1.edTerminadorChange(Sender: TObject);
begin
  ACBrMTer1.Terminador := edTerminador.Text;
end;

procedure TForm1.edTerminadorBalancaChange(Sender: TObject);
begin
  ACBrMTer1.TerminadorBalanca := edTerminadorBalanca.Text;
end;

procedure TForm1.seWaitChange(Sender: TObject);
begin
  ACBrMTer1.WaitInterval := seWait.Value
end;

procedure TForm1.ACBrMTer1RecebeOnLine(const IP: String;
  const Conectado: Boolean; const RepostaOnLine: String);
begin
  mOutput.Lines.Add('Terminal: '+IP+' - '+IfThen(Conectado,'On Line','Off Line') );
  mOutput.Lines.Add('Resposta: '+RepostaOnLine);
end;

procedure TForm1.ACBrMTer1RecebeDados(const IP, Recebido: String;
  var EchoMode: TACBrMTerEchoMode);
begin
  mOutput.Lines.Add('IP: ' + IP + ' - Recebido: ' + TranslateUnprintable( Recebido ) );

  if (PageControl2.ActivePageIndex = 1) then
    AvaliarRespostaTerminal(IP, Recebido);
end;

end.
