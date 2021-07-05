{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Jos� M S Junior, Victor Hugo Gonzales          }
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

unit ACBrBoletoRet_BancoBrasil_API;

interface

uses
  Classes, SysUtils, ACBrBoleto,ACBrBoletoWS, ACBrBoletoRetorno,
  Jsons,
  ACBrUtil, DateUtils, pcnConversao;

type

{ TRetornoEnvio_BancoBrasil_API }

 TRetornoEnvio_BancoBrasil_API = class(TRetornoEnvioREST)
 private
   function DateBBtoDateTime(Const AValue : String) : TDateTime;
 public
   constructor Create(ABoletoWS: TACBrBoleto); override;
   destructor  Destroy; Override;
   function LerRetorno: Boolean; override;
   function RetornoEnvio: Boolean; override;

 end;

implementation

uses
  ACBrBoletoConversao;

{ TRetornoEnvio }

constructor TRetornoEnvio_BancoBrasil_API.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);

end;

function TRetornoEnvio_BancoBrasil_API.DateBBtoDateTime(
  const AValue: String): TDateTime;
begin
  Result := StrToDateDef( StringReplace( AValue,'.','/', [rfReplaceAll] ),0);
end;

destructor TRetornoEnvio_BancoBrasil_API.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_BancoBrasil_API.LerRetorno: Boolean;
var
  Retorno: TRetEnvio;
  AJson: TJson;
  AJSonRejeicao, AJSonObject: TJsonObject;
  ARejeicao: TRejeicao;
  AJSonResp, AJsonBoletos: TJsonArray;
  I: Integer;
  TipoOperacao : TOperacao;
begin
  Result := True;
  TipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;
  if RetWS <> '' then
  begin
    Retorno := ACBrBoleto.CriarRetornoWebNaLista;
    try
      AJSon := TJson.Create;
      try
        AJSon.Parse(RetWS);
        AJSonResp              := AJson.Values['erros'].AsArray;
        Retorno.HTTPResultCode := HTTPResultCode;
        Retorno.JSON           := AJson.Stringify;
        //retorna quando houver erro
        For I := 0 to Pred(AJSonResp.Count) do
        begin
          AJSonRejeicao := AJSonResp[I].AsObject;
          ARejeicao            := Retorno.CriarRejeicaoLista;
          ARejeicao.Codigo     := AJSonRejeicao.Values['codigo'].AsString;
          ARejeicao.Versao     := AJSonRejeicao.Values['versao'].AsString;
          ARejeicao.Mensagem   := AJSonRejeicao.Values['mensagem'].AsString;
          ARejeicao.Ocorrencia := AJSonRejeicao.Values['ocorrencia'].AsString;
        end;
        if (AJson.Values['error'].AsString <> '') then
        begin
          ARejeicao            := Retorno.CriarRejeicaoLista;
          ARejeicao.Codigo     := AJson.Values['statusCode'].AsString;
          ARejeicao.Versao     := AJson.Values['error'].AsString;
          ARejeicao.Mensagem   := AJson.Values['message'].AsString;
        end;

        //retorna quando tiver sucesso
        if (Retorno.ListaRejeicao.Count = 0) then
        begin
          if (TipoOperacao = tpInclui) then
          begin
            AJSonObject := AJson.Values['qrCode'].AsObject;
            QRCodeRet.url := AJSonObject.Values['url'].AsString;
            QRCodeRet.txId := AJSonObject.Values['txId'].AsString;
            QRCodeRet.emv := AJSonObject.Values['emv'].AsString;

            Retorno.DadosRet.IDBoleto.CodBarras      := AJson.Values['codigoBarraNumerico'].AsString;
            Retorno.DadosRet.IDBoleto.LinhaDig       := AJson.Values['linhaDigitavel'].AsString;
            Retorno.DadosRet.IDBoleto.NossoNum       := AJson.Values['numero'].AsString;

            Retorno.DadosRet.TituloRet.CodBarras     := Retorno.DadosRet.IDBoleto.CodBarras;
            Retorno.DadosRet.TituloRet.LinhaDig      := Retorno.DadosRet.IDBoleto.LinhaDig;
            Retorno.DadosRet.TituloRet.NossoNumero   := Retorno.DadosRet.IDBoleto.NossoNum;
            Retorno.DadosRet.TituloRet.Carteira      := IntToStrZero(AJson.Values['numeroCarteira'].AsInteger,0);
            Retorno.DadosRet.TituloRet.Modalidade    := AJson.Values['numeroVariacaoCarteira'].AsInteger;
            Retorno.DadosRet.TituloRet.CodigoCliente := AJson.Values['codigoCliente'].AsNumber;
          end else
          if (TipoOperacao = tpConsulta) then
          begin
            AJsonBoletos := AJson.Values['boletos'].AsArray;
            for I := 0 to Pred(AJsonBoletos.Count) do
            begin
              if I > 0 then
                Retorno := ACBrBoleto.CriarRetornoWebNaLista;
                
              AJSonObject  := AJsonBoletos[I].AsObject;

              Retorno.indicadorContinuidade := AJson.Values['indicadorContinuidade'].AsString = 'S';
              Retorno.proximoIndice         := AJson.Values['proximoIndice'].AsInteger;



              Retorno.DadosRet.IDBoleto.CodBarras      := '';
              Retorno.DadosRet.IDBoleto.LinhaDig       := '';
              Retorno.DadosRet.IDBoleto.NossoNum       := AJSonObject.Values['numeroBoletoBB'].AsString;

              Retorno.DadosRet.TituloRet.CodBarras      := Retorno.DadosRet.IDBoleto.CodBarras;
              Retorno.DadosRet.TituloRet.LinhaDig       := Retorno.DadosRet.IDBoleto.LinhaDig;


              Retorno.DadosRet.TituloRet.NossoNumero                := Retorno.DadosRet.IDBoleto.NossoNum;
              Retorno.DadosRet.TituloRet.DataRegistro               := DateBBtoDateTime(AJSonObject.Values['dataRegistro'].AsString);
              Retorno.DadosRet.TituloRet.Vencimento                 := DateBBtoDateTime(AJSonObject.Values['dataVencimento'].AsString);
              Retorno.DadosRet.TituloRet.ValorDocumento             := AJSonObject.Values['valorOriginal'].AsNumber;
              Retorno.DadosRet.TituloRet.Carteira                   := OnlyNumber(AJSonObject.Values['carteiraConvenio'].AsString);
              Retorno.DadosRet.TituloRet.Modalidade                 := AJSonObject.Values['variacaoCarteiraConvenio'].AsInteger;
              Retorno.DadosRet.TituloRet.codigoEstadoTituloCobranca := OnlyNumber(AJSonObject.Values['codigoEstadoTituloCobranca'].AsString);
              Retorno.DadosRet.TituloRet.estadoTituloCobranca       := AJSonObject.Values['estadoTituloCobranca'].AsString;
              Retorno.DadosRet.TituloRet.contrato                   := AJSonObject.Values['contrato'].AsString;
              Retorno.DadosRet.TituloRet.DataMovimento              := DateBBtoDateTime(AJSonObject.Values['dataMovimento'].AsString);
              Retorno.DadosRet.TituloRet.dataCredito                := DateBBtoDateTime(AJSonObject.Values['dataCredito'].AsString);
              Retorno.DadosRet.TituloRet.ValorAtual                 := AJSonObject.Values['valorAtual'].AsNumber;
              Retorno.DadosRet.TituloRet.ValorPago                  := AJSonObject.Values['valorPago'].AsNumber;



            end;
          end;
        end;

      finally
        AJson.free;
      end;


    except
      Result := False;
    end;

  end;

end;

function TRetornoEnvio_BancoBrasil_API.RetornoEnvio: Boolean;
begin

  Result:=inherited RetornoEnvio;

end;

end.

