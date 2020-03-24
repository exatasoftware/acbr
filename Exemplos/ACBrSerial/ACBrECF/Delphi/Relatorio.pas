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

unit Relatorio;

interface

uses
  SysUtils,
  {$IFDEF Delphi6_UP} Types, {$ELSE} ACBrD5, {$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, Classes;

type
  TfrRelatorio = class(TForm)
    mRelat: TMemo;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edVias: TEdit;
    OpenDialog1: TOpenDialog;
    lCodFPG: TLabel;
    edFPG: TEdit;
    sbFPG: TSpeedButton;
    lValor: TLabel;
    edValor: TEdit;
    lCupom: TLabel;
    edCupom: TEdit;
    lCodCNF: TLabel;
    edCNF: TEdit;
    sbCNF: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbFPGClick(Sender: TObject);
    procedure edValorKeyPress(Sender: TObject; var Key: Char);
    procedure sbCNFClick(Sender: TObject);
  private
    { Private declarations }
  public
    TipoRelatorio : Char ;
    { Public declarations }
  end;

var
  frRelatorio: TfrRelatorio;

implementation

uses ECFTeste1, ACBrECF, ACBrConsts;

{$R *.dfm}

procedure TfrRelatorio.FormCreate(Sender: TObject);
begin
  TipoRelatorio := 'G' ;
end;

procedure TfrRelatorio.Button1Click(Sender: TObject);
begin
if OpenDialog1.Execute then
   mRelat.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrRelatorio.Button2Click(Sender: TObject);
begin
  if TipoRelatorio = 'V' then
     Form1.ACBrECF1.CupomVinculado( edCupom.Text, edFPG.Text, edCNF.Text,
        StrToFloatDef( edValor.Text,0 ), mRelat.Lines,
        StrToIntDef(edVias.Text,1) )
  else
     Form1.ACBrECF1.RelatorioGerencial(mRelat.Lines,StrToIntDef(edVias.Text,1), StrToIntDef(edCupom.Text, 0));
end;

procedure TfrRelatorio.FormShow(Sender: TObject);
begin
//  mRelat.WrapAtValue := Form1.ACBrECF1.Colunas ;
  edFPG.Visible   := (TipoRelatorio = 'V') ;
//  lCupom.Visible  := edFPG.Visible ;
//  edCupom.Visible := edFPG.Visible ;
  lCodFPG.Visible := edFPG.Visible ;
  sbFPG.Visible   := edFPG.Visible ;
  lValor.Visible  := edFPG.Visible ;
  edValor.Visible := edFPG.Visible ;

  if edCupom.Visible then
     edCupom.Text := Form1.ACBrECF1.NumCupom ;
     
  edCNF.Text      := '' ;
  edCNF.Visible   := edFPG.Visible and
                    (Form1.ACBrECF1.Modelo in [ecfDaruma, ecfSchalter]) ;
  sbCNF.Visible   := edCNF.Visible ;
  lCodCNF.Visible := edCNF.Visible ;
  if TipoRelatorio = 'V' then
     Caption := 'Cupom NAO Fiscal Vinculado'
  else
  begin
     Caption := 'Relat�rio Ger�ncial' ;
     lCupom.Caption :=  '&Indice Relat�rio Rerencial';
     edCupom.Text   :=  '01';
  end;
end;

procedure TfrRelatorio.sbFPGClick(Sender: TObject);
begin
  Form1.FormasdePagamento1Click( Sender );
end;

procedure TfrRelatorio.edValorKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [',','.'] then
     Key := DecimalSeparator ;
end;

procedure TfrRelatorio.sbCNFClick(Sender: TObject);
begin
  Form1.CarregaComprovantesNAOFiscais1Click( Sender );
end;

end.
