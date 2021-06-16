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

unit SimplISS.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv1, ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_SimplISS }

  TNFSeW_SimplISS = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarItensServico: TACBrXmlNodeArray; override;
  end;

  { TNFSeW_SimplISSv2 }

  TNFSeW_SimplISSv2 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     SimplISS
//==============================================================================

{ TNFSeW_SimplISS }

procedure TNFSeW_SimplISS.Configuracao;
begin
  inherited Configuracao;

  NrOcorrOutrasInformacoes := 0;
  NrOcorrInscEstTomador := 0;

  PrefixoPadrao := 'nfse';
end;

function TNFSeW_SimplISS.GerarItensServico: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.Servico.ItemServico.Count);

  for i := 0 to NFSe.Servico.ItemServico.Count - 1 do
  begin
    Result[i] := CreateElement('ItensServico');

    Result[i].AppendChild(AddNode(tcStr, '#33', 'Descricao    ', 1, 100, 1,
                             NFSe.Servico.ItemServico[i].Descricao, DSC_XSERV));

    Result[i].AppendChild(AddNode(tcDe2, '#34', 'Quantidade   ', 1, 015, 1,
                             NFSe.Servico.ItemServico[i].Quantidade, DSC_QTDE));

    Result[i].AppendChild(AddNode(tcDe4, '#35', 'ValorUnitario', 1, 015, 1,
                         NFSe.Servico.ItemServico[i].ValorUnitario, DSC_VUNIT));
  end;

  if NFSe.Servico.ItemServico.Count > 10 then
    wAlerta('#54', 'ItensServico', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

{ TNFSeW_SimplISSv2 }

procedure TNFSeW_SimplISSv2.Configuracao;
begin
  inherited Configuracao;

  FormatoAliq := tcDe2;
  NrOcorrValorDeducoes := 1;
  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  NrOcorrOutrasRet := 1;
  NrOcorrValTotTrib := 1;
  NrOcorrAliquota := 1;
  NrOcorrDescIncond := 1;
  NrOcorrDescCond := 1;
  NrOcorrCodigoPaisServico := 1;
  NrOcorrValorISS := -1;
end;

end.
