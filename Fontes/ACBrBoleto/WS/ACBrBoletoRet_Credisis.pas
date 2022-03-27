{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo:  Victor Hugo Gonzales - Panda                   }
{                               Igless                                         }
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

unit ACBrBoletoRet_Credisis;

interface

uses
  Classes, SysUtils, ACBrBoleto, ACBrBoletoWS, ACBrBoletoRetorno,  ACBrUtil, DateUtils, pcnConversao;

type

{ TRetornoEnvio_Credisis }

  TRetornoEnvio_Credisis = class(TRetornoEnvioSOAP)
  private

  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno: Boolean;override;
    function RetornoEnvio: Boolean; override;

  end;

  const
  C_URL_Retorno = 'SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="urn:CredisisBoletoInterface-CredisisWebService"';

implementation

uses
  ACBrBoletoConversao, ACBrUtil.XMLHTML;

{ TRetornoEnvio_Credisis }

constructor TRetornoEnvio_Credisis.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_Credisis.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Credisis.LerRetorno: Boolean;
var
    RetornoCredisis: TRetEnvio;
    lXML: String;
begin
    Result := True;

    lXML:= StringReplace(Leitor.Arquivo, 'ns1:', '', [rfReplaceAll]) ;
    lXML:= StringReplace(lXML, C_URL_Retorno, '', [rfReplaceAll]) ;
    Leitor.Arquivo := lXML;
    Leitor.Grupo   := Leitor.Arquivo;

    RetornoCredisis:= ACBrBoleto.CriarRetornoWebNaLista;
    try
      if leitor.rExtrai(1, 'gerarBoletosResponse') <> '' then
      begin
          RetornoCredisis.DadosRet.ControleNegocial.NSU := Leitor.rCampo(tcStr, 'numeroSequencial');
          RetornoCredisis.DadosRet.IDBoleto.NossoNum    := Leitor.rCampo(tcStr, 'nossonumero');
          RetornoCredisis.DadosRet.IDBoleto.LinhaDig    := Leitor.rCampo(tcStr, 'linhaDigitavel');
          RetornoCredisis.DadosRet.IDBoleto.CodBarras   := Leitor.rCampo(tcStr, 'codigoBarras');

          RetornoCredisis.CodRetorno       := Leitor.rCampo(tcStr, 'code');
          RetornoCredisis.DadosRet.Excecao := Leitor.rCampo(tcStr, 'message');
      end;
    except
      Result := False;
    end;

  end;

function TRetornoEnvio_Credisis.RetornoEnvio: Boolean;
var
  lRetornoWS: String;
begin

  lRetornoWS := RetWS;
  RetWS := SeparaDados(lRetornoWS, 'SOAP-ENV:Body');

  Result:=inherited RetornoEnvio;

end;

end.

