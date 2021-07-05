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

unit ACBrCHQMenno;

interface
uses
  Classes,
  ACBrCHQClass,Dialogs
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type TACBrCHQMenno = class( TACBrCHQClass )
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

constructor TACBrCHQMenno.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpDevice.Stop := s2 ;
  fpModeloStr := 'Menno' ;
end;

procedure TACBrCHQMenno.Ativar;
begin
  if fpDevice.Porta = ''  then
     raise Exception.Create(ACBrStr('Impressora de Cheques '+fpModeloStr+' requer'+#10+
                            'Porta Serial (COMn) ou Paralela (LPTn)'));

  inherited Ativar ; { Abre porta serial }
end;

procedure TACBrCHQMenno.ImprimirCheque;
Var ValStr, DataStr : String ;
   vImprime : String;
begin
  //EnviarStr( #27+'@' ) ;

  { Banco }
  vImprime := #27+ '�' + fpBanco + #13;
  { Valor }
  ValStr := FormatFloatBr(fpValor);
  vImprime := vImprime + #27+'�' + ValStr + #13;
  { Data }
  //caso habilitado para emitir bom para, a data enviada sera impressa no campo bom para e
  //a data do cheque ser� a data atual
  if fpBomPara>0 then
     DataStr := FormatDateTime('dd/mm/yyyy',fpBomPara)
  else
     DataStr := FormatDateTime('dd/mm/yyyy',fpData);

  vImprime := vImprime +  #27+'�' + DataStr + #13;
  { Cidade }
  vImprime := vImprime +  #27+'�' + fpCidade + #13;
  { Favorecido }
  vImprime := vImprime +  #27+'�' +  fpFavorecido + #13;
  { Numero Cheque - Caso n�o mande nada vai solicitar na impressora }
  vImprime := vImprime +  #27+'�' + '000000' + #13;
  { Cruzado }
  vImprime := vImprime + #27+'�0';  //mude o parametro para �1 se desejar cruzar o cheque
  { bom para }
  if fpBomPara>0 then
     vImprime := vImprime + #27+'�1'
  else
     vImprime := vImprime + #27+'�0';

  { c�pia de cheque}
  vImprime := vImprime + #27+'�0';  //mude o parametro para �1 se desejar emitir copia do cheque

  vImprime := vImprime + #27+'�';

  EnviarStr( vImprime ) ;

end;

function TACBrCHQMenno.GetChequePronto: Boolean;
Var nBit : Byte ;
begin
  Result := true ;

  if not fpDevice.IsSerialPort then
     exit ;

  fpDevice.EnviaString( #27 + #63 ) ;   // Pede Status
  nBit := fpDevice.LeByte( 200 ) ;
  
  Result := (Chr(nBit)='1');
end;

procedure TACBrCHQMenno.ImprimirLinha(const AString: AnsiString);
var
  NovaString: AnsiString;
begin
  NovaString := AString;
  EnviarStr( NovaString+#12 );
end;

procedure TACBrCHQMenno.ImprimirVerso(AStringList: TStrings);
Var A : Integer ;
   vImprime : String;
begin
  vImprime := #27+'@'+#13+#13+#13+#13+#13;
  For A := 0 to AStringList.Count - 1 do
     vImprime := vImprime + #13+StringOfChar(' ',15) + AStringList[A];

  ImprimirLinha( vImprime );


end;

end.
