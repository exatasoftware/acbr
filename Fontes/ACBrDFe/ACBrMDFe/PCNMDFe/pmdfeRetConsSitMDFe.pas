{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
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
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit pmdfeRetConsSitMDFe;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnAuxiliar, pcnConversao, pcnLeitor,
  pmdfeProcMDFe, pmdfeRetEnvEventoMDFe;

type

  TRetEventoMDFeCollectionItem = class(TObject)
  private
    FRetEventoMDFe: TRetEventoMDFe;
  public
    constructor Create;
    destructor Destroy; override;
    property RetEventoMDFe: TRetEventoMDFe read FRetEventoMDFe write FRetEventoMDFe;
  end;

  TRetEventoMDFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetEventoMDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetEventoMDFeCollectionItem);
  public
    function Add: TRetEventoMDFeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetEventoMDFeCollectionItem;
    property Items[Index: Integer]: TRetEventoMDFeCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsSitMDFe = class(TObject)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FchMDFe: String;
    FprotMDFe: TProcMDFe;
    FprocEventoMDFe: TRetEventoMDFeCollection;
    FXMLprotMDFe: String;
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
    property chMDFe: String                           read FchMDFe         write FchMDFe;
    property protMDFe: TProcMDFe                      read FprotMDFe       write FprotMDFe;
    property procEventoMDFe: TRetEventoMDFeCollection read FprocEventoMDFe write FprocEventoMDFe;
    property XMLprotMDFe: String                      read FXMLprotMDFe    write FXMLprotMDFe;
  end;

implementation

{ TRetConsSitMDFe }

constructor TRetConsSitMDFe.Create;
begin
  inherited Create;
  FLeitor   := TLeitor.Create;
  FprotMDFe := TProcMDFe.create;
end;

destructor TRetConsSitMDFe.Destroy;
begin
  FLeitor.Free;
  FprotMDFe.Free;
  if Assigned(procEventoMDFe) then
    procEventoMDFe.Free;
  inherited;
end;

function TRetConsSitMDFe.LerXml: boolean;
var
  ok: boolean;
  i: Integer;
begin
  Result := False;
  
  try
    if leitor.rExtrai(1, 'retConsSitMDFe') <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao', 'retConsSitMDFe');
      FtpAmb    := StrToTpAmb(ok, leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic := leitor.rCampo(tcStr, 'verAplic');
      FcStat    := leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := leitor.rCampo(tcStr, 'xMotivo');
      FcUF      := leitor.rCampo(tcInt, 'cUF');

      { Caso o valor de FcStat for um dos relacionados abaixo ser� retornado
        o grupo protMDFe com as informa��es sobre a autoriza��o do MDF-e e uma
        ocorrecia do grupo procEventoMDFe para cada evento vinculado ao MDF-e.
        100 = Autorizado
        101 = Cancelado
        132 = Encerrado
      }
      if FcStat in [100, 101, 132] then
      begin
        if (Leitor.rExtrai(1, 'protMDFe') <> '') then
        begin
          // A propriedade XMLprotMDFe contem o XML que traz o resultado do
          // processamento do MDF-e.
          XMLprotMDFe := Leitor.Grupo;

          if Leitor.rExtrai(2, 'infProt') <> '' then
          begin
            protMDFe.tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
            protMDFe.verAplic := Leitor.rCampo(tcStr, 'verAplic');
            protMDFe.chMDFe   := Leitor.rCampo(tcStr, 'chMDFe');
            protMDFe.dhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
            protMDFe.nProt    := Leitor.rCampo(tcStr, 'nProt');
            protMDFe.digVal   := Leitor.rCampo(tcStr, 'digVal');
            protMDFe.cStat    := Leitor.rCampo(tcInt, 'cStat');
            protMDFe.xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
            protMDFe.cMsg     := Leitor.rCampo(tcInt, 'cMsg');
            protMDFe.xMsg     := Leitor.rCampo(tcStr, 'xMsg');
            FchMDFe           := protMDFe.chMDFe;
          end;
        end;
      end;

      if Assigned(procEventoMDFe) then
        procEventoMDFe.Free;
      procEventoMDFe := TRetEventoMDFeCollection.Create;
      i := 0;
      while Leitor.rExtrai(1, 'procEventoMDFe', '', i + 1) <> '' do
      begin
        procEventoMDFe.New;
        procEventoMDFe.Items[i].RetEventoMDFe.Leitor.Arquivo := Leitor.Grupo;
        procEventoMDFe.Items[i].RetEventoMDFe.XML := Leitor.Grupo;
        procEventoMDFe.Items[i].RetEventoMDFe.LerXml;
        inc(i);
      end;

      Result := True;
    end;

  except
    Result := False;
  end;
end;

{ TRetEventoMDFeCollection }

function TRetEventoMDFeCollection.Add: TRetEventoMDFeCollectionItem;
begin
  Result := Self.New;
end;

function TRetEventoMDFeCollection.GetItem(Index: Integer): TRetEventoMDFeCollectionItem;
begin
  Result := TRetEventoMDFeCollectionItem(inherited Items[Index]);
end;

procedure TRetEventoMDFeCollection.SetItem(Index: Integer;
  Value: TRetEventoMDFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetEventoMDFeCollection.New: TRetEventoMDFeCollectionItem;
begin
  Result := TRetEventoMDFeCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetEventoMDFeCollectionItem }

constructor TRetEventoMDFeCollectionItem.Create;
begin
  inherited Create;
  FRetEventoMDFe := TRetEventoMDFe.Create;
end;

destructor TRetEventoMDFeCollectionItem.Destroy;
begin
  FRetEventoMDFe.Free;
  inherited;
end;

end.

