{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrPagForLerTxt;

interface

uses
  SysUtils, Classes,
  ACBrPagForInterface, ACBrPagForClass, ACBrPagForConversao;

type
  { TArquivoRClass }

  TArquivoRClass = class
  private
    FPagFor: TPagFor;
    FBanco: TBanco;
    FArquivo: string;
  protected
    FpAOwner: IACBrPagForProvider;

    procedure Configuracao; virtual;

    function LerCampo(const Linha: string; Inicio, Tamanho: Integer;
      Tipo: TTipoCampo): Variant;
  public
    constructor Create(AOwner: IACBrPagForProvider);

    function LerTxt: Boolean; virtual;

    property PagFor: TPagFor read FPagFor  write FPagFor;
    property Banco: TBanco   read FBanco   write FBanco;
    property Arquivo: string read FArquivo write FArquivo;
  end;

implementation

uses
  ACBrUtil.Base, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrDFeException;

{ TArquivoRClass }

procedure TArquivoRClass.Configuracao;
begin
  // Nada implementado
end;

constructor TArquivoRClass.Create(AOwner: IACBrPagForProvider);
begin
  FpAOwner := AOwner;
end;

function TArquivoRClass.LerCampo(const Linha: string; Inicio, Tamanho: Integer;
  Tipo: TTipoCampo): Variant;
var
  ConteudoCampo: string;
  iDecimais: Integer;
begin
  ConteudoCampo := Copy(Trim(Linha), Inicio, Tamanho);

  case Tipo of
    tcStr:
      result := Trim(ConteudoCampo);

    tcDat:
      begin
        if length(ConteudoCampo) > 0 then
        begin
          ConteudoCampo := Copy(ConteudoCampo, 1, 2) + '/' +
                           Copy(ConteudoCampo, 3, 2) + '/' +
                           Copy(ConteudoCampo, 5, 4);
          result := EncodeDataHora(ConteudoCampo, 'DD/MM/YYYY');
        end
        else
          result := 0;
      end;

    tcDatISO:
      begin
        if length(ConteudoCampo) > 0 then
          result := EncodeDataHora(ConteudoCampo, 'YYYY/MM/DD')
        else
          result := 0;
      end;

    tcHor:
      begin
        if length(ConteudoCampo) > 0 then
          result := EncodeTime(StrToIntDef(copy(ConteudoCampo, 1, 2), 0),
                               StrToIntDef(copy(ConteudoCampo, 3, 2), 0),
                               StrToIntDef(copy(ConteudoCampo, 5, 2), 0), 0)
        else
          result := 0;
      end;

    tcDe2, tcDe5, tcDe8:
      begin
        case Tipo of
          tcDe2: iDecimais := 2;
          tcDe5: iDecimais := 5;
          tcDe8: iDecimais := 8;
        else
          iDecimais := 2;
        end;

        Result := StringDecimalToFloat(ConteudoCampo, iDecimais);
      end;

    tcInt:
      begin
        if length(ConteudoCampo) > 0 then
          result := StrToIntDef(OnlyNumber(ConteudoCampo), 0)
        else
          result := 0;
      end;

    tcInt64:
      begin
        if length(ConteudoCampo) > 0 then
          result := StrToInt64Def(OnlyNumber(ConteudoCampo), 0)
        else
          result := 0;
      end;
  else
    raise Exception.Create('Campo <' + Linha + '> com conte�do inv�lido. ' +
                           ConteudoCampo);
  end;
end;

function TArquivoRClass.LerTxt: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.LerTxt, n�o implementado');
end;

end.
