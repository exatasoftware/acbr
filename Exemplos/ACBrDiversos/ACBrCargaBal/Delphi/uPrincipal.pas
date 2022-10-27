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

unit uPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ACBrCargaBal, ACBrBase, ComCtrls;

type
  TfrmPrincipal = class(TForm)
    ACBrCargaBal1: TACBrCargaBal;
    cbxModelo: TComboBox;
    edtDiretorio: TEdit;
    btnEscolherDiretorio: TButton;
    btnGerarArquivo: TButton;
    btnFechar: TButton;
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    lblStatus: TLabel;
    procedure btnFecharClick(Sender: TObject);
    procedure btnGerarArquivoClick(Sender: TObject);
    procedure btnEscolherDiretorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ACBrCargaBal1Progresso(Mensagem: String; ProgressoAtual,
      ProgressoTotal: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  FileCtrl, TypInfo;

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  I: TACBrCargaBalModelo;
begin
  edtDiretorio.Clear;

  cbxModelo.Items.Clear ;
  for I := Low(TACBrCargaBalModelo) to High(TACBrCargaBalModelo) do
    cbxModelo.Items.Add( GetEnumName(TypeInfo(TACBrCargaBalModelo), integer(I) ) ) ;

  cbxModelo.ItemIndex := 0;
end;

procedure TfrmPrincipal.btnEscolherDiretorioClick(Sender: TObject);
var
  Diretorio: String;
begin
  if SelectDirectory('Selecione o diret�rio onde ser�o gerados os arquivos:', '', Diretorio) then
    edtDiretorio.Text := Diretorio;
end;

procedure TfrmPrincipal.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPrincipal.btnGerarArquivoClick(Sender: TObject);
var
  I: Integer;
begin
  try
    // defini��o do modelo do arquivo, utilizado para padronizar o layout
    // conforme a balan�a para a qual se vai gerar o arquivo
    ACBrCargaBal1.Modelo := TACBrCargaBalModelo(cbxModelo.ItemIndex);

    // adi��o dos itens que ser�o gerados no arquivo
    ACBrCargaBal1.Produtos.Clear;

    for I := 0 to 1 do
    begin
      with ACBrCargaBal1.Produtos.New do
      begin
        ModeloEtiqueta  := 1;
        Tipo            := tpvPeso;
        Codigo          := I;
        Descricao       := Format('Descricao item %d', [I]);
        ValorVenda      := 1.23;
        Validade        := 15;
        CodigoFornecedor:=i;
        CodigoFracionador:=i;

        // Teclado
        Teclado.Codigo_Teclado := 0; // Preencher no caso de Toledo (C�digo do Teclado)
        Teclado.Pagina_Teclado := 0; // Preencher no caso de Toledo (Pagina do Teclado)
        Teclado.Tecla          := 0; // C�digo da Tecla
        InformacaoExtra.Receita := Format('Receita do item %d', [I]);
//        Nutricional     := Format('Informa��o Nutricional do item %d', [I]);;

        Nutricional.Codigo:=I;
        Nutricional.Qtd :=1;
        Nutricional.UndPorcao := tpGramas;
        Nutricional.PartInteira :=1;
        Nutricional.PartDecimal:= tpPara12;
        Nutricional.MedCaseira := tpColherSopa;
        Nutricional.ValorEnergetico := 20;
        Nutricional.Carboidrato := 2;
        Nutricional.Proteina := 3;
        Nutricional.GorduraTotal:= 4;
        Nutricional.GorduraSaturada:=5;
        Nutricional.GorduraTrans := 6;
        Nutricional.Fibra := 7;
        Nutricional.Sodio :=8;
        //RDC 429
        Nutricional.QtdeAutomaticaPorcao429:=True;
        Nutricional.QtdePorcEmb429:=1;
        Nutricional.QtdePorcao429:=2;
        Nutricional.UndPorcao429:=tpMililitros429;
        Nutricional.PartIntMedidaCaseira429:=3;
        Nutricional.PartDecMedidaCaseira429:=tpPara23_429;
        Nutricional.MedCaseira429:=tpUnidade429;
        Nutricional.ValorEnergetico429:=6;
        Nutricional.Carboidrato429:=7;
        Nutricional.AcucaresTotais429:=8;
        Nutricional.AcucaresAdicionados429:=9;
        Nutricional.Proteinas429:=10;
        Nutricional.GordurasTotais429:=11;
        Nutricional.GordurasSaturadas429:=12;
        Nutricional.GordurasTrans429:=13;
        Nutricional.FibraAlimentar429:=14;
        Nutricional.Sodio429:=15;
        Nutricional.AltoAcucar429:=1;
        Nutricional.AltoGordura429:=1;
        Nutricional.AltoSodio429:=1;
        Nutricional.Lactose429:=16;
        Nutricional.Galactose429:=17;

        Fornecedor.Codigo:=i;
        Fornecedor.Observacao:='observacao do fornecedor'+i.ToString;
        Fornecedor.Descricao1:='descricao 1 do fornecedor'+i.ToString;
        Fornecedor.Descricao2:='descricao 2 do fornecedor'+i.ToString;
        Fornecedor.Descricao3:='descricao 3 do fornecedor'+i.ToString;
        Fornecedor.Descricao4:='descricao 4 do fornecedor'+i.ToString;
        Fornecedor.Descricao5:='descricao 5 do fornecedor'+i.ToString;

        Fracionador.Codigo:=i;
        Fracionador.Observacao:='obs fracionador'+i.ToString;
        Fracionador.Descricao1:='desc1 fracionador'+i.ToString;
        Fracionador.Descricao2:='desc2 fracionador'+i.ToString;
        Fracionador.Descricao3:='desc3 fracionador'+i.ToString;

        Setor.Codigo    := 1;
        Setor.Descricao := 'GERAL';
      end;
    end;

    // gerar os arquivos para o diret�rio, informe somente o caminho do diret�rio
    ACBrCargaBal1.GerarArquivos(edtDiretorio.Text);
    ShowMessage('Arquivo gerado com sucesso!');
  except
    on E: Exception do
    begin
      // todo erro do componente levanta uma excess�o
      ShowMessage('Ocorreu o seguinte erro:' + sLineBreak + E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.ACBrCargaBal1Progresso(Mensagem: String;
  ProgressoAtual, ProgressoTotal: Integer);
begin
  lblStatus.Caption     := Mensagem;
  ProgressBar1.Max      := ProgressoTotal;
  ProgressBar1.Position := ProgressoAtual;

  Application.ProcessMessages;
end;

end.
