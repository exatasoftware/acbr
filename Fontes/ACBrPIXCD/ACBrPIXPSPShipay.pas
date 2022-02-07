{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

(*

  Documenta��o
  https://api-staging.shipay.com.br/docs.html

*)

{$I ACBr.inc}

unit ACBrPIXPSPShipay;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrShipaySchemas;

const
  cShipayURLStaging = 'https://api-staging.shipay.com.br';
  cShipayURLProducao = 'https://api.shipay.com.br';
  cShipayVersaoAPI = '/v1';
  cShipayEndPointAuth = '/pdvauth';
  cShipayEndPointRefreshToken = '/refresh-token';
  cShipayEndPointListaCarteiras = cShipayVersaoAPI+'/wallets';

type

  { TACBrPSPShipay }

  TACBrPSPShipay = class(TACBrPSP)
  private
    fAccessKey: String;
    fRefreshToken: String;
    fWallets: TShipayWalletArray;
    function GetSecretKey: String;
    procedure SetSecretKey(AValue: String);

    procedure ProcessarAutenticacao(const AURL: String; ResultCode: Integer;
      const RespostaHttp: AnsiString);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Autenticar; override;
    procedure RenovarToken; override;
    function GetWallets: Boolean;

    property Wallets: TShipayWalletArray read fWallets;
  published
    property ClientID;
    property SecretKey: String read GetSecretKey write SetSecretKey;
    property AccessKey: String read fAccessKey write fAccessKey;
  end;

implementation

uses
  synautil,
  ACBrUtil,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr
  {$Else}
   Jsons
  {$EndIf},
  DateUtils;

{ TACBrPSPShipay }

constructor TACBrPSPShipay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fWallets := TShipayWalletArray.Create('');
  fRefreshToken := '';
  fAccessKey := '';
end;

destructor TACBrPSPShipay.Destroy;
begin
  fWallets.Free;
  inherited Destroy;
end;

procedure TACBrPSPShipay.Autenticar;
var
  AURL, Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  js: TJsonObject;
begin
  LimparHTTP;
  AURL := ObterURLAmbiente( ACBrPixCD.Ambiente ) + cShipayEndPointAuth;

  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
   try
     js.S['access_key'] := AccessKey;
     js.S['secret_key'] := SecretKey;
     js.S['client_id'] := ClientID;
     Body := js.ToJSON();
   finally
     js.Free;
   end;
  {$Else}
   js := TJsonObject.Create;
   try
     js['access_key'].AsString := AccessKey;
     js['secret_key'].AsString := SecretKey;
     js['client_id'].AsString := ClientID;
     Body := js.Stringify;
   finally
     js.Free;
   end;
  {$EndIf}

  WriteStrToStream(Http.Document, Body);
  Http.MimeType := CContentTypeApplicationJSon;
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);
  ProcessarAutenticacao(AURL, ResultCode, RespostaHttp);
end;

procedure TACBrPSPShipay.RenovarToken;
var
  AURL: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  LimparHTTP;
  AURL := ObterURLAmbiente( ACBrPixCD.Ambiente ) + cShipayEndPointRefreshToken;

  Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+fpRefereshToken);
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);
  ProcessarAutenticacao(AURL, ResultCode, RespostaHttp);
end;

function TACBrPSPShipay.GetWallets: Boolean;
var
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  AURL: String;
begin
  Wallets.Clear;
  PrepararHTTP;
  AcessarEndPoint(ChttpMethodGET, cShipayEndPointListaCarteiras, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
    fWallets.AsJSON := String(RespostaHttp)
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodGET, cShipayEndPointListaCarteiras);
    ACBrPixCD.DispararExcecao(EACBrPixHttpException.CreateFmt(
      sErroHttp,[Http.ResultCode, ChttpMethodPOST, AURL]));
  end;
end;

function TACBrPSPShipay.GetSecretKey: String;
begin
   Result := ClientSecret;
end;

procedure TACBrPSPShipay.SetSecretKey(AValue: String);
begin
  ClientSecret := AValue;
end;

procedure TACBrPSPShipay.ProcessarAutenticacao(const AURL: String;
  ResultCode: Integer; const RespostaHttp: AnsiString);
var
  js: TJsonObject;
begin
  Wallets.Clear;
  if (ResultCode = HTTP_OK) then
  begin
   {$IfDef USE_JSONDATAOBJECTS_UNIT}
    js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
    try
      fpToken := js.S['access_token'];
      fRefreshToken := js.S['refresh_token'];
    finally
      js.Free;
    end;
   {$Else}
    js := TJsonObject.Create;
    try
      js.Parse(RespostaHttp);
      fpToken := js['access_token'].AsString;
      fRefreshToken := js['refresh_token'].AsString;
    finally
      js.Free;
    end;
   {$EndIf}

    if (Trim(fpToken) = '') then
      ACBrPixCD.DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

    fpValidadeToken := IncHour(Now, 24);
    fpAutenticado := True;

    GetWallets;
  end
  else
    ACBrPixCD.DispararExcecao(EACBrPixHttpException.CreateFmt(
      sErroHttp,[Http.ResultCode, ChttpMethodPOST, AURL]));
end;

function TACBrPSPShipay.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (ACBrPixCD.Ambiente = ambProducao) then
    Result := cShipayURLProducao
  else
    Result := cShipayURLStaging;
end;

end.


