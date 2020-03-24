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

{$I ACBr.inc}

unit TrocoTeste1;

interface

uses
  Windows, Messages, SysUtils,
  {$IFDEF Delphi6_UP} Variants, {$ENDIF}
  Classes, Graphics, Controls, Forms,
  Dialogs, Contnrs, StdCtrls, ExtCtrls, ACBrBase, ACBrTroco;

type
  TFrmTroco = class(TForm)
    eDescricao: TEdit;
    eValor: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Memo2: TMemo;
    bTroco: TButton;
    Bevel1: TBevel;
    bTrocoDetalhado: TButton;
    Button2: TButton;
    ACBrTroco1: TACBrTroco;
    Label1: TLabel;
    Label4: TLabel;
    edTroco: TEdit;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure bTrocoClick(Sender: TObject);
    procedure bTrocoDetalhadoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ListaDinheiro;
  end;

var
  FrmTroco: TFrmTroco;

implementation
Uses ACBrUtil ;

{$R *.dfm}


{ TForm1 }

procedure TFrmTroco.FormShow(Sender: TObject);
begin
  ListaDinheiro ;
end;

procedure TFrmTroco.ListaDinheiro;
var
   A:integer;
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Add( 'Descricao                Valor') ;
  Memo1.Lines.Add( '------------------------------') ;

  for A := 0 to ACBrTroco1.DinheiroList.Count -1 do
     Memo1.Lines.Add( PadRight( ACBrTroco1.DinheiroList[A].Descricao,23) +
                      PadLeft( FormatFloat('#####0.00',ACBrTroco1.DinheiroList[A].Valor),7) );
end;

procedure TFrmTroco.Button3Click(Sender: TObject);
begin
  ListaDinheiro;
end;

procedure TFrmTroco.Button4Click(Sender: TObject);
begin
  ACBrTroco1.InserirDinheiro(eDescricao.Text,StrToFloat(eValor.Text));
  ListaDinheiro;
end;

procedure TFrmTroco.Button5Click(Sender: TObject);
begin
ACBrTroco1.LimparDinheiro;
ListaDinheiro;
end;

procedure TFrmTroco.bTrocoClick(Sender: TObject);
var
   A:integer;
begin
   try
      ACBrTroco1.Troco := StrToFloat(edTroco.Text);
   except
      ShowMessage('Valor invalido');
   end;

   Memo2.Lines.Clear;
   for A := 0 to ACBrTroco1.TrocoList.Count -1 do
      Memo2.Lines.Add(ACBrTroco1.TrocoList[A].DescricaoCompleta);
end;

procedure TFrmTroco.bTrocoDetalhadoClick(Sender: TObject);
var
   A:integer;
begin
   try
      ACBrTroco1.Troco := StrToFloat(edTroco.Text);
   except
      ShowMessage('Valor invalido');
   end;
   
   Memo2.Lines.Clear;
   for A := 0 to ACBrTroco1.TrocoList.Count -1 do
      begin
         with Memo2.Lines do
            begin
               Add('Quantidade: '+ FloatToStr(ACBrTroco1.TrocoList[A].Quantidade));
               Add('Descricao: ' + ACBrTroco1.TrocoList[A].Descricao);
               Add('Tipo: ' + ACBrTroco1.TrocoList[A].Tipo);
               Add('Valor: ' + FloatToStr(ACBrTroco1.TrocoList[A].Valor));
               Add('--------------------------------------------');
            end;
      end;
end;

procedure TFrmTroco.Button2Click(Sender: TObject);
var
   valor:String;
begin
   valor := '0';
   if not InputQuery('Informe Valor','Insira o valor do Dinheiro a ser removido da lista', valor) then
      Exit;

   if ACBrTroco1.RemoverDinheiro(StrToFloat(valor)) then
      ShowMessage('Valor removido')
   else
      ShowMessage('N�o foi possivel remover');

   ListaDinheiro;
end;

end.
