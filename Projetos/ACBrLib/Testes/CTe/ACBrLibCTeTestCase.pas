{******************************************************************************}
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

unit ACBrLibCTeTestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry;

type

  { TTestACBrCTeLib }

  TTestACBrCTeLib = class(TTestCase)
  published
    procedure Test_CTe_Inicializar_Com_DiretorioInvalido;
    procedure Test_CTe_Inicializar;
    procedure Test_CTe_Inicializar_Ja_Inicializado;
    procedure Test_CTe_Finalizar;
    procedure Test_CTe_Finalizar_Ja_Finalizado;
    procedure Test_CTe_ConfigLerValor;
    procedure Test_CTe_ConfigGravarValor;

    procedure Test_CTe_StatusServico;

    procedure Test_CTe_LimparLista;
    procedure Test_CTe_CarregarXML;
    procedure Test_CTe_Imprimir;
    procedure Test_CTe_ImprimirPDF;

    procedure Test_CTe_CarregarINI;
    procedure Test_CTe_Assinar;
    procedure Test_CTe_Validar;
    procedure Test_CTe_ValidarRegrasdeNegocios;
    procedure Test_CTe_VerificarAssinatura;

    procedure Test_CTe_Enviar;
    procedure Test_CTe_Consultar;
    procedure Test_CTe_Cancelar;
    procedure Test_CTe_EnviarEmail;

    procedure Test_CTe_Inutilizar;
    procedure Test_CTe_ImprimirInutilizacao;
    procedure Test_CTe_ImprimirInutilizacaoPDF;

    procedure Test_CTe_EnviarEvento;
    procedure Test_CTe_EnviarEmailEvento;
    procedure Test_CTe_ImprimirEvento;
    procedure Test_CTe_ImprimirEventoPDF;

    procedure Test_CTe_DistribuicaoDFePorUltNSU;
    procedure Test_CTe_DistribuicaoDFePorNSU;
    procedure Test_CTe_DistribuicaoDFePorChave;
  end;

implementation

uses
  ACBrLibCTeStaticImport, ACBrLibCTeConsts, ACBrLibConsts;

procedure TTestACBrCTeLib.Test_CTe_Inicializar_Com_DiretorioInvalido;
begin
  AssertEquals(ErrDiretorioNaoExiste, CTe_Inicializar('C:\NAOEXISTE\ACBrLib.ini',''));
end;

procedure TTestACBrCTeLib.Test_CTe_Inicializar;
begin
  AssertEquals(ErrOk, CTe_Inicializar('',''));
end;

procedure TTestACBrCTeLib.Test_CTe_Inicializar_Ja_Inicializado;
begin
  AssertEquals(ErrOk, CTe_Inicializar('',''));
end;

procedure TTestACBrCTeLib.Test_CTe_Finalizar;
begin
  AssertEquals(ErrOk, CTe_Finalizar());
end;

procedure TTestACBrCTeLib.Test_CTe_Finalizar_Ja_Finalizado;
begin
  AssertEquals(ErrOk, CTe_Finalizar());
end;

procedure TTestACBrCTeLib.Test_CTe_ConfigLerValor;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Obtendo o Tamanho //
  Bufflen := 255;
  AStr := Space(Bufflen);
  //AssertEquals(ErrOk, CTe_ConfigLerValor(CSessaoVersao, CLibCTeNome, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  //AssertEquals(CLibCTeVersao, AStr);
end;

procedure TTestACBrCTeLib.Test_CTe_ConfigGravarValor;
var
  Bufflen: Integer;
  AStr: String;
begin
  // Gravando o valor
  AssertEquals('Erro ao Mudar configuração', ErrOk, CTe_ConfigGravarValor(CSessaoPrincipal, CChaveLogNivel, '4'));

  // Checando se o valor foi atualizado //
  Bufflen := 255;
  AStr := Space(Bufflen);
  AssertEquals(ErrOk, CTe_ConfigLerValor(CSessaoPrincipal, CChaveLogNivel, PChar(AStr), Bufflen));
  AStr := copy(AStr,1,Bufflen);
  AssertEquals('Erro ao Mudar configuração', '4', AStr);
end;

procedure TTestACBrCTeLib.Test_CTe_StatusServico;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando a consulta ao Status de Serviço
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao consultar ao Status de Serviço', ErrOk, CTe_StatusServico(Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_LimparLista;
begin
  // Iniciando a Limpeza da Lista de CT-e
  AssertEquals('Erro ao limpar a lista de CT-e', ErrOk, CTe_LimparLista);
end;

procedure TTestACBrCTeLib.Test_CTe_CarregarXML;
begin
  // Iniciando o Carregamento do XML do CT-e
  AssertEquals('Erro ao carregar o XML do CT-e', ErrOk,
   CTe_CarregarXML('C:\ERP\XML\201808\CTe\35180804550110000188570010000009491283342822-cte.xml'));
end;

procedure TTestACBrCTeLib.Test_CTe_Imprimir;
begin
  // Iniciando a Impressão do DACTE
  AssertEquals('Erro ao Imprimir o DACTE', ErrOk, CTe_Imprimir('', 1, '', ''));
end;

procedure TTestACBrCTeLib.Test_CTe_ImprimirPDF;
begin
  // Iniciando a geração do PDF do DACTE
  AssertEquals('Erro ao gerar o PDF do DACTE', ErrOk, CTe_ImprimirPDF);
end;

procedure TTestACBrCTeLib.Test_CTe_CarregarINI;
begin
  Test_CTe_LimparLista;

  // Iniciando o Carregamento do INI do CT-e
  AssertEquals('Erro ao carregar o INI do CT-e', ErrOk,
   CTe_CarregarINI('C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\Modelo-CTe.ini'));
end;

procedure TTestACBrCTeLib.Test_CTe_Assinar;
begin
  // Iniciando a Assinatura
  AssertEquals('Erro ao Assinar', ErrOk, CTe_Assinar);
end;

procedure TTestACBrCTeLib.Test_CTe_Validar;
begin
  // Iniciando a Validação
  AssertEquals('Erro ao Validar', ErrOk, CTe_Validar);
end;

procedure TTestACBrCTeLib.Test_CTe_ValidarRegrasdeNegocios;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando a Validação de Regras de Negócios
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Validar regras de negócio', ErrOk,
    CTe_ValidarRegrasdeNegocios(Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_VerificarAssinatura;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando a Verificação de Assinatura
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Verificar assinatura', ErrOk,
    CTe_VerificarAssinatura(Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_Enviar;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando o Envio do Lote de CT-e
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Enviar Lote de CT-e', ErrOk,
    CTe_Enviar(1, True, Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_Consultar;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  Test_CTe_LimparLista;

  // Iniciando a Consulta
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Consultar o CT-e', ErrOk,
    CTe_Consultar('C:\ERP\XML\201808\CTe\35180804550110000188570010000009491283342822-cte.xml', Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_Cancelar;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  Test_CTe_LimparLista;

  // Iniciando o Cancelamento
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Cancelar o CT-e', ErrOk,
    CTe_Cancelar('35180804550110000188570010000009491283342822',
                 'Desacordo comercial', '04550110000188', 1, Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_EnviarEmail;
begin
  //a
end;

procedure TTestACBrCTeLib.Test_CTe_Inutilizar;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  AssertEquals('Erro ao Inicializar', ErrOk, CTE_Inicializar('', ''));

  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Validar', ErrOk, CTE_Inutilizar('12061411000176', 'teste de homologacao', 2019, 67, 1, 1, 1, Resposta, Tamanho));
  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');

  AssertEquals('Erro ao Finalizar', ErrOk, CTE_Finalizar);
end;

procedure TTestACBrCTeLib.Test_CTe_ImprimirInutilizacao;
begin
  // Iniciando a Impressão da Inutilização

  AssertEquals('Erro ao imprimir a Inutilização', ErrOk,
    CTe_ImprimirInutilizacao('C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\1795714200014457017000000009000000010-ProcInutCTe.xml'));
end;

procedure TTestACBrCTeLib.Test_CTe_ImprimirInutilizacaoPDF;
begin
  // Iniciando a Geração do PDF da Inutilização

  AssertEquals('Erro ao gerar o PDF da Inutilização', ErrOk,
    CTe_ImprimirInutilizacaoPDF('C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\1795714200014457017000000009000000010-ProcInutCTe.xml'));
end;

procedure TTestACBrCTeLib.Test_CTe_EnviarEvento;
begin
  //a
end;

procedure TTestACBrCTeLib.Test_CTe_EnviarEmailEvento;
var
  Path, ArqCTe, ArqEvento: String;
begin
  // Iniciando o envio do evento por email
  Path := 'C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\';
  ArqCTe := Path + '28140417957142000144570170000000311556600342-cte.xml';
  ArqEvento := Path + '2814041795714200014457017000000031155660034211011001-procEventoCTe.xml';

  AssertEquals('Erro ao enviar email do evento', ErrOk,
    CTe_EnviarEmailEvento('italo.jurisato@gmail.com', PChar(ArqEvento),
      PChar(ArqCTe), True, 'Evento', '', '',
      'Teste de envio de evento por email.'));
end;

procedure TTestACBrCTeLib.Test_CTe_ImprimirEvento;
var
  Path, ArqCTe, ArqEvento: String;
begin
  // Iniciando a Impressão do Evento
  Path := 'C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\';
  ArqCTe := Path + '28140417957142000144570170000000311556600342-cte.xml';
  ArqEvento := Path + '2814041795714200014457017000000031155660034211011001-procEventoCTe.xml';

  AssertEquals('Erro ao imprimir o evento', ErrOk,
    CTe_ImprimirEvento(PChar(ArqCTe), PChar(ArqEvento)));
end;

procedure TTestACBrCTeLib.Test_CTe_ImprimirEventoPDF;
var
  Path, ArqCTe, ArqEvento: String;
begin
  // Iniciando a geração do PDF do Evento
  Path := 'C:\ACBr\trunk2\Projetos\ACBrLib\Testes\CTe\bin\';
  ArqCTe := Path + '28140417957142000144570170000000311556600342-cte.xml';
  ArqEvento := Path + '2814041795714200014457017000000031155660034211011001-procEventoCTe.xml';

  AssertEquals('Erro ao gerar o PDF do evento', ErrOk,
    CTe_ImprimirEventoPDF(PChar(ArqCTe), PChar(ArqEvento)));
end;

procedure TTestACBrCTeLib.Test_CTe_DistribuicaoDFePorUltNSU;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando a Consulta no WebServices DistribuicaoDFe
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Consultar o DistribuicaoDFePorUltNSU', ErrOk,
    CTe_DistribuicaoDFePorUltNSU(35, '04550110000188', '0', Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_DistribuicaoDFePorNSU;
var
  Resposta: PChar;
  Tamanho: Longint;
begin
  // Iniciando a Consulta no WebServices DistribuicaoDFe
  Resposta := '';
  Tamanho := 0;

  AssertEquals('Erro ao Consultar o DistribuicaoDFePorNSU', ErrOk,
    CTe_DistribuicaoDFePorNSU(35, '04550110000188', '100', Resposta, Tamanho));

  AssertEquals('Resposta= ' + AnsiString(Resposta), '', '');
  AssertEquals('Tamanho= ' + IntToStr(Tamanho), '', '');
end;

procedure TTestACBrCTeLib.Test_CTe_DistribuicaoDFePorChave;
begin
  // A SEFAZ ainda não disponibilizou a consulta pela chave no webservice
  // DistribuicaoDFe
end;

initialization
  RegisterTest(TTestACBrCTeLib);

end.

