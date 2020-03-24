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

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ACBrBase, ACBrAAC, jpeg, ExtCtrls;

type
  TForm2 = class(TForm)
    Image1: TImage;
    ACBrAAC1: TACBrAAC;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtSH_RazaoSocial: TEdit;
    Label2: TLabel;
    edtSH_CNPJ: TEdit;
    Label3: TLabel;
    edtSH_IE: TEdit;
    Label4: TLabel;
    edtSH_IM: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    edtPAF_Nome: TEdit;
    Label6: TLabel;
    edtPAF_Versao: TEdit;
    Label7: TLabel;
    edtPAF_MD5: TEdit;
    Label8: TLabel;
    edtNomeArquivoAuxiliar: TEdit;
    Label9: TLabel;
    edtParams: TMemo;
    Salvar: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Label10: TLabel;
    procedure SalvarClick(Sender: TObject);
    procedure ACBrAAC1GetChave(var Chave: AnsiString);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.ACBrAAC1GetChave(var Chave: AnsiString);
begin
   // Adicione aqui sua chave privada, que ser� usada para criptografar e
   // descriptogravar o arquivo auxiliar.
   Chave := '1234';
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
   // Nome do arquivo auxiliar criptografado
   ACBrAAC1.NomeArquivoAux := edtNomeArquivoAuxiliar.Text;
   ACBrAAC1.AbrirArquivo;

   // Dados da software house
   edtSH_RazaoSocial.Text := ACBrAAC1.IdentPAF.Empresa.RazaoSocial;
   edtSH_CNPJ.Text := ACBrAAC1.IdentPAF.Empresa.CNPJ;
   edtSH_IE.Text := ACBrAAC1.IdentPAF.Empresa.IE;
   edtSH_IM.Text := ACBrAAC1.IdentPAF.Empresa.IM;

   // Dados do Aplicativo PAF
   edtPAF_Nome.Text := ACBrAAC1.IdentPAF.Paf.Nome;
   edtPAF_Versao.Text := ACBrAAC1.IdentPAF.Paf.Versao;

   // Outras informa��es extras
   edtParams.Text := ACBrAAC1.Params.Text;

   // Mostra como pegar valores dos parametros extras
   ShowMessage('PAF_PVPendentes=' + ACBrAAC1.Params.Values['PAF_PVPendentes']);
end;

procedure TForm2.SalvarClick(Sender: TObject);
begin
   // Nome do arquivo auxiliar criptografado
   ACBrAAC1.NomeArquivoAux := edtNomeArquivoAuxiliar.Text;

   // Dados da software house
   ACBrAAC1.IdentPAF.Empresa.RazaoSocial := edtSH_RazaoSocial.Text;
   ACBrAAC1.IdentPAF.Empresa.CNPJ := edtSH_CNPJ.Text;
   ACBrAAC1.IdentPAF.Empresa.IE := edtSH_IE.Text;
   ACBrAAC1.IdentPAF.Empresa.IM := edtSH_IM.Text;

   // Dados do Aplicativo PAF
   ACBrAAC1.IdentPAF.Paf.Nome := edtPAF_Nome.Text;
   ACBrAAC1.IdentPAF.Paf.Versao := edtPAF_Versao.Text;
   ACBrAAC1.IdentPAF.Paf.PrincipalExe.MD5 := edtPAF_MD5.Text;

   // Outras informa��es extras
   ACBrAAC1.Params.Text := edtParams.Text;

   // Salvar arquivo criptografado
   ACBrAAC1.SalvarArquivo;
end;

end.
