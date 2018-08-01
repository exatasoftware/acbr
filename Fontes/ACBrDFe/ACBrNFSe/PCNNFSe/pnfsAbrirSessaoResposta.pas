{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
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

{$I ACBr.inc}

unit pnfsAbrirSessaoResposta;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor, pnfsConversao, pnfsNFSe;

type

 TMsgRetornoAbreSessaoCollection = class;
 TMsgRetornoAbreSessaoCollectionItem = class;

 TInfAbrirSessao = class(TPersistent)
  private
    FHashIdent: String;
    FMsgRetorno: TMsgRetornoAbreSessaoCollection;

    procedure SetMsgRetorno(Value: TMsgRetornoAbreSessaoCollection);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    property HashIdent: String                           read FHashIdent  write FHashIdent;
    property MsgRetorno: TMsgRetornoAbreSessaoCollection read FMsgRetorno write SetMsgRetorno;
  end;

 TMsgRetornoAbreSessaoCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TMsgRetornoAbreSessaoCollectionItem;
    procedure SetItem(Index: Integer; Value: TMsgRetornoAbreSessaoCollectionItem);
  public
    constructor Create(AOwner: TInfAbrirSessao);
    function Add: TMsgRetornoAbreSessaoCollectionItem;
    property Items[Index: Integer]: TMsgRetornoAbreSessaoCollectionItem read GetItem write SetItem; default;
  end;

 TMsgRetornoAbreSessaoCollectionItem = class(TCollectionItem)
  private
    FCodigo: String;
    FMensagem: String;
    FCorrecao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Codigo: String   read FCodigo   write FCodigo;
    property Mensagem: String read FMensagem write FMensagem;
    property Correcao: String read FCorrecao write FCorrecao;
  end;

 { TretAbrirSessao }

 TretAbrirSessao = class(TPersistent)
  private
    FLeitor: TLeitor;
    FInfAbrirSessao: TInfAbrirSessao;
    FProvedor: TnfseProvedor;
  public
    constructor Create;
    destructor Destroy; override;

    function LerXml: Boolean;

    function LerXML_proEL: Boolean;

  published
    property Leitor: TLeitor                 read FLeitor         write FLeitor;
    property InfAbrirSessao: TInfAbrirSessao read FInfAbrirSessao write FInfAbrirSessao;
    property Provedor: TnfseProvedor         read FProvedor       write FProvedor;
  end;

implementation

{ TInfAbrirSessao }

constructor TInfAbrirSessao.Create;
begin
  FMsgRetorno := TMsgRetornoAbreSessaoCollection.Create(Self);
end;

destructor TInfAbrirSessao.Destroy;
begin
  FMsgRetorno.Free;
  inherited;
end;

procedure TInfAbrirSessao.SetMsgRetorno(Value: TMsgRetornoAbreSessaoCollection);
begin
  FMsgRetorno.Assign(Value);
end;

{ TMsgRetornoAbreSessaoCollection }

function TMsgRetornoAbreSessaoCollection.Add: TMsgRetornoAbreSessaoCollectionItem;
begin
  Result := TMsgRetornoAbreSessaoCollectionItem(inherited Add);
  Result.create;
end;

constructor TMsgRetornoAbreSessaoCollection.Create(AOwner: TInfAbrirSessao);
begin
  inherited Create(TMsgRetornoAbreSessaoCollectionItem);
end;

function TMsgRetornoAbreSessaoCollection.GetItem(
  Index: Integer): TMsgRetornoAbreSessaoCollectionItem;
begin
  Result := TMsgRetornoAbreSessaoCollectionItem(inherited GetItem(Index));
end;

procedure TMsgRetornoAbreSessaoCollection.SetItem(Index: Integer;
  Value: TMsgRetornoAbreSessaoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TMsgRetornoAbreSessaoCollectionItem }

constructor TMsgRetornoAbreSessaoCollectionItem.Create;
begin
end;

destructor TMsgRetornoAbreSessaoCollectionItem.Destroy;
begin
  inherited;
end;

{ TretAbrirSessao }

constructor TretAbrirSessao.Create;
begin
  FLeitor := TLeitor.Create;
  FInfAbrirSessao := TInfAbrirSessao.Create;
end;

destructor TretAbrirSessao.Destroy;
begin
  FLeitor.Free;
  FInfAbrirSessao.Free;
  inherited;
end;

function TretAbrirSessao.LerXml: Boolean;
begin
  if Provedor = proISSCuritiba then
    Leitor.Arquivo := RemoverNameSpace(Leitor.Arquivo)
  else
    Leitor.Arquivo := RemoverNameSpace(RemoverAtributos(RetirarPrefixos(Leitor.Arquivo, Provedor), Provedor));

  Leitor.Grupo := Leitor.Arquivo;

  case Provedor of
    proEL: Result := LerXML_proEL;
  else
    Result := False;
  end;
end;

function TretAbrirSessao.LerXML_proEL: Boolean;
var
  i: Integer;
  Cod, Msg: String;
  strAux: AnsiString;
begin
  try
    InfAbrirSessao.FHashIdent := Leitor.rCampo(tcStr, 'return'); 

    if leitor.rExtrai(1, 'mensagens') <> '' then
    begin
      i := 0;
      while Leitor.rExtrai(1, 'mensagens', '', i + 1) <> '' do
      begin
        strAux := Leitor.rCampo(tcStr, 'mensagens');
        Cod    := Copy(strAux, 1, 4);
        Msg    := Copy(strAux, 8, Length(strAux));
        if Trim(Msg) <> '' then
        begin
          InfAbrirSessao.FMsgRetorno.Add;
          InfAbrirSessao.FMsgRetorno[i].Codigo   := Cod;
          InfAbrirSessao.FMsgRetorno[i].Mensagem := Msg;
          InfAbrirSessao.FMsgRetorno[i].Correcao := '';
          Inc(i);
        end
        else
          Break;
      end;
    end;

    Result := True;
  except
    Result := False;
  end;
end;

end.

