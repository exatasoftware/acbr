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

unit ACBrMDFeDAMDFeRL;

interface

uses
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  pmdfeMDFe, ACBrMDFe, ACBrMDFeDAMDFeRLClass, ACBrDFeReportFortes;

type

  { TfrlDAMDFeRL }

  TfrlDAMDFeRL = class(TForm)
    RLMDFe: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
  private
    { Private declarations }
  protected
    fpACBrMDFe: TACBrMDFe;
    fpMDFe: TMDFe;
    fpDAMDFe: TACBrMDFeDAMDFeRL;
    fpAfterPreview: boolean;
    fpChangedPos: boolean;
    fpSemValorFiscal: boolean;

    procedure rllSemValorFiscalPrint(Sender: TObject; var Value: string);
  public
    { Public declarations }
    class procedure Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFes: array of TMDFe);
    class procedure SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe; AFile: String);

  end;

implementation

uses
  ACBrUtil;

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

class procedure TfrlDAMDFeRL.Imprimir(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFes: array of TMDFe);
var
  Report: TRLReport;
  ReportNext: TRLCustomReport;
  i: Integer;
  DAMDFeReport: TfrlDAMDFeRL;
  ReportArray: array of TfrlDAMDFeRL;
begin
  if (Length(AMDFes) < 1) then
    Exit;

  try
    SetLength(ReportArray, Length(AMDFes));

    for i := 0 to High(AMDFes) do
    begin
      DAMDFeReport := Create(nil);
      DAMDFeReport.fpMDFe := AMDFes[i];
      DAMDFeReport.fpDAMDFe := ADAMDFe;
      if ADAMDFe.AlterarEscalaPadrao then
      begin
        DAMDFeReport.Scaled := False;
        DAMDFeReport.ScaleBy(ADAMDFe.NovaEscala , Screen.PixelsPerInch);
      end;

      DAMDFeReport.RLMDFe.CompositeOptions.ResetPageNumber := True;
      ReportArray[i] := DAMDFeReport;
    end;

    Report := ReportArray[0].RLMDFe;
    for i := 1 to High(ReportArray) do
    begin
      if (Report.NextReport = nil) then
        Report.NextReport := ReportArray[i].RLMDFe
      else
      begin
        ReportNext := Report.NextReport;

        repeat
          if (ReportNext.NextReport <> nil) then
            ReportNext := ReportNext.NextReport;
        until (ReportNext.NextReport = nil);

        ReportNext.NextReport := ReportArray[i].RLMDFe;
      end;
    end;

    TDFeReportFortes.AjustarReport(Report, DAMDFeReport.fpDAMDFe);

    if DAMDFeReport.fpDAMDFe.MostraPreview then
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

class procedure TfrlDAMDFeRL.SalvarPDF(ADAMDFe: TACBrMDFeDAMDFeRL; AMDFe: TMDFe; AFile: String);
var
  DAMDFeReport: TfrlDAMDFeRL;
//  ADir: String;
begin
  DAMDFeReport := Create(nil);
  try
    DAMDFeReport.fpMDFe := AMDFe;
    DAMDFeReport.fpDAMDFe := ADAMDFe;
    if ADAMDFe.AlterarEscalaPadrao then
    begin
      DAMDFeReport.Scaled := False;
      DAMDFeReport.ScaleBy(ADAMDFe.NovaEscala , Screen.PixelsPerInch);
    end;

    TDFeReportFortes.AjustarReport(DAMDFeReport.RLMDFe, DAMDFeReport.fpDAMDFe);
    TDFeReportFortes.AjustarFiltroPDF(DAMDFeReport.RLPDFFilter1, DAMDFeReport.fpDAMDFe, AFile);

    with DAMDFeReport.RLPDFFilter1.DocumentInfo do
    begin
      Title := ACBrStr('DAMDFe - MDFe n� ') +
          FormatFloat('000,000,000', DAMDFeReport.fpMDFe.Ide.nMDF);
      KeyWords := ACBrStr('N�mero:') + FormatFloat('000,000,000', DAMDFeReport.fpMDFe.Ide.nMDF) +
          ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', DAMDFeReport.fpMDFe.Ide.dhEmi) +
          '; CNPJ: ' + DAMDFeReport.fpMDFe.emit.CNPJCPF;
    end;

    DAMDFeReport.RLMDFe.Prepare;
    DAMDFeReport.RLPDFFilter1.FilterPages(DAMDFeReport.RLMDFe.Pages);
  finally
    FreeAndNil(DAMDFeReport);
  end;
end;

procedure TfrlDAMDFeRL.rllSemValorFiscalPrint(Sender: TObject; var Value: string);
begin
  inherited;
  if fpSemValorFiscal then
    Value := '';
end;

end.
