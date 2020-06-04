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

unit ACBrTEFDDisc;

interface

uses
  Classes, SysUtils, ACBrTEFDClass;

const
  CACBrTEFDDisc_ArqTemp   = 'C:\TEF_Disc\req\intpos.tmp' ;
  CACBrTEFDDisc_ArqReq    = 'C:\TEF_Disc\req\intpos.001' ;
  CACBrTEFDDisc_ArqResp   = 'C:\TEF_Disc\resp\intpos.001' ;
  CACBrTEFDDisc_ArqSTS    = 'C:\TEF_Disc\resp\intpos.sts' ;
  CACBrTEFDDisc_GPExeName = 'C:\TEF_Disc\tef_Disc.exe' ;


type
   { TACBrTEFDDisc }

   TACBrTEFDDisc = class( TACBrTEFDClassTXT )
   private
   public
     constructor Create( AOwner : TComponent ) ; override ;
   end;

implementation

{ TACBrTEFDClass }

constructor TACBrTEFDDisc.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ArqReq    := CACBrTEFDDisc_ArqReq ;
  ArqResp   := CACBrTEFDDisc_ArqResp ;
  ArqSTS    := CACBrTEFDDisc_ArqSTS ;
  ArqTemp   := CACBrTEFDDisc_ArqTemp ;
  GPExeName := CACBrTEFDDisc_GPExeName ;
  fpTipo    := gpTefDisc;
  Name      := 'TEF_Disc' ;
end;

end.

