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

unit u_principal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, LCL, LCLType,
  LCLProc, ExtCtrls, StdCtrls, Buttons, MaskEdit, ACBrConsultaCNPJ;

type

  { TFprincipal }

  TFprincipal = class(TForm)
    ACBrConsultaCNPJ1: TACBrConsultaCNPJ;
    ButBuscar: TBitBtn;
    EditAbertura: TEdit;
    EditBairro: TEdit;
    EditCaptcha: TEdit;
    EditCEP: TEdit;
    EditCidade: TEdit;
    EditCNAE1 : TEdit ;
    EditCNAE2: TMemo;
    EditNaturezaJuridica : TEdit ;
    EditCNPJ: TMaskEdit;
    EditComplemento: TEdit;
    EditEndereco: TEdit;
    EditFantasia: TEdit;
    EditNumero: TEdit;
    EditRazaoSocial: TEdit;
    EditSituacao: TEdit;
    EditTipo: TEdit;
    EditUF: TEdit;
    Image1: TImage;
    LabAtualizarCaptcha: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15 : TLabel ;
    Label16 : TLabel ;
    Label17 : TLabel ;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Timer1: TTimer;
    procedure ButBuscarClick(Sender: TObject);
    procedure EditCaptchaKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabAtualizarCaptchaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Fprincipal: TFprincipal;

implementation

{$R *.lfm}

{ TFprincipal }

procedure TFprincipal.ButBuscarClick(Sender: TObject);
begin
  if EditCaptcha.Text <> '' then
  begin
    if ACBrConsultaCNPJ1.Consulta(EditCNPJ.Text, EditCaptcha.Text) then
    begin
      EditTipo.Text        := ACBrConsultaCNPJ1.EmpresaTipo;
      EditRazaoSocial.Text := ACBrConsultaCNPJ1.RazaoSocial;
      EditAbertura.Text    := DateToStr( ACBrConsultaCNPJ1.Abertura );
      EditFantasia.Text    := ACBrConsultaCNPJ1.Fantasia;
      EditEndereco.Text    := ACBrConsultaCNPJ1.Endereco;
      EditNumero.Text      := ACBrConsultaCNPJ1.Numero;
      EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
      EditBairro.Text      := ACBrConsultaCNPJ1.Bairro;
      EditComplemento.Text := ACBrConsultaCNPJ1.Complemento;
      EditCidade.Text      := ACBrConsultaCNPJ1.Cidade;
      EditUF.Text          := ACBrConsultaCNPJ1.UF;
      EditCEP.Text         := ACBrConsultaCNPJ1.CEP;
      EditSituacao.Text    := ACBrConsultaCNPJ1.Situacao;
      EditCNAE1.Text       := ACBrConsultaCNPJ1.CNAE1;
      EditCNAE2.Lines.Text := ACBrConsultaCNPJ1.CNAE2.Text;
      EditNaturezaJuridica.Text := ACBrConsultaCNPJ1.NaturezaJuridica;
    end;
  end
  else
  begin
    ShowMessage('É necessário digitar o captcha.');
    EditCaptcha.SetFocus;
  end;
end;

procedure TFprincipal.EditCaptchaKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
    ButBuscarClick(ButBuscar);
end;

procedure TFprincipal.FormCreate(Sender: TObject);
begin
  DateSeparator:='/';
  ShortDateFormat := 'dd/mm/yyyy';
end;

procedure TFprincipal.FormShow(Sender: TObject);
begin
  Timer1.Enabled:= True;
end;

procedure TFprincipal.LabAtualizarCaptchaClick(Sender: TObject);
var
  Stream: TMemoryStream;
  Png: TPortableNetworkGraphic;
begin
  Stream:= TMemoryStream.Create;
  Png:= TPortableNetworkGraphic.Create;
  try
    ACBrConsultaCNPJ1.Captcha(Stream);
    Png.LoadFromStream(Stream);
    Image1.Picture.Assign(Png);

    EditCaptcha.Clear;
    EditCaptcha.SetFocus;
  finally
    Stream.Free;
    Png.Free;
  end;
end;

procedure TFprincipal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:= False;
  LabAtualizarCaptchaClick(LabAtualizarCaptcha);
  EditCNPJ.SetFocus;
end;

end.

