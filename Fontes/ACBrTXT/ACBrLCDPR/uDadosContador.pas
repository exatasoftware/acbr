{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Willian H�bner                                  }
{							   Elton Barbosa -EMBarbosa                        }
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

unit uDadosContador;

interface

type
  TContador = Class
  private
    FFONE: String;
    FEMAIL: String;
    FIDENT_NOME: String;
    FIND_CRC: String;
    FIDENT_CPF_CNPJ: String;
    procedure SetEMAIL(const Value: String);
    procedure SetFONE(const Value: String);
    procedure SetIDENT_CPF_CNPJ(const Value: String);
    procedure SetIDENT_NOME(const Value: String);
    procedure SetIND_CRC(const Value: String);
  public
    property IDENT_NOME : String read FIDENT_NOME write SetIDENT_NOME;
    property IDENT_CPF_CNPJ : String read FIDENT_CPF_CNPJ write SetIDENT_CPF_CNPJ;
    property IND_CRC : String read FIND_CRC write SetIND_CRC;
    property EMAIL : String read FEMAIL write SetEMAIL;
    property FONE : String read FFONE write SetFONE;
  End;

implementation

uses
  ACBrUtil;

{ TContador }

procedure TContador.SetEMAIL(const Value: String);
begin
  FEMAIL := Value;
end;

procedure TContador.SetFONE(const Value: String);
begin
  FFONE := OnlyNumber(Value);
end;

procedure TContador.SetIDENT_CPF_CNPJ(const Value: String);
begin
  FIDENT_CPF_CNPJ := Value;
end;

procedure TContador.SetIDENT_NOME(const Value: String);
begin
  FIDENT_NOME := Value;
end;

procedure TContador.SetIND_CRC(const Value: String);
begin
  FIND_CRC := Value;
end;

end.
