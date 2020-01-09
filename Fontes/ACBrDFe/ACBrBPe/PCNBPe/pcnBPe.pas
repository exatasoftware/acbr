////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar BPe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml do BPe          //
//                                                                            //
//        site: www.projetocooperar.org                                       //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{*******************************************************************************
|* Historico
|*
|* 20/06/2017: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnBPe;

interface

uses
  SysUtils, Classes, Contnrs,
  pcnConversao, pcnConversaoBPe, pcnSignature, pcnProcBPe, pcnGerador;

type

  TBPe = class;
  TInfBPe = class;
  TIde = class;

  TEmit = class;
  TenderEmit = class;

  TComp = class;
  TenderComp = class;

  TAgencia = class;

  TInfBPeSub = class;
  TInfPassagem = class;
  TInfPassageiro = class;

  TInfViagemCollection = class;
  TInfViagemCollectionItem = class;
  TinfTravessia = class;

  TinfValorBPe = class;
  TCompCollection = class;
  TCompCollectionItem = class;

  TImp = class;
  TICMS = class;
  TICMSUFFim = class;

  TpagCollection = class;
  TpagCollectionItem = class;

  TautXMLCollection     = class;
  TautXMLCollectionItem = class;

  TInfAdic = class;
  TinfBPeSupl = class;

  { TinfRespTec }

  TinfRespTec = class(TObject)
  private
    FCNPJ: String;
    FxContato: String;
    Femail: String;
    Ffone: String;
    FidCSRT: Integer;
    FhashCSRT: String;
  public
    procedure Assign(Source: TinfRespTec);

    property CNPJ: String     read FCNPJ     write FCNPJ;
    property xContato: String read FxContato write FxContato;
    property email: String    read Femail    write Femail;
    property fone: String     read Ffone     write Ffone;
    property idCSRT: Integer  read FidCSRT   write FidCSRT;
    property hashCSRT: String read FhashCSRT write FhashCSRT;
  end;

  { TBPe }

  TBPe = class(TObject)
  private
    FinfBPe: TinfBPe;
    FIde: TIde;
    FEmit: TEmit;
    FComp: TComp;
    FAgencia: TAgencia;
    FinfBPeSub: TinfBPeSub;
    FinfPassagem: TinfPassagem;
    FinfViagem: TInfViagemCollection;
    FinfValorBPe: TinfValorBPe;
    FImp: TImp;
    FPag: TpagCollection;
    FautXML: TautXMLCollection;
    FInfAdic: TInfAdic;
    FinfBPeSupl: TinfBPeSupl;
    FSignature: TSignature;
    FProcBPe: TProcBPe;
    FinfRespTec: TinfRespTec;

    procedure SetInfViagem(const Value: TInfViagemCollection);
    procedure SetPag(Value: TpagCollection);
    procedure SetautXML(const Value: TautXMLCollection);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TBPe);
    procedure SetXMLString(const AValue : AnsiString) ;
    property infBPe: TinfBPe read FinfBPe write FinfBPe;
    property Ide: TIde read FIde write FIde;
    property Emit: TEmit read FEmit write FEmit;
    property Comp: TComp read FComp write FComp;
    property Agencia: TAgencia read FAgencia write FAgencia;
    property infBPeSub: TinfBPeSub read FinfBPeSub write FinfBPeSub;
    property infPassagem: TinfPassagem read FinfPassagem write FinfPassagem;
    property infViagem: TInfViagemCollection read FinfViagem write SetInfViagem;
    property infValorBPe: TinfValorBPe read FinfValorBPe write FinfValorBPe;
    property Imp: TImp read FImp write FImp;
    property Pag: TpagCollection read Fpag write SetPag;
    property autXML: TautXMLCollection read FautXML write SetautXML;
    property InfAdic: TInfAdic read FInfAdic write FInfAdic;
    property infBPeSupl: TinfBPeSupl read FinfBPeSupl write FinfBPeSupl;
    property Signature: TSignature read FSignature write FSignature;
    property procBPe: TProcBPe read FProcBPe write FProcBPe;
    property infRespTec: TinfRespTec read FinfRespTec write FinfRespTec;
  end;

  TinfBPe = class(TObject)
  private
    FVersao: Real;
    FID: String;

    function GetVersaoStr: String;
    function GetVersao: Real;
  public
    procedure Assign(Source: TinfBPe);

    property Versao: Real read GetVersao write FVersao;
    property VersaoStr: String read GetVersaoStr;
    property ID: String read FID write FID;
  end;

  TIde = class(TObject)
  private
    FcUF: Integer;
    FtpAmb: TpcnTipoAmbiente;
    Fmodelo: Integer;
    Fserie: Integer;
    FnBP: Integer;
    FcBP: Integer;
    FcDV: Integer;
    Fmodal: TModalBPe;
    FdhEmi: TDateTime;
    FtpEmis: TpcnTipoEmissao;
    FverProc: String;
    FtpBPe: TTipoBPe;
    FindPres: TpcnPresencaComprador;
    FUFIni: String;
    FcMunIni: Integer;
    FUFFim: String;
    FcMunFim: Integer;
    FdhCont : TDateTime;
    FxJust  : String;

  public
    procedure Assign(Source: TIde);

    property cUF: Integer read FcUF write FcUF;
    property tpAmb: TpcnTipoAmbiente read FtpAmb write FtpAmb default taHomologacao;
    property modelo: Integer read Fmodelo write Fmodelo;
    property serie: Integer read Fserie write Fserie;
    property nBP: Integer read FnBP write FnBP;
    property cBP: Integer read FcBP write FcBP;
    property cDV: Integer read FcDV write FcDV;
    property modal: TModalBPe read Fmodal write Fmodal;
    property dhEmi: TDateTime read FdhEmi write FdhEmi;
    property tpEmis: TpcnTipoEmissao read FtpEmis write FtpEmis default teNormal;
    property verProc: String read FverProc write FverProc;
    property tpBPe: TTipoBPe read FtpBPe write FtpBPe default tbNormal;
    property indPres: TpcnPresencaComprador read FindPres write FindPres;
    property UFIni: String read FUFIni write FUFIni;
    property cMunIni: Integer read FcMunIni write FcMunIni;
    property UFFim: String read FUFFim write FUFFim;
    property cMunFim: Integer read FcMunFim write FcMunFim;
    property dhCont: TDateTime read FdhCont write FdhCont;
    property xJust: String read FxJust write FxJust;
  end;

  TEmit = class(TObject)
  private
    FCNPJ: String;
    FIE: String;
    FIEST: String;
    FxNome: String;
    FxFant: String;
    FIM: String;
    FCNAE: String;
    FCRT: TpcnCRT;
    FenderEmit: TenderEmit;
    FTAR: String;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TEmit);

    property CNPJ: String read FCNPJ write FCNPJ;
    property IE: String read FIE write FIE;
    property IEST: String read FIEST write FIEST;
    property xNome: String read FxNome write FxNome;
    property xFant: String read FxFant write FxFant;
    property IM: String read FIM write FIM;
    property CNAE: String read FCNAE write FCNAE;
    property CRT: TpcnCRT read FCRT write FCRT;
    property EnderEmit: TEnderEmit read FEnderEmit write FEnderEmit;
    property TAR: String read FTAR write FTAR;
  end;

  TEnderEmit = class(TObject)
  private
    FxLgr: String;
    Fnro: String;
    fxCpl: String;
    FxBairro: String;
    FcMun: Integer;
    FxMun: String;
    FCEP: Integer;
    FUF: String;
    Ffone: String;
    FEmail: String;
  public
    procedure Assign(Source: TEnderEmit);

    property xLgr: String read FxLgr write FxLgr;
    property nro: String read Fnro write Fnro;
    property xCpl: String read FxCpl write FxCpl;
    property xBairro: String read FxBairro write FxBairro;
    property cMun: Integer read FcMun write FcMun;
    property xMun: String read FxMun write FxMun;
    property CEP: Integer read FCEP write FCEP;
    property UF: String read FUF write FUF;
    property Fone: String read Ffone write Ffone;
    property Email: String read FEmail write FEmail;
  end;

  TComp = class(TObject)
  private
    FxNome: String;
    FCNPJCPF: String;
    FidEstrangeiro: String;
    FIE: String;
    FenderComp: TenderComp;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TComp);

    property xNome: String read FxNome write FxNome;
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
    property idEstrangeiro: String read FidEstrangeiro write FidEstrangeiro;
    property IE: String read FIE write FIE;
    property EnderComp: TEnderComp read FEnderComp write FEnderComp;
  end;

  TEnderComp = class(TObject)
  private
    FxLgr: String;
    Fnro: String;
    fxCpl: String;
    FxBairro: String;
    FcMun: Integer;
    FxMun: String;
    FCEP: Integer;
    FUF: String;
    FcPais: Integer;
    FxPais: String;
    Ffone: String;
    FEmail: String;
  public
    procedure Assign(Source: TEnderComp);

    property xLgr: String read FxLgr write FxLgr;
    property nro: String read Fnro write Fnro;
    property xCpl: String read FxCpl write FxCpl;
    property xBairro: String read FxBairro write FxBairro;
    property cMun: Integer read FcMun write FcMun;
    property xMun: String read FxMun write FxMun;
    property CEP: Integer read FCEP write FCEP;
    property UF: String read FUF write FUF;
    property cPais: Integer read FcPais write FcPais;
    property xPais: String read FxPais write FxPais;
    property Fone: String read Ffone write Ffone;
    property Email: String read FEmail write FEmail;
  end;

  TAgencia = class(TObject)
  private
    FxNome: String;
    FCNPJ: String;
    FenderAgencia: TenderComp;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TAgencia);

    property xNome: String read FxNome write FxNome;
    property CNPJ: String read FCNPJ write FCNPJ;
    property EnderAgencia: TEnderComp read FEnderAgencia write FEnderAgencia;
  end;

  TinfBPeSub = class(TObject)
  private
    FchBPe: String;
    FtpSub: TTipoSubstituicao;
  public
    procedure Assign(Source: TinfBPeSub);

    property chBPe: String read FchBPe write FchBPe;
    property tpSub: TTipoSubstituicao read FtpSub write FtpSub;
  end;

  TinfPassagem = class(TObject)
  private
    FcLocOrig: String;
    FxLocOrig: String;
    FcLocDest: String;
    FxLocDest: String;
    FdhEmb: TDateTime;
    FdhValidade: TDateTime;
    FinfPassageiro: TinfPassageiro;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TinfPassagem);

    property cLocOrig: String read FcLocOrig write FcLocOrig;
    property xLocOrig: String read FxLocOrig write FxLocOrig;
    property cLocDest: String read FcLocDest write FcLocDest;
    property xLocDest: String read FxLocDest write FxLocDest;
    property dhEmb: TDateTime read FdhEmb write FdhEmb;
    property dhValidade: TDateTime read FdhValidade write FdhValidade;
    property infPassageiro: TinfPassageiro read FinfPassageiro write FinfPassageiro;
  end;

  TinfPassageiro = class(TObject)
  private
    FxNome: String;
    FCPF: String;
    FtpDoc: TTipoDocumento;
    FnDoc: String;
    FxDoc: String;
    FdNasc: TDateTime;
    FFone: String;
    FEmail: String;
  public
    procedure Assign(Source: TinfPassageiro);

    property xNome: String read FxNome write FxNome;
    property CPF: String read FCPF write FCPF;
    property tpDoc: TTipoDocumento read FtpDoc write FtpDoc;
    property nDoc: String read FnDoc write FnDoc;
    property xDoc: String read FxDoc write FxDoc;
    property dNasc: TDateTime read FdNasc write FdNasc;
    property Fone: String read FFone write FFone;
    property Email: String read FEmail write FEmail;
  end;

  TInfViagemCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TInfViagemCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfViagemCollectionItem);
  public
    function Add: TInfViagemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfViagemCollectionItem;
    property Items[Index: Integer]: TInfViagemCollectionItem read GetItem write SetItem; default;
  end;

  TInfViagemCollectionItem = class(TObject)
  private
    FcPercurso: String;
    FxPercurso: String;
    FtpViagem: TTipoViagem;
    FtpServ: TTipoServico;
    FtpAcomodacao: TTipoAcomodacao;
    FtpTrecho: TTipoTrecho;
    FdhViagem: TDateTime;
    FdhConexao: TDateTime;
    FPrefixo: String;
    FPoltrona: Integer;
    FPlataforma: String;
    FinfTravessia: TinfTravessia;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TInfViagemCollectionItem);

    property cPercurso: String read FcPercurso write FcPercurso;
    property xPercurso: String read FxPercurso write FxPercurso;
    property tpViagem: TTipoViagem read FtpViagem write FtpViagem;
    property tpServ: TTipoServico read FtpServ write FtpServ;
    property tpAcomodacao: TTipoAcomodacao read FtpAcomodacao write FtpAcomodacao;
    property tpTrecho: TTipoTrecho read FtpTrecho write FtpTrecho;
    property dhViagem: TDateTime read FdhViagem write FdhViagem;
    property dhConexao: TDateTime read FdhConexao write FdhConexao;
    property Prefixo: String read FPrefixo write FPrefixo;
    property Poltrona: Integer read FPoltrona write FPoltrona;
    property Plataforma: String read FPlataforma write FPlataforma;
    property infTravessia: TinfTravessia read FinfTravessia write FinfTravessia;
  end;

  TinfTravessia = class(TObject)
  private
    FtpVeiculo: TTipoVeiculo;
    FsitVeiculo: TSitVeiculo;
  public
    procedure Assign(Source: TinfTravessia);

    property tpVeiculo: TTipoVeiculo read FtpVeiculo write FtpVeiculo;
    property sitVeiculo: TSitVeiculo read FsitVeiculo write FsitVeiculo;
  end;

  TinfValorBPe = class(TObject)
  private
    FvBP: Currency;
    FvDesconto: Currency;
    FvPgto: Currency;
    FvTroco: Currency;
    FtpDesconto: TTipoDesconto;
    FxDesconto: String;
    FcDesconto: String;
    FComp: TCompCollection;

    procedure SetComp(const Value: TCompCollection);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TinfValorBPe);
    property vBP: Currency read FvBP write FvBP;
    property vDesconto: Currency read FvDesconto write FvDesconto;
    property vPgto: Currency read FvPgto write FvPgto;
    property vTroco: Currency read FvTroco write FvTroco;
    property tpDesconto: TTipoDesconto read FtpDesconto write FtpDesconto;
    property xDesconto: String read FxDesconto write FxDesconto;
    property cDesconto: String read FcDesconto write FcDesconto;
    property Comp: TCompCollection read FComp write SetComp;
  end;

  TCompCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TCompCollectionItem;
    procedure SetItem(Index: Integer; Value: TCompCollectionItem);
  public
    function Add: TCompCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TCompCollectionItem;
    property Items[Index: Integer]: TCompCollectionItem read GetItem write SetItem; default;
  end;

  TCompCollectionItem = class(TObject)
  private
    FtpComp: TTipoComponente;
    FvComp: Currency;
  public
    procedure Assign(Source: TCompCollectionItem);
    property tpComp: TTipoComponente read FtpComp write FtpComp;
    property vComp: Currency read FvComp write FvComp;
  end;

  TImp = class(TObject)
  private
    FICMS: TICMS;
    FvTotTrib: Currency;
    FinfAdFisco: String;
    FICMSUFFim: TICMSUFFim;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TImp);

    property ICMS: TICMS read FICMS write FICMS;
    property vTotTrib: Currency read FvTotTrib write FvTotTrib;
    property infAdFisco: String read FinfAdFisco write FinfAdFisco;
    property ICMSUFFim: TICMSUFFim read FICMSUFFim write FICMSUFFim;
  end;

  TICMS = class(TObject)
  private
    FCST: TpcnCSTIcms;
    FvBC: Currency;
    FpICMS: Currency;
    FvICMS: Currency;
    FpRedBC: Currency;
    FvCred: Currency;
    FpRedBCOutraUF: Currency;
    FvBCOutraUF: Currency;
    FpICMSOutraUF: Currency;
    FvICMSOutraUF: Currency;
  public
    procedure Assign(Source: TICMS);
    property CST: TpcnCSTIcms read FCST write FCST default cst00;
    property vBC: Currency read FvBC write FvBC;
    property pICMS: Currency read FpICMS write FpICMS;
    property vICMS: Currency read FvICMS write FvICMS;
    property pRedBC: Currency read FpRedBC write FpRedBC;
    property vCred: Currency read FvCred write FvCred;
    property pRedBCOutraUF: Currency read FpRedBCOutraUF write FpRedBCOutraUF;
    property vBCOutraUF: Currency read FvBCOutraUF write FvBCOutraUF;
    property pICMSOutraUF: Currency read FpICMSOutraUF write FpICMSOutraUF;
    property vICMSOutraUF: Currency read FvICMSOutraUF write FvICMSOutraUF;
  end;

  TICMSUFFim = class(TObject)
  private
    FvBCUFFim: Currency;
    FpFCPUFFim: Currency;
    FpICMSUFFim: Currency;
    FpICMSInter: Currency;
    FpICMSInterPart: Currency;
    FvFCPUFFim: Currency;
    FvICMSUFFim: Currency;
    FvICMSUFIni: Currency;    
  public
    procedure Assign(Source: TICMSUFFim);

    property vBCUFFim: Currency read FvBCUFFim write FvBCUFFim;
    property pFCPUFFim: Currency read FpFCPUFFim write FpFCPUFFim;
    property pICMSUFFim: Currency read FpICMSUFFim write FpICMSUFFim;
    property pICMSInter: Currency read FpICMSInter write FpICMSInter;
    property pICMSInterPart: Currency read FpICMSInterPart write FpICMSInterPart;
    property vFCPUFFim: Currency read FvFCPUFFim write FvFCPUFFim;
    property vICMSUFFim: Currency read FvICMSUFFim write FvICMSUFFim;
    property vICMSUFIni: Currency read FvICMSUFIni write FvICMSUFIni;
  end;

  { TpagCollection}

  TpagCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TpagCollectionItem;
    procedure SetItem(Index: Integer; Value: TpagCollectionItem);
  public
    function Add: TpagCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TpagCollectionItem;
    property Items[Index: Integer]: TpagCollectionItem read GetItem write SetItem; default;
  end;

  TpagCollectionItem = class(TObject)
  private
    FtPag: TFormaPagamento;
    FxPag: String;
    FnDocPag: String;
    FvPag: Currency;
    FtpIntegra: TtpIntegra;
    FCNPJ: String;
    FtBand: TBandeiraCard;
    FxBand: String;
    FcAut: String;
    FnsuTrans: String;
    FnsuHost: String;
    FnParcelas: Integer;
    FinfAdCard: String;
  public
    procedure Assign(Source: TpagCollectionItem);
    property tPag: TFormaPagamento read FtPag write FtPag;
    property xPag: String read FxPag write FxPag;
    property nDocPag: String read FnDocPag write FnDocPag;
    property vPag: Currency read FvPag write FvPag;
    property tpIntegra: TtpIntegra read FtpIntegra write FtpIntegra;
    property CNPJ: String read FCNPJ write FCNPJ;
    property tBand: TBandeiraCard read FtBand write FtBand;
    property xBand: String read FxBand write FxBand;
    property cAut: String read FcAut write FcAut;
    property nsuTrans: String read FnsuTrans write FnsuTrans;
    property nsuHost: String read FnsuHost write FnsuHost;
    property nParcelas: Integer read FnParcelas write FnParcelas;
    property infAdCard: String read FinfAdCard write FinfAdCard;
  end;

  TautXMLCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TautXMLCollectionItem;
    procedure SetItem(Index: Integer; Value: TautXMLCollectionItem);
  public
    function Add: TautXMLCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TautXMLCollectionItem;
    property Items[Index: Integer]: TautXMLCollectionItem read GetItem write SetItem; default;
  end;

  TautXMLCollectionItem = class(TObject)
  private
    FCNPJCPF: String;
  public
    procedure Assign(Source: TautXMLCollectionItem);
    property CNPJCPF: String read FCNPJCPF write FCNPJCPF;
  end;

  TInfAdic = class(TObject)
  private
    FinfAdFisco: String;
    FinfCpl: String;
  public
    procedure Assign(Source: TInfAdic);
    property infAdFisco: String read FinfAdFisco write FinfAdFisco;
    property infCpl: String read FinfCpl write FinfCpl;
  end;

  TinfBPeSupl = class(TObject)
  private
    FqrCodBPe: String;
    FboardPassBPe: String;
  public
    procedure Assign(Source: TinfBPeSupl);
    property qrCodBPe: String read FqrCodBPe write FqrCodBPe;
    property boardPassBPe: String read FboardPassBPe write FboardPassBPe;
  end;

const
  CMUN_EXTERIOR = 9999999;
  XMUN_EXTERIOR = 'EXTERIOR';
  UF_EXTERIOR = 'EX';

implementation

uses
  ACBrUtil, pcnBPeR;

procedure TBPe.Assign(Source: TBPe);
begin
  infBPe.Assign(Source.infBPe);
  Ide.Assign(Source.Ide);
  Emit.Assign(Source.Emit);
  Comp.Assign(Source.Comp);
  Agencia.Assign(Source.Agencia);
  infBPeSub.Assign(Source.infBPeSub);
  infPassagem.Assign(Source.infPassagem);
  infViagem.Assign(Source.infViagem);
  infValorBPe.Assign(Source.infValorBPe);
  Imp.Assign(Source.Imp);
  infBPeSupl.Assign(Source.infBPeSupl);
  Signature.Assign(Source.Signature);
  procBPe.Assign(Source.procBPe);
end;

procedure TBPe.SetXMLString(const AValue: AnsiString);
var
 LocBPeR : TBPeR;
begin
  LocBPeR := TBPeR.Create(Self);
  try
    LocBPeR.Leitor.Arquivo := AValue;
    LocBPeR.LerXml;
  finally
    LocBPeR.Free
  end;
end;

constructor TBPe.Create;
begin
  inherited Create;
  FinfBPe      := TinfBPe.Create;
  FIde         := TIde.Create;
  FEmit        := TEmit.Create;
  FComp        := TComp.Create;
  FAgencia     := TAgencia.Create;
  FinfBPeSub   := TinfBPeSub.Create;
  FinfPassagem := TinfPassagem.Create;
  FinfViagem   := TInfViagemCollection.Create;
  FinfValorBPe := TinfValorBPe.Create;
  FImp         := TImp.Create;
  Fpag         := TpagCollection.Create;
  FautXML      := TautXMLCollection.Create;
  FinfAdic     := TinfAdic.Create;
  FinfBPeSupl  := TinfBPeSupl.Create;
  FSignature   := TSignature.create;
  FProcBPe     := TProcBPe.create;
  FinfRespTec  := TinfRespTec.Create;

  FinfBPe.Versao := 0;
end;

destructor TBPe.Destroy;
begin
  FinfBPe.Free;
  FIde.Free;
  FEmit.Free;
  FComp.Free;
  FAgencia.Free;
  FinfBPeSub.Free;
  FinfPassagem.Free;
  FinfViagem.Free;
  FinfValorBPe.Free;
  FImp.Free;
  Fpag.Free;
  FautXML.Free;
  FinfAdic.Free;
  FinfBPeSupl.Free;
  FSignature.Free;
  FProcBPe.Free;
  FinfRespTec.Free;

  inherited Destroy;
end;

procedure TBPe.SetInfViagem(const Value: TInfViagemCollection);
begin
  FinfViagem := Value;
end;

procedure TBPe.SetPag(Value: TpagCollection);
begin
  Fpag.Assign(Value);
end;

procedure TBPe.SetautXML(const Value: TautXMLCollection);
begin
  FautXML := Value;
end;

{ TinfBPe }

procedure TinfBPe.Assign(Source: TinfBPe);
begin
  ID     := Source.ID;
  Versao := Source.Versao;
end;

function TinfBPe.GetVersao: Real;
begin
  if FVersao <= 0 then
     Result := 1
  else
     Result := FVersao;
end;

function TinfBPe.GetVersaoStr: String;
begin
  if FVersao <= 0 then
     Result := V1_00
  else
     Result := 'versao="' + FloatToString(FVersao, '.', '#0.00') + '"';
end;

{Ide}

procedure TIde.Assign(Source: TIde);
begin
  cUF     := Source.cUF;
  tpAmb   := Source.tpAmb;
  modelo  := Source.modelo;
  serie   := Source.serie;
  nBP     := Source.nBP;
  cBP     := Source.cBP;
  cDV     := Source.cDV;
  Modal   := Source.modal;
  dhEmi   := Source.dhEmi;
  tpEmis  := Source.tpEmis;
  verProc := Source.verProc;
  tpBPe   := Source.tpBPe;
  indPres := Source.indPres;
  UFIni   := Source.UFIni;
  cMunIni := Source.cMunIni;
  UFFim   := Source.UFFim;
  cMunFim := Source.cMunFim;
  dhCont  := Source.dhCont;
  xJust   := Source.xJust;
end;

{Emit}

procedure TEmit.Assign(Source: TEmit);
begin
  CNPJ  := Source.CNPJ;
  IE    := Source.IE;
  IEST  := Source.IEST;
  xNome := Source.xNome;
  xFant := Source.xFant;
  IM    := Source.IM;
  CNAE  := Source.CNAE;
  CRT   := Source.CRT;
  EnderEmit.Assign(Source.EnderEmit);
  TAR   := Source.TAR;
end;

constructor TEmit.Create;
begin
  inherited Create;
  FEnderEmit := TEnderEmit.Create;
  FCRT:= crtRegimeNormal;
end;

destructor TEmit.Destroy;
begin
  FEnderEmit.Free;
  inherited;
end;

{ TenderEmit }

procedure TenderEmit.Assign(Source: TEnderEmit);
begin
  xLgr    := Source.xLgr;
  nro     := Source.nro;
  xCpl    := Source.xCpl;
  xBairro := Source.xBairro;
  cMun    := Source.cMun;
  xMun    := Source.xMun;
  CEP     := Source.CEP;
  UF      := Source.UF;
  fone    := Source.fone;
  Email   := Source.Email;
end;

{ TComp }

procedure TComp.Assign(Source: TComp);
begin
  xNome         := Source.xNome;
  CNPJCPF       := Source.CNPJCPF;
  idEstrangeiro := Source.idEstrangeiro;
  IE            := Source.IE;
  EnderComp.Assign(Source.EnderComp);

end;

constructor TComp.Create;
begin
  inherited Create;
  FEnderComp := TEnderComp.Create;
end;

destructor TComp.Destroy;
begin
  FEnderComp.Free;
  inherited;
end;

{ TEnderComp }

procedure TEnderComp.Assign(Source: TEnderComp);
begin
  xLgr    := Source.xLgr;
  nro     := Source.nro;
  xCpl    := Source.xCpl;
  xBairro := Source.xBairro;
  cMun    := Source.cMun;
  xMun    := Source.xMun;
  UF      := Source.UF;
  CEP     := Source.CEP;
  cPais   := Source.cPais;
  xPais   := Source.xPais;
  fone    := Source.fone;
  Email   := Source.Email;
end;

{ TAgencia }

procedure TAgencia.Assign(Source: TAgencia);
begin
  xNome := Source.xNome;
  CNPJ  := Source.CNPJ;
  EnderAgencia.Assign(Source.EnderAgencia);
end;

constructor TAgencia.Create;
begin
  inherited Create;
  FEnderAgencia := TEnderComp.Create;
end;

destructor TAgencia.Destroy;
begin
  FEnderAgencia.Free;
  inherited;
end;

{ TinfBPeSub }

procedure TinfBPeSub.Assign(Source: TinfBPeSub);
begin
  chBPe := Source.chBPe;
  tpSub := Source.tpSub;
end;

{ TinfPassagem }

procedure TinfPassagem.Assign(Source: TinfPassagem);
begin
  cLocOrig   := Source.cLocOrig;
  xLocOrig   := Source.xLocOrig;
  cLocDest   := Source.cLocDest;
  xLocDest   := Source.xLocDest;
  dhEmb      := Source.dhEmb;
  dhValidade := Source.dhValidade;
  infPassageiro.Assign(Source.infPassageiro);
end;

constructor TinfPassagem.Create;
begin
  inherited Create;
  FinfPassageiro := TinfPassageiro.Create;
end;

destructor TinfPassagem.Destroy;
begin
  FinfPassageiro.Free;
  inherited;
end;

{ TinfPassageiro }

procedure TinfPassageiro.Assign(Source: TinfPassageiro);
begin
  xNome := Source.xNome;
  CPF   := Source.CPF;
  tpDoc := Source.tpDoc;
  nDoc  := Source.nDoc;
  xDoc  := Source.xDoc;
  dNasc := Source.dNasc;
  Fone  := Source.Fone;
  Email := Source.Email;
end;

{ TInfViagemCollection }

function TInfViagemCollection.GetItem(Index: Integer): TInfViagemCollectionItem;
begin
  Result := TInfViagemCollectionItem(inherited GetItem(Index));
end;

procedure TInfViagemCollection.SetItem(Index: Integer; Value: TInfViagemCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TInfViagemCollection.Add: TInfViagemCollectionItem;
begin
  Result := Self.New;
end;

function TInfViagemCollection.New: TInfViagemCollectionItem;
begin
  Result := TInfViagemCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfViagemCollectionItem }

procedure TInfViagemCollectionItem.Assign(Source: TInfViagemCollectionItem);
begin
  cPercurso    := Source.cPercurso;
  xPercurso    := Source.xPercurso;
  tpViagem     := Source.tpViagem;
  tpServ       := Source.tpServ;
  tpAcomodacao := Source.tpAcomodacao;
  tpTrecho     := Source.tpTrecho;
  dhViagem     := Source.dhViagem;
  dhConexao    := Source.dhConexao;
  Prefixo      := Source.Prefixo;
  Poltrona     := Source.Poltrona;
  Plataforma   := Source.Plataforma;
  infTravessia.Assign(Source.infTravessia);
end;

constructor TInfViagemCollectionItem.Create;
begin
  inherited;
  FinfTravessia := TinfTravessia.Create;
end;

destructor TInfViagemCollectionItem.Destroy;
begin
  FinfTravessia.Free;
  inherited;
end;

{ TinfTravessia }

procedure TinfTravessia.Assign(Source: TinfTravessia);
begin
  tpVeiculo  := Source.tpVeiculo;
  sitVeiculo := Source.sitVeiculo;
end;

{ TinfValorBPe }

procedure TinfValorBPe.Assign(Source: TinfValorBPe);
begin
  vBP        := Source.vBP;
  vDesconto  := Source.vDesconto;
  vPgto      := Source.vPgto;
  vTroco     := Source.vTroco;
  tpDesconto := Source.tpDesconto;
  xDesconto  := Source.xDesconto;
  cDesconto  := Source.cDesconto;
  Comp       := Source.Comp;
end;

constructor TinfValorBPe.Create;
begin
  inherited Create;
  FComp := TCompCollection.Create;
end;

destructor TinfValorBPe.Destroy;
begin
  FComp.Free;

  inherited Destroy;
end;

procedure TinfValorBPe.SetComp(const Value: TCompCollection);
begin
  FComp := Value;
end;

{ TCompCollection }

function TCompCollection.Add: TCompCollectionItem;
begin
  Result := Self.New;
end;

function TCompCollection.GetItem(Index: Integer): TCompCollectionItem;
begin
  Result := TCompCollectionItem(inherited GetItem(Index));
end;

procedure TCompCollection.SetItem(Index: Integer; Value: TCompCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TCompCollection.New: TCompCollectionItem;
begin
  Result := TCompCollectionItem.Create;
  Self.Add(Result);
end;

{ TCompCollectionItem }

procedure TCompCollectionItem.Assign(Source: TCompCollectionItem);
begin
  tpComp := Source.FtpComp;
  vComp  := Source.vComp;
end;

{ TImp }

procedure TImp.Assign(Source: TImp);
begin
  ICMS       := Source.ICMS;
  vTotTrib   := Source.vTotTrib;
  infAdFisco := Source.infAdFisco;
  ICMSUFFim  := Source.ICMSUFFim;
end;

constructor TImp.Create;
begin
  inherited Create;
  FICMS := TICMS.Create;
  FICMSUFFim := TICMSUFFim.Create;
end;

destructor TImp.Destroy;
begin
  FICMS.Free;
  FICMSUFFim.Free;
  inherited;
end;

{ TICMS }

procedure TICMS.Assign(Source: TICMS);
begin
  CST           := Source.CST;
  vBC           := Source.vBC;
  pICMS         := Source.pICMS;
  vICMS         := Source.vICMS;
  pRedBC        := Source.pRedBC;
  vCred         := Source.vCred;
  pRedBCOutraUF := Source.pRedBCOutraUF;
  vBCOutraUF    := Source.vBCOutraUF;
  pICMSOutraUF  := Source.pICMSOutraUF;
  vICMSOutraUF  := Source.vICMSOutraUF;
end;

{ TICMSUFFim }

procedure TICMSUFFim.Assign(Source: TICMSUFFim);
begin
  vBCUFFim       := Source.vBCUFFim;
  pFCPUFFim      := Source.pFCPUFFim;
  pICMSUFFim     := Source.pICMSUFFim;
  pICMSInter     := Source.pICMSInter;
  pICMSInterPart := Source.pICMSInterPart;
  vFCPUFFim      := Source.vFCPUFFim;
  vICMSUFFim     := Source.vICMSUFFim;
  vICMSUFIni     := Source.vICMSUFIni;
end;

{ TpagCollection }

function TpagCollection.Add: TpagCollectionItem;
begin
  Result := Self.New;
end;

function TpagCollection.GetItem(Index: Integer): TpagCollectionItem;
begin
  Result := TpagCollectionItem(inherited GetItem(Index));
end;

procedure TpagCollection.SetItem(Index: Integer;
  Value: TpagCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TpagCollection.New: TpagCollectionItem;
begin
  Result := TpagCollectionItem.Create;
  Self.Add(Result);
end;

{ TpagCollectionItem }

procedure TpagCollectionItem.Assign(Source: TpagCollectionItem);
begin
  tPag      := Source.tPag;
  xPag      := Source.xPag;
  nDocPag   := Source.nDocPag;
  vPag      := Source.vPag;
  tpIntegra := Source.tpIntegra;
  CNPJ      := Source.CNPJ;
  tBand     := Source.tBand;
  xBand     := Source.xBand;
  cAut      := Source.cAut;
  nsuTrans  := Source.nsuTrans;
  nsuHost   := Source.nsuHost;
  nParcelas := Source.nParcelas;
  infAdCard := Source.infAdCard;
end;

{ TautXMLCollection }

function TautXMLCollection.Add: TautXMLCollectionItem;
begin
  Result := Self.New;
end;

function TautXMLCollection.GetItem(Index: Integer): TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem(inherited GetItem(Index));
end;

procedure TautXMLCollection.SetItem(Index: Integer;
  Value: TautXMLCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TautXMLCollection.New: TautXMLCollectionItem;
begin
  Result := TautXMLCollectionItem.Create;
  Self.Add(Result);
end;

{ TautXMLCollectionItem }

procedure TautXMLCollectionItem.Assign(Source: TautXMLCollectionItem);
begin
  CNPJCPF := Source.CNPJCPF;
end;

{infAdic}

procedure TInfAdic.Assign(Source: TInfAdic);
begin
  infAdFisco := Source.infAdFisco;
  infCpl     := Source.infCpl;
end;

{ TinfBPeSupl }

procedure TinfBPeSupl.Assign(Source: TinfBPeSupl);
begin
  qrCodBPe     := Source.qrCodBPe;
  boardPassBPe := Source.boardPassBPe;
end;

{ TinfRespTec }

procedure TinfRespTec.Assign(Source: TinfRespTec);
begin
  CNPJ     := Source.CNPJ;
  xContato := Source.xContato;
  email    := Source.email;
  fone     := Source.fone;
  idCSRT   := Source.idCSRT;
  hashCSRT := Source.hashCSRT;
end;

end.

