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

unit ACBrGNReGuiaRL;

interface

uses
Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, pgnreConversao,pgnreGNRERetorno,pgnreGNRE, ACBrGNRE2,
  RLReport, RLFilters, RLPrinters, RLPDFFilter, RLConsts;

type

  { TfrlGuiaRL }

  TfrlGuiaRL = class(TForm)
  RLGNRe: TRLReport;
  RLPDFFilter1: TRLPDFFilter;
  private
    { Private declarations }
  protected
    FACBrGNRe: TACBrGNRE;
    FGNRe: TGNRERetorno;
    FEmail: string;
    FFax: string;
    FNumCopias: integer;
    FSistema: string;
    FSite: string;
    FUsuario: string;
    AfterPreview: boolean;
    ChangedPos: boolean;
    FSemValorFiscal: boolean;
    FMargemSuperior: double;
    FMargemInferior: double;
    FMargemEsquerda: double;
    FMargemDireita: double;
    FImpressora: string;
  public
    { Public declarations }
    class procedure Imprimir(AOwner: TComponent;
      AGNRe: TGNRERetorno;
      AEmail: string = '';
      AFax: string = '';
      ANumCopias: integer = 1;
      ASistema: string = '';
      ASite: string = '';
      AUsuario: string = '';
      APreview: boolean = True;
      AMargemSuperior: double = 0.8;
      AMargemInferior: double = 0.8;
      AMargemEsquerda: double = 0.6;
      AMargemDireita: double = 0.51;
      AImpressora: string = '';
      APrintDialog  : Boolean = True  );

    class procedure SavePDF(AOwner: TComponent;
      AFile: string;
      AGNRe: TGNRERetorno;
      AEmail: string = '';
      AFax: string = '';
      ANumCopias: integer = 1;
      ASistema: string = '';
      ASite: string = '';
      AUsuario: string = '';
      AMargemSuperior: double = 0.8;
      AMargemInferior: double = 0.8;
      AMargemEsquerda: double = 0.6;
      AMargemDireita: double = 0.51);
  end;

implementation

{$ifdef FPC}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

class procedure TfrlGuiaRL.Imprimir(AOwner: TComponent;
  AGNRe: TGNRERetorno;
  AEmail: string = '';
  AFax: string = '';
  ANumCopias: integer = 1;
  ASistema: string = '';
  ASite: string = '';
  AUsuario: string = '';
  APreview: boolean = True;
  AMargemSuperior: double = 0.8;
  AMargemInferior: double = 0.8;
  AMargemEsquerda: double = 0.6;
  AMargemDireita: double = 0.51;
  AImpressora: string = '';
  APrintDialog: Boolean = True);
begin
  with Create(AOwner) do
    try
      FGNRe := AGNRe;
      FEmail := AEmail;
      FNumCopias := ANumCopias;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;
      FImpressora := AImpressora;

      if FImpressora > '' then
        RLPrinter.PrinterName := FImpressora;

      if FNumCopias > 0 then
        RLPrinter.Copies := FNumCopias
      else
        RLPrinter.Copies := 1;

      RLGNRe.PrintDialog := APrintDialog;
      if APreview = True then
        RLGNRe.PreviewModal
      else
        RLGNRe.Print;
    finally
      Free;
    end;
end;

class procedure TfrlGuiaRL.SavePDF(AOwner: TComponent;
  AFile: string;
  AGNRe: TGNRERetorno;
  AEmail: string = '';
  AFax: string = '';
  ANumCopias: integer = 1;
  ASistema: string = '';
  ASite: string = '';
  AUsuario: string = '';
  AMargemSuperior: double = 0.8;
  AMargemInferior: double = 0.8;
  AMargemEsquerda: double = 0.6;
  AMargemDireita: double = 0.51);
begin
  with Create(AOwner) do
    try
      FGNRe := AGNRe;
      FEmail := AEmail;
      FFax := AFax;
      FNumCopias := ANumCopias;
      FSistema := ASistema;
      FSite := ASite;
      FUsuario := AUsuario;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;

      with RLPDFFilter1.DocumentInfo do
      begin
//        Title := ACBrStr('Guia - GNRe n� ') +  FGNRe.
        //KeyWords := ACBrStr('N�mero:') + FGNRe.c42_identificadorGuia;
          //ACBrStr('; Data de emiss�o: ') + FormatDateTime('dd/mm/yyyy', FGNRe.Ide.dhEmi) +'; CNPJ: ' + FGNRe.emit.CNPJ;
      end;

      RLPDFFilter1.FileName := AFile;
      RLGNRe.Prepare;
      RLPDFFilter1.FilterPages(RLGNRe.Pages);

//      RLGNRe.SaveToFile(AFile);
    finally
      Free;
    end;
end;

end.
