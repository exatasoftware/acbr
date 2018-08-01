{******************************************************************************}
{ Projeto: Componente ACBrANe                                                  }
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

{*******************************************************************************
|* Historico
|*
|* 24/02/2016: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcaRetEnvANe;

interface
 uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnLeitor;

type
  TRetEnvANe = class;
  TAverbado = class;
  TErros = class;
  TInfos = class;

  TErroCollectionItem = class(TCollectionItem)
  private
    FCodigo: String;
    FDescricao: String;
    FValorEsperado: String;
    FValorInformado: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Codigo: String         read FCodigo         write FCodigo;
    property Descricao: String      read FDescricao      write FDescricao;
    property ValorEsperado: String  read FValorEsperado  write FValorEsperado;
    property ValorInformado: String read FValorInformado write FValorInformado;
  end;

  TErroCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TErroCollectionItem;
    procedure SetItem(Index: Integer; Value: TErroCollectionItem);
  public
    constructor Create(AOwner: TErros); reintroduce;
    function Add: TErroCollectionItem;
    property Items[Index: Integer]: TErroCollectionItem read GetItem write SetItem; default;
  end;

  TErros = class(TPersistent)
  private
    FErro: TErroCollection;

    procedure SetErro(const Value: TErroCollection);
  public
    constructor Create(AOwner: TRetEnvANe);
    destructor Destroy; override;

    property Erro: TErroCollection read FErro   write SetErro;
  end;

  TDadosSeguroCollectionItem = class(TCollectionItem)
  private
    FNumeroAverbacao: String;
    FCNPJSeguradora: String;
    FNomeSeguradora: String;
    FNumApolice: String;
    FTpMov: String;
    FTpDDR: String;
    FValorAverbado: Double;
    FRamoAverbado: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property NumeroAverbacao: String read FNumeroAverbacao write FNumeroAverbacao;
    property CNPJSeguradora: String  read FCNPJSeguradora  write FCNPJSeguradora;
    property NomeSeguradora: String  read FNomeSeguradora  write FNomeSeguradora;
    property NumApolice: String      read FNumApolice      write FNumApolice;
    property TpMov: String           read FTpMov           write FTpMov;
    property TpDDR: String           read FTpDDR           write FTpDDR;
    property ValorAverbado: Double   read FValorAverbado   write FValorAverbado;
    property RamoAverbado: String    read FRamoAverbado    write FRamoAverbado;
  end;

  TDadosSeguroCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TDadosSeguroCollectionItem;
    procedure SetItem(Index: Integer; Value: TDadosSeguroCollectionItem);
  public
    constructor Create(AOwner: TAverbado); reintroduce;
    function Add: TDadosSeguroCollectionItem;
    property Items[Index: Integer]: TDadosSeguroCollectionItem read GetItem write SetItem; default;
  end;

  TAverbado = class(TPersistent)
  private
    FdhAverbacao: TDateTime;
    FProtocolo: String;
    FDadosSeguro: TDadosSeguroCollection;
    procedure SetDadosSeguro(const Value: TDadosSeguroCollection);
  public
    constructor Create(AOwner: TRetEnvANe);
    destructor Destroy; override;

    property dhAverbacao: TDateTime read FdhAverbacao write FdhAverbacao;
    property Protocolo: String      read FProtocolo   write FProtocolo;

    property DadosSeguro: TDadosSeguroCollection read FDadosSeguro write SetDadosSeguro;
  end;

  TInfoCollectionItem = class(TCollectionItem)
  private
    FCodigo: String;
    FDescricao: String;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
    property Codigo: String    read FCodigo    write FCodigo;
    property Descricao: String read FDescricao write FDescricao;
  end;

  TInfoCollection = class(TCollection)
  private
    function GetItem(Index: Integer): TInfoCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfoCollectionItem);
  public
    constructor Create(AOwner: TInfos); reintroduce;
    function Add: TInfoCollectionItem;
    property Items[Index: Integer]: TInfoCollectionItem read GetItem write SetItem; default;
  end;

  TInfos = class(TPersistent)
  private
    FInfo: TInfoCollection;

    procedure SetInfo(const Value: TInfoCollection);
  public
    constructor Create(AOwner: TRetEnvANe);
    destructor Destroy; override;

    property Info: TInfoCollection read FInfo write SetInfo;
  end;

  TDeclarado = class(TPersistent)
  private
    FdhChancela: TDateTime;
    FProtocolo: String;
  public
    constructor Create(AOwner: TRetEnvANe);
    destructor Destroy; override;

    property dhChancela: TDateTime read FdhChancela write FdhChancela;
    property Protocolo: String     read FProtocolo  write FProtocolo;
  end;

  TRetEnvANe = class(TPersistent)
  private
    FLeitor: TLeitor;

    FXML: String;

    FNumero: String;
    FSerie: String;
    FFilial: String;
    FCNPJCli: String;
    FTpDoc: Integer;
    FInfAdic: String;

    FErros: TErros;
    FAverbado: TAverbado;
    FInfos: TInfos;
    FDeclarado: TDeclarado;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;

    property XML: String read FXML write FXML;

    property Numero: String  read FNumero  write FNumero;
    property Serie: String   read FSerie   write FSerie;
    property Filial: String  read FFilial  write FFilial;
    property CNPJCli: String read FCNPJCli write FCNPJCli;
    property TpDoc: Integer  read FTpDoc   write FTpDoc;
    property InfAdic: String read FInfAdic write FInfAdic;

    property Erros: TErros         read FErros     write FErros;
    property Averbado: TAverbado   read FAverbado  write FAverbado;
    property Infos: TInfos         read FInfos     write FInfos;
    property Declarado: TDeclarado read FDeclarado write FDeclarado;
  end;

implementation

{ TErroCollectionItem }

constructor TErroCollectionItem.Create;
begin

end;

destructor TErroCollectionItem.Destroy;
begin

  inherited;
end;

{ TErroCollection }

constructor TErroCollection.Create(AOwner: TErros);
begin
  inherited Create(TErroCollectionItem);
end;

function TErroCollection.Add: TErroCollectionItem;
begin
  Result := TErroCollectionItem(inherited Add);
end;

function TErroCollection.GetItem(Index: Integer): TErroCollectionItem;
begin
  Result := TErroCollectionItem(inherited GetItem(Index));
end;

procedure TErroCollection.SetItem(Index: Integer;
  Value: TErroCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TErro }

constructor TErros.Create(AOwner: TRetEnvANe);
begin
  FErro := TErroCollection.Create(Self);
end;

destructor TErros.Destroy;
begin
  FErro.Free;

  inherited;
end;

procedure TErros.SetErro(const Value: TErroCollection);
begin
  FErro := Value;
end;

{ TDadosSeguroCollectionItem }

constructor TDadosSeguroCollectionItem.Create;
begin

end;

destructor TDadosSeguroCollectionItem.Destroy;
begin

  inherited;
end;

{ TDadosSeguroCollection }

function TDadosSeguroCollection.Add: TDadosSeguroCollectionItem;
begin
  Result := TDadosSeguroCollectionItem(inherited Add);
end;

constructor TDadosSeguroCollection.Create(AOwner: TAverbado);
begin
  inherited Create(TDadosSeguroCollectionItem);
end;

function TDadosSeguroCollection.GetItem(
  Index: Integer): TDadosSeguroCollectionItem;
begin
  Result := TDadosSeguroCollectionItem(inherited GetItem(Index));
end;

procedure TDadosSeguroCollection.SetItem(Index: Integer;
  Value: TDadosSeguroCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TAverbado }

constructor TAverbado.Create(AOwner: TRetEnvANe);
begin
  FDadosSeguro := TDadosSeguroCollection.Create(Self);
end;

destructor TAverbado.Destroy;
begin
  FDadosSeguro.Free;

  inherited;
end;

procedure TAverbado.SetDadosSeguro(const Value: TDadosSeguroCollection);
begin
  FDadosSeguro := Value;
end;

{ TInfoCollectionItem }

constructor TInfoCollectionItem.Create;
begin

end;

destructor TInfoCollectionItem.Destroy;
begin

  inherited;
end;

{ TInfoCollection }

function TInfoCollection.Add: TInfoCollectionItem;
begin
  Result := TInfoCollectionItem(inherited Add);
end;

constructor TInfoCollection.Create(AOwner: TInfos);
begin
  inherited Create(TInfoCollectionItem);
end;

function TInfoCollection.GetItem(Index: Integer): TInfoCollectionItem;
begin
  Result := TInfoCollectionItem(inherited GetItem(Index));
end;

procedure TInfoCollection.SetItem(Index: Integer;
  Value: TInfoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TDeclarado }

constructor TDeclarado.Create(AOwner: TRetEnvANe);
begin

end;

destructor TDeclarado.Destroy;
begin

  inherited;
end;

{ TInfos }

constructor TInfos.Create(AOwner: TRetEnvANe);
begin
  FInfo := TInfoCollection.Create(Self);
end;

destructor TInfos.Destroy;
begin
  FInfo.Free;
  
  inherited;
end;

procedure TInfos.SetInfo(const Value: TInfoCollection);
begin
  FInfo := Value;
end;

{ TRetEnvANe }

constructor TRetEnvANe.Create;
begin
  FLeitor    := TLeitor.Create;
  FErros     := TErros.Create( Self );
  FAverbado  := TAverbado.Create( Self );
  FInfos     := TInfos.Create( Self );
  FDeclarado := TDeclarado.Create( Self );
end;

destructor TRetEnvANe.Destroy;
begin
  FLeitor.Free;
  FErros.Free;
  FAverbado.Free;
  FInfos.Free;
  FDeclarado.Free;

  inherited;
end;

function TRetEnvANe.LerXml: boolean;
var
  i: Integer;
begin
  Result := False;

  try
    Leitor.Grupo := Leitor.Arquivo;

    FXML := Leitor.Grupo;

    if (leitor.rExtrai(1, 'ns1:averbaCTeResponse') <> '') or
       (leitor.rExtrai(1, 'ns1:averbaNFeResponse') <> '') then
    begin
      if (leitor.rExtrai(2, 'Response') <> '') then
      begin
        FNumero  := Leitor.rCampo(tcStr, 'Numero');
        FSerie   := Leitor.rCampo(tcStr, 'Serie');
        FFilial  := Leitor.rCampo(tcStr, 'Filial');
        FCNPJCli := Leitor.rCampo(tcStr, 'CNPJCli');
        FTpDoc   := Leitor.rCampo(tcInt, 'TpDoc');
        FInfAdic := Leitor.rCampo(tcStr, 'InfAdic');

        if (leitor.rExtrai(3, 'Erros') <> '') then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'Erro', '', i + 1) <> '' do
          begin
            Erros.FErro.Add;
            Erros.FErro[i].FCodigo         := Leitor.rCampo(tcStr, 'Codigo');
            Erros.FErro[i].FDescricao      := Leitor.rCampo(tcStr, 'Descricao');
            Erros.FErro[i].FValorEsperado  := Leitor.rCampo(tcStr, 'ValorEsperado');
            Erros.FErro[i].FValorInformado := Leitor.rCampo(tcStr, 'ValorInformado');

            inc(i);
          end;
        end;

        if leitor.rExtrai(3, 'Averbado') <> '' then
        begin
          Averbado.FdhAverbacao := Leitor.rCampo(tcDatHor, 'dhAverbacao');
          Averbado.FProtocolo   := Leitor.rCampo(tcStr, 'Protocolo');

          i := 0;
          while Leitor.rExtrai(4, 'DadosSeguro', '', i + 1) <> '' do
          begin
            Averbado.FDadosSeguro.Add;
            Averbado.FDadosSeguro[i].FNumeroAverbacao := Leitor.rCampo(tcStr, 'NumeroAverbacao');
            Averbado.FDadosSeguro[i].FCNPJSeguradora  := Leitor.rCampo(tcStr, 'CNPJSeguradora');
            Averbado.FDadosSeguro[i].FNomeSeguradora  := Leitor.rCampo(tcStr, 'NomeSeguradora');
            Averbado.FDadosSeguro[i].FNumApolice      := Leitor.rCampo(tcStr, 'NumApolice');
            Averbado.FDadosSeguro[i].FTpMov           := Leitor.rCampo(tcStr, 'TpMov');
            Averbado.FDadosSeguro[i].FTpDDR           := Leitor.rCampo(tcStr, 'TpDDR');
            Averbado.FDadosSeguro[i].FValorAverbado   := Leitor.rCampo(tcDe2, 'ValorAverbado');
            Averbado.FDadosSeguro[i].FRamoAverbado    := Leitor.rCampo(tcStr, 'RamoAverbado');

            inc(i);
          end;
        end;

        if leitor.rExtrai(3, 'Infos') <> '' then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'Info', '', i + 1) <> '' do
          begin
            Infos.FInfo.Add;
            Infos.FInfo[i].FCodigo    := Leitor.rCampo(tcStr, 'Codigo');
            Infos.FInfo[i].FDescricao := Leitor.rCampo(tcStr, 'Descricao');

            inc(i);
          end;
        end;

        Result := True;
      end;
    end;

    if leitor.rExtrai(1, 'ns1:declaraMDFeResponse') <> '' then
    begin
      if (leitor.rExtrai(2, 'Response') <> '') then
      begin
        FNumero := Leitor.rCampo(tcStr, 'Numero');
        FSerie  := Leitor.rCampo(tcStr, 'Serie');
        FFilial := Leitor.rCampo(tcStr, 'Filial');

        if (leitor.rExtrai(3, 'Erros') <> '') then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'Erro', '', i + 1) <> '' do
          begin
            Erros.FErro.Add;
            Erros.FErro[i].FCodigo         := Leitor.rCampo(tcStr, 'Codigo');
            Erros.FErro[i].FDescricao      := Leitor.rCampo(tcStr, 'Descricao');
            Erros.FErro[i].FValorEsperado  := Leitor.rCampo(tcStr, 'ValorEsperado');
            Erros.FErro[i].FValorInformado := Leitor.rCampo(tcStr, 'ValorInformado');

            inc(i);
          end;
        end;

        if (leitor.rExtrai(3, 'Declarado') <> '') then
        begin
          Declarado.FdhChancela := Leitor.rCampo(tcDatHor, 'dhChancela');
          Declarado.FProtocolo  := Leitor.rCampo(tcStr, 'Protocolo');
        end;

        if leitor.rExtrai(3, 'Infos') <> '' then
        begin
          i := 0;
          while Leitor.rExtrai(4, 'Info', '', i + 1) <> '' do
          begin
            Infos.FInfo.Add;
            Infos.FInfo[i].FCodigo    := Leitor.rCampo(tcStr, 'Codigo');
            Infos.FInfo[i].FDescricao := Leitor.rCampo(tcStr, 'Descricao');

            inc(i);
          end;
        end;

        Result := True;
      end;
    end;

  except
    Result := False;
  end;
end;

end.

