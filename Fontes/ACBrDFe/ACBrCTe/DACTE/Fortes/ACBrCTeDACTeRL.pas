{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                       Juliomar Marchetti                     }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrCTeDACTeRL;

interface

{$H+}

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
  {$IFDEF MSWINDOWS}Windows, Messages, {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts, RLBarcode,
  ACBrCTe, ACBrCTeDACTeRLClass,
  pcteCTe, pcnConversao;

type

  { TfrmDACTeRL }

  TfrmDACTeRL = class(TForm)
    Datasource1: TDatasource;
    RLCTe: TRLReport;
    RLPDFFilter1: TRLPDFFilter;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  protected
    fpACBrCTe: TACBrCTe;
    fpCTe: TCTe;
    fpDACTe: TACBrCTeDACTeRL;
    fpSemValorFiscal: boolean;
    fpTotalPages: integer;

    cdsDocumentos: {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};
    procedure ConfigDataSet;

    procedure rllSemValorFiscalPrint(Sender: TObject; var Value: string);
    function GetTextoResumoCanhoto: string;

  public
    class procedure Imprimir(aDACTe: TACBrCTeDACTeRL; ACTes: array of TCTe);
    class procedure SalvarPDF(aDACTe: TACBrCTeDACTeRL; ACTe: TCTe; AFile: string);

  end;

implementation

uses
  MaskUtils, pcteConversaoCTe,
  ACBrDFeUtil, ACBrDFeReportFortes, ACBrUtil;


{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

class procedure TfrmDACTeRL.Imprimir(aDACTe: TACBrCTeDACTeRL; ACTes: array of TCTe);
var
  Report: TRLReport;
  ReportNext: TRLCustomReport;
  i: integer;
  DACTeReport: TfrmDACTeRL;
  ReportArray: array of TfrmDACTeRL;
begin
  try
    SetLength(ReportArray, Length(ACTes));

    for i := 0 to High(ACTes) do
    begin
      DACTeReport := Create(nil);
      DACTeReport.fpCTe := ACTes[i];
      DACTeReport.fpDACTe := aDACTe;
      if aDACTe.AlterarEscalaPadrao then
      begin
        DACTeReport.Scaled := False;
        DACTeReport.ScaleBy(aDACTe.NovaEscala , Screen.PixelsPerInch);
      end;

      DACTeReport.RLCTe.CompositeOptions.ResetPageNumber := True;
      ReportArray[i] := DACTeReport;
    end;

    if Length(ReportArray) = 0 then
      raise Exception.Create('Nenhum relatorio foi inicializado.');

    Report := ReportArray[0].RLCTe;
    for i := 1 to High(ReportArray) do
    begin
      if Report.NextReport = nil then
        Report.NextReport := ReportArray[i].RLCTe
      else
      begin
        ReportNext := Report.NextReport;

        repeat
          if ReportNext.NextReport <> nil then
            ReportNext := ReportNext.NextReport;
        until ReportNext.NextReport = nil;

        ReportNext.NextReport := ReportArray[i].RLCTe;
      end;
    end;

    TDFeReportFortes.AjustarReport(Report, aDACTe);
    TDFeReportFortes.AjustarMargem(Report, aDACTe);

    if aDACTe.MostraPreview then
      Report.PreviewModal
    else
      Report.Print;
  finally
    if (ReportArray <> nil) then
    begin
      for i := 0 to High(ReportArray) do
        FreeAndNil(ReportArray[i]);

      SetLength(ReportArray, 0);
      Finalize(ReportArray);
      ReportArray := nil;
    end;
  end;
end;

class procedure TfrmDACTeRL.SalvarPDF(aDACTe: TACBrCTeDACTeRL; ACTe: TCTe; AFile: string);
var
  DACTeReport: TfrmDACTeRL;
begin
  DACTeReport := Create(nil);
  try
    DACTeReport.fpCTe := ACTe;
    DACTeReport.fpDACTe := aDACTe;
    if aDACTe.AlterarEscalaPadrao then
    begin
      DACTeReport.Scaled := False;
      DACTeReport.ScaleBy(aDACTe.NovaEscala , Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DACTeReport.RLCTe, DACTeReport.fpDACTe);
    TDFeReportFortes.AjustarMargem(DACTeReport.RLCTe, DACTeReport.fpDACTe);
    TDFeReportFortes.AjustarFiltroPDF(DACTeReport.RLPDFFilter1, DACTeReport.fpDACTe, AFile);

    with DACTeReport.RLPDFFilter1.DocumentInfo do
    begin
      Title := 'DACTE - Conhecimento n� ' +
        FormatFloat('000,000,000', DACTeReport.fpCTe.Ide.nCT);
        KeyWords := 'N�mero:' + FormatFloat('000,000,000', DACTeReport.fpCTe.Ide.nCT) +
          '; Data de emiss�o: ' + FormatDateTime('dd/mm/yyyy', DACTeReport.fpCTe.Ide.dhEmi) +
          '; Destinat�rio: ' + DACTeReport.fpCTe.Dest.xNome +
          '; CNPJ: ' + DACTeReport.fpCTe.Dest.CNPJCPF;
    end;

    DACTeReport.RLCTe.Prepare;
    DACTeReport.RLPDFFilter1.FilterPages(DACTeReport.RLCTe.Pages);
  finally
    if DACTeReport <> nil then
        FreeAndNil(DACTeReport);
  end;
end;

procedure TfrmDACTeRL.rllSemValorFiscalPrint(Sender: TObject; var Value: string);
begin
  inherited;
  if fpSemValorFiscal then
    Value := '';
end;

procedure TfrmDACTeRL.FormDestroy(Sender: TObject);
begin
  RLCTe.Free;
  FreeAndNil(cdsDocumentos);
end;

procedure TfrmDACTeRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrmDACTeRL.ConfigDataSet;
begin
  if not Assigned(cdsDocumentos) then
    cdsDocumentos :=
{$IFDEF BORLAND}  TClientDataSet.create(nil)  {$ELSE}
      TBufDataset.Create(nil)
{$ENDIF}
  ;

  if cdsDocumentos.Active then
  begin
   {$IFDEF BORLAND}
    if cdsDocumentos is TClientDataSet then
    TClientDataSet(cdsDocumentos).EmptyDataSet;
   {$ENDIF}
    cdsDocumentos.Active := False;
  end;

   {$IFDEF BORLAND}
   if cdsDocumentos is TClientDataSet then
    begin
    TClientDataSet(cdsDocumentos).StoreDefs := False;
    TClientDataSet(cdsDocumentos).IndexDefs.Clear;
    TClientDataSet(cdsDocumentos).IndexFieldNames := '';
    TClientDataSet(cdsDocumentos).IndexName := '';
    TClientDataSet(cdsDocumentos).Aggregates.Clear;
    TClientDataSet(cdsDocumentos).AggFields.Clear;
    end;
   {$ELSE}
  if cdsDocumentos is TBufDataset then
  begin
    TBufDataset(cdsDocumentos).IndexDefs.Clear;
    TBufDataset(cdsDocumentos).IndexFieldNames := '';
    TBufDataset(cdsDocumentos).IndexName := '';
  end;
   {$ENDIF}

  with cdsDocumentos do
    if FieldCount = 0 then
    begin
      FieldDefs.Clear;
      Fields.Clear;
      FieldDefs.Add('TIPO_1', ftString, 15);
      FieldDefs.Add('CNPJCPF_1', ftString, 70);
      FieldDefs.Add('DOCUMENTO_1', ftString, 33);
      FieldDefs.Add('TIPO_2', ftString, 15);
      FieldDefs.Add('CNPJCPF_2', ftString, 70);
      FieldDefs.Add('DOCUMENTO_2', ftString, 33);

     {$IFDEF BORLAND}
      if cdsDocumentos is TClientDataSet then
      TClientDataSet(cdsDocumentos).CreateDataSet;
     {$ELSE}
      if cdsDocumentos is TBufDataset then
        TBufDataset(cdsDocumentos).CreateDataSet;
     {$ENDIF}
    end;

   {$IFDEF BORLAND}
    if cdsDocumentos is TClientDataSet then
    TClientDataSet(cdsDocumentos).StoreDefs := False;
   {$ENDIF}

  if not cdsDocumentos.Active then
    cdsDocumentos.Active := True;

    {$IFDEF BORLAND}
     if cdsDocumentos is TClientDataSet then
     if cdsDocumentos.Active then
     TClientDataSet(cdsDocumentos).LogChanges := False;
   {$ENDIF}

  DataSource1.dataset := cdsDocumentos;
end;

function TfrmDACTeRL.GetTextoResumoCanhoto: string;
begin
  Result := 'EMIT: ' + fpCTe.Emit.xNome + ' - ' +
    'EMISS�O: ' + FormatDateTime('DD/MM/YYYY', fpCTe.Ide.dhEmi) + '  -  TOMADOR: ';
  if fpCTe.Ide.Toma4.xNome = '' then
  begin
    case fpCTe.Ide.Toma03.Toma of
      tmRemetente: Result := Result + fpCTe.Rem.xNome;
      tmExpedidor: Result := Result + fpCTe.Exped.xNome;
      tmRecebedor: Result := Result + fpCTe.Receb.xNome;
      tmDestinatario: Result := Result + fpCTe.Dest.xNome;
    end;
  end
  else
    Result := Result + fpCTe.Ide.Toma4.xNome;
  Result := Result + ' - VALOR A RECEBER: R$ ' + fpDACTe.FormatarValorUnitario(fpCTe.vPrest.vRec);
end;

end.
