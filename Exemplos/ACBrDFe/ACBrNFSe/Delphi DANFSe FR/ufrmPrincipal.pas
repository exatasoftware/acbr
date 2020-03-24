{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
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

unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils,pcnConversao,
  ACBrBase, ACBrDFe, frxClass, Vcl.ComCtrls, ACBrNFSeDANFSeClass, ACBrNFSeDANFSeFR, ACBrNFSe,
  ACBrDFeReport;

type
  TfrmPrincipal = class(TForm)
    imgLogo: TImage;
    pnlbotoes: TPanel;
    btnImprimir: TButton;
    btncarregar: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    frxReport1: TfrxReport;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lstbxFR3: TListBox;
    TabSheet2: TTabSheet;
    RbCanhoto: TRadioGroup;
    ACBrNFSe1: TACBrNFSe;
    ACBrNFSeDANFSeFR1: TACBrNFSeDANFSeFR;
    procedure FormCreate(Sender: TObject);
    procedure btncarregarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    procedure Configuracao;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}


procedure TfrmPrincipal.btncarregarClick(Sender: TObject);
begin
  ACBrNFSe1.NotasFiscais.Clear;
  if OpenDialog1.Execute then
    ACBrNFSe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  Configuracao;
  if lstbxFR3.ItemIndex = -1 then
    raise Exception.Create('Selecione um arquivo fr3 ');

  if ACBrNFSe1.NotasFiscais.Count = 0 then
    raise Exception.Create('N�o foi carregado nenhum xml para impress�o');

  ACBrNFSeDANFSeFR1.FastFile := lstbxFR3.Items[lstbxFR3.ItemIndex];
  ACBrNFSe1.NotasFiscais.Imprimir;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  fsFiles: string;
begin
  for fsFiles in TDirectory.GetFiles('..\Delphi\Report\') do
    if Pos('.fr3', LowerCase(fsFiles)) > 0 then
      lstbxFR3.AddItem(fsFiles, nil);
  ACBrNFSe1.Configuracoes.Geral.PathIniCidades := '..\ArqINI';
end;

procedure TfrmPrincipal.Configuracao;
begin
//  With ACBrNFSeDANFSeFR1 do
//  begin
//    PosCanhoto := TPosRecibo(RbCanhoto.ItemIndex);
//  end;
end;

end.
