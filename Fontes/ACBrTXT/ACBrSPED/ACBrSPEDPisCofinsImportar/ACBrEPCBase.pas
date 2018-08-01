{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2010   Macgayver Armini Apolonio            }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 23/02/2015: Macgayver Armini Apolonio
|*  - Cria��o
*******************************************************************************}
unit ACBrEPCBase;

interface

uses
  Classes,
  SysUtils,
  Variants,
  ACBrSpedPisCofins;

type

  // Permite interceptar os valores inseridos pela ACBR.
  TACBrSpedPCImportarGetColumn = procedure(var Coluna: string; const ColunaI: integer) of Object;

  TACBrSpedPCImportar_Base = class
  private
    FAntesInserirValor: TACBrSpedPCImportarGetColumn;
  protected
    Indice: integer;
    Delimitador: TStrings;
    FACBrSPEDPisCofins: TACBrSPEDPisCofins;

    function Head: string;
    function Valor: string; // Procedimento Base para os outros valores
    function ValorI: integer;
    function ValorF: Currency;
    function ValorFV: Variant;
    function ValorD: TDateTime;

  public
    constructor Create;

    procedure AnalisaRegistro(const inDelimitador: TStrings); virtual;

    property ACBrSpedPisCofins: TACBrSPEDPisCofins read FACBrSPEDPisCofins write FACBrSPEDPisCofins;
    property AntesInserirValor: TACBrSpedPCImportarGetColumn read FAntesInserirValor write FAntesInserirValor;
  end;

implementation

{ TBaseIndice }

procedure TACBrSpedPCImportar_Base.AnalisaRegistro(const inDelimitador: TStrings);
begin
  Delimitador := inDelimitador;
end;

constructor TACBrSpedPCImportar_Base.Create;
begin
  Indice := 1;
end;

function TACBrSpedPCImportar_Base.Head: string;
begin
  Result := Delimitador[1];
end;

function TACBrSpedPCImportar_Base.Valor: string;
var
  vValor: string;
begin
  Indice := Indice + 1;
  vValor := Delimitador[Indice];

  if Assigned(FAntesInserirValor) then
    FAntesInserirValor(vValor, Indice);

  Result := vValor;
end;

function TACBrSpedPCImportar_Base.ValorD: TDateTime;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := EncodeDate(StrToInt(Copy(S, 5, 4)), StrToInt(Copy(S, 3, 2)),StrToInt(Copy(S, 1, 2)))
  else
    Result := 0;
end;

function TACBrSpedPCImportar_Base.ValorI: integer;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := StrToInt(S)
  else
    Result := 0;
end;

function TACBrSpedPCImportar_Base.ValorF: Currency;
var
  S: string;
begin
  S := Valor;
  if S <> EmptyStr then
    Result := StrToFloat(S)
  else
    Result := 0;
end;

function TACBrSpedPCImportar_Base.ValorFV: Variant;
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
