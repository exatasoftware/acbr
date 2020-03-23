{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Dipold                                   }
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

unit ACBrBALToledo9091_8530_8540;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};
  
type
  TACBrBALToledo9091_8530_8540 = class( TACBrBALClass )
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end ;

implementation

Uses
  SysUtils, Math,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALToledo9091_8530_8540 }

constructor TACBrBALToledo9091_8530_8540.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Toledo 9091 8530 8540' ;
end;

function TACBrBALToledo9091_8530_8540.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  SWA, SWB, SWC, SP : AnsiString;
  PesoBruto : Integer;
  STX : Integer ;
begin
  Result := -9;

  if (aResposta = EmptyStr) then
    Exit;

  {
    Protocolo 8530 COUGAR 60.000 ou 80.000
    Protocolo 8540 ANAL�GICO NUM�RICO 60.000 ou 80.000
    [ STX ] [ SWA ] [ SWB ] [ SWC ] [ SP ] [ IIIII ] [ TTTTTT ] [ CR ] [ CKS ]
    [  0  ] [  1  ] [  2  ] [  3  ] [ 4  ] [ 5-10  ] [ 11-16  ] [ 17 ] [ 18  ]

    Protocolo 9091
    Protocolo 8530 COUGAR 100.000 ou 120.000
    Protocolo 8540 ANAL�GICO NUM�RICO 100.000 ou 120.000
    [ STX ] [ SWA ] [ SWB ] [ SWC ] [ IIIIII ] [ TTTTTT ] [ CR ] [ CKS ]
    [  0  ] [  1  ] [  2  ] [  3  ] [ 4-9    ] [ 10-15  ] [ 16 ] [ 17  ]

    STX           : Caractere ASCII de In�cio de Texto (02 HEX)
    SWA, SWB, SWC : Palavras de Estado A, B e C
    SP            : Espa�o
    IIIIII        : Peso exibido no display
    TTTTTT        : Peso da Tara
    CR            : Caractere ASCII de Retorno de Carro (0D HEX)
    CKS           : Checksun
  }

    try
    STX := Pos(#02, aResposta);

    if (STX > 0) then
    begin
      SWA := Copy(aResposta, 1, 1);
      SWB := Copy(aResposta, 2, 1);
      SWC := Copy(aResposta, 3, 1);
      SP  := Copy(aResposta, 4, 1);

	  // TODO: Testar SWB 
	  //  bit 1 = 1 para peso negativo 
	  //  bit 2 = 1 para sobrecarga
	  //  bit 3 = 1 para movimento
	  
      if (SP = ' ') then
      begin
        PesoBruto := StrToIntDef(Copy(aResposta, 5, 6), 0);
        //PesoTara:= StrToIntDef(Copy(aResposta, 11, 6), 0);
      end
      else
      begin
        PesoBruto := StrToIntDef(Copy(aResposta, 4, 6), 0);
        //PesoTara:= StrToIntDef(Copy(aResposta, 10, 6), 0);
      end;

      Result := PesoBruto;
    end;
  except
     Result := -9;
  end;

end;

end.
