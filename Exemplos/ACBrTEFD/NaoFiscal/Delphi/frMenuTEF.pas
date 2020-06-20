{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit frMenuTEF; 

interface

uses
  Classes, SysUtils,
  Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons;

type

{$R *.dfm}

  { TFormMenuTEF }

  TFormMenuTEF = class(TForm)
     btOK : TBitBtn;
     btCancel : TBitBtn;
     btVoltar: TBitBtn;
     lbOpcoes : TListBox;
     mOpcao : TMemo ;
     pTitulo : TPanel;
     Panel2 : TPanel;
     Splitter1 : TSplitter ;
     procedure FormShow(Sender: TObject);
     procedure lbOpcoesClick(Sender: TObject);
     procedure lbOpcoesKeyPress(Sender: TObject; var Key: char);
  private
    { private declarations }
    FUsaTeclasDeAtalho: Boolean;
    FNumeroPressionado: Boolean;
    function GetItemSelecionado: Integer;
    function GetOpcoes: TStrings;
    function GetTitulo: String;
    procedure SetItemSelecionado(AValue: Integer);
    procedure SetOpcoes(AValue: TStrings);
    procedure SetTitulo(AValue: String);
  public
    { public declarations }
    property Titulo: String read GetTitulo write SetTitulo;
    property Opcoes: TStrings read GetOpcoes write SetOpcoes;
    property ItemSelecionado: Integer read GetItemSelecionado write SetItemSelecionado;
    property UsaTeclasDeAtalho: Boolean read FUsaTeclasDeAtalho write FUsaTeclasDeAtalho;
  end; 

implementation

uses
  ACBrUtil;

{ TFormMenuTEF }

procedure TFormMenuTEF.FormShow(Sender: TObject);
begin
   if mOpcao.Lines.Count > 0 then
   begin
     mOpcao.Width   := Trunc(Width/2)-10;
     mOpcao.Visible := True ;
     Splitter1.Visible := True ;
   end ;

   lbOpcoes.SetFocus;
   if lbOpcoes.Items.Count > 0 then
      lbOpcoes.ItemIndex := 0 ;

   FNumeroPressionado := False;
end;

procedure TFormMenuTEF.lbOpcoesClick(Sender: TObject);
begin
  if FUsaTeclasDeAtalho and FNumeroPressionado then
    ModalResult := mrOK;
end;

procedure TFormMenuTEF.lbOpcoesKeyPress(Sender: TObject; var Key: char);
begin
  FNumeroPressionado := CharIsNum(Key);
end;

function TFormMenuTEF.GetTitulo: String;
begin
  Result := pTitulo.Caption;
end;

procedure TFormMenuTEF.SetItemSelecionado(AValue: Integer);
begin
  lbOpcoes.ItemIndex := AValue;
end;

function TFormMenuTEF.GetOpcoes: TStrings;
begin
  Result := lbOpcoes.Items;
end;

function TFormMenuTEF.GetItemSelecionado: Integer;
begin
  Result := lbOpcoes.ItemIndex;
end;

procedure TFormMenuTEF.SetOpcoes(AValue: TStrings);
begin
  lbOpcoes.Items.Assign(AValue);
end;

procedure TFormMenuTEF.SetTitulo(AValue: String);
begin
  pTitulo.Caption := AValue;
end;

end.

