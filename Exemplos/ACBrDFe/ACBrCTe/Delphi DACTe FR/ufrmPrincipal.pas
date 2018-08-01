{******************************************************************************}
{ Projeto: Demo para impress�o de DACTe, Carta Corre��o e Inutliza��o em       }
{ Fast-Report                                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2016 Juliomar Marchetti                     }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
******************************************************************************}
unit ufrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils,
  dxGDIPlusClasses, ACBrBase, ACBrDFe, ACBrNFe, frxClass, ACBrCTeDACTEClass, ACBrCTeDACTEFR, ACBrCTe;

type
  TfrmPrincipal = class(TForm)
    imgLogo: TImage;
    lstbxFR3: TListBox;
    pnlbotoes: TPanel;
    btnImprimir: TButton;
    btncarregar: TButton;
    btnCarregarEvento: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    frxReport1: TfrxReport;
    ACBrCTe1: TACBrCTe;
    ACBrCTeDACTEFR1: TACBrCTeDACTEFR;
    btnlogo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btncarregarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnCarregarEventoClick(Sender: TObject);
    procedure btnlogoClick(Sender: TObject);
  private
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
  ACBrCTe1.Conhecimentos.Clear;
  if OpenDialog1.Execute then
    ACBrCTe1.Conhecimentos.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  if lstbxFR3.ItemIndex = -1 then
    raise Exception.Create('Selecione um arquivo fr3 ');


  if Pos('evento', LowerCase(lstbxFR3.Items[lstbxFR3.ItemIndex])) > 0 then
  begin
    if ACBrCTe1.EventoCTe.Evento.Count = 0 then
      raise Exception.Create('N�o tem nenhum evento para imprimir');

    ACBrCTeDACTEFR1.FastFileEvento := lstbxFR3.Items[lstbxFR3.ItemIndex];
    ACBrCTe1.ImprimirEvento;
  end
  else
  if Pos('dact', LowerCase(lstbxFR3.Items[lstbxFR3.ItemIndex])) > 0 then
  begin
    if ACBrCTe1.Conhecimentos.Count = 0 then
      raise Exception.Create('N�o foi carregado nenhum xml para impress�o');

    ACBrCTeDACTEFR1.FastFile := lstbxFR3.Items[lstbxFR3.ItemIndex];
    ACBrCTe1.Conhecimentos.Imprimir;
  end;

end;

procedure TfrmPrincipal.btnlogoClick(Sender: TObject);
begin
  OpenDialog1.Execute();
  ACBrCTeDACTEFR1.Logo := OpenDialog1.FileName;
end;

procedure TfrmPrincipal.btnCarregarEventoClick(Sender: TObject);
begin
  ACBrCTe1.Conhecimentos.Clear;
  ACBrCTe1.EventoCTe.Evento.Clear;
  OpenDialog1.Execute();
  ACBrCTe1.EventoCTe.LerXML(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  fsFiles: string;
begin
  for fsFiles in TDirectory.GetFiles('..\Delphi\Report\') do
    if Pos('.fr3', LowerCase(fsFiles)) > 0 then
      lstbxFR3.AddItem(fsFiles, nil);
end;

end.
