{******************************************************************************}
{ Projeto: Componente ACBrNF3e                                                 }
{  Nota Fiscal de Energia Eletrica Eletr�nica - NF3e                           }
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
|* 18/12/2019: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnRetConsSitNF3e;

interface

uses
  SysUtils, Classes, Contnrs,
  pcnConversao, pcnLeitor, pcnProcNF3e, pcnRetEnvEventoNF3e;

type

  TRetEventoNF3eCollectionItem = class(TObject)
  private
    FRetEventoNF3e: TRetEventoNF3e;
  public
    constructor Create;
    destructor Destroy; override;
    property RetEventoNF3e: TRetEventoNF3e read FRetEventoNF3e write FRetEventoNF3e;
  end;

  TRetEventoNF3eCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TRetEventoNF3eCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoNF3eCollectionItem);
  public
    function New: TRetEventoNF3eCollectionItem;
    property Items[Index: Integer]: TRetEventoNF3eCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsSitNF3e = class(TObject)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FdhRecbto: TDateTime;
    FchNF3e: String;
    FprotNF3e: TProcNF3e;
    FprocEventoNF3e: TRetEventoNF3eCollection;
    FnRec: String;
    FXMLprotNF3e: String;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;

    property Leitor: TLeitor                          read FLeitor         write FLeitor;
    property versao: String                           read Fversao         write Fversao;
    property tpAmb: TpcnTipoAmbiente                  read FtpAmb          write FtpAmb;
    property verAplic: String                         read FverAplic       write FverAplic;
    property cStat: Integer                           read FcStat          write FcStat;
    property xMotivo: String                          read FxMotivo        write FxMotivo;
    property cUF: Integer                             read FcUF            write FcUF;
    property dhRecbto: TDateTime                      read FdhRecbto       write FdhRecbto;
    property chNF3e: String                           read FchNF3e         write FchNF3e;
    property protNF3e: TProcNF3e                      read FprotNF3e       write FprotNF3e;
    property procEventoNF3e: TRetEventoNF3eCollection read FprocEventoNF3e write FprocEventoNF3e;
    property nRec: String                             read FnRec           write FnRec;
    property XMLprotNF3e: String                      read FXMLprotNF3e    write FXMLprotNF3e;
  end;

implementation

{ TRetEventoCollection }

function TRetEventoNF3eCollection.GetItem(Index: Integer): TRetEventoNF3eCollectionItem;
begin
  Result := TRetEventoNF3eCollectionItem(inherited GetItem(Index));
end;

procedure TRetEventoNF3eCollection.SetItem(Index: Integer;
  Value: TRetEventoNF3eCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetEventoCollectionItem }

constructor TRetEventoNF3eCollectionItem.Create;
begin
  inherited Create;

  FRetEventoNF3e := TRetEventoNF3e.Create;
end;

destructor TRetEventoNF3eCollectionItem.Destroy;
begin
  FRetEventoNF3e.Free;

  inherited;
end;

function TRetEventoNF3eCollection.New: TRetEventoNF3eCollectionItem;
begin
  Result := TRetEventoNF3eCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetConsSitNF3e }

constructor TRetConsSitNF3e.Create;
begin
  inherited Create;

  FLeitor   := TLeitor.Create;
  FprotNF3e := TProcNF3e.create;
end;

destructor TRetConsSitNF3e.Destroy;
begin
  FLeitor.Free;
  FprotNF3e.Free;

  if Assigned(procEventoNF3e) then
    procEventoNF3e.Free;

  inherited;
end;

function TRetConsSitNF3e.LerXml: Boolean;
var
  ok: Boolean;
  i: Integer;
begin
  Result := False;
  try
    if leitor.rExtrai(1, 'retConsSitNF3e') <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao');
      FtpAmb    := StrToTpAmb(ok, leitor.rCampo(tcStr, 'tpAmb'));
      FcUF      := leitor.rCampo(tcInt, 'cUF');
      FverAplic := leitor.rCampo(tcStr, 'verAplic');

      FnRec     := leitor.rCampo(tcStr, 'nRec');

      FcStat    := leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := leitor.rCampo(tcStr, 'xMotivo');
      FdhRecbto := leitor.rCampo(tcDatHor, 'dhRecbto');
      FchNF3e   := leitor.rCampo(tcStr, 'chNF3e');

      case FcStat of
        100,101,104,110,150,151,155,301,302,303:
          begin
            if (Leitor.rExtrai(1, 'protNF3e') <> '') then
            begin
              // A propriedade XMLprotNF3e contem o XML que traz o resultado do
              // processamento da NF3-e.
              XMLprotNF3e := Leitor.Grupo;

              if Leitor.rExtrai(2, 'infProt') <> '' then
              begin
                protNF3e.tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
                protNF3e.verAplic := Leitor.rCampo(tcStr, 'verAplic');
                protNF3e.chNF3e   := Leitor.rCampo(tcStr, 'chNF3e');
                protNF3e.dhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
                protNF3e.nProt    := Leitor.rCampo(tcStr, 'nProt');
                protNF3e.digVal   := Leitor.rCampo(tcStr, 'digVal');
                protNF3e.cStat    := Leitor.rCampo(tcInt, 'cStat');
                protNF3e.xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
                protNF3e.cMsg     := Leitor.rCampo(tcInt, 'cMsg');
                protNF3e.xMsg     := Leitor.rCampo(tcStr, 'xMsg');
              end;
            end;
          end;
      end;

      if Assigned(procEventoNF3e) then
        procEventoNF3e.Free;

      procEventoNF3e := TRetEventoNF3eCollection.Create;
      i := 0;

      while Leitor.rExtrai(1, 'procEventoNF3e', '', i + 1) <> '' do
      begin
        procEventoNF3e.New;
        procEventoNF3e.Items[i].RetEventoNF3e.Leitor.Arquivo := Leitor.Grupo;
        procEventoNF3e.Items[i].RetEventoNF3e.XML            := Leitor.Grupo;
        procEventoNF3e.Items[i].RetEventoNF3e.LerXml;
        inc(i);
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

end.

