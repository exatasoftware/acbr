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

unit ACBrTEFDDialScopeGetcard;

interface

uses
  Classes, SysUtils,
  ACBrTEFDClass, ACBrTEFComum;

const
  CACBrTEFDDial_ArqTemp   = 'C:\TEF_DIAL\req\intpos.tmp' ;
  CACBrTEFDDial_ArqReq    = 'C:\TEF_DIAL\req\intpos.001' ;
  CACBrTEFDDial_ArqResp   = 'C:\TEF_DIAL\resp\intpos.001' ;
  CACBrTEFDDial_ArqSTS    = 'C:\TEF_DIAL\resp\intpos.sts' ;
  CACBrTEFDDial_GPExeName = 'C:\TEF_DIAL\tef_dial.exe' ;

  CACBrTEFDVersaoInterface = '210';



type

  { TACBrTEFDRespScopeGetcard }

  TACBrTEFDRespScopeGetcard = class( TACBrTEFDRespTXT )
  public
    procedure ProcessarTipoInterno(ALinha: TACBrTEFLinha); override;
    procedure ConteudoToProperty; override;
  end;

  { TACBrTEFDDialScopeGetcard }

  TACBrTEFDDialScopeGetcard = class( TACBrTEFDClassTXT )
     //Importante: lembrar que o que o manual Scope chama de "suportar Troco" � na verdade "suportar Saque".
  private
    fSuportaViasDiferenciadas: Boolean;

  protected
    procedure AdicionarIdentificacao; override;
    procedure ProcessarResposta; override;
    procedure FinalizarRequisicao; override;

  public
    constructor Create(AOwner: TComponent); override;

  published
    property SuportaViasDiferenciadas: Boolean read fSuportaViasDiferenciadas write fSuportaViasDiferenciadas default True;
  end;

implementation

uses
  Math, ACBrTEFD;

{ TACBrTEFDDialScopeGetcard }

procedure TACBrTEFDDialScopeGetcard.AdicionarIdentificacao;
var
  Operacoes: Integer ;
  ComponenteACBrTEFD: TACBrTEFD;
begin
  ComponenteACBrTEFD := TACBrTEFD(Owner);
  // 733-000 Vers�o da interface n..3 Valor fixo, identificando a vers�o deste documento
  // implementada pela Automa��o Comercial (somente n�meros, por exemplo, 210 para �v2.10�)
  Req.Conteudo.GravaInformacao(733,000, CACBrTEFDVersaoInterface);

  if (ComponenteACBrTEFD.Identificacao.NomeAplicacao  <> '') then
    Req.Conteudo.GravaInformacao(735,000, ComponenteACBrTEFD.Identificacao.NomeAplicacao);

  if (ComponenteACBrTEFD.Identificacao.VersaoAplicacao <> '') then
    Req.Conteudo.GravaInformacao(736,000, ComponenteACBrTEFD.Identificacao.VersaoAplicacao);

  if (ComponenteACBrTEFD.Identificacao.RegistroCertificacao <> '') then
    Req.Conteudo.GravaInformacao(738,000, ComponenteACBrTEFD.Identificacao.RegistroCertificacao) ;

  if (ComponenteACBrTEFD.Identificacao.RazaoSocial <> '') then
    Req.Conteudo.GravaInformacao(716,000, ComponenteACBrTEFD.Identificacao.RazaoSocial)
  else if (ComponenteACBrTEFD.Identificacao.SoftwareHouse <> '') then
    Req.Conteudo.GravaInformacao(716,000, ComponenteACBrTEFD.Identificacao.SoftwareHouse);

  Operacoes := 0;
  if ComponenteACBrTEFD.AutoEfetuarPagamento then
  begin
    if ComponenteACBrTEFD.SuportaSaque and not ComponenteACBrTEFD.SuportaDesconto then
      Operacoes := Operacoes + 1
    else if ComponenteACBrTEFD.SuportaDesconto and (not ComponenteACBrTEFD.SuportaSaque) then
      Operacoes := Operacoes + 2;
  end
  else
  begin
    if ComponenteACBrTEFD.SuportaSaque then
      Operacoes := Operacoes + 1;  // 1: funcionalidade de troco (ver campo 708-000)

    if ComponenteACBrTEFD.SuportaDesconto then
      Operacoes := Operacoes + 2;  // 2: funcionalidade de desconto (ver campo 709-000)

//    if True then
    Operacoes := Operacoes + 4;  // 4: valor fixo, sempre incluir

    if SuportaViasDiferenciadas then
    begin
      Operacoes := Operacoes + 8;  // 8: vias diferenciadas do comprovante para Cliente/Estabelecimento (campos 712-000 a 715-000)
      if ComponenteACBrTEFD.ImprimirViaClienteReduzida then
        Operacoes := Operacoes + 16; // 16: cupom reduzido (campos 710-000 e 711-000)
    end;
  end;

  Req.Conteudo.GravaInformacao(706,000, IntToStr(Operacoes) ) ;
end;

constructor TACBrTEFDDialScopeGetcard.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ArqReq    := CACBrTEFDDial_ArqReq ;
  ArqResp   := CACBrTEFDDial_ArqResp ;
  ArqSTS    := CACBrTEFDDial_ArqSTS ;
  ArqTemp   := CACBrTEFDDial_ArqTemp ;
  GPExeName := CACBrTEFDDial_GPExeName ;
  fpTipo    := gpTefDialScopeGetcard;
  Name      := 'Dial_ScopeGetcard' ;

  fSuportaViasDiferenciadas := True;

  if Assigned(fpResp) then
    fpResp.Free ;

  fpResp := TACBrTEFDRespScopeGetcard.Create;
  fpResp.TipoGP := fpTipo;
end;

procedure TACBrTEFDDialScopeGetcard.FinalizarRequisicao;
begin
  VerificarIniciouRequisicao;

  // Se informou a DataHora, vamos informar no campo 717
  if Trim(Req.Conteudo.LeInformacao(22,0).AsString) <> '' then
    if (pos(Req.Header, 'CRT,CHQ,ADM,CNC,CNF,NCN') > 0) then
      Req.GravaInformacao(717,0, FormatDateTime('YYMMDDhhnnss', Req.DataHoraTransacaoComprovante) );

  inherited FinalizarRequisicao;
end;

procedure TACBrTEFDDialScopeGetcard.ProcessarResposta;
begin
  fpSalvarArquivoBackup := Resp.Confirmar;
  inherited ProcessarResposta;
end;

{ TACBrTEFDRespScopeGetcard }

procedure TACBrTEFDRespScopeGetcard.ConteudoToProperty;
var
  IndiceViaCliente, Linhas, I: Integer;
  ViasDeComprovante, TipoDeCartao, TipoDeFinanciamento, StatusConfirmacao: String;
  ImprimirViaCliente, ImprimirViaEstabelecimento, CupomReduzido: Boolean;

  function LinhasDaViaDoCliente( ViaReduzida: Boolean ): Integer;
  begin
    if ViaReduzida then
      Result := LeInformacao(710, 0).AsInteger     // 710-000 Linhas Via Reduzida Cliente
    else
      Result := LeInformacao(712, 0).AsInteger;    // 712-000 Tamanho Via Normal Cliente
  end;

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
    CupomReduzido := ViaClienteReduzida;
    Linhas := LinhasDaViaDoCliente( CupomReduzido );
    if (Linhas = 0) then  // Se n�o achou, veja se tem algo no outro tipo
    begin
      CupomReduzido := not CupomReduzido;
      Linhas := LinhasDaViaDoCliente( CupomReduzido );
    end;

    // Se n�o foi informado espec�fico, usar� Via Unica (029-000), j� carregada em TACBrTEFDRespTXT.ConteudoToProperty
    if (Linhas > 0) then
    begin
      if CupomReduzido then
        IndiceViaCliente := 711
      else
        IndiceViaCliente := 713;

      fpImagemComprovante1aVia.Clear;
      For I := 1 to Linhas do
        fpImagemComprovante1aVia.Add( AjustaLinhaImagemComprovante(LeInformacao(IndiceViaCliente, I).AsString) );
    end;
  end
  else
    fpImagemComprovante1aVia.Clear;

  fpQtdLinhasComprovante := Max(fpImagemComprovante1aVia.Count, fpImagemComprovante2aVia.Count);

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

  // 729-000 - Status da confirma��o
  //    1: transa��o n�o requer confirma��o, ou j� confirmada
  //    2: transa��o requer confirma��o
  //    Para manter compatibilidade com vers�es de especifica��o anteriores, caso este campo
  //    n�o esteja presente no arquivo de resposta, assumir que a transa��o requer confirma��o
  //    se houver comprovantes a serem impressos.

  StatusConfirmacao := Trim(LeInformacao(729,0).AsString);
  if (StatusConfirmacao <> '') then
    fpConfirmar := (StatusConfirmacao = '2');
end;

procedure TACBrTEFDRespScopeGetcard.ProcessarTipoInterno(ALinha: TACBrTEFLinha);
var
//  ARede: TACBrTEFPayGoRede;
  CodRede: Integer;
begin
  case ALinha.Identificacao of
    707 : fpValorOriginal := ALinha.Informacao.AsFloat;
    708 :
    begin
      //Chamado de troco
      fpSaque         := ALinha.Informacao.AsFloat;
    end;
    709 : fpDesconto      := ALinha.Informacao.AsFloat;
    727 : fpTaxaServico   := ALinha.Informacao.AsFloat;
    //716-000 Empresa De Automa��o
    //717-000 Data:Hora fiscal
    //718-000 N�mero l�gico do terminal
    //719-000 C�digo do estabelecimento
    //722-000 Dados Adicionais#1
    //723-000 Dados Adicionais#2
    //724-000 Dados Adicionais#3
    //725-000 Dados Adicionais#4
    //726-000 Idioma Do Cliente
    //728-000 Taxa De Embarque

  else
    inherited ProcessarTipoInterno(ALinha);
  end;
end;

end.

