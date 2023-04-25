unit ACBrBoletoWS.Rest.OAuth;

interface

uses
  pcnConversao,
  httpsend,
  ACBrBoletoConversao;
type
  TpAuthorizationType = (atNoAuth,atBearer);
  { TOAuth }
  TOAuth = class
  private
    FURL             : String;
    FContentType     : String;
    FGrantType       : String;
    FScope           : String;
    FAmbiente        : TpcnTipoAmbiente;
    FClientID        : String;
    FClientSecret    : String;
    FToken           : String;
    FExpire          : TDateTime;
    FErroComunicacao : String;
    FPayload         : Boolean;
    FHTTPSend        : THTTPSend;
    FParamsOAuth : string;
    FAuthorizationType: TpAuthorizationType;
    FHeaderParamsList : Array of TParams;

    procedure setURL(const AValue: String);
    procedure setContentType(const AValue: String);
    procedure setGrantType(const AValue: String);
    procedure setPayload(const AValue: Boolean);


    function getURL: String;
    function getContentType: String;
    function getGrantType: String;
    function getClientID : String;
    function getClientSecret : String;
    function getScope : String;

    procedure ProcessarRespostaOAuth(const ARetorno: AnsiString);
    function Executar(const AAuthBase64: String): Boolean;
    procedure SetAuthorizationType(const Value: TpAuthorizationType);
  protected

  public
    constructor Create(ASSL: THTTPSend; ATipoAmbiente: TpcnTipoAmbiente; AClientID, AClientSecret, AScope: String; ACertificateCRT : string = ''; ACertificateKEY : String = ''  );
    destructor  Destroy; Override;
    property URL             : String           read getURL         write setURL;
    function GerarToken      : Boolean;
    property ParamsOAuth     : String           read FParamsOAuth   write FParamsOAuth;
    function AddHeaderParam(AParamName, AParamValue : String) : TOAuth;

    function ClearHeaderParams() : TOAuth;
    property ContentType     : String           read getContentType write setContentType;
    property GrantType       : String           read getGrantType   write setGrantType;
    property Scope           : String           read getScope;
    property ClientID        : String           read getClientID;
    property ClientSecret    : String           read getClientSecret;
    property Ambiente        : TpcnTipoAmbiente read FAmbiente default taHomologacao;
    property Expire          : TDateTime        read FExpire;
    property ErroComunicacao : String           read FErroComunicacao;
    property Token           : String           read FToken;
    property Payload         : Boolean          read FPayLoad       write setPayload;
    property AuthorizationType : TpAuthorizationType read FAuthorizationType write SetAuthorizationType;
  end;

implementation

uses
  SysUtils,
  ACBrUtil.Strings,
  ACBrUtil.Base,
  ACBrBoletoWS,
  ACBrJSON,
  DateUtils,
  Classes,
  synacode,
  synautil;


{ TOAuth }

procedure TOAuth.setURL(const AValue: String);
begin
  if FURL <> AValue then
    FURL := AValue;
end;

procedure TOAuth.setContentType(const AValue: String);
begin
  if FContentType <> AValue then
    FContentType := AValue;
end;

procedure TOAuth.setGrantType(const AValue: String);
begin
  if FGrantType <> AValue then
    FGrantType := AValue;

end;

procedure TOAuth.setPayload(const AValue: Boolean);
begin
  if FPayload <> AValue then
    FPayload := AValue;
end;

function TOAuth.getURL: String;
begin
  if FURL = '' then
    Raise Exception.Create(ACBrStr('M�todo de Autentica��o inv�lido. URL n�o definida!'))
  else
    Result := FURL;
end;

function TOAuth.getContentType: String;
begin
  if FContentType = '' then
    Result := 'application/x-www-form-urlencoded'
  else
    Result := FContentType;
end;

function TOAuth.getGrantType: String;
begin
  if FGrantType = '' then
    Result := 'client_credentials'
  else
    Result := FGrantType;
end;

function TOAuth.getClientID: String;
begin
  if FClientID = '' then
    Raise Exception.Create(ACBrStr('Client_ID n�o Informado'));

  Result := FClientID;
end;

function TOAuth.getClientSecret: String;
begin
  if FClientSecret = '' then
    Raise Exception.Create(ACBrStr('Client_Secret n�o Informado'));

  Result := FClientSecret;
end;

function TOAuth.getScope: String;
begin
  if FScope = '' then
    Raise Exception.Create(ACBrStr('Scope n�o Informado'));

  Result := FScope;
end;

procedure TOAuth.ProcessarRespostaOAuth(const ARetorno: AnsiString);
var
  LJson: TACBrJSONObject;
begin
  FToken           := '';
  FExpire          := 0;
  FErroComunicacao := '';
  try
    LJson := TACBrJSONObject.Parse(ARetorno);
    try
      if (FHTTPSend.ResultCode in [200..205]) then
      begin
        FToken := LJson.AsString['access_token'];
        try
          FExpire := Now + (LJson.AsInteger['expires_in'] * OneSecond);
        except
          FExpire:= 0;
        end;
      end
      else
      begin
        FErroComunicacao := 'HTTP_Code='+ IntToStr(FHTTPSend.ResultCode);
        if Assigned(LJson) then
          FErroComunicacao := FErroComunicacao
                              + ' Erro='
                              + LJson.AsString['error_description'];
      end;
    finally
      LJson.Free;
    end;
  except
    FErroComunicacao := 'HTTP_Code='
                        + IntToStr(FHTTPSend.ResultCode)
                        + ' Erro='
                        + ARetorno;
  end;
end;

procedure TOAuth.SetAuthorizationType(const Value: TpAuthorizationType);
begin
  FAuthorizationType := Value;
end;

function TOAuth.Executar(const AAuthBase64: String): Boolean;
var
  LHeaders : TStringList;
  I : Integer;
begin
  FErroComunicacao := '';

  if not Assigned(FHTTPSend) then
    raise EACBrBoletoWSException.Create(ClassName + Format( S_METODO_NAO_IMPLEMENTADO, [C_DFESSL] ));

  //Definindo Header da requisi��o OAuth
  FHTTPSend.Headers.Clear;
  LHeaders := TStringList.Create;
  try
    //LHeaders.Add(C_CONTENT_TYPE  + ': ' + ContentType);
    if Self.AuthorizationType = atBearer then
      LHeaders.Add(C_AUTHORIZATION + ': ' + AAuthBase64);
    //LHeaders.Add(C_CACHE_CONTROL + ': ' + C_NO_CACHE);
    for I := 0  to Length(FHeaderParamsList) -1 do
      LHeaders.Add(FHeaderParamsList[I].prName+': '+FHeaderParamsList[I].prValue);
    FHTTPSend.Headers.AddStrings(LHeaders);
  finally
    LHeaders.Free;
  end;

  FHTTPSend.MimeType := ContentType;

  try
    //Utiliza HTTPMethod para envio

    if FPayload then
    begin
      FHTTPSend.Document.Position:= 0;
      WriteStrToStream(FHTTPSend.Document, AnsiString(FParamsOAuth));
      FHTTPSend.HTTPMethod(MetodoHTTPToStr(htPOST), URL);
    end
    else
      FHTTPSend.HTTPMethod(MetodoHTTPToStr(htPOST), URL + '?' + FParamsOAuth);

    FHTTPSend.Document.Position:= 0;
    ProcessarRespostaOAuth( ReadStrFromStream(FHTTPSend.Document, FHTTPSend.Document.Size ) );
    Result := true;
  except
    on E: Exception do
    begin
      Result := False;
      FErroComunicacao := E.Message;
      raise EACBrBoletoWSException.Create(ACBrStr('Falha na Autentica��o: '+ E.Message));
    end;
  end;
end;

function TOAuth.AddHeaderParam(AParamName, AParamValue: String): TOAuth;
begin
  Result := Self;
  SetLength(FHeaderParamsList,Length(FHeaderParamsList)+1);
  FHeaderParamsList[Length(FHeaderParamsList)-1].prName := AParamName;
  FHeaderParamsList[Length(FHeaderParamsList)-1].prValue := AParamValue;
end;

function TOAuth.ClearHeaderParams: TOAuth;
begin
  SetLength(FHeaderParamsList,0);
end;

constructor TOAuth.Create(ASSL: THTTPSend; ATipoAmbiente: TpcnTipoAmbiente; AClientID, AClientSecret, AScope: String; ACertificateCRT : string = ''; ACertificateKEY : String = '' );
begin
  if Assigned(ASSL) then
    FHTTPSend := ASSL;

  // Adicionando o Certificado
  if NaoEstaVazio(ACertificateCRT) then
    FHTTPSend.Sock.SSL.CertificateFile := ACertificateCRT;

  if NaoEstaVazio(ACertificateKEY) then
    FHTTPSend.Sock.SSL.PrivateKeyFile := ACertificateKEY;
  FAmbiente        := ATipoAmbiente;
  FClientID        := AClientID;
  FClientSecret    := AClientSecret;
  FScope           := AScope;
  FURL             := '';
  FContentType     := '';
  FGrantType       := '';
  FToken           := '';
  FExpire          := 0;
  FErroComunicacao := '';
  FPayload         := False;
  FAuthorizationType := atBearer;
end;

destructor TOAuth.Destroy;
begin
  inherited Destroy;
end;

function TOAuth.GerarToken: Boolean;
begin

  if ( Token <> '' ) and ( CompareDateTime( Expire, Now ) = 1 ) then                                        //Token ja gerado e ainda v�lido
    Result := True
  else                                                                                                      //Converte Basic da Autentica��o em Base64
    Result := Executar( 'Basic ' + String(EncodeBase64(AnsiString(ClientID + ':' + ClientSecret))) );

end;
end.
