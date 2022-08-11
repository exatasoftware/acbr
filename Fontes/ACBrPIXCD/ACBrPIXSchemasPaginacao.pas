{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXSchemasPaginacao;

interface

uses
  Classes, SysUtils, ACBrJSON, ACBrPIXBase;

type

  { TACBrPIXPaginacao }

  TACBrPIXPaginacao = class(TACBrPIXSchema)
  private
    fitensPorPagina: Integer;
    fpaginaAtual: Integer;
    fquantidadeDePaginas: Integer;
    fquantidadeTotalDeItens: Integer;
  protected
    procedure DoWriteToJSon(AJSon: TACBrJSONObject); override;
    procedure DoReadFromJSon(AJSon: TACBrJSONObject); override;
  public
    constructor Create(const ObjectName: String); override;
    procedure Clear; override;
    function IsEmpty: Boolean; override;
    procedure Assign(Source: TACBrPIXPaginacao);

    property paginaAtual: Integer read fpaginaAtual write fpaginaAtual;
    property itensPorPagina: Integer read fitensPorPagina write fitensPorPagina;
    property quantidadeDePaginas: Integer read fquantidadeDePaginas write fquantidadeDePaginas;
    property quantidadeTotalDeItens: Integer read fquantidadeTotalDeItens write fquantidadeTotalDeItens;
  end;

implementation

{ TACBrPIXPaginacao }

constructor TACBrPIXPaginacao.Create(const ObjectName: String);
begin
  inherited Create(ObjectName);
  Clear;
end;

procedure TACBrPIXPaginacao.Clear;
begin
  fitensPorPagina := 0;
  fpaginaAtual := 0;
  fquantidadeDePaginas := 0;
  fquantidadeTotalDeItens := 0;
end;

function TACBrPIXPaginacao.IsEmpty: Boolean;
begin
  Result := (fitensPorPagina = 0) and
            (fpaginaAtual = 0) and
            (fquantidadeDePaginas = 0) and
            (fquantidadeTotalDeItens = 0);
end;

procedure TACBrPIXPaginacao.Assign(Source: TACBrPIXPaginacao);
begin
  fitensPorPagina := Source.itensPorPagina;
  fpaginaAtual := Source.paginaAtual;
  fquantidadeDePaginas := Source.quantidadeDePaginas;
  fquantidadeTotalDeItens := Source.quantidadeTotalDeItens;
end;

procedure TACBrPIXPaginacao.DoWriteToJSon(AJSon: TACBrJSONObject);
begin
  aJson
    .AddPair('itensPorPagina', fitensPorPagina)
    .AddPair('paginaAtual', fpaginaAtual)
    .AddPair('quantidadeDePaginas', fquantidadeDePaginas)
    .AddPair('quantidadeTotalDeItens', fquantidadeTotalDeItens);
end;

procedure TACBrPIXPaginacao.DoReadFromJSon(AJSon: TACBrJSONObject);
begin
  AJSon
    .Value('itensPorPagina', fitensPorPagina)
    .Value('paginaAtual', fpaginaAtual)
    .Value('quantidadeDePaginas', fquantidadeDePaginas)
    .Value('quantidadeTotalDeItens', fquantidadeTotalDeItens);
end;

end.

