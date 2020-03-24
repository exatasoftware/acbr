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

unit UFormMaster;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  ACBrBase, ACBrInStore, FMX.Controls.Presentation, FMX.Edit, FMX.Objects;

type
  TFormMaster = class(TForm)
    Image1: TImage;
    edtCodificacao: TEdit;
    ACBrInStore1: TACBrInStore;
    edtCodigoEtiqueta: TEdit;
    edtPrefixo: TEdit;
    edtCodigo: TEdit;
    edtPeso: TEdit;
    edtTotal: TEdit;
    edtDV: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ACBrInStore1GetPrecoUnitario(const Codigo: string;
      var PrecoUnitario: Double);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMaster: TFormMaster;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}
{$R *.LgXhdpiPh.fmx ANDROID}

procedure TFormMaster.ACBrInStore1GetPrecoUnitario(const Codigo: string;
  var PrecoUnitario: Double);
begin
  // Fa�a a pesquisa do c�digo no seu DB, e pegue o pre�o unit�rio.
  PrecoUnitario := 10.00;
end;

procedure TFormMaster.Button1Click(Sender: TObject);
begin
  // Define a mascara do c�digo de barra da balan�a, e j� acha o prefixo
  // Guardando na propriedade Prefixo.
  ACBrInStore1.Codificacao := edtCodificacao.Text;

  // Checa se o c�digo da balan�a tem 13 digitos
  if Length(edtCodigoEtiqueta.Text) = 13 then
  begin
     // Verifica se o prefixo encontrado na mascara � igual ao
     // prefixo do c�digo de barra que veio da balan�a
     // Atendendo a essas situa��es isso quer dizer que o c�digo recebido �
     // um c�digo gerado pela balan�a.
     if ACBrInStore1.Prefixo = Copy(edtCodigoEtiqueta.Text, 1, Length(ACBrInStore1.Prefixo)) then
     begin
        ACBrInStore1.Desmembrar(edtCodigoEtiqueta.Text);

        edtPrefixo.Text := ACBrInStore1.Prefixo;
        edtCodigo.Text  := ACBrInStore1.Codigo;
        edtPeso.Text    := FloatToStr( ACBrInStore1.Peso );
        edtTotal.Text   := FloatToStr( ACBrInStore1.Total );
        edtDV.Text      := ACBrInStore1.DV;
     end;
  end;
end;

end.
