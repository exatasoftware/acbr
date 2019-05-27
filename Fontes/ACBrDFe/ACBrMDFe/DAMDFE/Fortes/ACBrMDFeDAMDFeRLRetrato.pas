{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrMDFeDAMDFeRLRetrato;

interface

uses
  Messages, SysUtils, Variants, Classes, db, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RLReport, RLBarcode, RLPDFFilter, pcnConversao,
  pmdfeConversaoMDFe, ACBrMDFeDAMDFeRL, ACBrMDFeDAMDFeClass, ACBrMDFeDAMDFeRLClass,
  RLFilters;

type

  { TfrlDAMDFeRLRetrato }

  TfrlDAMDFeRLRetrato = class(TfrlDAMDFeRL)
    rlb_2_Rodo: TRLBand;
    rlb_3_Aereo: TRLBand;
    rlb_4_Aquav: TRLBand;
    rlb_5_Ferrov: TRLBand;
    rlb_6_Observacao: TRLBand;
    rlLabel22: TRLLabel;
    rllMsgTeste: TRLLabel;
    rllDataHoraImpressao: TRLLabel;
    rllSistema: TRLLabel;
    rlb_7_Documentos_Titulos: TRLBand;
    rlLabel141: TRLLabel;
    rlLabel91: TRLLabel;
    rlLabel92: TRLLabel;
    rlLabel96: TRLLabel;
    rlLabel109: TRLLabel;
    rlLabel106: TRLLabel;
    rlLabel100: TRLLabel;
    rlmObservacao: TRLMemo;
    RLBand1: TRLBand;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLDraw4: TRLDraw;
    rlLabel12: TRLLabel;
    rllPesoTotal: TRLLabel;
    rllqMDFe: TRLLabel;
    rllqNFe: TRLLabel;
    rllqCTe: TRLLabel;
    rlLabel23: TRLLabel;
    rlLabel10: TRLLabel;
    rlLabel5: TRLLabel;
    RLBand2: TRLBand;
    rllModal: TRLLabel;
    subItens: TRLSubDetail;
    rlbItens: TRLBand;
    LinhaQuantidade: TRLDraw;
    rlmChave1: TRLMemo;
    rlmChave2: TRLMemo;
    rlb_1_DadosManifesto: TRLBand;
    rliLogo: TRLImage;
    rlmEmitente: TRLMemo;
    rlmDadosEmitente: TRLMemo;
    RLPanel1: TRLPanel;
    RLPanel2: TRLPanel;
    rllProtocolo: TRLLabel;
    rllDescricao: TRLLabel;
    RLPanel3: TRLPanel;
    rllChave: TRLLabel;
    rlLabel1: TRLLabel;
    RLPanel4: TRLPanel;
    RLBarcode1: TRLBarcode;
    rlLabel74: TRLLabel;
    rlLabel17: TRLLabel;
    RLMemo1: TRLMemo;
    RLPanel5: TRLPanel;
    RLPanel6: TRLPanel;
    rllModelo: TRLLabel;
    rllSerie: TRLLabel;
    rllNumMDFe: TRLLabel;
    RLSystemInfo1: TRLSystemInfo;
    rllEmissao: TRLLabel;
    rllUFCarrega: TRLLabel;
    rllUFDescarrega: TRLLabel;
    rlLabel2: TRLLabel;
    rlLabel3: TRLLabel;
    rlLabel4: TRLLabel;
    rlLabel25: TRLLabel;
    rlLabel33: TRLLabel;
    rlLabel77: TRLLabel;
    RLLabel6: TRLLabel;
    rlsLinhaV05: TRLDraw;
    rlsLinhaV06: TRLDraw;
    rlsLinhaV07: TRLDraw;
    rlsLinhaV08: TRLDraw;
    rlsLinhaV09: TRLDraw;
    RLDraw1: TRLDraw;
    RLPanel7: TRLPanel;
    rlShape10: TRLDraw;
    rlLabel35: TRLLabel;
    rlLabel9: TRLLabel;
    rlLabel13: TRLLabel;
    rlLabel14: TRLLabel;
    rlLabel15: TRLLabel;
    rlLabel16: TRLLabel;
    RLDraw5: TRLDraw;
    RLDraw6: TRLDraw;
    rlmCPF: TRLMemo;
    rlmCondutor: TRLMemo;
    RLDraw7: TRLDraw;
    RLDraw8: TRLDraw;
    rlmPlaca: TRLMemo;
    rlmRNTRC: TRLMemo;
    RLDraw9: TRLDraw;
    RLLabel7: TRLLabel;
    RLDraw10: TRLDraw;
    rlLabel19: TRLLabel;
    rlLabel20: TRLLabel;
    rlLabel21: TRLLabel;
    rlShape16: TRLDraw;
    rlShape17: TRLDraw;
    rlmRespCNPJ: TRLMemo;
    rlmFornCNPJ: TRLMemo;
    rlmNumComprovante: TRLMemo;
    RLPanel8: TRLPanel;
    RLPanel9: TRLPanel;
    rlLabel24: TRLLabel;
    rllCodEmbar: TRLLabel;
    rlLabel26: TRLLabel;
    rllNomeEmbar: TRLLabel;
    RLLabel8: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel18: TRLLabel;
    RLLabel31: TRLLabel;
    rlmCodCarreg: TRLMemo;
    rlmNomeCarreg: TRLMemo;
    rlmCodDescarreg: TRLMemo;
    rlmNomeDescarreg: TRLMemo;
    RLDraw11: TRLDraw;
    RLDraw12: TRLDraw;
    RLDraw13: TRLDraw;
    RLDraw14: TRLDraw;
    rlbNumcipio: TRLLabel;
    RLDraw15: TRLDraw;
    RLLabel27: TRLLabel;
    rllValorMercadoria: TRLLabel;
    RLLabel28: TRLLabel;
    RLLabel29: TRLLabel;
    rlmRespSeguradora: TRLMemo;
    RLLabel30: TRLLabel;
    rlmRespApolice: TRLMemo;
    RLDraw16: TRLDraw;
    RLDraw17: TRLDraw;
    RLLabel32: TRLLabel;
    rlmRespAverbacao: TRLMemo;
    rlmRespSeguro: TRLLabel;
    procedure rlb_1_DadosManifestoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_2_RodoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_3_AereoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_4_AquavBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_5_FerrovBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_6_ObservacaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLMDFeBeforePrint(Sender: TObject; var PrintIt: boolean);
    procedure subItensDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure RLMDFeDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensAfterPrint(Sender: TObject);
  private
    { Private declarations }
    FNumItem: Integer;
    FTotalPages: integer;
  end;

implementation

uses
  StrUtils, DateUtils,
  pmdfeMDFe,
  ACBrUtil, ACBrDFeUtil, ACBrValidador, ACBrDFeReportFortes;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

const
  _NUM_ITEMS_PAGE1 = 18;
  _NUM_ITEMS_OTHERPAGES = 50;

var
  nItemControle: integer;

procedure TfrlDAMDFeRLRetrato.rlb_1_DadosManifestoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  CarregouLogo: Boolean;
begin
  inherited;
  if  (RLMDFe.PageNumber <> 1) then
  begin
    rlb_2_Rodo.Visible := False;
    RLBand2.Visible    := False;
    RLBand1.Visible    := False;
  end;

  {$IFNDEF BORLAND}
    RLMemo1.Layout := tlCenter;
    RLMemo1.Font.Size := 6;
  {$ENDIF}

  CarregouLogo := TDFeReportFortes.CarregarLogo(rliLogo, fpDAMDFe.Logo);

  if fpDAMDFe.ExpandeLogoMarca then
  begin
    rliLogo.top     := 2;
    rliLogo.Left    := 2;
    rliLogo.Height  := 142;
    rliLogo.Width   := 330;
    rliLogo.Stretch := True;

    rlmEmitente.visible := False;
    rlmDadosEmitente.visible := False;
  end
  else
  begin
    rliLogo.Stretch := true;
    rlmEmitente.Enabled := True;
    rlmDadosEmitente.Enabled := True;
    // Emitente
    with fpMDFe.Emit do
    begin
      rlmEmitente.Lines.Text := XNome;

      rlmDadosEmitente.Lines.Clear;
      with EnderEmit do
      begin
        rlmDadosEmitente.Lines.Add(XLgr + IfThen(Nro = '0', '', ', ' + Nro));
        if XCpl <> '' then
          rlmDadosEmitente.Lines.Add(XCpl);
        if XBairro <> '' then
          rlmDadosEmitente.Lines.Add(XBairro);
        rlmDadosEmitente.Lines.Add('CEP: ' + FormatarCEP(CEP) +
          ' - ' + XMun + ' - ' + UF);
      end;
      rlmDadosEmitente.Lines.Add('CNPJ: ' + FormatarCNPJouCPF(CNPJCPF));
      rlmDadosEmitente.Lines.Add(ACBrStr('INSCRI��O ESTADUAL: ') + IE);
      rlmDadosEmitente.Lines.Add('TELEFONE: ' + FormatarFone(EnderEmit.Fone));

      if Trim(fpDAMDFe.Site) <> '' then
        rlmDadosEmitente.Lines.Add('SITE: ' + fpDAMDFe.Site);
      if Trim(fpDAMDFe.Email) <> '' then
        rlmDadosEmitente.Lines.Add('E-MAIL: ' + fpDAMDFe.Email);
    end;
  end;

  RLBarcode1.Caption := Copy ( fpMDFe.InfMDFe.Id, 5, 44 );
  rllChave.Caption   := FormatarChaveAcesso(Copy(fpMDFe.InfMDFe.Id, 5, 44));

  if fpMDFe.ide.tpEmis = teNormal then
  begin
    rllProtocolo.Font.Size  := 8;
    rllProtocolo.Font.Style := [fsBold];

    if fpDAMDFe.Protocolo <> '' then
      rllProtocolo.Caption := fpDAMDFe.Protocolo
    else
      rllProtocolo.Caption := fpMDFe.procMDFe.nProt + '   ' +
        IfThen(fpMDFe.procMDFe.dhRecbto <> 0,
        DateTimeToStr(fpMDFe.procMDFe.dhRecbto), '');
  end
  else
  begin
    rllProtocolo.Font.Size  := 5;
    rllProtocolo.Font.Style := [];

    rllProtocolo.Caption := ACBrStr('Impress�o em conting�ncia. Obrigat�ria a autoriza��o em 168 horas' +
      ' ap�s esta Emiss�o (') + FormatDateTime('dd/mm/yyyy hh:nn', Now) + ')';
  end;

  rllModelo.Caption       := fpMDFe.Ide.modelo;
  rllSerie.Caption        := Poem_Zeros(fpMDFe.Ide.serie, 3);
  rllNumMDFe.Caption      := FormatarNumeroDocumentoFiscal(IntToStr(fpMDFe.Ide.nMDF));
  rllEmissao.Caption      := FormatDateTimeBr(fpMDFe.Ide.dhEmi);
  rllUFCarrega.Caption    := fpMDFe.Ide.UFIni;
  rllUFDescarrega.Caption := fpMDFe.Ide.UFFim;

  rlb_2_Rodo.Enabled   := False;
  rlb_3_Aereo.Enabled  := false;
  rlb_4_Aquav.Enabled  := false;
  rlb_5_Ferrov.Enabled := false;

  case fpMDFe.Ide.modal of
    moRodoviario  : rllModal.Caption := ACBrStr('MODAL RODOVI�RIO DE CARGA');
    moAereo       : rllModal.Caption := ACBrStr('MODAL A�REO DE CARGA');
    moAquaviario  : rllModal.Caption := ACBrStr('MODAL AQUAVI�RIO DE CARGA');
    moFerroviario : rllModal.Caption := ACBrStr('MODAL FERROVI�RIO DE CARGA');
  end;

  rllqCTe.Caption  := FormatFloatBr(fpMDFe.tot.qCTe,  '#0');
  rllqNFe.Caption  := FormatFloatBr(fpMDFe.tot.qNFe,  '#0');
  rllqMDFe.Caption := FormatFloatBr(fpMDFe.tot.qMDFe, '#0');

  if fpMDFe.tot.cUnid = uTON then
    rlLabel12.Caption := 'PESO TOTAL (Ton)'
  else
    rlLabel12.Caption := 'PESO TOTAL (Kg)';

  rllPesoTotal.Caption := FormatFloatBr(fpMDFe.tot.qCarga, ',#0.0000');
  rllValorMercadoria.Caption := FormatFloatBr(fpMDFe.tot.vCarga, ',#0.00');
end;

procedure TfrlDAMDFeRLRetrato.rlb_2_RodoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  i, j: integer;
  averbacao: string;
begin
  inherited;
  rlb_2_Rodo.Enabled := (fpMDFe.Ide.modal = moRodoviario);
  if rlb_2_Rodo.Enabled then
    rlb_2_Rodo.Height := 208
  else
    rlb_2_Rodo.Height := 0;

  rlmPlaca.Lines.Clear;
  rlmPlaca.Lines.Add(FormatarPlaca(fpMDFe.rodo.veicTracao.placa) + ' - ' +
                     fpMDFe.rodo.veicTracao.UF );

  rlmRNTRC.Lines.Clear;
  if fpMDFe.rodo.veicTracao.prop.RNTRC <> '' then
    rlmRNTRC.Lines.Add(fpMDFe.rodo.veicTracao.prop.RNTRC)
  else
    if (fpMDFe.infMDFe.versao >= 3) then
      rlmRNTRC.Lines.Add(fpMDFe.rodo.infANTT.RNTRC)
    else
      rlmRNTRC.Lines.Add(fpMDFe.rodo.RNTRC);

  for i := 0 to fpMDFe.rodo.veicReboque.Count - 1 do
  begin
    rlmPlaca.Lines.Add(FormatarPlaca(fpMDFe.rodo.veicReboque.Items[i].placa) + ' - ' +
                     fpMDFe.rodo.veicReboque.Items[i].UF );
    if fpMDFe.rodo.veicReboque.Items[i].prop.RNTRC <> '' then
      rlmRNTRC.Lines.Add(fpMDFe.rodo.veicReboque.Items[i].prop.RNTRC)
    else
      rlmRNTRC.Lines.Add(fpMDFe.rodo.RNTRC);
  end;

  rlmCPF.Lines.Clear;
  rlmCondutor.Lines.Clear;

  for i := 0 to fpMDFe.rodo.veicTracao.condutor.Count - 1 do
  begin
    rlmCPF.Lines.Add(FormatarCPF(fpMDFe.rodo.veicTracao.condutor.Items[i].CPF));
    rlmCondutor.Lines.Add(fpMDFe.rodo.veicTracao.condutor.Items[i].xNome);
  end;

  rlmRespCNPJ.Lines.Clear;
  rlmFornCNPJ.Lines.Clear;
  rlmNumComprovante.Lines.Clear;
  
  if fpMDFe.rodo.valePed.disp.Count > 0 then
  begin
    for i := 0 to fpMDFe.rodo.valePed.disp.Count - 1 do
    begin
      rlmRespCNPJ.Lines.Add(FormatarCNPJ(fpMDFe.rodo.valePed.disp.Items[i].CNPJPg));
      rlmFornCNPJ.Lines.Add(FormatarCNPJ(fpMDFe.rodo.valePed.disp.Items[i].CNPJForn));
      rlmNumComprovante.Lines.Add(fpMDFe.rodo.valePed.disp.Items[i].nCompra);
    end;
  end
  else
  if fpMDFe.rodo.infANTT.valePed.disp.Count > 0 then
  begin
    for i := 0 to fpMDFe.rodo.infANTT.valePed.disp.Count - 1 do
    begin
      rlmRespCNPJ.Lines.Add(FormatarCNPJ(fpMDFe.rodo.infANTT.valePed.disp.Items[i].CNPJPg));
      rlmFornCNPJ.Lines.Add(FormatarCNPJ(fpMDFe.rodo.infANTT.valePed.disp.Items[i].CNPJForn));
      rlmNumComprovante.Lines.Add(fpMDFe.rodo.infANTT.valePed.disp.Items[i].nCompra);
    end;
  end;

  rlmRespSeguradora.Lines.Clear;
  rlmRespApolice.Lines.Clear;
  rlmRespAverbacao.Lines.Clear;

  rlmRespSeguro.Caption:= '';

  if fpMDFe.seg.Count > 0 then
    rlmRespSeguro.Caption := RspSeguroMDFeToStrText(fpMDFe.seg.Items[0].respSeg);

  for i := 0 to fpMDFe.seg.Count - 1 do
  begin
    rlmRespSeguradora.Lines.Add(fpMDFe.seg.Items[i].xSeg);
    rlmRespApolice.Lines.Add(fpMDFe.seg.Items[i].nApol);

    averbacao := '';
    for j := 0 to fpMDFe.seg.Items[i].aver.Count - 1 do
    begin
      if (averbacao = '') then
        averbacao := fpMDFe.seg.Items[i].aver.Items[j].nAver
      else
        averbacao := averbacao +'; '+ fpMDFe.seg.Items[i].aver.Items[j].nAver;
    end;
    rlmRespAverbacao.Lines.Add(averbacao);
  end;
end;

procedure TfrlDAMDFeRLRetrato.rlb_3_AereoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  rlb_3_Aereo.Enabled := (fpMDFe.Ide.modal = moAereo);
  if rlb_3_Aereo.Enabled then
    rlb_3_Aereo.Height := 54
  else
    rlb_3_Aereo.Height := 0;
end;

procedure TfrlDAMDFeRLRetrato.rlb_4_AquavBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  i: integer;
begin
  inherited;
  rlb_4_Aquav.Enabled := (fpMDFe.Ide.modal = moAquaviario);
  if rlb_4_Aquav.Enabled then
    rlb_4_Aquav.Height := 121
  else
    rlb_4_Aquav.Height := 0;

  rllCodEmbar.Caption  := fpMDFe.aquav.cEmbar;
  rllNomeEmbar.Caption := fpMDFe.aquav.xEmbar;

  rlmCodCarreg.Lines.Clear;
  rlmNomeCarreg.Lines.Clear;
  rlmCodDescarreg.Lines.Clear;
  rlmNomeDescarreg.Lines.Clear;

  for i := 0 to fpMDFe.aquav.infTermCarreg.Count - 1 do
  begin
    rlmCodCarreg.Lines.Add(fpMDFe.aquav.infTermCarreg.Items[i].cTermCarreg);
    rlmNomeCarreg.Lines.Add(fpMDFe.aquav.infTermCarreg.Items[i].xTermCarreg);
  end;

  for i := 0 to fpMDFe.aquav.infTermDescarreg.Count - 1 do
  begin
    rlmCodDescarreg.Lines.Add(fpMDFe.aquav.infTermDescarreg.Items[i].cTermDescarreg);
    rlmNomeDescarreg.Lines.Add(fpMDFe.aquav.infTermDescarreg.Items[i].xTermDescarreg);
  end;
end;

procedure TfrlDAMDFeRLRetrato.rlb_5_FerrovBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  rlb_5_Ferrov.Enabled := (fpMDFe.Ide.modal = moFerroviario);
  if rlb_5_Ferrov.Enabled then
    rlb_5_Ferrov.Height := 60
  else
    rlb_5_Ferrov.Height := 0;
end;

procedure TfrlDAMDFeRLRetrato.rlb_6_ObservacaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  rlmObservacao.Lines.BeginUpdate;
  rlmObservacao.Lines.Clear;
  rlmObservacao.Lines.Add(StringReplace(fpMDFe.infAdic.infCpl, '&lt;BR&gt;', #13#10, [rfReplaceAll, rfIgnoreCase]));
  rlmObservacao.Lines.Text := StringReplace(rlmObservacao.Lines.Text, ';', #13, [rfReplaceAll]);
  rlmObservacao.Lines.EndUpdate;

  // Mensagem para modo Homologacao.

  rllMsgTeste.Enabled := False;
  rllMsgTeste.Visible := False;

  if fpMDFe.Ide.tpAmb = taHomologacao then
  begin
    rllMsgTeste.Caption := ACBrStr('AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL');
    rllMsgTeste.Enabled := True;
    rllMsgTeste.Visible := True;
  end
  else
  begin
    if fpMDFe.procMDFe.cStat > 0 then
    begin
      if (fpMDFe.procMDFe.cStat = 101) or (fpDAMDFe.Cancelada) then
      begin
        rllMsgTeste.Caption := 'MDF-e CANCELADO';
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;

      if (fpMDFe.procMDFe.cStat = 100) and (fpDAMDFe.Encerrado) then
      begin
        rllMsgTeste.Caption := 'MDF-e ENCERRADO';
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;

      if fpMDFe.procMDFe.cStat = 110 then
      begin
        rllMsgTeste.Caption := 'MDF-e DENEGADO';
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;

      if not fpMDFe.procMDFe.cStat in [101, 110, 100] then
      begin
        rllMsgTeste.Caption := fpMDFe.procMDFe.xMotivo;
        rllMsgTeste.Visible := True;
        rllMsgTeste.Enabled := True;
      end;
    end
    else
    begin
      rllMsgTeste.Caption := ACBrStr('MDF-E N�O ENVIADO PARA SEFAZ');
      rllMsgTeste.Visible := True;
      rllMsgTeste.Enabled := True;
    end;
  end;

  rllMsgTeste.Repaint;

  // imprime data e hora da impressao
  rllDataHoraImpressao.Caption := ACBrStr('DATA E HORA DA IMPRESS�O: ') + FormatDateTime('dd/mm/yyyy hh:nn', Now);

  // imprime usuario
  if fpDAMDFe.Usuario <> '' then
    rllDataHoraImpressao.Caption := rllDataHoraImpressao.Caption + ACBrStr('   USU�RIO: ') + fpDAMDFe.Usuario;

  // imprime sistema
  if fpDAMDFe.Sistema <> '' then
    rllSistema.Caption := 'Desenvolvido por ' + fpDAMDFe.Sistema
  else
    rllSistema.Caption := '';
end;

procedure TfrlDAMDFeRLRetrato.RLMDFeBeforePrint(Sender: TObject; var PrintIt: boolean);
begin
  inherited;
  nItemControle := 0;
  FTotalPages   := 1;
  RLMDFe.Title  := ACBrStr('Manifesto Eletr�nico de Documentos Fiscais - MDF-e');

  TDFeReportFortes.AjustarMargem(RLMDFe, fpDAMDFe);

  with RLMDFe do
  begin
    Title              := ACBrStr('Manifesto Eletr�nico de Documentos Fiscais - MDF-e');
    Borders.DrawTop    := true;
    Borders.DrawLeft   := true;
    Borders.DrawRight  := true;
    Borders.DrawBottom := true;
  end;

  with rlb_1_DadosManifesto do
  begin
    Borders.DrawTop    := False;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := False;
  end;

  with rlb_2_Rodo do
  begin
    Borders.DrawTop    := True;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := False;
  end;

  with RLBand2 do
  begin
    Borders.DrawTop    := False;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := False;
  end;

  with RLBand1 do
  begin
    Borders.DrawTop    := True;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := False;
  end;

  with rlb_7_Documentos_Titulos do
  begin
    Borders.DrawTop    := True;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := True;
  end;

  with rlb_6_Observacao do
  begin
    BandType           := btFooter;
    Borders.DrawTop    := True;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := False;
  end;

  subItens.Borders.DrawLeft  := False;
  subItens.Borders.DrawRight := False;

  with rlbItens do
  begin
    AutoSize           := True;
    Borders.DrawTop    := False;
    Borders.DrawLeft   := False;
    Borders.DrawRight  := False;
    Borders.DrawBottom := true;
  end;

  rlmChave1.Lines.Clear;
  rlmChave2.Lines := rlmChave1.Lines;

  rlmChave1.AutoSize := True;
  rlmChave2.AutoSize := rlmChave1.AutoSize;
end;

procedure TfrlDAMDFeRLRetrato.RLMDFeDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  inherited;
  Eof := (RecNo > 1);
  RecordAction := raUseIt;
  rlb_6_Observacao.Visible := Eof;
end;



procedure TfrlDAMDFeRLRetrato.subItensDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  inherited;
  FNumItem     := RecNo - 1;
  Eof          := (RecNo > fpMDFe.infDoc.infMunDescarga.Count);
  RecordAction := raUseIt;
end;

procedure TfrlDAMDFeRLRetrato.rlbItensAfterPrint(Sender: TObject);
begin
  inherited;
  rlmChave1.Lines.Clear;
  rlmChave2.Lines.Clear;
end;

procedure TfrlDAMDFeRLRetrato.rlbItensBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  J, nItem : integer;

  procedure Printar( sTemp : String; nItem : Integer );
  begin
    if (nItem mod 2) = 0 then
      rlmChave1.Lines.Add(sTemp)
    else
      rlmChave2.Lines.Add( sTemp);
  end;
begin
  nItem := 0;
  with fpMDFe.infDoc.infMunDescarga.Items[FNumItem] do
  begin
    rlbNumcipio.Caption   := ACBrStr(Format('Munic�pio %s ',[ fpMDFe.infDoc.infMunDescarga.Items[FNumItem].xMunDescarga]));
   // Lista de CT-e
    for J := 0 to ( infCTe.Count - 1) do
    begin
      Printar( 'CT-e          ' + FormatarChaveAcesso(infCTe.Items[J].chCTe), nItem);
      Inc(nItem);
    end;

   // Lista de CT
    for J := 0 to (infCT.Count - 1) do
    begin
      Printar( 'CT            ' + FormatarCNPJouCPF(fpMDFe.emit.CNPJCPF) + ' - '
                                + IntToStr(infCT.Items[J].serie)     + '-'
                                + infCT.Items[J].nCT , nItem );
      Inc(nItem);
    end;

    // Lista de NF-e
    for J := 0 to (infNFe.Count - 1) do
    begin
      Printar( 'NF-e          ' + FormatarChaveAcesso(infNFe.Items[J].chNFe),nItem );
      Inc(nItem);
    end;

    // Lista de NF
    for J := 0 to ( infNF.Count - 1) do
    begin
      Printar( 'NF            ' + FormatarCNPJouCPF(infNF.Items[J].CNPJ) + ' - '
                                + IntToStr(infNF.Items[J].serie) + '-'
                                + IntToStr(infNF.Items[J].nNF),nItem);
      Inc(nItem);
    end;

    // Lista de MDF-e
    for J := 0 to ( infMDFeTransp.Count - 1) do
    begin
      Printar( 'MDF-e         ' + FormatarChaveAcesso( infMDFeTransp.Items[J].chMDFe),nItem);
      Inc(nItem);
    end;
  end;
  inherited;
end;

end.
