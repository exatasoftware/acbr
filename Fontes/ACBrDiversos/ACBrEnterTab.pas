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

unit ACBrEnterTab;

interface

uses
 ACBrBase,
 Classes,
 {$IF DEFINED(VisualCLX)}
  QControls, QForms, QStdCtrls,
 {$ELSEIF DEFINED(FMX)}
  FMX.Controls, FMX.Forms, FMX.StdCtrls, FMX.Types, System.UITypes,
 {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
  Vcl.Controls, Vcl.Forms, Vcl.StdCtrls,
 {$ELSE}
  Controls, Forms, StdCtrls,
 {$IFEND}
 SysUtils;


type
  THackForm = class(TForm);
  {$IfDef FMX}
   THackButtomControl = class(TCustomButton);
  {$Else}
   THackButtomControl = class(TButtonControl);
  {$EndIf}

  { TACBrEnterTab }

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllDesktopPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrEnterTab = class ( TACBrComponent )
  private
    FAllowDefault: Boolean;
    FEnterAsTab: Boolean;
    FFormOwner: TForm;
    {$IfDef FMX}
     FOldOnKeyDown: TKeyEvent;
    {$Else}
     FOldKeyPreview : Boolean;
     FOldOnKeyPress : TKeyPressEvent ;
     FUseScreenControl: Boolean;
    {$EndIf}
    procedure SetEnterAsTab(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override ;
    destructor Destroy ; override ;

    {$IfDef FMX}
     procedure DoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
     property EnterAsTab: Boolean read FEnterAsTab write SetEnterAsTab default false ;
    {$Else}
     procedure DoEnterAsTab(AForm : TObject; var Key: Char);
    {$EndIf}
  published
    property AllowDefault: Boolean read FAllowDefault write FAllowDefault default true ;
    {$IfNDef FMX}
     property EnterAsTab: Boolean read FEnterAsTab write SetEnterAsTab default false ;
     property UseScreenControl: Boolean read FUseScreenControl write FUseScreenControl
        default {$IfDef FPC}True{$Else}False{$EndIf};
    {$EndIf}
  end;

implementation

uses
  ACBrUtil;

{ TACBrEnterTab }
constructor TACBrEnterTab.Create(AOwner: TComponent);
begin
  if not Assigned(AOwner) then
    raise Exception.Create(ACBrStr('TACBrEnterTab.Owner n�o informado'));

  inherited Create(AOwner);

  FFormOwner := nil;
  FEnterAsTab := false;
  FAllowDefault := True;
  {$IfDef FMX}
   FOldOnKeyDown := nil;
  {$Else}
   FOldKeyPreview := False;
   FOldOnKeyPress := nil;
   FUseScreenControl := {$IfDef FPC}True{$Else}False{$EndIf};
  {$EndIf}
end;

destructor TACBrEnterTab.Destroy;
begin
  { Restaurando estado das propriedades de Form modificadas }
  if Assigned(FFormOwner) then
  begin
    if not (csFreeNotification in FFormOwner.ComponentState) then
    begin
      with FFormOwner do
      begin
        {$IfDef FMX}
         OnKeyDown := FOldOnKeyDown;
        {$Else}
         KeyPreview := FOldKeyPreview;
         OnKeyPress := FOldOnKeyPress;
        {$EndIf}
      end ;
    end;
  end;

  inherited Destroy ;
end;

{$IfDef FMX}
 procedure TACBrEnterTab.DoKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
 begin
   try
     If Key = vkReturn Then
     begin
       if (FFormOwner.ActiveControl is TCustomButton) and FAllowDefault then
         THackButtomControl( FFormOwner.ActiveControl ).Click
       else
       begin
         Key := vkTab;
         FFormOwner.KeyDown(Key, KeyChar, Shift);
       end;
     end ;
   finally
     if Assigned(FOldOnKeyDown) then
       FOldOnKeyDown(Sender, Key, KeyChar, Shift);

     Key := 0;
   end;
 end;
{$Else}
 procedure TACBrEnterTab.DoEnterAsTab(AForm: TObject; var Key: Char);
 Var
   DoClick : Boolean ;
 begin
   try
     if not (AForm is TForm) then
       exit ;

     If Key = #13 Then
     begin
       if (TForm(AForm).ActiveControl is TButtonControl) and FAllowDefault then
       begin
          {$IFDEF VisualCLX}
           TButtonControl( TForm(AForm).ActiveControl ).AnimateClick;
          {$ELSE}
            DoClick := True;
           {$IFDEF FPC}
            {$IFNDEF Linux}
             DoClick := False;  // Para evitar Click ocorre 2x em FPC com Win32
            {$ENDIF}
           {$ENDIF}
           if DoClick then
             THackButtomControl( TForm(AForm).ActiveControl ).Click;
          {$ENDIF}
          Exit;
       end ;

       if FUseScreenControl then
         THackForm( AForm ).SelectNext( Screen.ActiveControl, True, True )
       else
         THackForm( AForm ).SelectNext( TForm(AForm).ActiveControl, True, True );
     end ;
   finally
     if Assigned( FOldOnKeyPress ) then
       FOldOnKeyPress( AForm, Key );

     If Key = #13 Then
       Key := #0;
   end;
 end;
{$EndIf}

procedure TACBrEnterTab.SetEnterAsTab(const Value: Boolean);
var
  RealOwner: TComponent;
begin
  if Value = FEnterAsTab then
    Exit;

  if Value and (not Assigned(FFormOwner)) then
  begin
    RealOwner := Owner;
    while Assigned(RealOwner) and (not (RealOwner is TCustomForm)) do
      RealOwner := RealOwner.Owner;

    if (not Assigned(RealOwner)) then
      raise Exception.Create(ACBrStr('N�o foi poss�vel encontrar o Form Pai para TACBrEnterTab'));

    FFormOwner := TForm(RealOwner);
    { Salvando estado das Propriedades do Form, que ser�o modificadas }
    with FFormOwner do
    begin
      {$IfDef FMX}
       FOldOnKeyDown := OnKeyDown;
      {$Else}
       FOldKeyPreview := KeyPreview ;
       FOldOnKeyPress := OnKeyPress ;
      {$EndIf}
    end ;
  end;

  if not (csDesigning in ComponentState) then
  begin
    with TForm(Owner) do
    begin
      if Value then
      begin
        {$IfDef FMX}
         OnKeyDown := DoKeyDown;
        {$Else}
         KeyPreview := true;
         OnKeyPress := DoEnterAsTab;
        {$EndIf}
      end
      else
      begin
        {$IfDef FMX}
         OnKeyDown := FOldOnKeyDown;
        {$Else}
         KeyPreview := FOldKeyPreview;
         OnKeyPress := FOldOnKeyPress;
        {$EndIf}
      end;
    end;
  end;

  FEnterAsTab := Value;
end;

end.
