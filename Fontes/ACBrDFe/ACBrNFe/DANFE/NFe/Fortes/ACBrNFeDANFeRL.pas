{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{$I ACBr.inc}
unit ACBrNFeDANFeRL;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, Qt,
  {$ELSE}
  Graphics, Controls, Forms,
  {$ENDIF}
  ACBrNFeDANFeRLClass, ACBrDFeReportFortes,
  pcnNFe, pcnConversao,
  RLReport, RLPDFFilter, RLFilters;

type

  { TfrlDANFeRL }

  TfrlDANFeRL = class(TForm)
    RLNFe: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject);

  protected
    fpNFe: TNFe;
    fpDANFe: TACBrNFeDANFeRL;
    fpCorDestaqueProdutos: TColor;

    fpLimiteLinhas: Integer;
    fpLimiteCaracteresLinha: Integer;
    fpLimiteCaracteresContinuacao: Integer;
    fpLinhasUtilizadas: Integer;
    fpAuxDiferencaPDF: Integer;

    fpQuantItens: Integer;
    fpItemAtual: Integer;

    procedure ConfigurarVariavies(ATipoDANFE: TpcnTipoImpressao);
    procedure InserirLinhas(sTexto: String; iLimCaracteres: Integer; rMemo: TRLMemo);

  public
    class procedure Imprimir(ADANFe: TACBrNFeDANFeRL; ANotas: array of TNFe);
    class procedure SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; const AFile: String);
  end;

implementation

uses
  StrUtils, Math,
  ACBrValidador, ACBrUtil;

{$IfNDef FPC}
 {$R *.dfm}
{$Else}
 {$R *.lfm}
{$EndIf}

class procedure TfrlDANFeRL.Imprimir(ADANFe: TACBrNFeDANFeRL; ANotas: array of TNFe);
var
  Report: TRLReport;
  ReportNext: TRLCustomReport;
  i: Integer;
  DANFeReport: TfrlDANFeRL;
  ReportArray: array of TfrlDANFeRL;
begin
  if (Length(ANotas) < 1) then
    Exit;

  DANFeReport := nil;
  try
    SetLength(ReportArray, Length(ANotas));

    for i := 0 to High(ANotas) do
    begin
      DANFeReport := Create(nil);
      DANFeReport.fpNFe := ANotas[i];
      DANFeReport.fpDANFe := ADANFe;

      DANFeReport.RLNFe.CompositeOptions.ResetPageNumber := True;
      DANFeReport.fpAuxDiferencaPDF := 0;
      ReportArray[i] := DANFeReport;
    end;

    Report := ReportArray[0].RLNFe;
    //Associa cada Report com o pr�ximo;
    for i := 1 to High(ReportArray) do
    begin
      ReportNext := Report;
      while (ReportNext.NextReport <> nil) do
      begin
        ReportNext := ReportNext.NextReport;
      end;
      ReportNext.NextReport := ReportArray[i].RLNFe;
    end;

    TDFeReportFortes.AjustarReport(Report, ADANFe);

    if ADANFe.MostraPreview then
    begin
      if Assigned(DANFeReport) then
        SelectedFilter := DANFeReport.RLPDFFilter1;

      Report.PreviewModal;
    end
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

class procedure TfrlDANFeRL.SalvarPDF(ADANFe: TACBrNFeDANFeRL; ANFe: TNFe; const AFile: String);
var
  DANFeReport: TfrlDANFeRL;
begin
  DANFeReport := Create(nil);
  try
    DANFeReport.fpNFe := ANFe;
    DANFeReport.fpDANFe := ADANFe;

    TDFeReportFortes.AjustarReport(DANFeReport.RLNFe, DANFeReport.fpDANFe);
    TDFeReportFortes.AjustarFiltroPDF(DANFeReport.RLPDFFilter1, DANFeReport.fpDANFe, AFile);

    with DANFeReport.RLPDFFilter1.DocumentInfo do
    begin
      Title := ACBrStr('DANFE - Nota fiscal n� ') +
        FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF);
      KeyWords := ACBrStr(
        'N�mero:' + FormatFloat('000,000,000', DANFeReport.fpNFe.Ide.nNF) +
        '; Data de emiss�o: ' + FormatDateBr(DANFeReport.fpNFe.Ide.dEmi) +
        '; Destinat�rio: ' + DANFeReport.fpNFe.Dest.xNome +
        '; CNPJ: ' + DANFeReport.fpNFe.Dest.CNPJCPF +
        '; Valor total: ' + FormatFloatBr(DANFeReport.fpNFe.Total.ICMSTot.vNF));
    end;

    DANFeReport.fpAuxDiferencaPDF := 10;
    DANFeReport.RLNFe.Prepare;
    DANFeReport.RLPDFFilter1.FilterPages(DANFeReport.RLNFe.Pages);
  finally
    FreeAndNil(DANFeReport);
  end;
end;

procedure TfrlDANFeRL.FormCreate(Sender: TObject);
begin
  {$IfNDef FPC}
  Self.Scaled := False;
  {$EndIf}
  fpCorDestaqueProdutos := StringToColor('$00E5E5E5');

end;

procedure TfrlDANFeRL.ConfigurarVariavies(ATipoDANFE: TpcnTipoImpressao);
begin
  fpLinhasUtilizadas := 0;

  case ATipoDANFE of
    tiRetrato:
    begin
      fpLimiteLinhas := 10;
      fpLimiteCaracteresLinha := 81;
      fpLimiteCaracteresContinuacao := 129;
    end;

    tiPaisagem:
    begin
      fpLimiteLinhas := 12;
      fpLimiteCaracteresLinha := 142;
      fpLimiteCaracteresContinuacao := 204;
    end;
  end;
end;

procedure TfrlDANFeRL.InserirLinhas(sTexto: String; iLimCaracteres: Integer; rMemo: TRLMemo);
var
  iTotalLinhas, iUltimoEspacoLinha, iPrimeiraQuebraDeLinha, iPosAtual, iQuantCaracteres, i: Integer;
  sLinhaProvisoria, sLinha: String;
begin
  iPosAtual := 1;
  sTexto := StringReplace(sTexto, sLineBreak, ';', [rfReplaceAll]);
  iQuantCaracteres := Length(sTexto);
  if iQuantCaracteres <= fpLimiteLinhas then
    iTotalLinhas := 1
  else
  begin
    if (iQuantCaracteres mod iLimCaracteres) > 0 then
      iTotalLinhas := (iQuantCaracteres div iLimCaracteres) + 1
    else
      iTotalLinhas := iQuantCaracteres div iLimCaracteres;
  end;

  // Define o numero de linhas em complemento
  // iTotalLinhas + 20 = 30 linhas
  for i := 1 to (iTotalLinhas + 20) do
  begin
    sLinhaProvisoria := Copy(sTexto, iPosAtual, iLimCaracteres);
    iUltimoEspacoLinha := PosLast(' ', sLinhaProvisoria);
    iPrimeiraQuebraDeLinha := Pos(';', sLinhaProvisoria);

    if iUltimoEspacoLinha = 0 then
      iUltimoEspacoLinha := iQuantCaracteres;

    if (iPrimeiraQuebraDeLinha = 0) then
    begin
      if (iUltimoEspacoLinha = iLimCaracteres) or (iUltimoEspacoLinha = (iLimCaracteres + 1)) then
        sLinha := sLinhaProvisoria
      else
      begin
        if ((iQuantCaracteres - iPosAtual) > iLimCaracteres) then
          sLinha := Copy(sLinhaProvisoria, 1, iUltimoEspacoLinha)
        else
          sLinha := sLinhaProvisoria;
      end;

      iPosAtual := iPosAtual + Length(sLinha);
    end
    else
    begin
      sLinha := Copy(sLinhaProvisoria, 1, iPrimeiraQuebraDeLinha);
      iPosAtual := iPosAtual + (Length(sLinha));
    end;

    if NaoEstaVazio(sLinha) then
    begin
      if (LeftStr(sLinha, 1) = ' ') then
        sLinha := Copy(sLinha, 2, (Length(sLinha) - 1));

      rMemo.Lines.Add(sLinha);
    end;
  end;
end;

end.
