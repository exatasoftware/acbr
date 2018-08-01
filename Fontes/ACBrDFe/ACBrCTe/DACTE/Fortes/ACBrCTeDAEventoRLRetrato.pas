{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Mark dos Santos Gon�alves              }
{                                        Juliomar Marchetti                     }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
******************************************************************************}

{$I ACBr.inc}

unit ACBrCTeDAEventoRLRetrato;

interface

uses
  SysUtils, Variants, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, Qt, QStdCtrls,
  {$ELSE}
  Messages, Graphics, Controls, Forms, Dialogs, ExtCtrls, MaskUtils, StdCtrls,
  {$ENDIF}
  RLReport, RLFilters, RLPDFFilter,
  pcnConversao, RLBarcode,  DB, StrUtils, RLRichText, ACBrCTeDAEventoRL;

type

  { TfrmCTeDAEventoRLRetrato }

  TfrmCTeDAEventoRLRetrato = class(TfrmCTeDAEventoRL)
    rlb_09_Itens: TRLBand;
    rldbtTpDoc1: TRLDBText;
    rldbtCnpjEmitente1: TRLDBText;
    rldbtDocumento1: TRLDBText;
    rldbtDocumento2: TRLDBText;
    rldbtCnpjEmitente2: TRLDBText;
    rldbtTpDoc2: TRLDBText;
    rlb_01_Titulo: TRLBand;
    rllProtocolo: TRLLabel;
    rllOrgao: TRLLabel;
    rllDescricao: TRLLabel;
    rlLabel2: TRLLabel;
    rlLabel78: TRLLabel;
    rllDescricaoEvento: TRLLabel;
    rlb_08_HeaderItens: TRLBand;
    rlb_10_Sistema: TRLBand;
    rlb_05_Evento: TRLBand;
    rlLabel13: TRLLabel;
    rlLabel16: TRLLabel;
    rlLabel22: TRLLabel;
    rlLabel24: TRLLabel;
    rllRazaoEmitente: TRLLabel;
    rllEnderecoEmitente: TRLLabel;
    rllMunEmitente: TRLLabel;
    rllCNPJEmitente: TRLLabel;
    rlLabel93: TRLLabel;
    rllInscEstEmitente: TRLLabel;
    rllCEPEmitente: TRLLabel;
    rlLabel98: TRLLabel;
    rlb_03_Emitente: TRLBand;
    rlb_04_Tomador: TRLBand;
    rlb_06_Condicoes: TRLBand;
    rlLabel38: TRLLabel;
    rlLabel44: TRLLabel;
    rlmGrupoAlterado: TRLMemo;
    rlLabel46: TRLLabel;
    rlmCampoAlterado: TRLMemo;
    rlLabel42: TRLLabel;
    rlmValorAlterado: TRLMemo;
    rlLabel45: TRLLabel;
    rlmNumItemAlterado: TRLMemo;
    RLDraw18: TRLDraw;
    RLDraw17: TRLDraw;
    RLDraw15: TRLDraw;
    RLDraw19: TRLDraw;
    lblTitulo_06: TRLLabel;
    RLDraw5: TRLDraw;
    rlmCondicoes: TRLMemo;
    rlsQuadro01: TRLDraw;
    rlsQuadro02: TRLDraw;
    rlsQuadro04: TRLDraw;
    rlsQuadro05: TRLDraw;
    rlsLinhaV10: TRLDraw;
    rlsLinhaV09: TRLDraw;
    rlsLinhaH04: TRLDraw;
    rlsLinhaV01: TRLDraw;
    rlsLinhaH06: TRLDraw;
    rlsLinhaH07: TRLDraw;
    RLDraw10: TRLDraw;
    rlLabel65: TRLLabel;
    RLDraw2: TRLDraw;
    rlb_07_Correcao: TRLBand;
    RLDraw46: TRLDraw;
    rllLinha3: TRLLabel;
    rllLinha2: TRLLabel;
    rllLinha1: TRLLabel;
    rlb_02_Documento: TRLBand;
    RLDraw81: TRLDraw;
    RLDraw88: TRLDraw;
    rlsQuadro03: TRLDraw;
    rlLabel8: TRLLabel;
    rllModelo: TRLLabel;
    rlLabel21: TRLLabel;
    rllSerie: TRLLabel;
    rlLabel23: TRLLabel;
    rllNumCte: TRLLabel;
    rlsLinhaV05: TRLDraw;
    rlsLinhaV06: TRLDraw;
    rlsLinhaV08: TRLDraw;
    rlLabel33: TRLLabel;
    rllEmissao: TRLLabel;
    rlsLinhaV07: TRLDraw;
    rlLabel74: TRLLabel;
    rllChave: TRLLabel;
    rllTituloEvento: TRLLabel;
    RLDraw48: TRLDraw;
    rlLabel9: TRLLabel;
    rllTipoAmbiente: TRLLabel;
    rlLabel6: TRLLabel;
    rllEmissaoEvento: TRLLabel;
    rlLabel28: TRLLabel;
    rllTipoEvento: TRLLabel;
    rlLabel17: TRLLabel;
    rllSeqEvento: TRLLabel;
    RLDraw49: TRLDraw;
    RLDraw50: TRLDraw;
    rlLabel18: TRLLabel;
    rllStatus: TRLLabel;
    rlLabel12: TRLLabel;
    RLDraw51: TRLDraw;
    rlLabel1: TRLLabel;
    RLDraw52: TRLDraw;
    RLDraw53: TRLDraw;
    RLDraw82: TRLDraw;
    RLDraw99: TRLDraw;
    rlLabel4: TRLLabel;
    rllBairroEmitente: TRLLabel;
    RLDraw108: TRLDraw;
    rlLabel5: TRLLabel;
    rllFoneEmitente: TRLLabel;
    RLDraw109: TRLDraw;
    rlLabel14: TRLLabel;
    rllRazaoTomador: TRLLabel;
    rlLabel25: TRLLabel;
    rllEnderecoTomador: TRLLabel;
    rlLabel27: TRLLabel;
    rllMunTomador: TRLLabel;
    rlLabel30: TRLLabel;
    rllCNPJTomador: TRLLabel;
    rlLabel32: TRLLabel;
    rllBairroTomador: TRLLabel;
    rlLabel35: TRLLabel;
    rllCEPTomador: TRLLabel;
    rlLabel37: TRLLabel;
    rllFoneTomador: TRLLabel;
    rlLabel40: TRLLabel;
    rllInscEstTomador: TRLLabel;
    RLDraw7: TRLDraw;
    RLDraw8: TRLDraw;
    RLDraw9: TRLDraw;
    RLDraw55: TRLDraw;
    RLDraw56: TRLDraw;
    RLDraw58: TRLDraw;
    RLDraw59: TRLDraw;
    rllMsgTeste: TRLLabel;
    rlLabel15: TRLLabel;
    rllblSistema: TRLLabel;
    rliBarCode: TRLBarcode;
    procedure rlb_01_TituloBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_02_DocumentoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_05_EventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_03_EmitenteBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_04_TomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_06_CondicoesBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_07_CorrecaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_08_HeaderItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_09_ItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlb_10_SistemaBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLCTeEventoBeforePrint(Sender: TObject; var PrintIt: boolean);
  private
    procedure Itens;
  public
    procedure ProtocoloCTe(const sProtocolo: string);
  end;

implementation

uses
  DateUtils, ACBrDFeUtil, ACBrUtil, ACBrValidador, pcteConversaoCTe;

{$IFnDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

var
  FProtocoloCTe: string;

procedure TfrmCTeDAEventoRLRetrato.Itens;
begin
  // Itens
end;

procedure TfrmCTeDAEventoRLRetrato.ProtocoloCTe(const sProtocolo: string);
begin
  FProtocoloCTe := sProtocolo;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_01_TituloBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  //  TpcnTpEvento = (teCCe, teCancelamento, teManifDestConfirmacao, teManifDestCiencia,
  //                  teManifDestDesconhecimento, teManifDestOperNaoRealizada,
  //                  teEncerramento, teEPEC, teInclusaoCondutor, teMultiModal);
  case FEventoCTe.InfEvento.tpEvento of
    teCCe:
    begin
      rllLinha1.Caption := ACBrStr('CARTA DE CORRE��O ELETR�NICA');
      rllLinha2.Caption := ACBrStr('N�o possui valor fiscal, simples representa��o da CC-e indicada abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DA CARTA DE CORRE��O ELETR�NICA NO SITE DA SEFAZ AUTORIZADORA.');
    end;
    teCancelamento:
    begin
      rllLinha1.Caption := 'CANCELAMENTO';
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do Cancelamento indicado abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DO CANCELAMENTO NO SITE DA SEFAZ AUTORIZADORA.');
    end;
    teEPEC:
    begin
      rllLinha1.Caption := ACBrStr('EVENTO PR�VIO DE EMISS�O EM CONTING�NCIA - EPEC');
      rllLinha2.Caption := ACBrStr('N�o possui valor fiscal, simples representa��o da EPEC indicada abaixo.');
      rllLinha3.Caption := ACBrStr('CONSULTE A AUTENTICIDADE DA EPEC NO SITE DA SEFAZ VIRTUAL DE CONTING�NCIA DO RS/SP.');
    end;
    tePrestDesacordo:
    begin
      rllLinha1.Caption := 'PRESTA��O DE SERVI�O EM DESACORDO';
      rllLinha2.Caption := ACBrStr(
        'N�o possui valor fiscal, simples representa��o do evento indicado abaixo.');
      rllLinha3.Caption := ACBrStr(
        'CONSULTE A AUTENTICIDADE DA PRESTA��O DE SERVI�O EM DESACORDO NO SITE DA SEFAZ AUTORIZADORA.');
    end;
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_02_DocumentoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  PrintIt := False;

  if FCTe <> nil then
  begin
    PrintIt := True;

    rllModelo.Caption := IntToStr(FCTe.ide.modelo);
    rllSerie.Caption := IntToStr(FCTe.ide.serie);
    rllNumCTe.Caption := FormatFloat('000,000,000', FCTe.Ide.nCT);
    rllEmissao.Caption := FormatDateTimeBr(FCTe.Ide.dhEmi);
    rliBarCode.Caption := OnlyNumber(FCTe.InfCTe.Id);
    rllChave.Caption := FormatarChaveAcesso(OnlyNumber(FCTe.InfCTe.Id));
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_05_EventoBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  with FEventoCTe do
  begin
    case InfEvento.tpEvento of
      teCCe: rllTituloEvento.Caption := ACBrStr('CARTA DE CORRE��O ELETR�NICA');
      teCancelamento: rllTituloEvento.Caption := 'CANCELAMENTO';
      teEPEC: rllTituloEvento.Caption := ACBrStr('EVENTO PR�VIO DE EMISS�O EM CONTING�NCIA');
      tePrestDesacordo: rllTituloEvento.Caption := ACBrStr('PRESTA��O DE SERVI�O EM DESACORDO');
    end;

    rllOrgao.Caption := IntToStr(InfEvento.cOrgao);
    case InfEvento.tpAmb of
      taProducao: rllTipoAmbiente.Caption := ACBrStr('PRODU��O');
      taHomologacao: rllTipoAmbiente.Caption := ACBrStr('HOMOLOGA��O - SEM VALOR FISCAL');
    end;
    rllEmissaoEvento.Caption := FormatDateTimeBr(InfEvento.dhEvento);
    rllTipoEvento.Caption := InfEvento.TipoEvento;
    rllDescricaoEvento.Caption := InfEvento.DescEvento;
    rllSeqEvento.Caption := IntToStr(InfEvento.nSeqEvento);
    rllStatus.Caption := IntToStr(RetInfEvento.cStat) + ' - ' +
      RetInfEvento.xMotivo;
    rllProtocolo.Caption := RetInfEvento.nProt + ' ' +
      FormatDateTimeBr(RetInfEvento.dhRegEvento);
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_03_EmitenteBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  PrintIt := False;

  if FCTe <> nil then
  begin
    PrintIt := True;

    rllRazaoEmitente.Caption := FCTe.emit.xNome;
    rllCNPJEmitente.Caption := FormatarCNPJouCPF(FCTe.emit.CNPJ);
    rllEnderecoEmitente.Caption := FCTe.emit.EnderEmit.xLgr + ', ' + FCTe.emit.EnderEmit.nro;
    rllBairroEmitente.Caption := FCTe.emit.EnderEmit.xBairro;
    rllCEPEmitente.Caption := FormatarCEP(FCTe.emit.EnderEmit.CEP);
    rllMunEmitente.Caption := FCTe.emit.EnderEmit.xMun + ' - ' + FCTe.emit.EnderEmit.UF;
    rllFoneEmitente.Caption := FormatarFone(FCTe.emit.enderEmit.fone);
    rllInscEstEmitente.Caption := FCTe.emit.IE;
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_04_TomadorBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  PrintIt := False;

  if FCTe <> nil then
  begin
    PrintIt := True;
    case FCTe.Ide.modelo of
      57:
      begin
        if FCTe.Ide.Toma4.xNome = '' then
        begin
          case FCTe.Ide.Toma03.Toma of
            tmRemetente:
            begin
              rllRazaoTomador.Caption := FCTe.Rem.xNome;
              rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.Rem.CNPJCPF);
              rllEnderecoTomador.Caption := FCTe.Rem.EnderReme.xLgr + ', ' + FCTe.Rem.EnderReme.nro;
              rllBairroTomador.Caption := FCTe.Rem.EnderReme.xBairro;
              rllCEPTomador.Caption := FormatarCEP(FCTe.Rem.EnderReme.CEP);
              rllMunTomador.Caption := FCTe.Rem.EnderReme.xMun + ' - ' + FCTe.Rem.EnderReme.UF;
              rllFoneTomador.Caption := FormatarFone(FCTe.Rem.fone);
              rllInscEstTomador.Caption := FCTe.Rem.IE;
            end;
            tmExpedidor:
            begin
              rllRazaoTomador.Caption := FCTe.Exped.xNome;
              rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.Exped.CNPJCPF);
              rllEnderecoTomador.Caption := FCTe.Exped.EnderExped.xLgr + ', ' + FCTe.Exped.EnderExped.nro;
              rllBairroTomador.Caption := FCTe.Exped.EnderExped.xBairro;
              rllCEPTomador.Caption := FormatarCEP(FCTe.Exped.EnderExped.CEP);
              rllMunTomador.Caption := FCTe.Exped.EnderExped.xMun + ' - ' + FCTe.Exped.EnderExped.UF;
              rllFoneTomador.Caption := FormatarFone(FCTe.Exped.fone);
              rllInscEstTomador.Caption := FCTe.Exped.IE;
            end;
            tmRecebedor:
            begin
              rllRazaoTomador.Caption := FCTe.Receb.xNome;
              rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.Receb.CNPJCPF);
              rllEnderecoTomador.Caption := FCTe.Receb.EnderReceb.xLgr + ', ' + FCTe.Receb.EnderReceb.nro;
              rllBairroTomador.Caption := FCTe.Receb.EnderReceb.xBairro;
              rllCEPTomador.Caption := FormatarCEP(FCTe.Receb.EnderReceb.CEP);
              rllMunTomador.Caption := FCTe.Receb.EnderReceb.xMun + ' - ' + FCTe.Receb.EnderReceb.UF;
              rllFoneTomador.Caption := FormatarFone(FCTe.Receb.fone);
              rllInscEstTomador.Caption := FCTe.Receb.IE;
            end;
            tmDestinatario:
            begin
              rllRazaoTomador.Caption := FCTe.Dest.xNome;
              rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.Dest.CNPJCPF);
              rllEnderecoTomador.Caption := FCTe.Dest.EnderDest.xLgr + ', ' + FCTe.Dest.EnderDest.nro;
              rllBairroTomador.Caption := FCTe.Dest.EnderDest.xBairro;
              rllCEPTomador.Caption := FormatarCEP(FCTe.Dest.EnderDest.CEP);
              rllMunTomador.Caption := FCTe.Dest.EnderDest.xMun + ' - ' + FCTe.Dest.EnderDest.UF;
              rllFoneTomador.Caption := FormatarFone(FCTe.Dest.fone);
              rllInscEstTomador.Caption := FCTe.Dest.IE;
            end;
          end;
        end
        else
        begin
          rllRazaoTomador.Caption := FCTe.Ide.Toma4.xNome;
          rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.Ide.Toma4.CNPJCPF);
          rllEnderecoTomador.Caption := FCTe.Ide.Toma4.EnderToma.xLgr + ', ' + FCTe.Ide.Toma4.EnderToma.nro;
          rllBairroTomador.Caption := FCTe.Ide.Toma4.EnderToma.xBairro;
          rllCEPTomador.Caption := FormatarCEP(FCTe.Ide.Toma4.EnderToma.CEP);
          rllMunTomador.Caption := FCTe.Ide.Toma4.EnderToma.xMun + ' - ' + FCTe.Ide.Toma4.EnderToma.UF;
          rllFoneTomador.Caption := FormatarFone(FCTe.Ide.Toma4.fone);
          rllInscEstTomador.Caption := FCTe.Ide.Toma4.IE;
        end;
      end;
      67:
      begin
        rllRazaoTomador.Caption := FCTe.toma.xNome;
        rllCNPJTomador.Caption := FormatarCNPJouCPF(FCTe.toma.CNPJCPF);
        rllEnderecoTomador.Caption := FCTe.toma.EnderToma.xLgr + ', ' + FCTe.toma.EnderToma.nro;
        rllBairroTomador.Caption := FCTe.toma.EnderToma.xBairro;
        rllCEPTomador.Caption := FormatarCEP(FCTe.toma.EnderToma.CEP);
        rllMunTomador.Caption := FCTe.toma.EnderToma.xMun + ' - ' + FCTe.toma.EnderToma.UF;
        rllFoneTomador.Caption := FormatarFone(FCTe.toma.fone);
        rllInscEstTomador.Caption := FCTe.toma.IE;
      end;
    end;
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_06_CondicoesBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  PrintIt := (FEventoCTe.InfEvento.tpEvento = teCCe) or
    (FEventoCTe.InfEvento.tpEvento = teCancelamento) or
    (FEventoCTe.InfEvento.tpEvento = teEPEC) or
    (FEventoCTe.InfEvento.tpAmb = taHomologacao);

  rllMsgTeste.Visible := False;
  rllMsgTeste.Enabled := False;

  if FEventoCTe.InfEvento.tpAmb = taHomologacao then
  begin
    rllMsgTeste.Caption := ACBrStr('AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL');
    rllMsgTeste.Visible := True;
    rllMsgTeste.Enabled := True;
  end;

  rlmCondicoes.Visible := (FEventoCTe.InfEvento.tpEvento = teCCe) or
    (FEventoCTe.InfEvento.tpEvento = teCancelamento) or
    (FEventoCTe.InfEvento.tpEvento = teEPEC) or
    (FEventoCTe.InfEvento.tpEvento = tePrestDesacordo);
  rlmCondicoes.Enabled := (FEventoCTe.InfEvento.tpEvento = teCCe) or
    (FEventoCTe.InfEvento.tpEvento = teCancelamento) or
    (FEventoCTe.InfEvento.tpEvento = teEPEC) or
    (FEventoCTe.InfEvento.tpEvento = tePrestDesacordo);

  case FEventoCTe.InfEvento.tpEvento of
    teCCe:
    begin
      lblTitulo_06.Caption := ACBrStr('CONDI��ES DE USO');
      rlmCondicoes.Lines.Clear;
      rlmCondicoes.Lines.Add( ACBrStr(
        'A Carta de Corre��o e disciplinada pelo Art. 58-B do CONVENIO/SINIEF 06/89: Fica permitida a utilizacao de carta de correcao, para regulariza��o'));
      rlmCondicoes.Lines.Add( ACBrStr(
        'de erro ocorrido na emiss�o de documentos fiscais relativos a presta��o de servi�o de transporte, desde que o erro nao esteja relacionado com:'));
      rlmCondicoes.Lines.Add( ACBrStr(
        'I - as variaveis que determinam o valor do imposto tais como: base de calculo, al�quota, diferen�a de pre�o, quantidade, valor da presta��o;'));
      rlmCondicoes.Lines.Add( ACBrStr(
        'II - a corre��o de dados cadastrais que implique mudanca do emitente, tomador, remetente ou do destinat�rio;'));
      rlmCondicoes.Lines.Add(ACBrStr('III - a data de emiss�o ou de sa�da.'));
    end;
    teCancelamento:
    begin
      lblTitulo_06.Caption := ACBrStr('DESCRI��O');
      rlmCondicoes.Lines.Clear;
      rlmCondicoes.Lines.Add('Protocolo do CTe Cancelado: ' + FEventoCTe.InfEvento.detEvento.nProt);
      rlmCondicoes.Lines.Add('Motivo do Cancelamento    : ' + FEventoCTe.InfEvento.detEvento.xJust);
      rlmCondicoes.Lines.Add('Chave do CTe Cancelado    : ' + FEventoCTe.InfEvento.chCTe);
    end;
    teEPEC:
    begin
      lblTitulo_06.Caption := ACBrStr('DESCRI��O');
      rlmCondicoes.Lines.Clear;
      rlmCondicoes.Lines.Add('Motivo do EPEC     : ' + FEventoCTe.InfEvento.detEvento.xJust);
      rlmCondicoes.Lines.Add('Valor do ICMS      : ' + FormatFloat(
        '#0.00', FEventoCTe.InfEvento.detEvento.vICMS));
      rlmCondicoes.Lines.Add(ACBrStr('Valor da Presta��o : ') + FormatFloat(
        '#0.00', FEventoCTe.InfEvento.detEvento.vTPrest));
      rlmCondicoes.Lines.Add('Valor da Carga     : ' + FormatFloat(
        '#0.00', FEventoCTe.InfEvento.detEvento.vCarga));
      rlmCondicoes.Lines.Add(ACBrStr('UF de inicio/fim da presta��o: ') + FEventoCTe.InfEvento.detEvento.UFIni + ' / ' +
        FEventoCTe.InfEvento.detEvento.UFFim);
    end;
    tePrestDesacordo:
    begin
      lblTitulo_06.Caption := ACBrStr('JUSTIFICATIVA');
      rlmCondicoes.Lines.Clear;
      rlmCondicoes.Lines.Add(FEventoCTe.InfEvento.detEvento.xOBS);
    end;
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_07_CorrecaoBeforePrint(Sender: TObject; var PrintIt: Boolean);
var
  i: integer;
begin
  inherited;

  PrintIt := FEventoCTe.InfEvento.tpEvento = teCCe;

  rlmNumItemAlterado.Lines.Clear;
  rlmGrupoAlterado.Lines.Clear;
  rlmCampoAlterado.Lines.Clear;
  rlmValorAlterado.Lines.Clear;

  for i := 0 to (FEventoCTe.InfEvento.detEvento.infCorrecao.Count - 1) do
  begin
    rlmNumItemAlterado.Lines.Add(IntToStr(FEventoCTe.InfEvento.detEvento.infCorrecao[i].nroItemAlterado));
    rlmGrupoAlterado.Lines.Add(FEventoCTe.InfEvento.detEvento.infCorrecao[i].grupoAlterado);
    rlmCampoAlterado.Lines.Add(FEventoCTe.InfEvento.detEvento.infCorrecao[i].campoAlterado);
    rlmValorAlterado.Lines.Add(FEventoCTe.InfEvento.detEvento.infCorrecao[i].valorAlterado);
  end;
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_08_HeaderItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;
  // Imprime os Documentos Origin�rios se o Tipo de CTe for Normal
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_09_ItensBeforePrint(Sender: TObject; var PrintIt: Boolean);
//var
// i : integer;
begin
  inherited;

  rlb_09_Itens.Enabled := True;
  (*
  for i := 1 to 2 do
    if Trim(cdsDocumentos.FieldByName('DOCUMENTO_' + IntToStr(i)).AsString) = '' then
      TRLDBText(FindComponent('rldbtCnpjEmitente' + intToStr(i))).Width := 325
    else
      TRLDBText(FindComponent('rldbtCnpjEmitente' + intToStr(i))).Width := 128;
  *)
end;

procedure TfrmCTeDAEventoRLRetrato.rlb_10_SistemaBeforePrint(Sender: TObject; var PrintIt: Boolean);
begin
  inherited;

  rllblSistema.Caption := FSistema + ' - ' + FUsuario;
end;

procedure TfrmCTeDAEventoRLRetrato.RLCTeEventoBeforePrint(Sender: TObject; var PrintIt: boolean);
begin

  Itens;

  rlCTeEvento.Title := 'Evento: ' + FormatFloat('000,000,000', FEventoCTe.InfEvento.nSeqEvento);

  rlCTeEvento.Margins.TopMargin := FMargemSuperior * 10;
  rlCTeEvento.Margins.BottomMargin := FMargemInferior * 10;
  rlCTeEvento.Margins.LeftMargin := FMargemEsquerda * 10;
  rlCTeEvento.Margins.RightMargin := FMargemDireita * 10;
end;

end.
