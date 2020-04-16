{******************************************************************************}
{ Projeto: Componente ACBrNFSe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

unit pnfsNFSeW_Siat;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  synacode, ACBrConsts,
  pnfsNFSeW,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao, pnfsConsts;

type
  { TNFSeW_Siat }

  TNFSeW_Siat = class(TNFSeWClass)
  private
    FSituacao: String;
    FTipoRecolhimento: String;
  protected

    procedure GerarIdentificacaoRPS;
    procedure GerarRPSSubstituido;

    procedure GerarPrestador;
    procedure GerarTomador;
    procedure GerarIntermediarioServico;

    procedure GerarListaServicos;
    procedure GerarValoresServico;

    procedure GerarXML_Siat;

  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;

    property Situacao: String         read FSituacao;
    property TipoRecolhimento: String read FTipoRecolhimento;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do Siat.                                                            }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_Siat }

procedure TNFSeW_Siat.GerarIdentificacaoRPS;
begin
  Gerador.wCampo(tcStr, '', 'TipoRPS', 01, 20, 1, 'RPS', '');

  if NFSe.IdentificacaoRps.Serie = ''
   then
    Gerador.wCampo(tcStr, '', 'SerieRPS', 01, 02, 1, 'NF', '')
  else
    Gerador.wCampo(tcStr, '', 'SerieRPS', 01, 02, 1, NFSe.IdentificacaoRps.Serie, '');

  Gerador.wCampo(tcStr,    '', 'NumeroRPS',      01, 12, 1, NFSe.IdentificacaoRps.Numero, DSC_NUMRPS);
  Gerador.wCampo(tcDatHor, '', 'DataEmissaoRPS', 01, 21, 1, NFse.DataEmissaoRps, '');
  Gerador.wCampo(tcStr,    '', 'SituacaoRPS',    01, 01, 1, Situacao, '');

  GerarRPSSubstituido;

  if (NFSe.SeriePrestacao = '') then
    Gerador.wCampo(tcInt, '', 'SeriePrestacao', 01, 02, 1, '99', '')
  else
    Gerador.wCampo(tcInt, '', 'SeriePrestacao', 01, 02, 1, NFSe.SeriePrestacao, '');
end;

procedure TNFSeW_Siat.GerarRPSSubstituido;
begin
  if NFSe.RpsSubstituido.Numero <> '' then
  begin
    if NFSe.RpsSubstituido.Serie = '' then
      Gerador.wCampo(tcStr, '', 'SerieRPSSubstituido', 00, 02, 1, 'NF', '')
    else
      Gerador.wCampo(tcStr, '', 'SerieRPSSubstituido', 00, 02, 1, NFSe.RpsSubstituido.Serie, '');

    Gerador.wCampo(tcStr, '', 'NumeroNFSeSubstituida', 00, 02, 1, NFSe.RpsSubstituido.Numero, '');
    Gerador.wCampo(tcStr, '', 'NumeroRPSSubstituido',  00, 02, 1, NFSe.RpsSubstituido.Numero, '');
  end;
end;

procedure TNFSeW_Siat.GerarPrestador;
begin
  Gerador.wCampo(tcStr, '', 'InscricaoMunicipalPrestador', 01, 011, 1, NFSe.Prestador.InscricaoMunicipal, '');
  Gerador.wCampo(tcStr, '', 'RazaoSocialPrestador',        01, 120, 1, NFSe.PrestadorServico.RazaoSocial, '');
end;

procedure TNFSeW_Siat.GerarTomador;
begin
  Gerador.wCampo(tcStr, '', 'InscricaoMunicipalTomador',  01, 011, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');
  Gerador.wCampo(tcStr, '', 'CPFCNPJTomador',             01, 014, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
  Gerador.wCampo(tcStr, '', 'RazaoSocialTomador',         01, 120, 1, NFSe.Tomador.RazaoSocial, '');
  Gerador.wCampo(tcStr, '', 'DocTomadorEstrangeiro',      00, 020, 1, NFSe.Tomador.IdentificacaoTomador.DocTomadorEstrangeiro, '');
  Gerador.wCampo(tcStr, '', 'TipoLogradouroTomador',      00, 10, 1, NFSe.Tomador.Endereco.TipoLogradouro, '');
  Gerador.wCampo(tcStr, '', 'LogradouroTomador',          01, 50, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampo(tcStr, '', 'NumeroEnderecoTomador',      01, 09, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampo(tcStr, '', 'ComplementoEnderecoTomador', 01, 30, 0, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampo(tcStr, '', 'TipoBairroTomador',          00, 10, 1, NFSe.Tomador.Endereco.TipoBairro, '');
  Gerador.wCampo(tcStr, '', 'BairroTomador',              01, 50, 1, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampo(tcStr, '', 'CidadeTomador',              01, 10, 1, CodCidadeToCodSiafi(strtoint64(NFSe.Tomador.Endereco.CodigoMunicipio)), '');

  if (Trim(NFSe.Tomador.Endereco.xMunicipio) <> '') then
    Gerador.wCampo(tcStr, '', 'CidadeTomadorDescricao', 01, 50, 1, NFSe.Tomador.Endereco.xMunicipio, '')
  else
    Gerador.wCampo(tcStr, '', 'CidadeTomadorDescricao', 01, 50, 1, CodCidadeToCidade(strtoint64(NFSe.Tomador.Endereco.CodigoMunicipio)), '');

  Gerador.wCampo(tcStr, '', 'CEPTomador',   01, 08, 1, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wCampo(tcStr, '', 'EmailTomador', 01, 60, 1, NFSe.Tomador.Contato.Email, '');
end;

procedure TNFSeW_Siat.GerarIntermediarioServico;
begin
  Gerador.wCampo(tcStr, '', 'CPFCNPJIntermediario', 00, 14, 0, OnlyNumber(NFSe.IntermediarioServico.CpfCnpj), '');
end;

procedure TNFSeW_Siat.GerarListaServicos;
var
  i: Integer;
  sDeducaoPor, sTipoDeducao, sTributavel: String;
begin
  if NFSe.Servico.Deducao.Count > 0 then
  begin
    Gerador.wGrupo('Deducoes');

    for i := 0 to NFSe.Servico.Deducao.Count -1 do
    begin
      Gerador.wGrupo('Deducao');

      sDeducaoPor := EnumeradoToStr( NFSe.Servico.Deducao.Items[i].DeducaoPor,
                                           ['Percentual', 'Valor'], [dpPercentual, dpValor]);
      Gerador.wCampo(tcStr, '', 'DeducaoPor', 01, 20, 1, sDeducaoPor , '');

      sTipoDeducao := EnumeradoToStr( NFSe.Servico.Deducao.Items[i].TipoDeducao,
                                            ['', 'Despesas com Materiais', 'Despesas com Subempreitada', 'Deducao de Valor'],
                                            [tdNenhum, tdMateriais, tdSubEmpreitada, tdValor]);
      Gerador.wCampo(tcStr, '', 'TipoDeducao', 00, 255, 1, sTipoDeducao , '');

      Gerador.wCampo(tcStr, '', 'CPFCNPJReferencia'   , 00, 14, 1, OnlyNumber(NFSe.Servico.Deducao.Items[i].CpfCnpjReferencia) , '');
      Gerador.wCampo(tcStr, '', 'NumeroNFReferencia'  , 00, 10, 1, NFSe.Servico.Deducao.Items[i].NumeroNFReferencia, '');
      Gerador.wCampo(tcDe2, '', 'ValorTotalReferencia', 00, 18, 1, NFSe.Servico.Deducao.Items[i].ValorTotalReferencia, '');
      Gerador.wCampo(tcDe2, '', 'PercentualDeduzir', 00, 18, 1, NFSe.Servico.Deducao.Items[i].PercentualDeduzir, '');
      Gerador.wCampo(tcDe2, '', 'ValorDeduzir'   , 00, 08, 1, NFSe.Servico.Deducao.Items[i].ValorDeduzir, '');

      Gerador.wGrupo('/Deducao');
    end;

    Gerador.wGrupo('/Deducoes');
  end;

  if NFSe.Servico.ItemServico.Count > 0 then
  begin
    Gerador.wGrupo('Itens');

    for i := 0 to NFSe.Servico.ItemServico.Count -1 do
    begin
      Gerador.wGrupo('Item');
	    sTributavel := EnumeradoToStr( NFSe.Servico.ItemServico.Items[i].Tributavel,
                                           ['S', 'N'], [snSim, snNao]);

      Gerador.wCampo(tcStr, '', 'DiscriminacaoServico', 01, 80, 1, NFSe.Servico.ItemServico.Items[i].Descricao , '');
      Gerador.wCampo(tcDe4, '', 'Quantidade'          , 01, 15, 1, NFSe.Servico.ItemServico.Items[i].Quantidade , '');
      Gerador.wCampo(tcDe4, '', 'ValorUnitario'       , 01, 20, 1, NFSe.Servico.ItemServico.Items[i].ValorUnitario , ''); {MXM}
      Gerador.wCampo(tcDe2, '', 'ValorTotal'          , 01, 18, 1, NFSe.Servico.ItemServico.Items[i].ValorTotal , '');
      Gerador.wCampo(tcStr, '', 'Tributavel'          , 01, 01, 0, sTributavel , '');
      Gerador.wGrupo('/Item');
    end;

    Gerador.wGrupo('/Itens');
  end;
end;

procedure TNFSeW_Siat.GerarValoresServico;
begin
  Gerador.wCampo(tcStr, '', 'CodigoAtividade', 01, 09, 1, NFSe.Servico.CodigoCnae, '');

    
  Gerador.wCampo(tcDe4, '', 'AliquotaAtividade', 01, 11, 1, NFSe.Servico.Valores.Aliquota, '');

  // "A" a receber; "R" retido na Fonte
  FTipoRecolhimento := EnumeradoToStr( NFSe.Servico.Valores.IssRetido,
                                       ['A','R'], [stNormal, stRetencao]);

  Gerador.wCampo(tcStr, '', 'TipoRecolhimento', 01, 01,  1, TipoRecolhimento, '');

  Gerador.wCampo(tcStr, '', 'MunicipioPrestacao',          01, 10,  1, CodCidadeToCodSiafi(strtoint64(NFSe.Servico.CodigoMunicipio)), '');
  Gerador.wCampo(tcStr, '', 'MunicipioPrestacaoDescricao', 01, 30,  1, CodCidadeToCidade(strtoint64(NFSe.Servico.CodigoMunicipio)), '');
  Gerador.wCampo(tcStr, '', 'Operacao',   01, 01, 1, OperacaoToStr(NFSe.Servico.Operacao), '');
  Gerador.wCampo(tcStr, '', 'Tributacao', 01, 01, 1, TributacaoToStr(NFSe.Servico.Tributacao), '');

  Gerador.wCampo(tcDe2, '', 'ValorPIS',    01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampo(tcDe2, '', 'ValorCOFINS', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampo(tcDe2, '', 'ValorINSS',   01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampo(tcDe2, '', 'ValorIR',     01, 15, 1, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampo(tcDe2, '', 'ValorCSLL',   01, 15, 1, NFSe.Servico.Valores.ValorCsll, '');

  Gerador.wCampo(tcDe4, '', 'AliquotaPIS',    01, 06, 1, NFSe.Servico.Valores.AliquotaPIS, '');
  Gerador.wCampo(tcDe4, '', 'AliquotaCOFINS', 01, 06, 1, NFSe.Servico.Valores.AliquotaCOFINS, '');
  Gerador.wCampo(tcDe4, '', 'AliquotaINSS',   01, 06, 1, NFSe.Servico.Valores.AliquotaINSS, '');
  Gerador.wCampo(tcDe4, '', 'AliquotaIR',     01, 06, 1, NFSe.Servico.Valores.AliquotaIR, '');
  Gerador.wCampo(tcDe4, '', 'AliquotaCSLL',   01, 06, 1, NFSe.Servico.Valores.AliquotaCSLL, '');

  Gerador.wCampo(tcStr, '', 'DescricaoRPS', 01, 1500, 1, NFSe.OutrasInformacoes, '');
end;

procedure TNFSeW_Siat.GerarXML_Siat;
var
  sIEEmit, SerieRPS, NumeroRPS, sDataEmis,
  sTributacao, sSituacaoRPS, sTipoRecolhimento,
  sValorServico, sValorDeducao, sCodAtividade,
  sCPFCNPJTomador, sAssinatura: String;
begin
  Gerador.Prefixo := '';
  Gerador.wGrupo('RPS ' + FIdentificador + '="rps:' + NFSe.InfID.ID + '"');

  FSituacao := EnumeradoToStr( NFSe.Status, ['N','C'], [srNormal, srCancelado]);

  sIEEmit           := Poem_Zeros(NFSe.Prestador.InscricaoMunicipal, 11);
  SerieRPS          := PadRight( NFSe.IdentificacaoRps.Serie, 5 , ' ');
  NumeroRPS         := Poem_Zeros(NFSe.IdentificacaoRps.Numero, 12);
  sDataEmis         := FormatDateTime('yyyymmdd',NFse.DataEmissaoRps);
  sTributacao       := TributacaoToStr(NFSe.Servico.Tributacao) + ' ';
  sSituacaoRPS      := FSituacao;
  sTipoRecolhimento := EnumeradoToStr( NFSe.Servico.Valores.IssRetido, ['N','S'], [stNormal, stRetencao]);

  sValorServico   := Poem_Zeros( OnlyNumber( FormatFloat('#0.00',
                                (NFSe.Servico.Valores.ValorServicos -
                                 NFSe.Servico.Valores.ValorDeducoes) ) ), 15);
  sValorDeducao   := Poem_Zeros( OnlyNumber( FormatFloat('#0.00',
                                 NFSe.Servico.Valores.ValorDeducoes)), 15 );
  sCodAtividade   := Poem_Zeros( OnlyNumber( NFSe.Servico.CodigoCnae ), 10 );
  sCPFCNPJTomador := Poem_Zeros( OnlyNumber( NFSe.Tomador.IdentificacaoTomador.CpfCnpj), 14);


  sAssinatura := sIEEmit + SerieRPS + NumeroRPS + sDataEmis + sTributacao +
                 sSituacaoRPS + sTipoRecolhimento + sValorServico +
                 sValorDeducao + sCodAtividade + sCPFCNPJTomador;

  sAssinatura := AsciiToHex(SHA1(sAssinatura));
  sAssinatura := LowerCase(sAssinatura);

  Gerador.wCampo(tcStr, '', 'Assinatura', 01, 2000, 1, sAssinatura, '');

  GerarPrestador;
  GerarIdentificacaoRPS;
  GerarTomador;
  GerarValoresServico;

  if Length(OnlyNumber(NFSe.PrestadorServico.Contato.Telefone)) = 11 then
    Gerador.wCampo(tcStr, '', 'DDDPrestador', 00, 03, 1, LeftStr(OnlyNumber(NFSe.PrestadorServico.Contato.Telefone),3), '')
  else
    if Length(OnlyNumber(NFSe.PrestadorServico.Contato.Telefone)) = 10 then
      Gerador.wCampo(tcStr, '', 'DDDPrestador', 00, 03, 1, LeftStr(OnlyNumber(NFSe.PrestadorServico.Contato.Telefone),2), '')
    else
      Gerador.wCampo(tcStr, '', 'DDDPrestador', 00, 03, 1, '', '');

  Gerador.wCampo(tcStr, '', 'TelefonePrestador', 00, 08, 1, RightStr(OnlyNumber(NFSe.PrestadorServico.Contato.Telefone),8), '');

  if Length(OnlyNumber(NFSe.Tomador.Contato.Telefone)) = 11 then
    Gerador.wCampo(tcStr, '', 'DDDTomador', 00, 03, 1, LeftStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),3), '')
  else
    if Length(OnlyNumber(NFSe.Tomador.Contato.Telefone)) = 10 then
      Gerador.wCampo(tcStr, '', 'DDDTomador', 00, 03, 1, LeftStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),2), '')
    else
      Gerador.wCampo(tcStr, '', 'DDDTomador', 00, 03, 1, '', '');

  Gerador.wCampo(tcStr, '', 'TelefoneTomador', 00, 08, 1, RightStr(OnlyNumber(NFSe.Tomador.Contato.Telefone),8), '');

  if (NFSe.Status = srCancelado) then
    Gerador.wCampo(tcStr, '', 'MotCancelamento',01, 80, 1, NFSE.MotivoCancelamento, '')
  else
    Gerador.wCampo(tcStr, '', 'MotCancelamento',00, 80, 0, NFSE.MotivoCancelamento, '');

  GerarIntermediarioServico;
  GerarListaServicos;

  Gerador.wGrupo('/RPS');
end;

constructor TNFSeW_Siat.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);

end;

function TNFSeW_Siat.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_Siat.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  FNFSe.InfID.ID := FNFSe.IdentificacaoRps.Numero;

  GerarXML_Siat;

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
