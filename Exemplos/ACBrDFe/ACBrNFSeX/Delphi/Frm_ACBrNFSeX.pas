unit Frm_ACBrNFSeX;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ComCtrls, OleCtrls, SHDocVw,
  ShellAPI, XMLIntf, XMLDoc, zlib,
  ACBrBase, ACBrUtil, ACBrDFe, ACBrDFeReport, ACBrMail, ACBrNFSeX,
  ACBrNFSeXWebservicesResponse,
  ACBrNFSeXDANFSeClass, ACBrNFSeXDANFSeRLClass;

type
  TfrmACBrNFSe = class(TForm)
    pnlMenus: TPanel;
    pnlCentral: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    PageControl4: TPageControl;
    TabSheet3: TTabSheet;
    lSSLLib: TLabel;
    lCryptLib: TLabel;
    lHttpLib: TLabel;
    lXmlSign: TLabel;
    gbCertificado: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    sbtnCaminhoCert: TSpeedButton;
    Label25: TLabel;
    sbtnGetCert: TSpeedButton;
    sbtnNumSerie: TSpeedButton;
    edtCaminho: TEdit;
    edtSenha: TEdit;
    edtNumSerie: TEdit;
    btnDataValidade: TButton;
    btnNumSerie: TButton;
    btnSubName: TButton;
    btnCNPJ: TButton;
    btnIssuerName: TButton;
    grpCalculo: TGroupBox;
    edtTexto: TEdit;
    btnSha256: TButton;
    cbAssinar: TCheckBox;
    btnHTTPS: TButton;
    btnLeituraX509: TButton;
    cbSSLLib: TComboBox;
    cbCryptLib: TComboBox;
    cbHttpLib: TComboBox;
    cbXmlSignLib: TComboBox;
    TabSheet4: TTabSheet;
    GroupBox3: TGroupBox;
    sbtnPathSalvar: TSpeedButton;
    Label29: TLabel;
    Label31: TLabel;
    spPathSchemas: TSpeedButton;
    edtPathLogs: TEdit;
    ckSalvar: TCheckBox;
    cbFormaEmissao: TComboBox;
    cbxAtualizarXML: TCheckBox;
    cbxExibirErroSchema: TCheckBox;
    edtFormatoAlerta: TEdit;
    cbxRetirarAcentos: TCheckBox;
    edtPathSchemas: TEdit;
    TabSheet7: TTabSheet;
    GroupBox4: TGroupBox;
    lTimeOut: TLabel;
    lSSLLib1: TLabel;
    cbxVisualizar: TCheckBox;
    rgTipoAmb: TRadioGroup;
    cbxSalvarSOAP: TCheckBox;
    seTimeOut: TSpinEdit;
    cbSSLType: TComboBox;
    gbProxy: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edtProxyHost: TEdit;
    edtProxyPorta: TEdit;
    edtProxyUser: TEdit;
    edtProxySenha: TEdit;
    gbxRetornoEnvio: TGroupBox;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    cbxAjustarAut: TCheckBox;
    edtTentativas: TEdit;
    edtIntervalo: TEdit;
    edtAguardar: TEdit;
    TabSheet12: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    edtEmitCNPJ: TEdit;
    edtEmitIM: TEdit;
    edtEmitRazao: TEdit;
    edtEmitFantasia: TEdit;
    edtEmitFone: TEdit;
    edtEmitCEP: TEdit;
    edtEmitLogradouro: TEdit;
    edtEmitNumero: TEdit;
    edtEmitComp: TEdit;
    edtEmitBairro: TEdit;
    TabSheet13: TTabSheet;
    sbPathNFSe: TSpeedButton;
    Label35: TLabel;
    cbxSalvarArqs: TCheckBox;
    cbxPastaMensal: TCheckBox;
    cbxAdicionaLiteral: TCheckBox;
    cbxEmissaoPathNFSe: TCheckBox;
    cbxSepararPorCNPJ: TCheckBox;
    edtPathNFSe: TEdit;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    sbtnLogoMarca: TSpeedButton;
    edtLogoMarca: TEdit;
    rgTipoDANFSE: TRadioGroup;
    TabSheet14: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    edtSmtpHost: TEdit;
    edtSmtpPort: TEdit;
    edtSmtpUser: TEdit;
    edtSmtpPass: TEdit;
    edtEmailAssunto: TEdit;
    cbEmailSSL: TCheckBox;
    mmEmailMsg: TMemo;
    btnSalvarConfig: TBitBtn;
    lblColaborador: TLabel;
    lblPatrocinador: TLabel;
    lblDoar1: TLabel;
    lblDoar2: TLabel;
    pgcBotoes: TPageControl;
    tsEnvios: TTabSheet;
    tsConsultas: TTabSheet;
    tsCancelamento: TTabSheet;
    pgRespostas: TPageControl;
    TabSheet5: TTabSheet;
    MemoResp: TMemo;
    TabSheet6: TTabSheet;
    WBResposta: TWebBrowser;
    TabSheet8: TTabSheet;
    memoLog: TMemo;
    TabSheet9: TTabSheet;
    trvwDocumento: TTreeView;
    TabSheet10: TTabSheet;
    memoRespWS: TMemo;
    Dados: TTabSheet;
    MemoDados: TMemo;
    OpenDialog1: TOpenDialog;
    Label6: TLabel;
    lblSchemas: TLabel;
    Label39: TLabel;
    edtPrestLogo: TEdit;
    sbtnPrestLogo: TSpeedButton;
    Label40: TLabel;
    edtPrefeitura: TEdit;
    Label21: TLabel;
    cbCidades: TComboBox;
    Label22: TLabel;
    edtEmitUF: TEdit;
    Label20: TLabel;
    edtCodCidade: TEdit;
    Label32: TLabel;
    edtTotalCidades: TEdit;
    edtEmitCidade: TEdit;
    Label42: TLabel;
    edtEmailRemetente: TEdit;
    cbEmailTLS: TCheckBox;
    btnGerarEnviarLote: TButton;
    btnGerarEnviarNFSe: TButton;
    btnGerarEnviarSincrono: TButton;
    btnImprimir: TButton;
    btnEnviaremail: TButton;
    btnLinkNFSe: TButton;
    btnGerarLoteRPS: TButton;
    btnSubsNFSe: TButton;
    btnConsultarSitLote: TButton;
    btnConsultarLote: TButton;
    btnConsultarNFSeRPS: TButton;
    btnConsultarNFSePeriodo: TButton;
    btnCancNFSe: TButton;
    ACBrMail1: TACBrMail;
    btnConsultarNFSePeloNumero: TButton;
    btnConsultarNFSeFaixa: TButton;
    ACBrNFSeX1: TACBrNFSeX;
    btnEmitir: TButton;
    Label43: TLabel;
    edtCNPJPrefeitura: TEdit;
    tsTeste: TTabSheet;
    btnGerarEnviarTeste_SP: TButton;
    mmoObs: TMemo;
    chkConsultaLoteAposEnvio: TCheckBox;
    chkConsultaAposCancelar: TCheckBox;
    ACBrNFSeXDANFSeRL1: TACBrNFSeXDANFSeRL;
    tsConsServPrest: TTabSheet;
    btnConsultarNFSeServicoPrestadoPorNumero: TButton;
    tsConsServTom: TTabSheet;
    btnConsultarNFSeServicoTomadoPorNumero: TButton;
    btnConsultarNFSeServicoPrestadoPorPeriodo: TButton;
    btnConsultarNFSeServicoPrestadoPorTomador: TButton;
    btnConsultarNFSeServicoPrestadoPorIntermediario: TButton;
    btnConsultarNFSeServicoTomadoPorPeriodo: TButton;
    btnConsultarNFSeServicoTomadoPorPrestador: TButton;
    btnConsultarNFSeServicoTomadoPorIntermediario: TButton;
    btnConsultarNFSeServicoTomadoPorTomador: TButton;
    btnConsultarNFSeGenerico: TButton;
    btnConsNFSeURL: TButton;
    Label30: TLabel;
    edtSenhaWeb: TEdit;
    Label33: TLabel;
    edtUserWeb: TEdit;
    Label34: TLabel;
    edtFraseSecWeb: TEdit;
    Label41: TLabel;
    Label44: TLabel;
    edtChaveAcessoWeb: TEdit;
    edtChaveAutorizWeb: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure btnSalvarConfigClick(Sender: TObject);
    procedure sbPathNFSeClick(Sender: TObject);
    procedure sbtnCaminhoCertClick(Sender: TObject);
    procedure sbtnNumSerieClick(Sender: TObject);
    procedure sbtnGetCertClick(Sender: TObject);
    procedure btnDataValidadeClick(Sender: TObject);
    procedure btnNumSerieClick(Sender: TObject);
    procedure btnSubNameClick(Sender: TObject);
    procedure btnCNPJClick(Sender: TObject);
    procedure btnIssuerNameClick(Sender: TObject);
    procedure btnSha256Click(Sender: TObject);
    procedure btnHTTPSClick(Sender: TObject);
    procedure btnLeituraX509Click(Sender: TObject);
    procedure sbtnPathSalvarClick(Sender: TObject);
    procedure spPathSchemasClick(Sender: TObject);
    procedure sbtnLogoMarcaClick(Sender: TObject);
    procedure PathClick(Sender: TObject);
    procedure cbSSLTypeChange(Sender: TObject);
    procedure cbSSLLibChange(Sender: TObject);
    procedure cbCryptLibChange(Sender: TObject);
    procedure cbHttpLibChange(Sender: TObject);
    procedure cbXmlSignLibChange(Sender: TObject);
    procedure lblColaboradorClick(Sender: TObject);
    procedure lblPatrocinadorClick(Sender: TObject);
    procedure lblDoar1Click(Sender: TObject);
    procedure lblDoar2Click(Sender: TObject);
    procedure lblMouseEnter(Sender: TObject);
    procedure lblMouseLeave(Sender: TObject);
    procedure ACBrNFSeX1GerarLog(const ALogLine: string; var Tratado: Boolean);
    procedure ACBrNFSeX1StatusChange(Sender: TObject);
    procedure sbtnPrestLogoClick(Sender: TObject);
    procedure btnGerarEnviarLoteClick(Sender: TObject);
    procedure btnGerarEnviarNFSeClick(Sender: TObject);
    procedure btnGerarEnviarSincronoClick(Sender: TObject);
    procedure btnGerarLoteRPSClick(Sender: TObject);
    procedure btnSubsNFSeClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure btnEnviaremailClick(Sender: TObject);
    procedure btnLinkNFSeClick(Sender: TObject);
    procedure btnConsultarSitLoteClick(Sender: TObject);
    procedure btnConsultarLoteClick(Sender: TObject);
    procedure btnConsultarNFSeRPSClick(Sender: TObject);
    procedure btnConsultarNFSePeriodoClick(Sender: TObject);
    procedure btnCancNFSeClick(Sender: TObject);
    procedure cbCidadesChange(Sender: TObject);
    procedure btnConsultarNFSePeloNumeroClick(Sender: TObject);
    procedure btnConsultarNFSeFaixaClick(Sender: TObject);
    procedure btnGerarEnviarTeste_SPClick(Sender: TObject);
    procedure btnConsultarNFSeServicoPrestadoPorNumeroClick(Sender: TObject);
    procedure btnConsultarNFSeServicoTomadoPorNumeroClick(Sender: TObject);
    procedure btnEmitirClick(Sender: TObject);
    procedure btnConsultarNFSeServicoPrestadoPorPeriodoClick(Sender: TObject);
    procedure btnConsultarNFSeServicoPrestadoPorTomadorClick(Sender: TObject);
    procedure btnConsultarNFSeServicoPrestadoPorIntermediarioClick(
      Sender: TObject);
    procedure btnConsultarNFSeServicoTomadoPorPeriodoClick(Sender: TObject);
    procedure btnConsultarNFSeServicoTomadoPorPrestadorClick(Sender: TObject);
    procedure btnConsultarNFSeServicoTomadoPorIntermediarioClick(
      Sender: TObject);
    procedure btnConsultarNFSeServicoTomadoPorTomadorClick(Sender: TObject);
    procedure btnConsultarNFSeGenericoClick(Sender: TObject);
    procedure btnConsNFSeURLClick(Sender: TObject);
  private
    { Private declarations }
    procedure GravarConfiguracao;
    procedure LerConfiguracao;
    procedure ConfigurarComponente;
    procedure AlimentarNFSe(NumDFe, NumLote: String);
    procedure LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);
    procedure AtualizarSSLLibsCombo;
    procedure AtualizarCidades;
    function RoundTo5(Valor: Double; Casas: Integer): Double;

    procedure ChecarResposta(const Response: TNFSeWebserviceResponse);
  public
    { Public declarations }
  end;

var
  frmACBrNFSe: TfrmACBrNFSe;

implementation

uses
  strutils, math, TypInfo, DateUtils, synacode, blcksock, FileCtrl, Grids,
  IniFiles, Printers,
  pcnAuxiliar, pcnConversao,
  ACBrDFeConfiguracoes, ACBrDFeSSL, ACBrDFeOpenSSL, ACBrDFeUtil,
  ACBrNFSeXConversao,
  ACBrNFSeXWebserviceBase,
  Frm_Status, Frm_SelecionarCertificado;

const
  SELDIRHELP = 1000;

{$R *.dfm}

{ TfrmACBrNFSe }

procedure TfrmACBrNFSe.ACBrNFSeX1GerarLog(const ALogLine: string;
  var Tratado: Boolean);
begin
  memoLog.Lines.Add(ALogLine);
  Tratado := False;
end;

procedure TfrmACBrNFSe.ACBrNFSeX1StatusChange(Sender: TObject);
begin
  case ACBrNFSeX1.Status of
    stNFSeIdle:
      begin
        if (frmStatus <> nil) then
          frmStatus.Hide;
      end;

    stNFSeRecepcao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando RPS...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsultaSituacao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando a Situa��o...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeConsulta:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Consultando...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeCancelamento:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Cancelando NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeSubstituicao:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Substituindo NFSe...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;

    stNFSeEmail:
      begin
        if (frmStatus = nil) then
          frmStatus := TfrmStatus.Create(Application);
        frmStatus.lblStatus.Caption := 'Enviando Email...';
        frmStatus.Show;
        frmStatus.BringToFront;
      end;
  end;

  Application.ProcessMessages;
end;

procedure TfrmACBrNFSe.AlimentarNFSe(NumDFe, NumLote: String);
var
  ValorISS: Double;
  i: Integer;
begin
  with ACBrNFSeX1 do
  begin
    NotasFiscais.NumeroLote := NumLote;
    NotasFiscais.Transacao := True;

    with NotasFiscais.New.NFSe do
    begin
      // Provedor SigISS
      {
        Situa��o pode ser:
        tp � Tributada no prestador = tsTributadaNoPrestador;
        tt � Tributada no tomador = tsTibutadaNoTomador;
        is � Isenta = tsIsenta;
        im � Imune = tsImune;
        nt � N�o tributada = tsNaoTributada.
      }
      SituacaoTrib := tsTributadaNoPrestador;

//      refNF := '123456789012345678901234567890123456789';
      Numero := NumDFe;
      // Provedor Infisc - Layout Proprio
      cNFSe := GerarCodigoDFe(StrToIntDef(Numero, 0));

      // no Caso dos provedores abaixo o campo SeriePrestacao devemos informar:
      {
        N�mero do equipamento emissor do RPS ou s�rie de presta��o.
        Caso n�o utilize a s�rie, preencha o campo com o valor �99� que indica
        modelo �nico. Caso queira utilizar o campo s�rie para indicar o n�mero do
        equipamento emissor do RPS deve-se solicitar libera��o da prefeitura.
      }
      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
        SeriePrestacao := '99'
      else
        SeriePrestacao := '1';

      NumeroLote := NumLote;

      IdentificacaoRps.Numero := FormatFloat('#########0', StrToInt(NumDFe));

      case ACBrNFSeX1.Configuracoes.Geral.Provedor of
        proNFSeBrasil,
        proEquiplano:
          IdentificacaoRps.Serie := '1';

        proBetha,
        proBethav2,
        proISSDSF,
        proSiat:
          IdentificacaoRps.Serie := 'NF';

        proISSNet:
          if ACBrNFSeX1.Configuracoes.WebServices.Ambiente = taProducao then
            IdentificacaoRps.Serie := '1'
          else
            IdentificacaoRps.Serie := '8';

      else
        IdentificacaoRps.Serie := '85'; // NF
      end;

      // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
      IdentificacaoRps.Tipo := trRPS;

      DataEmissao := Now;
      Competencia := Now;
      DataEmissaoRPS := Now;

      (*
        TnfseNaturezaOperacao = ( no1, no2, no3, no4, no5, no6, no7,
        no50, no51, no52, no53, no54, no55, no56, no57, no58, no59,
        no60, no61, no62, no63, no64, no65, no66, no67, no68, no69,
        no70, no71, no72, no78, no79,
        no101, no111, no121, no201, no301,
        no501, no511, no541, no551, no601, no701 );
      *)

      case ACBrNFSeX1.Configuracoes.Geral.Provedor of
        // Provedor Thema: 50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|78|79
        proThema:
          NaturezaOperacao := no51;
      else
        NaturezaOperacao := no1;
      end;

      {
        TnfseRegimeEspecialTributacao =
        ( retNenhum, retMicroempresaMunicipal, retEstimativa,
          retSociedadeProfissionais, retCooperativa,
          retMicroempresarioIndividual, retMicroempresarioEmpresaPP,
          retLucroReal, retLucroPresumido, retSimplesNacional,
          retImune, retEmpresaIndividualRELI, retEmpresaPP,
          retMicroEmpresario, retOutros);
      }
      RegimeEspecialTributacao := retMicroempresaMunicipal;

      // TnfseSimNao = ( snSim, snNao );
      OptanteSimplesNacional := snNao;

      // TnfseSimNao = ( snSim, snNao );
      IncentivadorCultural := snNao;
      // Provedor Tecnos
      PercentualCargaTributaria := 0;
      ValorCargaTributaria := 0;
      PercentualCargaTributariaMunicipal := 0;
      ValorCargaTributariaMunicipal := 0;
      PercentualCargaTributariaEstadual := 0;
      ValorCargaTributariaEstadual := 0;

      // TnfseSimNao = ( snSim, snNao );
      // snSim = Ambiente de Produ��o
      // snNao = Ambiente de Homologa��o
      if ACBrNFSeX1.Configuracoes.WebServices.Ambiente = taProducao then
        Producao := snSim
      else
        Producao := snNao;

      // TnfseStatusRPS = ( srNormal, srCancelado );
      Status := srNormal;

      // Somente Os provedores Betha, FISSLex e SimplISS permitem incluir no RPS
      // a TAG: OutrasInformacoes os demais essa TAG � gerada e preenchida pelo
      // WebService do provedor.
      OutrasInformacoes := 'Pagamento a Vista';

      // Usado quando o RPS for substituir outro
      {
       RpsSubstituido.Numero := FormatFloat('#########0', i);
       RpsSubstituido.Serie  := 'UNICA';
       // TnfseTipoRPS = ( trRPS, trNFConjugada, trCupom );
       RpsSubstituido.Tipo   := trRPS;
      }

      Servico.Valores.ValorServicos := 100.00;
      Servico.Valores.ValorDeducoes := 0.00;
      Servico.Valores.AliquotaPis := 1.00;
      Servico.Valores.ValorPis := 1.00;
      Servico.Valores.AliquotaCofins := 2.00;
      Servico.Valores.ValorCofins := 2.00;
      Servico.Valores.ValorInss := 0.00;
      Servico.Valores.ValorIr := 0.00;
      Servico.Valores.ValorCsll := 0.00;

      // TnfseSituacaoTributaria = ( stRetencao, stNormal, stSubstituicao );
      // stRetencao = snSim
      // stNormal   = snNao

      // Neste exemplo n�o temos ISS Retido ( stNormal = N�o )
      // Logo o valor do ISS Retido � igual a zero.
      Servico.Valores.IssRetido := stNormal;
      Servico.Valores.ValorIssRetido := 0.00;

      Servico.Valores.OutrasRetencoes := 0.00;
      Servico.Valores.DescontoIncondicionado := 0.00;
      Servico.Valores.DescontoCondicionado := 0.00;

      Servico.Valores.BaseCalculo := Servico.Valores.ValorServicos -
        Servico.Valores.ValorDeducoes - Servico.Valores.DescontoIncondicionado;

      Servico.Valores.Aliquota := 4;

      // No provedor ISSCuritiba a aliquota � gerada dividida por 100, logo no
      // calculo do valor ISS n�o se deve dividir novamente
      case ACBrNFSeX1.Configuracoes.Geral.Provedor of
        proISSCuritiba:
          ValorISS := Servico.Valores.BaseCalculo * Servico.Valores.Aliquota;
      else
        ValorISS := Servico.Valores.BaseCalculo * Servico.Valores.Aliquota / 100;
      end;

      // A fun��o RoundTo5 � usada para arredondar valores, sendo que o segundo
      // parametro se refere ao numero de casas decimais.
      // exemplos: RoundTo5(50.532, -2) ==> 50.53
      // exemplos: RoundTo5(50.535, -2) ==> 50.54
      // exemplos: RoundTo5(50.536, -2) ==> 50.54

      Servico.Valores.ValorISS := RoundTo5(ValorISS, -2);

      Servico.Valores.ValorLiquidoNfse := Servico.Valores.ValorServicos -
        Servico.Valores.ValorPis - Servico.Valores.ValorCofins -
        Servico.Valores.ValorInss - Servico.Valores.ValorIr -
        Servico.Valores.ValorCsll - Servico.Valores.OutrasRetencoes -
        Servico.Valores.ValorIssRetido - Servico.Valores.DescontoIncondicionado
        - Servico.Valores.DescontoCondicionado;

      // TnfseResponsavelRetencao = ( ptTomador, rtPrestador );
      Servico.ResponsavelRetencao := ptTomador;

      Servico.ItemListaServico := '09.01';

      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat,
          proAgiliv2] then
        Servico.CodigoCnae := '452000200'
      else
        Servico.CodigoCnae := '852010';

      if (ACBrNFSeX1.Configuracoes.Geral.Provedor = proISSNet) and
         (ACBrNFSeX1.Configuracoes.WebServices.Ambiente = taHomologacao)  then
        Servico.CodigoCnae := '6511102';

      case ACBrNFSeX1.Configuracoes.Geral.Provedor of
        proSJP:
          Servico.CodigoTributacaoMunicipio := '631940000';

        proCenti:
          Servico.CodigoTributacaoMunicipio := '0901';
      else
        Servico.CodigoTributacaoMunicipio := '63194';
      end;

      Servico.Discriminacao := 'discriminacao I; discriminacao II';

      // Para o provedor ISS.NET em ambiente de Homologa��o
      // o Codigo do Municipio tem que ser '999'
      Servico.CodigoMunicipio := edtCodCidade.Text;
      Servico.UFPrestacao := 'SP';

      // Informar A Exigibilidade ISS para fintelISS [1/2/3/4/5/6/7]
      Servico.ExigibilidadeISS := exiExigivel;

      // Informar para Saatri
      Servico.CodigoPais := 1058; // Brasil
      Servico.MunicipioIncidencia := StrToIntDef(edtCodCidade.Text, 0);

      // Somente o provedor SimplISS permite infomar mais de 1 servi�o
      with Servico.ItemServico.New do
      begin
        // fintelISS, Agili, EL, Equiplano
        // Para o provedor Elotech o tamanho m�ximo � de 20 caracteres
        Descricao := 'Desc. do Serv. 1';

        // fintelISS
        ItemListaServico := '09.01';

        // infisc, EL
        CodServ := '12345';
        // Infisc, EL
        codLCServ := '123';

        ValorDeducoes := 0;
        ValorIss := 0;
        Aliquota := 4;
        BaseCalculo := 100;
        DescontoIncondicionado := 0;
        DescontoCondicionado := 0;

        //EloTech
        Tributavel := snNao;

        // SimplISS, EloTech
        Quantidade := 10;
        ValorUnitario := 5;

        ValorTotal := Quantidade * ValorUnitario;
      end;

      Prestador.IdentificacaoPrestador.CNPJ := edtEmitCNPJ.Text; //'88888888888888';
      Prestador.IdentificacaoPrestador.InscricaoMunicipal := edtEmitIM.Text;

      Prestador.RazaoSocial  := edtEmitRazao.Text;
      Prestador.NomeFantasia := edtEmitRazao.Text;
      // Para o provedor ISSDigital deve-se informar tamb�m:
      Prestador.cUF := UFtoCUF(edtEmitUF.Text);

      Prestador.Endereco.Endereco := edtEmitLogradouro.Text;
      Prestador.Endereco.Numero   := edtEmitNumero.Text;
      Prestador.Endereco.Bairro   := edtEmitBairro.Text;
      Prestador.Endereco.CodigoMunicipio := edtCodCidade.Text;
      Prestador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(edtCodCidade.Text, 0));
      Prestador.Endereco.UF := edtEmitUF.Text;
      Prestador.Endereco.CodigoPais := 1058;
      Prestador.Endereco.xPais := 'BRASIL';
      Prestador.Endereco.CEP := '14800123';

      Prestador.Contato.Telefone := '1633224455';
      Prestador.Contato.Email    := 'nome@provedor.com.br';

      // Para o provedor IPM usar os valores:
      // tpPFNaoIdentificada ou tpPF para pessoa Fisica
      // tpPJdoMunicipio ou tpPJforaMunicipio ou tpPJforaPais para pessoa Juridica

      // Para o provedor SigISS usar os valores acima de forma adquada
      Tomador.IdentificacaoTomador.Tipo := tpPJdoMunicipio;
      Tomador.IdentificacaoTomador.CpfCnpj := edtEmitCNPJ.Text; //'55555555555555';
      Tomador.IdentificacaoTomador.InscricaoMunicipal := '17331600';

      Tomador.RazaoSocial := 'INSCRICAO DE TESTE';

      Tomador.Endereco.TipoLogradouro := 'RUA';
      Tomador.Endereco.Endereco := 'RUA PRINCIPAL';
      Tomador.Endereco.Numero := '100';
      Tomador.Endereco.Complemento := 'APTO 11';
      Tomador.Endereco.Bairro := 'CENTRO';
      Tomador.Endereco.CodigoMunicipio := edtCodCidade.Text;
      Tomador.Endereco.xMunicipio := CodCidadeToCidade(StrToIntDef(edtCodCidade.Text, 0));
      Tomador.Endereco.UF := edtEmitUF.Text;
      Tomador.Endereco.CodigoPais := 1058; // Brasil
      Tomador.Endereco.CEP := edtEmitCEP.Text;

      // Provedor Equiplano � obrigat�rio o pais e IE
      Tomador.Endereco.xPais := 'BRASIL';
      Tomador.IdentificacaoTomador.InscricaoEstadual := '123456';

      if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proSigep] then
        Tomador.Contato.Telefone := '22223333'
      else
        Tomador.Contato.Telefone := '1622223333';

      Tomador.Contato.Email := 'nome@provedor.com.br';

      Tomador.AtualizaTomador := snNao;
      Tomador.TomadorExterior := snNao;

      // Usado quando houver um intermediario na presta��o do servi�o
      // IntermediarioServico.RazaoSocial        := 'razao';
      // IntermediarioServico.CpfCnpj            := '00000000000';
      // IntermediarioServico.InscricaoMunicipal := '12547478';

      // Usado quando o servi�o for uma obra
      // ConstrucaoCivil.CodigoObra := '88888';
      // ConstrucaoCivil.Art        := '433';

      // Condi��o de Pagamento usado pelo provedor Betha vers�o 1 do Layout da ABRASF
      CondicaoPagamento.QtdParcela := 2;
//      CondicaoPagamento.Condicao   := cpAPrazo;
      CondicaoPagamento.Condicao   := cpAVista;

      for i := 1 to CondicaoPagamento.QtdParcela do
      begin
        with CondicaoPagamento.Parcelas.New do
        begin
          Parcela := i;
          DataVencimento := Date + (30 * i);
          Valor := (Servico.Valores.ValorLiquidoNfse / CondicaoPagamento.QtdParcela);
        end;
      end;
    end;
  end;
end;

procedure TfrmACBrNFSe.AtualizarCidades;
var
  IniCidades: TMemIniFile;
  Cidades: TStringList;
  I: Integer;
  sNome, sCod, sUF: String;
begin
  IniCidades := TMemIniFile.Create('');
  Cidades    := TStringList.Create;

  ACBrNFSeX1.LerCidades;
  IniCidades.SetStrings(ACBrNFSeX1.Configuracoes.WebServices.Params);

  try
    IniCidades.ReadSections(Cidades);
    cbCidades.Items.Clear;

    for I := 0 to Pred(Cidades.Count) do
    begin
      if (StrToIntdef(Cidades[I], 0) > 0) then
      begin
        //Exemplo: Alfenas/3101607/MG
        sCod  := Cidades[I];
        sNome := IniCidades.ReadString(sCod, 'Nome', '');
        sUF   := IniCidades.ReadString(sCod, 'UF', '');

        cbCidades.Items.Add(Format('%s/%s/%s', [sNome, sCod, sUF]));
      end;
    end;

    //Sort
    cbCidades.Sorted := false;
    cbCidades.Sorted := true;
    edtTotalCidades.Text := IntToStr(cbCidades.Items.Count);
  finally
    FreeAndNil(Cidades);
    IniCidades.Free;
  end;
end;

procedure TfrmACBrNFSe.AtualizarSSLLibsCombo;
begin
  cbSSLLib.ItemIndex     := Integer(ACBrNFSeX1.Configuracoes.Geral.SSLLib);
  cbCryptLib.ItemIndex   := Integer(ACBrNFSeX1.Configuracoes.Geral.SSLCryptLib);
  cbHttpLib.ItemIndex    := Integer(ACBrNFSeX1.Configuracoes.Geral.SSLHttpLib);
  cbXmlSignLib.ItemIndex := Integer(ACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib);

  cbSSLType.Enabled := (ACBrNFSeX1.Configuracoes.Geral.SSLHttpLib in [httpWinHttp, httpOpenSSL]);
end;

procedure TfrmACBrNFSe.btnCancNFSeClick(Sender: TObject);
var
  NumNFSe, Codigo, Motivo, NumLote, CodVerif, SerNFSe, NumRps,
  SerRps, ValNFSe, ChNFSe: String;
  CodCanc: Integer;
  InfCancelamento: TInfCancelamento;
  Response: TNFSeCancelaNFSeResponse;
  Titulo: string;
begin
  Titulo := 'Cancelar NFSe';

  // Os Provedores da lista requerem que seja informado a chave e o c�digo
  // de cancelamento
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfiscV100, proInfiscV110] then
  begin
    ChNFSe := '12345678';
    if not (InputQuery(Titulo, 'Chave da NFSe', ChNFSe)) then
      exit;

    Codigo := '1';
    if not (InputQuery(Titulo, 'C�digo de Cancelamento', Codigo)) then
      exit;
  end
  else
  begin
    NumNFSe := '';
    if not (InputQuery(Titulo, 'Numero da NFSe', NumNFSe)) then
      exit;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proiiBrasilV2, proWebFisco] then
    begin
      SerNFSe := '1';
      if not (InputQuery(Titulo, 'S�rie da NFSe', SerNFSe)) then
        exit;
    end;

    // Provedor Conam
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proConam then
    begin
      SerNFSe := '1';
      if not (InputQuery(Titulo, 'S�rie da NFSe', SerNFSe)) then
        exit;

      NumRps := '';
      if not (InputQuery(Titulo, 'Numero do RPS', NumRps)) then
        exit;

      SerRps := '';
      if not (InputQuery(Titulo, 'S�rie do Rps', SerRps)) then
        exit;

      ValNFSe := '';
      if not (InputQuery(Titulo, 'Valor da NFSe', ValNFSe)) then
        exit;
    end;

    // Codigo de Cancelamento
    // 1 - Erro de emiss�o
    // 2 - Servi�o n�o concluido
    // 3 - RPS Cancelado na Emiss�o

    Codigo := '1';
    if not (InputQuery(Titulo, 'C�digo de Cancelamento', Codigo)) then
      exit;

    // Provedor SigEp - O c�digo de cancelamento � diferente
    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep then
    begin
      CodCanc := StrToIntDef(Codigo, 1);

      case CodCanc of
        1: Codigo := 'EE';
        2: Codigo := 'ED';
        3: Codigo := 'OU';
        4: Codigo := 'SB';
      end;
    end;

    // Os Provedores da lista requerem que seja informado o motivo do cancelamento
    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAgili, proAssessorPublico,
      proConam, proEquiplano, proGoverna, proIPM, proIPMa, proISSDSF, proLencois,
      proModernizacaoPublica, proPublica, proSiat, proSigISS, proSigep,
      proSmarAPD, proWebFisco, proTecnos] then
    begin
      Motivo := 'Motivo do Cancelamento';
      if not (InputQuery(Titulo, 'Motivo do Cancelamento', Motivo)) then
        exit;
    end;

    if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico then
    begin
      NumLote := '1';
      if not (InputQuery(Titulo, 'Numero do Lote', NumLote)) then
        exit;
    end;

    // Os Provedores da lista requerem que seja informado o c�digo de verifica��o
    if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proInfiscV100, proInfiscV110,
         proISSDSF, proLencois, proGoverna, proSiat, proSigep] then
    begin
      CodVerif := '12345678';
      if not (InputQuery(Titulo, 'C�digo de Verifica��o ou Chave de Autentica��o', CodVerif)) then
        exit;
    end;
  end;

  InfCancelamento := TInfCancelamento.Create;

  try
    with InfCancelamento do
    begin
      NumeroNFSe      := NumNFSe;
      SerieNFSe       := SerNFSe;
      ChaveNFSe       := ChNFSe;
      CodCancelamento := Codigo;
      MotCancelamento := Motivo;
      NumeroLote      := NumLote;
      NumeroRps       := StrToIntDef(NumRps, 0);
      SerieRps        := SerRps;
      ValorNFSe       := StrToFloatDef(ValNFSe, 0);
      CodVerificacao  := CodVerif;
    end;

    Response := ACBrNFSeX1.CancelarNFSe(InfCancelamento);
  finally
    InfCancelamento.Free;
  end;

  ChecarResposta(Response);
end;

procedure TfrmACBrNFSe.btnCNPJClick(Sender: TObject);
begin
  ShowMessage(ACBrNFSeX1.SSL.CertCNPJ);
end;

procedure TfrmACBrNFSe.btnConsNFSeURLClick(Sender: TObject);
var
  xTitulo, NumIniNFSe, CodTrib: String;
  i: Integer;
  InfConsultaNFSe: TInfConsultaNFSe;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe URL Retornado';

  NumIniNFSe := '';
  if not(InputQuery(xTitulo, 'Numero NFSe:', NumIniNFSe)) then
    exit;

  CodTrib := '';
  if not(InputQuery(xTitulo, 'C�digo de Tributa��o do Municipio:', CodTrib)) then
    exit;

  InfConsultaNFSe := TInfConsultaNFSe.Create;

  try
    with InfConsultaNFSe do
    begin
      // Valores aceito para o Tipo de Consulta:
      // tcPorNumero, tcPorFaixa, tcPorPeriodo, tcServicoPrestado,
      // tcServicoTomado, tcPorNumeroURLRetornado
      tpConsulta := tcPorNumeroURLRetornado;

      // Necess�rio para a consulta por numero e por faixa
      NumeroIniNFSe := NumIniNFSe;
      NumeroFinNFSe := NumIniNFSe;

      CodTribMun := CodTrib;
    end;

    Response := ACBrNFSeX1.ConsultarNFSe(InfConsultaNFSe);
  finally
    InfConsultaNFSe.Free;
  end;

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarLoteClick(Sender: TObject);
var
  Protocolo, Lote: String;
  Response: TNFSeConsultaLoteRpsResponse;
  i: Integer;
begin
  Protocolo := '';
  if not (InputQuery('Consultar Lote', 'N�mero do Protocolo (Obrigat�rio):', Protocolo)) then
    exit;

  Lote := '';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico, proElotech,
       proInfiscV100, proInfiscV110, proIPM, proISSDSF, proEquiplano,
       proeGoverneISS, proGeisWeb, proSiat, proSP] then
  begin
    if not (InputQuery('Consultar Lote', 'N�mero do Lote:', Lote)) then
      exit;
  end;

  Response := ACBrNFSeX1.ConsultarLoteRps(Protocolo, Lote);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeFaixaClick(Sender: TObject);
var
  xTitulo, NumNFSeIni, NumNFSeFin, NumPagina: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Por Faixa';

  NumNFSeIni := '';
  if not(InputQuery(xTitulo, 'Numero da NFSe Inicial:', NumNFSeIni)) then
    exit;

  NumNFSeFin := NumNFSeIni;
  if not(InputQuery(xTitulo, 'Numero da NFSe Final:', NumNFSeFin)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSePorFaixa(NumNFSeIni, NumNFSeFin, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add(' ');
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeGenericoClick(Sender: TObject);
var
  xTitulo, NumIniNFSe, NumFinNFSe, DataIni, DataFin,
  CPFCNPJ_Prestador, IM_Prestador, CPFCNPJ_Tomador, IM_Tomador,
  CPFCNPJ_Inter, IM_Inter, NumLote, NumPagina: String;
  i: Integer;
  InfConsultaNFSe: TInfConsultaNFSe;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Gen�rico';

  NumIniNFSe := '';
  if not(InputQuery(xTitulo, 'Numero Inicial da NFSe:', NumIniNFSe)) then
    exit;

  NumFinNFSe := '';
  if not(InputQuery(xTitulo, 'Numero Final da NFSe:', NumFinNFSe)) then
    exit;

  DataIni := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Inicial (DD/MM/AAAA):', DataIni)) then
    exit;

  DataFin := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Final (DD/MM/AAAA):', DataFin)) then
    exit;

  CPFCNPJ_Prestador := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Prestador:', CPFCNPJ_Prestador)) then
    exit;

  IM_Prestador := '';
  if not(InputQuery(xTitulo, 'I.M. Prestador:', IM_Prestador)) then
    exit;

  CPFCNPJ_Tomador := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Tomador:', CPFCNPJ_Tomador)) then
    exit;

  IM_Tomador := '';
  if not(InputQuery(xTitulo, 'I.M. Tomador:', IM_Tomador)) then
    exit;

  CPFCNPJ_Inter := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Intermedi�rio:', CPFCNPJ_Inter)) then
    exit;

  IM_Inter := '';
  if not(InputQuery(xTitulo, 'I.M. Intermedi�rio:', IM_Inter)) then
    exit;

  NumLote := '1';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    if not(InputQuery(xTitulo, 'Numero do Lote:', NumLote)) then
      exit;
  end;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  InfConsultaNFSe := TInfConsultaNFSe.Create;

  try
    with InfConsultaNFSe do
    begin
      // Valores aceito para o Tipo de Consulta:
      // tcPorNumero, tcPorFaixa, tcPorPeriodo, tcServicoPrestado,
      // tcServicoTomado, tcPorNumeroURLRetornado
      tpConsulta := tcPorNumero;

      // Necess�rio para a consulta por numero e por faixa
      NumeroIniNFSe := NumIniNFSe;
      NumeroFinNFSe := NumFinNFSe;

      // Valores aceito para o Tipo de Periodo:
      // tpEmissao, tpCompetencia
      tpPeriodo := tpEmissao;

      // Necess�rio para consulta por periodo
      DataInicial := StrToDateDef(DataIni, 0);
      DataFinal   := StrToDateDef(DataFin, 0);

      // Necess�rio para consulta a servi�o tomado por prestador
      CNPJPrestador := CPFCNPJ_Prestador;
      IMPrestador   := IM_Prestador;

      // Necess�rio para consulta a servi�o prestado ou tomado por tomador
      CNPJTomador := CPFCNPJ_Tomador;
      IMTomador   := IM_Tomador;

      // Necess�rio para consulta a servi�o prestado ou tomado por Intermedi�rio
      CNPJInter := CPFCNPJ_Inter;
      IMInter   := IM_Inter;

      // Necess�rio para os provedores: proISSDSF, proSiat
      NumeroLote := NumLote;

      // Necess�rio para os provedores que seguem a vers�o 2 do layout da ABRASF
      Pagina := StrToIntDef(NumPagina, 1);
    end;

    Response := ACBrNFSeX1.ConsultarNFSe(InfConsultaNFSe);
  finally
    InfConsultaNFSe.Free;
  end;

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSePeloNumeroClick(Sender: TObject);
var
  xTitulo, NumeroNFSe, NumPagina, NumLote, DataIni, DataFin, xTipo: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
  InfConsultaNFSe: TInfConsultaNFSe;
begin
  xTitulo := 'Consultar NFSe Por Numero';

  NumeroNFSe := '';
  if not(InputQuery(xTitulo, 'Numero da NFSe:', NumeroNFSe)) then
    exit;

  NumLote := '1';
  DataIni := '';
  DataFin := '';

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico] then
  begin
    if not(InputQuery(xTitulo, 'Numero do Lote:', NumLote)) then
      exit;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    if not(InputQuery(xTitulo, 'Numero do Lote:', NumLote)) then
      exit;

    DataIni := DateToStr(Date);
    if not (InputQuery(xTitulo, 'Data Inicial (DD/MM/AAAA):', DataIni)) then
      exit;

    DataFin := DateToStr(Date);
    if not (InputQuery(xTitulo, 'Data Final (DD/MM/AAAA):', DataFin)) then
      exit;
  end;

  xTipo := '';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proWebFisco] then
  begin
    if not(InputQuery(xTitulo, 'Tipo da NFSe:', xTipo)) then
      exit;
  end;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  case ACBrNFSeX1.Configuracoes.Geral.Provedor of
    proISSDSF,
    proSiat:
      Response := ACBrNFSeX1.ConsultarNFSePorPeriodo(StrToDateDef(DataIni, 0),
                  StrToDateDef(DataFin, 0), StrToIntDef(NumPagina, 1), NumLote);

    proAssessorPublico:
      begin
        InfConsultaNFSe := TInfConsultaNFSe.Create;

        try
          with InfConsultaNFSe do
          begin
            tpConsulta := tcPorNumero;

            NumeroIniNFSe := NumeroNFSe;
            NumeroLote := NumLote;
            Pagina := StrToIntDef(NumPagina, 1);
          end;

          Response := ACBrNFSeX1.ConsultarNFSe(InfConsultaNFSe);
        finally
          InfConsultaNFSe.Free;
        end;
      end;
  else
    Response := ACBrNFSeX1.ConsultarNFSeporNumero(NumeroNFSe);
  end;

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSePeriodoClick(Sender: TObject);
var
  xTitulo, DataIni, DataFin, NumPagina, NumLote: String;
  Response: TNFSeConsultaNFSeResponse;
  i: Integer;
begin
  xTitulo := 'Consultar NFSe por Per�odo';

  DataIni := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Inicial (DD/MM/AAAA):', DataIni)) then
    exit;

  DataFin := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Final (DD/MM/AAAA):', DataFin)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  NumLote := '1';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    if not(InputQuery(xTitulo, 'Numero do Lote:', NumLote)) then
      exit;
  end;

  Response := ACBrNFSeX1.ConsultarNFSeporPeriodo(StrToDateDef(DataIni, 0),
    StrToDateDef(DataFin, 0), StrToIntDef(NumPagina, 1), NumLote);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeRPSClick(Sender: TObject);
var
  NumeroRps, SerieRps, TipoRps, //NumeroLote,
  CodVerificacao: String;
  iTipoRps: Integer;
  Response: TNFSeConsultaNFSeporRpsResponse;
  i: Integer;
begin
  NumeroRps := '';
  if not (InputQuery('Consultar NFSe por RPS', 'Numero do RPS:', NumeroRps)) then
    exit;

  SerieRps := '1';
  if not (InputQuery('Consultar NFSe por RPS', 'Serie do RPS:', SerieRps)) then
    exit;

  TipoRps := '1';
  if not (InputQuery('Consultar NFSe por RPS', 'Tipo do RPS:', TipoRps)) then
    exit;

  // Provedor ISSDSF e Siat
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proISSDSF, proSiat] then
  begin
    // Utilizado como serie da presta��o
    SerieRps := '99';
  end;

  // Provedor SigEp o Tipo do RPS � diferente
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);

    case iTipoRps of
      1: TipoRps := 'R1';
      2: TipoRps := 'R2';
      3: TipoRps := 'R3';
    end;
  end;

  // Provedor Agili o Tipo do RPS � diferente
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAgili then
  begin
    iTipoRps := StrToIntDef(TipoRps, 1);

    case iTipoRps of
      1: TipoRps := '-2';
      2: TipoRps := '-4';
      3: TipoRps := '-5';
    end;
  end;
  {
  NumeroLote := '';
  if not (InputQuery('Consultar NFSe por RPS', 'Numero do Lote:', NumeroLote)) then
    exit;
  }
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proGiap, proGoverna] then
  begin
    CodVerificacao := '123';
    if not (InputQuery('Consultar NFSe por RPS', 'Codigo Verifica��o:', CodVerificacao)) then
      exit;
  end;

  Response := ACBrNFSeX1.ConsultarNFSeporRps(NumeroRps, SerieRps, TipoRps, //NumeroLote,
    CodVerificacao);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoPrestadoPorIntermediarioClick(
  Sender: TObject);
var
  xTitulo, NumPagina, CPFCNPJInter, IMInter: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Prestado Por Intermedi�rio';

  CPFCNPJInter := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Intermedi�rio:', CPFCNPJInter)) then
    exit;

  IMInter := '';
  if not(InputQuery(xTitulo, 'I.M. Intermedi�rio:', IMInter)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoPrestadoPorIntermediario(CPFCNPJInter,
    IMInter, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoPrestadoPorNumeroClick(Sender: TObject);
var
  xTitulo, NumeroNFSe, NumPagina: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Prestado Por N�mero';

  NumeroNFSe := '0';
  if not(InputQuery(xTitulo, 'Numero da NFSe:', NumeroNFSe)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoPrestadoPorNumero(NumeroNFSe, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoPrestadoPorPeriodoClick(
  Sender: TObject);
var
  xTitulo, NumPagina, DataIni, DataFin: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Prestado Por Periodo';

  DataIni := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Inicial (DD/MM/AAAA):', DataIni)) then
    exit;

  DataFin := DataIni;
  if not (InputQuery(xTitulo, 'Data Final (DD/MM/AAAA):', DataFin)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoPrestadoPorPeriodo(StrToDateDef(DataIni, 0),
    StrToDateDef(DataFin, 0), StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoPrestadoPorTomadorClick(
  Sender: TObject);
var
  xTitulo, NumPagina, CPFCNPJTomador, IMTomador: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Prestado Por Tomador';

  CPFCNPJTomador := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Tomador:', CPFCNPJTomador)) then
    exit;

  IMTomador := '';
  if not(InputQuery(xTitulo, 'I.M. Tomador:', IMTomador)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoPrestadoPorTomador(CPFCNPJTomador,
    IMTomador, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoTomadoPorIntermediarioClick(
  Sender: TObject);
var
  xTitulo, NumPagina, CPFCNPJInter, IMInter: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Tomado Por Intermedi�rio';

  CPFCNPJInter := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Intermedi�rio:', CPFCNPJInter)) then
    exit;

  IMInter := '';
  if not(InputQuery(xTitulo, 'I.M. Intermedi�rio:', IMInter)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoTomadoPorIntermediario(CPFCNPJInter,
    IMInter, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoTomadoPorNumeroClick(Sender: TObject);
var
  xTitulo, NumeroNFSe, NumPagina: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Tomado Por N�mero';

  NumeroNFSe := '';
  if not(InputQuery(xTitulo, 'Numero da NFSe:', NumeroNFSe)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoTomadoPorNumero(NumeroNFSe, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarSitLoteClick(Sender: TObject);
var
  Protocolo, Lote: String;
  Response: TNFSeConsultaSituacaoResponse;
begin
  Protocolo := '';
  if not (InputQuery('Consultar Lote', 'N�mero do Protocolo (Obrigat�rio):', Protocolo)) then
    exit;

  Lote := '';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAssessorPublico,
      proEquiplano, proSP] then
  begin
    if not (InputQuery('Consultar Lote', 'N�mero do Lote:', Lote)) then
      exit;
  end;

  Response := ACBrNFSeX1.ConsultarSituacao(Protocolo, Lote);

  ChecarResposta(Response);
end;

procedure TfrmACBrNFSe.btnDataValidadeClick(Sender: TObject);
begin
  ShowMessage(FormatDateBr(ACBrNFSeX1.SSL.CertDataVenc));
end;

procedure TfrmACBrNFSe.btnEmitirClick(Sender: TObject);
var
  sQtde, vNumRPS, vNumLote: String;
  iQtde, iAux, I: Integer;
  Response: TNFSeEmiteResponse;
begin
  sQtde := '1';
  if not(InputQuery('Emitir', 'Quantidade de RPS', sQtde)) then
    exit;

  vNumRPS := '';
  if not(InputQuery('Emitir', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Emitir', 'Numero do Lote', vNumLote)) then
    exit;

  iQtde := StrToIntDef(sQtde, 1);
  iAux := StrToIntDef(vNumRPS, 1);

  ACBrNFSeX1.NotasFiscais.Clear;

  for I := 1 to iQtde do
  begin
    vNumRPS := IntToStr(iAux);
    AlimentarNFSe(vNumRPS, vNumLote);
    inc(iAux);
  end;

  Response := ACBrNFSeX1.Emitir(vNumLote);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for I := 0 to iQtde - 1 do
  begin
    MemoDados.Lines.Add('Nome XML: ' + ACBrNFSeX1.NotasFiscais.Items[I].NomeArq);
    MemoDados.Lines.Add('Nota Numero: ' + ACBrNFSeX1.NotasFiscais.Items[I].NFSe.Numero);
    MemoDados.Lines.Add('C�digo de Verifica��o: ' +
                       ACBrNFSeX1.NotasFiscais.Items[I].NFSe.CodigoVerificacao);
  end;
end;

procedure TfrmACBrNFSe.btnEnviaremailClick(Sender: TObject);
var
  vAux: String;
  sCC: TStrings;
begin
  OpenDialog1.Title := 'Selecione a NFSe';
  OpenDialog1.DefaultExt := '*-NFSe.xml';
  OpenDialog1.Filter :=
    'Arquivos NFSe (*-NFSe.xml)|*-NFSe.xml|Arquivos XML (*.xml)|*.xml|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFSeX1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNFSeX1.NotasFiscais.Clear;
    ACBrNFSeX1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);

    if not(InputQuery('Enviar e-mail', 'Destinat�rio', vAux)) then
      exit;

    sCC := TStringList.Create;
    sCC.Clear; // Usando para add outros e-mail como Com-C�pia

    ACBrNFSeX1.NotasFiscais.Items[0].EnviarEmail(vAux, edtEmailAssunto.Text,
      mmEmailMsg.Lines, True // Enviar PDF junto
      , nil // Lista com emails que ser�o enviado c�pias - TStrings
      , nil // Lista de anexos - TStrings
      );

    sCC.Free;

    MemoDados.Lines.Add('Arquivo Carregado de: ' + ACBrNFSeX1.NotasFiscais.Items[0].NomeArq);
    MemoResp.Lines.LoadFromFile(ACBrNFSeX1.NotasFiscais.Items[0].NomeArq);
    LoadXML(MemoResp.Text, WBResposta);

    pgRespostas.ActivePageIndex := 2;
  end;
end;

procedure TfrmACBrNFSe.btnGerarEnviarLoteClick(Sender: TObject);
var
  sQtde, vNumRPS, vNumLote: String;
  iQtde, iAux, I: Integer;
  Response: TNFSeEmiteResponse;
begin
  sQtde := '1';
  if not(InputQuery('Gerar e Enviar um Lote de RPS (Ass�ncrono)', 'Quantidade de RPS', sQtde)) then
    exit;

  vNumRPS := '';
  if not(InputQuery('Gerar e Enviar um Lote de RPS (Ass�ncrono)', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Gerar e Enviar um Lote de RPS (Ass�ncrono)', 'Numero do Lote', vNumLote)) then
    exit;

  iQtde := StrToIntDef(sQtde, 1);
  iAux := StrToIntDef(vNumRPS, 1);

  ACBrNFSeX1.NotasFiscais.Clear;

  for I := 1 to iQtde do
  begin
    vNumRPS := IntToStr(iAux);
    AlimentarNFSe(vNumRPS, vNumLote);
    inc(iAux);
  end;

  {
     O m�todo Emitir possui os seguintes par�metros:
     aNumLote (Integer ou String)
     aModEnvio [meAutomatico, meLoteAssincrono, meLoteSincrono, meUnitario, meTeste]
     aImprimir (Boolean)
  }
  Response := ACBrNFSeX1.Emitir(vNumLote, meLoteAssincrono);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for I := 0 to iQtde - 1 do
  begin
    MemoDados.Lines.Add('Nome XML: ' + ACBrNFSeX1.NotasFiscais.Items[I].NomeArq);
    MemoDados.Lines.Add('Nota Numero: ' + ACBrNFSeX1.NotasFiscais.Items[I].NFSe.Numero);
    MemoDados.Lines.Add('C�digo de Verifica��o: ' +
                       ACBrNFSeX1.NotasFiscais.Items[I].NFSe.CodigoVerificacao);
  end;
end;

procedure TfrmACBrNFSe.btnGerarEnviarNFSeClick(Sender: TObject);
var
  vNumRPS, vNumLote, sNomeArq: String;
  Response: TNFSeEmiteResponse;
begin
  // **************************************************************************
  //
  // A function Gerar s� esta disponivel para alguns provedores.
  //
  // **************************************************************************
  vNumRPS := '';
  if not(InputQuery('Gerar e Enviar um RPS', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Gerar e Enviar um RPS', 'Numero do Lote', vNumLote)) then
    exit;

  ACBrNFSeX1.NotasFiscais.Clear;
  AlimentarNFSe(vNumRPS, vNumLote);

  {
     O m�todo Emitir possui os seguintes par�metros:
     aNumLote (Integer ou String)
     aModEnvio [meAutomatico, meLoteAssincrono, meLoteSincrono, meUnitario]
     aImprimir (Boolean)
  }
  Response := ACBrNFSeX1.Emitir(vNumLote, meUnitario);

  ChecarResposta(Response);

  sNomeArq := ACBrNFSeX1.NotasFiscais.Items[0].NomeArq;

  if sNomeArq <> '' then
  begin
    ACBrNFSeX1.NotasFiscais.Clear;
    ACBrNFSeX1.NotasFiscais.LoadFromFile(sNomeArq);
    ACBrNFSeX1.NotasFiscais.Imprimir;

    MemoDados.Lines.Add('Arquivo Carregado de: ' + sNomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnGerarEnviarSincronoClick(Sender: TObject);
var
  sQtde, vNumRPS, vNumLote: String;
  Response: TNFSeEmiteResponse;
  iQtde, iAux, i: Integer;
begin
  sQtde := '1';
  if not(InputQuery('Gerar e Enviar um Lote de RPS (S�ncrono)', 'Quantidade de RPS', sQtde)) then
    exit;

  vNumRPS := '';
  if not(InputQuery('Gerar e Enviar um Lote de RPS (S�ncrono)', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Gerar e Enviar um Lote de RPS (S�ncrono)', 'Numero do Lote', vNumLote)) then
    exit;

  iQtde := StrToIntDef(sQtde, 1);
  iAux := StrToIntDef(vNumRPS, 1);

  ACBrNFSeX1.NotasFiscais.Clear;

  for I := 1 to iQtde do
  begin
    vNumRPS := IntToStr(iAux);
    AlimentarNFSe(vNumRPS, vNumLote);
    inc(iAux);
  end;

  {
     O m�todo Emitir possui os seguintes par�metros:
     aNumLote (Integer ou String)
     aModEnvio [meAutomatico, meLoteAssincrono, meLoteSincrono, meUnitario, meTeste]
     aImprimir (Boolean)
  }
  Response := ACBrNFSeX1.Emitir(vNumLote, meLoteSincrono);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for I := 0 to iQtde - 1 do
  begin
    MemoDados.Lines.Add('Nome XML: ' + ACBrNFSeX1.NotasFiscais.Items[I].NomeArq);
    MemoDados.Lines.Add('Nota Numero: ' + ACBrNFSeX1.NotasFiscais.Items[I].NFSe.Numero);
    MemoDados.Lines.Add('C�digo de Verifica��o: ' +
                       ACBrNFSeX1.NotasFiscais.Items[I].NFSe.CodigoVerificacao);
  end;
end;

procedure TfrmACBrNFSe.btnGerarLoteRPSClick(Sender: TObject);
var
  vNumRPS, vNumLote: String;
begin
  // **************************************************************************
  //
  // A function GerarLote apenas gera o XML do lote, assina se necess�rio
  // e valida, salvando o arquivo com o nome: <lote>-lot-rps.xml na pasta Ger
  // N�o ocorre o envio para nenhum webservice.
  //
  // **************************************************************************
  vNumRPS := '';
  if not(InputQuery('Gerar e Enviar Lote', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Gerar e Enviar Lote', 'Numero do Lote', vNumLote)) then
    exit;

  ACBrNFSeX1.NotasFiscais.Clear;
  AlimentarNFSe(vNumRPS, vNumLote);

  ACBrNFSeX1.GerarLote(vNumLote);

  ShowMessage('Arquivo gerado em: ' + ACBrNFSeX1.NotasFiscais.Items[0].NomeArq);

  ACBrNFSeX1.NotasFiscais.Clear;

  pgRespostas.ActivePageIndex := 2;
end;

procedure TfrmACBrNFSe.btnHTTPSClick(Sender: TObject);
var
  Acao: String;
  OldUseCert: Boolean;
begin
  Acao := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' +
     '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
     'xmlns:cli="http://cliente.bean.master.sigep.bsb.correios.com.br/"> ' +
     ' <soapenv:Header/>' +
     ' <soapenv:Body>' +
     ' <cli:consultaCEP>' +
     ' <cep>18270-170</cep>' +
     ' </cli:consultaCEP>' +
     ' </soapenv:Body>' +
     ' </soapenv:Envelope>';

  OldUseCert := ACBrNFSeX1.SSL.UseCertificateHTTP;
  ACBrNFSeX1.SSL.UseCertificateHTTP := False;

  try
    MemoResp.Lines.Text := ACBrNFSeX1.SSL.Enviar(Acao, 'https://apps.correios.com.br/SigepMasterJPA/AtendeClienteService/AtendeCliente?wsdl', '');
  finally
    ACBrNFSeX1.SSL.UseCertificateHTTP := OldUseCert;
  end;

  pgRespostas.ActivePageIndex := 0;
end;

procedure TfrmACBrNFSe.btnImprimirClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione a NFSe';
  OpenDialog1.DefaultExt := '*-NFSe.xml';
  OpenDialog1.Filter :=
    'Arquivos NFSe (*-NFSe.xml)|*-NFSe.xml|Arquivos XML (*.xml)|*.xml|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ACBrNFSeX1.Configuracoes.Arquivos.PathSalvar;

  if OpenDialog1.Execute then
  begin
    ACBrNFSeX1.NotasFiscais.Clear;
    ACBrNFSeX1.NotasFiscais.LoadFromFile(OpenDialog1.FileName);
    ACBrNFSeX1.NotasFiscais.Imprimir;
    ACBrNFSeX1.NotasFiscais.ImprimirPDF;

    if ACBrNFSeX1.NotasFiscais.Items[0].NomeArqRps <> '' then
      MemoDados.Lines.Add('Arquivo Carregado de: ' + ACBrNFSeX1.NotasFiscais.Items[0].NomeArqRps)
    else
      MemoDados.Lines.Add('Arquivo Carregado de: ' + ACBrNFSeX1.NotasFiscais.Items[0].NomeArq);

    MemoDados.Lines.Add('Nota Numero: ' + ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Numero);
    MemoDados.Lines.Add('C�digo de Verifica��o: ' + ACBrNFSeX1.NotasFiscais.Items[0].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Data de Emiss�o: ' + DateToStr(ACBrNFSeX1.NotasFiscais.Items[0].NFSe.DataEmissao));

    if ACBrNFSeX1.NotasFiscais.Items[0].NomeArqRps <> '' then
      MemoResp.Lines.LoadFromFile(ACBrNFSeX1.NotasFiscais.Items[0].NomeArqRps)
    else
      MemoResp.Lines.LoadFromFile(ACBrNFSeX1.NotasFiscais.Items[0].NomeArq);

    LoadXML(MemoResp.Text, WBResposta);

    pgRespostas.ActivePageIndex := 2;
  end;
end;

procedure TfrmACBrNFSe.btnIssuerNameClick(Sender: TObject);
begin
  ShowMessage(ACBrNFSeX1.SSL.CertIssuerName + sLineBreak + sLineBreak +
              'Certificadora: ' + ACBrNFSeX1.SSL.CertCertificadora);
end;

procedure TfrmACBrNFSe.btnLeituraX509Click(Sender: TObject);
//var
//  Erro, AName: String;
begin
  with ACBrNFSeX1.SSL do
  begin
     CarregarCertificadoPublico(AnsiString(MemoDados.Lines.Text));
     MemoResp.Lines.Add(CertIssuerName);
     MemoResp.Lines.Add(CertRazaoSocial);
     MemoResp.Lines.Add(CertCNPJ);
     MemoResp.Lines.Add(CertSubjectName);
     MemoResp.Lines.Add(CertNumeroSerie);

    //MemoDados.Lines.LoadFromFile('c:\temp\teste2.xml');
    //MemoResp.Lines.Text := Assinar(MemoDados.Lines.Text, 'Entrada', 'Parametros');
    //Erro := '';
    //if VerificarAssinatura(MemoResp.Lines.Text, Erro, 'Parametros' ) then
    //  ShowMessage('OK')
    //else
    //  ShowMessage('ERRO: '+Erro)

    pgRespostas.ActivePageIndex := 0;
  end;
end;

procedure TfrmACBrNFSe.btnLinkNFSeClick(Sender: TObject);
var
  vNumNFSe, sCodVerif, sLink: String;
begin
  if not(InputQuery('Gerar o Link da NFSe', 'Numero da NFSe', vNumNFSe)) then
    exit;

  if not(InputQuery('Gerar o Link da NFSe', 'Codigo de Verificacao', sCodVerif)) then
    exit;

  sLink := ACBrNFSeX1.LinkNFSe(vNumNFSe, sCodVerif);

  MemoResp.Lines.Add('Link Gerado: ' + sLink);

  pgRespostas.ActivePageIndex := 0;
end;

procedure TfrmACBrNFSe.btnNumSerieClick(Sender: TObject);
begin
  ShowMessage(ACBrNFSeX1.SSL.CertNumeroSerie);
end;

procedure TfrmACBrNFSe.btnSalvarConfigClick(Sender: TObject);
begin
  GravarConfiguracao;
end;

procedure TfrmACBrNFSe.btnSha256Click(Sender: TObject);
var
  Ahash: String;
  xAssinatura: TStringList;
begin
  xAssinatura := TStringList.Create;
  try
    xAssinatura.Add(edtTexto.Text);

    Ahash := string(ACBrNFSeX1.SSL.CalcHash(xAssinatura, dgstSHA256, outBase64, cbAssinar.Checked));
    MemoResp.Lines.Add( Ahash );
    pgRespostas.ActivePageIndex := 0;
  finally
    xAssinatura.Free;
  end;
end;

procedure TfrmACBrNFSe.btnSubNameClick(Sender: TObject);
begin
  ShowMessage(ACBrNFSeX1.SSL.CertSubjectName + sLineBreak + sLineBreak +
              'Raz�o Social: ' + ACBrNFSeX1.SSL.CertRazaoSocial);
end;

procedure TfrmACBrNFSe.btnSubsNFSeClick(Sender: TObject);
var
  vNumRPS, Codigo, Motivo, sNumNFSe, sSerieNFSe, NumLote, CodVerif: String;
  CodCanc: Integer;
  Response: TNFSeSubstituiNFSeResponse;
begin
  vNumRPS := '';
  if not(InputQuery('Substituir NFS-e', 'Numero do novo RPS', vNumRPS)) then
    exit;

  ACBrNFSeX1.NotasFiscais.Clear;
  AlimentarNFSe(vNumRPS, '1');

  // Codigo de Cancelamento
  // 1 - Erro de emiss�o
  // 2 - Servi�o n�o concluido
  // 3 - RPS Cancelado na Emiss�o

  Codigo := '1';
  if not(InputQuery('Substituir NFSe', 'C�digo de Cancelamento', Codigo)) then
    exit;

  // Provedor SigEp o c�digo de cancelamento � diferente
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proSigep then
  begin
    CodCanc := StrToIntDef(Codigo, 1);

    case CodCanc of
      1: Codigo := 'EE';
      2: Codigo := 'ED';
      3: Codigo := 'OU';
      4: Codigo := 'SB';
    end;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proAgili, proConam, proEquiplano,
    proGoverna, proIPM, proIPMa, proISSDSF, proLencois, proModernizacaoPublica,
    proPublica, proSiat, proSigISS, proSmarAPD, proWebFisco] then
  begin
    Motivo := 'Teste de Cancelamento';
    if not (InputQuery('Cancelar NFSe', 'Motivo de Cancelamento', Motivo)) then
      exit;
  end;

  sNumNFSe := vNumRPS;
  if not(InputQuery('Substituir NFS-e', 'Numero da NFS-e', sNumNFSe)) then
    exit;

  sSerieNFSe := '';
  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proiiBrasilV2 then
  begin
    if not(InputQuery('Substituir NFS-e', 'S�rie da NFS-e', sSerieNFSe)) then
      exit;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor = proAssessorPublico then
  begin
    NumLote := '1';
    if not (InputQuery('Cancelar NFSe', 'Numero do Lote', NumLote)) then
      exit;
  end;

  if ACBrNFSeX1.Configuracoes.Geral.Provedor in [proLencois, proGoverna,
       proSiat, proSigep] then
  begin
    CodVerif := '12345678';
    if not (InputQuery('Cancelar NFSe', 'C�digo de Verifica��o', CodVerif)) then
      exit;
  end;

  Response := ACBrNFSeX1.SubstituirNFSe(sNumNFSe, sSerieNFSe, Codigo,
                                        Motivo, NumLote, CodVerif);

  ChecarResposta(Response);

  MemoDados.Lines.Add('Retorno da Substitui��o:');
  MemoDados.Lines.Add('C�d. Cancelamento: ' + Response.InfCancelamento.CodCancelamento);
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoTomadoPorPeriodoClick(Sender: TObject);
var
  xTitulo, NumPagina, DataIni, DataFin: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Tomado Por Periodo';

  DataIni := DateToStr(Date);
  if not (InputQuery(xTitulo, 'Data Inicial (DD/MM/AAAA):', DataIni)) then
    exit;

  DataFin := DataIni;
  if not (InputQuery(xTitulo, 'Data Final (DD/MM/AAAA):', DataFin)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoTomadoPorPeriodo(StrToDateDef(DataIni, 0),
    StrToDateDef(DataFin, 0), StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoTomadoPorPrestadorClick(Sender: TObject);
var
  xTitulo, NumPagina, CPFCNPJPrestador, IMPrestador: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Tomado Por Prestador';

  CPFCNPJPrestador := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Prestador:', CPFCNPJPrestador)) then
    exit;

  IMPrestador := '';
  if not(InputQuery(xTitulo, 'I.M. Prestador:', IMPrestador)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoTomadoPorPrestador(CPFCNPJPrestador,
    IMPrestador, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnConsultarNFSeServicoTomadoPorTomadorClick(
  Sender: TObject);
var
  xTitulo, NumPagina, CPFCNPJTomador, IMTomador: String;
  i: Integer;
  Response: TNFSeConsultaNFSeResponse;
begin
  xTitulo := 'Consultar NFSe Servi�o Tomado Por Tomador';

  CPFCNPJTomador := '';
  if not(InputQuery(xTitulo, 'CPF/CNPJ Tomador:', CPFCNPJTomador)) then
    exit;

  IMTomador := '';
  if not(InputQuery(xTitulo, 'I.M. Tomador:', IMTomador)) then
    exit;

  NumPagina := '1';
  if not(InputQuery(xTitulo, 'Pagina:', NumPagina)) then
    exit;

  Response := ACBrNFSeX1.ConsultarNFSeServicoTomadoPorTomador(CPFCNPJTomador,
    IMTomador, StrToIntDef(NumPagina, 1));

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for i := 0 to ACBrNFSeX1.NotasFiscais.Count -1 do
  begin
    MemoDados.Lines.Add('NFS-e Numero....: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.Numero);
    MemoDados.Lines.Add('Cod. Verificacao: ' + ACBrNFSeX1.NotasFiscais.Items[i].NFSe.CodigoVerificacao);
    MemoDados.Lines.Add('Nome do arquivo.: ' + ACBrNFSeX1.NotasFiscais.Items[i].NomeArq);
  end;
end;

procedure TfrmACBrNFSe.btnGerarEnviarTeste_SPClick(Sender: TObject);
var
  sQtde, vNumRPS, vNumLote: String;
  iQtde, iAux, I: Integer;
  Response: TNFSeEmiteResponse;
begin
  sQtde := '1';
  if not(InputQuery('Teste de Envio', 'Quantidade de RPS', sQtde)) then
    exit;

  vNumRPS := '';
  if not(InputQuery('Teste de Envio', 'Numero do RPS', vNumRPS)) then
    exit;

  vNumLote := vNumRPS;
  if not(InputQuery('Teste de Envio', 'Numero do Lote', vNumLote)) then
    exit;

  iQtde := StrToIntDef(sQtde, 1);
  iAux := StrToIntDef(vNumRPS, 1);

  ACBrNFSeX1.NotasFiscais.Clear;

  for I := 1 to iQtde do
  begin
    vNumRPS := IntToStr(iAux);
    AlimentarNFSe(vNumRPS, vNumLote);
    inc(iAux);
  end;

  {
     O m�todo Emitir possui os seguintes par�metros:
     aNumLote (Integer ou String)
     aModEnvio [meAutomatico, meLoteAssincrono, meLoteSincrono, meUnitario, meTeste]
     aImprimir (Boolean)
  }
  Response := ACBrNFSeX1.Emitir(vNumLote, meTeste);

  ChecarResposta(Response);

  MemoDados.Lines.Clear;

  for I := 0 to iQtde - 1 do
  begin
    MemoDados.Lines.Add('Nome XML: ' + ACBrNFSeX1.NotasFiscais.Items[I].NomeArq);
    MemoDados.Lines.Add('Nota Numero: ' + ACBrNFSeX1.NotasFiscais.Items[I].NFSe.Numero);
    MemoDados.Lines.Add('C�digo de Verifica��o: ' +
                       ACBrNFSeX1.NotasFiscais.Items[I].NFSe.CodigoVerificacao);
  end;
end;

procedure TfrmACBrNFSe.cbCryptLibChange(Sender: TObject);
begin
  try
    if cbCryptLib.ItemIndex <> -1 then
      ACBrNFSeX1.Configuracoes.Geral.SSLCryptLib := TSSLCryptLib(cbCryptLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNFSe.cbHttpLibChange(Sender: TObject);
begin
  try
    if cbHttpLib.ItemIndex <> -1 then
      ACBrNFSeX1.Configuracoes.Geral.SSLHttpLib := TSSLHttpLib(cbHttpLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNFSe.cbSSLLibChange(Sender: TObject);
begin
  try
    if cbSSLLib.ItemIndex <> -1 then
      ACBrNFSeX1.Configuracoes.Geral.SSLLib := TSSLLib(cbSSLLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNFSe.cbSSLTypeChange(Sender: TObject);
begin
  if cbSSLType.ItemIndex <> -1 then
    ACBrNFSeX1.SSL.SSLType := TSSLType(cbSSLType.ItemIndex);
end;

procedure TfrmACBrNFSe.cbXmlSignLibChange(Sender: TObject);
begin
  try
    if cbXmlSignLib.ItemIndex <> -1 then
      ACBrNFSeX1.Configuracoes.Geral.SSLXmlSignLib := TSSLXmlSignLib(cbXmlSignLib.ItemIndex);
  finally
    AtualizarSSLLibsCombo;
  end;
end;

procedure TfrmACBrNFSe.FormCreate(Sender: TObject);
var
  T: TSSLLib;
  I: TpcnTipoEmissao;
  U: TSSLCryptLib;
  V: TSSLHttpLib;
  X: TSSLXmlSignLib;
  Y: TSSLType;
begin
  cbSSLLib.Items.Clear;
  for T := Low(TSSLLib) to High(TSSLLib) do
    cbSSLLib.Items.Add( GetEnumName(TypeInfo(TSSLLib), integer(T) ) );
  cbSSLLib.ItemIndex := 0;

  cbCryptLib.Items.Clear;
  for U := Low(TSSLCryptLib) to High(TSSLCryptLib) do
    cbCryptLib.Items.Add( GetEnumName(TypeInfo(TSSLCryptLib), integer(U) ) );
  cbCryptLib.ItemIndex := 0;

  cbHttpLib.Items.Clear;
  for V := Low(TSSLHttpLib) to High(TSSLHttpLib) do
    cbHttpLib.Items.Add( GetEnumName(TypeInfo(TSSLHttpLib), integer(V) ) );
  cbHttpLib.ItemIndex := 0;

  cbXmlSignLib.Items.Clear;
  for X := Low(TSSLXmlSignLib) to High(TSSLXmlSignLib) do
    cbXmlSignLib.Items.Add( GetEnumName(TypeInfo(TSSLXmlSignLib), integer(X) ) );
  cbXmlSignLib.ItemIndex := 0;

  cbSSLType.Items.Clear;
  for Y := Low(TSSLType) to High(TSSLType) do
    cbSSLType.Items.Add( GetEnumName(TypeInfo(TSSLType), integer(Y) ) );
  cbSSLType.ItemIndex := 0;

  cbFormaEmissao.Items.Clear;
  for I := Low(TpcnTipoEmissao) to High(TpcnTipoEmissao) do
    cbFormaEmissao.Items.Add( GetEnumName(TypeInfo(TpcnTipoEmissao), integer(I) ) );
  cbFormaEmissao.ItemIndex := 0;

  LerConfiguracao;

  pgRespostas.ActivePageIndex := 2;
end;

procedure TfrmACBrNFSe.GravarConfiguracao;
var
  IniFile: String;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    Ini.WriteInteger('Certificado', 'SSLLib',     cbSSLLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'CryptLib',   cbCryptLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'HttpLib',    cbHttpLib.ItemIndex);
    Ini.WriteInteger('Certificado', 'XmlSignLib', cbXmlSignLib.ItemIndex);
    Ini.WriteString( 'Certificado', 'Caminho',    edtCaminho.Text);
    Ini.WriteString( 'Certificado', 'Senha',      edtSenha.Text);
    Ini.WriteString( 'Certificado', 'NumSerie',   edtNumSerie.Text);

    Ini.WriteBool(   'Geral', 'AtualizarXML',     cbxAtualizarXML.Checked);
    Ini.WriteBool(   'Geral', 'ExibirErroSchema', cbxExibirErroSchema.Checked);
    Ini.WriteString( 'Geral', 'FormatoAlerta',    edtFormatoAlerta.Text);
    Ini.WriteInteger('Geral', 'FormaEmissao',     cbFormaEmissao.ItemIndex);
    Ini.WriteBool(   'Geral', 'RetirarAcentos',   cbxRetirarAcentos.Checked);
    Ini.WriteBool(   'Geral', 'Salvar',           ckSalvar.Checked);
    Ini.WriteString( 'Geral', 'PathSalvar',       edtPathLogs.Text);
    Ini.WriteString( 'Geral', 'PathSchemas',      edtPathSchemas.Text);
    Ini.WriteString( 'Geral', 'LogoMarca',        edtLogoMarca.Text);
    Ini.WriteString( 'Geral', 'PrestLogo',        edtPrestLogo.Text);
    Ini.WriteString( 'Geral', 'Prefeitura',       edtPrefeitura.Text);

    Ini.WriteBool(   'Geral', 'ConsultaAposEnvio',    chkConsultaLoteAposEnvio.Checked);
    Ini.WriteBool(   'Geral', 'ConsultaAposCancelar', chkConsultaAposCancelar.Checked);

    Ini.WriteInteger('WebService', 'Ambiente',     rgTipoAmb.ItemIndex);
    Ini.WriteBool(   'WebService', 'Visualizar',   cbxVisualizar.Checked);
    Ini.WriteBool(   'WebService', 'SalvarSOAP',   cbxSalvarSOAP.Checked);
    Ini.WriteBool(   'WebService', 'AjustarAut',   cbxAjustarAut.Checked);
    Ini.WriteString( 'WebService', 'Aguardar',     edtAguardar.Text);
    Ini.WriteString( 'WebService', 'Tentativas',   edtTentativas.Text);
    Ini.WriteString( 'WebService', 'Intervalo',    edtIntervalo.Text);
    Ini.WriteInteger('WebService', 'TimeOut',      seTimeOut.Value);
    Ini.WriteInteger('WebService', 'SSLType',      cbSSLType.ItemIndex);
    Ini.WriteString( 'WebService', 'SenhaWeb',     edtSenhaWeb.Text);
    Ini.WriteString( 'WebService', 'UserWeb',      edtUserWeb.Text);
    Ini.WriteString( 'WebService', 'FraseSecWeb',  edtFraseSecWeb.Text);
    Ini.WriteString( 'WebService', 'ChAcessoWeb',  edtChaveAcessoWeb.Text);
    Ini.WriteString( 'WebService', 'ChAutorizWeb', edtChaveAutorizWeb.Text);

    Ini.WriteString('Proxy', 'Host',  edtProxyHost.Text);
    Ini.WriteString('Proxy', 'Porta', edtProxyPorta.Text);
    Ini.WriteString('Proxy', 'User',  edtProxyUser.Text);
    Ini.WriteString('Proxy', 'Pass',  edtProxySenha.Text);

    Ini.WriteBool(  'Arquivos', 'Salvar',          cbxSalvarArqs.Checked);
    Ini.WriteBool(  'Arquivos', 'PastaMensal',     cbxPastaMensal.Checked);
    Ini.WriteBool(  'Arquivos', 'AddLiteral',      cbxAdicionaLiteral.Checked);
    Ini.WriteBool(  'Arquivos', 'EmissaoPathNFSe', cbxEmissaoPathNFSe.Checked);
    Ini.WriteBool(  'Arquivos', 'SepararPorCNPJ',  cbxSepararPorCNPJ.Checked);
    Ini.WriteString('Arquivos', 'PathNFSe',        edtPathNFSe.Text);

    Ini.WriteString('Emitente', 'CNPJ',        edtEmitCNPJ.Text);
    Ini.WriteString('Emitente', 'IM',          edtEmitIM.Text);
    Ini.WriteString('Emitente', 'RazaoSocial', edtEmitRazao.Text);
    Ini.WriteString('Emitente', 'Fantasia',    edtEmitFantasia.Text);
    Ini.WriteString('Emitente', 'Fone',        edtEmitFone.Text);
    Ini.WriteString('Emitente', 'CEP',         edtEmitCEP.Text);
    Ini.WriteString('Emitente', 'Logradouro',  edtEmitLogradouro.Text);
    Ini.WriteString('Emitente', 'Numero',      edtEmitNumero.Text);
    Ini.WriteString('Emitente', 'Complemento', edtEmitComp.Text);
    Ini.WriteString('Emitente', 'Bairro',      edtEmitBairro.Text);
    Ini.WriteString('Emitente', 'CodCidade',   edtCodCidade.Text);
    Ini.WriteString('Emitente', 'Cidade',      edtEmitCidade.Text);
    Ini.WriteString('Emitente', 'UF',          edtEmitUF.Text);
    Ini.WriteString('Emitente', 'CNPJPref',    edtCNPJPrefeitura.Text);

    Ini.WriteString('Email', 'Host',    edtSmtpHost.Text);
    Ini.WriteString('Email', 'Port',    edtSmtpPort.Text);
    Ini.WriteString('Email', 'User',    edtSmtpUser.Text);
    Ini.WriteString('Email', 'Pass',    edtSmtpPass.Text);
    Ini.WriteString('Email', 'Assunto', edtEmailAssunto.Text);
    Ini.WriteBool(  'Email', 'SSL',     cbEmailSSL.Checked );

    StreamMemo := TMemoryStream.Create;
    mmEmailMsg.Lines.SaveToStream(StreamMemo);
    StreamMemo.Seek(0,soFromBeginning);

    Ini.WriteBinaryStream('Email', 'Mensagem', StreamMemo);

    StreamMemo.Free;

    Ini.WriteInteger('DANFSE', 'Tipo',      rgTipoDANFSE.ItemIndex);
    Ini.WriteString( 'DANFSE', 'LogoMarca', edtLogoMarca.Text);

    ConfigurarComponente;
  finally
    Ini.Free;
  end;
end;

procedure TfrmACBrNFSe.lblColaboradorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/5');
end;

procedure TfrmACBrNFSe.lblDoar1Click(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/14');
end;

procedure TfrmACBrNFSe.lblDoar2Click(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/14');
end;

procedure TfrmACBrNFSe.lblMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsBold,fsUnderline];
end;

procedure TfrmACBrNFSe.lblMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style := [fsBold];
end;

procedure TfrmACBrNFSe.lblPatrocinadorClick(Sender: TObject);
begin
  OpenURL('http://acbr.sourceforge.net/drupal/?q=node/5');
end;

procedure TfrmACBrNFSe.LerConfiguracao;
var
  IniFile: String;
  Ini: TIniFile;
  StreamMemo: TMemoryStream;
begin
  IniFile := ChangeFileExt(Application.ExeName, '.ini');

  Ini := TIniFile.Create(IniFile);
  try
    cbSSLLib.ItemIndex     := Ini.ReadInteger('Certificado', 'SSLLib',     0);
    cbCryptLib.ItemIndex   := Ini.ReadInteger('Certificado', 'CryptLib',   0);
    cbHttpLib.ItemIndex    := Ini.ReadInteger('Certificado', 'HttpLib',    0);
    cbXmlSignLib.ItemIndex := Ini.ReadInteger('Certificado', 'XmlSignLib', 0);
    edtCaminho.Text        := Ini.ReadString( 'Certificado', 'Caminho',    '');
    edtSenha.Text          := Ini.ReadString( 'Certificado', 'Senha',      '');
    edtNumSerie.Text       := Ini.ReadString( 'Certificado', 'NumSerie',   '');

    AtualizarCidades;

    cbxAtualizarXML.Checked     := Ini.ReadBool(   'Geral', 'AtualizarXML',     True);
    cbxExibirErroSchema.Checked := Ini.ReadBool(   'Geral', 'ExibirErroSchema', True);
    edtFormatoAlerta.Text       := Ini.ReadString( 'Geral', 'FormatoAlerta',    'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.');
    cbFormaEmissao.ItemIndex    := Ini.ReadInteger('Geral', 'FormaEmissao',     0);

    ckSalvar.Checked          := Ini.ReadBool(  'Geral', 'Salvar',         True);
    cbxRetirarAcentos.Checked := Ini.ReadBool(  'Geral', 'RetirarAcentos', True);
    edtPathLogs.Text          := Ini.ReadString('Geral', 'PathSalvar',     PathWithDelim(ExtractFilePath(Application.ExeName))+'Logs');
    edtPathSchemas.Text       := Ini.ReadString('Geral', 'PathSchemas',    '');
    edtLogoMarca.Text         := Ini.ReadString('Geral', 'LogoMarca',      '');
    edtPrestLogo.Text         := Ini.ReadString('Geral', 'PrestLogo',      '');
    edtPrefeitura.Text        := Ini.ReadString('Geral', 'Prefeitura',     '');

    chkConsultaLoteAposEnvio.Checked := Ini.ReadBool('Geral', 'ConsultaAposEnvio', False);
    chkConsultaAposCancelar.Checked  := Ini.ReadBool('Geral', 'ConsultaAposCancelar', False);

    rgTipoAmb.ItemIndex     := Ini.ReadInteger('WebService', 'Ambiente',    0);
    cbxVisualizar.Checked   := Ini.ReadBool(   'WebService', 'Visualizar',  False);
    cbxSalvarSOAP.Checked   := Ini.ReadBool(   'WebService', 'SalvarSOAP',  False);
    cbxAjustarAut.Checked   := Ini.ReadBool(   'WebService', 'AjustarAut',  False);
    edtAguardar.Text        := Ini.ReadString( 'WebService', 'Aguardar',    '0');
    edtTentativas.Text      := Ini.ReadString( 'WebService', 'Tentativas',  '5');
    edtIntervalo.Text       := Ini.ReadString( 'WebService', 'Intervalo',   '0');
    seTimeOut.Value         := Ini.ReadInteger('WebService', 'TimeOut',     5000);
    cbSSLType.ItemIndex     := Ini.ReadInteger('WebService', 'SSLType',     0);
    edtSenhaWeb.Text        := Ini.ReadString( 'WebService', 'SenhaWeb',    '');
    edtUserWeb.Text         := Ini.ReadString( 'WebService', 'UserWeb',     '');
    edtFraseSecWeb.Text     := Ini.ReadString( 'WebService', 'FraseSecWeb', '');
    edtChaveAcessoWeb.Text  := Ini.ReadString( 'WebService', 'ChAcessoWeb', '');
    edtChaveAutorizWeb.Text := Ini.ReadString( 'WebService', 'ChAutorizWeb', '');

    edtProxyHost.Text  := Ini.ReadString('Proxy', 'Host',  '');
    edtProxyPorta.Text := Ini.ReadString('Proxy', 'Porta', '');
    edtProxyUser.Text  := Ini.ReadString('Proxy', 'User',  '');
    edtProxySenha.Text := Ini.ReadString('Proxy', 'Pass',  '');

    cbxSalvarArqs.Checked       := Ini.ReadBool(  'Arquivos', 'Salvar',           false);
    cbxPastaMensal.Checked      := Ini.ReadBool(  'Arquivos', 'PastaMensal',      false);
    cbxAdicionaLiteral.Checked  := Ini.ReadBool(  'Arquivos', 'AddLiteral',       false);
    cbxEmissaoPathNFSe.Checked  := Ini.ReadBool(  'Arquivos', 'EmissaoPathNFSe',   false);
    cbxSepararPorCNPJ.Checked   := Ini.ReadBool(  'Arquivos', 'SepararPorCNPJ',   false);
    edtPathNFSe.Text            := Ini.ReadString('Arquivos', 'PathNFSe',          '');

    edtEmitCNPJ.Text       := Ini.ReadString('Emitente', 'CNPJ',        '');
    edtEmitIM.Text         := Ini.ReadString('Emitente', 'IM',          '');
    edtEmitRazao.Text      := Ini.ReadString('Emitente', 'RazaoSocial', '');
    edtEmitFantasia.Text   := Ini.ReadString('Emitente', 'Fantasia',    '');
    edtEmitFone.Text       := Ini.ReadString('Emitente', 'Fone',        '');
    edtEmitCEP.Text        := Ini.ReadString('Emitente', 'CEP',         '');
    edtEmitLogradouro.Text := Ini.ReadString('Emitente', 'Logradouro',  '');
    edtEmitNumero.Text     := Ini.ReadString('Emitente', 'Numero',      '');
    edtEmitComp.Text       := Ini.ReadString('Emitente', 'Complemento', '');
    edtEmitBairro.Text     := Ini.ReadString('Emitente', 'Bairro',      '');
    edtCodCidade.Text      := Ini.ReadString('Emitente', 'CodCidade',   '');
    edtEmitCidade.Text     := Ini.ReadString('Emitente', 'Cidade',      '');
    edtEmitUF.Text         := Ini.ReadString('Emitente', 'UF',          '');
    cbCidades.ItemIndex    := cbCidades.Items.IndexOf(edtEmitCidade.Text + '/' +
      edtCodCidade.Text + '/' + edtEmitUF.Text);
    edtCNPJPrefeitura.Text := Ini.ReadString('Emitente', 'CNPJPref',    '');

    edtSmtpHost.Text     := Ini.ReadString('Email', 'Host',    '');
    edtSmtpPort.Text     := Ini.ReadString('Email', 'Port',    '');
    edtSmtpUser.Text     := Ini.ReadString('Email', 'User',    '');
    edtSmtpPass.Text     := Ini.ReadString('Email', 'Pass',    '');
    edtEmailAssunto.Text := Ini.ReadString('Email', 'Assunto', '');
    cbEmailSSL.Checked   := Ini.ReadBool(  'Email', 'SSL',     False);

    StreamMemo := TMemoryStream.Create;
    Ini.ReadBinaryStream('Email', 'Mensagem', StreamMemo);
    mmEmailMsg.Lines.LoadFromStream(StreamMemo);
    StreamMemo.Free;

    rgTipoDANFSe.ItemIndex := Ini.ReadInteger('DANFSE', 'Tipo',       0);
    edtLogoMarca.Text      := Ini.ReadString( 'DANFSE', 'LogoMarca',  '');

    ConfigurarComponente;
  finally
    Ini.Free;
  end;
end;

procedure TfrmACBrNFSe.ChecarResposta(const Response: TNFSeWebserviceResponse);
var
  i: Integer;
begin
  memoLog.Clear;

  if Response is TNFSeEmiteResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + ModoEnvioToStr(TNFSeEmiteResponse(Response).ModoEnvio));
    memoLog.Lines.Add('Numero do Lote: ' + TNFSeEmiteResponse(Response).Lote);
    memoLog.Lines.Add('Data de Envio : ' + DateToStr(TNFSeEmiteResponse(Response).Data));
    memoLog.Lines.Add('Numero do Prot: ' + TNFSeEmiteResponse(Response).Protocolo);
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeSubstituiNFSeResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(tmSubstituirNFSe));
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeConsultaSituacaoResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(tmConsultarSituacao));
    memoLog.Lines.Add('Numero do Lote: ' + TNFSeConsultaSituacaoResponse(Response).Lote);
    memoLog.Lines.Add('Numero do Prot: ' + TNFSeConsultaSituacaoResponse(Response).Protocolo);
    memoLog.Lines.Add('Situa��o Lote : ' + TNFSeConsultaSituacaoResponse(Response).Situacao);
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeConsultaLoteRpsResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(tmConsultarLote));
    memoLog.Lines.Add('Numero do Lote: ' + TNFSeConsultaLoteRpsResponse(Response).Lote);
    memoLog.Lines.Add('Numero do Prot: ' + TNFSeConsultaLoteRpsResponse(Response).Protocolo);
    memoLog.Lines.Add('Situa��o Lote : ' + TNFSeConsultaLoteRpsResponse(Response).Situacao);
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeConsultaNFSeporRpsResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(tmConsultarNFSePorRps));
    memoLog.Lines.Add('Numero do Rps : ' + TNFSeConsultaNFSeporRpsResponse(Response).NumRPS);
    memoLog.Lines.Add('S�rie do Rps  : ' + TNFSeConsultaNFSeporRpsResponse(Response).Serie);
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeConsultaNFSeResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(TNFSeConsultaNFSeResponse(Response).Metodo));
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
  end;

  if Response is TNFSeCancelaNFSeResponse then
  begin
    memoLog.Lines.Add('Modo de Envio : ' + MetodoToStr(tmCancelarNFSe));
    memoLog.Lines.Add('Numero da NFSe: ' + TNFSeCancelaNFSeResponse(Response).InfCancelamento.NumeroNFSe);
    memoLog.Lines.Add('S�rie da NFSe : ' + TNFSeCancelaNFSeResponse(Response).InfCancelamento.SerieNFSe);
    memoLog.Lines.Add('Sucesso       : ' + BoolToStr(Response.Sucesso, True));
    memoLog.Lines.Add(' ');
    memoLog.Lines.Add('Retorno do Pedido de Cancelamento:');
    memoLog.Lines.Add('Situa��o : ' + TNFSeCancelaNFSeResponse(Response).RetCancelamento.Situacao);
  end;

  if Response.Erros.Count > 0 then
  begin
    memoLog.Lines.Add(' ');
    memoLog.Lines.Add('Erro(s):');
    for i := 0 to Response.Erros.Count -1 do
    begin
      memoLog.Lines.Add('C�digo  : ' + Response.Erros[i].Codigo);
      memoLog.Lines.Add('Mensagem: ' + Response.Erros[i].Descricao);
      memoLog.Lines.Add('Corre��o: ' + Response.Erros[i].Correcao);
      memoLog.Lines.Add('---------');
    end;
  end;

  if Response.Alertas.Count > 0 then
  begin
    memoLog.Lines.Add(' ');
    memoLog.Lines.Add('Alerta(s):');
    for i := 0 to Response.Alertas.Count -1 do
    begin
      memoLog.Lines.Add('C�digo  : ' + Response.Alertas[i].Codigo);
      memoLog.Lines.Add('Mensagem: ' + Response.Alertas[i].Descricao);
      memoLog.Lines.Add('Corre��o: ' + Response.Alertas[i].Correcao);
      memoLog.Lines.Add('---------');
    end;
  end;

  MemoResp.Lines.Text := Response.XmlEnvio;
  memoRespWS.Lines.Text := Response.XmlRetorno;
  LoadXML(Response.XmlEnvio, WBResposta);

  pgRespostas.ActivePageIndex := 2;
end;

procedure TfrmACBrNFSe.ConfigurarComponente;
var
  Ok: Boolean;
  PathMensal: String;
begin
  ACBrNFSeX1.Configuracoes.Certificados.ArquivoPFX  := edtCaminho.Text;
  ACBrNFSeX1.Configuracoes.Certificados.Senha       := AnsiString(edtSenha.Text);
  ACBrNFSeX1.Configuracoes.Certificados.NumeroSerie := edtNumSerie.Text;

  ACBrNFSeX1.SSL.DescarregarCertificado;

  with ACBrNFSeX1.Configuracoes.Geral do
  begin
    SSLLib        := TSSLLib(cbSSLLib.ItemIndex);
    SSLCryptLib   := TSSLCryptLib(cbCryptLib.ItemIndex);
    SSLHttpLib    := TSSLHttpLib(cbHttpLib.ItemIndex);
    SSLXmlSignLib := TSSLXmlSignLib(cbXmlSignLib.ItemIndex);

    AtualizarSSLLibsCombo;

    Salvar           := ckSalvar.Checked;
    ExibirErroSchema := cbxExibirErroSchema.Checked;
    RetirarAcentos   := cbxRetirarAcentos.Checked;
    FormatoAlerta    := edtFormatoAlerta.Text;
    FormaEmissao     := TpcnTipoEmissao(cbFormaEmissao.ItemIndex);

    ConsultaLoteAposEnvio := chkConsultaLoteAposEnvio.Checked;
    ConsultaAposCancelar  := chkConsultaAposCancelar.Checked;

    CNPJPrefeitura := edtCNPJPrefeitura.Text;

    Emitente.CNPJ           := edtEmitCNPJ.Text;
    Emitente.InscMun        := edtEmitIM.Text;
    Emitente.RazSocial      := edtEmitRazao.Text;
    Emitente.WSUser         := edtUserWeb.Text;
    Emitente.WSSenha        := edtSenhaWeb.Text;
    Emitente.WSFraseSecr    := edtFraseSecWeb.Text;
    Emitente.WSChaveAcesso  := edtChaveAcessoWeb.Text;

    // Para o provedor Giap a Chave de Autoriza��o deve ser composta:
    // Inscri��o Municipal - Chave
    Emitente.WSChaveAutoriz := edtChaveAutorizWeb.Text;

    {
      Para o provedor ADM, utilizar as seguintes propriedades de configura��es:
      WSChaveAcesso  para o Key
      WSChaveAutoriz para o Auth
      WSUser         para o RequestId

      Essas 3 propriedades s�o geradas pelo provedor quando o emitente se cadastra
    }
  end;

  with ACBrNFSeX1.Configuracoes.WebServices do
  begin
    Ambiente   := StrToTpAmb(Ok,IntToStr(rgTipoAmb.ItemIndex+1));
    Visualizar := cbxVisualizar.Checked;
    Salvar     := cbxSalvarSOAP.Checked;
    UF         := edtEmitUF.Text;

    AjustaAguardaConsultaRet := cbxAjustarAut.Checked;

    if NaoEstaVazio(edtAguardar.Text)then
      AguardarConsultaRet := ifThen(StrToInt(edtAguardar.Text) < 1000, StrToInt(edtAguardar.Text) * 1000, StrToInt(edtAguardar.Text))
    else
      edtAguardar.Text := IntToStr(AguardarConsultaRet);

    if NaoEstaVazio(edtTentativas.Text) then
      Tentativas := StrToInt(edtTentativas.Text)
    else
      edtTentativas.Text := IntToStr(Tentativas);

    if NaoEstaVazio(edtIntervalo.Text) then
      IntervaloTentativas := ifThen(StrToInt(edtIntervalo.Text) < 1000, StrToInt(edtIntervalo.Text) * 1000, StrToInt(edtIntervalo.Text))
    else
      edtIntervalo.Text := IntToStr(ACBrNFSeX1.Configuracoes.WebServices.IntervaloTentativas);

    TimeOut   := seTimeOut.Value;
    ProxyHost := edtProxyHost.Text;
    ProxyPort := edtProxyPorta.Text;
    ProxyUser := edtProxyUser.Text;
    ProxyPass := edtProxySenha.Text;
  end;

  ACBrNFSeX1.SSL.SSLType := TSSLType(cbSSLType.ItemIndex);

  with ACBrNFSeX1.Configuracoes.Arquivos do
  begin
    NomeLongoNFSe    := True;
    Salvar           := cbxSalvarArqs.Checked;
    SepararPorMes    := cbxPastaMensal.Checked;
    AdicionarLiteral := cbxAdicionaLiteral.Checked;
    EmissaoPathNFSe  := cbxEmissaoPathNFSe.Checked;
    SepararPorCNPJ   := cbxSepararPorCNPJ.Checked;
//    PathSalvar       := edtPathLogs.Text;
    PathSchemas      := edtPathSchemas.Text;
    PathGer          := edtPathLogs.Text;
    PathMensal       := GetPathGer(0);
    PathSalvar       := PathMensal;
    PathCan          := PathMensal;
//    PathNFSe         := PathMensal;
  end;

  if ACBrNFSeX1.DANFSe <> nil then
  begin
    // TTipoDANFSE = ( tpPadrao, tpIssDSF, tpFiorilli );
    ACBrNFSeX1.DANFSe.TipoDANFSE := tpPadrao;
    ACBrNFSeX1.DANFSe.Logo       := edtLogoMarca.Text;
    ACBrNFSeX1.DANFSe.PrestLogo  := edtPrestLogo.Text;
    ACBrNFSeX1.DANFSe.Prefeitura := edtPrefeitura.Text;
    ACBrNFSeX1.DANFSe.PathPDF    := PathMensal;

    ACBrNFSeX1.DANFSe.MargemDireita  := 5;
    ACBrNFSeX1.DANFSe.MargemEsquerda := 5;
    ACBrNFSeX1.DANFSe.MargemSuperior := 5;
    ACBrNFSeX1.DANFSe.MargemInferior := 5;
  end;

  with ACBrNFSeX1.MAIL do
  begin
    Host      := edtSmtpHost.Text;
    Port      := edtSmtpPort.Text;
    Username  := edtSmtpUser.Text;
    Password  := edtSmtpPass.Text;
    From      := edtEmailRemetente.Text;
    FromName  := edtEmitRazao.Text;
    SetTLS    := cbEmailTLS.Checked;
    SetSSL    := cbEmailSSL.Checked;
    UseThread := False;

    ReadingConfirmation := False;
  end;

  // A propriedade CodigoMunicipio tem que ser a ultima a receber o seu valor
  // Pois ela se utiliza das demais configura��es
  with ACBrNFSeX1.Configuracoes.Geral do
  begin
    CodigoMunicipio := StrToIntDef(edtCodCidade.Text, 0);

    // Exemplos de valores para WSChaveAcesso para alguns provedores.

    if Provedor in [proAgili, proAgiliv2, proElotech] then
      Emitente.WSChaveAcesso := '0aA1bB2cC3dD4eE5fF6aA7bB8cC9dDEF';

    if Provedor = proISSNet then
      Emitente.WSChaveAcesso := 'A001.B0001.C0001-1';

    if Provedor = proSigep then
      Emitente.WSChaveAcesso := 'A001.B0001.C0001';

    if Provedor = proiiBrasilv2 then
      Emitente.WSChaveAcesso := 'TLXX4JN38KXTRNSEAJYYEA==';
  end;

  lblSchemas.Caption := ACBrNFSeX1.Configuracoes.Geral.xProvedor;
end;

procedure TfrmACBrNFSe.LoadXML(RetWS: String; MyWebBrowser: TWebBrowser);
begin
  ACBrUtil.WriteToTXT(PathWithDelim(ExtractFileDir(application.ExeName)) + 'temp.xml',
                      AnsiString(ACBrUtil.ConverteXMLtoUTF8(RetWS)), False, False);

  MyWebBrowser.Navigate(PathWithDelim(ExtractFileDir(application.ExeName)) + 'temp.xml');

  if ACBrNFSeX1.NotasFiscais.Count > 0then
    MemoResp.Lines.Add('Empresa: ' + ACBrNFSeX1.NotasFiscais.Items[0].NFSe.Prestador.RazaoSocial);
end;

procedure TfrmACBrNFSe.PathClick(Sender: TObject);
var
  Dir: string;
begin
  if Length(TEdit(Sender).Text) <= 0 then
    Dir := ExtractFileDir(application.ExeName)
  else
    Dir := TEdit(Sender).Text;

  if SelectDirectory(Dir, [sdAllowCreate, sdPerformCreate, sdPrompt],SELDIRHELP) then
    TEdit(Sender).Text := Dir;
end;

function TfrmACBrNFSe.RoundTo5(Valor: Double; Casas: Integer): Double;
var
  xValor, xDecimais: String;
  p, nCasas: Integer;
  nValor: Double;
begin
  nValor := Valor;
  xValor := Trim(FloatToStr(Valor));
  p := pos(',', xValor);

  if Casas < 0 then
    nCasas := -Casas
  else
    nCasas := Casas;

  if p > 0 then
  begin
    xDecimais := Copy(xValor, p + 1, Length(xValor));

    if Length(xDecimais) > nCasas then
    begin
      if xDecimais[nCasas + 1] >= '5' then
        SetRoundMode(rmUP)
      else
        SetRoundMode(rmNearest);
    end;

    nValor := RoundTo(Valor, Casas);
  end;

  Result := nValor;
end;

procedure TfrmACBrNFSe.sbPathNFSeClick(Sender: TObject);
begin
  PathClick(edtPathNFSe);
end;

procedure TfrmACBrNFSe.sbtnCaminhoCertClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Certificado';
  OpenDialog1.DefaultExt := '*.pfx';
  OpenDialog1.Filter := 'Arquivos PFX (*.pfx)|*.pfx|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);

  if OpenDialog1.Execute then
    edtCaminho.Text := OpenDialog1.FileName;
end;

procedure TfrmACBrNFSe.sbtnGetCertClick(Sender: TObject);
begin
  edtNumSerie.Text := ACBrNFSeX1.SSL.SelecionarCertificado;
end;

procedure TfrmACBrNFSe.sbtnLogoMarcaClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Logo';
  OpenDialog1.DefaultExt := '*.bmp';
  OpenDialog1.Filter := 'Arquivos BMP (*.bmp)|*.bmp|Todos os Arquivos (*.*)|*.*';

  OpenDialog1.InitialDir := ExtractFileDir(application.ExeName);

  if OpenDialog1.Execute then
    edtLogoMarca.Text := OpenDialog1.FileName;
end;

procedure TfrmACBrNFSe.sbtnNumSerieClick(Sender: TObject);
var
  I: Integer;
  ASerie: String;
  AddRow: Boolean;
begin
  ACBrNFSeX1.SSL.LerCertificadosStore;
  AddRow := False;

  with frmSelecionarCertificado.StringGrid1 do
  begin
    ColWidths[0] := 220;
    ColWidths[1] := 250;
    ColWidths[2] := 120;
    ColWidths[3] := 80;
    ColWidths[4] := 150;

    Cells[0, 0] := 'Num.S�rie';
    Cells[1, 0] := 'Raz�o Social';
    Cells[2, 0] := 'CNPJ';
    Cells[3, 0] := 'Validade';
    Cells[4, 0] := 'Certificadora';
  end;

  for I := 0 to ACBrNFSeX1.SSL.ListaCertificados.Count-1 do
  begin
    with ACBrNFSeX1.SSL.ListaCertificados[I] do
    begin
      ASerie := NumeroSerie;

      if (CNPJ <> '') then
      begin
        with frmSelecionarCertificado.StringGrid1 do
        begin
          if Addrow then
            RowCount := RowCount + 1;

          Cells[0, RowCount-1] := NumeroSerie;
          Cells[1, RowCount-1] := RazaoSocial;
          Cells[2, RowCount-1] := CNPJ;
          Cells[3, RowCount-1] := FormatDateBr(DataVenc);
          Cells[4, RowCount-1] := Certificadora;

          AddRow := True;
        end;
      end;
    end;
  end;

  frmSelecionarCertificado.ShowModal;

  if frmSelecionarCertificado.ModalResult = mrOK then
    edtNumSerie.Text := frmSelecionarCertificado.StringGrid1.Cells[0, frmSelecionarCertificado.StringGrid1.Row];
end;

procedure TfrmACBrNFSe.sbtnPathSalvarClick(Sender: TObject);
begin
  PathClick(edtPathLogs);
end;

procedure TfrmACBrNFSe.sbtnPrestLogoClick(Sender: TObject);
begin
  OpenDialog1.Title := 'Selecione o Logo';
  OpenDialog1.DefaultExt := '*.bmp';
  OpenDialog1.Filter :=
    'Arquivos BMP (*.bmp)|*.bmp|Todos os Arquivos (*.*)|*.*';
  OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName);

  if OpenDialog1.Execute then
  begin
    edtLogoMarca.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmACBrNFSe.spPathSchemasClick(Sender: TObject);
begin
  PathClick(edtPathSchemas);
end;

procedure TfrmACBrNFSe.cbCidadesChange(Sender: TObject);
var
  Tamanho: Integer;
begin
  Tamanho := Length(Trim(cbCidades.Text));

  edtEmitCidade.Text := Copy(cbCidades.Text, 1, Tamanho - 11);
  edtEmitUF.Text := Copy(cbCidades.Text, Tamanho - 1, 2);
  edtCodCidade.Text := Copy(cbCidades.Text, Tamanho - 9, 7);
end;

end.
