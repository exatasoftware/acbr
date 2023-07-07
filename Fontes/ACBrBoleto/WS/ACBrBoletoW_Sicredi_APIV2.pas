{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo:  Victor Hugo Gonzales - Panda, Leandro do Couto,}
{  Fernando Henrique                                                           }
{                                                                              }
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

unit ACBrBoletoW_Sicredi_APIV2;

interface

uses
  SysUtils,
  Classes,
  Synacode,
  StrUtils,
  DateUtils,
  Jsons,
  pcnConversao,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrBoletoWS,
  ACBrBoletoWS.Rest,
  ACBrBoleto;

type
  { TBoletoW_Sicredi_APIV2 }
  TBoletoW_Sicredi_APIV2 = class(TBoletoWSREST)
  private
    function CodigoTipoTitulo(AEspecieDoc:String): String;
    function TipoDescontoToString(const AValue: TACBrTipoDesconto): String;
    function TipoJuros(const AValue: String): String;
  protected
    function GerarTokenAutenticacao: string; override;
    function DefinirParametros: String;
    function DefinirParametrosDetalhe: String;
    function ValidaAmbiente: Integer;
    function DefinirNossoNumero:string;
    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirAuthorization; override;
    procedure DefinirKeyUser;
    procedure DefinirAutenticacao;
    procedure DefinirPosto;
    procedure DefinirCooperativa;
    procedure DefinirCodigoBeneficiario;
    procedure DefinirParamOAuth; override;
    procedure RequisicaoJson;
    procedure RequisicaoAltera;
    procedure RequisicaoAlteraVencto;
    procedure RequisicaoAlteraDesconto;
    procedure RequisicaoAlteraDataDesconto;
    procedure RequisicaoAlteraJuros;
    procedure RequisicaoAlteraSeuNumero;
    procedure RequisicaoBaixa;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaDetalhe;
    procedure GerarPagador(AJson: TJsonObject);
    procedure GerarBenificiarioFinal(AJson: TJsonObject);
    procedure GerarInfomativo(AJson: TJsonObject);
    procedure GerarMensagem(AJson: TJsonObject);
  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: string; override;
    function Enviar: boolean; override;

  end;

const
  C_URL            = 'https://api-parceiro.sicredi.com.br/cobranca/boleto/v1';
  C_URL_HOM        = 'https://api-parceiro.sicredi.com.br/sb/cobranca/boleto/v1';

  C_URL_OAUTH_PROD = 'https://api-parceiro.sicredi.com.br/auth/openapi/token';
  C_URL_OAUTH_HOM  = 'https://api-parceiro.sicredi.com.br/sb/auth/openapi/token';

  C_ACCEPT         = 'application/json';
  C_AUTHORIZATION  = 'Authorization';
  C_GRANDTYPE      = 'password';

implementation

uses
  ACBrBoletoWS.Rest.OAuth,
  ACBrBoletoConversao;


{ TBoletoW_Sicredi_APIV2 }

procedure TBoletoW_Sicredi_APIV2.DefinirURL;
var 
  ID: String;
begin
  FPURL     := IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao,C_URL, C_URL_HOM);

  if ATitulo <> nil then 
		ID      := DefinirNossoNumero;

  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui                : FPURL := FPURL+'/boletos' ;
    tpConsulta              : FPURL := FPURL + '/boletos/liquidados/dia' + '?' + DefinirParametros;
    tpConsultaDetalhe       : FPURL := FPURL + '/boletos?' + DefinirParametrosDetalhe;
    //tpAlteraSeuNumero       : FPURL := FPURL + '/boletos/'+ ID + '/seu-numero';
    tpBaixa                 : FPURL := FPURL + '/boletos/'+ ID + '/baixa';
    //tpConsultarPDF          : FPURL := FPURL + '/boletos/pdf?linhaDigitavel='+ATitulo.LinhaDigitada;
    tpAltera                :
    begin
      case ATitulo.OcorrenciaOriginal.Tipo of
        toRemessaAlterarVencimento : FPURL := FPURL + '/boletos/'+ ID + '/data-vencimento';
        toRemessaAlterarOutrosDados:
        begin
          case ATitulo.OcorrenciaOriginal.ComplementoOutrosDados of
            TCompDesconto : FPURL := FPURL + '/boletos/'+ ID + '/desconto';
            TCompJurosDia : FPURL := FPURL + '/boletos/'+ ID + '/juros';
            TCompDataLimiteDesconto : FPURL := FPURL + '/boletos/'+ ID + '/data-desconto';
            else 
              raise EACBrBoletoWSException.Create(ClassName +
                ' N�o Implementado DefinirURL/Opera��o/tpAltera para ocorr�ncia 31 - Complemento - '+
                inttostr(integer( ATitulo.OcorrenciaOriginal.ComplementoOutrosDados)));
          end;
        end;
        else 
          raise EACBrBoletoWSException.Create(ClassName +
            ' N�o Implementado DefinirURL/Opera��o/tpAltera para ocorr�ncia '+
            inttostr(Integer(ATitulo.OcorrenciaOriginal.Tipo)));
      end;
    End;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.DefinirCodigoBeneficiario;
begin
  FPHeaders.Add(
    Format('codigoBeneficiario: %s',[Boleto.Cedente.CodigoCedente]));
end;

procedure TBoletoW_Sicredi_APIV2.DefinirContentType;
begin
  FPContentType := 'application/json';
  if (Boleto.Configuracoes.WebService.Operacao = tpConsulta) then
    FPContentType := 'application/x-www-form-urlencoded';
end;


procedure TBoletoW_Sicredi_APIV2.DefinirCooperativa;
begin
  FPHeaders.Add(
    Format('cooperativa: %s',[OnlyNumber(Boleto.Cedente.Agencia)]));
end;

procedure TBoletoW_Sicredi_APIV2.GerarHeader;
begin
	FPHeaders.Clear;
  DefinirContentType;
  DefinirKeyUser;
  DefinirPosto;
  DefinirCooperativa;
  case Boleto.Configuracoes.WebService.Operacao of
    tpBaixa,
    tpAltera
      :DefinirCodigoBeneficiario;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarInfomativo(AJson: TJsonObject);
var
  JSOnArray: TJSONArray;
  JsonPair  : TJsonPair;
  I: Integer;
begin
  try
    JsonArray := TJSONArray.Create;
    try
      if ATitulo.Informativo.Text <> '' then
      Begin
        for I := 0 to ATitulo.Informativo.Count - 1 do
        begin
          JSOnArray.Add().AsString := Copy(Atitulo.Informativo.Strings[I],1,80);
          if I = 4 then 
            break;
        end;
        JsonPair := TJSONPair.Create(AJson, 'informativos');
        try
          JsonPair.Value.AsArray := JSOnArray;
          AJson.Add('informativos').Assign(JsonPair);
        finally
          JsonPair.Free;
        end;
      End;
    finally
      JSOnArray.Free;
    end;
  finally
  end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarDados;
begin
  if Assigned(Boleto) then
   case Boleto.Configuracoes.WebService.Operacao of
     tpInclui:
       begin
         FMetodoHTTP:= htPOST;  // Define M�todo POST para Incluir
         RequisicaoJson;
       end;
     tpAltera:
       begin
         FMetodoHTTP:= htPATCH;  // Define M�todo PATCH para alteracao
         RequisicaoAltera;
       end;
     //tpAlteraSeuNumero:
     //  begin
     //    FMetodoHTTP:= htPATCH;  // Define M�todo PATCH para alteracao
     //    RequisicaoAlteraSeuNumero;
     //  end;
     tpBaixa :
       begin
         FMetodoHTTP:= htPATCH;  // Define M�todo htPATCH para Baixa
         RequisicaoBaixa;
       end;
     tpConsulta :
       begin
         FMetodoHTTP:= htGET;   //Define M�todo GET Consulta
         RequisicaoConsulta;
       end;
       tpConsultaDetalhe :
       begin
         FMetodoHTTP:= htGET;   //Define M�todo GET Consulta
         RequisicaoConsultaDetalhe;
       end;
     //tpConsultarPDF :
     //  begin
     //   FMetodoHTTP:= htGET;   //Define M�todo GET Consulta
     //  end;
   else
     raise EACBrBoletoWSException.Create(ClassName + Format(
       S_OPERACAO_NAO_IMPLEMENTADO, [
       TipoOperacaoToStr(
       Boleto.Configuracoes.WebService.Operacao)]));
   end;

end;

procedure TBoletoW_Sicredi_APIV2.DefinirAuthorization;
begin
  FPAuthorization := Format(  '%s: Bearer %s',[C_Authorization , GerarTokenAutenticacao]);
end;

function TBoletoW_Sicredi_APIV2.GerarTokenAutenticacao: string;
begin
  OAuth.ClearHeaderParams;
  OAuth.ContentType := 'application/x-www-form-urlencoded';
  OAuth.Payload := true;
  OAuth.AuthorizationType := atNoAuth;
  OAuth.AddHeaderParam('context','COBRANCA');
  OAuth.AddHeaderParam('x-api-key',Boleto.Cedente.CedenteWS.KeyUser);
  Result := inherited GerarTokenAutenticacao;
end;

procedure TBoletoW_Sicredi_APIV2.DefinirKeyUser;
begin
  FPKeyUser := Format('x-api-key: %s', [Boleto.Cedente.CedenteWS.KeyUser]);
end;

function TBoletoW_Sicredi_APIV2.DefinirNossoNumero: string;
begin
  if ATitulo.NossoNumero <> EmptyStr then
    result := OnlyNumber(ATitulo.NossoNumero)
  else
    result := OnlyNumber(ATitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(ATitulo));
end;

function TBoletoW_Sicredi_APIV2.DefinirParametros: String;
var
  Consulta : TStringList;
  Documento : String;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
      if Boleto.Configuracoes.WebService.Filtro.indicadorSituacao <> isbBaixado then
        raise EACBrBoletoWSException.Create(ClassName + ' Informar somente situa��o baixados. ');

      if (Boleto.Cedente.CodigoCedente = EmptyStr) then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o codigoCedente. ');

      Documento := OnlyNumber(Boleto.Cedente.CNPJCPF);

      Consulta := TStringList.Create;
      try
        Consulta.Delimiter := '&';
        Consulta.Add(Format('codigoBeneficiario=%s',[Boleto.Cedente.CodigoCedente]));
        Consulta.Add(Format('dia=%s', [FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio, 'DD/MM/YYYY')]));
        {
        if Documento <> '' then
          Consulta.Add(Format('cpfCnpjBeneficiarioFinal=%s',[Documento]));
        if Boleto.Configuracoes.WebService.Filtro.indiceContinuidade > 0 then
          Consulta.Add(Format('pagina=%s',[FloatToStr(Boleto.Configuracoes.WebService.Filtro.indiceContinuidade)]));
        }
      finally
        Result := Consulta.DelimitedText;
        Consulta.Free;
      end;
  end;
end;

function TBoletoW_Sicredi_APIV2.DefinirParametrosDetalhe: String;
var
  Consulta : TStringList;
  Documento : String;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
      if (Boleto.Cedente.CodigoCedente = EmptyStr) then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o codigoCedente. ');

      Documento := OnlyNumber(Boleto.Cedente.CNPJCPF);

      Consulta := TStringList.Create;
      try
        Consulta.Delimiter := '&';
        Consulta.Add(Format('codigoBeneficiario=%s',[Boleto.Cedente.CodigoCedente]));        
        Consulta.Add(Format('nossoNumero=%s',[DefinirNossoNumero]));
        Result := Consulta.DelimitedText;
      finally
        Consulta.Free;
      end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.DefinirParamOAuth;
begin
  FParamsOAuth := Format( 'username=%s&password=%s&scope=%s&grant_type=password',
                   [Boleto.Cedente.CedenteWS.ClientID,
                    Boleto.Cedente.CedenteWS.ClientSecret,
                    Boleto.Cedente.CedenteWS.Scope] );
end;

procedure TBoletoW_Sicredi_APIV2.DefinirPosto;
begin
  FPHeaders.Add(
    Format('posto: %s', [OnlyNumber(Boleto.Cedente.AgenciaDigito)]));
end;

procedure TBoletoW_Sicredi_APIV2.DefinirAutenticacao;
begin
  FPAuthorization := Format( '%s: %s', [C_ACCESS_TOKEN , GerarTokenAutenticacao]);
end;

function TBoletoW_Sicredi_APIV2.ValidaAmbiente: Integer;
begin
  Result := StrToIntDef(IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao, '1','2'),2);
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoJson;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('tipoCobranca').Value.AsString                           := IfThen(Boleto.Cedente.CedenteWS.IndicadorPix,'HIBRIDO','NORMAL');
      Json.Add('codigoBeneficiario').Value.AsString                     := Boleto.Cedente.CodigoCedente;
      Json.Add('especieDocumento').Value.AsString                       := self.codigoTipoTitulo(ATitulo.EspecieDoc);
      Json.Add('nossoNumero').Value.AsString                            := DefinirNossoNumero;
      Json.Add('seuNumero').Value.AsString                              := ATitulo.SeuNumero;
      Json.Add('dataVencimento').Value.AsString                         := FormatDateBr(ATitulo.Vencimento, 'YYYY-MM-DD');
      if (ATitulo.DataProtesto > 0) then
        Json.Add('diasProtestoAuto').Value.AsInteger                    := Trunc(ATitulo.DataProtesto - ATitulo.Vencimento);
      if (ATitulo.DiasDeNegativacao > 0) then
        Json.Add('diasNegativacaoAuto').Value.AsInteger                 := ATitulo.DiasDeNegativacao;
     
      Json.Add('valor').Value.AsNumber                                  := ATitulo.ValorDocumento;
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      Begin
        Json.Add('tipoDesconto').Value.AsString                         := Self.TipoDescontoToString(ATitulo.TipoDesconto);
        Json.Add('valorDesconto1').Value.AsNumber                       := ATitulo.ValorDesconto;
        Json.Add('dataDesconto1').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto, 'YYYY-MM-DD');
      End;
      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      Begin
        Json.Add('tipoDesconto').Value.AsString                         := Self.TipoDescontoToString(ATitulo.TipoDesconto);
        Json.Add('valorDesconto2').Value.AsNumber                       := ATitulo.ValorDesconto2;
        Json.Add('dataDesconto2').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto2, 'YYYY-MM-DD');
      End;
      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      Begin
        Json.Add('tipoDesconto').Value.AsString                         := Self.TipoDescontoToString(ATitulo.TipoDesconto);
        Json.Add('valorDesconto3').Value.AsNumber                       := ATitulo.ValorDesconto3;
        Json.Add('dataDesconto3').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto3, 'YYYY-MM-DD');
      End;
      if ATitulo.ValorDescontoAntDia > 0 then
        Json.Add('descontoAtencipado').Value.AsNumber                   := ATitulo.ValorDescontoAntDia;
      if ATitulo.ValorMoraJuros > 0 then
      Begin
        Json.Add('tipoJuros').Value.AsString                            := Self.TipoJuros(ATitulo.CodigoMora);
        Json.Add('juros').Value.AsNumber                                := ATitulo.ValorMoraJuros;
      End;
      if ATitulo.PercentualMulta > 0 then
        Json.Add('multa').Value.AsNumber                                := ATitulo.PercentualMulta;
      GerarPagador(Json);
      GerarBenificiarioFinal(Json);
      GerarMensagem(Json);
      GerarInfomativo(Json);

      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAltera;
begin
  if Assigned(ATitulo) then
  begin
    case ATitulo.OcorrenciaOriginal.Tipo of
      toRemessaAlterarVencimento  : RequisicaoAlteraVencto;
      toRemessaAlterarOutrosDados :
          Begin
            case ATitulo.OcorrenciaOriginal.ComplementoOutrosDados of
              TCompDesconto           : RequisicaoAlteraDesconto;
              TCompJurosDia           : RequisicaoAlteraJuros;
              TCompDataLimiteDesconto : RequisicaoAlteraDataDesconto;
              else
              raise EACBrBoletoWSException.Create(ClassName + Format(S_OPERACAO_NAO_IMPLEMENTADO, [
              '  RequisicaoAltera/Opera��o/tpAltera para ocorr�ncia 31 - Complemento - '+inttostr(Integer(ATitulo.OcorrenciaOriginal.ComplementoOutrosDados))]));
            end;
          End;
      else
        raise EACBrBoletoWSException.Create(ClassName + Format(S_OPERACAO_NAO_IMPLEMENTADO, [
         ' RequisicaoAltera/Opera��o/tpAltera para ocorr�ncia '+inttostr(Integer(ATitulo.OcorrenciaOriginal.Tipo))]));
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraDataDesconto;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('dataDesconto1').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto, 'YYYY-MM-DD');

      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('dataDesconto2').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto2, 'YYYY-MM-DD');

      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('dataDesconto3').Value.AsString                        := FormatDateBr(ATitulo.DataDesconto3, 'YYYY-MM-DD');

      if (Json.Count = 0) then
        raise EACBrBoletoWSException.Create(ClassName + ' Para requisi��es de altera��o de data desconto � necess�rio informar ao menos um dos campo de data desconto!');
      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraDesconto;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('valorDesconto1').Value.AsNumber                       := ATitulo.ValorDesconto;

      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('valorDesconto2').Value.AsNumber                       := ATitulo.ValorDesconto2;

      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
        Json.Add('valorDesconto3').Value.AsNumber                       := ATitulo.ValorDesconto3;

      if (Json.Count = 0) then
         raise EACBrBoletoWSException.Create(ClassName + 'Para requisi��es de altera��o de desconto � necess�rio informar ao menos um dos campo de desconto!');
				 
      Data := Json.Stringify;
      FPDadosMsg := Data;
    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraJuros;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('valorouPercentual').Value.AsNumber                         := ATitulo.ValorMoraJuros;
      Data := Json.Stringify;
      FPDadosMsg := Data;
    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraSeuNumero;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('seuNumero').Value.AsString                         := ATitulo.SeuNumero;

      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;


procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraVencto;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('dataVencimento').Value.AsString                         := FormatDateBr(ATitulo.Vencimento, 'YYYY-MM-DD');

      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoBaixa;
begin
  if Assigned(ATitulo) then
  begin
    try
      FPDadosMsg := '{}';
    finally
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoConsulta;
begin
   //Sem Payload - Define M�todo GET
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoConsultaDetalhe;
begin
    //Sem Payload - Define M�todo GET
end;

procedure TBoletoW_Sicredi_APIV2.GerarPagador(AJson: TJsonObject);
var
  JsonDadosPagador: TJsonObject;
  JsonPairPagador: TJsonPair;

begin
  if Assigned(ATitulo) then
  begin
    if Assigned(AJson) then
    begin
      JsonDadosPagador := TJSONObject.Create;

      try
        JsonDadosPagador.Add('tipoPessoa').Value.AsString       := IfThen(Length( OnlyNumber(ATitulo.Sacado.CNPJCPF)) = 11,'PESSOA_FISICA','PESSOA_JURIDICA');
        JsonDadosPagador.Add('documento').Value.AsString        := OnlyNumber(ATitulo.Sacado.CNPJCPF);
        JsonDadosPagador.Add('nome').Value.AsString             := ATitulo.Sacado.NomeSacado;
        JsonDadosPagador.Add('endereco').Value.AsString         := ATitulo.Sacado.Logradouro + ' ' + ATitulo.Sacado.Numero;
        JsonDadosPagador.Add('cidade').Value.AsString           := ATitulo.Sacado.Cidade;
        JsonDadosPagador.Add('uf').Value.AsString               := ATitulo.Sacado.UF;
        JsonDadosPagador.Add('cep').Value.AsString              := OnlyNumber(ATitulo.Sacado.CEP);
        if ATitulo.Sacado.Fone <> '' then
          JsonDadosPagador.Add('telefone').Value.AsString         := ATitulo.Sacado.Fone;
        if ATitulo.Sacado.Email <> '' then
          JsonDadosPagador.Add('email').Value.AsString            := ATitulo.Sacado.Email;
        JsonPairPagador := TJsonPair.Create(AJson, 'pagador');
        try
          JsonPairPagador.Value.AsObject := JsonDadosPagador;
          AJson.Add('pagador').Assign(JsonPairPagador);
        finally
          JsonPairPagador.Free;
        end;
      finally
        JsonDadosPagador.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_Sicredi_APIV2.GerarBenificiarioFinal(AJson: TJsonObject);
var
  JsonSacadorAvalista: TJsonObject;
  JsonPairSacadorAvalista: TJsonPair;

begin
  if Assigned(ATitulo) then
  begin
      if ATitulo.Sacado.SacadoAvalista.CNPJCPF = EmptyStr then
        Exit;

      if Assigned(AJson) then
      begin
        JsonSacadorAvalista := TJSONObject.Create;

        try
          JsonSacadorAvalista.Add('tipoPessoa').Value.AsString         :=  IfThen( Length( OnlyNumber(ATitulo.Sacado.SacadoAvalista.CNPJCPF)) = 11,'PESSOA_FISICA','PESSOA_JURIDICA');
          JsonSacadorAvalista.Add('documento').Value.AsString           :=  OnlyNumber(ATitulo.Sacado.SacadoAvalista.CNPJCPF);
          JsonSacadorAvalista.Add('nome').Value.AsString                :=  ATitulo.Sacado.SacadoAvalista.NomeAvalista;

          if ATitulo.Sacado.SacadoAvalista.Logradouro <> '' then
            JsonSacadorAvalista.Add('logradouro').Value.AsString          :=  ATitulo.Sacado.SacadoAvalista.Logradouro;
          if ATitulo.Sacado.SacadoAvalista.Complemento <> '' then
            JsonSacadorAvalista.Add('complemento').Value.AsString         :=  ATitulo.Sacado.SacadoAvalista.Complemento;
          if ATitulo.Sacado.SacadoAvalista.Numero <> '' then
            JsonSacadorAvalista.Add('numeroEndereco').Value.AsString      :=  ATitulo.Sacado.SacadoAvalista.Numero;
          if ATitulo.Sacado.SacadoAvalista.Cidade <> '' then
            JsonSacadorAvalista.Add('cidade').Value.AsString              :=  ATitulo.Sacado.SacadoAvalista.Cidade;
          if ATitulo.Sacado.SacadoAvalista.UF <> '' then
            JsonSacadorAvalista.Add('uf').Value.AsString                  :=  ATitulo.Sacado.SacadoAvalista.UF;
          if ATitulo.Sacado.SacadoAvalista.CEP <> '' then
            JsonSacadorAvalista.Add('cep').Value.AsString                 :=  OnlyNumber(ATitulo.Sacado.SacadoAvalista.CEP);
          if ATitulo.Sacado.SacadoAvalista.Fone <> '' then
            JsonSacadorAvalista.Add('telefone').Value.AsString            :=  ATitulo.Sacado.SacadoAvalista.Fone;
          if ATitulo.Sacado.SacadoAvalista.Email <> '' then
            JsonSacadorAvalista.Add('email').Value.AsString               :=  ATitulo.Sacado.SacadoAvalista.Email;

          JsonPairSacadorAvalista := TJsonPair.Create(AJson, 'beneficiarioFinal');
          try
            JsonPairSacadorAvalista.Value.AsObject := JsonSacadorAvalista;
            AJson.Add('beneficiarioFinal').Assign(JsonPairSacadorAvalista);
          finally
            JsonPairSacadorAvalista.Free;
          end;
        finally
          JsonSacadorAvalista.Free;
        end;
      end;

    end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarMensagem(AJson: TJsonObject);
var
  JSOnArray: TJSONArray;
  JsonPair  : TJsonPair;
  I: Integer;
begin
  try
    JsonArray := TJSONArray.Create;
    try
      if ATitulo.Mensagem.Text <> '' then
      Begin
        for I := 0 to ATitulo.Mensagem.Count - 1 do
        begin
          JSOnArray.Add().AsString := Copy(Atitulo.Mensagem.Strings[I],1,80);
          if I = 3 then break;//Somente 4 infos
        end;
        JsonPair := TJSONPair.Create(AJson, 'mensagens');
        try
          JsonPair.Value.AsArray := JSOnArray;
          AJson.Add('mensagens').Assign(JsonPair);
        finally
          JsonPair.Free;
        end;
      End;
    finally
      JSOnArray.Free;
    end;
  finally
  end;
end;

function TBoletoW_Sicredi_APIV2.CodigoTipoTitulo(AEspecieDoc : String): String;
begin
  { Pegando o tipo de EspecieDoc }
  if AEspecieDoc = 'DMI' then
     AEspecieDoc   := 'DUPLICATA_MERCANTIL_INDICACAO'
  else if AEspecieDoc = 'DR' then
     AEspecieDoc   := 'DUPLICATA_RURAL'
  else if AEspecieDoc = 'NP' then
     AEspecieDoc   := 'NOTA_PROMISSORIA'
  else if AEspecieDoc = 'NR' then
     AEspecieDoc   := 'NOTA_PROMISSORIA_RURAL'
  else if AEspecieDoc = 'NS' then
     AEspecieDoc   := 'NOTA_SEGUROS'
  else if AEspecieDoc = 'RC' then
     AEspecieDoc   := 'RECIBO'
  else if AEspecieDoc = 'LC' then
     AEspecieDoc   := 'LETRA_CAMBIO'
  else if AEspecieDoc = 'ND' then
     AEspecieDoc   := 'NOTA_DEBITO'
  else if AEspecieDoc = 'DSI' then
     AEspecieDoc   := 'DUPLICATA_SERVICO_INDICACAO'
  else if AEspecieDoc = 'OS' then
     AEspecieDoc   := 'OUTROS'
  else if AEspecieDoc = 'O' then
     AEspecieDoc   := 'BOLETO_PROPOSTA'
  else if AEspecieDoc = 'P' then
     AEspecieDoc   := 'CARTAO_CREDITO'
  else
     AEspecieDoc := 'DUPLICATA_MERCANTIL_INDICACAO';
  Result := AEspecieDoc;
end;

constructor TBoletoW_Sicredi_APIV2.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);

  FPAccept := C_ACCEPT;

  if Assigned(OAuth) then
  begin
    if OAuth.Ambiente = taHomologacao then
      OAuth.URL := C_URL_OAUTH_HOM
    else
      OAuth.URL := C_URL_OAUTH_PROD;

    OAuth.Payload := True;
  end;

end;

function TBoletoW_Sicredi_APIV2.GerarRemessa: string;
begin
  Result := inherited GerarRemessa;
end;

function TBoletoW_Sicredi_APIV2.Enviar: boolean;
begin
  Result := inherited Enviar;
end;

function TBoletoW_Sicredi_APIV2.TipoDescontoToString(const AValue: TACBrTipoDesconto
  ): String;
begin
  begin
    case AValue of
      tdValorFixoAteDataInformada : Result := 'VALOR';
      tdPercentualAteDataInformada : Result := 'PERCENTUAL';
      tdValorAntecipacaoDiaCorrido : Result := 'VALOR';
      tdValorAntecipacaoDiaUtil : Result := 'VALOR';
      tdPercentualSobreValorNominalDiaCorrido : Result := 'PERCENTUAL';
      tdPercentualSobreValorNominalDiaUtil : Result := 'PERCENTUAL';
    else
      Result := 'VALOR';
    end;
  end;
end;


function TBoletoW_Sicredi_APIV2.TipoJuros(const AValue: String): String;
begin
  if (AValue = 'A') then
    Result := 'VALOR'
  else   if (AValue = 'B') then
    Result := 'PERCENTUAL'
  else
    Result := 'VALOR'
end;

end.

