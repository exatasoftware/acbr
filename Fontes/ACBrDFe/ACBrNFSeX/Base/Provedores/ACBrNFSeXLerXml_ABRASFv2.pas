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

unit ACBrNFSeXLerXml_ABRASFv2;

interface

uses
  SysUtils, Classes, StrUtils,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXLerXml;

type
  { TNFSeR_ABRASFv2 }

  TNFSeR_ABRASFv2 = class(TNFSeRClass)
  private

  protected
    function LerDataHora(const ANode: TACBrXmlNode): TDateTime; virtual;
    function LerDataEmissao(const ANode: TACBrXmlNode): TDateTime; virtual;
    function LerDataEmissaoRps(const ANode: TACBrXmlNode): TDateTime; virtual;
    function LerCompetencia(const ANode: TACBrXmlNode): TDateTime; virtual;

    procedure LerInfNfse(const ANode: TACBrXmlNode);

    procedure LerValoresNfse(const ANode: TACBrXmlNode);

    procedure LerPrestadorServico(const ANode: TACBrXmlNode);
    procedure LerEnderecoPrestadorServico(const ANode: TACBrXmlNode; aTag: string);
    procedure LerContatoPrestadorServico(const ANode: TACBrXmlNode);
    procedure LerContatoPrestador(const ANode: TACBrXmlNode);

    procedure LerOrgaoGerador(const ANode: TACBrXmlNode);
    procedure LerDeclaracaoPrestacaoServico(const ANode: TACBrXmlNode);
    procedure LerInfDeclaracaoPrestacaoServico(const ANode: TACBrXmlNode);

    procedure LerRps(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoRps(const ANode: TACBrXmlNode);
    procedure LerRpsSubstituido(const ANode: TACBrXmlNode);

    procedure LerServico(const ANode: TACBrXmlNode);
    procedure LerValores(const ANode: TACBrXmlNode);

    procedure LerPrestador(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoPrestador(const ANode: TACBrXmlNode);

    procedure LerTomadorServico(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerContatoTomador(const ANode: TACBrXmlNode);

    procedure LerIntermediarioServico(const ANode: TACBrXmlNode);

    procedure LerConstrucaoCivil(const ANode: TACBrXmlNode);

    procedure LerNfseCancelamento(const ANode: TACBrXmlNode);
    procedure LerConfirmacao(const ANode: TACBrXmlNode);
    procedure LerPedido(const ANode: TACBrXmlNode);
    procedure LerInfConfirmacaoCancelamento(const ANode: TACBrXmlNode);
    procedure LerInfPedidoCancelamento(const ANode: TACBrXmlNode);
    procedure LerIdentificacaoNfse(const ANode: TACBrXmlNode);

    procedure LerNfseSubstituicao(const ANode: TACBrXmlNode);
    procedure LerSubstituicaoNfse(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

uses
  ACBrUtil.Base,
  ACBrUtil.Strings,
  ACBrConsts,
  ACBrNFSeXConversao;

//==============================================================================
// Essa unit tem por finalidade exclusiva de ler o XML da NFS-e e RPS dos provedores:
//     que seguem a vers�o 2.xx do layout da ABRASF
//==============================================================================

{ TNFSeR_ABRASFv2 }

function TNFSeR_ABRASFv2.LerCompetencia(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('Competencia'), tcDat);
end;

function TNFSeR_ABRASFv2.LerDataEmissao(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcDatHor);
end;

function TNFSeR_ABRASFv2.LerDataEmissaoRps(
  const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataEmissao'), tcDatHor);
end;

function TNFSeR_ABRASFv2.LerDataHora(const ANode: TACBrXmlNode): TDateTime;
begin
  Result := ObterConteudo(ANode.Childrens.FindAnyNs('DataHora'), tcDatHor);
end;

procedure TNFSeR_ABRASFv2.LerConfirmacao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Confirmacao');

  if AuxNode <> nil then
  begin
    LerPedido(AuxNode);
    LerInfConfirmacaoCancelamento(AuxNode);

    with NFSe.NfseCancelamento do
    begin
      DataHora := LerDataHora(AuxNode);

      if DataHora > 0 then
        NFSe.SituacaoNfse := snCancelado;
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerConstrucaoCivil(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ConstrucaoCivil');

  if AuxNode <> nil then
  begin
    with NFSe.ConstrucaoCivil do
    begin
      CodigoObra := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoObra'), tcStr);
      Art        := ObterConteudo(AuxNode.Childrens.FindAnyNs('Art'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerContatoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Contato');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Contato do
    begin
      Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('Telefone'), tcStr);
      Email    := ObterConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerContatoPrestadorServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ContatoPrestadorServico');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Contato do
    begin
      Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('Telefone'), tcStr);
      Email := ObterConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerContatoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Contato');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Contato do
    begin
      Telefone := ObterConteudo(AuxNode.Childrens.FindAnyNs('Telefone'), tcStr);
      Email    := ObterConteudo(AuxNode.Childrens.FindAnyNs('Email'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerDeclaracaoPrestacaoServico(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('DeclaracaoPrestacaoServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('Rps');

  if AuxNode <> nil then
    LerInfDeclaracaoPrestacaoServico(AuxNode);
end;

procedure TNFSeR_ABRASFv2.LerEnderecoPrestadorServico(const ANode: TACBrXmlNode;
  aTag: string);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs(aTag);

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.Endereco do
    begin
      Endereco        := ObterConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento     := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      UF              := ObterConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CodigoPais      := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      CEP             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Endereco');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco        := ObterConteudo(AuxNode.Childrens.FindAnyNs('Endereco'), tcStr);
      Numero          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento     := ObterConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro          := ObterConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      UF              := ObterConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
      CEP             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cep'), tcStr);
      xMunicipio      := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoNfse');

  if AuxNode <> nil then
  begin
    with NFSe.NfseCancelamento.Pedido.IdentificacaoNfse do
    begin
      Numero             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Cnpj               := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);
      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
      CodigoMunicipio    := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoPrestador(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoPrestador');

  if AuxNode <> nil then
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      CpfCnpj := ObterConteudo(AuxNode.Childrens.FindAnyNs('Cnpj'), tcStr);

      if CpfCnpj = '' then
      begin
        AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

        if AuxNodeCpfCnpj <> nil then
        begin
          CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

          if CpfCnpj = '' then
            CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
        end;
      end;

      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end
  else
  begin
    with NFSe.Prestador.IdentificacaoPrestador do
    begin
      CpfCnpj := ObterConteudo(ANode.Childrens.FindAnyNs('Cnpj'), tcStr);

      if CpfCnpj = '' then
      begin
        AuxNodeCpfCnpj := ANode.Childrens.FindAnyNs('CpfCnpj');

        if AuxNodeCpfCnpj <> nil then
        begin
          CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

          if CpfCnpj = '' then
            CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
        end;
      end;

      InscricaoMunicipal := ObterConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;

    if NFSe.Prestador.RazaoSocial = '' then
    begin
      NFSe.Prestador.RazaoSocial := ObterConteudo(ANode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
      NFSe.Prestador.RazaoSocial := StringReplace(NFSe.Prestador.RazaoSocial, '&amp;', '&', [rfReplaceAll]);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoRps');

  if AuxNode <> nil then
  begin
    with NFSe.IdentificacaoRps do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Serie  := ObterConteudo(AuxNode.Childrens.FindAnyNs('Serie'), tcStr);
      Tipo   := StrToTipoRPS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('Tipo'), tcStr));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerIdentificacaoTomador(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('IdentificacaoTomador');

  if AuxNode <> nil then
  begin
    AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

    with NFSe.Tomador.IdentificacaoTomador do
    begin
      if AuxNodeCpfCnpj <> nil then
      begin
        CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

        if CpfCnpj = '' then
          CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
      end;

      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;

    if NFSe.Tomador.RazaoSocial = '' then
    begin
      NFSe.Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
      NFSe.Tomador.RazaoSocial := StringReplace(NFSe.Tomador.RazaoSocial, '&amp;', '&', [rfReplaceAll]);
    end;

    LerEnderecoTomador(AuxNode);
    LerContatoTomador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfConfirmacaoCancelamento(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfConfirmacaoCancelamento');

  NFSe.SituacaoNfse := snNormal;

  if AuxNode <> nil then
  begin
    with NFSe.NfseCancelamento do
    begin
      Sucesso  := ObterConteudo(AuxNode.Childrens.FindAnyNs('Sucesso'), tcBool);
      DataHora := LerDataHora(AuxNode);
    end;

    if NFSe.NfseCancelamento.DataHora > 0 then
      NFSe.SituacaoNfse := snCancelado;
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfDeclaracaoPrestacaoServico(
  const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfDeclaracaoPrestacaoServico');

  if AuxNode = nil then
    AuxNode := ANode;

  if AuxNode <> nil then
  begin
    LerRps(AuxNode);

    NFSe.Competencia := LerCompetencia(AuxNode);

    LerServico(AuxNode);
    LerPrestador(AuxNode);
    LerTomadorServico(AuxNode);
    LerIntermediarioServico(AuxNode);
    LerConstrucaoCivil(AuxNode);

    NFSe.RegimeEspecialTributacao := FpAOwner.StrToRegimeEspecialTributacao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RegimeEspecialTributacao'), tcStr));
    NFSe.OptanteSimplesNacional   := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('OptanteSimplesNacional'), tcStr));
    NFSe.IncentivadorCultural     := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('IncentivoFiscal'), tcStr));

    if NFSe.InformacoesComplementares = '' then
    begin
      NFSe.InformacoesComplementares := ObterConteudo(AuxNode.Childrens.FindAnyNs('InformacoesComplementares'), tcStr);
      NFSe.InformacoesComplementares := StringReplace(NFSe.InformacoesComplementares, '&lt;br&gt;', ';', [rfReplaceAll]);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerInfNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfNfse');

  if AuxNode <> nil then
  begin
    NFSe.Numero            := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
    NFSe.CodigoVerificacao := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoVerificacao'), tcStr);
    NFSe.DataEmissao       := LerDataEmissao(AuxNode);
    NFSe.NfseSubstituida   := ObterConteudo(AuxNode.Childrens.FindAnyNs('NfseSubstituida'), tcStr);

    NFSe.OutrasInformacoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('OutrasInformacoes'), tcStr);
    NFSe.InformacoesComplementares := ObterConteudo(AuxNode.Childrens.FindAnyNs('InformacoesComplementares'), tcStr);
    NFSe.Link := ObterConteudo(AuxNode.Childrens.FindAnyNs('UrlNfse'), tcStr);

    if NFSe.Link = '' then
      NFSe.Link := ObterConteudo(AuxNode.Childrens.FindAnyNs('LinkNota'), tcStr);

    NFSe.Link := StringReplace(NFSe.Link, '&amp;', '&', [rfReplaceAll]);

    LerValoresNfse(AuxNode);

    NFSe.ValorCredito := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorCredito'), tcDe2);

    LerServico(AuxNode);

    LerTomadorServico(AuxNode);
    LerPrestadorServico(AuxNode);
    LerEnderecoPrestadorServico(AuxNode, 'EnderecoPrestadorServico');
    LerOrgaoGerador(AuxNode);
    LerDeclaracaoPrestacaoServico(AuxNode);

    NFSe.ChaveAcesso := ObterConteudo(AuxNode.Childrens.FindAnyNs('ChaveAcesso'), tcStr);

    if NFSe.IdentificacaoRps.Numero = '' then
      NFSe.IdentificacaoRps.Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroRps'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerNfseCancelamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NfseCancelamento');

  LerConfirmacao(AuxNode);
end;

procedure TNFSeR_ABRASFv2.LerNfseSubstituicao(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('NfseSubstituicao');

  LerSubstituicaoNfse(AuxNode);
end;

procedure TNFSeR_ABRASFv2.LerInfPedidoCancelamento(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('InfPedidoCancelamento');

  if AuxNode <> nil then
  begin
    LerIdentificacaoNfse(AuxNode);

    with NFSe.NfseCancelamento.Pedido do
      CodigoCancelamento := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoCancelamento'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerIntermediarioServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNodeCpfCnpj: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Intermediario');

  if AuxNode <> nil then
  begin
    NFSe.IntermediarioServico.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);

    AuxNodeCpfCnpj := AuxNode.Childrens.FindAnyNs('CpfCnpj');

    with NFSe.IntermediarioServico do
    begin
      if AuxNodeCpfCnpj <> nil then
      begin
        CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cpf'), tcStr);

        if CpfCnpj = '' then
          CpfCnpj := ObterConteudo(AuxNodeCpfCnpj.Childrens.FindAnyNs('Cnpj'), tcStr);
      end;

      InscricaoMunicipal := ObterConteudo(AuxNode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerOrgaoGerador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('OrgaoGerador');

  if AuxNode <> nil then
  begin
    with NFSe.OrgaoGerador do
    begin
      CodigoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);
      Uf              := ObterConteudo(AuxNode.Childrens.FindAnyNs('Uf'), tcStr);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerPedido(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Pedido');

  if AuxNode <> nil then
  begin
    LerInfPedidoCancelamento(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerPrestador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Prestador');

  if AuxNode <> nil then
  begin
    LerIdentificacaoPrestador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerPrestadorServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('PrestadorServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('Prestador');


  if AuxNode <> nil then
  begin
    LerIdentificacaoPrestador(AuxNode);

    with NFSe.Prestador do
    begin
      RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
      RazaoSocial := StringReplace(RazaoSocial, '&amp;', '&', [rfReplaceAll]);
      NomeFantasia := ObterConteudo(AuxNode.Childrens.FindAnyNs('NomeFantasia'), tcStr);
    end;

    LerEnderecoPrestadorServico(AuxNode, 'Endereco');
    LerContatoPrestador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerRps(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Rps');

  if AuxNode = nil then
    AuxNode := ANode;

  if AuxNode <> nil then
  begin
    LerIdentificacaoRps(AuxNode);

    NFSe.DataEmissaoRps := LerDataEmissaoRps(AuxNode);

    NFSe.StatusRps := StrToStatusRPS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('Status'), tcStr));

    LerRpsSubstituido(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerRpsSubstituido(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('RpsSubstituido');

  if AuxNode <> nil then
  begin
    with NFSe.RpsSubstituido do
    begin
      Numero := ObterConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Serie  := ObterConteudo(AuxNode.Childrens.FindAnyNs('Serie'), tcStr);
      Tipo   := StrToTipoRPS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('Tipo'), tcStr));
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerServico(const ANode: TACBrXmlNode);
var
  AuxNode, AuxNode2: TACBrXmlNode;
  Ok: Boolean;
  CodigoItemServico, Responsavel: string;
  ValorLiq: Double;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Servico');

  if AuxNode <> nil then
  begin
    AuxNode2 := AuxNode.Childrens.FindAnyNs('tcDadosServico');

    if AuxNode2 <> nil then
      AuxNode := AuxNode2;

    LerValores(AuxNode);

    CodigoItemServico := ObterConteudo(AuxNode.Childrens.FindAnyNs('ItemListaServico'), tcStr);

    // Provedor MegaSoft
    if CodigoItemServico = '' then
      CodigoItemServico := OnlyNumber(ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoTributacaoMunicipio'), tcStr));

    with NFSe.Servico do
    begin
      Responsavel := ObterConteudo(AuxNode.Childrens.FindAnyNs('ResponsavelRetencao'), tcStr);

      if Responsavel = '' then
        ResponsavelRetencao := rtNenhum
      else
        ResponsavelRetencao := FpAOwner.StrToResponsavelRetencao(Ok, Responsavel);

      ItemListaServico          := NormatizarItemListaServico(CodigoItemServico);
      xItemListaServico         := ItemListaServicoDescricao(ItemListaServico);
      CodigoCnae                := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoCnae'), tcStr);
      CodigoTributacaoMunicipio := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoTributacaoMunicipio'), tcStr);
      Discriminacao             := ObterConteudo(AuxNode.Childrens.FindAnyNs('Discriminacao'), tcStr);
      CodigoMunicipio           := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoMunicipio'), tcStr);

      CodigoPais          := ObterConteudo(AuxNode.Childrens.FindAnyNs('CodigoPais'), tcInt);
      ExigibilidadeISS    := StrToExigibilidadeISS(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('ExigibilidadeISS'), tcStr));
      MunicipioIncidencia := ObterConteudo(AuxNode.Childrens.FindAnyNs('MunicipioIncidencia'), tcInt);
      NumeroProcesso      := ObterConteudo(AuxNode.Childrens.FindAnyNs('NumeroProcesso'), tcStr);

      with Valores do
      begin
        IssRetido := FpAOwner.StrToSituacaoTributaria(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('IssRetido'), tcStr));

        if IssRetido = stRetencao then
          ValorIssRetido := ValorIss
        else
          ValorIssRetido := 0;

        ValorLiq := ValorServicos - ValorPis - ValorCofins - ValorInss -
                    ValorIr - ValorCsll - OutrasRetencoes - ValorIssRetido -
                    DescontoIncondicionado - DescontoCondicionado;

        if (ValorLiquidoNfse = 0) or (ValorLiquidoNfse <> ValorLiq) then
          ValorLiquidoNfse := ValorLiq;
      end;
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerSubstituicaoNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('SubstituicaoNfse');

  if AuxNode <> nil then
  begin
    NFSe.NfseSubstituidora := ObterConteudo(AuxNode.Childrens.FindAnyNs('NfseSubstituidora'), tcStr);
  end;
end;

procedure TNFSeR_ABRASFv2.LerTomadorServico(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('TomadorServico');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('Tomador');

  if AuxNode <> nil then
  begin
    NFSe.Tomador.RazaoSocial := ObterConteudo(AuxNode.Childrens.FindAnyNs('RazaoSocial'), tcStr);
    NFSe.Tomador.RazaoSocial := StringReplace(NFSe.Tomador.RazaoSocial, '&amp;', '&', [rfReplaceAll]);

    LerIdentificacaoTomador(AuxNode);

    LerEnderecoTomador(AuxNode);
    LerContatoTomador(AuxNode);
  end;
end;

procedure TNFSeR_ABRASFv2.LerValores(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  Ok: Boolean;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Valores');

  if AuxNode <> nil then
  begin
    with NFSe.Servico.Valores do
    begin
      ValorServicos   := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorServicos'), tcDe2);
      ValorDeducoes   := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorDeducoes'), tcDe2);

      AliquotaPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaPis'), tcDe2);
      RetidoPis := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RetidoPis'), tcStr));
      ValorPis := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorPis'), tcDe2);

      AliquotaCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaCofins'), tcDe2);
      RetidoCofins := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RetidoCofins'), tcStr));
      ValorCofins := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorCofins'), tcDe2);

      AliquotaInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaInss'), tcDe2);
      RetidoInss := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RetidoInss'), tcStr));
      ValorInss := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorInss'), tcDe2);

      AliquotaIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaIr'), tcDe2);
      RetidoIr := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RetidoIr'), tcStr));
      ValorIr := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorIr'), tcDe2);

      AliquotaCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('AliquotaCsll'), tcDe2);
      RetidoCsll := FpAOwner.StrToSimNao(Ok, ObterConteudo(AuxNode.Childrens.FindAnyNs('RetidoCsll'), tcStr));
      ValorCsll := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorCsll'), tcDe2);

      ValorIss        := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorIss'), tcDe2);
      OutrasRetencoes := ObterConteudo(AuxNode.Childrens.FindAnyNs('OutrasRetencoes'), tcDe2);

      if NFSe.ValoresNfse.BaseCalculo = 0 then
      begin
        BaseCalculo := ObterConteudo(AuxNode.Childrens.FindAnyNs('BaseCalculo'), tcDe2);
        NFSe.ValoresNfse.BaseCalculo := BaseCalculo;
      end;

      if NFSe.ValoresNfse.ValorIss = 0 then
      begin
        ValorIss := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorIss'), tcDe2);
        NFSe.ValoresNfse.ValorIss := ValorIss;
      end;

      Aliquota := ObterConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe4);

      if NFSe.ValoresNfse.ValorLiquidoNfse = 0 then
      begin
        ValorLiquidoNfse := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorLiquidoNfse'), tcDe2);
        NFSe.ValoresNfse.ValorLiquidoNfse := ValorLiquidoNfse;
      end;

      DescontoCondicionado   := ObterConteudo(AuxNode.Childrens.FindAnyNs('DescontoCondicionado'), tcDe2);
      DescontoIncondicionado := ObterConteudo(AuxNode.Childrens.FindAnyNs('DescontoIncondicionado'), tcDe2);
    end;
  end;
end;

procedure TNFSeR_ABRASFv2.LerValoresNfse(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('ValoresNfse');

  if AuxNode <> nil then
  begin
    with NFSe.ValoresNfse do
    begin
      BaseCalculo      := ObterConteudo(AuxNode.Childrens.FindAnyNs('BaseCalculo'), tcDe2);
      Aliquota         := ObterConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe4);
      ValorIss         := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorIss'), tcDe2);
      ValorLiquidoNfse := ObterConteudo(AuxNode.Childrens.FindAnyNs('ValorLiquidoNfse'), tcDe2);
    end;

    with NFSe.Servico.Valores do
    begin
      BaseCalculo := NFSe.ValoresNfse.BaseCalculo;
      ValorLiquidoNfse := NFSe.ValoresNfse.ValorLiquidoNfse;
    end;
  end;
end;

function TNFSeR_ABRASFv2.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
begin
  if EstaVazio(Arquivo) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  Arquivo := NormatizarXml(Arquivo);

  tpXML := TipodeXMLLeitura(Arquivo);

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(Arquivo);

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  NFSe.Clear;

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);

  FreeAndNil(FDocument);
end;

function TNFSeR_ABRASFv2.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
var
  AuxNode: TACBrXmlNode;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  AuxNode := ANode.Childrens.FindAnyNs('Nfse');

  if AuxNode = nil then
    AuxNode := ANode;

  LerInfNfse(AuxNode);

  LerNfseCancelamento(ANode);
  LerNfseSubstituicao(ANode);
end;

function TNFSeR_ABRASFv2.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  if not Assigned(ANode) or (ANode = nil) then Exit;

  LerInfDeclaracaoPrestacaoServico(ANode);
end;

end.
