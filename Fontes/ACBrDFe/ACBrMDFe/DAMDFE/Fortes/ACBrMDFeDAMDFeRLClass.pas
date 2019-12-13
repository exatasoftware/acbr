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

unit ACBrMDFeDAMDFeRLClass;

interface

uses
  Forms, SysUtils, Classes,
  ACBrBase, ACBrMDFeDAMDFeClass, pmdfeMDFe;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrMDFeDAMDFeRL = class(TACBrMDFeDAMDFeClass)
  private
  protected
    FPrintDialog: Boolean;  
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDAMDFe(MDFe: TMDFe = nil); override;
    procedure ImprimirDAMDFePDF(MDFe: TMDFe = nil); override;
    procedure ImprimirEVENTO(MDFe: TMDFe = nil); override;
    procedure ImprimirEVENTOPDF(MDFe: TMDFe = nil); override;
  published
    property PrintDialog: Boolean read FPrintDialog write FPrintDialog;
end;

implementation

uses
  Dialogs, ACBrUtil, ACBrMDFe,
  ACBrMDFeDAMDFeRLRetrato, ACBrMDFeDAEventoRL, ACBrMDFeDAEventoRLRetrato;

constructor TACBrMDFeDAMDFeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := True;
end;

destructor TACBrMDFeDAMDFeRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirDAMDFE(MDFe: TMDFe = nil);
var
  i: Integer;
  Manifestos: array of TMDFe;
begin
  if (MDFe = nil) then
  begin
    SetLength(Manifestos, TACBrMDFe(ACBrMDFe).Manifestos.Count);

    for i := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      Manifestos[i] := TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe;
  end
  else
  begin
    SetLength(Manifestos, 1);
    Manifestos[0] := MDFe;
  end;

  TfrlDAMDFeRLRetrato.Imprimir(Self, Manifestos);
end;

procedure TACBrMDFeDAMDFeRL.ImprimirDAMDFEPDF(MDFe: TMDFe = nil);
var
  i: integer;
begin
  FPArquivoPDF := '';
  if MDFe = nil then
  begin
    for i := 0 to TACBrMDFe(ACBrMDFe).Manifestos.Count - 1 do
    begin
      FPArquivoPDF := PathWithDelim(Self.PathPDF) +
        OnlyNumber(TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe.infMDFe.ID)
        + '-mdfe.pdf';
      TfrlDAMDFeRLRetrato.SalvarPDF(Self, TACBrMDFe(ACBrMDFe).Manifestos.Items[i].MDFe, FPArquivoPDF);
    end;
  end
  else
  begin
     FPArquivoPDF := PathWithDelim(Self.PathPDF) + OnlyNumber(MDFe.infMDFe.ID) + '-mdfe.pdf';
     TfrlDAMDFeRLRetrato.SalvarPDF(Self, MDFe, FPArquivoPDF);
  end;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirEVENTO(MDFe: TMDFe);
var
  i, j: integer;
  Impresso: boolean;
begin
  if MDFe = nil then
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
      Impresso := False;
      for j := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      begin
        if OnlyNumber(TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe.infMDFe.ID) =
        TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i].InfEvento.chMDFe then
        begin
          TfrmMDFeDAEventoRLRetrato.Imprimir(Self,
              TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i],
              TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe);
          Impresso := True;
          Break;
        end;
      end;

      if Impresso = False then
      begin
        TfrmMDFeDAEventoRLRetrato.Imprimir(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i]);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
      TfrmMDFeDAEventoRLRetrato.Imprimir(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i], MDFe);
    end;
  end;
end;

procedure TACBrMDFeDAMDFeRL.ImprimirEVENTOPDF(MDFe: TMDFe);
var
  i, j: integer;
  Impresso: boolean;
begin
  FPArquivoPDF := '';
  if TACBrMDFe(ACBrMDFe).Manifestos.Count > 0 then
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
      FPArquivoPDF := TACBrMDFe(ACBrMDFe).DAMDFe.PathPDF +
        OnlyNumber(TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i].InfEvento.ID) +
        '-procEventoMDFe.pdf';
      Impresso := False;

      for j := 0 to (TACBrMDFe(ACBrMDFe).Manifestos.Count - 1) do
      begin
        if OnlyNumber(TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe.infMDFe.ID) =
        TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i].InfEvento.chMDFe then
        begin
            TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i],
              FPArquivoPDF, TACBrMDFe(ACBrMDFe).Manifestos.Items[j].MDFe);
            Impresso := True;
            Break;
        end;
      end;

      if Impresso = False then
      begin
        TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i], FPArquivoPDF);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Count - 1) do
    begin
        FPArquivoPDF := TACBrMDFe(ACBrMDFe).DAMDFe.PathPDF +
                 OnlyNumber(TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i].InfEvento.ID) +
                 '-procEventoMDFe.pdf';

        TfrmMDFeDAEventoRLRetrato.SalvarPDF(Self, TACBrMDFe(ACBrMDFe).EventoMDFe.Evento.Items[i], FPArquivoPDF, MDFe);
    end;
  end;
end;

end.
