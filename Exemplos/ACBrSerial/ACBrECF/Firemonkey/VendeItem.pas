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

unit VendeItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TfrVendeItem = class(TForm)
    Label8: TLabel;
    edCodigo: TEdit;
    Label1: TLabel;
    edDescricao: TEdit;
    Label2: TLabel;
    edQtd: TEdit;
    Label3: TLabel;
    edPrecoUnita: TEdit;
    Label4: TLabel;
    edUN: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    edDesconto: TEdit;
    rbPercentagem: TRadioButton;
    rbValor: TRadioButton;
    Panel2: TPanel;
    Label6: TLabel;
    edICMS: TEdit;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    ckInmetro: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure edQtdKeyPress(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frVendeItem: TfrVendeItem;

implementation
uses
  ECFTeste1, ACBrConsts;

{$R *.fmx}

procedure TfrVendeItem.Button1Click(Sender: TObject);
Var Desc : Char ;
begin
//  if Form1.ACBrECF1.AguardandoResposta then
//     raise Exception.Create('Aguarde imprimindo Item anterior...') ;

  Button1.Enabled := False ;
  Desc := '%' ;
  if rbValor.IsChecked then
     Desc := '$' ;

  try
     if ckInmetro.IsChecked then
        Form1.ACBrECF1.LegendaInmetroProximoItem;

     Form1.ACBrECF1.VendeItem( edCodigo.Text, edDescricao.Text,
                               edICMS.Text, StrToFloatDef( edQtd.Text, 0 ),
                               StrToFloatDef( edPrecoUnita.Text,0 ),
                               StrToFloatDef( edDesconto.Text,0 ), edUN.Text,
                               Desc );

     Form1.mResp.Lines.Add( 'Vende Item: Cod:'+ edCodigo.Text+
                            ' Desc'+ edDescricao.Text+
                            ' Aliq:'+edICMS.Text +
                            ' Qtd:'+edQtd.Text +
                            ' Pre�o:'+edPrecoUnita.Text +
                            ' Desc:'+edDesconto.Text +
                            ' Un:'+edUN.Text +
                            ' Desc:'+Desc );
     Form1.AtualizaMemos ;
  finally
     Button1.Enabled := True ;
  end ;
end;

procedure TfrVendeItem.Button2Click(Sender: TObject);
begin
  close ;
end;

procedure TfrVendeItem.edQtdKeyPress(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if KeyChar in [',','.'] then
     KeyChar := DecimalSeparator ;
end;

end.
