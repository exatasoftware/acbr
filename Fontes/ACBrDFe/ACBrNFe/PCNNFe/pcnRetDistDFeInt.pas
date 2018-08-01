////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
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

{$I ACBr.inc}

unit pcnRetDistDFeInt;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnConversaoNFe, pcnLeitor, synacode;

type
  TresNFe               = class;
  TresEvento            = class;
  TprocEvento           = class;
  TdocZipCollection     = class;
  TdocZipCollectionItem = class;
  TRetDistDFeInt        = class;

  TDetEventoCTe = class
  private
    FchCTe: String;
    Fmodal: TpcteModal;
    FdhEmi: TDateTime;
    FnProt: String;
    FdhRecbto: TDateTime;
  public
    property chCTe: String       read FchCTe    write FchCTe;
    property modal: TpcteModal   read Fmodal    write Fmodal;
    property dhEmi: TDateTime    read FdhEmi    write FdhEmi;
    property nProt: String       read FnProt    write FnProt;
    property dhRecbto: TDateTime read FdhRecbto write FdhRecbto;
  end;

  TDetEventoEmit = class
  private
    FCNPJ: String;
    FIE: String;
    FxNome: String;
  public
    property CNPJ: String  read FCNPJ  write FCNPJ;
    property IE: String    read FIE    write FIE;
    property xNome: String read FxNome write FxNome;
  end;

  TprocEvento_DetEvento = class
  private
    FVersao: String;
    FDescEvento: String;
    FnProt: String;
    FxJust: String;
    FxCorrecao: String;

    FCTe: TDetEventoCTe;
    Femit: TDetEventoEmit;
  public
    constructor Create(AOwner: TprocEvento);
    destructor Destroy; override;

    property versao: String     read FVersao     write FVersao;
    property descEvento: String read FDescEvento write FDescEvento;
    property nProt: String      read FnProt      write FnProt;
    property xJust: String      read FxJust      write FxJust;
    property xCorrecao: String  read FxCorrecao  write FxCorrecao;

    property CTe: TDetEventoCTe   read FCTe  write FCTe;
    property emit: TDetEventoEmit read Femit write Femit;
  end;

  TprocEvento_RetInfEvento = class
  private
    FId: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: String;
    FchNFe: String;
    FtpEvento: TpcnTpEvento;
    FxEvento: String;
    FnSeqEvento: Integer;
    FCNPJDest: String;
    FemailDest: String;
    FcOrgaoAutor: Integer;
    FdhRegEvento: TDateTime;
    FnProt: String;
  public
    property Id: String              read FId          write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb       write FtpAmb;
    property verAplic: String        read FverAplic    write FverAplic;
    property cOrgao: Integer         read FcOrgao      write FcOrgao;
    property cStat: Integer          read FcStat       write FcStat;
    property xMotivo: String         read FxMotivo     write FxMotivo;
    property chNFe: String           read FchNFe       write FchNFe;
    property tpEvento: TpcnTpEvento  read FtpEvento    write FtpEvento;
    property xEvento: String         read FxEvento     write FxEvento;
    property nSeqEvento: Integer     read FnSeqEvento  write FnSeqEvento;
    property CNPJDest: String        read FCNPJDest    write FCNPJDest;
    property emailDest: String       read FemailDest   write FemailDest;
    property cOrgaoAutor: Integer    read FcOrgaoAutor write FcOrgaoAutor;
    property dhRegEvento: TDateTime  read FdhRegEvento write FdhRegEvento;
    property nProt: String           read FnProt       write FnProt;
  end;

  TresNFe = class
  private
    FchNFe: String;
    FCNPJCPF: String;
    FxNome: String;
    FIE: String;
    FdhEmi: TDateTime;
    FtpNF: TpcnTipoNFe;
    FvNF: Currency;
    FdigVal: String;
    FdhRecbto: TDateTime;
    FnProt: String;
    FcSitNFe: TSituacaoDFe;
  public
    property chNFe: String            read FchNFe    write FchNFe;
    property CNPJCPF: String          read FCNPJCPF  write FCNPJCPF;
    property xNome: String            read FxNome    write FxNome;
    property IE: String               read FIE       write FIE;
    property dhEmi: TDateTime         read FdhEmi    write FdhEmi;
    property tpNF: TpcnTipoNFe        read FtpNF     write FtpNF;
    property vNF: Currency            read FvNF      write FvNF;
    property digVal: String           read FdigVal   write FdigVal;
    property dhRecbto: TDateTime      read FdhRecbto write FdhRecbto;
    property nProt: String            read FnProt    write FnProt;
    property cSitNFe: TSituacaoDFe    read FcSitNFe  write FcSitNFe;
  end;

  TresEvento = class
  private
    FcOrgao: Integer;
    FCNPJCPF: String;
    FchNFe: String;
    FdhEvento: TDateTime;
    FtpEvento: TpcnTpEvento;
    FnSeqEvento: ShortInt;
    FxEvento: String;
    FdhRecbto: TDateTime;
    FnProt: String;
  public
    property cOrgao: Integer        read FcOrgao     write FcOrgao;
    property CNPJCPF: String        read FCNPJCPF    write FCNPJCPF;
    property chNFe: String          read FchNFe      write FchNFe;
    property dhEvento: TDateTime    read FdhEvento   write FdhEvento;
    property tpEvento: TpcnTpEvento read FtpEvento   write FtpEvento;
    property nSeqEvento: ShortInt   read FnSeqEvento write FnSeqEvento;
    property xEvento: String        read FxEvento    write FxEvento;
    property dhRecbto: TDateTime    read FdhRecbto   write FdhRecbto;
    property nProt: String          read FnProt      write FnProt;
  end;

  TprocEvento = class
  private
    FId: String;
    FcOrgao: Integer;
    FtpAmb: TpcnTipoAmbiente;
    FCNPJ: String;
    FchNFe: String;
    FdhEvento: TDateTime;
    FtpEvento: TpcnTpEvento;
    FnSeqEvento: Integer;
    FverEvento: String;

    FDetEvento: TprocEvento_DetEvento;
    FRetInfEvento: TprocEvento_RetInfEvento;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: String              read FId             write FId;
    property cOrgao: Integer         read FcOrgao         write FcOrgao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb          write FtpAmb;
    property CNPJ: String            read FCNPJ           write FCNPJ;
    property chNFe: String           read FchNFe          write FchNFe;
    property dhEvento: TDateTime     read FdhEvento       write FdhEvento;
    property tpEvento: TpcnTpEvento  read FtpEvento       write FtpEvento;
    property nSeqEvento: Integer     read FnSeqEvento     write FnSeqEvento;
    property verEvento: String       read FverEvento      write FverEvento;

    property detEvento: TprocEvento_DetEvento read FDetEvento write FDetEvento;
    property RetinfEvento: TprocEvento_RetInfEvento read FRetInfEvento write FRetInfEvento;
  end;

  TdocZipCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TdocZipCollectionItem;
    procedure SetItem(Index: Integer; Value: TdocZipCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TdocZipCollectionItem;
    property Items[Index: Integer]: TdocZipCollectionItem read GetItem write SetItem; default;
  end;

  TdocZipCollectionItem = class(TCollectionItem)
  private
    // Atributos do resumo da NFe ou Evento
    FNSU: String;
    Fschema: TSchemaNFe;

    // A propriedade InfZip contem a informa��o Resumida ou documento fiscal
    // eletr�nico Compactado no padr�o gZip
    FInfZip: String;

    // Resumos e Processamento de Eventos Descompactados
    FresNFe: TresNFe;
    FresEvento: TresEvento;
    FprocEvento: TprocEvento;

    // XML do Resumo ou Documento descompactado
    FXML: String;

  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property NSU: String             read FNSU        write FNSU;
    property schema: TSchemaNFe      read Fschema     write Fschema;
    property InfZip: String          read FInfZip     write FInfZip;
    property resNFe: TresNFe         read FresNFe     write FresNFe;
    property resEvento: TresEvento   read FresEvento  write FresEvento;
    property procEvento: TprocEvento read FprocEvento write FprocEvento;
    property XML: String             read FXML        write FXML;
  end;

  TRetDistDFeInt = class(TPersistent)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhResp: TDateTime;
    FultNSU: String;
    FmaxNSU: String;
    FXML: AnsiString;
    FdocZip: TdocZipCollection;

    procedure SetdocZip(const Value: TdocZipCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
    function LerXMLFromFile(CaminhoArquivo: String): Boolean;
  published
    property Leitor: TLeitor           read FLeitor   write FLeitor;
    property versao: String            read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente   read FtpAmb    write FtpAmb;
    property verAplic: String          read FverAplic write FverAplic;
    property cStat: Integer            read FcStat    write FcStat;
    property xMotivo: String           read FxMotivo  write FxMotivo;
    property dhResp: TDateTime         read FdhResp   write FdhResp;
    property ultNSU: String            read FultNSU   write FultNSU;
    property maxNSU: String            read FmaxNSU   write FmaxNSU;
    property docZip: TdocZipCollection read FdocZip   write SetdocZip;
    property XML: AnsiString           read FXML      write FXML;
  end;

implementation

uses 
  pcnAuxiliar,
  ACBrUtil, pcnGerador;

{ TprocEvento_DetEvento }

constructor TprocEvento_DetEvento.Create(AOwner: TprocEvento);
begin
  CTe  := TDetEventoCTe.Create;
  emit := TDetEventoEmit.Create;
end;

destructor TprocEvento_DetEvento.Destroy;
begin
  CTe.Free;
  emit.Free;
  inherited;
end;

{ TprocEvento }

constructor TprocEvento.Create;
begin
  FdetEvento    := TprocEvento_detEvento.Create(Self);
  FRetInfEvento := TprocEvento_RetInfEvento.Create;
end;

destructor TprocEvento.Destroy;
begin
  FdetEvento.Free;
  FRetInfEvento.Free;
  inherited;
end;

{ TdocZipCollection }

function TdocZipCollection.Add: TdocZipCollectionItem;
begin
  Result := TdocZipCollectionItem(inherited Add);
  Result.create;
end;

constructor TdocZipCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TdocZipCollectionItem);
end;

function TdocZipCollection.GetItem(Index: Integer): TdocZipCollectionItem;
begin
  Result := TdocZipCollectionItem(inherited GetItem(Index));
end;

procedure TdocZipCollection.SetItem(Index: Integer;
  Value: TdocZipCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TdocZipCollectionItem }

constructor TdocZipCollectionItem.Create;
begin
  FresNFe     := TresNFe.Create;
  FresEvento  := TresEvento.Create;
  FprocEvento := TprocEvento.Create;
end;

destructor TdocZipCollectionItem.Destroy;
begin
  FresNFe.Free;
  FresEvento.Free;
  FprocEvento.Free;
  inherited;
end;

{ TRetDistDFeInt }

constructor TRetDistDFeInt.Create;
begin
  FLeitor := TLeitor.Create;
  FdocZip := TdocZipCollection.Create(Self);
end;

destructor TRetDistDFeInt.Destroy;
begin
  FLeitor.Free;
  FdocZip.Free;
  inherited;
end;

procedure TRetDistDFeInt.SetdocZip(const Value: TdocZipCollection);
begin
  FdocZip := Value;
end;

function TRetDistDFeInt.LerXml: boolean;
var
  ok: boolean;
  i: Integer;
  StrAux, StrDecod: AnsiString;
  oLeitorInfZip: TLeitor;
begin
  Result := False;

  try
    FXML := Self.Leitor.Arquivo;

    if (Leitor.rExtrai(1, 'retDistDFeInt') <> '') then
    begin
      Fversao   := Leitor.rAtributo('versao');
      FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      FcStat    := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
      FdhResp   := Leitor.rCampo(tcDatHor, 'dhResp');
      FultNSU   := Leitor.rCampo(tcStr, 'ultNSU');
      FmaxNSU   := Leitor.rCampo(tcStr, 'maxNSU');

      i := 0;
      while Leitor.rExtrai(2, 'docZip', '', i + 1) <> '' do
      begin
        FdocZip.Add;
        FdocZip.Items[i].FNSU   := Leitor.rAtributo('NSU');
        FdocZip.Items[i].schema := StrToSchemaNFe(ok, Leitor.rAtributo('schema'));

        StrAux := RetornarConteudoEntre(Leitor.Grupo, '>', '</docZip');
        StrDecod := DecodeBase64(StrAux);
        FdocZip.Items[i].FInfZip := UnZip(StrDecod);

        oLeitorInfZip := TLeitor.Create;
        try
          oLeitorInfZip.Arquivo := FdocZip.Items[i].FInfZip;

          if (oLeitorInfZip.rExtrai(1, 'resNFe') <> '') then
          begin
            FdocZip.Items[i].XML := IIF(Pos(ENCODING_UTF8, oLeitorInfZip.Grupo) > 0, '', '<' + ENCODING_UTF8 + '>') + oLeitorInfZip.Grupo;

            FdocZip.Items[i].FresNFe.chNFe    := oLeitorInfZip.rCampo(tcStr, 'chNFe');
            FdocZip.Items[i].FresNFe.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CNPJ');

            if FdocZip.Items[i].FresNFe.FCNPJCPF = '' then
              FdocZip.Items[i].FresNFe.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CPF');

            FdocZip.Items[i].FresNFe.FxNome    := oLeitorInfZip.rCampo(tcStr, 'xNome');
            FdocZip.Items[i].FresNFe.FIE       := oLeitorInfZip.rCampo(tcStr, 'IE');
            FdocZip.Items[i].FresNFe.FdhEmi    := oLeitorInfZip.rCampo(tcDatHor, 'dhEmi');
            FdocZip.Items[i].FresNFe.FtpNF     := StrToTpNF(ok, oLeitorInfZip.rCampo(tcStr, 'tpNF'));
            FdocZip.Items[i].FresNFe.FvNF      := oLeitorInfZip.rCampo(tcDe2, 'vNF');
            FdocZip.Items[i].FresNFe.FdigVal   := oLeitorInfZip.rCampo(tcStr, 'digVal');
            FdocZip.Items[i].FresNFe.FdhRecbto := oLeitorInfZip.rCampo(tcDatHor, 'dhRecbto');
            FdocZip.Items[i].FresNFe.FnProt    := oLeitorInfZip.rCampo(tcStr, 'nProt');
            FdocZip.Items[i].FresNFe.FcSitNFe  := StrToSituacaoDFe(ok, oLeitorInfZip.rCampo(tcStr, 'cSitNFe'));
          end;

          if (oLeitorInfZip.rExtrai(1, 'resEvento') <> '') then
          begin
            FdocZip.Items[i].XML := IIF(Pos(ENCODING_UTF8, oLeitorInfZip.Grupo) > 0, '', '<' + ENCODING_UTF8 + '>') + oLeitorInfZip.Grupo;

            FdocZip.Items[i].FresEvento.FcOrgao  := oLeitorInfZip.rCampo(tcInt, 'cOrgao');
            FdocZip.Items[i].FresEvento.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CNPJ');

            if FdocZip.Items[i].FresEvento.FCNPJCPF = '' then
              FdocZip.Items[i].FresEvento.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CPF');

            FdocZip.Items[i].FresEvento.chNFe       := oLeitorInfZip.rCampo(tcStr, 'chNFe');
            FdocZip.Items[i].FresEvento.FdhEvento   := oLeitorInfZip.rCampo(tcDatHor, 'dhEvento');
            FdocZip.Items[i].FresEvento.FtpEvento   := StrToTpEvento(ok, oLeitorInfZip.rCampo(tcStr, 'tpEvento'));
            FdocZip.Items[i].FresEvento.FnSeqEvento := oLeitorInfZip.rCampo(tcInt, 'nSeqEvento');
            FdocZip.Items[i].FresEvento.FxEvento    := oLeitorInfZip.rCampo(tcStr, 'xEvento');
            FdocZip.Items[i].FresEvento.FdhRecbto   := oLeitorInfZip.rCampo(tcDatHor, 'dhRecbto');
            FdocZip.Items[i].FresEvento.FnProt      := oLeitorInfZip.rCampo(tcStr, 'nProt');
          end;

          if (oLeitorInfZip.rExtrai(1, 'nfeProc') <> '') then
          begin
            FdocZip.Items[i].XML := IIF(Pos(ENCODING_UTF8, oLeitorInfZip.Grupo) > 0, '', '<' + ENCODING_UTF8 + '>') + oLeitorInfZip.Grupo;

            oLeitorInfZip.rExtrai(1, 'infNFe');
            FdocZip.Items[i].FresNFe.chNFe := copy(oLeitorInfZip.Grupo, pos('Id="NFe', oLeitorInfZip.Grupo)+7, 44);

            oLeitorInfZip.rExtrai(1, 'emit');
            FdocZip.Items[i].FresNFe.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CNPJ');
            if FdocZip.Items[i].FresNFe.FCNPJCPF = '' then
              FdocZip.Items[i].FresNFe.FCNPJCPF := oLeitorInfZip.rCampo(tcStr, 'CPF');

            FdocZip.Items[i].FresNFe.FxNome := oLeitorInfZip.rCampo(tcStr, 'xNome');
            FdocZip.Items[i].FresNFe.FIE    := oLeitorInfZip.rCampo(tcStr, 'IE');

            oLeitorInfZip.rExtrai(1, 'ide');
            FdocZip.Items[i].FresNFe.FdhEmi := oLeitorInfZip.rCampo(tcDatHor, 'dhEmi');

            // Se for Vers�o 2.00 a data de emiss�o est� em dEmi
            if FdocZip.Items[i].FresNFe.FdhEmi = 0 then
              FdocZip.Items[i].FresNFe.FdhEmi := oLeitorInfZip.rCampo(tcDat, 'dEmi');

            FdocZip.Items[i].FresNFe.FtpNF := StrToTpNF(ok, oLeitorInfZip.rCampo(tcStr, 'tpNF'));

            oLeitorInfZip.rExtrai(1, 'total');
            FdocZip.Items[i].FresNFe.FvNF := oLeitorInfZip.rCampo(tcDe2, 'vNF');

            oLeitorInfZip.rExtrai(1, 'infProt');
            FdocZip.Items[i].FresNFe.digVal    := oLeitorInfZip.rCampo(tcStr, 'digVal');
            FdocZip.Items[i].FresNFe.FdhRecbto := oLeitorInfZip.rCampo(tcDatHor, 'dhRecbto');
            FdocZip.Items[i].FresNFe.FnProt    := oLeitorInfZip.rCampo(tcStr, 'nProt');

            case oLeitorInfZip.rCampo(tcInt, 'cStat') of
              100: FdocZip.Items[i].FresNFe.FcSitNFe := snAutorizado;
              101: FdocZip.Items[i].FresNFe.FcSitNFe := snCancelado;
              110: FdocZip.Items[i].FresNFe.FcSitNFe := snDenegado;
            end;
          end;

          if (oLeitorInfZip.rExtrai(1, 'procEventoNFe') <> '') then
          begin
            FdocZip.Items[i].XML := IIF(Pos(ENCODING_UTF8, oLeitorInfZip.Grupo) > 0, '', '<' + ENCODING_UTF8 + '>') + oLeitorInfZip.Grupo;

            FdocZip.Items[i].FprocEvento.FId         := oLeitorInfZip.rAtributo('Id');
            FdocZip.Items[i].FprocEvento.FcOrgao     := oLeitorInfZip.rCampo(tcInt, 'cOrgao');
            FdocZip.Items[i].FprocEvento.FtpAmb      := StrToTpAmb(ok, oLeitorInfZip.rCampo(tcStr, 'tpAmb'));
            FdocZip.Items[i].FprocEvento.FCNPJ       := oLeitorInfZip.rCampo(tcStr, 'CNPJ');
            FdocZip.Items[i].FprocEvento.FchNFe      := oLeitorInfZip.rCampo(tcStr, 'chNFe');
            FdocZip.Items[i].FprocEvento.FdhEvento   := oLeitorInfZip.rCampo(tcDatHor, 'dhEvento');
            FdocZip.Items[i].FprocEvento.FtpEvento   := StrToTpEvento(ok, oLeitorInfZip.rCampo(tcStr, 'tpEvento'));
            FdocZip.Items[i].FprocEvento.FnSeqEvento := oLeitorInfZip.rCampo(tcInt, 'nSeqEvento');
            FdocZip.Items[i].FprocEvento.FverEvento  := oLeitorInfZip.rCampo(tcStr, 'verEvento');

            if (oLeitorInfZip.rExtrai(2, 'detEvento') <> '') then
            begin
              FdocZip.Items[i].FprocEvento.detEvento.FVersao     := oLeitorInfZip.rAtributo('versao');
              FdocZip.Items[i].FprocEvento.detEvento.FnProt      := oLeitorInfZip.rCampo(tcStr, 'nProt');
              FdocZip.Items[i].FprocEvento.detEvento.FxJust      := oLeitorInfZip.rCampo(tcStr, 'xJust');
              FdocZip.Items[i].FprocEvento.detEvento.FxCorrecao  := oLeitorInfZip.rCampo(tcStr, 'xCorrecao');
              FdocZip.Items[i].FprocEvento.detEvento.FDescEvento := oLeitorInfZip.rCampo(tcStr, 'descEvento');

              if (oLeitorInfZip.rExtrai(3, 'CTe') <> '') then
              begin
                FdocZip.Items[i].FprocEvento.detEvento.FCTe.FchCTe    := oLeitorInfZip.rCampo(tcStr, 'chCTe');
                FdocZip.Items[i].FprocEvento.detEvento.FCTe.Fmodal    := StrToTpModal(ok, oLeitorInfZip.rCampo(tcStr, 'modal'));
                FdocZip.Items[i].FprocEvento.detEvento.FCTe.FdhEmi    := oLeitorInfZip.rCampo(tcDatHor, 'dhEmi');
                FdocZip.Items[i].FprocEvento.detEvento.FCTe.FnProt    := oLeitorInfZip.rCampo(tcStr, 'nProt');
                FdocZip.Items[i].FprocEvento.detEvento.FCTe.FdhRecbto := oLeitorInfZip.rCampo(tcDatHor, 'dhRecbto');
              end;

              if (oLeitorInfZip.rExtrai(3, 'emit') <> '') then
              begin
                FdocZip.Items[i].FprocEvento.detEvento.Femit.FCNPJ  := oLeitorInfZip.rCampo(tcStr, 'CNPJ');
                FdocZip.Items[i].FprocEvento.detEvento.Femit.FIE    := oLeitorInfZip.rCampo(tcStr, 'IE');
                FdocZip.Items[i].FprocEvento.detEvento.Femit.FxNome := oLeitorInfZip.rCampo(tcStr, 'xNome');
              end;
            end;

            if (oLeitorInfZip.rExtrai(2, 'retEvento') <> '') then
            begin
              FdocZip.Items[i].FprocEvento.RetinfEvento.FId          := oLeitorInfZip.rAtributo('Id');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FtpAmb       := StrToTpAmb(ok, oLeitorInfZip.rCampo(tcStr, 'tpAmb'));
              FdocZip.Items[i].FprocEvento.RetinfEvento.FverAplic    := oLeitorInfZip.rCampo(tcStr, 'verAplic');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FcOrgao      := oLeitorInfZip.rCampo(tcInt, 'cOrgao');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FcStat       := oLeitorInfZip.rCampo(tcInt, 'cStat');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FxMotivo     := oLeitorInfZip.rCampo(tcStr, 'xMotivo');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FchNFe       := oLeitorInfZip.rCampo(tcStr, 'chNFe');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FtpEvento    := StrToTpEvento(ok, oLeitorInfZip.rCampo(tcStr, 'tpEvento'));
              FdocZip.Items[i].FprocEvento.RetinfEvento.FxEvento     := oLeitorInfZip.rCampo(tcStr, 'xEvento');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FnSeqEvento  := oLeitorInfZip.rCampo(tcInt, 'nSeqEvento');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FCNPJDest    := oLeitorInfZip.rCampo(tcStr, 'CNPJDest');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FdhRegEvento := oLeitorInfZip.rCampo(tcDatHor, 'dhRegEvento');
              FdocZip.Items[i].FprocEvento.RetinfEvento.FnProt       := oLeitorInfZip.rCampo(tcStr, 'nProt');
            end;
          end;
        finally
          FreeAndNil(oLeitorInfZip);
        end;

        inc(i);
      end;

      Result := True;
    end;
  except
    on e : Exception do
    begin
//      result := False;
      Raise Exception.Create(e.Message);
    end;
  end;
end;

function TRetDistDFeInt.LerXMLFromFile(CaminhoArquivo: String): Boolean;
var
  ArqDist: TStringList;
begin
  ArqDist := TStringList.Create;
  try
     ArqDist.LoadFromFile(CaminhoArquivo);

     Self.Leitor.Arquivo := ArqDist.Text;

     Result := LerXml;
  finally
     ArqDist.Free;
  end;
end;

end.

