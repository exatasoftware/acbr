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

{$I ACBr.inc}

unit ACBrPIXPSPBancoDoBrasil;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrPIXSchemasProblema;

const
  cURLBBSandbox = 'https://api.hm.bb.com.br';  // 'https://api.sandbox.bb.com.br';
  cURLBBProducao = 'https://api.bb.com.br';
  cURLBBAPIPix = '/pix/v1';
  cURLBBAuthTeste = 'https://oauth.hm.bb.com.br/oauth/token';
  cURLBBAuthProducao = 'https://oauth.bb.com.br/oauth/token';

type

  { TACBrPSPBancoDoBrasil }

  TACBrPSPBancoDoBrasil = class(TACBrPSP)
  private
    fDeveloperApplicationKey: String;
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    procedure ConfigurarQueryParameters(const Method, EndPoint: String); override;
    procedure TratarRetornoComErro(ResultCode: Integer; const RespostaHttp: String;
      Problema: TACBrPIXProblema); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Autenticar; override;
  published
    property ClientID;
    property ClientSecret;

    property DeveloperApplicationKey: String read fDeveloperApplicationKey
      write fDeveloperApplicationKey;
  end;

implementation

uses
  synautil, synacode,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr
  {$Else}
   Jsons
  {$EndIf},
  DateUtils;

{ TACBrPSPBancoDoBrasil }

constructor TACBrPSPBancoDoBrasil.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fDeveloperApplicationKey := '';
end;

procedure TACBrPSPBancoDoBrasil.Autenticar;
var
  AURL, RespostaHttp, Body, BasicAutentication: String;
  ResultCode, sec: Integer;
  js: TJsonObject;
  qp: TACBrQueryParams;
begin
  LimparHTTP;

  if (ACBrPixCD.Ambiente = ambProducao) then
    AURL := cURLBBAuthProducao
  else
    AURL := cURLBBAuthTeste;

  qp := TACBrQueryParams.Create;
  try
    qp.Values['grant_type'] := 'client_credentials';
    qp.Values['scope'] := 'cob.read cob.write pix.read pix.write';
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
      fpToken := js.S['access_token'];
      sec := js.I['expires_in'];
    finally
      js.Free;
    end;
   {$Else}
    js := TJsonObject.Create;
    try
      js.Parse(RespostaHttp);
      fpToken := js['access_token'].AsString;
      sec := js['expires_in'].AsInteger;
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

function TACBrPSPBancoDoBrasil.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cURLBBProducao
  else
    Result := cURLBBSandbox;

  Result := Result + cURLBBAPIPix;
end;

procedure TACBrPSPBancoDoBrasil.ConfigurarQueryParameters(const Method, EndPoint: String);
begin
  inherited ConfigurarQueryParameters(Method, EndPoint);

  with QueryParams do
  begin
    if (fDeveloperApplicationKey <> '') then
      Values['gw-dev-app-key'] := fDeveloperApplicationKey;
  end;
end;

procedure TACBrPSPBancoDoBrasil.TratarRetornoComErro(ResultCode: Integer;
  const RespostaHttp: String; Problema: TACBrPIXProblema);
var
  js, ej: TJsonObject;
  ae: TJsonArray;
begin
  if (pos('"ocorrencia"', RespostaHttp) > 0) then   // Erro no formato pr�prio do B.B.
  begin
     (* Exemplo de Retorno
       {
	    "erros": [{
		    "codigo": "4769515",
		    "versao": "1",
		    "mensagem": "N�o h� informa��es para os dados informados.",
		    "ocorrencia": "CHOM00000062715498140101"
	    }]
       }
     *)
    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
     try
       ae := js.A['erros'];
       if Assigned(ae) and (ae.Count > 0) then
       begin
         ej := ae.O[0];
         Problema.title := ej.S['ocorrencia'];
         Problema.status := ej.I['codigo'];
         Problema.detail := ej.S['mensagem'];
       end;
     finally
       js.Free;
     end;
    {$Else}
     js := TJsonObject.Create;
     try
       js.Parse(RespostaHttp);
       ae := js['erros'].AsArray;
       if Assigned(ae) and (ae.Count > 0) then
       begin
         ej := ae[0].AsObject;
         Problema.title := ej['ocorrencia'].AsString;
         Problema.status := ej['codigo'].AsInteger;
         Problema.detail := ej['mensagem'].AsString;
       end;
     finally
       js.Free;
     end;
    {$EndIf}

    if (Problema.title = '') then
      AtribuirErroHTTPProblema(Problema);
  end
  else if  (pos('"statusCode"', RespostaHttp) > 0) then   // Erro interno
  begin
    // Exemplo de Retorno
    // {"statusCode":401,"error":"Unauthorized","message":"Bad Credentials","attributes":{"error":"Bad Credentials"}}

    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
     try
       Problema.title := js.S['error'];
       Problema.status := js.I['statusCode'];
       Problema.detail := js.S['message'];
     finally
       js.Free;
     end;
    {$Else}
     js := TJsonObject.Create;
     try
       js.Parse(RespostaHttp);
       Problema.title := js['error'].AsString;
       Problema.status := js['statusCode'].AsInteger;
       Problema.detail := js['message'].AsString;
     finally
       js.Free;
     end;
    {$EndIf}

    if (Problema.title = '') then
      AtribuirErroHTTPProblema(Problema);
  end
  else
    inherited TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

end.

