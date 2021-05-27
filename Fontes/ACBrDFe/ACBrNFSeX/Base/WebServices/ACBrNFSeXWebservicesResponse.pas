{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Rafael Dias                                     }
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

unit ACBrNFSeXWebservicesResponse;

interface

uses
  {$IF DEFINED(NEXTGEN)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$IFEND}
  SysUtils,
  ACBrBase, ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXWebserviceBase;

type
 { TInfRetorno }

  TInfRetorno = class
  private
    FNumeroLote: String;
    FDataRecebimento: TDateTime;
    FProtocolo: String;
    FSucesso: String;
    FSituacao: String;

//    FRetornoNFSe: TRetornoNFSe;
    FInformacoesLote: TInformacoesLote;
    FListaChaveNFeRPS: TChaveNFeRPSCollection;
    // Retornado pelo GerarNfse
    FChaveNFeRPS: TChaveNFeRPS;
    FNumeroNota: Integer;
    FLink: String;

    procedure SetListaChaveNFeRPS(const Value: TChaveNFeRPSCollection);
  public
    constructor Create;
    destructor Destroy; override;

    property NumeroLote: String         read FNumeroLote      write FNumeroLote;
    property DataRecebimento: TDateTime read FDataRecebimento write FDataRecebimento;
    property Protocolo: String          read FProtocolo       write FProtocolo;
    property Sucesso: String            read FSucesso         write FSucesso;
    property Situacao: String           read FSituacao        write FSituacao;

//    property RetornoNFSe: TRetornoNFSe                read FRetornoNFSe      write FRetornoNFSe;
    property InformacoesLote: TInformacoesLote        read FInformacoesLote  write FInformacoesLote;
    property ListaChaveNFeRPS: TChaveNFeRPSCollection read FListaChaveNFeRPS write SetListaChaveNFeRPS;
    // Retornado pelo GerarNfse
    property ChaveNFeRPS: TChaveNFeRPS read FChaveNFeRPS write FChaveNFeRPS;
    property NumeroNota: Integer       read FNumeroNota  write FNumeroNota;
    property Link: String              read FLink        write FLink;
  end;

  TNFSeEventoCollectionItem = class
  private
    FCodigo: String;
    FDescricao: String;
    FCorrecao: String;

  public
    property Codigo: String read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Correcao: String read FCorrecao write FCorrecao;

  end;

  TNFSeEventoCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNFSeEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TNFSeEventoCollectionItem);

  public
    function New: TNFSeEventoCollectionItem;
    function Add(ANota: TNFSeEventoCollectionItem): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNFSeEventoCollectionItem); reintroduce;

    property Items[Index: Integer]: TNFSeEventoCollectionItem read GetItem write SetItem; default;

  end;

  TNotasCanceladasCollectionItem = class
  private
    FNumeroNota: String;
    FCodigoVerficacao: String;
    FInscricaoMunicipalPrestador: String;
  public
    property NumeroNota: String read FNumeroNota write FNumeroNota;
    property CodigoVerficacao: String read FCodigoVerficacao write FCodigoVerficacao;
    property InscricaoMunicipalPrestador: String read FInscricaoMunicipalPrestador write FInscricaoMunicipalPrestador;

  end;

  TNotasCanceladasCollection = class(TACBrObjectList)
  private
    function GetItem(Index: Integer): TNotasCanceladasCollectionItem;
    procedure SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);

  public
    function New: TNotasCanceladasCollectionItem; reintroduce;
    function Add(ANota: TNotasCanceladasCollectionItem): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNotasCanceladasCollectionItem); reintroduce;

    property Items[Index: Integer]: TNotasCanceladasCollectionItem read GetItem write SetItem; default;

  end;

  TRetCancelamento = class
  private
    FNumeroLote: String;
    FSituacao: String;
    FDataHora: TDateTime;
    FMsgCanc: String;
    FSucesso: String;
    FLink: String;
    FNumeroNota: Integer;
    FPedido: TPedidocancelamento;
    FNotasCanceladas: TNotasCanceladasCollection;

  public
    constructor Create;
    destructor Destroy; override;

    property NumeroLote: String read FNumeroLote write FNumeroLote;
    property Situacao: String read FSituacao write FSituacao;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property MsgCanc: String read FMsgCanc write FMsgCanc;
    property Sucesso: String read FSucesso write FSucesso;
    property Link: String read FLink write FLink;
    property NumeroNota: Integer read FNumeroNota  write FNumeroNota;
    property Pedido: TPedidocancelamento read FPedido;
    property NotasCanceladas: TNotasCanceladasCollection read FNotasCanceladas;

  end;

  TNFSeWebserviceResponse = class abstract
  private
    FSucesso: Boolean;
    FAlertas: TNFSeEventoCollection;
    FErros: TNFSeEventoCollection;
    FXmlEnvio: String;
    FXmlRetorno: String;
    FEnvelopeEnvio: String;
    FEnvelopeRetorno: String;

  public
    constructor Create;
    destructor Destroy; override;

    property Sucesso: Boolean read FSucesso write FSucesso;
    property Alertas: TNFSeEventoCollection read FAlertas;
    property Erros: TNFSeEventoCollection read FErros;
    property XmlEnvio: String read FXmlEnvio write FXmlEnvio;
    property XmlRetorno: String read FXmlRetorno write FXmlRetorno;
    property EnvelopeEnvio: String read FEnvelopeEnvio write FEnvelopeEnvio;
    property EnvelopeRetorno: String read FEnvelopeRetorno write FEnvelopeRetorno;

  end;

  TNFSeEmiteResponse = class(TNFSeWebserviceResponse)
  private
    FLote: string;
    FData: TDateTime;
    FProtocolo: String;
    FModoEnvio: TmodoEnvio;
    FMaxRps: Integer;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property Lote: string read FLote write FLote;
    property Data: TDateTime read FData write FData;
    property Protocolo: String read FProtocolo write FProtocolo;
    property MaxRps: Integer read FMaxRps write FMaxRps;
    property ModoEnvio: TmodoEnvio read FModoEnvio write FModoEnvio;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeConsultaSituacaoResponse = class(TNFSeWebserviceResponse)
  private
    FLote: string;
    FSituacao: string;
    FProtocolo: string;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeConsultaLoteRpsResponse = class(TNFSeWebserviceResponse)
  private
    FLote: string;
    FProtocolo: string;
    FSituacao: string;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeConsultaNFSeporRpsResponse = class(TNFSeWebserviceResponse)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeConsultaNFSeResponse = class(TNFSeWebserviceResponse)
  private
    FInfConsultaNFSe: TInfConsultaNFSe;
    FMetodo: TMetodo;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property InfConsultaNFSe: TInfConsultaNFSe read FInfConsultaNFSe write FInfConsultaNFSe;
    property Metodo: TMetodo read FMetodo write FMetodo;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeCancelaNFSeResponse = class(TNFSeWebserviceResponse)
  private
    FInfCancelamento: TInfCancelamento;
    FRetCancelamento: TRetCancelamento;
    FInfRetorno: TInfRetorno;

  public
    constructor Create;
    destructor Destroy; override;

    property InfCancelamento: TInfCancelamento read FInfCancelamento write FInfCancelamento;
    property RetCancelamento: TRetCancelamento read FRetCancelamento;

    property InfRetorno: TInfRetorno read FInfRetorno write FInfRetorno;
  end;

  TNFSeSubstituiNFSeResponse = class(TNFSeWebserviceResponse)
  private
    FInfCancelamento: TInfCancelamento;

    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;

    FPedCanc: string;
    FRetCancelamento: TRetCancelamento;
  public
    constructor Create;
    destructor Destroy; override;

    property InfCancelamento: TInfCancelamento read FInfCancelamento write FInfCancelamento;

    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property RetCancelamento: TRetCancelamento read FRetCancelamento;

    property PedCanc: string read FPedCanc write FPedCanc;

  end;

  TNFSeAbreSessaoResponse = class(TNFSeWebserviceResponse)
  private
    FLote: string;
    FHashIdent: String;

  public
    property Lote: string read FLote write FLote;
    property HashIdent: String read FHashIdent write FHashIdent;
  end;

  TNFSeFechaSessaoResponse = class(TNFSeWebserviceResponse)
  private
    FLote: string;
    FHashIdent: String;

  public
    property Lote: string read FLote write FLote;
    property HashIdent: String read FHashIdent write FHashIdent;
  end;

implementation

{ TNFSeEventoCollection }

function TNFSeEventoCollection.GetItem(Index: Integer): TNFSeEventoCollectionItem;
begin
  Result := TNFSeEventoCollectionItem(inherited Items[Index]);
end;

procedure TNFSeEventoCollection.SetItem(Index: Integer; Value: TNFSeEventoCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TNFSeEventoCollection.New: TNFSeEventoCollectionItem;
begin
  Result := TNFSeEventoCollectionItem.Create;
  Self.Add(Result);
end;

function TNFSeEventoCollection.Add(ANota: TNFSeEventoCollectionItem): Integer;
begin
  Result := inherited Add(ANota);
end;

Procedure TNFSeEventoCollection.Insert(Index: Integer; ANota: TNFSeEventoCollectionItem);
begin
  inherited Insert(Index, ANota);
end;

{ TNotasCanceladasCollection }

function TNotasCanceladasCollection.GetItem(Index: Integer): TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem(inherited Items[Index]);
end;

procedure TNotasCanceladasCollection.SetItem(Index: Integer; Value: TNotasCanceladasCollectionItem);
begin
  inherited Items[Index] := Value;
end;

function TNotasCanceladasCollection.New: TNotasCanceladasCollectionItem;
begin
  Result := TNotasCanceladasCollectionItem.Create;
  Self.Add(Result);
end;

function TNotasCanceladasCollection.Add(ANota: TNotasCanceladasCollectionItem): Integer;
begin
  Result := inherited Add(ANota);
end;

Procedure TNotasCanceladasCollection.Insert(Index: Integer; ANota: TNotasCanceladasCollectionItem);
begin
  inherited Insert(Index, ANota);
end;

{ TRetCancelamento }

constructor TRetCancelamento.Create;
begin
  inherited Create;

  FPedido          := TPedidoCancelamento.Create;
  FNotasCanceladas := TNotasCanceladasCollection.Create;
end;

destructor TRetCancelamento.Destroy;
begin
  FPedido.Free;
  FNotasCanceladas.Free;

  inherited Destroy;
end;

{ TNFSeWebserviceResponse }

constructor TNFSeWebserviceResponse.Create;
begin
  inherited Create;

  FSucesso := False;
  FAlertas := TNFSeEventoCollection.Create;
  FErros := TNFSeEventoCollection.Create;
end;

destructor TNFSeWebserviceResponse.Destroy;
begin
  FAlertas.Free;
  FErros.Free;

  inherited;
end;

{ TNFSeConsultaNFSeResponse }

constructor TNFSeConsultaNFSeResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;
end;

destructor TNFSeConsultaNFSeResponse.Destroy;
begin
  FInfRetorno.Free;
  FreeAndNil(FInfConsultaNFSe);

  inherited Destroy;
end;

{ TNFSeCancelaNFSeResponse }

constructor TNFSeCancelaNFSeResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;

  FInfCancelamento := TInfCancelamento.Create;
  FRetCancelamento := TRetCancelamento.Create;
end;

destructor TNFSeCancelaNFSeResponse.Destroy;
begin
  FInfRetorno.Free;

  FreeAndNil(FInfCancelamento);
  FreeAndNil(FRetCancelamento);

  inherited Destroy;
end;

{ TNFSeSubstituiNFSeResponse }

constructor TNFSeSubstituiNFSeResponse.Create;
begin
  inherited Create;

  FInfCancelamento := TInfCancelamento.Create;
  FRetCancelamento := TRetCancelamento.Create;
end;

destructor TNFSeSubstituiNFSeResponse.Destroy;
begin
  FreeAndNil(FInfCancelamento);
  FreeAndNil(FRetCancelamento);

  inherited Destroy;
end;

{ TInfRetorno }

constructor TInfRetorno.Create;
begin
  inherited Create;

//  FRetornoNFSe      := TRetornoNFSe.Create;
  FInformacoesLote  := TInformacoesLote.Create;
  FListaChaveNFeRPS := TChaveNFeRPSCollection.Create;
  FChaveNFeRPS      := TChaveNFeRPS.Create;
end;

destructor TInfRetorno.Destroy;
begin
//  FRetornoNFSe.Free;
  FInformacoesLote.Free;
  FListaChaveNFeRPS.Free;
  FChaveNFeRPS.Free;

  inherited Destroy;
end;

procedure TInfRetorno.SetListaChaveNFeRPS(const Value: TChaveNFeRPSCollection);
begin
  FListaChaveNFeRPS := Value;
end;

{ TNFSeEmiteResponse }

constructor TNFSeEmiteResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;
end;

destructor TNFSeEmiteResponse.Destroy;
begin
  FInfRetorno.Free;
//  FreeAndNil(FInfRetorno);

  inherited Destroy;
end;

{ TNFSeConsultaSituacaoResponse }

constructor TNFSeConsultaSituacaoResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;
end;

destructor TNFSeConsultaSituacaoResponse.Destroy;
begin
  FInfRetorno.Free;

  inherited Destroy;
end;

{ TNFSeConsultaLoteRpsResponse }

constructor TNFSeConsultaLoteRpsResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;
end;

destructor TNFSeConsultaLoteRpsResponse.Destroy;
begin
  FInfRetorno.Free;

  inherited Destroy;
end;

{ TNFSeConsultaNFSeporRpsResponse }

constructor TNFSeConsultaNFSeporRpsResponse.Create;
begin
  inherited Create;

  FInfRetorno := TInfRetorno.Create;
end;

destructor TNFSeConsultaNFSeporRpsResponse.Destroy;
begin
  FInfRetorno.Free;

  inherited Destroy;
end;

end.
