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

unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ACBrCotacao, ACBrBase, ACBrSocket, ComCtrls;

type

  TfrmPrincipal = class(TForm)
    GroupBox1: TGroupBox;
    btnAtualizarMostrar: TButton;
    ACBrCotacao1: TACBrCotacao;
    btnProcurarSimbolo: TButton;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label3: TLabel;
    procedure btnAtualizarMostrarClick(Sender: TObject);
    procedure btnProcurarSimboloClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  ShellAPI, ACBrUtil;

{$R *.dfm}

procedure TfrmPrincipal.btnAtualizarMostrarClick(Sender: TObject);
var
  I: Integer;
begin
  ListBox1.Items.BeginUpdate;
  try
    ListBox1.Clear;

    ACBrCotacao1.AtualizarTabela(DateTimePicker1.Date);
    for I := 0 to ACBrCotacao1.Tabela.Count - 1 do
    begin
      ListBox1.Items.Add(
        Format('%s  %3.3d  %s  %s  %s  %5.5d  %s  %10s  %10s  %10s  %10s', [
          DateToStr(ACBrCotacao1.Tabela[I].DataCotacao),
          ACBrCotacao1.Tabela[I].CodigoMoeda,
          ACBrCotacao1.Tabela[I].Tipo,
          ACBrCotacao1.Tabela[I].Moeda,
          PadRight(ACBrCotacao1.Tabela[I].Nome, 20, ' '),
          ACBrCotacao1.Tabela[I].CodPais,
          PadRight(ACBrCotacao1.Tabela[I].Pais, 30, ' '),
          FloatTostr(ACBrCotacao1.Tabela[I].TaxaCompra),
          FloatTostr(ACBrCotacao1.Tabela[I].TaxaVenda),
          FloatTostr(ACBrCotacao1.Tabela[I].ParidadeCompra),
          FloatTostr(ACBrCotacao1.Tabela[I].ParidadeVenda)
        ])
      );
    end;
  finally
    ListBox1.Items.EndUpdate;
  end;
end;

procedure TfrmPrincipal.btnProcurarSimboloClick(Sender: TObject);
var
  Simbolo: String;
  Item: TACBrCotacaoItem;
begin
  if ACBrCotacao1.Tabela.Count = 0 then
  begin
    if Application.MessageBox('Deseja atualizar a tabela de cota��es?', 'Atualizar', MB_ICONQUESTION + MB_YESNO) = ID_YES then
      ACBrCotacao1.AtualizarTabela(DateTimePicker1.Date)
    else
      raise Exception.Create('Antes de continuar atualize a tabela de cota��es!');
  end;

  Simbolo := AnsiUpperCase(Trim(InputBox('Procurar', 'Informe o c�digo da moeda:', '')));
  if Simbolo <> '' then
  begin
    Item := ACBrCotacao1.Procurar(Simbolo);

    if Item <> nil then
    begin
      ShowMessage(
        'Data Cotacao: ' + DateToStr(Item.DataCotacao) + sLineBreak +
        'Codigo Moeda: ' + IntToStr(Item.CodigoMoeda) + sLineBreak +
        'Tipo: ' + Item.Tipo + sLineBreak +
        'Moeda: ' + Item.Moeda + sLineBreak +
        'Nome: ' + Item.Nome + sLineBreak +
        'Cod Pais: ' + IntToStr(Item.CodPais) + sLineBreak +
        'Pais: ' + Item.Pais + sLineBreak +
        'Taxa Compra: ' + FloatToStr(Item.TaxaCompra) + sLineBreak +
        'Taxa Venda: ' + FloatToStr(Item.TaxaVenda) + sLineBreak +
        'Paridade Compra: ' + FloatToStr(Item.ParidadeCompra) + sLineBreak +
        'Paridade Venda: ' + FloatToStr(Item.ParidadeVenda)
      );
    end
    else
      raise Exception.Create('N�o foi encontrado nenhuma cota��o para a moeda informada!');
  end;
  
end;

procedure TfrmPrincipal.Label2Click(Sender: TObject);
begin
  OpenURL( Label2.Caption )
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  DateTimePicker1.DateTime := Date;
end;

end.
