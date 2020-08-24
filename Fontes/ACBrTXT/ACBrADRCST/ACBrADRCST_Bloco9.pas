{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ribamar M. Santos                               }
{                              Juliomar Marchetti                              }
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

unit ACBrADRCST_Bloco9;

interface

Uses
  SysUtils,
  Classes,
  ACBrADRCST_Blocos;

type
  TRegistro9000 = class(TBlocos)
  private
    FREG1200_ICMSST_RECUPERAR_RESSARCIR: currency;
    FREG1200_ICMSST_COMPLEMENTAR: currency;
    FREG1300_ICMSST_RECUPERAR_RESSARCIR: currency;
    FREG1400_ICMSST_RECUPERAR_RESSARCIR: currency;
    FREG1500_ICMSST_RECUPERAR_RESSARCIR: currency;
    FREG9000_FECOP_RESSARCIR: currency;
    FREG9000_FECOP_COMPLEMENTAR: currency;
  public
    //constructor Create;
    //destructor Destroy; override;

    property REG1200_ICMSST_RECUPERAR_RESSARCIR: currency read FREG1200_ICMSST_RECUPERAR_RESSARCIR write FREG1200_ICMSST_RECUPERAR_RESSARCIR;
    property REG1200_ICMSST_COMPLEMENTAR: currency read FREG1200_ICMSST_COMPLEMENTAR write FREG1200_ICMSST_COMPLEMENTAR;
    property REG1300_ICMSST_RECUPERAR_RESSARCIR: currency read FREG1300_ICMSST_RECUPERAR_RESSARCIR write FREG1300_ICMSST_RECUPERAR_RESSARCIR;
    property REG1400_ICMSST_RECUPERAR_RESSARCIR: currency read FREG1400_ICMSST_RECUPERAR_RESSARCIR write FREG1400_ICMSST_RECUPERAR_RESSARCIR;
    property REG1500_ICMSST_RECUPERAR_RESSARCIR: currency read FREG1500_ICMSST_RECUPERAR_RESSARCIR write FREG1500_ICMSST_RECUPERAR_RESSARCIR;
    property REG9000_FECOP_RESSARCIR: currency read FREG9000_FECOP_RESSARCIR write FREG9000_FECOP_RESSARCIR;
    property REG9000_FECOP_COMPLEMENTAR: currency  read FREG9000_FECOP_COMPLEMENTAR write FREG9000_FECOP_COMPLEMENTAR;
  end;

  TRegistro9999 = class(TCloseBlocos)
  public
  end;

implementation

end.
