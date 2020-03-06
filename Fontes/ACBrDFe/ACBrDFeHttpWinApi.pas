{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Andr� Ferreira de Moraes                       }
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

unit ACBrDFeHttpWinApi;

interface

uses
  Classes, SysUtils,
  ACBrDFeSSL, ACBrWinReqRespClass, ACBrWinHTTPReqResp, ACBrWinINetReqResp;

type

  { TDFeHttpWinHttp }

  TDFeHttpWinHttp = class(TDFeSSLHttpClass)
  private
    FWinHTTPReqResp: TACBrWinReqResp;

  protected
    function GetHTTPResultCode: Integer; override;
    function GetInternalErrorCode: Integer; override;
    procedure ConfigurarHTTP(const AURL, ASoapAction: String; const AMimeType: String); override;

  public
    constructor Create(ADFeSSL: TDFeSSL); override;
    destructor Destroy; override;

    function Enviar(const ConteudoXML: String; const AURL: String;
      const ASoapAction: String; const AMimeType: String = ''): String; override;
    procedure Abortar; override;
  end;


implementation

uses
  typinfo,
  ACBrDFeException, ACBrConsts,
  synautil;

{ TDFeHttpWinHttp }

constructor TDFeHttpWinHttp.Create(ADFeSSL: TDFeSSL);
begin
  inherited Create(ADFeSSL);

  if ADFeSSL.SSLHttpLib = httpWinINet then
    FWinHTTPReqResp := TACBrWinINetReqResp.Create
  else
    FWinHTTPReqResp := TACBrWinHTTPReqResp.Create;
end;

destructor TDFeHttpWinHttp.Destroy;
begin
  FWinHTTPReqResp.Free;
  inherited Destroy;
end;

function TDFeHttpWinHttp.Enviar(const ConteudoXML: String; const AURL: String;
  const ASoapAction: String; const AMimeType: String): String;
var
  Resp: TMemoryStream;
begin
  Result := '';

  ConfigurarHTTP(AURL, ASoapAction, AMimeType);

  Resp := TMemoryStream.Create;
  try
    try
      // Enviando, dispara exceptions no caso de erro //
      FWinHTTPReqResp.Execute(ConteudoXML, Resp);
      // DEBUG //
      //Resp.SaveToFile('c:\temp\ReqResp.xml');

      Resp.Position := 0;
      Result := String( ReadStrFromStream(Resp, Resp.Size) );

      // Verifica se o ResultCode �: 200 OK; 201 Created; 202 Accepted
      // https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
      if not (FWinHTTPReqResp.HTTPResultCode in [200, 201, 202]) then
        raise EACBrDFeException.Create('');

    except
      On E: Exception do
      begin
        raise EACBrDFeException.CreateDef( Format( cACBrDFeSSLEnviarException,
                                           [InternalErrorCode, HTTPResultCode, AURL] ) + sLineBreak +
                                           E.Message ) ;
      end;
    end;
  finally
    Resp.Free;
  end;
end;

procedure TDFeHttpWinHttp.Abortar;
begin
  FWinHTTPReqResp.Abortar;
end;

procedure TDFeHttpWinHttp.ConfigurarHTTP(const AURL, ASoapAction: String;
  const AMimeType: String);
begin
  with FpDFeSSL do
  begin
    if UseCertificateHTTP then
      FWinHTTPReqResp.CertContext := FpDFeSSL.CertContextWinApi
    else
      FWinHTTPReqResp.CertContext := Nil;

    FWinHTTPReqResp.SSLType   := SSLType;
    FWinHTTPReqResp.ProxyHost := ProxyHost;
    FWinHTTPReqResp.ProxyPort := ProxyPort;
    FWinHTTPReqResp.ProxyUser := ProxyUser;
    FWinHTTPReqResp.ProxyPass := ProxyPass;
    FWinHTTPReqResp.TimeOut   := TimeOut;
  end;

  FWinHTTPReqResp.Url        := AURL;
  FWinHTTPReqResp.SOAPAction := ASoapAction;
  FWinHTTPReqResp.MimeType   := AMimeType;
end;

function TDFeHttpWinHttp.GetHTTPResultCode: Integer;
begin
  Result := FWinHTTPReqResp.HTTPResultCode;
end;

function TDFeHttpWinHttp.GetInternalErrorCode: Integer;
begin
  Result := FWinHTTPReqResp.InternalErrorCode;
end;

end.

