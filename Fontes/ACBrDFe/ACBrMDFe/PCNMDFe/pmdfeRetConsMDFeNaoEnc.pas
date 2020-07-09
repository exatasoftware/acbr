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

unit pmdfeRetConsMDFeNaoEnc;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnAuxiliar, pcnConversao, pcnLeitor;

type

  TRetInfMDFeCollectionItem = class;

  TRetInfMDFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetInfMDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfMDFeCollectionItem);
  public
    function Add: TRetInfMDFeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetInfMDFeCollectionItem;
    property Items[Index: Integer]: TRetInfMDFeCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfMDFeCollectionItem = class(TObject)
  private
    FchMDFe: String;
    FnProt: String;
  public
    property chMDFe: String read FchMDFe write FchMDFe;
    property nProt: String  read FnProt  write FnProt;
  end;

  TRetConsMDFeNaoEnc = class(TObject)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FcUF: Integer;
    FInfMDFe: TRetInfMDFeCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
    property Leitor: TLeitor                read FLeitor   write FLeitor;
    property versao: String                 read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente        read FtpAmb    write FtpAmb;
    property verAplic: String               read FverAplic write FverAplic;
    property cStat: Integer                 read FcStat    write FcStat;
    property xMotivo: String                read FxMotivo  write FxMotivo;
    property cUF: Integer                   read FcUF      write FcUF;
    property InfMDFe: TRetInfMDFeCollection read FInfMDFe  write FInfMDFe;
  end;

implementation

{ TRetConsMDFeNaoEnc }

constructor TRetConsMDFeNaoEnc.Create;
begin
  inherited Create;
  FLeitor := TLeitor.Create;
end;

destructor TRetConsMDFeNaoEnc.Destroy;
begin
  FLeitor.Free;

  if Assigned(InfMDFe) then
    InfMDFe.Free;
  inherited;
end;

function TRetConsMDFeNaoEnc.LerXml: boolean;
var
  ok: boolean;
  i: Integer;
begin
  Result := False;
  
  try
    if leitor.rExtrai(1, 'retConsMDFeNaoEnc') <> '' then
    begin
      Fversao   := Leitor.rAtributo('versao', 'retConsMDFeNaoEnc');
      FtpAmb    := StrToTpAmb(ok, leitor.rCampo(tcStr, 'tpAmb'));
      FverAplic := leitor.rCampo(tcStr, 'verAplic');
      FcStat    := leitor.rCampo(tcInt, 'cStat');
      FxMotivo  := leitor.rCampo(tcStr, 'xMotivo');
      FcUF      := leitor.rCampo(tcInt, 'cUF');

      if Assigned(InfMDFe) then
        InfMDFe.Free;

      InfMDFe := TRetInfMDFeCollection.Create;
      i := 0;
      while Leitor.rExtrai(1, 'infMDFe', '', i + 1) <> '' do
      begin
        InfMDFe.New;
        InfMDFe.Items[i].FchMDFe := leitor.rCampo(tcStr, 'chMDFe');
        InfMDFe.Items[i].FnProt  := leitor.rCampo(tcStr, 'nProt');
        inc(i);
      end;

      Result := True;
    end;

  except
    Result := False;
  end;
end;

{ TRetInfMDFeCollection }

function TRetInfMDFeCollection.Add: TRetInfMDFeCollectionItem;
begin
  Result := Self.New;
end;

function TRetInfMDFeCollection.GetItem(Index: Integer): TRetInfMDFeCollectionItem;
begin
  Result := TRetInfMDFeCollectionItem(inherited Items[Index]);
end;

procedure TRetInfMDFeCollection.SetItem(Index: Integer;
  Value: TRetInfMDFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetInfMDFeCollection.New: TRetInfMDFeCollectionItem;
begin
  Result := TRetInfMDFeCollectionItem.Create;
  Self.Add(Result);
end;

end.

