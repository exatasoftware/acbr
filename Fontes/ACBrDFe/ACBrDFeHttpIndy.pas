{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andr� Ferreira de Moraes                        }
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

unit ACBrDFeHttpIndy;

interface

uses
  Classes, SysUtils,
  {$IF CompilerVersion >= 33}System.Net.HttpClient,{$IFEND}
  ACBrDFeSSL,
  SoapHTTPClient, SOAPHTTPTrans;

const
  INTERNET_OPTION_CLIENT_CERT_CONTEXT = 84;

type
  { TDFeDelphiSoap }

  TDFeHttpIndy = class(TDFeSSLHttpClass)
  private
    FIndyReqResp: THTTPReqResp;
    FMimeType: String;
  {$IF CompilerVersion >= 33}
    procedure OnBeforePost(const HTTPReqResp: THTTPReqResp; Client: THTTPClient);
  {$ELSE}
    procedure OnBeforePost(const HTTPReqResp: THTTPReqResp; Data: Pointer);
  {$IFEND}
  protected
    function GetHTTPResultCode: Integer; override;
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
  strutils, WinInet, SOAPConst,
  ACBr_WinCrypt, ACBrDFeException, ACBRConsts,
  synautil;

{ TDFeDelphiSoap }

constructor TDFeHttpIndy.Create(ADFeSSL: TDFeSSL);
begin
  inherited Create(ADFeSSL);

  FIndyReqResp := THTTPReqResp.Create(nil);
end;

destructor TDFeHttpIndy.Destroy;
begin
  FIndyReqResp.Free;

  inherited Destroy;
end;

function TDFeHttpIndy.Enviar(const ConteudoXML, AURL, ASoapAction: String;
  const AMimeType: String): String;
var
  Resp: TMemoryStream;
begin
  Result := '';

  ConfigurarHTTP(AURL, ASoapAction, AMimeType);

  Resp := TMemoryStream.Create;
  try
    try
      // Enviando, dispara exceptions no caso de erro //
      FIndyReqResp.Execute(ConteudoXML, Resp);
    except
      On E: Exception do
      begin
        raise EACBrDFeException.Create( Format( cACBrDFeSSLEnviarException,
                                        [InternalErrorCode, HTTPResultCode, AURL] ) + sLineBreak +
                                        E.Message ) ;
      end;
    end;

    Resp.Position := 0;
    Result := ReadStrFromStream(Resp, Resp.Size);
    // DEBUG //
    //Resp.SaveToFile('c:\temp\ReqResp.xml');
  finally
    Resp.Free;
  end;
end;

procedure TDFeHttpIndy.Abortar;
begin
  FreeAndNil( FIndyReqResp );
  FIndyReqResp := THTTPReqResp.Create(nil);
end;

procedure TDFeHttpIndy.ConfigurarHTTP(const AURL, ASoapAction: String;
  const AMimeType: String);
begin
  with FpDFeSSL do
  begin
    if ProxyHost <> '' then
    begin
      FIndyReqResp.Proxy := ProxyHost + ':' + ProxyPort;
      FIndyReqResp.UserName := ProxyUser;
      FIndyReqResp.Password := ProxyPass;
    end;

    FIndyReqResp.ConnectTimeout := TimeOut;
  {$IF CompilerVersion >= 33}
    //NOTA: N�o existe a propriedade SendTimeout em Soap.SOAPHTTPTrans (Delphi 10.3.1)
    //No Delphi 10.3 SendTimeout = ReceiveTimeout
    FIndyReqResp.ReceiveTimeout := TimeOut;
  {$ELSE}
    FIndyReqResp.SendTimeout    := TimeOut;
    FIndyReqResp.ReceiveTimeout := TimeOut;
  {$IFEND}
  end;

  FMimeType := AMimeType;

  FIndyReqResp.OnBeforePost := OnBeforePost;
  FIndyReqResp.UseUTF8InHeader := True;
  FIndyReqResp.SoapAction := ASoapAction;
  FIndyReqResp.URL := AURL;
end;

{$IF CompilerVersion >= 33}
//Client: THTTPClient requer a unit System.Net.HttpClient
procedure TDFeHttpIndy.OnBeforePost(const HTTPReqResp: THTTPReqResp;
  Client: THTTPClient);
var
  ContentHeader: String;
begin
  with FpDFeSSL do
  begin
    if (UseCertificateHTTP) then
    begin
      if not InternetSetOption(Client, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
        FpDFeSSL.CertContextWinApi, SizeOf(CERT_CONTEXT)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_CLIENT_CERT_CONTEXT: ' +
                                       IntToStr(GetLastError));
    end;

    if trim(ProxyUser) <> '' then
      if not InternetSetOption(Client, INTERNET_OPTION_PROXY_USERNAME,
        PChar(ProxyUser), Length(ProxyUser)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_USERNAME: ' +
                                       IntToStr(GetLastError));

    if trim(ProxyPass) <> '' then
      if not InternetSetOption(Client, INTERNET_OPTION_PROXY_PASSWORD,
        PChar(ProxyPass), Length(ProxyPass)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_PASSWORD: ' +
                                       IntToStr(GetLastError));

    ContentHeader := Format(ContentTypeTemplate, [FMimeType]);
    HttpAddRequestHeaders(Client, PChar(ContentHeader), Length(ContentHeader),
                            HTTP_ADDREQ_FLAG_REPLACE);
  end;

  //N�o existe este m�todo CheckContentType em Soap.SOAPHTTPTrans (D10.3.1)
  //FIndyReqResp.CheckContentType;
end;

{$ELSE}

procedure TDFeHttpIndy.OnBeforePost(const HTTPReqResp: THTTPReqResp;
  Data: Pointer);
var
  ContentHeader: String;
begin
  with FpDFeSSL do
  begin
    if (UseCertificateHTTP) then
    begin
      if not InternetSetOption(Data, INTERNET_OPTION_CLIENT_CERT_CONTEXT,
        FpDFeSSL.CertContextWinApi, SizeOf(CERT_CONTEXT)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_CLIENT_CERT_CONTEXT: ' +
                                       IntToStr(GetLastError));
    end;

    if trim(ProxyUser) <> '' then
      if not InternetSetOption(Data, INTERNET_OPTION_PROXY_USERNAME,
        PChar(ProxyUser), Length(ProxyUser)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_USERNAME: ' +
                                       IntToStr(GetLastError));

    if trim(ProxyPass) <> '' then
      if not InternetSetOption(Data, INTERNET_OPTION_PROXY_PASSWORD,
        PChar(ProxyPass), Length(ProxyPass)) then
        raise EACBrDFeException.Create('Erro ao ajustar INTERNET_OPTION_PROXY_PASSWORD: ' +
                                       IntToStr(GetLastError));

    ContentHeader := Format(ContentTypeTemplate, [FMimeType]);
    HttpAddRequestHeaders(Data, PChar(ContentHeader), Length(ContentHeader),
                            HTTP_ADDREQ_FLAG_REPLACE);
  end;

  FIndyReqResp.CheckContentType;
end;
{$IFEND}


function TDFeHttpIndy.GetHTTPResultCode: Integer;
begin
  Result := GetLastError;
end;

end.

