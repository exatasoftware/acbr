{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Elias C�sar Vieira                              }
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

unit ACBrPIXPSPPixPDV;

interface

uses
  Classes, SysUtils, ACBrPIXCD;

const

  cPixPDVURLSandbox = 'https://pixpdv.com.br/api-h/v1';
  cPixPDVURLProducao = 'https://pixpdv.com.br/api/v1';
  cPixPDVHeaderPoweredBy = 'X-PoweredBy: Projeto ACBr';

type

  TACBrPSPPixPDV = class(TACBrPSP)
  private
    fCNPJ: String;
    fToken: String;

  protected
    function ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String; override;

    procedure ConfigurarAutenticacao(const Method: string; const EndPoint: string); override;
    procedure ConfigurarHeaders(const Method: string; const AURL: string); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property CNPJ: String read fCNPJ write fCNPJ;
    property Token: String read fToken write fToken;
    property ClientSecret;
  end;

implementation

uses
  ACBrOpenSSLUtils;

{ TACBrPSPPixPDV }

procedure TACBrPSPPixPDV.ConfigurarAutenticacao(const Method, EndPoint: string);
begin
  inherited ConfigurarAutenticacao(Method, EndPoint);

  Http.UserName := CNPJ;
  Http.Password := Token;
end;

procedure TACBrPSPPixPDV.ConfigurarHeaders(const Method, AURL: string);
var
  wHash: String;
  wStrStream: TStringStream;
  wOpenSSL: TACBrOpenSSLUtils;
begin
  inherited ConfigurarHeaders(Method, AURL);

  Http.Headers.Add(cPixPDVHeaderPoweredBy);

  if (Http.Document.Size <= 0) then
    Exit;

  wStrStream := TStringStream.Create('');
  wOpenSSL := TACBrOpenSSLUtils.Create(Nil);
  try
    wStrStream.CopyFrom(Http.Document, 0);
    wHash := wOpenSSL.HMACFromString(wStrStream.DataString, ClientSecret, algSHA256);

    Http.Headers.Add('Json-Hash: ' + wHash);
  finally
    wOpenSSL.Free;
    wStrStream.Free;
  end;
end;

constructor TACBrPSPPixPDV.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fCNPJ := EmptyStr;
  fToken := EmptyStr;
end;

function TACBrPSPPixPDV.ObterURLAmbiente(const Ambiente: TACBrPixCDAmbiente): String;
begin
  if (Ambiente = ambProducao) then
    Result := cPixPDVURLProducao
  else
    Result := cPixPDVURLSandbox;
end;

end.
