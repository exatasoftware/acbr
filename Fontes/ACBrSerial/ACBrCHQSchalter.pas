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

unit ACBrCHQSchalter;

interface
uses
  Classes,
  ACBrCHQClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type TACBrCHQSchalter = class( TACBrCHQClass )
  private

  protected
    function GetChequePronto: Boolean; Override ;

  public
    constructor Create(AOwner: TComponent);

    procedure Ativar ; override ;

    procedure ImprimirCheque ; Override ;
    procedure ImprimirLinha( const AString : AnsiString ) ; Override ;
    procedure ImprimirVerso( AStringList : TStrings ) ; Override ;
end ;

implementation
Uses ACBrUtil,
     SysUtils,
   {$IFDEF COMPILER6_UP} DateUtils, {$ELSE} Windows,{$ENDIF}
     ACBrDeviceSerial;

{ TACBrCHQSchalter }

constructor TACBrCHQSchalter.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpDevice.Stop := s2 ;
  fpModeloStr := 'Schalter' ;
end;

procedure TACBrCHQSchalter.Ativar;
begin
  if fpDevice.Porta = ''  then
     raise Exception.Create(ACBrStr('Impressora de Cheques '+fpModeloStr+' requer'+#10+
                            'Porta Serial (COMn) ou Paralela (LPTn)'));

  inherited Ativar ; { Abre porta serial }
end;

procedure TACBrCHQSchalter.ImprimirCheque;
Var ValStr, DataStr : String ;
begin
  { Banco }
  EnviarStr( #27 + 'B' + fpBanco ) ;
  { Favorecido }
  EnviarStr( #27 + 'F' +  fpFavorecido + '$' ) ;
  { Cidade }
  EnviarStr( #27 + 'C' + fpCidade + '$' ) ;
  { Data }
  DataStr := FormatDateTime('ddmmyy',fpData) ;
  EnviarStr( #27 + 'D' + DataStr ) ;
  { Valor }
  ValStr := IntToStrZero( Round( fpValor * 100), 14) ;
  EnviarStr( #27 + 'V' + ValStr ) ;
  { Envio do comando Valor Inicia a Impress�o }
end;

function TACBrCHQSchalter.GetChequePronto: Boolean;
begin
  Result := fpDevice.EmLinha ;
end;

procedure TACBrCHQSchalter.ImprimirLinha(const AString: AnsiString);
var
  NovaString: AnsiString;
begin
  if Trim(AString) <> '' then
     NovaString := StringOfChar(' ',10) + AString
  else
     NovaString := Trim(AString) ;

  EnviarStr( CodificarPaginaDeCodigo(NovaString) + #10 );  { Adciona LF }
end;

procedure TACBrCHQSchalter.ImprimirVerso(AStringList: TStrings);
Var A : Integer ;
begin
  For A := 0 to AStringList.Count - 1 do
     ImprimirLinha( StringOfChar(' ',10) + AStringList[A] );

  EnviarStr( #12 ) { Envia FF } ;
end;

end.
