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

unit uEnvioLote;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmEnvioLote = class(TForm)
    btnTrocarChip: TButton;
    btnCancelar: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnTrocarChipClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEnvioLote: TfrmEnvioLote;

implementation

uses
  uPrincipal, ACBrSMSClass;

{$R *.dfm}

procedure TfrmEnvioLote.btnCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmEnvioLote.btnTrocarChipClick(Sender: TObject);
var
  Indices: String;
  LoteMsgs: TACBrSMSMensagens;
begin
  if OpenDialog1.Execute then
  begin
    LoteMsgs := TACBrSMSMensagens.Create;
    try
      // envio de lote apartir de arquivo
      // cada linha do arquivo � uma mensagem, seguinte o padr�o:
      // 1122223333|Mensagem que deseja enviar
      //
      LoteMsgs.LoadFromFile(OpenDialog1.FileName);

      {
        Pode ser populada a m�o utilizado o m�todo Add, assim o usu�rio pode
        montar a lista a partir de uma tabela no banco de dados por exemplo

        Exemplo:

        while not Tabela.Eof do
        begin
          with LoteMsgs.Add do
          begin
            Telefone := '1122223333';
            Mensagem := 'Mensagem que deseja enviar';
          end;

          Tabela.Next;
        end;
      }

      frmPrincipal.ACBrSMS1.EnviarSMSLote(LoteMsgs, Indices);
      ShowMessage('Enviadas: ' + Indices);
    finally
      LoteMsgs.Free;
    end;
  end;
end;

end.
