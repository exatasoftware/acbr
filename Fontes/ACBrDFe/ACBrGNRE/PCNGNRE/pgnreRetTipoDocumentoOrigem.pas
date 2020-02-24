{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Juliomar Marchetti                              }
{                              Claudemir Vitor Pereira                         }
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

unit pgnreRetTipoDocumentoOrigem;

interface

uses
  SysUtils, Classes,
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  ACBrBase,
  pcnAuxiliar, pcnConversao, pcnLeitor, pgnreConfigUF;

type
  TRetInfTipoDocumentoOrigemCollection = class;
  TRetInfTipoDocumentoOrigemCollectionItem = class;
  TRetTipoDocumentoOrigem = class;

  TRetInfTipoDocumentoOrigemCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetInfTipoDocumentoOrigemCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfTipoDocumentoOrigemCollectionItem);
  public
    function Add: TRetInfTipoDocumentoOrigemCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetInfTipoDocumentoOrigemCollectionItem;
    property Items[Index: Integer]: TRetInfTipoDocumentoOrigemCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfTipoDocumentoOrigemCollectionItem = class(TObject)
  private
    FRetTipoDocumentoOrigem: TRetInfTipoDocumentoOrigem;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property RetTipoDocumentoOrigem: TRetInfTipoDocumentoOrigem read FRetTipoDocumentoOrigem write FRetTipoDocumentoOrigem;
  end;

  TRetTipoDocumentoOrigem = class(TObject)
  private
    FLeitor: TLeitor;
    FretTipoDocumentoOrigem: TRetInfTipoDocumentoOrigemCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property Leitor: TLeitor read FLeitor write FLeitor;
    property retTipoDocumentoOrigem: TRetInfTipoDocumentoOrigemCollection read FretTipoDocumentoOrigem write FretTipoDocumentoOrigem;
  end;

implementation

{ TRetInfTipoDocumentoOrigemCollection }

function TRetInfTipoDocumentoOrigemCollection.Add: TRetInfTipoDocumentoOrigemCollectionItem;
begin
  Result := Self.New;
end;

function TRetInfTipoDocumentoOrigemCollection.GetItem(
  Index: Integer): TRetInfTipoDocumentoOrigemCollectionItem;
begin
  Result := TRetInfTipoDocumentoOrigemCollectionItem(inherited Items[Index]);
end;

function TRetInfTipoDocumentoOrigemCollection.New: TRetInfTipoDocumentoOrigemCollectionItem;
begin
  Result := TRetInfTipoDocumentoOrigemCollectionItem.Create();
  Self.Add(Result);
end;

procedure TRetInfTipoDocumentoOrigemCollection.SetItem(Index: Integer;
  Value: TRetInfTipoDocumentoOrigemCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetInfTipoDocumentoOrigemCollectionItem }

constructor TRetInfTipoDocumentoOrigemCollectionItem.Create;
begin
  FRetTipoDocumentoOrigem := TRetInfTipoDocumentoOrigem.Create;
end;

destructor TRetInfTipoDocumentoOrigemCollectionItem.Destroy;
begin
  FRetTipoDocumentoOrigem.Free;

  inherited;
end;

{ TRetTipoDocumentoOrigem }

constructor TRetTipoDocumentoOrigem.Create;
begin
  FLeitor := TLeitor.Create;
  FretTipoDocumentoOrigem := TRetInfTipoDocumentoOrigemCollection.Create;
end;

destructor TRetTipoDocumentoOrigem.Destroy;
begin
  FLeitor.Free;
  FretTipoDocumentoOrigem.Free;

  inherited;
end;

function TRetTipoDocumentoOrigem.LerXml: Boolean;
var i: Integer;
begin
  Result := False;

  try
    i := 0;
    if Leitor.rExtrai(1, 'ns1:tiposDocumentosOrigem') <> '' then
    begin
      while Leitor.rExtrai(2, 'ns1:tipoDocumentoOrigem', '', i + 1) <> '' do
      begin
        retTipoDocumentoOrigem.New;
        retTipoDocumentoOrigem.Items[i].RetTipoDocumentoOrigem.codigo    := Leitor.rCampo(tcInt, 'ns1:codigo');
        retTipoDocumentoOrigem.Items[i].RetTipoDocumentoOrigem.descricao := Leitor.rCampo(tcStr, 'ns1:descricao');
        inc(i);
      end;

      if i = 0 then
        retTipoDocumentoOrigem.New;

      Result := True;
    end;
  except
    Result := false;
  end;
end;

end.
