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

unit Tecnos.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv2, ACBrNFSeXConversao,
  ACBrNFSeXConsts;

type
  { TNFSeW_Tecnos }

  TNFSeW_Tecnos = class(TNFSeW_ABRASFv2)
  protected
    function DefinirNameSpaceDeclaracao: string; override;

    function GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode; override;
    function GerarValores: TACBrXmlNode; override;

    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Tecnos
//==============================================================================

{ TNFSeW_Tecnos }

procedure TNFSeW_Tecnos.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Altera a Configura��o Padr�o para gerar o XML do RPS
  FormatoEmissao := tcDatHor;
  FormatoCompetencia := tcDatHor;
  FormatoAliq := tcDe2;

  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  NrOcorrAliquota := 1;
  NrOcorrTipoNota := 1;
  NrOcorrSiglaUF := 1;
  NrOcorrIdCidade := 1;
  NrOcorrEspDoc := 1;
  NrOcorrSerieTal := 1;
  NrOcorrFormaPag := 1;

  NrOcorrCodigoPaisServico := 1;
  NrOcorrCodigoPaisTomador := 1;
  NrOcorrDescIncond := 1;
  NrOcorrDescCond := 1;

  NrOcorrNaturezaOperacao := 1;
  NrOcorrBaseCalcCRS := 1;
  NrOcorrIrrfInd := 1;
  NrOcorrValorDeducoes := 1;
  NrOcorrOutrasRet := 1;
  NrOcorrRespRetencao := 1;
  NrOcorrNumParcelas := 1;
  NrOcorrRazaoSocialPrest := 1;
  NrOcorrNaturezaOperacao := 1;
  NrOcorrPercCargaTrib := 1;
  NrOcorrValorCargaTrib := 1;
  NrOcorrPercCargaTribMun := 1;
  NrOcorrValorCargaTribMun := 1;
  NrOcorrPercCargaTribEst := 1;
  NrOcorrValorCargaTribEst := 1;
  NrOcorrOutrasInformacoes := 1;

  NrOcorrRegimeEspecialTributacao := 1;

  GerarTagServicos := False;
end;

function TNFSeW_Tecnos.DefinirNameSpaceDeclaracao: string;
begin
  Result := 'http://www.abrasf.org.br/nfse.xsd';
end;

function TNFSeW_Tecnos.GerarInfDeclaracaoPrestacaoServico: TACBrXmlNode;
begin
  Result := CreateElement('tcDeclaracaoPrestacaoServico');

  Result.AppendChild(inherited GerarInfDeclaracaoPrestacaoServico);
end;

function TNFSeW_Tecnos.GerarValores: TACBrXmlNode;
begin
  Result := CreateElement('tcDadosServico');

  Result.AppendChild(inherited GerarValores);

  Result.AppendChild(AddNode(tcStr, '#20', 'IssRetido', 1, 01, 1,
       SituacaoTributariaToStr(NFSe.Servico.Valores.IssRetido), DSC_INDISSRET));

  Result.AppendChild(AddNode(tcStr, '#21', 'ResponsavelRetencao', 1, 1, NrOcorrRespRetencao,
   ResponsavelRetencaoToStr(NFSe.Servico.ResponsavelRetencao), DSC_INDRESPRET));

  Result.AppendChild(AddNode(tcStr, '#29', 'ItemListaServico', 1, 5, 1,
                                 NFSe.Servico.ItemListaServico, DSC_CLISTSERV));

  Result.AppendChild(AddNode(tcStr, '#30', 'CodigoCnae', 1, 7, 1,
                                OnlyNumber(NFSe.Servico.CodigoCnae), DSC_CNAE));

  Result.AppendChild(AddNode(tcStr, '#31', 'CodigoTributacaoMunicipio', 1, 20, 0,
                     NFSe.Servico.CodigoTributacaoMunicipio, DSC_CSERVTRIBMUN));

  Result.AppendChild(AddNode(tcStr, '#32', 'Discriminacao', 1, 2000, 1,
    StringReplace(NFSe.Servico.Discriminacao, ';', FAOwner.ConfigGeral.QuebradeLinha,
                                       [rfReplaceAll, rfIgnoreCase]), DSC_DISCR,
                (NFSe.Prestador.Endereco.CodigoMunicipio <> '3304557')));

  Result.AppendChild(AddNode(tcStr, '#33', 'CodigoMunicipio', 1, 7, 1,
                           OnlyNumber(NFSe.Servico.CodigoMunicipio), DSC_CMUN));

  Result.AppendChild(AddNode(tcInt, '#34', 'CodigoPais', 4, 4, NrOcorrCodigoPaisServico,
                                           NFSe.Servico.CodigoPais, DSC_CPAIS));

  Result.AppendChild(AddNode(tcStr, '#35', 'ExigibilidadeISS', 1, 01, 1,
             ExigibilidadeISSToStr(NFSe.Servico.ExigibilidadeISS), DSC_INDISS));

  Result.AppendChild(AddNode(tcInt, '#36', 'MunicipioIncidencia', 7, 07, NrOcorrMunIncid,
                                NFSe.Servico.MunicipioIncidencia, DSC_MUNINCI));

  Result.AppendChild(AddNode(tcStr, '#37', 'NumeroProcesso', 1, 30, 1,
                                   NFSe.Servico.NumeroProcesso, DSC_NPROCESSO));
end;

end.
