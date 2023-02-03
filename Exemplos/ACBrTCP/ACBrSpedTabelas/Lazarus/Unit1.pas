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

{$MODE Delphi}{$H+}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Grids, DBGrids, DB, BufDataset, StdCtrls, Buttons,
  ExtCtrls, ACBrBase, ACBrSpedTabelas, typinfo;

type

  { TForm1 }

  TForm1 = class(TForm)
    ACBrSpedTabelas1: TACBrSpedTabelas;
    BufDataset1: TBufDataset;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    BufDataset1Id: TStringField;
    BufDataset1Pacote: TStringField;
    BufDataset1Tipo: TStringField;
    BufDataset1Desc: TStringField;
    BufDataset1Versao: TStringField;
    BufDataset1DtCriacao: TDateField;
    BufDataset1DtVersao: TDateField;
    BufDataset1Hash: TStringField;
    Label1: TLabel;
    Panel1: TPanel;
    BtnListar: TBitBtn;
    BtnDow: TBitBtn;
    BtnDowT: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnListarClick(Sender: TObject);
    procedure BtnDowClick(Sender: TObject);
    procedure BtnDowTClick(Sender: TObject);
  private
    FID:string;
    FVersao :string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

{$R *.lfm}

procedure TForm1.BtnDowClick(Sender: TObject);
begin
  FId := BufDataset1.FieldByName('Id').AsString;
  FVersao := BufDataset1.FieldByName('Versao').AsString;

  ACBrSpedTabelas1.CodSistema := TACBrCodSistema( ComboBox1.ItemIndex ) ;
  if ACBrSpedTabelas1.Download(FId, FVersao, FId + FVersao + '.txt') then
    MessageDlg('Download comcluido com sucesso', mtInformation, [mbOK], 0)
  else
    MessageDlg('Falha ao efetuar o download', mtError, [mbOK], 0);
end;

procedure TForm1.BtnDowTClick(Sender: TObject);
var
  Ok, Ok1: boolean;
begin
  ACBrSpedTabelas1.CodSistema := TACBrCodSistema( ComboBox1.ItemIndex ) ;
  Ok := True;
  BufDataset1.First;
  while not BufDataset1.EOF do
  begin
    FId := BufDataset1.FieldByName('Id').AsString;
    FVersao := BufDataset1.FieldByName('Versao').AsString;
    Ok1 := ACBrSpedTabelas1.Download(FId, FVersao, FId + FVersao + '.txt');

    if Ok1 = False then
      Ok := False;

    BufDataset1.Next;
    Application.ProcessMessages;
  end;
  if Ok = True then
    MessageDlg('Download comcluido com sucesso', mtInformation, [mbOK], 0)
  else
    MessageDlg('Falha ao efetuar o download', mtError, [mbOK], 0);
end;

procedure TForm1.BtnListarClick(Sender: TObject);
var
  I: integer;
begin
  BufDataset1.First;
  while not(BufDataset1.EOF) do
    BufDataset1.Delete;

  ACBrSpedTabelas1.CodSistema := TACBrCodSistema( ComboBox1.ItemIndex ) ;
  ACBrSpedTabelas1.ListarTabelas;
  for I := 0 to ACBrSpedTabelas1.Tabelas.Count - 1 do
  begin
    BufDataset1.Append;

    BufDataset1Id.Value := ACBrSpedTabelas1.Tabelas[I].Id;
    BufDataset1Pacote.Value := ACBrSpedTabelas1.Tabelas[I].Pacote;
    BufDataset1Tipo.Value := ACBrSpedTabelas1.Tabelas[I].Tipo;
    BufDataset1Desc.Value := ACBrSpedTabelas1.Tabelas[I].Desc;
    BufDataset1Versao.Value := ACBrSpedTabelas1.Tabelas[I].Versao;
    BufDataset1DtCriacao.Value := ACBrSpedTabelas1.Tabelas[I].DtCriacao;
    BufDataset1DtVersao.Value := ACBrSpedTabelas1.Tabelas[I].DtVersao;
    BufDataset1Hash.Value := ACBrSpedTabelas1.Tabelas[I].Hash;


    BufDataset1.Post;
    Application.ProcessMessages;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
  BufDataset1.CreateDataset;
end;

procedure TForm1.FormCreate(Sender: TObject);
Var
  I: TACBrCodSistema ;
  AppDir: String ;
begin
  ComboBox1.Items.Clear ;
  For I := Low(TACBrCodSistema) to High(TACBrCodSistema) do
     ComboBox1.Items.Add( GetEnumName(TypeInfo(TACBrCodSistema), integer(I) ) ) ;
  ComboBox1.ItemIndex := 0 ;
end;

end.
