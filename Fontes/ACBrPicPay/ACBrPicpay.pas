{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Felipe Baldin                                   }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{ Esse arquivo usa a classe  SynaSer   Copyright (c)2001-2003, Lukas Gebauer   }
{  Project : Ararat Synapse     (Found at URL: http://www.ararat.cz/synapse/)  }
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

{******************************************************************************}
{* Historico                                                                   }
{*                                                                             }
{* 24/03/2020: Primeira Versao - Felipe Baldin                                 }
{*    Doa��o para o projeto ACBR                                               }
{*    Cria�ao do componente ACBrPicpay, que implementa a integra��o com a API  }
{*    do Picpay atrav�s de m�todos HTTP usando a suite Synapse para envio      }
{*    e retorno de arquivos usando Json nativo do ACBr.                        }
{******************************************************************************}

unit ACBrPicpay;

{$I ACBr.inc}

interface

uses
  ACBRBase, ACBRValidador, ACBrUtil, ACBrSocket,
  {$IFDEF FPC}
  base64,
  {$ELSE}
  EncdDecd,
  {$ENDIF}
  Classes, SysUtils, Jsons, httpsend, synautil, StrUtils;

const
  PICPAY_URL_CANCELAMENTO = 'https://appws.picpay.com/ecommerce/public/payments/{referenceId}/cancellations';
  PICPAY_URL_ENVIO = 'https://appws.picpay.com/ecommerce/public/payments';
  PICPAY_URL_RETORNO = 'https://appws.picpay.com/ecommerce/public/payments/{referenceId}/status';

type
  EACBrPicpayError = class( Exception ) ;

  TWaitingPayment = procedure (Status: String) of Object;

  TStatusPayment = procedure (AuthorizationId, Status : String) of Object;

  TErrorPayment = procedure (Error : String) of Object;

//  TACBrPicPayPessoa = (pFisica, pJuridica, pOutras);
  TACBrPicPayPessoa = (pFisica, pJuridica);

//  TACBrTipoRetorno = (trThread, trCallback);
//  TACBrTipoRetornoPicpay = trThread..trCallback;
  TACBrTipoRetornoPicpay = (trThread, trCallback);


  TACBrPicPayComprador = class;
  TACBrPicPay = class;
  TACBrPicPayLojista = class;

  { TACBrThread }
  TACBrPicPayThread = class(TThread)
  private
    fACBrPicpay: TACBrPicPay;
    procedure StatusPayment;
  protected
    procedure Execute; override;
  public
    constructor Create ( AOwner: TComponent );
    destructor Destroy; override;
  end;

  { TACBrLojista }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrPicPayLojista = class(TComponent)
  private
    fURLCallBack: string;
    fURLReturn: string;
    fPicpayToken: string;
    fSellerToken: string;

    fACBrPicpay: TACBrPicPay;
  public
    constructor Create ( AOwner: TComponent ); override;
  published
    //URL do servidor que vai receber a callback
    property URLCallBack: string read fURLCallBack write fURLCallBack;
    property URLReturn: string read fURLReturn write fURLReturn;

    //Esses dados est�o dispon�veis no site do picpay quando abre a conta.
    property PicpayToken: string read fPicpayToken write fPicpayToken;
    property SellerToken: string read fSellerToken write fSellerToken;
  end;


  { TACBrComprador }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrPicPayComprador = class(TComponent)
  private
    fNome: string;
    fSobreNome: string;
    fDocumento: string;
    fEmail: string;
    fTelefone: string;
    fTipoInscricao: TACBrPicPayPessoa;

    fACBrPicpay: TACBrPicPay;

    procedure SetTipoInscricao ( const AValue: TACBrPicPayPessoa ) ;
    procedure SetDocumento(const AValue: String );
  public
    constructor Create ( AOwner: TComponent); override;
    property ACBrPicpay  : TACBrPicPay read fACBrPicpay;
  published
    property Nome: string read fNome write fNome;
    property SobreNome: string read fSobreNome write fSobreNome;
    property Documento: string read fDocumento write SetDocumento;
    property Telefone: string read fTelefone write fTelefone;
    property Email: string read fEmail write fEmail;

    property TipoInscricao: TACBrPicPayPessoa  read fTipoInscricao write  SetTipoInscricao;
  end;

  { TACBrPicpay }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrPicPay = class(TACBrHTTP)
  private
    fReferenceId: string;
    fCancellationId: string;
    fAuthorizationId: string;
    fStatus: string;
    fProduto: string;
    fValor: Currency;
    fCancelarAguardoRetorno: Boolean;

    fTipoRetorno: TACBrTipoRetornoPicpay;
    fOnStatusPayment: TStatusPayment;
    fOnErrorPayment: TErrorPayment;
    fOnWaitingPayment: TWaitingPayment;

    fTempoRetorno: Integer;

    fQRCode: string;

    fLojista: TACBrPicPayLojista;
    fComprador: TACBrPicPayComprador;
    fThread: TACBrPicPayThread;

    procedure AguardarRetorno;

    procedure SetTipoRetorno ( const AValue: TACBrTipoRetornoPicpay ) ;
    procedure SetTempoRetorno(const AValue: Integer);
    procedure SetReferenceId(const AValue: String);
    function GetQRCode: TStringStream;
  protected
    { Protected declarations }
  public
    property QRCode: TStringStream read GetQRCode;
    property Status: string read fStatus;
    procedure Enviar;
    procedure Consultar;
    property CancelarAguardoRetorno: Boolean write fCancelarAguardoRetorno;
    function Cancelar(const aAuthorizationId: string): Boolean;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published

    //Dados do pagamento
    property ReferenceId: string read fReferenceId write SetReferenceId;
    property CancellationId: string read fCancellationId;
    property AuthorizationId: string read fAuthorizationId;
    property Produto: string read fProduto write fProduto;
    property Valor: Currency read fValor write fValor;

    property Comprador: TACBrPicPayComprador read fComprador write fComprador;
    property Lojista: TACBrPicPayLojista read fLojista write fLojista;
    property TempoRetorno: Integer read fTempoRetorno write SetTempoRetorno;
    property TipoRetorno: TACBrTipoRetornoPicpay read fTipoRetorno write SetTipoRetorno;

    property OnStatusPayment: TStatusPayment read FOnStatusPayment write FOnStatusPayment;
    property OnWaitingPayment: TWaitingPayment read fOnWaitingPayment write fOnWaitingPayment;
    property OnErrorPayment: TErrorPayment read fOnErrorPayment write fOnErrorPayment;
  end;

implementation

{ *** TACBrThread *** }

{ Private }

procedure TACBrPicPayThread.StatusPayment;
begin
  if Assigned(fACBrPicpay.fOnStatusPayment) then
    fACBrPicpay.fOnStatusPayment(fACBrPicpay.fAuthorizationId, fACBrPicpay.fStatus);
end;


{ Protected }

procedure TACBrPicPayThread.Execute;
begin
  repeat
    Sleep(1000);
    Dec(fACBrPicpay.fTempoRetorno);

    if fACBrPicpay.fQRCode <> '' then
      fACBrPicpay.Consultar;

    if Assigned(fACBrPicpay.fOnWaitingPayment) then
      fACBrPicpay.fOnWaitingPayment(fACBrPicpay.Status);

  until (fACBrPicpay.fStatus = 'paid') or fACBrPicpay.fCancelarAguardoRetorno or (fACBrPicpay.fTempoRetorno <= 0);
  Synchronize(StatusPayment);
end;

{ Public }

constructor TACBrPicPayThread.Create(AOwner: TComponent);
begin
  inherited Create(True);
  if not (AOwner is TACBrPicPay) then
    EACBrPicpayError.Create('Owner n�o � do tipo: TACBrPicpay');

  fACBrPicpay := TACBrPicPay(AOwner);
end;

destructor TACBrPicPayThread.Destroy;
begin
  inherited;
end;


{ *** TACBrLojista *** }

{ Public }

constructor TACBrPicPayLojista.Create ( AOwner: TComponent );
begin
  inherited Create(AOwner);
  fACBrPicpay := TACBrPicPay(AOwner);
end;

{ *** TACBrComprador *** }

{ Private }

procedure TACBrPicPayComprador.SetTipoInscricao ( const AValue: TACBrPicPayPessoa ) ;
begin
   if fTipoInscricao = AValue then
      exit;

   fTipoInscricao := AValue;
end;

procedure TACBrPicPayComprador.SetDocumento ( const AValue: String ) ;
var
  ACBrVal: TACBrValidador;
  ADocto: String;
begin
   if fDocumento = AValue then
     Exit;

   ADocto := OnlyNumber(AValue);
   if EstaVazio(ADocto) then
   begin
      fDocumento:= ADocto;
      Exit;
   end;

   ACBrVal := TACBrValidador.Create(Self);
   try
     with ACBrVal do
     begin
       if fTipoInscricao = pFisica then
       begin
         TipoDocto := docCPF;
         Documento := RightStr(ADocto,11);
       end
       else
       begin
         TipoDocto := docCNPJ;
         Documento := RightStr(ADocto,14);
       end;

       IgnorarChar := './-';
       RaiseExcept := True;
       Validar;    // Dispara Exception se Documento estiver errado

       fDocumento := Formatar;
     end;
   finally
     ACBrVal.Free;
   end;
end;

{ Public }

constructor TACBrPicPayComprador.Create ( AOwner: TComponent);
begin
  inherited Create(AOwner);
  fDocumento := '';

  fTipoInscricao := pFisica;
  fACBrPicpay := TACBrPicPay(AOwner);
end;

{ *** TACBrPicpay *** }

{ Private }

procedure TACBrPicPay.SetTipoRetorno ( const AValue: TACBrTipoRetornoPicpay ) ;
begin
   if fTipoRetorno = AValue then
      exit;

   fTipoRetorno := AValue;
end;


procedure TACBrPicPay.SetTempoRetorno(const AValue: Integer);
begin
  if AValue = fTempoRetorno then
    Exit;

  if AValue <= 0  then
    fTempoRetorno := 1
  else
    fTempoRetorno := AValue;
end;

procedure TACBrPicPay.SetReferenceId(const AValue: String);
var
  aId: Integer;
begin
   if fReferenceId = AValue then
      exit;

   fReferenceId:= AValue;
   aId:= StrToIntDef(trim(AValue),0);

   if aId = 0 then
      exit;

   fReferenceId:= IntToStrZero(aId, 6 );
end;

function TACBrPicPay.GetQRCode: TStringStream;
var
  Input: TStringStream;
///  s: TMemoryStream;
///  bb: TBytes;
begin
  if fQRCode = ''  then
  begin
    Result := nil;
    EACBrPicpayError.Create('QRCode est� vazio ou inv�lido.');
  end;

  fQRCode := StringReplace(fQRCode, 'data:image/png;base64,', '', [rfReplaceAll]);

  {$IFDEF FPC}
  EACBrPicpayError.Create('Ainda n�o implementado leitra QRCode para FPC/Lazarus.');
  (*
    s := TMemoryStream.Create;
    try
      bb := EncdDecd.decodebase64(fQRCode);
      if Length(bb) > 0 then
      begin
        s.WriteData(bb, Length(bb));
        s.position := 0;
        Result := TPngImage.Create;
        Result.LoadFromStream(s);
      end;
    finally
      s.free;
    end;

    *)
  {$ELSE}
  Input := TStringStream.Create(fQRCode);
  try
    Result := TStringStream.Create(fQRCode);
    DecodeStream(Input, Result);
    Result.Position := 0;
  finally
    Input.Free;
  end;
  {$ENDIF}
end;

procedure TACBrPicPay.AguardarRetorno;
begin
  if fTipoRetorno = trThread then
    fThread.Resume;
end;

(*
  TThread.CreateAnonymousThread(
    procedure
    begin
      repeat
        Sleep(1000);
        Dec(fTempoRetorno);

        if fQRCode <> '' then
          Consultar;

        if Assigned(fOnWaitingPayment) then
          fOnWaitingPayment(Status);

      until (fStatus = 'paid') or fCancelarAguardoRetorno or (fTempoRetorno <= 0);


      TThread.Synchronize(nil, procedure
      begin
        if Assigned(fOnStatusPayment) then
          fOnStatusPayment(fAuthorizationId, fStatus);
      end);
    end).Start;
end;

*)

{ Public }

procedure TACBrPicPay.Consultar;
var
  JsonResponse: TJson;
  Url: string;
  I: Integer;
begin
  Url := StringReplace(PICPAY_URL_RETORNO, '{referenceId}', fReferenceId, [rfReplaceAll]);

  Self.HTTPSend.Headers.Clear;
  Self.HTTPSend.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV2';
  Self.HTTPSend.KeepAlive := True;
  Self.HTTPSend.MimeType := 'application/json';
  Self.HTTPSend.Headers.Add('Content-Type: application/json');
  Self.HTTPSend.Headers.Add('x-picpay-token: ' + fLojista.fPicpayToken);
  Self.HTTPSend.Protocol := '1.1';
  Self.HTTPSend.Status100 := False;

  Self.HTTPMethod('GET', Url);

  { Convertendo uma string para json object }
  JsonResponse := TJSon.Create;
  try
    JsonResponse.Parse(Self.RespHTTP.Text);
    for I := 0 to JsonResponse.Count - 1 do
    begin

      fReferenceId := JsonResponse.Values['referenceId'].AsString;
      fStatus := JsonResponse.Values['status'].AsString;

      if SameText('paid', fStatus) then
        fAuthorizationId := JsonResponse.Values['authorizationId'].AsString;
    end;
  finally
    JsonResponse.Free;
  end;
end;

procedure TACBrPicPay.Enviar;
var
  data: AnsiString;
  DataToSend : TStringStream;
  JsonBuyer: TJsonPair;
  Json: TJSONObject;
  JsonCliente: TJSONObject;
  JsonResponse: TJson;
  I: Integer;
  J: Integer;

begin
  Json := TJsonObject.Create;
  try
    Json.Add('referenceId').Value.AsString := fReferenceId;
    Json.Add('callbackUrl').Value.AsString := fLojista.fURLCallBack;
    Json.Add('returnUrl').Value.AsString := fLojista.fURLReturn;
    Json.Add('productName').Value.AsString := fProduto;
    Json.Add('value').Value.AsNumber := fValor;
    JsonCliente := TJSONObject.Create;
    try
      JsonCliente.Add('firstName').Value.AsString := fComprador.fNome;
      JsonCliente.Add('lastName').Value.AsString := fComprador.fSobreNome;
      JsonCliente.Add('document').Value.AsString := fComprador.fDocumento;
      JsonCliente.Add('email').Value.AsString := fComprador.fEmail;
      JsonCliente.Add('phone').Value.AsString := fComprador.fTelefone;

      JsonBuyer := TJsonPair.Create(Json, 'buyer');
      try
        JsonBuyer.Value.AsObject := JsonCliente;
        Json.Add('buyer').Assign(JsonBuyer);
      finally
        JsonBuyer.Free;
      end;
    finally
      JsonCliente.Free;
    end;
    data := Json.Stringify;
  finally
    Json.Free;
  end;

  data := NativeStringToUTF8(data);

  DataToSend := TStringStream.Create(data);
  try
    Self.HTTPSend.Headers.Clear;
    Self.HTTPSend.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV2';
    Self.HTTPSend.KeepAlive := True;
    Self.HTTPSend.MimeType := 'application/json';
    Self.HTTPSend.Headers.Add('Content-Type: application/json');
    Self.HTTPSend.Headers.Add('x-picpay-token: ' + fLojista.fPicpayToken);
    Self.HTTPSend.Protocol := '1.1';
    Self.HTTPSend.Status100 := True;
    Self.HTTPSend.Document.LoadFromStream(DataToSend);


    Self.HTTPMethod('POST', PICPAY_URL_ENVIO);


    { Convertendo uma string para json object }
    JsonResponse := TJSon.Create;
    try
      JsonResponse.Parse(Self.RespHTTP.Text);
      for I := 0 to JsonResponse.Count - 1 do
      begin

        fReferenceId := JsonResponse.Values['referenceId'].AsString;

        for J := 0 to TJsonObject(JsonResponse.Values['qrcode'].AsObject).Count - 1 do
        begin
          fQrCode := TJsonObject(JsonResponse.Values['qrcode'].AsObject).Values['base64'].AsString;
        end;
      end;


      if fQRCode <> '' then
      begin
        case fTipoRetorno of
          trThread: AguardarRetorno;
          trCallback: EACBrPicpayError.Create('Tem que implementar o servidor HTTP.');
        end;
      end;

    finally
      JsonResponse.Free;
    end;

  finally
    DataToSend.Free;
  end;
end;

function TACBrPicPay.Cancelar(const aAuthorizationId: string): Boolean;
var
  JsonPicPay: TJsonObject;
  JsonResponse: TJSONObject;
  Url: string;
  DataToSend: TStringStream;
  data: string;
  I: Integer;
begin
  Result := False;

  JsonPicPay := TJsonObject.Create;
  try
    JsonPicPay.Add('picpaytoken').Value.AsString := fLojista.PicpayToken;
    JsonPicPay.Add('sellertoken').Value.AsString := fLojista.SellerToken;
    JsonPicPay.Add('referenceId').Value.AsString := fReferenceId;
    JsonPicPay.Add('authorizationId').Value.AsString := aAuthorizationId;

    data := JsonPicPay.Stringify;

  finally
    JsonPicPay.Free;
  end;

  Url := StringReplace(PICPAY_URL_CANCELAMENTO, '{referenceId}', fReferenceId, [rfReplaceAll]);

  data := UTF8ToNativeString(data);

  DataToSend := TStringStream.Create(data);
  try
    Self.HTTPSend.Headers.Clear;
    Self.HTTPSend.UserAgent := 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV2';
    Self.HTTPSend.KeepAlive := True;
    Self.HTTPSend.MimeType := 'application/json';
    Self.HTTPSend.Headers.Add('Content-Type: application/json');
    Self.HTTPSend.Headers.Add('x-picpay-token: ' + fLojista.fPicpayToken);
    Self.HTTPSend.Protocol := '1.1';
    Self.HTTPSend.Status100 := True;
    Self.HTTPSend.Document.LoadFromStream(DataToSend);

    Self.HTTPMethod('POST', Url);

    { Convertendo uma string para json object }

    if Self.RespHTTP.Text = '' then
      Exit;

    JsonResponse := TJsonObject.Create(nil);
    try
      JsonResponse.Parse(Self.RespHTTP.Text);
      for I := 0 to JsonResponse.Count - 1 do
      begin
        fReferenceId := JsonResponse.Values['referenceId'].AsString;
        fCancellationId := JsonResponse.Values['cancellationId'].AsString;
      end;

    finally
      JsonResponse.Free;
    end;

    Result := fCancellationId <> '';
  finally
    DataToSend.Free;
  end;
end;

constructor TACBrPicPay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fTipoRetorno := trThread;

  fCancelarAguardoRetorno := False;

  fThread := TACBrPicPayThread.Create(Self);

  fLojista      := TACBrPicPayLojista.Create(self);
  fLojista.Name := 'Lojista';
  {$IFDEF COMPILER6_UP}
   fLojista.SetSubComponent(True);   // Ajustando como SubComponente para aparecer no ObjectInspector
  {$ENDIF}

  fComprador      := TACBrPicPayComprador.Create(self);
  fComprador.Name := 'Comprador';
  {$IFDEF COMPILER6_UP}
   fComprador.SetSubComponent(True);   // Ajustando como SubComponente para aparecer no ObjectInspector
  {$ENDIF}
end;

destructor TACBrPicPay.Destroy;
begin
  fComprador.Free;
  fLojista.Free;
  fThread.Free;
  inherited;
end;

end.

