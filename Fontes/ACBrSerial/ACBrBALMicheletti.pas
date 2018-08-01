{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2017 André Angeluci                         }
{                                       Juliomar Marchetti                     }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Praça Anita Costa, 34 - Tatuí - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 29/09/2017: André Angeluci
|*  - Primeira Versao ACBrBALMicheletti
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALMicheletti;

interface

uses
  ACBrBALClass, Classes;

type
  TACBrBALMicheletti = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);
    function InterpretarRepostaPeso(aResposta: AnsiString): Double; override;
end;

implementation

uses
  ACBrUtil, ACBrConsts, SysUtils;

{ TACBrBALMicheletti }

constructor TACBrBALMicheletti.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpModeloStr := 'Micheletti';
end;

function TACBrBALMicheletti.InterpretarRepostaPeso(aResposta: AnsiString): Double;
var
  wResposta: AnsiString;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  (* Corta o peso bruto da resposta e substitui o . ou , pelo separador de
     decimais configurado no Windows. *)
  wResposta   := Copy(aResposta, 1, 10);
  wResposta   := Trim(Copy(wResposta, 4, 7));
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  Result := StrToFloatDef(wResposta, 0);
end;

end.
