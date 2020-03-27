﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
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
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

unit ACBrLibCHQTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

const
  CLibCHQNome = 'ACBrLibCHQ';

type

  { TTestACBrCHQLib }

  TTestACBrCHQLib = class(TTestCase)
  published
    procedure Test_CHQ_Inicializar_Com_DiretorioInvalido;
    procedure Test_CHQ_Inicializar;
    procedure Test_CHQ_Inicializar_Ja_Inicializado;
    procedure Test_CHQ_Finalizar;
    procedure Test_CHQ_Finalizar_Ja_Finalizado;
    procedure Test_CHQ_Nome_Obtendo_LenBuffer;
    procedure Test_CHQ_Nome_Lendo_Buffer_Tamanho_Identico;
    procedure Test_CHQ_Nome_Lendo_Buffer_Tamanho_Maior;
    procedure Test_CHQ_Nome_Lendo_Buffer_Tamanho_Menor;
    procedure Test_CHQ_Versao;
    procedure Test_CHQ_ConfigLerValor;
    procedure Test_CHQ_ConfigGravarValor;

    procedure Test_CHQ_Ativar;
    procedure Test_CHQ_TravarCheque;

    procedure Test_CHQ_SetBanco;
    procedure Test_CHQ_SetValor;
    procedure Test_CHQ_SetData;
    procedure Test_CHQ_SetCidade;
    procedure Test_CHQ_SetFavorecido;
    procedure Test_CHQ_SetObservacao;
    procedure Test_CHQ_SetBomPara;

    procedure Test_CHQ_ImprimirLinha;
    procedure Test_CHQ_ImprimirVerso;

    procedure Test_CHQ_DestravarCheque;
    procedure Test_CHQ_ImprimirCheque;
    procedure Test_CHQ_Desativar;
  end;

implementation

uses
  ACBrLibCHQStaticImport, ACBrLibCHQConsts, ACBrLibConsts, ACBrUtil;

procedure TTestACBrCHQLib.Test_CHQ_Inicializar_Com_DiretorioInvalido;
begin
  AssertEquals(ErrDiretorioNaoExiste, CHQ_Inicializar('C:\NAOEXISTE\ACBrLib.ini',''));
end;

procedure TTestACBrCHQLib.Test_CHQ_Inicializar;
begin
  AssertEquals(ErrOk, CHQ_Inicializar('',''));
end;

procedure TTestACBrCHQLib.Test_CHQ_Inicializar_Ja_Inicializado;
begin
  AssertEquals(ErrOk, CHQ_Inicializar('',''));
end;

procedure TTestACBrCHQLib.Test_CHQ_Finalizar;
begin
  AssertEquals(ErrOk, CHQ_Finalizar());
end;

procedure TTestACBrCHQLib.Test_CHQ_Finalizar_Ja_Finalizado;
begin
  AssertEquals(ErrOk, CHQ_Finalizar());
end;

procedure TTestACBrCHQLib.Test_CHQ_Nome_Obtendo_LenBuffer;
var
  Bufflen: Integer;
begin
  // Obtendo o Tamanho //
  Bufflen := 0;
  AssertEquals(ErrOk, CHQ_Nome(Nil, Bufflen));
  AssertEquals(Length(CLibCHQNome), Bufflen);
end;

procedure TTestACBrCHQLib.Test_CHQ_Nome_Lendo_Buffer_Tamanho_Identico;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := Length(CLibCHQNome);
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_Nome(PChar(AStr), Bufflen));
  AssertEquals(Length(CLibCHQNome), Bufflen);
  AssertEquals(CLibCHQNome, AStr);
end;

procedure TTestACBrCHQLib.Test_CHQ_Nome_Lendo_Buffer_Tamanho_Maior;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := Length(CLibCHQNome)*2;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_Nome(PChar(AStr), Bufflen));
  AStr := copy(AStr, 1, Bufflen);
  AssertEquals(Length(CLibCHQNome), Bufflen);
  AssertEquals(CLibCHQNome, AStr);
end;

procedure TTestACBrCHQLib.Test_CHQ_Nome_Lendo_Buffer_Tamanho_Menor;
var
  AStr: String;
  Bufflen: Integer;
begin
  Bufflen := 4;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_Nome(PChar(AStr), Bufflen));
  AssertEquals(4, Bufflen);
  AssertEquals(copy(CLibCHQNome,1,4), AStr);
end;

procedure TTestACBrCHQLib.Test_CHQ_Versao;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  Bufflen := 0;
  AssertEquals(ErrOk, CHQ_Versao(Nil, Bufflen));
  Assert(Bufflen > 0);

  // Lendo a resposta //
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_Versao(PChar(AStr), Bufflen));
  Assert(Bufflen > 0);
  Assert(AStr <> '');
end;

procedure TTestACBrCHQLib.Test_CHQ_ConfigLerValor;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_ConfigLerValor(CSessaoVersao, CACBrLib, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals(CACBrLibVersaoConfig, AStr);
end;

procedure TTestACBrCHQLib.Test_CHQ_ConfigGravarValor;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Gravando o valor
  AssertEquals('Erro ao Mudar configuração', ErrOk, CHQ_ConfigGravarValor(CSessaoPrincipal, CChaveLogNivel, '4'));

  // Checando se o valor foi atualizado //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CHQ_ConfigLerValor(CSessaoPrincipal, CChaveLogNivel, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals('Erro ao Mudar configuração', '4', AStr);
end;

procedure TTestACBrCHQLib.Test_CHQ_Ativar;
begin
  // Ativando o Cheque
  AssertEquals('Erro ao Ativar o Cheque', ErrOk, CHQ_Ativar);
end;

procedure TTestACBrCHQLib.Test_CHQ_Desativar;
begin
  // Desativando o Cheque
  AssertEquals('Erro ao Desativar o Cheque', ErrOk, CHQ_Desativar);
end;

procedure TTestACBrCHQLib.Test_CHQ_TravarCheque;
begin
  // Iniciando o travamento do Cheque
  AssertEquals('Erro ao travar o Cheque', ErrOk, CHQ_TravarCheque);
end;

procedure TTestACBrCHQLib.Test_CHQ_DestravarCheque;
begin
  // Iniciando o Destravamento do Cheque
  AssertEquals('Erro ao destravar o Cheque', ErrOk, CHQ_DestravarCheque);
end;

procedure TTestACBrCHQLib.Test_CHQ_SetBanco;
begin
  // Definindo o Banco (001 - 999)
  AssertEquals('Erro ao definir o Banco', ErrOk, CHQ_SetBanco('001'));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetValor;
begin
  // Definindo o Valor
  AssertEquals('Erro ao definir o valor', ErrOk, CHQ_SetValor(500));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetData;
begin
  // Definindo a data
  AssertEquals('Erro ao definir a data', ErrOk, CHQ_SetData(StrToDateTime('23/08/2018')));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetCidade;
begin
  // Definindo a Cidade
  AssertEquals('Erro ao definir a cidade', ErrOk, CHQ_SetCidade('Araraquara'));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetFavorecido;
begin
  // Definindo o Favorecido
  AssertEquals('Erro ao definir o favorecido', ErrOk, CHQ_SetFavorecido('Empresa XYZ'));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetObservacao;
begin
  // Definindo uma observação
  AssertEquals('Erro ao definir uma observação', ErrOk, CHQ_SetObservacao(''));
end;

procedure TTestACBrCHQLib.Test_CHQ_SetBomPara;
begin
  // Definindo a data (BomPara)
  AssertEquals('Erro ao definir a data (BomPara)', ErrOk, CHQ_SetBomPara(StrToDateTime('10/09/2018')));
end;

procedure TTestACBrCHQLib.Test_CHQ_ImprimirLinha;
begin
  // Definindo uma linha a ser impressa
  AssertEquals('Erro ao definir a linha a ser impressa', ErrOk,
                                     CHQ_ImprimirLinha('Linha a ser impressa'));
end;

procedure TTestACBrCHQLib.Test_CHQ_ImprimirVerso;
begin
  // Definindo as linhas do verso a serem impressa
  AssertEquals('Erro ao definir as linhas do verso', ErrOk,
                                     CHQ_ImprimirVerso('Linha1|Linha2|Linha3'));
end;

procedure TTestACBrCHQLib.Test_CHQ_ImprimirCheque;
begin
  // Executando a impressão do cheque
  AssertEquals('Erro ao imprimir o cheque', ErrOk,
                                     CHQ_ImprimirCheque);
end;

initialization
  RegisterTest(TTestACBrCHQLib);

end.

