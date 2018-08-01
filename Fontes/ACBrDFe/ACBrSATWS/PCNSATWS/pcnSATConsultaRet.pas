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

unit pcnSATConsultaRet;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor, pcnSignature, ACBrUtil;

type
  TSATConsultaRet = class;
  TLoteCollectionItem   = class;
  TInfCFeCollectionItem = class;

  { TInfCFeCollection }
  TInfCFeCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfCFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfCFeCollectionItem);
  public
    constructor Create(AOwner: TLoteCollectionItem); reintroduce;
    function Add: TInfCFeCollectionItem;
    property Items[Index: Integer]: TInfCFeCollectionItem read GetItem write SetItem; default;
  end;

  { TInfCFeCollectionItem }
  TInfCFeCollectionItem = class(TCollectionItem)
  private
    FChave : String;
    FnCupom : String;
    FSituacao : String;
    FErros : String;
  published
    property Chave    : String        read FChave    write FChave;
    property nCupom   : String        read FnCupom   write FnCupom;
    property Situacao : String        read FSituacao write FSituacao;
    property Erros    : String        read FErros    write FErros;
  end;

  { TLoteCollection }
  TLoteCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TLoteCollectionItem;
    procedure SetItem(Index: Integer; Value: TLoteCollectionItem);
  public
    constructor Create(AOwner: TSATConsultaRet); reintroduce;
    function Add: TLoteCollectionItem;
    property Items[Index: Integer]: TLoteCollectionItem read GetItem write SetItem; default;
  end;

  { TLoteCollectionItem }
  TLoteCollectionItem = class(TCollectionItem)
  private
    FNRec            : String;
    FdhEnvioLote     : TDateTime;
    FdhProcessamento : TDateTime;
    FTipoLote        : String;
    FOrigem          : String;
    FQtdeCupoms      : Integer;
    FSituacaoLote    : String;
    FInfCFe          : TInfCFeCollection;
    FSignature       : TSignature;

    procedure SetInfCFe(AValue: TInfCFeCollection);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;

  published
    property NRec            : String      read FNRec            write FNRec;
    property dhEnvioLote     : TDateTime   read FdhEnvioLote     write FdhEnvioLote;
    property dhProcessamento : TDateTime   read FdhProcessamento write FdhProcessamento;
    property TipoLote        : String      read FTipoLote        write FTipoLote;
    property Origem          : String      read FOrigem          write FOrigem;
    property QtdeCupoms      : Integer     read FQtdeCupoms      write FQtdeCupoms;
    property SituacaoLote    : String      read FSituacaoLote    write FSituacaoLote;
    property InfCFe: TInfCFeCollection     read FInfCFe          write SetInfCFe;
    property Signature       : TSignature  read FSignature       write FSignature;
  end;


  { TSATConsultaRet }

  TSATConsultaRet = class(TPersistent)
  private
    FLeitor: TLeitor;
    FCNPJ  : String;
    FxNome : String;
    FMensagem : String;
    FLote: TLoteCollection;

    procedure SetLote(const Value: TLoteCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;

    property Leitor   : TLeitor         read FLeitor   write FLeitor;
  published
    property CNPJ     : String          read FCNPJ     write FCNPJ;
    property xNome    : String          read FxNome    write FxNome;
    property Mensagem : String          read FMensagem write FMensagem;
    property Lote     : TLoteCollection read FLote     write SetLote;
  end;

implementation

{ TLoteCollectionItem }

procedure TLoteCollectionItem.SetInfCFe(AValue: TInfCFeCollection);
begin
  FInfCFe.Assign(AValue);
end;

constructor TLoteCollectionItem.Create(ACollection: TCollection);
begin
  inherited;

  FInfCFe := TInfCFeCollection.Create(Self);
  FSignature := TSignature.Create;
end;

destructor TLoteCollectionItem.Destroy;
begin
  FSignature.Free;
  FInfCFe.Free;
  inherited Destroy;
end;

{ TInfCFeCollection }

function TInfCFeCollection.GetItem(Index: Integer): TInfCFeCollectionItem;
begin
  Result := TInfCFeCollectionItem(inherited GetItem(Index));
end;

procedure TInfCFeCollection.SetItem(Index: Integer; Value: TInfCFeCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

constructor TInfCFeCollection.Create(AOwner: TLoteCollectionItem);
begin
  inherited Create(TInfCFeCollectionItem);
end;

function TInfCFeCollection.Add: TInfCFeCollectionItem;
begin
  Result := TInfCFeCollectionItem(inherited Add);
end;

{ TLoteCollection }

function TLoteCollection.GetItem(Index: Integer): TLoteCollectionItem;
begin
  Result := TLoteCollectionItem(inherited GetItem(Index));
end;

procedure TLoteCollection.SetItem(Index: Integer; Value: TLoteCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

constructor TLoteCollection.Create(AOwner: TSATConsultaRet);
begin
  inherited Create(TLoteCollectionItem);
end;

function TLoteCollection.Add: TLoteCollectionItem;
begin
  Result := TLoteCollectionItem(inherited Add);
end;

{ TSATConsultaRet }

procedure TSATConsultaRet.SetLote(const Value: TLoteCollection);
begin
  FLote.Assign(Value);
end;

constructor TSATConsultaRet.Create;
begin
  FLeitor := TLeitor.Create;
  FLote := TLoteCollection.Create(Self);
end;

destructor TSATConsultaRet.Destroy;
begin
  FLote.Free;
  FLeitor.Free;
  inherited;
end;

function TSATConsultaRet.LerXml: Boolean;
var
  i, j: Integer;
begin
  i := 0;
  Result := False;
  try
    Leitor.Grupo := Leitor.Arquivo;
    Mensagem := trim(Leitor.rCampo(tcStr, 'Mensagem'));

    if Leitor.rExtrai(1, 'infContribuinte') <> '' then
    begin
      CNPJ := trim(Leitor.rCampo(tcStr, 'CNPJ'));
      if (CNPJ <> '') and (length(CNPJ) < 14) then
        CNPJ := PadLeft(CNPJ, 14, '0');

      xNome := trim(Leitor.rCampo(tcStr, 'xNome'));
    end;

    if Leitor.rExtrai(1, 'Lote') <> '' then
    begin
      while Leitor.rExtrai(1, 'Lote', '', i + 1) <> '' do
      begin

        FLote.Add;
        FLote[i].NRec            := Leitor.rCampo(tcStr, 'NRec');
        FLote[i].dhEnvioLote     := Leitor.rCampo(tcDatHorCFe, 'dhEnvioLote');
        FLote[i].dhProcessamento := Leitor.rCampo(tcDatHorCFe, 'dhProcessamento');
        FLote[i].TipoLote        := Leitor.rCampo(tcStr, 'TipoLote');
        FLote[i].Origem          := Leitor.rCampo(tcStr, 'Origem');
        FLote[i].QtdeCupoms      := Leitor.rCampo(tcStr, 'QtdeCupoms');
        FLote[i].SituacaoLote    := Leitor.rCampo(tcStr, 'SituacaoLote');

        with FLote[i].Signature do
        begin
          URI             := Leitor.rAtributo('Reference URI=');
          DigestValue     := Leitor.rCampo(tcStr, 'DigestValue');
          SignatureValue  := Leitor.rCampo(tcStr, 'SignatureValue');
          X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');
        end;

        j:= 0;
        while Leitor.rExtrai(2, 'Cfe', '', j + 1) <> '' do
        begin
          FLote.Items[i].InfCFe.Add;
          FLote.Items[i].InfCFe[j].Chave    :=  Leitor.rCampo(tcStr, 'Chave');
          FLote.Items[i].InfCFe[j].nCupom   :=  Leitor.rCampo(tcStr, 'nCupom');
          FLote.Items[i].InfCFe[j].Situacao :=  Leitor.rCampo(tcStr, 'Situacao');
          FLote.Items[i].InfCFe[j].Erros    :=  Leitor.rCampo(tcStr, 'cfeErros');
          Inc(J);
        end;
        Inc(I);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

