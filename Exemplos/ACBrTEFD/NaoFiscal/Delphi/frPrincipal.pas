{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit frPrincipal;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Spin, Buttons, DBCtrls, ExtCtrls, Grids, ACBrTEFD,
  ACBrPosPrinter, ACBrTEFDClass, uVendaClass, ACBrTEFDCliSiTef,
  ImgList, ACBrBase;

type

  TTipoBotaoOperacao = (bopNaoExibir, bopCancelarVenda, bopLiberarCaixa, bopCancelarEsperaTEF);

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    ACBrPosPrinter1: TACBrPosPrinter;
    ACBrTEFD1: TACBrTEFD;
    btAdministrativo: TBitBtn;
    btImprimir: TBitBtn;
    btIncluirPagamentos: TBitBtn;
    btExcluirPagamento: TBitBtn;
    btLerParametros: TBitBtn;
    btLimparImpressora: TBitBtn;
    btMudaPagina: TBitBtn;
    btOperacao: TBitBtn;
    btEfetuarPagamentos: TBitBtn;
    btSalvarParametros: TBitBtn;
    btSerial: TSpeedButton;
    btProcuraImpressoras: TSpeedButton;
    btTestarPosPrinter: TBitBtn;
    btTestarTEF: TBitBtn;
    btObterCPF: TButton;
    cbTestePayGo: TComboBox;
    cbIMprimirViaReduzida: TCheckBox;
    cbMultiplosCartoes: TCheckBox;
    cbSimularErroNoDoctoFiscal: TCheckBox;
    cbSuportaDesconto: TCheckBox;
    cbSuportaReajusteValor: TCheckBox;
    cbSuportaSaque: TCheckBox;
    cbxGP: TComboBox;
    cbxModeloPosPrinter: TComboBox;
    cbxPagCodigo: TComboBox;
    cbxPorta: TComboBox;
    cbEnviarImpressora: TCheckBox;
    edRazaoSocial: TEdit;
    edLog: TEdit;
    edAplicacaoNome: TEdit;
    edRegistro: TEdit;
    edAplicacaoVersao: TEdit;
    gbConfigImpressora: TGroupBox;
    gbConfigTEF: TGroupBox;
    gbPagamentos: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label8: TLabel;
    lNumOperacao: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label7: TLabel;
    lSaidaImpressao: TLabel;
    mImpressao: TMemo;
    mLog: TMemo;
    pImpressoraBotes: TPanel;
    pImpressao: TPanel;
    pMensagem: TPanel;
    pMensagemCliente: TPanel;
    pMensagemOperador: TPanel;
    pPrincipal: TPanel;
    pBotoesConfiguracao: TPanel;
    pConfiguracao: TPanel;
    pLogs: TPanel;
    pBotoesPagamentos: TPanel;
    pSimulador: TPanel;
    pStatus: TPanel;
    edTotalVenda: TEdit;
    edTotalPago: TEdit;
    edTroco: TEdit;
    gbTotaisVenda: TGroupBox;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ImageList1: TImageList;
    pOperacao: TPanel;
    pgPrincipal: TPageControl;
    SbArqLog: TSpeedButton;
    seColunas: TSpinEdit;
    seEspLinhas: TSpinEdit;
    seLinhasPular: TSpinEdit;
    seMaxCartoes: TSpinEdit;
    seTotalAcrescimo: TSpinEdit;
    seTotalDesconto: TSpinEdit;
    seTrocoMaximo: TSpinEdit;
    seValorInicialVenda: TSpinEdit;
    sbLimparLog: TSpeedButton;
    Splitter1: TSplitter;
    sgPagamentos: TStringGrid;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    tsConfiguracao: TTabSheet;
    tsOperacao: TTabSheet;
    procedure ACBrTEFD1AguardaResp(Arquivo: String; SegundosTimeOut: Integer;
      var Interromper: Boolean);
    procedure ACBrTEFD1AntesFinalizarRequisicao(Req: TACBrTEFDReq);
    procedure ACBrTEFD1BloqueiaMouseTeclado(Bloqueia: Boolean;
      var Tratado: Boolean);
    procedure ACBrTEFD1ComandaECF(Operacao: TACBrTEFDOperacaoECF;
      Resp: TACBrTEFDResp; var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFAbreVinculado(COO, IndiceECF: String;
      Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFImprimeVia(
      TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer;
      ImagemComprovante: TStringList; var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFPagamento(IndiceECF: String; Valor: Double;
      var RetornoECF: Integer);
    procedure ACBrTEFD1ComandaECFSubtotaliza(DescAcre: Double;
      var RetornoECF: Integer);
    procedure ACBrTEFD1DepoisConfirmarTransacoes(
      RespostasPendentes: TACBrTEFDRespostasPendentes);
    procedure ACBrTEFD1ExibeMsg(Operacao: TACBrTEFDOperacaoMensagem;
      Mensagem: String; var AModalResult: TModalResult);
    procedure ACBrTEFD1GravarLog(const GP: TACBrTEFDTipo; ALogLine: String;
      var Tratado: Boolean);
    procedure ACBrTEFD1InfoECF(Operacao: TACBrTEFDInfoECF;
      var RetornoECF: String);
    procedure btAdministrativoClick(Sender: TObject);
    procedure btEfetuarPagamentosClick(Sender: TObject);
    procedure btIncluirPagamentosClick(Sender: TObject);
    procedure btOperacaoClick(Sender: TObject);
    procedure btLerParametrosClick(Sender: TObject);
    procedure btMudaPaginaClick(Sender: TObject);
    procedure btProcuraImpressorasClick(Sender: TObject);
    procedure btSalvarParametrosClick(Sender: TObject);
    procedure btSerialClick(Sender: TObject);
    procedure btTestarPosPrinterClick(Sender: TObject);
    procedure btTestarTEFClick(Sender: TObject);
    procedure btObterCPFClick(Sender: TObject);
    procedure cbEnviarImpressoraChange(Sender: TObject);
    procedure CliSiTefExibeMenu(Titulo: String; Opcoes: TStringList;
      var ItemSelecionado: Integer; var VoltarMenu: Boolean);
    procedure CliSiTefObtemCampo(Titulo: String; TamanhoMinimo,
      TamanhoMaximo: Integer; TipoCampo: Integer;
      Operacao: TACBrTEFDCliSiTefOperacaoCampo; var Resposta: AnsiString;
      var Digitado: Boolean; var VoltarMenu: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btLimparImpressoraClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbLimparLogClick(Sender: TObject);
    procedure seTotalAcrescimoChange(Sender: TObject);
    procedure seTotalDescontoChange(Sender: TObject);
    procedure seValorInicialVendaChange(Sender: TObject);
  private
    FVenda: TVenda;
    FTipoBotaoOperacao: TTipoBotaoOperacao;
    FCanceladoPeloOperador: Boolean;
    FTempoDeEspera: TDateTime;
    FTestePayGo: Integer;

    function GetNomeArquivoConfiguracao: String;
    function GetNomeArquivoVenda: String;
    function GetStatusVenda: TStatusVenda;
    procedure SetTipoBotaoOperacao(AValue: TTipoBotaoOperacao);
    procedure SetStatusVenda(AValue: TStatusVenda);

    procedure TratarException(Sender : TObject; E : Exception);
  protected
    procedure LerConfiguracao;
    procedure GravarConfiguracao;

    procedure IrParaOperacaoTEF;
    procedure IrParaConfiguracao;

    procedure ConfigurarTEF;
    procedure AtivarTEF;
    procedure ConfigurarPosPrinter;
    procedure AtivarPosPrinter;
    procedure Ativar;
    procedure Desativar;

    procedure IniciarOperacao;
    procedure AdicionarPagamento(const Indice: String; AValor: Double);
    procedure CancelarVenda;
    procedure FinalizarVenda; // Em caso de Venda, Gere e transmita seu Documento Fiscal
    procedure VerificarTestePayGo;

    procedure AtualizarCaixaLivreNaInterface;
    procedure AtualizarVendaNaInterface;
    procedure AtualizarTotaisVendaNaInterface;
    procedure AtualizarPagamentosVendaNaInterface;
    procedure MensagemTEF(const MsgOperador, MsgCliente: String);
    procedure LimparMensagensTEF;

    procedure AdicionarLinhaLog(AMensagem: String);
    procedure AdicionarLinhaImpressao(ALinha: String);
  public
    property NomeArquivoConfiguracao: String read GetNomeArquivoConfiguracao;
    property NomeArquivoVenda: String read GetNomeArquivoVenda;

    property StatusVenda: TStatusVenda read GetStatusVenda write SetStatusVenda;
    property TipoBotaoOperacao: TTipoBotaoOperacao read FTipoBotaoOperacao write SetTipoBotaoOperacao;

    property Venda: TVenda read FVenda;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  IniFiles, typinfo, dateutils, math, strutils,
  frIncluirPagamento, frMenuTEF, frObtemCampo,
  configuraserial,
  ACBrUtil;

{$R *.dfm}

{ TFormPrincipal }

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  I: TACBrTEFDTipo;
  N: TACBrPosPrinterModelo;
  O: TACBrPosPaginaCodigo;
begin
  FVenda := TVenda.Create(NomeArquivoVenda);

  cbxGP.Items.Clear ;
  For I := Low(TACBrTEFDTipo) to High(TACBrTEFDTipo) do
     cbxGP.Items.Add( GetEnumName(TypeInfo(TACBrTEFDTipo), integer(I) ) ) ;
  cbxGP.ItemIndex := 0 ;

  cbxModeloPosPrinter.Items.Clear ;
  For N := Low(TACBrPosPrinterModelo) to High(TACBrPosPrinterModelo) do
     cbxModeloPosPrinter.Items.Add( GetEnumName(TypeInfo(TACBrPosPrinterModelo), integer(N) ) ) ;

  cbxPagCodigo.Items.Clear ;
  For O := Low(TACBrPosPaginaCodigo) to High(TACBrPosPaginaCodigo) do
     cbxPagCodigo.Items.Add( GetEnumName(TypeInfo(TACBrPosPaginaCodigo), integer(O) ) ) ;

  ImageList1.GetBitmap(1, btMudaPagina.Glyph);
  ImageList1.GetBitmap(1, btEfetuarPagamentos.Glyph);
  ImageList1.GetBitmap(2, btSalvarParametros.Glyph);
  ImageList1.GetBitmap(3, btLerParametros.Glyph);
  ImageList1.GetBitmap(4, btTestarPosPrinter.Glyph);
  ImageList1.GetBitmap(4, btImprimir.Glyph);
  ImageList1.GetBitmap(5, btTestarTEF.Glyph);
  ImageList1.GetBitmap(6, btSerial.Glyph);
  ImageList1.GetBitmap(7, btLimparImpressora.Glyph);
  ImageList1.GetBitmap(7, sbLimparLog.Glyph);
  ImageList1.GetBitmap(8, btIncluirPagamentos.Glyph);
  ImageList1.GetBitmap(9, btExcluirPagamento.Glyph);
  ImageList1.GetBitmap(10, btAdministrativo.Glyph);
  ImageList1.GetBitmap(11, sbLimparLog.Glyph);
  ImageList1.GetBitmap(12, btProcuraImpressoras.Glyph);

  with sgPagamentos do
  begin
    ColWidths[0] := 35;
    ColWidths[1] := 150;
    ColWidths[2] := 100;
    ColWidths[3] := 110;
    ColWidths[4] := 110;
    ColWidths[5] := 50;
    ColWidths[6] := 140;

    Cells[0, 0] := 'Item';
    Cells[1, 0] := 'Forma de Pagamento';
    Cells[2, 0] := 'Valor';
    Cells[3, 0] := 'NSU';
    Cells[4, 0] := 'Rede';
    Cells[5, 0] := 'CNF';
    Cells[6, 0] := 'CNPJ Credenciadora';
  end;

  tsConfiguracao.TabVisible := False;
  tsOperacao.TabVisible := False;
  pgPrincipal.ActivePageIndex := 0;

  LerConfiguracao;
  LimparMensagensTEF;
  FTipoBotaoOperacao := High(TTipoBotaoOperacao);    // For�a atualizar tela
  Venda.Status := High(TStatusVenda);                // For�a atualizar tela
  FCanceladoPeloOperador := False;
  FTempoDeEspera := 0;
  FTestePayGo := 0;

  Application.OnException := TratarException;
  ACBrTEFD1.TEFCliSiTef.OnObtemCampo := CliSiTefObtemCampo;

  btProcuraImpressoras.Click;
end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
  FVenda.Free;
end;

procedure TFormPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 27) and (btOperacao.Visible and btOperacao.Enabled) then
  begin
    btOperacao.Click;
    Key := 0;
  end;
end;

procedure TFormPrincipal.btImprimirClick(Sender: TObject);
begin
  ACBrPosPrinter1.Buffer.Assign(mImpressao.Lines);
  ACBrPosPrinter1.Imprimir;
end;

procedure TFormPrincipal.btLimparImpressoraClick(Sender: TObject);
begin
  mImpressao.Lines.Clear;
end;

procedure TFormPrincipal.sbLimparLogClick(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TFormPrincipal.seTotalAcrescimoChange(Sender: TObject);
begin
  Venda.TotalAcrescimo := seTotalAcrescimo.Value;
  AtualizarTotaisVendaNaInterface;
end;

procedure TFormPrincipal.seTotalDescontoChange(Sender: TObject);
begin
  Venda.TotalDesconto := seTotalDesconto.Value;
  AtualizarTotaisVendaNaInterface;
end;

procedure TFormPrincipal.btMudaPaginaClick(Sender: TObject);
begin
  if pgPrincipal.ActivePage = tsConfiguracao then
    IrParaOperacaoTEF
  else
    IrParaConfiguracao;
end;

procedure TFormPrincipal.btProcuraImpressorasClick(Sender: TObject);
begin
  cbxPorta.Items.Clear;
  ACBrPosPrinter1.Device.AcharPortasSeriais( cbxPorta.Items );
  {$IfDef MSWINDOWS}
  ACBrPosPrinter1.Device.AcharPortasUSB( cbxPorta.Items );
  {$EndIf}
  ACBrPosPrinter1.Device.AcharPortasRAW( cbxPorta.Items );

  cbxPorta.Items.Add('TCP:192.168.0.31:9100') ;

  {$IfNDef MSWINDOWS}
   cbxPorta.Items.Add('/dev/ttyS0') ;
   cbxPorta.Items.Add('/dev/ttyUSB0') ;
   cbxPorta.Items.Add('/tmp/ecf.txt') ;
  {$Else}
   cbxPorta.Items.Add('\\localhost\Epson') ;
   cbxPorta.Items.Add('c:\temp\ecf.txt') ;
  {$EndIf}
end;

procedure TFormPrincipal.btLerParametrosClick(Sender: TObject);
begin
  LerConfiguracao;
end;

procedure TFormPrincipal.btOperacaoClick(Sender: TObject);
begin
  AdicionarLinhaLog('- btOperacaoClick');

  case TipoBotaoOperacao of
    bopLiberarCaixa:
      StatusVenda := stsLivre;

    bopCancelarVenda:
      CancelarVenda;

    bopCancelarEsperaTEF:
      FCanceladoPeloOperador := True;
  end;
end;

procedure TFormPrincipal.btEfetuarPagamentosClick(Sender: TObject);
begin
  VerificarTestePayGo;
  StatusVenda := stsEmPagamento;
  btIncluirPagamentos.Click;
end;

procedure TFormPrincipal.btIncluirPagamentosClick(Sender: TObject);
var
  FormIncluirPagamento: TFormIncluirPagamento;
begin
  FormIncluirPagamento := TFormIncluirPagamento.Create(Self);
  try
    FormIncluirPagamento.cbFormaPagamento.ItemIndex := 2;
    FormIncluirPagamento.seValorPago.Value := -Trunc(Venda.Troco);
    if (FormIncluirPagamento.ShowModal = mrOK) then
    begin
      AdicionarPagamento( cPagamentos[FormIncluirPagamento.cbFormaPagamento.ItemIndex, 0],
                          FormIncluirPagamento.seValorPago.Value );
    end;
  finally
    FormIncluirPagamento.Free;
  end;
end;

procedure TFormPrincipal.ACBrTEFD1ExibeMsg(Operacao: TACBrTEFDOperacaoMensagem;
  Mensagem: String; var AModalResult: TModalResult);
var
   Fim : TDateTime;
   OldMensagem : String;
begin
  case Operacao of

    opmOK:
       AModalResult := MessageDlg( Mensagem, mtInformation, [mbOK], 0);

    opmYesNo:
       AModalResult := MessageDlg( Mensagem, mtConfirmation, [mbYes, mbNo], 0);

    opmExibirMsgOperador:
      MensagemTEF(Mensagem,'') ;

    opmRemoverMsgOperador:
      MensagemTEF(' ','') ;

    opmExibirMsgCliente:
      MensagemTEF('', Mensagem) ;

    opmRemoverMsgCliente:
      MensagemTEF('', ' ') ;

    opmDestaqueVia:
      begin
        OldMensagem := pMensagemOperador.Caption ;
        try
          { Aguardando 3 segundos }
          Fim := IncSecond(now, 3)  ;
          repeat
            MensagemTEF(Mensagem + ' ' + IntToStr(SecondsBetween(Fim,now)), '');
            Sleep(200) ;
          until (now > Fim) ;
        finally
          MensagemTEF(OldMensagem, '');
        end;
      end;
  end;
end;

procedure TFormPrincipal.ACBrTEFD1DepoisConfirmarTransacoes(
  RespostasPendentes: TACBrTEFDRespostasPendentes);
var
  i , j: Integer;
begin
  for i := 0 to RespostasPendentes.Count-1  do
  begin
     with RespostasPendentes[i] do
     begin
        AdicionarLinhaLog('Confirmado: '+Header+' ID: '+IntToStr( ID ) );

        // Lendo os campos mapeados //
        AdicionarLinhaLog('- Rede: '  + Rede + ', NSU: '  + NSU );
        //AdicionarLinhaLog('- Parcelas: '+ IntToStr(QtdParcelas) +
        //                  ', parcelado por: '+ GetEnumName(TypeInfo(TACBrTEFRespParceladoPor), integer(ParceladoPor) ));
        AdicionarLinhaLog('- � D�bito: '+BoolToStr(Debito)+
                          ', � Cr�dito: '+BoolToStr(Credito)+
                          ', Valor: '+ FormatFloat('###,###,##0.00',ValorTotal)) ;

        // Lendo um Campo Espec�fico //
        //AdicionarLinhaLog('- Campo 11: ' + LeInformacao(11,0).AsString );

        for j := 0 to Venda.Pagamentos.Count-1 do
        begin
          if NSU = Venda.Pagamentos[j].NSU then
          begin
            Venda.Pagamentos[j].Confirmada := True;
            Break;
          end;
        end;
     end;
  end;

  AtualizarPagamentosVendaNaInterface;
end;

procedure TFormPrincipal.ACBrTEFD1ComandaECF(Operacao: TACBrTEFDOperacaoECF;
  Resp: TACBrTEFDResp; var RetornoECF: Integer);

  procedure PularLinhasECortar;
  begin
    AdicionarLinhaImpressao('</pular_linhas>');
    AdicionarLinhaImpressao('</corte>');
  end;

begin
  AdicionarLinhaLog('ACBrTEFD1ComandaECF: '+GetEnumName( TypeInfo(TACBrTEFDOperacaoECF), integer(Operacao) ));

  try
    case Operacao of
      opeAbreGerencial:
        AdicionarLinhaImpressao('</zera>');

      opeSubTotalizaCupom:
      begin
        if StatusVenda = stsIniciada then
          StatusVenda := stsEmPagamento;
      end;

      opeCancelaCupom:
        CancelarVenda;

      opeFechaCupom:
        FinalizarVenda;

      opePulaLinhas:
        PularLinhasECortar;

      opeFechaGerencial, opeFechaVinculado:
      begin
        PularLinhasECortar;
        if StatusVenda in [stsOperacaoTEF] then
          StatusVenda := stsFinalizada;
      end;
    end;

    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TFormPrincipal.ACBrTEFD1AntesFinalizarRequisicao(Req: TACBrTEFDReq);
begin
  AdicionarLinhaLog('Enviando: '+Req.Header+' ID: '+IntToStr( Req.ID ) );

  FCanceladoPeloOperador := False;
  FTempoDeEspera := 0;
  // Use esse evento, para inserir campos personalizados, ou modificar o arquivo
  // de requisi�o, que ser� criado e envido para o Gerenciador Padr�o

  if (FTestePayGo > 0) then
  begin
    if (Req.Header = 'CRT') and (FTestePayGo = 2) then // Passo 02 - Venda � vista aprovada com pr�-sele��o de par�metros
    begin
      Req.GravaInformacao(010,000,'CERTIF');
      Req.GravaInformacao(730,000,'1');  // opera��o �VENDA�
      Req.GravaInformacao(731,000,'1');  // tipo de cart�o �CR�DITO�
      Req.GravaInformacao(732,000,'1');  // tipo de financiamento �� VISTA�
      FTestePayGo := 0;
    end

    else if (Req.Header = 'CRT') and (FTestePayGo = 3) then // Passo 03 - Venda parcelada aprovada com pr�-sele��o de par�metros
    begin
      Req.GravaInformacao(010,000,'CERTIF');
      Req.GravaInformacao(018,000,'3');  // n�mero de parcelas = 3
      Req.GravaInformacao(730,000,'1');  // opera��o �VENDA�
      Req.GravaInformacao(731,000,'2');  // tipo de cart�o �D�BITO�
      Req.GravaInformacao(732,000,'3');  // tipo de financiamento �PARCELADO PELO ESTABELECIMENTO�
      FTestePayGo := 0;
    end

    else if (Req.Header = 'CRT') and (FTestePayGo = 4) then // Passo 04 - Venda aprovada em moeda estrangeira
    begin
      Req.GravaInformacao(004,000,'1');  // D�lar americano
      FTestePayGo := 0;
    end

    else if (Req.Header = 'CRT') and (FTestePayGo = 27) then // Passo 27 - Venda aprovada com pr�-sele��o de par�metros de carteira digital
    begin
      Req.GravaInformacao(010,000,'CERTIF');
      Req.GravaInformacao(749,000,'8');  // Tipo de Pagamento como carteira digital
      Req.GravaInformacao(750,000,'1');  // Identifica��o da Carteira Digital como QR Code
      FTestePayGo := 0;
    end

    else if (Req.Header = 'ADM') and (FTestePayGo = 31) then // Passo 31 - Opera��o bem sucedida com valor pr�-definido
    begin
      Req.GravaInformacao(003,000,'1');
      FTestePayGo := 0;
    end;
  end;
end;

procedure TFormPrincipal.ACBrTEFD1AguardaResp(Arquivo: String;
  SegundosTimeOut: Integer; var Interromper: Boolean);
var
  Msg : String ;
begin
  if FCanceladoPeloOperador then
  begin
    FCanceladoPeloOperador := False;
    Interromper := True ;
    Exit;
  end;

  Msg := '' ;
  if (ACBrTEFD1.GPAtual in [gpCliSiTef, gpVeSPague]) then   // � TEF dedicado ?
   begin
     if (Arquivo = '23') and ACBrTEFD1.TecladoBloqueado then  // Est� aguardando Pin-Pad ?
     begin
       // Desbloqueia o Teclado
       ACBrTEFD1.BloquearMouseTeclado(False);
       // Ajusta Interface para Espera do TEF, com op�ao de cancelamento pelo Operador
       StatusVenda := stsAguardandoTEF;

       Msg := 'Aguardando Resposta do Pinpad.  Pressione <ESC> para Cancelar';
       FCanceladoPeloOperador := False;
     end;
   end
  else if FTempoDeEspera <> SegundosTimeOut then
  begin
     Msg := 'Aguardando: '+Arquivo+' '+IntToStr(SegundosTimeOut) ;
     FTempoDeEspera := SegundosTimeOut;
  end;

  if Msg <> '' then
    AdicionarLinhaLog(Msg);

  Application.ProcessMessages;
end;

procedure TFormPrincipal.ACBrTEFD1BloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
begin
  Self.Enabled := not Bloqueia ;
  AdicionarLinhaLog('BloqueiaMouseTeclado = '+IfThen(Bloqueia,'SIM', 'NAO'));
  Tratado := False ;  { Deixa executar o c�digo de Bloqueio do ACBrTEFD }
end;

procedure TFormPrincipal.ACBrTEFD1ComandaECFAbreVinculado(COO,
  IndiceECF: String; Valor: Double; var RetornoECF: Integer);
begin
  AdicionarLinhaLog( 'ACBrTEFD1ComandaECFAbreVinculado, COO:'+COO+
     ' IndiceECF: '+IndiceECF+' Valor: '+FormatFloatBr(Valor) ) ;
  AdicionarLinhaImpressao('</zera>');
  AdicionarLinhaImpressao('</linha_dupla>');
  RetornoECF := 1;
end;

procedure TFormPrincipal.ACBrTEFD1ComandaECFImprimeVia(
  TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer;
  ImagemComprovante: TStringList; var RetornoECF: Integer);
begin
  AdicionarLinhaLog( 'ACBrTEFD1ComandaECFImprimeVia: '+IntToStr(Via) );
  AdicionarLinhaImpressao( ImagemComprovante.Text );
  RetornoECF := 1 ;
end;

procedure TFormPrincipal.ACBrTEFD1ComandaECFPagamento(IndiceECF: String;
  Valor: Double; var RetornoECF: Integer);
begin
  AdicionarLinhaLog('ACBrTEFD1ComandaECFPagamento, IndiceECF: '+IndiceECF+' Valor: '+FormatFloatBr(Valor));
  RetornoECF := 1;
end;

procedure TFormPrincipal.ACBrTEFD1ComandaECFSubtotaliza(DescAcre: Double;
  var RetornoECF: Integer);
begin
  AdicionarLinhaLog('ACBrTEFD1ComandaECFSubtotaliza: DescAcre: ' + FormatFloatBr(DescAcre));
  if StatusVenda = stsIniciada then
    StatusVenda := stsEmPagamento;
end;

procedure TFormPrincipal.ACBrTEFD1GravarLog(const GP: TACBrTEFDTipo;
  ALogLine: String; var Tratado: Boolean);
begin
  AdicionarLinhaLog(ALogLine);
  Tratado := False;
end;

procedure TFormPrincipal.ACBrTEFD1InfoECF(Operacao: TACBrTEFDInfoECF;
  var RetornoECF: String);
begin
   //try
   //   if not ACBrECF1.Ativo then
   //      ACBrECF1.Ativar ;
   //except
   //   { Para CliSiTEF ou V&SPague aplique o IF abaixo em sua aplica��o, que
   //     permite saber se o Cupom foi concluido mesmo com o ECF desligado }
   //
   //   if (not ACBrTEFD1.TEF.Inicializado) and   { Est� na inicializa��o ? }
   //      (Operacao = ineEstadoECF) and          { Quer Saber o estado do ECF ? (mas se chegou aqui � pq o ECF j� est� com problemas) }
   //      (ACBrTEFD1.GPAtual in [gpCliSiTef,gpVeSPague]) then
   //   begin
   //      { Leia o �ltimo Documento Gravado no seu Banco de Dados, e verifique
   //        se o Cupom j� foi finalizado,ou se j� foi aberto um CCD ou Gerencial...
   //        Exemplo:
   //
   //        Documento.Le(0);
   //
   //        if (Documento.Finalizado) or (pos(Documento.Denominacao,'CC|RG') > 0) then
   //           RetornoECF := 'R'
   //        else
   //           RetornoECF := 'O' ;
   //      }
   //
   //      //RetornoECF := 'O';    // Executar� CancelarTransacoesPendentes;
   //      RetornoECF := 'R';    // Executar� ConfirmarESolicitarImpressaoTransacoesPendentes;
   //      exit ;
   //   end ;
   //
   //   raise ;
   //end;

   case Operacao of
     ineSubTotal :
       RetornoECF := FloatToStr( Venda.TotalVenda ) ;

     ineTotalAPagar :
     begin
       // ACBrTEFD1.RespostasPendentes.TotalPago  deve ser subtraido, pois ACBrTEFD j� subtrai o total dos pagamentos em TEF internamente
       RetornoECF := FloatToStr( RoundTo(Venda.TotalPago - ACBrTEFD1.RespostasPendentes.TotalPago, -2) );
     end;

     ineEstadoECF :
       begin
         //"L" - Livre
         //"V" - Venda de Itens
         //"P" - Pagamento (ou SubTotal efetuado)
         //"C" ou "R" - CDC ou Cupom Vinculado
         //"G" ou "R" - Relat�rio Gerencial
         //"N" - Recebimento N�o Fiscal
         //"O" - Outro
         Case StatusVenda of
           stsIniciada:
             RetornoECF := 'V' ;
           stsEmPagamento:
             RetornoECF := 'P' ;
           stsLivre, stsFinalizada, stsCancelada, stsOperacaoTEF:
             RetornoECF := 'L' ;
         else
           RetornoECF := 'O' ;
         end;
       end;
   end;
end;

procedure TFormPrincipal.btAdministrativoClick(Sender: TObject);
begin
  AdicionarLinhaLog('- btAdministrativoClick');
  IniciarOperacao;
  StatusVenda := stsOperacaoTEF;
  try
    ACBrTEFD1.ADM;
  finally
    StatusVenda := stsFinalizada;
  end;
end;

procedure TFormPrincipal.btSalvarParametrosClick(Sender: TObject);
begin
  GravarConfiguracao;
end;

function TFormPrincipal.GetNomeArquivoConfiguracao: String;
begin
  Result := ChangeFileExt( Application.ExeName,'.ini' ) ;
end;

function TFormPrincipal.GetNomeArquivoVenda: String;
begin
  Result := ApplicationPath+'Venda.ini' ;
end;

function TFormPrincipal.GetStatusVenda: TStatusVenda;
begin
  Result := Venda.Status;
end;

procedure TFormPrincipal.LerConfiguracao;
Var
  INI : TIniFile ;
begin
  AdicionarLinhaLog('- LerConfiguracao');

  INI := TIniFile.Create(NomeArquivoConfiguracao);
  try
    cbxModeloPosPrinter.ItemIndex := INI.ReadInteger('PosPrinter', 'Modelo', 1);
    cbxPorta.Text := INI.ReadString('PosPrinter','Porta',ACBrPosPrinter1.Porta);
    cbxPagCodigo.ItemIndex := INI.ReadInteger('PosPrinter','PaginaDeCodigo', 2);
    ACBrPosPrinter1.Device.ParamsString := INI.ReadString('PosPrinter','ParamsString','');
    seColunas.Value := INI.ReadInteger('PosPrinter','Colunas', 40);
    seEspLinhas.Value := INI.ReadInteger('PosPrinter','EspacoLinhas',ACBrPosPrinter1.EspacoEntreLinhas);
    seLinhasPular.Value := INI.ReadInteger('PosPrinter','LinhasEntreCupons',ACBrPosPrinter1.LinhasEntreCupons);

    cbxGP.ItemIndex := INI.ReadInteger('TEF', 'GP', 0);
    edLog.Text := INI.ReadString('TEF', 'Log', '');
    seMaxCartoes.Value := INI.ReadInteger('TEF', 'MaxCartoes', seMaxCartoes.Value);
    seTrocoMaximo.Value := Trunc(INI.ReadFloat('TEF', 'TrocoMaximo', seTrocoMaximo.Value));
    cbImprimirViaReduzida.Checked := INI.ReadBool('TEF', 'ImprimirViaReduzida', cbImprimirViaReduzida.Checked);
    cbMultiplosCartoes.Checked := INI.ReadBool('TEF', 'MultiplosCartoes', cbMultiplosCartoes.Checked);
    cbSuportaDesconto.Checked := INI.ReadBool('TEF', 'SuportaDesconto', cbSuportaDesconto.Checked);
    cbSuportaSaque.Checked := INI.ReadBool('TEF', 'SuportaSaque', cbSuportaSaque.Checked);
    cbSuportaReajusteValor.Checked := INI.ReadBool('TEF', 'SuportaReajusteValor', cbSuportaReajusteValor.Checked);

    edRazaoSocial.Text := INI.ReadString('Aplicacao', 'RazaoSocial', edRazaoSocial.Text);
    edRegistro.Text := INI.ReadString('Aplicacao', 'Registro', edRegistro.Text);
    edAplicacaoNome.Text := INI.ReadString('Aplicacao', 'Nome', edAplicacaoNome.Text);
    edAplicacaoVersao.Text := INI.ReadString('Aplicacao', 'Versao', edAplicacaoVersao.Text);
  finally
     INI.Free ;
  end ;
end;

procedure TFormPrincipal.GravarConfiguracao;
Var
  INI : TIniFile ;
begin
  AdicionarLinhaLog('- GravarConfiguracao');

  INI := TIniFile.Create(NomeArquivoConfiguracao);
  try
    INI.WriteInteger('PosPrinter', 'Modelo', cbxModeloPosPrinter.ItemIndex);
    INI.WriteString('PosPrinter','Porta', cbxPorta.Text);
    INI.WriteInteger('PosPrinter','PaginaDeCodigo', cbxPagCodigo.ItemIndex);
    INI.WriteString('PosPrinter','ParamsString', ACBrPosPrinter1.Device.ParamsString);
    INI.WriteInteger('PosPrinter','Colunas', seColunas.Value);
    INI.WriteInteger('PosPrinter','EspacoLinhas', seEspLinhas.Value);
    INI.WriteInteger('PosPrinter','LinhasEntreCupons', seLinhasPular.Value);

    INI.WriteInteger('TEF', 'GP', cbxGP.ItemIndex);
    INI.WriteString('TEF', 'Log', edLog.Text);
    INI.WriteInteger('TEF', 'MaxCartoes', seMaxCartoes.Value);
    INI.WriteFloat('TEF', 'TrocoMaximo', seTrocoMaximo.Value);
    INI.WriteBool('TEF', 'ImprimirViaReduzida', cbImprimirViaReduzida.Checked);
    INI.WriteBool('TEF', 'MultiplosCartoes', cbMultiplosCartoes.Checked);
    INI.WriteBool('TEF', 'SuportaDesconto', cbSuportaDesconto.Checked);
    INI.WriteBool('TEF', 'SuportaSaque', cbSuportaSaque.Checked);
    INI.WriteBool('TEF', 'SuportaReajusteValor', cbSuportaReajusteValor.Checked);

    INI.WriteString('Aplicacao', 'RazaoSocial', edRazaoSocial.Text);
    INI.WriteString('Aplicacao', 'Registro', edRegistro.Text);
    INI.WriteString('Aplicacao', 'Nome', edAplicacaoNome.Text);
    INI.WriteString('Aplicacao', 'Versao', edAplicacaoVersao.Text);
  finally
     INI.Free ;
  end ;
end;

procedure TFormPrincipal.IrParaOperacaoTEF;
begin
  AdicionarLinhaLog('- IrParaOperacaoTEF');
  Ativar;
  btMudaPagina.Caption := 'Configura��o';
  btMudaPagina.Glyph := nil;
  ImageList1.GetBitmap(0, btMudaPagina.Glyph);
  pgPrincipal.ActivePage := tsOperacao;
  btImprimir.Enabled := ACBrPosPrinter1.Ativo;
  cbEnviarImpressora.Enabled := ACBrPosPrinter1.Ativo;
  cbEnviarImpressora.Checked := cbEnviarImpressora.Enabled;
  StatusVenda := stsLivre;
end;

procedure TFormPrincipal.IrParaConfiguracao;
begin
  AdicionarLinhaLog('- IrParaConfiguracao');
  Desativar;
  btMudaPagina.Caption := 'Opera��o TEF';
  btMudaPagina.Glyph := nil;
  ImageList1.GetBitmap(1, btMudaPagina.Glyph);
  pgPrincipal.ActivePage := tsConfiguracao;
end;

procedure TFormPrincipal.AdicionarLinhaLog(AMensagem: String);
begin
  mLog.Lines.Add(AMensagem);
end;

procedure TFormPrincipal.AdicionarLinhaImpressao(ALinha: String);
begin
  mImpressao.Lines.Add(ALinha);
  if ACBrPosPrinter1.Ativo then
    ACBrPosPrinter1.Imprimir(ALinha);
end;

procedure TFormPrincipal.SetTipoBotaoOperacao(AValue: TTipoBotaoOperacao);
var
  MsgOperacao: String;
begin
  if FTipoBotaoOperacao = AValue then Exit;

  MsgOperacao := '';

  case AValue of
    bopCancelarVenda, bopCancelarEsperaTEF:
      MsgOperacao := 'Cancelar';

    bopLiberarCaixa:
      MsgOperacao := 'Liberar';
  end;

  FTipoBotaoOperacao := AValue;

  btOperacao.Visible := (MsgOperacao <> '');
  btOperacao.Caption := 'ESC - '+MsgOperacao;
end;

procedure TFormPrincipal.SetStatusVenda(AValue: TStatusVenda);
var
  MsgStatus: String;
begin
  if StatusVenda = AValue then
    Exit;

  AdicionarLinhaLog('- StatusOperacao: '+GetEnumName(TypeInfo(TStatusVenda), integer(AValue) ));

  gbTotaisVenda.Enabled := (AValue in [stsLivre, stsIniciada]);
  gbPagamentos.Enabled := (AValue = stsEmPagamento);
  btAdministrativo.Enabled := (AValue = stsLivre);
  btObterCPF.Enabled := btAdministrativo.Enabled;
  pImpressao.Enabled := (AValue in [stsLivre, stsFinalizada, stsCancelada]);
  btEfetuarPagamentos.Enabled := (AValue = stsIniciada);
  lNumOperacao.Visible := (AValue <> stsLivre);

  case AValue of
    stsIniciada:
    begin
      MsgStatus := 'EM VENDA';
      TipoBotaoOperacao := bopCancelarVenda;
      AtualizarVendaNaInterface;
    end;

    stsEmPagamento:
    begin
      MsgStatus := 'EM PAGAMENTO';
      TipoBotaoOperacao := bopCancelarVenda;
      sgPagamentos.SetFocus;
    end;

    stsFinalizada:
    begin
      MsgStatus := 'FINALIZADA';
      TipoBotaoOperacao := bopLiberarCaixa;
    end;

    stsCancelada:
    begin
      MsgStatus := 'CANCELADA';
      TipoBotaoOperacao := bopLiberarCaixa;
    end;

    stsAguardandoTEF:
    begin
      MsgStatus := 'TRANSACAO TEF';
      TipoBotaoOperacao := bopCancelarEsperaTEF;
    end;

    stsOperacaoTEF:
    begin
      MsgStatus := 'OPERA��O TEF';
      TipoBotaoOperacao := bopNaoExibir;
      AtualizarVendaNaInterface;
    end;

  else
    MsgStatus := 'CAIXA LIVRE';
    TipoBotaoOperacao := bopNaoExibir;
    seValorInicialVenda.SetFocus;
    AtualizarCaixaLivreNaInterface;
  end;

  pStatus.Caption := MsgStatus;
  Venda.Status := AValue;
  if (AValue <> stsLivre) then
    Venda.Gravar;
end;

procedure TFormPrincipal.TratarException(Sender: TObject; E: Exception);
begin
  AdicionarLinhaLog('');
  AdicionarLinhaLog('***************' + E.ClassName + '***************');
  AdicionarLinhaLog(E.Message);
  AdicionarLinhaLog('');
end;

procedure TFormPrincipal.btSerialClick(Sender: TObject);
var
  frConfiguraSerial: TfrConfiguraSerial;
begin
  AdicionarLinhaLog('- btSerialClick');
  frConfiguraSerial := TfrConfiguraSerial.Create(self);
  try
    frConfiguraSerial.Device.Porta        := ACBrPosPrinter1.Device.Porta ;
    frConfiguraSerial.cmbPortaSerial.Text := cbxPorta.Text ;
    frConfiguraSerial.Device.ParamsString := ACBrPosPrinter1.Device.ParamsString ;

    if frConfiguraSerial.ShowModal = mrOk then
    begin
      cbxPorta.Text := frConfiguraSerial.cmbPortaSerial.Text ;
      ACBrPosPrinter1.Device.ParamsString := frConfiguraSerial.Device.ParamsString ;
    end ;
  finally
    FreeAndNil( frConfiguraSerial ) ;
  end ;
end;

procedure TFormPrincipal.btTestarPosPrinterClick(Sender: TObject);
var
  SL: TStringList;
begin
  AdicionarLinhaLog('- btTestarPosPrinterClick');
  try
    AtivarPosPrinter;

    SL := TStringList.Create;
    try
      SL.Add('</zera>');
      SL.Add('</linha_dupla>');
      SL.Add('FONTE NORMAL: '+IntToStr(ACBrPosPrinter1.ColunasFonteNormal)+' Colunas');
      SL.Add(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteNormal));
      SL.Add('<e>EXPANDIDO: '+IntToStr(ACBrPosPrinter1.ColunasFonteExpandida)+' Colunas');
      SL.Add(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteExpandida));
      SL.Add('</e><c>CONDENSADO: '+IntToStr(ACBrPosPrinter1.ColunasFonteCondensada)+' Colunas');
      SL.Add(LeftStr('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8', ACBrPosPrinter1.ColunasFonteCondensada));
      SL.Add('</c><n>FONTE NEGRITO</N>');
      SL.Add('<in>FONTE INVERTIDA</in>');
      SL.Add('<S>FONTE SUBLINHADA</s>');
      SL.Add('<i>FONTE ITALICO</i>');
      SL.Add('FONTE NORMAL');
      SL.Add('');
      SL.Add('TESTE DE ACENTOS. ����������');
      SL.Add('');
      SL.Add('</corte_total>');

      cbEnviarImpressora.Checked := True;
      AdicionarLinhaImpressao(SL.Text);
    finally
       SL.Free;
    end;
  except
    On E: Exception do
    begin
      MessageDlg('Falha ao ativar a Impressora' + sLineBreak + E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TFormPrincipal.btTestarTEFClick(Sender: TObject);
var
  NomeTEF: String;
begin
  NomeTEF := GetEnumName(TypeInfo(TACBrTEFDTipo), cbxGP.ItemIndex);
  AdicionarLinhaLog('- btTestarTEFClick: '+NomeTEF);
  try
    AtivarTEF;
    ACBrTEFD1.ATV;
    MessageDlg(Format('TEF %S ATIVO', [NomeTEF]), mtInformation, [mbOK], 0);
  except
    On E: Exception do
    begin
      MessageDlg(Format('Falha ao ativar TEF %S' + sLineBreak + E.Message, [NomeTEF]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TFormPrincipal.btObterCPFClick(Sender: TObject);
var
  Saida: AnsiString;
begin
  Saida := '';
  if ACBrTEFD1.GPAtual = gpCliSiTef then
  begin
    // SiTef precisa de par�metros extras, vamos informar...
    ACBrTEFD1.TEFCliSiTef.PinPadIdentificador := '01.123.456/0001-07';
    ACBrTEFD1.TEFCliSiTef.PinPadChaveAcesso := 'Chave Fornecida pela Software Express, eclusiva para o Identificador acima';
  end;

  ACBrTEFD1.CDP('F', Saida);  // F=CPF
  if (Saida <> '') then
    ShowMessage(Saida)
  else
    ShowMessage('Falha ao Obter CPF no PinPad');
end;

procedure TFormPrincipal.cbEnviarImpressoraChange(Sender: TObject);
begin
  btImprimir.Enabled := ACBrPosPrinter1.Ativo and (not cbEnviarImpressora.Checked);
end;

procedure TFormPrincipal.CliSiTefExibeMenu(Titulo: String; Opcoes: TStringList;
  var ItemSelecionado: Integer; var VoltarMenu: Boolean);
Var
  MR: TModalResult ;
begin
  FormMenuTEF := TFormMenuTEF.Create(self);
  try
    FormMenuTEF.Panel1.Caption := Titulo;
    FormMenuTEF.ListBox1.Items.AddStrings(Opcoes);

    MR := FormMenuTEF.ShowModal ;

    VoltarMenu := (MR = mrRetry) ;

    if (MR = mrOK) then
      ItemSelecionado := FormMenuTEF.ListBox1.ItemIndex;
  finally
    FormMenuTEF.Free;
  end;
end;

procedure TFormPrincipal.CliSiTefObtemCampo(Titulo: String; TamanhoMinimo,
  TamanhoMaximo: Integer; TipoCampo: Integer;
  Operacao: TACBrTEFDCliSiTefOperacaoCampo; var Resposta: AnsiString;
  var Digitado: Boolean; var VoltarMenu: Boolean);
Var
  MR: TModalResult ;
begin
  FormObtemCampo := TFormObtemCampo.Create(self);
  try
    FormObtemCampo.Panel1.Caption := Titulo;
    FormObtemCampo.TamanhoMaximo  := TamanhoMaximo;
    FormObtemCampo.TamanhoMinimo  := TamanhoMinimo;
    FormObtemCampo.Operacao       := Operacao;
    FormObtemCampo.TipoCampo      := TipoCampo;
    FormObtemCampo.Edit1.Text     := Resposta; { Para usar Valores Previamente informados }

    MR := FormObtemCampo.ShowModal ;

    Digitado   := (MR = mrOK) ;
    VoltarMenu := (MR = mrRetry) ;

    if Digitado then
       Resposta := FormObtemCampo.Edit1.Text;
  finally
    FormObtemCampo.Free;
  end;
end;

procedure TFormPrincipal.seValorInicialVendaChange(Sender: TObject);
begin
  seTotalDesconto.MaxValue := seValorInicialVenda.Value;
  if (seValorInicialVenda.Value <> 0) and (StatusVenda = stsLivre) then
  begin
    IniciarOperacao;
    Venda.ValorInicial := seValorInicialVenda.Value;
    StatusVenda := stsIniciada;
  end
  else
  begin
    Venda.ValorInicial := seValorInicialVenda.Value;
    AtualizarTotaisVendaNaInterface;
  end;
end;

procedure TFormPrincipal.AtualizarCaixaLivreNaInterface;
begin
  AdicionarLinhaLog('- AtualizarCaixaLivreNaInterface');
  LimparMensagensTEF;
  mImpressao.Clear;
  cbTestePayGo.ItemIndex := 0;
  Venda.Clear;
  AtualizarVendaNaInterface;
  FCanceladoPeloOperador := False;
  FTempoDeEspera := 0;
end;

procedure TFormPrincipal.IniciarOperacao;
var
  ProxVenda: Integer;
begin
  Venda.Ler;
  ProxVenda := Venda.NumOperacao+1;

  Venda.Clear;
  Venda.NumOperacao := ProxVenda;
  Venda.DHInicio := Now;
  FCanceladoPeloOperador := False;
  FTempoDeEspera := 0;
end;

procedure TFormPrincipal.AdicionarPagamento(const Indice: String; AValor: Double
  );
var
  Ok, TemTEF: Boolean;
  ReajusteValor: Double;
begin
  Ok := True;
  TemTEF := False;

  if (Indice = '02') then
  begin
    Ok := ACBrTEFD1.CHQ(AValor, Indice);
    TemTEF := True;
  end
  else if (Indice = '03') or (Indice = '04') then
  begin
    Ok := ACBrTEFD1.CRT(AValor, Indice);
    TemTEF := True;
  end
  else if (Indice = '05') then
  begin
    FTestePayGo := 27;
    Ok := ACBrTEFD1.CRT(AValor, Indice);
    TemTEF := True;
  end;

  StatusVenda := stsEmPagamento;
  
  if Ok then
  begin
    with Venda.Pagamentos.New do
    begin
      TipoPagamento := Indice;
      ValorPago := AValor;

      if TemTEF then
      begin
        NSU := ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].NSU;
        Rede := ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].Rede;
        RedeCNPJ := ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].NFCeSAT.CNPJCredenciadora;

        // Calcula a Diferen�a do Valor Retornado pela Opera��o TEF do Valor que
        //   Informamos no CRT/CHQ
        ReajusteValor := RoundTo(ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].ValorTotal - ValorPago, -2);

        Saque := ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].Saque;
        if (Saque > 0) then
        begin
          // Se houve Saque na opera��o TEF, devemos adicionar no ValorPago,
          //   para que o Saque conste como Troco
          ValorPago := ValorPago + Saque
        end
        else if ReajusteValor > 0 then
        begin
          // Se n�o � Saque, mas houve acr�scimo no valor Retornado, devemos lan�ar
          //   o Reajuste como Acr�scimo na venda
          Venda.TotalAcrescimo := Venda.TotalAcrescimo + ReajusteValor;
        end;

        Desconto := ACBrTEFD1.RespostasPendentes[ACBrTEFD1.RespostasPendentes.Count-1].Desconto;
        if Desconto > 0 then
        begin
          // Se houve Desconto na Opera��o TEF, devemos subtrair do ValorPago
          //   e lan�ar um Desconto no Total da Transacao
          ValorPago := ValorPago - Desconto;
          Venda.TotalDesconto := Venda.TotalDesconto + Desconto;
        end
        else if (ReajusteValor < 0) then
        begin
          // Se n�o � Desconto, mas houve redu��o no Valor Retornado, devemos
          //   considerar a redu��o no ValorPago, pois a Adquirente limitou o
          //   valor da Opera��o, a um m�ximo permitido... Dever� fechar o cupom,
          //   com outra forma de Pagamento
          ValorPago := ValorPago + ReajusteValor;
        end;
      end;
    end;

    AtualizarPagamentosVendaNaInterface;

    if (Venda.TotalPago >= Venda.TotalVenda) then
      FinalizarVenda;
  end;
end;

procedure TFormPrincipal.CancelarVenda;
begin
  AdicionarLinhaLog('- CancelarVenda');
  // AQUI voc� deve cancelar a sua venda no Banco de Dados, desfazendo baixa de
  // estoque ou outras opera��es que ocorreram durante a venda.

  ACBrTEFD1.CancelarTransacoesPendentes;
  StatusVenda := stsCancelada;
end;

procedure TFormPrincipal.FinalizarVenda;
var
  SL: TStringList;
  i: Integer;
  DoctoFiscalOk: Boolean;
  MR: TModalResult;
begin
  try
    // AQUI voc� deve Chamar uma Rotina para Gerar e Transmitir o Documento Fiscal (NFCe ou SAT)
    DoctoFiscalOk := not cbSimularErroNoDoctoFiscal.Checked;
    while not DoctoFiscalOk do
    begin
      MR := MessageDlg( 'Falha no Documento Fiscal' + sLineBreak +
                        'Tentar Novamente ?', mtConfirmation,
                        [mbYes, mbNo, mbIgnore], 0);
      if (MR = mrIgnore) then
        cbSimularErroNoDoctoFiscal.Checked := False
      else if (MR <> mrYes) then
        raise Exception.Create('Erro no Documento Fiscal');

      // AQUI voc� deve Chamar uma Rotina para Gerar e Transmitir o Documento Fiscal (NFCe ou SAT)
      DoctoFiscalOk := not cbSimularErroNoDoctoFiscal.Checked;
    end;

    SL := TStringList.Create;
    try
      // Ao inv�s do relat�rio abaixo, voc� deve enviar a impress�o de um DANFCE ou Extrato do SAT

      SL.Add(PadCenter( ' COMPROVANTE DE OPERA��O ', ACBrPosPrinter1.Colunas, '-'));
      SL.Add('N�mero: <n>' + FormatFloat('000000',Venda.NumOperacao) + '</n>');
      SL.Add('Data/Hora: <n>' + FormatDateTimeBr(Venda.DHInicio) + '</n>');
      SL.Add('</linha_simples>');
      SL.Add('');
      SL.Add('Valor Inicial...: <n>' + FormatFloatBr(Venda.ValorInicial) + '</n>');
      SL.Add('Total Descontos.: <n>' + FormatFloatBr(Venda.TotalDesconto) + '</n>');
      SL.Add('Total Acr�scimos: <n>' + FormatFloatBr(Venda.TotalAcrescimo) + '</n>');
      SL.Add('</linha_simples>');
      SL.Add('VALOR FINAL.....: <n>' + FormatFloatBr(Venda.TotalVenda) + '</n>');
      SL.Add('');
      SL.Add(PadCenter( ' Pagamentos ', ACBrPosPrinter1.Colunas, '-'));
      for i := 0 to Venda.Pagamentos.Count-1 do
      begin
        with Venda.Pagamentos[i] do
        begin
          SL.Add(PadSpace( TipoPagamento+' - '+DescricaoTipoPagamento(TipoPagamento)+'|'+
                           FormatFloatBr(ValorPago)+'|'+Rede, ACBrPosPrinter1.Colunas, '|') );
        end;
      end;
      SL.Add('</linha_simples>');

      SL.Add('Total Pago......: <n>' + FormatFloatBr(Venda.TotalPago) + '</n>');
      if (Venda.Troco > 0) then
        SL.Add('Troco...........: <n>' + FormatFloatBr(Venda.Troco) + '</n>');

      SL.Add('</linha_dupla>');
      SL.Add('</corte>');
      AdicionarLinhaImpressao(SL.Text);
    finally
      SL.Free;
    end;

    StatusVenda := stsFinalizada;
    ACBrTEFD1.ImprimirTransacoesPendentes();
  except
    CancelarVenda;
  end;
end;

procedure TFormPrincipal.VerificarTestePayGo;
var
  P: Integer;
  ATeste: String;
begin
  P := pos('-',cbTestePayGo.Text);
  ATeste := copy(cbTestePayGo.Text, 1, P-1);
  FTestePayGo := StrToIntDef(ATeste, 0);
end;

procedure TFormPrincipal.AtualizarVendaNaInterface;
begin
  lNumOperacao.Caption := FormatFloat('000000',Venda.NumOperacao);
  seValorInicialVenda.Value := Trunc(Venda.ValorInicial);
  AtualizarPagamentosVendaNaInterface;
end;

procedure TFormPrincipal.AtualizarTotaisVendaNaInterface;
begin
  seTotalDesconto.Value := Trunc(Venda.TotalDesconto);
  seTotalAcrescimo.Value := Trunc(Venda.TotalAcrescimo);
  edTotalVenda.Text := FormatFloatBr(Venda.TotalVenda);
  edTotalPago.Text := FormatFloatBr(Venda.TotalPago);
  edTroco.Text := FormatFloatBr(max(Venda.Troco,0));
end;

procedure TFormPrincipal.AtualizarPagamentosVendaNaInterface;
var
  i, ARow: Integer;
begin
  sgPagamentos.RowCount := 2;
  ARow := sgPagamentos.RowCount-1;

  for i := 0 to Venda.Pagamentos.Count-1 do
  begin
    if (ARow > 1) then
      sgPagamentos.RowCount := sgPagamentos.RowCount + 1;

    with Venda.Pagamentos[i] do
    begin
      sgPagamentos.Cells[0, ARow] := FormatFloat('000', ARow);
      sgPagamentos.Cells[1, ARow] := TipoPagamento + ' - ' + DescricaoTipoPagamento(TipoPagamento);
      sgPagamentos.Cells[2, ARow] := FormatFloatBr(ValorPago);
      sgPagamentos.Cells[3, ARow] := NSU;
      sgPagamentos.Cells[4, ARow] := Rede;
      sgPagamentos.Cells[5, ARow] := ifthen(Confirmada, 'Sim', 'N�o');
      sgPagamentos.Cells[6, ARow] := RedeCNPJ;
    end;

    Inc(ARow);
  end;

  AtualizarTotaisVendaNaInterface;
end;

procedure TFormPrincipal.MensagemTEF(const MsgOperador, MsgCliente: String);
begin
  if (MsgOperador <> '') then
    pMensagemOperador.Caption := MsgOperador;

  if (MsgCliente <> '') then
    pMensagemCliente.Caption := MsgCliente;

  pMensagemOperador.Visible := (Trim(pMensagemOperador.Caption) <> '');
  pMensagemCliente.Visible := (Trim(pMensagemCliente.Caption) <> '');
  pMensagem.Visible := pMensagemOperador.Visible or pMensagemCliente.Visible;
  Application.ProcessMessages;
end;

procedure TFormPrincipal.LimparMensagensTEF;
begin
  MensagemTEF(' ',' ');
end;

procedure TFormPrincipal.ConfigurarTEF;
begin
  AdicionarLinhaLog('- ConfigurarTEF');
  ACBrTEFD1.ArqLOG := edLog.Text;
  ACBrTEFD1.TrocoMaximo := seTrocoMaximo.Value;
  ACBrTEFD1.ImprimirViaClienteReduzida := cbImprimirViaReduzida.Checked;
  ACBrTEFD1.MultiplosCartoes := cbMultiplosCartoes.Checked;
  ACBrTEFD1.NumeroMaximoCartoes := seMaxCartoes.Value;
  ACBrTEFD1.SuportaDesconto := cbSuportaDesconto.Checked;
  ACBrTEFD1.SuportaSaque := cbSuportaSaque.Checked;

  ACBrTEFD1.Identificacao.RazaoSocial := edRazaoSocial.Text;
  ACBrTEFD1.Identificacao.RegistroCertificacao := edRegistro.Text;
  ACBrTEFD1.Identificacao.NomeAplicacao := edAplicacaoNome.Text;
  ACBrTEFD1.Identificacao.VersaoAplicacao := edAplicacaoVersao.Text;

  ACBrTEFD1.TEFPayGo.SuportaReajusteValor := cbSuportaReajusteValor.Checked;
  ACBrTEFD1.TEFPayGo.SuportaNSUEstendido := True;
  ACBrTEFD1.TEFPayGo.SuportaViasDiferenciadas := True;

  // Configura��es abaixo s�o obrigat�rios, para funcionamento de N�o Fiscal //
  ACBrTEFD1.AutoEfetuarPagamento := False;
  ACBrTEFD1.AutoFinalizarCupom := False;
end;

procedure TFormPrincipal.AtivarTEF;
begin
  AdicionarLinhaLog('- AtivarTEF');
  ConfigurarTEF;
  ACBrTEFD1.Inicializar(TACBrTEFDTipo(cbxGP.ItemIndex));
end;

procedure TFormPrincipal.ConfigurarPosPrinter;
begin
  AdicionarLinhaLog('- ConfigurarPosPrinter');
  ACBrPosPrinter1.Desativar;
  ACBrPosPrinter1.Modelo := TACBrPosPrinterModelo( cbxModeloPosPrinter.ItemIndex );
  ACBrPosPrinter1.PaginaDeCodigo := TACBrPosPaginaCodigo( cbxPagCodigo.ItemIndex );
  ACBrPosPrinter1.Porta := cbxPorta.Text;
  ACBrPosPrinter1.ColunasFonteNormal := seColunas.Value;
  ACBrPosPrinter1.LinhasEntreCupons := seLinhasPular.Value;
  ACBrPosPrinter1.EspacoEntreLinhas := seEspLinhas.Value;
end;

procedure TFormPrincipal.AtivarPosPrinter;
begin
  AdicionarLinhaLog('- AtivarPosPrinter');
  ConfigurarPosPrinter;
  if (ACBrPosPrinter1.Porta <> '') then
    ACBrPosPrinter1.Ativar
  else
    raise Exception.Create('Porta n�o definida');
end;

procedure TFormPrincipal.Ativar;
begin
  AdicionarLinhaLog('- Ativar');
  GravarConfiguracao;
  try
    AtivarPosPrinter;
  except
    On E: Exception do
    begin
      TratarException(nil, E);
    end;
  end;
  AtivarTEF;
end;

procedure TFormPrincipal.Desativar;
begin
  AdicionarLinhaLog('- Desativar');
  ACBrPosPrinter1.Desativar;
  ACBrTEFD1.DesInicializar(TACBrTEFDTipo(cbxGP.ItemIndex));
end;

end.

