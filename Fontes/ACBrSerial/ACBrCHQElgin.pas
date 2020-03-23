{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: La�rcio S Amici                                 }
{                              Emerson Virissimo da Silva                      }
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

unit ACBrCHQElgin;

interface
uses
  ACBrCHQClass,
  Classes
  {$IFNDEF COMPILER6_UP} ,Windows {$ENDIF} ;

type

  TACBrCHQElgin = class(TACBrCHQClass)
  private
    FImprimeVerso: boolean;

  public
    constructor Create(AOwner: TComponent);

    procedure Ativar ; override ;

    procedure ImprimirCheque ; Override ;
    Procedure TravarCheque ;  Override ;
    Procedure DestravarCheque ;  Override ;
    Procedure ImprimirVerso(AStringList : TStrings); Override;
  end;

implementation

uses
  SysUtils
  {$IFDEF COMPILER6_UP}, DateUtils {$ENDIF},
  ACBrUtil, ACBrConsts, ACBrDeviceSerial;

{ TACBrCHQBematech }

constructor TACBrCHQElgin.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  { Parametros de conex�o Elgin }
  fpDevice.Baud := 9600;
  fpDevice.Parity := pNone;
  fpDevice.Data := 8;
  fpDevice.Stop := s2;
  //fpDevice.HardFlow := true ;
  fpModeloStr := 'Elgin' ;
end;

procedure TACBrCHQElgin.Ativar;
begin
  if fpDevice.Porta = ''  then
     raise Exception.Create(ACBrStr('Impressora de Cheques '+fpModeloStr+' requer'+#10+
                            'Porta Serial (COMn) ou Paralela (LPTn)'));

  fpDevice.HardFlow := true ;  { Ativar RTS/CTS } 
  inherited Ativar ; { Abre porta serial }
end;

procedure TACBrCHQElgin.TravarCheque;
begin
(* Elgin n�o trava cheque

  if FImprimeVerso then
    EnviarStr( #27 + #119 + #1 )
  else
    EnviarStr( #27 + #177 );
*)
end;

procedure TACBrCHQElgin.DestravarCheque;
begin
(* Elgin n�o trava cheque

  if FImprimeVerso then
    EnviarStr( #27 + #119 + #0 )
  else
    EnviarStr( #27 + #176 );
*)
end;

procedure TACBrCHQElgin.ImprimirVerso(AStringList : TStrings);
begin
(* N�O IMPLEMENTADO
  FImprimeVerso := True;

  TravarCheque ;

  For A := 0 to AStringList.Count - 1 do
     ImprimirLinha( StringOfChar(' ',10) + TiraAcentos( AStringList[A] ) );

  DestravarCheque ;
*)
end;

procedure TACBrCHQElgin.ImprimirCheque;
Var ValStr, DataStr : String ;
begin
  if not fpDevice.EmLinha( 3 ) then  { Impressora est� em-linha ? }
    raise Exception.Create(ACBrStr('A impressora de Cheques '+fpModeloStr+
                           ' n�o est� pronta.')) ;
  FImprimeVerso := False;


  TravarCheque ;

  { Banco }
  EnviarStr( #27 + #66 + fpBanco ) ;

  { Cidade }
  EnviarStr( #27 + #67 + Copy(fpCidade,1,20) + '$' ) ;  // Cidade - termina com caracter $ #36

  { Data }
  DataStr := FormatDateTime('dd/mm/yyyy',fpData) ;
  DataStr := StringReplace(DataStr, DateSeparator, '',[rfReplaceAll]) ;
  EnviarStr( #27 + #68 + DataStr ) ;

  { Favorecido }
  EnviarStr( #27 + #70 + fpFavorecido + '$' ) ;   // Favorecido - termina com caracter $

  { Valor com 14 digitos - SEMPRE ENVIAR POR �LTIMO - Quando recebe o valor, imprime o chq }
  ValStr := IntToStrZero( Round( fpValor * 100), 14) ;
  // Nao usa separador
  //ValStr := copy(ValStr,1,9)+','+copy(ValStr,10,2) ;
  EnviarStr( #27 + #86 + ValStr );

  DestravarCheque ;
end;

end.
