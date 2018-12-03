{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - NFe - http://www.nfe.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015 Juliomar Marchetti                     }
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

{*******************************************************************************
|* Historico
|*
*******************************************************************************}

{$I ACBr.inc}

unit ACBrNFeDAInutRL;


interface

uses
  SysUtils, Variants, Classes, StrUtils, Printers,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
      Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  pcnNFe, pcnInutNFe,
  ACBrNFe, ACBrUtil, ACBrNFeDANFeRLClass, ACBrDFeReportFortes,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB;

type

  { TfrmNFeDAInutRL }

  TfrmNFeDAInutRL = class(TForm)
    DataSource1: TDataSource;
    RLNFeInut: TRLReport;
    RLPDFFilter1: TRLPDFFilter;

    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    cdsItens:  {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};

    procedure ConfigDataSet;

  protected
    fpInutNFe: TInutNFe;
    fpNFe: TNFe;
    fpDANFe: TACBrNFeDANFeRL;

  public
    class procedure Imprimir(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; ANFe: TNFe = nil);
    class procedure SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; AFile: String = ''; ANFe: TNFe = nil);
  end;

implementation

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

class procedure TfrmNFeDAInutRL.Imprimir(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; ANFe: TNFe = nil);
Var
   DANFeReport: TfrmNFeDAInutRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := aDANFe;
    DANFeReport.fpInutNFe := AInutNFe;
    TDFeReportFortes.AjustarReport(DANFeReport.RLNFeInut, DANFeReport.fpDANFe);

    if ANFe <> nil then
      DANFeReport.fpNFe := ANFe;

    if aDANFe.MostraPreview then
      DANFeReport.RLNFeInut.PreviewModal
    else
      DANFeReport.RLNFeInut.Print;
  finally
     DANFeReport.Free;
  end;
end;

class procedure TfrmNFeDAInutRL.SalvarPDF(aDANFe: TACBrNFeDANFeRL; AInutNFe: TInutNFe; AFile: String = ''; ANFe: TNFe = nil);
var
   i :integer;
   DANFeReport: TfrmNFeDAInutRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpDANFe := aDANFe;
    DANFeReport.fpInutNFe := AInutNFe;
    TDFeReportFortes.AjustarReport(DANFeReport.RLNFeInut, DANFeReport.fpDANFe);
    TDFeReportFortes.AjustarFiltroPDF(DANFeReport.RLPDFFilter1, DANFeReport.fpDANFe, AFile);

    if ANFe <> nil then
    begin
      DANFeReport.fpNFe := ANFe;
      with DANFeReport.RLPDFFilter1.DocumentInfo do
      begin
        Title := ACBrStr('Inutiliza��o - Nota fiscal n� ' +
          FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF));
        KeyWords := ACBrStr('N�mero:' + FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF) +
          '; Data de emiss�o: ' + FormatDateTime('dd/mm/yyyy', DANFeReport.fpNFe.Ide.dEmi) +
          '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
          '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF);
      end;
    end;

    for i := 0 to DANFeReport.ComponentCount -1 do
    begin
      if (DANFeReport.Components[i] is TRLDraw) and (TRLDraw(DANFeReport.Components[i]).DrawKind = dkRectangle) then
      begin
       TRLDraw(DANFeReport.Components[i]).DrawKind := dkRectangle;
       TRLDraw(DANFeReport.Components[i]).Pen.Width := 1;
      end;
    end;

    DANFeReport.RLNFeInut.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFeInut.Pages);
  finally
     DANFeReport.Free;
  end;
end;

procedure TfrmNFeDAInutRL.ConfigDataSet;
begin
 if not Assigned( cdsItens ) then
 cdsItens:=  {$IFDEF BORLAND}  TClientDataSet.create(nil)  {$ELSE}  TBufDataset.create(nil) {$ENDIF};

  if cdsItens.Active then
 begin
 {$IFDEF BORLAND}
  if cdsItens is TClientDataSet then
  TClientDataSet(cdsItens).EmptyDataSet;
 {$ENDIF}
  cdsItens.Active := False;
 end;

 {$IFDEF BORLAND}
 if cdsItens is TClientDataSet then
  begin
  TClientDataSet(cdsItens).StoreDefs := False;
  TClientDataSet(cdsItens).IndexDefs.Clear;
  TClientDataSet(cdsItens).IndexFieldNames := '';
  TClientDataSet(cdsItens).IndexName := '';
  TClientDataSet(cdsItens).Aggregates.Clear;
  TClientDataSet(cdsItens).AggFields.Clear;
  end;
 {$ELSE}
 if cdsItens is TBufDataset then
  begin
  TBufDataset(cdsItens).IndexDefs.Clear;
  TBufDataset(cdsItens).IndexFieldNames:='';
  TBufDataset(cdsItens).IndexName:='';
  end;
 {$ENDIF}

 with cdsItens do
  if FieldCount = 0 then
  begin
    FieldDefs.Clear;
    Fields.Clear;
    FieldDefs.Add('CODIGO',ftString,60);
   {$IFDEF BORLAND}
    if cdsItens is TClientDataSet then
    TClientDataSet(cdsItens).CreateDataSet;
   {$ELSE}
    if cdsItens is TBufDataset then
    TBufDataset(cdsItens).CreateDataSet;
   {$ENDIF}
   end;

 {$IFDEF BORLAND}
  if cdsItens is TClientDataSet then
  TClientDataSet(cdsItens).StoreDefs := False;
 {$ENDIF}

   if not cdsItens.Active then
   cdsItens.Active := True;

  {$IFDEF BORLAND}
   if cdsItens is TClientDataSet then
   if cdsItens.Active then
   TClientDataSet(cdsItens).LogChanges := False;
 {$ENDIF}

 cdsItens.Insert;
 cdsItens.FieldByName('CODIGO').AsString := '1';
 cdsItens.Post;

 DataSource1.dataset := cdsItens;

end;

procedure TfrmNFeDAInutRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrmNFeDAInutRL.FormDestroy(Sender: TObject);
begin  
  if Assigned(cdsItens) then
	FreeAndNil(cdsItens);
	
  RLNFeInut.Free;
end;

end.

