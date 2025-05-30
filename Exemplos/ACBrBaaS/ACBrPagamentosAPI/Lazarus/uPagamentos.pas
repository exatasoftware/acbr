{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{ - Elias César                                                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit uPagamentos;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, Buttons, DateTimePicker,
  ACBrPagamentosAPI, ACBrSchemasPagamentosAPI;

type

  { TfrmPagamentos }

  TfrmPagamentos = class(TForm)
    btConsultarLote: TBitBtn;
    btConsultarIdPagamento: TBitBtn;
    btIncluirLancamento: TBitBtn;
    btLimparLancamentos: TBitBtn;
    btPreencher: TBitBtn;
    btLoteEnviar: TBitBtn;
    cbBoletosTipoAvalista: TComboBox;
    cbBoletosTipoBeneficiario: TComboBox;
    cbBoletosTipoPagador: TComboBox;
    cbConsultaLoteTipo: TComboBox;
    cbConsultarIdPagamentoTipo: TComboBox;
    cbDARFTipoContribuinte: TComboBox;
    cbLoteTipo: TComboBox;
    cbGPSTipoContribuinte: TComboBox;
    dtBoletosDataPagamento: TDateTimePicker;
    dtDARFDataPagamento: TDateTimePicker;
    dtDARFDataApuracao: TDateTimePicker;
    dtDARFDataVencimento: TDateTimePicker;
    dtGRUDataPagamento: TDateTimePicker;
    dtGPSDataPagamento: TDateTimePicker;
    dtGRUDataVencimento: TDateTimePicker;
    dtGuiaDataPagamento: TDateTimePicker;
    edBoletosCodigoBarras: TEdit;
    edConsultarIdLote: TEdit;
    edConsultarIdPagamento: TEdit;
    edDARFCodReceita: TEdit;
    edDARFDescricaoPagamento: TEdit;
    edDARFDocumentoDebito: TEdit;
    edDARFIDContribuinte: TEdit;
    edDARFIdTributo: TEdit;
    edDARFValorMulta: TEdit;
    edDARFSeuDocumento: TEdit;
    edDARFValorJuros: TEdit;
    edDARFValorPrincipal: TEdit;
    edDARFValorPagamento: TEdit;
    edDARFNumReferencia: TEdit;
    edGRUCodigoBarras: TEdit;
    edGRUDescricaoPagamento: TEdit;
    edGPSDescricaoPagamento: TEdit;
    edGPSValorAtualizacao: TEdit;
    edGRUDocumentoDebito: TEdit;
    edGPSDocumentoDebito: TEdit;
    edGRUidContribuinte: TEdit;
    edGPSOutrasEntradas: TEdit;
    edGRUMesAnoCompetencia: TEdit;
    edGPSValorDevido: TEdit;
    edGRUNumeroReferencia: TEdit;
    edGPSIdTributo: TEdit;
    edGRUValorAcrescimo: TEdit;
    edGPSIDContribuinte: TEdit;
    edGRUValorDesconto: TEdit;
    edGRUValorJuros: TEdit;
    edGRUValorMulta: TEdit;
    edGPSMesAnoCompetencia: TEdit;
    edGRUValorOutraDeducao: TEdit;
    edGPSCodReceita: TEdit;
    edGRUValorPagamento: TEdit;
    edGPSValorPagamento: TEdit;
    edGRUValorPrincipal: TEdit;
    edGuiaCodigoBarras: TEdit;
    edGuiaDescricaoPagamento: TEdit;
    edGuiaDocumentoDebito: TEdit;
    edGuiaSeuDocumento: TEdit;
    edGPSSeuDocumento: TEdit;
    edGuiaValorPagamento: TEdit;
    edCodigoContrato: TEdit;
    edBoletosDescricaoPagamento: TEdit;
    edDigitoCCDebito: TEdit;
    edBoletosDocumentoAvalista: TEdit;
    edBoletosDocumentoBeneficiario: TEdit;
    edBoletosDocumentoDebito: TEdit;
    edBoletosDocumentoPagador: TEdit;
    edBoletosNossoNumero: TEdit;
    edNumeroAgenciaDebito: TEdit;
    edNumeroContaCorrenteDebito: TEdit;
    edNumRequisicao: TEdit;
    edBoletosSeuDocumento: TEdit;
    edBoletosValorDesconto: TEdit;
    edBoletosValorMoraMulta: TEdit;
    edBoletosValorNominal: TEdit;
    edBoletosValorPagamento: TEdit;
    gbBoletosLacamento: TGroupBox;
    gbGPSLancamento: TGroupBox;
    gbDARFLancamento: TGroupBox;
    gbGuiaLacamento: TGroupBox;
    gbGRURequisicao: TGroupBox;
    lbBoletosCodigoBarras: TLabel;
    lbConsultaIdLote: TLabel;
    lbConsultarIdPagamento: TLabel;
    lbConsultaLoteTipo: TLabel;
    lbConsultarIdPagamentoTipo: TLabel;
    lbDARFCodReceita: TLabel;
    lbDARFDataPagamento: TLabel;
    lbDARFDataApuracao: TLabel;
    lbDARFDataVencimento: TLabel;
    lbDARFDescricaoPagamento: TLabel;
    lbDARFDocumentoDebito: TLabel;
    lbDARFIDContribuinte: TLabel;
    lbDARFIdTributo: TLabel;
    lbDARFValorMulta: TLabel;
    lbDARFSeuDocumento: TLabel;
    lbDARFTipoContribuinte: TLabel;
    lbDARFValorJuros: TLabel;
    lbDARFValorPrincipal: TLabel;
    lbDARFValorPagamento: TLabel;
    lbDARFNumReferencia: TLabel;
    lbGRUCodigoBarras: TLabel;
    lbGRUDataPagamento: TLabel;
    lbGPSDataPagamento: TLabel;
    lbGRUDataVencimento: TLabel;
    lbGRUDescricaoPagamento: TLabel;
    lbGPSDescricaoPagamento: TLabel;
    lbGPSValorAtualizacao: TLabel;
    lbGRUDocumentoDebito: TLabel;
    lbGPSDocumentoDebito: TLabel;
    lbGRUidContribuinte: TLabel;
    lbGPSOutrasEntradas: TLabel;
    lbGRUMesAnoCompetencia: TLabel;
    lbGPSValorDevido: TLabel;
    lbGRUNumeroReferencia: TLabel;
    lbGPSIdTributo: TLabel;
    lbGRUValorAcrescimo: TLabel;
    lbGPSIDContribuinte: TLabel;
    lbGRUValorDesconto: TLabel;
    lbGRUValorJuros: TLabel;
    lbGPSTipoContribuinte: TLabel;
    lbGRUValorMulta: TLabel;
    lbGPSMesAnoCompetencia: TLabel;
    lbGRUValorOutraDeducao: TLabel;
    lbGPSCodReceita: TLabel;
    lbGRUValorPagamento: TLabel;
    lbGPSValorPagamento: TLabel;
    lbGRUValorPrincipal: TLabel;
    lbGuiaCodigoBarras: TLabel;
    lbBoletosDataPagamento: TLabel;
    lbGuiaDataPagamento: TLabel;
    lbBoletosDescricaoPagamento: TLabel;
    lbGuiaDescricaoPagamento: TLabel;
    lbBoletosDocumentoAvalista: TLabel;
    lbBoletosDocumentoBeneficiario: TLabel;
    lbBoletosDocumentoDebito: TLabel;
    lbGuiaDocumentoDebito: TLabel;
    lbBoletosDocumentoPagador: TLabel;
    lbBoletosNossoNumero: TLabel;
    lbBoletosSeuDocumento: TLabel;
    lbGuiaSeuDocumento: TLabel;
    lbBoletosTipoAvalista: TLabel;
    lbBoletosTipoBeneficiario: TLabel;
    lbBoletosTipoPagador: TLabel;
    lbBoletosValorDesconto: TLabel;
    lbBoletosValorMoraMulta: TLabel;
    lbBoletosValorNominal: TLabel;
    lbBoletosValorPagamento: TLabel;
    lbGPSSeuDocumento: TLabel;
    lbGuiaValorPagamento: TLabel;
    mmConsultaLog: TMemo;
    mmConsultarPagamentoLog: TMemo;
    PageControl1: TPageControl;
    pnDARFLancamento: TPanel;
    pnLoteConsultar: TPanel;
    pgLancamentos: TPageControl;
    pnBoletosLancamento: TPanel;
    pnGRULancamento: TPanel;
    pnGPSLancamento: TPanel;
    pnGuiaLancamento: TPanel;
    pnLancamentos: TPanel;
    pnPagamentoConsultar: TPanel;
    tsDARF: TTabSheet;
    tsPagamentoConsultar: TTabSheet;
    tsLoteConsultar: TTabSheet;
    tsGPS: TTabSheet;
    tsGRU: TTabSheet;
    tsGuiaCodBarras: TTabSheet;
    tsBoletoLancamento: TTabSheet;
    lbLoteTipo: TLabel;
    lbCodigoContrato: TLabel;
    lbDigitoCCDebito: TLabel;
    lbLancamentos: TLabel;
    lbLancamentosQtd: TLabel;
    lbNumeroAgenciaDebito: TLabel;
    lbNumeroContaCorrenteDebito: TLabel;
    lbNumRequisicao: TLabel;
    pgPagamentos: TPageControl;
    pnLote: TPanel;
    pnLoteDados: TPanel;
    pnLoteRodape: TPanel;
    tsGuias: TTabSheet;
    tsLotePagamento: TTabSheet;
    procedure btConsultarLoteClick(Sender: TObject);
    procedure btConsultarIdPagamentoClick(Sender: TObject);
    procedure btIncluirLancamentoClick(Sender: TObject);
    procedure btLimparLancamentosClick(Sender: TObject);
    procedure btPreencherClick(Sender: TObject);
    procedure btLoteEnviarClick(Sender: TObject);
    procedure cbLoteTipoSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LimparCampos;
    procedure AtualizarContadorLancamentos;

    procedure IncluirBoletoSolicitado;
    procedure IncluirGuiaCodBarrasSolicitada;
    procedure IncluirGRUSolicitado;
    procedure IncluirDARFSolicitado;
    procedure IncluirGPSSolicitado;

    procedure PreencherCamposBoleto;
    procedure PreencherCamposGuiaCodBarras;
    procedure PreencherCamposGRU;
    procedure PreencherCamposDARF;
    procedure PreencherCamposGPS;

    procedure ConsultarLoteBoletos;
    procedure ConsultarLoteGuiasCodBarras;
    procedure ConsultarLoteGRU;
    procedure ConsultarLoteDARF;
    procedure ConsultarLoteGPS;

    procedure ConsultarPagamentoBoleto;
    procedure ConsultarPagamentoGuiaCodBarras;
    procedure ConsultarPagamentoGRU;
    procedure ConsultarPagamentoDARF;
    procedure ConsultarPagamentoGPS;

    function EnviarLoteBoletos: Boolean;
    function EnviarLoteGuiasCodBarras: Boolean;
    function EnviarLoteGRU: Boolean;
    function EnviarLoteDARF: Boolean;
    function EnviarLoteGPS: Boolean;

    function ACBrPagamentosAPI: TACBrPagamentosAPI;
  public

  end;

var
  frmPagamentos: TfrmPagamentos;

implementation

uses
  Math, uDemoBaaS,
  ACBrUtil.Base,
  ACBrUtil.FilesIO,
  ACBrUtil.DateTime;

{$R *.lfm}

{ TfrmPagamentos }

procedure TfrmPagamentos.btLimparLancamentosClick(Sender: TObject);
begin
  if (MessageDlg('Deseja zerar a lista de lançamentos?', mtConfirmation, mbYesNo, 0) = mrNo) then
    Exit;

  ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado.lancamentos.Clear;
  AtualizarContadorLancamentos;
end;

procedure TfrmPagamentos.btPreencherClick(Sender: TObject);
begin
  edNumRequisicao.Text := IntToStr(RandomRange(1, 9999999));
  edCodigoContrato.Text := '731030';
  edNumeroAgenciaDebito.Text := '1607';
  edNumeroContaCorrenteDebito.Text := '99738672';
  edDigitoCCDebito.Text := 'X';

  case cbLoteTipo.ItemIndex of
    0: PreencherCamposBoleto;
    1: PreencherCamposGuiaCodBarras;
    2: PreencherCamposGRU;
    3: PreencherCamposDARF;
    4: PreencherCamposGPS;
  end;
end;

procedure TfrmPagamentos.btLoteEnviarClick(Sender: TObject);
var
  ok: Boolean;
begin
  case cbLoteTipo.ItemIndex of
    0: ok := EnviarLoteBoletos;
    1: ok := EnviarLoteGuiasCodBarras;
    2: ok := EnviarLoteGRU;
    3: ok := EnviarLoteDARF;
    4: ok := EnviarLoteGPS;
  end;

  if ok then
    MessageDlg('Lote solicitado com Sucesso!', mtInformation, [mbOK], 0)
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' +
      ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.cbLoteTipoSelect(Sender: TObject);
var
  i: Integer;
begin
  LimparCampos;

  i := cbLoteTipo.ItemIndex;            
  gbBoletosLacamento.Visible := (i = 0);
  gbGuiaLacamento.Visible := (i = 1);   
  gbGRURequisicao.Visible := (i = 2);
  gbDARFLancamento.Visible := (i = 3);
  gbGPSLancamento.Visible := (i = 4);

  if Assigned(ACBrPagamentosAPI.Banco) then
  begin
    ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado.lancamentos.Clear;
    ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasSolicitado.lancamentos.Clear;
    ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUSolicitado.listaRequisicao.Clear;
    ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSSolicitado.lancamentos.Clear;
    AtualizarContadorLancamentos;
  end;
end;

procedure TfrmPagamentos.FormCreate(Sender: TObject);
begin
  LimparCampos;
  pgPagamentos.PageIndex := 0;
  pgLancamentos.Visible := False;

  gbGuiaLacamento.Visible := False;
  gbGuiaLacamento.Parent := pnLancamentos;

  gbBoletosLacamento.Visible := False;
  gbBoletosLacamento.Parent := pnLancamentos;

  gbGRURequisicao.Visible := False;
  gbGRURequisicao.Parent := pnLancamentos;

  gbDARFLancamento.Visible := False;
  gbDARFLancamento.Parent := pnLancamentos;

  gbGPSLancamento.Visible := False;
  gbGPSLancamento.Parent := pnLancamentos;

  cbLoteTipo.ItemIndex := 0;
  cbLoteTipoSelect(Nil);
end;

procedure TfrmPagamentos.LimparCampos;
begin
  edNumRequisicao.Text := EmptyStr;
  edCodigoContrato.Text := EmptyStr;
  edNumeroAgenciaDebito.Text := EmptyStr;
  edNumeroContaCorrenteDebito.Text := EmptyStr;
  edDigitoCCDebito.Text := EmptyStr;

  edBoletosDocumentoDebito.Text := EmptyStr;
  edBoletosCodigoBarras.Text := EmptyStr;
  dtBoletosDataPagamento.DateTime := NullDate;
  edBoletosValorPagamento.Text := EmptyStr;
  edBoletosValorNominal.Text := EmptyStr;
  edBoletosValorDesconto.Text := EmptyStr;
  edBoletosValorMoraMulta.Text := EmptyStr;
  edBoletosSeuDocumento.Text := EmptyStr;
  edBoletosNossoNumero.Text := EmptyStr;
  edBoletosDescricaoPagamento.Text := EmptyStr;
  cbBoletosTipoPagador.ItemIndex := -1;
  edBoletosDocumentoPagador.Text := EmptyStr;
  cbBoletosTipoBeneficiario.ItemIndex := -1;
  edBoletosDocumentoBeneficiario.Text := EmptyStr;
  cbBoletosTipoAvalista.ItemIndex := -1;
  edBoletosDocumentoAvalista.Text := EmptyStr; 

  edGuiaDocumentoDebito.Text := EmptyStr;
  edGuiaCodigoBarras.Text := EmptyStr;
  dtGuiaDataPagamento.DateTime := NullDate;
  edGuiaValorPagamento.Text := EmptyStr;
  edGuiaSeuDocumento.Text := EmptyStr;
  edGuiaDescricaoPagamento.Text := EmptyStr;

  dtDARFDataPagamento.DateTime := NullDate;
  edDARFValorPagamento.Text := EmptyStr;
  edDARFDocumentoDebito.Text := EmptyStr;
  edDARFSeuDocumento.Text := EmptyStr;
  edDARFDescricaoPagamento.Text := EmptyStr;
  edDARFCodReceita.Text := EmptyStr;
  cbDARFTipoContribuinte.ItemIndex := -1;
  edDARFIDContribuinte.Text := EmptyStr;
  edDARFIdTributo.Text := EmptyStr;
  edDARFValorPrincipal.Text := EmptyStr;
  edDARFValorMulta.Text := EmptyStr;
  edDARFValorJuros.Text := EmptyStr;
  edDARFNumReferencia.Text := EmptyStr;

  edGRUCodigoBarras.Text := EmptyStr;
  dtGRUDataPagamento.DateTime := NullDate;
  dtGRUDataVencimento.DateTime := NullDate;
  edGRUValorPagamento.Text := EmptyStr;
  edGRUValorPrincipal.Text := EmptyStr;
  edGRUValorDesconto.Text := EmptyStr;
  edGRUValorOutraDeducao.Text := EmptyStr;
  edGRUValorMulta.Text := EmptyStr;
  edGRUValorJuros.Text := EmptyStr;
  edGRUValorAcrescimo.Text := EmptyStr;
  edGRUDescricaoPagamento.Text := EmptyStr;
  edGRUDocumentoDebito.Text := EmptyStr;
  edGRUNumeroReferencia.Text := EmptyStr;
  edGRUMesAnoCompetencia.Text := EmptyStr;
  edGRUidContribuinte.Text := EmptyStr;

  dtGPSDataPagamento.DateTime := NullDate;
  edGPSValorPagamento.Text := EmptyStr;
  edGPSDocumentoDebito.Text := EmptyStr; 
  edGPSSeuDocumento.Text := EmptyStr;
  edGPSDescricaoPagamento.Text := EmptyStr;
  edGPSCodReceita.Text := EmptyStr;
  edGPSMesAnoCompetencia.Text := EmptyStr;
  cbGPSTipoContribuinte.ItemIndex := -1;
  edGPSIDContribuinte.Text := EmptyStr;
  edGPSIdTributo.Text := EmptyStr;
  edGPSValorDevido.Text := EmptyStr;
  edGPSOutrasEntradas.Text := EmptyStr;
  edGPSValorAtualizacao.Text := EmptyStr;
end;

procedure TfrmPagamentos.btIncluirLancamentoClick(Sender: TObject);
begin
  if (MessageDlg('Deseja incluir o lançamento atual?', mtConfirmation, mbYesNo, 0) = mrNo) then
    Exit;

  case cbLoteTipo.ItemIndex of
    0: IncluirBoletoSolicitado;
    1: IncluirGuiaCodBarrasSolicitada;
    2: IncluirGRUSolicitado;
    3: IncluirDARFSolicitado;
    4: IncluirGPSSolicitado;
  end;

  AtualizarContadorLancamentos;
end;

procedure TfrmPagamentos.btConsultarLoteClick(Sender: TObject);
begin
  if EstaVazio(edConsultarIdLote.Text) then
  begin
    MessageDlg('Preencha o campo Id para efetuar a consulta', mtError, [mbOK], 0);
    Abort;
  end;

  case cbConsultaLoteTipo.ItemIndex of
    0: ConsultarLoteBoletos;
    1: ConsultarLoteGuiasCodBarras;
    2: ConsultarLoteGRU;
    3: ConsultarLoteDARF;
    4: ConsultarLoteGPS;
  end;
end;

procedure TfrmPagamentos.btConsultarIdPagamentoClick(Sender: TObject);
begin
  if EstaVazio(edConsultarIdPagamento.Text) then
  begin
    MessageDlg('Preencha o campo Id para efetuar a consulta', mtError, [mbOK], 0);
    Abort;
  end;

  case cbConsultarIdPagamentoTipo.ItemIndex of
    0: ConsultarPagamentoBoleto;
    1: ConsultarPagamentoGuiaCodBarras;
    2: ConsultarPagamentoGRU;
    3: ConsultarPagamentoDARF;
    4: ConsultarPagamentoGPS;
  end;
end;

procedure TfrmPagamentos.AtualizarContadorLancamentos;
var
  qtd: Integer;
begin
  case cbLoteTipo.ItemIndex of
    0: qtd := ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado.lancamentos.Count;
    1: qtd := ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasSolicitado.lancamentos.Count;
    2: qtd := ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUSolicitado.listaRequisicao.Count;
    3: qtd := ACBrPagamentosAPI.Banco.Pagamentos.LoteDARFSolicitado.lancamentos.Count;
    4: qtd := ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSSolicitado.lancamentos.Count;
  end;

  lbLancamentosQtd.Caption := IntToStrZero(qtd, 2);
end;

procedure TfrmPagamentos.IncluirBoletoSolicitado;
begin
  with ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado.lancamentos.New do
  begin
    numeroDocumentoDebito := StrToIntDef(edBoletosDocumentoDebito.Text, 0);
    numeroCodigoBarras := Trim(edBoletosCodigoBarras.Text);
    dataPagamento := dtBoletosDataPagamento.DateTime;
    valorPagamento := StrToFloatDef(edBoletosValorPagamento.Text, 0);
    valorNominal := StrToFloatDef(edBoletosValorNominal.Text, 0);
    valorDesconto := StrToFloatDef(edBoletosValorDesconto.Text, 0);
    valorMoraMulta := StrToFloatDef(edBoletosValorMoraMulta.Text, 0);
    codigoSeuDocumento := edBoletosSeuDocumento.Text;
    codigoNossoDocumento := edBoletosNossoNumero.Text;
    descricaoPagamento := edBoletosDescricaoPagamento.Text;
    codigoTipoPagador :=  TACBrPagamentoTipoPessoa(cbBoletosTipoPagador.ItemIndex+1);
    documentoPagador := edBoletosDocumentoPagador.Text;
    codigoTipoBeneficiario := TACBrPagamentoTipoPessoa(cbBoletosTipoBeneficiario.ItemIndex+1);
    documentoBeneficiario := edBoletosDocumentoBeneficiario.Text;
    codigoTipoAvalista := TACBrPagamentoTipoPessoa(cbBoletosTipoAvalista.ItemIndex+1);
    documentoAvalista := edBoletosDocumentoAvalista.Text;
  end;
end;

procedure TfrmPagamentos.IncluirGuiaCodBarrasSolicitada;
begin 
  with ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasSolicitado.lancamentos.New do
  begin
    numeroDocumentoDebito := StrToIntDef(edGuiaDocumentoDebito.Text, 0);
    codigoBarras := Trim(edGuiaCodigoBarras.Text);
    dataPagamento := dtGuiaDataPagamento.DateTime;
    valorPagamento := StrToFloatDef(edGuiaValorPagamento.Text, 0);
    codigoSeuDocumento := edGuiaSeuDocumento.Text;
    descricaoPagamento := edGuiaDescricaoPagamento.Text;
  end;
end;

procedure TfrmPagamentos.IncluirGRUSolicitado;
begin
  with ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUSolicitado.listaRequisicao.New do
  begin
    codigoBarras := Trim(edGRUCodigoBarras.Text);
    dataPagamento := dtGRUDataPagamento.DateTime;
    dataVencimento := dtGRUDataVencimento.DateTime;
    valorPagamento := StrToFloatDef(edGRUValorPagamento.Text, 0);
    valorPrincipal := StrToFloatDef(edGRUValorPrincipal.Text, 0);
    valorDesconto := StrToFloatDef(edGRUValorDesconto.Text, 0);
    valorOutraDeducao := StrToFloatDef(edGRUValorOutraDeducao.Text, 0);
    valorMulta := StrToFloatDef(edGRUValorMulta.Text, 0);
    valorJuroEncargo := StrToFloatDef(edGRUValorJuros.Text, 0);
    valorOutroAcrescimo := StrToFloatDef(edGRUValorAcrescimo.Text, 0);
    textoPagamento := edGRUDescricaoPagamento.Text;
    numeroDocumentoDebito := StrToIntDef(edGRUDocumentoDebito.Text, 0);
    numeroReferencia := Trim(edGRUNumeroReferencia.Text);
    mesAnoCompetencia := StrToIntDef(edGRUMesAnoCompetencia.Text, 0);
    idContribuinte := StrToIntDef(edGRUidContribuinte.Text, 0);
  end;
end;

procedure TfrmPagamentos.IncluirDARFSolicitado;
begin
  with ACBrPagamentosAPI.Banco.Pagamentos.LoteDARFSolicitado.lancamentos.New do
  begin
    dataPagamento := dtDARFDataPagamento.DateTime;
    valorPagamento := StrToFloatDef(edDARFValorPagamento.Text, 0);
    numeroDocumentoDebito := StrToIntDef(edDARFDocumentoDebito.Text, 0);
    codigoSeuDocumento := edDARFSeuDocumento.Text;
    textoDescricaoPagamento := edDARFDescricaoPagamento.Text;
    codigoReceitaTributo := StrToIntDef(edDARFCodReceita.Text, 0);
    codigoTipoContribuinte := TACBrTipoContribuinte(cbDARFTipoContribuinte.ItemIndex);
    numeroIdentificacaoContribuinte := StrToIntDef(edDARFIDContribuinte.Text, 0);
    codigoIdentificadorTributo := edDARFIdTributo.Text;
    valorPrincipal := StrToFloatDef(edDARFValorPrincipal.Text, 0);
    valorMulta := StrToFloatDef(edDARFValorMulta.Text, 0);
    valorJuroEncargo := StrToFloatDef(edDARFValorJuros.Text, 0);
    dataApuracao := dtDARFDataApuracao.DateTime;
    dataVencimento := dtDARFDataVencimento.DateTime;
    numeroReferencia := edDARFNumReferencia.Text;
  end;
end;

procedure TfrmPagamentos.IncluirGPSSolicitado;
begin
  with ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSSolicitado.lancamentos.New do
  begin
    dataPagamento := dtGPSDataPagamento.DateTime;
    valorPagamento := StrToFloatDef(edGPSValorPagamento.Text, 0);
    numeroDocumentoDebito := StrToIntDef(edGPSDocumentoDebito.Text, 0);
    codigoSeuDocumento := edGPSSeuDocumento.Text;
    textoDescricaoPagamento := edGPSDescricaoPagamento.Text;
    codigoReceitaTributoGuiaPrevidenciaSocial := StrToIntDef(edGPSCodReceita.Text, 0);
    mesAnoCompetenciaGuiaPrevidenciaSocial := StrToIntDef(edGPSMesAnoCompetencia.Text, 0);
    codigoTipoContribuinteGuiaPrevidenciaSocial := TACBrTipoContribuinte(cbGPSTipoContribuinte.ItemIndex);
    numeroIdentificacaoContribuinteGuiaPrevidenciaSocial := StrToIntDef(edGPSIDContribuinte.Text, 0);
    codigoIdentificadorTributoGuiaPrevidenciaSocial := edGPSIdTributo.Text;
    valorPrevistoInstNacSeguridadeSocialGuiaPrevidenciaSocial := StrToFloatDef(edGPSValorDevido.Text, 0);
    valorOutroEntradaGuiaPrevidenciaSocial := StrToFloatDef(edGPSOutrasEntradas.Text, 0);
    valorAtualizacaoMonetarioGuiaPrevidenciaSocial := StrToFloatDef(edGPSValorAtualizacao.Text, 0);
  end;
end;

procedure TfrmPagamentos.PreencherCamposBoleto;
begin
  edBoletosDocumentoDebito.Text := '123';
  edBoletosCodigoBarras.Text := '99999999999999999999999999999';
  dtBoletosDataPagamento.DateTime := IncWorkingDay(Now, 5);
  edBoletosValorPagamento.Text := FormatFloatBr(RoundTo(RandomRange(50, 150) * Random, -2));
  edBoletosValorNominal.Text := edBoletosValorPagamento.Text;
  edBoletosValorDesconto.Text := '0';
  edBoletosValorMoraMulta.Text := '0';
  edBoletosSeuDocumento.Text := EmptyStr;
  edBoletosNossoNumero.Text := EmptyStr;
  edBoletosDescricaoPagamento.Text := 'Teste Lote Boletos';
  cbBoletosTipoPagador.ItemIndex := -1;
  edBoletosDocumentoPagador.Text := EmptyStr;
  cbBoletosTipoBeneficiario.ItemIndex := 0;
  edBoletosDocumentoBeneficiario.Text := '99999999999';
  cbBoletosTipoAvalista.ItemIndex := -1;
  edBoletosDocumentoAvalista.Text := EmptyStr;
end;

procedure TfrmPagamentos.PreencherCamposGuiaCodBarras;
begin
  edGuiaDocumentoDebito.Text := '123';
  edGuiaCodigoBarras.Text := '99999999999999999999999999999999999999999999';
  dtGuiaDataPagamento.DateTime := IncWorkingDay(Now, 5);
  edGuiaValorPagamento.Text := FormatFloatBr(RoundTo(RandomRange(50, 150) * Random, -2));
  edGuiaSeuDocumento.Text := EmptyStr;
  edGuiaDescricaoPagamento.Text := 'Teste Lote Guias com Cod.Barras';
end;

procedure TfrmPagamentos.PreencherCamposGRU;
begin
  edGRUCodigoBarras.Text := '99999999999999999999999999999999999999999999';
  dtGRUDataPagamento.Date := IncWorkingDay(Now, 5);
  dtGRUDataVencimento.DateTime := 0;
  edGRUValorPagamento.Text := FormatFloatBr(RoundTo(RandomRange(50, 150) * Random, -2));
  edGRUValorPrincipal.Text := edGRUValorPagamento.Text;
  edGRUValorDesconto.Text := EmptyStr;
  edGRUValorOutraDeducao.Text := EmptyStr;
  edGRUValorMulta.Text := EmptyStr;
  edGRUValorJuros.Text := EmptyStr;
  edGRUValorAcrescimo.Text := EmptyStr;
  edGRUDescricaoPagamento.Text := 'Teste Lote Pagamentos GRU';
  edGRUDocumentoDebito.Text := '123';
  edGRUNumeroReferencia.Text := EmptyStr;
  edGRUMesAnoCompetencia.Text := FormatDateTimeBr(Now, 'MMYYYY');
  edGRUidContribuinte.Text := '96050176876';
end;

procedure TfrmPagamentos.PreencherCamposDARF;
begin 
  dtDARFDataPagamento.DateTime := IncWorkingDay(Now, 5);
  dtDARFDataApuracao.DateTime := 0;
  dtDARFDataVencimento.DateTime := 0;
  edDARFValorPagamento.Text := FormatFloatBr(RoundTo(RandomRange(50, 150) * Random, -2));
  edDARFDocumentoDebito.Text := '123';
  edDARFSeuDocumento.Text := EmptyStr;
  edDARFDescricaoPagamento.Text := 'Teste Lote DARF';
  edDARFCodReceita.Text := '6106';
  cbDARFTipoContribuinte.ItemIndex := 0;
  edDARFIDContribuinte.Text := '96050176876';
  edDARFIdTributo.Text := '16';
  edDARFValorPrincipal.Text := edDARFValorPagamento.Text;
  edDARFValorMulta.Text := '0';
  edDARFValorJuros.Text := '0';
  edDARFNumReferencia.Text := EmptyStr;
end;

procedure TfrmPagamentos.PreencherCamposGPS;
begin 
  dtGPSDataPagamento.DateTime := IncWorkingDay(Now, 5);
  edGPSValorPagamento.Text := FormatFloatBr(RoundTo(RandomRange(50, 150) * Random, -2));
  edGPSDocumentoDebito.Text := '123';
  edGPSSeuDocumento.Text := EmptyStr;
  edGPSDescricaoPagamento.Text := 'Teste Pagto GPS';
  edGPSCodReceita.Text := '2909';
  edGPSMesAnoCompetencia.Text := '112021';
  cbGPSTipoContribuinte.ItemIndex := 1;
  edGPSIDContribuinte.Text := '96050176876';
  edGPSIdTributo.Text := '17';
  edGPSValorDevido.Text := edGPSValorPagamento.Text;
  edGPSOutrasEntradas.Text := '0';
  edGPSValorAtualizacao.Text := '0';
end;

procedure TfrmPagamentos.ConsultarLoteBoletos;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.BoletoConsultarLotePagamentos(edConsultarIdLote.Text);

  if ok then
  begin
    MessageDlg('Lote consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultaLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarLoteGuiasCodBarras;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GuiaCodigoBarrasConsultarLotePagamentos(edConsultarIdLote.Text);

  if ok then
  begin
    MessageDlg('Lote consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultaLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarLoteGRU;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GRUConsultarLotePagamentos(edConsultarIdLote.Text);

  if ok then
  begin
    MessageDlg('Lote consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultaLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarLoteDARF;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.DARFConsultarLotePagamentos(edConsultarIdLote.Text);

  if ok then
  begin
    MessageDlg('Lote consultado com Sucesso!', mtInformation, [mbOK], 0);
    //mmConsultaLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.LoteDARFConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarLoteGPS;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GPSConsultarLotePagamentos(edConsultarIdLote.Text);

  if ok then
  begin
    MessageDlg('Lote consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultaLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarPagamentoBoleto;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.BoletoConsultarPagamentoEspecifico(edConsultarIdPagamento.Text);

  if ok then
  begin
    MessageDlg('Pagamento consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultarPagamentoLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.PagamentoBoletoConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else if (not ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsEmpty) then
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarPagamentoGuiaCodBarras;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GuiaCodigoBarrasConsultarPagamentoEspecifico(edConsultarIdPagamento.Text);

  if ok then
  begin
    MessageDlg('Pagamento consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultarPagamentoLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.PagamentoGuiaCodigoBarrasConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else if (not ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsEmpty) then
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarPagamentoGRU;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GRUConsultarPagamentoEspecifico(edConsultarIdPagamento.Text);

  if ok then
  begin
    MessageDlg('Pagamento consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultarPagamentoLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.PagamentoGRUConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else if (not ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsEmpty) then
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarPagamentoDARF;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.DARFConsultarPagamentoEspecifico(edConsultarIdPagamento.Text);

  if ok then
  begin
    MessageDlg('Pagamento consultado com Sucesso!', mtInformation, [mbOK], 0);
    //mmConsultarPagamentoLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.PagamentoDARFConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else if (not ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsEmpty) then
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

procedure TfrmPagamentos.ConsultarPagamentoGPS;
var
  ok: Boolean;
begin
  ok := ACBrPagamentosAPI.Banco.Pagamentos.GPSConsultarPagamentoEspecifico(edConsultarIdPagamento.Text);

  if ok then
  begin
    MessageDlg('Pagamento consultado com Sucesso!', mtInformation, [mbOK], 0);
    mmConsultarPagamentoLog.Lines.Text := ACBrPagamentosAPI.Banco.Pagamentos.PagamentoGPSConsultado.AsJSON;
  end
  else if ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsOAuthError then
    MessageDlg('Erro de Autenticação: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.OAuthError.message, mtError, [mbOK], 0)
  else if (not ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros.IsEmpty) then
    MessageDlg('Erro: ' + ACBrPagamentosAPI.Banco.Pagamentos.RespostaErros[0].mensagem, mtError, [mbOK], 0);
end;

function TfrmPagamentos.EnviarLoteBoletos: Boolean;
var
  lote: TACBrLoteBoletosRequisicao;
begin
  Result := False;

  if ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado.lancamentos.IsEmpty then
  begin
    MessageDlg('Nenhum lançamento incluído', mtError, [mbOK], 0);
    Abort;
  end;

  lote := ACBrPagamentosAPI.Banco.Pagamentos.LoteBoletosSolicitado;
  lote.numeroRequisicao := StrToIntDef(edNumRequisicao.Text, 0);
  lote.codigoContrato := StrToIntDef(edCodigoContrato.Text, 0);
  lote.numeroAgenciaDebito := StrToIntDef(edNumeroAgenciaDebito.Text, 0);
  lote.numeroContaCorrenteDebito := StrToIntDef(edNumeroContaCorrenteDebito.Text, 0);
  lote.digitoVerificadorContaCorrenteDebito := edDigitoCCDebito.Text;

  Result := ACBrPagamentosAPI.Banco.Pagamentos.BoletoSolicitarLotePagamentos;
end;

function TfrmPagamentos.EnviarLoteGuiasCodBarras: Boolean;
var
  lote: TACBrLoteGuiasCodigoBarrasRequisicao;
begin
  Result := False;

  if ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasSolicitado.lancamentos.IsEmpty then
  begin
    MessageDlg('Nenhum lançamento incluído', mtError, [mbOK], 0);
    Abort;
  end;

  lote := ACBrPagamentosAPI.Banco.Pagamentos.LoteGuiasCodigoBarrasSolicitado;
  lote.numeroRequisicao := StrToIntDef(edNumRequisicao.Text, 0);
  lote.codigoContrato := StrToIntDef(edCodigoContrato.Text, 0);
  lote.numeroAgenciaDebito := StrToIntDef(edNumeroAgenciaDebito.Text, 0);
  lote.numeroContaCorrenteDebito := StrToIntDef(edNumeroContaCorrenteDebito.Text, 0);
  lote.digitoVerificadorContaCorrenteDebito := edDigitoCCDebito.Text;

  Result := ACBrPagamentosAPI.Banco.Pagamentos.GuiaCodigoBarrasSolicitarLotePagamentos;
end;

function TfrmPagamentos.EnviarLoteGRU: Boolean;
var
  lote: TACBrLoteGRURequisicao;
begin
  Result := False;

  if ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUSolicitado.listaRequisicao.IsEmpty then
  begin
    MessageDlg('Nenhum lançamento incluído', mtError, [mbOK], 0);
    Abort;
  end;
               
  lote := ACBrPagamentosAPI.Banco.Pagamentos.LoteGRUSolicitado;
  lote.numeroRequisicao := StrToIntDef(edNumRequisicao.Text, 0);
  lote.codigoContrato := StrToIntDef(edCodigoContrato.Text, 0);
  lote.agencia := StrToIntDef(edNumeroAgenciaDebito.Text, 0);
  lote.conta := StrToIntDef(edNumeroContaCorrenteDebito.Text, 0);
  lote.digitoConta := edDigitoCCDebito.Text;

  Result := ACBrPagamentosAPI.Banco.Pagamentos.GRUSolicitarPagamentos;
end;

function TfrmPagamentos.EnviarLoteDARF: Boolean;
var
  lote: TACBrLoteDARFRequisicao;
begin
  Result := False;

  if ACBrPagamentosAPI.Banco.Pagamentos.LoteDARFSolicitado.lancamentos.IsEmpty then
  begin
    MessageDlg('Nenhum lançamento incluído', mtError, [mbOK], 0);
    Abort;
  end;

  lote := ACBrPagamentosAPI.Banco.Pagamentos.LoteDARFSolicitado;
  lote.id := 123456;
  lote.numeroRequisicao := StrToIntDef(edNumRequisicao.Text, 0);
  lote.codigoContrato := StrToIntDef(edCodigoContrato.Text, 0);
  lote.numeroAgenciaDebito := StrToIntDef(edNumeroAgenciaDebito.Text, 0);
  lote.numeroContaCorrenteDebito := StrToIntDef(edNumeroContaCorrenteDebito.Text, 0);
  lote.digitoVerificadorContaCorrenteDebito := edDigitoCCDebito.Text;

  Result := ACBrPagamentosAPI.Banco.Pagamentos.DARFSolicitarPagamentos;
end;

function TfrmPagamentos.EnviarLoteGPS: Boolean;
var
  lote: TACBrLoteGPSRequisicao;
begin
  Result := False;

  if ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSSolicitado.lancamentos.IsEmpty then
  begin
    MessageDlg('Nenhum lançamento incluído', mtError, [mbOK], 0);
    Abort;
  end;

  lote := ACBrPagamentosAPI.Banco.Pagamentos.LoteGPSSolicitado;
  lote.numeroRequisicao := StrToIntDef(edNumRequisicao.Text, 0);
  lote.codigoContrato := StrToIntDef(edCodigoContrato.Text, 0);
  lote.numeroAgenciaDebito := StrToIntDef(edNumeroAgenciaDebito.Text, 0);
  lote.numeroContaCorrenteDebito := StrToIntDef(edNumeroContaCorrenteDebito.Text, 0);
  lote.digitoVerificadorContaCorrenteDebito := edDigitoCCDebito.Text;

  Result := ACBrPagamentosAPI.Banco.Pagamentos.GPSSolicitarPagamentos;
end;

function TfrmPagamentos.ACBrPagamentosAPI: TACBrPagamentosAPI;
begin
  Result := frPagamentosAPITeste.ACBrPagamentosAPI1;
end;

end.

