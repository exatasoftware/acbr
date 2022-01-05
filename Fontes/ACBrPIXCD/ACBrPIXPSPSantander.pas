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
  https://developer.santander.com.br/

*)

{$I ACBr.inc}

unit ACBrPIXPSPSantander;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD;

const
  cURLSantanderApiPIX = '/api/v1';
  cURLSantanderSandbox = 'https://pix.santander.com.br'+cURLSantanderApiPIX+'/sandbox';
  cURLSantanderPreProducao = 'https://trust-pix-h.santander.com.br'+cURLSantanderApiPIX;
  cURLSantanderProducao = 'https://trust-pix.santander.com.br'+cURLSantanderApiPIX;

  cURLSantanderAuthTeste = 'https://pix.santander.com.br/sandbox/oauth/token';
  cURLSantanderAuthPreProducao = 'https://trust-pix-h.santander.com.br/oauth/token';
  cURLSantanderAuthProducao = 'https://trust-pix.santander.com.br/oauth/token';

resourcestring
  sErroClienteIdDiferente = 'Cliente_Id diferente do Informado';

type

  { TACBrPSPSantander }

  TACBrPSPSantander = class(TACBrPSP)
  private
    fRefreshURL: String;
    function GetConsumerKey: String;
    function GetConsumerSecret: String;
    procedure SetConsumerKey(AValue: String);
    procedure SetConsumerSecret(AValue: String);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;
    procedure RenovarToken; override;
  published
    property ConsumerKey: String read GetConsumerKey write SetConsumerKey;
    property ConsumerSecret: String read GetConsumerSecret write SetConsumerSecret;
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

{ TACBrPSPSantander }

constructor TACBrPSPSantander.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fRefreshURL := '';
end;

procedure TACBrPSPSantander.Autenticar;
var
  AURL, RespostaHttp, Body, client_id: String;
  ResultCode, sec: Integer;
  js: TJsonObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  case ACBrPixCD.Ambiente of
    ambProducao: AURL := cURLSantanderAuthProducao;
    ambPreProducao: AURL := cURLSantanderAuthPreProducao;
  else
    AURL := cURLSantanderAuthTeste;
  end;

  AURL := AURL + '?grant_type=client_credentials';

  qp := TACBrQueryParams.Create;
  try
    qp.Values['client_id'] := ClientID;
    qp.Values['client_secret'] := ClientSecret;
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);

  if (ResultCode = HTTP_OK) then
  begin
   {$IfDef USE_JSONDATAOBJECTS_UNIT}
    js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
    try
      client_id := Trim(js.S['client_id']);
      if (client_id <> ClientID) then
        raise EACBrPixHttpException.Create(ACBrStr(sErroClienteIdDiferente));
      fpToken := js.S['access_token'];
      sec := js.I['expires_in'];
      fRefreshURL := js.S['refresh_token'];
    finally
      js.Free;
    end;
   {$Else}
    js := TJsonObject.Create;
    try
      js.Parse(RespostaHttp);
      client_id := Trim(js['client_id'].AsString);
      if (client_id <> ClientID) then
        raise EACBrPixHttpException.Create(ACBrStr(sErroClienteIdDiferente));
      fpToken := js['access_token'].AsString;
      sec := js['expires_in'].AsInteger;
      fRefreshURL := js['refresh_token'].AsString;
    finally
      js.Free;
    end;
   {$EndIf}

   fpValidadeToken := IncSecond(Now, sec);
   fpAutenticado := True;
  end
  else
    ACBrPixCD.DispararExcecao(EACBrPixHttpException.CreateFmt(
      sErroHttp,[Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPSantander.RenovarToken;
begin
  // TODO: ??
  inherited RenovarToken;
end;

function TACBrPSPSantander.GetConsumerKey: String;
begin
  Result := ClientID;
end;

function TACBrPSPSantander.GetConsumerSecret: String;
begin
  Result := ClientSecret;
end;

procedure TACBrPSPSantander.SetConsumerKey(AValue: String);
begin
  ClientID := AValue;
end;

procedure TACBrPSPSantander.SetConsumerSecret(AValue: String);
begin
  ClientSecret := AValue;
end;

function TACBrPSPSantander.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  case ACBrPixCD.Ambiente of
    ambProducao: Result := cURLSantanderProducao;
    ambPreProducao: Result := cURLSantanderPreProducao;
  else
    Result := cURLSantanderSandbox;
  end;
end;

end.


