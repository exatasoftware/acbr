{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{ Colaboradores nesse arquivo:  J�ter Rabelo Ferreira                          }
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

unit ACBrBoletoRet_Santander_API;

interface

uses
  Classes,
  SysUtils,
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  Jsons,
  DateUtils,
  ACBrBoletoWS.Rest,
  pcnConversao;

type
  { TRetornoEnvio_Santander }

  TRetornoEnvio_Santander_API = class(TRetornoEnvioREST)
  private

  public
    constructor Create(ABoletoWS: TACBrBoleto); override;
    destructor  Destroy; Override;
    function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
    function RetornoEnvio(const AIndex: Integer): Boolean; override;
  end;


implementation

uses
  ACBrUtil.Strings,
  ACBrUtil.DateTime;

{ TRetornoEnvio_Santander_API }

constructor TRetornoEnvio_Santander_API.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);
end;

destructor TRetornoEnvio_Santander_API.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_Santander_API.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  AJson: TJson;
  AJSonRejeicao: TJsonObject;
  ARejeicao: TACBrBoletoRejeicao;
  AJSonResp: TJsonArray;
  I: Integer;
begin
  Result := True;

  ARetornoWs.JSONEnvio      := EnvWs;
  ARetornoWS.HTTPResultCode := HTTPResultCode;

  if RetWS <> '' then
  begin
    try
      with ARetornoWS do
      begin
        AJSon := TJson.Create;
        try
          AJSon.Parse(RetWS);
          ARetornoWS.JSON := AJson.Stringify;
          AJSonResp := AJson.Values['_errors'].AsArray;
          ARetornoWS.CodRetorno := IntToStr(HTTPResultCode);
          if AJSonResp.Count > 0  then
          begin
            ARetornoWS.CodRetorno := AJson.Values['_errorCode'].AsString;
            ARetornoWS.MsgRetorno := AJson.Values['_message'].AsString;

            for I := 0 to AJSonResp.Count-1 do
            begin
              AJSonRejeicao      := AJSonResp[I].AsObject;
              ARejeicao          := CriarRejeicaoLista;
              ARejeicao.Codigo   := AJson.Values['_errorCode'].AsString;
              ARejeicao.Campo    := AJSonRejeicao.Values['_code'].AsString;
              ARejeicao.Mensagem := AJSonRejeicao.Values['_field'].AsString;
              ARejeicao.Valor    := AJSonRejeicao.Values['_message'].AsString;
            end;
            Exit;
          end;

          with AJson.Values['payer'].AsObject do
          begin
            DadosRet.TituloRet.Sacado.CNPJCPF        := Values['documentNumber'].AsString;
            DadosRet.TituloRet.Sacado.NomeSacado     := Values['name'].AsString;
            DadosRet.TituloRet.Sacado.Logradouro := Values['address'].AsString;
            DadosRet.TituloRet.Sacado.Bairro     := Values['neighborhood'].AsString;
            DadosRet.TituloRet.Sacado.Cidade     := Values['city'].AsString;
            DadosRet.TituloRet.Sacado.UF         := Values['state'].AsString;
            DadosRet.TituloRet.Sacado.Cep        := Values['zipCode'].AsString;
          end;

          with AJson.Values['beneficiary'].AsObject do
          begin
            DadosRet.TituloRet.SacadoAvalista.CNPJCPF := Values['documentNumber'].AsString;
            DadosRet.TituloRet.SacadoAvalista.NomeAvalista := Values['name'].AsString;
          end;

          DadosRet.IDBoleto.CodBarras := AJson.Values['barCode'].AsString;
          DadosRet.IDBoleto.LinhaDig  := AJson.Values['digitableLine'].AsString;
          DadosRet.IDBoleto.NossoNum  := AJson.Values['bankNumber'].AsString;

          DadosRet.TituloRet.Vencimento:= StringToDateTimeDef(AJson.Values['dueDate'].AsString, 0, 'yyyy-mm-dd');
          DadosRet.TituloRet.NossoNumero:= AJson.Values['bankNumber'].AsString;
          DadosRet.TituloRet.SeuNumero:= AJson.Values['clientNumber'].AsString;
          DadosRet.TituloRet.CodBarras:= AJson.Values['barCode'].AsString;
          DadosRet.TituloRet.LinhaDig:= AJson.Values['digitableLine'].AsString;
          DadosRet.TituloRet.DataProcessamento:= StringToDateTimeDef(AJson.Values['entryDate'].AsString, 0, 'yyyy-mm-dd');
          DadosRet.TituloRet.DataDocumento:=  StringToDateTimeDef(AJson.Values['issueDate'].AsString, 0, 'yyyy-mm-dd');
          DadosRet.TituloRet.ValorDocumento:= StrToFloatDef( AJson.Values['nominalValue'].AsString, 0);
          DadosRet.TituloRet.EMV := AJson.Values['qrCodePix'].AsString;
          DadosRet.TituloRet.UrlPix := AJson.Values['qrCodeUrl'].AsString;
        finally
          AJson.free;
        end;
      end;
    except
      Result := False;
    end;
  end;
end;

function TRetornoEnvio_Santander_API.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  Result:=inherited RetornoEnvio(AIndex);
end;

end.

