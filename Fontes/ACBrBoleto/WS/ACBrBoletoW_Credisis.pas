unit ACBrBoletoW_Credisis;

interface

Uses
   Classes,
   SysUtils,
   DateUtils,
   ACBrBoletoWS,

   pcnConversao,
   pcnGerador,
   ACBrBoletoConversao,
   Soap.InvokeRegistry,
   Soap.SOAPHTTPClient,
   System.Types,

   ACBrValidador,
   ACBrBoleto,

   Soap.XSBuiltIns;

const
    IS_OPTN = $0001;
    IS_UNBD = $0002;
    IS_UNQL = $0008;


Type

//  TipoOperacao = (INCLUSAO, ALTERACAO, BAIXA, BAIXA_MANUAL, CANCELAMENTO);

 { TBoletoW_Credisis }
  TBoletoW_Credisis  = class(TBoletoWSSOAP)
  private

  protected
    procedure DefinirEnvelopeSoap; override;
    procedure DefinirRootElement; override;

    procedure GerarHeader; override;
    procedure GerarDados; override;


    procedure GerarTitulo;
    procedure GerarAvalista;
    procedure GerarPagador;
    Procedure GeraProtesto;
    Procedure GeraMulta;
    Procedure GeraJuros;
    Procedure GeraDesconto;

    procedure DefinirURL; override;

    function  Modulo11(Valor: String; Base: Integer = 9; Resto : boolean = false) : string;



  public
    constructor Create(ABoletoWS: TBoletoWS); override;

    function GerarRemessa: String; override;
    function Enviar: Boolean; override;
  end;

Const
  C_CredSis_URL = 'https://credisiscobranca.com.br/v2/ws?wsdl';
  C_CredSis_SOAP_ATTRIBUTTES = 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '+
                       'xmlns:urn="urn:CredisisBoletoInterface" xmlns:urn1="urn:CredisisBoletoInterface-CredisisWebService"';

implementation

uses
  ACBrUtil, synacode, ACBrBoletoPcnConsts, strutils, pcnConsts;


{ TBoletoW_Credisis }

constructor TBoletoW_Credisis.Create(ABoletoWS: TBoletoWS);
begin
    inherited Create(ABoletoWS);
    FPSoapEnvelopeAtributtes := C_CredSis_SOAP_ATTRIBUTTES;
end;

procedure TBoletoW_Credisis.DefinirEnvelopeSoap;
var Texto: String;

begin
  {$IFDEF FPC}
   Texto := '<' + ENCODING_UTF8 + '>';    // Envelope j� est� sendo montado em UTF8
  {$ELSE}
   Texto := '';  // Isso for�ar� a convers�o para UTF8, antes do envio
  {$ENDIF}

  FPDadosMsg := RemoverDeclaracaoXML(FPDadosMsg);

  Texto := Texto + '<' + FPSoapVersion + ':Envelope ' + FPSoapEnvelopeAtributtes + '>';
  Texto := Texto + '  <' + FPSoapVersion + ':Header>';
  Texto := Texto + '    <urn:Chave>';
  Texto := Texto + '      <token>'+ Titulos.ACBrBoleto.Cedente.CedenteWS.ClientSecret +'</token>';
  Texto := Texto + '      <convenio>'+Titulos.ACBrBoleto.Cedente.Convenio+'</convenio>';
  Texto := Texto + '    </urn:Chave>';
  Texto := Texto + '  </soapenv:Header>';
  Texto := Texto + '<' + FPSoapVersion + ':Body>';
  Texto := Texto + '  <urn1:gerarBoletos>';
  Texto := Texto + '     <layout>'+'default'+'</layout>';
  Texto := Texto + FPDadosMsg;
  Texto := Texto + '  </urn1:gerarBoletos>';
  Texto := Texto + '</' + FPSoapVersion + ':Body>';
  Texto := Texto + '</' + FPSoapVersion + ':Envelope>';

  FPEnvelopeSoap := Texto;

  FPSoapAction  := 'INCLUSAO';
  FPMimeType    := '';
end;

procedure TBoletoW_Credisis.DefinirRootElement;
begin
    FPRootElement:= '';
    FPCloseRootElement:= '';
end;

procedure TBoletoW_Credisis.DefinirURL;
begin
    FPURL := C_CredSis_URL;
end;

function TBoletoW_Credisis.Enviar: Boolean;
begin
    Result:=inherited Enviar;
end;

procedure TBoletoW_Credisis.GeraDesconto;
Var iTipo : Integer;
begin
    if Assigned(Titulos) then
    Begin
        iTipo := 0;
        if ( Titulos.ValorDesconto > 0 ) then
        Begin
            case Titulos.CodigoDesconto of
               cdSemDesconto : iTipo := 3;
               cdValorFixo   : iTipo := 2;
            end;
            if iTipo = 0 then
             iTipo := 1;

            Gerador.wGrupo('desconto1');
            Gerador.wCampo(tcDe2, '#01', 'valor', 01, 15, 1, Titulos.ValorDesconto, DSC_VALOR_DESCONTO);
            Gerador.wCampo(tcDat, '#02', 'data', 10, 10, 1, Titulos.DataDesconto, DSC_DATA_DESCONTO);
            Gerador.wCampo(tcInt, '#03', 'tipo', 01, 10, 1, iTipo, DSC_DATA_DESCONTO);
            Gerador.wGrupo('/desconto1');
        End;
        if ( Titulos.ValorDesconto2 > 0 ) then
        Begin
            case Titulos.CodigoDesconto of
               cdSemDesconto : iTipo := 3;
               cdValorFixo   : iTipo := 2;
            end;
            if iTipo = 0 then
             iTipo := 1;

            Gerador.wGrupo('desconto2');
            Gerador.wCampo(tcDe2, '#01', 'valor', 01, 15, 1, Titulos.ValorDesconto2, DSC_VALOR_DESCONTO);
            Gerador.wCampo(tcDat, '#02', 'data', 10, 10, 1, Titulos.DataDesconto2, DSC_DATA_DESCONTO);
            Gerador.wCampo(tcInt, '#03', 'tipo', 01, 10, 1, iTipo, DSC_DATA_DESCONTO);
            Gerador.wGrupo('/desconto2');
        End;
        if ( Titulos.ValorDesconto3 > 0 ) then
        Begin
            case Titulos.CodigoDesconto of
               cdSemDesconto : iTipo := 3;
               cdValorFixo   : iTipo := 2;
            end;
            if iTipo = 0 then
             iTipo := 1;

            Gerador.wGrupo('desconto3');
            Gerador.wCampo(tcDe2, '#01', 'valor', 01, 15, 1, Titulos.ValorDesconto3, DSC_VALOR_DESCONTO);
            Gerador.wCampo(tcDat, '#02', 'data', 10, 10, 1, Titulos.DataDesconto3, DSC_DATA_DESCONTO);
            Gerador.wCampo(tcInt, '#03', 'tipo', 01, 10, 1, iTipo, DSC_DATA_DESCONTO);
            Gerador.wGrupo('/desconto3');
        End;

    End;
end;

procedure TBoletoW_Credisis.GeraJuros;
Var iTipo : Integer;
    iDias : Integer;
begin
    if Assigned(Titulos) then
    Begin
        if ( Titulos.ValorMoraJuros > 0 ) and ( Titulos.DataMoraJuros > 0) then
        Begin
            iTipo := 0;
            iDias := 0;
            case Titulos.CodigoMoraJuros of
               cjValorDia,
               cjValorMensal : iTipo := 1;
               cjTaxaMensal,
               cjTaxaDiaria  : iTipo := 2;
               cjIsento      : iTipo := 3;
            end;

            if Titulos.DataMoraJuros <> Titulos.Vencimento then
             iDias := DaysBetween(Titulos.Vencimento, Titulos.DataMoraJuros);

            Gerador.wGrupo('juros');
            Gerador.wCampo(tcDe2, '#01', 'valor', 01, 15, 1, Titulos.ValorMoraJuros, DSC_VALOR_MORA_JUROS);
            Gerador.wGrupo('carencia');
            Gerador.wCampo(tcInt, '#01', 'dias', 01, 10, 1, iDias, DSC_DIAS_PROTESTO);
            Gerador.wCampo(tcInt, '#02', 'tipo', 01, 10, 1, iTipo, DSC_CODIGO_MORA_JUROS);
            Gerador.wGrupo('/carencia');
            Gerador.wCampo(tcInt, '#01', 'tipo', 01, 10, 1, iTipo, DSC_CODIGO_MORA_JUROS);
            Gerador.wGrupo('/juros');
        End;
    End;

end;

procedure TBoletoW_Credisis.GeraMulta;
Var iTipo : Integer;
    iDias : Integer;
begin
    if Assigned(Titulos) then
    Begin
        if ( Titulos.PercentualMulta > 0 ) and ( Titulos.DataMulta > 0) then
        Begin
            iTipo := 0;
            iDias := 0;

            Case Titulos.CodigoMulta Of
              cmValorFixo  : iTipo := 1;
              cmPercentual : iTipo := 2;
              cmIsento     : iTipo := 3;
            End;

            if Titulos.DataMulta <> Titulos.Vencimento then
             iDias := DaysBetween(Titulos.Vencimento, Titulos.DataMulta);

            Gerador.wGrupo('multa');
            Gerador.wCampo(tcDe2, '#01', 'valor', 01, 15, 1, Titulos.PercentualMulta, DSC_PERCENTUAL_MULTA);
            Gerador.wGrupo('carencia');
            Gerador.wCampo(tcInt, '#01', 'dias', 01, 10, 1, iDias, DSC_DIAS_PROTESTO);
            Gerador.wCampo(tcInt, '#02', 'tipo', 01, 10, 1, iTipo, DSC_DIAS_PROTESTO);
            Gerador.wGrupo('/carencia');
            Gerador.wCampo(tcInt, '#02', 'tipo', 01, 10, 1, iTipo, DSC_DIAS_PROTESTO);
            Gerador.wGrupo('/multa');
        End;
    End;
end;

procedure TBoletoW_Credisis.GeraProtesto;
Var iTipo : Integer;
begin
    if Assigned(Titulos) then
    Begin
        iTipo := 0;

        Case Titulos.CodigoNegativacao Of
         cnNenhum           : iTipo := 1;
         cnProtestarCorrido : iTipo := 2;
         cnProtestarUteis   : iTipo := 1;
         cnNaoProtestar     : iTipo := 1;
         cnNegativar        : iTipo := 1;
         cnNaoNegativar     : iTipo := 1;
         cnCancelamento     : iTipo := 1;
        End;

        Gerador.wGrupo('protesto');
        Gerador.wCampo(tcStr, '#01', 'tipo', 01, 1, 1, iTipo, DSC_DIAS_PROTESTO);
        Gerador.wCampo(tcInt, '#02', 'dias', 01, 2, 1, Titulos.DiasDeProtesto, DSC_DIAS_PROTESTO);
        Gerador.wGrupo('/protesto');
    End;
end;

procedure TBoletoW_Credisis.GerarAvalista;
begin
  if Assigned(Titulos) then
  Begin
      if NaoEstaVazio(Titulos.Sacado.SacadoAvalista.CNPJCPF) then
      begin
          Gerador.wGrupo('avalista');

          if (Integer(Titulos.Sacado.SacadoAvalista.Pessoa) = 0) then
           Gerador.wCampo(tcStr, '#01', 'nome', 01, 40, 1, Titulos.Sacado.SacadoAvalista.NomeAvalista, DSC_NOME_AVALISTA)
          else
           Gerador.wCampo(tcStr, '#01', 'nome', 01, 40, 1, Titulos.Sacado.SacadoAvalista.NomeAvalista, DSC_NOME_AVALISTA);

          Gerador.wCampoCNPJCPF('#02', 'cpfCnpj', Titulos.Sacado.SacadoAvalista.CNPJCPF);

         Gerador.wGrupo('/avalista');
      end;
  End;
end;

procedure TBoletoW_Credisis.GerarDados;
begin
  if Assigned(Titulos) then
    with Titulos do
    begin
      case Boleto.Configuracoes.WebService.Operacao of
        tpInclui: GerarTitulo
      else
        raise EACBrBoletoWSException.Create(ClassName + Format( S_OPERACAO_NAO_IMPLEMENTADO, [
                                                  TipoOperacaoToStr( Boleto.Configuracoes.WebService.Operacao ) ] ));
      end;
    end;
end;

procedure TBoletoW_Credisis.GerarHeader;
begin

end;

procedure TBoletoW_Credisis.GerarPagador;
begin
    if Assigned(Titulos) then
    Begin
        Gerador.wGrupo('pagador');
        Gerador.wCampo(tcStr, '#01', 'nome', 01, 60, 1, Titulos.Sacado.NomeSacado, DSC_NOME_SACADO);
        Gerador.wCampo(tcStr, '#02', 'cpfCnpj', 01, 14, 1, Titulos.Sacado.CNPJCPF, DSC_CPF);

        Gerador.wGrupo('endereco');
        Gerador.wCampo(tcStr, '#03', 'endereco', 01, 40, 1, Titulos.Sacado.Logradouro, DSC_LOGRADOURO);
        Gerador.wCampo(tcStr, '#04', 'bairro'  , 01, 15, 1, Titulos.Sacado.Bairro, DSC_BAIRRO);
        Gerador.wCampo(tcStr, '#05', 'cep'     , 08, 08, 1, Titulos.Sacado.Cep, DSC_CEP);
        Gerador.wCampo(tcStr, '#06', 'cidade'  , 01, 15, 1, Titulos.Sacado.Cidade, DSC_CIDADE);
        Gerador.wCampo(tcStr, '#07', 'uf'      , 02, 02, 1, Titulos.Sacado.UF, DSC_UF);
        Gerador.wCampo(tcStr, '#08', 'numero'  , 02, 10, 1, Titulos.Sacado.Numero, DSC_NUMERO_SACADO);
        Gerador.wGrupo('/endereco');

        Gerador.wGrupo('contatos');
        Gerador.wGrupo('item');
        Gerador.wCampo(tcStr, '#09', 'contato'    , 02, 10, 1, Titulos.Sacado.Fone, DSC_FONE );
        Gerador.wCampo(tcInt, '#10', 'tipoContato', 01, 10, 1, 1, DSC_FONE );

        Gerador.wGrupo('/item');
        Gerador.wGrupo('/contatos');
        Gerador.wGrupo('/pagador');
    end;
end;

function TBoletoW_Credisis.GerarRemessa: String;
begin
    Result:=inherited GerarRemessa;
end;

procedure TBoletoW_Credisis.GerarTitulo;
Var vNossoNumero:String;
    FCalculoDigito : TACBrCalcDigito;

    Function CalcularDigitoVerificador(const ACBrTitulo: TACBrTitulo): string;
    Begin
        FCalculoDigito.CalculoPadrao;
        FCalculoDigito.Documento := ACBrTitulo.NossoNumero;
        FCalculoDigito.Calcular;
        if FCalculoDigito.ModuloFinal = 0 then
         Result := '1'
        else
         Result := IntToStr(FCalculoDigito.DigitoFinal);
    End;

begin
    if Assigned(Titulos) then
    Begin
        FCalculoDigito := TACBrCalcDigito.Create;

        vNossoNumero := '097'+
                        CalcularDigitoVerificador(Titulos)+
                        ACBrUtil.PadLeft(Titulos.ACBrBoleto.Cedente.Agencia,4,'0')+
                        ACBrUtil.PadLeft(Titulos.ACBrBoleto.Cedente.Convenio,6,'0')+
                        ACBrUtil.PadLeft(Titulos.NossoNumero,6,'0');

        Gerador.wGrupo('boletos');
        Gerador.wGrupo('boleto');

        GerarAvalista;
        GerarPagador;

        Gerador.wCampo(tcStr, '#01', 'documento', 11, 11, 1, Titulos.NumeroDocumento, DSC_NUMERO_DOCUMENTO);
        Gerador.wCampo(tcDat, '#02', 'dataEmissao', 10, 10, 1, Titulos.DataDocumento, DSC_DATA_DOCUMENTO);
        Gerador.wCampo(tcDat, '#03', 'dataVencimento', 10, 10, 1, Titulos.Vencimento, DSC_DATA_VENCIMENTO);
        Gerador.wCampo(tcDat, '#04', 'dataLimitePagamento', 10, 10, 1, Titulos.DataLimitePagto, DSC_DATA_LIMITE_PAGAMENTO);
        Gerador.wCampo(tcDe2, '#05', 'valor', 01, 15, 1, Titulos.ValorDocumento, DSC_VALOR_DOCUMENTO);
        //<!--Optional:-->
        //Gerador.wCampo(tcInt, '#10', 'grupoParcela', 1, 10, 1, 1, '' );
        //<grupoParcela>?</grupoParcela>

        //<!--Optional:-->
        Gerador.wCampo(tcStr, '#07', 'nossonumero', 1, 30, 1, vNossoNumero, DSC_NOSSO_NUMERO);
        //<!--Optional:-->
        Gerador.wCampo(tcInt, '#08', 'quantidadeParcelas', 1, 1, 1, Titulos.Parcela, DSC_NNFINI );
        //<!--Optional:-->
        Gerador.wCampo(tcInt, '#09', 'intervaloParcela', 1, 1, 1, Titulos.TotalParcelas, DSC_NNFFIN);

        //<!--Optional:-->
        //<layout>'default_'</layout>

        //<!--Optional:-->
        //<formato>?</formato>

        If Titulos.EspecieDoc = 'DMI' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '03', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'DSI' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '05', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'NP' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '12', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'RC' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '17', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'AP' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '20', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'ME' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '21', DSC_TIPO_ESPECIE)
        Else If Titulos.EspecieDoc = 'NF' Then
         Gerador.wCampo(tcStr, '#12', 'codigoEspecie', 01, 15, 1, '23', DSC_TIPO_ESPECIE);

        GeraProtesto;

        //<!--Optional:-->
        //<tipoEnvio>?</tipoEnvio>
        //<!--Optional:-->

        Gerador.wCampo(tcStr, '#13', 'instrucao', 01, 100, 1, Titulos.Mensagem.Text, DSC_INSTRUCAO1);

        GeraMulta;
        GeraJuros;
        GeraDesconto;

        Gerador.wGrupo('/boleto');
        Gerador.wGrupo('/boletos');

        FreeAndNil(FCalculoDigito);
    End;
end;

function TBoletoW_Credisis.Modulo11(Valor: String; Base: Integer; Resto: boolean): string;
var
   Soma : integer;
   Contador, Peso, Digito : integer;
begin
   Valor := Trim(valor);
   Soma := 0;
   Peso := 2;
   for Contador := Length(Valor) downto 1 do
   begin
      Soma := Soma + (StrToInt(Valor[Contador]) * Peso);
      if Peso < Base then
         Peso := Peso + 1
      else
         Peso := 2;
   end;

   if Resto then
      Result := IntToStr(Soma mod 11)
   else
   begin
      Digito := 11 - (Soma mod 11);
      if (Digito > 9) then
         Digito := 0;
      Result := IntToStr(Digito);
   end
end;


end.
