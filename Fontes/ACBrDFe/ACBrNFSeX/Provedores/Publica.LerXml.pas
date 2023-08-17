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

unit Publica.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml_ABRASFv1;

type
  { TNFSeR_Publica }

  TNFSeR_Publica = class(TNFSeR_ABRASFv1)
  protected
    procedure LerCondicaoPagamento(const ANode: TACBrXmlNode);
    procedure LerInfNfse(const ANode: TACBrXmlNode); override;

  public
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Publica
//==============================================================================

{ TNFSeR_Publica }

procedure TNFSeR_Publica.LerCondicaoPagamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  ANodes: TACBrXmlNodeArray;
  i: Integer;
  Ok: Boolean;
begin
  AuxNode := ANode.Childrens.FindAnyNs('CondicaoPagamento');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      ANodes := AuxNode.Childrens.FindAllAnyNs('Parcelas');

      for i := 0 to Length(ANodes) - 1 do
      begin
        CondicaoPagamento.Parcelas.New;
        with CondicaoPagamento.Parcelas[i] do
        begin
          Condicao := FpAOwner.StrToCondicaoPag(Ok, ObterConteudo(ANodes[i].Childrens.FindAnyNs('Condicao'), tcStr));
          Parcela := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Parcela'), tcStr);
          Valor := ObterConteudo(ANodes[i].Childrens.FindAnyNs('Valor'), tcDe2);
          DataVencimento := ObterConteudo(ANodes[i].Childrens.FindAnyNs('DataVencimento'), tcDat);
        end;
      end;
    end;
  end;
end;

procedure TNFSeR_Publica.LerInfNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  inherited LerInfNfse(ANode);

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfNfse');

  if AuxNode <> nil then
    LerCondicaoPagamento(AuxNode);
end;

function TNFSeR_Publica.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := inherited LerXmlRps(Anode);

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfRps');

  if AuxNode <> nil then
    LerCondicaoPagamento(AuxNode);
end;

end.
