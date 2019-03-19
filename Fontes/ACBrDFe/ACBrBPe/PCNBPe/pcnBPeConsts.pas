////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar BPe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml do BPe          //
//                                                                            //
//        site: www.projetocooperar.org                                       //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{*******************************************************************************
|* Historico
|*
|* 20/06/2017: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnBPeConsts;

interface

uses
  SysUtils;

const
  DSC_CHBPE = 'Chave do Bilhete de Passagem Eletr�nico';
  DSC_INFQRCODEBPE = 'QR-Code do BP-e';
  DSC_BOARDPASSBPE = 'Boarding Pass do BP-e';
  DSC_MODALBPE = 'Modal do BP-e';
  DSC_TPBPE = 'Tipo de BP-e';
  DSC_INDPRESBPE = 'Indicador de Presen�a';
  DSC_UFINIBPE = 'UF de Inicio';
  DSC_CMUNINIBPE = 'C�digo do Municipio de Inicio';
  DSC_UFFIMBPE = 'UF de Fim';
  DSC_CMUNFIMBPE = 'C�digo do Municipio de Fim';
  DSC_CRTBPE = 'C�digo do Regime Tribut�rio';
  DSC_TAR = 'Termo de Autoriza��o de Servi�o Regular';
  DSC_IDESTRBPE = 'Indicador de Comprador Estrangeiro';
  DSC_TPSUB = 'Tipo de Substitui��o';
  DSC_CLOCORIG = 'C�digo do Local de Origem';
  DSC_XLOCORIG = 'Descri��o do Local de Origem';
  DSC_CLOCDEST = 'C�digo do Local de Destino';
  DSC_XLOCDEST = 'Descri��o do Local de Destino';
  DSC_DHEMB = 'Data e Hora de Embarque';
  DSC_DHVALIDADE = 'Data e Hora de Validade';
  DSC_XNOMEPASS = 'Nome do Passageiro';
  DSC_TPDOC = 'Tipo de Documento';
  DSC_NDOC = 'Numero do Documento';
  DSC_DNASC = 'Data de Nascimento';
  DSC_CPERCURSO = 'C�digo do Percurso';
  DSC_XPERCURSO = 'Descri��o do Percurso';
  DSC_TPVIAGEM = 'Tipo de Viagem';
  DSC_TPSERVICO = 'Tipo de Servi�o';
  DSC_TPACOMODACAO = 'Tipo de Acomoda��o';
  DSC_TPTRECHO = 'Tipo de Trecho';
  DSC_DHVIAGEM = 'Data e Hora da Viagem';
  DSC_DHCONEXAO = 'Data e Hora da Conex�o';
  DSC_INFVIAGEM = 'Informa��es da Viagem';
  DSC_PREFIXO = 'Prefixo da Linha';
  DSC_POLTRONA = 'Numero da Poltrona / Assento / Cabine';
  DSC_PLATAFORMA = 'Plataforma / Carro / Barco de Embarque';
  DSC_TPVEICULO = 'Tipo de Ve�culo Transportado';
  DSC_SITVEICULO = 'Situa��o do Ve�culo Transportado';
  DSC_VBP = 'Valor do Bilhete de Passagem';
  DSC_VDESCONTO = 'Valor do Desconto';
  DSC_VPGTO = 'Valor Pago';
  DSC_VTROCO = 'Valor do Troco';
  DSC_TPDESCONTO = 'Tipo de Desconto / Beneficio';
  DSC_XDESCONTO = 'Descri��o do Tipo de Desconto / Beneficio Concedido';
  DSC_TPCOMP = 'Tipo de Componente';
  DSC_VCOMP = 'Valor do Componente';
  DSC_COMP = 'Componente do Valor do Bilhete';
  DSC_VCRED = 'Valor do Cr�dito Outorgado / Presumido';
  DSC_VTOTTRIB = 'Valor Aproximado dos Tributos';
  DSC_VBCUFFIM = 'Valor da BC';
  DSC_PFCPUFFIM = 'Percentual para Fundo ao Combate a Pobreza';
  DSC_PICMSUFFIM = 'Percentual do ICMS';
  DSC_PICMSINTER = 'Percentual do ICMS Interno';
  DSC_PICMSINTERPART = 'Percentual do ICMS Interno Parte';
  DSC_VFCPUFFIM = 'Valor do Fundo ao Combate a Pobreza';
  DSC_VICMSUFFIM = 'Valor do ICMS da UF de Fim';
  DSC_VICMSUFINI = 'Valor do ICMS da UF de Inicio';
  DSC_XPAG = 'Desci��o da forma de pagamento';
  DSC_XBAND = 'Descri��o do tipo de bandeira';
  DSC_NSUTRANS = 'Numero Sequencial Unico da Transa��o';
  DSC_NSUHOST = 'Numero Sequencial Unico da Host';
  DSC_NPARCELAS = 'Numero de Parcelas';
  DSC_CDESCONTO = 'C�digo do Desconto / Beneficio Concedido';
  DSC_INFADCARD = 'Informa��es Adicionais do Cart�o de Cr�dito';
  DSC_XDOC = 'Descri��o do Documento';
  DSC_NDOCPAG = 'Numero do Documento para Pagamento';
  DSC_XXXX = 'XXXX';

implementation

end.

