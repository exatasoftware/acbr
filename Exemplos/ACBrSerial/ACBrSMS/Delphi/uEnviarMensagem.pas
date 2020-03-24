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

unit uEnviarMensagem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmEnviarMensagem = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lblContador: TLabel;
    edtTelefone: TEdit;
    btnEnviar: TButton;
    memMensagem: TMemo;
    btnCancelar: TButton;
    ckbQuebrarMensagem: TCheckBox;
    rdgBandeja: TRadioGroup;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
    procedure memMensagemChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnviarMensagem: TfrmEnviarMensagem;

implementation

uses
  uPrincipal, ACBrSMSClass;

{$R *.dfm}

procedure TfrmEnviarMensagem.FormCreate(Sender: TObject);
begin
  edtTelefone.Clear;
  memMensagem.Clear;

  rdgBandeja.Enabled := frmPrincipal.ACBrSMS1.BandejasSimCard > 1;
  if rdgBandeja.Enabled then
    rdgBandeja.ItemIndex := Integer(frmPrincipal.ACBrSMS1.SimCard);
end;

procedure TfrmEnviarMensagem.memMensagemChange(Sender: TObject);
begin
  lblContador.Caption := Format('%d caracter(es)', [Length(memMensagem.Text)]);
end;

procedure TfrmEnviarMensagem.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmEnviarMensagem.btnEnviarClick(Sender: TObject);
var
  IndiceMsgEnviada: String;
begin
  if Trim(edtTelefone.Text) = EmptyStr then
    raise Exception.Create('Informe o n�mero do telefone.');

  if Trim(memMensagem.Text) = EmptyStr then
    raise Exception.Create('Informe a mensagem a ser enviada.');

  // definir a bandeja de chip quando possuir mais de uma
  if frmPrincipal.ACBrSMS1.BandejasSimCard > 1 then
  begin
    if rdgBandeja.ItemIndex = 0 then
      frmPrincipal.ACBrSMS1.TrocarBandeja(simCard1)
    else
      frmPrincipal.ACBrSMS1.TrocarBandeja(simCard2);
  end;

  // quebra de mensagens maiores que 160 caracteres
  frmPrincipal.ACBrSMS1.QuebraMensagens := ckbQuebrarMensagem.Checked;

  // enviar o sms
  frmPrincipal.ACBrSMS1.EnviarSMS(
    edtTelefone.Text,
    memMensagem.Text,
    IndiceMsgEnviada
  );

  ShowMessage(
    'Mensagem envida com sucesso. Indice: ' + IndiceMsgEnviada +
    sLineBreak +
    sLineBreak +
    'Ultima resposta: ' +
    sLineBreak +
    frmPrincipal.ACBrSMS1.UltimaResposta
  );
end;

end.
