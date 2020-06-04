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

unit ACBrTEFDAuttar;

interface

uses
  Classes, SysUtils, ACBrTEFDClass;

const
  CACBrTEFDAuttar_ArqTemp   = 'C:\Auttar_TefIP\req\intpos.tmp' ;
  CACBrTEFDAuttar_ArqReq    = 'C:\Auttar_TefIP\req\intpos.001' ;
  CACBrTEFDAuttar_ArqResp   = 'C:\Auttar_TefIP\resp\intpos.001' ;
  CACBrTEFDAuttar_ArqSTS    = 'C:\Auttar_TefIP\resp\intpos.sts' ;
  CACBrTEFDAuttar_GPExeName = 'C:\Program Files (x86)\Auttar\IntegradorTEF-IP.exe' ;


type
   { TACBrTEFDAuttar }

   TACBrTEFDAuttar = class( TACBrTEFDClassTXT )
   private
   protected
     procedure FinalizarRequisicao ; override;
   public
     constructor Create( AOwner : TComponent ) ; override ;
   end;

implementation

Uses
  ACBrTEFD;

{ TACBrTEFDClass }

constructor TACBrTEFDAuttar.Create(AOwner : TComponent);
var
  DirApp : String ;
begin
  inherited Create(AOwner);

  ArqReq    := CACBrTEFDAuttar_ArqReq ;
  ArqResp   := CACBrTEFDAuttar_ArqResp ;
  ArqSTS    := CACBrTEFDAuttar_ArqSTS ;
  ArqTemp   := CACBrTEFDAuttar_ArqTemp ;

  GPExeName := '';
  DirApp := Trim(GetEnvironmentVariable('ProgramFiles(x86)'));
  if DirApp = '' then
     DirApp := Trim(GetEnvironmentVariable('ProgramFiles'));
  if DirApp <> '' then
     GPExeName := DirApp + PathDelim+'Auttar'+PathDelim+'IntegradorTEF-IP.exe' ;

  if GPExeName = '' then
     GPExeName := CACBrTEFDAuttar_GPExeName ;

  fpTipo    := gpTefAuttar;
  Name      := 'TEFAuttar' ;
end;

procedure TACBrTEFDAuttar.FinalizarRequisicao ;
begin
  VerificarIniciouRequisicao;

  if (pos(Req.Header,'CRT|CNF') > 0) and                       // � CRT ou CNF ?
     ( TACBrTEFD(Owner).RespostasPendentes.Count > 0 ) then    // � acima de 1 cart�o ?
     Req.GravaInformacao(099,000,'1'); // Campo obrigatorio ap�s segundo cart�o com valor = 1

  inherited FinalizarRequisicao ;
end ;

end.

