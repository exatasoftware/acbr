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

unit pgnreRetCampoAdicional;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor,
  pgnreConfigUF, ACBrUtil;
(*
 pgnreConversao;
*)
type
  TRetInfCampoAdicionalCollection = class;
  TRetInfCampoAdicionalCollectionItem = class;
  TRetCampoAdicional = class;

  TRetInfCampoAdicionalCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TRetInfCampoAdicionalCollectionItem;
    procedure SetItem(Index: Integer; Value: TRetInfCampoAdicionalCollectionItem);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TRetInfCampoAdicionalCollectionItem;
    property Items[Index: Integer]: TRetInfCampoAdicionalCollectionItem read GetItem write SetItem; default;
  end;

  TRetInfCampoAdicionalCollectionItem = class(TCollectionItem)
  private
    FRetCampoAdicional: TRetInfCampoAdicional;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property RetCampoAdicional: TRetInfCampoAdicional read FRetCampoAdicional write FRetCampoAdicional;
  end;

  TRetCampoAdicional = class(TPersistent)
  private
    FLeitor: TLeitor;
    FretCampoAdicional: TRetInfCampoAdicionalCollection;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property retCampoAdicional: TRetInfCampoAdicionalCollection read FretCampoAdicional write FretCampoAdicional;
  end;

implementation

{ TRetInfCamposAdicionaisCollection }

function TRetInfCampoAdicionalCollection.Add: TRetInfCampoAdicionalCollectionItem;
begin
  Result := TRetInfCampoAdicionalCollectionItem(inherited Add);
  Result.Create;
end;

constructor TRetInfCampoAdicionalCollection.Create(AOwner: TPersistent);
begin
  inherited Create(TRetInfCampoAdicionalCollectionItem);
end;

function TRetInfCampoAdicionalCollection.GetItem(
  Index: Integer): TRetInfCampoAdicionalCollectionItem;
begin
  Result := TRetInfCampoAdicionalCollectionItem(inherited GetItem(Index));
end;

procedure TRetInfCampoAdicionalCollection.SetItem(Index: Integer;
  Value: TRetInfCampoAdicionalCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TRetInfCamposAdicionaisCollectionItem }

constructor TRetInfCampoAdicionalCollectionItem.Create;
begin
  FRetCampoAdicional := TRetInfCampoAdicional.Create;
end;

destructor TRetInfCampoAdicionalCollectionItem.Destroy;
begin
  FRetCampoAdicional.Free;
  inherited;
end;

{ TRetCampoAdicional }

constructor TRetCampoAdicional.Create;
begin
  FLeitor := TLeitor.Create;
  FretCampoAdicional := TRetInfCampoAdicionalCollection.Create(Self);
end;

destructor TRetCampoAdicional.Destroy;
begin
  FLeitor.Free;
  FretCampoAdicional.Free;
  inherited;
end;

function TRetCampoAdicional.LerXml: Boolean;
var i: Integer;
begin
  Result := False;
  try
    i := 0;
    if Leitor.rExtrai(1, 'ns1:camposAdicionais') <> '' then
    begin
      while Leitor.rExtrai(2, 'ns1:campoAdicional', '', i + 1) <> '' do
      begin
        retCampoAdicional.Add;
        retCampoAdicional.Items[i].RetCampoAdicional.obrigatorio    := Leitor.rCampo(tcStr, 'ns1:obrigatorio');
        retCampoAdicional.Items[i].RetCampoAdicional.codigo         := StrToInt(SeparaDados(Leitor.Grupo, 'ns1:codigo'));
        retCampoAdicional.Items[i].RetCampoAdicional.tipo           := SeparaDados(Leitor.Grupo, 'ns1:tipo');
        retCampoAdicional.Items[i].RetCampoAdicional.tamanho        := Leitor.rCampo(tcInt, 'ns1:tamanho');
        if Pos('ns1:casasDecimais', Leitor.Grupo) > 0 then
          retCampoAdicional.Items[i].RetCampoAdicional.casasDecimais  := Leitor.rCampo(tcInt, 'ns1:casasDecimais');
        retCampoAdicional.Items[i].RetCampoAdicional.titulo         := Leitor.rCampo(tcStr, 'ns1:titulo');
        inc(i);
      end;

      if i = 0
       then retCampoAdicional.Add;

      Result := True;
    end;
  except
    Result := false;
  end;
end;

end.
