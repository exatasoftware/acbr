{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:  Ederson Selvati                                }

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

unit ACBrBoletoW_PenseBank_API;

interface

uses
  Classes, SysUtils, ACBrBoletoWS, pcnConversao, ACBrBoletoConversao,
//  {$IfDef USE_JSONDATAOBJECTS_UNIT}
//    JsonDataObjects_ACBr,
//  {$Else}
    Jsons,
//  {$EndIf}
  ACBrUtil;

type
  { TBoletoW_PenseBank_API }
  TBoletoW_PenseBank_API = class(TBoletoWSREST)
  private
    function CodigoTipoTitulo(AEspecieDoc:String): Integer;
  protected
    procedure DefinirURL; override;
    procedure DefinirContentType; override;
    procedure GerarHeader; override;
    procedure GerarDados; override;
    procedure DefinirAuthorization; override;
    function GerarTokenAutenticacao: string; override;
    procedure DefinirKeyUser;
    procedure DefinirAutenticacao;
    function ValidaAmbiente: Integer;
    procedure RequisicaoJson;
    procedure RequisicaoAltera;
    procedure RequisicaoBaixa;
    procedure RequisicaoConsulta;
    procedure RequisicaoConsultaLista;
    procedure RequisicaoCancelar;
    procedure GerarPagador(AJson: TJsonObject);
    procedure GerarBenificiarioFinal(AJson: TJsonObject);
    procedure GerarJuros(AJson: TJsonObject);
    procedure GerarMulta(AJson: TJsonObject);
    procedure GerarDesconto(AJson: TJsonObject);

    procedure AlteraDataVencimento(AJson: TJsonObject);
    procedure AlterarProtesto(AJson: TJsonObject);

  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: string; override;
    function Enviar: boolean; override;

  end;

const
  C_URL            = 'https://pensebank.com.br';
  C_URL_HOM        = 'https://sandbox.pensebank.com.br';

  C_ACCEPT         = 'application/json';
  C_AUTHORIZATION  = 'Authorization';
implementation

uses
  synacode, strutils, DateUtils, ACBrUtil.Strings, ACBrUtil.DateTime,
  ACBrBoleto;

{ TBoletoW_PenseBank_API }

procedure TBoletoW_PenseBank_API.DefinirURL;
var
  ID, NConvenio : String;
begin
  FPURL     := IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao,C_URL, C_URL_HOM);

  if Titulos <> nil then
    ID      := Titulos.ACBrBoleto.Banco.MontarCampoNossoNumero(Titulos);

  NConvenio := OnlyNumber(Boleto.Cedente.Convenio);

  case Boleto.Configuracoes.WebService.Operacao of
    tpInclui           : FPURL := FPURL + '/Boleto';
    tpConsulta         : FPURL := FPURL + '/BoletoConsulta';
    tpConsultaDetalhe  : FPURL := FPURL + '/BoletoConsultaLista';
    tpAltera           : begin
                           if Titulos.OcorrenciaOriginal.Tipo=TACBrTipoOcorrencia.toRemessaAlterarVencimento then
                             FPURL := FPURL + '/BoletoProrrogacao'
                           else if Titulos.OcorrenciaOriginal.Tipo=TACBrTipoOcorrencia.toRemessaProtestar then
                             FPURL := FPURL + '/BoletoProtesto';
                         end;
    tpBaixa            : FPURL := FPURL + '/BoletoBaixa';
    tpCancelar         : FPURL := FPURL + '/BoletoCancelamento';
  end;

end;

procedure TBoletoW_PenseBank_API.DefinirContentType;
begin
  FPContentType := 'application/json';
end;


procedure TBoletoW_PenseBank_API.GerarHeader;
begin
  DefinirContentType;
  DefinirKeyUser;
end;

procedure TBoletoW_PenseBank_API.GerarDados;
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
         MetodoHTTP:= htPOST;  // Define M�todo PATCH para alteracao
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
         MetodoHTTP:= htGET;   //Define M�todo GET Consulta
         RequisicaoConsultaLista;
       end;

     tpCancelar :
       begin
         MetodoHTTP:= htPOST;   //Define M�todo GET Consulta
         RequisicaoCancelar;
       end;
   else
     raise EACBrBoletoWSException.Create(ClassName + Format(
       S_OPERACAO_NAO_IMPLEMENTADO, [
       TipoOperacaoToStr(
       Boleto.Configuracoes.WebService.Operacao)]));
   end;

end;

procedure TBoletoW_PenseBank_API.DefinirAuthorization;
begin
  FPAuthorization := C_Authorization + ': ' + 'Bearer ' + GerarTokenAutenticacao;
end;

function TBoletoW_PenseBank_API.GerarTokenAutenticacao: string;
begin
  Result:= '';
  if Assigned(OAuth) then
    Result := OAuth.ClientID
  else
    raise EACBrBoletoWSException.Create(ClassName + Format( S_ERRO_GERAR_TOKEN_AUTENTICACAO, [OAuth.ErroComunicacao] ));

end;

procedure TBoletoW_PenseBank_API.DefinirKeyUser;
begin
  if Assigned(Titulos) then
    FPKeyUser := Titulos.ACBrBoleto.Cedente.CedenteWS.KeyUser;

end;

procedure TBoletoW_PenseBank_API.DefinirAutenticacao;
begin
  FPAuthorization := C_ACCESS_TOKEN + ': ' + GerarTokenAutenticacao;
end;

function TBoletoW_PenseBank_API.ValidaAmbiente: Integer;
begin
  Result := StrToIntDef(IfThen(Boleto.Configuracoes.WebService.Ambiente = taProducao, '1','2'),2);
end;

procedure TBoletoW_PenseBank_API.RequisicaoJson;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('idexterno').Value.AsString                              := Titulos.SeuNumero;
      Json.Add('dataEmissao').Value.AsString                            := FormatDateBr(Titulos.DataDocumento, 'DD/MM/YYYY');
      Json.Add('dataVencimento').Value.AsString                         := FormatDateBr(Titulos.Vencimento, 'DD/MM/YYYY');
      Json.Add('valorOriginal').Value.AsNumber                          := Titulos.ValorDocumento;
      Json.Add('valorAbatimento').Value.AsNumber                        := Titulos.ValorAbatimento;
      if (Titulos.DataProtesto > 0) then
        Json.Add('quantidadeDiasProtesto').Value.AsInteger              := Trunc(Titulos.DataProtesto - Titulos.Vencimento);
      if (Titulos.DiasDeNegativacao > 0) then
      begin
        Json.Add('quantidadeDiasNegativacao').Value.AsInteger           := Titulos.DiasDeNegativacao;
        Json.Add('orgaoNegativador').Value.AsInteger                    := StrToInt64Def(Titulos.orgaoNegativador,0);
      end;
      if (Titulos.DataLimitePagto > 0 ) then
      begin
        Json.Add('indicadorAceiteTituloVencido').Value.AsString         := 'S';
        Json.Add('numeroDiasLimiteRecebimento').Value.AsInteger         := Trunc(Titulos.DataLimitePagto - Titulos.Vencimento);
      end;
      Json.Add('codigoAceite').Value.AsString                           := IfThen(Titulos.Aceite = atSim,'A','N');
      Json.Add('codigoTipoTitulo').Value.AsInteger                      := codigoTipoTitulo(Titulos.EspecieDoc);
      Json.Add('descricaoTipoTitulo').Value.AsString                    := Titulos.EspecieDoc;
      if Titulos.TipoPagamento = tpAceita_Qualquer_Valor then
        Json.Add('indicadorPermissaoRecebimentoParcial').Value.AsString := 'S';

      Json.Add('numeroTituloBeneficiario').Value.AsString               := Copy(Trim(UpperCase(Titulos.NumeroDocumento)),0,15);
      Json.Add('campoUtilizacaoBeneficiario').Value.AsString            := Copy(Trim(StringReplace(UpperCase(Titulos.Mensagem.Text),'\r\n',' ',[rfReplaceAll])),0,30);
      Json.Add('numeroTituloCliente').Value.AsString                    := Boleto.Banco.MontarCampoNossoNumero(Titulos);
      Json.Add('mensagemBloquetoOcorrencia').Value.AsString             := UpperCase(Copy(Trim(Titulos.Instrucao1 +' '+Titulos.Instrucao2+' '+Titulos.Instrucao3),0,165));

      GerarDesconto(Json);
      GerarJuros(Json);
      GerarMulta(Json);
      GerarPagador(Json);
      GerarBenificiarioFinal(Json);

      Json.Add('cnpjSh').Value.AsString := FPKeyUser;
      Json.Add('pix').Value.AsBoolean := Boleto.Cedente.CedenteWS.IndicadorPix;
      Json.Add('emailGeracao').Value.AsBoolean := Boleto.Cedente.CedenteWS.IndicadorEmail;
      Json.Add('sms').Value.AsBoolean := Boleto.Cedente.CedenteWS.IndicadorSMS;

      Data := Json.Stringify;
      FPDadosMsg := Data;
    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_PenseBank_API.RequisicaoAltera;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin

    Json := TJsonObject.Create;
    try
      case Integer(Titulos.OcorrenciaOriginal.Tipo) of
        7: //RemessaAlterarVencimento
          begin
            AlteraDataVencimento(Json);
          end;
        9:  //RemessaProtestar
          begin
            AlterarProtesto(Json);
          end;
      end;
      Data := Json.Stringify;
      FPDadosMsg := Data;
    finally
      Json.Free;
    end;
  end;

end;

procedure TBoletoW_PenseBank_API.RequisicaoBaixa;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('idboleto').Value.AsString := Titulos.NumeroDocumento;
      Json.Add('numeroTituloCliente').Value.AsString := Titulos.NossoNumero;
      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;

end;

procedure TBoletoW_PenseBank_API.RequisicaoCancelar;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('idboleto').Value.AsString := Titulos.NumeroDocumento;
      Json.Add('numeroTituloCliente').Value.AsString := Titulos.NossoNumero;
      Data := Json.Stringify;
      FPDadosMsg := Data;
    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_PenseBank_API.RequisicaoConsulta;
var
  Data: string;
  Json: TJSONObject;
begin
  if Assigned(Titulos) then
  begin
    Json := TJsonObject.Create;
    try
      Json.Add('idboleto').Value.AsString := Titulos.NumeroDocumento;
      Json.Add('numeroTituloCliente').Value.AsString := Titulos.NossoNumero;
      Data := Json.Stringify;

      FPDadosMsg := Data;

    finally
      Json.Free;
    end;
  end;
end;

procedure TBoletoW_PenseBank_API.RequisicaoConsultaLista;
begin
//
end;

procedure TBoletoW_PenseBank_API.GerarPagador(AJson: TJsonObject);
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
        JsonDadosPagador.Add('numeroInscricao').Value.AsString  := OnlyNumber(Titulos.Sacado.CNPJCPF);
        JsonDadosPagador.Add('nome').Value.AsString             := Titulos.Sacado.NomeSacado;
        JsonDadosPagador.Add('endereco').Value.AsString         := Titulos.Sacado.Logradouro + ' ' + Titulos.Sacado.Numero;
        JsonDadosPagador.Add('cep').Value.AsInteger             := StrToInt(OnlyNumber(Titulos.Sacado.CEP));
        JsonDadosPagador.Add('cidade').Value.AsString           := Titulos.Sacado.Cidade;
        JsonDadosPagador.Add('bairro').Value.AsString           := Titulos.Sacado.Bairro;
        JsonDadosPagador.Add('uf').Value.AsString               := Titulos.Sacado.UF;
        JsonDadosPagador.Add('telefone').Value.AsString         := Titulos.Sacado.Fone;
        JsonDadosPagador.Add('email').Value.AsString            := Titulos.Sacado.Email;

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

procedure TBoletoW_PenseBank_API.GerarBenificiarioFinal(AJson: TJsonObject);
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

procedure TBoletoW_PenseBank_API.GerarJuros(AJson: TJsonObject);
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
        if (Titulos.ValorMoraJuros > 0) then
        begin
          JsonJuros.Add('tipo').Value.AsInteger             := StrToIntDef(Titulos.CodigoMora, 3);
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

procedure TBoletoW_PenseBank_API.GerarMulta(AJson: TJsonObject);
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
            1 : JsonMulta.Add('valor').Value.AsNumber       := Titulos.PercentualMulta;
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

procedure TBoletoW_PenseBank_API.GerarDesconto(AJson: TJsonObject);
var
  JsonDesconto: TJsonObject;
  JsonPairDesconto: TJsonPair;
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      JsonDesconto := TJSONObject.Create;
      try

        if (Titulos.DataDesconto > 0) then
        begin
          JsonDesconto.Add('tipo').Value.AsInteger             := integer(Titulos.TipoDesconto);
          JsonDesconto.Add('dataExpiracao').Value.AsString     := FormatDateBr(Titulos.DataDesconto, 'DD.MM.YYYY');
          case integer(Titulos.TipoDesconto) of
            1 : JsonDesconto.Add('valor').Value.AsNumber       := Titulos.ValorDesconto;
            2 : JsonDesconto.Add('porcentagem').Value.AsNumber := Titulos.ValorDesconto;
          end;

          JsonPairDesconto := TJsonPair.Create(AJson, 'desconto');
          try
            JsonPairDesconto.Value.AsObject := JsonDesconto;
            AJson.Add('desconto').Assign(JsonPairDesconto);
          finally
            JsonPairDesconto.Free;
          end;
        end;
      finally
        JsonDesconto.Free;
      end;
    end;
  end;

end;

procedure TBoletoW_PenseBank_API.AlteraDataVencimento(AJson: TJsonObject);
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      if (Titulos.Vencimento > 0) then
      begin
        AJson.Add('idboleto').Value.AsString := Titulos.NumeroDocumento;
        AJson.Add('dataVencimento').Value.AsString := FormatDateBr(Titulos.Vencimento, 'DD/MM/YYYY');
        AJson.Add('numeroTituloCliente').Value.AsString := Titulos.NossoNumero;
      end;
    end;

  end;

end;

procedure TBoletoW_PenseBank_API.AlterarProtesto(AJson: TJsonObject);
begin
  if Assigned(Titulos) then
  begin
    if Assigned(AJson) then
    begin
      if (Titulos.DiasDeProtesto > 0) then
      begin
        AJson.Add('idboleto').Value.AsString := Titulos.NumeroDocumento;
        AJson.Add('numeroTituloCliente').Value.AsString := Titulos.NossoNumero;
        AJson.Add('quantidadeDiasProtesto').Value.AsInteger := Titulos.DiasDeProtesto;
      end;

    end;
  end;
end;

function TBoletoW_PenseBank_API.CodigoTipoTitulo(AEspecieDoc : String): Integer;
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

constructor TBoletoW_PenseBank_API.Create(ABoletoWS: TBoletoWS);
begin
  inherited Create(ABoletoWS);

  FPAccept := C_ACCEPT;
end;

function TBoletoW_PenseBank_API.GerarRemessa: string;
begin
  Result := inherited GerarRemessa;

end;

function TBoletoW_PenseBank_API.Enviar: boolean;
begin
  Result := inherited Enviar;

end;
end.
