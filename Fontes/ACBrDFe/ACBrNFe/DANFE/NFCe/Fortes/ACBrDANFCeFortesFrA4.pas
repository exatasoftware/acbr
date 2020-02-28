{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2015 Daniel Simoes de Almeida               }
{                                       Juliomar Marchetti                     }
{                                       Marciano Bandeira                      }
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
{ http://www.opensource.org/licenses/gpl-license.php                           }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}


{******************************************************************************
|* Historico
|*
|* 28/10/2015 Marciano Bandeira Disponibilizou os fontes
******************************************************************************}
{$I ACBr.inc}

unit ACBrDANFCeFortesFrA4;

interface

uses
  Classes, SysUtils,
  {$IFDEF FPC}
   LResources,
  {$ENDIF}
  Variants, Graphics, Controls, Forms, Dialogs,
  ACBrBase, ACBrNFeDANFEClass, pcnNFe, ACBrNFe,
  RLReport, RLHTMLFilter, RLFilters, RLPDFFilter,
  ACBrUtil, pcnConversao, ACBrDFeUtil, ACBrValidador;

type
  TACBrNFeDANFCeFortesA4Filtro = (fiNenhum, fiPDF, fiHTML ) ;
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFeDANFCeFortesA4 = class(TACBrNFeDANFCEClass)
  private
    FpNFe: TNFe;
    procedure Imprimir(const DanfeResumido : Boolean = False; const AFiltro : TACBrNFeDANFCeFortesA4Filtro = fiNenhum);
  public
    procedure ImprimirDANFE(NFE : TNFe = nil); override ;
    procedure ImprimirDANFEResumido(NFE : TNFe = nil); override ;
    procedure ImprimirDANFEPDF(NFE : TNFe = nil); override;
    procedure ImprimirDANFEResumidoPDF(NFE : TNFe = nil);override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  { TfrmACBrDANFCeFortesFrA4 }

  TfrmACBrDANFCeFortesFrA4 = class(TForm)
    rlReportA4: TRLReport;
    RLBand1: TRLBand;
    imgLogo: TRLImage;
    lNomeFantasia: TRLLabel;
    RLLabel1: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLBand2: TRLBand;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLBand3: TRLBand;
    RLLabel8: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel12: TRLLabel;
    RLLabel14: TRLLabel;
    RLLabel15: TRLLabel;
    subItens: TRLSubDetail;
    RLBand4: TRLBand;
    RLPDFFilter1: TRLPDFFilter;
    RLHTMLFilter1: TRLHTMLFilter;
    RLLabel13: TRLLabel;
    RLMemo1: TRLMemo;
    RLLabel16: TRLLabel;
    RLLabel17: TRLLabel;
    RLLabel18: TRLLabel;
    RLLabel19: TRLLabel;
    RLLabel20: TRLLabel;
    RLBand5: TRLBand;
    RLLabel21: TRLLabel;
    RLLabel22: TRLLabel;
    RLLabel23: TRLLabel;
    RLLabel24: TRLLabel;
    RLSubDetail1: TRLSubDetail;
    RLBand6: TRLBand;
    RLLabel25: TRLLabel;
    RLLabel26: TRLLabel;
    RLBand7: TRLBand;
    RLLabel27: TRLLabel;
    RLLabel28: TRLLabel;
    RLBand8: TRLBand;
    RLLabel29: TRLLabel;
    RLLabel30: TRLLabel;
    RLSubDetail2: TRLSubDetail;
    RLBand9: TRLBand;
    RLLabel31: TRLLabel;
    RLBand10: TRLBand;
    RLMemo2: TRLMemo;
    RLBand11: TRLBand;
    RLLabel32: TRLLabel;
    RLLabel33: TRLLabel;
    RLLabel34: TRLLabel;
    RLLabel35: TRLLabel;
    RLLabel36: TRLLabel;
    RLLabel37: TRLLabel;
    RLMemo3: TRLMemo;
    rlbConsumidor: TRLBand;
    lTitConsumidor: TRLLabel;
    lEnderecoConsumidor: TRLMemo;
    lCPF_CNPJ_ID: TRLMemo;
    rlbRodape: TRLBand;
    lConsultaQRCode: TRLLabel;
    imgQRCode: TRLImage;
    pGap05: TRLPanel;
    lSistema: TRLLabel;
    lProtocolo: TRLLabel;
    RLBand12: TRLBand;
    RLLabel39: TRLLabel;
    RLLabel40: TRLLabel;
    RLBand13: TRLBand;
    RLLabel3: TRLLabel;
    RLLabel38: TRLLabel;
    RLBand14: TRLBand;
    RLLabel41: TRLLabel;
    RLLabel42: TRLLabel;
    RLBand15: TRLBand;
    RLLabel44: TRLLabel;
    RLLabel45: TRLLabel;
    RLLabel46: TRLLabel;
    RLLabel47: TRLLabel;
    RLLabel48: TRLLabel;
    RLLabel49: TRLLabel;
    RLBand16: TRLBand;
    RLLabel50: TRLLabel;
    RlPelosProdutos: TRLLabel;
    RLLabel51: TRLLabel;
    lCancelada: TRLLabel;
    rllFisco: TRLLabel;
    RLBand17: TRLBand;
    RLLabel43: TRLLabel;
    RLLabel52: TRLLabel;
    procedure lNomeFantasiaBeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand9BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLLabel14BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel15BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel1BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel2BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure RLLabel4BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel5BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure imgLogoBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLLabel13BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLMemo1BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel16BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel17BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel18BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel19BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel20BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure rlReportA4DataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure RLLabel22BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel23BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure subItensDataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure RLSubDetail1DataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure RLLabel27BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel28BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel30BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand8BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLSubDetail2DataRecord(Sender: TObject; RecNo, CopyNo: Integer;
      var Eof: Boolean; var RecordAction: TRLRecordAction);
    procedure RLLabel31BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand10BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLMemo2BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel33BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel37BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLMemo3BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure rlbConsumidorBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure rlbRodapeBeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure lSistemaBeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel35BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel32BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel39BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel3BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand12BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLBand13BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLLabel41BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand15BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLLabel45BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel47BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel49BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel50BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RlPelosProdutosBeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLLabel51BeforePrint(Sender: TObject; var Text: string;
      var PrintIt: Boolean);
    procedure RLBand11BeforePrint(Sender: TObject; var PrintIt: Boolean);
    procedure RLLabel52BeforePrint(Sender: TObject; var AText: string;
      var PrintIt: Boolean);
    procedure RLBand17BeforePrint(Sender: TObject; var PrintIt: Boolean);
  private
    FNumItem: Integer;
    FNumPag: Integer;
    FACBrNFeDANFCeFortesA4: TACBrNFeDANFCeFortesA4;
    FFiltro: TACBrNFeDANFCeFortesA4Filtro;
    FResumido: Boolean;
    function CompoemEnderecoCFe: String ;
  protected
    property Filtro   : TACBrNFeDANFCeFortesA4Filtro read FFiltro write FFiltro default fiNenhum ;
    property Resumido : Boolean read FResumido write FResumido;
  public
    { Public declarations }
  end;

implementation

{$ifdef FPC}
  {$R *.lfm}
{$else}
  {$R *.dfm}
{$ENDIF}

uses RLPrinters, StrUtils,
     ACBrDFeDANFeReport, ACBrDFeReportFortes, ACBrDFeREport, ACBrDelphiZXingQRCode;

function TfrmACBrDANFCeFortesFrA4.CompoemEnderecoCFe: String;
var
  Endereco, CEP: String;
begin
  with self.FACBrNFeDANFCeFortesA4.FpNFe do
  begin
    // Definindo dados do Cliche //
    Endereco := Emit.EnderEmit.xLgr ;
    if (Emit.EnderEmit.nro <> '') then
      Endereco := Endereco + ', '+Emit.EnderEmit.nro;
    if (Emit.EnderEmit.xCpl <> '') then
      Endereco := Endereco + ' - '+Emit.EnderEmit.xCpl;
    if (Emit.EnderEmit.xBairro <> '') then
      Endereco := Endereco + ' - '+Emit.EnderEmit.xBairro;
    if (Emit.EnderEmit.xMun <> '') then
      Endereco := Endereco + ' - '+Emit.EnderEmit.xMun;
    if (Emit.EnderEmit.UF <> '') then
      Endereco := Endereco + ' - '+Emit.EnderEmit.UF;
    if (Emit.EnderEmit.CEP <> 0) then
    begin
      CEP := IntToStr(Emit.EnderEmit.CEP);
      Endereco := Endereco + ' - '+copy(CEP,1,5)+'-'+copy(CEP,6,3);
    end;
    if (Emit.EnderEmit.fone <> '') then
    begin
      Endereco := Endereco + ' - TEL: '+FormatarFone(Emit.EnderEmit.fone);
    end;

  end;
  Result := Endereco;
end;

procedure TfrmACBrDANFCeFortesFrA4.FormCreate(Sender: TObject);
begin
  FACBrNFeDANFCeFortesA4          := TACBrNFeDANFCeFortesA4(Owner) ;  // Link para o Pai

  //Pega as marges que for defina na classe pai.
  TDFeReportFortes.AjustarMargem(rlReportA4, FACBrNFeDANFCeFortesA4);

end;

procedure TfrmACBrDANFCeFortesFrA4.lNomeFantasiaBeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  lNomeFantasia.Visible := FACBrNFeDANFCeFortesA4.ImprimeNomeFantasia;

  if lNomeFantasia.Visible then
     Text := self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.xFant
  else
     Text := '';
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand9BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := (FACBrNFeDANFCeFortesA4.ImprimeTributos <> trbNenhum);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel14BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  PrintIt := FACBrNFeDANFCeFortesA4.ImprimeDescAcrescItem;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel15BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  PrintIt := FACBrNFeDANFCeFortesA4.ImprimeDescAcrescItem;
end;

procedure TfrmACBrDANFCeFortesFrA4.lSistemaBeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  if trim(self.FACBrNFeDANFCeFortesA4.Sistema) <> '' then
    Text := self.FACBrNFeDANFCeFortesA4.Sistema ;
end;

procedure TfrmACBrDANFCeFortesFrA4.imgLogoBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  LogoStream: TStringStream;
begin
  PrintIt := self.FACBrNFeDANFCeFortesA4.Logo <> '';
  if PrintIt then
  begin
    if FileExists (self.FACBrNFeDANFCeFortesA4.Logo) then
        imgLogo.Picture.LoadFromFile(self.FACBrNFeDANFCeFortesA4.Logo)
    else
    begin
      LogoStream := TStringStream.Create(self.FACBrNFeDANFCeFortesA4.Logo);
      try
        imgLogo.Picture.Bitmap.LoadFromStream(LogoStream);
      finally
        LogoStream.Free;
      end;
    end;
  end;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand10BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := StringReplace(Trim(self.FACBrNFeDANFCeFortesA4.FpNFe.InfAdic.infCpl), ';', #13, [rfReplaceAll] ) <> '';

//  self.memDadosAdc.Lines.Clear;
//  self.memDadosAdc.Lines.Add(self.FACBrNFeDANFCeFortesA4.FpNFe.InfAdic.infCpl);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand11BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  if self.FACBrNFeDANFCeFortesA4.Cancelada then
    lCancelada.Caption    := ACBrStr('NF-e CANCELADA');

  rllFisco.Caption := ACBrStr(self.FACBrNFeDANFCeFortesA4.FpNFe.procNFe.xMsg);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand12BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vDesc > 0;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand13BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := (self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vOutro > 0);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand15BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  with self.FACBrNFeDANFCeFortesA4 do
    PrintIt := (ImprimeTributos = trbSeparadamente);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand17BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  PrintIt := self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vFrete > 0;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLBand8BeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  Troco : Currency ;
begin
  Troco := FACBrNFeDANFCeFortesA4.FpNFe.pag.vTroco;
  if Troco = 0 then
  begin
    Troco := FACBrNFeDANFCeFortesA4.vTroco;
  end;
  PrintIt := (Troco> 0);
end;

procedure TfrmACBrDANFCeFortesFrA4.rlbConsumidorBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
begin
  with self.FACBrNFeDANFCeFortesA4.FpNFe do
  begin
    if (Dest.idEstrangeiro = '') and
       (Dest.CNPJCPF = '') then
     begin
        lCPF_CNPJ_ID.Lines.Text := ACBrStr('CONSUMIDOR N�O IDENTIFICADO');
     end
    else if Dest.idEstrangeiro <> '' then
     begin
       lCPF_CNPJ_ID.Lines.Text  := 'CNPJ/CPF/ID Estrangeiro -'+Dest.idEstrangeiro+' '+Dest.xNome;
     end
    else
     begin
       if Length(trim(Dest.CNPJCPF)) > 11 then
          lCPF_CNPJ_ID.Lines.Text  := 'CNPJ/CPF/ID Estrangeiro -'+FormatarCNPJ(Dest.CNPJCPF)
       else
          lCPF_CNPJ_ID.Lines.Text  := 'CNPJ/CPF/ID Estrangeiro -'+FormatarCPF(Dest.CNPJCPF);

       lCPF_CNPJ_ID.Lines.Text  := lCPF_CNPJ_ID.Caption+' '+Dest.xNome;
     end;
     lEnderecoConsumidor.Lines.Text := Trim(Dest.EnderDest.xLgr)+' '+
                                       Trim(Dest.EnderDest.nro)+' '+
                                       Trim(Dest.EnderDest.xCpl)+' '+
                                       Trim(Dest.EnderDest.xBairro)+' '+
                                       Trim(Dest.EnderDest.xMun);
  end;
end;

procedure TfrmACBrDANFCeFortesFrA4.rlbRodapeBeforePrint(Sender: TObject;
  var PrintIt: Boolean);
var
  qrcode: String;
begin
  with self.FACBrNFeDANFCeFortesA4.FpNFe do
  begin
    qrcode := TACBrNFe(self.FACBrNFeDANFCeFortesA4.ACBrNFe).GetURLQRCode( ide.cUF, ide.tpAmb,
                                     OnlyNumber(InfNFe.ID),  //correcao para pegar somente numeros, estava indo junto o NFE
                                     ifthen(Dest.idEstrangeiro <> '',Dest.idEstrangeiro, OnlyNumber(Dest.CNPJCPF)),
                                     ide.dEmi,
                                     Total.ICMSTot.vNF, Total.ICMSTot.vICMS,
                                     signature.DigestValue,
                                     infNFe.Versao);
    PintarQRCode(qrcode, imgQRCode.Picture.Bitmap, qrUTF8NoBOM);

    lProtocolo.Caption := ACBrStr('Protocolo de Autoriza��o: '+procNFe.nProt+
                           ' '+ifthen(procNFe.dhRecbto<>0,DateTimeToStr(procNFe.dhRecbto),''));
  end;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel13BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.cProd;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel16BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat(',0.00##', self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.qCom) + ' ' +
          self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.uCom;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel17BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00##', self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.vUnCom);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel18BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00##', self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.vDesc);
  PrintIt := FACBrNFeDANFCeFortesA4.ImprimeDescAcrescItem;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel19BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00##', self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.vOutro);
  PrintIt := FACBrNFeDANFCeFortesA4.ImprimeDescAcrescItem;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel1BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.xNome;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel20BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00##', self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.vProd);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel22BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat(',0', self.FACBrNFeDANFCeFortesA4.FpNFe.Det.Count);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel23BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00;R$ -,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vProd);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel27BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := ACBrStr(FormaPagamentoToDescricao(self.FACBrNFeDANFCeFortesA4.FpNFe.pag[self.FNumPag].tPag));
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel28BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.pag[self.FNumPag].vPag);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel2BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := 'CNPJ: ' + FormatarCNPJ(self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.CNPJCPF);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel30BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
 var
  Troco : Currency ;
begin
  Troco := FACBrNFeDANFCeFortesA4.FpNFe.pag.vTroco;
  if Troco = 0 then
  begin
    Troco := FACBrNFeDANFCeFortesA4.vTroco;
  end;
  Text := FormatFloat('R$ ,0.00', Troco);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel32BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  if self.FACBrNFeDANFCeFortesA4.FpNFe.Ide.tpAmb = taHomologacao then Begin
      if self.FACBrNFeDANFCeFortesA4.FpNFe.Ide.tpEmis <> teNormal then
        Text := ACBrStr('EMITIDA EM CONTING�NCIA - AMBIENTE DE HOMOLOGA��O -  SEM VALOR FISCAL')
    else
       Text := ACBrStr('EMITIDA EM AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL')
  End else
    begin
      if self.FACBrNFeDANFCeFortesA4.FpNFe.Ide.tpEmis <> teNormal then
         Text := ACBrStr('EMITIDA EM CONTING�NCIA')
      else
         Text := ACBrStr('�REA DE MENSAGEM FISCAL');
    end;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel33BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := ACBrStr('N�mero ')   + FormatFloat(',0', FACBrNFeDANFCeFortesA4.FpNFe.Ide.nNF) +
          ACBrStr(' S�rie ')   + FormatFloat('000', FACBrNFeDANFCeFortesA4.FpNFe.Ide.serie) +
          ACBrStr(' Emiss�o ') + FormatDateTime('dd/MM/yyyy hh:mm:ss', FACBrNFeDANFCeFortesA4.FpNFe.Ide.dEmi);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel35BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  if EstaVazio(self.FACBrNFeDANFCeFortesA4.FpNFe.infNFeSupl.urlChave) then
    Text := ACBrStr(
      'Consulte pela Chave de Acesso em ' +
      TACBrNFe(self.FACBrNFeDANFCeFortesA4.ACBrNFe).GetURLConsultaNFCe(
        self.FACBrNFeDANFCeFortesA4.FpNFe.Ide.cUF,
        self.FACBrNFeDANFCeFortesA4.FpNFe.Ide.tpAmb,
        self.FACBrNFeDANFCeFortesA4.FpNFe.infNFe.Versao
        )
      )
  else
    Text := ACBrStr(
      'Consulte pela Chave de Acesso em ' +
      self.FACBrNFeDANFCeFortesA4.FpNFe.infNFeSupl.urlChave);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel37BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatarChaveAcesso(OnlyNumber(self.FACBrNFeDANFCeFortesA4.FpNFe.infNFe.ID));

  if (FACBrNFeDANFCeFortesA4.FpNFe.Ide.tpEmis = teNormal) and (FACBrNFeDANFCeFortesA4.FpNFe.procNFe.cStat = 0) then
  begin
    Text  := ACBrStr('NFC-E N�O ENVIADA PARA SEFAZ');
    RLLabel37.Font.Color := clRed;
  end;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel39BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00;R$ -,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vDesc);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel3BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00;R$ -,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vOutro);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel41BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00;R$ -,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vNF);
end;





procedure TfrmACBrDANFCeFortesFrA4.RLLabel45BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
 Text:=FormatFloat('R$ ,0.00', self.FACBrNFeDANFCeFortesA4.vTribFed);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel47BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
 Text:=FormatFloat('R$ ,0.00', self.FACBrNFeDANFCeFortesA4.vTribEst);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLLabel49BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
 Text:=FormatFloat('R$ ,0.00', self.FACBrNFeDANFCeFortesA4.vTribMun);
end;



procedure TfrmACBrDANFCeFortesFrA4.RLLabel4BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  PrintIt := Trim(self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.IM) <> '';
  Text    := ACBrStr('Inscri��o Municipal: ') + self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.IM;
end;



procedure TfrmACBrDANFCeFortesFrA4.RLLabel5BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  PrintIt := Trim(self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.IE) <> '';
  Text    := ACBrStr('Inscri��o Estadual: ') + self.FACBrNFeDANFCeFortesA4.FpNFe.Emit.IE;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLMemo1BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  if self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].infAdProd = '' then
    Text := self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.xProd
  else
    Text := self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].Prod.xProd + ' - '
			+ StringReplace( self.FACBrNFeDANFCeFortesA4.FpNFe.Det[self.FNumItem].infAdProd, ';',#13,[rfReplaceAll]);
end;

procedure TfrmACBrDANFCeFortesFrA4.RLMemo2BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
var
  I:integer;
begin
  with self.FACBrNFeDANFCeFortesA4.FpNFe do
  begin
    if InfAdic.obsCont.Count > 0 then
    begin
      for I := 0 to InfAdic.obsCont.Count - 1 do
        Text := Text + StringReplace(InfAdic.obsCont[i].xCampo + ': ' +
                                     InfAdic.obsCont[i].xTexto, ';', #13, [rfReplaceAll] ) + #13;
    end;

    Text := Text + StringReplace(InfAdic.infCpl, ';', #13, [rfReplaceAll] ) + #13;
  end;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLMemo3BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  Text := CompoemEnderecoCFe;
end;

procedure TfrmACBrDANFCeFortesFrA4.rlReportA4DataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  Eof := (RecNo > 1);
  RecordAction := raUseIt;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLSubDetail1DataRecord(Sender: TObject;
  RecNo, CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  FNumPag := RecNo - 1 ;

  Eof := (RecNo > self.FACBrNFeDANFCeFortesA4.FpNFe.pag.Count) ;
  RecordAction := raUseIt ;
end;

procedure TfrmACBrDANFCeFortesFrA4.RLSubDetail2DataRecord(Sender: TObject;
  RecNo, CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  Eof := (RecNo > 1);
  RecordAction := raUseIt ;
end;

procedure TfrmACBrDANFCeFortesFrA4.subItensDataRecord(Sender: TObject; RecNo,
  CopyNo: Integer; var Eof: Boolean; var RecordAction: TRLRecordAction);
begin
  FNumItem := RecNo - 1 ;

  Eof := (RecNo > self.FACBrNFeDANFCeFortesA4.FpNFe.Det.Count) ;
  RecordAction := raUseIt ;
end;

{ TACBrNFeDANFCeFortesA4 }

constructor TACBrNFeDANFCeFortesA4.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TACBrNFeDANFCeFortesA4.Destroy;
begin

  inherited;
end;

procedure TACBrNFeDANFCeFortesA4.Imprimir(const DanfeResumido: Boolean;
  const AFiltro: TACBrNFeDANFCeFortesA4Filtro);
var
  frACBrNFeDANFCeFortesFr: TfrmACBrDANFCeFortesFrA4;
  RLLayout: TRLReport;
  RLFiltro: TRLCustomSaveFilter;
begin

  frACBrNFeDANFCeFortesFr := TfrmACBrDANFCeFortesFrA4.Create(Self);
  try
    with frACBrNFeDANFCeFortesFr do
    begin
	  if AlterarEscalaPadrao then
      begin
        frACBrNFeDANFCeFortesFr.Scaled := False;
        frACBrNFeDANFCeFortesFr.ScaleBy(NovaEscala , Screen.PixelsPerInch);
      end;
	
      Filtro := AFiltro;
      RLLayout := rlReportA4;
      Resumido := DanfeResumido;

      if (NumCopias > 0) and (RLPrinter.Copies <> NumCopias) then
      begin
        RLPrinter.Copies := NumCopias;
      end;

      if FACBrNFeDANFCeFortesA4.Impressora <> '' then
        RLPrinter.PrinterName := FACBrNFeDANFCeFortesA4.Impressora;

      RLLayout.PrintDialog := FACBrNFeDANFCeFortesA4.MostraPreview;
      RLLayout.ShowProgress:= False ;

      if Filtro = fiNenhum then
      begin
        if MostraPreview then
          RLLayout.PreviewModal
        else
          RLLayout.Print;
      end
      else
      begin
        if RLLayout.Prepare then
        begin
          case Filtro of
            fiPDF  : RLFiltro := RLPDFFilter1;
            fiHTML : RLFiltro := RLHTMLFilter1;
          else
            exit ;
          end ;

          RLFiltro.ShowProgress := FACBrNFeDANFCeFortesA4.MostraStatus;
          RLFiltro.FileName := FACBrNFeDANFCeFortesA4.PathPDF + OnlyNumber(FACBrNFeDANFCeFortesA4.FpNFe.infNFe.ID) + '-nfe.pdf';
          RLFiltro.FilterPages( RLLayout.Pages );
          FACBrNFeDANFCeFortesA4.FPArquivoPDF := RLFiltro.FileName;
        end;
      end;
    end;
  finally
    frACBrNFeDANFCeFortesFr.Free ;
  end;
end;

procedure TACBrNFeDANFCeFortesA4.ImprimirDANFE(NFE: TNFe);
begin
  if NFe = nil then
   begin
     if not Assigned(ACBrNFe) then
        raise Exception.Create('Componente ACBrNFe n�o atribu�do');

     FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFe;
   end
  else
    FpNFe := NFE;

  Imprimir(False);
end;

procedure TACBrNFeDANFCeFortesA4.ImprimirDANFEPDF(NFE: TNFe);
begin
  if NFe = nil then
   begin
     if not Assigned(ACBrNFe) then
        raise Exception.Create('Componente ACBrNFe n�o atribu�do');

     FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFe;
   end
  else
    FpNFe := NFE;
  Imprimir(False, fiPDF);
end;

procedure TACBrNFeDANFCeFortesA4.ImprimirDANFEResumido(NFE: TNFe);
begin
  if NFe = nil then
   begin
     if not Assigned(ACBrNFe) then
        raise Exception.Create('Componente ACBrNFe n�o atribu�do');

     FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFe;
   end
  else
    FpNFe := NFE;

  Imprimir(True);
end;

procedure TACBrNFeDANFCeFortesA4.ImprimirDANFEResumidoPDF(NFE: TNFe);
begin
  if NFe = nil then
   begin
     if not Assigned(ACBrNFe) then
        raise Exception.Create('Componente ACBrNFe n�o atribu�do');

     FpNFe := TACBrNFe(ACBrNFe).NotasFiscais.Items[0].NFe;
   end
  else
    FpNFe := NFE;

  Imprimir(True, fiPDF);
end;


procedure TfrmACBrDANFCeFortesFrA4.RLLabel31BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);

  Function ManterValorTributosLinha : String;
  Var
    sFederal, sEstadual , sMunicipal : String;
    dTemp : Double;
  begin
    With self.FACBrNFeDANFCeFortesA4 do
    begin
      dTemp := ( vTribFed + vTribEst + vTribMun );
      if ( dTemp > 0 ) then
      begin
        Result      := 'Tributos aproxidamente R$:';

        sFederal    := ' Federal e ' ;
        sEstadual   := ' Estadual';
        sMunicipal  := ' municipal';

        if ( vTribEst > 0 ) and ( vTribMun > 0 ) then
        begin
          sFederal    := ' Federal, ' ;
          sEstadual   := ' Estadual e ' ;
        end;

        if vTribFed > 0 then
          Result := Result + ' ' + FormatFloatBr( vTribFed,'###,###,##0.00') + sFederal ;
        if vTribEst > 0 then
          Result := Result + ' ' + FormatFloatBr( vTribEst,'###,###,##0.00') + sEstadual;
        if vTribMun > 0 then
          Result := Result + ' ' + FormatFloatBr( vTribMun,'###,###,##0.00') + sMunicipal;
      end
      else
        Result := '';

    end;
  end;
begin
  if (FACBrNFeDANFCeFortesA4.ImprimeTributos = trbNenhum) then
    Text := ''
  else if (FACBrNFeDANFCeFortesA4.ImprimeTributos = trbNormal) then
    Text := ManterValorTributosLinha
  else
    Text := ACBrStr('Voc� pagou aproximadamente : ');
end;


procedure TfrmACBrDANFCeFortesFrA4.RLLabel51BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
begin
  With Self.FACBrNFeDANFCeFortesA4 do
  begin
    if  ( vTribFed > 0 ) and
        ( vTribEst > 0 ) and
        ( vTribMun > 0 ) then
          Text :=  ACBrStr('pelos produtos/servi�os :')
    else
    if  ( vTribFed > 0 ) and
        ( vTribEst = 0 ) and
        ( vTribMun > 0 ) then
          Text :=  ACBrStr('pelos servi�os :')
    else
    if  ( vTribFed > 0 ) and
        ( vTribEst > 0 ) and
        ( vTribMun = 0 ) then
          Text :=  ACBrStr('pelos produtos :')
  end;
end;


procedure TfrmACBrDANFCeFortesFrA4.RLLabel52BeforePrint(Sender: TObject;
  var AText: string; var PrintIt: Boolean);
begin
  Text := FormatFloat('R$ ,0.00;R$ -,0.00', self.FACBrNFeDANFCeFortesA4.FpNFe.Total.ICMSTot.vFrete);
end;

procedure TfrmACBrDANFCeFortesFrA4.RlPelosProdutosBeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
Var
  dPelosProdutos : Double;
begin
  With self.FACBrNFeDANFCeFortesA4 do
  begin
    With FpNFe.Total.ICMSTot do
      dPelosProdutos := (vProd - vDesc + vOutro + vFrete); // Valor Total

    dPelosProdutos := dPelosProdutos - ( vTribFed + vTribEst + vTribMun) ;
  end;
  Text  := FormatFloat('R$ ,0.00', dPelosProdutos );
end;


procedure TfrmACBrDANFCeFortesFrA4.RLLabel50BeforePrint(Sender: TObject;
  var Text: string; var PrintIt: Boolean);
Var
  sTemp : String;
begin
  sTemp := '';
  with FACBrNFeDANFCeFortesA4 do
  begin
    if ( FpNFe.Total.ICMSTot.vTotTrib > 0 ) then
      sTemp := ACBrStr('Informa��o dos Tributos Totais (Lei Federal 12.741/2012 ) ')+
                FormatFloat('R$ ,0.00', FpNFe.Total.ICMSTot.vTotTrib);
    if Trim(FonteTributos) <> '' then
      sTemp := sTemp + 'Fonte : ' + FonteTributos+'  '+ ChaveTributos+' ';
  end;
  Text := sTemp;

end;

end.
