{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit Febraban150.GravarTxtRemessa;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrDebitoAutomaticoGravarTxt, ACBrDebitoAutomaticoClass, ACBrDebitoAutomaticoConversao;

const
  IDENTIFICACAOSERVICO = 'DEBITO AUTOMATICO';

type
  { TArquivoW_Febraban150 }

  TArquivoW_Febraban150 = class(TArquivoWClass)
  private
    FNomeArquivo: String;
    FArquivoTXT: String;
  protected
    FLayoutVersao: TDebitoLayoutVersao;

    procedure GerarRegistroA; virtual;
    procedure GerarRegistrosC; virtual;
    procedure GerarRegistrosD; virtual;
    procedure GerarRegistrosE; virtual;
    procedure GerarRegistrosI; virtual;
    procedure GerarRegistrosJ; virtual;
    procedure GerarRegistrosK; virtual;
    procedure GerarRegistrosL; virtual;
    procedure GerarRegistroZ; virtual;

    procedure ValidarLinha(const Tipo: string); virtual;
    procedure IncluirLinha; virtual;
  public
    function GerarTxt: Boolean; override;

    procedure LimparRegistros;

    property NomeArquivo: string read FNomeArquivo write FNomeArquivo;
    property ArquivoTXT: string read FArquivoTXT write FArquivoTXT;
  end;

implementation

uses
  ACBrUtil.Strings, ACBrUtil.Compatibilidade,
  ACBrDebitoAutomatico, ACBrDebitoAutomaticoProviderBase;

{ TArquivoW_Febraban150 }

procedure TArquivoW_Febraban150.GerarRegistroA;
begin
  {
    Registro A - Header
    Ocorr�ncia: Obrigat�rio e unico no arquivo
    Origem: Destinat�ria e Deposit�ria
  }
  FpLinha := '';

  GravarCampo('A', 1, tcStr);
  GravarCampo(TipoArquivoToStr(DebitoAutomatico.Geral.TipoArquivo), 1, tcStr);
  GravarCampo(DebitoAutomatico.RegistroA.CodigoConvenio, 20, tcStrZero);
  GravarCampo(DebitoAutomatico.RegistroA.NomeEmpresa, 20, tcStr);
  GravarCampo(DebitoAutomatico.RegistroA.CodigoBanco, 3, tcInt);
  GravarCampo(DebitoAutomatico.RegistroA.NomeBanco, 20, tcStr);
  GravarCampo(DebitoAutomatico.RegistroA.Geracao, 8, tcDatISO);
  GravarCampo(DebitoAutomatico.RegistroA.NSA, 6, tcInt);
  GravarCampo(LayoutVersaoToStr(DebitoAutomatico.RegistroA.LayoutVersao), 2, tcStr);
  GravarCampo(IDENTIFICACAOSERVICO, 17, tcStr);
  GravarCampo(' ', 52, tcStr);

  ValidarLinha('A');
  IncluirLinha;
end;

procedure TArquivoW_Febraban150.GerarRegistrosC;
var
  i: Integer;
begin
  {
    Registro C - Ocorr�ncias no Cancelamento do D�bito Autom�tico.
    Ocorr�ncia: Opcional e varios no arquivo
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroC.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('C', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroC[i].IdentificacaoClienteEmpresa, 25, tcStr);
    GravarCampo(DebitoAutomatico.RegistroC[i].AgenciaDebito, 4, tcStrZero);

    if FLayoutVersao = lv8 then
      GravarCampo(DebitoAutomatico.RegistroC[i].IdentificacaoClienteBanco, 20, tcStrZero)
    else
      GravarCampo(DebitoAutomatico.RegistroC[i].IdentificacaoClienteBanco, 14, tcStrZero);

    GravarCampo(DebitoAutomatico.RegistroC[i].Ocorrencia1, 40, tcStr);
    GravarCampo(DebitoAutomatico.RegistroC[i].Ocorrencia2, 40, tcStr);

    if FLayoutVersao = lv8 then
      GravarCampo(' ', 19, tcStr)
    else
      GravarCampo(' ', 25, tcStr);

    GravarCampo(MovimentoCadastroToStr(DebitoAutomatico.RegistroC[i].CodigoMovimento), 1, tcStr);

    ValidarLinha('C');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosD;
var
  i: Integer;
begin
  {
    Registro D - Solicita��o da Destinat�ria a Altera��o de cadastrodo Cliente
                 na Deposit�ria/ Cancelamento de Contrato de D�bito via
                 Destinat�ria.
    Ocorr�ncia: Opcional e varios no arquivo
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroD.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('D', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroD[i].IdentificacaoClienteEmpresaAnterior, 25, tcStr);
    GravarCampo(DebitoAutomatico.RegistroD[i].AgenciaDebito, 4, tcStrZero);

    if FLayoutVersao = lv8 then
      GravarCampo(DebitoAutomatico.RegistroD[i].IdentificacaoClienteBanco, 20, tcStrZero)
    else
      GravarCampo(DebitoAutomatico.RegistroD[i].IdentificacaoClienteBanco, 14, tcStrZero);

    GravarCampo(DebitoAutomatico.RegistroD[i].IdentificacaoClienteEmpresaAtual, 25, tcStr);

    if FLayoutVersao = lv8 then
    begin
      GravarCampo(DebitoAutomatico.RegistroD[i].Ocorrencia, 55, tcStr);
      GravarCampo(DebitoAutomatico.RegistroD[i].NovaDataVencAutorizacao, 8, tcDatISO);
      GravarCampo(AlteracaoOpcaoToStr(DebitoAutomatico.RegistroD[i].AlteracaoOpcaoUsoChequeEspecial), 1, tcStr);
      GravarCampo(AlteracaoOpcaoToStr(DebitoAutomatico.RegistroD[i].AlteracaoOpcaoDebParcialIntegralPosVenc), 1, tcStr);
      GravarCampo(' ', 9, tcStr)
    end
    else
    begin
      GravarCampo(DebitoAutomatico.RegistroD[i].Ocorrencia, 60, tcStr);
      GravarCampo(' ', 20, tcStr);
    end;

    GravarCampo(MovimentoAlteracaoToStr(DebitoAutomatico.RegistroD[i].CodigoMovimento), 1, tcStr);

    ValidarLinha('D');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosE;
var
  i: Integer;
begin
  {
    Registro E - Cadastramento do D�bito Autom�tico / D�bito em Conta
    Ocorr�ncia: Obrigat�rio
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroE.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('E', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroE[i].IdentificacaoClienteEmpresa, 25, tcStr);
    GravarCampo(DebitoAutomatico.RegistroE[i].AgenciaDebito, 4, tcStrZero);

    if FLayoutVersao = lv8 then
      GravarCampo(DebitoAutomatico.RegistroE[i].IdentificacaoClienteBanco, 20, tcStrZero)
    else
      GravarCampo(DebitoAutomatico.RegistroE[i].IdentificacaoClienteBanco, 14, tcStrZero);

    GravarCampo(DebitoAutomatico.RegistroE[i].Vencimento, 8, tcDatISO);

    if DebitoAutomatico.RegistroE[i].DebitoMoeda = mUFIR then
      GravarCampo(DebitoAutomatico.RegistroE[i].Valor, 15, tcDe5)
    else
      GravarCampo(DebitoAutomatico.RegistroE[i].Valor, 15, tcDe2);

    GravarCampo(MoedaToStr(DebitoAutomatico.RegistroE[i].DebitoMoeda), 2, tcStr);

    case FLayoutVersao of
      lv8:
        begin
          GravarCampo(DebitoAutomatico.RegistroE[i].UsoEmpresa, 53, tcStr);
          GravarCampo(UsoEmpresaXYToStr(DebitoAutomatico.RegistroE[i].UsoEmpresaXY), 1, tcStr);
          GravarCampo(CPFCNPJToStr(DebitoAutomatico.RegistroE[i].TipoIdentificacao), 1, tcStr);
          GravarCampo(DebitoAutomatico.RegistroE[i].CPFCNPJ, 15, tcStrZero);
          GravarCampo(TipoOperacaoToStr(DebitoAutomatico.RegistroE[i].TipoOperacao), 1, tcStr);
          GravarCampo(SimNaoToStr(DebitoAutomatico.RegistroE[i].UtilizacaoChequeEspecial), 1, tcStr);
          GravarCampo(SimNaoToStr(DebitoAutomatico.RegistroE[i].OpcaoDebParcialIntegralPosVenc), 1, tcStr);
          GravarCampo(' ', 1, tcStr);
        end;

      lv5,
      lv6:
        begin
          GravarCampo(DebitoAutomatico.RegistroE[i].UsoEmpresa, 59, tcStr);
          GravarCampo(UsoEmpresaXYToStr(DebitoAutomatico.RegistroE[i].UsoEmpresaXY), 1, tcStr);
          GravarCampo(CPFCNPJToStr(DebitoAutomatico.RegistroE[i].TipoIdentificacao), 1, tcStr);
          GravarCampo(DebitoAutomatico.RegistroE[i].CPFCNPJ, 15, tcStrZero);
          GravarCampo(' ', 4, tcStr);
        end;

      lv4:
        begin
          GravarCampo(DebitoAutomatico.RegistroE[i].UsoEmpresa, 49, tcStr);
          GravarCampo(DebitoAutomatico.RegistroE[i].UsoEmpresaValorTotalTributos, 10, tcDe2);
          GravarCampo(UsoEmpresaXYToStr(DebitoAutomatico.RegistroE[i].UsoEmpresaXY), 1, tcStr);
          GravarCampo(' ', 20, tcStr);
        end;
    end;

    GravarCampo(MovimentoDebitoToStr(DebitoAutomatico.RegistroE[i].CodigoMovimento), 1, tcStr);

    ValidarLinha('E');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosI;
var
  i: Integer;
begin
  {
    Registro I - Incentivo de D�bito Autom�tico
    Ocorr�ncia: Opcional
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroI.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('I', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroI[i].IdentificacaoClienteEmpresa, 25, tcStr);
    GravarCampo(CPFCNPJToStr(DebitoAutomatico.RegistroI[i].TipoIdentificacao), 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroI[i].CPFCNPJ, 14, tcStrZero);
    GravarCampo(DebitoAutomatico.RegistroI[i].Nome, 40, tcStr);
    GravarCampo(DebitoAutomatico.RegistroI[i].Cidade, 30, tcStr);
    GravarCampo(DebitoAutomatico.RegistroI[i].UF, 2, tcStr);
    GravarCampo(' ', 37, tcStr);

    ValidarLinha('I');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosJ;
var
  i: Integer;
begin
  {
    Registro J - Confirma��o de Processamento de Arquivos
    Ocorr�ncia: Opcional
    Origem: Destinat�ria e Deposit�ria
  }
  for i := 0 to DebitoAutomatico.RegistroJ.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('J', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroJ[i].NSA, 6, tcInt);
    GravarCampo(DebitoAutomatico.RegistroJ[i].Geracao, 8, tcDatISO);
    GravarCampo(DebitoAutomatico.RegistroJ[i].TotalRegistros, 6, tcInt);
    GravarCampo(DebitoAutomatico.RegistroJ[i].ValorTotal, 17, tcDe2);
    GravarCampo(DebitoAutomatico.RegistroJ[i].Processamento, 8, tcDatISO);
    GravarCampo(' ', 104, tcStr);

    ValidarLinha('J');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosK;
var
  i: Integer;
begin
  {
    Registro K - Lei n.� 10.833
    Ocorr�ncia: Opcional
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroK.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('K', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroK[i].IdentificacaoClienteEmpresa, 25, tcStr);
    GravarCampo(DebitoAutomatico.RegistroK[i].AgenciaDebito, 4, tcStrZero);
    GravarCampo(DebitoAutomatico.RegistroK[i].IdentificacaoClienteBanco, 14, tcStrZero);
    GravarCampo(DebitoAutomatico.RegistroK[i].TipoTratamento, 2, tcInt);
    GravarCampo(DebitoAutomatico.RegistroK[i].Valor, 15, tcDe2);
    GravarCampo(IntToStr(DebitoAutomatico.RegistroK[i].CodigoReceita), 4, tcStr);
    GravarCampo(CPFCNPJToStr(DebitoAutomatico.RegistroK[i].TipoIdentificacao), 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroK[i].CPFCNPJ, 15, tcStrZero);
    GravarCampo(' ', 69, tcStr);

    ValidarLinha('K');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistrosL;
var
  i: Integer;
begin
  {
    Registro L - Cronograma de Faturamento de Contas / Tributos
    Ocorr�ncia: Opcional
    Origem: Destinat�ria
  }
  for i := 0 to DebitoAutomatico.RegistroL.Count - 1 do
  begin
    FpLinha := '';

    GravarCampo('L', 1, tcStr);
    GravarCampo(DebitoAutomatico.RegistroL[i].FaturamentoContas, 8, tcDatISO);
    GravarCampo(DebitoAutomatico.RegistroL[i].VencimentoFatura, 8, tcDatISO);
    GravarCampo(DebitoAutomatico.RegistroL[i].RemessaArquivoBanco, 8, tcDatISO);
    GravarCampo(DebitoAutomatico.RegistroL[i].RemessaContasFisicas, 8, tcDatISO);
    GravarCampo(' ', 117, tcStr); // nos manuais consta 104

    ValidarLinha('L');
    IncluirLinha;
  end;
end;

procedure TArquivoW_Febraban150.GerarRegistroZ;
var
  Total, i: Integer;
  ValorTotal: Double;
begin
  {
    Registro Z - Trailler
    Ocorr�ncia: Obrigat�rio
    Origem: Destinat�ria e Deposit�ria
  }
  FpLinha := '';
  ValorTotal := 0;

  GravarCampo('Z', 1, tcStr);

  with DebitoAutomatico do
  begin
    Total := RegistroC.Count + RegistroD.Count + RegistroE.Count +
             RegistroI.Count + RegistroJ.Count + RegistroL.Count + 2;

    if FLayoutVersao in [lv5, lv6] then
      Total := Total + RegistroK.Count;

    for i := 0 to RegistroE.Count - 1 do
      ValorTotal := ValorTotal + RegistroE[i].Valor;
  end;

  GravarCampo(Total, 6, tcInt);
  GravarCampo(ValorTotal, 17, tcDe2);
  GravarCampo(' ', 126, tcStr);

  ValidarLinha('Z');
  IncluirLinha;
end;

function TArquivoW_Febraban150.GerarTxt: Boolean;
begin
  FArquivoTXT := '';
  FLayoutVersao := DebitoAutomatico.RegistroA.LayoutVersao;
  FConteudoTxt.Clear;
  {
  REMESSA: enviado pela Institui��o Destinat�ria (empresa),
           para a Institui��o Deposit�ria (banco).
           Este arquivo poder� conter os seguintes registros:
           A, C, D, E, J, e Z.
  }
  try
    LimparRegistros;

    GerarRegistroA;
    GerarRegistrosC;
    GerarRegistrosD;
    GerarRegistrosE;

    if FLayoutVersao <> lv8 then
      GerarRegistrosI;

    GerarRegistrosJ;

    if FLayoutVersao in [lv5, lv6] then
      GerarRegistrosK;

    if FLayoutVersao <> lv8 then
      GerarRegistrosL;

    GerarRegistroZ;

    FConteudoTxt.Text := FArquivoTXT;
    Result := True;
  except
    on E: Exception do
    begin
      raise Exception.Create('N�o Foi Poss�vel incluir Registros no Arquivo: ' +
              FNomeArquivo + #13 + E.Message);
    end;
  end;
end;

procedure TArquivoW_Febraban150.IncluirLinha;
begin
  if FArquivoTXT = '' then
    FArquivoTXT := FpLinha
  else
    FArquivoTXT := FArquivoTXT + sLineBreak + FpLinha;
end;

procedure TArquivoW_Febraban150.LimparRegistros;
begin
// N�o Implementado
end;

procedure TArquivoW_Febraban150.ValidarLinha(const Tipo: string);
var
  Titulo: string;
begin
  Titulo := 'Registro ['+ Tipo;

  if Length(FpLinha) <> 150 then
    raise Exception.Create(#13 + Titulo + '] inv�lido!' + #13 +
     'Deve conter 150 posi��es.' + #13 +
     'Registro: [' + FpLinha + ']' + #13 +
     'possui ' + IntToStr(Length(FpLinha)) + ' posi��es.');
end;

end.
