{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2019 Daniel Simoes de Almeida               }
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

unit ACBrEDI;

{$I ACBr.inc}

interface

uses SysUtils, Classes, Contnrs, ACBrEDIConhectos, ACBrEDIOcorrencia,
     ACBrEDICobranca, ACBrBase ;

type

  { TACBrEDI }
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}

  TACBrEDI = class(TComponent)
  private
    FConEmb: TACBrEDIConhectos ;
    FOcor  : TACBrEDIOcorrencia ;
    FDocCob: TACBrEDICobranca ;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ConEmb: TACBrEDIConhectos  read FConEmb write FConEmb ;
    property DocCob: TACBrEDICobranca   read FDocCob write FDocCob ;
    property Ocor  : TACBrEDIOcorrencia read FOcor   write FOcor   ;
  end;

procedure Register;

implementation

{$IFNDEF FPC}
 {$R ACBrEDI.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrEDI', [TACBrEDI]);
end;

{ TACBrEDI }

constructor TACBrEDI.Create(AOwner: TComponent);
begin
  inherited Create(AOwner) ;
  FConEmb := TACBrEDIConhectos.Create(Self);
  FDocCob := TACBrEDICobranca.Create(Self);
  FOcor   := TACBrEDIOcorrencia.Create(Self);
end;

destructor TACBrEDI.Destroy;
begin
  FConEmb.Free ;
  FDocCob.Free ;
  FOcor.Free ;
  inherited;
end;

end.
