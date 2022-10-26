{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrPAFNFCe;

interface

uses
  Classes, SysUtils, ACBrBase,
  ACBrDFe, ACBrDFeConfiguracoes,
  ACBrPAFNFCe_MenuFiscal, ACBrPAFNFCe_Comum,
  ACBrUtil.FilesIO;

type

  { TConfiguracoesPAFNFCe }

  TConfiguracoesPAFNFCe = class(TConfiguracoes)
  public
  published
    property Geral;
    property Certificados;
  end;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrPAFNFCe = class(TACBrDFe)
  private
    FMenuFiscal: TACBrPAFNFCe_MenuFiscal;
    function GetConfiguracoes: TConfiguracoesPAFNFCe;
    procedure SetConfiguracoes(const Value: TConfiguracoesPAFNFCe);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property MenuFiscal: TACBrPAFNFCe_MenuFiscal read FMenuFiscal write FMenuFiscal;

  published
    property Configuracoes: TConfiguracoesPAFNFCe read GetConfiguracoes Write SetConfiguracoes;
  end;

implementation

{ TACBrPAFNFCe }

constructor TACBrPAFNFCe.Create(AOwner: TComponent);
begin
  inherited;
  FMenuFiscal := TACBrPAFNFCe_MenuFiscal.Create(Self);
end;

destructor TACBrPAFNFCe.Destroy;
begin
  FMenuFiscal.Free;
  inherited;
end;

function TACBrPAFNFCe.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesPAFNFCe.Create(Self);
end;

function TACBrPAFNFCe.GetConfiguracoes: TConfiguracoesPAFNFCe;
begin
  Result := TConfiguracoesPAFNFCe(FPConfiguracoes);
end;

procedure TACBrPAFNFCe.SetConfiguracoes(const Value: TConfiguracoesPAFNFCe);
begin
  FPConfiguracoes := Value;
end;

end.
