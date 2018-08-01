{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                        Juliomar Marchetti                     }
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

unit ACBrCTeDAEventoRL;

interface

uses
  SysUtils, Variants, Classes, StrUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows, Messages, {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts,
  {$IFDEF BORLAND} DBClient, {$ELSE} BufDataset, {$ENDIF} DB,
  RLBarcode, pcteCTe, ACBrCTe, pcnConversao,
  pcteEnvEventoCTe;

type

  { TfrmCTeDAEventoRL }

  TfrmCTeDAEventoRL = class(TForm)
    Datasource1: TDatasource;
    RLCTeEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  protected
    FACBrCTe: TACBrCTe;
    FCTe: TCTe;
    FEventoCTe: TInfEventoCollectionItem;
    FLogo: string;
    FNumCopias: integer;
    FSistema: string;
    FUsuario: string;
    FMostrarPreview: boolean;
    FMargemSuperior: double;
    FMargemInferior: double;
    FMargemEsquerda: double;
    FMargemDireita: double;
    FImpressora: string;

    cdsDocumentos: {$IFDEF BORLAND} TClientDataSet {$ELSE} TBufDataset{$ENDIF};
    procedure ConfigDataSet;

  public
    class procedure Imprimir(AEventoCTe: TInfEventoCollectionItem; ALogo: string = '';
      ANumCopias: integer = 1; ASistema: string = '';
      AUsuario: string = ''; AMostrarPreview: boolean = True;
      AMargemSuperior: double = 0.7; AMargemInferior: double = 0.7;
      AMargemEsquerda: double = 0.7; AMargemDireita: double = 0.7;
      AImpressora: string = ''; ACTe: TCTe = nil);

    class procedure SavePDF(AEventoCTe: TInfEventoCollectionItem; ALogo: string = '';
      AFile: string = ''; ASistema: string = '';
      AUsuario: string = ''; AMargemSuperior: double = 0.7;
      AMargemInferior: double = 0.7; AMargemEsquerda: double = 0.7;
      AMargemDireita: double = 0.7; ACTe: TCTe = nil);
  end;

implementation

uses
  MaskUtils, ACBrUtil;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

class procedure TfrmCTeDAEventoRL.Imprimir(AEventoCTe: TInfEventoCollectionItem;
  ALogo: string = '';
  ANumCopias: integer = 1;
  ASistema: string = '';
  AUsuario: string = '';
  AMostrarPreview: boolean = True;
  AMargemSuperior: double = 0.7;
  AMargemInferior: double = 0.7;
  AMargemEsquerda: double = 0.7;
  AMargemDireita: double = 0.7;
  AImpressora: string = '';
  ACTe: TCTe = nil);
begin
  with Create(nil) do
    try
      FEventoCTe := AEventoCTe;
      FLogo := ALogo;
      FNumCopias := ANumCopias;
      FSistema := ASistema;
      FUsuario := AUsuario;
      FMostrarPreview := AMostrarPreview;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;
      FImpressora := AImpressora;

      if ACTe <> nil then
        FCTe := ACTe;

      if FImpressora > '' then
        RLPrinter.PrinterName := FImpressora;

      if FNumCopias > 0 then
        RLPrinter.Copies := FNumCopias
      else
        RLPrinter.Copies := 1;

      if FMostrarPreview = True then
        RLCTeEvento.PreviewModal
      else
        RLCTeEvento.Print;
    finally
  //    RLCTeEvento.Free;
  //    RLCTeEvento := nil;
      Free;
    end;
end;

class procedure TfrmCTeDAEventoRL.SavePDF(AEventoCTe: TInfEventoCollectionItem;
  ALogo: string = ''; AFile: string = '';
  ASistema: string = '';
  AUsuario: string = '';
  AMargemSuperior: double = 0.7;
  AMargemInferior: double = 0.7;
  AMargemEsquerda: double = 0.7;
  AMargemDireita: double = 0.7;
  ACTe: TCTe = nil);
begin
  with Create(nil) do
    try
      FEventoCTe := AEventoCTe;
      FLogo := ALogo;
      FSistema := ASistema;
      FUsuario := AUsuario;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;

      if ACTe <> nil then
	  begin
        FCTe := ACTe;

        with RLPDFFilter1.DocumentInfo do
        begin
          Title := ACBrStr('DACTE - Conhecimento n� ') +
            FormatFloat('000,000,000', FCTe.Ide.nCT);
          KeyWords := ACBrStr('N�mero:') + FormatFloat('000,000,000', FCTe.Ide.nCT) +
            ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', FCTe.Ide.dhEmi) +
            ACBrStr('; Destinat�rio: ') + FCTe.Dest.xNome +
            '; CNPJ: ' + FCTe.Dest.CNPJCPF;
        end;
	  end;

      RLCTeEvento.SaveToFile(AFile);
    finally
      Free;
    end;
end;

procedure TfrmCTeDAEventoRL.FormDestroy(Sender: TObject);
begin
//  RLPrinter.Free;
  RLCTeEvento.Free;
  FreeAndNil(cdsDocumentos);
end;

procedure TfrmCTeDAEventoRL.FormCreate(Sender: TObject);
begin
  ConfigDataSet;
end;

procedure TfrmCTeDAEventoRL.ConfigDataSet;
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
      FieldDefs.Add('TIPO_1', ftString, 14);
      FieldDefs.Add('CNPJCPF_1', ftString, 70);
      FieldDefs.Add('DOCUMENTO_1', ftString, 33);
      FieldDefs.Add('TIPO_2', ftString, 14);
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

end.













