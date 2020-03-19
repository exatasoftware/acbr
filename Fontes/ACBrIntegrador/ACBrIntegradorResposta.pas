{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andr� Ferreira de Moraes                        }
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
unit ACBrIntegradorResposta;

interface

uses
  Classes, SysUtils, pcnLeitor, pcnConversao;

type

{$M+}
  { TIntegradorResposta }

  TIntegradorResposta = class
  private
    FLeitor: TLeitor;
    FIdentificador: Integer;
    FCodigo: String;
    FValor: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;

    procedure LerResposta(const XML: String);
  published
    property Identificador: Integer read FIdentificador write FIdentificador;
    property Codigo: String read FCodigo write FCodigo;
    property Valor: String read FValor write FValor;
  end;

{$M-}

implementation

{ TIntegradorResposta }

constructor TIntegradorResposta.Create;
begin
  FLeitor := TLeitor.Create;
end;

destructor TIntegradorResposta.Destroy;
begin
  FLeitor.Free;
  inherited Destroy;
end;

procedure TIntegradorResposta.Clear;
begin
  FIdentificador := 0;
  FCodigo        := '';
  FValor         := '';
end;

procedure TIntegradorResposta.LerResposta(const XML: String);
begin
  FLeitor.Arquivo := XML;

  if FLeitor.rExtrai(1, 'Integrador') <> '' then
  begin
    if FLeitor.rExtrai(2, 'Identificador') <> '' then
      FIdentificador := FLeitor.rCampo(tcInt, 'valor');

    if FLeitor.rExtrai(2, 'IntegradorResposta') <> '' then
    begin
      FCodigo := FLeitor.rCampo(tcStr, 'Codigo');
      FValor  := FLeitor.rCampo(tcStr, 'Valor');
    end;
  end ;
end;

end.

