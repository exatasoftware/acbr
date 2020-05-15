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

unit pcnEnvEventoNFe;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  pcnConversao, pcnGerador, pcnEventoNFe, pcnConsts, pcnNFeConsts, pcnSignature,
  ACBrBase;

type
  EventoException          = class(Exception);

  TInfEventoCollectionItem = class;
  TEventoNFe               = class;

  TInfEventoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfEventoCollectionItem);
  public
    function Add: TInfEventoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New.'{$EndIf};
    function New: TInfEventoCollectionItem;
    property Items[Index: Integer]: TInfEventoCollectionItem read GetItem write SetItem; default;
  end;

  TInfEventoCollectionItem = class(TObject)
  private
    FInfEvento: TInfEvento;
    Fsignature: Tsignature;
    FRetInfEvento: TRetInfEvento;
    FXML: String;
  public
    constructor Create;
    destructor Destroy; override;

    property InfEvento: TInfEvento       read FInfEvento    write FInfEvento;
    property signature: Tsignature       read Fsignature    write Fsignature;
    property RetInfEvento: TRetInfEvento read FRetInfEvento write FRetInfEvento;
    property XML: String                 read FXML          write FXML;
  end;

  { TEventoNFe }

  TEventoNFe = class(TObject)
  private
    FGerador: TGerador;
    FidLote: Integer;
    FEvento: TInfEventoCollection;
    FVersao: String;

    procedure SetEvento(const Value: TInfEventoCollection);
    procedure GerarDestNFe(const EventoItem: TInfEventoCollectionItem);
    procedure GerarDestNFCe(const EventoItem: TInfEventoCollectionItem);
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function LerXML(const CaminhoArquivo: String): Boolean;
    function LerXMLFromString(const AXML: String): Boolean;
    function ObterNomeArquivo(tpEvento: TpcnTpEvento): String;
    function LerFromIni(const AIniString: String; CCe: Boolean = True): Boolean;

    property Gerador: TGerador            read FGerador write FGerador;
    property idLote: Integer              read FidLote  write FidLote;
    property Evento: TInfEventoCollection read FEvento  write SetEvento;
    property Versao: String               read FVersao  write FVersao;
  end;

implementation

uses
  IniFiles,
  pcnRetEnvEventoNFe, pcnAuxiliar, pcnConversaoNFe,
  ACBrUtil, ACBrDFeUtil;

{ TEventoNFe }

constructor TEventoNFe.Create;
begin
  inherited Create;
  FGerador := TGerador.Create;
  FEvento  := TInfEventoCollection.Create();
end;

destructor TEventoNFe.Destroy;
begin
  FGerador.Free;
  FEvento.Free;
  inherited;
end;

function TEventoNFe.ObterNomeArquivo(tpEvento: TpcnTpEvento): String;
begin
 case tpEvento of
    teCCe                       : Result := IntToStr(Self.idLote) + '-cce.xml';     // Carta de Corre��o Eletr�nica
    teCancelamento,
    teCancSubst                 : Result := IntToStr(Self.idLote) + '-can-eve.xml'; // Cancelamento da NFe como Evento
    teManifDestCiencia,
    teManifDestConfirmacao,
    teManifDestDesconhecimento,
    teManifDestOperNaoRealizada : Result := IntToStr(Self.idLote) + '-man-des.xml'; // Manifesta��o do Destinat�rio
    teEPECNFe                   : Result := Evento.Items[0].InfEvento.chNFe + '-ped-epec.xml'; // EPEC
    tePedProrrog1,
    tePedProrrog2               : Result := Evento.Items[0].InfEvento.chNFe + '-ped-prorr.xml';
    teCanPedProrrog1,
    teCanPedProrrog2            : Result := Evento.Items[0].InfEvento.chNFe + '-can-prorr.xml';
  else
    raise EventoException.Create('Obter nome do arquivo de Evento n�o Implementado!');
 end;
end;

function TEventoNFe.GerarXML: Boolean;
var
  i, j, Serie: Integer;
  sDoc, sModelo: String;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('envEvento ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wCampo(tcInt, 'HP03', 'idLote', 001, 015, 1, FidLote, DSC_IDLOTE);
  for i := 0 to Evento.Count - 1 do
  begin
    sModelo := Copy(OnlyNumber(Evento.Items[i].InfEvento.chNFe), 21, 2);

    Evento.Items[i].InfEvento.id := 'ID'+
                                      Evento.Items[i].InfEvento.TipoEvento +
                                      OnlyNumber(Evento.Items[i].InfEvento.chNFe) +
                                      Format('%.2d', [Evento.Items[i].InfEvento.nSeqEvento]);

    Gerador.wGrupo('evento ' + NAME_SPACE + ' versao="' + Versao + '"');
    Gerador.wGrupo('infEvento Id="' + Evento.Items[i].InfEvento.id + '"');

    if Length(Evento.Items[i].InfEvento.id) < 54 then
      Gerador.wAlerta('HP07', 'ID', '', 'ID de Evento inv�lido');

    Gerador.wCampo(tcInt, 'HP08', 'cOrgao', 001, 002, 1, FEvento.Items[i].FInfEvento.cOrgao);
    Gerador.wCampo(tcStr, 'HP09', 'tpAmb', 001, 001,  1, TpAmbToStr(Evento.Items[i].InfEvento.tpAmb), DSC_TPAMB);

    sDoc := OnlyNumber(Evento.Items[i].InfEvento.CNPJ);
    if EstaVazio(sDoc) then
      sDoc := ExtrairCNPJChaveAcesso(Evento.Items[i].InfEvento.chNFe);

    // Verifica a S�rie do Documento, caso esteja no intervalo de 910-969
    // o emitente � pessoa fisica, logo na chave temos um CPF.
    Serie := ExtrairSerieChaveAcesso(Evento.Items[i].InfEvento.chNFe);
    if (Length(sDoc) = 14)
      and (Serie >= 910) and (Serie <= 969)
      and not (Evento.Items[i].InfEvento.tpEvento in [teManifDestConfirmacao..teManifDestOperNaoRealizada]) then
    begin
      sDoc := Copy(sDoc, 4, 11);
    end;

    case Length( sDoc ) of
     14: begin
           Gerador.wCampo(tcStr, 'HP10', 'CNPJ', 014, 014, 1, sDoc , DSC_CNPJ);
           if not ValidarCNPJ( sDoc ) then Gerador.wAlerta('HP10', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
         end;
     11: begin
           Gerador.wCampo(tcStr, 'HP11', 'CPF', 011, 011, 1, sDoc, DSC_CPF);
           if not ValidarCPF( sDoc ) then Gerador.wAlerta('HP11', 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
         end;
    end;
    Gerador.wCampo(tcStr,    'HP12', 'chNFe', 044, 044,      1, Evento.Items[i].InfEvento.chNFe, DSC_CHAVE);

    if not ValidarChave(Evento.Items[i].InfEvento.chNFe) then
      Gerador.wAlerta('HP12', 'chNFe', '', 'Chave de NFe inv�lida');

    Gerador.wCampo(tcStr,    'HP13', 'dhEvento', 001, 050,   1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss',Evento.Items[i].InfEvento.dhEvento)+
                                                                GetUTC(CodigoParaUF(Evento.Items[i].InfEvento.cOrgao), Evento.Items[i].InfEvento.dhEvento));
    Gerador.wCampo(tcInt,    'HP14', 'tpEvento', 006, 006,   1, Evento.Items[i].InfEvento.TipoEvento);
    Gerador.wCampo(tcInt,    'HP15', 'nSeqEvento', 001, 002, 1, Evento.Items[i].InfEvento.nSeqEvento);
    // Alterado por Italo em 21/11/2017
    Gerador.wCampo(tcStr,    'HP16', 'verEvento', 001, 004,  1, Versao); // Evento.Items[i].InfEvento.versaoEvento);
    Gerador.wGrupo('detEvento versao="' +  Versao + '"');
    Gerador.wCampo(tcStr,    'HP19', 'descEvento', 004, 060, 1,  Evento.Items[i].InfEvento.DescEvento);
    case Evento.Items[i].InfEvento.tpEvento of
        teCCe:
          begin
            Gerador.wCampo(tcStr, 'HP20', 'xCorrecao', 015, 1000, 1,  Evento.Items[i].InfEvento.detEvento.xCorrecao);
            Gerador.wCampo(tcStr, 'HP20a', 'xCondUso', 001, 5000, 1,  Evento.Items[i].InfEvento.detEvento.xCondUso);
          end;
        teCancelamento:
          begin
            Gerador.wCampo(tcStr, 'HP20', 'nProt', 015, 015, 1,  Evento.Items[i].InfEvento.detEvento.nProt);
            Gerador.wCampo(tcStr, 'HP21', 'xJust', 015, 255, 1,  Evento.Items[i].InfEvento.detEvento.xJust);
          end;
        teCancSubst:
          begin
            Gerador.wCampo(tcInt, 'HP20', 'cOrgaoAutor', 001, 002, 1, Evento.Items[i].InfEvento.detEvento.cOrgaoAutor);
            Gerador.wCampo(tcInt, 'HP21', 'tpAutor    ', 001, 001, 1, '1');
            Gerador.wCampo(tcStr, 'HP22', 'verAplic   ', 001, 020, 1, Evento.Items[i].InfEvento.detEvento.verAplic);
            Gerador.wCampo(tcStr, 'HP23', 'nProt      ', 015, 015, 1, Evento.Items[i].InfEvento.detEvento.nProt);
            Gerador.wCampo(tcStr, 'HP30', 'xJust      ', 015, 255, 1, Evento.Items[i].InfEvento.detEvento.xJust);
            Gerador.wCampo(tcStr, 'HP31', 'chNFeRef   ', 044, 044, 1, Evento.Items[i].InfEvento.detEvento.chNFeRef, DSC_CHAVE);

            if not ValidarChave(Evento.Items[i].InfEvento.detEvento.chNFeRef) then
              Gerador.wAlerta('HP31', 'chNFeRef', '', 'Chave de NFe Refenciada inv�lida');
          end;
        teManifDestOperNaoRealizada:
          begin
            Gerador.wCampo(tcStr, 'HP21', 'xJust', 015, 255, 1,  Evento.Items[i].InfEvento.detEvento.xJust);
          end;
        teEPECNFe:
          begin
            Gerador.wCampo(tcInt, 'P20', 'cOrgaoAutor', 01, 02, 1, FEvento.Items[i].FInfEvento.detEvento.cOrgaoAutor);
            Gerador.wCampo(tcStr, 'P21', 'tpAutor',     01, 01, 1, TipoAutorToStr(Evento.Items[i].InfEvento.detEvento.tpAutor));
            Gerador.wCampo(tcStr, 'P22', 'verAplic',    01, 20, 1, Evento.Items[i].InfEvento.detEvento.verAplic);
            Gerador.wCampo(tcStr, 'P23', 'dhEmi',       01, 50, 1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss',Evento.Items[i].InfEvento.detEvento.dhEmi)+
                                                                   GetUTC(CodigoParaUF(Evento.Items[i].InfEvento.detEvento.cOrgaoAutor), Evento.Items[i].InfEvento.detEvento.dhEmi));
//            Gerador.wCampo(tcStr, 'P23', 'dhEmi',       01, 50, 1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss',Evento.Items[i].InfEvento.detEvento.dhEmi)+
//                                                                   GetUTC(CodigoParaUF(Evento.Items[i].InfEvento.cOrgao), Evento.Items[i].InfEvento.detEvento.dhEmi));
            Gerador.wCampo(tcStr, 'P24', 'tpNF',        01, 01, 1, tpNFToStr(Evento.Items[i].InfEvento.detEvento.tpNF));
            Gerador.wCampo(tcStr, 'P25', 'IE',          02, 14, 1, Evento.Items[i].InfEvento.detEvento.IE);

            if sModelo = '55' then
              GerarDestNFe(Evento.Items[i])
            else begin
              GerarDestNFCe(Evento.Items[i]);
              // No EPEC da NFC-e segundo o schema as TAGs vNF e vICMS est�o fora do grupo dest e n�o
              // tem a TAG vST.
              Gerador.wCampo(tcDe2, 'P32', 'vNF',   01, 15, 1, Evento.Items[i].InfEvento.detEvento.vNF, DSC_VNF);
              Gerador.wCampo(tcDe2, 'P33', 'vICMS', 01, 15, 1, Evento.Items[i].InfEvento.detEvento.vICMS, DSC_VICMS);
            end;
          end;
        tePedProrrog1,
        tePedProrrog2:
          begin
            Gerador.wCampo(tcStr, 'P19', 'nProt', 015, 015, 1,  Evento.Items[i].InfEvento.detEvento.nProt);

            for j := 0 to Evento.Items[i].FInfEvento.detEvento.itemPedido.count  - 1 do
            begin
              Gerador.wGrupo('itemPedido numItem="' + intToStr(Evento.Items[i].InfEvento.detEvento.itemPedido.Items[j].numItem) + '"');
              Gerador.wCampo(tcDe2, 'P22', 'qtdeItem', 01, 15, 1, Evento.Items[i].InfEvento.detEvento.itemPedido.Items[j].qtdeItem, '***');
              Gerador.wGrupo('/itemPedido');
            end;

          end;
        teCanPedProrrog1,
        teCanPedProrrog2:
          begin
            Gerador.wCampo(tcStr, 'P19', 'idPedidoCancelado', 54, 54, 1, Evento.Items[i].InfEvento.detEvento.idPedidoCancelado);
            Gerador.wCampo(tcStr, 'P20', 'nProt', 15, 15, 1, Evento.Items[i].InfEvento.detEvento.nProt);
          end;

    end;
    Gerador.wGrupo('/detEvento');
    Gerador.wGrupo('/infEvento');

    if Evento.Items[i].signature.URI <> '' then
    begin
      Evento.Items[i].signature.Gerador.Opcoes.IdentarXML := Gerador.Opcoes.IdentarXML;
      Evento.Items[i].signature.GerarXML;
      Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML + Evento.Items[i].signature.Gerador.ArquivoFormatoXML;
    end;

    Gerador.wGrupo('/evento');
  end;
  Gerador.wGrupo('/envEvento');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TEventoNFe.GerarDestNFe(const EventoItem: TInfEventoCollectionItem);
var
  sDoc: String;
begin
  Gerador.wGrupo('dest');
  Gerador.wCampo(tcStr, 'P27', 'UF', 02, 02, 1, EventoItem.InfEvento.detEvento.dest.UF);

  if (EventoItem.InfEvento.detEvento.dest.idEstrangeiro = '') and
     (EventoItem.InfEvento.detEvento.dest.UF <> 'EX') then
  begin
    sDoc := OnlyNumber( EventoItem.InfEvento.detEvento.dest.CNPJCPF );
    case Length( sDoc ) of
      14 : begin
             Gerador.wCampo(tcStr, 'P28', 'CNPJ', 014, 014, 1, sDoc , DSC_CNPJ);
             if not ValidarCNPJ( sDoc ) then Gerador.wAlerta('P28', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
           end;
      11 : begin
             Gerador.wCampo(tcStr, 'P29', 'CPF', 011, 011, 1, sDoc, DSC_CPF);
             if not ValidarCPF( sDoc ) then Gerador.wAlerta('P29', 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
           end;
    end;
  end
  else begin
    Gerador.wCampo(tcStr, 'P30', 'idEstrangeiro', 05, 20, 1, EventoItem.InfEvento.detEvento.dest.idEstrangeiro);
  end;

  if (EventoItem.InfEvento.detEvento.dest.IE <> '') then
    Gerador.wCampo(tcStr, 'P31', 'IE', 02, 14, 1, EventoItem.InfEvento.detEvento.dest.IE);

  // No EPEC da NF-e segundo o schema as TAGs vNF, vICMS e vST est�o dentro do grupo dest.

  Gerador.wCampo(tcDe2, 'P32', 'vNF',   01, 15, 1, EventoItem.InfEvento.detEvento.vNF, DSC_VNF);
  Gerador.wCampo(tcDe2, 'P33', 'vICMS', 01, 15, 1, EventoItem.InfEvento.detEvento.vICMS, DSC_VICMS);
  Gerador.wCampo(tcDe2, 'P34', 'vST',   01, 15, 1, EventoItem.InfEvento.detEvento.vST, DSC_VST);

  Gerador.wGrupo('/dest');
end;

procedure TEventoNFe.GerarDestNFCe(const EventoItem: TInfEventoCollectionItem);
var
  sDoc: String;
begin
  if (EventoItem.InfEvento.detEvento.dest.UF <> '') and
      ((EventoItem.InfEvento.detEvento.dest.CNPJCPF <> '') or
       (EventoItem.InfEvento.detEvento.dest.idEstrangeiro <> '')) then
  begin
    Gerador.wGrupo('dest');
    Gerador.wCampo(tcStr, 'P27', 'UF', 02, 02, 1, EventoItem.InfEvento.detEvento.dest.UF);

    if (EventoItem.InfEvento.detEvento.dest.idEstrangeiro = '') and
       (EventoItem.InfEvento.detEvento.dest.UF <> 'EX') then
    begin
      sDoc := OnlyNumber( EventoItem.InfEvento.detEvento.dest.CNPJCPF );
      case Length( sDoc ) of
        14 : begin
               Gerador.wCampo(tcStr, 'P28', 'CNPJ', 014, 014, 1, sDoc , DSC_CNPJ);
               if not ValidarCNPJ( sDoc ) then Gerador.wAlerta('P28', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
             end;
        11 : begin
               Gerador.wCampo(tcStr, 'P29', 'CPF', 011, 011, 1, sDoc, DSC_CPF);
               if not ValidarCPF( sDoc ) then Gerador.wAlerta('P29', 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
             end;
      end;
    end
    else begin
      Gerador.wCampo(tcStr, 'P30', 'idEstrangeiro', 05, 20, 1, EventoItem.InfEvento.detEvento.dest.idEstrangeiro);
    end;

    Gerador.wGrupo('/dest');
  end;
end;

procedure TEventoNFe.SetEvento(const Value: TInfEventoCollection);
begin
  FEvento.Assign(Value);
end;

function TEventoNFe.LerXML(const CaminhoArquivo: String): Boolean;
var
  ArqEvento    : TStringList;
begin
  ArqEvento := TStringList.Create;
  try
     ArqEvento.LoadFromFile(CaminhoArquivo);
     Result := LerXMLFromString(ArqEvento.Text);
  finally
     ArqEvento.Free;
  end;
end;

function TEventoNFe.LerXMLFromString(const AXML: String): Boolean;
var
  RetEventoNFe : TRetEventoNFe;
begin
  RetEventoNFe := TRetEventoNFe.Create;
  try
     RetEventoNFe.Leitor.Arquivo := AXML;
     Result := RetEventoNFe.LerXml;
     with FEvento.New do
      begin
        XML                     := AXML;
        infEvento.ID            := RetEventoNFe.InfEvento.id;
        infEvento.cOrgao        := RetEventoNFe.InfEvento.cOrgao;
        infEvento.tpAmb         := RetEventoNFe.InfEvento.tpAmb;
        infEvento.CNPJ          := RetEventoNFe.InfEvento.CNPJ;
        infEvento.chNFe         := RetEventoNFe.InfEvento.chNFe;
        infEvento.dhEvento      := RetEventoNFe.InfEvento.dhEvento;
        infEvento.tpEvento      := RetEventoNFe.InfEvento.tpEvento;
        infEvento.nSeqEvento    := RetEventoNFe.InfEvento.nSeqEvento;
        infEvento.VersaoEvento  := RetEventoNFe.InfEvento.VersaoEvento;

        infEvento.DetEvento.descEvento := RetEventoNFe.InfEvento.DetEvento.descEvento;
        infEvento.DetEvento.xCorrecao  := RetEventoNFe.InfEvento.DetEvento.xCorrecao;
        infEvento.DetEvento.xCondUso   := RetEventoNFe.InfEvento.DetEvento.xCondUso;
        infEvento.DetEvento.nProt      := RetEventoNFe.InfEvento.DetEvento.nProt;
        infEvento.DetEvento.xJust      := RetEventoNFe.InfEvento.DetEvento.xJust;
        infEvento.DetEvento.chNFeRef   := RetEventoNFe.InfEvento.DetEvento.chNFeRef;

        infEvento.detEvento.cOrgaoAutor := RetEventoNFe.InfEvento.detEvento.cOrgaoAutor;
        infEvento.detEvento.tpAutor     := RetEventoNFe.InfEvento.detEvento.tpAutor;
        infEvento.detEvento.verAplic    := RetEventoNFe.InfEvento.detEvento.verAplic;
        infEvento.detEvento.dhEmi       := RetEventoNFe.InfEvento.detEvento.dhEmi;
        infEvento.detEvento.tpNF        := RetEventoNFe.InfEvento.detEvento.tpNF;
        infEvento.detEvento.IE          := RetEventoNFe.InfEvento.detEvento.IE;

        infEvento.detEvento.dest.UF            := RetEventoNFe.InfEvento.detEvento.dest.UF;
        infEvento.detEvento.dest.CNPJCPF       := RetEventoNFe.InfEvento.detEvento.dest.CNPJCPF;
        infEvento.detEvento.dest.idEstrangeiro := RetEventoNFe.InfEvento.detEvento.dest.idEstrangeiro;
        infEvento.detEvento.dest.IE            := RetEventoNFe.InfEvento.detEvento.dest.IE;

        infEvento.detEvento.vNF   := RetEventoNFe.InfEvento.detEvento.vNF;
        infEvento.detEvento.vICMS := RetEventoNFe.InfEvento.detEvento.vICMS;
        infEvento.detEvento.vST   := RetEventoNFe.InfEvento.detEvento.vST;

        signature.URI             := RetEventoNFe.signature.URI;
        signature.DigestValue     := RetEventoNFe.signature.DigestValue;
        signature.SignatureValue  := RetEventoNFe.signature.SignatureValue;
        signature.X509Certificate := RetEventoNFe.signature.X509Certificate;

        if RetEventoNFe.retEvento.Count > 0 then
         begin
           FRetInfEvento.Id := RetEventoNFe.retEvento.Items[0].RetInfEvento.Id;
           FRetInfEvento.tpAmb := RetEventoNFe.retEvento.Items[0].RetInfEvento.tpAmb;
           FRetInfEvento.verAplic := RetEventoNFe.retEvento.Items[0].RetInfEvento.verAplic;
           FRetInfEvento.cOrgao := RetEventoNFe.retEvento.Items[0].RetInfEvento.cOrgao;
           FRetInfEvento.cStat := RetEventoNFe.retEvento.Items[0].RetInfEvento.cStat;
           FRetInfEvento.xMotivo := RetEventoNFe.retEvento.Items[0].RetInfEvento.xMotivo;
           FRetInfEvento.chNFe := RetEventoNFe.retEvento.Items[0].RetInfEvento.chNFe;
           FRetInfEvento.tpEvento := RetEventoNFe.retEvento.Items[0].RetInfEvento.tpEvento;
           FRetInfEvento.xEvento := RetEventoNFe.retEvento.Items[0].RetInfEvento.xEvento;
           FRetInfEvento.nSeqEvento := RetEventoNFe.retEvento.Items[0].RetInfEvento.nSeqEvento;
           FRetInfEvento.cOrgaoAutor := RetEventoNFe.retEvento.Items[0].RetInfEvento.cOrgaoAutor;
           FRetInfEvento.CNPJDest := RetEventoNFe.retEvento.Items[0].RetInfEvento.CNPJDest;
           FRetInfEvento.emailDest := RetEventoNFe.retEvento.Items[0].RetInfEvento.emailDest;
           FRetInfEvento.dhRegEvento := RetEventoNFe.retEvento.Items[0].RetInfEvento.dhRegEvento;
           FRetInfEvento.nProt := RetEventoNFe.retEvento.Items[0].RetInfEvento.nProt;
           FRetInfEvento.XML := RetEventoNFe.retEvento.Items[0].RetInfEvento.XML;
         end;
      end;
  finally
     RetEventoNFe.Free;
  end;
end;

function TEventoNFe.LerFromIni(const AIniString: String; CCe: Boolean): Boolean;
var
  I      : Integer;
  sSecao, sFim : String;
  INIRec : TMemIniFile ;
  ok     : Boolean;
begin
{$IFNDEF COMPILER23_UP}
  Result := False;
{$ENDIF}
  Self.Evento.Clear;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);
    idLote := INIRec.ReadInteger( 'EVENTO','idLote' ,INIRec.ReadInteger( 'CCE','idLote',0));

    I := 1 ;
    while true do
    begin
      sSecao := 'EVENTO'+IntToStrZero(I,3) ;
      sFim   := INIRec.ReadString(  sSecao,'chNFe'  ,'FIM');
      if (sFim = 'FIM') or (Length(sFim) <= 0) then
        break ;

      with Self.Evento.New do
      begin
        infEvento.cOrgao := INIRec.ReadInteger( sSecao,'cOrgao' ,0);
        infEvento.CNPJ   := INIRec.ReadString(  sSecao,'CNPJ' ,'');
        infEvento.chNFe  := sFim;
        infEvento.dhEvento :=  StringToDateTime(INIRec.ReadString(  sSecao,'dhEvento' ,''));
        if CCe then
          infEvento.tpEvento := teCCe
        else
          infEvento.tpEvento := StrToTpEventoNFe(ok,INIRec.ReadString(  sSecao,'tpEvento' ,''));

        infEvento.nSeqEvento   := INIRec.ReadInteger( sSecao,'nSeqEvento' ,1);
        infEvento.versaoEvento := INIRec.ReadString(  sSecao,'versaoEvento' ,'1.00');;

        if (infEvento.tpEvento = teEPECNFe) then
        begin
          infEvento.detEvento.cOrgaoAutor := INIRec.ReadInteger(sSecao, 'cOrgaoAutor', 0);
          infEvento.detEvento.tpAutor     := StrToTipoAutor(ok,INIRec.ReadString(sSecao, 'tpAutor', '1'));
          infEvento.detEvento.verAplic    := INIRec.ReadString(sSecao, 'verAplic', '1.0');
          infEvento.detEvento.dhEmi       := StringToDateTime(INIRec.ReadString(sSecao, 'dhEmi', ''));
          infEvento.detEvento.tpNF        := StrToTpNF(ok,INIRec.ReadString(sSecao, 'tpNF', '1'));
          infEvento.detEvento.IE          := INIRec.ReadString(sSecao, 'IE', '');

          infEvento.detEvento.dest.UF      := INIRec.ReadString('DEST', 'DestUF', '');
          infEvento.detEvento.dest.CNPJCPF := INIRec.ReadString('DEST', 'DestCNPJCPF', '');
          infEvento.detEvento.dest.IE      := INIRec.ReadString('DEST', 'DestIE', '');

          infEvento.detEvento.vNF   := StringToFloatDef(INIRec.ReadString(sSecao, 'vNF', ''), 0);
          infEvento.detEvento.vICMS := StringToFloatDef(INIRec.ReadString(sSecao, 'vICMS', ''), 0);
          infEvento.detEvento.vST   := StringToFloatDef(INIRec.ReadString(sSecao, 'vST', ''), 0);
        end
        else
        begin
          infEvento.detEvento.xCorrecao   := INIRec.ReadString( sSecao, 'xCorrecao' ,'');
          infEvento.detEvento.xCondUso    := INIRec.ReadString( sSecao, 'xCondUso' ,''); //Texto fixo conforme NT 2011.003 -  http://www.nfe.fazenda.gov.br/portal/exibirArquivo.aspx?conteudo=tsiloeZ6vBw=
          infEvento.detEvento.nProt       := INIRec.ReadString( sSecao, 'nProt' ,'');
          infEvento.detEvento.xJust       := INIRec.ReadString( sSecao, 'xJust' ,'');
          infEvento.detEvento.cOrgaoAutor := INIRec.ReadInteger(sSecao, 'cOrgaoAutor', 0);
          infEvento.detEvento.verAplic    := INIRec.ReadString( sSecao, 'verAplic', '1.0');
          infEvento.detEvento.chNFeRef    := INIRec.ReadString( sSecao, 'chNFeRef', '');
        end;
      end;

      Inc(I);
    end;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

{ TInfEventoCollection }

function TInfEventoCollection.Add: TInfEventoCollectionItem;
begin
  Result := Self.New;
end;

function TInfEventoCollection.GetItem(
  Index: Integer): TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem(inherited Items[Index]);
end;

procedure TInfEventoCollection.SetItem(Index: Integer;
  Value: TInfEventoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfEventoCollection.New: TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfEventoCollectionItem }

constructor TInfEventoCollectionItem.Create;
begin
  inherited Create;
  FInfEvento := TInfEvento.Create;
  Fsignature := Tsignature.Create;
  FRetInfEvento := TRetInfEvento.Create;
end;

destructor TInfEventoCollectionItem.Destroy;
begin
  FInfEvento.Free;
  fsignature.Free;
  FRetInfEvento.Free;
  inherited;
end;

end.

