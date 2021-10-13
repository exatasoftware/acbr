{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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

unit ACBrTEFAndroid;

interface

uses
  Classes, SysUtils,
  System.UITypes,
  System.Generics.Collections,
  {$IfDef ANDROID}
  Androidapi.JNI.GraphicsContentViewText,
  {$EndIf}
  ACBrBase, ACBrTEFComum, ACBrTEFAPIComum;

resourcestring
  sACBrTEFAndroidPlataformException = '%s dispon�vel apenas para Android';

type
  TACBrTEFAndroidModelo = (tefNenhum, tefPayGo);

  EACBrTEFAndroidErro = class(EACBrTEFAPIErro);

  {$IfDef ANDROID}
  TACBrTEFAndroidEstadoTransacao = procedure(AIntent: JIntent) of object;
  {$EndIf}

  { TACBrTEFAndroidPersonalizacao }

  TACBrTEFAndroidPersonalizacao = class( TPersistent )
  private
    fcorFundoTela: TAlphaColor;
    fcorFonte: TAlphaColor;
    fcorTextoCaixaEdicao: TAlphaColor;
    fcorFundoCaixaEdicao: TAlphaColor;
    fcorSeparadorMenu: TAlphaColor;
    fcorTeclaLiberadaTeclado: TAlphaColor;
    fcorTeclaPressionadaTeclado: TAlphaColor;
    fcorFundoToolbar: TAlphaColor;
    fcorFonteTeclado: TAlphaColor;
    fcorFundoTeclado: TAlphaColor;
    fArquivoIcone: String;
    fArquivoFonte: String;
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TPersistent); override;

  published
    property corFundoTela: TAlphaColor read fcorFundoTela write fcorFundoTela default 0;
    property corFundoToolbar: TAlphaColor read fcorFundoToolbar write fcorFundoToolbar default 0;
    property corFundoTeclado: TAlphaColor read fcorFundoTeclado write fcorFundoTeclado default 0;
    property corFonte: TAlphaColor read fcorFonte write fcorFonte default 0;
    property corFundoCaixaEdicao: TAlphaColor read fcorFundoCaixaEdicao write fcorFundoCaixaEdicao default 0;
    property corTextoCaixaEdicao: TAlphaColor read fcorTextoCaixaEdicao write fcorTextoCaixaEdicao default 0;
    property corTeclaLiberadaTeclado: TAlphaColor read fcorTeclaLiberadaTeclado write fcorTeclaLiberadaTeclado default 0;
    property corTeclaPressionadaTeclado: TAlphaColor read fcorTeclaPressionadaTeclado write fcorTeclaPressionadaTeclado default 0;
    property corFonteTeclado: TAlphaColor read fcorFonteTeclado write fcorFonteTeclado default 0;
    property corSeparadorMenu: TAlphaColor read fcorSeparadorMenu write fcorSeparadorMenu default 0;
    property ArquivoIcone: String read fArquivoIcone write fArquivoIcone;
    property ArquivoFonte: String read fArquivoFonte write fArquivoFonte;
  end;

  { TACBrTEFAndroid }

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllAndroidPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrTEFAndroid = class( TACBrTEFAPIComum )
  private
    fTEFModelo: TACBrTEFAndroidModelo;
    {$IfDef ANDROID}
     fQuandoIniciarTransacao: TACBrTEFAndroidEstadoTransacao;
    {$EndIf}
    fPersonalizacao: TACBrTEFAndroidPersonalizacao;

    procedure SetModelo(const AValue: TACBrTEFAndroidModelo);
    procedure SetPersonalizacao(const Value: TACBrTEFAndroidPersonalizacao);
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Inicializar; override;
    procedure DoException(const AErrorMsg: String); override;

    property TEF: TACBrTEFAPIComumClass read fpTEFAPIClass;
  published
    property Modelo: TACBrTEFAndroidModelo
      read fTEFModelo write SetModelo default tefNenhum;

    property Personalizacao: TACBrTEFAndroidPersonalizacao
      read fPersonalizacao write SetPersonalizacao;

    {$IfDef ANDROID}
     property QuandoIniciarTransacao: TACBrTEFAndroidEstadoTransacao
       read fQuandoIniciarTransacao
       write fQuandoIniciarTransacao;
    {$EndIf}
  end;

implementation

uses
  StrUtils, TypInfo,
  ACBrUtil
  {$IfDef ANDROID}
  ,ACBrTEFAndroidPayGo
  {$EndIf}
  ;

{ TACBrTEFAndroid }

constructor TACBrTEFAndroid.Create(AOwner: TComponent);
begin
  inherited;
  {$IfDef ANDROID}
   fQuandoIniciarTransacao := Nil;
  {$EndIf}
  fPersonalizacao := TACBrTEFAndroidPersonalizacao.Create;
  fTEFModelo := TACBrTEFAndroidModelo.tefNenhum;
end;

destructor TACBrTEFAndroid.Destroy;
begin
  fPersonalizacao.Free;
  inherited;
end;

procedure TACBrTEFAndroid.DoException(const AErrorMsg: String);
begin
  if (Trim(AErrorMsg) = '') then
    Exit;

  GravarLog('EACBrTEFAndroidErro: '+AErrorMsg);
  raise EACBrTEFAndroidErro.Create(AErrorMsg);
end;

procedure TACBrTEFAndroid.Inicializar;
begin
  if not fPersonalizacao.ArquivoIcone.IsEmpty then
    if not FileExists(fPersonalizacao.ArquivoIcone) then
      DoException(Format( sACBrTEFAPIArquivoNaoExistenteException,
                          [fPersonalizacao.ArquivoIcone]));

  if not fPersonalizacao.ArquivoFonte.IsEmpty then
    if not FileExists(fPersonalizacao.ArquivoFonte) then
      DoException( Format( sACBrTEFAPIArquivoNaoExistenteException,
                           [fPersonalizacao.ArquivoFonte]));

  inherited;
end;

procedure TACBrTEFAndroid.SetPersonalizacao(const Value: TACBrTEFAndroidPersonalizacao);
begin
  if (fPersonalizacao <> Value) then
    fPersonalizacao.Assign(Value);
end;

procedure TACBrTEFAndroid.SetModelo(const AValue: TACBrTEFAndroidModelo);
begin
  if fTEFModelo = AValue then
    Exit;

  GravarLog('SetModelo( '+GetEnumName(TypeInfo(TACBrTEFAndroidModelo), integer(AValue))+' )');

  if Inicializado then
    DoException( Format( sACBrTEFAPIComponenteInicializadoException, ['Modelo']));

  FreeAndNil( fpTEFAPIClass ) ;

  { Instanciando uma nova classe de acordo com AValue }
  case AValue of
    tefPayGo :
      begin
       // IfDef Abaixo, permite que o Modelo fique dispon�vel no ObjectInspector (Win)
       {$IfDef ANDROID}
        fpTEFAPIClass := TACBrTEFAndroidPayGoClass.Create( Self );
       {$Else}
        fpTEFAPIClass := TACBrTEFAPIComumClass.Create( Self );
        DoException( Format( sACBrTEFAndroidPlataformException, ['tefPayGo']));
       {$EndIf}
      end
  else
    fpTEFAPIClass := TACBrTEFAPIComumClass.Create( Self );
  end;

  fTEFModelo := AValue;
end;

{ TACBrTEFAndroidPersonalizacao }

constructor TACBrTEFAndroidPersonalizacao.Create;
begin
  inherited;
  Clear;
end;

procedure TACBrTEFAndroidPersonalizacao.Clear;
begin
  fcorFundoTela := 0;
  fcorFonte := 0;
  fcorTextoCaixaEdicao := 0;
  fcorFundoCaixaEdicao := 0;
  fcorSeparadorMenu := 0;
  fcorTeclaLiberadaTeclado := 0;
  fcorTeclaPressionadaTeclado := 0;
  fcorFundoToolbar := 0;
  fcorFonteTeclado := 0;
  fcorFundoTeclado := 0;
  fArquivoIcone := '';
  fArquivoFonte := '';
end;

procedure TACBrTEFAndroidPersonalizacao.Assign(Source: TPersistent);
begin
  if (Source is TACBrTEFAndroidPersonalizacao) then
  begin
    fcorFundoTela := TACBrTEFAndroidPersonalizacao(Source).corFundoTela;
    fcorFonte := TACBrTEFAndroidPersonalizacao(Source).corFonte;
    fcorTextoCaixaEdicao := TACBrTEFAndroidPersonalizacao(Source).corTextoCaixaEdicao;
    fcorFundoCaixaEdicao := TACBrTEFAndroidPersonalizacao(Source).corFundoCaixaEdicao;
    fcorSeparadorMenu := TACBrTEFAndroidPersonalizacao(Source).corSeparadorMenu;
    fcorTeclaLiberadaTeclado := TACBrTEFAndroidPersonalizacao(Source).corTeclaLiberadaTeclado;
    fcorTeclaPressionadaTeclado := TACBrTEFAndroidPersonalizacao(Source).corTeclaPressionadaTeclado;
    fcorFundoToolbar := TACBrTEFAndroidPersonalizacao(Source).corFundoToolbar;
    fcorFonteTeclado := TACBrTEFAndroidPersonalizacao(Source).corFonteTeclado;
    fcorFundoTeclado := TACBrTEFAndroidPersonalizacao(Source).corFundoTeclado;
    fArquivoIcone := TACBrTEFAndroidPersonalizacao(Source).ArquivoIcone;
    fArquivoFonte := TACBrTEFAndroidPersonalizacao(Source).ArquivoFonte;
  end;
end;

end.

