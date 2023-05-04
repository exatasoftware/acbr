{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jos� M S Junior, Victor Hugo Gonzales          }
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
unit ACBrBoletoWS.Rest;

interface

uses
  httpsend,
  ACBrJSON,
  SysUtils,
  DateUtils,
  Classes,
  ACBrBoletoConversao,
  pcnConversao,
  ACBrBoletoWS,
  ACBrBoleto;

type
{ TBoletoWSREST }   //Implementar Bancos que utilizam JSON
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TBoletoWSREST = class(TBoletoWSClass)
  private

  protected
    FPURL           : String;
    FPContentType   : String;
    FPKeyUser       : String;
    FPIdentificador : String;
    FPAccept        : String;
    FPAuthorization : String;
    FMetodoHTTP     : TMetodoHTTP;
    FParamsOAuth    : String;
    FPHeaders       : TStringList;
    procedure setDefinirAccept(const AValue: String);
    procedure setMetodoHTTP(const AValue: TMetodoHTTP);
    procedure DefinirAuthorization; virtual;
    procedure DefinirContentType; virtual;
    procedure DefinirURL; virtual;
    procedure DefinirCertificado;
    procedure DefinirProxy;

    procedure GerarHeader; virtual;
    procedure GerarDados; virtual;

    function GerarTokenAutenticacao: String; virtual;
    function GerarRemessa: String; override;
    function Enviar: Boolean; override;
    procedure DefinirParamOAuth; virtual;
    procedure Executar;

  public
    constructor Create(ABoletoWS: TBoletoWS); override;
    destructor Destroy; override;

  end;

  { TRetornoEnvioREST }  //Implementar Retornos em JSON
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TRetornoEnvioREST = class(TRetornoEnvioClass)
  private

  protected
    //FSucessResponse: Boolean;
    function RetornoEnvio(const AIndex: Integer): Boolean; Override;

  public
    constructor Create(ABoletoWS: TACBrBoleto); Override;

  end;


implementation
uses
  ACBrUtil.Strings,
  ACBrBoletoWS.Rest.OAuth,
  ACBrUtil.Base,
  synautil,
  synacode,
  StrUtils;

{ TRetornoEnvioREST }

constructor TRetornoEnvioREST.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
  //FSucessResponse:= False;
end;

function TRetornoEnvioREST.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  if (ACBrBoleto.ListadeBoletos.Count > 0) and (ACBrBoleto.Configuracoes.WebService.Operacao <> tpConsulta) then
  begin
    Result:= LerRetorno(ACBrBoleto.ListadeBoletos[AIndex].RetornoWeb);
    ACBrBoleto.ListadeBoletos[AIndex].QrCode; //GetQRCode valida campos no titulo
  end
  else
    Result:= LerListaRetorno;

end;

{ TBoletoWSREST }

procedure TBoletoWSREST.DefinirCertificado;
begin
  BoletoWS.ArquivoCRT := Boleto.Configuracoes.WebService.ArquivoCRT;
  BoletoWS.ArquivoKEY := Boleto.Configuracoes.WebService.ArquivoKEY;

  // Adicionando o Certificado
  if NaoEstaVazio(BoletoWS.ArquivoCRT) then
    HTTPSend.Sock.SSL.CertificateFile := BoletoWS.ArquivoCRT;

  if NaoEstaVazio(BoletoWS.ArquivoKEY) then
    HTTPSend.Sock.SSL.PrivateKeyFile := BoletoWS.ArquivoKEY;
end;

procedure TBoletoWSREST.DefinirContentType;
begin
  if FPContentType = '' then
    FPContentType:= S_CONTENT_TYPE;
end;

procedure TBoletoWSREST.DefinirParamOAuth;
begin
  DefinirCertificado;
  FParamsOAuth := C_GRANT_TYPE
                 + '=' + OAuth.GrantType
                 + '&' + C_SCOPE
                 + '=' + OAuth.Scope;
end;

procedure TBoletoWSREST.DefinirProxy;
begin
  HTTPSend.ProxyHost := BoletoWS.ProxyHost;
  HTTPSend.ProxyPort := BoletoWS.ProxyPort;
  HTTPSend.ProxyUser := BoletoWS.ProxyUser;
  HTTPSend.ProxyPass := BoletoWS.ProxyPass;

  if (BoletoWS.TimeOut <> 0) then
    HTTPSend.Timeout := BoletoWS.TimeOut;
end;

procedure TBoletoWSREST.setDefinirAccept(const AValue: String);
begin
  if AValue <> '' then
    FPAccept := AValue;
end;

procedure TBoletoWSREST.setMetodoHTTP(const AValue: TMetodoHTTP);
begin
  FMetodoHTTP := AValue;
end;

procedure TBoletoWSREST.DefinirURL;
begin
  raise EACBrBoletoWSException.Create(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_DEFINIR_URL] ));
end;

destructor TBoletoWSREST.Destroy;
begin
  FPHeaders.Free;
  inherited;
end;

procedure TBoletoWSREST.GerarHeader;
begin
  raise EACBrBoletoWSException.Create(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_GERAR_HEADER] ));
end;

procedure TBoletoWSREST.GerarDados;
begin
  raise EACBrBoletoWSException.Create(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_GERAR_DADOS] ));
end;

procedure TBoletoWSREST.DefinirAuthorization;
begin
  raise EACBrBoletoWSException.Create(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_AUTHORIZATION] ));
end;

function TBoletoWSREST.GerarTokenAutenticacao: String;
begin
  Result:= '';
  if Assigned(OAuth) then
  begin
    BoletoWS.DoLog('Autenticando Token... ');
    DefinirParamOAuth;
    OAuth.ParamsOAuth := FParamsOAuth;
    if OAuth.GerarToken then
      Result := OAuth.Token
    else
      BoletoWS.DoLog( Format( S_ERRO_GERAR_TOKEN_AUTENTICACAO, [OAuth.ErroComunicacao] ) );
  end;
end;

procedure TBoletoWSREST.Executar;
var
  LHeaders : TStringList;
  LStream : TStringStream;
begin
  LStream  := TStringStream.Create('');
  LHeaders := TStringList.Create;
  try
    HTTPSend.OutputStream := LStream;
    HTTPSend.Headers.Clear;

     if FPAccept <> '' then
      LHeaders.Add(C_ACCEPT  + ': ' + FPAccept);

    if FPAuthorization <> '' then
      LHeaders.Add(FPAuthorization);

    if FPKeyUser <> '' then
      LHeaders.Add(FPKeyUser);

    if FPIdentificador <> '' then
      LHeaders.Add(FPIdentificador);

    //if FPContentType <> '' then
    //  LHeaders.Add(C_CONTENT_TYPE +': '+ FPContentType);

    HTTPSend.Headers.AddStrings(LHeaders);

    if FPHeaders.Count > 0 then
      HTTPSend.Headers.AddStrings(FPHeaders);

    HTTPSend.MimeType := FPContentType;
  finally
    LHeaders.Free;
  end;
  HTTPSend.Document.Clear;
  try
    HTTPSend.Document.Position:= 0;
    if FPDadosMsg <> '' then
      WriteStrToStream(HTTPSend.Document, AnsiString(FPDadosMsg));
    HTTPSend.HTTPMethod(MetodoHTTPToStr(FMetodoHTTP), FPURL );
  finally
    HTTPSend.Document.Position:= 0;
    FRetornoWS:= String(UTF8Decode(LStream.DataString));
    BoletoWS.RetornoBanco.CodRetorno     := HTTPSend.Sock.LastError;

    try
//      LStream.CopyFrom(HTTPSend.Document,0);
      BoletoWS.RetornoBanco.Msg            := Trim('HTTP_Code='+ IntToStr(HTTPSend.ResultCode)+' '+ HTTPSend.ResultString+' '+LStream.DataString);
      BoletoWS.RetornoBanco.HTTPResultCode := HTTPSend.ResultCode;
    finally
      LStream.Free;
    end;
  end;
end;

constructor TBoletoWSREST.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);
  FTipoRegistro   := C_JSON;
  FMetodoHTTP     := htPOST;
  FPContentType   := '';
  FPAccept        := '';
  FPDadosMsg      := '';
  FPURL           := '';
  FPAuthorization := '';
  FPKeyUser       := '';
  FPIdentificador := '';
  FPHeaders := TStringList.Create;
end;

function TBoletoWSREST.GerarRemessa: String;
begin
  Result := '';
  HTTPSend.Headers.Clear;
  //Gera o Header, para REST
  GerarHeader;
  //Gera o Json, implementado na classe do Banco selecionado
  GerarDados;

  Result := FPDadosMsg;
end;

function TBoletoWSREST.Enviar: Boolean;
begin
  BoletoWS.RetornoBanco.CodRetorno := 0;
  BoletoWS.RetornoBanco.Msg        := '';

  DefinirAuthorization;
  DefinirURL;
  DefinirContentType;
  DefinirCertificado;
  DefinirProxy;

  //Grava json gerado
  BoletoWS.DoLog('Comando Enviar: ' + FPDadosMsg);

  try
    Executar;
  finally
    Result := (BoletoWS.RetornoBanco.HTTPResultCode in [200..207]);

    if Result then //Grava retorno
      BoletoWS.DoLog('Retorno Envio: ' + FRetornoWS)
    else
      BoletoWS.DoLog('Retorno Envio: ' +'HTTPCode=' + IntToStr(BoletoWS.RetornoBanco.HTTPResultCode)
                                        + IfThen(BoletoWS.RetornoBanco.CodRetorno > 0, sLineBreak + 'ErrorCode=' + IntToStr(BoletoWS.RetornoBanco.CodRetorno),'')
                                        + sLineBreak +'Result=' + NativeStringToAnsi(FRetornoWS));
  end;

end;

end.
