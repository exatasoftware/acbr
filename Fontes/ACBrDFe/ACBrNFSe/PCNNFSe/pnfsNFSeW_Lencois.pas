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

unit pnfsNFSeW_Lencois;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrConsts,
  pnfsNFSeW, pcnAuxiliar, pcnConversao, pcnGerador, pnfsNFSe, pnfsConversao;

type
  { TNFSeW_Lencois }

  TNFSeW_Lencois = class(TNFSeWClass)
  protected
    procedure GerarTomador;
    procedure GerarServicoValores;
    procedure GerarXML_Lencois;
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
{ layout do provedor Lencois.                                                  }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

function _RegimeEspecialTributacaoToStr(const t: TnfseRegimeEspecialTributacao): String;
begin
  result := EnumeradoToStr(t,
                           ['','-2','-4','-5','-6'],
                           [retNenhum, retEstimativa, retCooperativa, retMicroempresarioIndividual, retMicroempresarioEmpresaPP]);
end;

function SimNaoToStr(const t: TnfseSimNao): String;
begin
  result := EnumeradoToStr(t,
                           ['1','0'],
                           [snSim, snNao]);
end;

function _ExigibilidadeISSToStr(const t: TnfseExigibilidadeISS): String;
begin
  // -8 = Fixo
  result := EnumeradoToStr(t,
                           ['-1','-2','-3','-4','-5','-6','-7'],
                           [exiExigivel, exiNaoIncidencia, exiIsencao, exiExportacao, exiImunidade,
                            exiSuspensaDecisaoJudicial, exiSuspensaProcessoAdministrativo]);
end;

function _TipoRPSToStr(const t: TnfseTipoRPS): String;
begin
  result := EnumeradoToStr(t,
                           ['-2','-4','-5'],
                           [trRPS, trNFConjugada, trCupom]);
end;

function _ResponsavelRetencaoToStr(const T: TnfseResponsavelRetencao): String;
begin
  result := EnumeradoToStr(t,
                           ['-1', '-2', '-3'],
                           [ptTomador, rtIntermediario, rtPrestador]);
end;
{ TNFSeW_Lencois }

procedure TNFSeW_Lencois.GerarTomador;
begin
   if (NFSe.Tomador.IdentificacaoTomador.CpfCnpj <> '') or (NFSe.Tomador.RazaoSocial <> '') or
      (NFSe.Tomador.Endereco.Endereco <> '') or (NFSe.Tomador.Contato.Telefone <> '') or (NFSe.Tomador.Contato.Email <> '') then begin
      Gerador.wGrupo('Tomador');
      //
      if NFSe.Tomador.Endereco.UF <> 'EX' then begin
         Gerador.wCampo(tcStr, '', 'CPF_CNPJ', 11, 14, 1, OnlyNumber(NFSe.Tomador.IdentificacaoTomador.CpfCnpj), '');
      end;
      //
      Gerador.wCampo(tcStr, '', 'Nome', 001, 50, 0, NFSe.Tomador.RazaoSocial, '');
      //
      Gerador.wGrupo('Endereco');
      Gerador.wCampo(tcStr, '', 'Logradouro ', 001, 095, 1, NFSe.Tomador.Endereco.Endereco, '');
      Gerador.wCampo(tcStr, '', 'Numero     ', 001, 015, 1, NFSe.Tomador.Endereco.Numero, '');
      Gerador.wCampo(tcStr, '', 'Complemento', 001, 020, 1, NFSe.Tomador.Endereco.Complemento, '');
      Gerador.wCampo(tcStr, '', 'Bairro     ', 001, 075, 1, NFSe.Tomador.Endereco.Bairro, '');
      Gerador.wCampo(tcStr, '', 'Municipio  ', 7, 7, 1, OnlyNumber(NFSe.Tomador.Endereco.CodigoMunicipio), '');
      Gerador.wGrupo('/Endereco');
      //
      if (NFSe.Tomador.Contato.Email <> '') then begin
         Gerador.wCampo(tcStr, '', 'Email   ', 01, 050, 0, NFSe.Tomador.Contato.Email, '');
      end;
      //
      if length(OnlyNumber(NFSe.Prestador.Cnpj)) <= 11 then begin
         Gerador.wCampo(tcStr, '', 'Particular', 001, 001, 1, '1', '');
      end else begin
         Gerador.wCampo(tcStr, '', 'Particular', 001, 001, 1, '0', '');
      end;
      //
      Gerador.wGrupo('/Tomador');
   end else begin
      Gerador.wCampo(tcStr, '', 'Tomador', 0, 1, 1, '', '');
   end;
end;

procedure TNFSeW_Lencois.GerarServicoValores;
begin
  Gerador.wCampo(tcDe2, '', 'ValorTotal  ', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampo(tcDe2, '', 'ValorDeducao', 01, 15, 1, NFSe.Servico.Valores.ValorDeducoes, '');
  //
  Gerador.wCampo(tcDe6, '', 'Aliquota      ', 01, 07, 1, NFSe.Servico.Valores.Aliquota, '');
  //
  if (NFSe.OptanteSimplesNacional = snNao) then begin
     Gerador.wCampo(tcDe2, '', 'ValorPIS      ', 01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
     Gerador.wCampo(tcDe2, '', 'ValorCOFINS   ', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
  end;
  //
  // Reten��es
  Gerador.wCampo(tcDe2, '', 'RetencaoIRRF  ', 01, 15, 1, NFSe.Servico.Valores.ValorIr, '');
  Gerador.wCampo(tcDe2, '', 'RetencaoINSS  ', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
  Gerador.wCampo(tcDe2, '', 'RetencaoPIS   ', 01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
  Gerador.wCampo(tcDe2, '', 'RetencaoCOFINS', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
  Gerador.wCampo(tcDe2, '', 'RetencaoCSLL  ', 01, 15, 1, NFSe.Servico.Valores.ValorCsll, '');
  //
  Gerador.wCampo(tcInt, '', 'EnviarEmail  ', 01, 01, 1, '1', '');
  //
  Gerador.wCampo(tcInt, '', 'TributacaoISS ', 01, 02, 1, '0', '');
  //
  if (NFSe.Servico.MunicipioIncidencia > 0) then begin
     Gerador.wGrupo('RecolhimentoFora');
     Gerador.wCampo(tcDe6, '', 'Aliquota  ', 01, 08, 1, NFSe.Servico.Valores.Aliquota, '');
     case NFSe.Servico.ResponsavelRetencao of
        ptTomador: Gerador.wCampo(tcInt, '', 'Obrigacao ', 01, 01, 1, '1', '');
        else Gerador.wCampo(tcInt, '', 'Obrigacao ', 01, 01, 1, '0', '');;
     end;
     Gerador.wGrupo('/RecolhimentoFora');
  end;
end;

procedure TNFSeW_Lencois.GerarXML_Lencois;
begin
  Gerador.wCampo(tcStr, '', 'Versao', 01, 30, 1, '1.1', '');
  Gerador.wCampo(tcStr, '', 'InscricaoMunicipal', 01, 5, 1, NFSe.Prestador.InscricaoMunicipal, '');
  //
  Gerador.wGrupo('PASNF');
  Gerador.wCampo(tcInt, '', 'Numero', 01, 5, 1, NFSe.Numero, '');
  Gerador.wCampo(tcDat, '', 'Data', 10, 10, 1, NFSe.DataEmissao, '');
  Gerador.wGrupo('/PASNF');
  //
  GerarTomador;
  //
  if (NFSe.Servico.CodigoMunicipio<>'') then begin
     Gerador.wCampo(tcInt, '', 'CidadeExecucao', 1, 7, 1, NFSe.Servico.CodigoMunicipio, '');
  end;
  //
  Gerador.wCampo(tcStr, '', 'Descricao', 1, 1000, 1, NFSe.Servico.Descricao, '');
  //
  GerarServicoValores;
end;

constructor TNFSeW_Lencois.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

function TNFSeW_Lencois.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_Lencois.GerarXml: Boolean;
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

  Gerador.wGrupo('Nota' + Atributo);

  FNFSe.InfID.ID := OnlyNumber(FNFSe.IdentificacaoRps.Numero) + FNFSe.IdentificacaoRps.Serie;

  GerarXML_Lencois;

  Gerador.wGrupo('/Nota');

  Gerador.gtAjustarRegistros(NFSe.InfID.ID);
  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.
