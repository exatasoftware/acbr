{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Ferreira de Moraes                        }
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

unit ACBrSATWS_WebServices;

interface

uses
  Classes, SysUtils,
  ACBrDFe, pcnSATConsulta, pcnSATConsultaRet, ACBrDFeWebService,
  ACBrUtil, pcnConversao;

const
  ACBRSATWS_VERSAO = '0.1';

  type

  { TWebServiceSATWS }

  TWebServiceSATWS = class(TDFeWebService)
  private
  protected
    procedure DefinirURL; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
  end;

  { TConsultarSATWS }

  TConsultarSATWS = class(TWebServiceSATWS)
    FtpAmb          : TpcnTipoAmbiente;
    FcUF            : Integer;
    FversaoDados    : String;
    FnserieSAT      : Integer;
    FdhInicial      : TDateTime;
    FdhFinal        : TDateTime;
    FchaveSeguranca : String;
    FConsultaRet : TSATConsultaRet;
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;
  protected
    function GerarVersaoDadosSoap: String; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    property tpAmb          : TpcnTipoAmbiente read FtpAmb          write FtpAmb;
    property cUF            : Integer          read FcUF            write FcUF;
    property versaoDados    : String           read FversaoDados    write FversaoDados;
    property nserieSAT      : Integer          read FnserieSAT      write FnserieSAT;
    property dhInicial      : TDateTime        read FdhInicial      write FdhInicial;
    property dhFinal        : TDateTime        read FdhFinal        write FdhFinal;
    property chaveSeguranca : String           read FchaveSeguranca write FchaveSeguranca;
    property ConsultaRet: TSATConsultaRet read FConsultaRet write FConsultaRet;
  end;

  { TACBrSATWS_WebServices }

  TACBrSATWS_WebServices = class
  private
    FConsultarSATWS: TConsultarSATWS;

  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    property ConsultarSATWS: TConsultarSATWS read FConsultarSATWS write FConsultarSATWS;
  end;

implementation

uses
  ACBrSATWS;

{ TWebServiceSATWS }

constructor TWebServiceSATWS.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);
  FPHeaderElement := 'cfeCabecMsg';
  FPBodyElement := 'CfeConsultarLotes';

  FPDFeOwner.SSL.UseCertificateHTTP := False;
end;

procedure TWebServiceSATWS.DefinirURL;
begin
  FPURL := 'https://wssatsp.fazenda.sp.gov.br/CfeConsultarLotes/CfeConsultarLotes.asmx';
end;

{ TConsultarBlocoX }

destructor TConsultarSATWS.Destroy;
begin
  FConsultaRet.Free;
  inherited Destroy;
end;

procedure TConsultarSATWS.Clear;
begin
  inherited Clear;

  if Assigned(FConsultaRet) then
    FConsultaRet.Free;

  FConsultaRet := TSATConsultaRet.Create;

  FPArqEnv := 'ped-con-sat';
  FPArqResp := 'resp-con-sat'
end;

procedure TConsultarSATWS.DefinirURL;
begin
  inherited DefinirURL;
  FPBodyElement := 'CfeConsultarLotes';
end;

procedure TConsultarSATWS.DefinirServicoEAction;
begin
  FPServico := 'http://www.fazenda.sp.gov.br/sat/wsdl/CfeConsultaLotes';
  FPSoapAction := 'http://www.fazenda.sp.gov.br/sat/wsdl/CfeConsultar';
end;

procedure TConsultarSATWS.DefinirDadosMsg;
var
  ConsultaSAT: TSATConsulta;
begin
  ConsultaSAT := TSATConsulta.Create;
  try
    ConsultaSAT.tpAmb       := tpAmb;
    ConsultaSAT.versaoDados := versaoDados;
    ConsultaSAT.nserieSAT   := nserieSAT;
    ConsultaSAT.dhInicial   := dhInicial;
    ConsultaSAT.dhFinal     := dhFinal;
    ConsultaSAT.chaveSeguranca := chaveSeguranca;
    ConsultaSAT.GerarXML;

    FPDadosMsg := '<cfeDadosMsg>'+'<![CDATA['+ConsultaSAT.Gerador.ArquivoFormatoXML+ ']]>'+'</cfeDadosMsg>';
  finally
    ConsultaSAT.Free;
  end;
end;

function TConsultarSATWS.TratarResposta: Boolean;
begin
  FPRetWS := Trim(ParseText(SeparaDados(FPRetornoWS, 'CfeConsultarLotesResult')));

  FConsultaRet.Leitor.Arquivo := FPRetWS;
  FConsultaRet.LerXml;

  Result := (FPRetWS <> '');
end;

function TConsultarSATWS.GerarVersaoDadosSoap: String;
begin
  Result:='<versaoDados>'+versaoDados+'</versaoDados>';
end;


{ TACBrSATWS_WebServices }

constructor TACBrSATWS_WebServices.Create(AOwner: TACBrDFe);
begin
  FConsultarSATWS := TConsultarSATWS.Create(AOwner);
end;

destructor TACBrSATWS_WebServices.Destroy;
begin
  FConsultarSATWS.Free;
  inherited Destroy;
end;


end.
