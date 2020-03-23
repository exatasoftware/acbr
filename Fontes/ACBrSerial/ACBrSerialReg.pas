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
unit ACBrSerialReg;

interface
Uses Classes ,
    {$IFDEF FPC}
       LResources, LazarusPackageIntf, PropEdits, componenteditors
    {$ELSE}
       {$IFNDEF COMPILER6_UP}
          DsgnIntf
       {$ELSE}
          DesignIntf,
          DesignEditors
       {$ENDIF}
    {$ENDIF} ;

type
  { Editor de Proriedades de Componente de ACBrGAV -> StrComando }
  TACBrGAVStrComandoProperty = class( TStringProperty )
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc : TGetStrProc) ; override;
  end;

  { Editor de Componente do ECF para Mostrar TestarDialog }
  TACBrECFEditor = class( TComponentEditor )
  public
    procedure Edit; override;
  end;

procedure Register;

implementation
Uses ACBrUtil, ACBrReg,
     ACBrECF, ACBrGAV, ACBrCHQ, ACBrLCB, ACBrDIS, ACBrTER, ACBrBAL, ACBrETQ,
     ACBrRFD, ACBrSMS, ACBrPosPrinter, ACBrECFVirtualNaoFiscal,
     SysUtils;

{$IFNDEF FPC}
   {$R ACBrSerial.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrSerial', [TACBrECF, TACBrRFD, TACBrGAV, TACBrCHQ,
     TACBrLCB, TACBrDIS, TACBrTER, TACBrBAL, TACBrETQ, TACBrSMS, TACBrPosPrinter,
     TACBrECFVirtualNaoFiscal]);

  { Registrando os Editores de Propriedade }
  RegisterPropertyEditor(TypeInfo(String), TACBrGAV, 'StrComando',
     TACBrGAVStrComandoProperty);
  RegisterPropertyEditor(TypeInfo(String), TACBrCHQ, 'ArquivoBancosINI',
     TACBrFileINIProperty);
  RegisterPropertyEditor(TypeInfo(String), TACBrRFD, 'DirBase',
     TACBrDirProperty);

  {$IFNDEF COMPILER6_UP}
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrECF, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrGAV, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrCHQ, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrLCB, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrDIS, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrBAL, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrTER, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrETQ, 'Device',
    TClassProperty);
  RegisterPropertyEditor(TypeInfo(TACBrDevice), TACBrSMS, 'Device',
    TClassProperty);
  {$ENDIF}

  { Registrando os Editores de Componente }
  RegisterComponentEditor(TACBrECF, TACBrECFEditor);
end;


{ TACBrECFEditor }

procedure TACBrECFEditor.Edit;
begin
  with Component as TACBrECF do
     TestarDialog ;
end;

{ TACBrGAVStrComandoProperty }

procedure TACBrGAVStrComandoProperty.Edit;
begin
  inherited;

end;

function TACBrGAVStrComandoProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paValueList, paSortList];
end;

procedure TACBrGAVStrComandoProperty.GetValues(Proc: TGetStrProc);
begin
  Proc('#027,v,#140 | Bematech') ;
  Proc('#254 | Daruma') ;
  Proc('#027,p,0,#050,#200 | Mecaf') ;
  Proc('#027,p,#000,#050,#200 | Schalter') ;
  Proc('#027,#112,#048,#050 | Zantus') ;
end;

{$ifdef FPC}
initialization
   {$i ACBrSerial.lrs}
{$endif}

end.
