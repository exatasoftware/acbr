{******************************************************************************}
{ Projeto: Componente ACBrBlocoX                                               }
{ Biblioteca multiplataforma de componentes Delphi para Gera��o de arquivos    }
{ do Bloco X                                                                   }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{******************************************************************************}

{$I ACBr.inc}

unit ACBrBlocoX;

interface

uses
  Classes, SysUtils, ACBrBase,
  ACBrDFe, ACBrDFeConfiguracoes, ACBrBlocoX_WebServices, 
  ACBrBlocoX_ReducaoZ, ACBrBlocoX_Estoque, ACBrBlocoX_Comum, 
  ACBrBlocoX_Consulta, ACBrUtil;

type

  { TConfiguracoesBlocoX }

  TConfiguracoesBlocoX = class(TConfiguracoes)
  public
    FVersaoER: TVersaoER;
  published
    property VersaoER: TVersaoER read FVersaoER write FVersaoER;
    property Geral;
    property WebServices;
    property Certificados;
  end;

  { TACBrBlocoX_Estabelecimento }

  TACBrBlocoX_Estabelecimento = class(TPersistent)
  private
    FCnpj: String;
    FIe: String;
    FNomeEmpresarial: String;
  published
    property Ie: String read FIe write FIe;
    property Cnpj: String read FCnpj write FCnpj;
    property NomeEmpresarial: String read FNomeEmpresarial write FNomeEmpresarial;
  end;

  { TACBrBlocoX_PafECF }

  TACBrBlocoX_PafECF = class(TPersistent)
  private
    FVersao: String;
    FNumeroCredenciamento: String;
    FNomeComercial: String;
    FNomeEmpresarialDesenvolvedor: String;
    FCnpjDesenvolvedor: String;
  published
    property NumeroCredenciamento: String read FNumeroCredenciamento write FNumeroCredenciamento;
    property NomeComercial: String read FNomeComercial write FNomeComercial;
    property Versao: String read FVersao write FVersao;
    property CnpjDesenvolvedor: String read FCnpjDesenvolvedor write FCnpjDesenvolvedor;
    property NomeEmpresarialDesenvolvedor: String read FNomeEmpresarialDesenvolvedor write FNomeEmpresarialDesenvolvedor;
  end;

  { TACBrBlocoX_ECF }

  TACBrBlocoX_ECF = class(TPersistent)
  private
    FVersao: String;
    FNumeroCredenciamento: String;
    FNumeroFabricacao: String;
    FModelo: String;
    FMarca: String;
    FCaixa: String;
    FTipo: String;
  published
    property NumeroCredenciamento: String read FNumeroCredenciamento write FNumeroCredenciamento;
    property NumeroFabricacao: String read FNumeroFabricacao write FNumeroFabricacao;
    property Tipo: String read FTipo write FTipo;
    property Marca: String read FMarca write FMarca;
    property Modelo: String read FModelo write FModelo;
    property Versao: String read FVersao write FVersao;
    property Caixa: String read FCaixa write FCaixa;
  end;
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrBlocoX = class(TACBrDFe)
  private
    FPafECF: TACBrBlocoX_PafECF;
    FEstabelecimento: TACBrBlocoX_Estabelecimento;
    FEstoque: TACBrBlocoX_Estoque;
    FReducoesZ: TACBrBlocoX_ReducaoZ;
    FECF: TACBrBlocoX_ECF;
    FWebServices: TACBrBlocoX_WebServices;
    FConsultarProcessamentoArquivo: TACBrBlocoX_ConsultarProcessamentoArquivo;
    FReprocessarArquivo: TACBrBlocoX_ReprocessarArquivo;
    FConsultarHistoricoArquivo: TACBrBlocoX_ConsultarHistoricoArquivo;
    FListarArquivos: TACBrBlocoX_ListarArquivos;
    FDownloadArquivo: TACBrBlocoX_DownloadArquivo;
    FCancelarArquivo: TACBrBlocoX_CancelarArquivo;
    FConsultarPendenciasContribuinte: TACBrBlocoX_ConsultarPendenciasContribuinte;
    FConsultarPendenciasDesenvolvedorPafEcf: TACBrBlocoX_ConsultarPendenciasDesenvolvedorPafEcf;
    function GetConfiguracoes: TConfiguracoesBlocoX;
    procedure SetConfiguracoes(const Value: TConfiguracoesBlocoX);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Estoque: TACBrBlocoX_Estoque read FEstoque write FEstoque;
    property ReducoesZ: TACBrBlocoX_ReducaoZ read FReducoesZ write FReducoesZ;

    property ConsultarProcessamentoArquivo: TACBrBlocoX_ConsultarProcessamentoArquivo read FConsultarProcessamentoArquivo write FConsultarProcessamentoArquivo;
    property ReprocessarArquivo: TACBrBlocoX_ReprocessarArquivo read FReprocessarArquivo write FReprocessarArquivo;
    property ConsultarHistoricoArquivo: TACBrBlocoX_ConsultarHistoricoArquivo read FConsultarHistoricoArquivo write FConsultarHistoricoArquivo;
    property ListarArquivos: TACBrBlocoX_ListarArquivos read FListarArquivos write FListarArquivos;
    property DownloadArquivo: TACBrBlocoX_DownloadArquivo read FDownloadArquivo write FDownloadArquivo;
    property CancelarArquivo: TACBrBlocoX_CancelarArquivo read FCancelarArquivo write FCancelarArquivo;
    property ConsultarPendenciasContribuinte: TACBrBlocoX_ConsultarPendenciasContribuinte read FConsultarPendenciasContribuinte write FConsultarPendenciasContribuinte;
    property ConsultarPendenciasDesenvolvedorPafEcf: TACBrBlocoX_ConsultarPendenciasDesenvolvedorPafEcf
      read FConsultarPendenciasDesenvolvedorPafEcf write FConsultarPendenciasDesenvolvedorPafEcf;
  published
    property Estabelecimento: TACBrBlocoX_Estabelecimento read FEstabelecimento write FEstabelecimento;
    property PafECF: TACBrBlocoX_PafECF read FPafECF write FPafECF;
    property ECF: TACBrBlocoX_ECF read FECF write FECF;
    property Configuracoes: TConfiguracoesBlocoX read GetConfiguracoes Write SetConfiguracoes;

    property WebServices: TACBrBlocoX_WebServices read FWebServices write FWebServices;
  end;

implementation

{ TACBrBlocoX }

constructor TACBrBlocoX.Create(AOwner: TComponent);
begin
  inherited;
  FEstoque         := TACBrBlocoX_Estoque.Create(Self);
  FReducoesZ       := TACBrBlocoX_ReducaoZ.Create(Self);
  FPafECF          := TACBrBlocoX_PafECF.Create;
  FEstabelecimento := TACBrBlocoX_Estabelecimento.Create;
  FECF             := TACBrBlocoX_ECF.Create;
  FWebServices     := TACBrBlocoX_WebServices.Create(Self);
  FConsultarProcessamentoArquivo          := TACBrBlocoX_ConsultarProcessamentoArquivo.Create(Self);
  FReprocessarArquivo                     := TACBrBlocoX_ReprocessarArquivo.Create(Self);
  FConsultarHistoricoArquivo              := TACBrBlocoX_ConsultarHistoricoArquivo.Create(Self);
  FListarArquivos                         := TACBrBlocoX_ListarArquivos.Create(Self);
  FDownloadArquivo                        := TACBrBlocoX_DownloadArquivo.Create(Self);
  FCancelarArquivo                        := TACBrBlocoX_CancelarArquivo.Create(Self);
  FConsultarPendenciasContribuinte        := TACBrBlocoX_ConsultarPendenciasContribuinte.Create(Self);
  FConsultarPendenciasDesenvolvedorPafEcf := TACBrBlocoX_ConsultarPendenciasDesenvolvedorPafEcf.Create(Self);
end;

destructor TACBrBlocoX.Destroy;
begin
  FEstoque.Free;
  FReducoesZ.Free;
  FPafECF.Free;
  FEstabelecimento.Free;
  FECF.Free;
  FWebServices.Free;
  FConsultarProcessamentoArquivo.Free;
  FReprocessarArquivo.Free;
  FConsultarHistoricoArquivo.Free;
  FListarArquivos.Free;
  FDownloadArquivo.Free;
  FCancelarArquivo.Free;
  FConsultarPendenciasContribuinte.Free;
  FConsultarPendenciasDesenvolvedorPafEcf.Free;
  inherited;
end;

function TACBrBlocoX.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesBlocoX.Create(Self);
end;

function TACBrBlocoX.GetConfiguracoes: TConfiguracoesBlocoX;
begin
  Result := TConfiguracoesBlocoX(FPConfiguracoes);
end;

procedure TACBrBlocoX.SetConfiguracoes(const Value: TConfiguracoesBlocoX);
begin
  FPConfiguracoes := Value;
end;

end.
