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

unit pcnRetEnvBPe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor;

type

  TProtBPeCollection     = class;
  TProtBPeCollectionItem = class;

  TretEnvBPe = class(TPersistent)
  private
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FcStat: Integer;
    FLeitor: TLeitor;
    FcUF: Integer;
    FverAplic: String;
    FxMotivo: String;
    FProtBPe: TProtBPeCollection;

    procedure SetProtBPe(const Value: TProtBPeCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor         read FLeitor   write FLeitor;
    property versao: String          read Fversao    write Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: String        read FverAplic write FverAplic;
    property cStat: Integer          read FcStat    write FcStat;
    property xMotivo: String         read FxMotivo  write FxMotivo;
    property cUF: Integer            read FcUF      write FcUF;
    property ProtBPe: TProtBPeCollection read FProtBPe  write SetProtBPe;
  end;

  TProtBPeCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TProtBPeCollectionItem;
    procedure SetItem(Index: Integer; Value: TProtBPeCollectionItem);
  public
    constructor Create(AOwner: TretEnvBPe); reintroduce;
    function Add: TProtBPeCollectionItem;
    property Items[Index: Integer]: TProtBPeCollectionItem read GetItem write SetItem; default;
  end;

  TProtBPeCollectionItem = class(TCollectionItem)
  private
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FchBPe: String;
    FdhRecbto: TDateTime;
    FnProt: String;
    FdigVal: String;
    FcStat: Integer;
    FxMotivo: String;
    FXMLprotBPe: String;
  published
    property tpAmb: TpcnTipoAmbiente read FtpAmb      write FtpAmb;
    property verAplic: String        read FverAplic   write FverAplic;
    property chBPe: String           read FchBPe      write FchBPe;
    property dhRecbto: TDateTime     read FdhRecbto   write FdhRecbto;
    property nProt: String           read FnProt      write FnProt;
    property digVal: String          read FdigVal     write FdigVal;
    property cStat: Integer          read FcStat      write FcStat;
    property xMotivo: String         read FxMotivo    write FxMotivo;
    property XMLprotBPe: String      read FXMLprotBPe write FXMLprotBPe;
  end;

implementation

{ TretEnvBPe }

constructor TretEnvBPe.Create;
begin
  FLeitor  := TLeitor.Create;
  FProtBPe := TProtBPeCollection.Create(self);
end;

destructor TretEnvBPe.Destroy;
begin
  FLeitor.Free;
  FProtBPe.Free;
  inherited;
end;

procedure TretEnvBPe.SetProtBPe(const Value: TProtBPeCollection);
begin
  FProtBPe := Value;
end;

{ TProtBPeCollection }

constructor TProtBPeCollection.Create(AOwner: TretEnvBPe);
begin
  inherited Create(TProtBPeCollectionItem);
end;

function TProtBPeCollection.Add: TProtBPeCollectionItem;
begin
  Result := TProtBPeCollectionItem(inherited Add);
end;

function TProtBPeCollection.GetItem(Index: Integer): TProtBPeCollectionItem;
begin
  Result := TProtBPeCollectionItem(inherited GetItem(Index));
end;

procedure TProtBPeCollection.SetItem(Index: Integer; Value: TProtBPeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TretEnvBPe.LerXml: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    Leitor.Grupo := Leitor.Arquivo;
    if leitor.rExtrai(1, 'retBPe') <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao');
      FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FcUF      := Leitor.rCampo(tcInt, 'cUF');
      FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      FcStat    := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');

      i := 0;
      while (FcStat = 100) and (Leitor.rExtrai(1, 'protBPe', '', i + 1) <> '') do
      begin
        ProtBPe.Add;

        // A propriedade XMLprotBPe contem o XML que traz o resultado do
        // processamento da BP-e.
        ProtBPe[i].XMLprotBPe := Leitor.Grupo;

        if Leitor.rExtrai(2, 'infProt') <> '' then
        begin
          ProtBPe[i].FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
          ProtBPe[i].FverAplic := Leitor.rCampo(tcStr, 'verAplic');
          ProtBPe[i].FchBPe    := Leitor.rCampo(tcStr, 'chBPe');
          ProtBPe[i].FdhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
          ProtBPe[i].FnProt    := Leitor.rCampo(tcStr, 'nProt');
          ProtBPe[i].FdigVal   := Leitor.rCampo(tcStr, 'digVal');
          ProtBPe[i].FcStat    := Leitor.rCampo(tcInt, 'cStat');
          ProtBPe[i].FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
        end;
        inc(i);
      end;

      Result := True;
    end;
  except
    Result := false;
  end;
end;

end.

