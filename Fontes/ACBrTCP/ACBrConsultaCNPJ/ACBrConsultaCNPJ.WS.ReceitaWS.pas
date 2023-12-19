unit ACBrConsultaCNPJ.WS.ReceitaWS;

interface
uses
  ACBrJSON, Jsons, SysUtils, ACBrConsultaCNPJ.WS;
type
  EACBrConsultaCNPJWSException = class ( Exception );

  { TACBrConsultaCNPJWS }
  TACBrConsultaCNPJWSReceitaWS = class(TACBrConsultaCNPJWS)
    public
      function Executar:boolean; override;
  end;
const
  C_URL = 'https://receitaws.com.br/v1/cnpj/';

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  blcksock,
  Classes,
  synautil, httpsend;

{ TACBrConsultaCNPJWS }

function TACBrConsultaCNPJWSReceitaWS.Executar: boolean;
var
  LJSon: TJson;
  LJsonObject : TJsonObject;
  LStream : TStringStream;
  LRetorno : String;
  LJsonArray: TJsonArray;
  I, Z : Integer;
begin
  inherited;
  HTTPSend := THTTPSend.Create;
  LStream  := TStringStream.Create('');
  try
    HTTPSend.OutputStream := LStream;
    HTTPSend.Clear;
    HTTPSend.Headers.Clear;
    HTTPSend.Headers.Add('Accept: application/json');
    HTTPSend.Headers.Add('charset=utf-8');
    if FUsuario <> '' then
      HTTPSend.Headers.Add('Authorization: Bearer ' + FUsuario);

    HTTPSend.MimeType := 'application/x-www-form-urlencoded';

    HTTPSend.Sock.SSL.SSLType := LT_TLSv1_2;

    HTTPSend.HTTPMethod('GET',C_URL +  OnlyNumber(FCNPJ));

    HTTPSend.Document.Position:= 0;
    LRetorno := ReadStrFromStream(LStream, LStream.Size);

    LJSon := TJson.Create;
    LJSon.Parse('[' + UTF8ToNativeString(LRetorno) + ']');
    for I := 0 to Pred(LJSon.Count) do
    begin
      LJsonObject := LJSon.Get(I).AsObject;
      if LJsonObject.Values['status'].AsString = 'OK' then
      begin
        FResposta.RazaoSocial          := ACBrStr(LJsonObject.Values['nome'].AsString);
        FResposta.CNPJ                 := ACBrStr(LJsonObject.Values['cnpj'].AsString);
        FResposta.Fantasia             := ACBrStr(LJsonObject.Values['fantasia'].AsString);
        FResposta.Abertura             := StringToDateTimeDef(LJsonObject.Values['abertura'].AsString,0);
        FResposta.Porte                := ACBrStr(LJsonObject.Values['porte'].AsString);

        LJsonArray := LJsonObject.Values['atividade_principal'].AsArray;
        if LJsonArray.Count > 0 then
          FResposta.CNAE1              := ACBrStr(LJsonArray[0].AsObject.Values['code'].AsString + ' ' + LJsonArray[0].AsObject.Values['text'].AsString);

        LJsonArray := LJsonObject.Values['atividades_secundarias'].AsArray;
        for Z := 0 to Pred(LJsonArray.Count) do
          FResposta.CNAE2.Add(ACBrStr(LJsonArray[Z].AsObject.Values['code'].AsString + ' ' + LJsonArray[Z].AsObject.Values['text'].AsString));

        FResposta.EmpresaTipo          := ACBrStr(LJsonObject.Values['tipo'].AsString);
        FResposta.Endereco             := ACBrStr(LJsonObject.Values['logradouro'].AsString);
        FResposta.Numero               := ACBrStr(LJsonObject.Values['numero'].AsString);
        FResposta.Complemento          := ACBrStr(LJsonObject.Values['complemento'].AsString);
        FResposta.CEP                  := ACBrStr(OnlyNumber( LJsonObject.Values['cep'].AsString));
        FResposta.Bairro               := ACBrStr(LJsonObject.Values['bairro'].AsString);
        FResposta.Cidade               := ACBrStr(LJsonObject.Values['municipio'].AsString);
        FResposta.UF                   := ACBrStr(LJsonObject.Values['uf'].AsString);
        FResposta.Situacao             := ACBrStr(LJsonObject.Values['situacao'].AsString);
        FResposta.SituacaoEspecial     := ACBrStr(LJsonObject.Values['situacao_especial'].AsString);
        FResposta.DataSituacao         := StringToDateTimeDef(LJsonObject.Values['data_situacao'].AsString,0);
        FResposta.DataSituacaoEspecial := StringToDateTimeDef(LJsonObject.Values['data_situacao_especial'].AsString,0);
        FResposta.NaturezaJuridica     := ACBrStr(LJsonObject.Values['natureza_juridica'].AsString);
        FResposta.EndEletronico        := ACBrStr(LJsonObject.Values['email'].AsString);
        FResposta.Telefone             := ACBrStr(LJsonObject.Values['telefone'].AsString);
        FResposta.EFR                  := ACBrStr(LJsonObject.Values['efr'].AsString);
        FResposta.MotivoSituacaoCad    := ACBrStr(LJsonObject.Values['motivo_situacao'].AsString);
        Result := true;
      end;
    end;
  finally
    LJSon.Free;
    HTTPSend.Free;
  end;
end;

end.
