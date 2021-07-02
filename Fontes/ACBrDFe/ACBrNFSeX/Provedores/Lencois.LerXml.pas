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

unit Lencois.LerXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXConversao, ACBrNFSeXLerXml;

type
  { Provedor com layout pr�prio }
  { TNFSeR_Lencois }

  TNFSeR_Lencois = class(TNFSeRClass)
  protected

    procedure LerPASNF(const ANode: TACBrXmlNode);
    procedure LerTomador(const ANode: TACBrXmlNode);
    procedure LerEnderecoTomador(const ANode: TACBrXmlNode);
    procedure LerRecolhimentoFora(const ANode: TACBrXmlNode);
  public
    function LerXml: Boolean; override;
    function LerXmlRps(const ANode: TACBrXmlNode): Boolean;
    function LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
  end;

implementation

//==============================================================================
// Essa unit tem por finalidade exclusiva ler o XML do provedor:
//     Lencois
//==============================================================================

{ TNFSeR_Lencois }

procedure TNFSeR_Lencois.LerEnderecoTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Endereco');

  if AuxNode <> nil then
  begin
    with NFSe.Tomador.Endereco do
    begin
      Endereco := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Logradouro'), tcStr);
      Numero := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      Complemento := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Complemento'), tcStr);
      Bairro := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Bairro'), tcStr);
      CodigoMunicipio := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Municipio'), tcStr);
    end;
  end;
end;

procedure TNFSeR_Lencois.LerPASNF(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('PASNF');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      Numero := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Numero'), tcStr);
      DataEmissao := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Data'), tcDat);
    end;
  end;
end;

procedure TNFSeR_Lencois.LerRecolhimentoFora(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
  aValor: string;
begin
  AuxNode := ANode.Childrens.FindAnyNs('RecolhimentoFora');

  if AuxNode <> nil then
  begin
    with NFSe.Servico do
    begin
      aValor := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Obrigacao'), tcStr);

      if aValor = '1' then
        ResponsavelRetencao := ptTomador
      else
        ResponsavelRetencao := rtPrestador;

      Valores.Aliquota := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Aliquota'), tcDe6);
    end;
  end;
end;

procedure TNFSeR_Lencois.LerTomador(const ANode: TACBrXmlNode);
var
  AuxNode: TACBrXmlNode;
begin
  AuxNode := ANode.Childrens.FindAnyNs('Tomador');

  if AuxNode <> nil then
  begin
    with NFSe do
    begin
      with Tomador do
      begin
        with IdentificacaoTomador do
        begin
          CpfCnpj := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('CPF_CNPJ'), tcStr);
        end;

        RazaoSocial := ProcessarConteudo(AuxNode.Childrens.FindAnyNs('Nome'), tcStr);

        LerEnderecoTomador(AuxNode);

        with Contato do
        begin
          Email := ProcessarConteudo(ANode.Childrens.FindAnyNs('Email'), tcStr);
        end;
      end;
    end;
  end;
end;

function TNFSeR_Lencois.LerXml: Boolean;
var
  XmlNode: TACBrXmlNode;
  xRetorno: string;
begin
  xRetorno := TratarXmlRetorno(Arquivo);

  if EstaVazio(xRetorno) then
    raise Exception.Create('Arquivo xml n�o carregado.');

  if FDocument = nil then
    FDocument := TACBrXmlDocument.Create();

  Document.Clear();
  Document.LoadFromXml(xRetorno);

  if (Pos('Nota', xRetorno) > 0) then
    tpXML := txmlNFSe
  else
    tpXML := txmlRPS;

  XmlNode := Document.Root;

  if XmlNode = nil then
    raise Exception.Create('Arquivo xml vazio.');

  if tpXML = txmlNFSe then
    Result := LerXmlNfse(XmlNode)
  else
    Result := LerXmlRps(XmlNode);
end;

function TNFSeR_Lencois.LerXmlNfse(const ANode: TACBrXmlNode): Boolean;
//var
//  AuxNode: TACBrXmlNode;
begin
  Result := False;

  // Falta Implementar (N�o tem schema para tomar como base)

  (*
  AuxNode := ANode.Childrens.FindAnyNs('NFe');

  if AuxNode = nil then
    AuxNode := ANode.Childrens.FindAnyNs('CompNfse');

  if AuxNode = nil then Exit;

  *)
end;

function TNFSeR_Lencois.LerXmlRps(const ANode: TACBrXmlNode): Boolean;
begin
  Result := True;

  with NFSe do
  begin
    with Prestador do
    begin
      with IdentificacaoPrestador do
      begin
        InscricaoMunicipal := ProcessarConteudo(ANode.Childrens.FindAnyNs('InscricaoMunicipal'), tcStr);
      end;
    end;

    LerPASNF(ANode);
    LerTomador(ANode);

    with Servico do
    begin
      CodigoMunicipio := ProcessarConteudo(ANode.Childrens.FindAnyNs('CidadeExecucao'), tcStr);
      Descricao := ProcessarConteudo(ANode.Childrens.FindAnyNs('Descricao'), tcStr);

      with Valores do
      begin
        ValorServicos := ProcessarConteudo(ANode.Childrens.FindAnyNs('ValorTotal'), tcDe2);
        ValorDeducoes := ProcessarConteudo(ANode.Childrens.FindAnyNs('ValorDeducao'), tcDe2);
        Aliquota := ProcessarConteudo(ANode.Childrens.FindAnyNs('Aliquota'), tcDe6);
        ValorPis := ProcessarConteudo(ANode.Childrens.FindAnyNs('ValorPIS'), tcDe2);
        ValorCofins := ProcessarConteudo(ANode.Childrens.FindAnyNs('ValorCOFINS'), tcDe2);
        ValorIr := ProcessarConteudo(ANode.Childrens.FindAnyNs('RetencaoIRRF'), tcDe2);
        ValorInss := ProcessarConteudo(ANode.Childrens.FindAnyNs('RetencaoINSS'), tcDe2);
        ValorPis := ProcessarConteudo(ANode.Childrens.FindAnyNs('RetencaoPIS'), tcDe2);
        ValorCofins := ProcessarConteudo(ANode.Childrens.FindAnyNs('RetencaoCOFINS'), tcDe2);
        ValorCsll := ProcessarConteudo(ANode.Childrens.FindAnyNs('RetencaoCSLL'), tcDe2);
      end;
    end;

    LerRecolhimentoFora(ANode);
  end;
end;

end.
