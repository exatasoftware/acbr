{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andr� Ferreira de Moraes                        }
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
{ This file uses: DelphiZXIngQRCode Copyright 2008 ZXing authors,              }
{   port to Delphi, by Debenu Pty Ltd                                          }
{   URL: http://www.debenu.com/open-sourc1e/delphizxingqrcode                  }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrSATExtratoReportClass;

interface

uses 
  Classes, SysUtils,
  ACBrBase, ACBrSATExtratoClass,
  pcnConversao;

type

  { TACBrSATExtratoReportClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSATExtratoReportClass = class( TACBrSATExtratoClass )
  private
    fLarguraBobina: Integer;
    fEspacoFinal: Integer;
    fLogoWidth: Integer;
    fLogoHeigth: Integer;
    fLogoStreatch: Boolean;
    fLogoAutoSize: Boolean;
    fLogoCenter: Boolean;
    fLogoVisible: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  published
    property LarguraBobina : Integer read fLarguraBobina  write fLarguraBobina default 302;
    property EspacoFinal   : Integer read fEspacoFinal write fEspacoFinal default 0;
    property LogoWidth     : Integer read fLogoWidth write fLogoWidth default 77;
    property LogoHeigth    : Integer read fLogoHeigth write fLogoHeigth default 50;
    property LogoStretch   : Boolean read fLogoStreatch write fLogoStreatch default False;
    property LogoAutoSize  : Boolean read fLogoAutoSize write fLogoAutoSize default True;
    property LogoCenter    : Boolean read fLogoCenter write fLogoCenter default True;
    property LogoVisible   : Boolean read fLogoVisible write fLogoVisible default True;
  end ;

implementation

{ TACBrSATExtratoReportClass }
constructor TACBrSATExtratoReportClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  fLarguraBobina := 302;
  fEspacoFinal   := 0;
  fLogoWidth     := 77;
  fLogoHeigth    := 50;
  fLogoStreatch  := False;
  fLogoAutoSize  := True;
  fLogoCenter    := True;
  fLogoVisible   := True;
  MargemInferior := 4;
  MargemSuperior := 2;
  MargemEsquerda := 2;
  MargemDireita := 2;
end;

destructor TACBrSATExtratoReportClass.Destroy;
begin
  inherited Destroy ;
end;

end.
