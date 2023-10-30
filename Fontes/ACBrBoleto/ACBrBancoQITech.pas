{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}
//incluido 30/10/2023
{$I ACBr.inc}
unit ACBrBancoQITech;
interface
uses
  Classes, SysUtils, ACBrBancoBradesco, ACBrBoleto;
type
  { TACBrBancoQITechSCD }
  TACBrBancoQITechSCD = class(TACBrBancoBradesco)
  private
  public
    Constructor create(AOwner: TACBrBanco);
    function GetLocalPagamento: String; override;
    function CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String; override;
  end;
implementation
uses ACBrUtil.Base,
     ACBrUtil.FilesIO,
     ACBrUtil.Strings;
constructor TACBrBancoQITechSCD.create(AOwner: TACBrBanco);
begin
  inherited create(AOwner);

  fpNome                       := 'QI SCD';
  fpNumero                     := 329;
  fpDigito                     := 2;
  fpTamanhoMaximoNossoNum      := 11;
  fpTamanhoAgencia             := 4;
  fpTamanhoConta               := 7;
  fpTamanhoCarteira            := 2;
  fpModuloMultiplicadorInicial := 0;
  fpModuloMultiplicadorFinal   := 7;
  fpCodParametroMovimento      := 'MX';
end;

function TACBrBancoQITechSCD.GetLocalPagamento: String;
begin
  Result := ACBrStr('Pag�vel preferencialmente na QI SCD');
end;

function TACBrBancoQITechSCD.CodMotivoRejeicaoToDescricao(const TipoOcorrencia: TACBrTipoOcorrencia; const CodMotivo: String): String;
var LMotivo : String;
begin
  LMotivo := inherited CodMotivoRejeicaoToDescricao(TipoOcorrencia, CodMotivo);
  LMotivo := StringReplace( LMotivo, 'Bradesco Expresso', 'QI Tech', [rfReplaceAll,rfIgnoreCase]);
  Result  := StringReplace( LMotivo, 'Bradesco', 'QI Tech', [rfReplaceAll,rfIgnoreCase]);
end;
end.
