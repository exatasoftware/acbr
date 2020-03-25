{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{ Colaboradores neste arquivo: Italo Jurisato Junior                           }
{																			   }
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

unit pcnRetAdmCSCNFCe;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IfEnd}
  pcnConversao, pcnLeitor,
  ACBrBase;

type

  TRetdadosCscCollectionItem = class;
  TRetAdmCSCNFCe             = class;

  TRetdadosCscCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetdadosCscCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetdadosCscCollectionItem);
  public
    function Add: TRetdadosCscCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetdadosCscCollectionItem;
    property Items[Index: Integer]: TRetdadosCscCollectionItem read GetItem write SetItem; default;
  end;

  TRetdadosCscCollectionItem = class(TObject)
  private
    FidCsc: Integer;
    FcodigoCsc: String;
  public
    property idCsc: Integer    read FidCsc     write FidCsc;
    property codigoCsc: String read FcodigoCsc write FcodigoCsc;
  end;

  TRetAdmCSCNFCe = class(TObject)
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
  Result := Self.New;
end;

function TRetdadosCscCollection.GetItem(
  Index: Integer): TRetdadosCscCollectionItem;
begin
  Result := TRetdadosCscCollectionItem(inherited Items[Index]);
end;

procedure TRetdadosCscCollection.SetItem(Index: Integer;
  Value: TRetdadosCscCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TRetdadosCscCollection.New: TRetdadosCscCollectionItem;
begin
  Result := TRetdadosCscCollectionItem.Create;
  Self.Add(Result);
end;

{ TRetAdmCSCNFCe }

constructor TRetAdmCSCNFCe.Create;
begin
  inherited Create;
  FLeitor   := TLeitor.Create;
  FdadosCsc := TRetdadosCscCollection.Create;
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
         FdadosCsc.New;
         FdadosCsc.Items[i].FidCsc     := Leitor.rCampo(tcInt, 'idCsc');
         FdadosCsc.Items[i].FcodigoCsc := Leitor.rCampo(tcStr, 'codigoCsc');
         inc(i);
       end;

      if i = 0 then
      begin
        FdadosCsc.New;
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

