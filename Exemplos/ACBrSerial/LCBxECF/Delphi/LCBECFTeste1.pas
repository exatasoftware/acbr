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

unit LCBECFTeste1;

interface

uses
  SysUtils, Forms, Types, Classes, ACBrLCB, ACBrBase, ACBrECF, StdCtrls,
  Controls, ExtCtrls ;

type
  TForm1 = class(TForm)
    ACBrECF1: TACBrECF;
    ACBrLCB1: TACBrLCB;
    bLiberaECF: TButton;
    lInstr: TLabel;
    pVenda: TPanel;
    Label1: TLabel;
    edCod: TEdit;
    Label6: TLabel;
    edAliq: TEdit;
    Label7: TLabel;
    edUN: TEdit;
    Label3: TLabel;
    edDescricao: TEdit;
    Label4: TLabel;
    edQtd: TEdit;
    Label5: TLabel;
    edUnit: TEdit;
    bVendeItem: TButton;
    Button1: TButton;
    Label8: TLabel;
    edAtrasoAbre: TEdit;
    lAtraso: TLabel;
    Label2: TLabel;
    edAtrasoVende: TEdit;
    procedure bLiberaECFClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bVendeItemClick(Sender: TObject);
    procedure ACBrECF1AguardandoRespostaChange(Sender: TObject);
    procedure ACBrLCB1LeCodigo(Sender: TObject);
  private
    { Private declarations }
    fEmVenda : Boolean ;  { Flag para indicar que est� no Loop de Venda }
    procedure BloqueiaVenda ;
    procedure LiberaVenda ;
    procedure VendeItem( Codigo : String ) ;
    procedure SimulaAtraso( MillisecTempo : Integer ) ;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  ACBrECF1.Ativar ;
  ACBrLCB1.Ativar ;
  fEmVenda := False ;
end;

procedure TForm1.bLiberaECFClick(Sender: TObject);
begin
  ACBrECF1.CorrigeEstadoErro ;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ACBrECF1.Ativar ;
  ACBrECF1.AbreCupom();

  { Simulando um atraso para testar a chegada de Dados em ACBrLCB... Util apenas
    quando testando com o modelo ecfNaoFiscal }
  SimulaAtraso( StrToIntDef(edAtrasoAbre.Text,0) );
end;

procedure TForm1.ACBrECF1AguardandoRespostaChange(Sender: TObject);
begin
  if ACBrECF1.AguardandoResposta then
     BloqueiaVenda
  else
     LiberaVenda ;
end;

procedure TForm1.bVendeItemClick(Sender: TObject);
begin
  VendeItem( edCod.Text );
end;

procedure TForm1.ACBrLCB1LeCodigo(Sender: TObject);
begin
  if not fEmVenda then
     VendeItem( ACBrLCB1.LerFila ) ;
end;

procedure TForm1.VendeItem( Codigo : String );
begin
  fEmVenda := True ;
  BloqueiaVenda ;

  try
     while Codigo <> '' do
     begin
        { TODO: Fazer a busca de Codigo no Banco de dados... ao invez de usar os
          valores dos Edits }

        { TODO: Exibir campos localizados no BD nos Labels ou Edit }
        edCod.Text := Codigo ;
        Application.ProcessMessages ;

        ACBrECF1.VendeItem(Codigo, edDescricao.Text, edAliq.Text,
           StrToFloat(edQtd.Text) ,StrToFloat(edUnit.Text) ,0 , edUN.Text );

        { Simulando um atraso para testar a chegada de Dados em ACBrLCB...
          Util apenas quando testando com o modelo ecfNaoFiscal }
        SimulaAtraso( StrToIntDef(edAtrasoVende.Text,0) );

        Codigo := ACBrLCB1.LerFila ;
     end ;
  finally
     fEmVenda := False ;
     LiberaVenda ;
  end ;
end;

procedure TForm1.BloqueiaVenda;
begin
  pVenda.Enabled     := False ;
  Application.ProcessMessages ;

  { Est� com o ECF ocupado ? Desabilite a leitura de dados
    (dados ficam no buffer da serial }
  if not fEmVenda then
     ACBrLCB1.Intervalo := 0 ;
end;

procedure TForm1.LiberaVenda;
begin
  pVenda.Enabled := not (ACBrECF1.AguardandoResposta or fEmVenda) ;
  ACBrLCB1.Intervalo := 200 ;
end;

procedure TForm1.SimulaAtraso(MillisecTempo: Integer);
begin
  if (ACBrECF1.ModeloStr <> 'NaoFiscal') or (MillisecTempo <= 0) then exit ;

  lInstr.Visible  := False ;
  lAtraso.Visible := True ;
  Application.ProcessMessages ;

  Sleep( MillisecTempo);

  lAtraso.Visible := False ;
  lInstr.Visible  := True ;
end;

end.
