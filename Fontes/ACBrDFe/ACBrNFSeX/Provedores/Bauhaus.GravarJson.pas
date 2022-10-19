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

unit Bauhaus.GravarJson;

interface

uses
  SysUtils, Classes, Variants, StrUtils,
  ACBrXmlBase, ACBrXmlDocument, ACBrJSON,
  ACBrNFSeXParametros, ACBrNFSeXGravarXml,
  ACBrNFSeXConversao, ACBrNFSeXConsts;

type
  { TNFSeW_Bauhaus }

  TNFSeW_Bauhaus = class(TNFSeWClass)

  protected
    procedure Configuracao; override;

    function GerarDadosNota: String;
    function GerarAtividade: String;
    function GerarPrestador: String;
    function GerarTomador: String;
    function GerarEndereco: String;
    function GerarContato: String;
    function GerarRps: String;
    function GerarServicos: String;
    function GerarValores: String;
  public
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrNFSeX,
  ACBrUtil.Base, ACBrUtil.Strings,
  ACBrConsts;

//==============================================================================
// Essa unit tem por finalidade exclusiva gerar o Json do RPS do provedor:
//     Bauhaus
//==============================================================================

{ TNFSeW_Bauhaus }

procedure TNFSeW_Bauhaus.Configuracao;
begin
  inherited Configuracao;

end;

function TNFSeW_Bauhaus.GerarXml: Boolean;
begin
  Configuracao;

  Opcoes.QuebraLinha := FpAOwner.ConfigGeral.QuebradeLinha;

  ListaDeAlertas.Clear;

  FDocument.Clear();

  FConteudoTxt.Clear;

  {$IFDEF FPC}
  FConteudoTxt.LineBreak := CRLF;
  {$ELSE}
    {$IFDEF DELPHI2006_UP}
    FConteudoTxt.LineBreak := CRLF;
    {$ENDIF}
  {$ENDIF}

  FConteudoTxt.Text := '{"DadosNota" : ' + GerarDadosNota + '}';

  Result := True;
end;

function TNFSeW_Bauhaus.GerarDadosNota: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe do
      AJSon
        .AddPair('MunicipioPrestacao', StrToInt(Prestador.Endereco.CodigoMunicipio))
        .AddPair('NaturezaOperacao', StrToInt(NaturezaOperacaoToStr(NaturezaOperacao)))
        .AddPair('IssRetido', IfThen((Servico.Valores.IssRetido = stRetencao), 'S' , 'N'))
        .AddPair('Observacoes', OutrasInformacoes);

    Result := StringReplace(AJSon.ToJSON, '}', '', [rfReplaceAll]) + ','
                          + ' "Atividade": ' + GerarAtividade + ','
                          + ' "Prestador": ' + GerarPrestador + ','
                          + ' "Tomador": ' + GerarTomador + ','
                          + ' "Rps": ' + GerarRps + ','
                          + ' "Servicos": ' + '[' + GerarServicos + ']' + ','
                          + ' "Valores": ' + GerarValores + '}';

  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarAtividade: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Servico do
      AJSon
        .AddPair('Codigo', StrToInt(IfThen((CodigoTributacaoMunicipio=''), '0' , CodigoTributacaoMunicipio)))
        .AddPair('CodigoCnae', CodigoCnae);
//        .AddPair('CodigoLc116', StrToInt(ItemServico[0].ItemListaServico));

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarPrestador: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Prestador.IdentificacaoPrestador do
      AJSon
        .AddPair('InscricaoMunicipal', OnlyNumber(InscricaoMunicipal));

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarTomador: String;
var
  AJSon: TACBrJSONObject;
  TipoPessoa: String;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Tomador do
    begin
      case IdentificacaoTomador.Tipo of
        tpPF: TipoPessoa := 'F';
        tpPJforaPais: TipoPessoa := 'E';
      else
        TipoPessoa := 'J';
      end;

      AJSon
        .AddPair('TipoPessoa', TipoPessoa)
        .AddPair('NrDocumento', IdentificacaoTomador.CpfCnpj)
        .AddPair('RazaoSocial', RazaoSocial)
    end;

    Result := StringReplace(AJSon.ToJSON, '}', '', [rfReplaceAll]) + ','
                          + ' "Endereco": ' + GerarEndereco + ','
                          + ' "Contato": ' + GerarContato + '}';
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarEndereco: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Tomador.Endereco do
      AJSon
        .AddPair('Logradouro', Endereco)
        .AddPair('Numero', Numero)
        .AddPair('Complemento', Complemento)
        .AddPair('Bairro', Bairro)
        .AddPair('Municipio', StrToInt(CodigoMunicipio))
        .AddPair('Cep', StrToInt(CEP));

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarContato: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Tomador.Contato do
      AJSon
        .AddPair('Telefone', Telefone)
        .AddPair('Email', Email);

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarRps: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.IdentificacaoRps do
      AJSon
        .AddPair('Numero', StrToInt(Numero))
        .AddPair('Serie', StrToInt(Serie))
        .AddPair('Tipo', 1)
        .AddPairISODate('DataEmissao', NFSe.DataEmissaoRps);

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;


function TNFSeW_Bauhaus.GerarServicos: String;
var
  AJSon: TACBrJSONObject;
  i: Integer;
  xListaServico: String;
begin
  AJSon := TACBrJsonObject.Create;
  xListaServico := '';

  try
    with NFSe.Servico do
      for i := 0 to ItemServico.Count - 1 do
      begin
        AJSon
          .AddPair('Unidade', ItemServico[i].Unidade)
          .AddPair('Quantidade', ItemServico[i].Quantidade)
          .AddPair('Descricao', ItemServico[i].Descricao)
          .AddPair('ValorUnitario', ItemServico[i].ValorUnitario);

        xListaServico := xListaServico + AJSon.ToJSON;
      end;

    Result := StringReplace(xListaServico, '}{', '},{', [rfReplaceAll]);
  finally
    AJSon.Free;
  end;
end;

function TNFSeW_Bauhaus.GerarValores: String;
var
  AJSon: TACBrJSONObject;
begin
  AJSon := TACBrJsonObject.Create;

  try
    with NFSe.Servico.Valores do
      AJSon
        .AddPair('ValorServicos',  ValorServicos)
        .AddPair('ValorDeducoes', ValorDeducoes)
        .AddPair('ValorOutrasDeducoes', 0)
        .AddPair('ValorPis', ValorPis)
        .AddPair('ValorCofins', ValorCofins)
        .AddPair('ValorInss', ValorInss)
        .AddPair('ValorIr', ValorIr)
        .AddPair('ValorCsll', ValorCsll)
        .AddPair('OutrasRetencoes', OutrasRetencoes)
        .AddPair('DescontoIncondicionado', DescontoIncondicionado)
        .AddPair('DescontoCondicionado', DescontoCondicionado)
        .AddPair('BaseCalculo', BaseCalculo)
        .AddPair('Aliquota', Aliquota)
        .AddPair('ValorIss', ValorIss)
        .AddPair('ValorLiquidoNota', ValorLiquidoNfse)
        .AddPair('ValorTotalTributos', ValorTotalTributos)
        .AddPair('ValorCredito', NFSe.ValorCredito)
        .AddPair('ValorTotalNota', ValorLiquidoNfse);

    Result := AJSon.ToJSON;
  finally
    AJSon.Free;
  end;
end;

end.
