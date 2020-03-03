{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliana Tamizou                                 }
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

unit ACBrSEF2_BlocoE;

interface

Uses
  Classes, SysUtils,
  ACBrSEF2Conversao;

type
  TRegistroSEFE003List = class;
  TRegistroSEFE020List = class;
  TRegistroSEFE025List = class;
  TRegistroSEFE050List = class;
  TRegistroSEFE055List = class;
  TRegistroSEFE060List = class;
  TRegistroSEFE065List = class;
  TRegistroSEFE080List = class;
  TRegistroSEFE085List = class;
  TRegistroSEFE100List = class;
  TRegistroSEFE105List = class;
  TRegistroSEFE120List = class;  
  TRegistroSEFE300List = class;
  TRegistroSEFE305List = class;
  TRegistroSEFE310List = class;
  TRegistroSEFE330List = class;
  TRegistroSEFE340List = class;
  TRegistroSEFE350List = class;
  TRegistroSEFE360List = class;
  TRegistroSEFE500List = class;
  TRegistroSEFE520List = class;
  TRegistroSEFE525List = class;
  TRegistroSEFE540List = class;
  TRegistroSEFE550List = class;
  TRegistroSEFE560List = class;
                 
 //LINHA E001: ABERTURA DO BLOCO E

  { TRegistroSEFE001 }

  TRegistroSEFE001 = class(TOpenBlocos)
  private
    fIND_DAD: TSEFIIIndConteudoDocumento;
    fRegistroE003: TRegistroSEFE003List;
    fRegistroE020: TRegistroSEFE020List;
    fRegistroE050: TRegistroSEFE050List;
    fRegistroE060: TRegistroSEFE060List;
    fRegistroE080: TRegistroSEFE080List;
    fRegistroE100: TRegistroSEFE100List;
    fRegistroE120: TRegistroSEFE120List;
    fRegistroE300: TRegistroSEFE300List;
    fRegistroE500: TRegistroSEFE500List;
  public
    constructor Create; virtual; /// Create
    destructor Destroy; override; /// Destroy
    property IND_DAD : TSEFIIIndConteudoDocumento read fIND_DAD write fIND_DAD;
    property RegistroE003: TRegistroSEFE003List read fRegistroE003 write fRegistroE003;
    property RegistroE020: TRegistroSEFE020List read fRegistroE020 write fRegistroE020;
    property RegistroE050: TRegistroSEFE050List read fRegistroE050 write fRegistroE050;
    property RegistroE060: TRegistroSEFE060List read fRegistroE060 write fRegistroE060;
    property RegistroE080: TRegistroSEFE080List read fRegistroE080 write fRegistroE080;
    property RegistroE100: TRegistroSEFE100List read fRegistroE100 write fRegistroE100;
    property RegistroE120: TRegistroSEFE120List read fRegistroE120 write fRegistroE120;
    property RegistroE300: TRegistroSEFE300List read fRegistroE300 write fRegistroE300;
    property RegistroE500: TRegistroSEFE500List read fRegistroE500 write fRegistroE500;
  end;

  TRegistroSEFE003 = class
  private
    fUF       : String;
    fLIN_MON  : String;
    fCAMPO_INI: Integer;
    fQTD_CAMPO: Integer;
  public
    constructor Create(AOwner: TRegistroSEFE001); virtual; /// Create
    property UF        : String  read	fUF        write fUF;        // Sigla da unidade da Federa��o do domic�lio fiscal do contribuinte	C	2	-
    property LIN_MON   : String  read	fLIN_MON   write fLIN_MON;   // Texto fixo contendo: "E025"; "E055"; "E065"; "E085"; "E310"; "E350"
    property CAMPO_INI : Integer read fCAMPO_INI write fCAMPO_INI; // Texto fixo contendo "16", para LIN_NOM = "E025"; "09", para LIN_NOM = "E055"; "10", para LIN_NOM = "E065"; "06", para LIN_NOM = "E085"; "11", para LIN_NOM = "E105"; "10", para LIN_NOM = "E310"; "10", para LIN_NOM = "E350"
    property QTD_CAMPO : Integer read	fQTD_CAMPO write fQTD_CAMPO; // Texto fixo contendo "2", para LIN_NOM = "E025"; "1", para LIN_NOM = "E055"; "1", para LIN_NOM = "E065"; "1", para LIN_NOM = "E085"; "1", para LIN_NOM = "E105"; "1", para LIN_NOM = "E310"; "1", para LIN_NOM = "E350"
  end;

  TRegistroSEFE003List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE003;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE003);
  public
    function New(AOwner: TRegistroSEFE001): TRegistroSEFE003;
    property Items[Index: Integer]: TRegistroSEFE003 read GetItem write SetItem;
  end;

 //LINHA E020: LAN�AMENTO - NOTA FISCAL (C�DIGO 01), NOTA FISCAL DE PRODUTOR (C�DIGO 04) E NOTA FISCAL ELETR�NICA (C�DIGO 55)
  TRegistroSEFE020 = class
  private
    fNUM_DOC     : Integer;
    fCOD_NAT     : String;
    fSER         : String;
    fCHV_NFE     : String;
    fNUM_LCTO    : String;
    fCOD_INF_OBS : String;
    fCOD_PART    : String;
    fDT_EMIS     : TDateTime;
    fDT_DOC      : TDateTime;
    fVL_CONT     : Double;
    fVL_OP_ISS   : Double;
    fVL_BC_ICMS  : Double;
    fVL_ICMS     : Double;
    fVL_ICMS_ST  : Double;
    fVL_ST_E     : Double;
    fVL_ST_S     : Double;
    fVL_AT       : Double;
    fVL_ISNT_ICMS: Double;
    fVL_OUT_ICMS : Double;
    fVL_BC_IPI   : Double;
    fVL_IPI      : Double;
    fVL_ISNT_IPI : Double;
    fVL_OUT_IPI  : Double;
    fIND_PGTO    : TIndicePagamento;
    fCOD_SIT     : TCodigoSituacao;
    fIND_OPER    : TIndiceOperacao;
    fIND_EMIT    : TIndiceEmissao;
    fCOD_MOD     : TSEFIIDocFiscalReferenciado;
    fRegistroE025: TRegistroSEFE025List;
    fCOP: String;
  public
    constructor Create(); virtual;
    destructor Destroy; override;

    property IND_OPER   : TIndiceOperacao  read	fIND_OPER write fIND_OPER;           //Indicador de opera��o: 0- Entrada ou aquisi��o1- Sa�da ou presta��o
    property IND_EMIT   : TIndiceEmissao   read	fIND_EMIT write fIND_EMIT;           // Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria 1- Emiss�o por terceiros
    property COD_MOD    : TSEFIIDocFiscalReferenciado read	fCOD_MOD write fCOD_MOD; // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property COD_SIT    : TCodigoSituacao  read	fCOD_SIT  write fCOD_SIT;            // C�digo da situa��o do lan�amento, conforme a tabela indicada no item 4.1.3
    property IND_PGTO   : TIndicePagamento read	fIND_PGTO write fIND_PGTO;           // Indicador do pagamento: 0- Opera��o � vista 1- Opera��o a prazo 2- Opera��o n�o onerosa
    property COD_PART   : String  read  fCOD_PART     write fCOD_PART;               // C�digo do participante (campo 02 da Linha 0150): - do emitente do documento ou do remetente das mercadorias, no caso de entradas - do adquirente, no caso de sa�das
    property COD_NAT    : String  read	fCOD_NAT      write fCOD_NAT;                // C�digo da natureza da opera��o ou presta��o (campo 02 da Linha 0400)
    property COP        : String  read  fCOP          write fCOP;                    // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property NUM_DOC    : Integer read	fNUM_DOC      write fNUM_DOC;                // N�mero do documento fiscal
    property SER        : String  read	fSER          write fSER;                    // S�rie do documento fiscal
    property CHV_NFE    : String  read	fCHV_NFE      write fCHV_NFE;                // Chave de acesso da Nota Fiscal Eletr�nica (NF-e, modelo 55)
    property NUM_LCTO   : String  read	fNUM_LCTO     write fNUM_LCTO;               // N�mero ou c�digo de identifica��o �nica do lan�amento cont�bil
    property COD_INF_OBS: String  read	fCOD_INF_OBS  write fCOD_INF_OBS;            // C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
    property DT_EMIS    : TDateTime read	fDT_EMIS    write fDT_EMIS;                // DATA DE EMISSAO
    property DT_DOC     : TDateTime read	fDT_DOC     write fDT_DOC;                 // Na entrada ou aquisi��o: data da entrada da mercadoria, da aquisi��o do servi�o ou do desembara�o aduaneiro; na sa�da ou presta��o: data da emiss�o do documento fiscal
    property VL_CONT    : Double  read	fVL_CONT      write fVL_CONT;                // Valor cont�bil (valor do documento)
    property VL_OP_ISS  : Double  read	fVL_OP_ISS    write fVL_OP_ISS;              // Valor da opera��o tributado pelo ISS
    property VL_BC_ICMS : Double  read	fVL_BC_ICMS   write fVL_BC_ICMS;             // Valor da base de c�lculo do ICMS
    property VL_ICMS    : Double  read	fVL_ICMS      write fVL_ICMS;                // Valor do ICMS creditado/debitado
    property VL_ICMS_ST : Double  read	fVL_ICMS_ST   write fVL_ICMS_ST;             // Valor original do ICMS da substitui��o tribut�ria registrado no documento
    property VL_ST_E    : Double  read	fVL_ST_E      write fVL_ST_E;                // Valor do ICMS da substitui��o tribut�ria creditado: - devido pelo alienante na opera��o de entrada, registrado em documento de emiss�o pr�pria - retido pelo alienante na opera��o de entrada, registrado em documento emitido por terceiro
    property VL_ST_S    : Double  read	fVL_ST_S      write fVL_ST_S;                // Valor do ICMS da substitui��o tribut�ria devido pelo alienante: - registrado na opera��o de sa�da interna - registrado na opera��o de sa�da interestadual
    property VL_AT       : Double read	fVL_AT        write fVL_AT;                  // Valor do ICMS creditado na opera��o de entrada: - relativamente � antecipa��o tribut�ria do diferencial de al�quotas na opera��o de aquisi��o de mercadorias - relativamente � antecipa��o tribut�ria do diferencial de al�quotas na opera��o de aquisi��o de material para ativo fixo - relativamente � antecipa��o tribut�ria do diferencial de al�quotas na opera��o de aquisi��o de material para uso ou consumo - relativamente � antecipa��o tribut�ria conforme defini��es da legisla��o espec�fica (descrever em observa��es)
    property VL_ISNT_ICMS: Double read	fVL_ISNT_ICMS write fVL_ISNT_ICMS;           // Valor das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_OUT_ICMS: Double  read	fVL_OUT_ICMS  write fVL_OUT_ICMS;            // Valor das outras opera��es do ICMS
    property VL_BC_IPI  : Double  read	fVL_BC_IPI    write fVL_BC_IPI;              // Valor da base de c�lculo do IPI
    property VL_IPI     : Double  read	fVL_IPI       write fVL_IPI;                 // Valor do IPI creditado/debitado
    property VL_ISNT_IPI: Double  read	fVL_ISNT_IPI  write fVL_ISNT_IPI;            // Valor das opera��es isentas ou n�o-tributadas pelo IPI
    property VL_OUT_IPI : Double  read	fVL_OUT_IPI   write fVL_OUT_IPI;             // Valor das outras opera��es do IPI

    property RegistroE025: TRegistroSEFE025List read fRegistroE025 write fRegistroE025;
  end;

  TRegistroSEFE020List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE020;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE020);
  public
    function New(): TRegistroSEFE020;
    property Itens[Index: Integer]: TRegistroSEFE020 read GetItem write SetItem;
  end;

  TRegistroSEFE025 = class
  private
    fVL_CONT_P     : Double;
    fVL_OP_ISS_P   : Double ;
    fVL_BC_ICMS_P  : Double;
    fALIQ_ICMS     : Double;
    fVL_ICMS_P     : Double;
    fVL_BC_ST_P    : Double;
    fVL_ICMS_ST_P  : Double;
    fVL_OUT_ICMS_P : Double;
    fVL_BC_IPI_P   : Double;
    fVL_IPI_P      : Double;
    fVL_ISNT_IPI_P : Double;
    fVL_OUT_IPI_P  : Double;
    fVL_ISNT_ICMS_P: Double;
    fCFOP          : String;
    fIND_PETR      : Integer;
    fIND_IMUN      : Integer;
  public
    constructor Create(AOwner: TRegistroSEFE020); virtual; /// Create
    property VL_CONT_P     : Double  read	fVL_CONT_P      write fVL_CONT_P;      // Valor (CFOP/Al�quota)
    property VL_OP_ISS_P   : Double  read	fVL_OP_ISS_P    write fVL_OP_ISS_P;    // Valor da opera��o tributado pelo ISS, rateado por CFOP e al�quota
    property VL_BC_ICMS_P  : Double  read	fVL_BC_ICMS_P   write fVL_BC_ICMS_P;   // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property ALIQ_ICMS     : Double  read	fALIQ_ICMS      write fALIQ_ICMS;      // Al�quota do ICMS
    property VL_ICMS_P     : Double  read	fVL_ICMS_P      write fVL_ICMS_P;      // Valor do ICMS consolidado por CFOP e al�quota
    property VL_BC_ST_P    : Double  read	fVL_BC_ST_P     write fVL_BC_ST_P;     // Valor da base de c�lculo do ICMS  da substitui��o tribut�ria consolidado por CFOP e al�quota
    property VL_ICMS_ST_P  : Double  read	fVL_ICMS_ST_P   write fVL_ICMS_ST_P;   // Valor das opera��es isentas ou n�o-tributadas pelo ICMS, rateado por CFOP e al�quota
    property VL_ISNT_ICMS_P: Double  read fVL_ISNT_ICMS_P write fVL_ISNT_ICMS_P;
    property VL_OUT_ICMS_P : Double  read	fVL_OUT_ICMS_P  write fVL_OUT_ICMS_P;  // Valor das outras opera��es do ICMS, rateado por CFOP e al�quota
    property VL_BC_IPI_P   : Double  read	fVL_BC_IPI_P    write fVL_BC_IPI_P;    // Valor da base de c�lculo do IPI, rateado por CFOP e al�quota
    property VL_IPI_P      : Double  read	fVL_IPI_P       write fVL_IPI_P;       // Valor do IPI, rateado por CFOP e al�quota
    property VL_ISNT_IPI_P : Double  read	fVL_ISNT_IPI_P  write fVL_ISNT_IPI_P;  // Valor das opera��es isentas ou n�o-tributadas pelo IPI, rateado por CFOP e al�quota
    property VL_OUT_IPI_P  : Double  read	fVL_OUT_IPI_P   write fVL_OUT_IPI_P;   // Valor das outras opera��es do IPI, rateado por CFOP e al�quota
    property CFOP          : String  read fCFOP           write fCFOP;           // C�digo Fiscal de Opera��es e Presta��es, conforme a tabela externa indicada no item 3.3.1
    property IND_PETR      : Integer read	fIND_PETR       write fIND_PETR;       // Indicador da opera��o: 0- Sem envolver combust�vel ou lubrificante 1- Envolvendo combust�vel ou lubrificante derivado de petr�leo 2- Envolvendo combust�vel ou lubrificante n�o-derivado de petr�leo
    property IND_IMUN      : Integer read	fIND_IMUN       write fIND_IMUN;       // Indicador da opera��o: 0- Sem envolver item imune do ICMS ou IPI  1- Envolvendo livro, jornal, peri�dico ou com o papel destinado � impress�o destes (imunes do ICMS e do IPI) 2- Envolvendo mineral (imune do IPI)
  end;

  TRegistroSEFE025List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE025;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE025);
  public
    function New(AOwner: TRegistroSEFE020): TRegistroSEFE025;
    property Itens[Index: Integer]: TRegistroSEFE025 read GetItem write SetItem;
  end;

  //  LINHA E050: LAN�AMENTO - NOTA FISCAL DE VENDA A CONSUMIDOR (C�DIGO 02)
  TRegistroSEFE050 = class
  private
    fCOD_MOD     : TSEFIIDocFiscalReferenciado;
    fSER         : String;
    fNUM_LCTO    : String;
    fCOD_INF_OBS : String;
    fCFOP        : String;
    fQTD_CANC    : Integer;
    fSUB         : Integer;
    fNUM_DOC_INI : Integer;
    fNUM_DOC_FIN : Integer;
    fVL_CONT     : Double;
    fVL_BC_ICMS  : Double;
    fVL_ICMS     : Double;
    fVL_ISNT_ICMS: Double;
    fVL_OUT_ICMS : Double;
    fDT_DOC      : TDateTime;
    fRegistroE055: TRegistroSEFE055List;
    fCOP: String;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property COD_MOD     : TSEFIIDocFiscalReferenciado  read fCOD_MOD      write fCOD_MOD;      // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property SER         : String	read fSER          write fSER;          // S�rie do documento fiscal
    property COD_INF_OBS : String  read fCOD_INF_OBS  write fCOD_INF_OBS;  // C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
    property NUM_LCTO    : String  read fNUM_LCTO     write fNUM_LCTO;     // N�mero ou c�digo de identifica��o �nica do lan�amento cont�bil
    property QTD_CANC    : Integer read fQTD_CANC     write fQTD_CANC;     // Quantidade de documentos cancelados
    property SUB         : Integer read fSUB          write fSUB;          // Subs�rie dos documentos fiscais
    property NUM_DOC_INI : Integer read fNUM_DOC_INI  write fNUM_DOC_INI;  // N�mero do primeiro documento fiscal emitido no dia
    property NUM_DOC_FIN : Integer read fNUM_DOC_FIN  write fNUM_DOC_FIN;  // N�mero do �ltimo documento fiscal emitido no dia
    property DT_DOC      : TDateTime read fDT_DOC     write fDT_DOC;       // Data da emiss�o dos documentos fiscais
    property CFOP        : String  read fCFOP         write fCFOP;         // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property COP         : String  read fCOP          write fCOP;          // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property VL_CONT     : Double  read fVL_CONT      write fVL_CONT;      // Valor cont�bil (valor dos documentos)
    property VL_BC_ICMS  : Double  read fVL_BC_ICMS   write fVL_BC_ICMS;   // Valor da base de c�lculo do ICMS
    property VL_ICMS     : Double  read fVL_ICMS      write fVL_ICMS;      // Valor do ICMS debitado
    property VL_ISNT_ICMS: Double  read fVL_ISNT_ICMS write fVL_ISNT_ICMS; // Valor das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_OUT_ICMS : Double  read fVL_OUT_ICMS  write fVL_OUT_ICMS;  // Valor das outras opera��es do ICMS

    property RegistroE055: TRegistroSEFE055List read FRegistroE055 write FRegistroE055;
  end;

  { TRegistroSEFE050List }

  TRegistroSEFE050List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE050;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE050);
  public
    function New(): TRegistroSEFE050;
    property Itens[Index: Integer]: TRegistroSEFE050 read GetItem write SetItem;
  end;


  //LINHA E055: DETALHE - VALORES PARCIAIS
  TRegistroSEFE055 = class
  private
    fVL_CONT_P     : Double;
    fVL_BC_ICMS_P  : Double;
    fALIQ_ICMS     : Double;
    fVL_ICMS_P     : Double;
    fVL_ISNT_ICMS_P: Double;
    fVL_OUT_ICMS_P : Double;
    fCFOP          : String;
    fIND_IMUN      : Integer;
  public
    property VL_CONT_P     : Double  read	FVL_CONT_P      write FVL_CONT_P;      // Valor cont�bil, rateado por CFOP e al�quota
    property VL_BC_ICMS_P  : Double  read FVL_BC_ICMS_P   write FVL_BC_ICMS_P;   // Valor da base de c�lculo do ICMS consolidado por CFOP e al�quota
    property ALIQ_ICMS     : Double  read	FALIQ_ICMS      write FALIQ_ICMS;      // Al�quota do ICMS
    property VL_ICMS_P     : Double  read	FVL_ICMS_P      write FVL_ICMS_P;      // Valor do ICMS referente ao CFOP e � al�quota
    property VL_ISNT_ICMS_P: Double  read	FVL_ISNT_ICMS_P write FVL_ISNT_ICMS_P; // Valor das opera��es isentas ou n�o-tributadas pelo ICMS, rateado por CFOP e al�quota
    property VL_OUT_ICMS_P : Double  read	FVL_OUT_ICMS_P  write FVL_OUT_ICMS_P;  // Valor das outras opera��es do ICMS, rateado por CFOP e al�quota
    property CFOP          : String  read	FCFOP           write FCFOP;           // C�digo Fiscal de Opera��es e Presta��es preponderante no dia, conforme a tabela externa indicada no item 3.3.1
    property IND_IMUN      : Integer read	FIND_IMUN       write FIND_IMUN;       // Indicador da opera��o: 0- Sem envolver item imune do ICMS ou IPI 1- Envolvendo livro, jornal, peri�dico ou com o papel destinado � impress�o destes (imunes do ICMS e do IPI) 2- Envolvendo mineral (imune do IPI)
  end;

  { TRegistroSEFE055List }

  TRegistroSEFE055List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE055;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE055);
  public
    function New(): TRegistroSEFE055;
    property Itens[Index: Integer]: TRegistroSEFE055 read GetItem write SetItem;
  end;

  //LINHA E060: LAN�AMENTO - REDU��O Z/ICMS
  TRegistroSEFE060 = class
  private
    fCOD_MOD     : TSEFIIDocFiscalReferenciado;
    fECF_FAB     : String;
    fCOD_INF_OBS : String;
    fECF_CX      : Integer;
    FCRO         : Integer;
    FCRZ         : Integer;
    FDT_DOC      : TDateTime;
    fNUM_DOC_INI : Integer;
    fNUM_DOC_FIN : Integer;
    fGT_INI      : Double;
    fGT_FIN      : Double;
    fVL_BRT      : Double;
    fVL_CANC_ICMS: Double;
    fVL_DESC_ICMS: Double;
    fVL_ACMO_ICMS: Double;
    fVL_OP_ISS   : Double;
    fVL_LIQ      : Double;
    fVL_BC_ICMS  : Double;
    fVL_ICMS     : Double;
    fVL_ISN      : Double;
    fVL_NT       : Double;
    fVL_ST       : Double;
    fRegistroE065: TRegistroSEFE065List;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property COD_MOD     : TSEFIIDocFiscalReferenciado read fCOD_MOD write fCOD_MOD;   //C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property COD_INF_OBS : String    read	fCOD_INF_OBS  write fCOD_INF_OBS;  // Observa��o
    property ECF_FAB     : String	  read  fECF_FAB      write fECF_FAB;      // N�mero de s�rie de fabrica��o do ECF
    property ECF_CX      : Integer   read	fECF_CX       write fECF_CX;       // N�mero do caixa (n�mero de ordem seq�encial do ECF)
    property CRO         : Integer   read	fCRO          write fCRO;          // Posi��o do Contador de Rein�cio de Opera��o
    property CRZ         : Integer   read	fCRZ          write fCRZ;          // Posi��o do Contador de Redu��o Z
    property DT_DOC      : TDateTime read	fDT_DOC       write fDT_DOC;       // Data das opera��es a que se refere a Redu��o Z
    property NUM_DOC_INI : Integer   read	fNUM_DOC_INI  write fNUM_DOC_INI;  // N�mero do primeiro cupom fiscal (CCF, CVC ou CBP) emitido no dia
    property NUM_DOC_FIN : Integer   read	fNUM_DOC_FIN  write fNUM_DOC_FIN;  // N�mero do �ltimo cupom fiscal (CCF, CVC ou CBP) emitido no dia
    property GT_INI      : Double    read	fGT_INI       write fGT_INI;       // Valor do Grande Total inicial
    property GT_FIN      : Double    read	fGT_FIN       write fGT_FIN;       // Valor do Grande Total final
    property VL_BRT      : Double    read	fVL_BRT       write fVL_BRT;       // Valor da venda bruta
    property VL_CANC_ICMS: Double    read	fVL_CANC_ICMS write fVL_CANC_ICMS; // Valor dos cancelamentos referentes ao ICMS
    property VL_DESC_ICMS: Double    read	fVL_DESC_ICMS write fVL_DESC_ICMS; // Valor dos descontos registrados nas opera��es sujeitas ao ICMS
    property VL_ACMO_ICMS: Double    read	fVL_ACMO_ICMS write fVL_ACMO_ICMS; // Valor dos acr�scimos referentes ao ICMS
    property VL_OP_ISS   : Double    read	fVL_OP_ISS    write fVL_OP_ISS;    // Valor das opera��es tributado pelo ISS
    property VL_LIQ      : Double    read	fVL_LIQ       write fVL_LIQ;       // Valor da venda l�quida
    property VL_BC_ICMS  : Double    read	fVL_BC_ICMS   write fVL_BC_ICMS;   // Valor da base de c�lculo do ICMS
    property VL_ICMS     : Double    read	fVL_ICMS      write fVL_ICMS;      // Valor do ICMS debitado
    property VL_ISN      : Double    read	fVL_ISN       write fVL_ISN;       // Valor das opera��es isentas
    property VL_NT       : Double    read	fVL_NT        write fVL_NT;        // Valor das opera��es n�o-tributadas pelo ICMS
    property VL_ST       : Double    read	fVL_ST        write fVL_ST;        // Valor das opera��es com mercadorias adquiridas com substitui��o tribut�ria do ICMS

    property RegistroE065: TRegistroSEFE065List read fRegistroE065 write fRegistroE065;
  end;


  TRegistroSEFE060List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE060;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE060);
  public
    function New(): TRegistroSEFE060;
    property notas[Index: Integer]: TRegistroSEFE060 read Getnotas write SetNotas;
  end;

  //LINHA E065: DETALHE - VALORES PARCIAIS
  TRegistroSEFE065 = class
  private
    fCFOP        : String;
    fIND_IMUN    : Integer;
    fVL_BC_ICMS_P: Double;
    fALIQ_ICMS   : Double;
    fVL_ICMS_P   : Double;
  public
    property CFOP        : String  read	fCFOP         write fCFOP;         // C�digo Fiscal de Opera��es e Presta��es preponderante no dia, conforme a tabela externa indicada no item 3.3.1
    property IND_IMUN    : Integer read	fIND_IMUN     write fIND_IMUN;     // Indicador da opera��o: 0- Sem envolver item imune do ICMS ou IPI 1- Envolvendo livro, jornal, peri�dico ou com o papel destinado � impress�o destes (imunes do ICMS e do IPI) 2- Envolvendo mineral (imune do IPI)
    property VL_BC_ICMS_P: Double	 read fVL_BC_ICMS_P write fVL_BC_ICMS_P; // Valor da base de c�lculo do ICMS consolidado por CFOP e al�quota
    property ALIQ_ICMS   : Double  read	fALIQ_ICMS    write fALIQ_ICMS;    // Al�quota do ICMS
    property VL_ICMS_P   : Double  read	fVL_ICMS_P    write fVL_ICMS_P;    // Valor do ICMS referente ao CFOP e � al�quota
  end;

  TRegistroSEFE065List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE065;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE065);
  public
    function New(): TRegistroSEFE065;
    property notas[Index: Integer]: TRegistroSEFE065 read Getnotas write SetNotas;
  end;

  //LINHA E080: LAN�AMENTO - MAPA-RESUMO DE ECF/ICMS
  TRegistroSEFE080 = class
  private
    fCOD_MOD     : TSEFIIDocFiscalReferenciado;
    fNUM_LCTO    : String;
    fCOP         : String;
    fIND_TOT     : Integer;
    fNUM_MR      : Integer;
    fIND_OBS     : Integer;
    fDT_DOC      : TDateTime;
    fVL_BRT      : Double;
    fVL_CANC_ICMS: Double;
    fVL_DESC_ICMS: Double;
    fVL_ACMO_ICMS: Double;
    fVL_OP_ISS   : Double;
    fVL_CONT     : Double;
    fVL_BC_ICMS  : Double;
    fVL_ICMS     : Double;
    fVL_ISNT_ICMS: Double;
    fVL_ST       : Double;
    fRegistroE085: TRegistroSEFE085List;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property COD_MOD     : TSEFIIDocFiscalReferenciado    read	FCOD_MOD      write FCOD_MOD;       // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property NUM_LCTO    : String    read	FNUM_LCTO     write FNUM_LCTO;      // Observa��o
    property IND_TOT     : Integer   read	FIND_TOT      write FIND_TOT;       // Indicador de totaliza��o: 0- Total do dia 1- Total do m�s
    property NUM_MR      : Integer	 read  FNUM_MR      write FNUM_MR;        // N�mero de ordem do mapa resumo, correspondente ao dia do m�s em que ocorreram as vendas (ou correspondente ao m�s em houve a totaliza��o)
    property COP         : string    read	FCOP          write FCOP;           // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property IND_OBS     : Integer   read	FIND_OBS      write FIND_OBS;       // Indicador de observa��es do Mapa-resumo ECF: 0- Lan�amento sem observa��o 1- Lan�amento com observa��o
    property DT_DOC      : TDateTime read	FDT_DOC       write FDT_DOC;        // Data do resumo das vendas por ECF
    property VL_BRT      : Double    read	FVL_BRT       write FVL_BRT;        // Valor da venda bruta
    property VL_CANC_ICMS: Double    read	FVL_CANC_ICMS write FVL_CANC_ICMS;  // Valor dos cancelamentos referentes ao ICMS
    property VL_DESC_ICMS: Double    read	FVL_DESC_ICMS write FVL_DESC_ICMS;  // Valor dos descontos registrados nas opera��es sujeitas ao ICMS
    property VL_ACMO_ICMS: Double    read	FVL_ACMO_ICMS write FVL_ACMO_ICMS;  // Valor dos acr�scimos referentes ao ICMS
    property VL_OP_ISS   : Double    read	FVL_OP_ISS    write FVL_OP_ISS;     // Valor das opera��es tributado pelo ISS
    property VL_CONT     : Double    read	FVL_CONT      write FVL_CONT;       // Valor da venda l�quida
    property VL_BC_ICMS  : Double    read	FVL_BC_ICMS   write FVL_BC_ICMS;    // Valor da base de c�lculo do ICMS
    property VL_ICMS     : Double    read	FVL_ICMS      write FVL_ICMS;       // Valor do ICMS debitado
    property VL_ISNT_ICMS: Double    read	FVL_ISNT_ICMS write FVL_ISNT_ICMS;  // Valor das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_ST       : Double    read	FVL_ST        write FVL_ST;         // Valor das opera��es com mercadorias adquiridas com substitui��o tribut�ria do ICMS

    property RegistroE085: TRegistroSEFE085List read FRegistroE085 write FRegistroE085;
  end;

  TRegistroSEFE080List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE080;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE080);
  public
    function New(): TRegistroSEFE080;
    property notas[Index: Integer]: TRegistroSEFE080 read Getnotas write SetNotas;
  end;

  TRegistroSEFE085 = class
  private
    fVL_CONT_P     : Double;
    fVL_OP_ISS_P   : Double;
    fVL_BC_ICMS_P  : Double;
    fALIQ_ICMS     : Double;
    fVL_ICMS_P     : Double;
    fVL_ISNT_ICMS_P: Double;
    fVL_ST_P       : Double;
    fIND_IMUN      : Integer;
    fCFOP          : Integer;
  public
    property VL_CONT_P     : Double  read	 FVL_CONT_P      write FVL_CONT_P;      // C�digo Fiscal de Opera��es e Presta��es preponderante no dia, conforme a tabela externa indicada no item 3.3.1
    property VL_OP_ISS_P   : Double	 read  FVL_OP_ISS_P    write FVL_OP_ISS_P;    // Parcela por CFOP e al�quota correspondente ao valor das opera��es tributado pelo ISS
    property VL_BC_ICMS_P  : Double  read	 FVL_BC_ICMS_P   write FVL_BC_ICMS_P;   // Valor do ICMS referente ao CFOP e � al�quota
    property ALIQ_ICMS     : Double  read	 FALIQ_ICMS      write FALIQ_ICMS;      // Al�quota do ICMS
    property VL_ICMS_P     : Double  read	 FVL_ICMS_P      write FVL_ICMS_P;      // Valor do ICMS referente ao CFOP e � al�quota
    property VL_ISNT_ICMS_P: Double  read	 FVL_ISNT_ICMS_P write FVL_ISNT_ICMS_P; // Valor do ICMS referente ao CFOP e � al�quota
    property VL_ST_P       : Double  read	 FVL_ST_P        write FVL_ST_P;        // Valor das opera��es com mercadorias adquiridas com substitui��o tribut�ria do ICMS, rateado por CFOP e al�quota
    property IND_IMUN      : Integer read	 FIND_IMUN       write FIND_IMUN;       // Indicador da opera��o: 0- Sem envolver item imune do ICMS ou IPI 1- Envolvendo livro, jornal, peri�dico ou com o papel destinado � impress�o destes (imunes do ICMS e do IPI) 2- Envolvendo mineral (imune do IPI)
    property CFOP          : Integer read	 FCFOP           write FCFOP;           // C�digo Fiscal de Opera��es e Presta��es preponderante, conforme a tabela externa indicada no item 3.3.1
  end;

  TRegistroSEFE085List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE085;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE085);
  public
    function New(): TRegistroSEFE085;
    property notas[Index: Integer]: TRegistroSEFE085 read Getnotas write SetNotas;
  end;

 //LINHA E100: LAN�AMENTO - NOTA FISCAL/CONTA DE ENERGIA EL�TRICA (C�DIGO 06), OU NOTA FISCAL (C�DIGO 01 OU C�DIGO 55) NAS OPERA��ES ISOLADAS, NOTA FISCAL DE SERVI�O DE COMUNICA��O (C�DIGO 21), NOTA FISCAL DE SERVI�O DE TELECOMUNICA��O (C�DIGO 22), NOTA FISCAL/CONTA DE FORNECIMENTO DE G�S (C�DIGO 28) E NOTA FISCAL/CONTA DE FORNECIMENTO D'�GUA (C�DIGO 29)
  TRegistroSEFE100 = class
  private
    fVL_CONT: Currency;
    fCOD_MUN_SERV: String;
    fCOD_SIT: TCodigoSituacao;
    fCOD_MOD: TSEFIIDocFiscalReferenciado;
    fCOD_PART: String;
    fVL_ICMS_ST: Currency;
    fCOP: String;
    fIND_OPER: TIndiceOperacao;
    fNUM_LCTO: String;
    fVL_ISNT_ICMS: Currency;
    fDT_EMIS: TDateTime;
    fVL_OUT_ICMS: Currency;
    fQTD_DOC: integer;
    fCOD_INF_OBS: String;
    fNUM_DOC: Integer;
    fCOD_CONS: integer;
    fQTD_CANC: integer;
    fVL_OP_ISS: Currency;
    fDT_DOC: TDateTime;
    fIND_EMIT: TIndiceEmissao;
    fVL_ICMS: Currency;
    fSUB: String;
    fSER: String;
    fVL_BC_ICMS: Currency;
    fRegistroE105: TRegistroSEFE105List;
  public
    constructor Create(); virtual;
    destructor Destroy; override;

    property IND_OPER     : TIndiceOperacao read	fIND_OPER     write fIND_OPER;           //Indicador de opera��o: 0- Entrada ou aquisi��o1- Sa�da ou presta��o
    property IND_EMIT     : TIndiceEmissao  read	fIND_EMIT     write fIND_EMIT;           // Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria 1- Emiss�o por terceiros
    property COD_PART     : String          read  fCOD_PART     write fCOD_PART;           // C�digo do participante (campo 02 da Linha 0150): - do emitente do documento ou do remetente das mercadorias, no caso de entradas - do adquirente, no caso de sa�das
    property COD_MUN_SERV : String          read  fCOD_MUN_SERV write fCOD_MUN_SERV;       // C�digo do munic�pio definido como local presta��o do servi�o, conforme a tabela externa indicada no item 3.3.1
    property COD_MOD      : TSEFIIDocFiscalReferenciado read	fCOD_MOD write fCOD_MOD;     // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property COD_SIT      : TCodigoSituacao read	fCOD_SIT      write fCOD_SIT;            // C�digo da situa��o do lan�amento, conforme a tabela indicada no item 4.1.3
    property QTD_CANC     : integer         read	fQTD_CANC     write fQTD_CANC;           // Quantidade de documentos sem repercuss�o fiscal, no caso de lan�amento consolidado
    property SER          : String          read	fSER          write fSER;                // S�rie do documento fiscal
    property SUB          : String          read	fSUB          write fSUB;                // Subs�rie do documento fiscal
    property COD_CONS     : integer         read  fCOD_CONS     write fCOD_CONS;           // C�digo da consolida��o por classe de consumo, conforme as tabelas 4.4.1.1, 4.4.2.1, 4.4.3.1 ou 4.4.4.1
    property NUM_DOC      : Integer         read	fNUM_DOC      write fNUM_DOC;            // N�mero do documento fiscal
    property QTD_DOC      : integer         read  fQTD_DOC      write fQTD_DOC;            // Quantidade de documentos com repercuss�o fiscal do lan�amento
    property DT_EMIS      : TDateTime       read	fDT_EMIS      write fDT_EMIS;            // DATA DE EMISSAO
    property DT_DOC       : TDateTime       read	fDT_DOC       write fDT_DOC;             // Na entrada ou aquisi��o: data da entrada da mercadoria, da aquisi��o do servi�o ou do desembara�o aduaneiro; na sa�da ou presta��o: data da emiss�o do documento fiscal
    property COP          : String          read  fCOP          write fCOP;                // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property NUM_LCTO     : String          read	fNUM_LCTO     write fNUM_LCTO;           // N�mero ou c�digo de identifica��o �nica do lan�amento cont�bil
    property VL_CONT      : Currency        read	fVL_CONT      write fVL_CONT;            // Valor cont�bil (valor do documento)
    property VL_OP_ISS    : Currency        read	fVL_OP_ISS    write fVL_OP_ISS;          // Valor da opera��o tributado pelo ISS
    property VL_BC_ICMS   : Currency        read	fVL_BC_ICMS   write fVL_BC_ICMS;         // Valor da base de c�lculo do ICMS
    property VL_ICMS      : Currency        read	fVL_ICMS      write fVL_ICMS;            // Valor do ICMS creditado/debitado
    property VL_ICMS_ST   : Currency        read	fVL_ICMS_ST   write fVL_ICMS_ST;         // Valor original do ICMS da substitui��o tribut�ria registrado no documento
    property VL_ISNT_ICMS : Currency        read	fVL_ISNT_ICMS write fVL_ISNT_ICMS;       // Valor das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_OUT_ICMS  : Currency        read	fVL_OUT_ICMS  write fVL_OUT_ICMS;        // Valor das outras opera��es do ICMS
    property COD_INF_OBS  : String          read	fCOD_INF_OBS  write fCOD_INF_OBS;        // C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)

    property RegistroE105: TRegistroSEFE105List read fRegistroE105 write fRegistroE105;
  end;

  TRegistroSEFE100List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE100;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE100);
  public
    function New(): TRegistroSEFE100;
    property Itens[Index: Integer]: TRegistroSEFE100 read GetItem write SetItem;
  end;

  TRegistroSEFE105 = class
  private
    fIND_PETR: Integer;
    fVL_OP_ISS_P: Double;
    fALIQ_ICMS: Double;
    fVL_ICMS_P: Double;
    fVL_BC_ICMS_P: Double;
    fVL_CONT_P: Double;
    fCFOP: String;
    fVL_ICMS_ST_P: Double;
    fVL_ISNT_ICMS_P: Double;
    fVL_OUT_ICMS_P: Double;
  public
    property VL_CONT_P     : Double  read	fVL_CONT_P      write fVL_CONT_P;      // Valor (CFOP/Al�quota)
    property VL_OP_ISS_P   : Double  read	fVL_OP_ISS_P    write fVL_OP_ISS_P;    // Valor da opera��o tributado pelo ISS, rateado por CFOP e al�quota
    property CFOP          : String  read fCFOP           write fCFOP;           // C�digo Fiscal de Opera��es e Presta��es, conforme a tabela externa indicada no item 3.3.1
    property VL_BC_ICMS_P  : Double  read	fVL_BC_ICMS_P   write fVL_BC_ICMS_P;   // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property ALIQ_ICMS     : Double  read	fALIQ_ICMS      write fALIQ_ICMS;      // Al�quota do ICMS
    property VL_ICMS_P     : Double  read	fVL_ICMS_P      write fVL_ICMS_P;      // Valor do ICMS consolidado por CFOP e al�quota
    property VL_ICMS_ST_P  : Double  read	fVL_ICMS_ST_P   write fVL_ICMS_ST_P;   // Valor das opera��es isentas ou n�o-tributadas pelo ICMS, rateado por CFOP e al�quota
    property VL_ISNT_ICMS_P: Double  read fVL_ISNT_ICMS_P write fVL_ISNT_ICMS_P; // Valor das opera��es isentas ou n�o tributadas pelo ICMS, rateado por CFOP e al�quota
    property VL_OUT_ICMS_P : Double  read	fVL_OUT_ICMS_P  write fVL_OUT_ICMS_P;  // Valor das outras opera��es do ICMS, rateado por CFOP e al�quota
    property IND_PETR      : Integer read	fIND_PETR       write fIND_PETR;       // Indicador da opera��o: 0- Sem envolver combust�vel ou lubrificante 1- Envolvendo combust�vel ou lubrificante derivado de petr�leo 2- Envolvendo combust�vel ou lubrificante n�o-derivado de petr�leo
  end;

  TRegistroSEFE105List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE105;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE105);
  public
    function New(): TRegistroSEFE105;
    property Itens[Index: Integer]: TRegistroSEFE105 read GetItem write SetItem;
  end;

  //Juliano Rosa 06/05/2014
  //LINHA E120: LAN�AMENTO - NOTA FISCAL DE SERVI�O DE TRANSPORTE (C�DIGO 07), CONHECIMENTOS DE TRANSPORTE RODOVI�RIO DE CARGAS (C�DIGO 08), AQUAVI�RIO DE CARGAS (C�DIGO 09), A�REO (C�DIGO 10), FERROVI�RIO DE CARGAS (C�DIGO 11), MULTIMODAL DE CARGAS (C�DIGO 26), ELETR�NICO (C�DIGO 57), NOTA FISCAL DE SERVI�O DE TRANSPORTE FERROVI�RIO (C�DIGO 27) E RESUMO DE MOVIMENTO DI�RIO (C�DIGO 18)
  TRegistroSEFE120 = class
  private
    fIND_OPER    : TIndiceOperacao;
    fIND_EMIT    : TIndiceEmissao;
    fCOD_PART    : String;
    fCOD_MUN_SERV: Integer;
    fCOD_MOD     : TSEFIIDocFiscalReferenciado;
    fCOD_SIT     : TCodigoSituacao;
    fSER         : String;
    fSUB         : integer;
    fNUM_DOC     : Integer;
    fCHV_CTE     : String;
    fDT_EMIS     : TDateTime;
    fDT_DOC      : TDateTime;
    fNUM_LCTO    : String;
    fIND_PGTO    : TIndicePagamento;
    fVL_CONT     : Double;
    fVL_BC_ICMS  : Double;
    fAL_ICMS     : Double;
    fVL_ICMS     : Double;
    fVL_ICMS_ST  : Double;
    fVL_ISNT_ICMS: Double;
    fVL_OUT_ICMS : Double;
    fCOD_INF_OBS : String;
    fCOP: String;
    fCFOP: integer;
  public
    constructor Create(AOwner: TRegistroSEFE001); virtual;
    destructor Destroy; override;

    property IND_OPER   : TIndiceOperacao  read	fIND_OPER write fIND_OPER;           //Indicador de opera��o: 0- Entrada ou aquisi��o1- Sa�da ou presta��o
    property IND_EMIT   : TIndiceEmissao   read	fIND_EMIT write fIND_EMIT;           // Indicador do emitente do documento fiscal: 0- Emiss�o pr�pria 1- Emiss�o por terceiros
    property COD_PART   : String  read  fCOD_PART     write fCOD_PART;               // C�digo do participante (campo 02 da Linha 0150): - do prestador do servi�o, no caso das aquisi��es - do tomador no caso das presta��es - filial, ag�ncia, esta��o, posto ou cong�nere (c�digo 18)
    property COD_MUN_SERV : Integer read	fCOD_MUN_SERV      write fCOD_MUN_SERV;   //C�digo do munic�pio definido como local presta��o do servi�o, conforme a tabela externa indicada no item 3.3.1
    property COD_MOD    : TSEFIIDocFiscalReferenciado read	fCOD_MOD write fCOD_MOD; // C�digo do modelo do documento fiscal, conforme a tabela indicada no item 4.1.1
    property COD_SIT    : TCodigoSituacao  read	fCOD_SIT  write fCOD_SIT;            // C�digo da situa��o do lan�amento, conforme a tabela indicada no item 4.1.3
    property SER        : String  read	fSER          write fSER;                    // S�rie do documento fiscal
    property SUB        : integer  read	fSUB          write fSUB;                    // Subs�rie do documento fiscal
    property NUM_DOC    : Integer read	fNUM_DOC      write fNUM_DOC;                // N�mero do documento fiscal
    property CHV_CTE    : String  read	fCHV_CTE      write fCHV_CTE;                // Chave de acesso do Conhecimento de Transporte Eletr�nico (CT-e, modelo 57)
    property DT_EMIS    : TDateTime read	fDT_EMIS    write fDT_EMIS;                // DATA DE EMISSAO
    property DT_DOC     : TDateTime read	fDT_DOC     write fDT_DOC;                 // Na entrada ou aquisi��o: data da entrada da mercadoria, da aquisi��o do servi�o ou do desembara�o aduaneiro; na sa�da ou presta��o: data da emiss�o do documento fiscal
    property NUM_LCTO   : String  read	fNUM_LCTO     write fNUM_LCTO;               // N�mero ou c�digo de identifica��o �nica do lan�amento cont�bil
    property IND_PGTO   : TIndicePagamento read	fIND_PGTO write fIND_PGTO;           // Indicador do pagamento: 0- Opera��o � vista 1- Opera��o a prazo 2- Opera��o n�o onerosa
    property VL_CONT    : Double  read	fVL_CONT      write fVL_CONT;                // Valor cont�bil (valor do documento)
    property CFOP       : integer read  fCFOP         write fCFOP;                   // C�digo Fiscal de Opera��es e Presta��es, conforme a tabela externa indicada no item 3.3.1
    property COP        : String  read  fCOP          write fCOP;                    // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property VL_BC_ICMS : Double  read	fVL_BC_ICMS   write fVL_BC_ICMS;             // Valor da base de c�lculo do ICMS
    property AL_ICMS    : Double  read	fAL_ICMS      write fAL_ICMS;                // Al�quota do ICMS
    property VL_ICMS    : Double  read	fVL_ICMS      write fVL_ICMS;                // Valor do ICMS creditado/debitado
    property VL_ICMS_ST : Double  read	fVL_ICMS_ST   write fVL_ICMS_ST;             // Valor original do ICMS da substitui��o tribut�ria registrado no documento
    property VL_ISNT_ICMS: Double read	fVL_ISNT_ICMS write fVL_ISNT_ICMS;           // Valor das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_OUT_ICMS: Double  read	fVL_OUT_ICMS  write fVL_OUT_ICMS;            // Valor das outras opera��es do ICMS
    property COD_INF_OBS: String  read	fCOD_INF_OBS  write fCOD_INF_OBS;            // C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
  end;

  TRegistroSEFE120List = class(TACBrSEFIIRegistros)
  private
    function GetItem(Index: Integer): TRegistroSEFE120;
    procedure SetItem(Index: Integer; const Value: TRegistroSEFE120);
  public
    function New(AOwner: TRegistroSEFE001): TRegistroSEFE120;
    property Itens[Index: Integer]: TRegistroSEFE120 read GetItem write SetItem;
  end;
  ///////////////////////// 


  //LINHA E300: APURA��O DO ICMS
  TRegistroSEFE300 = class
  private
    fDT_INI : TDateTime;
    fDT_FIN : TDateTime;
    fRegistroE305: TRegistroSEFE305List;
    fRegistroE310: TRegistroSEFE310List;
    fRegistroE330: TRegistroSEFE330List;
    fRegistroE340: TRegistroSEFE340List;
    fRegistroE350: TRegistroSEFE350List;
    fRegistroE360: TRegistroSEFE360List;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property DT_INI : TDateTime read	fDT_INI write fDT_INI;
    property DT_FIN : TDateTime read  fDT_FIN write fDT_FIN;
    property RegistroE305: TRegistroSEFE305List read fRegistroE305 write fRegistroE305;
    property RegistroE310: TRegistroSEFE310List read fRegistroE310 write fRegistroE310;
    property RegistroE330: TRegistroSEFE330List read fRegistroE330 write fRegistroE330;
    property RegistroE340: TRegistroSEFE340List read fRegistroE340 write fRegistroE340;
    property RegistroE350: TRegistroSEFE350List read fRegistroE350 write fRegistroE350;
    property RegistroE360: TRegistroSEFE360List read fRegistroE360 write fRegistroE360;

  end;

  TRegistroSEFE300List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE300;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE300);
  public
    function New(): TRegistroSEFE300;
    property notas[Index: Integer]: TRegistroSEFE300 read Getnotas write SetNotas;
  end;


  TRegistroSEFE305 = class
  private
    fIND_MRO     : Integer;
    fIND_OPER    : Integer;
    fDT_DOC      : TDateTime;
    fQTD_LCTO    : Integer;
    fCOP         : String;
    fNUM_LCTO    : String;
    fVL_CONT     : Double;
    fVL_OP_ISS   : Double;
    fVL_BC_ICMS  : Double;
    fVL_ICMS     : Double;
    fVL_ICMS_ST  : Double;
    fVL_ST_ENT   : Double;
    fVL_ST_FNT   : Double;
    fVL_ST_UF    : Double;
    fVL_ST_OE    : Double;
    fVL_AT       : Double;
    fVL_ISNT_ICMS: Double;
    fVL_OUT_ICMS : Double;
    fVL_BC_IPI   : Double;
    fVL_IPI      : Double;
    fVL_ISNT_IPI : Double;
    fVL_OUT_IPI  : Double;
  public
    property IND_MRO     : Integer read	fIND_MRO      write fIND_MRO;      // Indicador do resumo: 0- Total di�rio por COP 1- Total por COP  2- Total di�rio
    property IND_OPER    : Integer read	fIND_OPER     write fIND_OPER;     // Indicador de opera��o: 0- Entrada ou aquisi��o 1- Sa�da ou presta��o
    property DT_DOC      : TDateTime read fDT_DOC       write fDT_DOC;       // Data dos documentos
    property QTD_LCTO    : Integer read	fQTD_LCTO     write fQTD_LCTO;     // Quantidade de lan�amentos com repercuss�o por tipo de resumo
    property COP         : String  read	fCOP          write fCOP;          // C�digo da classe da opera��o ou presta��o, conforme a tabela indicada no item 4.2.2.1
    property NUM_LCTO    : String  read	fNUM_LCTO     write fNUM_LCTO;     // N�mero ou c�digo de identifica��o �nica do lan�amento cont�bil
    property VL_CONT     : Double  read	fVL_CONT      write fVL_CONT;      // Valor da venda l�quida
    property VL_OP_ISS   : Double  read	fVL_OP_ISS    write fVL_OP_ISS;    // Valor das opera��es tributado pelo ISS
    property VL_BC_ICMS  : Double  read	fVL_BC_ICMS   write fVL_BC_ICMS;   // Valor da base de c�lculo do ICMS
    property VL_ICMS     : Double  read	fVL_ICMS      write fVL_ICMS;      // Valor do ICMS creditado/debitado
    property VL_ICMS_ST  : Double  read	fVL_ICMS_ST   write fVL_ICMS_ST;  // Valor total do ICMS da substitui��o tribut�ria original registrado nos documentos
    property VL_ST_ENT   : Double  read	fVL_ST_ENT    write fVL_ST_ENT;    // Valor total do ICMS da substitui��o tribut�ria pelas entradas, creditado e devido pelo alienante nas opera��es de entrada, registrado em documentos de emiss�o pr�pria
    property VL_ST_FNT   : Double  read	fVL_ST_FNT    write fVL_ST_FNT;    // Valor total do ICMS da substitui��o tribut�ria devido pelo alienante, registrado nas opera��es de sa�das internas
    property VL_ST_UF    : Double  read	fVL_ST_UF     write fVL_ST_UF;     // Valor total do ICMS da substitui��o tribut�ria devido pelo alienante, registrado nas opera��es de sa�das internas
    property VL_ST_OE    : Double  read	fVL_ST_OE     write fVL_ST_OE;     // Valor total do ICMS da substitui��o tribut�ria devido pelo alienante, registrado nas opera��es de sa�das interestaduais
    property VL_AT       : Double  read	fVL_AT        write fVL_AT;        // Valor total do ICMS da antecipa��o tribut�ria creditado
    property VL_ISNT_ICMS: Double  read	fVL_ISNT_ICMS write fVL_ISNT_ICMS; // Valor total das opera��es isentas ou n�o-tributadas pelo ICMS
    property VL_OUT_ICMS : Double  read	fVL_OUT_ICMS  write fVL_OUT_ICMS;  // Valor total das outras opera��es do ICMS
    property VL_BC_IPI   : Double  read	fVL_BC_IPI    write fVL_BC_IPI;    // Valor total da base de c�lculo do IPI
    property VL_IPI      : Double  read	fVL_IPI       write fVL_IPI;       // Valor total do IPI creditado/debitado
    property VL_ISNT_IPI : Double  read	fVL_ISNT_IPI  write fVL_ISNT_IPI;  // Valor total das opera��es isentas ou n�o-tributadas pelo IPI
    property VL_OUT_IPI  : Double  read	fVL_OUT_IPI   write fVL_OUT_IPI ;  // Valor total das outras opera��es do IPI
  end;

  TRegistroSEFE305List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE305;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE305);
  public
    function New(): TRegistroSEFE305;
    property notas[Index: Integer]: TRegistroSEFE305 read Getnotas write SetNotas;
  end;

   //LINHA E310: CONSOLIDA��O PR CFOP DOS VALORES DO ICMS

  TRegistroSEFE310 = class
  private
    fVL_CONT : Double;
    fVL_OP_ISS : Double;
    fCFOP : Integer;
    fVL_BC_ICMS: Double;
    fVL_ICMS : Double;
    fVL_ICMS_ST : Double;
    fVL_ISNT_ICMS : Double;
    fVL_OUT_ICMS : Double;
    fIND_IMUN : Integer;
  public
    property VL_CONT      : Double    read fVL_CONT      write fVL_CONT;       // Valor cont�bil, consolidado por CFOP
    property VL_OP_ISS    : Double    read fVL_OP_ISS    write fVL_OP_ISS;     // Valor das opera��es tributado pelo ISS, consolidado por CFOP
    property CFOP         : Integer   read fCFOP         write fCFOP;          // C�digo Fiscal de Opera��es e Presta��es, conforme a tabela externa indicada no item 3.3.1
    property VL_BC_ICMS   : Double    read fVL_BC_ICMS   write fVL_BC_ICMS;    // Valor da base de c�lculo do ICMS, consolidado por CFOP
    property VL_ICMS      : Double    read fVL_ICMS      write fVL_ICMS;       // Valor do ICMS creditado/debitado, consolidado por CFOP
    property VL_ICMS_ST   : Double    read fVL_ICMS_ST   write fVL_ICMS_ST;    // Valor do ICMS da substitui��o tribut�ria, consolidado por CFOP
    property VL_ISNT_ICMS : Double    read fVL_ISNT_ICMS write fVL_ISNT_ICMS;  // Valor das opera��es isentas ou n�o tributadas pelo ICMS, consolidado por CFOP
    property VL_OUT_ICMS  : Double    read fVL_OUT_ICMS  write fVL_OUT_ICMS;   // Valor das outras opera��es do ICMS, consolidado por CFOP
    property IND_IMUN     : Integer   read fIND_IMUN     write fIND_IMUN;      // Indicador da opera��o: 0- Sem envolver item imune do ICMS ou IPI 1- Envolvendo livro, jornal, peri�dico ou com o papel destinado � impress�o destes (imunes do ICMS e do IPI) 2- Envolvendo mineral (imune do IPI)
  end;

  // Registro E310 - Lista
  TRegistroSEFE310List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE310;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE310);
  public
    function New(): TRegistroSEFE310;
    property notas[Index: Integer]: TRegistroSEFE310 read Getnotas write SetNotas;
  end;

   //LINHA E330: TOTALIZA��O DAS OPERA��ES DO ICMS

  TRegistroSEFE330 = class
  private
    fIND_TOT : integer;
    fVL_CONT : Double;
    fVL_OP_ISS : Double;
    fVL_BC_ICMS : Double;
    fVL_ICMS : Double;
    fVL_ICMS_ST : Double;
    fVL_ST_ENT : Double;
    fVL_ST_FNT : Double;
    fVL_ST_UF  : Double;
    fVL_ST_OE  : Double;
    fVL_AT : Double;
    fVL_ISNT_ICMS : Double;
    fVL_OUT_ICMS : Double;
    public
      property IND_TOT        : integer read fIND_TOT       write fIND_TOT;       // Indicador de totaliza��o: 1- Entradas internas, 2- Entradas interestaduais, 3- Entradas do exterior, 4- Entradas do per�odo (1 + 2 + 3), 5- Sa�das internas, 6- Sa�das interestaduais, 7- Sa�das para o exterior, 8- Sa�das do per�odo (5 + 6 + 7)
      property VL_CONT        : Double  read fVL_CONT       write fVL_CONT;       // Valor cont�bil
      property VL_OP_ISS      : Double  read fVL_OP_ISS     write fVL_OP_ISS;     // Valor das opera��es tributado pelo ISS
      property VL_BC_ICMS     : Double  read fVL_BC_ICMS    write fVL_BC_ICMS;    // Valor da base de c�lculo do ICMS
      property VL_ICMS        : Double  read fVL_ICMS       write fVL_ICMS;       // Valor do ICMS creditado/debitado
      property VL_ICMS_ST     : Double  read fVL_ICMS_ST    write fVL_ICMS_ST;    // Valor total do ICMS da substitui��o tribut�ria original registrado nos documentos
      property VL_ST_ENT      : Double  read fVL_ST_ENT     write fVL_ST_ENT;     // Valor  total  do  ICMS  da  substitui��o  tribut�ria  pelas  entradas, creditado e devido pelo alienante nas opera��es de entrada, regis-trado em documentos de emiss�o pr�pria
      property VL_ST_FNT      : Double  read fVL_ST_FNT     write fVL_ST_FNT;     // Valor  total  do  ICMS  da  substitui��o  tribut�ria  retido  na  fonte, creditado  nas  opera��es  de  entrada,  registrado  em  documentos emitidos por terceiros
      property VL_ST_UF       : Double  read fVL_ST_UF      write fVL_ST_UF;      // Valor  total  do  ICMS  da  substitui��o  tribut�ria  devido  pelo  alie-nante, registrado nas opera��es de sa�das internas
      property VL_ST_OE       : Double  read fVL_ST_OE      write fVL_ST_OE;      // Valor  total  do  ICMS  da  substitui��o  tribut�ria  devido  pelo  alie-nante, registrado nas opera��es de sa�das interestaduais
      property VL_AT          : Double  read fVL_AT         write fVL_AT;         // Valor total do ICMS da antecipa��o tribut�ria creditado
      property VL_ISNT_ICMS   : Double  read fVL_ISNT_ICMS  write fVL_ISNT_ICMS;  // Valor das opera��es isentas ou n�o tributadas pelo ICMS
      property VL_OUT_ICMS    : Double  read fVL_OUT_ICMS   write fVL_OUT_ICMS;   // Valor das outras opera��es do ICMS
    end;

  // Registro E330 - Lista
  TRegistroSEFE330List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE330;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE330);
  public
    function New(): TRegistroSEFE330;
    property notas[Index: Integer]: TRegistroSEFE330 read Getnotas write SetNotas;
  end;

     //LINHA E340:  SALDOS DA APURA��O DO ICMS

  TRegistroSEFE340 = class
  private
    fVL_01 : Double;
    fVL_02 : Double;
    fVL_03 : Double;
    fVL_04 : Double;
    fVL_05 : Double;
    fVL_06 : Double;
    fVL_07 : Double;
    fVL_08 : Double;
    fVL_09 : Double;
    fVL_10 : Double;
    fVL_11 : Double;
    fVL_12 : Double;
    fVL_13 : Double;
    fVL_14 : Double;
    fVL_15 : Double;
    fVL_16 : Double;
    fVL_17 : Double;
    fVL_18 : Double;
    fVL_19 : Double;
    fVL_20 : Double;
    fVL_21 : Double;
    fVL_22 : Double;
    fVL_99 : Double;
  public
    property VL_01  : Double  read fVL_01 write fVL_01;    //  01- Valor do cr�dito do ICMS das entradas e aquisi��es
    property VL_02  : Double  read fVL_02 write fVL_02;    //  02- Valor do cr�dito do ICMS da substitui��o tribut�ria pelas en-tradas
    property VL_03  : Double  read fVL_03 write fVL_03;    //  03- Valor do cr�dito do ICMS da substitui��o tribut�ria na fonte
    property VL_04  : Double  read fVL_04 write fVL_04;    //  04-  Valor  do  cr�dito  do  ICMS  da  antecipa��o  tribut�ria  nas  en-tradas
    property VL_05  : Double  read fVL_05 write fVL_05;    //  05- Valor dos outros cr�ditos
    property VL_06  : Double  read fVL_06 write fVL_06;    //  06- Valor dos estornos de d�bito
    property VL_07  : Double  read fVL_07 write fVL_07;    //  07- Valor do saldo credor do per�odo anterior
    property VL_08  : Double  read fVL_08 write fVL_08;    //  08- Valor total dos cr�ditos (01 + 02 + 03 + 04 + 05 + 06 + 07)
    property VL_09  : Double  read fVL_09 write fVL_09;    //  09- Valor do d�bito do ICMS das sa�das e presta��es
    property VL_10  : Double  read fVL_10 write fVL_10;    //  10- Valor dos outros d�bitos
    property VL_11  : Double  read fVL_11 write fVL_11;    //  11- Valor dos estornos de cr�dito
    property VL_12  : Double  read fVL_12 write fVL_12;    //  12- Valor total dos d�bitos (09 + 10 + 11)
    property VL_13  : Double  read fVL_13 write fVL_13;    //  13-  Valor  do  saldo  credor  a  transportar  para  o  per�odo  seguinte(08 � 12)
    property VL_14  : Double  read fVL_14 write fVL_14;    //  14- Valor do saldo devedor (12 � 08)
    property VL_15  : Double  read fVL_15 write fVL_15;    //  15- Valor das dedu��es
    property VL_16  : Double  read fVL_16 write fVL_16;    //  16- Valor do ICMS normal a recolher (14 � 15)
    property VL_17  : Double  read fVL_17 write fVL_17;    //  17- Valor do ICMS da substitui��o tribut�ria pelas entradas
    property VL_18  : Double  read fVL_18 write fVL_18;    //  18- Valor do ICMS da antecipa��o tribut�ria nas entradas
    property VL_19  : Double  read fVL_19 write fVL_19;    //  19- Valor do ICMS da substitui��o tribut�ria nas sa�das para o  Estado
    property VL_20  : Double  read fVL_20 write fVL_20;    //  20- Valor do ICMS da importa��o
    property VL_21  : Double  read fVL_21 write fVL_21;    //  21- Valor das outras obriga��es a recolher para o Estado
    property VL_22  : Double  read fVL_22 write fVL_22;    //  22- Valor total das obriga��es a recolher para o Estado (16 + 17 + 18 + 19 + 20 + 21)
    property VL_99  : Double  read fVL_99 write fVL_99;    //  99- Valor total do ICMS da substitui��o tribut�ria nas sa�das para outros estados
  end;

  { TRegistroSEFE340List }

  TRegistroSEFE340List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE340;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE340);
  public
    function New(): TRegistroSEFE340;
    property notas[Index: Integer]: TRegistroSEFE340 read Getnotas write SetNotas;
  end;

  //LINHA E350: AJUSTES DA APURA��O DO ICMS

  TRegistroSEFE350 = class
  private
    fUF_AJ : String;
    fCOD_AJ : Integer;
    fVL_AJ : Double;
    fNUM_DA : String;
    fNUM_PROC : String;
    fIND_PROC : String;
    fDESC_PROC : String;
    fCOD_INF_OBS : String;
    fIND_AP : String;
  public
    property UF_AJ        : String   read fUF_AJ        write fUF_AJ;         //  Sigla da unidade da Federa��o a que se refere o ajuste
    property COD_AJ       : Integer  read fCOD_AJ       write fCOD_AJ;        //  C�digo do ajuste da apura��o do ICMS, conforme a tabela indi-cada no item 5.2.1
    property VL_AJ        : Double   read fVL_AJ        write fVL_AJ;         //  Valor do ajuste da apura��o
    property NUM_DA       : String   read fNUM_DA       write fNUM_DA;        //  N�mero do documento de arrecada��o estadual, se houver
    property NUM_PROC     : String   read fNUM_PROC     write fNUM_PROC;      //  N�mero do processo vinculado ao ajuste, se houver
    property IND_PROC     : String   read fIND_PROC     write fIND_PROC;      //  Indicador da origem do processo: 0- Administra��o estadual 1- Justi�a Federal 2- Justi�a Estadual 9- Outros
    property DESC_PROC    : String   read fDESC_PROC    write fDESC_PROC;     //  Descri��o do processo que embasou o lan�amento
    property COD_INF_OBS  : String   read fCOD_INF_OBS  write fCOD_INF_OBS;   //  C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
    property IND_AP       : string  read fIND_AP       write fIND_AP;        //  Indicador da sub-apura��o do Prodepe: 1- item n�o incentivado (sub-apura��o 1) 2- item incentivado (sub-apura��o 2) 3- item incentivado (sub-apura��o 3) ... _9- item incentivado (sub-apura��o _9)
  end;

  // Registro E350 - Lista
  TRegistroSEFE350List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE350;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE350);
  public
    function New(): TRegistroSEFE350;
    property notas[Index: Integer]: TRegistroSEFE350 read Getnotas write SetNotas;
  end;


   //LINHA E360: OBRIGA��ES DO ICMS A RECOLHER

  TRegistroSEFE360 = class
  private
    fUF_OR : String;
    fCOD_OR : Integer;
    fPER_REF : String;
    fCOD_REC : String;
    fVL_ICMS_REC : Double;
    fDT_VCTO : TDateTime;
    fNUM_PROC : String;
    fIND_PROC : String;
    fDESCR_PROC : String;
    fCOD_INF_OBS : String;
   public
      property UF_OR       : String      read fUF_OR          write fUF_OR;         // Sigla da unidade da Federa��o a que se destina a obriga��o
      property COD_OR      : Integer     read fCOD_OR         write fCOD_OR;        // C�digo da obriga��o do ICMS a recolher, conforme a tabela in-dicada no item 5.3.1
      property PER_REF     : String      read fPER_REF        write fPER_REF;       // Per�odo fiscal de refer�ncia
      property COD_REC     : String      read fCOD_REC        write fCOD_REC;       // C�digo de receita referente � obriga��o a recolher para o Estado
      property VL_ICMS_REC : Double      read fVL_ICMS_REC    write fVL_ICMS_REC;   // Valor da obriga��o a recolher
      property DT_VCTO     : TDateTime   read fDT_VCTO        write fDT_VCTO ;      // Data de vencimento da obriga��o
      property NUM_PROC    : String      read fNUM_PROC       write fNUM_PROC ;     // N�mero do processo vinculado � obriga��o, se houver
      property IND_PROC    : String     read fIND_PROC       write fIND_PROC ;     // Indicador da origem do processo: 0- Administra��o estadual 1- Justi�a Federal 2- Justi�a Estadual 9- Outros
      property DESCR_PROC  : String      read fDESCR_PROC     write fDESCR_PROC ;   // Descri��o do processo que embasou o lan�amento
      property COD_INF_OBS : String      read fCOD_INF_OBS    write fCOD_INF_OBS;   // C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
    end;

  // Registro E360 - Lista
  TRegistroSEFE360List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE360;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE360);
  public
    function New(): TRegistroSEFE360;
    property notas[Index: Integer]: TRegistroSEFE360 read Getnotas write SetNotas;
  end;

  //LINHA E500: APURA��O DO IPI (MODELO 8)
  TRegistroSEFE500 = class
  private
    fDT_INI : TDateTime;
    fDT_FIN : TDateTime;
    fRegistroE520: TRegistroSEFE520List;
    fRegistroE525: TRegistroSEFE525List;
    fRegistroE540: TRegistroSEFE540List;
    fRegistroE550: TRegistroSEFE550List;
    fRegistroE560: TRegistroSEFE560List;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property DT_INI : TDateTime read	fDT_INI write fDT_INI;
    property DT_FIN : TDateTime read  fDT_FIN write fDT_FIN;
    property RegistroE520: TRegistroSEFE520List read fRegistroE520 write fRegistroE520;
    property RegistroE525: TRegistroSEFE525List read fRegistroE525 write fRegistroE525;
    property RegistroE540: TRegistroSEFE540List read fRegistroE540 write fRegistroE540;
    property RegistroE550: TRegistroSEFE550List read fRegistroE550 write fRegistroE550;
    property RegistroE560: TRegistroSEFE560List read fRegistroE560 write fRegistroE560;
  end;

  TRegistroSEFE500List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE500;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE500);
  public
    function New(): TRegistroSEFE500;
    property notas[Index: Integer]: TRegistroSEFE500 read Getnotas write SetNotas;
  end;

  //LINHA E520: CONSOLIDA��O POR CFOP DOS VALORES DO IPI
  TRegistroSEFE520 = class
  private
     fVL_CONT	    : Double; //Valor cont�bil, consolidado por CFOP	N	-	2				valor cont�bil
     fCFOP	      : integer;//C�digo Fiscal de Opera��es e Presta��es, conforme a tabela externa indicada no item 3.3.1	N	4	-		O	C	CFOP
     fVL_BC_IPI   : Double; //Valor da base de c�lculo do IPI, consolidado por CFOP	N	-	2				IPI - Base de C�lculo
     fVL_IPI	    : Double; //Valor do IPI creditado/debitado, consolidado por CFOP	N	-	2				IPI - Creditado
     fVL_ISNT_IPI	: Double; //Valor das opera��es isentas ou n�o-tributadas pelo IPI, consolidado por CFOP	N	-	2
     fVL_OUT_IPI	: Double; //Valor das outras opera��es do IPI, consolidado por CFOP	N	-	2
  public
    property VL_CONT     : Double  read	fVL_CONT      write fVL_CONT;
    property CFOP        : integer read	fCFOP         write fCFOP;
    property VL_BC_IPI   : Double  read	fVL_BC_IPI    write fVL_BC_IPI;
    property VL_IPI      : Double  read	fVL_IPI       write fVL_IPI;
    property VL_ISNT_IPI : Double  read	fVL_ISNT_IPI  write fVL_ISNT_IPI;
    property VL_OUT_IPI  : Double  read	fVL_OUT_IPI   write fVL_OUT_IPI ;
  end;

  TRegistroSEFE520List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE520;
    procedure SetNotas(Index: Integer; const Value: TRegistroSEFE520);
  public
    function New(): TRegistroSEFE520;
    property notas[Index: Integer]: TRegistroSEFE520 read Getnotas write SetNotas;
  end;

//LINHA E525: TOTALIZA��O DAS OPERA��ES DO IPI
  TRegistroSEFE525 = class
  private
    fIND_TOT	   : integer;//"Indicador de totaliza��o: 1- Entradas internas 2- Entradas interestaduais 3- Entradas do exterior 4- Entradas do per�odo (1 + 2 + 3) 5- Sa�das internas 6- Sa�das interestaduais 7- Sa�das para o exterior 8- Sa�das do per�odo (5 + 6 + 7)"	N	1	-		O	C
    fVL_CONT	   : Double;//Valor cont�bil	N	-	2				valor cont�bil
    fVL_BC_IPI   : Double;//	Valor da base de c�lculo do IPI	N	-	2				Base de C�lculo
    fVL_IPI	     : Double;//Valor do IPI creditado/debitado	N	-	2				IPI Creditado
    fVL_ISNT_IPI : Double;//	Valor das opera��es isentas ou n�o-tributadas pelo IPI	N	-	2				Opera��es/Presta��es Isentas/n�o-Tributadas
    fVL_OUT_IPI	 : Double;//Valor das outras opera��es do IPI	N	-	2				Outras
    public
      property IND_TOT        : integer read fIND_TOT       write fIND_TOT;
      property VL_CONT        : Double  read fVL_CONT       write fVL_CONT;
      property VL_BC_IPI      : Double  read fVL_BC_IPI     write fVL_BC_IPI;
      property VL_IPI         : Double  read fVL_IPI        write fVL_IPI;
      property VL_ISNT_IPI    : Double  read fVL_ISNT_IPI   write fVL_ISNT_IPI;
      property VL_OUT_IPI     : Double  read fVL_OUT_IPI    write fVL_OUT_IPI;
    end;

  // Registro E525 - Lista
  TRegistroSEFE525List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE525;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE525);
  public
    function New(): TRegistroSEFE525;
    property notas[Index: Integer]: TRegistroSEFE525 read Getnotas write SetNotas;
  end;

  //LINHA E540: SALDOS DA APURA��O DO IPI
  TRegistroSEFE540 = class
  private
    fVL_01 : Double;
    fVL_02 : Double;
    fVL_03 : Double;
    fVL_04 : Double;
    fVL_05 : Double;
    fVL_06 : Double;
    fVL_07 : Double;
    fVL_09 : Double;
    fVL_10 : Double;
    fVL_11 : Double;
    fVL_12 : Double;
    fVL_13 : Double;
    fVL_08 : Double;
    fVL_16 : Double;
    fVL_17 : Double;
  public
    property VL_01  : Double  read fVL_01 write fVL_01;    // 001- Valor dos cr�ditos por entradas do mercado nacional
    property VL_02  : Double  read fVL_02 write fVL_02;    // 002- Valor dos cr�ditos por entradas do mercado externo
    property VL_03  : Double  read fVL_03 write fVL_03;    // 003- Valor dos cr�ditos por sa�das para o mercado externo
    property VL_04  : Double  read fVL_04 write fVL_04;    // 004- Valor dos estornos de d�bitos
    property VL_05  : Double  read fVL_05 write fVL_05;    // 005- Valor dos outros cr�ditos
    property VL_06  : Double  read fVL_06 write fVL_06;    // 006- Valor subtotal (001 + 002 + 003 + 004 + 005)
    property VL_07  : Double  read fVL_07 write fVL_07;    // 007- Saldo credor do per�odo anterior
    property VL_09  : Double  read fVL_09 write fVL_09;    // 009- Valor dos d�bitos por sa�das para o mercado nacional
    property VL_10  : Double  read fVL_10 write fVL_10;    // 010- Valor dos estornos de cr�ditos
    property VL_11  : Double  read fVL_11 write fVL_11;    // 011- Valor dos ressarcimentos de cr�ditos
    property VL_12  : Double  read fVL_12 write fVL_12;    // 012- Valor dos outros d�bitos
    property VL_13  : Double  read fVL_13 write fVL_13;    // 014- D�bito total (= 013), onde '013- Valor total dos d�bitos (009 + 010 + 011 + 012)'
    property VL_08  : Double  read fVL_08 write fVL_08;    // 015- Cr�dito total (= 008), onde '008- Valor total dos cr�ditos (006 + 007)'
    property VL_16  : Double  read fVL_16 write fVL_16;    // 016- Saldo devedor (014 � 015)
    property VL_17  : Double  read fVL_17 write fVL_17;    // 017- Saldo credor (015 � 014)
  end;

  { TRegistroSEFE540List }

  TRegistroSEFE540List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE540;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE540);
  public
    function New(): TRegistroSEFE540;
    property notas[Index: Integer]: TRegistroSEFE540 read Getnotas write SetNotas;
  end;

    //LINHA E550: AJUSTES DA APURA��O DO IPI
  TRegistroSEFE550 = class
  private
    FCOD_AJ: String;
    FDESCR_AJ: String;
    FCOD_INF_OBS: string;
    FNUM_DOC: String;
    FVL_AJ: Double;
    FIND_DOC: String;
  public
  property COD_AJ      : String  read FCOD_AJ      write FCOD_AJ;       //C�digo do ajuste da apura��o do IPI, conforme a tabela externa indicada no item 3.3.1
  property VL_AJ       : Double  read FVL_AJ       write FVL_AJ;        //Valor do ajuste
  property IND_DOC     : String read FIND_DOC     write FIND_DOC;      //Indicador da origem do documento vinculado ao ajuste: 0- Processo judicial 1- Processo administrativo 2- PER/DCOMP 9- Outros
  property NUM_DOC     : String  read FNUM_DOC     write FNUM_DOC;      //N�mero do documento, processo ou declara��o vinculada ao ajuste, se houver
  property DESCR_AJ    : String  read FDESCR_AJ    write FDESCR_AJ;     //Descri��o detalhada do ajuste
  property COD_INF_OBS : string  read FCOD_INF_OBS write FCOD_INF_OBS;  //C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)
  end;

  // Registro E550 - Lista
  TRegistroSEFE550List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE550;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE550);
  public
    function New(): TRegistroSEFE550;
    property notas[Index: Integer]: TRegistroSEFE550 read Getnotas write SetNotas;
  end;


  TRegistroSEFE560 = class
  private
    fCOD_OR_IPI  : string;   //C�digo da obriga��o do IPI a recolher	C	4	-
    fPER_REF     : String;    //PER_REF	Per�odo fiscal de refer�ncia	N	6	-		O
    fCOD_REC_IPI : string;    //C�digo de receita do IPI, conforme a tabela externa indicada no item 3.3.1	N	4	-		O
    fVL_IPI_REC	 : Double;    //Valor da obriga��o a recolher	N	-	2		O
    fDT_VCTO     : TDateTime;	//Data de vencimento da obriga��o	N	8	-
    fIND_DOC	 : String;   //"Indicador da origem do processo vinculado � obriga��o: 0- Processo judicial 1- Processo administrativo 2- PER/DCOMP 9- Outros"	N	1	-
    fNUM_DOC	 : string;    //N�mero do documento, processo ou declara��o vinculada � obriga��o, se houver	C	-	-	25
    fDESCR_AJ    : string;    //Descri��o detalhada do ajuste	C	-	-	60
    fCOD_INF_OBS : string;    //C�digo de refer�ncia � observa��o (campo 02 da Linha 0450)	C	-	-	9
   public
      property COD_OR_IPI  : string      read fCOD_OR_IPI     write fCOD_OR_IPI;
      property PER_REF     : String      read fPER_REF        write fPER_REF;
      property COD_REC_IPI : String      read fCOD_REC_IPI    write fCOD_REC_IPI;
      property VL_IPI_REC  : Double      read fVL_IPI_REC     write fVL_IPI_REC;
      property DT_VCTO     : TDateTime   read fDT_VCTO        write fDT_VCTO;
      property IND_DOC     : String      read fIND_DOC        write fIND_DOC;
      property NUM_DOC     : String      read fNUM_DOC        write fNUM_DOC;
      property DESCR_AJ    : String      read fDESCR_AJ       write fDESCR_AJ;
      property COD_INF_OBS : String      read fCOD_INF_OBS    write fCOD_INF_OBS;
    end;

  // Registro E560 - Lista
  TRegistroSEFE560List = class(TACBrSEFIIRegistros)
  private
    function GetNotas(Index: Integer): TRegistroSEFE560;
    procedure SetNotas(Index: Integer;  const Value: TRegistroSEFE560);
  public
    function New(): TRegistroSEFE560;
    property notas[Index: Integer]: TRegistroSEFE560 read Getnotas write SetNotas;
  end;

  ////////////////////////////////////////////////////

  { TRegistroSEFE990 }

  /// Registro E990 - Encerramento do Bloco E
  TRegistroSEFE990 = class
  private
    fQTD_LIN_E: Integer;
  public
    property QTD_LIN_E: Integer read fQTD_LIN_E write fQTD_LIN_E;
  end;

implementation

{ TRegistroSEFE340List }

function TRegistroSEFE340List.GetNotas(Index: Integer): TRegistroSEFE340;
begin
  Result := TRegistroSEFE340(Get(Index));
end;

procedure TRegistroSEFE340List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE340);
begin
  Put(Index, Value);
end;

function TRegistroSEFE340List.New(): TRegistroSEFE340;
begin
  if Self.Count <> 0 then
     raise Exception.Create('J� existe o registro E340 para o periodo!' );
  Result := TRegistroSEFE340.Create;
  Add(Result);
end;

constructor TRegistroSEFE020.Create();
begin
  inherited Create;
  FRegistroE025 := TRegistroSEFE025List.Create;
end;

destructor TRegistroSEFE020.Destroy;
begin
   FRegistroE025.Free;
   inherited Destroy;
end;

constructor TRegistroSEFE120.Create(AOwner: TRegistroSEFE001);
begin

end;

destructor TRegistroSEFE120.Destroy;
begin
  inherited;
end;


procedure TRegistroSEFE003List.SetItem(Index: Integer;
  const Value: TRegistroSEFE003);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE020List.SetItem(Index: Integer;
  const Value: TRegistroSEFE020);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE025List.SetItem(Index: Integer;
  const Value: TRegistroSEFE025);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE060List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE060);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE065List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE065);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE080List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE080);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE085List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE085);
begin
  Put(Index, Value);
end;


procedure TRegistroSEFE120List.SetItem(Index: Integer;
  const Value: TRegistroSEFE120);
begin
  Put(Index, Value);
end;


procedure TRegistroSEFE300List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE300);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE305List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE305);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE310List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE310);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE330List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE330);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE350List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE350);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE360List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE360);
begin
  Put(Index, Value);
end;

procedure TRegistroSEFE500List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE500);
begin
  Put(Index, Value);
end;

function TRegistroSEFE500List.GetNotas(Index: Integer): TRegistroSEFE500;
begin
  Result := TRegistroSEFE500(Get(Index));
end;

function TRegistroSEFE520List.GetNotas(Index: Integer): TRegistroSEFE520;
begin
  Result := TRegistroSEFE520(Get(Index));
end;

procedure TRegistroSEFE520List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE520);
begin
  Put(Index, Value);
end;

function TRegistroSEFE520List.New(): TRegistroSEFE520;
begin
   Result := TRegistroSEFE520.Create;
   Add(Result);
end;

function TRegistroSEFE525List.GetNotas(Index: Integer): TRegistroSEFE525;
begin
  Result := TRegistroSEFE525(Get(Index));
end;

procedure TRegistroSEFE525List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE525);
begin
  Put(Index, Value);
end;

function TRegistroSEFE525List.New(): TRegistroSEFE525;
begin
   Result := TRegistroSEFE525.Create;
   Add(Result);
end;

function TRegistroSEFE540List.GetNotas(Index: Integer): TRegistroSEFE540;
begin
  Result := TRegistroSEFE540(Get(Index));
end;

procedure TRegistroSEFE540List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE540);
begin
  Put(Index, Value);
end;

function TRegistroSEFE540List.New(): TRegistroSEFE540;
begin
  if Self.Count <> 0 then
     raise Exception.Create('J� existe o registro E540 para o periodo!' );
  Result := TRegistroSEFE540.Create;
  Add(Result);
end;

procedure TRegistroSEFE560List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE560);
begin
  Put(Index, Value);
end;

function TRegistroSEFE560List.GetNotas(Index: Integer): TRegistroSEFE560;
begin
  Result := TRegistroSEFE560(Get(Index));
end;


function TRegistroSEFE003List.GetItem(Index: Integer): TRegistroSEFE003;
begin
  Result := TRegistroSEFE003(Get(Index));
end;

function TRegistroSEFE020List.GetItem(Index: Integer): TRegistroSEFE020;
begin
  Result := TRegistroSEFE020(Get(Index));
end;

function TRegistroSEFE025List.GetItem(Index: Integer): TRegistroSEFE025;
begin
  Result := TRegistroSEFE025(Get(Index));
end;

function TRegistroSEFE055List.GetItem(Index: Integer): TRegistroSEFE055;
begin
  Result := TRegistroSEFE055(Get(Index));
end;

procedure TRegistroSEFE055List.SetItem(Index: Integer;
  const Value: TRegistroSEFE055);
begin
   Put(Index, Value);
end;

function TRegistroSEFE060List.GetNotas(Index: Integer): TRegistroSEFE060;
begin
  Result := TRegistroSEFE060(Get(Index));
end;

function TRegistroSEFE065List.GetNotas(Index: Integer): TRegistroSEFE065;
begin
  Result := TRegistroSEFE065(Get(Index));
end;

function TRegistroSEFE080List.GetNotas(Index: Integer): TRegistroSEFE080;
begin
  Result := TRegistroSEFE080(Get(Index));
end;

function TRegistroSEFE085List.GetNotas(Index: Integer): TRegistroSEFE085;
begin
  Result := TRegistroSEFE085(Get(Index));
end;


function TRegistroSEFE120List.GetItem(Index: Integer): TRegistroSEFE120;
begin
  Result := TRegistroSEFE120(Get(Index));
end;


function TRegistroSEFE300List.GetNotas(Index: Integer): TRegistroSEFE300;
begin
  Result := TRegistroSEFE300(Get(Index));
end;

function TRegistroSEFE305List.GetNotas(Index: Integer): TRegistroSEFE305;
begin
  Result := TRegistroSEFE305(Get(Index));
end;

function TRegistroSEFE310List.GetNotas(Index: Integer): TRegistroSEFE310;
begin
  Result := TRegistroSEFE310(Get(Index));
end;

function TRegistroSEFE330List.GetNotas(Index: Integer): TRegistroSEFE330;
begin
  Result := TRegistroSEFE330(Get(Index));
end;

function TRegistroSEFE350List.GetNotas(Index: Integer): TRegistroSEFE350;
begin
  Result := TRegistroSEFE350(Get(Index));
end;

function TRegistroSEFE360List.GetNotas(Index: Integer): TRegistroSEFE360;
begin
  Result := TRegistroSEFE360(Get(Index));
end;

function TRegistroSEFE003List.New(AOwner: TRegistroSEFE001): TRegistroSEFE003;
begin
   Result := TRegistroSEFE003.create(AOwner);
   Add(Result);
end;

function TRegistroSEFE020List.New(): TRegistroSEFE020;
begin
   Result := TRegistroSEFE020.Create();
   Add(Result);
end;

function TRegistroSEFE050List.GetItem(Index: Integer): TRegistroSEFE050;
begin
   Result := TRegistroSEFE050(Get(Index));
end;

procedure TRegistroSEFE050List.SetItem(Index: Integer;
  const Value: TRegistroSEFE050);
begin
   Put(Index, Value);
end;

function TRegistroSEFE050List.New(): TRegistroSEFE050;
begin
   Result := TRegistroSEFE050.Create;
   Add(Result);
end;

function TRegistroSEFE055List.New(): TRegistroSEFE055;
begin
   Result := TRegistroSEFE055.Create;
   Add(Result);
end;

function TRegistroSEFE060List.New(): TRegistroSEFE060;
begin
   Result := TRegistroSEFE060.Create;
   Add(Result);
end;

function TRegistroSEFE080List.New(): TRegistroSEFE080;
begin
   Result := TRegistroSEFE080.Create;
   Add(Result);
end;

function TRegistroSEFE085List.New(): TRegistroSEFE085;
begin
   Result := TRegistroSEFE085.Create;
   Add(Result);
end;


function TRegistroSEFE120List.New(AOwner: TRegistroSEFE001): TRegistroSEFE120;
begin
   Result := TRegistroSEFE120.Create(AOwner);
   Add(Result);
end;


function TRegistroSEFE300List.New(): TRegistroSEFE300;
begin
   Result := TRegistroSEFE300.Create;
   Add(Result);
end;

function TRegistroSEFE305List.New(): TRegistroSEFE305;
begin
   Result := TRegistroSEFE305.Create;
   Add(Result);
end;

function TRegistroSEFE310List.New(): TRegistroSEFE310;
begin
   Result := TRegistroSEFE310.Create;
   Add(Result);
end;

function TRegistroSEFE330List.New(): TRegistroSEFE330;
begin
   Result := TRegistroSEFE330.Create;
   Add(Result);
end;

function TRegistroSEFE350List.New(): TRegistroSEFE350;
begin
   Result := TRegistroSEFE350.Create;
   Add(Result);
end;

function TRegistroSEFE360List.New(): TRegistroSEFE360;
begin
   Result := TRegistroSEFE360.Create;
   Add(Result);
end;

function TRegistroSEFE500List.New(): TRegistroSEFE500;
begin
   Result := TRegistroSEFE500.Create;
   Add(Result);
end;

function TRegistroSEFE560List.New(): TRegistroSEFE560;
begin
   Result := TRegistroSEFE560.Create;
   Add(Result);
end;


{ TRegistroSEFE060 }

constructor TRegistroSEFE060.Create;
begin
   FRegistroE065 := TRegistroSEFE065List.Create;
end;

destructor TRegistroSEFE060.Destroy;
begin
   FRegistroE065.Free;
   inherited Destroy;
end;

{ TRegistroSEFE001 }

constructor TRegistroSEFE001.Create;
begin
   inherited Create;
   fRegistroE003 := TRegistroSEFE003List.Create;
   fRegistroE020 := TRegistroSEFE020List.Create;
   fRegistroE050 := TRegistroSEFE050List.Create;
   fRegistroE060 := TRegistroSEFE060List.Create;
   fRegistroE080 := TRegistroSEFE080List.Create;
   fRegistroE100 := TRegistroSEFE100List.Create;
   fRegistroE120 := TRegistroSEFE120List.Create; 
   fRegistroE300 := TRegistroSEFE300List.Create;
   fRegistroE500 := TRegistroSEFE500List.Create;    
   IND_MOV := icSemConteudo;
end;

destructor TRegistroSEFE001.Destroy;
begin
   fRegistroE003.Free;
   fRegistroE020.Free;
   fRegistroE050.Free;
   fRegistroE060.Free;
   fRegistroE080.Free;
   fRegistroE100.Free;
   fRegistroE120.Free;
   fRegistroE300.Free;
   fRegistroE500.Free;
   inherited;
end;

function TRegistroSEFE025List.New(AOwner: TRegistroSEFE020): TRegistroSEFE025;
begin
   Result := TRegistroSEFE025.Create(AOwner);
   Add(Result);
end;

{ TRegistroSEFE050 }

constructor TRegistroSEFE050.Create;
begin
   FRegistroE055 := TRegistroSEFE055List.Create;
end;

destructor TRegistroSEFE050.Destroy;
begin
   FRegistroE055.Free;
   inherited Destroy;
end;

function TRegistroSEFE065List.New(): TRegistroSEFE065;
begin
   Result := TRegistroSEFE065.Create;
   Add(Result);
end;

{ TRegistroSEFE080 }

constructor TRegistroSEFE080.Create;
begin
   FRegistroE085 := TRegistroSEFE085List.Create;
end;

destructor TRegistroSEFE080.Destroy;
begin
   FRegistroE085.Free;
   inherited Destroy;
end;

{ TRegistroSEFE300 }

constructor TRegistroSEFE300.Create;
begin
   FRegistroE305 := TRegistroSEFE305List.Create;
   FRegistroE310 := TRegistroSEFE310List.Create;
   FRegistroE330 := TRegistroSEFE330List.Create;
   FRegistroE340 := TRegistroSEFE340List.Create;
   FRegistroE350 := TRegistroSEFE350List.Create;
   FRegistroE360 := TRegistroSEFE360List.Create;
end;

destructor TRegistroSEFE300.Destroy;
begin
   FRegistroE305.Free;
   FRegistroE310.Free;
   FRegistroE330.Free;
   FRegistroE340.Free;
   FRegistroE350.Free;
   FRegistroE360.Free;
   inherited Destroy;
end;

{ TRegistroSEFE025 }

constructor TRegistroSEFE025.Create(AOwner: TRegistroSEFE020);
begin

end;

{ TRegistroSEFE003 }

constructor TRegistroSEFE003.Create(AOwner: TRegistroSEFE001);
begin

end;

constructor TRegistroSEFE500.Create;
begin
   FRegistroE520 := TRegistroSEFE520List.Create;
   FRegistroE525 := TRegistroSEFE525List.Create;
   FRegistroE540 := TRegistroSEFE540List.Create;
   FRegistroE550 := TRegistroSEFE550List.Create;
   FRegistroE560 := TRegistroSEFE560List.Create;
end;

destructor TRegistroSEFE500.Destroy;
begin
   FRegistroE520.Free;
   FRegistroE525.Free;
   FRegistroE540.Free;
   FRegistroE550.Free;
   FRegistroE560.Free;
   inherited Destroy;
end;


{ TRegistroSEFE100 }

constructor TRegistroSEFE100.Create();
begin
  inherited Create;

  FRegistroE105 := TRegistroSEFE105List.Create;
end;

destructor TRegistroSEFE100.Destroy;
begin
   FRegistroE105.Free;
   inherited Destroy;
end;

{ TRegistroSEFE100List }

function TRegistroSEFE100List.GetItem(Index: Integer): TRegistroSEFE100;
begin
   Result := TRegistroSEFE100(Get(Index));
end;

function TRegistroSEFE100List.New(): TRegistroSEFE100;
begin
   Result := TRegistroSEFE100.Create();
   Add(Result);
end;

procedure TRegistroSEFE100List.SetItem(Index: Integer; const Value: TRegistroSEFE100);
begin
   Put(Index, Value);
end;

{ TRegistroSEFE105List }

function TRegistroSEFE105List.GetItem(Index: Integer): TRegistroSEFE105;
begin
  Result := TRegistroSEFE105(Get(Index));
end;

function TRegistroSEFE105List.New(): TRegistroSEFE105;
begin
   Result := TRegistroSEFE105.Create;
   Add(Result);
end;

procedure TRegistroSEFE105List.SetItem(Index: Integer; const Value: TRegistroSEFE105);
begin
   Put(Index, Value);
end;

{ TRegistroSEFE550List }

function TRegistroSEFE550List.GetNotas(Index: Integer): TRegistroSEFE550;
begin
  Result := TRegistroSEFE550(Get(Index));
end;

function TRegistroSEFE550List.New(): TRegistroSEFE550;
begin
   Result := TRegistroSEFE550.Create;
   Add(Result);
end;

procedure TRegistroSEFE550List.SetNotas(Index: Integer;
  const Value: TRegistroSEFE550);
begin
  Put(Index, Value);
end;

end.

