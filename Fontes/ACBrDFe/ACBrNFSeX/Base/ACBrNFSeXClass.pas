{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrNFSeXClass;

interface

uses
  SysUtils, Classes,
  {$IFNDEF VER130}
    Variants,
  {$ENDIF}
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  ACBrNFSeXConversao;

type

  TInfID = class(TObject)
  private
    FID: string;
  public
    property ID: string read FID write FID;
  end;

  TIdentificacaoRps = class(TObject)
  private
    FNumero: string;
    FSerie: string;
    FTipo: TTipoRps;
  public
    property Numero: string read FNumero write FNumero;
    property Serie: string read FSerie write FSerie;
    property Tipo: TTipoRps read FTipo write FTipo;
  end;

  TIdentificacaoNfse = class(TObject)
  private
    FNumero: string;
    FCnpj: string;
    FInscricaoMunicipal: string;
    FCodigoMunicipio: string;
  public
    property Numero: string read FNumero write FNumero;
    property Cnpj: string read FCnpj write FCnpj;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
  end;

  TValoresNfse = class(TObject)
  private
    FBaseCalculo: Double;
    FAliquota: Double;
    FValorIss: Double;
    FValorLiquidoNfse: Double;
  public
    property BaseCalculo: Double read FBaseCalculo write FBaseCalculo;
    property Aliquota: Double read FAliquota write FAliquota;
    property ValorIss: Double read FValorIss write FValorIss;
    property ValorLiquidoNfse: Double read FValorLiquidoNfse write FValorLiquidoNfse;
  end;

  TValores = class(TObject)
  private
    FValorServicos: Double;
    FValorDeducoes: Double;
    FValorPis: Double;
    FValorCofins: Double;
    FValorInss: Double;
    FValorIr: Double;
    FValorCsll: Double;
    FIssRetido: TnfseSituacaoTributaria;
    FValorIss: Double;
    FOutrasRetencoes: Double;
    FBaseCalculo: Double;
    FAliquota: Double;
    FAliquotaSN: Double; // Aliquota usada pelo Provedor Conam
    FAliquotaPis: Double;
    FAliquotaCofins: Double;
    FAliquotaInss: Double;
    FAliquotaIr: Double;
    FAliquotaCsll: Double;
    FOutrosDescontos: Double;
    FValorLiquidoNfse: Double;
    FValorIssRetido: Double;
    FDescontoCondicionado: Double;
    FDescontoIncondicionado: Double;
    FJustificativaDeducao: string;
    FvalorOutrasRetencoes: Double;
    FDescricaoOutrasRetencoes: string;
    FvalorRepasse: Double; // Governa
    FValorDespesasNaoTributaveis: Double; // Governa
    FValorTotalRecebido: Double;
    FValorTotalTributos: Double;
    FIrrfIndenizacao: Double;
  public
    property ValorServicos: Double read FValorServicos write FValorServicos;
    property ValorDeducoes: Double read FValorDeducoes write FValorDeducoes;
    property ValorPis: Double read FValorPis write FValorPis;
    property ValorCofins: Double read FValorCofins write FValorCofins;
    property ValorInss: Double read FValorInss write FValorInss;
    property ValorIr: Double read FValorIr write FValorIr;
    property ValorCsll: Double read FValorCsll write FValorCsll;
    property IssRetido: TnfseSituacaoTributaria read FIssRetido write FIssRetido;
    property ValorIss: Double read FValorIss write FValorIss;
    property OutrasRetencoes: Double read FOutrasRetencoes write FOutrasRetencoes;
    property BaseCalculo: Double read FBaseCalculo write FBaseCalculo;
    property Aliquota: Double read FAliquota write FAliquota;
    // Aliquota usada pelo Provedor Conam
    property AliquotaSN: Double read FAliquotaSN write FAliquotaSN;
    // Aliquotas usadas pelo Provedor IssDsf
    property AliquotaPis: Double read FAliquotaPis write FAliquotaPis;
    property AliquotaCofins: Double read FAliquotaCofins write FAliquotaCofins;
    property AliquotaInss: Double read FAliquotaInss write FAliquotaInss;
    property AliquotaIr: Double read FAliquotaIr write FAliquotaIr;
    property AliquotaCsll: Double read FAliquotaCsll write FAliquotaCsll;
    // Usado pelo Provedor EL
    property OutrosDescontos: Double read FOutrosDescontos write FOutrosDescontos;

    property ValorLiquidoNfse: Double read FValorLiquidoNfse write FValorLiquidoNfse;
    property ValorIssRetido: Double read FValorIssRetido write FValorIssRetido;
    property DescontoCondicionado: Double read FDescontoCondicionado write FDescontoCondicionado;
    property DescontoIncondicionado: Double read FDescontoIncondicionado write FDescontoIncondicionado;
    //Just. usada pelo provedor Equiplano
    property JustificativaDeducao: string read FJustificativaDeducao write FJustificativaDeducao;
    //propriedade do Provedor Governa
    property valorOutrasRetencoes: Double read FvalorOutrasRetencoes write FvalorOutrasRetencoes;
    property DescricaoOutrasRetencoes: string read FDescricaoOutrasRetencoes write FDescricaoOutrasRetencoes;
    property ValorRepasse: Double read FValorRepasse write FValorRepasse;
    //Provedor Infisc V 11
    property ValorDespesasNaoTributaveis: Double read FValorDespesasNaoTributaveis write FValorDespesasNaoTributaveis;
    //Recife
    property ValorTotalRecebido: Double read FValorTotalRecebido write FValorTotalRecebido;
    //Provedor proSimplISSv2
    property ValorTotalTributos: Double read FValorTotalTributos write FValorTotalTributos;
    //Provedor Tecnos
    property IrrfIndenizacao: Double read FIrrfIndenizacao write FIrrfIndenizacao;
  end;

  TItemServicoCollectionItem = class(TObject)
  private
    FDescricao: string;
    FQuantidade: Double;
    FValorUnitario: Double;
    FValorTotal: Double;
    FAliquota: Double;
    FValorIss: Double;
    FBaseCalculo: Double;
    FValorDeducoes: Double;
    FDescontoCondicionado: Double;
    FDescontoIncondicionado: Double;
    FTributavel: TnfseSimNao;
    //Provedor: SystemPro
    FValorCsll: Double;
    FValorPis: Double;
    FValorCofins: Double;
    FValorInss: Double;
    FValorIr: Double;
    FQuantidadeDiaria: Double;
    FValorTaxaTurismo: Double;
    // Provedor Infisc Vers�o XML 1.1
    FCodServ: string;
    FCodLCServ: string;
    FUnidade: string;
    FAliquotaISSST: Double;
    FValorISSST: Double;
    FpRetIR: Double;
    FvBCCSLL: Double;
    FpRetINSS: Double;
    FvBCINSS: Double;
    FvBCPISPASEP: Double;
    FvBCCOFINS: Double;
    FvBCRetIR: Double;
    FpRetCSLL: Double;
    FvDed: Double;
    FpRetPISPASEP: Double;
    FpRetCOFINS: Double;
    FvRed: Double;
    FTipoUnidade: TUnidade;
    FItemListaServico: string;
    FJustificativaDeducao: string;

  public
    constructor Create;

    property Descricao: string read FDescricao write FDescricao;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property ValorUnitario: Double read FValorUnitario write FValorUnitario;
    property ValorTotal: Double read FValorTotal write FValorTotal;
    property ValorDeducoes: Double read FValorDeducoes write FValorDeducoes;
    property ValorIss: Double read FValorIss write FValorIss;
    property Aliquota: Double read FAliquota write FAliquota;
    property BaseCalculo: Double read FBaseCalculo write FBaseCalculo;
    property DescontoCondicionado: Double read FDescontoCondicionado write FDescontoCondicionado;
    property DescontoIncondicionado: Double read FDescontoIncondicionado write FDescontoIncondicionado;
    property Tributavel: TnfseSimNao read FTributavel write FTributavel;
    // Provedor SystemPro
    property ValorPis: Double read FValorPis write FValorPis;
    property ValorCofins: Double read FValorCofins write FValorCofins;
    property ValorInss: Double read FValorInss write FValorInss;
    property ValorIr: Double read FValorIr write FValorIr;
    property ValorCsll: Double read FValorCsll write FValorCsll;
    property QuantidadeDiaria: Double read FQuantidadeDiaria write FQuantidadeDiaria;
    property ValorTaxaTurismo: Double read FValorTaxaTurismo write FValorTaxaTurismo;
    // Provedor Infisc Vers�o XML 1.1
    property CodServ: string read FCodServ write FCodServ;
    property CodLCServ: string read FCodLCServ write FCodLCServ;
    property Unidade: string read FUnidade write FUnidade;
    property AliquotaISSST: Double read FAliquotaISSST write FAliquotaISSST;
    property ValorISSST: Double read FValorISSST write FValorISSST;

    property vDed: Double read FvDed write FvDed;
    property vRed: Double read FvRed write FvRed;

    property vBCINSS: Double read FvBCINSS write FvBCINSS;
    property pRetINSS: Double read FpRetINSS write FpRetINSS;

    property vBCRetIR: Double read FvBCRetIR write FvBCRetIR;
    property pRetIR: Double read FpRetIR write FpRetIR;

    property vBCCOFINS: Double read FvBCCOFINS write FvBCCOFINS;
    property pRetCOFINS: Double read FpRetCOFINS write FpRetCOFINS;

    property vBCCSLL: Double read FvBCCSLL write FvBCCSLL;
    property pRetCSLL: Double read FpRetCSLL write FpRetCSLL;

    property vBCPISPASEP: Double read FvBCPISPASEP write FvBCPISPASEP;
    property pRetPISPASEP: Double read FpRetPISPASEP write FpRetPISPASEP;

    property TipoUnidade: TUnidade read FTipoUnidade write FTipoUnidade;
    property ItemListaServico: string read FItemListaServico write FItemListaServico;
    // Provedor Equiplano
    property JustificativaDeducao: string read FJustificativaDeducao write FJustificativaDeducao;
  end;

  TItemServicoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TItemServicoCollectionItem;
    procedure SetItem(Index: Integer; Value: TItemServicoCollectionItem);
  public
    function Add: TItemServicoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TItemServicoCollectionItem;
    property Items[Index: Integer]: TItemServicoCollectionItem read GetItem write SetItem; default;
  end;

  // classe usada no provedor IssDSF
  TDeducaoCollectionItem = class(TObject)
  private
    FDeducaoPor: TnfseDeducaoPor;
    FTipoDeducao: TnfseTipoDeducao;
    FCpfCnpjReferencia: string;
    FNumeroNFReferencia: string;
    FValorTotalReferencia: Double;
    FPercentualDeduzir: Double;
    FValorDeduzir: Double;
  public
    property DeducaoPor: TnfseDeducaoPor read FDeducaoPor write FDeducaoPor;
    property TipoDeducao: TnfseTipoDeducao read FTipoDeducao write FTipoDeducao;
    property CpfCnpjReferencia: string read FCpfCnpjReferencia write FCpfCnpjReferencia;
    property NumeroNFReferencia: string read FNumeroNFReferencia write FNumeroNFReferencia;
    property ValorTotalReferencia: Double read FValorTotalReferencia write FValorTotalReferencia;
    property PercentualDeduzir: Double read FPercentualDeduzir write FPercentualDeduzir;
    property ValorDeduzir: Double read FValorDeduzir write FValorDeduzir;
  end;

  TDeducaoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDeducaoCollectionItem;
    procedure SetItem(Index: Integer; Value: TDeducaoCollectionItem);
  public
    function Add: TDeducaoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDeducaoCollectionItem;
    property Items[Index: Integer]: TDeducaoCollectionItem read GetItem write SetItem; default;
  end;

  TDadosServico = class(TObject)
  private
    FValores: TValores;
    FItemListaServico: string;
    FCodigoCnae: string;
    FCodigoTributacaoMunicipio: string;
    FxCodigoTributacaoMunicipio: string;
    FDiscriminacao: string;
    FCodigoMunicipio: string;
    FCodigoPais: Integer;
    FExigibilidadeISS: TnfseExigibilidadeISS;
    FMunicipioIncidencia: Integer;
    FNumeroProcesso: string;
    FxItemListaServico: string;
    FItemServico: TItemServicoCollection;
    FResponsavelRetencao: TnfseResponsavelRetencao;
    FDescricao: string;
    // Provedor IssDsf
    FDeducao: TDeducaoCollection;
    FOperacao: TOperacao;
    FTributacao: TTributacao;
    // Provedor Governa
    FUFPrestacao: string;
    // Provedor SP
    FValorCargaTributaria: Double;
    FPercentualCargaTributaria: Double;
    FFonteCargaTributaria: string;

    procedure SetItemServico(Value: TItemServicoCollection);
    procedure SetDeducao(const Value: TDeducaoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property Valores: TValores read FValores write FValores;
    property ItemListaServico: string read FItemListaServico write FItemListaServico;
    property CodigoCnae: string read FCodigoCnae write FCodigoCnae;
    property CodigoTributacaoMunicipio: string read FCodigoTributacaoMunicipio write FCodigoTributacaoMunicipio;
    property xCodigoTributacaoMunicipio: string read FxCodigoTributacaoMunicipio write FxCodigoTributacaoMunicipio;
    property Discriminacao: string read FDiscriminacao write FDiscriminacao;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property CodigoPais: Integer read FCodigoPais write FCodigoPais;
    property ExigibilidadeISS: TnfseExigibilidadeISS read FExigibilidadeISS write FExigibilidadeISS;
    property MunicipioIncidencia: Integer read FMunicipioIncidencia write FMunicipioIncidencia;
    property NumeroProcesso: string read FNumeroProcesso write FNumeroProcesso;
    property xItemListaServico: string read FxItemListaServico write FxItemListaServico;
    property ItemServico: TItemServicoCollection read FItemServico write SetItemServico;
    property ResponsavelRetencao: TnfseResponsavelRetencao read FResponsavelRetencao write FResponsavelRetencao;
    property Descricao: string read FDescricao write FDescricao;
    // Provedor IssDsf
    property Deducao: TDeducaoCollection read FDeducao write SetDeducao;
    property Operacao: TOperacao read FOperacao write FOperacao;
    property Tributacao: TTributacao read FTributacao write FTributacao;
    // Provedor Governa
    property UFPrestacao: string read FUFPrestacao write FUFPrestacao;
    // Provedor SP
    property ValorCargaTributaria: Double read FValorCargaTributaria write FValorCargaTributaria;
    property PercentualCargaTributaria: Double read FPercentualCargaTributaria write FPercentualCargaTributaria;
    property FonteCargaTributaria: string read FFonteCargaTributaria write FFonteCargaTributaria;
  end;

  TIdentificacaoPrestador = class(TObject)
  private
    FCnpj: string;
    FInscricaoMunicipal: string;
    FInscricaoEstadual: string;
  public
    property Cnpj: string read FCnpj write FCnpj;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property InscricaoEstadual: string read FInscricaoEstadual write FInscricaoEstadual;
  end;

  TEndereco = class(TObject)
  private
    FEnderecoInformado: Boolean;
    FTipoLogradouro: string;
    FEndereco: string;
    FNumero: string;
    FComplemento: string;
    FTipoBairro: string;
    FBairro: string;
    FCodigoMunicipio: string;
    FUF: string;
    FCEP: string;
    FxMunicipio: string;
    FCodigoPais: Integer;
    FxPais: string;
  public
    property EnderecoInformado: Boolean read FEnderecoInformado write FEnderecoInformado;
    property TipoLogradouro: string read FTipoLogradouro write FTipoLogradouro;
    property Endereco: string read FEndereco write FEndereco;
    property Numero: string read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property TipoBairro: string read FTipoBairro write FTipoBairro;
    property Bairro: string read FBairro write FBairro;
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property UF: string read FUF write FUF;
    property CEP: string read FCEP write FCEP;
    property xMunicipio: string read FxMunicipio write FxMunicipio;
    property CodigoPais: Integer read FCodigoPais write FCodigoPais;
    property xPais: string read FxPais write FxPais;
  end;

  TContato = class(TObject)
  private
    FTelefone: string;
    FEmail: string;
    FDDD: string;
    FTipoTelefone: string;
  public
    property Telefone: string read FTelefone write FTelefone;
    property Email: string read FEmail write FEmail;
    property DDD: string read FDDD write FDDD;
    property TipoTelefone: string read FTipoTelefone write FTipoTelefone;
  end;

  TDadosPrestador = class(TObject)
  private
    FIdentificacaoPrestador: TIdentificacaoPrestador;

    FRazaoSocial: string;
    FNomeFantasia: string;

    FEndereco: TEndereco;
    FContato: TContato;

    FcUF: Integer;
    Fcrc: string;
    Fcrc_estado: string;
    FDataInicioAtividade: TDateTime;
    FValorReceitaBruta: Double;
  public
    constructor Create;
    destructor Destroy; override;

    property IdentificacaoPrestador: TIdentificacaoPrestador read FIdentificacaoPrestador write FIdentificacaoPrestador;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Contato: TContato read FContato write FContato;
    // Provedor ISSDigital
    property cUF: Integer read FcUF write FcUF;
    // Provedor SigISS
    property crc: string read Fcrc write Fcrc;
    property crc_estado: string read Fcrc_estado write Fcrc_estado;
    // Provedor WebFisco
    property ValorReceitaBruta: Double read FValorReceitaBruta write FValorReceitaBruta;
    property DataInicioAtividade: TDateTime read FDataInicioAtividade write FDataInicioAtividade;
  end;

  TIdentificacaoTomador = class(TObject)
  private
    FCpfCnpj: string;
    FInscricaoMunicipal: string;
    FInscricaoEstadual: string;
    FDocTomadorEstrangeiro: string;
    FTipo: TTipoPessoa;
  public
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property InscricaoEstadual: string read FInscricaoEstadual write FInscricaoEstadual;
    property DocTomadorEstrangeiro: string read FDocTomadorEstrangeiro write FDocTomadorEstrangeiro;
    property Tipo: TTipoPessoa read FTipo write FTipo;
  end;

  TDadosTomador = class(TObject)
  private
    FIdentificacaoTomador: TIdentificacaoTomador;

    FRazaoSocial: string;
    FNomeFantasia: string;

    FEndereco: TEndereco;
    FContato: TContato;

    FAtualizaTomador: TnfseSimNao;
    FTomadorExterior: TnfseSimNao;
    FNifTomador: string;
  public
    constructor Create;
    destructor Destroy; override;

    property IdentificacaoTomador: TIdentificacaoTomador read FIdentificacaoTomador write FIdentificacaoTomador;
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: string read FNomeFantasia write FNomeFantasia;
    property Endereco: TEndereco read FEndereco write FEndereco;
    property Contato: TContato read FContato write FContato;
    property AtualizaTomador: TnfseSimNao read FAtualizaTomador write FAtualizaTomador;
    property TomadorExterior: TnfseSimNao read FTomadorExterior write FTomadorExterior;
    property NifTomador: string read FNifTomador write FNifTomador;
  end;

  TIdentificacaoIntermediarioServico = class(TObject)
  private
    FRazaoSocial: string;
    FCpfCnpj: string;
    FInscricaoMunicipal: string;
    FIssRetido: TnfseSituacaoTributaria;
    FEMail: string;
  public
    property RazaoSocial: string read FRazaoSocial write FRazaoSocial;
    property CpfCnpj: string read FCpfCnpj write FCpfCnpj;
    property InscricaoMunicipal: string read FInscricaoMunicipal write FInscricaoMunicipal;
    property IssRetido: TnfseSituacaoTributaria read FIssRetido write FIssRetido;
    property EMail: string read FEMail write FEMail;
  end;

  TIdentificacaoOrgaoGerador = class(TObject)
  private
    FCodigoMunicipio: string;
    FUf: string;
  public
    property CodigoMunicipio: string read FCodigoMunicipio write FCodigoMunicipio;
    property Uf: string read FUf write FUf;
  end;

  TDadosConstrucaoCivil = class(TObject)
  private
    FCodigoObra: string;
    FArt: string;
    FLogradouroObra: string;
    FComplementoObra: string;
    FNumeroObra: string;
    FBairroObra: string;
    FCEPObra: string;
    FCodigoMunicipioObra: string;
    FUFObra: string;
    FCodigoPaisObra: Integer;
    FxPaisObra: string;
    FnCei: string;
    FnProj: string;
    FnMatri: string;
    FnNumeroEncapsulamento: string;
  public
    property CodigoObra: string read FCodigoObra write FCodigoObra;
    property Art: string read FArt write FArt;
    property LogradouroObra: string read FLogradouroObra write FLogradouroObra;
    property ComplementoObra: string read FComplementoObra write FComplementoObra;
    property NumeroObra: string read FNumeroObra write FNumeroObra;
    property BairroObra: string read FBairroObra write FBairroObra;
    property CEPObra: string read FCEPObra write FCEPObra;
    property CodigoMunicipioObra: string read FCodigoMunicipioObra write FCodigoMunicipioObra;
    property UFObra: string read FUFObra write FUFObra;
    property CodigoPaisObra: Integer read FCodigoPaisObra write FCodigoPaisObra;
    property xPaisObra: string read FxPaisObra write FxPaisObra;
    property nCei: string read FnCei write FnCei;
    property nProj: string read FnProj write FnProj;
    property nMatri: string read FnMatri write FnMatri;
    property nNumeroEncapsulamento: string read FnNumeroEncapsulamento write FnNumeroEncapsulamento;
  end;

  TParcelasCollectionItem = class(TObject)
  private
    FCondicao: TnfseCondicaoPagamento;
    FParcela: Integer;
    FDataVencimento: TDateTime;
    FValor: Double;
  public
    property Condicao: TnfseCondicaoPagamento read FCondicao write FCondicao;
    property Parcela: Integer read FParcela write FParcela;
    property DataVencimento: TDateTime read FDataVencimento write FDataVencimento;
    property Valor: Double read FValor write FValor;
  end;

  TParcelasCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TParcelasCollectionItem;
    procedure SetItem(Index: Integer; Const Value: TParcelasCollectionItem);
  public
    function Add: TParcelasCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TParcelasCollectionItem;
    property Items[Index: Integer]: TParcelasCollectionItem read GetItem write SetItem; default;
  end;

  TCondicaoPagamento = class(TObject)
  private
    FCondicao: TnfseCondicaoPagamento;
    FQtdParcela: Integer;
    FParcelas: TParcelasCollection;
    procedure SetParcelas(const Value: TParcelasCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property Condicao: TnfseCondicaoPagamento read FCondicao write FCondicao;
    property QtdParcela: Integer read FQtdParcela write FQtdParcela;
    property Parcelas: TParcelasCollection read FParcelas write SetParcelas;
 end;

  TemailCollectionItem = class(TObject)
  private
    FemailCC: string;
  public
    property emailCC: string read FemailCC write FemailCC;
  end;

  TemailCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TemailCollectionItem;
    procedure SetItem(Index: Integer; Value: TemailCollectionItem);
  public
    function Add: TemailCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TemailCollectionItem;
    property Items[Index: Integer]: TemailCollectionItem read GetItem write SetItem; default;
  end;

  TDadosTransportadora = class(TObject)
  private
    FxNomeTrans: string;
    FxCpfCnpjTrans: string;
    FxInscEstTrans: string;
    FxPlacaTrans: string;
    FxEndTrans: string;
    FcMunTrans: Integer;
    FxMunTrans: string;
    FxUFTrans: string;
    FcPaisTrans: Integer;
    FxPaisTrans: string;
    FvTipoFreteTrans: TnfseFrete;
  public
    property xNomeTrans: string read FxNomeTrans write FxNomeTrans;
    property xCpfCnpjTrans: string read FxCpfCnpjTrans write FxCpfCnpjTrans;
    property xInscEstTrans: string read FxInscEstTrans write FxInscEstTrans;
    property xPlacaTrans: string read FxPlacaTrans write FxPlacaTrans;
    property xEndTrans: string read FxEndTrans write FxEndTrans;
    property cMunTrans: Integer read FcMunTrans write FcMunTrans;
    property xMunTrans: string read FxMunTrans write FxMunTrans;
    property xUFTrans: string read FxUFTrans write FxUFTrans;
    property cPaisTrans: Integer read FcPaisTrans write FcPaisTrans;
    property xPaisTrans: string read FxPaisTrans write FxPaisTrans;
    property vTipoFreteTrans: TnfseFrete read FvTipoFreteTrans write FvTipoFreteTrans;
  end;

  TDespesaCollectionItem = class(TObject)
  private
    FnItemDesp: string;
    FxDesp: string;
    FdDesp: TDateTime;
    FvDesp: Double;
  public
    property nItemDesp: string read FnItemDesp write FnItemDesp;
    property xDesp: string read FxDesp write FxDesp;
    property dDesp: TDateTime read FdDesp write FdDesp;
    property vDesp: Double read FvDesp write FvDesp;
  end;

  TDespesaCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TDespesaCollectionItem;
    procedure SetItem(Index: Integer; Value: TDespesaCollectionItem);
  public
    function Add: TDespesaCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TDespesaCollectionItem;
    property Items[Index: Integer]: TDespesaCollectionItem read GetItem write SetItem;
  end;

  TAssinaComChaveParamsCollectionItem = class(TObject)
  private
    FParam: string;
    FConteudo: string;
  public
    property Param: string read FParam write FParam;
    property Conteudo: string read FConteudo write FConteudo;
  end;

  TAssinaComChaveParamsCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TAssinaComChaveParamsCollectionItem;
    procedure SetItem(Index: Integer; Const Value: TAssinaComChaveParamsCollectionItem);
  public
    function Add: TAssinaComChaveParamsCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TAssinaComChaveParamsCollectionItem;
    property Items[Index: Integer]: TAssinaComChaveParamsCollectionItem read GetItem write SetItem; default;
  end;

  TPedidoCancelamento = class(TObject)
  private
    FInfID: TInfID;
    FIdentificacaoNfse: TIdentificacaoNfse;
    FCodigoCancelamento: string;
  public
    constructor Create;
    destructor Destroy; override;

    property InfID: TInfID read FInfID write FInfID;
    property IdentificacaoNfse: TIdentificacaoNfse read FIdentificacaoNfse write FIdentificacaoNfse;
    property CodigoCancelamento: string read FCodigoCancelamento write FCodigoCancelamento;
  end;

  TConfirmacaoCancelamento = class(TObject)
  private
    FInfID: TInfID;
    FPedido: TPedidoCancelamento;
    FSucesso: Boolean;
    FDataHora: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;

    property InfID: TInfID read FInfID write FInfID;
    property Pedido: TPedidoCancelamento read FPedido write FPedido;
    property Sucesso: Boolean read FSucesso write FSucesso;
    property DataHora: TDateTime read FDataHora write FDataHora;
  end;

  TQuartoCollectionItem = class(TObject)
  private
    FCodigoInternoQuarto: Integer;
    FQtdHospedes: Integer;
    FCheckIn: TDateTime;
    FQtdDiarias: Integer;
    FValorDiaria: Double;
  public
    constructor Create;

    property CodigoInternoQuarto: Integer read FCodigoInternoQuarto write FCodigoInternoQuarto;
    property QtdHospedes: Integer read FQtdHospedes write FQtdHospedes;
    property CheckIn: TDateTime read FCheckIn write FCheckIn;
    property QtdDiarias: Integer read FQtdDiarias write FQtdDiarias;
    property ValorDiaria: Double read FValorDiaria write FValorDiaria;
  end;

  TQuartoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TQuartoCollectionItem;
    procedure SetItem(Index: Integer; Value: TQuartoCollectionItem);
  public
    function New: TQuartoCollectionItem;
    property Items[Index: Integer]: TQuartoCollectionItem read GetItem write SetItem; default;
  end;

  TNFSe = class(TPersistent)
  private
    // RPS e NFSe
    FSituacao: TSituacaoLoteRPS;

    FSituacaoNfse: TStatusNFSe;
    FNomeArq: string;
    FInfID: TInfID;
    FIdentificacaoRps: TIdentificacaoRps;
    FDataEmissao: TDateTime;
    FNaturezaOperacao: TnfseNaturezaOperacao;
    FRegimeEspecialTributacao: TnfseRegimeEspecialTributacao;
    FOptanteSimplesNacional: TnfseSimNao;
    FOptanteMEISimei: TnfseSimNao;
    // Provedor Conam
    FDataEmissaoRps: TDateTime;
    FDataOptanteSimplesNacional: TDateTime;
    FLogradouroLocalPrestacaoServico: TLogradouroLocalPrestacaoServico;
    FIncentivadorCultural: TnfseSimNao;
    FProducao: TnfseSimNao;
    FStatus: TStatusRps;
    FRpsSubstituido: TIdentificacaoRps;
    FSeriePrestacao: string;
    FServico: TDadosServico;
    FQuartos: TQuartoCollection;
    FPrestador: TDadosPrestador;
    FTomador: TDadosTomador;
    FIntermediarioServico: TIdentificacaoIntermediarioServico;
    FConstrucaoCivil: TDadosConstrucaoCivil;
    FDeducaoMateriais: TnfseSimNao;
    FCondicaoPagamento: TCondicaoPagamento;
    // NFSe
    FNumero: string;
    FCodigoVerificacao: string;
    FCompetencia: TDateTime;
    FNfseSubstituida: string;
    FOutrasInformacoes: string;
    FValorCredito: Double;
    FOrgaoGerador: TIdentificacaoOrgaoGerador;
    FValoresNfse: TValoresNfse;
    // Provedor EGoverneISS
    FAutenticador: string;
    FLink: string;

    // RPS e NFSe
    FDespesa: TDespesaCollection;

    FNumeroLote: string;
    FProtocolo: string;
    FdhRecebimento: TDateTime;

    FXML: string;

    FNfseCancelamento: TConfirmacaoCancelamento;
    FNfseSubstituidora: string;
    // Provedor ISSDSF
    FMotivoCancelamento: string;
    // Provedor Infisc
    FcNFSe: Integer;

    // Provedor Infisc Vers�o XML 1.1
    FTipoEmissao: TTipoEmissao;
    FEmpreitadaGlobal: TEmpreitadaGlobal;
    FModeloNFSe: string;
    FCancelada: TnfseSimNao;
    FTransportadora: TDadosTransportadora;
    FCanhoto: TnfseCanhoto;

    Femail: TemailCollection;
    FTipoRecolhimento: string;
    FRegRec: TRegRec;
    FFrmRec: TFrmRec;
    FTipoTributacaoRPS: TTipoTributacaoRPS;
    FAssinatura: string;
    FInformacoesComplementares: string;

    FAssinaComChaveParams: TAssinaComChaveParamsCollection;
    FPercentualCargaTributaria: Double;
    FValorCargaTributaria: Double;
    FPercentualCargaTributariaMunicipal: Double;
    FValorCargaTributariaMunicipal: Double;
    FPercentualCargaTributariaEstadual: Double;
    FValorCargaTributariaEstadual: Double;
    FTipoNota: Integer;
    FSiglaUF: string;
    FEspecieDocumento: Integer;
    FSerieTalonario: Integer;
    FFormaPagamento: Integer;
    FNumeroParcelas: Integer;
    Fid_sis_legado: Integer;
    FSituacaoTrib: TSituacaoTrib;
    FrefNF: string;

    procedure Setemail(const Value: TemailCollection);
    procedure SetInformacoesComplementares(const Value: string);
    procedure SetDespesa(const Value: TDespesaCollection);
    procedure SetAssinaComChaveParams(
      const Value: TAssinaComChaveParamsCollection);
  public
    constructor Create;
    destructor Destroy; override;
  published
    // RPS e NFSe
    property Situacao: TSituacaoLoteRPS read FSituacao write FSituacao;
    property SituacaoNfse: TStatusNFSe read FSituacaoNfse write FSituacaoNfse;
    property NomeArq: string read FNomeArq write FNomeArq;
    property InfID: TInfID read FInfID write FInfID;
    property IdentificacaoRps: TIdentificacaoRps read FIdentificacaoRps write FIdentificacaoRps;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property NaturezaOperacao: TnfseNaturezaOperacao read FNaturezaOperacao write FNaturezaOperacao;
    property RegimeEspecialTributacao: TnfseRegimeEspecialTributacao read FRegimeEspecialTributacao write FRegimeEspecialTributacao;
    property OptanteSimplesNacional: TnfseSimNao read FOptanteSimplesNacional write FOptanteSimplesNacional;
    property OptanteMEISimei: TnfseSimNao read FOptanteMEISimei write FOptanteMEISimei;
    //Provedor Conam
    property DataOptanteSimplesNacional: TDateTime read FDataOptanteSimplesNacional write FDataOptanteSimplesNacional;
    property LogradouLocalPrestacaoServico: TLogradouroLocalPrestacaoServico read FLogradouroLocalPrestacaoServico write FLogradouroLocalPrestacaoServico;
    property IncentivadorCultural: TnfseSimNao read FIncentivadorCultural write FIncentivadorCultural;
    property Producao: TnfseSimNao read FProducao write FProducao;
    property Status: TStatusRps read FStatus write FStatus;
    property RpsSubstituido: TIdentificacaoRps read FRpsSubstituido write FRpsSubstituido;
    property DataEmissaoRps: TDateTime read FDataEmissaoRps write FDataEmissaoRps;
    // Provedor IssDsf
    property SeriePrestacao: string read FSeriePrestacao write FSeriePrestacao;
    property Servico: TDadosServico read FServico write FServico;
    property Quartos: TQuartoCollection read FQuartos write FQuartos;
    property Prestador: TDadosPrestador read FPrestador write FPrestador;
    property Tomador: TDadosTomador read FTomador write FTomador;
    property IntermediarioServico: TIdentificacaoIntermediarioServico read FIntermediarioServico write FIntermediarioServico;
    property ConstrucaoCivil: TDadosConstrucaoCivil read FConstrucaoCivil write FConstrucaoCivil;
    property DeducaoMateriais: TnfseSimNao read FDeducaoMateriais write FDeducaoMateriais;
    property CondicaoPagamento: TCondicaoPagamento read FCondicaoPagamento write FCondicaoPagamento;
    // NFSe
    property Numero: string read FNumero write FNumero;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property Competencia: TDateTime read FCompetencia write FCompetencia;
    property NfseSubstituida: string read FNfseSubstituida write FNfseSubstituida;
    property OutrasInformacoes: string read FOutrasInformacoes write FOutrasInformacoes;
    property InformacoesComplementares: string read FInformacoesComplementares write SetInformacoesComplementares;
    property ValorCredito: Double read FValorCredito write FValorCredito;
    property OrgaoGerador: TIdentificacaoOrgaoGerador read FOrgaoGerador write FOrgaoGerador;
    property ValoresNfse: TValoresNfse read FValoresNfse write FValoresNfse;
    // Provedor EGoverneISS
    property Autenticador: string read FAutenticador write FAutenticador;
    property Link: string read FLink write FLink;
    property NumeroLote: string read FNumeroLote write FNumeroLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property dhRecebimento: TDateTime read FdhRecebimento write FdhRecebimento;
    property XML: string read FXML write FXML;
    property NfseCancelamento: TConfirmacaoCancelamento read FNfseCancelamento write FNfseCancelamento;
    property NfseSubstituidora: string read FNfseSubstituidora write FNfseSubstituidora;
    // Provedor ISSDSF
    property MotivoCancelamento: string read FMotivoCancelamento write FMotivoCancelamento;
    // Provedor Infisc
    property cNFSe: Integer read FcNFSe write FcNFSe;
    property refNF: string read FrefNF write FrefNF;
    // Provedor Infisc Vers�o XML 1.1
    property TipoEmissao: TTipoEmissao read FTipoEmissao write FTipoEmissao;
    property EmpreitadaGlobal: TEmpreitadaGlobal read FEmpreitadaGlobal write FEmpreitadaGlobal;
    property ModeloNFSe: string read FModeloNFSe write FModeloNFSe;
    property Cancelada: TnfseSimNao read FCancelada write FCancelada;
    property Canhoto: TnfseCanhoto read FCanhoto Write FCanhoto;
    property Transportadora: TDadosTransportadora read FTransportadora write FTransportadora;
    property Despesa: TDespesaCollection read FDespesa write SetDespesa;
    // Provedor Governa
    property TipoRecolhimento: string read FTipoRecolhimento write FTipoRecolhimento;

    property email: TemailCollection read Femail write Setemail;

    property TipoTributacaoRPS: TTipoTributacaoRPS read FTipoTributacaoRPS write FTipoTributacaoRPS;

    property AssinaComChaveParams: TAssinaComChaveParamsCollection read FAssinaComChaveParams write SetAssinaComChaveParams;

    // Provedor SP
    property Assinatura: string read FAssinatura write FAssinatura;
    // Provedor Governa
    property RegRec: TRegRec read FRegRec write FRegRec;
    property FrmRec: TFrmRec read FFrmRec write FFrmRec;
    // Provedor Techos
    property PercentualCargaTributaria: Double read FPercentualCargaTributaria write FPercentualCargaTributaria;
    property ValorCargaTributaria: Double read FValorCargaTributaria write FValorCargaTributaria;
    property PercentualCargaTributariaMunicipal: Double read FPercentualCargaTributariaMunicipal write FPercentualCargaTributariaMunicipal;
    property ValorCargaTributariaMunicipal: Double read FValorCargaTributariaMunicipal write FValorCargaTributariaMunicipal;
    property PercentualCargaTributariaEstadual: Double read FPercentualCargaTributariaEstadual write FPercentualCargaTributariaEstadual;
    property ValorCargaTributariaEstadual: Double read FValorCargaTributariaEstadual write FValorCargaTributariaEstadual;
    property TipoNota: Integer read FTipoNota write FTipoNota;
    property SiglaUF: string read FSiglaUF write FSiglaUF;
    property EspecieDocumento: Integer read FEspecieDocumento write FEspecieDocumento;
    property SerieTalonario: Integer read FSerieTalonario write FSerieTalonario;
    property FormaPagamento: Integer read FFormaPagamento write FFormaPagamento;
    property NumeroParcelas: Integer read FNumeroParcelas write FNumeroParcelas;
    // Provedor SigISS
    // C�digo da nota no sistema legado do contribuinte.
    property id_sis_legado: Integer read Fid_sis_legado write Fid_sis_legado;
    property SituacaoTrib: TSituacaoTrib read FSituacaoTrib write FSituacaoTrib;
  end;

  TSubstituicaoNfse = class(TObject)
  private
    FInfID: TInfID;
    FNfseSubstituidora: string;
  public
    constructor Create;
    destructor Destroy; override;

    property InfID: TInfID read FInfID write FInfID;
    property NfseSubstituidora: string read FNfseSubstituidora write FNfseSubstituidora;
  end;

// =============================================================================
// Classes utilizadas pelos retornos

  TChaveNFeRPS = class(TObject)
  private
    FInscricaoPrestador: string;
    FNumero: string;
    FCodigoVerificacao: string;
    FLink: string;
    FNumeroRPS: string;
    FSerieRPS: string;
  public
    property InscricaoPrestador: string read FInscricaoPrestador write FInscricaoPrestador;
    // NFS-e
    property Numero: string            read FNumero            write FNumero;
    property CodigoVerificacao: string read FCodigoVerificacao write FCodigoVerificacao;
    property Link: string              read FLink              write FLink;
    // RPS
    property SerieRPS: string  read FSerieRPS  write FSerieRPS;
    property NumeroRPS: string read FNumeroRPS write FNumeroRPS;
  end;

  TInformacoesLote = class(TObject)
  private
    FNumeroLote: string;
    FInscricaoPrestador: string;
    FCPFCNPJRemetente: string;
    FDataEnvioLote: TDateTime;
    FQtdNotasProcessadas: Integer;
    FTempoProcessamento: Integer;
    FValorTotalServico: Double;
    FNumeroRps: string;
    FNumeroNFSe: string;
    FCodVerificacao: string;
    FDescOcorrencia: string;
  public
    property NumeroLote: string           read FNumeroLote          write FNumeroLote;
    property InscricaoPrestador: string   read FInscricaoPrestador  write FInscricaoPrestador;
    property CPFCNPJRemetente: string     read FCPFCNPJRemetente    write FCPFCNPJRemetente;
    property DataEnvioLote: TDateTime     read FDataEnvioLote       write FDataEnvioLote;
    property QtdNotasProcessadas: Integer read FQtdNotasProcessadas write FQtdNotasProcessadas;
    property TempoProcessamento: Integer  read FTempoProcessamento  write FTempoProcessamento;
    property ValorTotalServico: Double    read FValorTotalServico   write FValorTotalServico;
    // Provedor Governa
    property NumeroRps: string      read FNumeroRps      write FNumeroRps;
    property NumeroNFSe: string     read FNumeroNFSe     write FNumeroNFSe;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property DescOcorrencia: string read FDescOcorrencia write FDescOcorrencia;
  end;

  TMsgRetornoIdentificacaoRps = class(TObject)
  private
    FNumero: string;
    FSerie: string;
    FTipo: TTipoRps;
  public
    property Numero: string read FNumero write FNumero;
    property Serie: string  read FSerie  write FSerie;
    property Tipo: TTipoRps read FTipo   write FTipo;
  end;

  TChaveNFeRPSCollectionItem = class(TObject)
  private
    FChaveNFeRPS: TChaveNFeRPS;
  public
    constructor Create;
    destructor Destroy; override;

    property ChaveNFeRPS: TChaveNFeRPS read FChaveNFeRPS write FChaveNFeRPS;
  end;

  TChaveNFeRPSCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TChaveNFeRPSCollectionItem;
    procedure SetItem(Index: Integer; Value: TChaveNFeRPSCollectionItem);
  public
    function Add: TChaveNFeRPSCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TChaveNFeRPSCollectionItem;
    property Items[Index: Integer]: TChaveNFeRPSCollectionItem read GetItem write SetItem; default;
  end;

  TMensagemRetornoItem = class(TObject)
  private
    // ABRASF vers�o 1 e 2
    FCodigo: string;
    FMensagem: string;
    FCorrecao: string;
    // ABRASF vers�o 2
    FIdentificacaoRps: TMsgRetornoIdentificacaoRps;

    // Provedor com layout proprio
    FChaveNFeRPS: TChaveNFeRPS;

//    FchvAcessoNFSe: string;
//    Fsit: string;

  public
    constructor Create;
    destructor Destroy; override;

    property Codigo: string   read FCodigo   write FCodigo;
    property Mensagem: string read FMensagem write FMensagem;
    property Correcao: string read FCorrecao write FCorrecao;

    property IdentificacaoRps: TMsgRetornoIdentificacaoRps read FIdentificacaoRps write FIdentificacaoRps;
    property ChaveNFeRPS: TChaveNFeRPS read FChaveNFeRPS write FChaveNFeRPS;
//    property chvAcessoNFSe: string read FchvAcessoNFSe write FchvAcessoNFSe;
//    property sit: string           read Fsit           write Fsit;
  end;

  TMensagemRetornoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TMensagemRetornoItem;
    procedure SetItem(Index: Integer; Value: TMensagemRetornoItem);
  public
    function Add: TMensagemRetornoItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TMensagemRetornoItem;
    property Items[Index: Integer]: TMensagemRetornoItem read GetItem write SetItem; default;
  end;

  TInfRetorno = class(TObject)
  private
    FXML: string;

    // Retorno do EnviarLoteRps
    FNumeroLote: string;
    FDataRecebimento: TDateTime;
    FProtocolo: string;
    // Retorno do Consultar Situacao do Lote
    FSituacao: TSituacaoLoteRPS;

    FSucesso: string;
    FHashIdent: string;

    FMsgRetorno: TMensagemRetornoCollection;
    FInformacoesLote: TInformacoesLote;
    FListaChaveNFeRPS: TChaveNFeRPSCollection;

    procedure SetMsgRetorno(Value: TMensagemRetornoCollection);
    procedure SetListaChaveNFeRPS(const Value: TChaveNFeRPSCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property XML: string read FXML write FXML;

    property NumeroLote: string         read FNumeroLote      write FNumeroLote;
    property DataRecebimento: TDateTime read FDataRecebimento write FDataRecebimento;
    property Protocolo: string          read FProtocolo       write FProtocolo;
    property Situacao: TSituacaoLoteRPS read FSituacao        write FSituacao;
    property Sucesso: string            read FSucesso         write FSucesso;
    property HashIdent: string          read FHashIdent       write FHashIdent;

    property MsgRetorno: TMensagemRetornoCollection read FMsgRetorno      write SetMsgRetorno;
    property InformacoesLote: TInformacoesLote      read FInformacoesLote write FInformacoesLote;

    property ListaChaveNFeRPS: TChaveNFeRPSCollection read FListaChaveNFeRPS write SetListaChaveNFeRPS;
  end;

const
  CMUN_EXTERIOR = 9999999;
  XMUN_EXTERIOR = 'EXTERIOR';
  UF_EXTERIOR = 'EX';

implementation

{ TDadosServicoRPS }

constructor TDadosServico.Create;
begin
  inherited Create;

  FValores := TValores.Create;

  with FValores do
  begin
    FValorServicos          := 0;
    FValorDeducoes          := 0;
    FValorPis               := 0;
    FValorCofins            := 0;
    FValorInss              := 0;
    FValorIr                := 0;
    FValorCsll              := 0;
    FIssRetido              := stNormal;
    FValorIss               := 0;
    FValorIssRetido         := 0;
    FOutrasRetencoes        := 0;
    FBaseCalculo            := 0;
    FAliquota               := 0;
    FValorLiquidoNfse       := 0;
    FDescontoIncondicionado := 0;
    FDescontoCondicionado   := 0;
    FValorDespesasNaoTributaveis := 0;
  end;

  FItemServico := TItemServicoCollection.Create;
  FDeducao     := TDeducaoCollection.Create;
  FDescricao   := '';
end;

destructor TDadosServico.Destroy;
begin
  FValores.Free;
  FItemServico.Free;
  FDeducao.Free;

  inherited Destroy;
end;

procedure TDadosServico.SetDeducao(const Value: TDeducaoCollection);
begin
  FDeducao := Value;
end;

procedure TDadosServico.SetItemServico(Value: TItemServicoCollection);
begin
  FItemServico.Assign(Value);
end;

{ TDadosPrestador }

constructor TDadosPrestador.Create;
begin
  inherited Create;

  FIdentificacaoPrestador := TIdentificacaoPrestador.Create;
  FEndereco               := TEndereco.Create;
  FContato                := TContato.Create;

  with FIdentificacaoPrestador do
  begin
    Cnpj               := '';
    InscricaoMunicipal := '';
    InscricaoEstadual  := '';
  end;
end;

destructor TDadosPrestador.Destroy;
begin
  FIdentificacaoPrestador.Free;
  FEndereco.Free;
  FContato.Free;

  inherited Destroy;
end;

{ TDadosTomador }

constructor TDadosTomador.Create;
begin
  inherited Create;

  FIdentificacaoTomador := TIdentificacaoTomador.Create;
  FEndereco             := TEndereco.Create;
  FContato              := TContato.Create;
end;

destructor TDadosTomador.Destroy;
begin
  FIdentificacaoTomador.Free;
  FEndereco.Free;
  FContato.Free;

  inherited Destroy;
end;

{ TNFSe }

constructor TNFSe.Create;
begin
  inherited Create;
  // RPS e NFSe
  FNomeArq                  := '';
  FInfID                    := TInfID.Create;
  FIdentificacaoRps         := TIdentificacaoRps.Create;
  FIdentificacaoRps.FTipo   := trRPS;
  FDataEmissao              := 0;
  FNaturezaOperacao         := no1;
  FRegimeEspecialTributacao := retNenhum;
  FOptanteSimplesNacional   := snNao;
  FOptanteMEISimei          := snNao;
  FIncentivadorCultural     := snNao;
  FStatus                   := srNormal;
  FRpsSubstituido           := TIdentificacaoRps.Create;
  FRpsSubstituido.FTipo     := trRPS;
  FServico                  := TDadosServico.Create;
  FPrestador                := TDadosPrestador.Create;
  FTomador                  := TDadosTomador.Create;
  FIntermediarioServico     := TIdentificacaoIntermediarioServico.Create;
  FConstrucaoCivil          := TDadosConstrucaoCivil.Create;
  FCondicaoPagamento        := TCondicaoPagamento.Create;
  FQuartos                  := TQuartoCollection.Create;
  // NFSe
  FNumero                    := '';
  FCodigoVerificacao         := '';
  FCompetencia               := 0;
  FNfseSubstituida           := '';
  FOutrasInformacoes         := '';
  FInformacoesComplementares := '';
  FValorCredito              := 0;
  FOrgaoGerador              := TIdentificacaoOrgaoGerador.Create;
  FValoresNfse               := TValoresNfse.Create;
  // RPS e NFSe
  FNfseCancelamento          := TConfirmacaoCancelamento.Create;
  FNfseCancelamento.DataHora := 0;
  FNfseSubstituidora         := '';

  // Provedor Infisc Vers�o XML 1.1
  FTipoEmissao      := teNormalNFSe;
  FEmpreitadaGlobal := EgOutros;
  FModeloNFSe       := '55';
  FCancelada        := snNao;
  FCanhoto          := tcNenhum;
  FTransportadora   := TDadosTransportadora.Create;

  FLogradouroLocalPrestacaoServico := llpTomador;

  Femail   := TemailCollection.Create;
  FDespesa := TDespesaCollection.Create;

  FAssinaComChaveParams := TAssinaComChaveParamsCollection.Create;
end;

destructor TNFSe.Destroy;
begin
  // RPS e NFSe
  FInfID.Free;
  FIdentificacaoRps.Free;
  FRpsSubstituido.Free;
  FServico.Free;
  FPrestador.Free;
  FTomador.Free;
  FIntermediarioServico.Free;
  FConstrucaoCivil.Free;
  FCondicaoPagamento.Free;
  FQuartos.Free;
  // NFSe
  FOrgaoGerador.Free;
  FValoresNfse.Free;
  // RPS e NFSe
  FNfseCancelamento.Free;
  Femail.Free;
  FDespesa.Free;
  FAssinaComChaveParams.Free;
  FTransportadora.Free;

  inherited Destroy;
end;

procedure TNFSe.SetInformacoesComplementares(const Value: string);
begin
  FInformacoesComplementares := Value;
end;

procedure TNFSe.Setemail(const Value: TemailCollection);
begin
  Femail := Value;
end;

procedure TNFSe.SetDespesa(const Value: TDespesaCollection);
begin
  FDespesa := Value;
end;

procedure TNFSe.SetAssinaComChaveParams(
  const Value: TAssinaComChaveParamsCollection);
begin
  FAssinaComChaveParams := Value;
end;

{ TPedidoCancelamento }

constructor TPedidoCancelamento.Create;
begin
  inherited Create;

  FInfID              := TInfID.Create;
  FIdentificacaoNfse  := TIdentificacaoNfse.Create;
  FCodigoCancelamento := '';
end;

destructor TPedidoCancelamento.Destroy;
begin
  FInfID.Free;
  FIdentificacaoNfse.Free;

  inherited Destroy;
end;

{ TConfirmacaoCancelamento }

constructor TConfirmacaoCancelamento.Create;
begin
  inherited Create;

  FInfID  := TInfID.Create;
  FPedido := TPedidoCancelamento.Create;
end;

destructor TConfirmacaoCancelamento.Destroy;
begin
  FInfID.Free;
  FPedido.Free;

  inherited Destroy;
end;

{ TSubstituicaoNfse }

constructor TSubstituicaoNfse.Create;
begin
  inherited Create;

  FInfID             := TInfID.Create;
  FNfseSubstituidora := '';
end;

destructor TSubstituicaoNfse.Destroy;
begin
  FInfID.Free;

  inherited Destroy;
end;

{ TItemServicoCollection }

function TItemServicoCollection.Add: TItemServicoCollectionItem;
begin
  Result := Self.New;
end;

function TItemServicoCollection.GetItem(Index: Integer): TItemServicoCollectionItem;
begin
  Result := TItemServicoCollectionItem(inherited Items[Index]);
end;

procedure TItemServicoCollection.SetItem(Index: Integer;
  Value: TItemServicoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TItemServicoCollection.New: TItemServicoCollectionItem;
begin
  Result := TItemServicoCollectionItem.Create;
  Self.Add(Result);
end;

{ TDeducaoCollection }
function TDeducaoCollection.Add: TDeducaoCollectionItem;
begin
  Result := Self.New;
end;

function TDeducaoCollection.GetItem(Index: Integer): TDeducaoCollectionItem;
begin
  Result := TDeducaoCollectionItem(inherited Items[Index]);
end;

procedure TDeducaoCollection.SetItem(Index: Integer;
  Value: TDeducaoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TDeducaoCollection.New: TDeducaoCollectionItem;
begin
  Result := TDeducaoCollectionItem.Create;
  Self.Add(Result);
end;

{ TItemServicoCollectionItem }

constructor TItemServicoCollectionItem.Create;
begin
  inherited Create;

  // Provedor Infisc Vers�o XML 1.1
  FCodServ := '';
  FUnidade := 'UN';
end;

{ TParcelasCollection }
function TParcelasCollection.Add: TParcelasCollectionItem;
begin
  Result := Self.New;
end;

function TParcelasCollection.GetItem(Index: Integer): TParcelasCollectionItem;
begin
  Result := TParcelasCollectionItem(inherited Items[Index]);
end;

procedure TParcelasCollection.SetItem(Index: Integer;
  const Value: TParcelasCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TParcelasCollection.New: TParcelasCollectionItem;
begin
  Result := TParcelasCollectionItem.Create;
  Self.Add(Result);
end;

{ TCondicaoPagamento }
constructor TCondicaoPagamento.Create;
begin
  inherited Create;

  FParcelas := TParcelasCollection.Create;
end;

destructor TCondicaoPagamento.Destroy;
begin
  FParcelas.Free;

  inherited Destroy;
end;

procedure TCondicaoPagamento.SetParcelas(const Value: TParcelasCollection);
begin
  FParcelas.Assign(Value);
end;

{ TemailCollection }

function TemailCollection.Add: TemailCollectionItem;
begin
  Result := Self.New;
end;

function TemailCollection.GetItem(Index: Integer): TemailCollectionItem;
begin
  Result := TemailCollectionItem(inherited Items[Index]);
end;

procedure TemailCollection.SetItem(Index: Integer;
  Value: TemailCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TemailCollection.New: TemailCollectionItem;
begin
  Result := TemailCollectionItem.Create;
  Self.Add(Result);
end;

{ TDespesaCollection }

function TDespesaCollection.Add: TDespesaCollectionItem;
begin
  Result := Self.New;
end;

function TDespesaCollection.GetItem(Index: Integer): TDespesaCollectionItem;
begin
  Result := TDespesaCollectionItem(inherited Items[Index]);
end;

procedure TDespesaCollection.SetItem(Index: Integer; Value: TDespesaCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TDespesaCollection.New: TDespesaCollectionItem;
begin
  Result := TDespesaCollectionItem.Create;
  Self.Add(Result);
end;

{ TAssinaComChaveParamsCollection }

function TAssinaComChaveParamsCollection.Add: TAssinaComChaveParamsCollectionItem;
begin
  Result := Self.New;
end;

function TAssinaComChaveParamsCollection.GetItem(
  Index: Integer): TAssinaComChaveParamsCollectionItem;
begin
  Result := TAssinaComChaveParamsCollectionItem(inherited Items[Index]);
end;

procedure TAssinaComChaveParamsCollection.SetItem(Index: Integer;
  const Value: TAssinaComChaveParamsCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TAssinaComChaveParamsCollection.New: TAssinaComChaveParamsCollectionItem;
begin
  Result := TAssinaComChaveParamsCollectionItem.Create;
  Self.Add(Result);
end;

{ TMensagemRetornoCollection }

function TMensagemRetornoCollection.Add: TMensagemRetornoItem;
begin
  Result := Self.New;
end;

function TMensagemRetornoCollection.GetItem(
  Index: Integer): TMensagemRetornoItem;
begin
  Result := TMensagemRetornoItem(inherited Items[Index]);
end;

function TMensagemRetornoCollection.New: TMensagemRetornoItem;
begin
  Result := TMensagemRetornoItem.Create;
  Self.Add(Result);
end;

procedure TMensagemRetornoCollection.SetItem(Index: Integer;
  Value: TMensagemRetornoItem);
begin
  inherited Items[Index] := Value;
end;

{ TChaveNFeRPSCollectionItem }

constructor TChaveNFeRPSCollectionItem.Create;
begin
  inherited Create;

  FChaveNFeRPS := TChaveNFeRPS.Create;
end;

destructor TChaveNFeRPSCollectionItem.Destroy;
begin
  FChaveNFeRPS.Free;

  inherited;
end;

{ TChaveNFeRPSCollection }

function TChaveNFeRPSCollection.Add: TChaveNFeRPSCollectionItem;
begin
  Result := Self.New;
end;

function TChaveNFeRPSCollection.GetItem(
  Index: Integer): TChaveNFeRPSCollectionItem;
begin
  Result := TChaveNFeRPSCollectionItem(inherited Items[Index]);
end;

function TChaveNFeRPSCollection.New: TChaveNFeRPSCollectionItem;
begin
  Result := TChaveNFeRPSCollectionItem.Create;
  Self.Add(Result);
end;

procedure TChaveNFeRPSCollection.SetItem(Index: Integer;
  Value: TChaveNFeRPSCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TMensagemRetornoItem }

constructor TMensagemRetornoItem.Create;
begin
  inherited Create;

  FIdentificacaoRps := TMsgRetornoIdentificacaoRps.Create;
  FChaveNFeRPS      := TChaveNFeRPS.Create;
end;

destructor TMensagemRetornoItem.Destroy;
begin
  FIdentificacaoRps.Free;
  FChaveNFeRPS.Free;

  inherited;
end;

{ TInfRetorno }

constructor TInfRetorno.Create;
begin
  inherited Create;

  FMsgRetorno       := TMensagemRetornoCollection.Create;
  FInformacoesLote  := TInformacoesLote.Create;
  FListaChaveNFeRPS := TChaveNFeRPSCollection.Create;
end;

destructor TInfRetorno.Destroy;
begin
  FMsgRetorno.Free;
  FInformacoesLote.Free;
  FListaChaveNFeRPS.Free;

  inherited;
end;

procedure TInfRetorno.SetListaChaveNFeRPS(const Value: TChaveNFeRPSCollection);
begin
  FListaChaveNFeRPS := Value;
end;

procedure TInfRetorno.SetMsgRetorno(Value: TMensagemRetornoCollection);
begin
  FMsgRetorno.Assign(Value);
end;

{ TQuartoCollection }

function TQuartoCollection.GetItem(Index: Integer): TQuartoCollectionItem;
begin
  Result := TQuartoCollectionItem(inherited Items[Index]);
end;

function TQuartoCollection.New: TQuartoCollectionItem;
begin
  Result := TQuartoCollectionItem.Create;
  Self.Add(Result);
end;

procedure TQuartoCollection.SetItem(Index: Integer; Value: TQuartoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TQuartoCollectionItem }

constructor TQuartoCollectionItem.Create;
begin
  inherited Create;
end;

end.
