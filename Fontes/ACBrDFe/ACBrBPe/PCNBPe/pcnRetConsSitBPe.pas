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

unit pcnRetConsSitBPe;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnLeitor, pcnProcBPe, pcnRetEnvEventoBPe;

type

  TRetEventoBPeCollection     = class;
  TRetEventoBPeCollectionItem = class;
  TRetConsSitBPe              = class;

  TRetEventoBPeCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TRetEventoBPeCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoBPeCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRetEventoBPeCollectionItem;
    property Items[Index: Integer]: TRetEventoBPeCollectionItem read GetItem write SetItem; default;
  end;

  TRetEventoBPeCollectionItem = class(TCollectionItem)
  private
    FRetEventoBPe: TRetEventoBPe;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property RetEventoBPe: TRetEventoBPe read FRetEventoBPe write FRetEventoBPe;
  end;

  TRetConsSitBPe = class(TPersistent)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FprotBPe: TProcBPe;
    FprocEventoBPe: TRetEventoBPeCollection;
    FXMLprotBPe: String;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor                        read FLeitor        write FLeitor;
    property versao: String                         read Fversao        write Fversao;
    property tpAmb: TpcnTipoAmbiente                read FtpAmb         write FtpAmb;
    property verAplic: String                       read FverAplic      write FverAplic;
    property cStat: Integer                         read FcStat         write FcStat;
    property xMotivo: String                        read FxMotivo       write FxMotivo;
    property cUF: Integer                           read FcUF           write FcUF;
    property protBPe: TProcBPe                      read FprotBPe       write FprotBPe;
    property procEventoBPe: TRetEventoBPeCollection read FprocEventoBPe write FprocEventoBPe;
    property XMLprotBPe: String                     read FXMLprotBPe    write FXMLprotBPe;
  end;

implementation

{ TRetConsSitBPe }

constructor TRetConsSitBPe.Create;
begin
  FLeitor  := TLeitor.Create;
  FprotBPe := TProcBPe.create;
end;

destructor TRetConsSitBPe.Destroy;
begin
  FLeitor.Free;
  FprotBPe.Free;
  if Assigned(procEventoBPe) then
    procEventoBPe.Free;

  inherited;
end;

function TRetConsSitBPe.LerXml: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    if leitor.rExtrai(1, 'retConsSitBPe') <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao');
      FtpAmb    := StrToTpAmb(ok, leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic := leitor.rCampo(tcStr, 'verAplic');
      FcStat    := leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := leitor.rCampo(tcStr, 'xMotivo');
      FcUF      := leitor.rCampo(tcInt, 'cUF');

      case FcStat of
        100,101,104,110,150,151,155,301,302,303:
           begin
             if (Leitor.rExtrai(1, 'protBPe') <> '') then
             begin
               // A propriedade XMLprotBPe contem o XML que traz o resultado do
               // processamento do BP-e.
               XMLprotBPe := Leitor.Grupo;

               if Leitor.rExtrai(2, 'infProt') <> '' then
               begin
                 protBPe.tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
                 protBPe.verAplic := Leitor.rCampo(tcStr, 'verAplic');
                 protBPe.chBPe    := Leitor.rCampo(tcStr, 'chBPe');
                 protBPe.dhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
                 protBPe.nProt    := Leitor.rCampo(tcStr, 'nProt');
                 protBPe.digVal   := Leitor.rCampo(tcStr, 'digVal');
                 protBPe.cStat    := Leitor.rCampo(tcInt, 'cStat');
                 protBPe.xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
               end;
             end;
           end;
      end;

      if Assigned(procEventoBPe) then
        procEventoBPe.Free;

      procEventoBPe := TRetEventoBPeCollection.Create(Self);
      i:=0;
      while Leitor.rExtrai(1, 'procEventoBPe', '', i + 1) <> '' do
      begin
        procEventoBPe.Add;
        procEventoBPe.Items[i].RetEventoBPe.Leitor.Arquivo := Leitor.Grupo;
        procEventoBPe.Items[i].RetEventoBPe.XML            := Leitor.Grupo; 
        procEventoBPe.Items[i].RetEventoBPe.LerXml;
        inc(i);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

{ TRetEventoCollection }

function TRetEventoBPeCollection.Add: TRetEventoBPeCollectionItem;
begin
  Result := TRetEventoBPeCollectionItem(inherited Add);
  Result.create;
end;

constructor TRetEventoBPeCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TRetEventoBPeCollectionItem);
end;

function TRetEventoBPeCollection.GetItem(Index: Integer): TRetEventoBPeCollectionItem;
begin
  Result := TRetEventoBPeCollectionItem(inherited GetItem(Index));
end;

procedure TRetEventoBPeCollection.SetItem(Index: Integer;
  Value: TRetEventoBPeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetEventoCollectionItem }

constructor TRetEventoBPeCollectionItem.Create;
begin
  FRetEventoBPe := TRetEventoBPe.Create;
end;

destructor TRetEventoBPeCollectionItem.Destroy;
begin
  FRetEventoBPe.Free;
  inherited;
end;

end.

