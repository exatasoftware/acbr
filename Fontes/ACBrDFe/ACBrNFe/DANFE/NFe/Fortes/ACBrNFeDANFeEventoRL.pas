{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
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
|* 14/03/2013: Peterson de Cerqueira Matos
|*  - In�cio da impress�o dos eventos em Fortes Report
******************************************************************************}
{$I ACBr.inc}
unit ACBrNFeDANFeEventoRL;

interface

uses
  SysUtils, Variants, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt,
  {$ELSE}
    Graphics, Controls, Forms, Dialogs, ExtCtrls,
  {$ENDIF}
  pcnEnvEventoNFe, pcnNFe, ACBrNFeDANFeRLClass,
  RLReport, RLPDFFilter, RLConsts, RLFilters, RLPrinters;

type
  TfrlDANFeEventoRL = class(TForm)
    RLEvento: TRLReport;
    RLPDFFilter1: TRLPDFFilter;
  private
    { Private declarations }
  protected
    FNFe: TNFe;
    FEventoNFe: TInfEventoCollectionItem;
    FLogo: String;
    FMarcaDagua: String;
    FNumCopias: Integer;
    FSsitema: String;
    FUsuario: String;
    FMostrarPreview: Boolean;
    FNomeFonte: TNomeFonte;
    FNegrito: Boolean;
    FMargemSuperior: Double;
    FMargemInferior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    FImpressora: String;

  public
    { Public declarations }
    class procedure Imprimir(ASender : TComponent; AEventoNFe: TInfEventoCollectionItem; ALogo: String = '';
                    AMarcaDagua: String = ''; ANumCopias: Integer = 1;
                    ASistema: String = ''; AUsuario: String = '';
                    AMostrarPreview: Boolean = True;
                    ANomeFonte: TNomeFonte = nfTimesNewRoman;
                    ANegrito: Boolean = True;
                    AMargemSuperior: Double = 0.7;
                    AMargemInferior: Double = 0.7;
                    AMargemEsquerda: Double = 0.7;
                    AMargemDireita: Double = 0.7;
                    AImpressora: String = '';
                    ANFe: TNFe = nil);

    class procedure SavePDF(ASender : TComponent; AEventoNFe: TInfEventoCollectionItem; ALogo: String = '';
                    AMarcaDagua: String = ''; AFile: String = '';
                    ASistema: String = ''; AUsuario: String = '';
                    ANomeFonte: TNomeFonte = nfTimesNewRoman;
                    ANegrito: Boolean = True;
                    AMargemSuperior: Double = 0.7;
                    AMargemInferior: Double = 0.7;
                    AMargemEsquerda: Double = 0.7;
                    AMargemDireita: Double = 0.7;
                    ANFe: TNFe = nil);
  end;

implementation


{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

class procedure TfrlDANFeEventoRL.Imprimir(ASender : TComponent; AEventoNFe: TInfEventoCollectionItem; ALogo: String = '';
                    AMarcaDagua: String = ''; ANumCopias: Integer = 1;
                    ASistema: String = ''; AUsuario: String = '';
                    AMostrarPreview: Boolean = True;
                    ANomeFonte: TNomeFonte = nfTimesNewRoman;
                    ANegrito: Boolean = True;
                    AMargemSuperior: Double = 0.7;
                    AMargemInferior: Double = 0.7;
                    AMargemEsquerda: Double = 0.7;
                    AMargemDireita: Double = 0.7;
                    AImpressora: String = '';
                    ANFe: TNFe = nil);

begin
  with Create ( ASender ) do
    try
      FEventoNFe := AEventoNFe;
      FLogo := ALogo;
      FMarcaDagua := AMarcaDagua;
      FNumCopias := ANumCopias;
      FSsitema := ASistema;
      FUsuario := AUsuario;
      FMostrarPreview := AMostrarPreview;
      FNomeFonte := ANomeFonte;
      FNegrito := ANegrito;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;
      FImpressora := AImpressora;

      if ANFe <> nil then
        FNFe := ANFe;

      if FImpressora > '' then
        RLPrinter.PrinterName := FImpressora;

      if FNumCopias > 0 then
        RLPrinter.Copies := FNumCopias
      else
        RLPrinter.Copies := 1;

      if FMostrarPreview = True then
        RLEvento.PreviewModal
      else
        RLEvento.Print;

    finally
      Free ;
    end ;
end;

class procedure TfrlDANFeEventoRL.SavePDF(ASender : TComponent; AEventoNFe: TInfEventoCollectionItem; ALogo: String = '';
                    AMarcaDagua: String = ''; AFile: String = '';
                    ASistema: String = ''; AUsuario: String = '';
                    ANomeFonte: TNomeFonte = nfTimesNewRoman;
                    ANegrito: Boolean = True;
                    AMargemSuperior: Double = 0.7;
                    AMargemInferior: Double = 0.7;
                    AMargemEsquerda: Double = 0.7;
                    AMargemDireita: Double = 0.7;
                    ANFe: TNFe = nil);

begin
  with Create ( ASender ) do
    try
      FEventoNFe := AEventoNFe;
      FLogo := ALogo;
      FMarcaDagua := AMarcaDagua;
      FSsitema := ASistema;
      FUsuario := AUsuario;
      FNomeFonte := ANomeFonte;
      FNegrito := ANegrito;
      FMargemSuperior := AMargemSuperior;
      FMargemInferior := AMargemInferior;
      FMargemEsquerda := AMargemEsquerda;
      FMargemDireita := AMargemDireita;

      if ANFe <> nil then
        FNFe := ANFe;

      RLEvento.SaveToFile(AFile);

    finally
      Free ;
    end ;
end;

end.
