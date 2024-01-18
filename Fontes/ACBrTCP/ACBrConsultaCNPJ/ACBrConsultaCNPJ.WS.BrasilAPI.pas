{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Victor H Gonzales - Pandaaa                     }
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
unit ACBrConsultaCNPJ.WS.BrasilAPI;

interface
uses
  ACBrJSON, Jsons, SysUtils, ACBrConsultaCNPJ.WS;
type
  EACBrConsultaCNPJWSException = class ( Exception );

  { TACBrConsultaCNPJWS }
  TACBrConsultaCNPJWSBrasilAPI = class(TACBrConsultaCNPJWS)
    public
      function Executar:boolean; override;
  end;
const
  C_URL = 'https://brasilapi.com.br/api/cnpj/v1/';

implementation

uses
  ACBrUtil.XMLHTML,
  ACBrUtil.Strings,
  ACBrUtil.DateTime,
  blcksock,
  Classes,
  synautil, httpsend;

{ TACBrConsultaCNPJWS }

function TACBrConsultaCNPJWSBrasilAPI.Executar: boolean;
var
  LJSon: TJson;
  LJsonObject : TJsonObject;
  LStream : TStringStream;
  LRetorno : String;
  LJsonArray: TJsonArray;
  I, Z : Integer;
begin
  inherited Executar;
  HTTPSend := THTTPSend.Create;
  try
    LStream  := TStringStream.Create('');
    try
      HTTPSend.OutputStream := LStream;
      HTTPSend.Clear;
      HTTPSend.Headers.Clear;
      HTTPSend.Headers.Add('Accept: application/json');

      HTTPSend.MimeType := 'application/json';

      HTTPSend.Sock.SSL.SSLType := LT_TLSv1_2;

      HTTPSend.HTTPMethod('GET',C_URL +  OnlyNumber(FCNPJ));

      HTTPSend.Document.Position:= 0;
      LRetorno := ReadStrFromStream(LStream, LStream.Size);

      LJSon := TJson.Create;
      try
        LJSon.Parse('[' + UTF8ToNativeString(LRetorno) + ']');
        for I := 0 to Pred(LJSon.Count) do
        begin
          LJsonObject := LJSon.Get(I).AsObject;
          if HTTPSend.ResultCode = 200 then
          begin
            FResposta.RazaoSocial          := LJsonObject.Values['razao_social'].AsString;
            FResposta.CNPJ                 := LJsonObject.Values['cnpj'].AsString;
            FResposta.Fantasia             := LJsonObject.Values['nome_fantasia'].AsString;
            FResposta.Abertura             := StringToDateTimeDef(LJsonObject.Values['data_inicio_atividade'].AsString,0,'yyyy/mm/dd');
            FResposta.Porte                := LJsonObject.Values['descricao_porte'].AsString;

            FResposta.CNAE1                := IntToStr(LJsonObject.Values['cnae_fiscal'].AsInteger) + ' ' + LJsonObject.Values['cnae_fiscal_descricao'].AsString;

            LJsonArray := LJsonObject.Values['cnaes_secundarias'].AsArray;
            for Z := 0 to Pred(LJsonArray.Count) do
              FResposta.CNAE2.Add(IntToStr(LJsonArray[Z].AsObject.Values['codigo'].AsInteger) + ' ' + LJsonArray[Z].AsObject.Values['descricao'].AsString);

            FResposta.EmpresaTipo          := LJsonObject.Values['descricao_matriz_filial'].AsString;
            FResposta.Endereco             := LJsonObject.Values['logradouro'].AsString;
            FResposta.Numero               := LJsonObject.Values['numero'].AsString;
            FResposta.Complemento          := LJsonObject.Values['complemento'].AsString;
            FResposta.CEP                  := IntToStr( LJsonObject.Values['cep'].AsInteger);
            FResposta.Bairro               := LJsonObject.Values['bairro'].AsString;
            FResposta.Cidade               := LJsonObject.Values['municipio'].AsString;
            FResposta.CodigoIBGE           := IntToStr(LJsonObject.Values['codigo_municipio'].AsInteger);
            FResposta.UF                   := LJsonObject.Values['uf'].AsString;
            FResposta.Situacao             := LJsonObject.Values['descricao_situacao_cadastral'].AsString;
            FResposta.SituacaoEspecial     := LJsonObject.Values['situacao_especial'].AsString;
            FResposta.DataSituacao         := StringToDateTimeDef(LJsonObject.Values['data_situacao_cadastral'].AsString,0,'yyyy/mm/dd');
            FResposta.DataSituacaoEspecial := StringToDateTimeDef(LJsonObject.Values['data_situacao_especial'].AsString,0,'yyyy/mm/dd');
            FResposta.NaturezaJuridica     := IntToStr(LJsonObject.Values['codigo_natureza_juridica'].AsInteger);
            FResposta.EndEletronico        := LJsonObject.Values[''].AsString;
            FResposta.Telefone             := LJsonObject.Values['ddd_telefone_1'].AsString;
            FResposta.EFR                  := '';

            FResposta.MotivoSituacaoCad    := LJsonObject.Values['motivo_situacao_cadastral'].AsString;

            Result := true;
          end else
          begin
            if (Trim(LJsonObject.Values['message'].AsString) <> '') then
              raise EACBrConsultaCNPJWSException.Create('Erro:'+IntToStr(HTTPSend.ResultCode) + ' - ' +LJsonObject.Values['message'].AsString);
          end;
        end;
      finally
        LJSon.Free;
      end;
    finally
      LStream.free;
    end;
  finally
    HTTPSend.Free;
  end;
end;

end.
