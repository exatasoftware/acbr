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

unit Betha.GravarXml;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlDocument,
  pcnConsts,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv1, ACBrNFSeXGravarXml_ABRASFv2,
  ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_Betha }

  TNFSeW_Betha = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

    function GerarCondicaoPagamento: TACBrXmlNode; override;
    function GerarParcelas: TACBrXmlNodeArray; override;
  end;

  { TNFSeW_Bethav2 }

  TNFSeW_Bethav2 = class(TNFSeW_ABRASFv2)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Betha
//==============================================================================

{ TNFSeW_Betha }

procedure TNFSeW_Betha.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Altera a Configura��o Padr�o para gerar o XML do RPS
  NrOcorrOutrasInformacoes := 0;
  NrOcorrValorISSRetido_1  := -1;
  NrOcorrValorISSRetido_2  := 0;
  NrOcorrInscEstTomador    := 0;
  //PrefixoPadrao := 'ns3';
end;

function TNFSeW_Betha.GerarCondicaoPagamento: TACBrXmlNode;
var
  nodeArray: TACBrXmlNodeArray;
  i: Integer;
begin
  Result := CreateElement('CondicaoPagamento');

  if (NFSe.CondicaoPagamento.QtdParcela > 0) and
     (NFSe.CondicaoPagamento.Condicao = cpAPrazo) then
  begin
    Result.AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
                     CondicaoToStr(NFSe.CondicaoPagamento.Condicao), DSC_TPAG));

    Result.AppendChild(AddNode(tcInt, '#54', 'QtdParcela', 1, 03, 1,
                                 NFSe.CondicaoPagamento.QtdParcela, DSC_QPARC));

    nodeArray := GerarParcelas;
    if nodeArray <> nil then
    begin
      for i := 0 to Length(nodeArray) - 1 do
      begin
        Result.AppendChild(nodeArray[i]);
      end;
    end;
  end
  else
    Result.AppendChild(AddNode(tcStr, '#53', 'Condicao', 1, 15, 1,
                                                          'A_VISTA', DSC_TPAG));
end;

function TNFSeW_Betha.GerarParcelas: TACBrXmlNodeArray;
var
  i: integer;
begin
  Result := nil;
  SetLength(Result, NFSe.CondicaoPagamento.Parcelas.Count);

  for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count - 1 do
  begin
    Result[i] := CreateElement('Parcelas');

    Result[i].AppendChild(AddNode(tcInt, '#55', 'Parcela', 1, 03, 1,
                  NFSe.CondicaoPagamento.Parcelas.Items[i].Parcela, DSC_NPARC));

    Result[i].AppendChild(AddNode(tcDatVcto, '#56', 'DataVencimento', 10, 10, 1,
           NFSe.CondicaoPagamento.Parcelas.Items[i].DataVencimento, DSC_DVENC));

    Result[i].AppendChild(AddNode(tcDe2, '#57', 'Valor', 1, 18, 1,
                    NFSe.CondicaoPagamento.Parcelas.Items[i].Valor, DSC_VPARC));
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 10 then
    wAlerta('#54', 'Parcelas', '', ERR_MSG_MAIOR_MAXIMO + '10');
end;

{ TNFSeW_Bethav2 }

procedure TNFSeW_Bethav2.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Altera a Configura��o Padr�o para gerar o XML do RPS
  NrOcorrCodigoPaisServico := -1;

end;

end.
