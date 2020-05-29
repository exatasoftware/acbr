{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
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

{$I ACBr.inc}

unit ACBrTEFDPayGo;

interface

uses
  Classes, SysUtils, ACBrTEFDClass, ACBrTEFComum;

const
  CACBrTEFDPayGo_ArqTemp = 'C:\PAYGO\REQ\intpos.tmp';
  CACBrTEFDPayGo_ArqReq  = 'C:\PAYGO\REQ\intpos.001';
  CACBrTEFDPayGo_ArqResp = 'C:\PAYGO\RESP\intpos.001';
  CACBrTEFDPayGo_ArqSTS  = 'C:\PAYGO\RESP\intpos.sts';


type

  { TACBrTEFDRespPayGo }

  TACBrTEFDRespPayGo = class( TACBrTEFDRespTXT )
  protected
    procedure ProcessarTipoInterno(ALinha: TACBrTEFLinha); override;
  public
    procedure ConteudoToProperty; override;
  end;

  { TACBrTEFDPayGo }

  TACBrTEFDPayGo = class( TACBrTEFDClassTXT )
  private
    fSuportaReajusteValor : Boolean;
    fSuportaNSUEstendido: Boolean;
    fSuportaViasDiferenciadas: Boolean;

  protected
    procedure AdicionarIdentificacao; override;
    procedure ProcessarResposta; override;
    procedure FinalizarRequisicao; override;

  public
    constructor Create(AOwner: TComponent); override;

  published
    Property SuportaReajusteValor: Boolean read fSuportaReajusteValor write fSuportaReajusteValor default False;
    Property SuportaNSUEstendido: Boolean read fSuportaNSUEstendido write fSuportaNSUEstendido default True;
    Property SuportaViasDiferenciadas: Boolean read fSuportaViasDiferenciadas write fSuportaViasDiferenciadas default True;
  end;

implementation

uses
  math,
  ACBrTEFD;

{ TACBrTEFDRespPayGo }

procedure TACBrTEFDRespPayGo.ConteudoToProperty;
var
  IndiceViaCliente, Linhas, I: Integer;
  ViasDeComprovante, TipoDeCartao, TipoDeFinanciamento: String;
  ImprimirViaCliente, ImprimirViaEstabelecimento: Boolean;
begin
  inherited ConteudoToProperty;

  // 737-000 Vias de Comprovante
  //   1: imprimir somente a via do Cliente
  //   2: imprimir somente a via do Estabelecimento
  //   3: imprimir ambas as vias do Cliente e do Estabelecimento
  ViasDeComprovante := Trim(LeInformacao(737, 0).AsString);
  if (ViasDeComprovante = '') then
    ViasDeComprovante := '3';

  ImprimirViaCliente := (ViasDeComprovante = '1') or (ViasDeComprovante = '3');
  ImprimirViaEstabelecimento := (ViasDeComprovante = '2') or (ViasDeComprovante = '3');

  // Verificando Via do Estabelecimento
  if ImprimirViaEstabelecimento then
  begin
    Linhas := LeInformacao(714, 0).AsInteger;    // 714-000 Linhas Via Estabelecimento;
    if (Linhas > 0) then
    begin
      fpImagemComprovante2aVia.Clear;
      For I := 1 to Linhas do
        fpImagemComprovante2aVia.Add( AjustaLinhaImagemComprovante(LeInformacao(715, I).AsString) );
    end
    else
    begin
      // N�o informado espec�fico, usa Via Unica (029-000), lida em TACBrTEFDRespTXT.ConteudoToProperty
      fpImagemComprovante2aVia.Text := fpImagemComprovante1aVia.Text;
    end;
  end
  else
    fpImagemComprovante2aVia.Clear;

  // Verificando Via do Cliente
  if ImprimirViaCliente then
  begin
    IndiceViaCliente := 0;
    Linhas := LeInformacao(710, 0).AsInteger;    // 710-000 Linhas Via Reduzida Cliente
    if (Linhas > 0) then
      IndiceViaCliente := 711
    else
    begin
      Linhas := LeInformacao(712, 0).AsInteger;    // 712-000 Tamanho Via Cliente
      if (Linhas > 0) then
        IndiceViaCliente := 713;
    end;

    // Se n�o foi informado espec�fico, usar� Via Unica (029-000), j� carregada em TACBrTEFDRespTXT.ConteudoToProperty
    if (IndiceViaCliente > 0) and (Linhas > 0) then
    begin
      fpImagemComprovante1aVia.Clear;
      For I := 1 to Linhas do
        fpImagemComprovante1aVia.Add( AjustaLinhaImagemComprovante(LeInformacao(IndiceViaCliente, I).AsString) );
    end;
  end
  else
    fpImagemComprovante1aVia.Clear;

  fpQtdLinhasComprovante := max(fpImagemComprovante1aVia.Count, fpImagemComprovante2aVia.Count);

  // 731-000 - Tipo de cart�o
  //     0: qualquer / n�o definido (padr�o)
  //     1: cr�dito
  //     2: d�bito
  //     3: voucher
  TipoDeCartao := Trim(LeInformacao(731, 0).AsString);
  if (TipoDeCartao <> '') then
  begin
    fpCredito := (TipoDeCartao = '1');
    fpDebito  := (TipoDeCartao = '2');
  end;

  // 732-000 - Tipo de financiamento
  //     0: qualquer / n�o definido (padr�o)
  //     1: � vista
  //     2: parcelado pelo Emissor
  //     3: parcelado pelo Estabelecimento
  //     4: pr�-datado
  //     5: pr�-datado for�ado
  TipoDeFinanciamento := Trim(LeInformacao(732, 0).AsString);
  if (TipoDeFinanciamento <> '') then
  begin
    if (TipoDeFinanciamento = '1') then
    begin
      fpTipoOperacao := opAvista;
      fpParceladoPor := parcNenhum;
    end

    else if (TipoDeFinanciamento = '2') then
    begin
      fpTipoOperacao := opParcelado;
      fpParceladoPor := parcADM;
    end

    else if (TipoDeFinanciamento = '2') then
    begin
      fpTipoOperacao := opParcelado;
      fpParceladoPor := parcADM;
    end

    else if (TipoDeFinanciamento = '3') then
    begin
      fpTipoOperacao := opParcelado;
      fpParceladoPor := parcLoja;
    end

    else if (TipoDeFinanciamento = '4') or (TipoDeFinanciamento = '5') then
      fpTipoOperacao := opPreDatado;

  end;

  fpNFCeSAT.Autorizacao := fpNSU;
end;

procedure TACBrTEFDRespPayGo.ProcessarTipoInterno(ALinha: TACBrTEFLinha);
begin
  case ALinha.Identificacao of
    707 : fpValorOriginal := ALinha.Informacao.AsFloat;
    708 : fpSaque         := ALinha.Informacao.AsFloat;
    709 : fpDesconto      := ALinha.Informacao.AsFloat;
    727 : fpTaxaServico   := ALinha.Informacao.AsFloat;
    739 :
    begin
      // 739-000 �ndice da Rede Adquirente
      fpCodigoRedeAutorizada := ALinha.Informacao.AsString;
      fpNFCeSAT.CodCredenciadora := fpCodigoRedeAutorizada;
      //TODO: Criar tabela interna -> fpNFCeSAT.CNPJCredenciadora := LinStr;
    end;
    740 :
    begin
      // 740-000 - N�mero do cart�o, mascarado
      fpBin := ALinha.Informacao.AsString;
      fpNFCeSAT.UltimosQuatroDigitos := fpBin;
    end;
    741 :
    begin
      // 741-000 - Nome do Cliente, extra�do do cart�o ou informado pelo emissor.
      fpNFCeSAT.DonoCartao := ALinha.Informacao.AsString;
    end;
    747 :
    begin
      // 747-000 - Data de vencimento do cart�o (MMAA)
      fpNFCeSAT.DataExpiracao := ALinha.Informacao.AsString;
    end;
    748 :
    begin
      // 748-000 - Nome do cart�o padronizado. Se existir, substitui o 040-000
      fpNomeAdministradora := ALinha.Informacao.AsString;
      fpNFCeSAT.Bandeira := fpNomeAdministradora;
    end;
  else
    inherited ProcessarTipoInterno(ALinha);
  end;
end;

{ TACBrTEFDClass }

constructor TACBrTEFDPayGo.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ArqReq    := CACBrTEFDPayGo_ArqReq;
  ArqResp   := CACBrTEFDPayGo_ArqResp;
  ArqSTS    := CACBrTEFDPayGo_ArqSTS;
  ArqTemp   := CACBrTEFDPayGo_ArqTemp;
  GPExeName := '';
  fpTipo    := gpPayGo;
  Name      := 'PagGo' ;

  fSuportaNSUEstendido := True;
  fSuportaReajusteValor := False;
  fSuportaViasDiferenciadas := True;

  if Assigned(fpResp) then
    fpResp.Free ;

  fpResp := TACBrTEFDRespPayGo.Create;
  fpResp.TipoGP := fpTipo;
end;

procedure TACBrTEFDPayGo.AdicionarIdentificacao;
var
  Operacoes: Integer ;
begin
  with TACBrTEFD(Owner) do
  begin
    if (Identificacao.NomeAplicacao  <> '') then
      Req.Conteudo.GravaInformacao(735,000, Identificacao.NomeAplicacao);

    if (Identificacao.VersaoAplicacao <> '') then
      Req.Conteudo.GravaInformacao(736,000, Identificacao.VersaoAplicacao);

    if (Identificacao.RegistroCertificacao <> '') then
      Req.Conteudo.GravaInformacao(738,000, Identificacao.RegistroCertificacao) ;

    if (Identificacao.RazaoSocial <> '') then
      Req.Conteudo.GravaInformacao(716,000, Identificacao.RazaoSocial)
    else if (Identificacao.SoftwareHouse <> '') then
      Req.Conteudo.GravaInformacao(716,000, Identificacao.SoftwareHouse);

    Operacoes := 4;   // 4: valor fixo, sempre incluir

    if AutoEfetuarPagamento then
    begin
      if SuportaSaque and not SuportaDesconto then
        Operacoes := Operacoes + 1
      else if SuportaDesconto and not SuportaSaque then
        Operacoes := Operacoes + 2;
    end
    else
    begin
      if SuportaSaque then
        Operacoes := Operacoes + 1;  // 1: funcionalidade de troco (ver campo 708-000)

      if SuportaDesconto then
        Operacoes := Operacoes + 2;  // 2: funcionalidade de desconto (ver campo 709-000)

      if SuportaViasDiferenciadas then
      begin
        Operacoes := Operacoes + 8;  // 8: vias diferenciadas do comprovante para Cliente/Estabelecimento (campos 712-000 a 715-000)
        if ImprimirViaClienteReduzida then
          Operacoes := Operacoes + 16; // 16: cupom reduzido (campos 710-000 e 711-000)
      end;

      if SuportaReajusteValor then
      begin
        Operacoes := Operacoes + 32 +  // 32: funcionalidade de valor devido (ver campo 743-000)
                                 64 ;  // 64: funcionalidade de valor reajustado (ver campo 744-000)
      end;

      if SuportaNSUEstendido then     // 128: suporta NSU com tamanho de at� 40 caracteres (campos 012-000 e 025-000)
        Operacoes := Operacoes + 128;
    end;

    Req.Conteudo.GravaInformacao(706,000, IntToStr(Operacoes) ) ;
  end;
end;

procedure TACBrTEFDPayGo.ProcessarResposta;
var
  StatusConfirmacao: String;
begin
  StatusConfirmacao := Trim(Resp.LeInformacao(729,0).AsString);
  // 729-000 - Status da confirma��o
  //    1: transa��o n�o requer confirma��o, ou j� confirmada
  //    2: transa��o requer confirma��o
  //    Se n�o encontrado c

  if (StatusConfirmacao = '1') then
    fpSalvarArquivoBackup := False
  else if (StatusConfirmacao = '2') then
    fpSalvarArquivoBackup := True
  else
    fpSalvarArquivoBackup := (Resp.QtdLinhasComprovante > 0);

  inherited ProcessarResposta;
end;

procedure TACBrTEFDPayGo.FinalizarRequisicao;
begin
  VerificarIniciouRequisicao;

  // Se informou a DataHora, vamos informar no campo 717
  if Trim(Req.Conteudo.LeInformacao(22,0).AsString) <> '' then
    if (pos(Req.Header, 'CRT,CHQ,ADM,CNC,CNF,NCN') > 0) then
      Req.GravaInformacao(717,0, FormatDateTime('YYMMDDhhnnss', Req.DataHoraTransacaoComprovante) );

  inherited FinalizarRequisicao;
end;


end.




