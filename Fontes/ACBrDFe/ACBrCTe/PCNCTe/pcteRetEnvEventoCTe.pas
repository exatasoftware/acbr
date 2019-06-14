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

unit pcteRetEnvEventoCTe;

interface

uses
  SysUtils, Classes, Contnrs,
{$IFNDEF VER130}
  Variants,
{$ENDIF}
  pcnAuxiliar, pcnConversao, pcnLeitor, pcteEventoCTe, pcteConversaoCTe,
  pcnSignature;

type
  TRetInfEventoCollectionItem = class;

  TRetInfEventoCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TRetInfEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfEventoCollectionItem);
  public
    function Add: TRetInfEventoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetInfEventoCollectionItem;
    property Items[Index: Integer]: TRetInfEventoCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfEventoCollectionItem = class(TObject)
  private
    FRetInfEvento: TRetInfEvento;
  public
    constructor Create;
    destructor Destroy; override;
    property RetInfEvento: TRetInfEvento read FRetInfEvento write FRetInfEvento;
  end;

  TRetEventoCTe = class(TObject)
  private
    FLeitor: TLeitor;
    FidLote: Integer;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcOrgao: Integer;
    FcStat: Integer;
    FxMotivo: String;
    FInfEvento: TInfEvento;
    FretEvento: TRetInfEventoCollection;
    FXML: AnsiString;
    Fsignature: Tsignature;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
    property Leitor: TLeitor                    read FLeitor    write FLeitor;
    property idLote: Integer                    read FidLote    write FidLote;
    property versao: String                     read Fversao    write Fversao;
    property tpAmb: TpcnTipoAmbiente            read FtpAmb     write FtpAmb;
    property verAplic: String                   read FverAplic  write FverAplic;
    property cOrgao: Integer                    read FcOrgao    write FcOrgao;
    property cStat: Integer                     read FcStat     write FcStat;
    property xMotivo: String                    read FxMotivo   write FxMotivo;
    property InfEvento: TInfEvento              read FInfEvento write FInfEvento;
    property signature: Tsignature              read Fsignature write Fsignature;
    property retEvento: TRetInfEventoCollection read FretEvento write FretEvento;
    property XML: AnsiString                    read FXML       write FXML;
  end;

implementation

{ TRetInfEventoCollection }

function TRetInfEventoCollection. Add: TRetInfEventoCollectionItem;
begin
  Result := Self.New;
end;

function TRetInfEventoCollection.GetItem(
  Index: Integer): TRetInfEventoCollectionItem;
begin
  Result := TRetInfEventoCollectionItem(inherited GetItem(Index));
end;

procedure TRetInfEventoCollection.SetItem(Index: Integer;
  Value: TRetInfEventoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TRetInfEventoCollection.New: TRetInfEventoCollectionItem;
begin
  Result := TRetInfEventoCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetInfEventoCollectionItem }

constructor TRetInfEventoCollectionItem.Create;
begin
  inherited Create;
  FRetInfEvento := TRetInfEvento.Create;
end;

destructor TRetInfEventoCollectionItem.Destroy;
begin
  FRetInfEvento.Free;
  inherited;
end;

{ TRetEventoCTe }
constructor TRetEventoCTe.Create;
begin
  inherited Create;
  FLeitor    := TLeitor.Create;
  FretEvento := TRetInfEventoCollection.Create;
  FInfEvento := TInfEvento.Create;
  Fsignature := Tsignature.Create;
end;

destructor TRetEventoCTe.Destroy;
begin
  FLeitor.Free;
  FretEvento.Free;
  FInfEvento.Free;
  Fsignature.Free;
  inherited;
end;

function TRetEventoCTe.LerXml: boolean;
var
  ok: boolean;
  i, j: Integer;
begin
  Result := False;
  i := 0;
  
  try
    if (Leitor.rExtrai(1, 'eventoCTe') <> '') or
       (Leitor.rExtrai(1, 'evento') <> '') then
    begin
      if Leitor.rExtrai(2, 'infEvento', '', i + 1) <> '' then
       begin
         infEvento.Id         := Leitor.rAtributo('Id=', 'infEvento');
         infEvento.cOrgao     := Leitor.rCampo(tcInt, 'cOrgao');
         infEvento.tpAmb      := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
         infEvento.CNPJ       := Leitor.rCampo(tcStr, 'CNPJ');
         infEvento.chCTe      := Leitor.rCampo(tcStr, 'chCTe');
         infEvento.dhEvento   := Leitor.rCampo(tcDatHor, 'dhEvento');
         infEvento.tpEvento   := StrToTpEventoCTe(ok,Leitor.rCampo(tcStr, 'tpEvento'));
         infEvento.nSeqEvento := Leitor.rCampo(tcInt, 'nSeqEvento');

         if Leitor.rExtrai(3, 'detEvento', '', i + 1) <> '' then
         begin
           infEvento.VersaoEvento         := Leitor.rAtributo('versaoEvento', 'detEvento');
           infEvento.detEvento.descEvento := Leitor.rCampo(tcStr, 'descEvento');
           infEvento.detEvento.nProt      := Leitor.rCampo(tcStr, 'nProt');
           infEvento.detEvento.xJust      := Leitor.rCampo(tcStr, 'xJust');
           infEvento.detEvento.vICMS      := Leitor.rCampo(tcDe2, 'vICMS');
           infEvento.detEvento.vTPrest    := Leitor.rCampo(tcDe2, 'vTPrest');
           infEvento.detEvento.vCarga     := Leitor.rCampo(tcDe2, 'vCarga');
           infEvento.detEvento.toma       := StrToTpTomador(ok, Leitor.rCampo(tcStr, 'toma'));
           infEvento.detEvento.UF         := Leitor.rCampo(tcStr, 'UF');
           infEvento.detEvento.CNPJCPF    := Leitor.rCampoCNPJCPF;
           infEvento.detEvento.IE         := Leitor.rCampo(tcStr, 'IE');
           infEvento.detEvento.modal      := StrToTpModal(ok, Leitor.rCampo(tcStr, 'modal'));
           infEvento.detEvento.UFIni      := Leitor.rCampo(tcStr, 'UFIni');
           infEvento.detEvento.UFFim      := Leitor.rCampo(tcStr, 'UFFim');
           infEvento.detEvento.xOBS       := Leitor.rCampo(tcStr, 'xOBS');
           infEvento.detEvento.dhEntrega  := Leitor.rCampo(tcDatHor, 'dhEntrega');
           infEvento.detEvento.nDoc       := Leitor.rCampo(tcStr, 'nDoc');
           infEvento.detEvento.xNome      := Leitor.rCampo(tcStr, 'xNome');
           infEvento.detEvento.latitude   := Leitor.rCampo(tcDe6, 'latitude');
           infEvento.detEvento.longitude  := Leitor.rCampo(tcDe6, 'longitude');

           infEvento.detEvento.hashEntrega   := Leitor.rCampo(tcStr, 'hashEntrega');
           infEvento.detEvento.dhHashEntrega := Leitor.rCampo(tcDatHor, 'dhHashEntrega');

           // Carrega os dados da informa��o da Corre��o aplicada
           i := 0;
           while Leitor.rExtrai(4, 'infCorrecao', '', i + 1) <> '' do
           begin
             with infEvento.detEvento.infCorrecao.New do
             begin
               grupoAlterado   := Leitor.rCampo(tcStr, 'grupoAlterado');
               campoAlterado   := Leitor.rCampo(tcStr, 'campoAlterado');
               valorAlterado   := Leitor.rCampo(tcStr, 'valorAlterado');
               nroItemAlterado := Leitor.rCampo(tcInt, 'nroItemAlterado');
             end;
             inc(i);
           end;

           // Carrega os dados da informa��o GTV
           i := 0;
           while Leitor.rExtrai(4, 'infGTV', '', i + 1) <> '' do
           begin
             with infEvento.detEvento.infGTV.New do
             begin
               nDoc     := Leitor.rCampo(tcStr, 'nDoc');
               id       := Leitor.rCampo(tcStr, 'id');
               serie    := Leitor.rCampo(tcStr, 'serie');
               subserie := Leitor.rCampo(tcStr, 'subserie');
               dEmi     := Leitor.rCampo(tcDat, 'dEmi');
               nDV      := Leitor.rCampo(tcInt, 'nDV');
               qCarga   := Leitor.rCampo(tcDe4, 'qCarga');
               placa    := Leitor.rCampo(tcStr, 'placa');
               UF       := Leitor.rCampo(tcStr, 'UF');
               RNTRC    := Leitor.rCampo(tcStr, 'RNTRC');

               // Carrega os dados da informa��o de Especie
               j := 0;
               while Leitor.rExtrai(5, 'infEspecie', '', j + 1) <> '' do
               begin
                 with infEvento.detEvento.infGTV.Items[i].infEspecie.New do
                 begin
                   tpEspecie := StrToTEspecie(Ok, Leitor.rCampo(tcStr, 'tpEspecie'));
                   vEspecie  := Leitor.rCampo(tcDe2, 'vEspecie');
                 end;
                 inc(j);
               end;

               if Leitor.rExtrai(5, 'rem') <> '' then
               begin
                 rem.CNPJCPF := Leitor.rCampoCNPJCPF;
                 rem.IE      := Leitor.rCampo(tcStr, 'IE');
                 rem.UF      := Leitor.rCampo(tcStr, 'UF');
                 rem.xNome   := Leitor.rCampo(tcStr, 'xNome');
               end;

               if Leitor.rExtrai(5, 'dest') <> '' then
               begin
                 dest.CNPJCPF := Leitor.rCampoCNPJCPF;
                 dest.IE      := Leitor.rCampo(tcStr, 'IE');
                 dest.UF      := Leitor.rCampo(tcStr, 'UF');
                 dest.xNome   := Leitor.rCampo(tcStr, 'xNome');
               end;
             end;
             inc(i);
           end;

           // Carrega os dados da informa��o de Entrega
           i := 0;
           while Leitor.rExtrai(4, 'infEntrega', '', i + 1) <> '' do
           begin
             with infEvento.detEvento.infEntrega.New do
               chNFe := Leitor.rCampo(tcStr, 'chNFe');

             inc(i);
           end;
         end;
      end;

      if Leitor.rExtrai(2, 'Signature', '', i + 1) <> '' then
      begin
        signature.URI             := Leitor.rAtributo('Reference URI=');
        signature.DigestValue     := Leitor.rCampo(tcStr, 'DigestValue');
        signature.SignatureValue  := Leitor.rCampo(tcStr, 'SignatureValue');
        signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
      end;

      Result := True;
    end;

    if (Leitor.rExtrai(1, 'retEnvEvento') <> '') or
       (Leitor.rExtrai(1, 'retEventoCTe') <> '') or
       (Leitor.rExtrai(1, 'retEvento') <> '') then
    begin
      i := 0;
      Fversao := Leitor.rAtributo('versao');

      while Leitor.rExtrai(2, 'infEvento', '', i + 1) <> '' do
       begin
         FretEvento.New;

         FretEvento.Items[i].FRetInfEvento.XML := Leitor.Grupo;

         FretEvento.Items[i].FRetInfEvento.Id       := Leitor.rAtributo('Id', 'infEvento');
         FretEvento.Items[i].FRetInfEvento.tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
         FretEvento.Items[i].FRetInfEvento.verAplic := Leitor.rCampo(tcStr, 'verAplic');
         FretEvento.Items[i].FRetInfEvento.cOrgao   := Leitor.rCampo(tcInt, 'cOrgao');
         FretEvento.Items[i].FRetInfEvento.cStat    := Leitor.rCampo(tcInt, 'cStat');
         FretEvento.Items[i].FRetInfEvento.xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');

         // Os campos abaixos seram retornados caso o cStat = 134 ou 135 ou 136
         FretEvento.Items[i].FRetInfEvento.chCTe       := Leitor.rCampo(tcStr, 'chCTe');
         FretEvento.Items[i].FRetInfEvento.tpEvento    := StrToTpEventoCTe(ok,Leitor.rCampo(tcStr, 'tpEvento'));
         FretEvento.Items[i].FRetInfEvento.xEvento     := Leitor.rCampo(tcStr, 'xEvento');
         FretEvento.Items[i].FRetInfEvento.nSeqEvento  := Leitor.rCampo(tcInt, 'nSeqEvento');
         FretEvento.Items[i].FRetInfEvento.dhRegEvento := Leitor.rCampo(tcDatHor, 'dhRegEvento');
         FretEvento.Items[i].FRetInfEvento.nProt       := Leitor.rCampo(tcStr, 'nProt');

         tpAmb   := FretEvento.Items[i].FRetInfEvento.tpAmb;
         cStat   := FretEvento.Items[i].FRetInfEvento.cStat;
         xMotivo := FretEvento.Items[i].FRetInfEvento.xMotivo;

         inc(i);
       end;

      if i = 0 then
        FretEvento.New;

      Result := True;
    end;
  except
    result := False;
  end;
end;

end.
