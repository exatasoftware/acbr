{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit pnfsNFSeW_SP;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrConsts,
  pnfsNFSeW,
  pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao, pnfsConsts;

type
  { TNFSeW_SP }

  TNFSeW_SP = class(TNFSeWClass)
  private
  protected

    procedure GerarChaveRPS;
    procedure GerarIdentificacaoRPS;
    procedure GerarValoresServico;
    procedure GerarTomador;
    procedure GerarIntermediarioServico;
    procedure GerarConstrucaoCivil;
    procedure GerarListaServicos;

    procedure GerarXML_SP;

   function AsciiToByte(const ABinaryString: AnsiString): String;

  public
    constructor Create(ANFSeW: TNFSeW); override;

    function ObterNomeArquivo: String; override;
    function GerarXml: Boolean; override;
  end;

implementation

uses
  ACBrUtil;

{==============================================================================}
{ Essa unit tem por finalidade exclusiva de gerar o XML do RPS segundo o       }
{ layout do SP.                                                                }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_SP }

procedure TNFSeW_SP.GerarChaveRPS;
begin
  Gerador.wGrupo('ChaveRPS');
  Gerador.wCampo(tcStr, '', 'InscricaoPrestador', 1, 11, 1, NFSe.Prestador.InscricaoMunicipal, '');
  Gerador.wCampo(tcStr, '', 'SerieRPS'          , 1, 02, 1, NFSe.IdentificacaoRps.Serie, '');
  Gerador.wCampo(tcStr, '', 'NumeroRPS'         , 1, 12, 1, NFSe.IdentificacaoRps.Numero, DSC_NUMRPS);
  Gerador.wGrupo('/ChaveRPS');
end;

procedure TNFSeW_SP.GerarIdentificacaoRPS;
var
 TipoRPS, Situacao: String;
begin
  TipoRPS := EnumeradoToStr(NFSe.IdentificacaoRps.Tipo,
                           ['RPS','RPS-M','RPS-C'],
                           [trRPS, trNFConjugada, trCupom]);

  Situacao := EnumeradoToStr(NFSe.Status, ['N', 'C'], [srNormal, srCancelado]);

  Gerador.wCampo(tcStr, '', 'TipoRPS'      , 1, 05, 1, TipoRPS, '');
  Gerador.wCampo(tcDat, '', 'DataEmissao'  , 1, 10, 1, NFse.DataEmissao, '');
  Gerador.wCampo(tcStr, '', 'StatusRPS'    , 1, 01, 1, Situacao, '');
  Gerador.wCampo(tcStr, '', 'TributacaoRPS', 1, 01, 1, TTributacaoRPSToStr(NFSe.TipoTributacaoRPS), '');
end;

procedure TNFSeW_SP.GerarValoresServico;
var
  aliquota, ISSRetido: String;
begin
  Gerador.wCampo(tcDe2, '', 'ValorServicos', 1, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampo(tcDe2, '', 'ValorDeducoes', 1, 15, 1, NFSe.Servico.Valores.ValorDeducoes, '');
  Gerador.wCampo(tcDe2, '', 'ValorPIS'     , 1, 15, 0, NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampo(tcDe2, '', 'ValorCOFINS'  , 1, 15, 0, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampo(tcDe2, '', 'ValorINSS'    , 1, 15, 0, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampo(tcDe2, '', 'ValorIR'      , 1, 15, 0, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampo(tcDe2, '', 'ValorCSLL'    , 1, 15, 0, NFSe.Servico.Valores.ValorCsll, '');
  Gerador.wCampo(tcStr, '', 'CodigoServico'   , 1, 05, 1, OnlyNumber(NFSe.Servico.ItemListaServico), '');

  if NFSe.Servico.Valores.Aliquota > 0 then
  begin
    if (FProvedor = proSP) then
      aliquota := FormatFloat('0.00##', NFSe.Servico.Valores.Aliquota / 100)
    else
      aliquota := FormatFloat('0.00##', NFSe.Servico.Valores.Aliquota);

    aliquota := StringReplace(aliquota, ',', '.', [rfReplaceAll]);
  end
  else
    aliquota := '0';

  Gerador.wCampo(tcStr, '', 'AliquotaServicos', 1, 6, 1, aliquota, '');

  ISSRetido := EnumeradoToStr( NFSe.Servico.Valores.IssRetido,
                                       ['false', 'true'], [stNormal, stRetencao]);

  Gerador.wCampo(tcStr, '', 'ISSRetido', 1, 05, 1, ISSRetido, '');
end;

procedure TNFSeW_SP.GerarTomador;
begin
  if OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) <> '' then
  begin
    Gerador.wGrupo('CPFCNPJTomador');
    Gerador.wCampoCNPJCPF('', '', OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj));
    Gerador.wGrupo('/CPFCNPJTomador');
  end;
  Gerador.wCampo(tcStr, '', 'InscricaoMunicipalTomador', 1, 08, 0, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal), '');
  Gerador.wCampo(tcStr, '', 'InscricaoEstadualTomador' , 1, 19, 0, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual), '');
  Gerador.wCampo(tcStr, '', 'RazaoSocialTomador'       , 1, 75, 0, NFSe.Tomador.RazaoSocial, '');

  Gerador.wGrupo('EnderecoTomador');
  Gerador.wCampo(tcStr, '', 'TipoLogradouro',      0, 10, 0, NFSe.Tomador.Endereco.TipoLogradouro, '');
  Gerador.wCampo(tcStr, '', 'Logradouro',          1, 50, 0, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampo(tcStr, '', 'NumeroEndereco',      1, 09, 0, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampo(tcStr, '', 'ComplementoEndereco', 1, 30, 0, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampo(tcStr, '', 'Bairro',              1, 50, 0, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampo(tcStr, '', 'Cidade',              1, 10, 0, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampo(tcStr, '', 'UF',                  1, 02, 0, NFSe.Tomador.Endereco.UF, '');
  Gerador.wCampo(tcStr, '', 'CEP',                 1, 08, 0, OnlyNumber(NFSe.Tomador.Endereco.CEP), '');
  Gerador.wGrupo('/EnderecoTomador');

  Gerador.wCampo(tcStr, '', 'EmailTomador', 1, 75, 0, NFSe.Tomador.Contato.Email, '');
end;

procedure TNFSeW_SP.GerarIntermediarioServico;
var
  sISSRetidoInter: String;
begin
  if OnlyNumber(NFSe.IntermediarioServico.CpfCnpj) <> '' then
  begin
    Gerador.wGrupo('CPFCNPJIntermediario');
    Gerador.wCampoCNPJCPF('', '', OnlyNumber(NFSe.IntermediarioServico.CpfCnpj));
    Gerador.wGrupo('/CPFCNPJIntermediario');

    Gerador.wCampo(tcStr, '', 'InscricaoMunicipalIntermediario',  01, 08, 0, OnlyNumber(NFSe.IntermediarioServico.InscricaoMunicipal), '');

    sISSRetidoInter := EnumeradoToStr( NFSe.IntermediarioServico.IssRetido,
                                  ['false', 'true'], [stNormal, stRetencao]);

    Gerador.wCampo(tcStr, '', 'ISSRetidoIntermediario', 1, 05, 0, sISSRetidoInter, '');
    Gerador.wCampo(tcStr, '', 'EmailIntermediario'    , 1, 75, 0, NFSe.IntermediarioServico.EMail, '');
  end;
end;

procedure TNFSeW_SP.GerarListaServicos;
begin
  Gerador.wCampo(tcStr, '', 'Discriminacao', 1, 2000, 1, NFSe.Servico.Discriminacao, '');
  Gerador.wCampo(tcDe2, '', 'ValorCargaTributaria', 1, 15, 0, NFSe.Servico.ValorCargaTributaria, '');
  Gerador.wCampo(tcDe4, '', 'PercentualCargaTributaria', 1, 5, 0, NFSe.Servico.PercentualCargaTributaria, '');
  Gerador.wCampo(tcStr, '', 'FonteCargaTributaria', 1, 10, 0, NFSe.Servico.FonteCargaTributaria, '');
end;

procedure TNFSeW_SP.GerarConstrucaoCivil;
begin
  Gerador.wCampo(tcStr, '', 'CodigoCEI', 1, 12, 0, NFSe.ConstrucaoCivil.nCei, '');
  Gerador.wCampo(tcStr, '', 'MatriculaObra', 1, 12, 0, NFSe.ConstrucaoCivil.nMatri, '');
  Gerador.wCampo(tcStr, '', 'NumeroEncapsulamento', 1, 12, 0, NFSe.ConstrucaoCivil.nNumeroEncapsulamento, '');
end;

function TNFSeW_SP.AsciiToByte(const ABinaryString: AnsiString): String;
var
  I, L: Integer;
begin
  Result := '' ;
  L := Length(ABinaryString) ;
  for I := 1 to L do
    Result := Result + IntToStr(Ord(ABinaryString[I]));
end;

procedure TNFSeW_SP.GerarXML_SP;
begin
  Gerador.Prefixo := '';
  Gerador.wGrupo('RPS');

  Gerador.wCampo(tcStr, '', 'Assinatura', 1, 2000, 1, NFSe.Assinatura, '');

  GerarChaveRPS;
  GerarIdentificacaoRPS;
  GerarValoresServico;
  GerarTomador;
  GerarIntermediarioServico;
  GerarListaServicos;
  GerarConstrucaoCivil;

  if (FProvedor = proSP) and (NFSe.TipoTributacaoRPS  <> ttTribnoMun) and (NFSe.TipoTributacaoRPS  <> ttTribnoMunIsento) then
    Gerador.wCampo(tcStr, '', 'MunicipioPrestacao', 1, 7, 0, NFSe.Servico.MunicipioIncidencia, '');

  Gerador.wGrupo('/RPS');
end;

constructor TNFSeW_SP.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);

end;

function TNFSeW_SP.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_SP.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;
  
  Gerador.Opcoes.SuprimirDecimais := True;
  Gerador.Opcoes.QuebraLinha      := FQuebradeLinha;

  FDefTipos := FServicoEnviar;

  if (RightStr(FURL, 1) <> '/') and (FDefTipos <> '')
    then FDefTipos := '/' + FDefTipos;

  if Trim(FPrefixo4) <> ''
    then Atributo := ' xmlns:' + StringReplace(Prefixo4, ':', '', []) + '="' + FURL + FDefTipos + '"'
    else Atributo := ' xmlns="' + FURL + FDefTipos + '"';

  FNFSe.InfID.ID := FNFSe.IdentificacaoRps.Numero;

  GerarXML_SP;

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Gerador.Opcoes.SuprimirDecimais := False;
  
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
