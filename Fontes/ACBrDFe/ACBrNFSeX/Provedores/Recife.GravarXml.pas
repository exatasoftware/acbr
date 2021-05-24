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

unit Recife.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml_ABRASFv1, ACBrNFSeXConversao;

type
  { TNFSeW_Recife }

  TNFSeW_Recife = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Recife
//==============================================================================

{ TNFSeW_Recife }

procedure TNFSeW_Recife.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Altera a Configura��o Padr�o para gerar o XML do RPS
  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;
  NrOcorrAliquota := 0;
  NrOcorrValorTotalRecebido := 1;
end;
{
procedure TNFSeW_Recife.ConfigurarEnvelopes;
begin
  with ConfigEnvelope do
  begin
    with Recepcionar do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'RecepcionarLoteRpsRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with ConsultarSituacao do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'ConsultarSituacaoLoteRpsRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with ConsultarLote do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'ConsultarLoteRpsRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with ConsultarNFSePorRps do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'ConsultarNfsePorRpsRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with ConsultarNFSe do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'ConsultarNfseRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with Cancelar do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'CancelarNfseRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
    end;

    with GerarNFSe do
    begin
      IncluirEncodingDados := True;
      ElementoBody := 'GerarNfseRequest';
      AtributoElementoBody := ' xmlns="http://nfse.recife.pe.gov.br/"';
      ElementoCabecalho := '';
      ElementoDados := 'inputXML';
      ServicoImplementado := True;
    end;
  end;
end;

procedure TNFSeW_Recife.ConfigurarSoapAction;
var
  URL: string;
begin
  URL := 'http://nfse.recife.pe.gov.br/';

  with ConfigSoapAction do
  begin
    Recepcionar         := URL + 'RecepcionarLoteRps';
    ConsultarSituacao   := URL + 'ConsultarSituacaoLoteRps';
    ConsultarLote       := URL + 'ConsultarLoteRps';
    ConsultarNFSePorRps := URL + 'ConsultarNfsePorRps';
    ConsultarNFSe       := URL + 'ConsultarNfse';
    Cancelar            := URL + 'CancelarNfse';
    GerarNFSe           := URL + 'GerarNfse';
  end;
end;
}
end.
