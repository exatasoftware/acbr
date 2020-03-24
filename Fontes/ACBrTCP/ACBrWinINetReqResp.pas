{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Classe para Lazarus/Free Pascal e Delphi para requisi��es SOAP com suporte  }
{ certificados A1 e A3 usando as bibliotecas WinINet e CAPICOM                 }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jean Patrick Figueiredo dos Santos,            }
{                               Andr� Ferreira de Moraes                       }
{                               Juliomar Marchetti                             }
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

unit ACBrWinINetReqResp;

interface

{$IfDef MSWINDOWS}
uses
  {$IFDEF DELPHIXE4_UP}
  AnsiStrings,
  {$ENDIF}
  Windows, Classes, SysUtils, wininet,
  ACBrWinReqRespClass,
  ACBr_WinCrypt;

const
  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;

type

  { TACBrWinINetReqResp }

  TACBrWinINetReqResp = class(TACBrWinReqResp)
  private
    fSession, fConnection, fRequest: HINTERNET;
  protected
    procedure UpdateErrorCodes(ARequest: HINTERNET); override;
    procedure CheckNotAborted;
    procedure CloseConnection;
  public
    constructor Create;
    procedure Execute(Resp: TStream); override;
    procedure Abortar; override;
  end;

implementation

uses synautil;

{ TACBrWinINetReqResp }

procedure TACBrWinINetReqResp.UpdateErrorCodes(ARequest: HINTERNET);
Var
  dummy, AStatusCode, ASize: DWORD;
begin
  FpInternalErrorCode := GetLastError;
  FpHTTPResultCode := 0;

  if Assigned(ARequest) then
  begin
    dummy := 0;
    AStatusCode := 0;
    ASize := SizeOf(DWORD);
    if HttpQueryInfo( ARequest,
                      HTTP_QUERY_STATUS_CODE or HTTP_QUERY_FLAG_NUMBER,
                      @AStatusCode, ASize,
                      dummy ) then
    begin
      FpHTTPResultCode := AStatusCode;
    end;
  end;
end;

procedure TACBrWinINetReqResp.CheckNotAborted;
begin
  if not Assigned(fSession) then
    raise EACBrWinReqResp.Create('Conex�o foi abortada');
end;

procedure TACBrWinINetReqResp.CloseConnection;
begin
  if Assigned(fRequest) then
  begin
    InternetCloseHandle(fRequest);
    fRequest := Nil
  end;

  if Assigned(fConnection) then
  begin
    InternetCloseHandle(fConnection);
    fConnection := Nil
  end;

  if Assigned(fSession) then
  begin
    InternetCloseHandle(fSession);
    fSession := Nil
  end;
end;

constructor TACBrWinINetReqResp.Create;
begin
  inherited;

  fSession := Nil;
  fConnection := Nil;
  fRequest := Nil;
end;

procedure TACBrWinINetReqResp.Execute(Resp: TStream);
var
  aBuffer: array[0..4096] of AnsiChar;
  BytesRead: cardinal;
  flags, flagsLen: longword;
  Ok, UseSSL, UseCertificate: Boolean;
  AccessType: Integer;
  ANone, AURI, AHost, AProt, APort, pProxy, Header: String;
begin

  AURI  := '';
  AProt := '';
  AHost := '';
  APort := '';
  ANone := '';

  AURI := ParseURL(Url, AProt, ANone, ANone, AHost, APort, ANone, ANone);

  UseSSL := (UpperCase(AProt) = 'HTTPS');
  UseCertificate := UseSSL and Assigned( CertContext );

  if ProxyHost <> '' then
  begin
    AccessType := INTERNET_OPEN_TYPE_PROXY;
    if (ProxyPort <> '') and (ProxyPort <> '0') then
      pProxy := ProxyHost + ':' + ProxyPort
    else
      pProxy := ProxyHost;
  end
  else
    AccessType := INTERNET_OPEN_TYPE_PRECONFIG;

  //DEBUG
  //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo sess�o');

  fSession := InternetOpen(PChar('Borland SOAP 1.2'), AccessType, PChar(pProxy), nil, 0);
  fConnection := Nil;
  fRequest := Nil;

  try
    if not Assigned(fSession) then
      raise EACBrWinReqResp.Create('Erro: Internet Open or Proxy');

    if TimeOut > 0 then
    begin
      //DEBUG
      //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Ajustando TimeOut: '+IntToStr(FTimeOut));

      CheckNotAborted;
      if not InternetSetOption(fSession, INTERNET_OPTION_CONNECT_TIMEOUT, @TimeOut, SizeOf(TimeOut)) then
        raise EACBrWinReqResp.Create('Erro ao definir TimeOut de Conex�o');

      CheckNotAborted;
      if not InternetSetOption(fSession, INTERNET_OPTION_SEND_TIMEOUT, @TimeOut, SizeOf(TimeOut)) then
        raise EACBrWinReqResp.Create('Erro ao definir TimeOut de Conex�o');

      CheckNotAborted;
      if not InternetSetOption(fSession, INTERNET_OPTION_RECEIVE_TIMEOUT, @TimeOut, SizeOf(TimeOut)) then
        raise EACBrWinReqResp.Create('Erro ao definir TimeOut de Conex�o');
    end;

    if APort = '' then
    begin
      if (UseSSL) then
        APort := IntToStr(INTERNET_DEFAULT_HTTPS_PORT)
      else
        APort := IntToStr(INTERNET_DEFAULT_HTTP_PORT);
    end;

    //Debug, TimeOut Test
    //AHost := 'www.google.com';
    //port := 81;

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Abrindo Conex�o: '+AHost+':'+APort);

    CheckNotAborted;
    fConnection := InternetConnect(fSession, PChar(AHost), StrToInt(APort),
                                   PChar(ProxyUser), PChar(ProxyPass),
                                   INTERNET_SERVICE_HTTP,
                                   0, 0{cardinal(Self)});
    if not Assigned(fConnection) then
      raise EACBrWinReqResp.Create('Erro: Internet Connect or Host');

    if (UseSSL) then
    begin
      flags := INTERNET_FLAG_KEEP_CONNECTION or INTERNET_FLAG_NO_CACHE_WRITE;
      flags := flags or INTERNET_FLAG_SECURE;

      if (UseCertificate) then
        flags := flags or (INTERNET_FLAG_IGNORE_CERT_CN_INVALID or
                           INTERNET_FLAG_IGNORE_CERT_DATE_INVALID);
    end
    else
      flags := INTERNET_SERVICE_HTTP;

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Fazendo POST: '+AURI);

    CheckNotAborted;
    fRequest := HttpOpenRequest(fConnection, PChar('POST'),
                                PChar(AURI), nil, nil, nil, flags, 0);

    if not Assigned(fRequest) then
      raise EACBrWinReqResp.Create('Erro: Open Request');

    UpdateErrorCodes(fRequest);

    if ( (APort <> IntToStr(INTERNET_DEFAULT_HTTP_PORT)) and (not UseSSL) ) or
       ( (APort <> IntToStr(INTERNET_DEFAULT_HTTPS_PORT)) and (UseSSL) ) then
      AHost := AHost +':'+ APort;

    Header := 'Host: ' + AHost + sLineBreak +
              'Content-Type: ' + MimeType + '; charset='+Charsets + SLineBreak +
              'Accept-Charset: ' + Charsets + SLineBreak;

    if SOAPAction <> '' then
      Header := Header +'SOAPAction: "' + SOAPAction + '"' +SLineBreak;

    if (UseCertificate) then
    begin
      CheckNotAborted;
      if not InternetSetOption(fRequest, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
                               CertContext, SizeOf(CERT_CONTEXT)) then
        raise EACBrWinReqResp.Create('Erro: Problema ao inserir o certificado')
    end;

    flags := 0;
    flagsLen := SizeOf(flags);
    CheckNotAborted;
    if not InternetQueryOption(fRequest, INTERNET_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
      raise EACBrWinReqResp.Create('InternetQueryOption erro ao ler wininet flags.' + GetWininetError(GetLastError));

    flags := flags or SECURITY_FLAG_IGNORE_REVOCATION or
                      SECURITY_FLAG_IGNORE_UNKNOWN_CA or
                      SECURITY_FLAG_IGNORE_CERT_CN_INVALID or
                      SECURITY_FLAG_IGNORE_CERT_DATE_INVALID or
                      SECURITY_FLAG_IGNORE_WRONG_USAGE;
    CheckNotAborted;
    if not InternetSetOption(fRequest, INTERNET_OPTION_SECURITY_FLAGS, @flags, flagsLen) then
      raise EACBrWinReqResp.Create('InternetQueryOption erro ao ajustar INTERNET_OPTION_SECURITY_FLAGS' + GetWininetError(GetLastError));

    if trim(ProxyUser) <> '' then
    begin
      CheckNotAborted;
      if not InternetSetOption(fRequest, INTERNET_OPTION_PROXY_USERNAME,
                               PChar(ProxyUser), Length(ProxyUser)) then
        raise EACBrWinReqResp.Create('Erro: Proxy User');

      if trim(ProxyPass) <> '' then
      begin
        CheckNotAborted;
        if not InternetSetOption(fRequest, INTERNET_OPTION_PROXY_PASSWORD,
                                 PChar(ProxyPass), Length(ProxyPass)) then
          raise EACBrWinReqResp.Create('Erro: Proxy Password');
      end;
    end;

    CheckNotAborted;
    HttpAddRequestHeaders(fRequest, PChar(Header), Length(Header), HTTP_ADDREQ_FLAG_ADD);

    if EncodeDataToUTF8 then
      Data := UTF8Encode(Data);

    //DEBUG
    //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Enviando Dados: '+AURI);
    //WriteToTXT('c:\temp\httpreqresp.log', FData);

    Ok := False;
    Resp.Size := 0;
    CheckNotAborted;
    if HttpSendRequest(fRequest, nil, 0, Pointer(Data), Length(Data)) then
    begin
      BytesRead := 0;
      //DEBUG
      //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Lendo Dados');

      CheckNotAborted;
      while InternetReadFile(fRequest, @aBuffer, SizeOf(aBuffer), BytesRead) do
      begin
        //DEBUG
        //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Bytes Lido: '+IntToStr(BytesRead));

        if (BytesRead = 0) then
          Break;

        Resp.Write(aBuffer, BytesRead);
      end;

      if Resp.Size > 0 then
      begin
        Resp.Position := 0;

        //DEBUG
        //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+ ' - Total Lido: '+IntToStr(Resp.Size));
        //Resp.Position := 0;
        //FData := ReadStrFromStream(Resp, Resp.Size);
        //Resp.Position := 0;
        //WriteToTXT('c:\temp\httpreqresp.log', FData);

        Ok := True;
      end;
    end;

    UpdateErrorCodes(fRequest);

    if not OK then
    begin
      //DEBUG
      //WriteToTXT('c:\temp\httpreqresp.log', FormatDateTime('hh:nn:ss:zzz', Now)+
      //   ' - Erro WinNetAPI: '+IntToStr(InternalErrorCode)+' HTTP: '+IntToStr(HTTPResultCode));

      raise EACBrWinReqResp.Create('Erro: Requisi��o n�o enviada.' + sLineBreak +
                                    GetWinInetError(InternalErrorCode));
    end;
 finally
   CloseConnection
 end;
end;

procedure TACBrWinINetReqResp.Abortar;
begin
 CloseConnection;
end;

{$Else}
implementation

{$EndIf}

end.
