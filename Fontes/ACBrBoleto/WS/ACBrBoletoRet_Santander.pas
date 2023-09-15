{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo:  Renato Rubinho                                 }
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

unit ACBrBoletoRet_Santander;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  ACBrUtil,
  DateUtils,
  pcnConversao,
  ACBrBoletoWS.SOAP;

type
  { TRetornoEnvio_Santander }

  TRetornoEnvio_Santander = class(TRetornoEnvioSOAP)
  private

  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;
  end;

  const
  C_URL_Retorno = 'soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"';

implementation

uses
  ACBrBoletoConversao;

{ TRetornoEnvio_Santander }

constructor TRetornoEnvio_Santander.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_Santander.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Santander.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  RetornoSantander: TACBrBoletoRetornoWS;
  lXML: String;
  TipoOperacao : TOperacao;
begin
  Result := True;

  TipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;
  ARetornoWS.HTTPResultCode := HTTPResultCode;
  ARetornoWS.JSONEnvio      := EnvWs;
  ARetornoWS.Header.Operacao := TipoOperacao;

  lXML := StringReplace(Leitor.Arquivo, 'ns2:', '', [rfReplaceAll]) ;
  lXML := StringReplace(lXML, C_URL_Retorno, '', [rfReplaceAll]) ;
  Leitor.Arquivo := lXML;
  Leitor.Grupo   := Leitor.Arquivo;

  RetornoSantander := ARetornoWS;
  try
    if leitor.rExtrai(1, 'registraTituloResponse') <> '' then
    begin
      RetornoSantander.DadosRet.ControleNegocial.NSU := Leitor.rCampo(tcStr, 'NSU');
      RetornoSantander.DadosRet.IDBoleto.NossoNum    := Leitor.rCampo(tcStr, 'nossoNumero');
      RetornoSantander.DadosRet.IDBoleto.LinhaDig    := Leitor.rCampo(tcStr, 'linDig');
      RetornoSantander.DadosRet.IDBoleto.CodBarras   := Leitor.rCampo(tcStr, 'cdBarra');

      RetornoSantander.DadosRet.Excecao := Leitor.rCampo(tcStr, 'descricaoErro');
    end;

    // Ticket - Extrair o ticket e validar
    if leitor.rExtrai(1, 'TicketResponse') <> '' then
    begin
      RetornoSantander.CodRetorno                        := Leitor.rCampo(tcStr, 'retCode');
      RetornoSantander.DadosRet.ControleNegocial.Retorno := Leitor.rCampo(tcStr, 'ticket');
    end;

  except
    Result := False;
  end;
end;

function TRetornoEnvio_Santander.RetornoEnvio(const AIndex: Integer): Boolean;
var
  lRetornoWS: String;
begin
  lRetornoWS := RetWS;
  RetWS := SeparaDados(lRetornoWS, 'soapenv:Body');

  Result := inherited RetornoEnvio(AIndex);
end;

end.

