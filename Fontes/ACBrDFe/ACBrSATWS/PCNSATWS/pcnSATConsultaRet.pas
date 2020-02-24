{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Ferreira de Moraes                        }
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

unit pcnSATConsultaRet;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnConversao, pcnLeitor, pcnSignature, ACBrUtil;

type
  TSATConsultaRet = class;
  TLoteCollectionItem   = class;
  TInfCFeCollectionItem = class;

  { TInfCFeCollection }
  TInfCFeCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TInfCFeCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfCFeCollectionItem);
  public
    function Add: TInfCFeCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfCFeCollectionItem;
    property Items[Index: Integer]: TInfCFeCollectionItem read GetItem write SetItem; default;
  end;

  { TInfCFeCollectionItem }
  TInfCFeCollectionItem = class(TObject)
  private
    FChave : String;
    FnCupom : String;
    FSituacao : String;
    FErros : String;
  public
    property Chave    : String        read FChave    write FChave;
    property nCupom   : String        read FnCupom   write FnCupom;
    property Situacao : String        read FSituacao write FSituacao;
    property Erros    : String        read FErros    write FErros;
  end;

  { TLoteCollection }
  TLoteCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TLoteCollectionItem;
    procedure SetItem(Index: Integer; Value: TLoteCollectionItem);
  public
    function Add: TLoteCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TLoteCollectionItem;
    property Items[Index: Integer]: TLoteCollectionItem read GetItem write SetItem; default;
  end;

  { TLoteCollectionItem }
  TLoteCollectionItem = class(TObject)
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
    constructor Create;
    destructor Destroy; override;

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

  TSATConsultaRet = class(TObject)
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

constructor TLoteCollectionItem.Create;
begin
  inherited;

  FInfCFe    := TInfCFeCollection.Create;
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
  Result := TInfCFeCollectionItem(inherited Items[Index]);
end;

procedure TInfCFeCollection.SetItem(Index: Integer; Value: TInfCFeCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TInfCFeCollection.Add: TInfCFeCollectionItem;
begin
  Result := Self.New;
end;

function TInfCFeCollection.New: TInfCFeCollectionItem;
begin
  Result := TInfCFeCollectionItem.Create();
  Self.Add(Result);
end;

{ TLoteCollection }

function TLoteCollection.GetItem(Index: Integer): TLoteCollectionItem;
begin
  Result := TLoteCollectionItem(inherited Items[Index]);
end;

procedure TLoteCollection.SetItem(Index: Integer; Value: TLoteCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TLoteCollection.Add: TLoteCollectionItem;
begin
  Result := Self.New;
end;

function TLoteCollection.New: TLoteCollectionItem;
begin
  Result := TLoteCollectionItem.Create;
  Self.Add(Result);
end;

{ TSATConsultaRet }

procedure TSATConsultaRet.SetLote(const Value: TLoteCollection);
begin
  FLote.Assign(Value);
end;

constructor TSATConsultaRet.Create;
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FLote   := TLoteCollection.Create;
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

        FLote.New;
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
          FLote.Items[i].InfCFe.New;
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

