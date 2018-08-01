{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit pgnreConfigUF;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor;
(*
 pgnreConversao, ACBrUtil;
*) 

type
  TInfReceita = class;
  TRetInfReceita = class;
  TInfDetalhamentoReceita = class;
  TRetInfDetalhamentoReceita = class;
  TInfProduto = class;
  TRetInfProduto = class;

  TInfReceita = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
    Fcourier: string;
    FexigeDetalhamentoReceita: string;
    FexigeProduto: string;
    FexigePeriodoReferencia: string;
    FexigePeriodoApuracao: string;
    FexigeParcela: string;
    FvalorExigido: string;
    FexigeDocumentoOrigem: string;
    FexigeContribuinteDestinatario: string;
    FexigeCamposAdicionais: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
    property courier: string read Fcourier write Fcourier;
    property exigeDetalhamentoReceita: string read FexigeDetalhamentoReceita write FexigeDetalhamentoReceita;
    property exigeProduto: string read FexigeProduto write FexigeProduto;
    property exigePeriodoReferencia: string read FexigePeriodoReferencia write FexigePeriodoReferencia;
    property exigePeriodoApuracao: string read FexigePeriodoApuracao write FexigePeriodoApuracao;
    property exigeParcela: string read FexigeParcela write FexigeParcela;
    property valorExigido: string read FvalorExigido write FvalorExigido;
    property exigeDocumentoOrigem: string read FexigeDocumentoOrigem write FexigeDocumentoOrigem;
    property exigeContribuinteDestinatario: string read FexigeContribuinteDestinatario write FexigeContribuinteDestinatario;
    property exigeCamposAdicionais: string read FexigeCamposAdicionais write FexigeCamposAdicionais;
  end;

  TRetInfReceita = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
    Fcourier: string;
    FexigeContribuinteEmitente: string;
    FexigeDetalhamentoReceita: string;
    FexigeProduto: string;
    FexigePeriodoReferencia: string;
    FexigePeriodoApuracao: string;
    FexigeParcela: string;
    FvalorExigido: string;
    FexigeDocumentoOrigem: string;
    FexigeContribuinteDestinatario: string;
    FexigeDataVencimento: string;
    FexigeDataPagamento: string;
    FexigeConvenio: string; 
    FexigeCamposAdicionais: string;
  published
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
    property courier: string read Fcourier write Fcourier;
    property exigeContribuinteEmitente: string read FexigeContribuinteEmitente write FexigeContribuinteEmitente;
    property exigeDetalhamentoReceita: string read FexigeDetalhamentoReceita write FexigeDetalhamentoReceita;
    property exigeProduto: string read FexigeProduto write FexigeProduto;
    property exigePeriodoReferencia: string read FexigePeriodoReferencia write FexigePeriodoReferencia;
    property exigePeriodoApuracao: string read FexigePeriodoApuracao write FexigePeriodoApuracao;
    property exigeParcela: string read FexigeParcela write FexigeParcela;
    property valorExigido: string read FvalorExigido write FvalorExigido;
    property exigeDocumentoOrigem: string read FexigeDocumentoOrigem write FexigeDocumentoOrigem;
    property exigeContribuinteDestinatario: string read FexigeContribuinteDestinatario write FexigeContribuinteDestinatario;
    property exigeDataVencimento: string read FexigeDataVencimento write FexigeDataVencimento;
    property exigeDataPagamento: string read FexigeDataPagamento write FexigeDataPagamento;    
    property exigeConvenio: string read FexigeConvenio write FexigeConvenio;
    property exigeCamposAdicionais: string read FexigeCamposAdicionais write FexigeCamposAdicionais;
  end;

  TInfDetalhamentoReceita = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TRetInfDetalhamentoReceita = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  published
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TInfProduto = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TRetInfProduto = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  published
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TInfPeriodoApuracao = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TRetInfPeriodoApuracao = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  published
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TInfTipoDocumentoOrigem = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  public
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TRetInfTipoDocumentoOrigem = class
  private
    Fcodigo: Integer;
    Fdescricao: string;
  published
    property codigo: Integer read Fcodigo write Fcodigo;
    property descricao: string read Fdescricao write Fdescricao;
  end;

  TInfCampoAdicional = class
  private
    Fobrigatorio: string;
    Fcodigo: Integer;
    Ftipo: string;
    Ftamanho: Integer;
    FcasasDecimais: Integer;
    Ftitulo: string;
  public
    property obrigatorio: string read Fobrigatorio write Fobrigatorio;
    property codigo: Integer read Fcodigo write Fcodigo;
    property tipo: string read Ftipo write Ftipo;
    property tamanho: Integer read Ftamanho write Ftamanho;
    property casasDecimais: Integer read FcasasDecimais write FcasasDecimais;
    property titulo: string read Ftitulo write Ftitulo;
  end;

  TRetInfCampoAdicional = class
  private
    Fobrigatorio: string;
    Fcodigo: Integer;
    Ftipo: string;
    Ftamanho: Integer;
    FcasasDecimais: Integer;
    Ftitulo: string;
  published
    property obrigatorio: string read Fobrigatorio write Fobrigatorio;
    property codigo: Integer read Fcodigo write Fcodigo;
    property tipo: string read Ftipo write Ftipo;
    property tamanho: Integer read Ftamanho write Ftamanho;
    property casasDecimais: Integer read FcasasDecimais write FcasasDecimais;
    property titulo: string read Ftitulo write Ftitulo;
  end;

implementation

end.
 