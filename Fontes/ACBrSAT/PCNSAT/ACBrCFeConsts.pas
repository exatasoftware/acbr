{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrCFeConsts;

interface

resourcestring
  DSC_INFADPROD = 'Informa��es adicionais do Produto';
  DSC_NITEM = 'Numero do item';
  DSC_CPROD = 'C�digo do produto ou servi�o';
  DSC_CEAN = 'C�digo de Barra do Item';
  DSC_XPROD = 'Descri��o do Produto ou Servi�o';
  DSC_NCM = 'C�digo NCM';
  DSC_CEST = 'C�digo Identificador da Substitu��o Tribut�ria';
  DSC_UCOM = 'Unidade Comercial';
  DSC_QCOM = 'Quantidade Comercial';
  DSC_VUNCOM = 'Valor Unit�rio de Comercializa��o';
  DSC_VPROD = 'Valor Total Bruto dos Produtos ou Servi�os';
  DSC_NITEMPED = 'Item do Pedido de Compra da DI � adi��o';
  DSC_VDESC = 'Valor do desconto';
  DSC_VOUTRO = 'Outras Despesas Acess�rias';
  DSC_ORIG = 'Origem da mercadoria';
  DSC_PICMS = 'Al�quota do imposto';
  DSC_VICMS = 'Valor do ICMS';
  DSC_CSOSN = 'C�digo de Situa��o da Opera��o � Simples Nacional';
  DSC_VBC = 'Valor da BC do ICMS';
  DSC_PPIS = 'Al�quota do PIS (em percentual)';
  DSC_VPIS = 'Valor do PIS';
  DSC_QBCPROD = 'BC da CIDE';
  DSC_VALIQPROD = 'Valor da al�quota (em reais)';
  DSC_PISOUTR = 'Grupo PIS outras opera��es';
  DSC_PCOFINS = 'Al�quota da COFINS (em percentual)';
  DSC_VCOFINS = 'Valor do COFINS';
  DSC_VBCISS = 'Valor da Base de C�lculo do ISSQN';
  DSC_VALIQ = 'Al�quota';
  DSC_VISSQN = 'Valor do Imposto sobre Servi�o de Qualquer Natureza';
  DSC_CMUNFG = 'C�digo do Munic�pio FG';
  DSC_CLISTSERV = 'Lista Presta��o de Servi�os';
  DSC_VISS = 'Valor do Imposto sobre Servi�o';
  DSC_CAUT = 'N�mero da Autoriza��o';

  DSC_VDESCSUBTOT = 'Valor de Desconto sobre Subtotal';
  DSC_VACRESSUBTOT = 'Valor de Acr�scimo sobre Subtotal';
  DSC_VPISST = 'Valor do PIS ST';
  DSC_VCOFINSST = 'Valor do COFINS ST';
  DSC_VCFE = 'Valor Total do CF-e';
  DSC_VCFELEI12741 = 'Valor aproximado dos tributos do CFe-SAT � Lei 12741/12.';
  DSC_VDEDUCISS = 'Valor das dedu��es para ISSQN';
  DSC_CSERVTRIBMUN = 'Codigo de tributa��o pelo ISSQN do municipio';
  DSC_CNATOP = 'Natureza da Opera��o de ISSQN';
  DSC_INDINCFISC = 'Indicador de Incentivo Fiscal do ISSQN';
  DSC_COFINSST = 'Grupo de COFINS Substitui��o Tribut�ria';
  DSC_REGTRIB = 'C�digo de Regime Tribut�rio';
  DSC_REGISSQN = 'Regime Especial de Tributa��o do ISSQN';
  DSC_RATISSQN = 'Indicador de rateio do Desconto sobre subtotal entre itens sujeitos � tributa��o pelo ISSQN.';
  DSC_NCFE = 'N�mero do Cupom Fiscal Eletronico';
  DSC_HEMI = 'Hora de emiss�o';
  DSC_SIGNAC = 'Assinatura do Aplicativo Comercial';
  DSC_MP = 'Grupo de informa��es sobre Pagamento do CFe';
  DSC_CMP = 'C�digo do Meio de Pagamento';
  DSC_VMP = 'Valor do Meio de Pagamento';
  DSC_CADMC = 'Credenciadora de cart�o de d�bito ou cr�dito';
  DSC_VTROCO = 'Valor do troco';
  DSC_VITEM = 'Valor l�quido do Item';
  DSC_VRATDESC = 'Rateio do desconto sobre subtotal';
  DSC_VRATACR = 'Rateio do acr�scimo sobre subtotal';
  DSC_NUMEROCAIXA = 'N�mero do Caixa ao qual o SAT est� conectado';
  DSC_VITEM12741 = 'Valor aproximado dos tributos do Produto ou servi�o � Lei 12741/12';
  DSC_NSERIESAT = 'N�mero de s�rie do equipamento SAT';
  DSC_DHINICIAL = 'Data e hora incial';
  DSC_DHFINAL = 'Data e Hora Final';

implementation

end.

