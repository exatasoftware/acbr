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

unit ACBrNFSeXLerXml;

interface

uses
  SysUtils, Classes,
  ACBrXmlBase, ACBrXmlReader,
  ACBrNFSeXInterface, ACBrNFSeXClass, ACBrNFSeXConversao;

type
  { TNFSeRClass }

  TNFSeRClass = class(TACBrXmlReader)
  private
    FNFSe: TNFSe;
    FProvedor: TnfseProvedor;
    FtpXML: TtpXML;
    FAmbiente: TACBrTipoAmbiente;

  protected
    FpAOwner: IACBrNFSeXProvider;

    function NormatizarItemListaServico(const Codigo: string): string;
    function ItemListaServicoDescricao(const Codigo: string): string;
    function TipodeXMLLeitura(const aArquivo: string): TtpXML; virtual;
    function NormatizarXml(const aXml: string): string; virtual;
  public
    constructor Create(AOwner: IACBrNFSeXProvider);

    function LerXml: Boolean; Override;

    property NFSe: TNFSe             read FNFSe     write FNFSe;
    property Provedor: TnfseProvedor read FProvedor write FProvedor;
    property tpXML: TtpXML           read FtpXML    write FtpXML;
    property Ambiente: TACBrTipoAmbiente read FAmbiente write FAmbiente default taHomologacao;
  end;

implementation

uses
  ACBrUtil.Strings,
  ACBrDFeException;

{ TNFSeRClass }

constructor TNFSeRClass.Create(AOwner: IACBrNFSeXProvider);
begin
  FpAOwner := AOwner;
end;

function TNFSeRClass.ItemListaServicoDescricao(const Codigo: string): string;
var
  xCodigo: string;
begin
  xCodigo := OnlyNumber(Codigo);

  if FpAOwner.ConfigGeral.TabServicosExt then
    Result := ObterDescricaoServico(xCodigo)
  else
    Result := CodItemServToDesc(xCodigo);
end;

function TNFSeRClass.LerXml: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.LerXml, n�o implementado');
end;

function TNFSeRClass.NormatizarItemListaServico(const Codigo: string): string;
var
  Item: Integer;
  xCodigo: string;
begin
  xCodigo := Codigo;

  Item := StrToIntDef(OnlyNumber(xCodigo), 0);
  if Item < 100 then
    Item := Item * 100 + 1;

  xCodigo := FormatFloat('0000', Item);

  Result := Copy(xCodigo, 1, 2) + '.' + Copy(xCodigo, 3, 2);
end;

function TNFSeRClass.NormatizarXml(const aXml: string): string;
begin
  Result := aXml;
end;

function TNFSeRClass.TipodeXMLLeitura(const aArquivo: string): TtpXML;
begin
  if (Pos('/infnfse>', LowerCase(Arquivo)) > 0) then
    Result := txmlNFSe
  else
    Result := txmlRPS;
end;

end.
