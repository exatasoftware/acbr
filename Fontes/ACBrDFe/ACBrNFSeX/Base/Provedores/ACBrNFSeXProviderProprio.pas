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

unit ACBrNFSeXProviderProprio;

interface

uses
  SysUtils, Classes,
  ACBrXmlDocument,
  ACBrNFSeXProviderBase, ACBrNFSeXWebservicesResponse;

type
  TACBrNFSeProviderProprio = class(TACBrNFSeXProvider)
  protected
    procedure Configuracao; override;

    procedure PrepararEmitir(Response: TNFSeEmiteResponse); override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;

    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;

    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;

    procedure PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;
    procedure TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse); override;

    procedure PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;
    procedure TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse); override;

    procedure PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeServicoPrestado(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); virtual;
    procedure TratarRetornoConsultaNFSeServicoTomado(Response: TNFSeConsultaNFSeResponse); virtual;

    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;

    procedure PrepararSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;
    procedure TratarRetornoSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse); override;

    procedure ProcessarMensagemErros(const RootNode: TACBrXmlNode;
                                     const Response: TNFSeWebserviceResponse;
                                     AListTag: string = 'ListaMensagemRetorno';
                                     AMessageTag: string = 'MensagemRetorno'); virtual;

  end;

implementation

{ TACBrNFSeProviderProprio }

procedure TACBrNFSeProviderProprio.Configuracao;
begin
  inherited Configuracao;

end;

procedure TACBrNFSeProviderProprio.PrepararEmitir(Response: TNFSeEmiteResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaNFSeporRps(Response: TNFSeConsultaNFSeporRpsResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaNFSe(Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaNFSeporFaixa(Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaNFSeServicoPrestado(
  Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoConsultaNFSeServicoTomado(
  Response: TNFSeConsultaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.PrepararSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.TratarRetornoSubstituiNFSe(Response: TNFSeSubstituiNFSeResponse);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

procedure TACBrNFSeProviderProprio.ProcessarMensagemErros(const RootNode: TACBrXmlNode;
  const Response: TNFSeWebserviceResponse; AListTag, AMessageTag: string);
begin
  // Deve ser implementado para cada provedor que tem o seu pr�prio layout
end;

end.
