{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrTEFDConvCard;

interface

uses
  Classes, SysUtils, ACBrTEFDClass;

const
  CACBrTEFDConvCard_ArqTemp   = 'C:\ger_convenio\tx\crtsol.tmp' ;
  CACBrTEFDConvCard_ArqReq    = 'C:\ger_convenio\tx\crtsol.001' ;
  CACBrTEFDConvCard_ArqResp   = 'C:\ger_convenio\rx\crtsol.001' ;
  CACBrTEFDConvCard_ArqSTS    = 'C:\ger_convenio\rx\crtsol.ok' ;
  CACBrTEFDConvCard_GPExeName = 'C:\ger_convcard\convcard.exe' ;


type
   { TACBrTEFDDial }

   TACBrTEFDConvCard = class( TACBrTEFDClassTXT )
   private
   public
     constructor Create( AOwner : TComponent ) ; override ;
   end;

implementation

{ TACBrTEFDClass }

constructor TACBrTEFDConvCard.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ArqReq    := CACBrTEFDConvCard_ArqReq ;
  ArqResp   := CACBrTEFDConvCard_ArqResp ;
  ArqSTS    := CACBrTEFDConvCard_ArqSTS ;
  ArqTemp   := CACBrTEFDConvCard_ArqTemp ;
  GPExeName := CACBrTEFDConvCard_GPExeName ;
  fpTipo    := gpConvCard;
  Name      := 'ConvCard' ;
end;

end.

