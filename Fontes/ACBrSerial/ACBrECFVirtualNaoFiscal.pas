{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
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
{ http://www.opensource.org/licenses/gpl-license.php                           }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrECFVirtualNaoFiscal ;

interface
uses ACBrECFVirtualPrinter, ACBrECFClass, ACBrUtil,
     Classes, SysUtils
     {$IFNDEF NOGUI}
       {$IF DEFINED(VisualCLX)}
          ,QControls, QForms, QDialogs
       {$ELSEIF DEFINED(FMX)}
          ,FMX.Controls, FMX.Forms, FMX.Dialogs, System.UITypes
       {$ELSE}
          ,Controls, Forms, Dialogs
          {$IFDEF DELPHIXE2_UP}
           , System.UITypes
          {$ENDIF}
       {$IFEND}
     {$ENDIF} ;

const
  ACBrECFVirtualNaoFiscal_VERSAO = '0.1.0a';

type

{ TACBrECFVirtualNaoFiscal }
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}	
TACBrECFVirtualNaoFiscal = class( TACBrECFVirtualPrinter )
  private
    function GetExibeAvisoLegal: Boolean;
    procedure SetExibeAvisoLegal(AValue: Boolean);
  protected
    procedure CreateVirtualClass ; override ;
  published
    property ExibeAvisoLegal: Boolean read GetExibeAvisoLegal
      write SetExibeAvisoLegal;
end ;

{ TACBrECFVirtualNaoFiscalClass }

TACBrECFVirtualNaoFiscalClass = class( TACBrECFVirtualPrinterClass )
  private
    fsExibeAvisoLegal: Boolean;
    Procedure MostraAvisoLegal ;
  protected
    function GetSubModeloECF: String ; override ;
    function GetNumVersao: String; override ;
    procedure AtivarVirtual ; override;
 public
   Constructor Create( AECFVirtualNaoFiscal : TACBrECFVirtualNaoFiscal ); overload;

   property ExibeAvisoLegal: Boolean read fsExibeAvisoLegal write fsExibeAvisoLegal;
 end ;

implementation

{ TACBrECFVirtualNaoFiscal }

procedure TACBrECFVirtualNaoFiscal.CreateVirtualClass;
begin
  fpECFVirtualClass := TACBrECFVirtualNaoFiscalClass.create( self );
end;

function TACBrECFVirtualNaoFiscal.GetExibeAvisoLegal: Boolean;
begin
  Result := TACBrECFVirtualNaoFiscalClass( fpECFVirtualClass ).ExibeAvisoLegal;
end;

procedure TACBrECFVirtualNaoFiscal.SetExibeAvisoLegal(AValue: Boolean);
begin
  TACBrECFVirtualNaoFiscalClass( fpECFVirtualClass ).ExibeAvisoLegal := AValue;
end;

{ TACBrECFVirtualNaoFiscalClass }

constructor TACBrECFVirtualNaoFiscalClass.Create(AECFVirtualNaoFiscal: TACBrECFVirtualNaoFiscal);
begin
  inherited create( AECFVirtualNaoFiscal ) ;

  fsExibeAvisoLegal := True;
end;

function TACBrECFVirtualNaoFiscalClass.GetSubModeloECF: String;
begin
  Result := 'VirtualNaoFiscal' ;
end;

function TACBrECFVirtualNaoFiscalClass.GetNumVersao: String ;
begin
  Result := ACBrECFVirtualNaoFiscal_VERSAO ;
end;

procedure TACBrECFVirtualNaoFiscalClass.AtivarVirtual;
begin
  if fsExibeAvisoLegal then
    MostraAvisoLegal ;

  inherited AtivarVirtual;
end;

procedure TACBrECFVirtualNaoFiscalClass.MostraAvisoLegal ;
begin
  {$IFNDEF NOGUI}
   if MessageDlg(ACBrStr( 'Este Emulador destina-se EXCLUSIVAMENTE para auxiliar no '+
                 'desenvolvimento de aplicativos para as impressoras fiscais. '+
                 sLineBreak + sLineBreak +
                 'Usar o emulador para fins comerciais sem a devida impress�o '+
                 'do Cupom Fiscal ou Nota Fiscal pode caracterizar crime de '+
                 'Sonega��o Fiscal.' + sLineBreak + sLineBreak +
                 'Continua com o uso do Emulador ?' )
                  ,{$IFDEF FMX}TMsgDlgType.{$ENDIF} mtWarning,mbYesNoCancel,0) <> mrYes then
     raise EACBrECFERRO.Create( ACBrStr('Uso indevido do emulador'));
  {$ENDIF}
end ;

end.

