{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrEDIClass ;

{$I ACBr.inc}

interface

uses Classes, SysUtils, pediConversao ;

type

  { TNotas Registro de Notas Fiscais de Cobran�a Arquivo DOCCOB }
  TNotas = class
  private
     FIdRegistro : String ;
     FxSerie     : String ;
     FxNumero    : String ;
     FCNPJEmissor: String ;       /////////////////////////////////////
     FdtEmissao  : TDateTime ;    //
     FvNF        : Currency ;     //
     FqPesoNF    : Double ;       //     Estes campos
     FRomaneio   : String ;       //     Utilizados pelo
     FNumeroSAP1 : String ;       //
     FNumeroSAP2 : String ;       //     EDI 5.0
     FDevolucao  : tediSimNao ;   //
     FNumeroSAP3 : String ;       //
     FFiller     : String ;       //////////////////////////////////////
  public
     property IdRegistro : String     read FIdRegistro  write FIdRegistro ;
     property xSerie     : String     read FxSerie      write FxSerie ;
     property xNumero    : String     read FxNumero     write FxNumero ;
     property CNPJEmissor: String     read FCNPJEmissor write FCNPJEmissor ;
     property dtEmissao  : TDateTime  read FdtEmissao   write FdtEmissao ;
     property vNF        : Currency   read FvNF         write FvNF ;
     property qPesoNF    : Double     read FqPesoNF     write FqPesoNF ;
     property Romaneio   : String     read FRomaneio    write FRomaneio ;
     property NumeroSAP1 : String     read FNumeroSAP1  write FNumeroSAP1 ;
     property NumeroSAP2 : String     read FNumeroSAP2  write FNumeroSAP2 ;
     property Devolucao  : tediSimNao read FDevolucao   write FDevolucao ;
     property NumeroSAP3 : String     read FNumeroSAP3  write FNumeroSAP3 ;
     property Filler     : String     read FFiller      write FFiller ;
  end;

  { TNFCT Registro de Notas Fiscais do Conhecmento Arquivo ConEmb}
   TNFCT = class(TNotas)
   private
     FqVolume       : Double ;       ///////////////////////////////////////
     FqPesoCubado   : Double ;       //
     FqPesoDensidade: Double ;       //     Estes campos s�o
     FIdPedido      : String ;       //
     FTipoNF        : Integer ;      //     Utilizados pelo
     FBonificacao   : tediSimNao ;   //
     FCFOP          : String ;      //     EDI 5.0
     FUFGerador     : String ;       //
     FDesdobro      : String ;       ///////////////////////////////////////
   public
     property qVolume       : Double     read FqVolume        write FqVolume ;
     property qPesoCubado   : Double     read FqPesoCubado    write FqPesoCubado ;
     property qPesoDensidade: Double     read FqPesoDensidade write FqPesoDensidade ;
     property IdPedido      : String     read FIdPedido       write FIdPedido ;
     property TipoNF        : Integer    read FTipoNF         write FTipoNF ;
     property Bonificacao   : tediSimNao read FBonificacao    write FBonificacao ;
     property CFOP          : String     read FCFOP           write FCFOP ;
     property UFGerador     : String     read FUFGerador      write FUFGerador ;
     property Desdobro      : String     read FDesdobro       write FDesdobro ;
   end;

   { TInfTransportadora Informa��o da Transportadora Respons�vel pelo Frete }
   TTransportador = class
   private
     FIdRegistro: String ;  // Identificador do Registro
     FCNPJ      : String ;
     FRazao     : String ;
     FFiller    : String ;
   public
     property IdRegistro: String read FIdRegistro write FIdRegistro ;
     property CNPJ      : String read FCNPJ       write FCNPJ ;
     property Razao     : String read FRazao      write FRazao ;
     property Filler    : String read FFiller     write FFiller ;
   end;

  { TCabecalho Registro de Identifica��o do Arquivo EDI  Registro 000}
  TCabecalhoEDI = class
  private
     FIdRegistro  : String ;  // Identificador do Registro
     FRemetente   : String ;  // Remetente do Arquivo (Gerador do Arquivo EDI)
     FDestinatario: String ;  // Destinat�rio do Arquivo (Recebedor do Arquivo EDI)
     FData        : TDateTime ;  // Data devera ser no Formato DDMMAA
     FHora        : TTime  ;  // Hora devera ser no Formato HHMM
     FId          : String ;  // Identifica��o do Interc�mbio caso n�o seja informado
                              // ser� gerado o formato sugerido pelo manual
     FSequencia   : Integer ; // N�mero de Controle Sequencial do Arquivo
     FCNPJTransp  : string ;  // Usado nas vers�es 3.0 e 3.0a
     FFiller      : String ;  // Espa�os em branco para uso futuro
  public
     property IdRegistro  : String    read FIdRegistro   write FIdRegistro ;
     property Remetente   : String    read FRemetente    write FRemetente ;
     property Destinatario: String    read FDestinatario write FDestinatario ;
     property Data        : TDateTime read FData         write FData ;
     property Hora        : TTime     read FHora         write FHora ;
     property Id          : String    read FId           write FId ;
     property Sequencia   : Integer   read FSequencia    write FSequencia ;
     property CNPJTransp  : String    read FCNPJTransp   write FCNPJTransp ;
     property Filler      : String    read FFiller       write FFiller ;
  end;

implementation

end.
