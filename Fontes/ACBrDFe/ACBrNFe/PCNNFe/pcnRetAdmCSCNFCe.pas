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

unit pcnRetAdmCSCNFCe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor;

type

  TRetdadosCscCollection     = class;
  TRetdadosCscCollectionItem = class;
  TRetAdmCSCNFCe             = class;

  TRetdadosCscCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TRetdadosCscCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetdadosCscCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRetdadosCscCollectionItem;
    property Items[Index: Integer]: TRetdadosCscCollectionItem read GetItem write SetItem; default;
  end;

  TRetdadosCscCollectionItem = class(TCollectionItem)
  private
    FidCsc: Integer;
    FcodigoCsc: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property idCsc: Integer    read FidCsc     write FidCsc;
    property codigoCsc: String read FcodigoCsc write FcodigoCsc;
  end;

  TRetAdmCSCNFCe = class(TPersistent)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FindOP: TpcnIndOperacao;
    FcStat: Integer;
    FxMotivo: String;
    FdadosCsc: TRetdadosCscCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
  published
    property Leitor: TLeitor                  read FLeitor   write FLeitor;
    property versao: String                   read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente          read FtpAmb    write FtpAmb;
    property indOP: TpcnIndOperacao           read FindOP    write FindOP;
    property cStat: Integer                   read FcStat    write FcStat;
    property xMotivo: String                  read FxMotivo  write FxMotivo;
    property dadosCsc: TRetdadosCscCollection read FdadosCsc write FdadosCsc;
  end;

implementation

{ TRetdadosCscCollection }

function TRetdadosCscCollection.Add: TRetdadosCscCollectionItem;
begin
  Result := TRetdadosCscCollectionItem(inherited Add);
  Result.create;
end;

constructor TRetdadosCscCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TRetdadosCscCollectionItem);
end;

function TRetdadosCscCollection.GetItem(
  Index: Integer): TRetdadosCscCollectionItem;
begin
  Result := TRetdadosCscCollectionItem(inherited GetItem(Index));
end;

procedure TRetdadosCscCollection.SetItem(Index: Integer;
  Value: TRetdadosCscCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetdadosCscCollectionItem }

constructor TRetdadosCscCollectionItem.Create;
begin

end;

destructor TRetdadosCscCollectionItem.Destroy;
begin

  inherited;
end;

{ TRetAdmCSCNFCe }

constructor TRetAdmCSCNFCe.Create;
begin
  FLeitor   := TLeitor.Create;
  FdadosCsc := TRetdadosCscCollection.Create(Self);
end;

destructor TRetAdmCSCNFCe.Destroy;
begin
  FLeitor.Free;
  FdadosCsc.Free;
  inherited;
end;

function TRetAdmCSCNFCe.LerXml: boolean;
var
  ok: boolean;
  i: Integer;
begin
  Result := False;

  try
    Leitor.Grupo := Leitor.Arquivo;
    if leitor.rExtrai(1, 'retAdmCscNFCe') <> '' then
    begin
      Fversao  := Leitor.rAtributo('versao');
      FtpAmb   := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FindOp   := StrToIndOperacao(Ok, Leitor.rCampo(tcStr, 'indOp'));
      FcStat   := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo := Leitor.rCampo(tcStr, 'xMotivo');

      i := 0;

      while Leitor.rExtrai(2, 'dadosCsc', '', i + 1) <> '' do
       begin
         FdadosCsc.Add;
         FdadosCsc.Items[i].FidCsc     := Leitor.rCampo(tcInt, 'idCsc');
         FdadosCsc.Items[i].FcodigoCsc := Leitor.rCampo(tcStr, 'codigoCsc');
         inc(i);
       end;

      if i = 0 then
      begin
        FdadosCsc.Add;
        FdadosCsc.Items[i].FidCsc     := 0;
        FdadosCsc.Items[i].FcodigoCsc := '';
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

