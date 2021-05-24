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

unit Ginfes.GravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrXmlBase,
  ACBrNFSeXParametros,
  ACBrNFSeXConversao,
  ACBrNFSeXGravarXml_ABRASFv1;

type
  { TNFSeW_Ginfes }

  TNFSeW_Ginfes = class(TNFSeW_ABRASFv1)
  protected
    procedure Configuracao; override;

  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o XML do RPS do provedor:
//     Ginfes
//==============================================================================

{ TNFSeW_Ginfes }

procedure TNFSeW_Ginfes.Configuracao;
begin
  // Executa a Configura��o Padr�o
  inherited Configuracao;

  // Altera a Configura��o Padr�o para gerar o XML do RPS
  NrOcorrAliquota := 0;
  NrOcorrValorPis := 1;
  NrOcorrValorCofins := 1;
  NrOcorrValorInss := 1;
  NrOcorrValorIr := 1;
  NrOcorrValorCsll := 1;
  NrOcorrValorIss := 1;

  PrefixoPadrao := 'ns4';
end;
{
procedure TNFSeW_Ginfes.ConfigurarEnvelopes;
var
  NameSpace: string;
begin
  with ConfigEnvelope do
  begin
    with ConsultarSituacao do
    begin
      ElementoBody := 'ns1:ConsultarSituacaoLoteRpsV3';
      AtributoElementoBody := ' xmlns:ns1="' + NameSpace + '"';
      ElementoCabecalho := 'arg0';
      ElementoDados := 'arg1';
    end;

    with ConsultarLote do
    begin
      ElementoBody := 'ns1:ConsultarLoteRpsV3';
      AtributoElementoBody := ' xmlns:ns1="' + NameSpace + '"';
      ElementoCabecalho := 'arg0';
      ElementoDados := 'arg1';
    end;

    with ConsultarNFSePorRps do
    begin
      ElementoBody := 'ns1:ConsultarNfsePorRpsV3';
      AtributoElementoBody := ' xmlns:ns1="' + NameSpace + '"';
      ElementoCabecalho := 'arg0';
      ElementoDados := 'arg1';
    end;

    with ConsultarNFSe do
    begin
      ElementoBody := 'ns1:ConsultarNfseV3';
      AtributoElementoBody := ' xmlns:ns1="' + NameSpace + '"';
      ElementoCabecalho := 'arg0';
      ElementoDados := 'arg1';
    end;

    with Cancelar do
    begin
      ElementoBody := 'ns1:CancelarNfse';
      AtributoElementoBody := ' xmlns:ns1="' + NameSpace + '"';
      ElementoCabecalho := '';
      ElementoDados := 'arg0';
    end;
  end;
end;

procedure TNFSeW_Ginfes.ConfigurarRetornos;
begin
  DefinirRetornoNFSe;

  with ConfigRetorno do
  begin
    GrupoMsgRecepcionar         := 'return';
    GrupoMsgConsultarSituacao   := GrupoMsgRecepcionar;
    GrupoMsgConsultarLote       := GrupoMsgRecepcionar;
    GrupoMsgConsultarNFSePorRps := GrupoMsgRecepcionar;
    GrupoMsgConsultarNFSe       := GrupoMsgRecepcionar;
    GrupoMsgCancelar            := GrupoMsgRecepcionar;

    // Os demais seguem o padr�o
    GrupoConsultarNFSePorRps := 'ConsultarNfseResposta';
  end;
end;
}
end.
