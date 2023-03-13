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

unit Saatri.LerXml;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrNFSeXLerXml_ABRASFv2;

type
  { TNFSeR_Saatri201 }

  TNFSeR_Saatri201 = class(TNFSeR_ABRASFv2)
  protected

  public
//    function LerXml: Boolean; override;

  end;

implementation

uses
  ACBrJSON;

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Saatri
//==============================================================================

{ TNFSeR_Saatri201 }
(*
function TNFSeR_Saatri201.LerXml: Boolean;
var
  xDiscriminacao: string;
  json, jsonItem: TACBrJsonObject;
  i: Integer;
begin
  Result := inherited LerXml;

  // Tratar a Discriminacao do servi�o

  xDiscriminacao := NFSe.Servico.Discriminacao;
  FpAOwner.ConfigGeral.DetalharServico := False;

  if (Pos('[', xDiscriminacao) > 0) and (Pos(']', xDiscriminacao) > 0) and
     (Pos('{', xDiscriminacao) > 0) and (Pos('}', xDiscriminacao) > 0) then
  begin
    FpAOwner.ConfigGeral.DetalharServico := True;

    xDiscriminacao := '{"a": ' + xDiscriminacao + '}';
    Json := TACBrJsonObject.Parse(xDiscriminacao);

    for i := 0 to json.AsJSONArray['a'].Count -1 do
    begin
      jsonItem := json.AsJSONArray['a'].ItemAsJSONObject[i];

      with NFSe.Servico.ItemServico.New do
      begin
        Descricao := jsonItem.AsString['Descricao'];
        ValorUnitario := jsonItem.AsCurrency['ValorUnitario'];
        Quantidade := jsonItem.AsCurrency['Quantidade'];
        ValorTotal := jsonItem.AsCurrency['ValorTotal'];
      end;
    end;
  end;
end;
*)
end.
