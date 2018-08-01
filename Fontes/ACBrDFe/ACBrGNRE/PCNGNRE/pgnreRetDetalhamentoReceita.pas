{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
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

{******************************************************************************
|* Historico
|*
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit pgnreRetDetalhamentoReceita;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor,
  pgnreConfigUF;
(*
 pgnreConversao;
*)
type
  TRetInfDetalhamentoReceitaCollection = class;
  TRetInfDetalhamentoReceitaCollectionItem = class;
  TRetDetalhamentoReceita = class;

  TRetInfDetalhamentoReceitaCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TRetInfDetalhamentoReceitaCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfDetalhamentoReceitaCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRetInfDetalhamentoReceitaCollectionItem;
    property Items[Index: Integer]: TRetInfDetalhamentoReceitaCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfDetalhamentoReceitaCollectionItem = class(TCollectionItem)
  private
    FRetDetalhamentoReceita: TRetInfDetalhamentoReceita;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property RetDetalhamentoReceita: TRetInfDetalhamentoReceita read FRetDetalhamentoReceita write FRetDetalhamentoReceita;
  end;

  TRetDetalhamentoReceita = class(TPersistent)
  private
    FLeitor: TLeitor;
    FretDetalhamentoReceita: TRetInfDetalhamentoReceitaCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property retDetalhamentoReceita: TRetInfDetalhamentoReceitaCollection read FretDetalhamentoReceita write FretDetalhamentoReceita;
  end;

implementation

{ TRetDetalhamentoReceitaCollection }

function TRetInfDetalhamentoReceitaCollection.Add: TRetInfDetalhamentoReceitaCollectionItem;
begin
  Result := TRetInfDetalhamentoReceitaCollectionItem(inherited Add);
  Result.Create;
end;

constructor TRetInfDetalhamentoReceitaCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TRetInfDetalhamentoReceitaCollectionItem);
end;

function TRetInfDetalhamentoReceitaCollection.GetItem(
  Index: Integer): TRetInfDetalhamentoReceitaCollectionItem;
begin
  Result := TRetInfDetalhamentoReceitaCollectionItem(inherited GetItem(Index));
end;

procedure TRetInfDetalhamentoReceitaCollection.SetItem(Index: Integer;
  Value: TRetInfDetalhamentoReceitaCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetDetalhamentoReceitaCollectionItem }

constructor TRetInfDetalhamentoReceitaCollectionItem.Create;
begin
  FRetDetalhamentoReceita := TRetInfDetalhamentoReceita.Create;
end;

destructor TRetInfDetalhamentoReceitaCollectionItem.Destroy;
begin
  FRetDetalhamentoReceita.Free;
  inherited;
end;

{ TRetDetalhamentosReceita }

constructor TRetDetalhamentoReceita.Create;
begin
  FLeitor := TLeitor.Create;
  FretDetalhamentoReceita := TRetInfDetalhamentoReceitaCollection.Create(Self);
end;

destructor TRetDetalhamentoReceita.Destroy;
begin
  FLeitor.Free;
  FretDetalhamentoReceita.Free;
  inherited;
end;

function TRetDetalhamentoReceita.LerXml: Boolean;
var i: Integer;
begin
  Result := False;
  try
    i := 0;
    if Leitor.rExtrai(1, 'ns1:detalhamentosReceita') <> '' then
    begin
      while Leitor.rExtrai(2, 'ns1:detalhamentoReceita', '', i + 1) <> '' do
      begin
        retDetalhamentoReceita.Add;
        retDetalhamentoReceita.Items[i].RetDetalhamentoReceita.codigo    := Leitor.rCampo(tcInt, 'ns1:codigo');
        retDetalhamentoReceita.Items[i].RetDetalhamentoReceita.descricao := Leitor.rCampo(tcStr, 'ns1:descricao');
        inc(i);
      end;

      if i = 0
       then retDetalhamentoReceita.Add;

      Result := True;       
    end;
  except
    Result := false;
  end;
end;

end.
 