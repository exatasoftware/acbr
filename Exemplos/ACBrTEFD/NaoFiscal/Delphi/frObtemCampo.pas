{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
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

unit frObtemCampo; 

interface

uses
  Classes, SysUtils, 
   Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, ExtCtrls,
  ACBrTEFDCliSiTef;

type

{$R *.dfm}

{ TFormObtemCampo }

  TFormObtemCampo = class(TForm)
     BitBtn1 : TBitBtn;
     BitBtn2 : TBitBtn;
     BitBtn3: TBitBtn;
     Edit1 : TEdit;
     Panel1 : TPanel;
     procedure Edit1KeyPress(Sender : TObject; var Key : char);
     procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
     procedure FormCreate(Sender : TObject);
     procedure FormShow(Sender : TObject);
  private
    { private declarations }
  public
    { public declarations }
    TipoCampo : Integer;
    Operacao  : TACBrTEFDCliSiTefOperacaoCampo;
    TamanhoMinimo, TamanhoMaximo : Integer ;
  end; 

var
  FormObtemCampo : TFormObtemCampo; 

implementation

uses
  ACBrConsts;

{ TFormObtemCampo }

procedure TFormObtemCampo.FormCreate(Sender : TObject);
begin
  TamanhoMinimo := 0 ;
  TamanhoMaximo := 0 ;
  Operacao      := tcString;
  TipoCampo     := 0 ;
end;

procedure TFormObtemCampo.Edit1KeyPress(Sender : TObject; var Key : char);
begin
   if Key in [#13,#8] then exit ;  { Enter e BackSpace, OK }

   if Operacao in [tcDouble, tcCMC7] then
      if not (Key in ['0'..'9', DecimalSeparator]) then    { Apenas n�meros }
         Key := #0 ;

   if (TamanhoMaximo > 0) and (Length( Edit1.Text ) >= TamanhoMaximo) then
      Key := #0 ;
end;

procedure TFormObtemCampo.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
   if (ModalResult = mrOK) and (TamanhoMinimo > 0) then
   begin
      if Length( Edit1.Text ) < TamanhoMinimo then
      begin
         ShowMessage('O Tamanho M�nimo para este campo e: '+IntToStr(TamanhoMinimo) );
         CanClose := False ;
         Edit1.SetFocus;
      end;
   end;
end;

procedure TFormObtemCampo.FormShow(Sender : TObject);
begin
   if Operacao = tcDouble then
      Edit1.Text := '0,00' ;
   Edit1.SetFocus;
end;

end.

