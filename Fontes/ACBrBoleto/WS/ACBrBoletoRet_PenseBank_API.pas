{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:  Victor Hugo Gonzales - Panda                   }
{                               Leandro do Couto                               }
{                               Fernando Henrique                              }
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

unit ACBrBoletoRet_PenseBank_API;

interface

uses
  ACBrBoleto,
  ACBrBoletoWS,
  ACBrBoletoRetorno,
  ACBrBoletoWS.Rest;

type

{ TRetornoEnvio_PenseBank_API }

 TRetornoEnvio_PenseBank_API = class(TRetornoEnvioREST)
 private

 public
   constructor Create(ABoletoWS: TACBrBoleto); override;
   destructor  Destroy; Override;
   function LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean; override;
   function LerListaRetorno: Boolean; override;
   function RetornoEnvio(const AIndex: Integer): Boolean; override;

 end;

implementation

uses
  SysUtils,
  ACBrJSON,
  ACBrBoletoConversao;

resourcestring
  C_LIQUIDADO = 'LIQUIDADO';
  C_BAIXADO_POS_SOLICITACAO = 'BAIXADO POR SOLICITACAO';

{ TRetornoEnvio }

constructor TRetornoEnvio_PenseBank_API.Create(ABoletoWS: TACBrBoleto);
begin
  inherited Create(ABoletoWS);

end;

destructor TRetornoEnvio_PenseBank_API.Destroy;
begin
  inherited Destroy;
end;

function TRetornoEnvio_PenseBank_API.LerRetorno(const ARetornoWS: TACBrBoletoRetornoWS): Boolean;
var
  LJsonObject, LItemObject: TACBrJSONObject;
  LJsonArray: TACBrJSONArray;
  LMensagemRejeicao: TACBrBoletoRejeicao;
  LTipoOperacao : TOperacao;
  I: Integer;
begin
  Result := True;

  LTipoOperacao := ACBrBoleto.Configuracoes.WebService.Operacao;

  ARetornoWS.HTTPResultCode  := HTTPResultCode;
  ARetornoWS.JSONEnvio       := EnvWs;
  ARetornoWS.Header.Operacao := LTipoOperacao;

  if RetWS <> '' then
  begin
    try
      LJsonObject := TACBrJSONObject.Parse(RetWS);
      try

        ARetornoWS.JSON := LJsonObject.ToJSON;
        if HTTPResultCode >= 400 then
        begin
          LMensagemRejeicao            := ARetornoWS.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := IntToStr(HTTPResultCode);
          LMensagemRejeicao.Mensagem   := LJsonObject.AsString['message'];
        end;

        //retorna quando tiver sucesso
        if (ARetornoWS.ListaRejeicao.Count = 0) then
        begin
          if (LTipoOperacao = tpInclui) then
          begin

            ARetornoWS.DadosRet.IDBoleto.CodBarras      := LJsonObject.AsString['codigoBarraNumerico'];
            ARetornoWS.DadosRet.IDBoleto.LinhaDig       := LJsonObject.AsString['linhaDigitavel'];
            ARetornoWS.DadosRet.IDBoleto.NossoNum       := LJsonObject.AsString['numeroTituloCliente'];

            ARetornoWS.DadosRet.IDBoleto.IDBoleto       := IntToStr(LJsonObject.AsInteger['idboleto']);
            ARetornoWS.DadosRet.IDBoleto.LinhaDig       := LJsonObject.AsString['linhaDigitavel'];
            ARetornoWS.DadosRet.IDBoleto.NossoNum       := LJsonObject.AsString['numeroTituloCliente'];
            ARetornoWS.DadosRet.IDBoleto.URL            := LJsonObject.AsString['url_boleto'];
            ARetornoWS.DadosRet.IDBoleto.URLPDF         := LJsonObject.AsString['url_pdf'];

            ARetornoWS.DadosRet.TituloRet.TxId          := LJsonObject.AsString['pixHash'];
            ARetornoWS.DadosRet.TituloRet.EMV           := LJsonObject.AsString['pixQrCode'];

            ARetornoWS.DadosRet.TituloRet.CodBarras     := ARetornoWS.DadosRet.IDBoleto.CodBarras;
            ARetornoWS.DadosRet.TituloRet.LinhaDig      := ARetornoWS.DadosRet.IDBoleto.LinhaDig;
            ARetornoWS.DadosRet.TituloRet.NossoNumero   := ARetornoWS.DadosRet.IDBoleto.NossoNum;
            ARetornoWS.DadosRet.TituloRet.SeuNumero     := LJsonObject.AsString['idexterno'];

          end
          else
          begin
            if (LTipoOperacao = tpConsultaDetalhe) then
            begin

              ARetornoWS.DadosRet.IDBoleto.IDBoleto        := IntToStr(LJsonObject.AsInteger['idboleto']);
              ARetornoWS.DadosRet.IDBoleto.CodBarras       := '';
              ARetornoWS.DadosRet.IDBoleto.LinhaDig        := LJsonObject.AsString['codigoLinhaDigitavel'];
              ARetornoWS.DadosRet.IDBoleto.NossoNum        := '';
              ARetornoWS.indicadorContinuidade             := false;
              ARetornoWS.DadosRet.TituloRet.CodBarras      := ARetornoWS.DadosRet.IDBoleto.CodBarras;
              ARetornoWS.DadosRet.TituloRet.LinhaDig       := ARetornoWS.DadosRet.IDBoleto.LinhaDig;

              ARetornoWS.DadosRet.TituloRet.NossoNumero                := ARetornoWS.DadosRet.IDBoleto.NossoNum;
              ARetornoWS.DadosRet.TituloRet.Vencimento                 := StrToDate(LJsonObject.AsString['dataVencimentoTituloCobranca']);
              ARetornoWS.DadosRet.TituloRet.ValorDocumento             := LJsonObject.AsFloat['valorOriginalTituloCobranca'];
              ARetornoWS.DadosRet.TituloRet.ValorAtual                 := LJsonObject.AsFloat['valorOriginalTituloCobranca'];

              if( LJsonObject.AsString['situacaoEstadoTituloCobranca'] = C_LIQUIDADO ) or ( LJsonObject.AsString['situacaoEstadoTituloCobranca'] = C_BAIXADO_POS_SOLICITACAO ) then
                ARetornoWS.DadosRet.TituloRet.ValorPago                := LJsonObject.AsFloat['valor'];

            end;
          end;
        end;
      except
        Result := False;
      end;
    finally
      LJsonObject.free;
    end;
  end;

end;

function TRetornoEnvio_PenseBank_API.LerListaRetorno: Boolean;
var
  LListaRetorno: TACBrBoletoRetornoWS;
  LJsonObject, LItemObject: TACBrJSONObject;
  LJsonArray: TACBrJSONArray;
  LMensagemRejeicao: TACBrBoletoRejeicao;
  I: Integer;
begin
  Result := True;

  LListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;
  LListaRetorno.HTTPResultCode := HTTPResultCode;
  LListaRetorno.JSONEnvio      := EnvWs;

  if RetWS <> '' then
  begin
    LListaRetorno.JSON := RetWS;
    try
      LJsonObject := TACBrJSONObject.Parse(RetWS);
      try
        if HTTPResultCode >= 400 then
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := IntToStr(HTTPResultCode);
          LMensagemRejeicao.Mensagem   := LJsonObject.AsString['message'];
        end;

        //retorna quando tiver sucesso
        if (LListaRetorno.ListaRejeicao.Count = 0) then
        begin
          LJsonArray := LJsonObject.AsJSONArray['boletos'];

          for I := 0 to Pred(LJsonArray.Count) do
          begin
            if I > 0 then
              LListaRetorno := ACBrBoleto.CriarRetornoWebNaLista;

            LItemObject  := LJsonArray.ItemAsJSONObject[I];

            LListaRetorno.DadosRet.IDBoleto.IDBoleto        := IntToStr(LItemObject.AsInteger['idboleto']);
            LListaRetorno.DadosRet.IDBoleto.CodBarras       := '';
            LListaRetorno.DadosRet.IDBoleto.LinhaDig        := LItemObject.AsString['codigoLinhaDigitavel'];
            LListaRetorno.DadosRet.IDBoleto.NossoNum        := '';
            LListaRetorno.indicadorContinuidade             := false;
            LListaRetorno.DadosRet.TituloRet.CodBarras      := LListaRetorno.DadosRet.IDBoleto.CodBarras;
            LListaRetorno.DadosRet.TituloRet.LinhaDig       := LListaRetorno.DadosRet.IDBoleto.LinhaDig;
            LListaRetorno.DadosRet.TituloRet.NossoNumero                := LListaRetorno.DadosRet.IDBoleto.NossoNum;
            LListaRetorno.DadosRet.TituloRet.Vencimento                 := StrToDate(LItemObject.AsString['dataVencimentoTituloCobranca']);
            LListaRetorno.DadosRet.TituloRet.ValorDocumento             := LItemObject.AsFloat['valorOriginalTituloCobranca'];
            LListaRetorno.DadosRet.TituloRet.ValorAtual                 := LItemObject.AsFloat['valorOriginalTituloCobranca'];
            if( LItemObject.AsString['situacaoEstadoTituloCobranca'] = C_LIQUIDADO ) or
               ( LItemObject.AsString['situacaoEstadoTituloCobranca'] = C_BAIXADO_POS_SOLICITACAO ) then
              LListaRetorno.DadosRet.TituloRet.ValorPago                  := LItemObject.AsFloat['valor'];
          end;
        end;
      except
        Result := False;
      end;
    finally
      LJsonObject.free;
    end;
  end else
  begin
    case HTTPResultCode of
      404 :
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := '404';
          LMensagemRejeicao.Mensagem   := 'N�O ENCONTRADO. O servidor n�o conseguiu encontrar o recurso solicitado.';
        end;
      503 :
        begin
          LMensagemRejeicao            := LListaRetorno.CriarRejeicaoLista;
          LMensagemRejeicao.Codigo     := '503';
          LMensagemRejeicao.Versao     := 'ERRO INTERNO BB';
          LMensagemRejeicao.Mensagem   := 'SERVI�O INDISPON�VEL. O servidor est� impossibilitado de lidar com a requisi��o no momento. Tente mais tarde.';
          LMensagemRejeicao.Ocorrencia := 'ERRO INTERNO nos servidores do Banco.';
        end;
    end;
  end;
end;

function TRetornoEnvio_PenseBank_API.RetornoEnvio(const AIndex: Integer): Boolean;
begin
  Result:=inherited RetornoEnvio(AIndex);
end;

end.

