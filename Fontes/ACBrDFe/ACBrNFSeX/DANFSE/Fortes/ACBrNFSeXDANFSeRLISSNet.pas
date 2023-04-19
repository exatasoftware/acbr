{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Fabio Pasquali                                  }
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
{                                                                              }
{ O formato desta nota segue o padr�o emitido pela NotaControl no DF           }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrNFSeXDANFSeRLISSNet;

interface

uses
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  ExtCtrls,
  RLFilters,
  RLPDFFilter,
  RLReport,
  ACBrDelphiZXingQRCode,
  ACBrNFSeXConversao,
  ACBrNFSeXDANFSeRL, ACBrBase, ACBrDFe, ACBrNFSeX, Types;

type

  { TfrlXDANFSeRLRetrato }

  { TfrlXDANFSeRLISSnet }

  TfrlXDANFSeRLISSnet = class(TfrlXDANFSeRL)
    rlbCabecalho: TRLBand;
    rllNumNF0: TRLLabel;
    rliLogo: TRLImage;
    rlbPrestador: TRLBand;
    RLLabel30: TRLLabel;
    RLLabel32: TRLLabel;
    rllPrestInscMunicipal: TRLLabel;
    rllPrestCNPJ: TRLLabel;
    rliPrestLogo: TRLImage;
    rllPrestNome: TRLLabel;
    rlbTomador: TRLBand;
    rllTomaCNPJ: TRLLabel;
    RLLabel11: TRLLabel;
    rllTomaInscMunicipal: TRLLabel;
    RLLabel15: TRLLabel;
    rllTomaNome: TRLLabel;
    RLLabel17: TRLLabel;
    rllTomaEndereco: TRLLabel;
    RLLabel19: TRLLabel;
    rllTomaMunicipio: TRLLabel;
    RLLabel21: TRLLabel;
    rllTomaUF: TRLLabel;
    RLLabel10: TRLLabel;
    rllTomaEmail: TRLLabel;
    RLLabel25: TRLLabel;
    rllTomaComplemento: TRLLabel;
    RLLabel27: TRLLabel;
    rllTomaTelefone: TRLLabel;
    rlbHeaderItens: TRLBand;
    rlbItens: TRLBand;
    rlbISSQN: TRLBand;
    rllBaseCalc: TRLLabel;
    rllValorISS: TRLLabel;
    rllAliquota: TRLLabel;
    rllValorCOFINS: TRLLabel;
    rllValorIR: TRLLabel;
    rllValorINSS: TRLLabel;
    rllValorCSLL: TRLLabel;
    rllValorServicos1: TRLLabel;
    rllDescIncondicionado1: TRLLabel;
    rllDescCondicionado: TRLLabel;
    rllOutrasRetencoes: TRLLabel;
    rllValorIssRetido: TRLLabel;
    rllValorLiquido: TRLLabel;
    rllValorDeducoes: TRLLabel;
    rllISSReter: TRLLabel;
    rbOutrasInformacoes: TRLBand;
    rlmDadosAdicionais: TRLMemo;
    rlbCanhoto: TRLBand;
    RLLabel26: TRLLabel;
    rllPrestNomeEnt: TRLLabel;
    RLLabel28: TRLLabel;
    RLDraw1: TRLDraw;
    RLLabel57: TRLLabel;
    RLLabel33: TRLLabel;
    RLDraw5: TRLDraw;
    RLLabel58: TRLLabel;
    RLLabel59: TRLLabel;
    RLDraw7: TRLDraw;
    RLLabel61: TRLLabel;
    rllTomaInscEstadual: TRLLabel;
    rlmDescricao: TRLMemo;
    rlbHeaderItensDetalhado: TRLBand;
    RLLabel65: TRLLabel;
    RLLabel66: TRLLabel;
    RLLabel67: TRLLabel;
    RLLabel68: TRLLabel;
    subItens: TRLSubDetail;
    rlbItensServico: TRLBand;
    txtServicoQtde: TRLLabel;
    rlmServicoDescricao: TRLMemo;
    txtServicoUnitario: TRLLabel;
    txtServicoTotal: TRLLabel;
    RLLabel69: TRLLabel;
    rllPrestInscEstadual: TRLLabel;
    RLBand1: TRLBand;
    rllDataHoraImpressao: TRLLabel;
    rllSistema: TRLLabel;
    rlmPrefeitura1: TRLLabel;
    rlmPrefeitura2: TRLLabel;
    rlmPrefeitura3: TRLLabel;
    RLDraw18: TRLDraw;
    RLDraw19: TRLDraw;
    RLLabel73: TRLLabel;
    RLMemo1: TRLMemo;
    RLLabel74: TRLLabel;
    RLLabel75: TRLLabel;
    RLDraw20: TRLDraw;
    RLDraw12: TRLDraw;
    RLDraw21: TRLDraw;
    RLDraw22: TRLDraw;
    RLDraw23: TRLDraw;
    RLDraw24: TRLDraw;
    RLLabel1: TRLLabel;
    RLLabel22: TRLLabel;
    RLLabel31: TRLLabel;
    RLLabel76: TRLLabel;
    rlImgQrCode: TRLImage;
    rllEmissao: TRLLabel;
    rllCompetencia: TRLLabel;
    rllCodVerificacao: TRLLabel;
    RLDraw2: TRLDraw;
    RLLabel7: TRLLabel;
    RLLabel4: TRLLabel;
    rllTomaCEP: TRLLabel;
    RLLabel8: TRLLabel;
    rlbDadosNota: TRLBand;
    RLDraw3: TRLDraw;
    RLLabel88: TRLLabel;
    RLDraw8: TRLDraw;
    RLDraw9: TRLDraw;
    RLDraw10: TRLDraw;
    RLDraw11: TRLDraw;
    RLDraw25: TRLDraw;
    RLLabel12: TRLLabel;
    RLLabel13: TRLLabel;
    rllNumeroRPS: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel18: TRLLabel;
    RLLabel20: TRLLabel;
    rllDataRPS: TRLLabel;
    RLLabel60: TRLLabel;
    rllLocalServico: TRLLabel;
    RLLabel62: TRLLabel;
    rllMunicipioIncidencia: TRLLabel;
    RLLabel44: TRLLabel;
    RLDraw13: TRLDraw;
    RLDraw26: TRLDraw;
    RLDraw27: TRLDraw;
    RLLabel63: TRLLabel;
    rllAtividade: TRLLabel;
    RLDraw28: TRLDraw;
    RLLabel64: TRLLabel;
    RLDraw29: TRLDraw;
    RLLabel77: TRLLabel;
    rllItem: TRLLabel;
    RLLabel78: TRLLabel;
    rllCodNBS: TRLLabel;
    RLDraw30: TRLDraw;
    RLLabel79: TRLLabel;
    rllCodCNAE: TRLLabel;
    RLDraw31: TRLDraw;
    RLLabel81: TRLLabel;
    RLDraw32: TRLDraw;
    RLLabel47: TRLLabel;
    RLDraw34: TRLDraw;
    RLLabel82: TRLLabel;
    RLDraw35: TRLDraw;
    RLLabel83: TRLLabel;
    RLDraw36: TRLDraw;
    RLLabel84: TRLLabel;
    RLDraw37: TRLDraw;
    RLLabel85: TRLLabel;
    RLDraw33: TRLDraw;
    RLLabel80: TRLLabel;
    RLLabel94: TRLLabel;
    RLDraw39: TRLDraw;
    RLLabel95: TRLLabel;
    RLDraw40: TRLDraw;
    RLLabel96: TRLLabel;
    RLDraw41: TRLDraw;
    RLLabel97: TRLLabel;
    RLDraw42: TRLDraw;
    RLLabel98: TRLLabel;
    RLDraw43: TRLDraw;
    RLLabel99: TRLLabel;
    RLDraw44: TRLDraw;
    RLLabel100: TRLLabel;
    rllValorPIS: TRLLabel;
    RLDraw45: TRLDraw;
    RLLabel86: TRLLabel;
    rllNatOperacao: TRLLabel;
    RLLabel3: TRLLabel;
    RLDraw4: TRLDraw;
    rllPrestFantasia: TRLLabel;
    rbConstrucao: TRLBand;
    rllTituloConstCivil: TRLLabel;
    rllCodigoObra: TRLLabel;
    rllCodObra: TRLLabel;
    rllCodigoArt: TRLLabel;
    rllCodART: TRLLabel;
    rllMsgTeste: TRLLabel;
    rllSite: TRLLabel;
    rllPrestEndereco: TRLMemo;
    lbIdentificacao: TRLLabel;
    rllTomadorNomeEnt: TRLLabel;
    rllNumNF0Ent: TRLLabel;

    procedure rlbCabecalhoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensServicoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbPrestadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbTomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbISSQNBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rbOutrasInformacoesBeforePrint(Sender: TObject;
      var PrintIt: Boolean);
    procedure RLNFSeBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure subItensDataRecord(Sender: TObject; RecNo: Integer;
      CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure rlbDadosNotaBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rbConstrucaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBand1BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    { Private declarations }
    FNumItem: Integer;
    function ManterAliquota(dAliquota: Double): String;
  public
    { Public declarations }
    class procedure QuebradeLinha(const sQuebradeLinha: String); override;
  end;

var
  frlXDANFSeRLISSnet: TfrlXDANFSeRLISSnet;

implementation

uses
  StrUtils, DateUtils,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrDFeUtil,
  ACBrNFSeXClass, ACBrNFSeXInterface,
  ACBrValidador, ACBrDFeReportFortes;

{$IFNDEF FPC}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

var
  FQuebradeLinha: String;

  { TfrlXDANFSeRLRetrato }

class procedure TfrlXDANFSeRLISSnet.QuebradeLinha(const sQuebradeLinha: String);
begin
  FQuebradeLinha := sQuebradeLinha;
end;

procedure TfrlXDANFSeRLISSnet.rbConstrucaoBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  with fpNFSe do
  begin
    rllCodObra.Caption := ConstrucaoCivil.CodigoObra;
    rllCodART.Caption := ConstrucaoCivil.Art;
  end;

  rllMsgTeste.Visible := (fpDANFSe.Producao = snNao);
  rllMsgTeste.Enabled := (fpDANFSe.Producao = snNao);

  if fpDANFSe.Cancelada or (fpNFSe.NfseCancelamento.DataHora <> 0) or
    (fpNFSe.SituacaoNfse = snCancelado) or (fpNFSe.StatusRps = srCancelado) then
  begin
    rllMsgTeste.Caption := 'NFS-e CANCELADA';
    rllMsgTeste.Visible := True;
    rllMsgTeste.Enabled := True;
  end;

  rllMsgTeste.Repaint;

  PrintIt := (rllCodObra.Caption <> '') or (rllCodART.Caption <> '') or rllMsgTeste.Visible;
end;

procedure TfrlXDANFSeRLISSnet.rbOutrasInformacoesBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  rlmDadosAdicionais.Lines.BeginUpdate;
  rlmDadosAdicionais.Lines.Clear;

  if fpDANFSe.OutrasInformacaoesImp <> '' then
    rlmDadosAdicionais.Lines.Add(StringReplace(fpDANFSe.OutrasInformacaoesImp, FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]))
  else
    if fpNFSe.OutrasInformacoes <> '' then
    rlmDadosAdicionais.Lines.Add(StringReplace(fpNFSe.OutrasInformacoes, FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]));

  if fpNFSe.InformacoesComplementares <> '' then
    rlmDadosAdicionais.Lines.Add(StringReplace(fpNFSe.InformacoesComplementares, FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]));

  rlmDadosAdicionais.Lines.EndUpdate;
  rllDataHoraImpressao.Caption := Format(ACBrStr('DATA E HORA DA IMPRESS�O: %s'), [FormatDateTime('dd/mm/yyyy hh:nn', Now)]);

  if fpDANFSe.Usuario <> '' then
    rllDataHoraImpressao.Caption := Format(ACBrStr('%s   USU�RIO: %s'), [rllDataHoraImpressao.Caption, fpDANFSe.Usuario]);

  // imprime sistema
  if fpDANFSe.Sistema <> '' then
    rllSistema.Caption := Format('Desenvolvido por %s', [fpDANFSe.Sistema])
  else
    rllSistema.Caption := '';

  // Exibe canhoto
  rlbCanhoto.Visible := fpDANFSe.ImprimeCanhoto;
end;

procedure TfrlXDANFSeRLISSnet.RLBand1BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  rllSite.Caption := fpDANFSe.Site;
end;

procedure TfrlXDANFSeRLISSnet.rlbCabecalhoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  strPrefeitura: TSplitResult;
begin
  inherited;

  With fpNFSe do
  begin
    TDFeReportFortes.CarregarLogo(rliLogo, fpDANFSe.Logo);

    rllNumNF0.Caption := Numero;

    // Somente as 3 primeiras linhas ser�o utilizadas
    strPrefeitura := ACBrUtil.Strings.Split(FQuebradeLinha[1], fpDANFSe.Prefeitura);

    if (Length(strPrefeitura) >= 1) then
      rlmPrefeitura1.Caption := strPrefeitura[0];

    if (Length(strPrefeitura) >= 2) then
      rlmPrefeitura2.Caption := strPrefeitura[1];

    if (Length(strPrefeitura) >= 3) then
      rlmPrefeitura3.Caption := strPrefeitura[2];
  end;
end;

procedure TfrlXDANFSeRLISSnet.rlbDadosNotaBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  CodigoIBGE: Integer;
  xUF: string;
  FProvider: IACBrNFSeXProvider;
begin
  inherited;

  FProvider := ACBrNFSe.Provider;

  With fpNFSe do
  begin
    rllNatOperacao.Caption := ACBrStr(FProvider.NaturezaOperacaoDescricao(NaturezaOperacao));
    rllNumeroRPS.Caption := IdentificacaoRps.Numero;
    rllDataRPS.Caption := FormatDateTime('dd/mm/yyyy', DataEmissaoRps);

    // Ser� necess�rio uma analise melhor para saber em que condi��es devemos usar o c�digo do municipio
    // do tomador em vez do que foi informado em Servi�o.
    CodigoIBGE := StrToIntDef(Servico.CodigoMunicipio, 0);
    xUF := '';
    rllLocalServico.Caption := ObterNomeMunicipio(CodigoIBGE, xUF, '', False) + ' - ' + xUF;
    rllMunicipioIncidencia.Caption := ObterNomeMunicipio(Servico.MunicipioIncidencia, xUF, '', False) + ' - ' + xUF;
  end;
end;

procedure TfrlXDANFSeRLISSnet.rlbItensServicoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  with fpNFSe.Servico.ItemServico.Items[FNumItem] do
  begin
    txtServicoQtde.Caption := FormatFloatBr(Quantidade);
    rlmServicoDescricao.Lines.Clear;
    rlmServicoDescricao.Lines.Add(StringReplace(Descricao, FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]));
    txtServicoUnitario.Caption := FormatFloatBr(ValorUnitario);

    if ValorTotal = 0.0 then
      ValorTotal := Quantidade * ValorUnitario;

    txtServicoTotal.Caption := FormatFloatBr(ValorTotal);
  end;
end;

procedure TfrlXDANFSeRLISSnet.rlbISSQNBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  FProvider: IACBrNFSeXProvider;
begin
  inherited;

  FProvider := ACBrNFSe.Provider;

  with fpNFSe do
    with Servico.Valores do
    begin
      rllAtividade.Caption := fpNFSe.DescricaoCodigoTributacaoMunicipio;
      rllItem.Caption := Servico.ItemListaServico;
      rllCodNBS.Caption := Servico.CodigoNBS;
      rllCodCNAE.Caption := Servico.CodigoCnae;

      rllAliquota.Caption := ManterAliquota(Aliquota);
      rllValorServicos1.Caption := FormatCurr('R$ ,0.00', ValorServicos);
      rllDescIncondicionado1.Caption := FormatCurr('R$ ,0.00', DescontoIncondicionado);
      rllValorDeducoes.Caption := FormatCurr('R$ ,0.00', ValorDeducoes);
      rllBaseCalc.Caption := FormatCurr('R$ ,0.00', BaseCalculo);
      rllValorISS.Caption := FormatCurr('R$ ,0.00', ValorIss);
      rllISSReter.Caption := FProvider.SituacaoTributariaDescricao(IssRetido);
      rllDescCondicionado.Caption := FormatCurr('R$ ,0.00', DescontoCondicionado);
      rllValorPIS.Caption := FormatCurr('R$ ,0.00', ValorPis);
      rllValorCOFINS.Caption := FormatCurr('R$ ,0.00', ValorCofins);
      rllValorIR.Caption := FormatCurr('R$ ,0.00', ValorIr);
      rllValorINSS.Caption := FormatCurr('R$ ,0.00', ValorInss);
      rllValorCSLL.Caption := FormatCurr('R$ ,0.00', ValorCsll);
      rllOutrasRetencoes.Caption := FormatCurr('R$ ,0.00', OutrasRetencoes);
      rllValorIssRetido.Caption := FormatCurr('R$ ,0.00', ValorIssRetido);
      rllValorLiquido.Caption := FormatCurr('R$ ,0.00', ValorLiquidoNfse);
    end;
end;

procedure TfrlXDANFSeRLISSnet.rlbItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  rlmDescricao.Lines.Clear;
  rlmDescricao.Lines.Add(StringReplace(fpNFSe.Servico.Discriminacao,
    FQuebradeLinha, #13#10, [rfReplaceAll, rfIgnoreCase]));
end;

procedure TfrlXDANFSeRLISSnet.rlbPrestadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  QrCode: TDelphiZXingQRCode;
  QrCodeBitmap: TBitmap;
  QRCodeData: String;
  Row, Column: Integer;
begin
  inherited;

  TDFeReportFortes.CarregarLogo(rliPrestLogo, fpDANFSe.Prestador.Logo);

  with fpNFSe do
  begin
    rllEmissao.Caption := FormatDateTime('dd/mm/yyyy hh:nn:ss', DataEmissao);
    rllCompetencia.Caption := IfThen(Competencia > 0, FormatDateTime('dd/mm/yyyy', Competencia), '');
    rllCodVerificacao.Caption := CodigoVerificacao;
  end;

  with fpNFSe.Prestador do
  begin
    rllPrestNome.Caption := IfThen(RazaoSocial <> '', RazaoSocial, fpDANFSe.Prestador.RazaoSocial);
    rllPrestFantasia.Caption := IfThen(NomeFantasia <> '', NomeFantasia, fpDANFSe.Prestador.NomeFantasia);

    with IdentificacaoPrestador do
    begin
      rllPrestCNPJ.Caption := FormatarCNPJouCPF(IfThen(CpfCnpj <> '', CpfCnpj, fpDANFSe.Prestador.CNPJ));
      rllPrestInscMunicipal.Caption := IfThen(InscricaoMunicipal <> '', InscricaoMunicipal, fpDANFSe.Prestador.InscricaoMunicipal);
      rllPrestInscEstadual.Caption := IfThen(InscricaoEstadual <> '', InscricaoEstadual, fpDANFSe.Prestador.InscricaoEstadual);
    end;

    with Endereco do
    begin
      rllPrestEndereco.Lines.Text := IfThen(Endereco <> '', Trim(Endereco) + ', ' +
        Trim(Trim(Numero) + ' ' + Trim(IfThen(Complemento <> '', Complemento, fpDANFSe.Prestador.Complemento))) + #13 +
        Trim(Bairro) + ' - ' + Trim(IfThen(xMunicipio <> '', xMunicipio, fpDANFSe.Prestador.Municipio)) + ' - ' +
        IfThen(UF <> '', UF, fpDANFSe.Prestador.UF) + ' CEP: ' + FormatarCEP(CEP) + #13 +
        Trim(IfThen(Contato.Telefone <> '', FormatarFone(Contato.Telefone), FormatarFone(fpDANFSe.Prestador.Fone)) + '  ' +
        IfThen(Contato.Email <> '', Contato.Email, fpDANFSe.Prestador.Email)),

        Trim(fpDANFSe.Prestador.Endereco));

    end;


    rllPrestNomeEnt.Caption := IfThen(RazaoSocial <> '', RazaoSocial, fpDANFSe.Prestador.RazaoSocial);
  end;

  if ((pos('http://', LowerCase(fpNFSe.OutrasInformacoes)) > 0) or
    (pos('https://', LowerCase(fpNFSe.OutrasInformacoes)) > 0) or
    (pos('http://', LowerCase(fpNFSe.Link)) > 0) or
    (pos('https://', LowerCase(fpNFSe.Link)) > 0)) then
  begin
    QRCodeData := Trim(MidStr(fpNFSe.Link, pos('http://', LowerCase(fpNFSe.Link)), Length(fpNFSe.Link)));

    if QRCodeData = '' then
      QRCodeData := Trim(MidStr(fpNFSe.Link, pos('https://', LowerCase(fpNFSe.Link)), Length(fpNFSe.Link)));

    if QRCodeData = '' then
      QRCodeData := Trim(MidStr(fpNFSe.OutrasInformacoes, pos('http://', LowerCase(fpNFSe.OutrasInformacoes)), Length(fpNFSe.OutrasInformacoes)));

    if QRCodeData = '' then
      QRCodeData := Trim(MidStr(fpNFSe.OutrasInformacoes, pos('https://', LowerCase(fpNFSe.OutrasInformacoes)), Length(fpNFSe.OutrasInformacoes)));

    QrCode := TDelphiZXingQRCode.Create;
    QrCodeBitmap := TBitmap.Create;

    try
      QrCode.Encoding := qrUTF8NoBOM;
      QrCode.QuietZone := 1;
      QrCode.Data := WideString(QRCodeData);

      QrCodeBitmap.Width := QrCode.Columns;
      QrCodeBitmap.Height := QrCode.Rows;

      for Row := 0 to QrCode.Rows - 1 do
        for Column := 0 to QrCode.Columns - 1 do
          if (QrCode.IsBlack[Row, Column]) then
            QrCodeBitmap.Canvas.Pixels[Column, Row] := clBlack
          else
            QrCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;

      rlImgQrCode.Picture.Bitmap.Assign(QrCodeBitmap);
    finally
      QrCode.Free;
      QrCodeBitmap.Free;
    end;
  end;

  rllNumNF0Ent.Caption := FormatFloat('00000000000', StrToFloatDef(fpNFSe.Numero, 0));
  rllTomadorNomeEnt.Caption := ACBrStr('Emiss�o:') +
    FormatDateTime('dd/mm/yy', fpNFSe.DataEmissao) +
    '-Tomador:' + fpNFSe.Tomador.RazaoSocial +
    '-Total:' +
    FormatFloat(',0.00', fpNFSe.Servico.Valores.ValorLiquidoNfse);

end;

procedure TfrlXDANFSeRLISSnet.rlbTomadorBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  inherited;

  with fpNFSe.Tomador do
  begin
    rllTomaNome.Caption := RazaoSocial;

    with IdentificacaoTomador do
    begin
      lbIdentificacao.Caption := 'CPF/CNPJ:';
      if (Length(Nif) > 0) then
      begin
        lbIdentificacao.Caption := 'NIF:';
        rllTomaCNPJ.Caption := Nif;
      end
      else
      begin
        if Length(CpfCnpj) <= 11 then
          rllTomaCNPJ.Caption := FormatarCPF(CpfCnpj)
        else
          rllTomaCNPJ.Caption := FormatarCNPJ(CpfCnpj);
      end;
      rllTomaInscMunicipal.Caption := IfThen(InscricaoMunicipal <> '', InscricaoMunicipal, fpDANFSe.Tomador.InscricaoMunicipal);

      rllTomaInscEstadual.Caption := IfThen(InscricaoEstadual <> '', InscricaoEstadual, fpDANFSe.Tomador.InscricaoEstadual);
    end;

    with Endereco do
    begin
      if Endereco <> '' then
      begin
        if UF = 'EX' then
        begin
          rllTomaEndereco.Caption := Trim(Endereco) + ', Pais: ' + Trim(xPais);
        end
        else
          rllTomaEndereco.Caption := Trim(Endereco) + ', ' +
            Trim(Numero) + ' - ' +
            Trim(Bairro) + ' - CEP: ' +
            FormatarCEP(CEP);
      end
      else
        rllTomaEndereco.Caption := Trim(fpDANFSe.Tomador.Endereco) + ' - CEP: ' +
          FormatarCEP(CEP);

      rllTomaComplemento.Caption := IfThen(Complemento <> '', Complemento, fpDANFSe.Tomador.Complemento);
      rllTomaMunicipio.Caption := xMunicipio;
      rllTomaUF.Caption := UF;
      rllTomaCEP.Caption := FormatarCEP(CEP);
    end;

    with Contato do
    begin
      rllTomaTelefone.Caption := IfThen(Telefone <> '', FormatarFone(Telefone), FormatarFone(fpDANFSe.Tomador.Fone));
      rllTomaEmail.Caption := IfThen(Email <> '', Email, fpDANFSe.Tomador.Email);
    end;
  end;
end;

procedure TfrlXDANFSeRLISSnet.RLNFSeBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  Detalhar: Boolean;
begin
  inherited;

  Detalhar := ACBrNFSe.Provider.ConfigGeral.DetalharServico;

  RLNFSe.Title := 'NFS-e: ' + fpNFSe.Numero;
  TDFeReportFortes.AjustarMargem(RLNFSe, fpDANFSe);
  rlbItens.Visible := not Detalhar;
  rlbHeaderItensDetalhado.Visible := Detalhar;
  subItens.Visible := Detalhar;

  // rlbItens.Visible := not (fpDANFSe.DetalharServico);
  // rlbHeaderItensDetalhado.Visible := fpDANFSe.DetalharServico;
  // subItens.Visible := fpDANFSe.DetalharServico;

  // Estudar a melhor forma de n�o especificar o provedor.
  RLLabel65.Visible := not (ACBrNFSe.Configuracoes.Geral.Provedor in [proSimple]);
  txtServicoQtde.Visible := not (ACBrNFSe.Configuracoes.Geral.Provedor in [proSimple]);
end;

procedure TfrlXDANFSeRLISSnet.subItensDataRecord(Sender: TObject;
  RecNo: Integer; CopyNo: Integer; var Eof: Boolean;
  var RecordAction: TRLRecordAction);
begin
  inherited;

  FNumItem := RecNo - 1;
  Eof := (RecNo > fpNFSe.Servico.ItemServico.Count);
  RecordAction := raUseIt;
end;

function TfrlXDANFSeRLISSnet.ManterAliquota(dAliquota: Double): String;
begin
  // Agora a multiplica��o por 100 � feita pela rotina que l� o XML.
  Result := FormatFloat(',0.00', dAliquota);
end;

end.
