{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Felipe Baldin                                   }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
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

                  {******************************************************************************}
{* Historico                                                                   }
{*                                                                             }
{* 24/03/2020: Primeira Versao - Felipe Baldin                                 }
{*    Doa��o para o projeto ACBR                                               }
{*    Cria�ao do componente ACBrPicpay, que implementa a integra��o com a API  }
{*    do Picpay atrav�s de m�todos HTTP usando a suite Synapse para envio      }
{*    e retorno de arquivos usando Json nativo do ACBr.                        }
{******************************************************************************}

unit Principal.View;

interface

{$I ACBr.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, DB, ACBrBase, ACBrSocket, ACBrPicpay;

//{$IFDEF CONDITIONALEXPRESSIONS}
//   {$IF CompilerVersion >= 20.0}
//     {$DEFINE DELPHI2009_UP}
//   {$IFEND}
//{$ENDIF}

{$IFDEF DELPHI2009_UP}
  {$DEFINE SUPPORT_PNG}
{$ENDIF}

{.$DEFINE SUPPORT_PNG}  // Remova o Ponto, se seu Delphi suporta PNG


type
  TPrincipalView = class(TForm)
    lb_idReference: TLabel;
    txt_idReference: TEdit;
    lbProductName: TLabel;
    txt_ProdutName: TEdit;
    lbValue: TLabel;
    txt_Value: TEdit;
    lbFirstName: TLabel;
    txt_FirstName: TEdit;
    lb_LastName: TLabel;
    txt_LastName: TEdit;
    lb_email: TLabel;
    txt_email: TEdit;
    lb_Phone: TLabel;
    txt_Phone: TEdit;
    btnSolicitar: TButton;
    Memo1: TMemo;
    Image1: TImage;
    lbStatus: TLabel;
    txt_Document: TEdit;
    lb_Document: TLabel;
    ACBrPicpay1: TACBrPicpay;
    Button1: TButton;
    Edit1: TEdit;
    procedure btnSolicitarClick(Sender: TObject);
    procedure ACBrPicpay1StatusPayment(AuthorizationId, Status: string);
    procedure ACBrPicpay1WaitingPayment(Status: string);
    procedure Button1Click(Sender: TObject);
  private
    procedure MostrarImagemQrCode;
  public
    { Public declarations }
  end;


var
  PrincipalView: TPrincipalView;

implementation

uses
  JPEG
  ///GraphicEx
{$IFDEF SUPPORT_PNG}
  , pngimage
{$ENDIF}
  ;

{$R *.dfm}


procedure TPrincipalView.ACBrPicpay1StatusPayment(AuthorizationId,
  Status: string);
begin
  if Status = 'paid' then
  begin
    lbStatus.Color := clGreen;
    lbStatus.Caption := 'Pago';
    Edit1.Text := AuthorizationId;
  end;
end;

procedure TPrincipalView.ACBrPicpay1WaitingPayment(Status: string);
begin
  if Status <> 'paid' then
    lbStatus.Caption := 'WAITING: ' + IntToStr(ACBrPicpay1.TempoRetorno) + ' segundos.';
end;

procedure TPrincipalView.btnSolicitarClick(Sender: TObject);
begin
  //Tempo em segundos aguardando o pagamento.
  ACBrPicpay1.TempoRetorno := 20;

  ACBrPicpay1.ReferenceId := txt_idReference.Text;
  ACBrPicpay1.Valor := StrToCurr(txt_Value.Text);

  //Crie sua conta em https://ecommerce.picpay.com/ para gerar o token e sellertoken
  ACBrPicpay1.Lojista.PicpayToken :=  'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';
  ACBrPicpay1.Lojista.URLCallBack := 'http://www.projetoacbr.com.br/callback';
  ACBrPicpay1.Lojista.URLReturn := 'http://www.projetoacbr.com.br/cliente/pedido/102030';

  ACBrPicpay1.Comprador.Nome := txt_FirstName.Text;
  ACBrPicpay1.Comprador.SobreNome := txt_LastName.Text;
  ACBrPicpay1.Comprador.Documento :=  txt_Document.Text;
  ACBrPicpay1.Comprador.Email := txt_email.Text;
  ACBrPicpay1.Comprador.Telefone := txt_Phone.Text;

  ACBrPicpay1.Enviar;

  MostrarImagemQrCode;

end;

procedure TPrincipalView.Button1Click(Sender: TObject);
begin
  if ACBrPicpay1.Cancelar(Edit1.Text) then
    lbStatus.Caption := 'CANCELADO';
end;

procedure TPrincipalView.MostrarImagemQrCode;

 {$IFDEF DELPHI2009_UP}
    procedure MostraImagemQrCodeDelphi2009UpPNG;
    var
      PNG: TPngImage;
    begin
      //Use esse c�digo para tratar a imagem do site em tipo PNG
      png:= TPngImage.Create;
      try
        png.LoadFromStream(ACBrPicpay1.QRCode);
        Image1.Picture.Assign(png);
      finally
        png.Free;
      end;
    end;
 {$ENDIF}

//    procedure MostraImagemQrCodeDelphiJPG;
//    var
//      Jpg: TJPEGImage;
//    begin
//       //Use esse c�digo para tratar a imagem do site em tipo JPG
//      Jpg:= TJPEGImage.Create;
//      try
//        Jpg.LoadFromStream(ACBrPicpay1.QrCode);
//        Image1.Picture.Assign(Jpg);
//      finally
//        Jpg.Free;
//      end;
//    end;
//    procedure MostraImagemQrCodeDelphi7GraphicEx();
//    var
//      PNG: TPNGGraphic;
//    begin
//      //Exemplo PNG para Delphi 7 usando GraphicEx .
//      // Necess�rio instalar a biblioteca de componentes e adicionar o library path.
//
//      PNG := TPNGGraphic.Create;
//      try
//        PNG.LoadFromStream(ACBrPicpay1.QRCode);
//        Image1.Picture.Assign(PNG);
//      finally
//        PNG.Free;
//      end;
//    end;

begin
 {$IFNDEF SUPPORT_PNG}
    ShowMessage('Aten��o: Seu Delphi n�o d� suporte nativo a imagens PNG. Queira verificar o c�digo fonte deste exemplo para saber como proceder.');
    Exit;
    // COMO PROCEDER:
    //
    // 1) Caso o site do picpay esteja utilizando uma imagem do tipo JPG, voc� pode utilizar o c�digo da fun��o MostraImagemQrCodeDelphiJPG.
    //    * Comente ou apague o c�digo que trabalha com PNG, incluindo o IFDEF/ENDIF;
    //    * descomente o c�digo da fun��o MostraImagemQrCodeDelphiJPG;
    //    * Troque a chamada da fun��o MostraImagemQrCodeDelphi2009UpPNG para MostraImagemQrCodeDelphiJPG
    // 2) Caso o site do picpay esteja utilizando uma imagem do tipo PNG, voc� ter� que utilizar uma biblioteca de terceiros para
    //conseguir trabalhar com imagens PNG.
    //  Neste caso, recomendamos verificar o manual da biblioteca em como fazer a implementa��o. Algumas sugest�es:
    //    * Uma das maneiras mais simples est� no link abaixo:
    //      - http://www.projetoacbr.com.br/forum/topic/20087-imagem-png-delphi-7/
    //    * Acima, a fun��o MostraImagemQrCodeDelphi7GraphicEx � um exemplo que  utiliza a biblioteca GraphicEX.
    // Mas existem outras bibliotecas, caso prefira:
    //      - http://synopse.info/forum/viewtopic.php?id=115
    //      - http://graphics32.org/wiki/
    //      - http://cc.embarcadero.com/Item/25631
    //      - V�rias outras: http://torry.net/quicksearchd.php?String=png&Title=Yes
  {$ENDIF}

 {$IFDEF DELPHI2009_UP}
  MostraImagemQrCodeDelphi2009UpPNG;
 {$ENDIF}

  //MostraImagemQrCodeDelphiJPG
  //MostraImagemQrCodeDelphi7GraphicEx;


end;




end.
