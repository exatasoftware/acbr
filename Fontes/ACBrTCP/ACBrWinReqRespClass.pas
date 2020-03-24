{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Classe para Lazarus/Free Pascal e Delphi para requisi��es SOAP com suporte  }
{ certificados A1 e A3 usando as bibliotecas WinINet e CAPICOM                 }
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

unit ACBrWinReqRespClass;

interface

{$IfDef MSWINDOWS}
uses
  Windows, Classes, SysUtils,
  ACBr_WinCrypt,
  blcksock;

type

  { EACBrWinReqResp }

  EACBrWinReqResp = class(Exception)
  public
    constructor Create(const Msg: String);
  end;

  { TACBrWinReqResp }

  TACBrWinReqResp = class
  private
    FCertContext: PCCERT_CONTEXT;
    FEncodeDataToUTF8: Boolean;
    FSOAPAction: String;
    FMimeType: String;
    FMethod: String;
    // (ex.: 'application/soap+xml' ou 'text/xml' - que � o Content-Type)
    FCharsets: String; //  (ex.: 'ISO-8859-1,utf-8' - que � o Accept-Charset)
    FData: AnsiString;
    FProxyHost: String;
    FProxyPass: String;
    FProxyPort: String;
    FProxyUser: String;
    FSSLType: TSSLType;
    FTimeOut: Integer;
    FUrl: String;
  protected
    FpInternalErrorCode: Integer;
    FpHTTPResultCode: Integer;

    function GetWinInetError(ErrorCode: DWORD): String; virtual;
    procedure UpdateErrorCodes(ARequest: Pointer); virtual;

  public
    constructor Create;
    destructor Destroy; override;

    property CertContext: PCCERT_CONTEXT read FCertContext write FCertContext;
    property SOAPAction: String read FSOAPAction write FSOAPAction;
    property MimeType: String read FMimeType write FMimeType;
    property Method: String read FMethod write FMethod;
    property Charsets: String read FCharsets write FCharsets;
    property Url: String read FUrl write FUrl;
    property Data: AnsiString read FData write FData;
    property ProxyHost: String read FProxyHost write FProxyHost;
    property ProxyPort: String read FProxyPort write FProxyPort;
    property ProxyUser: String read FProxyUser write FProxyUser;
    property ProxyPass: String read FProxyPass write FProxyPass;
    property EncodeDataToUTF8: Boolean read FEncodeDataToUTF8 write FEncodeDataToUTF8;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property SSLType: TSSLType read FSSLType write FSSLType;

    property HTTPResultCode: Integer read FpHTTPResultCode;
    property InternalErrorCode: Integer read FpInternalErrorCode;

    procedure Execute(Resp: TStream); overload; virtual;
    procedure Execute(const DataMsg: String; Resp: TStream); overload;

    procedure Abortar; virtual;
  end;

implementation

uses
  ACBrUtil, ACBr_WinHttp, wininet;

{ EACBrWinINetReqResp }

constructor EACBrWinReqResp.Create(const Msg: String);
begin
  inherited Create(ACBrStr(Msg));
end;

{ TACBrWinINetReqResp }

constructor TACBrWinReqResp.Create;
begin
  FMimeType := 'application/soap+xml';
  FCharsets := 'utf-8';
  FSOAPAction := '';
  FCertContext := Nil;
  FTimeOut := 0;
  FEncodeDataToUTF8 := False;
  FSSLType := LT_all;
  FMethod := 'POST';

  FpHTTPResultCode := 0;
  FpInternalErrorCode := 0;
end;

destructor TACBrWinReqResp.Destroy;
begin
  Abortar;
  inherited Destroy;
end;

function TACBrWinReqResp.GetWinInetError(ErrorCode: DWORD): String;
var
  ErrorMsg: AnsiString;
  Len: DWORD;
  WinINetHandle: HMODULE;
begin
  ErrorMsg := '';
  Result  := 'Erro: '+IntToStr(ErrorCode);

  WinINetHandle := GetModuleHandle('wininet.dll');
  SetLength(ErrorMsg, 1024);
  Len := FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM or
                        FORMAT_MESSAGE_FROM_HMODULE or
                        FORMAT_MESSAGE_IGNORE_INSERTS or
                        FORMAT_MESSAGE_MAX_WIDTH_MASK or
                        FORMAT_MESSAGE_ARGUMENT_ARRAY,
                        @WinINetHandle,
                        ErrorCode,
                        0,
                        @ErrorMsg[1], 1024,
                        nil);
  if (Len > 0) then
    ErrorMsg := Trim(ErrorMsg)
  else
  begin
    case ErrorCode of
       ERROR_WINHTTP_TIMEOUT:
         ErrorMsg := 'TimeOut de Requisi��o';
       ERROR_WINHTTP_NAME_NOT_RESOLVED:
         ErrorMsg := 'O nome do servidor n�o pode ser resolvido';
       ERROR_WINHTTP_CANNOT_CONNECT:
         ErrorMsg := 'Conex�o com o Servidor falhou';
       ERROR_WINHTTP_CONNECTION_ERROR:
         ErrorMsg := 'A conex�o com o servidor foi redefinida ou encerrada, ou um protocolo SSL incompat�vel foi encontrado';
       ERROR_INTERNET_CONNECTION_RESET:
         ErrorMsg := 'A conex�o com o servidor foi redefinida';
       ERROR_WINHTTP_SECURE_INVALID_CA:
         ErrorMsg := 'Certificado raiz n�o � confi�vel pelo provedor de confian�a';
       ERROR_WINHTTP_SECURE_CERT_REV_FAILED:
         ErrorMsg := 'Revoga��o do Certificado n�o pode ser verificada porque o servidor de revoga��o est� offline';
       ERROR_WINHTTP_SECURE_CHANNEL_ERROR:
         ErrorMsg := 'Erro relacionado ao Canal Seguro';
       ERROR_WINHTTP_SECURE_FAILURE:
         ErrorMsg := 'Um ou mais erros foram encontrados no certificado Secure Sockets Layer (SSL) enviado pelo servidor';
       ERROR_WINHTTP_CLIENT_CERT_NO_PRIVATE_KEY:
         ErrorMsg := 'O contexto para o certificado de cliente SSL n�o tem uma chave privada associada a ele. O certificado de cliente pode ter sido importado para o computador sem a chave privada';
       ERROR_WINHTTP_CLIENT_CERT_NO_ACCESS_PRIVATE_KEY:
         ErrorMsg := 'Falha ao obter a Chave Privada do Certificado para comunica��o segura';
    end;
  end;

  if (ErrorMsg <> '') then
    Result := Result + ' - '+ ErrorMsg;
end;

procedure TACBrWinReqResp.UpdateErrorCodes(ARequest: Pointer);
begin
  FpInternalErrorCode := GetLastError;
end;

procedure TACBrWinReqResp.Execute(const DataMsg: String; Resp: TStream);
begin
  Data := DataMsg;
  Execute(Resp);
end;

procedure TACBrWinReqResp.Abortar;
begin
  {}
end;

procedure TACBrWinReqResp.Execute(Resp: TStream);
begin
  raise EACBrWinReqResp.Create('Metodo "Execute" n�o implementado em '+ClassName);
end;

{$Else}
implementation

{$EndIf}

end.
