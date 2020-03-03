{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Carlos H. Marian                                }
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

unit ACBrPAF_Z;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrPAFRegistros;

type

  /// REGISTRO TIPO Z1 - IDENTIFICA��O DO USU�RIO DO PAF-ECF
  TRegistroZ1 = class(TRegistroX1);

  // REGISTRO TIPO Z2 - IDENTIFICA��O DA EMPRESA DESENVOLVEDORA DO PAF-ECF:
  TRegistroZ2 = Class(TRegistroX1);

  // REGISTRO TIPO Z3 - IDENTIFICA��O DO PAF-ECF
  TRegistroZ3 = Class(TRegistroX3);

  // REGISTRO TIPO Z4 � Totaliza��o de vendas a CPF/CNPJ:
  TRegistroZ4 = Class
  private
    fCPF_CNPJ: string;         /// N�mero do CPF/CNPJ identificado no campo previsto no item 2 do Requsito VIII.
    fVl_Total: Currency ;  /// Total de vendas no m�s, com duas casas decimais, ao CPF/CNPJ indicado no campo 02.
    fData_INI: TDateTime;  /// Primeiro dia do m�s a que se refere o relat�rio de vendas ao CPF/CNPJ identificado no campo 02
    fData_FIN: TDateTime;  /// �ltimo dia do m�s a que se refere o relat�rio de vendas ao CPF/CNPJ identificado no campo 02
  public
    property CPF_CNPJ: string read FCPF_CNPJ write FCPF_CNPJ;
    property VL_TOTAL: Currency  read fVl_Total write fVl_Total;
    property DATA_INI: TDateTime read fData_INI write fData_INI;
    property DATA_FIM: TDateTime read fData_FIN write fData_FIN;
  end;

  /// REGISTRO TIPO Z4 � Lista
  TRegistroZ4List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroZ4;
    procedure SetItem(Index: Integer; const Value: TRegistroZ4);
  public
    function New: TRegistroZ4;
    property Items[Index: Integer]: TRegistroZ4 read GetItem write SetItem;
  end;

  // REGISTRO TIPO Z9 - TOTALIZA��O DO ARQUIVO
  TRegistroZ9 = Class(TRegistroX9);

  // REGISTRO TIPO EAD - ASSINATURA DIGITAL

implementation

{ TRegistroZ4List }

function TRegistroZ4List.GetItem(Index: Integer): TRegistroZ4;
begin
  Result := TRegistroZ4(inherited Items[Index]);
end;

function TRegistroZ4List.New: TRegistroZ4;
begin
  Result := TRegistroZ4.Create;
  Add(Result);
end;

procedure TRegistroZ4List.SetItem(Index: Integer; const Value: TRegistroZ4);
begin
  Put(Index, Value);
end;

end.
