{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrNFSeXConsts;

interface

uses
  SysUtils;

const
  DSC_NUMRPS = 'Numero do RPS';
  DSC_SERIERPS = 'Serie do RPS';
  DSC_TIPORPS = 'Tipo do RPS';
  DSC_NUMRPSSUB = 'Numero do RPS Substituido';
  DSC_SERIERPSSUB = 'Serie do RPS Substituido';
  DSC_TIPORPSSUB = 'Tipo do RPS Substituido';
  DSC_VSERVICO = 'Valor do Servi�o';
  DSC_OUTRASRETENCOES = 'Valor de Outras Reten��es';
  DSC_VNFSE = 'Valor Liquido da NFS-e';
  DSC_DISCR = 'Discrimina��o do Servi�o';
  DSC_VUNIT = 'Valor Unit�rio';
  DSC_MUNINCI = 'Municipio de Incidencia';
  DSC_INDRESPRET = 'Indicador de Respons�vel pela Reten��o';
  DSC_COBRA = 'C�digo da Obra';
  DSC_ART = 'Arte';
  DSC_QPARC = 'Quantidade de Parcelas';
  DSC_NPARC = 'Numero da Parcela';
  DSC_VPARC = 'Valor da Parcela';
  DSC_INDNATOP = 'Indicador de Natureza de Opera��o';
  DSC_INDOPSN = 'Indicador do Optante pelo Simples Nacional';
  DSC_INDINCCULT = 'Indicador de Incentivador Cultural';
  DSC_INDSTATUS = 'Indicador de Status';
  DSC_OUTRASINF = 'Outras Informa��es';
  DSC_SENHA = 'Senha';
  DSC_FRASESECRETA = 'Frase Secreta';
  DSC_USUARIO = 'Usuario';
  DSC_ASSINATURA = 'Assinatura';
  DSC_DDD = 'DDD';
  DSC_TPTELEFONE = 'Tipo Telefone';
  DSC_VTOTREC = 'Valor Total Recebido';
  DSC_CODQRT = 'Codigo Interno do Quarto';
  DSC_QTDHOSPDS = 'Quantidade de Hospedes';
  DSC_CHECKIN = 'Chechin';
  DSC_QTDDIAR = 'Quantidade de Diarias';
  DSC_VDIAR = 'Valor da Diaria';
  DSC_INSCMUN = 'Inscri��o Municipal';

  // C�digos e Descri��es das mensagens
  Cod001 = 'X001';
  Desc001 = 'Servi�o n�o implementado pelo Provedor.';
  Cod002 = 'X002';
  Desc002 = 'Nenhum RPS adicionado ao componente.';
  Cod003 = 'X003';
  Desc003 = 'Conjunto de RPS transmitidos (m�ximo de xxx RPS) excedido. Quantidade atual: yyy';

  Cod101 = 'X101';
  Desc101 = 'N�mero do Protocolo n�o informado.';
  Cod102 = 'X102';
  Desc102 = 'N�mero do RPS n�o informado.';
  Cod103 = 'X103';
  Desc103 = 'S�rie do Rps n�o informada.';
  Cod104 = 'X104';
  Desc104 = 'Tipo do Rps n�o informado.';
  Cod105 = 'X105';
  Desc105 = 'N�mero Inicial da NFSe n�o informado.';
  Cod106 = 'X106';
  Desc106 = 'N�mero Final da NFSe n�o informado.';
  Cod107 = 'X107';
  Desc107 = 'Pedido de Cancelamento n�o informado.';
  Cod108 = 'X108';
  Desc108 = 'N�mero da NFSe n�o informado.';
  Cod109 = 'X109';
  Desc109 = 'C�digo de Cancelamento n�o informado.';
  Cod110 = 'X110';
  Desc110 = 'Motivo do Cancelamento n�o informado.';
  Cod111 = 'X111';
  Desc111 =	'N�mero do Lote n�o informado.';
  Cod112 = 'X112';
  Desc112 = 'S�rie da NFSe n�o informada.';
  Cod113 = 'X113';
  Desc113 = 'Valor da NFSe n�o informado.';
  Cod114 = 'X114';
  Desc114	= 'Tipo da NFSe n�o informado.';
  Cod115 = 'X115';
  Desc115	= 'Data Inicial n�o informada.';
  Cod116 = 'X116';
  Desc116 =	'Data Final n�o informada.';
  Cod117 = 'X117';
  Desc117 = 'C�digo de Verifica��o/Valida��o n�o informado.';
  Cod118 = 'X118';
  Desc118	= 'Chave da NFSe n�o informada.';

  Cod201 = 'X201';
  Desc201 = 'WebService retornou um XML vazio.';
  Cod202 = 'X202';
  Desc202 = 'Lista de NFSe n�o encontrada! (ListaNfse)';
  Cod203 = 'X203';
  Desc203 = 'N�o foi retornado nenhuma NFSe.';
  Cod204 = 'X204';
  Desc204 = 'Confirma��o do Cancelamento n�o encontrada.';
  Cod205 = 'X205';
  Desc205 = 'Retorno da Substitui��o n�o encontrada.';
  Cod206 = 'X206';
  Desc206 = 'Nfse Substituida n�o encontrada.';
  Cod207 = 'X207';
  Desc207 = 'Nfse Substituidora n�o encontrada.';
  Cod208 = 'X208';
  Desc208	= 'N�o foi retornado nenhum Rps.';

  Cod999 = 'X999';

implementation

end.

