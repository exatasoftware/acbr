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


*)

{$I ACBr.inc}

unit ACBrPIXPSPSicredi;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrOpenSSLUtils;

const
  cSicrediURLSandbox = 'https://api-pix-h.sicredi.com.br';
  cSicrediURLProducao = 'https://api-pix.sicredi.com.br';
  cSicrediPathAuthToken = '/oauth/token';
  cSicrediPathAPIPix = '/api';
  cSicrediURLAuthTeste = cSicrediURLSandbox+cSicrediPathAuthToken;
  cSicrediURLAuthProducao = cSicrediURLProducao+cSicrediPathAuthToken;


type

  { TACBrPSPItau }

  { TACBrPSPSicredi }

  TACBrPSPSicredi = class(TACBrPSP)
  private
    fSandboxStatusCode: String;
    fxCorrelationID: String;
    fSSLUtils: TACBrOpenSSLUtils;
    fArquivoCertificado: String;
    fArquivoChavePrivada: String;
    fQuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial;

    procedure SetArquivoCertificado(AValue: String);
    procedure SetArquivoChavePrivada(AValue: String);
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    procedure ConfigurarHeaders(const Method, AURL: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear; override;
    procedure Autenticar; override;

  published
    property APIVersion;
    property ClientID;
    property ClientSecret;

    property ArquivoChavePrivada: String read fArquivoChavePrivada write SetArquivoChavePrivada;
    property ArquivoCertificado: String read fArquivoCertificado write SetArquivoCertificado;
    property SandboxStatusCode: String read fSandboxStatusCode write fSandboxStatusCode;

    property QuandoNecessitarCredenciais: TACBrQuandoNecessitarCredencial
      read fQuandoNecessitarCredenciais write fQuandoNecessitarCredenciais;
  end;

implementation

uses
  synautil, synacode,
  ACBrUtil.Strings,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr
  {$Else}
   Jsons
  {$EndIf},
  DateUtils;

{ TACBrPSPItau }

constructor TACBrPSPSicredi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fSSLUtils := TACBrOpenSSLUtils.Create(Self);  // Self ir� destruir ele...
  Clear;
end;

procedure TACBrPSPSicredi.Clear;
begin
  inherited Clear;
  fxCorrelationID := '';
  fSandboxStatusCode := '';
  fArquivoCertificado := '';
  fArquivoChavePrivada := '';
  fQuandoNecessitarCredenciais := Nil;
end;

procedure TACBrPSPSicredi.Autenticar;
var
  AURL, Body, BasicAutentication: String;
  RespostaHttp: AnsiString;
  ResultCode, sec: Integer;
  js: TJsonObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    AURL := cSicrediURLAuthProducao
  else
    AURL := cSicrediURLAuthTeste;

  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type']    := 'client_credentials';
    qp.Values['scope']         := 'cob.read cob.write pix.read pix.write';
    Body := qp.AsURL;
    WriteStrToStream(Http.Document, Body);
    Http.MimeType := CContentTypeApplicationWwwFormUrlEncoded;
  finally
    qp.Free;
  end;

  BasicAutentication := 'Basic '+EncodeBase64(ClientID + ':' + ClientSecret);
  Http.Headers.Add(ChttpHeaderAuthorization+' '+BasicAutentication);
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);

  if (ResultCode = HTTP_OK) then
  begin
   {$IfDef USE_JSONDATAOBJECTS_UNIT}
    js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
    try
      fpToken        := js.S['access_token'];
      sec            := js.I['expires_in'];
      fpRefreshToken := '';
    finally
      js.Free;
    end;
   {$Else}
    js := TJsonObject.Create;
    try
      js.Parse(RespostaHttp);
      fpToken        := js['access_token'].AsString;
      sec            := js['expires_in'].AsInteger;
      fpRefreshToken := '';
    finally
      js.Free;
    end;
   {$EndIf}

   if (Trim(fpToken) = '') then
     DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

   fpValidadeToken := IncSecond(Now, sec);
   fpAutenticado := True;
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
      [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPSicredi.SetArquivoCertificado(AValue: String);
begin
  if (fArquivoCertificado = AValue) then
    Exit;

  fArquivoCertificado := Trim(AValue);
end;

procedure TACBrPSPSicredi.SetArquivoChavePrivada(AValue: String);
begin
  if (fArquivoChavePrivada = AValue) then
    Exit;

  fArquivoChavePrivada := (AValue);
end;

function TACBrPSPSicredi.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cSicrediURLProducao
  else
    Result := cSicrediURLSandbox;

  Result := Result + cSicrediPathAPIPix;
end;

procedure TACBrPSPSicredi.ConfigurarHeaders(const Method, AURL: String);
begin
  inherited ConfigurarHeaders(Method, AURL);

  Http.Sock.SSL.CertificateFile := fArquivoCertificado;
  Http.Sock.SSL.PrivateKeyFile  := fArquivoChavePrivada;
end;

procedure TACBrPSPSicredi.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  if (fSandboxStatusCode <> '') then
    URLQueryParams.Values['status_code'] := fSandboxStatusCode;
end;

end.


