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

unit ACBrDISGertecTEC65lib;

interface
uses
  Classes,
  ACBrDISClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

{ Nota: - Essa Unit depende da DLL da Gertec tec65_32.dll, a qual � carregada 
  dinamicamente ao Ativar }

const
  CTEC65LIB = 'tec65_32.dll';

type

{ TACBrDISGertecTEC65lib }

TACBrDISGertecTEC65lib = class( TACBrDISClass )
  private
      xOpenTec65 : function : integer; stdcall;
      XCloseTec65: function : integer; stdcall;
      xGoToXY : function (lin, col: integer): integer; stdcall;
      xDispStr : function (Str: PAnsiChar): integer; stdcall;
      xFormFeed : function : integer; stdcall;

      procedure FunctionDetectLib(const FuncName: String; var LibPointer: Pointer);
      procedure LoadDLLFunctions;
      procedure UnLoadDLLFunctions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Ativar ; override ;
    procedure Desativar; override;
    
    procedure LimparDisplay ; override ;

    procedure PosicionarCursor(Linha, Coluna: Integer ) ; override ;
    procedure Escrever( const Texto : String ) ; override ;
end ;

implementation
Uses ACBrUtil,
     SysUtils,
     {$IFDEF COMPILER6_UP} DateUtils {$ELSE} ACBrD5, Windows{$ENDIF} ;

{ ACBrDISGertecTEC65lib}

constructor TACBrDISGertecTEC65lib.Create(AOwner: TComponent);
begin
  inherited Create( AOwner );

  fpModeloStr := 'GertecTeclado65lib' ;
  LinhasCount := 2 ;
  Colunas     := 40 ;
  fpIntervaloEnvioBytes := 0;
end;

destructor TACBrDISGertecTEC65lib.Destroy;
begin
  UnLoadDLLFunctions;
  inherited Destroy;
end;


procedure TACBrDISGertecTEC65lib.LimparDisplay;
begin
  if Assigned(xFormFeed) then
    xFormFeed ;
end;

procedure TACBrDISGertecTEC65lib.PosicionarCursor(Linha, Coluna: Integer);
begin
  if Assigned(xGoToXY) then
    xGoToXY( Linha, Coluna);
end;

procedure TACBrDISGertecTEC65lib.Escrever(const Texto: String);
begin
  if Assigned(xDispStr) then
    xDispStr( PAnsiChar( AnsiString(ACBrStrToAnsi(Texto))) );
end;

procedure TACBrDISGertecTEC65lib.Ativar;
begin
  LoadDLLFunctions;
  xOpenTec65;
  fpAtivo := true ;
end;

procedure TACBrDISGertecTEC65lib.Desativar;
begin
  if Assigned(XCloseTec65) then
    XCloseTec65;

  UnLoadDLLFunctions;
  fpAtivo := false ;
end;

procedure TACBrDISGertecTEC65lib.LoadDLLFunctions;
begin
  FunctionDetectLib( 'OpenTec65',  @xOpenTec65 );
  FunctionDetectLib( 'CloseTec65', @XCloseTec65 );
  FunctionDetectLib( 'GoToXY',     @xGoToXY) ;
  FunctionDetectLib( 'DispStr',    @xDispStr);
  FunctionDetectLib( 'FormFeed',   @xFormFeed);
end;

procedure TACBrDISGertecTEC65lib.FunctionDetectLib(const FuncName : String ;
  var LibPointer : Pointer) ;
begin
  if not Assigned( LibPointer )  then
  begin
    if not FunctionDetect( CTEC65LIB, FuncName, LibPointer) then
    begin
       LibPointer := NIL ;
       raise EACBrDISErro.Create( ACBrStr(Format('Erro ao carregar a fun��o: %s na Biblioteca: %s', [FuncName,CTEC65LIB])) ) ;
    end ;
  end ;
end ;

procedure TACBrDISGertecTEC65lib.UnLoadDLLFunctions;
begin
  if not Assigned(xOpenTec65) then
    Exit;

  UnLoadLibrary( CTEC65LIB );

  xOpenTec65  := Nil;
  XCloseTec65 := Nil;
  xGoToXY     := Nil;
  xDispStr    := Nil;
  xFormFeed   := Nil;
end;



end.
