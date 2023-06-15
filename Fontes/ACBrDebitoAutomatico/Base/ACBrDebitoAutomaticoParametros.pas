{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit ACBrDebitoAutomaticoParametros;

interface

uses
  Classes, SysUtils,
  ACBrDebitoAutomaticoConversao;

type

  { TConta }
{
  TConta = class
  private
    FAgenciaCodigo: Integer;
    FAgenciaDV: string;
    FContaNumero: Int64;
    FContaDV: string;
    FDV: string;
    FTipoConta: Integer;
  public
    property AgenciaCodigo: Integer read FAgenciaCodigo write FAgenciaCodigo;
    property AgenciaDV: string read FAgenciaDV write FAgenciaDV;
    property ContaNumero: Int64 read FContaNumero write FContaNumero;
    property ContaDV: string read FContaDV write FContaDV;
    property DV: string read FDV write FDV;
    property TipoConta: Integer read FTipoConta write FTipoConta;
  end;
}
  { TEndereco }
{
  TEndereco = class
  private
    FLogradouro: string;
    FNumero: string;
    FComplemento: string;
    FCidade: string;
    FCEP: Integer;
    FEstado: string;
  public
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Cidade: string read FCidade write FCidade;
    property CEP: Integer read FCEP write FCEP;
    property Estado: string read FEstado write FEstado;
  end;
}
  { TEmpresa }
{
  TEmpresa = class
  private
//    FTipoInscricao: TTipoInscricao;
    FNumeroInscricao: string;
    FConvenio: string;
    FNome: string;
    FConta: TConta;
    FEndereco: TEndereco;
  public
    Constructor Create;
    destructor Destroy; override;

//    property TipoInscricao: TTipoInscricao read FTipoInscricao write FTipoInscricao;
    property NumeroInscricao: string read FNumeroInscricao write FNumeroInscricao;
    property Convenio: string read FConvenio write FConvenio;
    property Nome: string read FNome write FNome;

    property Conta: TConta read FConta write FConta;
    property Endereco: TEndereco read FEndereco write FEndereco;
  end;
}
  { TConfigGeral }

  TConfigGeral = class
  private
//    FEmpresa: TEmpresa;
//    FUsarDadosConfig: Boolean;
    FCNPJEmpresa: string;
  public
    constructor Create;
    destructor Destroy; override;

//    property Empresa: TEmpresa read FEmpresa write FEmpresa;
//    property UsarDadosConfig: Boolean read FUsarDadosConfig write FUsarDadosConfig;
    property CNPJEmpresa: string read FCNPJEmpresa write FCNPJEmpresa;
  end;

implementation

{ TConfigGeral }

constructor TConfigGeral.Create;
begin
  inherited Create;

//  FEmpresa := TEmpresa.Create;
end;

destructor TConfigGeral.Destroy;
begin
//  FEmpresa.Free;

  inherited Destroy;
end;

{ TEmpresa }
{
constructor TEmpresa.Create;
begin
  inherited Create;

  FConta := TConta.Create;
  FEndereco := TEndereco.Create;
end;

destructor TEmpresa.Destroy;
begin
  FConta.Free;
  FEndereco.Free;

  inherited Destroy;
end;
}
end.
