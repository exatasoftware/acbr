{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Fabio Farias                                   }
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

unit ACBrSIN;

interface

uses
  ACBrDevice, ACBrBase, ACBrSINClass,  {Units da ACBr}
  SysUtils, Classes,
  {$IFNDEF NOGUI}
    {$IF DEFINED(VisualCLX)}
      QExtCtrls,
    {$ElseIf DEFINED(FMX)}
      FMX.Types,
    {$Else}
      ExtCtrls,
    {$IfEnd}
  {$ENDIF}
  {$IFDEF COMPILER6_UP}
    Types
  {$ELSE}
    Windows, ACBrD5
  {$ENDIF};

type

TACBrSINModelo = (sinNenhum, sinLaurenti);

{ Componente ACBrSIN }

{ TACBrSIN }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSIN = class(TACBrComponent)
  private
    fsDevice: TACBrDevice;  { SubComponente ACBrDevice }

    { Propriedades do Componente ACBrSIN }
    fsAtivo  : Boolean;
    fsModelo : TACBrSINModelo;
    fsSIN    : TACBrSINClass ;

    function GetArqLOG: String;
    procedure SetArqLOG(const AValue: String);
    procedure SetModelo(const Value: TACBrSINModelo);
    procedure SetPorta(const Value: String);
    procedure SetAtivo(const Value: Boolean);
    function GetPorta: String;
    function GetModeloStrClass: String;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    procedure Ativar ;
    procedure Desativar ;

    property Ativo : Boolean read fsAtivo write SetAtivo ;
    property SIN : TACBrSINClass read fsSIN;
    property ModeloStr : String read GetModeloStrClass;
    procedure defineLed(const ALed: TACBrCorLed);
  published
     property Modelo : TACBrSINModelo read fsModelo write SetModelo default sinNenhum ;
     property Porta : String read GetPorta write SetPorta ;
     property ArqLOG : String      read GetArqLOG write SetArqLOG ;
     { Instancia do Componente ACBrDevice, ser� passada para fsBAL.create }
     property Device : TACBrDevice read fsDevice ;
  end ;

implementation

uses
  ACBrSinLaurenti,
  {$IFDEF COMPILER6_UP} StrUtils {$ELSE} ACBrD5{$ENDIF}, ACBrUtil.Strings;

{ TACBrSIN }
constructor TACBrSIN.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  fsAtivo       := false ;
  fsModelo      := sinNenhum ;

  { Instanciando SubComponente TACBrDevice }
  fsDevice := TACBrDevice.Create( self ) ;  { O dono � o proprio componente }
  fsDevice.Name := 'ACBrDevice' ;      { Apenas para aparecer no Object Inspector}
  {$IFDEF COMPILER6_UP}
  fsDevice.SetSubComponent( true );{ para gravar no DFM/XFM }
  {$ENDIF}
  fsDevice.Porta := 'COM1';
  fsDevice.TimeOut := 1 ;

  { Instanciando fsBAL com modelo Generico (TACBrBALClass) }
  fsSIN := TACBrSINClass.create( self ) ;
end;

destructor TACBrSIN.Destroy;
begin
  Desativar;
  if Assigned(fsSIN) then
    FreeAndNil(fsSIN);

  FreeAndNil(fsDevice);

  inherited Destroy;
end;

procedure TACBrSIN.SetModelo(const Value: TACBrSINModelo);
var
  wArqLOG: String;
begin
  if (fsModelo = Value) then
    Exit;

  if fsAtivo then
    raise Exception.Create(ACBrStr('N�o � poss�vel mudar o Modelo com ACBrSIN Ativo'));

  wArqLOG := ArqLOG;

  FreeAndNil(fsSIN);

  { Instanciando uma nova classe de acordo com fsModelo }
  case Value of
     sinLaurenti    : fsSIN := TACBrSinLaurenti.create(Self);
  else
     fsSIN := TACBrSINClass.Create(Self);
  end;

  ArqLOG       := wArqLOG;
  fsModelo     := Value;
end;

function TACBrSIN.GetArqLOG: String;
begin
  Result := fsSIN.ArqLOG;
end;

procedure TACBrSIN.SetArqLOG(const AValue: String);
begin
  fsSIN.ArqLOG := AValue;
end;

procedure TACBrSIN.defineLed(const ALed: TACBrCorLed);
begin
  fsSIN.defineLed(ALed);
end;

procedure TACBrSIN.SetAtivo(const Value: Boolean);
begin
  if Value then
    Ativar
  else
    Desativar ;
end;

procedure TACBrSIN.Ativar;
begin
  if fsAtivo then
    exit ;

  fsSIN.Ativar ;
  fsAtivo   := true;
end;

procedure TACBrSIN.Desativar;
begin
  if not fsAtivo then
    exit ;

  fsSIN.Desativar ;
  fsAtivo := false;
end;

function TACBrSIN.GetModeloStrClass: String;
begin
  Result := ACBrStr(fsSIN.ModeloStr) ;
end;

function TACBrSIN.GetPorta: String;
begin
  result := fsDevice.Porta ;
end;

procedure TACBrSIN.SetPorta(const Value: String);
begin
  fsDevice.Porta := Value ;
end;

end.


