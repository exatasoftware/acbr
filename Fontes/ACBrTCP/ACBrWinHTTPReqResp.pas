{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Classe para Lazarus/Free Pascal e Delphi para requisi��es SOAP com suporte  }
{ certificados A1 e A3 usando as bibliotecas WinINet e CAPICOM                 }
{ Direitos Autorais Reservados (c) 2014 Jean Patrick Figueiredo dos Santos     }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{ Colaboradores nesse arquivo:                                                 }
{                                       Juliomar Marchetti                     }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{******************************************************************************}

{$I ACBr.inc}
{.$Define DEBUG_WINHTTP}

unit ACBrWinHTTPReqResp;

interface

{$IfDef MSWINDOWS}
uses
  {$IFDEF DELPHIXE4_UP}
  AnsiStrings,
  {$ENDIF}
  Windows, Classes, SysUtils,
  ACBrWinReqRespClass,
  ACBr_WinCrypt, ACBr_WinHttp,
  blcksock;

type

  { TACBrWinHTTPReqResp }

  TACBrWinHTTPReqResp = class(TACBrWinReqResp)
  private
    fSession, fConnection, fRequest: HINTERNET;
  protected
    procedure UpdateErrorCodes(ARequest: HINTERNET); override;
    procedure CheckNotAborted;
    procedure CloseConnection;
  public
    procedure Execute(Resp: TStream); override;
    procedure Abortar; override;
  end;

implementation

uses
  {$IfDef DEBUG_WINHTTP}
   ACBrUtil,
  {$EndIf}
  synautil;

{ TACBrWinHTTPReqResp }

procedure TACBrWinHTTPReqResp.UpdateErrorCodes(ARequest: HINTERNET);
Var
  AStatusCode, ASize: DWORD;
begin
  FpInternalErrorCode := GetLastError;
  FpHTTPResultCode := 0;

  if Assigned(ARequest) then
  begin
    AStatusCode := 0;
    ASize := SizeOf(DWORD);
    if WinHttpQueryHeaders( ARequest,
                            WINHTTP_QUERY_STATUS_CODE or WINHTTP_QUERY_FLAG_NUMBER,
                            WINHTTP_HEADER_NAME_BY_INDEX,
                            @AStatusCode, @ASize,
                            WINHTTP_NO_HEADER_INDEX ) then
    begin
      FpHTTPResultCode := AStatusCode;
    end;
  end;
end;

procedure TACBrWinHTTPReqResp.CheckNotAborted;
begin
  if not Assigned(fSession) then
    raise EACBrWinReqResp.Create('Conex�o foi abortada');
end;

procedure TACBrWinHTTPReqResp.CloseConnection;
begin
  if Assigned(fRequest) then
  begin
    WinHttpCloseHandle(fRequest);
    fRequest := Nil
  end;

  if Assigned(fConnection) then
  begin
    WinHttpCloseHandle(fConnection);
    fConnection := Nil
  end;

  if Assigned(fSession) then
  begin
    WinHttpCloseHandle(fSession);
    fSession := Nil
  end;
end;

procedure TACBrWinHTTPReqResp.Execute(Resp: TStream);
var
  aBuffer: array[0..4096] of AnsiChar;
  BytesRead, BytesWrite: cardinal;
  UseSSL, UseCertificate: Boolean;
  ANone, AURI, AHost, AProt, APort, AHeader: String;
  wHeader: WideString;
  ConnectPort: WORD;
  AccessType, RequestFlags, flags, flagsLen: DWORD;
  HttpProxyName, HttpProxyPass: LPCWSTR;
  pProxyConfig: TWinHttpCurrentUserIEProxyConfig;
  {$IfDef DEBUG_WINHTTP}
   LogFile:String;
  {$EndIf}
begin
  {$IfDef DEBUG_WINHTTP}
  LogFile := 'c:\temp\winhttpreqresp.log';
  {$EndIf}

  AURI  := '';
  AProt := '';
  AHost := '';
  APort := '';
  ANone := '';

  AURI := ParseURL(Url, AProt, ANone, ANone, AHost, APort, ANone, ANone);

  UseSSL := (UpperCase(AProt) = 'HTTPS');
  UseCertificate := UseSSL and Assigned( CertContext );

  if (ProxyHost = '') then
  begin
    ZeroMemory(@pProxyConfig, SizeOf(pProxyConfig));
    if WinHttpGetIEProxyConfigForCurrentUser(pProxyConfig) then
      ProxyHost := String( pProxyConfig.lpszProxy );
  end;

  if (ProxyHost <> '') then
  begin
    AccessType := WINHTTP_ACCESS_TYPE_NAMED_PROXY;
    if (ProxyPort <> '') and (ProxyPort <> '0') then
      HttpProxyName := LPCWSTR( WideString(ProxyHost + ':' + ProxyPort) )
    else
      HttpProxyName := LPCWSTR( WideString(ProxyHost) );

    HttpProxyPass := LPCWSTR( WideString(ProxyPass) );
  end
  else
  begin
    AccessType := WINHTTP_ACCESS_TYPE_DEFAULT_PROXY;
    HttpProxyName := WINHTTP_NO_PROXY_NAME;
    HttpProxyPass := WINHTTP_NO_PROXY_BYPASS;
  end;

  {$IfDef DEBUG_WINHTTP}
   WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo sess�o');
  {$EndIf}

  fSession := WinHttpOpen( 'WinHTTP ACBr/1.0',
                           AccessType,
                           HttpProxyName,
                           HttpProxyPass,
                           0 );

  try
    if not Assigned(fSession) then
    begin
      UpdateErrorCodes(nil);
      raise EACBrWinReqResp.Create('Falha abrindo HTTP ou Proxy. Erro:' + GetWinInetError(FpInternalErrorCode));
    end;

    if (TimeOut > 0) then
    begin
      {$IfDef DEBUG_WINHTTP}
       WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Ajustando TimeOut: '+IntToStr(TimeOut));
      {$EndIf}
      //if not WinHttpSetOption( pSession,
      //                         WINHTTP_OPTION_CONNECT_TIMEOUT,
      //                         @TimeOut,
      //                         SizeOf(TimeOut)) then
      //  raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_CONNECT_TIMEOUT. Erro:' + GetWinInetError(GetLastError));

      CheckNotAborted;
      if not WinHttpSetTimeouts( fSession, TimeOut, TimeOut, TimeOut, TimeOut) then
        raise EACBrWinReqResp.Create('Falha ajustando Timeouts. Erro:' + GetWinInetError(GetLastError));
    end;

    if UseSSL then
    begin
      case SSLType of
        LT_SSLv2:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_SSL2;
        LT_SSLv3:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_SSL3;
        LT_TLSv1:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1;
        LT_TLSv1_1:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_1;
        LT_TLSv1_2:
          flags := WINHTTP_FLAG_SECURE_PROTOCOL_TLS1_2;
      else
        flags := WINHTTP_FLAG_SECURE_PROTOCOL_ALL;
      end;

      flagsLen := SizeOf(flags);
      CheckNotAborted;
      if not WinHttpSetOption(fSession, WINHTTP_OPTION_SECURE_PROTOCOLS, @flags, flagsLen) then
        raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_SECURE_PROTOCOLS. Erro:' + GetWinInetError(GetLastError));
    end;

    if APort = '' then
    begin
      if (UseSSL) then
        ConnectPort := INTERNET_DEFAULT_HTTPS_PORT
      else
        ConnectPort := INTERNET_DEFAULT_HTTP_PORT;
    end
    else
      ConnectPort := StrToInt(APort);

    //Debug, TimeOut Test
    //AHost := 'www.google.com';
    //port := 81;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo Conex�o: '+AHost+':'+APort);
    {$EndIf}
    CheckNotAborted;
    fConnection := WinHttpConnect( fSession,
                                   LPCWSTR(WideString(AHost)),
                                   ConnectPort,
                                   0);
    UpdateErrorCodes(Nil);
    CheckNotAborted;
    if not Assigned(fConnection) then
      raise EACBrWinReqResp.Create('Falha ao conectar no Host. Erro:' + GetWinInetError(GetLastError));

    if UseSSL then
      RequestFlags := WINHTTP_FLAG_SECURE
    else
      RequestFlags := 0;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo POST: '+AURI);
    {$EndIf}
    CheckNotAborted;
    fRequest := WinHttpOpenRequest( fConnection,
                                    LPCWSTR(WideString(Method)),
                                    LPCWSTR(WideString(AURI)),
                                    Nil,
                                    WINHTTP_NO_REFERER,
                                    WINHTTP_DEFAULT_ACCEPT_TYPES,
                                    RequestFlags);
    UpdateErrorCodes(fRequest);

    if not Assigned(fRequest) then
      raise EACBrWinReqResp.Create('Falha ao fazer requisi��o POST. Erro:' + GetWinInetError(GetLastError));

    if (UseCertificate) then
    begin
      CheckNotAborted;
      if not WinHttpSetOption(fRequest, WINHTTP_OPTION_CLIENT_CERT_CONTEXT,
                               CertContext, SizeOf(CERT_CONTEXT)) then
        raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_CLIENT_CERT_CONTEXT. Erro:' + GetWinInetError(GetLastError))
    end;

    // Ignorando alguns erros de conex�o //
    flags := 0;
    flagsLen := SizeOf(flags);
    CheckNotAborted;
    if not WinHttpQueryOption(fRequest, WINHTTP_OPTION_SECURITY_FLAGS, @flags, @flagsLen) then
      raise EACBrWinReqResp.Create('Falha lendo WINHTTP_OPTION_SECURITY_FLAGS. Erro:' + GetWinInetError(GetLastError));

    flags := flags or SECURITY_FLAG_IGNORE_UNKNOWN_CA or
                      SECURITY_FLAG_IGNORE_CERT_WRONG_USAGE or
                      SECURITY_FLAG_IGNORE_CERT_CN_INVALID or
                      SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;
    CheckNotAborted;
    if not WinHttpSetOption(fRequest, WINHTTP_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
      raise EACBrWinReqResp.Create('Falha ajustando WINHTTP_OPTION_SECURITY_FLAGS. Erro:' + GetWinInetError(GetLastError));

    if EncodeDataToUTF8 then
      Self.Data := UTF8Encode(Self.Data);

    if ( (APort <> IntToStr(INTERNET_DEFAULT_HTTP_PORT)) and (not UseSSL) ) or
       ( (APort <> IntToStr(INTERNET_DEFAULT_HTTPS_PORT)) and (UseSSL) ) then
      AHost := AHost +':'+ APort;

    AHeader := 'Host: ' + AHost + sLineBreak +
              'Content-Type: ' + MimeType + '; charset='+Charsets + SLineBreak +
              'Accept-Charset: ' + Charsets + SLineBreak;

    if Self.SOAPAction <> '' then
      AHeader := AHeader +'SOAPAction: "' + Self.SOAPAction + '"' +SLineBreak;

    wHeader := WideString(AHeader);

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo Requisi��o: '+AURI);
     WriteToTXT(LogFile, AHeader);
    {$EndIf}
    Resp.Size := 0;
    CheckNotAborted;
    if not WinHttpSendRequest( fRequest,
                               LPCWSTR(wHeader), Length(wHeader),
                               WINHTTP_NO_REQUEST_DATA, 0,
                               Length(Self.Data), 0) then
    begin
      UpdateErrorCodes(fRequest);
      raise EACBrWinReqResp.Create('Falha no Envio da Requisi��o.'+sLineBreak+
                                   GetWinInetError(FpInternalErrorCode));
    end;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Escrevendo Dados.');
     WriteToTXT(LogFile, Self.Data);
    {$EndIf}
    BytesWrite := 0;
    CheckNotAborted;
    if (Length(Self.Data) > 0) and not WinHttpWriteData(fRequest, PAnsiChar(Self.Data), Length(Self.Data), @BytesWrite) then
    begin
      UpdateErrorCodes(fRequest);
      raise EACBrWinReqResp.Create('Falha Enviando Dados. Erro:' + GetWinInetError(FpInternalErrorCode));
    end;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Lendo Dados');
    {$EndIf}
    CheckNotAborted;
    if not WinHttpReceiveResponse(fRequest, nil) then
    begin
      UpdateErrorCodes(fRequest);
      raise EACBrWinReqResp.Create('Falha Recebendo Dados. Erro:' + GetWinInetError(FpInternalErrorCode));
    end;

    repeat
      BytesRead := 0;
      CheckNotAborted;
      if not WinHttpReadData(fRequest, @aBuffer, SizeOf(aBuffer), @BytesRead) then
      begin
        UpdateErrorCodes(fRequest);
        raise EACBrWinReqResp.Create('Falha Lendo dados. Erro:' + GetWinInetError(FpInternalErrorCode));
      end;

      {$IfDef DEBUG_WINHTTP}
       WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Bytes Lido: '+IntToStr(BytesRead));
      {$EndIf}
      if (BytesRead > 0) then
        Resp.Write(aBuffer, BytesRead);
    until (BytesRead <= 0);

    UpdateErrorCodes(fRequest);

    if Resp.Size > 0 then
    begin
      Resp.Position := 0;
      {$IfDef DEBUG_WINHTTP}
       WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Total Lido: '+IntToStr(Resp.Size));
       Resp.Position := 0;
       Data := ReadStrFromStream(Resp, Resp.Size);
       Resp.Position := 0;
       WriteToTXT(LogFile, Data);
      {$EndIf}
    end;

    {$IfDef DEBUG_WINHTTP}
     WriteToTXT(LogFile, FormatDateTime('hh:nn:ss:zzz', Now)+
        ' - Erro WinHTTP: '+IntToStr(InternalErrorCode)+' HTTP: '+IntToStr(HTTPResultCode));
    {$EndIf}
  finally
    CloseConnection;
  end;
end;

procedure TACBrWinHTTPReqResp.Abortar;
begin
  CloseConnection;
end;

{$Else}
implementation

{$EndIf}

end.


