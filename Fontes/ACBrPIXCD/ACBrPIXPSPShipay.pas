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
  https://api-staging.shipay.com.br/docs.html

*)

{$I ACBr.inc}

unit ACBrPIXPSPShipay;

interface

uses
  Classes, SysUtils,
  ACBrPIXCD, ACBrShipaySchemas,
  ACBrPIXBase, ACBrPIXSchemasProblema;

const
  cShipayURLStaging = 'https://api-staging.shipay.com.br';
  cShipayURLProducao = 'https://api.shipay.com.br';
  cShipayEndPointAuth = '/pdvauth';
  cShipayEndPointRefreshToken = '/refresh-token';
  cShipayEndPointWallets = '/v1/wallets';
  cShipayEndPointOrder = '/order';
  cShipayEndPointOrders = '/orders';
  cShipayEndPointOrdersList = '/orders/list';
  cShipayEndPointOrderV = '/orderv';
  cShipayPathRefund = 'refund';
  cShipayWalletPix = 'pix';
  cShipayHeaderOrderType = 'x-shipay-order-type';
  cShipayEOrder = 'e-order';
  cItemTitleNotInformed = 'Item Vendido';

resourcestring
  sErrOrderIdDifferent = 'order_id diferente do informado';
  sErrOrderIdInvalid = 'order_id inv�lida: %s';
  sErrOrderRefNotInformed = '"order_ref" ou "txid" n�o informado';
  sErrNoWallet = 'Nenhuma Carteira associada a essa conta';

type

  TShipayQuandoEnviarOrder = procedure(ShipayOrder: TShipayOrder) of object;

  { TACBrPSPShipay }

  TACBrPSPShipay = class(TACBrPSP)
  private
    fAccessKey: String;
    fOrder: TShipayOrder;
    fOrderCreated: TShipayOrderCreated;
    fOrderInfo: TShipayOrderInfo;
    fOrderList: TShipayOrdersList;
    fQuandoEnviarOrder: TShipayQuandoEnviarOrder;
    fWallets: TShipayWalletArray;
    function GetSecretKey: String;
    procedure SetSecretKey(AValue: String);

    procedure ProcessarAutenticacao(const AURL: String; ResultCode: Integer;
      const RespostaHttp: AnsiString);
    procedure QuandoAcessarEndPoint(const AEndPoint: String;
      var AURL: String; var AMethod: String);
    procedure QuandoReceberRespostaEndPoint(const AEndPoint, AURL, AMethod: String;
      var AResultCode: Integer; var RespostaHttp: AnsiString);

    function ConverterJSONCobSolicitadaParaShipayOrder(const CobSolicitadaJSON: String;
      const TxId: String): String;
    function ConverterJSONOrderCreatedParaCobGerada(const OrderCreatedJSON: String): String;
    function ConverterJSONOrderInfoParaCobCompleta(const OrderInfoJSON: String): String;

    function ShiPayStatusToCobStatus(AShipayStatus: TShipayOrderStatus): TACBrPIXStatusCobranca;
  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;
    procedure TratarRetornoComErro(ResultCode: Integer; const RespostaHttp: AnsiString;
      Problema: TACBrPIXProblema); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; override;

    procedure Autenticar; override;
    procedure RenovarToken; override;

    procedure GetWallets;
    procedure PostOrder(IsEOrder: Boolean = False);
    function DeleteOrder(const order_id: String): Boolean;
    function RefundOrder(const order_id: String; ValorReembolso: Currency): Boolean;
    procedure GetOrderInfo(const order_id: String; Wallet: String = '');
    procedure GetOrdersList(start_date: TDateTime; end_date: TDateTime = 0;
      offset: Integer = 0; limit: Integer = 0);

    property Wallets: TShipayWalletArray read fWallets;
    property Order: TShipayOrder read fOrder;
    property OrderCreated: TShipayOrderCreated read fOrderCreated;
    property OrderInfo: TShipayOrderInfo read fOrderInfo;
    property OrderList: TShipayOrdersList read fOrderList;
  published
    property ClientID;
    property SecretKey: String read GetSecretKey write SetSecretKey;
    property AccessKey: String read fAccessKey write fAccessKey;

    property QuandoEnviarOrder: TShipayQuandoEnviarOrder read fQuandoEnviarOrder
      write fQuandoEnviarOrder;
  end;

implementation

uses
  StrUtils,
  synautil,
  ACBrUtil.DateTime, ACBrUtil.Strings, ACBrUtil.Base, ACBrUtil.FilesIO,
  ACBrPIXUtil, ACBrPIXSchemasCob, ACBrPIXBRCode,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr
  {$Else}
   Jsons
  {$EndIf},
  DateUtils;

{ TACBrPSPShipay }

constructor TACBrPSPShipay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fWallets := TShipayWalletArray.Create('wallets');
  fOrder := TShipayOrder.Create('');
  fOrderCreated := TShipayOrderCreated.Create('');
  fOrderInfo := TShipayOrderInfo.Create('');
  fOrderList := TShipayOrdersList.Create('');
  fAccessKey := '';
  fQuandoEnviarOrder := Nil;
  fpQuandoAcessarEndPoint := QuandoAcessarEndPoint;
  fpQuandoReceberRespostaEndPoint := QuandoReceberRespostaEndPoint;
end;

destructor TACBrPSPShipay.Destroy;
begin
  fWallets.Free;
  fOrder.Free;
  fOrderCreated.Free;
  fOrderInfo.Free;
  fOrderList.Free;
  inherited Destroy;
end;

procedure TACBrPSPShipay.Clear;
begin
  inherited Clear;
  fOrder.Clear;
  fOrderCreated.Clear;
  fOrderInfo.Clear;
  fOrderList.Clear;
end;

function TACBrPSPShipay.GetSecretKey: String;
begin
   Result := ClientSecret;
end;

procedure TACBrPSPShipay.SetSecretKey(AValue: String);
begin
  ClientSecret := AValue;
end;

procedure TACBrPSPShipay.Autenticar;
var
  AURL, Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  js: TJsonObject;
begin
  LimparHTTP;
  AURL := ObterURLAmbiente( ACBrPixCD.Ambiente ) + cShipayEndPointAuth;

  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
   try
     js.S['access_key'] := AccessKey;
     js.S['secret_key'] := SecretKey;
     js.S['client_id'] := ClientID;
     Body := js.ToJSON();
   finally
     js.Free;
   end;
  {$Else}
   js := TJsonObject.Create;
   try
     js['access_key'].AsString := AccessKey;
     js['secret_key'].AsString := SecretKey;
     js['client_id'].AsString := ClientID;
     Body := js.Stringify;
   finally
     js.Free;
   end;
  {$EndIf}

  WriteStrToStream(Http.Document, Body);
  Http.MimeType := CContentTypeApplicationJSon;
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);
  ProcessarAutenticacao(AURL, ResultCode, RespostaHttp);
end;

procedure TACBrPSPShipay.RenovarToken;
var
  AURL: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  LimparHTTP;
  AURL := ObterURLAmbiente( ACBrPixCD.Ambiente ) + cShipayEndPointRefreshToken;

  Http.Headers.Insert(0, ChttpHeaderAuthorization + ChttpAuthorizationBearer+' '+fpRefreshToken);
  TransmitirHttp(ChttpMethodPOST, AURL, ResultCode, RespostaHttp);
  ProcessarAutenticacao(AURL, ResultCode, RespostaHttp);
end;

procedure TACBrPSPShipay.GetWallets;
var
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  AURL: String;
  Ok: Boolean;
begin
  fWallets.Clear;
  PrepararHTTP;
  Ok := AcessarEndPoint(ChttpMethodGET, cShipayEndPointWallets, ResultCode, RespostaHttp);
  Ok := Ok and (ResultCode = HTTP_OK);

  if Ok then
  begin
    RespostaHttp := '{"wallets":'+RespostaHttp+'}';   // Transforma Array em Object
    fWallets.AsJSON := String(RespostaHttp)
  end
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodGET, cShipayEndPointWallets);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
  end;
end;

procedure TACBrPSPShipay.PostOrder(IsEOrder: Boolean);
var
  Body, AURL, ep: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  Ok: Boolean;
begin
  Body := Trim(fOrder.AsJSON);
  if (Body = '') then
    DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErroObjetoNaoPrenchido), ['Order']));

  if (LowerCase(fOrder.wallet) = cShipayWalletPix) then
  begin
    ep := cShipayEndPointOrderV;
    if (fOrder.expiration = 0) then
      fOrder.expiration := 3600;
  end
  else
    ep := cShipayEndPointOrder;

  fOrderCreated.Clear;
  PrepararHTTP;
  if IsEOrder then
    Http.Headers.Add(cShipayHeaderOrderType+' '+cShipayEOrder);
  WriteStrToStream(Http.Document, Body);
  Http.MimeType := CContentTypeApplicationJSon;
  Ok := AcessarEndPoint(ChttpMethodPOST, ep, ResultCode, RespostaHttp);
  Ok := Ok and (ResultCode = HTTP_OK);

  if Ok then
    fOrderCreated.AsJSON := String(RespostaHttp)
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodPOST, ep);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
  end;
end;

// Retorna Verdadeiro se a Ordeer foi cancelada com sucesso //
function TACBrPSPShipay.DeleteOrder(const order_id: String): Boolean;
var
  AURL: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
begin
  if (Trim(order_id) = '') then
    DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['order_id']));

  Clear;
  PrepararHTTP;
  URLPathParams.Add(order_id);
  AcessarEndPoint(ChttpMethodDELETE, cShipayEndPointOrder, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
  begin
    fOrderInfo.AsJSON := String(RespostaHttp);
    if (fOrderInfo.order_id <> Trim(order_id)) then
      DispararExcecao(EACBrPixException.Create(sErrOrderIdDifferent));

    Result := (fOrderInfo.status in [spsCancelled, spsRefunded]);
  end
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodDELETE, cShipayEndPointOrder);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodDELETE, AURL]));
  end;
end;

function TACBrPSPShipay.RefundOrder(const order_id: String;
  ValorReembolso: Currency): Boolean;
var
  AURL, Body: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  js: TJsonObject;
begin
  if (Trim(order_id) = '') then
    DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['order_id']));

  if (ValorReembolso <= 0) then
    DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['ValorReembolso']));

  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   js := TJsonObject.Create();
   try
     js.F['amount'] := ValorReembolso;
     Body := js.ToJSON();
   finally
     js.Free;
   end;
  {$Else}
   js := TJsonObject.Create;
   try
     js['amount'].AsNumber := ValorReembolso;
     Body := js.Stringify;
   finally
     js.Free;
   end;
  {$EndIf}

  Clear;
  PrepararHTTP;
  URLPathParams.Add(order_id);
  URLPathParams.Add(cShipayPathRefund);
  WriteStrToStream(Http.Document, Body);
  AcessarEndPoint(ChttpMethodDELETE, cShipayEndPointOrder, ResultCode, RespostaHttp);
  Result := (ResultCode = HTTP_OK);

  if Result then
  begin
    fOrderInfo.AsJSON := String(RespostaHttp);
    if (fOrderInfo.order_id <> Trim(order_id)) then
      DispararExcecao(EACBrPixException.Create(sErrOrderIdDifferent));

    Result := (fOrderInfo.status in [spsCancelled, spsRefunded]);
  end
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodDELETE, cShipayEndPointOrder);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodDELETE, AURL]));
  end;
end;

procedure TACBrPSPShipay.GetOrderInfo(const order_id: String; Wallet: String);
var
  AURL, ep: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  OK: Boolean;

  function DoGetOrderInfo: Boolean;
  begin
    Clear;
    PrepararHTTP;
    URLPathParams.Add(order_id);
    AcessarEndPoint(ChttpMethodGET, ep, ResultCode, RespostaHttp);
    Result := (ResultCode = HTTP_OK);
  end;

begin
  if (Trim(order_id) = '') then
    DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErroParametroInvalido), ['order_id']));

  if (LowerCase(Wallet) = cShipayWalletPix) then
    ep := cShipayEndPointOrderV
  else
    ep := cShipayEndPointOrder;

  Ok := DoGetOrderInfo;
  if (not Ok) and (ResultCode = HTTP_NOT_FOUND) then
  begin
    if (ep = cShipayEndPointOrderV) then
      ep := cShipayEndPointOrder
    else
      ep := cShipayEndPointOrderV;

    Ok := DoGetOrderInfo;
  end;

  if OK then
  begin
    fOrderInfo.AsJSON := String(RespostaHttp);
    if (fOrderInfo.order_id <> Trim(order_id)) then
      DispararExcecao(EACBrPixException.Create(sErrOrderIdDifferent));
  end
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodGET, ep);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodGET, AURL]));
  end;
end;

procedure TACBrPSPShipay.GetOrdersList(start_date: TDateTime;
  end_date: TDateTime; offset: Integer; limit: Integer);
var
  AURL: String;
  RespostaHttp: AnsiString;
  ResultCode: Integer;
  OK: Boolean;
begin
  Clear;
  PrepararHTTP;
  URLQueryParams.Values['start_date'] := DateTimeToIso8601(start_date);
  if (end_date <> 0) then
    URLQueryParams.Values['end_date'] := DateTimeToIso8601(end_date);
  if (limit <> 0) then
    URLQueryParams.Values['limit'] := IntToStr(limit);
  if (offset <> 0) then
    URLQueryParams.Values['offset'] := IntToStr(offset);
  URLPathParams.Add('list');
  AcessarEndPoint(ChttpMethodGET, cShipayEndPointOrder, ResultCode, RespostaHttp);
  OK := (ResultCode = HTTP_OK);

  if OK then
    fOrderList.AsJSON := String(RespostaHttp)
  else
  begin
    AURL := CalcularURLEndPoint(ChttpMethodDELETE, cShipayEndPointOrder);
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodDELETE, AURL]));
  end;
end;

procedure TACBrPSPShipay.ProcessarAutenticacao(const AURL: String;
  ResultCode: Integer; const RespostaHttp: AnsiString);
var
  js: TJsonObject;
begin
  Wallets.Clear;
  if (ResultCode = HTTP_OK) then
  begin
   {$IfDef USE_JSONDATAOBJECTS_UNIT}
    js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
    try
      fpToken := js.S['access_token'];
      fpRefreshToken := js.S['refresh_token'];
    finally
      js.Free;
    end;
   {$Else}
    js := TJsonObject.Create;
    try
      js.Parse(RespostaHttp);
      fpToken := js['access_token'].AsString;
      fpRefreshToken := js['refresh_token'].AsString;
    finally
      js.Free;
    end;
   {$EndIf}

    if (Trim(fpToken) = '') then
      DispararExcecao(EACBrPixHttpException.Create(ACBrStr(sErroAutenticacao)));

    fpValidadeToken := IncHour(Now, 24);
    fpAutenticado := True;

    GetWallets;
    if (fWallets.Count < 1) then
      DispararExcecao(EACBrPixHttpException.Create(sErrNoWallet));
  end
  else
    DispararExcecao(EACBrPixHttpException.CreateFmt( sErroHttp,
       [Http.ResultCode, ChttpMethodPOST, AURL]));
end;

procedure TACBrPSPShipay.QuandoAcessarEndPoint(const AEndPoint: String;
  var AURL: String; var AMethod: String);
const
  SDateFormat: string = 'yyyy''-''mm''-''dd''T''hh'':''nn'':''ss';
var
  Body, ep, TxId, uMethod, QueryParams: String;
  p: Integer;
  QP: TACBrQueryParams;
  inicio, fim: TDateTime;
  offset, limit: Integer;

  procedure ExtractTxIdFromURL;
  begin
    p := Pos(cEndPointCob, AURL);
    if (p > 0) then
    begin
      p := PosEx('/', AURL, p + Length(cEndPointCob));
      if (p > 0) then
      begin
        TxId := Copy(AURL, p+1, Length(AURL));
        AURL := copy(AURL, 1, p-1);
      end;
    end;
  end;

  procedure ExtractQueryParamsFromURL;
  begin
    p := PosLast('?', AURL);
    if (p > 0) then
    begin
      QueryParams := copy(AURL, p+1, Length(AURL));
      AURL := copy(AURL, 1, p-1);
    end;
  end;

begin
  TxId := '';
  uMethod := UpperCase(AMethod);
  if (AEndPoint = cEndPointCob) then
  begin
    if (pos(uMethod, ChttpMethodPOST+','+ChttpMethodPUT) > 0) then
    begin
      if (AMethod = ChttpMethodPUT) then
        ExtractTxIdFromURL;

      AMethod := ChttpMethodPOST;
      Body := ConverterJSONCobSolicitadaParaShipayOrder( String(StreamToAnsiString(Http.Document)), TxId );
      if (fOrder.wallet = cShipayWalletPix) then
        ep := cShipayEndPointOrderV
      else
        ep := cShipayEndPointOrder;

      AURL := StringReplace(AURL, cEndPointCob, ep, []);
      Http.Document.Clear;
      WriteStrToStream(Http.Document, Body);
    end

    else if (uMethod = ChttpMethodGET) then
    begin
      ExtractQueryParamsFromURL;
      ExtractTxIdFromURL;

      if (QueryParams <> '') and (TxId = '') then  // GET /cob
      begin
        QP := TACBrQueryParams.Create;
        try
          QP.AsURL := QueryParams;
          inicio := Iso8601ToDateTime(QP.Values['inicio']);
          fim := Iso8601ToDateTime(QP.Values['fim']);
          limit := StrToIntDef(QP.Values['paginacao.itensPorPagina'], -1);
          offset := StrToIntDef(QP.Values['paginacao.paginaAtual'], -1);
          QP.Clear;
          QP.Values['start_date'] := FormatDateTime(SDateFormat, inicio);
          QP.Values['end_date'] := FormatDateTime(SDateFormat, fim);
          if (limit > 0) then
            QP.Values['limit'] := IntToStr(limit);
          if (offset > 0) then
            QP.Values['offset'] := IntToStr(offset);
          QueryParams := qp.AsURL;
        finally
          QP.Free;
        end;
        AURL := StringReplace(AURL, cEndPointCob, cShipayEndPointOrdersList, []) +'?'+ QueryParams;
      end
      else
      begin                                        // GET /cob/{txid}
        TxId := LowerCase(TxId);
        if (pos('-', TxId) = 0) then
          FormatarGUID(TxId);
        if (Length(Trim(TxId)) <> 36) then
          DispararExcecao(EACBrPixException.CreateFmt(ACBrStr(sErrOrderIdInvalid),[TxId]));

        AURL := StringReplace(AURL, cEndPointCob, cShipayEndPointOrder, []) +'/'+ TxId;
      end;
    end;
  end;
end;

procedure TACBrPSPShipay.QuandoReceberRespostaEndPoint(const AEndPoint, AURL,
  AMethod: String; var AResultCode: Integer; var RespostaHttp: AnsiString);
var
  NovaURL, uMethod: String;
begin
  uMethod := UpperCase(AMethod);
  if (AEndPoint = cEndPointCob) then
  begin
    if (uMethod = ChttpMethodPOST) then
    begin
      if (AResultCode = HTTP_OK) or (AResultCode = HTTP_CREATED) then
      begin
        RespostaHttp := ConverterJSONOrderCreatedParaCobGerada( RespostaHttp );
        AResultCode := HTTP_CREATED;
      end;
    end

    else if (uMethod = ChttpMethodGET) then
    begin
      if (pos(cShipayEndPointOrdersList, AURL) = 0) then
      begin
        if (AResultCode = HTTP_BAD_REQUEST) then   // n�o achou em /order, veja em /orderv
        begin
          epCob.Clear;
          PrepararHTTP;
          NovaURL := StringReplace(AURL, cShipayEndPointOrder, cShipayEndPointOrderV, [rfReplaceAll]);
          TransmitirHttp(AMethod, NovaURL, AResultCode, RespostaHttp);
        end;

        if (AResultCode = HTTP_OK) then
          RespostaHttp := ConverterJSONOrderInfoParaCobCompleta( RespostaHttp );
      end;
    end;
  end
end;

function TACBrPSPShipay.ConverterJSONCobSolicitadaParaShipayOrder(
  const CobSolicitadaJSON: String; const TxId: String): String;
const
  cACBrOrderRefSufixo = '-acbr';
var
  Cob: TACBrPIXCobSolicitada;
  ia: TACBrPIXInfoAdicional;
  i: Integer;
  item: TShipayItem;
  s: String;
begin
  fOrder.Clear;
  Cob := TACBrPIXCobSolicitada.Create('');
  try
    Cob.AsJSON := CobSolicitadaJSON;

    fOrder.buyer.name := Cob.devedor.nome;
    fOrder.buyer.cpf_cnpj := IfEmptyThen(Cob.devedor.cnpj, Cob.devedor.cpf);
    fOrder.total := Cob.valor.original;
    fOrder.pix_dict_key := Cob.chave;
    fOrder.expiration := Cob.calendario.expiracao;

    if (TxId <> '') then
      fOrder.order_ref := TxId
    else
    begin
      ia := Cob.infoAdicionais.Find('order_ref');
      if (ia <> Nil) then
        fOrder.order_ref := ia.valor;
    end;

    ia := Cob.infoAdicionais.Find('wallet');
    if (ia <> Nil) then
      fOrder.wallet := ia.valor;

    i := 1;
    repeat
      s := 'item_'+IntToStr(i);
      ia := Cob.infoAdicionais.Find(s);
      if (ia <> Nil) then
      begin
        item := fOrder.items.New;
        try
          item.AsJSON := ia.valor;
        except
          On E: Exception do
          begin
            ACBrPixCD.RegistrarLog(Format('Erro na sintaxe de %s',[s]));
            ACBrPixCD.RegistrarLog(E.ClassName + ': ' + E.Message);
            fOrder.items.Remove(item);
          end;
        end;
        Inc(i);
      end;
    until (ia = Nil) ;

    // Chama Evento, para permitir ao usu�rio, informar a Wallet e os Items
    if Assigned(fQuandoEnviarOrder) then
      fQuandoEnviarOrder(fOrder);

    if (Trim(fOrder.order_ref) = '') then
      DispararExcecao(EACBrPixException.Create(ACBrStr(sErrOrderRefNotInformed)));

    if (pos(cACBrOrderRefSufixo, LowerCase(fOrder.order_ref)) = 0) then
       fOrder.order_ref := fOrder.order_ref + cACBrOrderRefSufixo;

    if (Trim(fOrder.wallet) = '') then
    begin
      // N�o especificou Wallet, usando a �nica Wallet retornada ou "pix"
      if (fWallets.Count = 1) then
        fOrder.wallet := fWallets[0].wallet
      else
      begin
        for i := 0 to fWallets.Count-1 do
        begin
          if (fWallets[i].wallet = cShipayWalletPix) then  // Tem Pix ?
          begin
            fOrder.wallet := cShipayWalletPix;
            Break;
          end;
        end;
        if (Trim(fOrder.wallet) = '') then  // N�o tem PIX, pegue a primeira da Lista
          fOrder.wallet := fWallets[0].wallet;
      end;
    end;

    if (fOrder.items.Count = 0) then
    begin
      // N�o especificou Item em "QuandoEnviarOrder", criando um Item padr�o
      with fOrder.items.New do
      begin
        sku := '00001';
        ean := '2'+ sku + '000000';  // 2 = in-store, Zeros = Total
        ean := ean + EAN13_DV(ean);
        item_title := cItemTitleNotInformed;
        quantity := 1;
        unit_price := fOrder.total;
      end;
    end;

    //with fOrder.items.New do
    //begin
    //  sku := 'ACBr';
    //  item_title := 'ACBrPIXCD';
    //  quantity := 0;
    //  unit_price := 0;
    //end;

    if (fOrder.wallet <> cShipayWalletPix) then
      fOrder.expiration := 0
    else
    begin
      if (fOrder.expiration <= 0) then
        fOrder.expiration := 3600
    end;

    Result := fOrder.AsJSON;
  finally
    Cob.Free;
  end;
end;

function TACBrPSPShipay.ConverterJSONOrderCreatedParaCobGerada(
  const OrderCreatedJSON: String): String;
var
  Cob: TACBrPIXCobGerada;
  qrd: TACBrPIXQRCodeDinamico;
begin
  fOrderCreated.AsJSON := OrderCreatedJSON;
  Cob := TACBrPIXCobGerada.Create('');
  try
    Cob.calendario.criacao := Now;
    if (fOrderCreated.expiration_date = 0) then
      fOrderCreated.expiration_date := IncMinute(Cob.calendario.criacao, 60);
    Cob.calendario.expiracao := SecondsBetween(Cob.calendario.criacao, fOrderCreated.expiration_date);
    Cob.txId := StringReplace(fOrderCreated.order_id, '-', '', [rfReplaceAll]);
    Cob.status := ShiPayStatusToCobStatus(fOrderCreated.status);
    Cob.pixCopiaECola := fOrderCreated.qr_code_text;
    with Cob.infoAdicionais.New do
    begin
      nome := 'order_id';
      valor := fOrderCreated.order_id;
    end;
    with Cob.infoAdicionais.New do
    begin
      nome := 'wallet';
      valor := fOrderCreated.wallet;
    end;
    //with Cob.infoAdicionais.New do
    //begin
    //  nome := 'qr_code';
    //  valor := fOrderCreated.qr_code;   // infoAdicional.valor s� aceita 200 chars;
    //end;

    if (fOrderCreated.wallet = cShipayWalletPix) then
    begin
      Cob.chave := fOrderCreated.pix_dict_key;
      with Cob.infoAdicionais.New do
      begin
        nome := 'pix_psp';
        valor := fOrderCreated.pix_psp;
      end;

      qrd := TACBrPIXQRCodeDinamico.Create;
      try
        qrd.AsString := fOrderCreated.qr_code_text;
        Cob.location := qrd.URL;
        Cob.loc.tipoCob := tcoCob;
        Cob.loc.location := qrd.URL;
      finally
        qrd.Free;
      end;
    end;

    // Copiando informa��es que n�o constam na resposta, do Objeto de Requisi��o //
    Cob.devedor.nome := fOrder.buyer.name;
    if (Length(fOrder.buyer.cpf_cnpj) > 11) then
      Cob.devedor.cnpj := fOrder.buyer.cpf_cnpj
    else
      Cob.devedor.cpf := fOrder.buyer.cpf_cnpj;
    Cob.valor.original := fOrder.total;
    Cob.chave := fOrder.pix_dict_key;
    with Cob.infoAdicionais.New do
    begin
      nome := 'order_ref';
      valor := fOrder.order_ref;
    end;

    Result := Cob.AsJSON;
  finally
    Cob.Free;
  end;
end;

function TACBrPSPShipay.ConverterJSONOrderInfoParaCobCompleta(
  const OrderInfoJSON: String): String;
var
  Cob: TACBrPIXCobCompleta;
begin
  fOrderInfo.AsJSON := OrderInfoJSON;
  Cob := TACBrPIXCobCompleta.Create('');
  try
    Cob.calendario.criacao := fOrderInfo.created_at;
    if (fOrderInfo.expiration_date = 0) then
      fOrderInfo.expiration_date := IncMinute(fOrderInfo.created_at, 60);
    Cob.calendario.expiracao := SecondsBetween(Cob.calendario.criacao, fOrderInfo.expiration_date);
    Cob.valor.original := fOrderInfo.total_order;
    Cob.txId := StringReplace(fOrderInfo.order_id, '-', '', [rfReplaceAll]);
    Cob.status := ShiPayStatusToCobStatus(fOrderInfo.status);
    with Cob.infoAdicionais.New do
    begin
      nome := 'order_id';
      valor := fOrderInfo.order_id;
    end;
    with Cob.infoAdicionais.New do
    begin
      nome := 'wallet';
      valor := fOrderInfo.wallet;
    end;
    if (fOrderInfo.wallet_payment_id <> '') then
    begin
      with Cob.infoAdicionais.New do
      begin
        nome := 'wallet_payment_id';
        valor := fOrderInfo.wallet_payment_id;
      end;
    end;
    if (fOrderInfo.wallet = cShipayWalletPix) then
    begin
      with Cob.infoAdicionais.New do
      begin
        nome := 'pix_psp';
        valor := fOrderInfo.pix_psp;
      end;
    end;

    Result := Cob.AsJSON;
  finally
    Cob.Free;
  end;
end;

function TACBrPSPShipay.ShiPayStatusToCobStatus(
  AShipayStatus: TShipayOrderStatus): TACBrPIXStatusCobranca;
begin
  case AShipayStatus of
    spsPending, spsPendingV:
      Result := stcATIVA;
    spsApproved, spsRefunded, spsRefundPending:
      Result := stcCONCLUIDA;
    spsCancelled, spsExpired:
      Result := stcREMOVIDA_PELO_PSP
  else
    Result := stcNENHUM;
  end;
end;

function TACBrPSPShipay.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cShipayURLProducao
  else
    Result := cShipayURLStaging;
end;

procedure TACBrPSPShipay.TratarRetornoComErro(ResultCode: Integer;
  const RespostaHttp: AnsiString; Problema: TACBrPIXProblema);
var
  js: TJsonObject;
begin
  if (pos('"message"', RespostaHttp) > 0) then   // Erro no formato pr�prio da ShiPay
  begin
     (* Exemplo de Retorno
       {"code":404,"message":"Order not Found"}
     *)
    {$IfDef USE_JSONDATAOBJECTS_UNIT}
     js := TJsonObject.Parse(RespostaHttp) as TJsonObject;
     try
       Problema.status := js.I['code'];
       Problema.detail := js.S['message'];
     finally
       js.Free;
     end;
    {$Else}
     js := TJsonObject.Create;
     try
       js.Parse(RespostaHttp);
       Problema.status := js['code'].AsInteger;
       Problema.detail := js['message'].AsString;
     finally
       js.Free;
     end;
     Problema.title := 'Error '+IntToStr(Problema.status);
    {$EndIf}
  end
  else
    inherited TratarRetornoComErro(ResultCode, RespostaHttp, Problema);
end;

end.


