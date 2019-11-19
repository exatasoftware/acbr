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

unit pcnRetConsReciDFe;

interface

uses
  SysUtils, Classes, Contnrs, pcnConversao, pcnLeitor;

type

  TProtDFeCollection     = class;
  TProtDFeCollectionItem = class;

  TRetConsReciDFe = class
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FnRec: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FcMsg: Integer;
    FxMsg: String;
    FProtDFe: TProtDFeCollection;
    FtagGrupoMsg: String;

    procedure SetProtDFe(const Value: TProtDFeCollection);
  public
    constructor Create(const AtagGrupoMsg: String);
    destructor Destroy; override;
    function LerXML: Boolean;
    property Leitor: TLeitor             read FLeitor   write FLeitor;
    property versao: String              read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente     read FtpAmb    write FtpAmb;
    property verAplic: String            read FverAplic write FverAplic;
    property nRec: String                read FnRec     write FnRec;
    property cStat: Integer              read FcStat    write FcStat;
    property xMotivo: String             read FxMotivo  write FxMotivo;
    property cUF: Integer                read FcUF      write FcUF;
    property cMsg: Integer               read FcMsg     write FcMsg;
    property xMsg: String                read FxMsg     write FxMsg;
    property ProtDFe: TProtDFeCollection read FProtDFe  write SetProtDFe;
  end;

  TProtDFeCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TProtDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TProtDFeCollectionItem);
  public
    function New: TProtDFeCollectionItem;
    property Items[Index: Integer]: TProtDFeCollectionItem read GetItem write SetItem; default;
  end;

  TProtDFeCollectionItem = class(TObject)
  private
    FId: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FchDFe: String;
    FdhRecbto: TDateTime;
    FnProt: String;
    FdigVal: String;
    FcStat: Integer;
    FxMotivo: String;
    FXMLprotDFe: String;
    FcMsg : Integer;
    FxMsg : String;
  public
    property Id: String              read FId         write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb      write FtpAmb;
    property verAplic: String        read FverAplic   write FverAplic;
    property chDFe: String           read FchDFe      write FchDFe;
    property dhRecbto: TDateTime     read FdhRecbto   write FdhRecbto;
    property nProt: String           read FnProt      write FnProt;
    property digVal: String          read FdigVal     write FdigVal;
    property cStat: Integer          read FcStat      write FcStat;
    property xMotivo: String         read FxMotivo    write FxMotivo;
    property XMLprotDFe: String      read FXMLprotDFe write FXMLprotDFe;
    property cMSg: Integer           read FcMsg       write FcMsg;
    property xMsg: String            read FxMsg       write FxMsg;
  end;

implementation

{ TRetConsReciDFe }

constructor TRetConsReciDFe.Create(const AtagGrupoMsg: String);
begin
  inherited Create;

  FLeitor  := TLeitor.Create;
  FProtDFe := TProtDFeCollection.Create();

  FtagGrupoMsg := AtagGrupoMsg;
end;

destructor TRetConsReciDFe.Destroy;
begin
  FLeitor.Free;
  FProtDFe.Free;

  inherited;
end;

procedure TRetConsReciDFe.SetProtDFe(const Value: TProtDFeCollection);
begin
  FProtDFe.Assign(Value);
end;

{ TProtDFeCollection }

function TProtDFeCollection.GetItem(Index: Integer): TProtDFeCollectionItem;
begin
  Result := TProtDFeCollectionItem(inherited GetItem(Index));
end;

procedure TProtDFeCollection.SetItem(Index: Integer; Value: TProtDFeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TRetConsReciDFe.LerXML: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    Leitor.Grupo := Leitor.Arquivo;

    if Leitor.rExtrai(1, 'retConsReci' + FtagGrupoMsg) <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao', 'retConsReci' + FtagGrupoMsg);
      FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      FnRec     := Leitor.rCampo(tcStr, 'nRec');
      FcStat    := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
      FcUF      := Leitor.rCampo(tcInt, 'cUF');
      FcMsg     := Leitor.rCampo(tcInt, 'cMsg');
      FxMsg     := Leitor.rCampo(tcStr, 'xMsg');

      i := 0;
      while (FcStat = 104) and (Leitor.rExtrai(1, 'prot' + FtagGrupoMsg, '', i + 1) <> '') do
      begin
        ProtDFe.New;

        // A propriedade XMLprotDFe contem o XML que traz o resultado do
        // processamento da NF-e.
        ProtDFe[i].XMLprotDFe := Leitor.Grupo;

        if Leitor.rExtrai(2, 'infProt') <> '' then
        begin
          ProtDFe[i].FId       := Leitor.rAtributo('Id=', 'infProt');
          ProtDFe[i].FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
          ProtDFe[i].FverAplic := Leitor.rCampo(tcStr, 'verAplic');
          ProtDFe[i].FchDFe    := Leitor.rCampo(tcStr, 'ch' + FtagGrupoMsg);
          ProtDFe[i].FdhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
          ProtDFe[i].FnProt    := Leitor.rCampo(tcStr, 'nProt');
          ProtDFe[i].FdigVal   := Leitor.rCampo(tcStr, 'digVal');
          ProtDFe[i].FcStat    := Leitor.rCampo(tcInt, 'cStat');
          ProtDFe[i].FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
          ProtDFe[i].FcMsg     := Leitor.rCampo(tcInt, 'cMsg');
          ProtDFe[i].FxMsg     := Leitor.rCampo(tcStr, 'xMsg');
        end;
        inc(i);
      end;

      Result := True;
    end;
  except
    result := False;
  end;
end;

function TProtDFeCollection.New: TProtDFeCollectionItem;
begin
  Result := TProtDFeCollectionItem.Create;
  Add(Result);
end;

end.

