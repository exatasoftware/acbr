{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit ACBrGTINWebServices;

interface

uses
  Classes, SysUtils, synacode,
  pcnConversao, pcnConsts,
  ACBrDFe, ACBrDFeWebService,
  ACBrGTINConversao, ACBrGTINConfiguracoes;

type

  { TGTINWebService }

  TGTINWebService = class(TDFeWebService)
  private
  protected
    FPStatus: TStatusACBrGTIN;
    FPLayout: TLayOutGTIN;
    FPConfiguracoesGTIN: TConfiguracoesGTIN;

  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    procedure DefinirEnvelopeSoap; override;
    procedure FinalizarServico; override;

  public
    constructor Create(AOwner: TACBrDFe); override;
    procedure Clear; override;

    property Status: TStatusACBrGTIN read FPStatus;
    property Layout: TLayOutGTIN read FPLayout;
  end;

  { TGTINConsulta }

  TGTINConsulta = class(TGTINWebService)
  private
    FOwner: TACBrDFe;
    FGTIN: String;
    FTpAmb: TpcnTipoAmbiente;
    FUF: string;

    Fversao: String;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FdhResp: TDateTime;
    FtpGTIN: Integer;
    FxProd: String;
    FNCM: String;
    FCEST: String;

    procedure SetGTIN(const AValue: String);
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe); reintroduce; overload;
    destructor Destroy; override;
    procedure Clear; override;

    property GTIN: String read FGTIN write SetGTIN;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property UF: string read FUF;

    property versao: String    read Fversao   write Fversao;
    property verAplic: String  read FverAplic write FverAplic;
    property cStat: Integer    read FcStat    write FcStat;
    property xMotivo: String   read FxMotivo  write FxMotivo;
    property dhResp: TDateTime read FdhResp   write FdhResp;
    property tpGTIN: Integer   read FtpGTIN   write FtpGTIN;
    property xProd: String     read FxProd    write FxProd;
    property NCM: String       read FNCM      write FNCM;
    property CEST: String      read FCEST     write FCEST;
  end;

 { TGTINEnvioWebService }

  TGTINEnvioWebService = class(TGTINWebService)
  private
    FXMLEnvio: String;
    FPURLEnvio: String;
    FVersao: String;
    FSoapActionEnvio: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgErro(E: Exception): String; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    procedure Clear; override;

    function Executar: Boolean; override;

    property Versao: String read FVersao;
    property XMLEnvio: String read FXMLEnvio write FXMLEnvio;
    property URLEnvio: String read FPURLEnvio write FPURLEnvio;
    property SoapActionEnvio: String read FSoapActionEnvio write FSoapActionEnvio;
  end;

  { TWebServices }

  TWebServices = class
  private
    FACBrGTIN: TACBrDFe;
    FConsulta: TGTINConsulta;
    FEnvioWebService: TGTINEnvioWebService;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    property ACBrGTIN: TACBrDFe read FACBrGTIN write FACBrGTIN;
    property Consulta: TGTINConsulta read FConsulta write FConsulta;
    property EnvioWebService: TGTINEnvioWebService read FEnvioWebService write FEnvioWebService;
  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil.Strings, ACBrUtil.DateTime, ACBrUtil.XMLHTML, ACBrUtil.Base,
  ACBrGTIN, ACBrGTINConsts, ACBrGTINConsultar, ACBrGTINRetConsultar,
  pcnLeitor;

{ TGTINWebService }

constructor TGTINWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPConfiguracoesGTIN := TConfiguracoesGTIN(FPConfiguracoes);
  FPLayout := LayGTINConsulta;

  FPHeaderElement := '';
  FPBodyElement := 'ccgConsGTIN';
end;

procedure TGTINWebService.Clear;
begin
  inherited Clear;

  FPStatus := stGTINIdle;
  FPDFeOwner.SSL.UseCertificateHTTP := True;
end;

procedure TGTINWebService.InicializarServico;
begin
  { Sobrescrever apenas se necess�rio }
  inherited InicializarServico;

  TACBrGTIN(FPDFeOwner).SetStatus(FPStatus);
end;

procedure TGTINWebService.DefinirEnvelopeSoap;
var
  Texto: String;
begin
  { Sobrescrever apenas se necess�rio }

  {$IFDEF FPC}
   Texto := '<' + ENCODING_UTF8 + '>';    // Envelope j� est� sendo montado em UTF8
  {$ELSE}
   Texto := '';  // Isso for�ar� a convers�o para UTF8, antes do envio
  {$ENDIF}

  Texto := Texto + '<' + FPSoapVersion + ':Envelope ' + FPSoapEnvelopeAtributtes + '>';
  Texto := Texto + '<' + FPSoapVersion + ':Body>';
  Texto := Texto + '<' + FPBodyElement + ' xmlns="' + Servico + '">';
  Texto := Texto + '<nfeDadosMsg>' + DadosMsg + '</nfeDadosMsg>';
  Texto := Texto + '</' + FPBodyElement + '>';
  Texto := Texto + '</' + FPSoapVersion + ':Body>';
  Texto := Texto + '</' + FPSoapVersion + ':Envelope>';

  FPEnvelopeSoap := Texto;
end;

procedure TGTINWebService.DefinirURL;
var
  Versao: Double;
begin
  { sobrescrever apenas se necess�rio.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';

  TACBrGTIN(FPDFeOwner).LerServicoDeParams(FPLayout, Versao, FPURL);
  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TGTINWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

  TACBrGTIN(FPDFeOwner).SetStatus(stGTINIdle);
end;

{ TGTINConsulta }

constructor TGTINConsulta.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FOwner := AOwner;
end;

destructor TGTINConsulta.Destroy;
begin

  inherited Destroy;
end;

procedure TGTINConsulta.Clear;
begin
  inherited Clear;

  FPStatus := stGTINConsulta;
  FPLayout := LayGTINConsulta;
  FPArqEnv := 'cons-gtin';
  FPArqResp := 'gtin';

  FverAplic := '';
  FcStat := 0;
  FxMotivo := '';
  Fversao := '';
  FdhResp := 0;
  FtpGTIN := 0;
  FxProd := '';
  FNCM := '';
  FCEST := '';

  if Assigned(FPConfiguracoesGTIN) then
  begin
    FtpAmb := FPConfiguracoesGTIN.WebServices.Ambiente;
    FUF := FPConfiguracoesGTIN.WebServices.UF;
  end;
end;

procedure TGTINConsulta.SetGTIN(const AValue: String);
var
  xGTIN: String;
begin
  if FGTIN = AValue then Exit;

  xGTIN := OnlyNumber(AValue);

  FGTIN := xGTIN;
end;

procedure TGTINConsulta.DefinirURL;
var
  VerServ: Double;
  Modelo: String;
  Ambiente: Integer;
begin
  FPVersaoServico := '';
  FPURL   := '';
  Modelo  := 'GTIN';
  FUF    := FPConfiguracoesGTIN.WebServices.UF;
  VerServ := VersaoGTINToDbl(FPConfiguracoesGTIN.Geral.VersaoDF);

  Ambiente := Integer(FPConfiguracoesGTIN.WebServices.Ambiente);

  TACBrGTIN(FPDFeOwner).LerServicoDeParams(
    Modelo,
    FUF,
    TpcnTipoAmbiente(Ambiente),
    LayOutToServico(FPLayout),
    VerServ,
    FPURL
  );

  FPVersaoServico := FloatToString(VerServ, '.', '0.00');
end;

procedure TGTINConsulta.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'ccgConsGtin';
  FPSoapAction := FPServico + '/ccgConsGTIN';
end;

procedure TGTINConsulta.DefinirDadosMsg;
var
  ConsGTIN: TConsultarGTIN;
begin
  ConsGTIN := TConsultarGTIN.Create;
  try
    ConsGTIN.GTIN := FGTIN;
    ConsGTIN.Versao := FPVersaoServico;

    FPDadosMsg := ConsGTIN.GerarXML;
  finally
    ConsGTIN.Free;
  end;
end;

function TGTINConsulta.TratarResposta: Boolean;
var
  GTINRetorno: TRetConsultarGTIN;
begin
  Result := False;

  GTINRetorno := TRetConsultarGTIN.Create;

  try
    FPRetWS := SeparaDados(FPRetornoWS, 'ccgConsGTINResponse');
    GTINRetorno.XmlRetorno := ParseText(FPRetWS, True, False);
    GTINRetorno.LerXML;

    Fversao := GTINRetorno.versao;
    FverAplic := GTINRetorno.verAplic;
    FcStat := GTINRetorno.cStat;
    FxMotivo := GTINRetorno.xMotivo;
    FdhResp := GTINRetorno.dhResp;
    FtpGTIN := GTINRetorno.tpGTIN;
    FxProd := GTINRetorno.xProd;
    FNCM := GTINRetorno.NCM;
    FCEST := GTINRetorno.CEST;

    Result := True;
  finally
    GTINRetorno.Free;
  end;
end;

function TGTINConsulta.GerarMsgLog: String;
begin
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'GTIN: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Resposta: %s ' + LineBreak +
                           'Tipo GTIN: %s ' + LineBreak +
                           'Produto: %s ' + LineBreak +
                           'NCM: %s ' + LineBreak +
                           'CEST: %s ' + LineBreak),
                   [Fversao, FGTIN, FverAplic, IntToStr(FcStat), FXMotivo,
                    FormatDateTimeBr(FdhResp), IntToStr(FtpGTIN), FxProd,
                    FNCM, FCEST]);
end;

function TGTINConsulta.GerarPrefixoArquivo: String;
begin
  Result := Trim(FGTIN);
end;

{ TGTINEnvioWebService }

constructor TGTINEnvioWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stGTINEnvioWebService;
end;

destructor TGTINEnvioWebService.Destroy;
begin
  inherited Destroy;
end;

procedure TGTINEnvioWebService.Clear;
begin
  inherited Clear;

  FVersao := '';
end;

function TGTINEnvioWebService.Executar: Boolean;
begin
  Result := inherited Executar;
end;

procedure TGTINEnvioWebService.DefinirURL;
begin
  FPURL := FPURLEnvio;
end;

procedure TGTINEnvioWebService.DefinirServicoEAction;
begin
  FPServico := FPSoapAction;
end;

procedure TGTINEnvioWebService.DefinirDadosMsg;
var
  LeitorXML: TLeitor;
begin
  LeitorXML := TLeitor.Create;
  try
    LeitorXML.Arquivo := FXMLEnvio;
    LeitorXML.Grupo := FXMLEnvio;
    FVersao := LeitorXML.rAtributo('versao')
  finally
    LeitorXML.Free;
  end;

  FPDadosMsg := FXMLEnvio;
end;

function TGTINEnvioWebService.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'soap:Body');
  Result := True;
end;

function TGTINEnvioWebService.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService: '+FPServico + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TGTINEnvioWebService.GerarVersaoDadosSoap: String;
begin
  Result := '<versaoDados>' + FVersao + '</versaoDados>';
end;

{ TWebServices }

constructor TWebServices.Create(AOwner: TACBrDFe);
begin
  FACBrGTIN := TACBrGTIN(AOwner);

  FConsulta := TGTINConsulta.Create(FACBrGTIN);
  FEnvioWebService := TGTINEnvioWebService.Create(FACBrGTIN);
end;

destructor TWebServices.Destroy;
begin
  FConsulta.Free;
  FEnvioWebService.Free;

  inherited Destroy;
end;

end.
