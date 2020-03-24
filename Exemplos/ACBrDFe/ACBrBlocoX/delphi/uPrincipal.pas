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
  Windows, Messages, SysUtils, Variants, Classes, Controls, StdCtrls, Forms, Clipbrd,
  Dialogs, Buttons, ACBrBase, ACBrDFe, ACBrBlocoX, ACBrBlocoX_WebServices;

type
  TfrmPrincipal = class(TForm)
    btnGerarXMLEstoque: TButton;
    ACBrBlocoX1: TACBrBlocoX;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    btnGerarXMLRZ: TButton;
    SaveDialog1: TSaveDialog;
    btnValidarEnviarXML: TButton;
    OpenDialog1: TOpenDialog;
    btnConsultarProcArquivo: TButton;
    edtRecibo: TEdit;
    Label3: TLabel;
    mmoRetWS: TMemo;
    Label4: TLabel;
    btnReprocArquivo: TButton;
    btnDownloadArquivo: TButton;
    edtMotivo: TEdit;
    Label5: TLabel;
    btnCancArquivo: TButton;
    Label6: TLabel;
    edtNumSerie: TEdit;
    procedure btnGerarXMLEstoqueClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnGerarXMLRZClick(Sender: TObject);
    procedure btnValidarEnviarXMLClick(Sender: TObject);
    procedure btnConsultarProcArquivoClick(Sender: TObject);
    procedure btnReprocArquivoClick(Sender: TObject);
    procedure btnDownloadArquivoClick(Sender: TObject);
    procedure btnCancArquivoClick(Sender: TObject);
    procedure ACBrBlocoX1AntesDeAssinar(var ConteudoXML: string;
      const docElement, infElement, SignatureNode, SelectionNamespaces,
      IdSignature: string);
  private
    procedure PreencherCabecalho(const AACBrBlocoX: TACBrBlocoX);
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  ACBrBlocoX_Comum;

{$R *.dfm}

procedure TfrmPrincipal.PreencherCabecalho(const AACBrBlocoX: TACBrBlocoX);
begin
  with AACBrBlocoX do
  begin
    Configuracoes.Certificados.NumeroSerie := Edit1.Text;
    Configuracoes.Certificados.Senha       := Edit2.Text;

    Estabelecimento.Ie              := '123456789';
    Estabelecimento.Cnpj            := '99999999999999';
    Estabelecimento.NomeEmpresarial := 'NOME EMPRESARIAL';

    PafECF.Versao                       := '01.01.01';
    PafECF.NumeroCredenciamento         := '123456789012345';
    PafECF.NomeComercial                := 'NOME COMERCIAL';
    PafECF.NomeEmpresarialDesenvolvedor := 'NOME EMPRESARIAL DO DESENVOLVEDOR';
    PafECF.CnpjDesenvolvedor            := '88888888888888';
  end;
end;

procedure TfrmPrincipal.btnDownloadArquivoClick(Sender: TObject);
begin
  if edtRecibo.Text = EmptyStr then
    Raise Exception.Create('Informe o recibo do arquivo transmitido antes de continuar!');
  with ACBrBlocoX1 do
  begin
    mmoRetWS.Clear;

    DownloadArquivo.Recibo := Trim(edtRecibo.Text);
    DownloadArquivo.GerarXML(True);

    //Clipboard.AsText := DownloadArquivo.XMLAssinado;

    with (WebServices) do
    begin
      DownloadArquivoBlocoX.XML := DownloadArquivo.XMLAssinado;
      DownloadArquivoBlocoX.UsarCData := True;
      if DownloadArquivoBlocoX.Executar then
      begin
        mmoRetWS.Lines.Text := DownloadArquivoBlocoX.RetWS;
        Clipboard.AsText := DownloadArquivoBlocoX.BlocoXRetorno.Arquivo;
        {Base decodificar e gerar o arquivo .zip, o retorno vem em base64

         URL para decodifica��o online:
         https://www.motobit.com/util/base64-decoder-encoder.asp

         By: Marcos Fincotto
        }
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnGerarXMLEstoqueClick(Sender: TObject);
var
  I: Integer;
begin
  if SaveDialog1.Execute then
  begin
    with ACBrBlocoX1 do
    begin
      PreencherCabecalho(ACBrBlocoX1);

      // arquivo de Estoque
      with Estoque do
      begin
        DataReferencia := DATE;

        Produtos.Clear;
        for I := 1 to 10 do
        begin
          with Produtos.Add do
          begin
            Codigo.Tipo             := tpcGTIN;
            Codigo.CodigoGTIN       := '7891234567891';
            Codigo.CodigoNCMSH      := '11041900';
            Descricao               := 'PRODUTO TESTE ' + IntToStr(I);
            ValorUnitario           := 1.23;
            Ippt                    := ipptTerceiros;
            SituacaoTributaria      := stTributado;
            Aliquota                := 12;
            Unidade                 := 'UN';
            Quantidade              := 1234;
            IndicadorArredondamento := False;
          end;
        end;

        SaveToFile(SaveDialog1.FileName);
        ShowMessage('terminado');
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnGerarXMLRZClick(Sender: TObject);
var
  I, X: Integer;
begin
  if SaveDialog1.Execute then
  begin
    with ACBrBlocoX1 do
    begin
      PreencherCabecalho(ACBrBlocoX1);

      ECF.NumeroFabricacao := 'BR1234567891234579';
      ECF.Tipo             := 'ECF-IF';
      ECF.Marca            := 'MARCA ECF';
      ECF.Modelo           := 'MODELO ECF';
      ECF.Versao           := '010101';

      with ReducoesZ do
      begin
        ReducoesZ.DataReferencia   := DATE;
        ReducoesZ.CRZ              := 1;
        ReducoesZ.COO              := 1;
        ReducoesZ.CRO              := 1;
        ReducoesZ.VendaBrutaDiaria := 3456.78;
        ReducoesZ.GT               := 123456789.45;

        TotalizadoresParciais.Clear;
        for I := 1 to 2 do
        begin
          with TotalizadoresParciais.Add do
          begin
            Identificacao := '0'+IntToStr(i-1)+'T1234';
            Valor       := 1234.56;

            for X := 1 to 2 do
            begin
              with Produtos.Add do
              begin
                Codigo.Tipo   := tpcProprio;
                Codigo.CodigoProprio := IntToStr(X);
                Codigo.CodigoNCMSH := '11041900';
                Descricao     := 'PRODUTO ' + IntToStr(X);
                Quantidade    := 1234556;
                Unidade       := 'UN';
                ValorUnitario := 1234.99;
              end;
            end;

            for X := 1 to 2 do
            begin
              with Servicos.Add do
              begin
                Codigo.Tipo   := tpcProprio;
                Codigo.CodigoProprio := IntToStr(X);
                Codigo.CodigoNCMSH := '11041900';
                Descricao     := 'SERVICO ' + IntToStr(X);
                Quantidade    := 1234556;
                Unidade       := 'UN';
                ValorUnitario := 1234.99;
              end;
            end;
          end;
        end;

        SaveToFile(SaveDialog1.FileName);
        ShowMessage('terminado');
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnReprocArquivoClick(Sender: TObject);
const
  MotivoReprocessamentoCancelamento = 'Falha na transmiss�o do arquivo BlocoX';
begin
  if edtRecibo.Text = EmptyStr then
    Raise Exception.Create('Informe o recibo do arquivo transmitido antes de continuar!');
  with ACBrBlocoX1 do
  begin
    mmoRetWS.Clear;

    ReprocessarArquivo.Recibo := Trim(edtRecibo.Text);
    ReprocessarArquivo.Motivo := MotivoReprocessamentoCancelamento;
    ReprocessarArquivo.GerarXML(True);

    //Clipboard.AsText := ReprocessarArquivo.XMLAssinado;

    with (WebServices) do
    begin
      ReprocessarArquivoBlocoX.XML := ReprocessarArquivo.XMLAssinado;
      ReprocessarArquivoBlocoX.UsarCData := True;
      if ReprocessarArquivoBlocoX.Executar then
      begin
        mmoRetWS.Lines.Text := ReprocessarArquivoBlocoX.RetWS;
        {with ReprocessarArquivoBlocoX.BlocoXRetorno do
        begin
          ShowMessage(SituacaoProcStr);
        end;}
      end;
    end;
  end;
end;

procedure TfrmPrincipal.btnValidarEnviarXMLClick(Sender: TObject);
var
  RespostaValidacao: string;
  Arquivo: TStringList;
  TextoArquivo: string;
begin
  if OpenDialog1.Execute then
  begin
    Arquivo := TStringList.Create;
    try
      Arquivo.LoadFromFile(OpenDialog1.FileName);
      TextoArquivo := Arquivo.Text;
    finally
      Arquivo.Free;
    end;

      // Webservice de Valida��o n�o est� mais dispon�vel
//    ACBrBlocoX1.WebServices.ValidarBlocoX.Clear;
//    ACBrBlocoX1.WebServices.ValidarBlocoX.XML := TextoArquivo;
//
//    ACBrBlocoX1.WebServices.ValidarBlocoX.Executar;
//    RespostaValidacao := ACBrBlocoX1.WebServices.ValidarBlocoX.RetWS;
//
//    if not (Pos('VALIDADO COM SUCESSO', UpperCase(RespostaValidacao)) > 0) then
//      raise Exception.Create(RespostaValidacao);
//
//    ShowMessage(RespostaValidacao);

    ACBrBlocoX1.WebServices.TransmitirArquivoBlocoX.Clear;
    ACBrBlocoX1.WebServices.TransmitirArquivoBlocoX.XML := TextoArquivo;

    if ACBrBlocoX1.WebServices.TransmitirArquivoBlocoX.Executar then
    begin
      ShowMessage(
        'Arquivo enviado com sucesso!' +
        sLineBreak +
        sLineBreak +
        ACBrBlocoX1.WebServices.TransmitirArquivoBlocoX.RetWS
      );
    end
    else
    begin
      raise Exception.Create(
        'N�o foi poss�vel transmitir o arquivo!' + sLineBreak +
        ACBrBlocoX1.WebServices.TransmitirArquivoBlocoX.RetWS
      );
    end;
  end;


end;

procedure TfrmPrincipal.ACBrBlocoX1AntesDeAssinar(var ConteudoXML: string;
  const docElement, infElement, SignatureNode, SelectionNamespaces,
  IdSignature: string);
begin
  with ACBrBlocoX1.Configuracoes.Certificados do
  begin
    if NumeroSerie = EmptyStr then
      NumeroSerie := Trim(edtNumSerie.Text);
  end;
end;

procedure TfrmPrincipal.btnCancArquivoClick(Sender: TObject);
begin
  if edtRecibo.Text = EmptyStr then
    Raise Exception.Create('Informe o recibo do arquivo transmitido antes de continuar!');

  mmoRetWS.Clear;

  ACBrBlocoX1.ConsultarProcessamentoArquivo.Recibo := Trim(edtRecibo.Text);
  ACBrBlocoX1.ConsultarProcessamentoArquivo.RemoverEncodingXMLAssinado := True;
  ACBrBlocoX1.ConsultarProcessamentoArquivo.GerarXML(True);

  ACBrBlocoX1.WebServices.ConsultarProcessamentoArquivoBlocoX.XML := ACBrBlocoX1.ConsultarProcessamentoArquivo.XMLAssinado;
  ACBrBlocoX1.WebServices.ConsultarProcessamentoArquivoBlocoX.UsarCData := True;
  if ACBrBlocoX1.WebServices.ConsultarProcessamentoArquivoBlocoX.Executar then
  begin
    mmoRetWS.Lines.Text := ACBrBlocoX1.WebServices.ConsultarProcessamentoArquivoBlocoX.RetWS;
    with ACBrBlocoX1.WebServices.ConsultarProcessamentoArquivoBlocoX do
    begin
      with BlocoXRetorno do
        if not SituacaoProcCod = 0 then
          Raise Exception.Create('Recibo com situa��o diferente de "Sucesso" n�o pode ser cancelado: ' + SituacaoProcStr);
      ACBrBlocoX1.CancelarArquivo.Recibo := Trim(edtRecibo.Text);
      ACBrBlocoX1.CancelarArquivo.Motivo := Trim(edtMotivo.Text);
      ACBrBlocoX1.CancelarArquivo.RemoverEncodingXMLAssinado := True;
      ACBrBlocoX1.CancelarArquivo.GerarXML(True);
      ACBrBlocoX1.WebServices.CancelarArquivoBlocoX.XML := ACBrBlocoX1.CancelarArquivo.XMLAssinado;
      ACBrBlocoX1.WebServices.CancelarArquivoBlocoX.UsarCData := True;
      if ACBrBlocoX1.WebServices.CancelarArquivoBlocoX.Executar then
        mmoRetWS.Lines.Text := ACBrBlocoX1.WebServices.CancelarArquivoBlocoX.RetWS;
    end;
  end;
end;

procedure TfrmPrincipal.btnConsultarProcArquivoClick(Sender: TObject);
begin
  if edtRecibo.Text = EmptyStr then
    Raise Exception.Create('Informe o recibo do arquivo transmitido antes de continuar!');
  with ACBrBlocoX1 do
  begin
    mmoRetWS.Clear;

    ConsultarProcessamentoArquivo.Recibo := Trim(edtRecibo.Text);
    ConsultarProcessamentoArquivo.RemoverEncodingXMLAssinado := True;
    ConsultarProcessamentoArquivo.GerarXML(True);

    //  XML Assinado
    //ConsultarProcessamentoArquivo.XMLAssinado;

    WebServices.ConsultarProcessamentoArquivoBlocoX.XML := ACBrBlocoX1.ConsultarProcessamentoArquivo.XMLAssinado;
    WebServices.ConsultarProcessamentoArquivoBlocoX.UsarCData := True;
    if WebServices.ConsultarProcessamentoArquivoBlocoX.Executar then
    begin
      mmoRetWS.Lines.Text := WebServices.ConsultarProcessamentoArquivoBlocoX.RetWS;
      with WebServices.ConsultarProcessamentoArquivoBlocoX do
      begin
        {with BlocoXRetorno do
        begin
          ShowMessage(Recibo);
          ShowMessage(IntToStr(SituacaoProcCod));
          ShowMessage(SituacaoProcStr);
        end;}
      end;
    end;
  end;
end;

procedure TfrmPrincipal.SpeedButton1Click(Sender: TObject);
begin
  Edit1.Text := ACBrBlocoX1.SSL.SelecionarCertificado;
  edtNumSerie.Text := ACBrBlocoX1.Configuracoes.Certificados.NumeroSerie;
end;

end.
