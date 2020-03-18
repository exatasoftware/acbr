{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Teno Dias                                }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrLibBoletoDataModule;

interface

uses
  Classes, SysUtils, ACBrBoleto, ACBrBoletoFCFortesFr, syncobjs,
  ACBrLibConfig, ACBrLibMailImport, ACBrMail;

type

  { TLibBoletoDM }

  TLibBoletoDM = class(TDataModule)
    ACBrBoleto1: TACBrBoleto;
    ACBrBoletoFCFortes1: TACBrBoletoFCFortes;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FLock: TCriticalSection;
    FACBrMail: TACBrMail;
    FLibMail: TACBrLibMail;

  public
    procedure AplicarConfiguracoes;
    procedure GravarLog(AMsg: String; NivelLog: TNivelLog; Traduzir: Boolean = False);
    procedure Travar;
    procedure Destravar;
    procedure CriarACBrMail;
    procedure AplicarConfigMail;

  end;

var
  LibBoletoDM: TLibBoletoDM;

implementation

uses
  ACBrUtil, ACBrLibComum, FileUtil, ACBrLibBoletoConfig, ACBrLibBoletoClass;

{$R *.lfm}

{ TLibBoletoDM }

procedure TLibBoletoDM.DataModuleCreate(Sender: TObject);
begin
  FLock := TCriticalSection.Create;
  FACBrMail := Nil;
  FLibMail := Nil;
end;

procedure TLibBoletoDM.DataModuleDestroy(Sender: TObject);
begin
  FLock.Destroy;
  if Assigned(FLibMail) then
    FreeAndNil(FLibMail)
  else if Assigned(FACBrMail) then
    FreeAndNil(FACBrMail);
end;

procedure TLibBoletoDM.AplicarConfiguracoes;
var
  pLibConfig: TLibBoletoConfig;
begin
  pLibConfig := TLibBoletoConfig(TACBrLibBoleto(pLib).Config);

  with ACBrBoleto1 do
  begin
    DataArquivo := pLibConfig.BoletoDiretorioConfig.DataArquivo;
    DataCreditoLanc := pLibConfig.BoletoDiretorioConfig.DataCreditoLanc;
    DirArqRemessa := pLibConfig.BoletoDiretorioConfig.DirArqRemessa;
    DirArqRetorno := pLibConfig.BoletoDiretorioConfig.DirArqRetorno;
    Homologacao := pLibConfig.BoletoDiretorioConfig.DirHomologacao;
    ImprimirMensagemPadrao := pLibConfig.BoletoDiretorioConfig.ImprimirMensagemPadrao;
    LayoutRemessa := pLibConfig.BoletoDiretorioConfig.LayoutRemessa;
    LeCedenteRetorno := pLibConfig.BoletoDiretorioConfig.LeCedenteRetorno;
    NomeArqRemessa := pLibConfig.BoletoDiretorioConfig.NomeArqRemessa;
    NomeArqRetorno := pLibConfig.BoletoDiretorioConfig.NomeArqRetorno;
    NumeroArquivo := pLibConfig.BoletoDiretorioConfig.NumeroArquivo;
    RemoveAcentosArqRemessa := pLibConfig.BoletoDiretorioConfig.RemoveAcentosArqRemessa;

    with ACBrBoleto1.Banco do
    begin
      Digito := pLibConfig.BoletoBancoConfig.Digito;
      LayoutVersaoArquivo := pLibConfig.BoletoBancoConfig.LayoutVersaoArquivo;
      LayoutVersaoLote := pLibConfig.BoletoBancoConfig.LayoutVersaoLote;
      LocalPagamento := pLibConfig.BoletoBancoConfig.LocalPagamento;
      Numero := pLibConfig.BoletoBancoConfig.Numero;
      NumeroCorrespondente := pLibConfig.BoletoBancoConfig.NumeroCorrespondente;
      OrientacoesBanco.Text := pLibConfig.BoletoBancoConfig.OrientacaoBanco;
      TipoCobranca := pLibConfig.BoletoBancoConfig.TipoCobranca;
    end;

    with ACBrBoleto1.Cedente do
    begin
      Agencia := pLibConfig.BoletoCedenteConfig.Agencia;
      AgenciaDigito := pLibConfig.BoletoCedenteConfig.AgenciaDigito;
      Bairro := pLibConfig.BoletoCedenteConfig.Bairro;
      CaracTitulo := pLibConfig.BoletoCedenteConfig.CaracTitulo;
      CEP := pLibConfig.BoletoCedenteConfig.CEP;
      Cidade := pLibConfig.BoletoCedenteConfig.Cidade;
      CNPJCPF := pLibConfig.BoletoCedenteConfig.CNPJCPF;
      CodigoCedente := pLibConfig.BoletoCedenteConfig.CodigoCedente;
      CodigoTransmissao := pLibConfig.BoletoCedenteConfig.CodigoTransmissao;
      Complemento := pLibConfig.BoletoCedenteConfig.Complemento;
      Conta := pLibConfig.BoletoCedenteConfig.Conta;
      ContaDigito := pLibConfig.BoletoCedenteConfig.ContaDigito;
      Convenio := pLibConfig.BoletoCedenteConfig.Convenio;
      Logradouro := pLibConfig.BoletoCedenteConfig.Logradouro;
      Modalidade := pLibConfig.BoletoCedenteConfig.Modalidade;
      Nome := pLibConfig.BoletoCedenteConfig.Nome;
      NumeroRes := pLibConfig.BoletoCedenteConfig.NumeroRes;
      ResponEmissao := pLibConfig.BoletoCedenteConfig.ResponEmissao;
      Telefone := pLibConfig.BoletoCedenteConfig.Telefone;
      TipoCarteira := pLibConfig.BoletoCedenteConfig.TipoCarteira;
      TipoDocumento := pLibConfig.BoletoCedenteConfig.TipoDocumento;
      TipoInscricao := pLibConfig.BoletoCedenteConfig.TipoInscricao;
      UF := pLibConfig.BoletoCedenteConfig.UF;
      DigitoVerificadorAgenciaConta := pLibConfig.BoletoCedenteConfig.DigitoVerificadorAgenciaConta;
    end;
  end;

  with ACBrBoletoFCFortes1 do
  begin
     DirLogo := pLibConfig.BoletoFCFortesConfig.DirLogo;
     Filtro := pLibConfig.BoletoFCFortesConfig.Filtro;
     Layout := pLibConfig.BoletoFCFortesConfig.Layout;
     MostrarPreview := pLibConfig.BoletoFCFortesConfig.MostrarPreview;
     MostrarProgresso := pLibConfig.BoletoFCFortesConfig.MostrarProgresso;
     MostrarSetup := pLibConfig.BoletoFCFortesConfig.MostrarSetup;
     NomeArquivo := pLibConfig.BoletoFCFortesConfig.NomeArquivo;
     NumCopias := pLibConfig.BoletoFCFortesConfig.NumeroCopias;
     PrinterName := pLibConfig.BoletoFCFortesConfig.PrinterName;
     SoftwareHouse := pLibConfig.BoletoFCFortesConfig.SoftwareHouse;
  end;

  AplicarConfigMail;

end;

procedure TLibBoletoDM.GravarLog(AMsg: String; NivelLog: TNivelLog;
  Traduzir: Boolean);
begin
  if Assigned(pLib) then
    pLib.GravarLog(AMsg, NivelLog, Traduzir);
end;

procedure TLibBoletoDM.Travar;
begin
  GravarLog('Travar', logParanoico);
  FLock.Acquire;
end;

procedure TLibBoletoDM.Destravar;
begin
  GravarLog('Destravar', logParanoico);
  FLock.Release;
end;

procedure TLibBoletoDM.CriarACBrMail;
var
  NomeLib: String;
begin
  if Assigned(FLibMail) or Assigned(FACBrMail) then
      Exit;

  GravarLog('  CriarACBrMail', logCompleto);

  NomeLib := ApplicationPath + CACBrMailLIBName;
  if FileExists(NomeLib) then
  begin
    GravarLog('      Carregando MAIL de: ' + NomeLib, logCompleto);
    // Criando Classe para Leitura da Lib //
    FLibMail  := TACBrLibMail.Create(NomeLib, pLib.Config.NomeArquivo, pLib.Config.ChaveCrypt);
    FACBrMail := FLibMail.ACBrMail;
  end
  else
  begin
    GravarLog('     Criando MAIL Interno', logCompleto);
    FACBrMail := TACBrMail.Create(Nil);
  end;

  ACBrBoleto1.MAIL := FACBrMail;
end;

procedure TLibBoletoDM.AplicarConfigMail;
begin
  if Assigned(FLibMail) or (not Assigned(FACBrMail)) then
    Exit;

  with FACBrMail do
  begin
    Attempts := pLib.Config.Email.Tentativas;
    SetTLS := pLib.Config.Email.TLS;
    DefaultCharset := pLib.Config.Email.Codificacao;
    From := pLib.Config.Email.Conta;
    FromName := pLib.Config.Email.Nome;
    SetSSL := pLib.Config.Email.SSL;
    Host := pLib.Config.Email.Servidor;
    IDECharset := pLib.Config.Email.Codificacao;
    IsHTML := pLib.Config.Email.IsHTML;
    Password := pLib.Config.Email.Senha;
    Port := IntToStr(pLib.Config.Email.Porta);
    Priority := pLib.Config.Email.Priority;
    ReadingConfirmation := pLib.Config.Email.Confirmacao;
    DeliveryConfirmation := pLib.Config.Email.ConfirmacaoEntrega;
    TimeOut := pLib.Config.Email.TimeOut;
    Username := pLib.Config.Email.Usuario;
    UseThread := pLib.Config.Email.SegundoPlano;
  end;

end;

{ TLibBoletoDM }

end.

