{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                        Juliomar Marchetti                    }
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

unit ACBrCTeDACTeRLClass;

interface

{$H+}

uses
  Forms, SysUtils, Classes, ACBrBase,
  pcnConversao, pcteCTe, ACBrCTeDACTEClass, RLTypes;

type

  { TACBrCTeDACTeRL }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrCTeDACTeRL = class(TACBrCTeDACTeClass)
  protected
     FPrintDialog: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ImprimirDACTe(CTe: TCTe = nil); override;
    procedure ImprimirDACTePDF(CTe: TCTe = nil); override;
    procedure ImprimirEVENTO(CTe: TCTe = nil); override;
    procedure ImprimirEVENTOPDF(CTe: TCTe = nil); override;
    procedure ImprimirINUTILIZACAO(CTe: TCTe = nil); override;
    procedure ImprimirINUTILIZACAOPDF(CTe: TCTe = nil); override;
  published
    property PrintDialog: Boolean read FPrintDialog write FPrintDialog;
  end;

implementation

uses
  StrUtils, Dialogs, ACBrUtil, ACBrCTe,
  ACBrCTeDAInutRL, ACBrCTeDAInutRLRetrato,
  ACBrCTeDACTeRL, ACBrCTeDACTeRLRetrato, ACBrCTeDACTeRLRetratoA5,
  ACBrCTeDAEventoRL, ACBrCTeDAEventoRLRetrato;

constructor TACBrCTeDACTeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := True;
end;

procedure TACBrCTeDACTeRL.ImprimirDACTe(CTe: TCTe = nil);
var
  i: integer;
  Conhecimentos: array of TCTe;
begin

  if CTe = nil then
  begin
    SetLength(Conhecimentos, TACBrCTe(ACBrCTe).Conhecimentos.Count);

    for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
    begin
      Conhecimentos[i] := TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe;
    end;
  end
  else
  begin
    SetLength(Conhecimentos, 1);
    Conhecimentos[0] := CTe;
  end;

  case TamanhoPapel of
    tpA5: TfrmDACTeRLRetratoA5.Imprimir(Self, Conhecimentos);
    else TfrmDACTeRLRetrato.Imprimir(Self, Conhecimentos);
  end;
end;

procedure TACBrCTeDACTeRL.ImprimirDACTePDF(CTe: TCTe = nil);
var
  i: integer;
begin

  FPArquivoPDF := '';
  if CTe = nil then
  begin
    for i := 0 to TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 do
    begin
      FPArquivoPDF := PathWithDelim(TACBrCTe(ACBrCTe).DACTE.PathPDF) +
          OnlyNumber(TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe.infCTe.ID) + '-cte.pdf';

      TACBrCTe(ACBrCTE).Conhecimentos.Items[i].NomeArqPDF := FPArquivoPDF;
//      if i < TACBrCTe(ACBrCTe).Conhecimentos.Count - 1 then
//        FPArquivoPDF := FPArquivoPDF + sLinebreak;

      case TamanhoPapel of
        tpA5: TfrmDACTeRLRetratoA5.SalvarPDF(Self, TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe, FPArquivoPDF);
        else TfrmDACTeRLRetrato.SalvarPDF(Self, TACBrCTe(ACBrCTe).Conhecimentos.Items[i].CTe, FPArquivoPDF);
      end;
    end;
  end
  else
  begin
    FPArquivoPDF := PathWithDelim(TACBrCTe(ACBrCTe).DACTE.PathPDF) +
                    OnlyNumber(CTe.infCTe.ID) + '-cte.pdf';

    case TamanhoPapel of
        tpA5: TfrmDACTeRLRetratoA5.SalvarPDF(Self, CTe, FPArquivoPDF);
        else TfrmDACTeRLRetrato.SalvarPDF(Self, CTe, FPArquivoPDF);
    end;
  end;
end;

procedure TACBrCTeDACTeRL.ImprimirEVENTO(CTe: TCTe);
var
  i, j: integer;
  Impresso: boolean;
begin
  if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      Impresso := False;
      for j := 0 to (TACBrCTe(ACBrCTe).Conhecimentos.Count - 1) do
      begin
        if OnlyNumber(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.Id) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        begin
          TfrmCTeDAEventoRLRetrato.Imprimir(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
            TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe);
          Impresso := True;
          Break;
        end;
      end;

      if Impresso = False then
      begin
        TfrmCTeDAEventoRLRetrato.Imprimir(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i]);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      TfrmCTeDAEventoRLRetrato.Imprimir(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i], CTe);
    end;
  end;
end;

procedure TACBrCTeDACTeRL.ImprimirEVENTOPDF(CTe: TCTe);
var
  i, j: integer;
  Impresso: boolean;
begin
  if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      FPArquivoPDF := TACBrCTe(ACBrCTe).DACTE.PathPDF +
               OnlyNumber(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.Id) + 
	       '-procEventoCTe.pdf';

      Impresso := False;
      for j := 0 to (TACBrCTe(ACBrCTe).Conhecimentos.Count - 1) do
      begin
        if OnlyNumber(TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe.infCTe.Id) = TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.chCTe then
        begin
          TfrmCTeDAEventoRLRetrato.SalvarPDF(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i],
            FPArquivoPDF, TACBrCTe(ACBrCTe).Conhecimentos.Items[j].CTe);
          Impresso := True;
          Break;
        end;
      end;

      if Impresso = False then
      begin
        TfrmCTeDAEventoRLRetrato.SalvarPDF(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i], FPArquivoPDF);
      end;
    end;
  end
  else
  begin
    for i := 0 to (TACBrCTe(ACBrCTe).EventoCTe.Evento.Count - 1) do
    begin
      FPArquivoPDF := TACBrCTe(ACBrCTe).DACTE.PathPDF +
               OnlyNumber(TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i].InfEvento.Id) +
               '-procEventoCTe.pdf';
      TfrmCTeDAEventoRLRetrato.SalvarPDF(Self, TACBrCTe(ACBrCTe).EventoCTe.Evento.Items[i], FPArquivoPDF, CTe);
    end;
  end;
end;

procedure TACBrCTeDACTeRL.ImprimirINUTILIZACAO(CTe: TCTe);
begin
  TfrmCTeDAInutRLRetrato.Imprimir(Self, TACBrCTe(ACBrCTe).InutCTe, CTe);
end;

procedure TACBrCTeDACTeRL.ImprimirINUTILIZACAOPDF(CTe: TCTe);
begin
  FPArquivoPDF := StringReplace(TACBrCTe(ACBrCTe).InutCTe.ID, 'ID', '', [rfIgnoreCase]);
  FPArquivoPDF := PathWithDelim(Self.PathPDF) + FPArquivoPDF + '-procInutCTe.pdf';
  TfrmCTeDAInutRLRetrato.SalvarPDF(Self, TACBrCTe(ACBrCTe).InutCTe, FPArquivoPDF, CTe);
end;

end.
