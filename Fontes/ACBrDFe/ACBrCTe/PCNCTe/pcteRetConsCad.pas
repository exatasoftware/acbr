////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar CTe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da CTe          //
//                                                                            //
//        site: www.projetocooperar.org/cte                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_cte/        //
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

unit pcteRetConsCad;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor;

type

  TRetConsCad = class;
  TInfCadCollection = class;
  TInfCadCollectionItem = class;

  TRetConsCad = class(TPersistent)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FUF: String;
    FIE: String;
    FCNPJ: String;
    FCPF: String;
    FdhCons: TDateTime;
    FcUF: Integer;
    FInfCad: TInfCadCollection;

    procedure SetInfCad(const Value: TInfCadCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXML: boolean;
  published
    property Leitor: TLeitor           read FLeitor   write FLeitor;
    property versao: String            read Fversao   write Fversao;
    property verAplic: String          read FverAplic write FverAplic;
    property cStat: Integer            read FcStat    write FcStat;
    property xMotivo: String           read FxMotivo  write FxMotivo;
    property UF: String                read FUF       write FUF;
    property IE: String                read FIE       write FIE;
    property CNPJ: String              read FCNPJ     write FCNPJ;
    property CPF: String               read FCPF      write FCPF;
    property dhCons: TDateTime         read FdhCons   write FdhCons;
    property cUF: Integer              read FcUF      write FcUF;
    property InfCad: TInfCadCollection read FInfCad   write SetInfCad;
  end;

  TInfCadCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfCadCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfCadCollectionItem);
  public
    constructor Create(AOwner: TRetConsCad); reintroduce;
    function Add: TInfCadCollectionItem;
    property Items[Index: Integer]: TInfCadCollectionItem read GetItem write SetItem; default;
  end;

  TInfCadCollectionItem = class(TCollectionItem)
  private
    FIE: String;
    FCNPJ: String;
    FCPF: String;
    FUF: String;
    FcSit: Integer;
    FindCredNFe: Integer;
    FindCredCTe: Integer;
    FxNome: String;
    FxFant: String;
    FxRegApur: String;
    FCNAE: Integer;
    FdIniAtiv: TDateTime;
    FdUltSit: TDateTime;
    FdBaixa: TDateTime;
    FIEUnica: String;
    FIEAtual: String;
    FxLgr: String;
    Fnro: String;
    FxCpl: String;
    FxBairro: String;
    FcMun: Integer;
    FxMun: String;
    FCep: Integer;
  published
    property IE: String          read FIE         write FIE;
    property CNPJ: String        read FCNPJ       write FCNPJ;
    property CPF: String         read FCPF        write FCPF;
    property UF: String          read FUF         write FUF;
    property cSit: Integer       read FcSit       write FcSit;
    property indCredNFe: Integer read FindCredNFe write FindCredNFe;
    property indCredCTe: Integer read FindCredCTe write FindCredCTe;
    property xNome: String       read FxNome      write FxNome;
    property xFant: String       read FxFant      write FxFant;
    property xRegApur: String    read FxRegApur   write FxRegApur;
    property CNAE: Integer       read FCNAE       write FCNAE;
    property dIniAtiv: TDateTime read FdIniAtiv   write FdIniAtiv;
    property dUltSit: TDateTime  read FdUltSit    write FdUltSit;
    property dBaixa: TDateTime   read FdBaixa     write FdBaixa;
    property IEUnica: String     read FIEUnica    write FIEUnica;
    property IEAtual: String     read FIEAtual    write FIEAtual;
    property xLgr: String        read FxLgr       write FxLgr;
    property nro: String         read Fnro        write Fnro;
    property xCpl: String        read FxCpl       write FxCpl;
    property xBairro: String     read FxBairro    write FxBairro;
    property cMun: Integer       read FcMun       write FcMun;
    property xMun: String        read FxMun       write FxMun;
    property CEP: Integer        read FCep        write FCep;
  end;

implementation

{ RetConsCad }

constructor TRetConsCad.Create;
begin
  FLeitor := TLeitor.Create;
  FInfCad := TInfCadCollection.Create(Self);
end;

destructor TRetConsCad.Destroy;
begin
  FLeitor.Free;
  FInfCad.Free;
  inherited;
end;

procedure TRetConsCad.SetInfCad(const Value: TInfCadCollection);
begin
  FInfCad.Assign(Value);
end;

{ TInfCadCollection }

constructor TInfCadCollection.Create(AOwner: TRetConsCad);
begin
  inherited Create(TInfCadCollectionItem);
end;

function TInfCadCollection.Add: TInfCadCollectionItem;
begin
  Result := TInfCadCollectionItem(inherited Add);
end;

function TInfCadCollection.GetItem(Index: Integer): TInfCadCollectionItem;
begin
  Result := TInfCadCollectionItem(inherited GetItem(Index));
end;

procedure TInfCadCollection.SetItem(Index: Integer; Value: TInfCadCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TRetConsCad.LerXML: boolean;
var
  i: Integer;
begin
  i := 0; 
  Result := False;
  try
    Fversao := Leitor.rAtributo('versao');

    if Leitor.rExtrai(1, 'infCons') <> '' then
    begin
      (*GR04 *)FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      (*GR05 *)FcStat    := Leitor.rCampo(tcInt, 'cStat');
      (*GR06 *)FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
      (*GR06a*)FUF       := Leitor.rCampo(tcStr, 'UF');
      (*GR06b*)FIE       := Leitor.rCampo(tcStr, 'IE');
      (*GR06c*)FCNPJ     := Leitor.rCampo(tcStr, 'CNPJ');
      (*GR06d*)FCPF      := Leitor.rCampo(tcStr, 'CPF');
      (*GR06e*)FdhCons   := Leitor.rCampo(tcDatHor, 'dhCons');
      (*GR06f*)FcUF      := Leitor.rCampo(tcInt, 'cUF');

      while Leitor.rExtrai(2, 'infCad', '', i + 1) <> '' do
      begin
        InfCad.Add;

        (*GR08 *)InfCad[i].FIE         := Leitor.rCampo(tcStr, 'IE');
        (*GR09 *)InfCad[i].FCNPJ       := Leitor.rCampo(tcStr, 'CNPJ');
        (*GR10 *)InfCad[i].FCPF        := Leitor.rCampo(tcStr, 'CPF');
        (*GR11 *)InfCad[i].FUF         := Leitor.rCampo(tcStr, 'UF');
        (*GR12 *)InfCad[i].FcSit       := Leitor.rCampo(tcInt, 'cSit');
        (*GR12a*)InfCad[i].FindCredNFe := Leitor.rCampo(tcInt, 'indCredNFe');
        (*GR12b*)InfCad[i].FindCredCTe := Leitor.rCampo(tcInt, 'indCredCTe');
        (*GR13 *)InfCad[i].FxNome      := Leitor.rCampo(tcStr, 'xNome');
        (*GR13a*)InfCad[i].FxFant      := Leitor.rCampo(tcStr, 'xFant');
        (*GR14 *)InfCad[i].FxRegApur   := Leitor.rCampo(tcStr, 'xRegApur');
        (*GR15 *)InfCad[i].FCNAE       := Leitor.rCampo(tcInt, 'CNAE');
        (*GR16 *)InfCad[i].FdIniAtiv   := Leitor.rCampo(tcDat, 'dIniAtiv');
        (*GR17 *)InfCad[i].FdUltSit    := Leitor.rCampo(tcDat, 'dUltSit');
        (*GR18 *)InfCad[i].FdBaixa     := Leitor.rCampo(tcDat, 'dBaixa');
        (*GR20 *)InfCad[i].FIEUnica    := Leitor.rCampo(tcStr, 'IEUnica');
        (*GR21 *)InfCad[i].FIEAtual    := Leitor.rCampo(tcStr, 'IEAtual');
        (*GR23 *)InfCad[i].FxLgr       := Leitor.rCampo(tcStr, 'xLgr');
        (*GR24 *)InfCad[i].Fnro        := Leitor.rCampo(tcStr, 'nro');
        (*GR25 *)InfCad[i].FxCpl       := Leitor.rCampo(tcStr, 'xCpl');
        (*GR26 *)InfCad[i].FxBairro    := Leitor.rCampo(tcStr, 'xBairro');
        (*GR27 *)InfCad[i].FcMun       := Leitor.rCampo(tcInt, 'cMun');
        (*GR28 *)InfCad[i].FxMun       := Leitor.rCampo(tcStr, 'xMun');
        (*GR29 *)InfCad[i].FCep        := Leitor.rCampo(tcInt, 'CEP');

        inc(i);
      end;
      
      if i = 0 then InfCad.Add;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

