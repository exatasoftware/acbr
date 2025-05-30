{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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
  ACBrBase,
  ACBrJSON,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoWS.Rest, ACBrUtil.FilesIO;

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
    procedure RequisicaoAlteraVencimento;
    procedure RequisicaoAlteraDesconto;
    procedure RequisicaoAlteraDataDesconto;
    procedure RequisicaoAlteraJuros;
    procedure RequisicaoAlteraSeuNumero;
    procedure RequisicaoBaixa;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaDetalhe;
    procedure RequisicaoConcederAbatimento;
    procedure GerarPagador(AJson: TACBrJSONObject);
    procedure GerarEnderecoPagador(AJson: TACBrJSONObject);
    procedure GerarBenificiarioFinal(AJson: TACBrJSONObject);
    procedure GerarInfomativo(AJson: TACBrJSONObject);
    procedure GerarMensagem(AJson: TACBrJSONObject);
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
  SysUtils,
  Classes,
  Synacode,
  StrUtils,

  pcnConversao,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  ACBrBoletoWS.Rest.OAuth,
  ACBrBoletoConversao;


{ TBoletoW_Sicredi_APIV2 }

procedure TBoletoW_Sicredi_APIV2.DefinirURL;
var
  LId: String;
begin
  case Boleto.Configuracoes.WebService.Ambiente of
    tawsProducao   : FPURL.URLProducao    := C_URL;
    tawsHomologacao: FPURL.URLHomologacao := C_URL_HOM;
  end;
  if ATitulo <> nil then
		LId      := DefinirNossoNumero;

  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui                : FPURL.SetPathURI( '/boletos' );
    tpConsulta              : FPURL.SetPathURI( '/boletos/liquidados/dia' + '?' + DefinirParametros );
    tpConsultaDetalhe       : FPURL.SetPathURI( '/boletos?' + DefinirParametrosDetalhe );
    tpBaixa                 : FPURL.SetPathURI( '/boletos/'+ LId + '/baixa' );
    tpAltera                :
    begin
      case ATitulo.OcorrenciaOriginal.Tipo of
        toRemessaAlterarVencimento  : FPURL.SetPathURI( '/boletos/'+ LId + '/data-vencimento' );
        toRemessaConcederAbatimento : FPURL.SetPathURI( '/boletos/'+ LId + '/conceder-abatimento' );
        toRemessaAlterarOutrosDados :
        begin
          case ATitulo.OcorrenciaOriginal.ComplementoOutrosDados of
            TCompDesconto : FPURL.SetPathURI( '/boletos/'+ LId + '/desconto' );
            TCompJurosDia : FPURL.SetPathURI( '/boletos/'+ LId + '/juros' );
            TCompDataLimiteDesconto : FPURL.SetPathURI( '/boletos/'+ LId + '/data-desconto' );
            else
              raise EACBrBoletoWSException.Create(ClassName +
                ' N�o Implementado DefinirURL/Opera��o/tpAltera para ocorr�ncia 31 - Complemento - '+
                IntToStr(Integer( ATitulo.OcorrenciaOriginal.ComplementoOutrosDados)));
          end;
        end;
        else
          raise EACBrBoletoWSException.Create(ClassName +
            ' N�o Implementado DefinirURL/Opera��o/tpAltera para ocorr�ncia '+
            inttostr(Integer(ATitulo.OcorrenciaOriginal.Tipo)));
      end;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.DefinirCodigoBeneficiario;
begin
  AddHeaderParam('codigoBeneficiario',Boleto.Cedente.CodigoCedente);
end;

procedure TBoletoW_Sicredi_APIV2.DefinirContentType;
begin
  FPContentType := 'application/json; charset=utf-8';
  if (Boleto.Configuracoes.WebService.Operacao = tpConsulta) then
    FPContentType := 'application/x-www-form-urlencoded';
end;

procedure TBoletoW_Sicredi_APIV2.DefinirCooperativa;
begin
  AddHeaderParam('cooperativa',OnlyNumber(Boleto.Cedente.Agencia) );
end;

procedure TBoletoW_Sicredi_APIV2.GerarHeader;
begin
  ClearHeaderParams;
  DefinirContentType;
  DefinirKeyUser;
  DefinirPosto;
  DefinirCooperativa;
  case Boleto.Configuracoes.WebService.Operacao of
    tpBaixa,
    tpAltera
      : DefinirCodigoBeneficiario;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarInfomativo(AJson: TACBrJSONObject);
var
  LJsonArray: TACBrJSONArray;
  I: Integer;
begin
  if ATitulo.Informativo.Text <> '' then
  begin
    LJsonArray := TACBrJSONArray.Create;
    for I := 0 to ATitulo.Informativo.Count - 1 do
    begin
      LJsonArray.AddElement(Copy(Atitulo.Informativo[I],1,80));
      if I = 4 then
        break;
    end;
    AJson.AddPair('informativos', LJsonArray);
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
   else
     raise EACBrBoletoWSException.Create(ClassName + Format(
       S_OPERACAO_NAO_IMPLEMENTADO, [
       TipoOperacaoToStr( Boleto.Configuracoes.WebService.Operacao ) ] ) );
   end;
end;

procedure TBoletoW_Sicredi_APIV2.DefinirAuthorization;
begin
  FPAuthorization := Format( '%s: Bearer %s',[C_Authorization , GerarTokenAutenticacao] );
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
  result := OnlyNumber(ATitulo.ACBrBoleto.Banco.MontarCampoNossoNumero(ATitulo));
end;

function TBoletoW_Sicredi_APIV2.DefinirParametros: String;
var
  LConsulta : TStringList;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
      if Boleto.Configuracoes.WebService.Filtro.indicadorSituacao <> isbBaixado then
        raise EACBrBoletoWSException.Create(ClassName + ' Informar somente situa��o baixados. ');

      if (Boleto.Cedente.CodigoCedente = EmptyStr) then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o codigoCedente. ');

      LConsulta := TStringList.Create;
      try
        LConsulta.Delimiter := '&';
        LConsulta.Add(Format('codigoBeneficiario=%s',[Boleto.Cedente.CodigoCedente]));
        LConsulta.Add(Format('dia=%s', [FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio, 'DD/MM/YYYY')]));

        if Boleto.Configuracoes.WebService.Filtro.indiceContinuidade > 0 then
           LConsulta.Add('pagina='+FloatToStr(Boleto.Configuracoes.WebService.Filtro.indiceContinuidade));

      finally
        Result := LConsulta.DelimitedText;
        LConsulta.Free;
      end;
  end;
end;

function TBoletoW_Sicredi_APIV2.DefinirParametrosDetalhe: String;
var
  LConsulta : TStringList;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
    if (Boleto.Cedente.CodigoCedente = EmptyStr) then
      raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o codigoCedente. ');

    LConsulta := TStringList.Create;
    try
      LConsulta.Delimiter := '&';
      LConsulta.Add(Format('codigoBeneficiario=%s',[Boleto.Cedente.CodigoCedente]));
      LConsulta.Add(Format('nossoNumero=%s',[DefinirNossoNumero]));
      Result := LConsulta.DelimitedText;
    finally
      LConsulta.Free;
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
  if Length(Boleto.Cedente.AgenciaDigito) <> 2 then
     raise EACBrException.Create('Ag�ncia necessidade de dois digitos!');
  AddHeaderParam('posto',Boleto.Cedente.AgenciaDigito );
end;

procedure TBoletoW_Sicredi_APIV2.DefinirAutenticacao;
begin
  FPAuthorization := Format( '%s: %s', [C_ACCESS_TOKEN , GerarTokenAutenticacao]);
end;

function TBoletoW_Sicredi_APIV2.ValidaAmbiente: Integer;
begin
  Result := StrToIntDef(IfThen(Boleto.Configuracoes.WebService.Ambiente = tawsProducao, '1', '2'), 2);
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoJson;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('tipoCobranca', IfThen(Boleto.Cedente.CedenteWS.IndicadorPix, 'HIBRIDO', 'NORMAL') );
      LJsonObject.AddPair('codigoBeneficiario', Boleto.Cedente.CodigoCedente);
      LJsonObject.AddPair('especieDocumento', Self.codigoTipoTitulo(ATitulo.EspecieDoc));
      LJsonObject.AddPair('nossoNumero', DefinirNossoNumero);
      LJsonObject.AddPair('seuNumero', ATitulo.SeuNumero);
      LJsonObject.AddPair('dataVencimento', FormatDateBr(ATitulo.Vencimento, 'YYYY-MM-DD') );
      if (ATitulo.DataProtesto > 0) then
        LJsonObject.AddPair('diasProtestoAuto', Trunc(ATitulo.DataProtesto - ATitulo.Vencimento) );
      if (ATitulo.DiasDeNegativacao > 0) then
        LJsonObject.AddPair('diasNegativacaoAuto', ATitulo.DiasDeNegativacao);

      LJsonObject.AddPair('valor', ATitulo.ValorDocumento);
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('tipoDesconto', Self.TipoDescontoToString(ATitulo.TipoDesconto) );
        LJsonObject.AddPair('valorDesconto1', ATitulo.ValorDesconto);
        LJsonObject.AddPair('dataDesconto1', FormatDateBr(ATitulo.DataDesconto, 'YYYY-MM-DD') );
      end;
      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('tipoDesconto', Self.TipoDescontoToString(ATitulo.TipoDesconto) );
        LJsonObject.AddPair('valorDesconto2', ATitulo.ValorDesconto2);
        LJsonObject.AddPair('dataDesconto2', FormatDateBr(ATitulo.DataDesconto2, 'YYYY-MM-DD') );
      end;
      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('tipoDesconto', Self.TipoDescontoToString(ATitulo.TipoDesconto) );
        LJsonObject.AddPair('valorDesconto3', ATitulo.ValorDesconto3);
        LJsonObject.AddPair('dataDesconto3', FormatDateBr(ATitulo.DataDesconto3, 'YYYY-MM-DD') );
      end;
      if ATitulo.ValorDescontoAntDia > 0 then
        LJsonObject.AddPair('descontoAtencipado', ATitulo.ValorDescontoAntDia);
      if ATitulo.ValorMoraJuros > 0 then
      begin
        LJsonObject.AddPair('tipoJuros', Self.TipoJuros(ATitulo.CodigoMora) );
        LJsonObject.AddPair('juros', ATitulo.ValorMoraJuros);
      end;
      if ATitulo.PercentualMulta > 0 then
        LJsonObject.AddPair('multa', ATitulo.PercentualMulta);

      GerarPagador(LJsonObject);
      GerarBenificiarioFinal(LJsonObject);
      GerarMensagem(LJsonObject);
      GerarInfomativo(LJsonObject);

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAltera;
begin
  if Assigned(ATitulo) then
  begin
    case ATitulo.OcorrenciaOriginal.Tipo of
      toRemessaAlterarVencimento  : RequisicaoAlteraVencimento;
      toRemessaConcederAbatimento : RequisicaoConcederAbatimento;
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
  LDescontoErro : Boolean;
  LJsonObject: TACBrJSONObject;
begin
  LDescontoErro := True;
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('data1', FormatDateBr(ATitulo.DataDesconto, 'YYYY-MM-DD') );
        LDescontoErro := False;
      end;

      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('data2', FormatDateBr(ATitulo.DataDesconto2, 'YYYY-MM-DD') );
        LDescontoErro := False;
      end;

      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('data3', FormatDateBr(ATitulo.DataDesconto3, 'YYYY-MM-DD') );
        LDescontoErro := False;
      end;

      if LDescontoErro then
        raise EACBrBoletoWSException.Create(ClassName + ' Para requisi��es de altera��o de data desconto � necess�rio informar ao menos um dos campo de data desconto!');

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraDesconto;
var
  LDescontoErro : Boolean;
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      if ((ATitulo.DataDesconto > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('valorDesconto1', ATitulo.ValorDesconto);
        LDescontoErro := False;
      end;

      if ((ATitulo.DataDesconto2 > EncodeDate(2000,01,01))and(ATitulo.ValorDesconto2 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('valorDesconto2', ATitulo.ValorDesconto2);
        LDescontoErro := False;
      end;

      if ((ATitulo.DataDesconto3 > EncodeDate(2000,01,01)) and(ATitulo.ValorDesconto3 > 0) and (ATitulo.ValorDescontoAntDia = 0)) then
      begin
        LJsonObject.AddPair('valorDesconto3', ATitulo.ValorDesconto3);
        LDescontoErro := False;
      end;

      if LDescontoErro then
         raise EACBrBoletoWSException.Create(ClassName + 'Para requisi��es de altera��o de desconto � necess�rio informar ao menos um dos campo de desconto!');

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraJuros;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('valorOuPercentual', ATitulo.ValorMoraJuros);
      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraSeuNumero;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('seuNumero', ATitulo.SeuNumero);

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoAlteraVencimento;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('dataVencimento', FormatDateBr(ATitulo.Vencimento, 'YYYY-MM-DD') );

      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoBaixa;
begin
  if Assigned(ATitulo) then
  begin
    FPDadosMsg := '{}';
  end;
end;

procedure TBoletoW_Sicredi_APIV2.RequisicaoConcederAbatimento;
var
  LJsonObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    LJsonObject := TACBrJSONObject.Create;
    try
      LJsonObject.AddPair('valorAbatimento', ATitulo.ValorAbatimento);
      FPDadosMsg := LJsonObject.ToJSON;
    finally
      LJsonObject.Free;
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

procedure TBoletoW_Sicredi_APIV2.GerarPagador(AJson: TACBrJSONObject);
var
  LJsonPagadorObject : TACBrJSONObject;
begin
  if Assigned(ATitulo) and Assigned(AJson) then
  begin
    LJsonPagadorObject := TACBrJSONObject.Create;

    LJsonPagadorObject.AddPair('tipoPessoa', IfThen(Length( OnlyNumber(ATitulo.Sacado.CNPJCPF)) = 11,'PESSOA_FISICA','PESSOA_JURIDICA') );
    LJsonPagadorObject.AddPair('documento', OnlyNumber(ATitulo.Sacado.CNPJCPF));
    LJsonPagadorObject.AddPair('nome', Copy(ATitulo.Sacado.NomeSacado, 1, 40));

    GerarEnderecoPagador(LJsonPagadorObject);

    if ATitulo.Sacado.Fone <> '' then
      LJsonPagadorObject.AddPair('telefone', Copy(ATitulo.Sacado.Fone, 1, 11));
    if ATitulo.Sacado.Email <> '' then
      LJsonPagadorObject.AddPair('email', Copy(ATitulo.Sacado.Email, 1, 40));

    AJson.AddPair('pagador', LJsonPagadorObject);
  end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarEnderecoPagador(AJson: TACBrJSONObject);
var
  LTamanhoNumero, LTamanhoLogradouro: Integer;
  LLogradouro: string;
begin
  LTamanhoNumero     := Length(trim(ATitulo.Sacado.Numero)) + 1;
  LTamanhoLogradouro := Length(trim(ATitulo.Sacado.Logradouro)) + LTamanhoNumero;

  LLogradouro :=  ifthen(LTamanhoLogradouro > 40,Copy(trim(ATitulo.Sacado.Logradouro), 1, (40 - LTamanhoNumero)),
                                                        trim(ATitulo.Sacado.Logradouro));

  AJson.AddPair('endereco', LLogradouro + ',' + trim(ATitulo.Sacado.Numero));
  AJson.AddPair('cidade', Copy(ATitulo.Sacado.Cidade, 1, 25));
  AJson.AddPair('uf', Copy(ATitulo.Sacado.UF, 1, 2));
  AJson.AddPair('cep', Copy(OnlyNumber(ATitulo.Sacado.CEP), 1, 8));
end;

procedure TBoletoW_Sicredi_APIV2.GerarBenificiarioFinal(AJson: TACBrJSONObject);
var
  LJsonPagadorFinalObject: TACBrJSONObject;
begin
  if Assigned(ATitulo) then
  begin
    if ATitulo.Sacado.SacadoAvalista.CNPJCPF = EmptyStr then
      Exit;

    if Assigned(AJson) then
    begin
      LJsonPagadorFinalObject := TACBrJSONObject.Create;

      LJsonPagadorFinalObject.AddPair('tipoPessoa', IfThen( Length( OnlyNumber(ATitulo.Sacado.SacadoAvalista.CNPJCPF)) = 11,'PESSOA_FISICA','PESSOA_JURIDICA') );
      LJsonPagadorFinalObject.AddPair('documento', OnlyNumber(ATitulo.Sacado.SacadoAvalista.CNPJCPF) );
      LJsonPagadorFinalObject.AddPair('nome', ATitulo.Sacado.SacadoAvalista.NomeAvalista);

      if ATitulo.Sacado.SacadoAvalista.Logradouro <> '' then
        LJsonPagadorFinalObject.AddPair('logradouro', ATitulo.Sacado.SacadoAvalista.Logradouro);
      if ATitulo.Sacado.SacadoAvalista.Complemento <> '' then
        LJsonPagadorFinalObject.AddPair('complemento', ATitulo.Sacado.SacadoAvalista.Complemento);
      if ATitulo.Sacado.SacadoAvalista.Numero <> '' then
        LJsonPagadorFinalObject.AddPair('numeroEndereco', ATitulo.Sacado.SacadoAvalista.Numero);
      if ATitulo.Sacado.SacadoAvalista.Cidade <> '' then
        LJsonPagadorFinalObject.AddPair('cidade', ATitulo.Sacado.SacadoAvalista.Cidade);
      if ATitulo.Sacado.SacadoAvalista.UF <> '' then
        LJsonPagadorFinalObject.AddPair('uf', ATitulo.Sacado.SacadoAvalista.UF);
      if ATitulo.Sacado.SacadoAvalista.CEP <> '' then
        LJsonPagadorFinalObject.AddPair('cep', OnlyNumber(ATitulo.Sacado.SacadoAvalista.CEP) );
      if ATitulo.Sacado.SacadoAvalista.Fone <> '' then
        LJsonPagadorFinalObject.AddPair('telefone', ATitulo.Sacado.SacadoAvalista.Fone);
      if ATitulo.Sacado.SacadoAvalista.Email <> '' then
        LJsonPagadorFinalObject.AddPair('email', ATitulo.Sacado.SacadoAvalista.Email);

      AJson.AddPair('beneficiarioFinal',LJsonPagadorFinalObject);

    end;
  end;
end;

procedure TBoletoW_Sicredi_APIV2.GerarMensagem(AJson: TACBrJSONObject);
var
  LJsonMensagemArray : TACBrJSONArray;
  I: Integer;
begin

  if Trim(ATitulo.Mensagem.Text) <> '' then
  begin
    LJsonMensagemArray := TACBrJSONArray.Create;
    for I := 0 to ATitulo.Mensagem.Count - 1 do
    begin
      LJsonMensagemArray.AddElement( Copy(Trim(Atitulo.Mensagem.Strings[I]),1,80) );
      if I = 3 then break;//Somente 4 infos
    end;
    AJson.AddPair('mensagens', LJsonMensagemArray);
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
    case OAuth.Ambiente of
      tawsProducao: OAuth.URL.URLProducao := C_URL_OAUTH_PROD;
      tawsHomologacao: OAuth.URL.URLHomologacao := C_URL_OAUTH_HOM;
    end;

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

function TBoletoW_Sicredi_APIV2.TipoDescontoToString(const AValue: TACBrTipoDesconto): String;
begin
  begin
    case AValue of
      tdValorFixoAteDataInformada               : Result := 'VALOR';
      tdPercentualAteDataInformada              : Result := 'PERCENTUAL';
      tdValorAntecipacaoDiaCorrido              : Result := 'VALOR';
      tdValorAntecipacaoDiaUtil                 : Result := 'VALOR';
      tdPercentualSobreValorNominalDiaCorrido   : Result := 'PERCENTUAL';
      tdPercentualSobreValorNominalDiaUtil      : Result := 'PERCENTUAL';
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

