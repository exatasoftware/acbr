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

unit Betha.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXLerXml_ABRASFv1, ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Betha }

  TNFSeR_Betha = class(TNFSeR_ABRASFv1)
  protected

  public
    function LerXml: Boolean; override;

  end;

  { TNFSeR_Betha202 }

  TNFSeR_Betha202 = class(TNFSeR_ABRASFv2)
  protected

  public

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Betha
//==============================================================================

{ TNFSeR_Betha }

function TNFSeR_Betha.LerXml: Boolean;
var
  xDiscriminacao, xDescricao, xItemServico: string;
  fQuantidade, fValorUnitario, fValorServico, fValorBC, fAliquota: Double;
  i, j: Integer;

  function ExtraiValorCampo(aCampo: string; aCampoNumerico: Boolean): string;
  begin
    i := PosEx(aCampo, xDiscriminacao, j) + Length(aCampo) + 1;

    if i = Length(aCampo) + 1 then
      Result := ''
    else
    begin
      j := PosEx(']', xDiscriminacao, i);
      Result := Copy(xDiscriminacao, i, j-i);

      if aCampoNumerico then
        Result := StringReplace(Result, '.', ',', [rfReplaceAll])
    end;
  end;
begin
  Result := inherited LerXml;

  // Tratar a Discriminacao do servi�o
  xDiscriminacao := NFSe.Servico.Discriminacao;
  J := 1;

  while true do
  begin
    xDescricao := ExtraiValorCampo('Descricao', False);

    if xDescricao = '' then
      Break;

    xItemServico := ExtraiValorCampo('ItemServico', False);
    fQuantidade := StrToFloatDef(ExtraiValorCampo('Quantidade', True), 0);
    fValorUnitario := StrToFloatDef(ExtraiValorCampo('ValorUnitario', True), 0);
    fValorServico := StrToFloatDef(ExtraiValorCampo('ValorServico', True), 0);
    fValorBC := StrToFloatDef(ExtraiValorCampo('ValorBaseCalculo', True), 0);
    fAliquota := StrToFloatDef(ExtraiValorCampo('Aliquota', True), 0);

    with NFSe.Servico.ItemServico.New do
    begin
      Descricao := xDescricao;
      ItemListaServico := xItemServico;
      Quantidade := fQuantidade;
      ValorUnitario := fValorUnitario;
      ValorTotal := fValorServico;
      ValorBCINSS := fValorBC;
      Aliquota := fAliquota;
    end;
  end;
end;

end.
