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

unit ACBrDISSmakTeclado;

interface
uses ACBrDISClass,
     Classes;

{ Nota: - A comunica��o com a Porta AT n�o � t�o r�pida quando a Porta Serial,
          por isso, evite o uso excessivo de textos "animados"
        - A fun�ao Tx1board() funciona normalmente em Win9x,
        - XP /NT /2000, deve-se usar uma DLL que permita acesso direto
          a porta AT  ( inpout32.dll )  http://www.logix4u.net/inpout32.htm
        - Linux: � necess�rio ser ROOT para acessar /dev/port
          (use: su  ou  chmod u+s SeuPrograma ) }
type

{ TACBrDISSmakTeclado }

TACBrDISSmakTeclado = class( TACBrDISClass )
  public
    constructor Create(AOwner: TComponent); override;

    procedure Ativar ; override ;

    procedure LimparDisplay ; override ;
    procedure LimparLinha( Linha: Integer ) ; override ;

    procedure PosicionarCursor(Linha, Coluna: Integer ) ; override ;
    procedure Escrever( const Texto : String ) ; override ;
end ;

implementation
Uses
     SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, Math, Windows{$ENDIF},
     math ;

{ TACBrDISSmakTeclado}

constructor TACBrDISSmakTeclado.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'Smak Teclado' ;
  LinhasCount := 2 ;
  Colunas     := 40 ;
end;

procedure TACBrDISSmakTeclado.LimparDisplay;
begin
  TxKeyboard( $097 );
  TxKeyboard( 1 );
  Sleep(2);
end;

procedure TACBrDISSmakTeclado.LimparLinha(Linha: Integer);
begin
  if Linha = 1 then
     TxKeyboard( $08E )
  else
     TxKeyboard( $08F ) ;
  Sleep(2);
end;

procedure TACBrDISSmakTeclado.PosicionarCursor(Linha, Coluna: Integer);
begin
  TxKeyboard( $096 );
  TxKeyboard( min(Coluna, Colunas) );
  TxKeyboard( min(Linha, LinhasCount) );
end;

procedure TACBrDISSmakTeclado.Escrever(const Texto: String);
Var A : Integer ;
begin
  TxKeyboard( $09A );
  for A := 1 to Length( Texto ) do
     TxKeyboard( ord(Texto[A]) ) ;      // Envia um Byte por vez...
  TxKeyboard( $000 );
end;

procedure TACBrDISSmakTeclado.Ativar;
begin
  { Nao precisa de inicializa�ao }
  fpAtivo := true ;
end;

end.
