{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:  Jos� M S Junior, Victor Hugo Gonzales          }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

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

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBoletoW_BancoBrasil_API;

interface

uses
  Classes, SysUtils, ACBrBoletoWS, pcnConversao, ACBrBoletoConversao,
  Jsons, ACBrUtil;

type

  { TBoletoW_BancoBrasil_API }
  TBoletoW_BancoBrasil_API = class(TBoletoWSREST)
  private
    function CodigoTipoTitulo(AEspecieDoc:String): Integer;
  protected
    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirAuthorization; override;
    function GerarTokenAutenticacao: string; override;
    function DefinirParametros:String;
    procedure DefinirKeyUser;
    procedure DefinirAutenticacao;
    function ValidaAmbiente: Integer;
    procedure RequisicaoJson;
    procedure RequisicaoAltera;
    procedure RequisicaoBaixa;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaDetalhe;
    procedure GerarPagador(AJson: TJsonObject);
    procedure GerarBenificiarioFinal(AJson: TJsonObject);
    procedure GerarJuros(AJson: TJsonObject);
    procedure GerarMulta(AJson: TJsonObject);
    procedure GerarDesconto(AJson: TJsonObject);

    procedure AlteraDataVencimento(AJson: TJsonObject);
    procedure AtribuirDesconto(AJson: TJsonObject);
    procedure AlteracaoDesconto(AJson: TJsonObject);
    procedure AlteracaoDataDesconto(AJson: TJsonObject);
    procedure AlterarProtesto(AJson: TJsonObject);
    procedure AtribuirAbatimento(AJson: TJsonObject);
    procedure AlteracaoAbatimento(AJson: TJsonObject);
    procedure AtribuirJuros(AJson: TJsonObject);
    procedure AtribuirMulta(AJson: TJsonObject);
    procedure AtribuirNegativacao(AJson: TJsonObject);
    procedure AlteracaoSeuNumero(AJson: TJsonObject);
    procedure AlteracaoEnderecoPagador(AJson: TJsonObject);
    procedure AlteracaoPrazo(AJson: TJsonObject);

  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: string; override;
    function Enviar: boolean; override;

  end;

const
  C_URL            = 'https://api.bb.com.br/cobrancas/v2';
  C_URL_HOM        = 'https://api.hm.bb.com.br/cobrancas/v2';

  C_URL_OAUTH_PROD = 'https://oauth.bb.com.br/oauth/token';
  C_URL_OAUTH_HOM  = 'https://oauth.sandbox.bb.com.br/oauth/token';

  C_ACCEPT         = 'application/json';
  C_AUTHORIZATION  = 'Authorization';
implementation

uses
  synacode, strutils, DateUtils;

{ TBoletoW_BancoBrasil_API }

procedure TBoletoW_BancoBrasil_API.DefinirURL;
begin
  FPURL := IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao,C_URL, C_URL_HOM);
  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui   : FPURL := FPURL + '/boletos?gw-dev-app-key='+Boleto.Cedente.CedenteWS.KeyUser;
    tpConsulta : FPURL := FPURL + '/boletos?gw-dev-app-key='+Boleto.Cedente.CedenteWS.KeyUser + '&' + DefinirParametros;
    tpAltera   : FPURL := FPURL + '/boletos/'+Titulos.ACBrBoleto.Banco.MontarCampoNossoNumero(Titulos) +
                                  '?gw-dev-app-key='+Boleto.Cedente.CedenteWS.KeyUser;
    tpConsultaDetalhe : FPURL := FPURL + '/boletos/'+Titulos.ACBrBoleto.Banco.MontarCampoNossoNumero(Titulos) +
                                  '?gw-dev-app-key='+Boleto.Cedente.CedenteWS.KeyUser +
                                  '&' + 'numeroConvenio='+ OnlyNumber(Boleto.Cedente.Convenio);
    tpBaixa    : FPURL := FPURL + '/boletos/'+Titulos.ACBrBoleto.Banco.MontarCampoNossoNumero(Titulos) +
                                  '/baixar?gw-dev-app-key='+Boleto.Cedente.CedenteWS.KeyUser;
  end;

end;

procedure TBoletoW_BancoBrasil_API.DefinirContentType;
begin
  FPContentType := 'application/json';
end;


procedure TBoletoW_BancoBrasil_API.GerarHeader;
begin
  DefinirContentType;
  DefinirKeyUser;
end;

procedure TBoletoW_BancoBrasil_API.GerarDados;
begin
  if Assigned(Boleto) then
   case Boleto.Configuracoes.WebService.Operacao of
     tpInclui:
       begin
         MetodoHTTP:= htPOST;  // Define M�todo POST para Incluir
         RequisicaoJson;
       end;
     tpAltera:
       begin
         MetodoHTTP:= htPATCH;  // Define M�todo PATCH para alteracao
         RequisicaoAltera;
       end;
     tpBaixa :
       begin
         MetodoHTTP:= htPOST;  // Define M�todo POST para Baixa
         RequisicaoBaixa;
       end;
     tpConsulta :
       begin
         MetodoHTTP:= htGET;   //Define M�todo GET Consulta
         RequisicaoConsulta;
       end;
     tpConsultaDetalhe :
       begin
         MetodoHTTP:= htGET;   //Define M�todo GET Consulta Detalhe
         RequisicaoConsultaDetalhe;
       end;

   else
     raise EACBrBoletoWSException.Create(ClassName + Format(
       S_OPERACAO_NAO_IMPLEMENTADO, [
       TipoOperacaoToStr(
       Boleto.Configuracoes.WebService.Operacao)]));
   end;

end;

procedure TBoletoW_BancoBrasil_API.DefinirAuthorization;
begin
  FPAuthorization := C_Authorization + ': ' + 'Bearer ' + GerarTokenAutenticacao;
end;

function TBoletoW_BancoBrasil_API.GerarTokenAutenticacao: string;
begin
  result:= '';
  if Assigned(OAuth) then
  begin
    if OAuth.GerarToken then
      result := OAuth.Token
    else
      raise EACBrBoletoWSException.Create(ClassName + Format( S_ERRO_GERAR_TOKEN_AUTENTICACAO, [OAuth.ErroComunicacao] ));
  end;

end;

procedure TBoletoW_BancoBrasil_API.DefinirKeyUser;
begin
  if Assigned(Titulos) then
    FPKeyUser := '';

end;

function TBoletoW_BancoBrasil_API.DefinirParametros: String;
var
  Consulta : TStringList;
  Documento : String;
begin
  if Assigned(Boleto.Configuracoes.WebService.Filtro) then
  begin
      if Boleto.Configuracoes.WebService.Filtro.indicadorSituacao = isbNenhum then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o indicadorSituacao diferente de isbNenhum. ');

      if (Boleto.Cedente.Agencia = EmptyStr) then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o agenciaBeneficiario. ');

      if (Boleto.Cedente.Conta = EmptyStr) then
        raise EACBrBoletoWSException.Create(ClassName + ' Obrigat�rio informar o contaBeneficiario. ');

      Documento := OnlyNumber(Boleto.Configuracoes.WebService.Filtro.cnpjCpfPagador);

      Consulta := TStringList.Create;
      try
        Consulta.Delimiter := '&';
        Consulta.Add('indicadorSituacao='+IfThen(Boleto.Configuracoes.WebService.Filtro.indicadorSituacao = isbBaixado,'B','A'));

        if Boleto.Configuracoes.WebService.Filtro.contaCaucao > 0 then
          Consulta.Add('contaCaucao='+ IntToStr(Boleto.Configuracoes.WebService.Filtro.contaCaucao));

        Consulta.Add('agenciaBeneficiario='+OnlyNumber( Boleto.Cedente.Agencia ));
        Consulta.Add('contaBeneficiario='+OnlyNumber( Boleto.Cedente.Conta ));
        //Consulta.Add('carteiraConvenio='+OnlyNumber(Boleto.Cedente.Convenio));
        //Consulta.Add('variacaoCarteiraConvenio='+Boleto.Cedente.Modalidade);

        if Boleto.Configuracoes.WebService.Filtro.modalidadeCobranca > 0 then
          Consulta.Add('modalidadeCobranca='+ IntToStr(Boleto.Configuracoes.WebService.Filtro.modalidadeCobranca));

        if Length(Documento) = 14 then
        begin
          Consulta.Add('cnpjPagador='+Copy(Documento,1,12));
          Consulta.Add('digitoCNPJPagador='+Copy(Documento,13,2));
        end else
        if Length(Documento) = 11 then
        begin
          Consulta.Add('cpfPagador='+Copy(Documento,1,9));
          Consulta.Add('digitoCPFPagador='+Copy(Documento,9,2));
        end;

        if Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataInicio > 0 then
          Consulta.Add('dataInicioVencimento='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataInicio, 'DD.MM.YYYY'));
        if Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataFinal > 0 then
          Consulta.Add('dataFimVencimento='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataVencimento.DataFinal, 'DD.MM.YYYY'));

        if Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataInicio > 0 then
          Consulta.Add('dataInicioRegistro='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataInicio, 'DD.MM.YYYY'));
        if Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataFinal > 0 then
          Consulta.Add('dataFimRegistro='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataRegistro.DataFinal, 'DD.MM.YYYY'));

        if Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio > 0 then
          Consulta.Add('dataInicioMovimento='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataInicio, 'DD.MM.YYYY'));
        if Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataFinal > 0 then
          Consulta.Add('dataFimMovimento='+FormatDateBr(Boleto.Configuracoes.WebService.Filtro.dataMovimento.DataFinal, 'DD.MM.YYYY'));

        if Boleto.Configuracoes.WebService.Filtro.codigoEstadoTituloCobranca > 0 then
          Consulta.Add('codigoEstadoTituloCobranca='+intToStr(Boleto.Configuracoes.WebService.Filtro.codigoEstadoTituloCobranca));

        if not (Boleto.Configuracoes.WebService.Filtro.boletoVencido = ibvNenhum) then
          Consulta.Add('boletoVencido='+IfThen(Boleto.Configuracoes.WebService.Filtro.boletoVencido = ibvSim,'S','N'));

        if Boleto.Configuracoes.WebService.Filtro.indiceContinuidade > 0 then
          Consulta.Add('indice='+ FloatToStr(Boleto.Configuracoes.WebService.Filtro.indiceContinuidade));

      finally
        Result := Consulta.DelimitedText;
        Consulta.Free;
      end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.DefinirAutenticacao;
begin
  FPAuthorization := C_ACCESS_TOKEN + ': ' + GerarTokenAutenticacao;
end;

function TBoletoW_BancoBrasil_API.ValidaAmbiente: Integer;
begin
  Result := StrToIntDef(IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao, '1','2'),2);
end;

procedure TBoletoW_BancoBrasil_API.RequisicaoJson;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('numeroConvenio').Value.AsNumber                         := StrToInt64Def(OnlyNumber(Boleto.Cedente.Convenio),0);
      Json.Add('numeroCarteira').Value.AsInteger                        := StrToIntDef(OnlyNumber(Titulos.Carteira),0);
      Json.Add('numeroVariacaoCarteira').Value.AsInteger                := StrToIntDef(OnlyNumber(Boleto.Cedente.Modalidade),0);
      Json.Add('codigoModalidade').Value.AsInteger                      := 1;

      Json.Add('dataEmissao').Value.AsString                            := FormatDateBr(Titulos.DataDocumento, 'DD.MM.YYYY');
      Json.Add('dataVencimento').Value.AsString                         := FormatDateBr(Titulos.Vencimento, 'DD.MM.YYYY');
      Json.Add('valorOriginal').Value.AsNumber                          := Titulos.ValorDocumento;
      Json.Add('valorAbatimento').Value.AsNumber                        := Titulos.ValorAbatimento;
      if (Titulos.DataProtesto > 0) then
        Json.Add('quantidadeDiasProtesto').Value.AsInteger              := Trunc(Titulos.DataProtesto - Titulos.Vencimento);
      if (Titulos.DataLimitePagto > 0 ) then
      begin
        Json.Add('indicadorAceiteTituloVencido').Value.AsString         := 'S';
        Json.Add('numeroDiasLimiteRecebimento').Value.AsInteger         := Trunc(Titulos.DataLimitePagto - Titulos.Vencimento);
      end;
      Json.Add('codigoAceite').Value.AsString                           := IfThen(Titulos.Aceite = atSim,'A','N');
      Json.Add('codigoTipoTitulo').Value.AsInteger                      := codigoTipoTitulo(Titulos.EspecieDoc);
      Json.Add('descricaoTipoTitulo').Value.AsString                    := Titulos.EspecieDoc;
      //Json.Add('indicadorPermissaoRecebimentoParcial').Value.AsString := 'N';
      Json.Add('numeroTituloBeneficiario').Value.AsString               := UpperCase(copy(Titulos.NumeroDocumento,0,15));
      Json.Add('campoUtilizacaoBeneficiario').Value.AsString            := UpperCase(Copy(Titulos.Mensagem.Text,0,30));
      Json.Add('numeroTituloCliente').Value.AsString                    := Boleto.Banco.MontarCampoNossoNumero(Titulos);
      Json.Add('mensagemBloquetoOcorrencia').Value.AsString             := UpperCase(Copy(Trim(Titulos.Instrucao1 +' '+Titulos.Instrucao2+' '+Titulos.Instrucao3),0,165));
      GerarDesconto(Json);
      GerarJuros(Json);
      GerarMulta(Json);
      GerarPagador(Json);
      GerarBenificiarioFinal(Json);
      //Json.Add('quantidadeDiasNegativacao').Value
      //Json.Add('orgaoNegativador').Value
      Json.Add('indicadorPix').Value.AsString := IfThen(Boleto.Cedente.CedenteWS.IndicadorPix,'S','N');

      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_BancoBrasil_API.RequisicaoAltera;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin

    Json := TJsonObject.Create;
    try
      Json.Add('numeroConvenio').Value.AsNumber := StrToInt64Def(OnlyNumber(Boleto.Cedente.Convenio),0);

      case Integer(Titulos.OcorrenciaOriginal.Tipo) of
        3:  // RemessaConcederAbatimento
          begin
            Json.Add('RemessaConcederAbatimento').Value.AsString := 'S';
            AtribuirAbatimento(Json);
          end;
        4:  // RemessaCancelarAbatimento
          begin
            Json.Add('RemessaCancelarAbatimento').Value.AsString := 'S';
            AlteracaoAbatimento(Json);
          end;
        5: //RemessaConcederDesconto
          begin
            Json.Add('indicadorAtribuirDesconto').Value.AsString := 'S';
            AtribuirDesconto(Json);
          end;
        7: //RemessaAlterarVencimento
          begin
            Json.Add('indicadorNovaDataVencimento').Value.AsString := 'S';
            AlteraDataVencimento(Json);
          end;
        9:  //RemessaProtestar
          begin
            Json.Add('indicadorProtestar').Value.AsString := 'S';
            AlterarProtesto(Json);
          end;
        10:  //RemessaSustarProtesto
          begin
            Json.Add('indicadorSustacaoProtesto').Value.AsString := 'S';
          end;
        12:  //RemessaCancelarInstrucaoProtesto
          begin
            Json.Add('indicadorCancelarProtesto').Value.AsString := 'S';
          end;
        13:  //RemessaDispensarJuros
          begin
            Json.Add('indicadorDispensarJuros').Value.AsString := 'S';
          end;
        14:  //RemessaAlterarNomeEnderecoSacado
          begin
            Json.Add('indicadorAlterarEnderecoPagador').Value.AsString := 'S';
            AlteracaoEnderecoPagador(Json);
          end;
        18:  //RemessaAlterarSeuNumero
          begin
            Json.Add('indicadorAlterarSeuNumero').Value.AsString := 'S';
            AlteracaoSeuNumero(Json);
          end;
        37: //RemessaCobrarJurosMora
          begin
            Json.Add('indicadorCobrarJuros').Value.AsString := 'S';
            AtribuirJuros(Json);
          end;
        50:  //RemessaAlterarMulta
          begin
            Json.Add('indicadorCobrarMulta').Value.AsString := 'S';
            AtribuirMulta(Json);
          end;
        51:  //RemessaDispensarMulta
          begin
            Json.Add('indicadorDispensarMulta').Value.AsString := 'S';
          end;
        52: //RemessaAlterarDesconto
          begin
            Json.Add('indicadorAlterarDesconto').Value.AsString := 'S';
            AlteracaoDesconto(Json);
          end;
        53: //RemessaAlterarDataDesconto
          begin
            Json.Add('indicadorAlterarDataDesconto').Value.AsString := 'S';
            AlteracaoDataDesconto(Json);
          end;
        55:  //RemessaAlterarPrazoLimiteRecebimento
          begin
            Json.Add('indicadorAlterarPrazoBoletoVencido').Value.AsString := 'S';
            AlteracaoPrazo(Json);
          end;
        66:  //RemessaNegativacaoSemProtesto
          begin
            Json.Add('indicadorNegativar').Value.AsString := 'S';
            AtribuirNegativacao(Json);
          end;
      end;

      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.RequisicaoBaixa;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('numeroConvenio').Value.AsNumber := StrToInt64Def(OnlyNumber(Boleto.Cedente.Convenio),0);
      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;

end;

procedure TBoletoW_BancoBrasil_API.RequisicaoConsulta;
begin
   //Sem Payload - Define M�todo GET
end;

procedure TBoletoW_BancoBrasil_API.RequisicaoConsultaDetalhe;
begin
    //Sem Payload - Define M�todo GET
end;

procedure TBoletoW_BancoBrasil_API.GerarPagador(AJson: TJsonObject);
var
  JsonDadosPagador: TJsonObject;
  JsonPairPagador: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonDadosPagador := TJSONObject.Create;

      try
        JsonDadosPagador.Add('tipoInscricao').Value.AsInteger   := StrToInt(IfThen(Length( OnlyNumber(Titulos.Sacado.CNPJCPF)) = 11,'1','2'));
        JsonDadosPagador.Add('numeroInscricao').Value.AsNumber  := StrToInt64(OnlyNumber(Titulos.Sacado.CNPJCPF));
        JsonDadosPagador.Add('nome').Value.AsString             := Titulos.Sacado.NomeSacado;
        JsonDadosPagador.Add('endereco').Value.AsString         := Titulos.Sacado.Logradouro + ' ' + Titulos.Sacado.Numero;
        JsonDadosPagador.Add('cep').Value.AsInteger             := StrToInt(OnlyNumber(Titulos.Sacado.CEP));
        JsonDadosPagador.Add('cidade').Value.AsString           := Titulos.Sacado.Cidade;
        JsonDadosPagador.Add('bairro').Value.AsString           := Titulos.Sacado.Bairro;
        JsonDadosPagador.Add('uf').Value.AsString               := Titulos.Sacado.UF;
        //JsonDadosPagador.Add('telefone').Value.AsString         :=

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

procedure TBoletoW_BancoBrasil_API.GerarBenificiarioFinal(AJson: TJsonObject);
var
  JsonSacadorAvalista: TJsonObject;
  JsonPairSacadorAvalista: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
      if Titulos.Sacado.SacadoAvalista.CNPJCPF = EmptyStr then
        Exit;

      if Assigned(AJson) then
      begin
        JsonSacadorAvalista := TJSONObject.Create;

        try
          JsonSacadorAvalista.Add('tipoInscricao').Value.AsInteger   :=  StrToInt(IfThen( Length( OnlyNumber(Titulos.Sacado.SacadoAvalista.CNPJCPF)) = 11,'1','2'));
          JsonSacadorAvalista.Add('numeroInscricao').Value.AsNumber  :=  StrToInt64Def(OnlyNumber(Titulos.Sacado.SacadoAvalista.CNPJCPF),0);
          JsonSacadorAvalista.Add('nome').Value.AsString             :=  Titulos.Sacado.SacadoAvalista.NomeAvalista;

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

procedure TBoletoW_BancoBrasil_API.GerarJuros(AJson: TJsonObject);
var
  JsonJuros: TJsonObject;
  JsonPairJuros: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonJuros := TJSONObject.Create;
      try
        if (Titulos.DataMoraJuros > 0) then
        begin
          JsonJuros.Add('tipo').Value.AsInteger             := StrToIntDef(Titulos.CodigoMora, 3);
          JsonJuros.Add('data').Value.AsString              := FormatDateBr(Titulos.DataMoraJuros, 'DD.MM.YYYY');
          case (StrToIntDef(Titulos.CodigoMora, 3)) of
            1 : JsonJuros.Add('valor').Value.AsNumber       := Titulos.ValorMoraJuros;
            2 : JsonJuros.Add('porcentagem').Value.AsNumber := Titulos.ValorMoraJuros;
          end;

          JsonPairJuros := TJsonPair.Create(AJson, 'jurosMora');
          try
            JsonPairJuros.Value.AsObject := JsonJuros;
            AJson.Add('jurosMora').Assign(JsonPairJuros);
          finally
            JsonPairJuros.Free;
          end;
        end;
      finally
        JsonJuros.Free;
      end;
    end;
  end;
end;

procedure TBoletoW_BancoBrasil_API.GerarMulta(AJson: TJsonObject);
var
  JsonMulta: TJsonObject;
  JsonPairMulta: TJsonPair;
  ACodMulta: integer;
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonMulta := TJSONObject.Create;

      try
        if Titulos.PercentualMulta > 0 then
        begin
          if Titulos.MultaValorFixo then
            ACodMulta := 1
          else
            ACodMulta := 2;
        end
        else
          ACodMulta := 3;


        if (Titulos.DataMulta > 0) then
        begin
          JsonMulta.Add('tipo').Value.AsInteger             := ACodMulta;
          JsonMulta.Add('data').Value.AsString              := FormatDateBr(Titulos.DataMulta, 'DD.MM.YYYY');
          case ACodMulta of
            1 : JsonMulta.Add('valor').Value.AsNumber       := Titulos.ValorMoraJuros;
            2 : JsonMulta.Add('porcentagem').Value.AsNumber := Titulos.PercentualMulta;
          end;

          JsonPairMulta := TJsonPair.Create(AJson, 'multa');
          try
            JsonPairMulta.Value.AsObject := JsonMulta;
            AJson.Add('multa').Assign(JsonPairMulta);
          finally
            JsonPairMulta.Free;
          end;
        end;
      finally
        JsonMulta.Free;
      end;
    end;
  end;
end;

procedure TBoletoW_BancoBrasil_API.GerarDesconto(AJson: TJsonObject);
var
  JsonDesconto: TJsonObject;
  JsonArrGrupoDesconto: TJsonArray;
  JsonPairDesconto: TJsonPair;
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonDesconto := TJSONObject.Create;
      JsonArrGrupoDesconto := TJsonArray.Create;
      try

        if (Titulos.DataDesconto > 0) then
        begin
          JsonDesconto.Add('tipo').Value.AsInteger             := integer(Titulos.TipoDesconto);
          JsonDesconto.Add('dataExpiracao').Value.AsString     := FormatDateBr(Titulos.DataDesconto, 'DD.MM.YYYY');
          case integer(Titulos.TipoDesconto) of
            1 : JsonDesconto.Add('valor').Value.AsNumber       := Titulos.ValorDesconto;
            2 : JsonDesconto.Add('porcentagem').Value.AsNumber := Titulos.ValorDesconto;
          end;

          JsonArrGrupoDesconto.Add.AsObject := JsonDesconto;
          JsonPairDesconto := TJsonPair.Create(AJson, 'desconto');
          try
            JsonPairDesconto.Value.AsArray := JsonArrGrupoDesconto;
            AJson.Add('desconto').Assign(JsonPairDesconto);
          finally
            JsonPairDesconto.Free;
          end;
        end;
      finally
        JsonArrGrupoDesconto.Free;
        JsonDesconto.Free;
      end;

      JsonDesconto := TJSONObject.Create;
      JsonArrGrupoDesconto := TJsonArray.Create;
      try
        JsonDesconto.Add('tipo').Value.AsInteger := integer(Titulos.TipoDesconto);
        if Titulos.DataDesconto2 > 0 then
        begin
          JsonDesconto.Add('dataExpiracao').Value.AsString     := FormatDateBr(Titulos.DataDesconto2, 'DD.MM.YYYY');
          case integer(Titulos.TipoDesconto2) of
            1 : JsonDesconto.Add('valor').Value.AsNumber       := Titulos.ValorDesconto2;
            2 : JsonDesconto.Add('porcentagem').Value.AsNumber := Titulos.ValorDesconto2;
          end;

          JsonArrGrupoDesconto.Add.AsObject := JsonDesconto;
          JsonPairDesconto                  := TJsonPair.Create(AJson, 'segundoDesconto');
          try
            JsonPairDesconto.Value.AsArray  := JsonArrGrupoDesconto;
            AJson.Add('segundoDesconto').Assign(JsonPairDesconto);
          finally
            JsonPairDesconto.Free;
          end;
        end;
      finally
        JsonArrGrupoDesconto.Free;
        JsonDesconto.Free;
      end;

    end;
  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteraDataVencimento(AJson: TJsonObject);
var
  JsonVencimento: TJsonObject;
  JsonPairVencimento: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonVencimento := TJSONObject.Create;
      try
        if (Titulos.Vencimento > 0) then
        begin
          JsonVencimento.Add('novaDataVencimento').Value.AsString := FormatDateBr(Titulos.Vencimento, 'DD.MM.YYYY');

          JsonPairVencimento := TJsonPair.Create(AJson, 'alteracaoData');
          try
            JsonPairVencimento.Value.AsObject := JsonVencimento;
            AJson.Add('alteracaoData').Assign(JsonPairVencimento);
          finally
            JsonPairVencimento.Free;
          end;
        end;
      finally
        JsonVencimento.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AtribuirDesconto(AJson: TJsonObject);
var
  JsonAtribuirDesconto: TJsonObject;
  JsonPairAtribuirDesconto: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirDesconto := TJSONObject.Create;
      try
        if (Titulos.ValorDesconto > 0) then
        begin
          JsonAtribuirDesconto.Add('tipoPrimeiroDesconto').Value.AsInteger := integer(Titulos.TipoDesconto);
          case integer(Titulos.TipoDesconto) of
            1 : JsonAtribuirDesconto.Add('valorPrimeiroDesconto').Value.AsNumber := Titulos.ValorDesconto;
            2 : JsonAtribuirDesconto.Add('percentualPrimeiroDesconto').Value.AsNumber := Titulos.ValorDesconto;
          end;
          JsonAtribuirDesconto.Add('dataPrimeiroDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto, 'DD.MM.YYYY');
        end;
        if (Titulos.ValorDesconto2 > 0) then
        begin
          JsonAtribuirDesconto.Add('tipoSegundoDesconto').Value.AsInteger := integer(Titulos.TipoDesconto2);
          case integer(Titulos.TipoDesconto2) of
            1 : JsonAtribuirDesconto.Add('valorSegundoDesconto').Value.AsNumber := Titulos.ValorDesconto2;
            2 : JsonAtribuirDesconto.Add('percentualSegundoDesconto').Value.AsNumber := Titulos.ValorDesconto2;
          end;
          JsonAtribuirDesconto.Add('dataSegundoDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto2, 'DD.MM.YYYY');
        end;

        if (Titulos.ValorDesconto > 0) or (Titulos.ValorDesconto > 0) then
        begin
          JsonPairAtribuirDesconto := TJsonPair.Create(AJson, 'desconto');
          try
            JsonPairAtribuirDesconto.Value.AsObject := JsonAtribuirDesconto;
            AJson.Add('desconto').Assign(JsonPairAtribuirDesconto);
          finally
            JsonPairAtribuirDesconto.Free;
          end;

        end;

      finally
        JsonAtribuirDesconto.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoDesconto(AJson: TJsonObject);
var
  JsonAtribuirDesconto: TJsonObject;
  JsonPairAtribuirDesconto: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirDesconto := TJSONObject.Create;
      try
        if (Titulos.ValorDesconto > 0) then
        begin
          JsonAtribuirDesconto.Add('tipoPrimeiroDesconto').Value.AsInteger := integer(Titulos.TipoDesconto);
          case integer(Titulos.TipoDesconto) of
            1 : JsonAtribuirDesconto.Add('novoValorPrimeiroDesconto').Value.AsNumber := Titulos.ValorDesconto;
            2 : JsonAtribuirDesconto.Add('novoPercentualPrimeiroDesconto').Value.AsNumber := Titulos.ValorDesconto;
          end;
          JsonAtribuirDesconto.Add('novaDataLimitePrimeiroDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto, 'DD.MM.YYYY');
        end;
        if (Titulos.ValorDesconto2 > 0) then
        begin
          JsonAtribuirDesconto.Add('tipoSegundoDesconto').Value.AsInteger := integer(Titulos.TipoDesconto2);
          case integer(Titulos.TipoDesconto2) of
            1 : JsonAtribuirDesconto.Add('novoValorSegundoDesconto').Value.AsNumber := Titulos.ValorDesconto2;
            2 : JsonAtribuirDesconto.Add('novoPercentualSegundoDesconto').Value.AsNumber := Titulos.ValorDesconto2;
          end;
          JsonAtribuirDesconto.Add('novaDataLimiteSegundoDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto2, 'DD.MM.YYYY');
        end;

        if (Titulos.ValorDesconto > 0) or (Titulos.ValorDesconto > 0) then
        begin
          JsonPairAtribuirDesconto := TJsonPair.Create(AJson, 'alteracaoDesconto');
          try
            JsonPairAtribuirDesconto.Value.AsObject := JsonAtribuirDesconto;
            AJson.Add('alteracaoDesconto').Assign(JsonPairAtribuirDesconto);
          finally
            JsonPairAtribuirDesconto.Free;
          end;

        end;

      finally
        JsonAtribuirDesconto.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoDataDesconto(AJson: TJsonObject);
var
  JsonAtribuirDesconto: TJsonObject;
  JsonPairAtribuirDesconto: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirDesconto := TJSONObject.Create;
      try
        if (Titulos.DataDesconto > 0) then
        begin
          JsonAtribuirDesconto.Add('novaDataLimitePrimeiroDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto, 'DD.MM.YYYY');
        end;
        if (Titulos.DataDesconto2 > 0) then
        begin
          JsonAtribuirDesconto.Add('novaDataLimiteSegundoDesconto').Value.AsString := FormatDateBr(Titulos.DataDesconto2, 'DD.MM.YYYY');
        end;

        if (Titulos.DataDesconto > 0) or (Titulos.DataDesconto2 > 0) then
        begin
          JsonPairAtribuirDesconto := TJsonPair.Create(AJson, 'alteracaoDataDesconto');
          try
            JsonPairAtribuirDesconto.Value.AsObject := JsonAtribuirDesconto;
            AJson.Add('alteracaoDataDesconto').Assign(JsonPairAtribuirDesconto);
          finally
            JsonPairAtribuirDesconto.Free;
          end;

        end;

      finally
        JsonAtribuirDesconto.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlterarProtesto(AJson: TJsonObject);
var
  JsonAtribuirProtesto: TJsonObject;
  JsonPairAtribuirProtesto: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirProtesto := TJSONObject.Create;
      try
        if (Titulos.DiasDeProtesto > 0) then
        begin
          JsonAtribuirProtesto.Add('quantidadeDiasProtesto').Value.AsInteger := Titulos.DiasDeProtesto;

          JsonPairAtribuirProtesto := TJsonPair.Create(AJson, 'protesto');
          try
            JsonPairAtribuirProtesto.Value.AsObject := JsonAtribuirProtesto;
            AJson.Add('protesto').Assign(JsonPairAtribuirProtesto);
          finally
            JsonPairAtribuirProtesto.Free;
          end;

        end;

      finally
        JsonAtribuirProtesto.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AtribuirAbatimento(AJson: TJsonObject);
var
  JsonAtribuirAbatimento: TJsonObject;
  JsonPairAtribuirAbatimento: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirAbatimento := TJSONObject.Create;
      try
        if (Titulos.ValorAbatimento > 0) then
        begin
          JsonAtribuirAbatimento.Add('valorAbatimento').Value.AsNumber := Titulos.ValorAbatimento;

          JsonPairAtribuirAbatimento := TJsonPair.Create(AJson, 'abatimento');
          try
            JsonPairAtribuirAbatimento.Value.AsObject := JsonAtribuirAbatimento;
            AJson.Add('abatimento').Assign(JsonPairAtribuirAbatimento);
          finally
            JsonPairAtribuirAbatimento.Free;
          end;

        end;

      finally
        JsonAtribuirAbatimento.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoAbatimento(AJson: TJsonObject);
var
  JsonAtribuirAbatimento: TJsonObject;
  JsonPairAtribuirAbatimento: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirAbatimento := TJSONObject.Create;
      try
        if (Titulos.ValorAbatimento > 0) then
        begin
          JsonAtribuirAbatimento.Add('novoValorAbatimento').Value.AsNumber := Titulos.ValorAbatimento;

          JsonPairAtribuirAbatimento := TJsonPair.Create(AJson, 'alteracaoAbatimento');
          try
            JsonPairAtribuirAbatimento.Value.AsObject := JsonAtribuirAbatimento;
            AJson.Add('alteracaoAbatimento').Assign(JsonPairAtribuirAbatimento);
          finally
            JsonPairAtribuirAbatimento.Free;
          end;

        end;
      finally
        JsonAtribuirAbatimento.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AtribuirJuros(AJson: TJsonObject);
var
  JsonAtribuirJuros: TJsonObject;
  JsonPairAtribuirJuros: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirJuros := TJSONObject.Create;
      try
        if (Titulos.ValorMoraJuros > 0) then
        begin
          JsonAtribuirJuros.Add('tipoJuros').Value.AsInteger := (StrToIntDef(Titulos.CodigoMora, 3));

          case (StrToIntDef(Titulos.CodigoMora, 2)) of
            1 : JsonAtribuirJuros.Add('valorJuros').Value.AsNumber:= Titulos.ValorMoraJuros;
            2 : JsonAtribuirJuros.Add('taxaJuros').Value.AsNumber := Titulos.ValorMoraJuros;
          end;

          JsonPairAtribuirJuros := TJsonPair.Create(AJson, 'juros');
          try
            JsonPairAtribuirJuros.Value.AsObject := JsonAtribuirJuros;
            AJson.Add('juros').Assign(JsonPairAtribuirJuros);
          finally
            JsonPairAtribuirJuros.Free;
          end;

        end;
      finally
        JsonAtribuirJuros.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AtribuirMulta(AJson: TJsonObject);
var
  JsonMulta: TJsonObject;
  JsonPairMulta: TJsonPair;
  ACodMulta: integer;
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonMulta := TJSONObject.Create;

      try
        if Titulos.PercentualMulta > 0 then
        begin
          if Titulos.MultaValorFixo then
            ACodMulta := 1
          else
            ACodMulta := 2;
        end
        else
          ACodMulta := 3;


        if (Titulos.DataMulta > 0) then
        begin
          JsonMulta.Add('tipoMulta').Value.AsInteger        := ACodMulta;
          JsonMulta.Add('dataInicioMulta').Value.AsString   := FormatDateBr(Titulos.DataMulta, 'DD.MM.YYYY');
          case ACodMulta of
            1 : JsonMulta.Add('valorMulta').Value.AsNumber := Titulos.ValorMoraJuros;
            2 : JsonMulta.Add('taxaMulta').Value.AsNumber  := Titulos.PercentualMulta;
          end;

          JsonPairMulta := TJsonPair.Create(AJson, 'multa');
          try
            JsonPairMulta.Value.AsObject := JsonMulta;
            AJson.Add('multa').Assign(JsonPairMulta);
          finally
            JsonPairMulta.Free;
          end;
        end;
      finally
        JsonMulta.Free;
      end;
    end;
  end;

end;

procedure TBoletoW_BancoBrasil_API.AtribuirNegativacao(AJson: TJsonObject);
var
  JsonAtribuirNegativacao: TJsonObject;
  JsonPairAtribuirNegativacao: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirNegativacao := TJSONObject.Create;
      try
        if (Titulos.DiasDeNegativacao > 0) then
        begin
          JsonAtribuirNegativacao.Add('quantidadeDiasNegativacao').Value.AsInteger := Titulos.DiasDeNegativacao;
          JsonAtribuirNegativacao.Add('tipoNegativacao').Value.AsInteger := 1;

          JsonPairAtribuirNegativacao := TJsonPair.Create(AJson, 'negativacao');
          try
            JsonPairAtribuirNegativacao.Value.AsObject := JsonAtribuirNegativacao;
            AJson.Add('negativacao').Assign(JsonPairAtribuirNegativacao);
          finally
            JsonPairAtribuirNegativacao.Free;
          end;

        end;
      finally
        JsonAtribuirNegativacao.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoSeuNumero(AJson: TJsonObject);
var
  JsonAtribuirSeuNumero: TJsonObject;
  JsonPairAtribuirSeuNumero: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirSeuNumero := TJSONObject.Create;
      try
        if (Titulos.SeuNumero <> '') then
        begin
          JsonAtribuirSeuNumero.Add('codigoSeuNumero').Value.AsString := Titulos.SeuNumero;

          JsonPairAtribuirSeuNumero := TJsonPair.Create(AJson, 'alteracaoSeuNumero');
          try
            JsonPairAtribuirSeuNumero.Value.AsObject := JsonAtribuirSeuNumero;
            AJson.Add('alteracaoSeuNumero').Assign(JsonPairAtribuirSeuNumero);
          finally
            JsonPairAtribuirSeuNumero.Free;
          end;

        end;
      finally
        JsonAtribuirSeuNumero.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoEnderecoPagador(AJson: TJsonObject);
var
  JsonAtribuirEndereco: TJsonObject;
  JsonPairAtribuirEndereco: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirEndereco := TJSONObject.Create;
      try
        if (Titulos.SeuNumero <> '') then
        begin
          JsonAtribuirEndereco.Add('enderecoPagador').Value.AsString := Titulos.Sacado.Logradouro;
          JsonAtribuirEndereco.Add('bairroPagador').Value.AsString := Titulos.Sacado.Bairro;
          JsonAtribuirEndereco.Add('cidadePagador').Value.AsString := Titulos.Sacado.Cidade;
          JsonAtribuirEndereco.Add('UFPagador').Value.AsString := Titulos.Sacado.UF;
          JsonAtribuirEndereco.Add('CEPPagador').Value.AsString := Titulos.Sacado.CEP;

          JsonPairAtribuirEndereco := TJsonPair.Create(AJson, 'alteracaoEndereco');
          try
            JsonPairAtribuirEndereco.Value.AsObject := JsonAtribuirEndereco;
            AJson.Add('alteracaoEndereco').Assign(JsonPairAtribuirEndereco);
          finally
            JsonPairAtribuirEndereco.Free;
          end;

        end;
      finally
        JsonAtribuirEndereco.Free;
      end;
    end;

  end;

end;

procedure TBoletoW_BancoBrasil_API.AlteracaoPrazo(AJson: TJsonObject);
var
  JsonAtribuirAlteracaoPrazo: TJsonObject;
  JsonPairAtribuirAlteracaoPrazo: TJsonPair;

begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonAtribuirAlteracaoPrazo := TJSONObject.Create;
      try
        if (Titulos.SeuNumero <> '') then
        begin
          JsonAtribuirAlteracaoPrazo.Add('quantidadeDiasAceite').Value.AsInteger := DaysBetween(Titulos.Vencimento, Titulos.DataLimitePagto);

          JsonPairAtribuirAlteracaoPrazo := TJsonPair.Create(AJson, 'alteracaoPrazo');
          try
            JsonPairAtribuirAlteracaoPrazo.Value.AsObject := JsonAtribuirAlteracaoPrazo;
            AJson.Add('alteracaoPrazo').Assign(JsonPairAtribuirAlteracaoPrazo);
          finally
            JsonPairAtribuirAlteracaoPrazo.Free;
          end;

        end;
      finally
        JsonAtribuirAlteracaoPrazo.Free;
      end;
    end;

  end;

end;

function TBoletoW_BancoBrasil_API.CodigoTipoTitulo(AEspecieDoc : String): Integer;
begin
{ Pegando o tipo de EspecieDoc }
  if AEspecieDoc = 'CH' then
    AEspecieDoc   := '01'
  else if AEspecieDoc = 'DM' then
    AEspecieDoc   := '02'
  else if AEspecieDoc = 'DMI' then
    AEspecieDoc   := '03'
  else if AEspecieDoc = 'DS' then
    AEspecieDoc   := '04'
  else if AEspecieDoc = 'DSI' then
    AEspecieDoc   := '05'
  else if AEspecieDoc = 'DR' then
    AEspecieDoc   := '06'
  else if AEspecieDoc = 'LC' then
    AEspecieDoc   := '07'
  else if AEspecieDoc = 'NCC' then
    AEspecieDoc   := '08'
  else if AEspecieDoc = 'NCE' then
    AEspecieDoc   := '09'
  else if AEspecieDoc = 'NCI' then
    AEspecieDoc   := '10'
  else if AEspecieDoc = 'NCR' then
    AEspecieDoc   := '11'
  else if AEspecieDoc = 'NP' then
    AEspecieDoc   := '12'
  else if AEspecieDoc = 'NPR' then
    AEspecieDoc   := '13'
  else if AEspecieDoc = 'TM' then
    AEspecieDoc   := '14'
  else if AEspecieDoc = 'TS' then
    AEspecieDoc   := '15'
  else if AEspecieDoc = 'NS' then
    AEspecieDoc   := '16'
  else if AEspecieDoc = 'RC' then
    AEspecieDoc   := '17'
  else if AEspecieDoc = 'FAT' then
    AEspecieDoc   := '18'
  else if AEspecieDoc = 'ND' then
    AEspecieDoc   := '19'
  else if AEspecieDoc = 'AP' then
    AEspecieDoc   := '20'
  else if AEspecieDoc = 'ME' then
    AEspecieDoc   := '21'
  else if AEspecieDoc = 'PC' then
    AEspecieDoc   := '22';
  Result := StrToIntDef(AEspecieDoc,0);
end;

constructor TBoletoW_BancoBrasil_API.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);

  FPAccept := C_ACCEPT;

  if Assigned(OAuth) then
  begin
    if OAuth.Ambiente = taHomologacao then
      OAuth.URL := C_URL_OAUTH_HOM
    else
      OAuth.URL := C_URL_OAUTH_PROD;

    OAuth.Payload := OAuth.Ambiente = taHomologacao;
  end;

end;

function TBoletoW_BancoBrasil_API.GerarRemessa: string;
begin
  Result := inherited GerarRemessa;

end;

function TBoletoW_BancoBrasil_API.Enviar: boolean;
begin
  Result := inherited Enviar;

end;
end.
