{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ISSIntel.Provider;

interface

uses
  SysUtils, Classes,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderABRASFv1, ACBrNFSeXWebserviceBase;

type
  TACBrNFSeXWebserviceISSIntel = class(TACBrNFSeXWebserviceSoap11)
  private
    function GetNameSpace: string;
    function GetSoapAction: string;
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSePorRps(ACabecalho, AMSG: String): string; override;
    function ConsultarNFSe(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;

    property NameSpace: string read GetNameSpace;
    property SoapAction: string read GetSoapAction;
  end;

  TACBrNFSeProviderISSIntel = class (TACBrNFSeProviderABRASFv1)
  protected
    procedure Configuracao; override;

    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;

  end;

implementation

uses
  ACBrNFSeX, ACBrDFeException,
  ISSIntel.GravarXml, ISSIntel.LerXml;

{ TACBrNFSeProviderISSIntel }

procedure TACBrNFSeProviderISSIntel.Configuracao;
begin
  inherited Configuracao;

  with ConfigAssinar do
  begin
    LoteRps := True;
    CancelarNFSe := True;
  end;

  SetXmlNameSpace('http://www.abrasf.org.br/nfse.xsd');

  ConfigWebServices.AtribVerLote := 'versao';
end;

function TACBrNFSeProviderISSIntel.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSIntel.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSIntel.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSIntel.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSIntel.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
begin
  if FAOwner.Configuracoes.WebServices.AmbienteCodigo = 2 then
  begin
   with ConfigWebServices.Homologacao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, CancelarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end
  else
  begin
    with ConfigWebServices.Producao do
    begin
      case AMetodo of
        tmRecepcionar:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, Recepcionar);
        tmConsultarSituacao:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarSituacao);
        tmConsultarLote:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarLote);
        tmConsultarNFSePorRps:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarNFSeRps);
        tmConsultarNFSe:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, ConsultarNFSe);
        tmCancelarNFSe:
          Result := TACBrNFSeXWebserviceISSIntel.Create(FAOwner, AMetodo, CancelarNFSe);
      else
        raise EACBrDFeException.Create(ERR_NAO_IMP);
      end;
    end;
  end;
end;

{ TACBrNFSeXWebserviceISSIntel }

function TACBrNFSeXWebserviceISSIntel.GetNameSpace: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.NameSpace
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.NameSpace;

  Result := 'xmlns:urn="' + Result + '"';
end;

function TACBrNFSeXWebserviceISSIntel.GetSoapAction: string;
begin
  if FPConfiguracoes.WebServices.AmbienteCodigo = 2 then
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Homologacao.SoapAction
  else
    Result := TACBrNFSeX(FPDFeOwner).Provider.ConfigWebServices.Producao.SoapAction;
end;

function TACBrNFSeXWebserviceISSIntel.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:RecepcionarLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</urn:RecepcionarLoteRps>';

  Result := Executar(SoapAction + 'RecepcionarLoteRps', Request,
                     ['EnviarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSIntel.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:ConsultarLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</urn:ConsultarLoteRps>';

  Result := Executar(SoapAction + 'ConsultarLoteRps', Request,
                     ['ConsultarLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSIntel.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:ConsultarSituacaoLoteRps>';
  Request := Request + AMSG;
  Request := Request + '</urn:ConsultarSituacaoLoteRps>';

  Result := Executar(SoapAction + 'ConsultarSituacaoLoteRps', Request,
                     ['ConsultarSituacaoLoteRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSIntel.ConsultarNFSePorRps(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:ConsultarNfsePorRps>';
  Request := Request + AMSG;
  Request := Request + '</urn:ConsultarNfsePorRps>';

  Result := Executar(SoapAction + 'ConsultarNfsePorRps', Request,
                     ['ConsultarNfseRpsResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSIntel.ConsultarNFSe(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:ConsultarNfse>';
  Request := Request + AMSG;
  Request := Request + '</urn:ConsultarNfse>';

  Result := Executar(SoapAction + 'ConsultarNfse', Request,
                     ['ConsultarNfseResposta'],
                     [NameSpace]);
end;

function TACBrNFSeXWebserviceISSIntel.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<urn:CancelarNfse>';
  Request := Request + AMSG;
  Request := Request + '</urn:CancelarNfse>';

  Result := Executar(SoapAction + 'CancelarNfse', Request,
                     ['CancelarNfseResposta'],
                     [NameSpace]);
end;

end.
