{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}


unit DISTeste1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ACBrDIS, Buttons, Spin;

type

  { TForm1 }

  TForm1 = class(TForm)
     Button1: TButton;
     Button2: TButton;
     Button3: TButton;
     edIntervalo: TSpinEdit;
     edIntervaloEnvioBytes: TSpinEdit;
    edLinha1: TEdit;
    edLinha2: TEdit;
    ACBrDIS1: TACBrDIS;
    cbxPorta: TComboBox;
    edPassos: TSpinEdit;
    edLin: TSpinEdit;
    edCol: TSpinEdit;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    cbxModelo: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    lLinhas: TLabel;
    lColunas: TLabel;
    lLinha1: TLabel;
    lLinha2: TLabel;
    bDemo: TButton;
    bLimpar: TButton;
    bParar: TButton;
    bContinuar: TButton;
    cbxAlinhamento: TComboBox;
    cbxExibirEfeito: TComboBox;
    cbxRolarEfeito: TComboBox;
    cbLinha1: TCheckBox;
    cbLinha2: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    bExibir: TButton;
    bExibirEfeito: TButton;
    bRolar: TButton;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure edIntervaloEnvioBytesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbLinha1Click(Sender: TObject);
    procedure cbxPortaChange(Sender: TObject);
    procedure cbxAlinhamentoChange(Sender: TObject);
    procedure cbxModeloChange(Sender: TObject);
    procedure edIntervaloChange(Sender: TObject);
    procedure edPassosChange(Sender: TObject);
    procedure bLimparClick(Sender: TObject);
    procedure bContinuarClick(Sender: TObject);
    procedure bPararClick(Sender: TObject);
    procedure bDemoClick(Sender: TObject);
    procedure bExibirClick(Sender: TObject);
    procedure ACBrDIS1Atualiza(Linha: Integer; TextoVisivel: String);
    procedure bExibirEfeitoClick(Sender: TObject);
    procedure bRolarClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

Uses AcbrUtil, typinfo ;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: TACBrDISModelo;
begin
  cbxModelo.Items.Clear ;
  For I := Low(TACBrDISModelo) to High(TACBrDISModelo) do
     cbxModelo.Items.Add( GetEnumName(TypeInfo(TACBrDISModelo), integer(I) ) ) ;

  cbxAlinhamento.ItemIndex  := 2 ;
  cbxExibirEfeito.ItemIndex := 0 ;
  cbxRolarEfeito.ItemIndex  := 4 ;
  cbxModelo.ItemIndex       := 0 ;

  cbxPorta.Text    := ACBrDIS1.Porta ;
  edIntervalo.Value := ACBrDIS1.Intervalo ;
  edPassos.Value    := ACBrDIS1.Passos ;
  edIntervaloEnvioBytes.Value := ACBrDIS1.IntervaloEnvioBytes;
  cbxPortaChange( Sender );
  cbxAlinhamentoChange( Sender ) ;
  cbxModeloChange( Sender );
end;

procedure TForm1.edIntervaloEnvioBytesChange(Sender: TObject);
begin
   ACBrDIS1.IntervaloEnvioBytes:= edIntervaloEnvioBytes.Value;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
   ACBrDIS1.LimparLinha( 1 );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  ACBrDIS1.LimparLinha( 2 );
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   ACBrDIS1.PosicionarCursor( edLin.Value, edCol.Value );
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
(*  if ACBrDIS1.Ativo then
  begin
     ACBrDIS1.Alinhamento := alCentro ;
     ACBrDIS1.Intervalo   := 100 ;
     ACBrDIS1.ExibirLinha(1,
        PadCenter('COMPONENTES ACBr',ACBrDIS1.Colunas,'*'),
        efeEsquerda_Direita);
     ACBrDIS1.ExibirLinha(2,
        PadCenter('acbr.sourceforge.net',ACBrDIS1.Colunas,'*'),
        efeDireita_Esquerda);

     while ACBrDIS1.Trabalhando do
        Application.ProcessMessages ;

     sleep(500) ;
  end ;
*)
  CanClose := true ;
end;

procedure TForm1.cbLinha1Click(Sender: TObject);
Var Ligado : Boolean ;
begin
  Ligado := cbLinha1.Checked or cbLinha2.Checked ;

  cbxAlinhamento.Enabled  := Ligado ;
  bExibir.Enabled         := Ligado ;
  cbxExibirEfeito.Enabled := Ligado ;
  bExibirEfeito.Enabled   := Ligado ;
  cbxRolarEfeito.Enabled  := Ligado ;
  bRolar.Enabled          := Ligado ;
end;

procedure TForm1.cbxPortaChange(Sender: TObject);
Var Atv : Boolean ;
begin
  Atv := ACBrDIS1.Ativo ;
  ACBrDIS1.Desativar ;
  ACBrDIS1.Porta := cbxPorta.Text ;
  ACBrDIS1.Ativo := Atv ;
end;

procedure TForm1.cbxModeloChange(Sender: TObject);
Var Atv : Boolean ;
begin
  Atv := ACBrDIS1.Ativo ;
  ACBrDIS1.Desativar ;
  ACBrDIS1.Modelo  := TACBrDISModelo( cbxModelo.ItemIndex ) ;
  ACBrDIS1.Ativo   := Atv ;
  lColunas.Caption := IntToStr( ACBrDIS1.Colunas ) ;
  lLinhas.Caption  := IntToStr( ACBrDIS1.LinhasCount ) ;
end;

procedure TForm1.edIntervaloChange(Sender: TObject);
begin
  ACBrDIS1.Intervalo := edIntervalo.Value ;
end;

procedure TForm1.edPassosChange(Sender: TObject);
begin
  ACBrDIS1.Passos := edPassos.Value ;
end;

procedure TForm1.bDemoClick(Sender: TObject);
begin
  ACBrDIS1.Alinhamento := alCentro ;
  ACBrDIS1.ExibirLinha(1,'COMPONENTES ACBr');
  ACBrDIS1.ExibirLinha(2,'acbr.sourceforge.net');

  ACBrDIS1.RolarLinha(1,rolParaEsquerda_Sempre);
  ACBrDIS1.RolarLinha(2,rolParaDireita_Sempre);
end;

procedure TForm1.bLimparClick(Sender: TObject);
begin
  ACBrDIS1.LimparDisplay ;
end;

procedure TForm1.bPararClick(Sender: TObject);
begin
  ACBrDIS1.Parar ;
end;

procedure TForm1.bContinuarClick(Sender: TObject);
begin
  ACBrDIS1.Continuar ;
end;

procedure TForm1.cbxAlinhamentoChange(Sender: TObject);
begin
  ACBrDIS1.Alinhamento := TACBrDISAlinhamento( cbxAlinhamento.ItemIndex ) ;
end;

procedure TForm1.ACBrDIS1Atualiza(Linha: Integer; TextoVisivel: String);
begin
  if Linha = 1 then
     lLinha1.Caption := TextoVisivel ;

  if Linha = 2 then
     lLinha2.Caption := TextoVisivel ;

  edLin.Value := ACBrDIS1.Cursor.X;
  edCol.Value := ACBrDIS1.Cursor.Y;
end;

procedure TForm1.bExibirClick(Sender: TObject);
begin
  if cbLinha1.Checked then
     ACBrDIS1.ExibirLinha(1,edLinha1.Text,
        TACBrDISAlinhamento( cbxAlinhamento.ItemIndex ) ) ;

  if cbLinha2.Checked then
     ACBrDIS1.ExibirLinha(2,edLinha2.Text,
        TACBrDISAlinhamento( cbxAlinhamento.ItemIndex ) ) ;
end;

procedure TForm1.bExibirEfeitoClick(Sender: TObject);
begin
  if cbLinha1.Checked then
     ACBrDIS1.ExibirLinha(1,edLinha1.Text,
        TACBrDISEfeitoExibir( cbxExibirEfeito.ItemIndex ) ) ;

  if cbLinha2.Checked then
     ACBrDIS1.ExibirLinha(2,edLinha2.Text,
        TACBrDISEfeitoExibir( cbxExibirEfeito.ItemIndex ) ) ;
end;

procedure TForm1.bRolarClick(Sender: TObject);
begin
  if cbLinha1.Checked then
     ACBrDIS1.RolarLinha(1, TACBrDISEfeitoRolar( cbxRolarEfeito.ItemIndex ) ) ;

  if cbLinha2.Checked then
     ACBrDIS1.RolarLinha(2, TACBrDISEfeitoRolar( cbxRolarEfeito.ItemIndex ) ) ;
end;


end.

