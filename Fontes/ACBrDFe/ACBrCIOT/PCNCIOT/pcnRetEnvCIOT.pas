
{$I ACBr.inc}

unit pcnRetEnvCIOT;

interface
 uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor, pcnCIOT, pcnConversaoCIOT, synacode;

type
  TRetornoEnvio = class;

{ TRetornoEnvio }

 TRetornoEnvio = class(TPersistent)
  private
    FLeitor: TLeitor;
    FRetEnvio: TRetEnvio;
    FIntegradora: TCIOTIntegradora;
  public
    constructor Create;
    destructor Destroy; override;

    function LerRetorno_eFrete: Boolean;
    function LerRetorno_Repom: Boolean;
    function LerRetorno_Pamcard: Boolean;

    function LerXml: Boolean;
  published
    property Integradora: TCIOTIntegradora read FIntegradora write FIntegradora;
    property Leitor: TLeitor     read FLeitor   write FLeitor;
    property RetEnvio: TRetEnvio read FRetEnvio write FRetEnvio;
  end;

implementation

uses
  ACBrUtil;

{ TRetornoEnvio }

constructor TRetornoEnvio.Create;
begin
  FLeitor   := TLeitor.Create;
  FRetEnvio := TRetEnvio.Create;
end;

destructor TRetornoEnvio.Destroy;
begin
  FLeitor.Free;
  FRetEnvio.Free;

  inherited;
end;

function TRetornoEnvio.LerRetorno_eFrete: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;

  try
    if (leitor.rExtrai(1, 'LoginResponse') <> '') or
       (leitor.rExtrai(1, 'LogoutResponse') <> '') or

       (leitor.rExtrai(1, 'GravarResponse') <> '') or

       (leitor.rExtrai(1, 'AdicionarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'RetificarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'CancelarOperacaoTransporteResponse') <> '') or
       (leitor.rExtrai(1, 'ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteResponse') <> '') or
       (leitor.rExtrai(1, 'ObterOperacaoTransportePdfResponse') <> '') or
       (leitor.rExtrai(1, 'AdicionarViagemResponse') <> '') or
       (leitor.rExtrai(1, 'AdicionarPagamentoResponse') <> '') or
       (leitor.rExtrai(1, 'CancelarPagamentoResponse') <> '') or
       (leitor.rExtrai(1, 'EncerrarOperacaoTransporteResponse') <> '') then
    begin
      if (leitor.rExtrai(2, 'LoginResult') <> '') or
         (leitor.rExtrai(2, 'LogoutResult') <> '') or

         (leitor.rExtrai(2, 'GravarResult') <> '') or

         (leitor.rExtrai(2, 'AdicionarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'RetificarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'CancelarOperacaoTransporteResult') <> '') or
         (leitor.rExtrai(2, 'ObterCodigoIdentificacaoOperacaoTransportePorIdOperacaoClienteResult') <> '') or
         (leitor.rExtrai(2, 'ObterOperacaoTransportePdfResult') <> '') or
         (leitor.rExtrai(2, 'AdicionarViagemResult') <> '') or
         (leitor.rExtrai(2, 'AdicionarPagamentoResult') <> '') or
         (leitor.rExtrai(2, 'CancelarPagamentoResult') <> '') or
         (leitor.rExtrai(2, 'EncerrarOperacaoTransporteResult') <> '') then
      begin
        with RetEnvio do
        begin
          Versao           := leitor.rCampo(tcStr, 'Versao');
          Sucesso          := leitor.rCampo(tcStr, 'Sucesso');
          ProtocoloServico := leitor.rCampo(tcStr, 'ProtocoloServico');

          Token := leitor.rCampo(tcStr, 'Token');

          if (leitor.rExtrai(3, 'Proprietario') <> '') then
          begin
            With Proprietario do
            begin
              CNPJ              := leitor.rCampo(tcStr, 'CNPJ');
              TipoPessoa        := StrToTipoPessoa(ok, leitor.rCampo(tcStr, 'TipoPessoa'));
              RazaoSocial       := leitor.rCampo(tcStr, 'RazaoSocial');
              RNTRC             := leitor.rCampo(tcStr, 'RNTRC');
              Tipo              := StrToTipoProprietario(ok, leitor.rCampo(tcStr, 'Tipo'));
              TACouEquiparado   := StrToBool(leitor.rCampo(tcBoolStr, 'TACouEquiparado'));
              DataValidadeRNTRC := leitor.rCampo(tcDat, 'DataValidadeRNTRC');
              RNTRCAtivo        := StrToBool(leitor.rCampo(tcBoolStr, 'RNTRCAtivo'));

              if (leitor.rExtrai(4, 'Endereco') <> '') then
              begin
                with Endereco do
                begin
                  Bairro          := leitor.rCampo(tcStr, 'Bairro');
                  Rua             := leitor.rCampo(tcStr, 'Rua');
                  Numero          := leitor.rCampo(tcStr, 'Numero');
                  Complemento     := leitor.rCampo(tcStr, 'Complemento');
                  CEP             := leitor.rCampo(tcStr, 'CEP');
                  CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
                end;
              end;

              if (leitor.rExtrai(4, 'Telefones') <> '') then
              begin
                with Telefones do
                begin
                  if (leitor.rExtrai(5, 'Celular') <> '') then
                  begin
                    Celular.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Celular.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;

                  if (leitor.rExtrai(5, 'Fixo') <> '') then
                  begin
                    Fixo.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Fixo.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;

                  if (leitor.rExtrai(5, 'Fax') <> '') then
                  begin
                    Fax.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Fax.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;
                end;
              end;
            end;
          end;

          if (leitor.rExtrai(3, 'Veiculo') <> '') then
          begin
            With Veiculo do
            begin
              Placa           := leitor.rCampo(tcStr, 'Placa');
              Renavam         := leitor.rCampo(tcStr, 'Renavam');
              Chassi          := leitor.rCampo(tcStr, 'Chassi');
              RNTRC           := leitor.rCampo(tcStr, 'RNTRC');
              NumeroDeEixos   := leitor.rCampo(tcInt, 'NumeroDeEixos');
              CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
              Marca           := leitor.rCampo(tcStr, 'Marca');
              Modelo          := leitor.rCampo(tcStr, 'Modelo');
              AnoFabricacao   := leitor.rCampo(tcInt, 'AnoFabricacao');
              AnoModelo       := leitor.rCampo(tcInt, 'AnoModelo');
              Cor             := leitor.rCampo(tcStr, 'Cor');
              Tara            := leitor.rCampo(tcInt, 'Tara');
              CapacidadeKg    := leitor.rCampo(tcInt, 'CapacidadeKg');
              CapacidadeM3    := leitor.rCampo(tcInt, 'CapacidadeM3');
              TipoRodado      := StrToTipoRodado(ok, leitor.rCampo(tcStr, 'TipoRodado'));
              TipoCarroceria  := StrToTipoCarroceria(ok, leitor.rCampo(tcStr, 'TipoCarroceria'));
            end;
          end;

          if (leitor.rExtrai(3, 'Motorista') <> '') then
          begin
            With Motorista do
            begin
              CPF                 := leitor.rCampo(tcStr, 'CPF');
              Nome                := leitor.rCampo(tcStr, 'Nome');
              CNH                 := leitor.rCampo(tcStr, 'CNH');
              DataNascimento      := leitor.rCampo(tcDat, 'DataNascimento');
              NomeDeSolteiraDaMae := leitor.rCampo(tcStr, 'NomeDeSolteiraDaMae');

              if (leitor.rExtrai(4, 'Endereco') <> '') then
              begin
                with Endereco do
                begin
                  Bairro          := leitor.rCampo(tcStr, 'Bairro');
                  Rua             := leitor.rCampo(tcStr, 'Rua');
                  Numero          := leitor.rCampo(tcStr, 'Numero');
                  Complemento     := leitor.rCampo(tcStr, 'Complemento');
                  CEP             := leitor.rCampo(tcStr, 'CEP');
                  CodigoMunicipio := leitor.rCampo(tcInt, 'CodigoMunicipio');
                end;
              end;

              if (leitor.rExtrai(4, 'Telefones') <> '') then
              begin
                with Telefones do
                begin
                  if (leitor.rExtrai(5, 'Celular') <> '') then
                  begin
                    Celular.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Celular.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;

                  if (leitor.rExtrai(5, 'Fixo') <> '') then
                  begin
                    Fixo.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Fixo.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;

                  if (leitor.rExtrai(5, 'Fax') <> '') then
                  begin
                    Fax.DDD    := leitor.rCampo(tcInt, 'DDD');
                    Fax.Numero := leitor.rCampo(tcInt, 'Numero');
                  end;
                end;
              end;
            end;
          end;

          PDF := leitor.rCampo(tcStr, 'Pdf');

          if PDF <> '' then
            PDF := UnZip(DecodeBase64(PDF));

          CodigoIdentificacaoOperacao := leitor.rCampo(tcStr, 'CodigoIdentificacaoOperacao');
          Data                        := leitor.rCampo(tcDatHor, 'Data');
          Protocolo                   := leitor.rCampo(tcStr, 'Protocolo');
          DataRetificacao             := leitor.rCampo(tcDatHor, 'DataRetificacao');
          QuantidadeViagens           := leitor.rCampo(tcInt, 'QuantidadeViagens');
          QuantidadePagamentos        := leitor.rCampo(tcInt, 'QuantidadePagamentos');
          IdPagamentoCliente          := leitor.rCampo(tcStr, 'IdPagamentoCliente');
          EstadoCiot                  := StrToEstadoCIOT(ok, leitor.rCampo(tcStr, 'EstadoCiot'));

          if leitor.rExtrai(3, 'DocumentoViagem') <> '' then
          begin
            i := 0;
            while Leitor.rExtrai(4, 'string', '', i + 1) <> '' do
            begin
              with DocumentoViagem.New do
              begin
                Mensagem := Leitor.rCampo(tcStr, 'string');
              end;
              inc(i);
            end;
          end;

          if leitor.rExtrai(3, 'DocumentoPagamento') <> '' then
          begin
            i := 0;
            while Leitor.rExtrai(4, 'string', '', i + 1) <> '' do
            begin
              with DocumentoPagamento.New do
              begin
                Mensagem := Leitor.rCampo(tcStr, 'string');
              end;
              inc(i);
            end;
          end;

          if leitor.rExtrai(3, 'Excecao') <> '' then
          begin
            Mensagem := leitor.rCampo(tcStr, 'Mensagem');
            Codigo   := leitor.rCampo(tcStr, 'Codigo');
          end;
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

function TRetornoEnvio.LerRetorno_Pamcard: Boolean;
begin
  Result := False;

  try

    //.................. Implementar

  except
    Result := False;
  end;
end;

function TRetornoEnvio.LerRetorno_Repom: Boolean;
begin
  Result := False;

  try

    //.................. Implementar

  except
    Result := False;
  end;
end;

function TRetornoEnvio.LerXml: Boolean;
begin
  Leitor.Grupo := Leitor.Arquivo;

  case Integradora of
    ieFrete:  Result := LerRetorno_eFrete;
    iRepom:   Result := LerRetorno_Repom;
    iPamcard: Result := LerRetorno_Pamcard;
  else
    Result := False;
  end;
end;

end.

