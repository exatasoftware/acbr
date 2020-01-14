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

unit pnfsNFSeW_Infisc;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ELSE}

{$ENDIF}
  SysUtils, Classes,
  ACBrConsts,
  pnfsNFSeW, pcnAuxiliar, pcnConversao, pcnGerador,
  pnfsNFSe, pnfsConversao;

type
  { TNFSeW_Infisc }

  TNFSeW_Infisc = class(TNFSeWClass)
  private
    FdTotBCISS: Double;
    FdTotISS: Double;
  protected

    // **************************** Vers�o 1.00
    procedure GerarIdentificacaoRPS_v10;
    procedure GerarPrestador_v10;
    procedure GerarTomador_v10;
    procedure GerarListaServicos_v10;
    procedure GerarValoresServico_v10;
    procedure GerarCondicaoPagamento_v10;

    procedure GerarXML_Infisc_v10;

    // **************************** Vers�o 1.10
    procedure GerarIdentificacaoRPS_v11;
    procedure GerarPrestador_v11;
    procedure GerarTomador_v11;
    procedure GerarListaServicos_v11;
    procedure GerarValoresServico_v11;
    procedure GerarCondicaoPagamento_v11;
    procedure GerarDespesasAdicionaisNaoTributaveis;

    procedure GerarXML_Infisc_v11;

    // **************************** Ambas Vers�es
    procedure GerarTransportadora;
    procedure GerarConstrucaoCivil;

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
{ layout do Infisc.                                                            }
{ Sendo assim s� ser� criado uma nova unit para um novo layout.                }
{==============================================================================}

{ TNFSeW_Infisc }

constructor TNFSeW_Infisc.Create(ANFSeW: TNFSeW);
begin
  inherited Create(ANFSeW);
end;

function TNFSeW_Infisc.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeW_Infisc.GerarXml: Boolean;
begin
  Gerador.ListaDeAlertas.Clear;

  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := FPrefixo4;

  Gerador.Opcoes.QuebraLinha := FQuebradeLinha;

  FNFSe.InfID.ID  := FNFSe.Numero;

  if VersaoNFSe = ve100 then
    GerarXML_Infisc_v10
  else
    GerarXML_Infisc_v11;


  Gerador.gtAjustarRegistros(NFSe.InfID.ID);

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

////////////////////////////////////////////////////////////////////////////////
// **************************** Vers�o 1.00
////////////////////////////////////////////////////////////////////////////////

procedure TNFSeW_Infisc.GerarIdentificacaoRPS_v10;
var
  sChave, cNFSe, serie, nNFSe:String;
begin
  sChave := NFSe.ChaveNFSe;
  serie  := NFSE.SeriePrestacao;
  nNFSe  := NFSe.Numero;
  cNFSe  := copy(sChave, 31, 9);

  Gerador.wGrupoNFSe('Id');
  Gerador.wCampoNFSe(tcStr, '', 'cNFS-e', 01, 09, 1, cNFSe, '');
  Gerador.wCampoNFSe(tcStr, '', 'natOp' , 01, 50, 1, NaturezaOperacaoToStr(NFSe.NaturezaOperacao), '');
  Gerador.wCampoNFSe(tcStr, '', 'mod'   , 01, 02, 1, NFSe.ModeloNFSe, '');  // segundo manual obrigat�rio ser 98
  Gerador.wCampoNFSe(tcStr, '', 'serie' , 01, 03, 1, serie, '');            // tem que ser S - ver como est� sendo passado a vari�vel "serie"
  Gerador.wCampoNFSe(tcStr, '', 'nNFS-e', 01, 09, 1, nNFSe, '');
  Gerador.wCampoNFSe(tcStr, '', 'dEmi'  , 01, 10, 1, FormatDateTime('yyyy-mm-dd',NFSe.DataEmissao), '');
  Gerador.wCampoNFSe(tcStr, '', 'hEmi'  , 01, 10, 1, FormatDateTime('hh:mm',NFSe.DataEmissao), '');
  Gerador.wCampoNFSe(tcStr, '', 'tpNF'  , 01, 01, 1, '1', '');     // 0- Entrada 1- Sa�da
  Gerador.wCampoNFSe(tcStr, '', 'cMunFG', 01, 07, 1, NFSe.Servico.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'refNF' , 01, 39, 1, sChave, '');  // chave de acesso 39 caracteres
  Gerador.wCampoNFSe(tcStr, '', 'tpEmis', 01, 01, 1, TipoEmissaoToStr(NFSe.TipoEmissao), ''); // N- Normal C- Contigencia
  Gerador.wCampoNFSe(tcStr, '', 'anulada', 01, 01, 1, 'N', '');
  Gerador.wGrupoNFSe('/Id');
end;

procedure TNFSeW_Infisc.GerarPrestador_v10;
begin
  Gerador.wGrupoNFSe('emit');
  Gerador.wCampoNFSe(tcStr, '', 'CNPJ'  , 01, 014, 1, NFSe.Prestador.Cnpj, '');
  Gerador.wCampoNFSe(tcStr, '', 'xNome' , 01, 100, 1, NFSe.PrestadorServico.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'xFant' , 01, 060, 1, NFSe.PrestadorServico.NomeFantasia, '');
  Gerador.wCampoNFSe(tcStr, '', 'IM'    , 01, 015, 1, NFSe.Prestador.InscricaoMunicipal, '');

  Gerador.wGrupoNFSe('end');
  Gerador.wCampoNFSe(tcStr, '', 'xLgr'   , 01, 100, 1, NFSe.PrestadorServico.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nro'    , 01, 015, 1, NFSe.PrestadorServico.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'xCpl'   , 01, 100, 1, NFSe.PrestadorServico.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'xBairro', 01, 100, 1, NFSe.PrestadorServico.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'cMun'   , 01, 007, 1, NFSe.PrestadorServico.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'xMun'   , 01, 060, 1, copy(CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio,0)),
                                                      0, pos('/',CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio,0)))-1), '');
  Gerador.wCampoNFSe(tcStr, '', 'UF'     , 01, 002, 1, NFSe.PrestadorServico.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'CEP'    , 01, 008, 1, NFSe.PrestadorServico.Endereco.CEP, '');
  Gerador.wCampoNFSe(tcInt, '', 'cPais'  , 01, 100, 1, NFSe.PrestadorServico.Endereco.CodigoPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'xPais'  , 01, 100, 1, NFSe.PrestadorServico.Endereco.xPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'fone'   , 01, 100, 1, NFSe.PrestadorServico.Contato.Telefone, '');
  Gerador.wGrupoNFSe('/end');

  case Nfse.RegimeEspecialTributacao of
    retNenhum,
    retMicroempresaMunicipal,
    retEstimativa,
    retSociedadeProfissionais,
    retCooperativa,
    retMicroempresarioIndividual    : ; // N�o tem informa��o no manual
    retSimplesNacional              : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '1', ''); // 1 - Simples
    retMicroempresarioEmpresaPP     : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '2', ''); // 2 - SIMEI
    retLucroReal, retLucroPresumido : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '3', ''); // 3 - Normal
  end;

  Gerador.wGrupoNFSe('/emit');
end;

procedure TNFSeW_Infisc.GerarTomador_v10;
begin
  Gerador.wGrupoNFSe('TomS');

  if Length(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) = 11 then
    Gerador.wCampoNFSe(tcStr, '', 'CPF', 01, 11, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'CNPJ', 01, 14, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '');

  Gerador.wCampoNFSe(tcStr, '', 'xNome', 01, 100, 1, NFSe.Tomador.RazaoSocial, '');

  Gerador.wGrupoNFSe('ender');
  Gerador.wCampoNFSe(tcStr, '', 'xLgr'   , 01, 100, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nro'    , 01, 015, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'xCpl'   , 01, 100, 1, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'xBairro', 01, 100, 1, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'cMun'   , 01, 007, 1, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'xMun'   , 01, 060, 1, CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio,0)), '');
  Gerador.wCampoNFSe(tcStr, '', 'UF'     , 01, 002, 1, NFSe.Tomador.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'CEP'    , 01, 008, 1, NFSe.Tomador.Endereco.CEP, '');
  Gerador.wCampoNFSe(tcStr, '', 'cPais'  , 01, 004, 1, '1058', '');
  Gerador.wCampoNFSe(tcStr, '', 'xPais'  , 01, 100, 1, 'Brasil', '');
  Gerador.wCampoNFSe(tcStr, '', 'fone'   , 01, 100, 1, NFSe.Tomador.Contato.Telefone, '');
  Gerador.wGrupoNFSe('/ender');

  Gerador.wCampoNFSe(tcStr, '', 'xEmail', 01, 100, 1, NFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'IM'    , 01, 015, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');

  if NFSe.Servico.MunicipioIncidencia <> 0 then
  begin
    if (NFSe.Servico.MunicipioIncidencia = 4303905) then
      Gerador.wCampoNFSe(tcStr, '', 'Praca', 01, 60, 1, 'Campo Bom-RS', '')
    else
      Gerador.wCampoNFSe(tcStr, '', 'Praca', 01, 60, 1, CodCidadeToCidade(NFSe.Servico.MunicipioIncidencia), '');
  end;

  Gerador.wGrupoNFSe('/TomS');
end;

procedure TNFSeW_Infisc.GerarListaServicos_v10;
var
  i, GeraTag: Integer;
  cServ, xServ: String;
begin
  FdTotBCISS := 0;
  FdTotISS   := 0;

  for i := 0 to NFSe.Servico.ItemServico.Count-1 do
  begin
    cServ := NFSe.Servico.ItemServico.Items[i].codServ; // cod. municipal
    xServ := NFSe.Servico.ItemServico.Items[i].Descricao;

    if NFSe.Servico.ItemListaServico <> '' then
      xServ := xServ + ' (Class.: ' + NFSe.Servico.ItemListaServico+')';

    Gerador.wGrupoNFSe('det');
    Gerador.wCampoNFSe(tcStr, '', 'nItem', 01, 02, 1, IntToStr(i+1), '');

    Gerador.wGrupoNFSe('serv');
    Gerador.wCampoNFSe(tcStr, '', 'cServ' , 01, 002, 1, cServ, '');
    Gerador.wCampoNFSe(tcStr, '', 'xServ' , 01, 120, 1, xServ, '');
    Gerador.wCampoNFSe(tcStr, '', 'uTrib' , 01, 006, 1, 'UN', '');
    Gerador.wCampoNFSe(tcDe2, '', 'qTrib' , 01, 015, 1, NFSe.Servico.ItemServico.Items[i].Quantidade, '');
    Gerador.wCampoNFSe(tcDe3, '', 'vUnit' , 01, 015, 1, NFSe.Servico.ItemServico.Items[i].ValorUnitario, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vServ' , 01, 015, 0, NFSe.Servico.ItemServico.Items[i].ValorServicos, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vDesc' , 01, 015, 0, NFSe.Servico.ItemServico.Items[i].DescontoIncondicionado, '');

    if ( Nfse.RegimeEspecialTributacao = retSimplesNacional ) or ( Nfse.OptanteSimplesNacional = snSim ) then
      GeraTag := 1
    else
      GeraTag := 0;

    Gerador.wCampoNFSe(tcDe2, '', 'vBCISS', 01, 015, GeraTag, NFSe.Servico.ItemServico.Items[i].BaseCalculo, '');
    Gerador.wCampoNFSe(tcDe2, '', 'pISS'  , 01, 015, GeraTag, NFSe.Servico.ItemServico.Items[i].Aliquota, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vISS'  , 01, 015, GeraTag, NFSe.Servico.ItemServico.Items[i].ValorIss, '');

    FdTotBCISS := FdTotBCISS + NFSe.Servico.ItemServico.Items[i].BaseCalculo;
    FdTotISS   := FdTotISS   + NFSe.Servico.ItemServico.Items[i].ValorIss;

    Gerador.wCampoNFSe(tcDe2, '', 'pRed', 01, 15, 0, 0, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vRed', 01, 15, 0, 0, '');

    // Reten��o INSS
    if NFSe.Servico.ItemServico.Items[i].ValorInss > 0 then
      Gerador.wCampoNFSe(tcDe2, '', 'vRetINSS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorInss, '');

    // Reten��o IRRF
    if NFSe.Servico.ItemServico.Items[i].ValorIr > 0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetIRF', 01, 02, 1, 'Reten��o IRRF', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetIRF', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorIr, '');
    end;

    // Reten��o PIS
    if NFSe.Servico.ItemServico.Items[i].ValorPis > 0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-PIS-PASEP', 01, 02, 1, 'Reten��o PIS', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-PIS-PASEP', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorPis, '');
    end;

    // Reten��o COFINS
    if NFSe.Servico.ItemServico.Items[i].ValorCofins > 0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-COFINS', 01, 02, 1, 'Reten��o COFINS', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-COFINS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorCofins, '');
    end;

    // Reten��o CSLL
    if NFSe.Servico.ItemServico.Items[i].ValorCsll > 0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-CSLL', 01, 02, 1, 'Reten��o CSLL', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-CSLL', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorCsll, '');
    end;

    Gerador.wGrupoNFSe('/serv');

    // Reten��o ISSQN
    if NFSe.Servico.ItemServico.Items[i].ValorISSST > 0 then
    begin
      Gerador.wGrupoNFSe('ISSST');
      Gerador.wCampoNFSe(tcDe2, '', 'vISSST', 01, 15, 0, NFSe.Servico.ItemServico.Items[i].ValorISSST, '');
      Gerador.wGrupoNFSe('/ISSST');
    end;

    Gerador.wGrupoNFSe('/det');
  end;
end;

procedure TNFSeW_Infisc.GerarValoresServico_v10;
begin
  Gerador.wGrupoNFSe('total');
  Gerador.wCampoNFSe(tcDe2, '', 'vServ' , 01, 15, 0, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vDesc' , 01, 15, 0, NFSe.Servico.Valores.DescontoIncondicionado, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vOutro', 01, 15, 0, 0, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vtNF'  , 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vtLiq' , 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');

  Gerador.wCampoNFSe(tcDe2, '', 'totalAproxTribServ', 01, 15, 0, 0, '');

  // Total Reten��o IRRF
  if (NFSe.Servico.Valores.ValorIr + NFSe.Servico.Valores.ValorPis +
      NFSe.Servico.Valores.ValorCofins + NFSe.Servico.Valores.ValorCsll +
      NFSe.Servico.Valores.ValorInss) > 0 then
  begin
    Gerador.wGrupoNFSe('Ret');

    if NFSe.Servico.Valores.ValorIr>0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetIRF', 01, 02, 1, 'Reten��o IRRF', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetIRF', 01, 15, 1, NFSe.Servico.Valores.ValorIr, '');
    end;

    if NFSe.Servico.Valores.ValorPis>0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-PIS-PASEP', 01, 02, 1, 'Reten��o PIS', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-PIS-PASEP', 01, 15, 1, NFSe.Servico.Valores.ValorPis, '');
    end;

    if NFSe.Servico.Valores.ValorCofins>0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-COFINS', 01, 02, 1, 'Reten��o COFINS', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-COFINS', 01, 15, 1, NFSe.Servico.Valores.ValorCofins, '');
    end;

    if NFSe.Servico.Valores.ValorCsll>0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetLei10833-CSLL', 01, 02, 1, 'Reten��o CSLL', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetLei10833-CSLL', 01, 15, 1, NFSe.Servico.Valores.ValorCsll, '');
    end;

    if NFSe.Servico.Valores.ValorInss>0 then
    begin
      Gerador.wCampoNFSe(tcStr, '', 'xRetINSS', 01, 02, 1, 'Reten��o INSS', '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetINSS', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
    end;

    Gerador.wGrupoNFSe('/Ret');
  end;

  // incluir tag 'fat' aqui!

  // Total Reten��o ISSQN
  Gerador.wGrupoNFSe('ISS');
  Gerador.wCampoNFSe(tcDe2, '', 'vBCISS'  , 01, 15, 0, FdTotBCISS, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vISS'    , 01, 15, 0, FdTotISS, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vBCSTISS', 01, 15, 0, 0, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vSTISS'  , 01, 15, 0, NFSe.Servico.Valores.ValorIssRetido, '');
  Gerador.wGrupoNFSe('/ISS');

  Gerador.wGrupoNFSe('/total');
end;

procedure TNFSeW_Infisc.GerarCondicaoPagamento_v10;
var
  i: Integer;
begin
  if NFSe.CondicaoPagamento.Parcelas.Count > 0 then
  begin
    Gerador.wGrupoNFSe('cobr');
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count -1 do
    begin
      Gerador.wGrupoNFSe('dup');
      Gerador.wCampoNFSe(tcStr, '', 'nDup',  01,  9,  1, NFSe.CondicaoPagamento.Parcelas[i].Parcela, '');
      Gerador.wCampoNFSe(tcDat, '', 'dVenc', 01, 15,  1, NFSe.CondicaoPagamento.Parcelas[i].DataVencimento, DSC_DEMI);
      Gerador.wCampoNFSe(tcDe2, '', 'vDup',  01, 15,  1, NFSe.CondicaoPagamento.Parcelas[i].Valor, '');
      Gerador.wCampoNFSe(tcStr, '', 'bBol',  01,  1,  1, '2', '');
      Gerador.wGrupoNFSe('/dup');
    end;
    Gerador.wGrupoNFSe('/cobr');
  end;
end;

procedure TNFSeW_Infisc.GerarXML_Infisc_v10;
begin
  Gerador.Prefixo := '';

  Gerador.wGrupoNFSe('NFS-e');

  Gerador.wGrupoNFSe('infNFSe versao="1.00"');

  GerarIdentificacaoRPS_v10;
  GerarPrestador_v10;
  GerarTomador_v10;

  //Dados da Obra caso empreitada global seja constru��o (1)
  if EmpreitadaGlobalToStr(NFSe.EmpreitadaGlobal) = '1' then
    GerarConstrucaoCivil;

  GerarTransportadora;
  GerarListaServicos_v10;
  GerarValoresServico_v10;
  GerarCondicaoPagamento_v10;

  if Trim(NFSe.OutrasInformacoes) <> '' then
  begin
    Gerador.wGrupoNFSe('Observacoes');
    Gerador.wCampoNFSe(tcStr, '', 'xinf', 01, 100, 1, copy(NFSe.OutrasInformacoes, 1, 100), '');
    Gerador.wGrupoNFSe('/Observacoes');
  end;

  Gerador.wGrupoNFSe('/infNFSe');

  Gerador.wGrupoNFSe('/NFS-e');
end;

////////////////////////////////////////////////////////////////////////////////
// **************************** Vers�o 1.10
////////////////////////////////////////////////////////////////////////////////

procedure TNFSeW_Infisc.GerarIdentificacaoRPS_v11;
var
  sChave, cNFSe, serie, nNFSe:String;
begin
  sChave := NFSe.ChaveNFSe;
  serie  := NFSE.SeriePrestacao;
  nNFSe  := NFSe.Numero;
  cNFSe  := copy(sChave, 31, 9);

  Gerador.wGrupoNFSe('Id');
  Gerador.wCampoNFSe(tcStr, '', 'cNFS-e', 01, 09, 1, cNFSe, '');
  Gerador.wCampoNFSe(tcStr, '', 'mod'   , 01, 02, 1, NFSe.ModeloNFSe, '');  // segundo manual obrigat�rio ser 98
  Gerador.wCampoNFSe(tcStr, '', 'serie' , 01, 03, 1, serie, '');          // tem que ser S - ver como est� sendo passado a vari�vel "serie"
  Gerador.wCampoNFSe(tcStr, '', 'nNFS-e', 01, 09, 1, nNFSe, '');
  Gerador.wCampoNFSe(tcStr, '', 'dEmi'  , 01, 10, 1, FormatDateTime('yyyy-mm-dd',NFSe.DataEmissao), '');
  Gerador.wCampoNFSe(tcStr, '', 'hEmi'  , 01, 10, 1, FormatDateTime('hh:mm',NFSe.DataEmissao), '');
  Gerador.wCampoNFSe(tcStr, '', 'tpNF'  , 01, 01, 1, '1', '');     // 0- Entrada 1- Sa�da
  Gerador.wCampoNFSe(tcStr, '', 'refNF' , 01, 39, 1, sChave, ''); // chave de acesso 39 caracteres
  Gerador.wCampoNFSe(tcStr, '', 'tpEmis', 01, 01, 1, TipoEmissaoToStr(NFSe.TipoEmissao), ''); // N- Normal C- Contigencia

  Gerador.wCampoNFSe(tcStr, '', 'cancelada', 01, 01, 1, SimNaoInFiscToStr(NFSe.Cancelada), '');
  Gerador.wCampoNFSe(tcStr, '', 'canhoto'  , 01, 01, 1, TCanhotoToStr(NFSe.Canhoto), '');

  {para Garibaldi - RS 4308607 N�o existe as tags abaixo}
  if (NFSe.PrestadorServico.Endereco.CodigoMunicipio <> '4308607') then
  begin
    { Ambiente 1- Producao 2- Homologacao }
    Gerador.wCampoNFSe(tcStr, '', 'ambienteEmi'     , 01, 01, 1, SimNaoToStr(NFSe.Producao), '');
    { forma de emissao 1- portal contribuinte 2- servidor web 3- submetidos via Upload no portal 4- emissao via RPS }
    Gerador.wCampoNFSe(tcStr, '', 'formaEmi'        , 01, 01, 1, '2', '');
    { 1- construcao civil 2- outros casos }
    Gerador.wCampoNFSe(tcStr, '', 'empreitadaGlobal', 01, 01, 1, EmpreitadaGlobalToStr(NFSe.EmpreitadaGlobal), '');
  end;

  Gerador.wGrupoNFSe('/Id');
end;

procedure TNFSeW_Infisc.GerarPrestador_v11;
begin
  Gerador.wGrupoNFSe('prest');
  Gerador.wCampoNFSe(tcStr, '', 'CNPJ' , 01, 014, 1, NFSe.Prestador.Cnpj, '');
  Gerador.wCampoNFSe(tcStr, '', 'xNome', 01, 100, 1, NFSe.PrestadorServico.RazaoSocial, '');
  Gerador.wCampoNFSe(tcStr, '', 'xFant', 01, 60, 1, NFSe.PrestadorServico.NomeFantasia, '');
  Gerador.wCampoNFSe(tcStr, '', 'IM'   , 01, 015, 1, NFSe.Prestador.InscricaoMunicipal, '');
  Gerador.wCampoNFSe(tcStr, '', 'xEmail' , 01, 50, 1, NFSe.PrestadorServico.Contato.Email, '');

  Gerador.wGrupoNFSe('end');
  Gerador.wCampoNFSe(tcStr, '', 'xLgr'   , 01, 100, 1, NFSe.PrestadorServico.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nro'    , 01, 015, 1, NFSe.PrestadorServico.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'xBairro', 01, 100, 1, NFSe.PrestadorServico.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'cMun'   , 01, 007, 1, NFSe.PrestadorServico.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'xMun'   , 01, 060, 1, copy(CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio,0)),
                                                      0, pos('/',CodCidadeToCidade(StrToIntDef(NFSe.PrestadorServico.Endereco.CodigoMunicipio,0)))-1), '');
  Gerador.wCampoNFSe(tcStr, '', 'UF'     , 01, 002, 1, NFSe.PrestadorServico.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'CEP'    , 01, 008, 1, NFSe.PrestadorServico.Endereco.CEP, '');
  Gerador.wCampoNFSe(tcInt, '', 'cPais'  , 01, 100, 1, NFSe.PrestadorServico.Endereco.CodigoPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'xPais'  , 01, 100, 1, NFSe.PrestadorServico.Endereco.xPais, '');
  Gerador.wGrupoNFSe('/end');

  Gerador.wCampoNFSe(tcStr, '', 'fone'  , 01, 100, 1, NFSe.PrestadorServico.Contato.Telefone, '');
  Gerador.wCampoNFSe(tcStr, '', 'IE'    , 01, 015, 1, NFSe.Prestador.InscricaoEstadual, '');

  case Nfse.RegimeEspecialTributacao of
    retNenhum,
    retMicroempresaMunicipal,
    retEstimativa,
    retSociedadeProfissionais,
    retCooperativa,
    retMicroempresarioIndividual    : ; // N�o tem informa��o no manual
    retSimplesNacional              : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '1', ''); // 1 - Simples
    retMicroempresarioEmpresaPP     : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '2', ''); // 2 - SIMEI
    retLucroReal, retLucroPresumido : Gerador.wCampoNFSe(tcStr, '', 'regimeTrib', 01, 01, 1, '3', ''); // 3 - Normal
  end;

  Gerador.wGrupoNFSe('/prest');
end;

procedure TNFSeW_Infisc.GerarTomador_v11;
begin
  Gerador.wGrupoNFSe('TomS');

  if Length(NFSe.Tomador.IdentificacaoTomador.CpfCnpj) = 11 then
    Gerador.wCampoNFSe(tcStr, '', 'CPF', 01, 11, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '')
  else
    Gerador.wCampoNFSe(tcStr, '', 'CNPJ', 01, 14, 1, NFSe.Tomador.IdentificacaoTomador.CpfCnpj, '');

  Gerador.wCampoNFSe(tcStr, '', 'xNome', 01, 100, 1, NFSe.Tomador.RazaoSocial, '');

  Gerador.wGrupoNFSe('ender');
  Gerador.wCampoNFSe(tcStr, '', 'xLgr'   , 01, 100, 1, NFSe.Tomador.Endereco.Endereco, '');
  Gerador.wCampoNFSe(tcStr, '', 'nro'    , 01, 015, 1, NFSe.Tomador.Endereco.Numero, '');
  Gerador.wCampoNFSe(tcStr, '', 'xCpl'   , 01, 100, 1, NFSe.Tomador.Endereco.Complemento, '');
  Gerador.wCampoNFSe(tcStr, '', 'xBairro', 01, 100, 1, NFSe.Tomador.Endereco.Bairro, '');
  Gerador.wCampoNFSe(tcStr, '', 'cMun'   , 01, 007, 1, NFSe.Tomador.Endereco.CodigoMunicipio, '');
  Gerador.wCampoNFSe(tcStr, '', 'xMun'   , 01, 060, 1, copy(CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio,0)),
                                                           0, pos('/',CodCidadeToCidade(StrToIntDef(NFSe.Tomador.Endereco.CodigoMunicipio,0)))-1), '');
  Gerador.wCampoNFSe(tcStr, '', 'UF'     , 01, 002, 1, NFSe.Tomador.Endereco.UF, '');
  Gerador.wCampoNFSe(tcStr, '', 'CEP'    , 01, 008, 1, NFSe.Tomador.Endereco.CEP, '');
  Gerador.wCampoNFSe(tcInt, '', 'cPais'  , 01, 100, 1, NFSe.Tomador.Endereco.CodigoPais, '');
  Gerador.wCampoNFSe(tcStr, '', 'xPais'  , 01, 100, 1, NFSe.Tomador.Endereco.xPais, '');
  Gerador.wGrupoNFSe('/ender');

  Gerador.wCampoNFSe(tcStr, '', 'xEmail', 01, 100, 0, NFSe.Tomador.Contato.Email, '');
  Gerador.wCampoNFSe(tcStr, '', 'IE'    , 01, 015, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoEstadual, '');
  Gerador.wCampoNFSe(tcStr, '', 'IM'    , 01, 015, 1, NFSe.Tomador.IdentificacaoTomador.InscricaoMunicipal, '');
  Gerador.wCampoNFSe(tcStr, '', 'fone'  , 01, 100, 0, NFSe.Tomador.Contato.Telefone, '');

  Gerador.wGrupoNFSe('/TomS');
end;

procedure TNFSeW_Infisc.GerarListaServicos_v11;
var
  i, GeraTag: Integer;
  cServ, xServ: String;
begin
  FdTotBCISS := 0;
  FdTotISS   := 0;

  for i := 0 to NFSe.Servico.ItemServico.Count-1 do
  begin
    cServ := NFSe.Servico.ItemServico.Items[i].codServ; // cod. municipal
    xServ := NFSe.Servico.ItemServico.Items[i].Descricao;

    Gerador.wGrupoNFSe('det');
    Gerador.wCampoNFSe(tcStr, '', 'nItem', 01, 02, 1, IntToStr(i+1), '');

    Gerador.wGrupoNFSe('serv');
    Gerador.wCampoNFSe(tcStr, '', 'cServ'  , 01, 002, 1, cServ, '');  // C�digo municipal do servi�o, apenas n�meros
    Gerador.wCampoNFSe(tcStr, '', 'cLCServ', 01, 004, 1, NFSe.Servico.ItemServico.Items[i].codLCServ, ''); // C�digo do servi�o conforme lei compl. 116
    Gerador.wCampoNFSe(tcStr, '', 'xServ'  , 01, 120, 1, xServ, ''); // Discrimina��o do servi�o

    Gerador.wCampoNFSe(tcStr, '', 'localTributacao'  , 01, 04, 1, IntToStr(NFSe.Servico.MunicipioIncidencia), ''); // Local tributacao conforme codificacao do IBGE
    Gerador.wCampoNFSe(tcStr, '', 'localVerifResServ', 01, 04, 1, '1', ''); // Local da verificacao: 1 - Brasil 2 - Exterior

    Gerador.wCampoNFSe(tcStr, '', 'uTrib', 01, 06, 1, NFSe.Servico.ItemServico.Items[i].Unidade, '');       // unidade
    Gerador.wCampoNFSe(tcDe2, '', 'qTrib', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].Quantidade, '');    // quantidade
    Gerador.wCampoNFSe(tcDe2, '', 'vUnit', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorUnitario, ''); // formatacao com 2 casas

    // (valor unitario * quantidade) - desconto
    Gerador.wCampoNFSe(tcDe2, '', 'vServ', 01, 15, 0, NFSe.Servico.ItemServico.Items[i].ValorServicos, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vDesc', 01, 15, 0, NFSe.Servico.ItemServico.Items[i].DescontoIncondicionado, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vDed' , 01, 15, 0, NFSe.Servico.ItemServico.Items[i].vDed, '');

    if NFSe.Servico.Valores.IssRetido = stNormal then
    begin  // 1 - stRetencao ; 2 - stNormal ; 3 - stSubstituicao

      // Alterado de = para <> por Italo em 28/05/2019
      if Nfse.RegimeEspecialTributacao <> retSimplesNacional then
        GeraTag := 1
      else
        GeraTag := 0;

      Gerador.wCampoNFSe(tcDe2, '', 'vBCISS', 01, 15, GeraTag, NFSe.Servico.ItemServico.Items[i].BaseCalculo, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pISS'  , 01, 15, GeraTag, NFSe.Servico.ItemServico.Items[i].Aliquota, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vISS'  , 01, 15, GeraTag, NFSe.Servico.ItemServico.Items[i].ValorIss, '');

      FdTotBCISS := FdTotBCISS + NFSe.Servico.ItemServico.Items[i].BaseCalculo;
      FdTotISS   := FdTotISS   + NFSe.Servico.ItemServico.Items[i].ValorIss;
    end;

    // Reten��o INSS
    if NFSe.Servico.ItemServico.Items[i].ValorInss > 0 then
    begin
      Gerador.wCampoNFSe(tcDe2, '', 'vBCINSS ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].vBCINSS, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pRetINSS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].pRetINSS, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetINSS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorInss, '');
    end;

    Gerador.wCampoNFSe(tcDe2, '', 'vRed' , 01, 15, 0, NFSe.Servico.ItemServico.Items[i].vRed, '');

    // Reten��o IRRF
    if NFSe.Servico.ItemServico.Items[i].ValorIr > 0 then
    begin
      Gerador.wCampoNFSe(tcDe2, '', 'vBCRetIR', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].vBCRetIR, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pRetIR  ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].pRetIR, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetIR  ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorIr, '');
    end;

    // Reten��o COFINS
    if NFSe.Servico.ItemServico.Items[i].ValorCofins > 0 then
    begin
      Gerador.wCampoNFSe(tcDe2, '', 'vBCCOFINS ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].vBCCOFINS, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pRetCOFINS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].pRetCOFINS, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetCOFINS', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorCofins, '');
    end;

    // Reten��o CSLL
    if NFSe.Servico.ItemServico.Items[i].ValorCsll > 0 then
    begin
      Gerador.wCampoNFSe(tcDe2, '', 'vBCCSLL ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].vBCCSLL, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pRetCSLL', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].pRetCSLL, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetCSLL', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorCsll, '');
    end;

    // Reten��o PIS
    if NFSe.Servico.ItemServico.Items[i].ValorPis > 0 then
    begin
      Gerador.wCampoNFSe(tcDe2, '', 'vBCPISPASEP ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].vBCPISPASEP, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pRetPISPASEP', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].pRetPISPASEP, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vRetPISPASEP', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorPis, '');
    end;

    Gerador.wGrupoNFSe('/serv');

    // Reten��o ISSQN
    if NFSe.Servico.Valores.IssRetido = stRetencao then
    begin  // 1 - stRetencao ; 2 - stNormal ; 3 - stSubstituicao
      Gerador.wGrupoNFSe('ISSST');
      Gerador.wCampoNFSe(tcDe2, '', 'vBCST ', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorServicos, '');
      Gerador.wCampoNFSe(tcDe2, '', 'pISSST', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].AlicotaISSST, '');
      Gerador.wCampoNFSe(tcDe2, '', 'vISSST', 01, 15, 1, NFSe.Servico.ItemServico.Items[i].ValorISSST, '');
      Gerador.wGrupoNFSe('/ISSST');
    end;

    Gerador.wGrupoNFSe('/det');
  end;
end;

procedure TNFSeW_Infisc.GerarValoresServico_v11;
begin
  Gerador.wGrupoNFSe('total');
  Gerador.wCampoNFSe(tcDe2, '', 'vServ', 01, 15, 0, NFSe.Servico.Valores.ValorServicos, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vDesc', 01, 15, 0, NFSe.Servico.Valores.DescontoIncondicionado, '');
  Gerador.wCampoNFSe(tcDe2, '', 'vtNF' , 01, 15, 1,  NFSe.Servico.Valores.ValorServicos, '');

//    if NFSe.CondicaoPagamento.Parcelas.Count > 0 then
    Gerador.wCampoNFSe(tcDe2, '', 'vtLiq', 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');
//    else
//      Gerador.wCampoNFSe(tcDe2, '', 'vtLiq', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');

//  Gerador.wCampoNFSe(tcDe2, '', 'totalAproxTrib', 01, 15, 1, 0, '');

  // Total Reten��o IRRF
  if (NFSe.Servico.Valores.ValorIr + NFSe.Servico.Valores.ValorPis +
      NFSe.Servico.Valores.ValorCofins + NFSe.Servico.Valores.ValorCsll +
      NFSe.Servico.Valores.ValorInss) > 0 then
  begin
    Gerador.wGrupoNFSe('Ret');

    Gerador.wCampoNFSe(tcDe2, '', 'vRetIR', 01, 15, 0, NFSe.Servico.Valores.ValorIr, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vRetPISPASEP', 01, 15, 0, NFSe.Servico.Valores.ValorPis, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vRetCOFINS', 01, 15, 0, NFSe.Servico.Valores.ValorCofins, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vRetCSLL', 01, 15, 0, NFSe.Servico.Valores.ValorCsll, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vRetINSS', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
//    if NFSe.Servico.Valores.ValorInss > 0 then
//    begin
//      //Felipe N�o � necessario este valor
////      Gerador.wCampoNFSe(tcStr, '', 'xRetINSS', 01, 02, 1, 'Reten��o INSS', '');
//      Gerador.wCampoNFSe(tcDe2, '', 'vRetINSS', 01, 15, 1, NFSe.Servico.Valores.ValorInss, '');
//    end;

    Gerador.wGrupoNFSe('/Ret');
  end;

  if NFSe.CondicaoPagamento.Parcelas.Count > 0 then
    Gerador.wCampoNFSe(tcDe2, '', 'vtLiqFaturas', 01, 15, 1, NFSe.Servico.Valores.ValorLiquidoNfse, '');

  if NFSe.Servico.Valores.ValorDespesasNaoTributaveis > 0 then
    Gerador.wCampoNFSe(tcDe2, '', 'vtDespesas', 01, 15, 1, NFSe.Servico.Valores.ValorDespesasNaoTributaveis, '');

  // Total Reten��o ISSQN
  if NFSe.Servico.Valores.IssRetido = stRetencao then
  begin  // 1 - stRetencao
    Gerador.wGrupoNFSe('ISS');
    Gerador.wCampoNFSe(tcDe2, '', 'vBCSTISS', 01, 15, 1, NFSe.Servico.Valores.ValorServicos, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vSTISS'  , 01, 15, 1, NFSe.Servico.Valores.ValorIssRetido, '');
    Gerador.wGrupoNFSe('/ISS');
  end;

  if NFSe.Servico.Valores.IssRetido = stNormal then
  begin  // 2 - stNormal
    Gerador.wGrupoNFSe('ISS');
    Gerador.wCampoNFSe(tcDe2, '', 'vBCISS', 01, 15, 0, FdTotBCISS, '');
    Gerador.wCampoNFSe(tcDe2, '', 'vISS'  , 01, 15, 0, FdTotISS, '');
    Gerador.wGrupoNFSe('/ISS');
  end;

  Gerador.wGrupoNFSe('/total');
end;

procedure TNFSeW_Infisc.GerarCondicaoPagamento_v11;
var
  i: Integer;
begin
  if NFSe.CondicaoPagamento.Parcelas.Count > 0 then
  begin
    Gerador.wGrupoNFSe('faturas');
    for i := 0 to NFSe.CondicaoPagamento.Parcelas.Count -1 do
    begin
      Gerador.wGrupoNFSe('fat');
      Gerador.wCampoNFSe(tcStr, '', 'nItem', 01, 15,  1, IntToStr(i+1), '');
      Gerador.wCampoNFSe(tcStr, '', 'nFat',  01, 15,  1, NFSe.CondicaoPagamento.Parcelas[i].Parcela, '');
      Gerador.wCampoNFSe(tcDat, '', 'dVenc', 01, 15,  1, NFSe.CondicaoPagamento.Parcelas[i].DataVencimento, DSC_DEMI);
      Gerador.wCampoNFSe(tcDe2, '', 'vFat',  01, 15,  1, NFSe.CondicaoPagamento.Parcelas[i].Valor, '');
      Gerador.wGrupoNFSe('/fat');
    end;
    Gerador.wGrupoNFSe('/faturas');
  end;
end;

procedure TNFSeW_Infisc.GerarXML_Infisc_v11;
var
  lLimiteLinha: Integer;
  lDeOndeIniciaCopia: Integer;
  lTexto: String;
  lNumeroCaracteres: Integer;
  lResultadoDivisao: Word;
  lResultadoSobra: Word;
  lIndex: Integer;
begin
  Gerador.Prefixo := '';

  Gerador.wGrupoNFSe('NFS-e');

  Gerador.wGrupoNFSe('infNFSe versao="1.1"');

  GerarIdentificacaoRPS_v11;
  GerarPrestador_v11;
  GerarTomador_v11;

  //Dados da Obra caso empreitada global seja constru��o (1)
  if EmpreitadaGlobalToStr(NFSe.EmpreitadaGlobal) = '1' then
    GerarConstrucaoCivil;

  GerarTransportadora;
  GerarListaServicos_v11;
  GerarDespesasAdicionaisNaoTributaveis;
  GerarValoresServico_v11;
  GerarCondicaoPagamento_v11;

  // - Felipe Mesturini
  //Quando � tributado fora do municipio temos que ter o IBGE o mesmo do localdeTributa��o do Servi�o
  Gerador.wCampoNFSe(tcStr, '', 'infAdicLT', 01, 100,  1, NFSe.Servico.MunicipioIncidencia, '');

  lIndex := 0;
  lLimiteLinha := 250;
  lDeOndeIniciaCopia := 1;
  lTexto := NFSe.OutrasInformacoes;
  lNumeroCaracteres := Length(lTexto);

  lResultadoDivisao := lNumeroCaracteres div lLimiteLinha;
  lResultadoSobra := lNumeroCaracteres mod lLimiteLinha;

  if (lResultadoDivisao > 0) then
  begin
    repeat
      lDeOndeIniciaCopia := lIndex * lLimiteLinha;
      Gerador.wCampoNFSe(tcStr, '', 'infAdic', 01, 100, 1, Copy(lTexto, lDeOndeIniciaCopia, lLimiteLinha), '');
      inc(lIndex);
    until lIndex > (lResultadoDivisao -1);

    lDeOndeIniciaCopia := (lIndex * lLimiteLinha);
  end;
  if (lResultadoSobra > 0) and (lDeOndeIniciaCopia > 0) then
    Gerador.wCampoNFSe(tcStr, '', 'infAdic', 01, 100, 1, Copy(lTexto, lIndex * lLimiteLinha, lLimiteLinha), '');

  Gerador.wGrupoNFSe('/infNFSe');

  Gerador.wGrupoNFSe('/NFS-e');
end;

////////////////////////////////////////////////////////////////////////////////
// **************************** Ambas Vers�es
////////////////////////////////////////////////////////////////////////////////

procedure TNFSeW_Infisc.GerarTransportadora;
begin
  if NFSe.Transportadora.xCpfCnpjTrans <> '' then
  begin
    Gerador.wGrupoNFSe('transportadora');

    Gerador.wCampoNFSe(tcStr, '', 'xNomeTrans'   , 01, 100, 1, NFSe.Transportadora.xNomeTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xCpfCnpjTrans', 01, 014, 1, NFSe.Transportadora.xCpfCnpjTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xInscEstTrans', 01, 015, 1, NFSe.Transportadora.xInscEstTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xPlacaTrans'  , 01, 007, 1, NFSe.Transportadora.xPlacaTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xEndTrans'    , 01, 100, 1, NFSe.Transportadora.xEndTrans, '');
    Gerador.wCampoNFSe(tcInt, '', 'cMunTrans'    , 01, 007, 1, NFSe.Transportadora.cMunTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xMunTrans'    , 01, 060, 1, NFSe.Transportadora.xMunTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xUfTrans'     , 01, 002, 1, NFSe.Transportadora.xUFTrans, '');
    Gerador.wCampoNFSe(tcInt, '', 'cPaisTrans'   , 01, 004, 1, NFSe.Transportadora.cPaisTrans, '');
    Gerador.wCampoNFSe(tcStr, '', 'xPaisTrans'   , 01, 100, 1, NFSe.Transportadora.xPaisTrans, '');

    Gerador.wCampoNFSe(tcInt, '', 'vTipoFreteTrans', 01, 01, 1, TipoFreteToStr(NFSe.Transportadora.vTipoFreteTrans), '');

    Gerador.wGrupoNFSe('/transportadora');
  end;
end;

procedure TNFSeW_Infisc.GerarConstrucaoCivil;
begin
  Gerador.wGrupoNFSe('dadosDaObra');
  Gerador.wCampoNFSe(tcStr, '', 'xLogObra',    01, 100, 1, NFSe.ConstrucaoCivil.LogradouroObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'xComplObra',  01, 100, 1, NFSe.ConstrucaoCivil.ComplementoObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'vNumeroObra', 01,  06, 1, NFSe.ConstrucaoCivil.NumeroObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'xBairroObra', 01, 100, 1, NFSe.ConstrucaoCivil.BairroObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'xCepObra',    01,  08, 1, NFSe.ConstrucaoCivil.CEPObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'cCidadeObra', 01,  07, 1, NFSe.ConstrucaoCivil.CodigoMunicipioObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'xCidadeObra', 01,  60, 1, copy(CodCidadeToCidade(StrToIntDef(NFSe.ConstrucaoCivil.CodigoMunicipioObra,0)),
                                                           0, pos('/',CodCidadeToCidade(StrToIntDef(NFSe.ConstrucaoCivil.CodigoMunicipioObra,0)))-1), '');
  Gerador.wCampoNFSe(tcStr, '', 'xUfObra',     01,  02, 1, NFSe.ConstrucaoCivil.UFObra, '');
  Gerador.wCampoNFSe(tcInt, '', 'cPaisObra',   01, 100, 1, NFSe.ConstrucaoCivil.CodigoPaisObra, '');
  Gerador.wCampoNFSe(tcStr, '', 'xPaisObra',   01, 100, 1, NFSe.ConstrucaoCivil.xPaisObra, '');
  // Campos opcionais
  Gerador.wCampoNFSe(tcStr, '', 'numeroArt',   01,  12, 0, NFSe.ConstrucaoCivil.Art,    ''); //num. ART 12 digitos
  Gerador.wCampoNFSe(tcStr, '', 'numeroCei',   01,  12, 0, NFSe.ConstrucaoCivil.nCei,   ''); //num. CEI 12 digitos
  Gerador.wCampoNFSe(tcStr, '', 'numeroProj',  01,  15, 0, NFSe.ConstrucaoCivil.nProj,  ''); //num. projeto
  Gerador.wCampoNFSe(tcStr, '', 'numeroMatri', 01,  15, 0, NFSe.ConstrucaoCivil.nMatri, ''); //num. matricula
  Gerador.wGrupoNFSe('/dadosDaObra');
end;

procedure TNFSeW_Infisc.GerarDespesasAdicionaisNaoTributaveis;
var
  lItem: Integer;
  lItemDepesa: TDespesaCollectionItem;
begin
  //Cria��o de despesas adicionais n�o tributaveis
  {Usado para inclus�o de servi�os que n�o s�o tributaveis e agregam valor no total da nota}
  if NFSe.Despesa.Count > 0 then
  begin
    Gerador.wGrupoNFSe('despesas');
    for lItem := 0 to Pred(NFSe.Despesa.Count) do
    begin
      lItemDepesa := NFSe.Despesa.Items[lItem];
      Gerador.wGrupoNFSe('despesa');
      Gerador.wCampoNFSe(tcStr, '', 'nItemDesp',    01, 100, 1, lItemDepesa.nItemDesp, '');
      Gerador.wCampoNFSe(tcStr, '', 'xDesp',  01, 100, 1, lItemDepesa.xDesp, '');
      Gerador.wCampoNFSe(tcDat, '', 'dDesp', 01, 15,  1, lItemDepesa.dDesp, DSC_DEMI);
      Gerador.wCampoNFSe(tcDe2, '', 'vDesp',  01, 15,  1, lItemDepesa.vDesp, '');
      Gerador.wGrupoNFSe('/despesa');
    end;
    Gerador.wGrupoNFSe('/despesas');
  end;
end;

end.
