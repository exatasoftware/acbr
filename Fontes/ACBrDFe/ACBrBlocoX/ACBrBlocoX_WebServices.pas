{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrBlocoX_WebServices;

interface

uses
  Classes, SysUtils, ACBrBase,
  ACBrDFe, pcnRetEnvBlocoX, ACBrDFeWebService,
  ACBrUtil, pcnConversao, ACBrBlocoX_Comum;

const
  ACBRBLOCOX_VERSAO = '1.1.0a';

  CPServico_Tempuri    = 'http://tempuri.org/';
  CPSoapAction_Tempuri = 'http://tempuri.org/';
  CPServico_WS         = 'http://webservices.sef.sc.gov.br/wsDfeSiv/';
  CPSoapAction_WS      = 'http://webservices.sef.sc.gov.br/wsDfeSiv/';

  type

  { TWebServiceBlocoX }

  TWebServiceBlocoX = class(TDFeWebService)
  private
    FUsarTempuri: Boolean;
    FUsarCData: Boolean;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    property UsarCData: Boolean read FUsarCData write FUsarCData;
  end;

  { TTransmitirArquivoBlocoX }

  TTransmitirArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FRecibo: AnsiString;
    FSituacaoProcCod: Integer;
    FSituacaoProcStr: AnsiString;
    FMensagem: AnsiString;
    FXML: AnsiString;
    FBlocoXRetorno: TRetTransmitirBlocoX;
    FXMLCompactado: AnsiString;

    procedure SetXML(const AValue: AnsiString);
    function GetXMLCompactado: AnsiString;

  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;

    procedure Clear; override;
    procedure LoadFromFile(const APathArquivo: string);


    property XML: AnsiString read FXML write SetXML;
    property XMLCompactado: AnsiString read GetXMLCompactado write FXMLCompactado;

    property Recibo:          AnsiString read FRecibo;
    property SituacaoProcCod: Integer    read FSituacaoProcCod;
    property SituacaoProcStr: AnsiString read FSituacaoProcStr;
    property Mensagem:        AnsiString read FMensagem;

    property BlocoXRetorno: TRetTransmitirBlocoX read FBlocoXRetorno;
  end;

  { TConsultarProcessamentoArquivoBlocoX }

  TConsultarProcessamentoArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FRetornoConsulta: TRetConsultaArquivoBlocoX;
    FXML: AnsiString;
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FRecibo: AnsiString;
    FSituacaoProcStr: AnsiString;
    FSituacaoProcCod: Integer;
    FMensagem: AnsiString;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;
    property Recibo:          AnsiString read FRecibo;
    property SituacaoProcCod: Integer    read FSituacaoProcCod;
    property SituacaoProcStr: AnsiString read FSituacaoProcStr;
    property Mensagem:        AnsiString read FMensagem;

    property BlocoXRetorno: TRetConsultaArquivoBlocoX read FRetornoConsulta write FRetornoConsulta;
  end;

  { TReprocessarArquivoBlocoX }

  TReprocessarArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FRetornoReprocessar: TRetReprocessarBlocoX;
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FSituacaoProcCod: Integer;
    FSituacaoProcStr: AnsiString;
    FRecibo: AnsiString;
    FXML: AnsiString;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;
    property Recibo:          AnsiString read FRecibo;
    property SituacaoProcCod: Integer    read FSituacaoProcCod;
    property SituacaoProcStr: AnsiString read FSituacaoProcStr;

    property BlocoXRetorno: TRetReprocessarBlocoX read FRetornoReprocessar write FRetornoReprocessar;
  end;

  { TDownloadArquivoBlocoX }

  TDownloadArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FArquivo: AnsiString;
    FXML: AnsiString;
    FRetornoDownload: TRetDownloadBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    function ExtrairArquivo(const FileName: String): String;
    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;
    property Arquivo:         AnsiString read FArquivo;

    property BlocoXRetorno: TRetDownloadBlocoX read FRetornoDownload write FRetornoDownload;
  end;

  { TCancelarArquivoBlocoX }

  TCancelarArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FRecibo: AnsiString;
    FSituacaoProcCod: Integer;
    FSituacaoProcStr: AnsiString;
    FXML: AnsiString;
    FRetornoCancelar: TRetCancelarBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;
    property Recibo:          AnsiString read FRecibo;
    property SituacaoProcStr: AnsiString read FSituacaoProcStr;
    property SituacaoProcCod: Integer    read FSituacaoProcCod;

    property BlocoXRetorno: TRetCancelarBlocoX read FRetornoCancelar write FRetornoCancelar;
  end;

  { TConsultarHistoricoArquivoBlocoX }

  TConsultarHistoricoArquivoBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FXML: AnsiString;
    FRetornoConsulta: TRetConsHistBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;

    property BlocoXRetorno: TRetConsHistBlocoX read FRetornoConsulta write FRetornoConsulta;
  end;

  { TListarArquivosBlocoX }

  TListarArquivosBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FIE: AnsiString;
    FXML: AnsiString;
    FRetornoConsulta: TRetListarBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property IE:              AnsiString read FIE; 
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;

    property BlocoXRetorno: TRetListarBlocoX read FRetornoConsulta write FRetornoConsulta;
  end;

  { TConsultarPendenciasContribuinteBlocoX }

  TConsultarPendenciasContribuinteBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FIE: AnsiString;
    FXML: AnsiString;
    FRetornoConsulta: TRetConsPendContribuinteBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property IE:              AnsiString read FIE;
    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;

    property BlocoXRetorno: TRetConsPendContribuinteBlocoX read FRetornoConsulta write FRetornoConsulta;
  end;

  { TConsultarPendenciasDesenvolvedorPafEcfBlocoX }

  TConsultarPendenciasDesenvolvedorPafEcfBlocoX = class(TWebServiceBlocoX)
  private
    FSituacaoOperCod: Integer;
    FSituacaoOperStr: AnsiString;
    FXML: AnsiString;
    FRetornoConsulta: TRetConsPendDesenvolvedorPafEcfBlocoX;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  public
    destructor Destroy; override;
    procedure Clear; override;

    property XML:             AnsiString read FXML write FXML;
    property SituacaoOperCod: Integer    read FSituacaoOperCod;
    property SituacaoOperStr: AnsiString read FSituacaoOperStr;

    property BlocoXRetorno: TRetConsPendDesenvolvedorPafEcfBlocoX read FRetornoConsulta write FRetornoConsulta;
  end;

  { TACBrBlocoX_WebServices }

  TACBrBlocoX_WebServices = class
  private
    FTransmitirArquivoBlocoX: TTransmitirArquivoBlocoX;
    FConsultarProcessamentoArquivoBlocoX: TConsultarProcessamentoArquivoBlocoX;
    FConsultarHistoricoArquivoBlocoX: TConsultarHistoricoArquivoBlocoX;
    FListarArquivosBlocoX: TListarArquivosBlocoX;
    FDownloadArquivoBlocoX: TDownloadArquivoBlocoX;
    FCancelarArquivoBlocoX: TCancelarArquivoBlocoX;
    FReprocessarArquivoBlocoX: TReprocessarArquivoBlocoX;
    FConsultarPendenciasContribuinteBlocoX: TConsultarPendenciasContribuinteBlocoX;
    FConsultarPendenciasDesenvolvedorPafEcfBlocoX: TConsultarPendenciasDesenvolvedorPafEcfBlocoX;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    property TransmitirArquivoBlocoX: TTransmitirArquivoBlocoX read FTransmitirArquivoBlocoX
      write FTransmitirArquivoBlocoX;

    property ConsultarProcessamentoArquivoBlocoX: TConsultarProcessamentoArquivoBlocoX
      read FConsultarProcessamentoArquivoBlocoX write FConsultarProcessamentoArquivoBlocoX;

    property ConsultarHistoricoArquivoBlocoX: TConsultarHistoricoArquivoBlocoX
      read FConsultarHistoricoArquivoBlocoX write FConsultarHistoricoArquivoBlocoX;

    property ListarArquivosBlocoX: TListarArquivosBlocoX read FListarArquivosBlocoX
      write FListarArquivosBlocoX;

    property DownloadArquivoBlocoX: TDownloadArquivoBlocoX read FDownloadArquivoBlocoX
      write FDownloadArquivoBlocoX;

    property CancelarArquivoBlocoX: TCancelarArquivoBlocoX read FCancelarArquivoBlocoX
      write FCancelarArquivoBlocoX;

    property ReprocessarArquivoBlocoX: TReprocessarArquivoBlocoX read FReprocessarArquivoBlocoX
      write FReprocessarArquivoBlocoX;

    property ConsultarPendenciasContribuinteBlocoX: TConsultarPendenciasContribuinteBlocoX
      read FConsultarPendenciasContribuinteBlocoX write FConsultarPendenciasContribuinteBlocoX;

    property ConsultarPendenciasDesenvolvedorPafEcfBlocoX: TConsultarPendenciasDesenvolvedorPafEcfBlocoX
      read FConsultarPendenciasDesenvolvedorPafEcfBlocoX write FConsultarPendenciasDesenvolvedorPafEcfBlocoX;
  end;

implementation

uses
  StrUtils, synacode, synautil;

{ TWebServiceBlocoX }

constructor TWebServiceBlocoX.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
  FUsarTempuri    := False;
  FUsarCData      := False;
  FPHeaderElement := '';
  FPBodyElement   := '';
end;

procedure TWebServiceBlocoX.DefinirURL;
begin
  if (FPConfiguracoes.WebServices.Ambiente = taProducao) then
    FPURL := 'http://webservices.sef.sc.gov.br/wsDfeSiv/BlocoX.asmx'
  else
    FPURL := 'http://webservices.sathomologa.sef.sc.gov.br/wsDfeSiv/BlocoX.asmx';
end;

procedure TWebServiceBlocoX.DefinirServicoEAction;
begin
  if (FUsarTempuri) then
  begin
    FPServico := CPServico_Tempuri;
    FPSoapAction := CPSoapAction_Tempuri;
  end
  else
  begin
    FPServico := CPServico_WS;
    FPSoapAction := CPSoapAction_WS;
  end;
end;

function TWebServiceBlocoX.GerarVersaoDadosSoap: String;
begin
  Result := '';
end;

{ TTransmitirArquivoBlocoX }

destructor TTransmitirArquivoBlocoX.Destroy;
begin
  FreeAndNil(FBlocoXRetorno);
  inherited Destroy;
end;

procedure TTransmitirArquivoBlocoX.Clear;
begin
  inherited Clear;
  FRecibo          := '';
  FSituacaoProcCod := 0;
  FSituacaoProcStr := '';
  FMensagem        := '';
  if Assigned(FBlocoXRetorno) then
    FreeAndNil(FBlocoXRetorno);
  FBlocoXRetorno := TRetTransmitirBlocoX.Create;
end;

procedure TTransmitirArquivoBlocoX.SetXML(const AValue: AnsiString);
begin
  if FXML = AValue then Exit;
  FXML := AValue;
  FXMLCompactado := '';
end;

function TTransmitirArquivoBlocoX.GetXMLCompactado: AnsiString;
var
  AZip: AnsiString;
begin
  if FXMLCompactado = '' then
  begin
    if FXML <> '' then
    begin
      AZip := ZipFile(FXML, FPBodyElement+'.xml');
      if AZip = '' then
        raise Exception.Create('O seu compilador n�o tem suporte nativo a ZipFile.'+sLineBreak+
                               'Informe o XML j� Zipado + Base64 em "XMLZipado"');

      FXMLCompactado := EncodeBase64(AZip);
    end;
  end;

  Result := FXMLCompactado;
end;

procedure TTransmitirArquivoBlocoX.LoadFromFile(const APathArquivo: string);
var
  SConteudo: Ansistring;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(APathArquivo);
    SConteudo := ReadStrFromStream(MS, MS.Size);
    SetXML(SConteudo);
  finally
    MS.Free;
  end;
end;

procedure TTransmitirArquivoBlocoX.DefinirDadosMsg;
begin
  //N�o utiliza CDATA
  FPDadosMsg := '<pXmlCompactado>'+XMLCompactado+'</pXmlCompactado>';
end;

procedure TTransmitirArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'TransmitirArquivo';
end;

procedure TTransmitirArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=TransmitirArquivo';
  FPBodyElement := 'TransmitirArquivo';
end;

function TTransmitirArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'TransmitirArquivoResult')));

  FBlocoXRetorno.Leitor.Arquivo := FPRetWS;
  FBlocoXRetorno.LerXml;

  FRecibo          := FBlocoXRetorno.Recibo;
  FSituacaoProcCod := FBlocoXRetorno.SituacaoProcCod;
  FSituacaoProcStr := FBlocoXRetorno.SituacaoProcStr;
  FMensagem        := FBlocoXRetorno.Mensagem;

  Result := (FPRetWS <> '');
end;

constructor TTransmitirArquivoBlocoX.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
end;

{ TConsultarProcessamentoArquivoBlocoX }

destructor TConsultarProcessamentoArquivoBlocoX.Destroy;
begin
  FRetornoConsulta.Free;
  inherited Destroy;
end;

procedure TConsultarProcessamentoArquivoBlocoX.Clear;
begin
  inherited Clear;
  FSituacaoOperCod := 0;
  FSituacaoOperStr := EmptyStr;
  FSituacaoProcCod := 0;
  FSituacaoProcStr := EmptyStr;
  FRecibo          := EmptyStr;
  FMensagem        := EmptyStr;

  if Assigned(FRetornoConsulta) then
    FreeAndNil(FRetornoConsulta);
  FRetornoConsulta := TRetConsultaArquivoBlocoX.Create;
end;

procedure TConsultarProcessamentoArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ConsultarProcessamentoArquivo';
  FPBodyElement := 'ConsultarProcessamentoArquivo';
end;

procedure TConsultarProcessamentoArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ConsultarProcessamentoArquivo';
end;

procedure TConsultarProcessamentoArquivoBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TConsultarProcessamentoArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ConsultarProcessamentoArquivoResult')));
  FRetornoConsulta.Leitor.Arquivo := FPRetWS;
  FRetornoConsulta.LerXml;

  FSituacaoOperCod := FRetornoConsulta.SituacaoOperCod;
  FSituacaoOperStr := FRetornoConsulta.SituacaoOperStr;
  FRecibo          := FRetornoConsulta.Recibo;
  FSituacaoProcCod := FRetornoConsulta.SituacaoProcCod;
  FSituacaoProcStr := FRetornoConsulta.SituacaoProcStr;

  Result := (FPRetWS <> '');
end;

{ TConsultarHistoricoArquivoBlocoX }

destructor TConsultarHistoricoArquivoBlocoX.Destroy;
begin
  FRetornoConsulta.Free;
  inherited Destroy;
end;

procedure TConsultarHistoricoArquivoBlocoX.Clear;
begin
  inherited Clear;

  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';

  if Assigned(FRetornoConsulta) then
    FRetornoConsulta.Free;

  FRetornoConsulta := TRetConsHistBlocoX.Create;
end;

procedure TConsultarHistoricoArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ConsultarHistoricoArquivo';
  FPBodyElement := 'ConsultarHistoricoArquivo';
end;

procedure TConsultarHistoricoArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ConsultarHistoricoArquivo';
end;

procedure TConsultarHistoricoArquivoBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TConsultarHistoricoArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ConsultarHistoricoArquivoResult')));

  FRetornoConsulta.Leitor.Arquivo := FPRetWS;
  FRetornoConsulta.LerXml;

  FSituacaoOperCod := FRetornoConsulta.SituacaoOperCod;
  FSituacaoOperStr := FRetornoConsulta.SituacaoOperStr;

  Result := (FPRetWS <> '');
end;

{ TListarArquivosBlocoX }

destructor TListarArquivosBlocoX.Destroy;
begin
  FRetornoConsulta.Free;
  inherited Destroy;
end;

procedure TListarArquivosBlocoX.Clear;
begin
  inherited Clear;

  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FIE              := '';

  if Assigned(FRetornoConsulta) then
    FRetornoConsulta.Free;

  FRetornoConsulta := TRetListarBlocoX.Create;
end;

procedure TListarArquivosBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ListarArquivos';
  FPBodyElement := 'ListarArquivos';
end;

procedure TListarArquivosBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ListarArquivos';
end;

procedure TListarArquivosBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TListarArquivosBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ListarArquivosResult')));

  FRetornoConsulta.Leitor.Arquivo := FPRetWS;
  FRetornoConsulta.LerXml;

  FSituacaoOperCod := FRetornoConsulta.SituacaoOperCod;
  FSituacaoOperStr := FRetornoConsulta.SituacaoOperStr;
  FIE              := FRetornoConsulta.IE;

  Result := (FPRetWS <> '');
end;

{ TDownloadArquivoBlocoX }

destructor TDownloadArquivoBlocoX.Destroy;
begin
  FRetornoDownload.Free;
  inherited Destroy;
end;

procedure TDownloadArquivoBlocoX.Clear;
begin
  inherited Clear;
  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FArquivo         := '';
  if Assigned(FRetornoDownload) then
    FreeAndNil(FRetornoDownload);
  FRetornoDownload := TRetDownloadBlocoX.Create;
end;

procedure TDownloadArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=DownloadArquivo';
  FPBodyElement := 'DownloadArquivo';
end;

procedure TDownloadArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'DownloadArquivo';
end;

procedure TDownloadArquivoBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TDownloadArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'DownloadArquivoResult')));

  FRetornoDownload.Leitor.Arquivo := FPRetWS;
  FRetornoDownload.LerXml;

  FSituacaoOperCod := FRetornoDownload.SituacaoOperCod;
  FSituacaoOperStr := FRetornoDownload.SituacaoOperStr;
  FArquivo         := FRetornoDownload.Arquivo;

  Result := (FPRetWS <> '');
end;

function TDownloadArquivoBlocoX.ExtrairArquivo(const FileName: String): String;
var
  AUnZip: AnsiString;
  ArquivoXML : TFileStream;
  iSize : Int64;
begin
  Result := '';
  if (FArquivo = '') then
    Exit;
  AUnZip := DecodeBase64(FArquivo);
  AUnZip := UnZipFile(AUnZip);
  if (AUnZip = '') then
  begin
    Result := 'O seu compilador n�o tem suporte nativo a ZipFile.' + sLineBreak +
              'N�o foi poss�vel descompactar os dados retornados.';
  end;
  try
    //Tamanho do registro
    iSize := Length(AUnZip);
    //Salva o conte�do no arquivo
    ArquivoXML := TFileStream.Create(FileName, fmCreate);
    ArquivoXML.Write(Pointer(AUnZip)^,iSize);
    ArquivoXML.Free;
  except on E:Exception do
    Result := 'N�o foi poss�vel extrair os dados retornados.' + sLineBreak +
              'Erro: ' + E.Message;
  end;
end;

{ TCancelarArquivoBlocoX }

destructor TCancelarArquivoBlocoX.Destroy;
begin
  FRetornoCancelar.Free;
  inherited Destroy;
end;

procedure TCancelarArquivoBlocoX.Clear;
begin
  inherited Clear;

  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FRecibo          := '';
  FSituacaoProcCod := 0;
  FSituacaoProcStr := '';

  if Assigned(FRetornoCancelar) then
    FRetornoCancelar.Free;

  FRetornoCancelar := TRetCancelarBlocoX.Create;
end;

procedure TCancelarArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=CancelarArquivo';
  FPBodyElement := 'CancelarArquivo';
end;

procedure TCancelarArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'CancelarArquivo';
end;

procedure TCancelarArquivoBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TCancelarArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'CancelarArquivoResult')));
  FRetornoCancelar.Leitor.Arquivo := FPRetWS;
  FRetornoCancelar.LerXml;
  FSituacaoOperCod := FRetornoCancelar.SituacaoOperCod;
  FSituacaoOperStr := FRetornoCancelar.SituacaoOperStr;
  FRecibo          := FRetornoCancelar.Recibo;
  FSituacaoProcCod := FRetornoCancelar.SituacaoProcCod;
  FSituacaoProcStr := FRetornoCancelar.SituacaoProcStr;
  Result := (FPRetWS <> '');
end;

{ TReprocessarArquivoBlocoX }

destructor TReprocessarArquivoBlocoX.Destroy;
begin
  FRetornoReprocessar.Free;
  inherited Destroy;
end;

procedure TReprocessarArquivoBlocoX.Clear;
begin
  inherited Clear;
  FRecibo := '';
  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FSituacaoProcCod := 0;
  FSituacaoProcStr := '';
  if Assigned(FRetornoReprocessar) then
    FreeAndNil(FRetornoReprocessar);
  FRetornoReprocessar := TRetReprocessarBlocoX.Create;
end;

procedure TReprocessarArquivoBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ReprocessarArquivo';
  FPBodyElement := 'ReprocessarArquivo';
end;

procedure TReprocessarArquivoBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ReprocessarArquivo';
end;

procedure TReprocessarArquivoBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TReprocessarArquivoBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ReprocessarArquivoResult')));
  FRetornoReprocessar.Leitor.Arquivo := FPRetWS;
  FRetornoReprocessar.LerXml;
  FRecibo := FRetornoReprocessar.Recibo;
  FSituacaoOperCod := FRetornoReprocessar.SituacaoOperCod;
  FSituacaoOperStr := FRetornoReprocessar.SituacaoOperStr;
  FSituacaoProcCod := FRetornoReprocessar.SituacaoProcCod;
  FSituacaoProcStr := FRetornoReprocessar.SituacaoProcStr;
  Result := (FPRetWS <> '');
end;

{ TConsultarPendenciasContribuinteBlocoX }

destructor TConsultarPendenciasContribuinteBlocoX.Destroy;
begin
  FRetornoConsulta.Free;
  inherited Destroy;
end;

procedure TConsultarPendenciasContribuinteBlocoX.Clear;
begin
  inherited Clear;

  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FIE              := '';

  if Assigned(FRetornoConsulta) then
    FRetornoConsulta.Free;

  FRetornoConsulta := TRetConsPendContribuinteBlocoX.Create;
end;

procedure TConsultarPendenciasContribuinteBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ConsultarPendenciasContribuinte';
  FPBodyElement := 'ConsultarPendenciasContribuinte';
end;

procedure TConsultarPendenciasContribuinteBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ConsultarPendenciasContribuinte';
end;

procedure TConsultarPendenciasContribuinteBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TConsultarPendenciasContribuinteBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ConsultarPendenciasContribuinteResult')));

  FRetornoConsulta.Leitor.Arquivo := FPRetWS;
  FRetornoConsulta.LerXml;

  FSituacaoOperCod := FRetornoConsulta.SituacaoOperCod;
  FSituacaoOperStr := FRetornoConsulta.SituacaoOperStr;
  FIE              := FRetornoConsulta.IE;

  Result := (FPRetWS <> '');
end;

{ TConsultarPendenciasDesenvolvedorPafEcfBlocoX }

destructor TConsultarPendenciasDesenvolvedorPafEcfBlocoX.Destroy;
begin
  FRetornoConsulta.Free;
  inherited Destroy;
end;

procedure TConsultarPendenciasDesenvolvedorPafEcfBlocoX.Clear;
begin
  inherited Clear;

  FSituacaoOperCod := 0;
  FSituacaoOperStr := '';
  FPArqEnv := 'blx-cdv';

  if Assigned(FRetornoConsulta) then
    FRetornoConsulta.Free;

  FRetornoConsulta := TRetConsPendDesenvolvedorPafEcfBlocoX.Create;
end;

procedure TConsultarPendenciasDesenvolvedorPafEcfBlocoX.DefinirURL;
begin
  inherited DefinirURL;
  FPURL := FPURL+'?op=ConsultarPendenciasDesenvolvedorPafEcf';
  FPBodyElement := 'ConsultarPendenciasDesenvolvedorPafEcf';
end;

procedure TConsultarPendenciasDesenvolvedorPafEcfBlocoX.DefinirServicoEAction;
begin
  FUsarTempuri := False;
  inherited DefinirServicoEAction;
  FPSoapAction := FPSoapAction + 'ConsultarPendenciasDesenvolvedorPafEcf';
end;

procedure TConsultarPendenciasDesenvolvedorPafEcfBlocoX.DefinirDadosMsg;
begin
  if FUsarCData then
    FPDadosMsg := '<pXml>' + '<![CDATA[' + FXML + ']]>' + '</pXml>'
  else
    FPDadosMsg := '<pXml>' + FXML + '</pXml>';
end;

function TConsultarPendenciasDesenvolvedorPafEcfBlocoX.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'ConsultarPendenciasDesenvolvedorPafEcfResult')));

  FRetornoConsulta.Leitor.Arquivo := FPRetWS;
  FRetornoConsulta.LerXml;

  FSituacaoOperCod := FRetornoConsulta.SituacaoOperCod;
  FSituacaoOperStr := FRetornoConsulta.SituacaoOperStr;

  Result := (FPRetWS <> '');
end;

{ TACBrBlocoX_WebServices }

constructor TACBrBlocoX_WebServices.Create(AOwner: TACBrDFe);
begin
  FTransmitirArquivoBlocoX                      := TTransmitirArquivoBlocoX.Create(AOwner);
  FConsultarProcessamentoArquivoBlocoX          := TConsultarProcessamentoArquivoBlocoX.Create(AOwner);
  FConsultarHistoricoArquivoBlocoX              := TConsultarHistoricoArquivoBlocoX.Create(AOwner);
  FListarArquivosBlocoX                         := TListarArquivosBlocoX.Create(AOwner);
  FDownloadArquivoBlocoX                        := TDownloadArquivoBlocoX.Create(AOwner);
  FCancelarArquivoBlocoX                        := TCancelarArquivoBlocoX.Create(AOwner);
  FReprocessarArquivoBlocoX                     := TReprocessarArquivoBlocoX.Create(AOwner);
  FConsultarPendenciasContribuinteBlocoX        := TConsultarPendenciasContribuinteBlocoX.Create(AOwner);
  FConsultarPendenciasDesenvolvedorPafEcfBlocoX := TConsultarPendenciasDesenvolvedorPafEcfBlocoX.Create(AOwner);
end;

destructor TACBrBlocoX_WebServices.Destroy;
begin
  FTransmitirArquivoBlocoX.Free;
  FConsultarProcessamentoArquivoBlocoX.Free;
  FConsultarHistoricoArquivoBlocoX.Free;
  FListarArquivosBlocoX.Free;
  FDownloadArquivoBlocoX.Free;
  FCancelarArquivoBlocoX.Free;
  FReprocessarArquivoBlocoX.Free;
  FConsultarPendenciasContribuinteBlocoX.Free;
  FConsultarPendenciasDesenvolvedorPafEcfBlocoX.Free;
  inherited Destroy;
end;

end.
