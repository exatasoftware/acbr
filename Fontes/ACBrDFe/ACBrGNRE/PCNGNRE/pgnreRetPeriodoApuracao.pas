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

unit pgnreRetPeriodoApuracao;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor,
  pgnreConfigUF;
(*
 pgnreConversao;
*)

type
  TRetInfPeriodoApuracaoCollection = class;
  TRetInfPeriodoApuracaoCollectionItem = class;
  TRetPeriodoApuracao = class;

  TRetInfPeriodoApuracaoCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TRetInfPeriodoApuracaoCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfPeriodoApuracaoCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRetInfPeriodoApuracaoCollectionItem;
    property Items[Index: Integer]: TRetInfPeriodoApuracaoCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfPeriodoApuracaoCollectionItem = class(TCollectionItem)
  private
    FRetPeriodoApuracao: TRetInfPeriodoApuracao;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property RetPeriodoApuracao: TRetInfPeriodoApuracao read FRetPeriodoApuracao write FRetPeriodoApuracao;
  end;

  TRetPeriodoApuracao = class(TPersistent)
  private
    FLeitor: TLeitor;
    FretPeriodoApuracao: TRetInfPeriodoApuracaoCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property retPeriodoApuracao: TRetInfPeriodoApuracaoCollection read FretPeriodoApuracao write FretPeriodoApuracao;
  end;

implementation

{ TRetInfPeriodoApuracaoCollection }

function TRetInfPeriodoApuracaoCollection.Add: TRetInfPeriodoApuracaoCollectionItem;
begin
  Result := TRetInfPeriodoApuracaoCollectionItem(inherited Add);
  Result.Create;
end;

constructor TRetInfPeriodoApuracaoCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TRetInfPeriodoApuracaoCollectionItem);
end;

function TRetInfPeriodoApuracaoCollection.GetItem(
  Index: Integer): TRetInfPeriodoApuracaoCollectionItem;
begin
  Result := TRetInfPeriodoApuracaoCollectionItem(inherited GetItem(Index));
end;

procedure TRetInfPeriodoApuracaoCollection.SetItem(Index: Integer;
  Value: TRetInfPeriodoApuracaoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetInfPeriodoApuracaoCollectionItem }

constructor TRetInfPeriodoApuracaoCollectionItem.Create;
begin
  FRetPeriodoApuracao := TRetInfPeriodoApuracao.Create;
end;

destructor TRetInfPeriodoApuracaoCollectionItem.Destroy;
begin
  FRetPeriodoApuracao.Free;
  inherited;
end;


{ TRetPeriodoApuracao }

constructor TRetPeriodoApuracao.Create;
begin
  FLeitor := TLeitor.Create;
  FretPeriodoApuracao := TRetInfPeriodoApuracaoCollection.Create(Self);
end;

destructor TRetPeriodoApuracao.Destroy;
begin
  FLeitor.Free;
  FretPeriodoApuracao.Free;
  inherited;
end;

function TRetPeriodoApuracao.LerXml: Boolean;
var i: Integer;
begin
  Result := False;
  try
    i := 0;
    if Leitor.rExtrai(1, 'ns1:periodosApuracao') <> '' then
    begin
      while Leitor.rExtrai(2, 'ns1:periodoApuracao', '', i + 1) <> '' do
      begin
        retPeriodoApuracao.Add;
        retPeriodoApuracao.Items[i].RetPeriodoApuracao.codigo    := Leitor.rCampo(tcInt, 'ns1:codigo');
        retPeriodoApuracao.Items[i].RetPeriodoApuracao.descricao := Leitor.rCampo(tcStr, 'ns1:descricao');
        inc(i);
      end;

      if i = 0
       then retPeriodoApuracao.Add;

      Result := True;
    end;
  except
    Result := false;
  end;
end;

end.
