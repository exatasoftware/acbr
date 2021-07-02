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

unit ModeloV2.GravarXml;
{
  Trocar todas as ocorrencias de "ModeloV2" pelo nome do provedor
}

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrNFSeXGravarXml_ABRASFv2;

type
  { TNFSeW_ModeloV2 }

  TNFSeW_ModeloV2 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     ModeloV2
//==============================================================================

{ TNFSeW_ModeloV2 }

procedure TNFSeW_ModeloV2.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  {
     Todos os par�metros de configura��o est�o com os seus valores padr�es.

     Se a configura��o padr�o atende o provedor ela pode ser excluida dessa
     procedure.

     Portanto deixe somente os par�metros de configura��o que foram alterados
     para atender o provedor.
  }

  // Propriedades de Formata��o de informa��es
  // elas requerem que seja declarado em uses a unit: ACBrXmlBase
  {
  FormatoEmissao     := tcDat;
  FormatoCompetencia := tcDat;

  FormatoAliq := tcDe4;
  }
  DivAliq100  := False;

  NrMinExigISS := 1;
  NrMaxExigISS := 1;

  GerarTagServicos := True;
  GerarIDRps := False;
  GerarIDDeclaracao := True;
  GerarTagSenhaFraseSecreta := False;
  GerarEnderecoExterior := False;

  TagTomador := 'Tomador';

  // Numero de Ocorrencias Minimas de uma tag
  // se for  0 s� gera a tag se o conteudo for diferente de vazio ou zero
  // se for  1 sempre vai gerar a tag
  // se for -1 nunca gera a tag

  // Por padr�o as tags abaixo s�o opcionais
  NrOcorrRazaoSocialInterm := 0;
  NrOcorrValorDeducoes := 0;
  NrOcorrRegimeEspecialTributacao := 0;
  NrOcorrValorISS := 0;
  NrOcorrAliquota := 0;
  NrOcorrDescIncond := 0;
  NrOcorrDescCond := 0;
  NrOcorrMunIncid := 0;
  NrOcorrInscEstInter := 0;
  NrOcorrOutrasRet := 0;
  NrOcorrEndereco := 0;
  NrOcorrUFTomador := 0;
  NrOcorrCepTomador := 0;
  NrOcorrCodTribMun_1 := 0;
  NrOcorrNumProcesso := 0;
  NrOcorrInscMunTomador := 0;

  // Por padr�o as tags abaixo s�o obrigat�rias
  NrOcorrIssRetido := 1;
  NrOcorrOptanteSimplesNacional := 1;
  NrOcorrIncentCultural := 1;
  NrOcorrItemListaServico := 1;
  NrOcorrCodigoPaisServico := 1;
  NrOcorrCodigoPaisTomador := 1;
  NrOcorrCompetencia := 1;
  NrOcorrSerieRPS := 1;
  NrOcorrTipoRPS := 1;
  NrOcorrCodigoCNAE := 1;
  NrOcorrDiscriminacao_1 := 1;
  NrOcorrExigibilidadeISS := 1;
  NrOcorrCodigoMunic_1 := 1;

  // Por padr�o as tags abaixo n�o devem ser geradas
  NrOcorrCodTribMun_2 := -1;
  NrOcorrDiscriminacao_2 := -1;
  NrOcorrNaturezaOperacao := -1;
  NrOcorrIdCidade := -1;
  NrOcorrValorTotalRecebido := -1;
  NrOcorrInscEstTomador := -1;
  NrOcorrOutrasInformacoes := -1;
  NrOcorrTipoNota := -1;
  NrOcorrSiglaUF := -1;
  NrOcorrEspDoc := -1;
  NrOcorrSerieTal := -1;
  NrOcorrFormaPag := -1;
  NrOcorrNumParcelas := -1;
  NrOcorrBaseCalcCRS := -1;
  NrOcorrIrrfInd := -1;
  NrOcorrRazaoSocialPrest := -1;
  NrOcorrPercCargaTrib := -1;
  NrOcorrValorCargaTrib := -1;
  NrOcorrPercCargaTribMun := -1;
  NrOcorrValorCargaTribMun := -1;
  NrOcorrPercCargaTribEst := -1;
  NrOcorrValorCargaTribEst := -1;
  NrOcorrInformacoesComplemetares := -1;
  NrOcorrValTotTrib := -1;
  NrOcorrRespRetencao := -1;
  NrOcorrTipoLogradouro := -1;
  NrOcorrLogradouro := -1;
  NrOcorrDDD := -1;
  NrOcorrTipoTelefone := -1;
  NrOcorrProducao := -1;
  NrOcorrAtualizaTomador := -1;
  NrOcorrTomadorExterior := -1;
  NrOcorrCodigoMunic_2 := -1;
  NrOcorrNIFTomador := -1;
  NrOcorrID := -1;
end;

end.
