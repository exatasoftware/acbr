{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{ Biblioteca multiplataforma de componentes Delphi para                        }
{ Emiss�o de Nota Fiscal de Servi�o                                            }

{ Direitos Autorais Reservados (c) 2015 Italo Jurisato Junior                  }
{                                       Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

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

unit ACBrNFSeDANFSeRLClass;

interface

uses
  Forms, SysUtils, Classes, pnfsNFSe,
  ACBrBase, ACBrNFSeDANFSeClass;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFSeDANFSeRL = class(TACBrNFSeDANFSeClass)
  private

  protected
    FPrintDialog: boolean;
	FDetalharServico : Boolean;
	
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); override;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); override;
  published
    property PrintDialog: boolean read FPrintDialog write FPrintDialog;
    property DetalharServico: Boolean read FDetalharServico write FDetalharServico default False;
	
  end;

implementation

uses
  Dialogs, ACBrUtil, ACBrNFSe, ACBrNFSeDANFSeRLRetrato;

constructor TACBrNFSeDANFSeRL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPrintDialog := True;
  FDetalharServico := False;
end;

destructor TACBrNFSeDANFSeRL.Destroy;
begin
  inherited Destroy;
end;

procedure TACBrNFSeDANFSeRL.ImprimirDANFSe(NFSe: TNFSe = nil);
var
  i: Integer;
  Notas: array of TNFSe;
begin
//  TfrlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.WebServices.QuebradeLinha);
  TfrlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.Geral.ConfigGeral.QuebradeLinha);
  if (NFSe = nil) then
  begin
    SetLength(Notas, TACBrNFSe(ACBrNFSe).NotasFiscais.Count);

    for i := 0 to (TACBrNFSe(ACBrNFSe).NotasFiscais.Count - 1) do
      Notas[i] := TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe;
  end
  else
  begin
    SetLength(Notas, 1);
    Notas[0] := NFSe;
  end;

  TfrlDANFSeRLRetrato.Imprimir(Self, Notas);
end;

procedure TACBrNFSeDANFSeRL.ImprimirDANFSePDF(NFSe: TNFSe = nil);
Var
  i: integer;
begin
  TfrlDANFSeRLRetrato.QuebradeLinha(TACBrNFSe(ACBrNFSe).Configuracoes.WebServices.QuebradeLinha);
  if NFSe = nil then
  begin
    for i := 0 to TACBrNFSe(ACBrNFSe).NotasFiscais.Count - 1 do
    begin
      FPArquivoPDF := PathWithDelim(Self.PathPDF) +
        TACBrNFSe(ACBrNFSe).NumID[TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe] + '-nfse.pdf';

      TfrlDANFSeRLRetrato.SalvarPDF(Self, TACBrNFSe(ACBrNFSe).NotasFiscais.Items[i].NFSe, FPArquivoPDF);
    end;
  end
  else
  begin
      FPArquivoPDF := PathWithDelim(Self.PathPDF) + TACBrNFSe(ACBrNFSe).NumID[NFSe] + '-nfse.pdf';
      TfrlDANFSeRLRetrato.SalvarPDF(Self, NFSe, FPArquivoPDF);
  end;
end;

end.
