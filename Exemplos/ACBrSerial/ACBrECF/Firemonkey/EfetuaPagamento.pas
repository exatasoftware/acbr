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

unit EfetuaPagamento;

interface

uses
  System.StrUtils, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation;

type
  TfrPagamento = class(TForm)
    PgPagamento: TTabControl;
    TabSheetPagamento: TTabItem;
    TabSheetEstorno: TTabItem;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    edCod: TEdit;
    Label2: TLabel;
    edValor: TEdit;
    Label8: TLabel;
    edObs: TEdit;
    cbVinc: TCheckBox;
    Label4: TLabel;
    btImprimir: TButton;
    Label5: TLabel;
    lTotalPago: TLabel;
    lTotalAPAGAR: TLabel;
    mFormas: TMemo;
    SpeedButton1: TButton;
    btnEstornar: TButton;
    EdtMsgPromocional: TEdit;
    Label12: TLabel;
    EdtValor: TEdit;
    Label11: TLabel;
    CBVincNovo: TCheckBox;
    EdtTipoNovo: TEdit;
    Label10: TLabel;
    CbVincCancelado: TCheckBox;
    Label9: TLabel;
    EdtTipoCanc: TEdit;
    MemoInformacaoEstorno: TMemo;
    Label13: TLabel;
    MFormasEst: TMemo;
    procedure edValorKeyPress(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure btImprimirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnEstornarClick(Sender: TObject);
    procedure MFormasEstEnter(Sender: TObject);
    procedure mFormasEnter(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizaVal ;
    Procedure CarregaFPG ;
  public
    { Public declarations }
    TipoCupom : Char ;
    Estado: String;
  end;

var
  frPagamento: TfrPagamento;

implementation

uses ECFTeste1, ACBrECFClass, ACBrUtil, ACBrConsts, ACBrECF;

{$R *.fmx}

procedure TfrPagamento.edValorKeyPress(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if KeyChar in [',','.'] then
     KeyChar := DecimalSeparator ;
end;


procedure TfrPagamento.btImprimirClick(Sender: TObject);
begin
  if TipoCupom <> 'N' then
   begin
     Form1.ACBrECF1.EfetuaPagamento( edCod.Text, StrToFloat( edValor.Text),
                                     edObs.Text ,cbVinc.IsChecked );
     Form1.mResp.Lines.Add( 'Efetua Pagamento: '+edCod.Text +
                            ' Valor: '+edValor.Text +
                            ' Obs: '+edObs.Text +
                            ' Vinc: '+IfThen(cbVinc.IsChecked,'S','N') );
   end
  else
   begin
     Form1.ACBrECF1.EfetuaPagamentoNaoFiscal( edCod.Text, StrToFloat( edValor.Text),
                                     edObs.Text ,cbVinc.IsChecked );
     Form1.mResp.Lines.Add( 'Efetua Pagamento N�o Fiscal: '+edCod.Text +
                            ' Valor: '+edValor.Text +
                            ' Obs: '+edObs.Text +
                            ' Vinc: '+IfThen(cbVinc.IsChecked,'S','N') );
   end ;

  Form1.AtualizaMemos ;
  AtualizaVal ;
end;

procedure TfrPagamento.FormShow(Sender: TObject);
begin
  if Estado = 'Estorno' then
    PgPagamento.ActiveTab:= TabSheetEstorno
  else
    PgPagamento.ActiveTab:= TabSheetPagamento;
  Estado:= '';

  AtualizaVal ;
  CarregaFPG ;
  TipoCupom := 'F' ;
end;

procedure TfrPagamento.AtualizaVal;
begin
  lTotalAPAGAR.Text := FloatToStr( Form1.ACBrECF1.Subtotal ) ;
  lTotalPago.Text   := FloatToStr( Form1.ACBrECF1.TotalPago ) ;
end;

procedure TfrPagamento.SpeedButton1Click(Sender: TObject);
Var Descricao : String ;
    FPG : TACBrECFFormaPagamento ;  { Necessita de uses ACBrECF }
begin
  if InputQuery('Pesquisa Descri��o Forma Pagamento',
                'Entre com a Descri��o a Localizar ou Cadastrar(Bematech)',
                Descricao) then
  begin
     FPG := Form1.ACBrECF1.AchaFPGDescricao( Descricao ) ;

     if FPG = nil then
        raise Exception.Create('Forma de Pagamento: '+Descricao+
                               ' n�o encontrada') ;

     edCod.Text := FPG.Indice ;

     { Bematech permite cadastrar formas de Pagamento dinamicamente }
     if (Form1.ACBrECF1.ModeloStr = 'Bematech') and
        (pos( FPG.Descricao, mFormas.Text ) = 0) then
        CarregaFPG ;
  end ;

end;

procedure TfrPagamento.CarregaFPG;
Var A : Integer ;
begin
  mFormas.Lines.Clear ;
  mFormas.Lines.Clear;
  with Form1 do
  begin
     { Bematech e NaoFiscal permitem cadastrar formas de Pagamento dinamicamente }
     if (Form1.ACBrECF1.Modelo in [ecfBematech,ecfNaoFiscal])then
        ACBrECF1.CarregaFormasPagamento
     else
        ACBrECF1.AchaFPGIndice('') ;  { for�a carregar, se ainda nao o fez }

     for A := 0 to ACBrECF1.FormasPagamento.Count -1 do
     begin
        mFormas.Lines.Add( ACBrECF1.FormasPagamento[A].Indice+' -> '+
              ACBrECF1.FormasPagamento[A].Descricao+' - '+IfThen(
              ACBrECF1.FormasPagamento[A].PermiteVinculado,'v',''));
        MFormasEst.Lines.Add( ACBrECF1.FormasPagamento[A].Indice+' -> '+
              ACBrECF1.FormasPagamento[A].Descricao+' - '+IfThen(
              ACBrECF1.FormasPagamento[A].PermiteVinculado,'v',''));
     end ;
  end ;

end;

procedure TfrPagamento.btnEstornarClick(Sender: TObject);
begin
   Form1.ACBrECF1.EstornaPagamento(EdtTipoCanc.Text, EdtTipoNovo.Text,
                                   StrToFloat(EdtValor.Text),EdtMsgPromocional.Text);
   Form1.AtualizaMemos ;
   AtualizaVal ;
end;

procedure TfrPagamento.MFormasEstEnter(Sender: TObject);
begin
   btnEstornar.SetFocus;
end;

procedure TfrPagamento.mFormasEnter(Sender: TObject);
begin
   btImprimir.SetFocus;
end;


end.
