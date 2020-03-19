{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Alexandre Rocha Lima e Marcondes                }
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

unit ACBrCalculadora;

interface

uses
 ACBrBase,
 Classes, SysUtils,
 {$IFDEF VisualCLX}
   QControls, QGraphics, QForms
 {$ELSE}
   Controls,  Graphics,  Forms
 {$ENDIF};

type
  TACBrCalculadoraDisplayChange = procedure(Sender: TObject; Valor : Double) of object;

  { TACBrCalculadora }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrCalculadora = class ( TACBrComponent )
  private
    FBorderStyle : TFormBorderStyle;
    FTitulo: String ;
    FValor : Double ;
    FValorInicio: Double;
    FTexto : String ;
    FPrecisao: Integer;
    FSaiComEsc: Boolean;
    FCalcLeft: Integer;
    FCalcTop: Integer;
    FCor: TColor;
    FCorForm: TColor;
    FCentraliza: Boolean;
    FOnCalcKey: TKeyPressEvent;
    FOnDisplayChange: TACBrCalculadoraDisplayChange;
    procedure SetValor(AValue: Double);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    property Texto  : String read FTexto ;
  published
  { TODO : Adicionar evento OnMudaValor }

     property Valor  : Double read FValor  write SetValor stored false ;
     property Titulo : String read FTitulo write FTitulo ;
     property Precisao : Integer read FPrecisao write FPrecisao default 4 ;
     property SaiComEsc : Boolean read FSaiComEsc write FSaiComEsc
                       default true ;
     property Centraliza : Boolean read FCentraliza write FCentraliza
                       default false ;
     property CalcTop  : Integer read FCalcTop write FCalcTop default 0;
     property CalcLeft : Integer read FCalcLeft write FCalcLeft default 0;
     property CorDisplay : TColor read FCor write FCor default clLime ;
     property CorForm : TColor read FCorForm write FCorForm
        default clBtnFace ;
     property OnCalcKey : TKeyPressEvent read FOnCalcKey write FOnCalcKey;
     property OnDisplayChange: TACBrCalculadoraDisplayChange
                      read FOnDisplayChange write FOnDisplayChange;
     property BorderStyle : TFormBorderStyle read FBorderStyle write FBorderStyle ;
  end;

implementation
Uses {$IFDEF VisualCLX}
       QCalculadora
     {$ELSE}
       {$IFDEF FPC}
         LCalculadora
       {$ELSE}
         Calculadora
       {$ENDIF}
     {$ENDIF};

{ TACBrCalculadora }

procedure TACBrCalculadora.SetValor(AValue: Double);
begin
  if FValor = AValue then Exit;
  FValor := AValue;
  FValorInicio := AValue;
end;

constructor TACBrCalculadora.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );
  FTitulo     := 'ACBr Calculadora' ;
  FPrecisao   := 4 ;
  FSaiComEsc  := true ;
  FCor        := clLime ;
  FCentraliza := false ;
  FCorForm    := clBtnFace ;
  {$IFDEF VisualCLX}
   FBorderStyle:= fbsDialog;
  {$ELSE}
   FBorderStyle:= bsDialog;
  {$ENDIF}
end;

function TACBrCalculadora.Execute: Boolean;
var
  FrCalculadora : TFrCalculadora ;
begin
  //Result := False;
  FrCalculadora := TFrCalculadora.Create( Application ) ;
  try
     if FCentraliza then
        FrCalculadora.Position := poMainFormCenter
     else
        if (FCalcTop = 0) and (FCalcLeft = 0) then
           FrCalculadora.Position := poDefault
        else
         begin
           FrCalculadora.Top  := FCalcTop  ;
           FrCalculadora.Left := FCalcLeft ;
         end ;

     FrCalculadora.BorderStyle := FBorderStyle ;
     FrCalculadora.Caption := FTitulo ;
     FrCalculadora.Color := FCorForm;
     FrCalculadora.pValor.Font.Color := FCor ;
     FrCalculadora.ValorDisplay := FloatToStr( FValorInicio ) ;
     FrCalculadora.pSaiComEsc := FSaiComEsc ;
     FrCalculadora.pPrecisao := FPrecisao ;
     FrCalculadora.pOnCalKey := FOnCalcKey ;
     FrCalculadora.pOnDisplayChange := FOnDisplayChange ;
     FValorInicio := 0;

     Result := ( FrCalculadora.ShowModal = mrOk ) ;

     FTexto := FrCalculadora.ValorDisplay ;
     FValor := StrToFloat( FTexto ) ;
  finally
     FCalcTop  := FrCalculadora.Top  ;
     FCalcLeft := FrCalculadora.Left ;
     FrCalculadora.Free;
  end;
end;

end.
