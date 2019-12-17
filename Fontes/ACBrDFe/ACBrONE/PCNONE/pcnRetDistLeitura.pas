{******************************************************************************}
{ Projeto: Componente ACBrONE                                                  }
{  Operador Nacional dos Estados - ONE                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2019                                        }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 14/10/2019: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnRetDistLeitura;

interface

uses
  SysUtils, Classes, Contnrs,
  pcnConversao, pcnLeitor, pcnEnvRecepcaoLeitura;

type
  TLeituraCollection     = class;
  TLeituraCollectionItem = class;

  TLeituraCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TLeituraCollectionItem;
    procedure SetItem(Index: Integer; Value: TLeituraCollectionItem);
  public
    function New: TLeituraCollectionItem;
    property Items[Index: Integer]: TLeituraCollectionItem read GetItem write SetItem; default;
  end;

  TLeituraCollectionItem = class(TObject)
  private
    // Atributos do resumo do DFe ou Evento
    FNSU: String;
    Fschema: TSchemaDFe;
    FRecepcaoLeitura: TRecepcaoLeitura;
    FXML: String;

  public
    constructor Create;
    destructor Destroy; override;

    property NSU: String             read FNSU        write FNSU;
    property schema: TSchemaDFe      read Fschema     write Fschema;
    property RecepcaoLeitura: TRecepcaoLeitura read FRecepcaoLeitura write FRecepcaoLeitura;
    property XML: String             read FXML        write FXML;
  end;

  TRetDistLeitura = class
  private
    FLeitor: TLeitor;

    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhResp: TDateTime;
    FultNSU: String;
    FultNSUONE: String;

    FXML: AnsiString;
    FLeitura: TLeituraCollection;

    procedure SetLeitura(const Value: TLeituraCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
    function LerXMLFromFile(Const CaminhoArquivo: String): Boolean;

    property Leitor: TLeitor             read FLeitor    write FLeitor;
    property versao: String              read Fversao    write Fversao;
    property tpAmb: TpcnTipoAmbiente     read FtpAmb     write FtpAmb;
    property verAplic: String            read FverAplic  write FverAplic;
    property cStat: Integer              read FcStat     write FcStat;
    property xMotivo: String             read FxMotivo   write FxMotivo;
    property dhResp: TDateTime           read FdhResp    write FdhResp;
    property ultNSU: String              read FultNSU    write FultNSU;
    property ultNSUONE: String           read FultNSUONE write FultNSUONE;
    property Leitura: TLeituraCollection read FLeitura   write SetLeitura;
    property XML: AnsiString             read FXML       write FXML;
  end;

implementation

uses
  pcnAuxiliar,
  ACBrUtil, pcnConversaoONE;

{ TLeituraCollection }

function TLeituraCollection.GetItem(Index: Integer): TLeituraCollectionItem;
begin
  Result := TLeituraCollectionItem(inherited GetItem(Index));
end;

procedure TLeituraCollection.SetItem(Index: Integer;
  Value: TLeituraCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TLeituraCollection.New: TLeituraCollectionItem;
begin
  Result := TLeituraCollectionItem.Create;
  Add(Result);
end;

{ TLeituraCollectionItem }

constructor TLeituraCollectionItem.Create;
begin
  inherited Create;

  FRecepcaoLeitura := TRecepcaoLeitura.Create;
end;

destructor TLeituraCollectionItem.Destroy;
begin
  FRecepcaoLeitura.Free;

  inherited;
end;

{ TRetDistLeitura }

constructor TRetDistLeitura.Create;
begin
  inherited Create;

  FLeitor  := TLeitor.Create;
  FLeitura := TLeituraCollection.Create();
end;

destructor TRetDistLeitura.Destroy;
begin
  FLeitor.Free;
  FLeitura.Free;

  inherited;
end;

procedure TRetDistLeitura.SetLeitura(const Value: TLeituraCollection);
begin
  FLeitura := Value;
end;

function TRetDistLeitura.LerXml: boolean;
var
  Ok: boolean;
  i: Integer;
//  StrAux, StrDecod: AnsiString;
begin
  Result := False;

  try
    FXML := Self.Leitor.Arquivo;

    if (Leitor.rExtrai(1, 'retOneDistLeitura') <> '') then
    begin
      Fversao    := Leitor.rAtributo('versao', 'retOneDistLeitura');
      FtpAmb     := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic  := Leitor.rCampo(tcStr, 'verAplic');
      FcStat     := Leitor.rCampo(tcInt, 'cStat');
      FxMotivo   := Leitor.rCampo(tcStr, 'xMotivo');
      FdhResp    := Leitor.rCampo(tcDatHor, 'dhResp');
      FultNSU    := Leitor.rCampo(tcStr, 'ultNSU');
      FultNSUONE := Leitor.rCampo(tcStr, 'ultNSUONE');

      i := 0;
      while Leitor.rExtrai(2, 'leitura', '', i + 1) <> '' do
      begin
        FLeitura.New;
        FLeitura.Items[i].FNSU   := Leitor.rAtributo('NSU', 'leitura');
        FLeitura.Items[i].schema := StrToSchemaDFe(Leitor.rAtributo('schema', 'leitura'));
        FLeitura.Items[i].XML    := RetornarConteudoEntre(Leitor.Grupo, '>', '</leitura');

        if (Leitor.rExtrai(3, 'oneRecepLeitura')) <> '' then
        begin
          with FLeitura.Items[i].RecepcaoLeitura do
          begin
            Versao   := Leitor.rAtributo('versao', 'oneRecepLeitura');
            tpAmb    := StrToTpAmb(Ok, Leitor.rCampo(tcStr, 'tpAmb'));
            verAplic := Leitor.rCampo(tcStr, 'verAplic');
            tpTransm := StrtotpTransm(Ok, Leitor.rCampo(tcStr, 'tpTransm'));
            dhTransm := Leitor.rCampo(tcDatHor, 'dhTransm');

            if (Leitor.rExtrai(3, 'infLeitura')) <> '' then
            begin
              cUF             := Leitor.rCampo(tcInt, 'cUF');
              dhPass          := Leitor.rCampo(tcDatHor, 'dhPass');
              CNPJOper        := Leitor.rCampo(tcStr, 'CNPJOper');
              cEQP            := Leitor.rCampo(tcStr, 'cEQP');
              latitude        := Leitor.rCampo(tcDe6, 'latitude');
              longitude       := Leitor.rCampo(tcDe6, 'longitude');
              tpSentido       := StrTotpSentido(Ok, Leitor.rCampo(tcStr, 'tpSentido'));
              placa           := Leitor.rCampo(tcStr, 'placa');
              tpVeiculo       := StrTotpVeiculo(Ok, Leitor.rCampo(tcStr, 'tpVeiculo'));
              velocidade      := Leitor.rCampo(tcInt, 'velocidade');
              foto            := Leitor.rCampo(tcStr, 'foto');
              indiceConfianca := Leitor.rCampo(tcInt, 'indiceConfianca');
              pesoBrutoTotal  := Leitor.rCampo(tcInt, 'pesoBrutoTotal');
              nroEixos        := Leitor.rCampo(tcInt, 'nroEixos');
            end;
          end;
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

function TRetDistLeitura.LerXMLFromFile(Const CaminhoArquivo: String): Boolean;
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

