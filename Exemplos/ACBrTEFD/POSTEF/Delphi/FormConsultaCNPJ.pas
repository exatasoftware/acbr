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

unit FormConsultaCNPJ;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;

type

  { TfrConsultaCNPJ }

  TfrConsultaCNPJ = class(TForm)
    btNovoCaptcha: TBitBtn;
    btOK: TBitBtn;
    btOK1: TBitBtn;
    imgCaptcha: TImage;
    lInformeCaptcha: TLabel;
    pBotoes: TPanel;
    pCaptcha: TPanel;
    Panel1: TPanel;
    edtCaptcha: TEdit;
    procedure btNovoCaptchaClick(Sender: TObject);
    procedure edtCaptchaChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    procedure AtualizarCaptcha;

  public

  end;

implementation

uses
  FormTelaPrincipal,
  ACBrUtil;

{$R *.dfm}

{ TfrConsultaCNPJ }

procedure TfrConsultaCNPJ.FormShow(Sender: TObject);
begin
  AtualizarCaptcha;
end;

procedure TfrConsultaCNPJ.btNovoCaptchaClick(Sender: TObject);
begin
  AtualizarCaptcha;
end;

procedure TfrConsultaCNPJ.edtCaptchaChange(Sender: TObject);
begin
  lInformeCaptcha.Visible := False;
end;

procedure TfrConsultaCNPJ.FormCloseQuery(Sender: TObject; var CanClose: boolean
  );
begin
  if (ModalResult = mrOK) then
  begin
    if (Trim(edtCaptcha.Text) = '') then
    begin
      lInformeCaptcha.Visible := True;
      CanClose := False;
    end;
  end;
end;

procedure TfrConsultaCNPJ.AtualizarCaptcha;
var
  Stream: TMemoryStream;
  ImgName: String;
begin
  ImgName := ApplicationPath+'captcha.png';
  Stream := TMemoryStream.Create;
  try
    frPOSTEFServer.ACBrConsultaCNPJ1.Captcha(Stream);
    Stream.SaveToFile(ImgName);
    imgCaptcha.Picture.LoadFromFile(ImgName);

    edtCaptcha.Clear;
    edtCaptcha.SetFocus;
  finally
    Stream.Free;
  end;
end;

end.

