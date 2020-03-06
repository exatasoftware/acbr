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
{.$Define SYNADEBUG}

unit ACBrDFeHttpOpenSSL;

interface

uses
  Classes, SysUtils,
  HTTPSend, ssl_openssl, ssl_openssl_lib, blcksock,
  ACBrDFeSSL,
  {$IfDef SYNADEBUG}synadbg,{$EndIf}
  OpenSSLExt;

type

  { TDFeHttpOpenSSL }

  TDFeHttpOpenSSL = class(TDFeSSLHttpClass)
  private
    FHTTP: THTTPSend;
    {$IfDef SYNADEBUG}
     FSynaDebug: TSynaDebug;
    {$EndIf}
    procedure VerificarSSLType(AValue: TSSLType);

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
  ACBrDFeException, ACBrUtil, ACBrConsts,
  synautil;

{ TDFeHttpOpenSSL }

constructor TDFeHttpOpenSSL.Create(ADFeSSL: TDFeSSL);
begin
  inherited;
  FHTTP := THTTPSend.Create;

  {$IfDef SYNADEBUG}
  FSynaDebug := TsynaDebug.Create;
  FHTTP.Sock.OnStatus := FSynaDebug.HookStatus;
  FHTTP.Sock.OnMonitor := FSynaDebug.HookMonitor;
  {$EndIf}
end;

destructor TDFeHttpOpenSSL.Destroy;
begin
  FHTTP.Free;
  {$IfDef SYNADEBUG}
  FSynaDebug.Free;
  {$EndIf}
  inherited Destroy;
end;

function TDFeHttpOpenSSL.Enviar(const ConteudoXML: String; const AURL: String;
  const ASoapAction: String; const AMimeType: String): String;
var
  OK: Boolean;
begin
  Result := '';

  // Configurando o THTTPSend //
  ConfigurarHTTP(AURL, ASoapAction, AMimeType);

  // Gravando no Buffer de Envio //
  WriteStrToStream(FHTTP.Document, AnsiString(ConteudoXML)) ;

  // DEBUG //
  //FHTTP.Document.SaveToFile( 'c:\temp\HttpSendDocument.xml' );
  //FHTTP.Headers.SaveToFile( 'c:\temp\HttpSendHeader.xml' );

  // Transmitindo //
  OK := FHTTP.HTTPMethod('POST', AURL);

  // Lendo a resposta //
  if OK then
  begin
    // DEBUG //
    //HTTP.Document.SaveToFile('c:\temp\ReqResp.xml');
    FHTTP.Document.Position := 0;
    Result := String( ReadStrFromStream(FHTTP.Document, FHTTP.Document.Size) );
  end;

  // Verifica se o ResultCode �: 200 OK; 201 Created; 202 Accepted
  // https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
  OK := OK and (FHTTP.ResultCode in [200, 201, 202]);
  if not OK then
    raise EACBrDFeException.Create( Format(cACBrDFeSSLEnviarException,
                                       [InternalErrorCode, HTTPResultCode, AURL] )
                                       + sLineBreak + FHTTP.Sock.LastErrorDesc);
end;

procedure TDFeHttpOpenSSL.Abortar;
begin
  FHTTP.Sock.CloseSocket;
end;

procedure TDFeHttpOpenSSL.ConfigurarHTTP(const AURL, ASoapAction: String;
  const AMimeType: String);
begin
  FHTTP.Clear;

  if not FpDFeSSL.UseCertificateHTTP then
  begin
    FHTTP.Sock.SSL.PFX := '';
    FHTTP.Sock.SSL.KeyPassword := '';
  end
  else
  begin
    FHTTP.Sock.SSL.PFX := FpDFeSSL.SSLCryptClass.CertPFXData;
    FHTTP.Sock.SSL.KeyPassword := FpDFeSSL.Senha;
  end;

  VerificarSSLType(FpDFeSSL.SSLType);
  FHTTP.Sock.SSL.SSLType := FpDFeSSL.SSLType;

  FHTTP.Timeout := FpDFeSSL.TimeOut;
  with FHTTP.Sock do
  begin
    SetTimeout(FpDFeSSL.TimeOut);
    ConnectionTimeout := FpDFeSSL.TimeOut;
    InterPacketTimeout := False;
    NonblockSendTimeout := FpDFeSSL.TimeOut;
    SocksTimeout := FpDFeSSL.TimeOut;
    HTTPTunnelTimeout := FpDFeSSL.TimeOut;
  end;

  FHTTP.ProxyHost := FpDFeSSL.ProxyHost;
  FHTTP.ProxyPort := FpDFeSSL.ProxyPort;
  FHTTP.ProxyUser := FpDFeSSL.ProxyUser;
  FHTTP.ProxyPass := FpDFeSSL.ProxyPass;
  FHTTP.MimeType  := AMimeType;
  FHTTP.UserAgent := 'Synapse OpenSSL ACBr/1.0';
  FHTTP.Protocol  := '1.1';
  //FHTTP.Sock.SSL.VerifyCert := False;
  FHTTP.AddPortNumberToHost := False;

  if ASoapAction <> '' then
    FHTTP.Headers.Add('SOAPAction: "' + ASoapAction + '"');
end;

procedure TDFeHttpOpenSSL.VerificarSSLType(AValue: TSSLType);
var
  SSLMethod: ssl_openssl_lib.PSSL_METHOD;
  OpenSSLVersion: String;
begin
  SSLMethod := Nil;

  case AValue of
    LT_SSLv2:
      SSLMethod := ssl_openssl_lib.SslMethodV2;
    LT_SSLv3:
      SSLMethod := ssl_openssl_lib.SslMethodV3;
    LT_TLSv1:
      SSLMethod := ssl_openssl_lib.SslMethodTLSV1;
    LT_TLSv1_1:
      SSLMethod := ssl_openssl_lib.SslMethodTLSV11;
    LT_TLSv1_2:
      SSLMethod := ssl_openssl_lib.SslMethodTLSV12;
    LT_TLSv1_3:
      SSLMethod := ssl_openssl_lib.SslMethodTLSV13;
    LT_all:
      begin
        SSLMethod := ssl_openssl_lib.SslMethodTLS;
        if not Assigned(SSLMethod) then
          SSLMethod := ssl_openssl_lib.SslMethodV23;
      end;
  end;

  if not Assigned(SSLMethod) then
  begin
    OpenSSLVersion := String(ssl_openssl_lib.OpenSSLVersion( 0 ));

    raise EACBrDFeException.CreateFmt(ACBrStr('%s, n�o suporta %s'),
          [OpenSSLVersion, GetEnumName(TypeInfo(TSSLType), integer(AValue) )]);
  end;
end;

function TDFeHttpOpenSSL.GetHTTPResultCode: Integer;
begin
  Result := FHTTP.ResultCode;
end;

function TDFeHttpOpenSSL.GetInternalErrorCode: Integer;
begin
  Result := FHTTP.Sock.LastError;
end;

end.



