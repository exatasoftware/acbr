{******************************************************************************}
{ Projeto: Componente ACBrBlocoX                                               }
{ Biblioteca multiplataforma de componentes Delphi para Gera��o de arquivos    }
{ do Bloco X                                                                   }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{******************************************************************************}

{$I ACBr.inc}

unit pcnRetEnvBlocoX;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor;

type

  { TRetEnvBlocoX }

  TRetEnvBlocoX = class(TPersistent)
  private
    fLeitor         : TLeitor;
    fVersao         : AnsiString;
    fSituacaoProcCod: Integer;
    fSituacaoProcStr: AnsiString;
    fRecibo         : AnsiString;
    fTipo           : AnsiString;
    fMensagem       : AnsiString;
    fDataRef        : AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor         : TLeitor    read fLeitor;
    property Versao         : AnsiString read fVersao;
    property SituacaoProcCod: Integer    read fSituacaoProcCod;
    property SituacaoProcStr: AnsiString read fSituacaoProcStr;
    property Recibo         : AnsiString read fRecibo;
    property Tipo           : AnsiString read fTipo;
    property Mensagem       : AnsiString read fMensagem;
    property DataRef        : AnsiString read fDataRef;
  end;

implementation

{ TRetEnvBlocoX }

constructor TretEnvBlocoX.Create;
begin
  inherited;
  fLeitor := TLeitor.Create;
end;

destructor TretEnvBlocoX.Destroy;
begin
  fLeitor.Free;
  inherited;
end;

function TretEnvBlocoX.LerXml: Boolean;
begin
  Result := False;

  try
    Leitor.Grupo := Leitor.Arquivo;
    if (Leitor.rExtrai(1, 'Resposta') <> '') then
    begin
      fVersao          := Leitor.rAtributo('Versao');
      fSituacaoProcCod := Leitor.rCampo(tcInt, 'SituacaoProcessamentoCodigo');
      fSituacaoProcStr := Leitor.rCampo(tcStr, 'SituacaoProcessamentoDescricao');
      fRecibo          := Leitor.rCampo(tcStr, 'Recibo');
      fTipo            := Leitor.rCampo(tcStr, 'Tipo');
      fMensagem        := Leitor.rCampo(tcStr, 'Mensagem');
      fDataRef         := Leitor.rCampo(tcStr, 'DataReferencia');
      
      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

