{******************************************************************************}
{ Projeto: Demo para impress�o de DANFe, Carta Corre��o e Inutliza��o em       }
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
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.IOUtils,pcnConversao,
  ACBrNFeDANFEFRDM, ACBrNFeDANFEClass, ACBrNFeDANFEFR, ACBrBase, ACBrDFe, ACBrNFe, frxClass,AcbrUtil,
  Vcl.ComCtrls;

type
  TfrmPrincipal = class(TForm)
    ACBrNFe1: TACBrNFe;
    ACBrNFeDANFEFR1: TACBrNFeDANFEFR;
    imgLogo: TImage;
    pnlbotoes: TPanel;
    btnImprimir: TButton;
    btncarregar: TButton;
    btnCarregarEvento: TButton;
    OpenDialog1: TOpenDialog;
    btncarregarinutilizacao: TButton;
    Image1: TImage;
    frxReport1: TfrxReport;
    PageControl1: TPageControl;
    TabArquivos: TTabSheet;
    lstbxFR3: TListBox;
    TabCustomizacao: TTabSheet;
    RbCanhoto: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditMargemEsquerda: TEdit;
    EditMargemSuperior: TEdit;
    EditMargemDireita: TEdit;
    EditMargemInferior: TEdit;
    Decimais: TTabSheet;
    RgTipodedecimais: TRadioGroup;
    PageControl2: TPageControl;
    TabtdetInteger: TTabSheet;
    TabtdetMascara: TTabSheet;
    cbtdetInteger_qtd: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    cbtdetInteger_Vrl: TComboBox;
    Label7: TLabel;
    cbtdetMascara_qtd: TComboBox;
    Label8: TLabel;
    cbtdetMascara_Vrl: TComboBox;
    rbTarjaNfeCancelada: TCheckBox;
    Label9: TLabel;
    CBImprimirUndQtVlComercial: TComboBox;
    rbImprimirDadosDocReferenciados: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btncarregarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btncarregarinutilizacaoClick(Sender: TObject);
    procedure btnCarregarEventoClick(Sender: TObject);
  private
    procedure Configuracao;
    procedure Initializao;
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
  ACBrNFe1.NotasFiscais.Clear;
  if OpenDialog1.Execute then
    ACBrNFe1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.btnImprimirClick(Sender: TObject);
begin
  Configuracao;
  if lstbxFR3.ItemIndex = -1 then
    raise Exception.Create('Selecione um arquivo fr3 ');

  if Pos('danf', LowerCase(lstbxFR3.Items[lstbxFR3.ItemIndex])) > 0 then
  begin
    if ACBrNFe1.NotasFiscais.Count = 0 then
      raise Exception.Create('N�o foi carregado nenhum xml para impress�o');

    ACBrNFeDANFEFR1.FastFile := lstbxFR3.Items[lstbxFR3.ItemIndex];
    ACBrNFe1.NotasFiscais.Imprimir;
  end
  else if Pos('evento', LowerCase(lstbxFR3.Items[lstbxFR3.ItemIndex])) > 0 then
  begin
    if ACBrNFe1.EventoNFe.Evento.Count = 0 then
      raise Exception.Create('N�o tem nenhum evento para imprimir');

    ACBrNFeDANFEFR1.FastFileEvento := lstbxFR3.Items[lstbxFR3.ItemIndex];
    ACBrNFe1.ImprimirEvento;
  end
  else if Pos('inuti', LowerCase(lstbxFR3.Items[lstbxFR3.ItemIndex])) > 0 then
  begin
    if ACBrNFe1.InutNFe.RetInutNFe.nProt = EmptyStr then
      raise Exception.Create('N�o foi carregado nenhuma inutiliza��o');

    ACBrNFeDANFEFR1.FastFileInutilizacao := lstbxFR3.Items[lstbxFR3.ItemIndex];
    ACBrNFe1.ImprimirInutilizacao;
  end;

end;

procedure TfrmPrincipal.btnCarregarEventoClick(Sender: TObject);
begin
  ACBrNFe1.NotasFiscais.Clear;
  ACBrNFe1.EventoNFe.Evento.Clear;
  OpenDialog1.Execute();
  ACBrNFe1.EventoNFe.LerXML(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.btncarregarinutilizacaoClick(Sender: TObject);
begin
  ACBrNFe1.NotasFiscais.Clear;

  OpenDialog1.Execute();
  ACBrNFe1.InutNFe.LerXML(OpenDialog1.FileName);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  fsFiles: string;
begin
  for fsFiles in TDirectory.GetFiles('..\Delphi\Report\') do
    if Pos('.fr3', LowerCase(fsFiles)) > 0 then
      lstbxFR3.AddItem(fsFiles, nil);

  Initializao;
end;

procedure TfrmPrincipal.Configuracao;
begin
  With ACBrNFeDANFEFR1 do
  begin
    PosCanhoto      := TPosRecibo( RbCanhoto.ItemIndex );

    // Mostra  a Tarja NFe CANCELADA
    NFeCancelada    := rbTarjaNfeCancelada.Checked;
    { Ajustar a propriedade ProtocoloNFe conforme a sua necessidade }
    { ProtocoloNFe := }

    // Margens
    MargemEsquerda  := StringToFloat( EditMargemEsquerda.Text );
    MargemSuperior  := StringToFloat( EditMargemSuperior.Text );
    MargemDireita   := StringToFloat( EditMargemDireita.Text );
    MargemInferior  := StringToFloat( EditMargemInferior.Text );

    // Decimais
    CasasDecimais.Formato       := TDetFormato( RgTipodedecimais.ItemIndex );
    CasasDecimais._qCom         := cbtdetInteger_qtd.ItemIndex;
    CasasDecimais._vUnCom       := cbtdetInteger_Vrl.ItemIndex;
    CasasDecimais._Mask_qCom    := cbtdetMascara_qtd.Items[ cbtdetMascara_qtd.ItemIndex ] ;
    CasasDecimais._Mask_vUnCom  := cbtdetMascara_Vrl.Items[cbtdetMascara_Vrl.ItemIndex ];

    // ImprimirUndQtVlComercial
    ImprimirUnQtVlComercial     := TImprimirUnidQtdeValor( CBImprimirUndQtVlComercial.ItemIndex );

    ImprimirDadosDocReferenciados := rbImprimirDadosDocReferenciados.Checked;

  end;
end;

procedure TfrmPrincipal.Initializao;
begin
  PageControl1.ActivePage := TabArquivos;

  With ACBrNFeDANFEFR1 do
  begin

    EditMargemEsquerda.Text := FloatToString( MargemEsquerda);
    EditMargemSuperior.Text := FloatToString( MargemSuperior);
    EditMargemDireita.Text  := FloatToString( MargemDireita);
    EditMargemInferior.Text := FloatToString( MargemInferior);

    NFeCancelada            := False;

    // Decimais
    RgTipodedecimais.ItemIndex  := integer( CasasDecimais.Formato );
    cbtdetInteger_qtd.ItemIndex := CasasDecimais._qCom;
    cbtdetInteger_Vrl.ItemIndex := CasasDecimais._vUnCom;
    cbtdetMascara_qtd.ItemIndex := CasasDecimais._qCom;
    cbtdetMascara_Vrl.ItemIndex := CasasDecimais._vUnCom;

    // ImprimirUndQtVlComercial
    CBImprimirUndQtVlComercial.ItemIndex  := integer( ImprimirUnQtVlComercial );

    rbImprimirDadosDocReferenciados.Checked := ImprimirDadosDocReferenciados;


  end;

 With frxReport1 do
  begin
    ShowProgress  := False;
    StoreInDFM    := False;
  end;

end;

end.
