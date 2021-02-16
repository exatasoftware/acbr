{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit ACBrPagForReg;

interface

uses
  SysUtils, Classes,
  {$IFDEF VisualCLX} QDialogs {$ELSE} Dialogs, FileCtrl {$ENDIF},
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
  { Editor de Proriedades de Componente para mostrar o AboutACBr }
  TACBrAboutDialogProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
  end;

  { Editor de Proriedades de Componente para chamar OpenDialog }
  TACBrPagForDirProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;

procedure Register;

implementation

uses
 ACBrPagFor, ACBrPagForConfiguracoes;

{$IFNDEF FPC}
   {$R ACBrPagFor.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBr', [TACBrPagFor]);

//  RegisterPropertyEditor(TypeInfo(TACBrPagForAboutInfo), nil, 'AboutACBrPagFor',
//     TACBrAboutDialogProperty);

  RegisterPropertyEditor(TypeInfo(TConfiguracoes), TACBrPagFor, 'Configuracoes',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(TGeralConf), TConfiguracoes, 'Geral',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(String), TGeralConf, 'PathSalvar',
     TACBrPagForDirProperty);

  RegisterPropertyEditor(TypeInfo(TArquivosConf), TConfiguracoes, 'Arquivos',
    TClassProperty);

  RegisterPropertyEditor(TypeInfo(String), TArquivosConf, 'PathSalvar',
     TACBrPagForDirProperty);

end;

{ TACBrAboutDialogProperty }

procedure TACBrAboutDialogProperty.Edit;
begin
//  ACBrAboutDialog ;
end;

function TACBrAboutDialogProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

function TACBrAboutDialogProperty.GetValue: String;
begin
//  Result := 'Vers�o: ' + ACBRPagFor_VERSAO;
end;

{ TACBrPagForeDirProperty }

procedure TACBrPagForDirProperty.Edit;
Var
{$IFNDEF VisualCLX} Dir: String; {$ELSE} Dir: WideString; {$ENDIF}
begin
  {$IFNDEF VisualCLX}
  Dir := GetValue;
  if SelectDirectory(Dir, [], 0) then
     SetValue(Dir);
  {$ELSE}
  Dir := '';
  if SelectDirectory('Selecione o Diret�rio', '', Dir) then
     SetValue(Dir);
  {$ENDIF}
end;

function TACBrPagForDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

initialization
{$IFDEF FPC}
   {$i ACBrPagFor.lrs}
{$ENDIF}

end.
