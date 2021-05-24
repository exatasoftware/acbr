{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrNFSeXGravarXml_ABRASFv2;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml, ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_ABRASFv2 }

  TNFSeW_ABRASFv2 = class(TNFSeWClass)
  private
    FNrOcorrComplTomador: Integer;
    FNrOcorrFoneTomador: Integer;
    FNrOcorrEmailTomador: Integer;
    FNrOcorrRazaoSocialPrest: Integer;
    FNrOcorrRazaoSocialInterm: Integer;
    FNrOcorrOutrasRet: Integer;
    FNrOcorrAliquota: Integer;
    FNrOcorrDescIncond: Integer;
    FNrOcorrDescCond: Integer;
    FNrOcorrValorDeducoes: Integer;
    FNrOcorrValorTotalRecebido: Integer;
    FNrOcorrInscEstTomador: Integer;
    FNrOcorrOutrasInformacoes: Integer;
    FNrOcorrNaturezaOperacao: Integer;
    FNrOcorrIdCidade: Integer;
    FNrOcorrRespRetencao: Integer;
    FNrOcorrPercCargaTrib: Integer;
    FNrOcorrValorCargaTrib: Integer;
    FNrOcorrPercCargaTribMun: Integer;
    FNrOcorrValorCargaTribMun: Integer;
    FNrOcorrValorCargaTribEst: Integer;
    FNrOcorrPercCargaTribEst: Integer;
    FNrOcorrTipoNota: Integer;
    FNrOcorrSiglaUF: Integer;
    FNrOcorrEspDoc: Integer;
    FNrOcorrSerieTal: Integer;
    FNrOcorrFormaPag: Integer;
    FNrOcorrNumParcelas: Integer;
    FNrOcorrIrrfInd: Integer;
    FNrOcorrBaseCalcCRS: Integer;
    FNrOcorrInformacoesComplemetares: Integer;
    FNrOcorrRegimeEspecialTributacao: Integer;
    FNrOcorrMunIncid: Integer;
    FGerarTagServicos: Boolean;
    FNrOcorrValTotTrib: Integer;
    FNrOcorrCodTribMun_1: Integer;
    FNrOcorrCodTribMun_2: Integer;
    FNrOcorrValorIss: Integer;
    FNrOcorrIssRetido: Integer;
    FNrOcorrOptanteSimplesNacional: Integer;
    FNrOcorrIncentCultural: Integer;
    FGerarIDDeclaracao: Boolean;
    FTagTomador: String;
    FNrOcorrInscEstInter: Integer;
    FNrOcorrCompetencia: Integer;
    FNrOcorrEndereco: Integer;
    FNrOcorrTipoLogradouro: Integer;
    FNrOcorrLogradouro: Integer;
    FNrOcorrSerieRPS: Integer;
    FNrOcorrDDD: Integer;
    FNrOcorrTipoTelefone: Integer;
    FNrOcorrTipoRPS: Integer;
    FNrOcorrUFTomador: Integer;
    FNrOcorrCepTomador: Integer;
    FNrOcorrCodigoCNAE: Integer;
    FNrOcorrDiscriminacao_1: Integer;
    FNrOcorrDiscriminacao_2: Integer;
    FNrOcorrExigibilidadeISS: Integer;
    FNrOcorrNumProcesso: Integer;
    FGerarTagSenhaFraseSecreta: Boolean;
    FNrOcorrProducao: Integer;
    FNrOcorrAtualizaTomador: Integer;
    FNrOcorrTomadorExterior: Integer;
    FNrOcorrCodigoMunic_1: Integer;
    FNrOcorrCodigoMunic_2: Integer;
    FNrOcorrNIFTomador: Integer;
    FGerarEnderecoExterior: Boolean;
    FNrOcorrID: Integer;
    FNrOcorrValorCsll: Integer;
    FNrOcorrValorPis: Integer;
    FNrOcorrValorCofins: Integer;
    FNrOcorrValorInss: Integer;
    FNrOcorrValorIr: Integer;

    FNrOcorrCodigoPaisServico: Integer;
    FNrOcorrCodigoPaisTomador: Integer;
    FNrOcorrInscMunTomador: Integer;

  protected
    procedure Configuracao; override;

    procedure DefinirIDRps; override;
    function DefinirNameSpaceDeclaracao: string; virtual;

    function GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode; virtual;
    function GerarRps: TACBrXmlNode; virtual;
    function GerarIdentificacaoRPS: TACBrXmlNode; virtual;
    function GerarRPSSubstituido: TACBrXmlNode; virtual;
    function GerarServico: TACBrXmlNode; virtual;
    function GerarValores: TACBrXmlNode; virtual;
    function GerarPrestador: TACBrXmlNode; virtual;
    function GerarTomador: TACBrXmlNode; virtual;
    function GerarIdentificacaoTomador: TACBrXmlNode; virtual;
    function GerarEnderecoTomador: TACBrXmlNode; virtual;
    function GerarContatoTomador: TACBrXmlNode; virtual;
    function GerarIntermediarioServico: TACBrXmlNode; virtual;
    function GerarIdentificacaoIntermediarioServico: TACBrXmlNode; virtual;
    function GerarConstrucaoCivil: TACBrXmlNode; virtual;
    function GerarStatus: TACBrXmlNode; virtual;
    function GerarTipoRPS: TACBrXmlNode; virtual;
    function GerarListaServicos: TACBrXmlNode; virtual;
    function GerarServicos: TACBrXmlNodeArray; virtual;
    function GerarItemValores(i: Integer): TACBrXmlNodeArray; virtual;
    function GerarValoresServico: TACBrXmlNode; virtual;
    function GerarListaItensServico: TACBrXmlNode; virtual;
    function GerarItemServico: TACBrXmlNodeArray; virtual;
    function GerarEnderecoExteriorTomador: TACBrXmlNode; virtual;
    function GerarQuartos: TACBrXmlNode; virtual;
    function GerarQuarto: TACBrXmlNodeArray; virtual;

  public
    function GerarXml: Boolean; override;

    property NrOcorrComplTomador: Integer read FNrOcorrComplTomador write FNrOcorrComplTomador;
    property NrOcorrFoneTomador: Integer  read FNrOcorrFoneTomador  write FNrOcorrFoneTomador;
    property NrOcorrEmailTomador: Integer read FNrOcorrEmailTomador write FNrOcorrEmailTomador;
    property NrOcorrValorPis: Integer     read FNrOcorrValorPis     write FNrOcorrValorPis;
    property NrOcorrValorCofins: Integer  read FNrOcorrValorCofins  write FNrOcorrValorCofins;
    property NrOcorrValorInss: Integer    read FNrOcorrValorInss    write FNrOcorrValorInss;
    property NrOcorrValorIr: Integer      read FNrOcorrValorIr      write FNrOcorrValorIr;
    property NrOcorrValorCsll: Integer    read FNrOcorrValorCsll    write FNrOcorrValorCsll;
    property NrOcorrValorIss: Integer     read FNrOcorrValorIss     write FNrOcorrValorIss;
    property NrOcorrOutrasRet: Integer    read FNrOcorrOutrasRet    write FNrOcorrOutrasRet;
    property NrOcorrAliquota: Integer     read FNrOcorrAliquota     write FNrOcorrAliquota;
    property NrOcorrDescIncond: Integer   read FNrOcorrDescIncond   write FNrOcorrDescIncond;
    property NrOcorrDescCond: Integer     read FNrOcorrDescCond     write FNrOcorrDescCond;
    property NrOcorrSerieRPS: Integer     read FNrOcorrSerieRPS     write FNrOcorrSerieRPS;
    property NrOcorrTipoRPS: Integer      read FNrOcorrTipoRPS      write FNrOcorrTipoRPS;
    property NrOcorrDDD: Integer          read FNrOcorrDDD          write FNrOcorrDDD;
    property NrOcorrTipoTelefone: Integer read FNrOcorrTipoTelefone write FNrOcorrTipoTelefone;
    property NrOcorrCodigoCNAE: Integer   read FNrOcorrCodigoCNAE   write FNrOcorrCodigoCNAE;
    property NrOcorrNumProcesso: Integer  read FNrOcorrNumProcesso  write FNrOcorrNumProcesso;

    property NrOcorrRazaoSocialPrest: Integer   read FNrOcorrRazaoSocialPrest   write FNrOcorrRazaoSocialPrest;
    property NrOcorrRazaoSocialInterm: Integer  read FNrOcorrRazaoSocialInterm  write FNrOcorrRazaoSocialInterm;
    property NrOcorrValorDeducoes: Integer      read FNrOcorrValorDeducoes      write FNrOcorrValorDeducoes;
    property NrOcorrValorTotalRecebido: Integer read FNrOcorrValorTotalRecebido write FNrOcorrValorTotalRecebido;
    property NrOcorrInscEstTomador: Integer     read FNrOcorrInscEstTomador     write FNrOcorrInscEstTomador;
    property NrOcorrOutrasInformacoes: Integer  read FNrOcorrOutrasInformacoes  write FNrOcorrOutrasInformacoes;
    property NrOcorrNaturezaOperacao: Integer   read FNrOcorrNaturezaOperacao   write FNrOcorrNaturezaOperacao;
    property NrOcorrPercCargaTrib: Integer      read FNrOcorrPercCargaTrib      write FNrOcorrPercCargaTrib;
    property NrOcorrValorCargaTrib: Integer     read FNrOcorrValorCargaTrib     write FNrOcorrValorCargaTrib;
    property NrOcorrPercCargaTribMun: Integer   read FNrOcorrPercCargaTribMun   write FNrOcorrPercCargaTribMun;
    property NrOcorrValorCargaTribMun: Integer  read FNrOcorrValorCargaTribMun  write FNrOcorrValorCargaTribMun;
    property NrOcorrPercCargaTribEst: Integer   read FNrOcorrPercCargaTribEst   write FNrOcorrPercCargaTribEst;
    property NrOcorrValorCargaTribEst: Integer  read FNrOcorrValorCargaTribEst  write FNrOcorrValorCargaTribEst;
    property NrOcorrTipoNota: Integer           read FNrOcorrTipoNota           write FNrOcorrTipoNota;
    property NrOcorrSiglaUF: Integer            read FNrOcorrSiglaUF            write FNrOcorrSiglaUF;
    property NrOcorrEspDoc: Integer             read FNrOcorrEspDoc             write FNrOcorrEspDoc;
    property NrOcorrSerieTal: Integer           read FNrOcorrSerieTal           write FNrOcorrSerieTal;
    property NrOcorrFormaPag: Integer           read FNrOcorrFormaPag           write FNrOcorrFormaPag;
    property NrOcorrNumParcelas: Integer        read FNrOcorrNumParcelas        write FNrOcorrNumParcelas;
    property NrOcorrBaseCalcCRS: Integer        read FNrOcorrBaseCalcCRS        write FNrOcorrBaseCalcCRS;
    property NrOcorrIrrfInd: Integer            read FNrOcorrIrrfInd            write FNrOcorrIrrfInd;
    property NrOcorrInscEstInter: Integer       read FNrOcorrInscEstInter       write FNrOcorrInscEstInter;
    property NrOcorrCompetencia: Integer        read FNrOcorrCompetencia        write FNrOcorrCompetencia;
    property NrOcorrEndereco: Integer           read FNrOcorrEndereco           write FNrOcorrEndereco;
    property NrOcorrTipoLogradouro: Integer     read FNrOcorrTipoLogradouro     write FNrOcorrTipoLogradouro;
    property NrOcorrLogradouro: Integer         read FNrOcorrLogradouro         write FNrOcorrLogradouro;
    property NrOcorrUFTomador: Integer          read FNrOcorrUFTomador          write FNrOcorrUFTomador;
    property NrOcorrCepTomador: Integer         read FNrOcorrCepTomador         write FNrOcorrCepTomador;
    property NrOcorrIncentCultural: Integer     read FNrOcorrIncentCultural     write FNrOcorrIncentCultural;
    property NrOcorrDiscriminacao_1: Integer    read FNrOcorrDiscriminacao_1    write FNrOcorrDiscriminacao_1;
    property NrOcorrDiscriminacao_2: Integer    read FNrOcorrDiscriminacao_2    write FNrOcorrDiscriminacao_2;
    property NrOcorrExigibilidadeISS: Integer   read FNrOcorrExigibilidadeISS   write FNrOcorrExigibilidadeISS;
    property NrOcorrAtualizaTomador: Integer    read FNrOcorrAtualizaTomador    write FNrOcorrAtualizaTomador;
    property NrOcorrTomadorExterior: Integer    read FNrOcorrTomadorExterior    write FNrOcorrTomadorExterior;
    property NrOcorrCodigoMunic_1: Integer      read FNrOcorrCodigoMunic_1      write FNrOcorrCodigoMunic_1;
    property NrOcorrCodigoMunic_2: Integer      read FNrOcorrCodigoMunic_2      write FNrOcorrCodigoMunic_2;
    property NrOcorrInscMunTomador: Integer     read FNrOcorrInscMunTomador      write FNrOcorrInscMunTomador;

    property NrOcorrInformacoesComplemetares: Integer read FNrOcorrInformacoesComplemetares write FNrOcorrInformacoesComplemetares;
    property NrOcorrRegimeEspecialTributacao: Integer read FNrOcorrRegimeEspecialTributacao write FNrOcorrRegimeEspecialTributacao;
    property NrOcorrOptanteSimplesNacional: Integer   read FNrOcorrOptanteSimplesNacional   write FNrOcorrOptanteSimplesNacional;

    property NrOcorrIdCidade: Integer     read FNrOcorrIdCidade     write FNrOcorrIdCidade;
    property NrOcorrRespRetencao: Integer read FNrOcorrRespRetencao write FNrOcorrRespRetencao;
    property NrOcorrMunIncid: Integer     read FNrOcorrMunIncid     write FNrOcorrMunIncid;
    property NrOcorrValTotTrib: Integer   read FNrOcorrValTotTrib   write FNrOcorrValTotTrib;
    property NrOcorrCodTribMun_1: Integer read FNrOcorrCodTribMun_1 write FNrOcorrCodTribMun_1;
    property NrOcorrCodTribMun_2: Integer read FNrOcorrCodTribMun_2 write FNrOcorrCodTribMun_2;
    property NrOcorrIssRetido: Integer    read FNrOcorrIssRetido    write FNrOcorrIssRetido;
    property NrOcorrProducao: Integer     read FNrOcorrProducao     write FNrOcorrProducao;
    property NrOcorrNIFTomador: Integer   read FNrOcorrNIFTomador   write FNrOcorrNIFTomador;
    property NrOcorrID: Integer           read FNrOcorrID           write FNrOcorrID;

    property NrOcorrCodigoPaisServico: Integer read FNrOcorrCodigoPaisServico write FNrOcorrCodigoPaisServico;
    property NrOcorrCodigoPaisTomador: Integer read FNrOcorrCodigoPaisTomador write FNrOcorrCodigoPaisTomador;

    property GerarTagServicos: Boolean  read FGerarTagServicos  write FGerarTagServicos;
    property GerarIDDeclaracao: Boolean read FGerarIDDeclaracao write FGerarIDDeclaracao;

    property GerarTagSenhaFraseSecreta: Boolean read FGerarTagSenhaFraseSecreta write FGerarTagSenhaFraseSecreta;
    property GerarEnderecoExterior: Boolean     read FGerarEnderecoExterior     write FGerarEnderecoExterior;

    property TagTomador: String read FTagTomador write FTagTomador;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS dos provedores
// que seguem a vers�o 2.xx do layout da ABRASF
//==============================================================================

{ TNFSeW_ABRASFv2 }

procedure TNFSeW_ABRASFv2.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  {italo
  // Os provedores que seguem a vers�o 1 do layout da ABRASF s� tem 3 m�todos de
  // envio: EnviarLoteRpsEnvio, EnviarLoteRpsSincronoEnvio e GerarNfseEnvio.
  // O m�todo escolhido como padr�o � o que funciona no modo S�ncrono.
  // Pode variar dependendo do provedor.
  with ConfigGeral do
  begin
    VersaoProv := ve200;

    QtdReqConsultar := 2;
    ConsultarRequisitos[1] := rcoNumeroInicial;
    ConsultarRequisitos[2] := rcoPagina;

    QtdReqConsultarNFSeRps := 3;
    ConsultarNFSeRpsRequisitos[1] := rconNumero;
    ConsultarNFSeRpsRequisitos[2] := rconSerie;
    ConsultarNFSeRpsRequisitos[3] := rconTipo;

    QtdReqCancelar := 2;
    CancelarRequisitos[1] := rcaNumeroNFSe;
    CancelarRequisitos[2] := rcaCodCancelamento;
  end;

  with ConfigMsgDados do
  begin
    VersaoRps       := '2.00';

    with LoteRps do
    begin
      GerarID           := True;
      GerarGrupoCPFCNPJ := True;
      GerarNSEnvioLote  := True;
    end;

    with ConsLote do
    begin
      GerarGrupoCPFCNPJ   := True;
      GerarGrupoPrestador := True;
    end;

    with ConsNFSeRps do
    begin
      GerarGrupoCPFCNPJ   := True;
      GerarGrupoPrestador := True;
    end;

    with ConsNFSe do
    begin
      GerarGrupoPrestador := True;
      GerarGrupoCPFCNPJ   := True;
    end;

    with Cancelar do
    begin
      GerarGrupoCPFCNPJ := True;
      NrOcorrMotCanc_1  := -1;
    end;

    with Gerar do
    begin
      GerarGrupoCPFCNPJ := True;
    end;
  end;
  }

  // Numero de Ocorrencias Minimas de uma tag
  // se for  0 s� gera a tag se o conteudo for diferente de vazio ou zero
  // se for  1 sempre vai gerar a tag
  // se for -1 nunca gera a tag

  // Por padr�o as tags abaixo s�o opcionais
  FNrOcorrRazaoSocialInterm := 0;
  FNrOcorrValorDeducoes := 0;
  FNrOcorrRegimeEspecialTributacao := 0;
  FNrOcorrValorISS := 0;
  FNrOcorrAliquota := 0;
  FNrOcorrDescIncond := 0;
  FNrOcorrDescCond := 0;
  FNrOcorrMunIncid := 0;
  FNrOcorrInscEstInter := 0;
  FNrOcorrOutrasRet := 0;
  FNrOcorrEndereco := 0;
  FNrOcorrUFTomador := 0;
  FNrOcorrCepTomador := 0;
  FNrOcorrCodTribMun_1 := 0;
  FNrOcorrNumProcesso := 0;

  // Por padr�o as tags abaixo s�o obrigat�rias
  FNrOcorrIssRetido := 1;
  FNrOcorrOptanteSimplesNacional := 1;
  FNrOcorrIncentCultural := 1;
  FNrOcorrCodigoPaisServico := 1;
  FNrOcorrCodigoPaisTomador := 1;
  FNrOcorrCompetencia := 1;
  FNrOcorrSerieRPS := 1;
  FNrOcorrTipoRPS := 1;
  FNrOcorrCodigoCNAE := 1;
  FNrOcorrDiscriminacao_1 := 1;
  FNrOcorrExigibilidadeISS := 1;
  FNrOcorrCodigoMunic_1 := 1;
  FNrOcorrInscMunTomador := 1;

  // Por padr�o as tags abaixo n�o devem ser geradas
  FNrOcorrCodTribMun_2 := -1;
  FNrOcorrDiscriminacao_2 := -1;
  FNrOcorrNaturezaOperacao := -1;
  FNrOcorrIdCidade := -1;
  FNrOcorrValorTotalRecebido := -1;
  FNrOcorrInscEstTomador := -1;
  FNrOcorrOutrasInformacoes := -1;
  FNrOcorrTipoNota := -1;
  FNrOcorrSiglaUF := -1;
  FNrOcorrEspDoc := -1;
  FNrOcorrSerieTal := -1;
  FNrOcorrFormaPag := -1;
  FNrOcorrNumParcelas := -1;
  FNrOcorrBaseCalcCRS := -1;
  FNrOcorrIrrfInd := -1;
  FNrOcorrRazaoSocialPrest := -1;
  FNrOcorrPercCargaTrib := -1;
  FNrOcorrValorCargaTrib := -1;
  FNrOcorrPercCargaTribMun := -1;
  FNrOcorrValorCargaTribMun := -1;
  FNrOcorrPercCargaTribEst := -1;
  FNrOcorrValorCargaTribEst := -1;
  FNrOcorrInformacoesComplemetares := -1;
  FNrOcorrValTotTrib := -1;
  FNrOcorrRespRetencao := -1;
  FNrOcorrTipoLogradouro := -1;
  FNrOcorrLogradouro := -1;
  FNrOcorrDDD := -1;
  FNrOcorrTipoTelefone := -1;
  FNrOcorrProducao := -1;
  FNrOcorrAtualizaTomador := -1;
  FNrOcorrTomadorExterior := -1;
  FNrOcorrCodigoMunic_2 := -1;
  FNrOcorrNIFTomador := -1;
  FNrOcorrID := -1;

  FGerarTagServicos := True;
  FGerarIDDeclaracao := True;
  FGerarTagSenhaFraseSecreta := False;
  FGerarEnderecoExterior := False;

  // Propriedades de Formata��o de informa��es
  FormatoEmissao     := tcDat;
  FormatoCompetencia := tcDat;

  FTagTomador := 'Tomador';
end;

function TNFSeW_ABRASFv2.GerarXml: Boolean;
var
  NFSeNode, xmlNode: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 2 do layout da ABRASF n�o deve ser alterado
//  Configuracao;

  ListaDeAlertas.Clear;

  Opcoes.QuebraLinha := FAOwner.ConfigGeral.QuebradeLinha;

  FDocument.Clear();

  NFSeNode := CreateElement('Rps');
  NFSeNode.SetNamespace(FAOwner.ConfigMsgDados.XmlRps.xmlns, Self.PrefixoPadrao);

  FDocument.Root := NFSeNode;

  xmlNode := GerarInfDeclaracaoPrestacaoServico;
  NFSeNode.AppendChild(xmlNode);

  // Define a tag raiz que vai conter o XML da NFS-e
//italo  DefinirRetornoNFSe;

  Result := True;
end;

procedure TNFSeW_ABRASFv2.DefinirIDRps;
begin
  NFSe.InfID.ID := '';
end;

function TNFSeW_ABRASFv2.DefinirNameSpaceDeclaracao: string;
begin
  Result := '';
end;

function TNFSeW_ABRASFv2.GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode;
var
  aNameSpace: string;
begin
  aNameSpace := DefinirNameSpaceDeclaracao;

  Result := CreateElement('InfDeclaracaoPrestacaoServico');

  if aNameSpace <> '' then
    Result.SetNamespace(aNameSpace);

  DefinirIDDeclaracao;

  if (FAOwner.ConfigGeral.Identificador <> '') and GerarIDDeclaracao then
    Result.SetAttribute(FAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  Result.AppendChild(AddNode(tcStr, '#4', 'Id', 1, 15, NrOcorrID,
                                                            NFSe.infID.ID, ''));

  Result.AppendChild(GerarRps);

  Result.AppendChild(GerarListaServicos);

  Result.AppendChild(AddNode(FormatoCompetencia, '#4', 'Competencia', 19, 19, NrOcorrCompetencia,
                                                   NFSe.Competencia, DSC_DEMI));

  Result.AppendChild(GerarServico);
  Result.AppendChild(GerarPrestador);
  Result.AppendChild(GerarTomador);
  Result.AppendChild(GerarIntermediarioServico);
  Result.AppendChild(GerarConstrucaoCivil);

  if (NFSe.RegimeEspecialTributacao <> retNenhum) then
    Result.AppendChild(AddNode(tcStr, '#6', 'RegimeEspecialTributacao', 1, 1, NrOcorrRegimeEspecialTributacao,
   RegimeEspecialTributacaoToStr(NFSe.RegimeEspecialTributacao), DSC_REGISSQN));

  Result.AppendChild(AddNode(tcStr, '#7', 'NaturezaOperacao', 1, 1, NrOcorrNaturezaOperacao,
                   NaturezaOperacaoToStr(NFSe.NaturezaOperacao), DSC_INDNATOP));

  Result.AppendChild(AddNode(tcStr, '#7', 'OptanteSimplesNacional', 1, 1, NrOcorrOptanteSimplesNacional,
                        SimNaoToStr(NFSe.OptanteSimplesNacional), DSC_INDOPSN));

  Result.AppendChild(AddNode(tcStr, '#8', 'IncentivoFiscal', 1, 1, NrOcorrIncentCultural,
                       SimNaoToStr(NFSe.IncentivadorCultural), DSC_INDINCCULT));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributaria', 1, 5, NrOcorrPercCargaTrib,
                                           NFSe.PercentualCargaTributaria, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributaria', 1, 15, NrOcorrValorCargaTrib,
                                                NFSe.ValorCargaTributaria, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributariaMunicipal', 1, 5, NrOcorrPercCargaTribMun,
                                  NFSe.PercentualCargaTributariaMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributariaMunicipal', 1, 15, NrOcorrValorCargaTribMun,
                                       NFSe.ValorCargaTributariaMunicipal, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'PercentualCargaTributariaEstadual', 1, 5, NrOcorrPercCargaTribEst,
                                   NFSe.PercentualCargaTributariaEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'ValorCargaTributariaEstadual', 1, 15, NrOcorrValorCargaTribEst,
                                        NFSe.ValorCargaTributariaEstadual, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'OutrasInformacoes', 0, 255, NrOcorrOutrasInformacoes,
                                        NFSe.OutrasInformacoes, DSC_OUTRASINF));

  Result.AppendChild(AddNode(tcStr, '#9', 'InformacoesComplementares', 0, 2000, NrOcorrInformacoesComplemetares,
                                NFSe.InformacoesComplementares, DSC_OUTRASINF));

  Result.AppendChild(AddNode(tcInt, '#9', 'TipoNota', 1, 3, NrOcorrTipoNota,
                                                            NFSe.TipoNota, ''));

  Result.AppendChild(AddNode(tcStr, '#9', 'SiglaUF', 2, 2, NrOcorrSiglaUF,
                                                             NFSe.SiglaUF, ''));

  if NFSe.Prestador.Endereco.CodigoMunicipio <> '' then
    Result.AppendChild(AddNode(tcStr, '#9', 'IdCidade', 7, 7, NrOcorrIdCidade,
                             NFSe.Prestador.Endereco.CodigoMunicipio, DSC_CMUN))
  else
    Result.AppendChild(AddNode(tcStr, '#9', 'IdCidade', 7, 7, NrOcorrIdCidade,
                                       NFSe.Servico.CodigoMunicipio, DSC_CMUN));

  Result.AppendChild(AddNode(tcInt, '#9', 'EspecieDocumento', 1, 3, NrOcorrEspDoc,
                                        NFSe.EspecieDocumento, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'SerieTalonario', 1, 3, NrOcorrSerieTal,
                                        NFSe.SerieTalonario, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'FormaPagamento', 1, 3, NrOcorrFormaPag,
                                        NFSe.FormaPagamento, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'NumeroParcelas', 1, 3, NrOcorrNumParcelas,
                                        NFSe.NumeroParcelas, ''));

  Result.AppendChild(AddNode(tcInt, '#9', 'Producao', 1, 1, NrOcorrProducao,
                                        SimNaoToStr(NFSe.Producao), DSC_TPAMB));

  Result.AppendChild(GerarValoresServico);

  Result.AppendChild(GerarQuartos);
end;

function TNFSeW_ABRASFv2.GerarRps: TACBrXmlNode;
begin
  Result := CreateElement('Rps');

  DefinirIDRps;

  if (FAOwner.ConfigGeral.Identificador <> '') and GerarIDRps then
    Result.SetAttribute(FAOwner.ConfigGeral.Identificador, NFSe.infID.ID);

  Result.AppendChild(GerarIdentificacaoRPS);

  Result.AppendChild(AddNode(FormatoEmissao, '#4', 'DataEmissao', 19, 19, 1,
                                                   NFSe.DataEmissao, DSC_DEMI));

  Result.AppendChild(GerarStatus);
  Result.AppendChild(GerarRPSSubstituido);
end;

function TNFSeW_ABRASFv2.GerarIdentificacaoRPS: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('IdentificacaoRps');

  Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                         OnlyNumber(NFSe.IdentificacaoRps.Numero), DSC_NUMRPS));

  Result.AppendChild(AddNode(tcStr, '#2', 'Serie ', 1, 05, NrOcorrSerieRPS,
                                    NFSe.IdentificacaoRps.Serie, DSC_SERIERPS));

  Result.AppendChild(GerarTipoRPS);
end;

function TNFSeW_ABRASFv2.GerarRPSSubstituido: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    Result := CreateElement('RpsSubstituido');

    Result.AppendChild(AddNode(tcStr, '#1', 'Numero', 1, 15, 1,
                        OnlyNumber(NFSe.RpsSubstituido.Numero), DSC_NUMRPSSUB));

    Result.AppendChild(AddNode(tcStr, '#2', 'Serie ', 1, 05, 1,
                                   NFSe.RpsSubstituido.Serie, DSC_SERIERPSSUB));

    Result.AppendChild(AddNode(tcStr, '#3', 'Tipo  ', 1, 01, 1,
                       TipoRPSToStr(NFSe.RpsSubstituido.Tipo), DSC_TIPORPSSUB));
  end;
end;

function TNFSeW_ABRASFv2.GerarServico: TACBrXmlNode;
begin
  Result := CreateElement('Servico');

  Result.AppendChild(GerarValores);

  if GerarTagServicos then
  begin
    Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 01, NrOcorrIssRetido,
       SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

    Result.AppendChild(AddNode(tcStr, '#21', 'ResponsavelRetencao', 1, 1, NrOcorrRespRetencao,
     ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), DSC_INDRESPRET));

    case FAOwner.ConfigGeral.FormatoItemListaServico of
      filsSemFormatacao:
        Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 4, NrOcorrItemListaServico,
           StringReplace(NFSe.Servico.ItemListaServico, '.', '', []), DSC_CLISTSERV));

      filsComFormatacaoSemZeroEsquerda:
        if Copy(NFSe.Servico.ItemListaServico, 1, 1) = '0' then
          Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, NrOcorrItemListaServico,
                        Copy(NFSe.Servico.ItemListaServico, 2, 4), DSC_CLISTSERV))
        else
          Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, NrOcorrItemListaServico,
                                   NFSe.Servico.ItemListaServico, DSC_CLISTSERV));
    else
      Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, NrOcorrItemListaServico,
                                   NFSe.Servico.ItemListaServico, DSC_CLISTSERV));
    end;

    Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 7, NrOcorrCodigoCNAE,
                                  OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

    Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun_1,
                       NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

    Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, NrOcorrDiscriminacao_1,
      StringReplace(NFSe.Servico.Discriminacao, ';', FAOwner.ConfigGeral.QuebradeLinha,
                                       [rfReplaceAll, rfIgnoreCase]), DSC_DISCR,
                (NFSe.Prestador.Endereco.CodigoMunicipio <> '3304557')));

    Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, NrOcorrCodigoMunic_1,
                             OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, NrOcorrCodTribMun_2,
                       NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

    Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, NrOcorrDiscriminacao_2,
      StringReplace(NFSe.Servico.Discriminacao, ';', FAOwner.ConfigGeral.QuebradeLinha,
                                       [rfReplaceAll, rfIgnoreCase]), DSC_DISCR,
                (NFSe.Prestador.Endereco.CodigoMunicipio <> '3304557')));

//    Result.AppendChild(AddNode(tcStr, '#33', 'CodigoNbs', 1, 7, NrOcorrCodigoNBS,
//                             OnlyNumber(NFSe.Servico.CodigoNBS), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, NrOcorrCodigoMunic_2,
                             OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(AddNode(tcInt, '#34', 'CodigoPais', 4, 4, NrOcorrCodigoPaisServico,
                                           NFSe.Servico.CodigoPais, DSC_CPAIS));

    Result.AppendChild(AddNode(tcInt, '#35', 'ExigibilidadeISS',
                               NrMinExigISS, NrMaxExigISS, NrOcorrExigibilidadeISS,
    StrToInt(ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS)), DSC_INDISS));

    Result.AppendChild(AddNode(tcInt, '#36', 'MunicipioIncidencia', 7, 07, NrOcorrMunIncid,
                                  NFSe.Servico.MunicipioIncidencia, DSC_MUNINCI));

    Result.AppendChild(AddNode(tcStr, '#37', 'NumeroProcesso     ', 1, 30, NrOcorrNumProcesso,
                                   NFSe.Servico.NumeroProcesso, DSC_NPROCESSO));

    Result.AppendChild(GerarListaItensServico);
  end;
end;

function TNFSeW_ABRASFv2.GerarServicos: TACBrXmlNodeArray;
begin
  Result := nil;
  SetLength(Result, 0);
end;

function TNFSeW_ABRASFv2.GerarStatus: TACBrXmlNode;
begin
  Result := AddNode(tcStr, '#9', 'Status', 1, 1, 1,
                                    StatusRPSToStr(NFSe.Status), DSC_INDSTATUS);
end;

function TNFSeW_ABRASFv2.GerarValores: TACBrXmlNode;
begin
  Result := CreateElement('Valores');

  Result.AppendChild(AddNode(tcDe2, '#13', 'BaseCalculoCRS', 1, 15, NrOcorrBaseCalcCRS,
                                         NFSe.Servico.Valores.BaseCalculo, ''));

  Result.AppendChild(AddNode(tcDe2, '#13', 'IrrfIndenizacao', 1, 15, NrOcorrIrrfInd,
                                     NFSe.Servico.Valores.IrrfIndenizacao, ''));

  Result.AppendChild(AddNode(tcDe2, '#13', 'ValorServicos', 1, 15, 1,
                             NFSe.Servico.Valores.ValorServicos, DSC_VSERVICO));

  Result.AppendChild(AddNode(tcDe2, '#14', 'ValorDeducoes', 1, 15, NrOcorrValorDeducoes,
                            NFSe.Servico.Valores.ValorDeducoes, DSC_VDEDUCISS));

  Result.AppendChild(AddNode(tcDe2, '#15', 'ValorPis     ', 1, 15, NrOcorrValorPis,
                                      NFSe.Servico.Valores.ValorPis, DSC_VPIS));

  Result.AppendChild(AddNode(tcDe2, '#16', 'ValorCofins  ', 1, 15, NrOcorrValorCofins,
                                NFSe.Servico.Valores.ValorCofins, DSC_VCOFINS));

  Result.AppendChild(AddNode(tcDe2, '#17', 'ValorInss    ', 1, 15, NrOcorrValorInss,
                                    NFSe.Servico.Valores.ValorInss, DSC_VINSS));

  Result.AppendChild(AddNode(tcDe2, '#18', 'ValorIr      ', 1, 15, NrOcorrValorIr,
                                        NFSe.Servico.Valores.ValorIr, DSC_VIR));

  Result.AppendChild(AddNode(tcDe2, '#19', 'ValorCsll    ', 1, 15, NrOcorrValorCsll,
                                    NFSe.Servico.Valores.ValorCsll, DSC_VCSLL));

  Result.AppendChild(AddNode(tcDe2, '#23', 'OutrasRetencoes ', 1, 15, NrOcorrOutrasRet,
                    NFSe.Servico.Valores.OutrasRetencoes, DSC_OUTRASRETENCOES));

  Result.AppendChild(AddNode(tcDe2, '#23', 'ValTotTributos  ', 1, 15, NrOcorrValTotTrib,
                                  NFSe.Servico.Valores.ValorTotalTributos, ''));

  Result.AppendChild(AddNode(tcDe2, '#21', 'ValorIss        ', 1, 15, NrOcorrValorISS,
                                      NFSe.Servico.Valores.ValorIss, DSC_VISS));

  if DivAliq100 then
    Result.AppendChild(AddNode(FormatoAliq, '#25', 'Aliquota', 1, 05, NrOcorrAliquota,
                              (NFSe.Servico.Valores.Aliquota / 100), DSC_VALIQ))
  else
    Result.AppendChild(AddNode(FormatoAliq, '#25', 'Aliquota', 1, 05, NrOcorrAliquota,
                                     NFSe.Servico.Valores.Aliquota, DSC_VALIQ));

  Result.AppendChild(AddNode(tcDe2, '#27', 'DescontoIncondicionado', 1, 15, NrOcorrDescIncond,
                 NFSe.Servico.Valores.DescontoIncondicionado, DSC_VDESCINCOND));

  Result.AppendChild(AddNode(tcDe2, '#28', 'DescontoCondicionado  ', 1, 15, NrOcorrDescCond,
                     NFSe.Servico.Valores.DescontoCondicionado, DSC_VDESCCOND));
end;

function TNFSeW_ABRASFv2.GerarValoresServico: TACBrXmlNode;
begin
  Result := nil;
end;

function TNFSeW_ABRASFv2.GerarPrestador: TACBrXmlNode;
begin
  Result := CreateElement('Prestador');

  Result.AppendChild(GerarCPFCNPJ(NFSe.Prestador.IdentificacaoPrestador.Cnpj));

  Result.AppendChild(AddNode(tcStr, '#48', 'RazaoSocial', 1, 115, NrOcorrRazaoSocialPrest,
                           NFSe.Prestador.RazaoSocial, DSC_XNOME));

  Result.AppendChild(AddNode(tcStr, '#35', 'InscricaoMunicipal', 1, 15, 0,
             NFSe.Prestador.IdentificacaoPrestador.InscricaoMunicipal, DSC_IM));

  if GerarTagSenhaFraseSecreta then
  begin
    Result.AppendChild(AddNode(tcStr, '#36', 'Senha', 1, 255, 1,
                                                             Senha, DSC_SENHA));

    Result.AppendChild(AddNode(tcStr, '#37', 'FraseSecreta', 1, 255, 1,
                                               FraseSecreta, DSC_FRASESECRETA));
  end;
end;

function TNFSeW_ABRASFv2.GerarQuarto: TACBrXmlNodeArray;
begin
  Result := nil;
end;

function TNFSeW_ABRASFv2.GerarQuartos: TACBrXmlNode;
begin
  Result := nil;
end;

function TNFSeW_ABRASFv2.GerarTipoRPS: TACBrXmlNode;
begin
  Result := AddNode(tcStr, '#3', 'Tipo', 1, 1, NrOcorrTipoRPS,
                         TipoRPSToStr(NFSe.IdentificacaoRps.Tipo), DSC_TIPORPS);
end;

function TNFSeW_ABRASFv2.GerarTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or
     (NFSe.Tomador.RazaoSocial <> '') or
     (NFSe.Tomador.Endereco.Endereco <> '') or
     (NFSe.Tomador.Contato.Telefone <> '') or
     (NFSe.Tomador.Contato.Email <>'') then
  begin
    Result := CreateElement(FTagTomador);

    if ((NFSe.Tomador.Endereco.UF <> 'EX') and
        ((NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or
         (NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal <> ''))) then
    begin
      Result.AppendChild(GerarIdentificacaoTomador);
    end;

    if NFSe.Tomador.Endereco.UF = 'EX' then
      Result.AppendChild(AddNode(tcStr, '#38', 'NifTomador', 1, 40, NrOcorrNIFTomador,
                                                      NFSe.Tomador.NifTomador));

    Result.AppendChild(AddNode(tcStr, '#38', 'RazaoSocial', 1, 115, 0,
                                          NFSe.Tomador.RazaoSocial, DSC_XNOME));

    Result.AppendChild(GerarEnderecoExteriorTomador);

    Result.AppendChild(GerarEnderecoTomador);
    Result.AppendChild(GerarContatoTomador);

    Result.AppendChild(AddNode(tcStr, '#', 'AtualizaTomador', 1, 1, NrOcorrAtualizaTomador,
                            SimNaoToStr(NFSe.Tomador.AtualizaTomador), '****'));

    Result.AppendChild(AddNode(tcStr, '#', 'TomadorExterior', 1, 1, NrOcorrTomadorExterior,
                            SimNaoToStr(NFSe.Tomador.TomadorExterior), '****'));
  end;
end;

function TNFSeW_ABRASFv2.GerarIdentificacaoTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := CreateElement('IdentificacaoTomador');

  if NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '' then
    Result.AppendChild(GerarCPFCNPJ(NFSe.Tomador.IdentificacaoTomador.CpfCnpj));

  Result.AppendChild(AddNode(tcStr, '#37', 'InscricaoMunicipal', 1, 15, NrOcorrInscMunTomador,
                 NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, DSC_IM));

  Result.AppendChild(AddNode(tcStr, '#38', 'InscricaoEstadual', 1, 20, NrocorrInscEstTomador,
                  NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, DSC_IE));
end;

function TNFSeW_ABRASFv2.GerarEnderecoExteriorTomador: TACBrXmlNode;
begin
  Result := nil;

  if GerarEnderecoExterior and (NFSe.Tomador.Endereco.Endereco <> '') and
     (NFSe.Tomador.Endereco.UF = 'EX') then
  begin
    Result := CreateElement('EnderecoExterior');

    Result.AppendChild(AddNode(tcInt, '#38', 'CodigoPais', 4, 4, 0,
                                  NFSe.Tomador.Endereco.CodigoPais, DSC_CPAIS));

    Result.AppendChild(AddNode(tcStr, '#39', 'EnderecoCompletoExterior', 1, 255, 0,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));
  end;
end;

function TNFSeW_ABRASFv2.GerarEnderecoTomador: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.Tomador.Endereco.Endereco <> '') or (NFSe.Tomador.Endereco.Numero <> '') or
     (NFSe.Tomador.Endereco.Bairro <> '') or (NFSe.Tomador.Endereco.CodigoMunicipio <> '') or
     (NFSe.Tomador.Endereco.UF <> '') or (NFSe.Tomador.Endereco.CEP <> '') then
  begin
    Result := CreateElement('Endereco');

    Result.AppendChild(AddNode(tcStr, '#39', 'Endereco', 1, 125, NrOcorrEndereco,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#39', 'TipoLogradouro', 1, 050, NrOcorrTipoLogradouro,
                               NFSe.Tomador.Endereco.TipoLogradouro, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#39', 'Logradouro', 1, 125, NrOcorrLogradouro,
                                     NFSe.Tomador.Endereco.Endereco, DSC_XLGR));

    Result.AppendChild(AddNode(tcStr, '#40', 'Numero', 1, 010, 0,
                                        NFSe.Tomador.Endereco.Numero, DSC_NRO));

    Result.AppendChild(AddNode(tcStr, '#41', 'Complemento', 1, 060, NrOcorrComplTomador,
                                  NFSe.Tomador.Endereco.Complemento, DSC_XCPL));

    Result.AppendChild(AddNode(tcStr, '#42', 'Bairro', 1, 060, 0,
                                    NFSe.Tomador.Endereco.Bairro, DSC_XBAIRRO));

    Result.AppendChild(AddNode(tcStr, '#43', 'CodigoMunicipio', 7, 007, 0,
                  OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), DSC_CMUN));

    Result.AppendChild(AddNode(tcStr, '#44', 'Uf', 2, 002, NrOcorrUFTomador,
                                             NFSe.Tomador.Endereco.UF, DSC_UF));

    Result.AppendChild(AddNode(tcInt, '#44', 'CodigoPais', 4, 4, NrOcorrCodigoPaisTomador,
                                  NFSe.Tomador.Endereco.CodigoPais, DSC_CPAIS));

    Result.AppendChild(AddNode(tcStr, '#45', 'Cep', 8, 8, NrOcorrCepTomador,
                               OnlyNumber(NFSe.Tomador.Endereco.CEP), DSC_CEP));
  end;
end;

function TNFSeW_ABRASFv2.GerarContatoTomador: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.Tomador.Contato.Telefone <> '') or (NFSe.Tomador.Contato.Email <> '') then
  begin
    Result := CreateElement('Contato');

    Result.AppendChild(AddNode(tcStr, '#46', 'Telefone', 1, 11, NrOcorrFoneTomador,
                          OnlyNumber(NFSe.Tomador.Contato.Telefone), DSC_FONE));

    Result.AppendChild(AddNode(tcStr, '#47', 'Ddd', 1, 3, NrOcorrDDD,
                                            NFSe.Tomador.Contato.DDD, DSC_DDD));

    Result.AppendChild(AddNode(tcStr, '#48', 'TipoTelefone', 1, 2, NrOcorrTipoTelefone,
                            NFSe.Tomador.Contato.TipoTelefone, DSC_TPTELEFONE));

    Result.AppendChild(AddNode(tcStr, '#47', 'Email', 1, 80, NrOcorrEmailTomador,
                                        NFSe.Tomador.Contato.Email, DSC_EMAIL));
  end;
end;

function TNFSeW_ABRASFv2.GerarIntermediarioServico: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.IntermediarioServico.RazaoSocial <> '') or
     (NFSe.IntermediarioServico.CpfCnpj <> '') then
  begin
    Result := CreateElement('IntermediarioServico');

    Result.AppendChild(GerarIdentificacaoIntermediarioServico);

    Result.AppendChild(AddNode(tcStr, '#48', 'RazaoSocial', 1, 115, NrOcorrRazaoSocialInterm,
                             NFSe.IntermediarioServico.RazaoSocial, DSC_XNOME));
  end;
end;

function TNFSeW_ABRASFv2.GerarItemServico: TACBrXmlNodeArray;
begin
  Result := nil;
  SetLength(Result, 0);
end;

function TNFSeW_ABRASFv2.GerarItemValores(i: Integer): TACBrXmlNodeArray;
begin
  Result := nil;
  SetLength(Result, 0);
end;

function TNFSeW_ABRASFv2.GerarListaItensServico: TACBrXmlNode;
begin
  Result := nil;
end;

function TNFSeW_ABRASFv2.GerarListaServicos: TACBrXmlNode;
begin
  Result := nil;
end;

function TNFSeW_ABRASFv2.GerarIdentificacaoIntermediarioServico: TACBrXmlNode;
begin
  Result := nil;

  if (NFSe.IntermediarioServico.CpfCnpj <> '') then
  begin
    Result := CreateElement('IdentificacaoIntermediario');

    Result.AppendChild(GerarCPFCNPJ(NFSe.IntermediarioServico.CpfCnpj));

    Result.AppendChild(AddNode(tcStr, '#50', 'InscricaoMunicipal', 1, 15, NrOcorrInscEstInter,
                         NFSe.IntermediarioServico.InscricaoMunicipal, DSC_IM));
  end;
end;

function TNFSeW_ABRASFv2.GerarConstrucaoCivil: TACBrXmlNode;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  Result := nil;

  if (NFSe.ConstrucaoCivil.CodigoObra <> '') then
  begin
    Result := CreateElement('ConstrucaoCivil');

    Result.AppendChild(AddNode(tcStr, '#51', 'CodigoObra', 1, 15, 1,
                                   NFSe.ConstrucaoCivil.CodigoObra, DSC_COBRA));

    Result.AppendChild(AddNode(tcStr, '#52', 'Art', 1, 15, 1,
                                            NFSe.ConstrucaoCivil.Art, DSC_ART));
  end;
end;

end.
