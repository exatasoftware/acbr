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

unit pgnreRetProduto;

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
  TRetInfProdutoCollection = class;
  TRetInfProdutoCollectionItem = class;
  TRetProduto = class;

  TRetInfProdutoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TRetInfProdutoCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfProdutoCollectionItem);
  public
    function Add: TRetInfProdutoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TRetInfProdutoCollectionItem;
    property Items[Index: Integer]: TRetInfProdutoCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfProdutoCollectionItem = class(TObject)
  private
    FRetProduto: TRetInfProduto;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property RetProduto: TRetInfProduto read FRetProduto write FRetProduto;
  end;

  TRetProduto = class(TObject)
  private
    FLeitor: TLeitor;
    FretProduto: TRetInfProdutoCollection;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    property Leitor: TLeitor read FLeitor write FLeitor;
    property retProduto: TRetInfProdutoCollection read FretProduto write FretProduto;
  end;

implementation

{ TRetInfProdutoCollection }

function TRetInfProdutoCollection.Add: TRetInfProdutoCollectionItem;
begin
  Result := Self.New;
end;

function TRetInfProdutoCollection.GetItem(
  Index: Integer): TRetInfProdutoCollectionItem;
begin
  Result := TRetInfProdutoCollectionItem(inherited Items[Index]);
end;

function TRetInfProdutoCollection.New: TRetInfProdutoCollectionItem;
begin
  Result := TRetInfProdutoCollectionItem.Create();
  Self.Add(Result);
end;

procedure TRetInfProdutoCollection.SetItem(Index: Integer;
  Value: TRetInfProdutoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

{ TRetInfProdutoCollectionItem }

constructor TRetInfProdutoCollectionItem.Create;
begin
  FRetProduto := TRetInfProduto.Create;
end;

destructor TRetInfProdutoCollectionItem.Destroy;
begin
  FRetProduto.Free;

  inherited;
end;

{ TRetProduto }

constructor TRetProduto.Create;
begin
  FLeitor := TLeitor.Create;
  FretProduto := TRetInfProdutoCollection.Create;
end;

destructor TRetProduto.Destroy;
begin
  FLeitor.Free;
  FretProduto.Free;

  inherited;
end;

function TRetProduto.LerXml: Boolean;
var i: Integer;
begin
  Result := False;

  try
    i := 0;
    if Leitor.rExtrai(1, 'ns1:produtos') <> '' then
    begin
      while Leitor.rExtrai(2, 'ns1:produto', '', i + 1) <> '' do
      begin
        retProduto.New;
        retProduto.Items[i].RetProduto.codigo    := Leitor.rCampo(tcInt, 'ns1:codigo');
        retProduto.Items[i].RetProduto.descricao := Leitor.rCampo(tcStr, 'ns1:descricao');
        inc(i);
      end;

      if i = 0 then
        retProduto.New;

      Result := True;
    end;
  except
    Result := false;
  end;
end;

end.
