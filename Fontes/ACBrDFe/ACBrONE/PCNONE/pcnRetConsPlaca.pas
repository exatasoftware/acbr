{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit pcnRetConsPlaca;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  ACBrBase, ACBrUtil.Base, ACBrUtil.FilesIO, synacode,
  pcnAuxiliar, pcnConversao, pcnLeitor;

type
  TinfMDFeCollectionItem = class(TObject)
  private
    FchMDFe: String;

  public
    property chMDFe: String read FchMDFe write FchMDFe;
  end;

  TinfMDFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TinfMDFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TinfMDFeCollectionItem);
  public
    function New: TinfMDFeCollectionItem;
    property Items[Index: Integer]: TinfMDFeCollectionItem read GetItem write SetItem; default;
  end;

  TRetConsPlaca = class(TObject)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhResp: TDateTime;
    FNSU: String;
    FleituraComp: String;
    FinfMDFe: TinfMDFeCollection;

    procedure SetinfMDFe(const Value: TinfMDFeCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;

    property Leitor: TLeitor         read FLeitor      write FLeitor;
    property versao: String          read Fversao      write Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb       write FtpAmb;
    property verAplic: String        read FverAplic    write FverAplic;
    property cStat: Integer          read FcStat       write FcStat;
    property xMotivo: String         read FxMotivo     write FxMotivo;
    property dhResp: TDateTime       read FdhResp      write FdhResp;
    property NSU: String             read FNSU         write FNSU;
    property leituraComp: String     read FleituraComp write FleituraComp;
    property infMDFe: TinfMDFeCollection read FinfMDFe  write SetinfMDFe;
  end;

implementation

{ TRetConsPlaca }

constructor TRetConsPlaca.Create;
begin
  inherited Create;

  FLeitor := TLeitor.Create;
  FinfMDFe := TinfMDFeCollection.Create();
end;

destructor TRetConsPlaca.Destroy;
begin
  FLeitor.Free;
  FinfMDFe.Free;

  inherited;
end;

function TRetConsPlaca.LerXml: boolean;
var
  ok: boolean;
  auxStr: AnsiString;
  i: Integer;
begin
  Result := False;

  FcStat := 0;

  try
    if Leitor.rExtrai(1, 'retOneConsPorPlaca') <> '' then
    begin
      versao   := Leitor.rAtributo('versao', 'retOneConsFoto');
      tpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      verAplic := Leitor.rCampo(tcStr, 'verAplic');
      cStat    := Leitor.rCampo(tcInt, 'cStat');
      xMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
      dhResp   := Leitor.rCampo(tcDatHor, 'dhResp');

      if Leitor.rExtrai(2, 'loteDistLeitura') <> '' then
      begin
        if Leitor.rExtrai(3, 'leituraCompactada') <> '' then
        begin
          NSU := Leitor.rAtributo('NSU', 'leituraCompactada');
          auxStr := Leitor.rCampo(tcStr, 'leituraComp');

          if auxStr <> '' then
            leituraComp := UnZip(DecodeBase64(auxStr));

          i := 0;
          while Leitor.rExtrai(3, 'infMDFe', '', i + 1) <> '' do
          begin
            FinfMDFe.New;
            FinfMDFe.Items[i].chMDFe := Leitor.rCampo(tcStr, 'chMDFe');

            Inc(i);
          end;
        end;
      end;

      Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure TRetConsPlaca.SetinfMDFe(const Value: TinfMDFeCollection);
begin
  FinfMDFe := Value;
end;

{ TinfMDFeCollection }

function TinfMDFeCollection.GetItem(Index: Integer): TinfMDFeCollectionItem;
begin
  Result := TinfMDFeCollectionItem(inherited Items[Index]);
end;

function TinfMDFeCollection.New: TinfMDFeCollectionItem;
begin
  Result := TinfMDFeCollectionItem.Create;
  Add(Result);
end;

procedure TinfMDFeCollection.SetItem(Index: Integer;
  Value: TinfMDFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

end.

