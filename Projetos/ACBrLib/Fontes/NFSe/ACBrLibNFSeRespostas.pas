{*******************************************************************************}
{ Projeto: Componentes ACBr                                                     }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa-  }
{ mentos de Automação Comercial utilizados no Brasil                            }
{                                                                               }
{ Direitos Autorais Reservados (c) 2018 Daniel Simoes de Almeida                }
{                                                                               }
{ Colaboradores nesse arquivo: Antonio Carlos Junior                            }
{                                                                               }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la  }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério)  }
{ qualquer versão posterior.                                                    }
{                                                                               }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU       }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto }
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,   }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Você também pode obter uma copia da licença em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatuí - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}

{$I ACBr.inc}

unit ACBrLibNFSeRespostas;

interface

uses
  SysUtils, Classes, contnrs,
  ACBrLibResposta, ACBrNFSeXNotasFiscais, ACBrNFSeX, ACBrNFSeXWebservicesResponse;

type

  { TLibNFSeResposta }
  TLibNFSeResposta = class (TACBrLibRespostaBase)
    private
      FMsg: String;

    public
      constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo;
      const AFormato: TACBrLibCodificacao); reintroduce;

    published
      property Msg: String read FMsg write FMsg;
  end;

  { TNFSeEventoItem }
  TNFSeEventoItem = class(TACBrLibRespostaBase)
  private
    FCodigo: String;
    FDescricao: String;
    FCorrecao: String;

  public
    procedure Processar(const Evento: TNFSeEventoCollectionItem);

  published
    property Codigo: String read FCodigo write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
    property Correcao: String read FCorrecao write FCorrecao;

  end;

  { TLibNFSeServiceResposta }
  TLibNFSeServiceResposta = class abstract(TACBrLibRespostaBase)
  private
    FXmlEnvio: string;
    FXmlRetorno: string;
    FErros: TObjectList;
    FAlertas: TObjectList;

  public
    constructor Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
    destructor Destroy;

    procedure Processar(const Response: TNFSeWebserviceResponse); virtual;

  published
    property XmlEnvio: String read FXmlEnvio write FXmlEnvio;
    property XmlRetorno: String read FXmlRetorno write FXmlRetorno;

  end;

  { TEmiteResposta }
  TEmiteResposta = class(TLibNFSeServiceResposta)
  private
    FLote: string;
    FData: TDateTime;
    FProtocolo: string;
    FModoEnvio: string;
    FMaxRps: Integer;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeEmiteResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Data: TDateTime read FData write FData;
    property Protocolo: String read FProtocolo write FProtocolo;
    property MaxRps: Integer read FMaxRps write FMaxRps;
    property ModoEnvio: string read FModoEnvio write FModoEnvio;

  end;

  { TConsultaSituacaoResposta }
  TConsultaSituacaoResposta = class(TLibNFSeServiceResposta)
  private
    FLote: string;
    FSituacao: string;
    FProtocolo: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeConsultaSituacaoResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;

  end;

  { TConsultaLoteRpsResposta }
  TConsultaLoteRpsResposta = class(TLibNFSeServiceResposta)
  private
      FLote: string;
      FProtocolo: string;
      FSituacao: string;
      FCodVerificacao: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeConsultaLoteRpsResponse); reintroduce;

  published
    property Lote: string read FLote write FLote;
    property Protocolo: string read FProtocolo write FProtocolo;
    property Situacao: string read FSituacao write FSituacao;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
  end;

  { TConsultaNFSePorRpsResposta }
  TConsultaNFSePorRpsResposta = class (TLibNFSeServiceResposta)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FCancelamento: TNFSeCancelamento;
    FNumNotaSubstituidora: string;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeConsultaNFSeporRpsResponse); reintroduce;

  published
    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property Cancelamento: TNFSeCancelamento read FCancelamento write FCancelamento;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;
  end;

  { TSubstituirNFSeResposta }
  TSubstituirNFSeResposta = class(TLibNFSeServiceResposta)
  private
    FNumRPS: string;
    FSerie: string;
    FTipo: string;
    FCodVerificacao: string;
    FPedCanc: string;
    FNumNotaSubstituida: string;
    FNumNotaSubstituidora: string;
  
  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeSubstituiNFSeResponse); reintroduce;

  published
    property NumRPS: string read FNumRPS write FNumRPS;
    property Serie: string read FSerie write FSerie;
    property Tipo: string read FTipo write FTipo;
    property CodVerificacao: string read FCodVerificacao write FCodVerificacao;
    property PedCanc: string read FPedCanc write FPedCanc;
    property NumNotaSubstituida: string read FNumNotaSubstituida write FNumNotaSubstituida;
    property NumNotaSubstituidora: string read FNumNotaSubstituidora write FNumNotaSubstituidora;    
  end;

  { TGerarTokenResposta }
  TGerarTokenResposta = class(TLibNFSeServiceResposta)
  private
    FToken: string;
    FDataExpiracao: TDateTime;

  public
    constructor Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao); reintroduce;
    destructor Destroy;

    procedure Processar(const Response: TNFSeGerarTokenResponse); reintroduce;

  published
    property Token: string read FToken write FToken;
    property DataExpiracao: TDateTime read FDataExpiracao write FDataExpiracao;
  end;

implementation

uses
  pcnAuxiliar, pcnConversao,
  ACBrNFSeXConversao,
  ACBrUtil, ACBrLibNFSeConsts;

{ TNFSeEventoItem }
procedure TNFSeEventoItem.Processar(const Evento: TNFSeEventoCollectionItem);
begin
  Codigo := Evento.Codigo;
  Descricao := Evento.Descricao;
  Correcao := Evento.Correcao;
end;

{ TLibNFSeResposta }
constructor TLibNFSeResposta.Create(const ASessao: String;
  const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);
end;

{ TLibNFSeServiceResposta }
constructor TLibNFSeServiceResposta.Create(const ASessao: String; const ATipo: TACBrLibRespostaTipo;
  const AFormato: TACBrLibCodificacao);
begin
  inherited Create(ASessao, ATipo, AFormato);

  FErros := TObjectList.Create(True);
  FAlertas := TObjectList.Create(True);
end;

destructor TLibNFSeServiceResposta.Destroy;
begin

  FErros.Destroy;
  FAlertas.Destroy;
  inherited Destroy;
end;

procedure TLibNFSeServiceResposta.Processar(const Response: TNFSeWebserviceResponse);
var
  i: Integer;
  Item: TNFSeEventoItem;
begin
  XmlEnvio := Response.XmlEnvio;
  XmlRetorno := Response.XmlRetorno;

  if Response.Erros.Count > 0 then
  begin
    for i := 0 to Response.Erros.Count -1 do
    begin
      Item := TNFSeEventoItem.Create(CSessaoRespErro + IntToStr(i + 1), Tipo, Formato);
      Item.Processar(Response.Erros.Items[i]);
      FErros.Add(Item);
    end;
  end;

  if Response.Alertas.Count > 0 then
  begin
    for i := 0 to Response.Alertas.Count -1 do
    begin
      Item := TNFSeEventoItem.Create(CSessaoRespAlerta + IntToStr(i + 1), Tipo, Formato);
      Item.Processar(Response.Alertas.Items[i]);
      FAlertas.Add(Item);
    end;
  end;
end;

{ TEmiteResposta }
constructor TEmiteResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespEnvio, ATipo, AFormato);
end;

destructor TEmiteResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TEmiteResposta.Processar(const Response: TNFSeEmiteResponse);
begin
  inherited Processar(Response);

  Lote := Response.Lote;
  Data := Response.Data;
  Protocolo := Response.Protocolo;
  MaxRps := Response.MaxRps;
  ModoEnvio := ModoEnvioToStr(Response.ModoEnvio);
end;

{ TConsultaSituacaoResposta }
constructor TConsultaSituacaoResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespSituacao, ATipo, AFormato);
end;

destructor TConsultaSituacaoResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaSituacaoResposta.Processar(const Response: TNFSeConsultaSituacaoResponse);
begin
  inherited Processar(Response);

  Lote := Response.Lote;
  Protocolo := Response.Protocolo;
  Situacao := Response.Situacao;
end;

{ TConsultaLoteRpsResposta }
constructor TConsultaLoteRpsResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaLoteRps, ATipo, AFormato);
end;

destructor TConsultaLoteRpsResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaLoteRpsResposta.Processar(const Response: TNFSeConsultaLoteRpsResponse);
begin
  inherited Processar(Response);

  Lote:= Response.Lote;
  Protocolo:= Response.Protocolo;
  Situacao:= Response.Situacao;
  CodVerificacao:= Response.CodVerificacao;
end;

 { TConsultaNFSePorRpsResposta }
constructor TConsultaNFSePorRpsResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespConsultaNFSePorRps, ATipo, AFormato);
end;

destructor TConsultaNFSePorRpsResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TConsultaNFSePorRpsResposta.Processar(const Response: TNFSeConsultaNFSeporRpsResponse);
begin
  inherited Processar(Response);

  NumRPS:= Response.NumRPS;
  Serie:= Response.Serie;
  Tipo:= Response.Tipo;
  CodVerificacao:= Response.CodVerificacao;
  Cancelamento:= Response.Cancelamento;
  NumNotaSubstituidora:= Response.NumNotaSubstituidora;
end;

 { TSubstituirNFSeResposta }
constructor TSubstituirNFSeResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespSubstituirNFSe, ATipo, AFormato);
end;

destructor TSubstituirNFSeResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TSubstituirNFSeResposta.Processar(const Response: TNFSeSubstituiNFSeResponse);
begin
  inherited Processar(Response);

  NumRPS:= Response.NumRPS;
  Serie:= Response.Serie;
  Tipo:= Response.Tipo;
  CodVerificacao:= Response.CodVerificacao;
  PedCanc:= Response.PedCanc;
  NumNotaSubstituida:= Response.NumNotaSubstituida;
  NumNotaSubstituidora:= Response.NumNotaSubstituidora;
end;

{ TGerarTokenResposta }
constructor TGerarTokenResposta.Create(const ATipo: TACBrLibRespostaTipo; const AFormato: TACBrLibCodificacao);
begin
  inherited Create(CSessaoRespGerarToken, ATipo, AFormato);
end;

destructor TGerarTokenResposta.Destroy;
begin
  inherited Destroy;
end;

procedure TGerarTokenResposta.Processar(const Response: TNFSeGerarTokenResponse);
begin
  inherited Processar(Response);

  Token:= Response.Token;
  DataExpiracao:= Response.DataExpiracao;
end;

end.

