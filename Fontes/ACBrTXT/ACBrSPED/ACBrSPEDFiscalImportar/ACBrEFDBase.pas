{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Macgayver Armini Apolonio, Rodrigo Buschmann e  }
{                              Rodrigo Coelho                                  }
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

{******************************************************************************
|* Historico
|*
|* 23/02/2015: Macgayver Armini Apolonio - Cria��o
|* 03/07/2017: Rodrigo Buschmann | Digibyte - Importa��o ICMS IPI
|* 30/04/2019: Rodrigo Coelho | Bunny Soft - Tratamento de exce��o
|*  - Verifica��o se o �ndique que se est� tentando ler n�o � maior que a quantidade
|*  de colunas dispon�veis no arquivo que est� sendo importado. Isso pode acontecer
|*  quando tentamos importar arquivos de SPED mais antigos que possuem menos colunas
|*  que a defini��o atual
*******************************************************************************}
unit ACBrEFDBase;

interface

uses
  Classes,
  SysUtils,
  Variants,
  ACBrSpedFiscal;

type

  // Permite interceptar os valores inseridos pela ACBR.
  TACBrSpedFiscalImportarGetColumn = procedure(var Coluna: string; const ColunaI: integer) of Object;

  TACBrSpedFiscalImportar_Base = class
  private
    FAntesInserirValor: TACBrSpedFiscalImportarGetColumn;
  protected
    Indice: integer;
    Delimitador: TStrings;
    FACBrSPEDFiscal: TACBrSPEDFiscal;

    function Head: string;
    function Valor: string; // Procedimento Base para os outros valores
    function ValorI: integer;
    function ValorF: Currency;
    function ValorFV: Variant;
    function ValorD: TDateTime;

  public
    constructor Create;

    procedure AnalisaRegistro(const inDelimitador: TStrings); virtual;

    property ACBrSpedFiscal: TACBrSPEDFiscal read FACBrSPEDFiscal write FACBrSPEDFiscal;
    property AntesInserirValor: TACBrSpedFiscalImportarGetColumn read FAntesInserirValor write FAntesInserirValor;
  end;

implementation

{ TBaseIndice }

procedure TACBrSpedFiscalImportar_Base.AnalisaRegistro(const inDelimitador: TStrings);
begin
  Delimitador := inDelimitador;
end;

constructor TACBrSpedFiscalImportar_Base.Create;
begin
  Indice := 1;
end;

function TACBrSpedFiscalImportar_Base.Head: string;
begin
  Result := Delimitador[1];
end;

function TACBrSpedFiscalImportar_Base.Valor: string;
var
  vValor: string;
begin
  Indice := Indice + 1;
  // Verificar se �ndice a ser lido n�o � maior que a quantidade de colunas dispon�veis no arquivo
  if (Indice <= Delimitador.Count - 1) then
    vValor := Delimitador[Indice]
  else
    vValor := '';

  if Assigned(FAntesInserirValor) then
    FAntesInserirValor(vValor, Indice);

  Result := vValor;
end;

function TACBrSpedFiscalImportar_Base.ValorD: TDateTime;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := EncodeDate(StrToInt(Copy(S, 5, 4)), StrToInt(Copy(S, 3, 2)),StrToInt(Copy(S, 1, 2)))
  else
    Result := 0;
end;

function TACBrSpedFiscalImportar_Base.ValorI: integer;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := StrToInt(S)
  else
    Result := 0;
end;

function TACBrSpedFiscalImportar_Base.ValorF: Currency;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := StrToFloat(S)
  else
    Result := 0;
end;

function TACBrSpedFiscalImportar_Base.ValorFV: Variant;
var
  S: string;
begin
  S := Valor;
  if S = EmptyStr then
    Result := Null
  else
    Result := StrToFloat(S);
end;

end.
