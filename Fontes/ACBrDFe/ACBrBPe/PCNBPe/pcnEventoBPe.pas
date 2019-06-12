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

unit pcnEventoBPe;

interface

uses
  SysUtils, Classes, Contnrs,
  pcnConversao, pcnConversaoBPe;

type
  TRetchBPePendCollection     = class;
  TRetchBPePendCollectionItem = class;

  TDetEvento      = class;
  TRetInfEvento   = class;
  EventoException = class(Exception);

  TitemPedidoCollection  = class;
  TitemPedidoCollectionItem = class;

  TInfEvento = class
  private
    FID: String;
    FtpAmbiente: TpcnTipoAmbiente;
    FCNPJ: String;
    FcOrgao: Integer;
    FChave: String;
    FDataEvento: TDateTime;
    FTpEvento: TpcnTpEvento;
    FnSeqEvento: Integer;
    FVersaoEvento: String;
    FDetEvento: TDetEvento;

    function getcOrgao: Integer;
    function getDescEvento: String;
    function getTipoEvento: String;
  public
    constructor Create;
    destructor Destroy; override;
    function DescricaoTipoEvento(TipoEvento:TpcnTpEvento): String;

    property id: String              read FID             write FID;
    property cOrgao: Integer         read getcOrgao       write FcOrgao;
    property tpAmb: TpcnTipoAmbiente read FtpAmbiente     write FtpAmbiente;
    property CNPJ: String            read FCNPJ           write FCNPJ;
    property chBPe: String           read FChave          write FChave;
    property dhEvento: TDateTime     read FDataEvento     write FDataEvento;
    property tpEvento: TpcnTpEvento  read FTpEvento       write FTpEvento;
    property nSeqEvento: Integer     read FnSeqEvento     write FnSeqEvento;
    property versaoEvento: String    read FVersaoEvento write FversaoEvento;
    property detEvento: TDetEvento   read FDetEvento      write FDetEvento;
    property DescEvento: String      read getDescEvento;
    property TipoEvento: String      read getTipoEvento;
  end;

  TDestinatario = class(TObject)
  private
    FUF: String;
    FCNPJCPF: String;
    FidEstrangeiro: String;
    FIE: String;
  public
    property UF: String            read FUF            write FUF;
    property CNPJCPF: String       read FCNPJCPF       write FCNPJCPF;
    property idEstrangeiro: String read FidEstrangeiro write FidEstrangeiro;
    property IE: String            read FIE            write FIE;
  end;

  TitemPedidoCollectionItem = class(TObject)
  private
    FqtdeItem: Currency;
    FnumItem: Integer;
  public
    property numItem: Integer   read FnumItem  write FnumItem;
    property qtdeItem: Currency read FqtdeItem write FqtdeItem;
  end;

  TitemPedidoCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TitemPedidoCollectionItem;
    procedure SetItem(Index: Integer; Value: TitemPedidoCollectionItem);
  public
    function Add: TitemPedidoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TitemPedidoCollectionItem;
    property Items[Index: Integer]: TitemPedidoCollectionItem read GetItem write SetItem; default;
  end;

  TDetEvento = class
  private
    FVersao: String;
    FDescEvento: String;
    FCorrecao: String;     // Carta de Corre��o
    FCondUso: String;      // Carta de Corre��o
    FnProt: String;        // Cancelamento
    FxJust: String;        // Cancelamento e Manif. Destinatario
    FcOrgaoAutor: Integer; // EPEC
    FtpAutor: TpcnTipoAutor;
    FverAplic: String;
    FdhEmi: TDateTime;
    FtpBPe: TTipoBPe;
    FIE: String;
    Fdest: TDestinatario;
    FvNF: Currency;
    FvICMS: Currency;
    FvST: Currency;
    FitemPedido: TitemPedidoCollection;
    FidPedidoCancelado: String;
    Fpoltrona: Integer;

    procedure setCondUso(const Value: String);
    procedure SetitemPedido(const Value: TitemPedidoCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property versao: String         read FVersao      write FVersao;
    property descEvento: String     read FDescEvento  write FDescEvento;
    property xCorrecao: String      read FCorrecao    write FCorrecao;
    property xCondUso: String       read FCondUso     write setCondUso;
    property nProt: String          read FnProt       write FnProt;
    property xJust: String          read FxJust       write FxJust;
    property cOrgaoAutor: Integer   read FcOrgaoAutor write FcOrgaoAutor;
    property tpAutor: TpcnTipoAutor read FtpAutor     write FtpAutor;
    property verAplic: String       read FverAplic    write FverAplic;
    property dhEmi: TDateTime       read FdhEmi       write FdhEmi;
    property tpBPe: TTipoBPe        read FtpBPe       write FtpBPe;
    property IE: String             read FIE          write FIE;
    property dest: TDestinatario    read Fdest        write Fdest;
    property vNF: Currency          read FvNF         write FvNF;
    property vICMS: Currency        read FvICMS       write FvICMS;
    property vST: Currency          read FvST         write FvST;
    property itemPedido: TitemPedidoCollection read FitemPedido write SetitemPedido;
    property idPedidoCancelado: String read FidPedidoCancelado write FidPedidoCancelado;
    property poltrona: Integer      read Fpoltrona    write Fpoltrona;
  end;

  TRetchBPePendCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TRetchBPePendCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetchBPePendCollectionItem);
  public
    function Add: TRetchBPePendCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetchBPePendCollectionItem;
    property Items[Index: Integer]: TRetchBPePendCollectionItem read GetItem write SetItem; default;
  end;

  TRetchBPePendCollectionItem = class(TObject)
  private
    FChavePend: String;
  public
    property ChavePend: String read FChavePend write FChavePend;
  end;

  { TRetInfEvento }

  TRetInfEvento = class(TObject)
  private
    FId: String;
    FNomeArquivo: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: String;
    FchBPe: String;
    FtpEvento: TpcnTpEvento;
    FxEvento: String;
    FnSeqEvento: Integer;
    FCNPJDest: String;
    FemailDest: String;
    FcOrgaoAutor: Integer;
    FdhRegEvento: TDateTime;
    FnProt: String;
    FchBPePend: TRetchBPePendCollection;
    FXML: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: String                         read FId          write FId;
    property tpAmb: TpcnTipoAmbiente            read FtpAmb       write FtpAmb;
    property verAplic: String                   read FverAplic    write FverAplic;
    property cOrgao: Integer                    read FcOrgao      write FcOrgao;
    property cStat: Integer                     read FcStat       write FcStat;
    property xMotivo: String                    read FxMotivo     write FxMotivo;
    property chBPe: String                      read FchBPe       write FchBPe;
    property tpEvento: TpcnTpEvento             read FtpEvento    write FtpEvento;
    property xEvento: String                    read FxEvento     write FxEvento;
    property nSeqEvento: Integer                read FnSeqEvento  write FnSeqEvento;
    property CNPJDest: String                   read FCNPJDest    write FCNPJDest;
    property emailDest: String                  read FemailDest   write FemailDest;
    property cOrgaoAutor: Integer               read FcOrgaoAutor write FcOrgaoAutor;
    property dhRegEvento: TDateTime             read FdhRegEvento write FdhRegEvento;
    property nProt: String                      read FnProt       write FnProt;
    property chBPePend: TRetchBPePendCollection read FchBPePend   write FchBPePend;
    property XML: AnsiString                    read FXML         write FXML;
    property NomeArquivo: String                read FNomeArquivo write FNomeArquivo;
  end;

implementation

{ TInfEvento }

constructor TInfEvento.Create;
begin
  inherited Create;
  FDetEvento := TDetEvento.Create;
end;

destructor TInfEvento.Destroy;
begin
  FDetEvento.Free;
  inherited;
end;

function TInfEvento.getcOrgao: Integer;
//  (AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO);
//  (12,27,16,13,29,23,53,32,52,21,51,50,31,15,25,41,26,22,33,24,43,11,14,42,35,28,17);
begin
  if FcOrgao <> 0 then
    Result := FcOrgao
  else
    Result := StrToIntDef(copy(FChave, 1, 2), 0);
end;

function TInfEvento.getDescEvento: String;
begin
  case fTpEvento of
    teCCe:               Result := 'Carta de Correcao';
    teCancelamento:      Result := 'Cancelamento';
    teNaoEmbarque:       Result := 'Nao Embarque';
    teAlteracaoPoltrona: Result := 'Alteracao de Poltrona';
  else
    Result := '';
  end;
end;

function TInfEvento.getTipoEvento: String;
begin
  try
    Result := TpEventoToStr( FTpEvento );
  except
    Result := '';
  end;
end;

function TInfEvento.DescricaoTipoEvento(TipoEvento: TpcnTpEvento): String;
begin
  case TipoEvento of
    teCCe:               Result := 'CARTA DE CORRE��O ELETR�NICA';
    teCancelamento:      Result := 'CANCELAMENTO DE BP-e';
    teNaoEmbarque:       Result := 'NAO EMBARQUE';
    teAlteracaoPoltrona: Result := 'ALTERACAO DE POLTRONA';
  else
    Result := 'N�o Definido';
  end;
end;

{ TDetEvento }

constructor TDetEvento.Create;
begin
  inherited Create;
  Fdest       := TDestinatario.Create;
  FitemPedido := TitemPedidoCollection.Create;
end;

destructor TDetEvento.Destroy;
begin
  Fdest.Free;
  FitemPedido.Free;
  inherited;
end;

procedure TDetEvento.setCondUso(const Value: String);
begin
  FCondUso := 'A Carta de Correcao e disciplinada pelo paragrafo 1o-A do' +
              ' art. 7o do Convenio S/N, de 15 de dezembro de 1970 e' +
              ' pode ser utilizada para regularizacao de erro ocorrido na' +
              ' emissao de documento fiscal, desde que o erro nao esteja' +
              ' relacionado com: I - as variaveis que determinam o valor' +
              ' do imposto tais como: base de calculo, aliquota, diferenca' +
              ' de preco, quantidade, valor da operacao ou da prestacao;' +
              ' II - a correcao de dados cadastrais que implique mudanca' +
              ' do remetente ou do destinatario; III - a data de emissao ou' +
              ' de saida.'
end;

procedure TDetEvento.SetitemPedido(const Value: TitemPedidoCollection);
begin
  FitemPedido := Value;
end;

{ TRetchBPePendCollection }

function TRetchBPePendCollection.Add: TRetchBPePendCollectionItem;
begin
  Result := Self.New;
end;

function TRetchBPePendCollection.GetItem(
  Index: Integer): TRetchBPePendCollectionItem;
begin
  Result := TRetchBPePendCollectionItem(inherited GetItem(Index));
end;

procedure TRetchBPePendCollection.SetItem(Index: Integer;
  Value: TRetchBPePendCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TRetchBPePendCollection.New: TRetchBPePendCollectionItem;
begin
  Result := TRetchBPePendCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetInfEvento }

constructor TRetInfEvento.Create;
begin
  inherited Create;
  FchBPePend := TRetchBPePendCollection.Create;
end;

destructor TRetInfEvento.Destroy;
begin
  FchBPePend.Free;
  inherited;
end;

{ TitemPedidoCollection }

function TitemPedidoCollection.Add: TitemPedidoCollectionItem;
begin
  Result := Self.New;
end;

function TitemPedidoCollection.GetItem(
  Index: Integer): TitemPedidoCollectionItem;
begin
  Result := TitemPedidoCollectionItem(inherited GetItem(Index));
end;

procedure TitemPedidoCollection.SetItem(Index: Integer;
  Value: TitemPedidoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TitemPedidoCollection.New: TitemPedidoCollectionItem;
begin
  Result := TitemPedidoCollectionItem.Create;
  Self.Add(Result);
end;

end.
