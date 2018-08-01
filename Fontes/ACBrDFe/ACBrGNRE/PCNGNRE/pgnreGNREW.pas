{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{******************************************************************************
|* Historico
|*
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}

{$I ACBr.inc}

unit pgnreGNREW;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnGerador, pcnConsts,
  pgnreGNRE, pgnreConversao;

type
  TGNREW = class(TPersistent)
  private
    FGerador: TGerador;
    FGNRE: TGNRE;
  public
    constructor Create(AOwner: TGNRE);
    destructor Destroy; override;
    function GerarXml: boolean;
    function ObterNomeArquivo: string;
  published
    property Gerador: TGerador read FGerador write FGerador;
    property GNRE: TGNRE read FGNRE write FGNRE;
  end;

implementation

{ TGNREW }

constructor TGNREW.Create(AOwner: TGNRE);
begin
  FGNRE    := AOwner;
  FGerador := TGerador.Create;
end;

destructor TGNREW.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TGNREW.GerarXml: boolean;
var
  i  : Integer;
  Doc: string;
begin
  Gerador.ListaDeAlertas.Clear;
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('TDadosGNRE');
  Gerador.wCampo(tcStr, '', 'c01_UfFavorecida  ', 002, 002, 1, GNRE.c01_UfFavorecida, DSC_UF + ' Favorecida');
  Gerador.wCampo(tcInt, '', 'c02_receita   ', 006, 006, 1, GNRE.c02_receita, '');
  if GNRE.c25_detalhamentoReceita > 0 then
    Gerador.wCampo(tcInt, '', 'c25_detalhamentoReceita   ', 006, 006, 1, GNRE.c25_detalhamentoReceita, '');

  if GNRE.c26_produto > 0 then
    Gerador.wCampo(tcInt, '', 'c26_produto   ', 001, 004, 1, GNRE.c26_produto, '');

  if GNRE.c27_tipoIdentificacaoEmitente > 0 then
    Gerador.wCampo(tcInt, '', 'c27_tipoIdentificacaoEmitente   ', 001, 001, 1, GNRE.c27_tipoIdentificacaoEmitente, '');

  if GNRE.c03_idContribuinteEmitente <> '' then
  begin
    Gerador.wGrupo('c03_idContribuinteEmitente');
    if GNRE.c27_tipoIdentificacaoEmitente = 1 then
    begin
      Doc := GNRE.c03_idContribuinteEmitente;
      Doc := StringReplace(Doc, '<CNPJ>', '', [rfReplaceAll]);
      Doc := StringReplace(Doc, '</CNPJ>', '', [rfReplaceAll]);
      if not ValidarCNPJ(Doc) then
        Gerador.wAlerta('', 'CNPJ', DSC_CNPJ + ' Emitente', ERR_MSG_INVALIDO);

     // Gerador.wGrupo('CNPJ');
      Gerador.wCampo(tcStr, '', 'CNPJ   ', 014, 014, 1, GNRE.c03_idContribuinteEmitente, DSC_CNPJ + ' Emitente');
     // Gerador.wGrupo('/CNPJ');
    end
    else
    begin
      Doc := GNRE.c03_idContribuinteEmitente;
      Doc := StringReplace(Doc, '<CPF>', '', [rfReplaceAll]);
      Doc := StringReplace(Doc, '</CPF>', '', [rfReplaceAll]);
      if not ValidarCPF(Doc) then
        Gerador.wAlerta('', 'CPF', DSC_CPF + ' Emitente', ERR_MSG_INVALIDO);

     // Gerador.wGrupo('CPF');
      Gerador.wCampo(tcStr, '', 'CPF   ', 011, 011, 1, GNRE.c03_idContribuinteEmitente, DSC_CPF + ' Emitente');
     // Gerador.wGrupo('/CPF');
    end;
    Gerador.wGrupo('/c03_idContribuinteEmitente');
  end;

  if GNRE.c28_tipoDocOrigem > 0 then
    Gerador.wCampo(tcInt, '', 'c28_tipoDocOrigem   ', 002, 002, 1, GNRE.c28_tipoDocOrigem, '');

  if GNRE.c04_docOrigem <> '' then
    Gerador.wCampo(tcStr, '', 'c04_docOrigem   ', 001, 018, 1, GNRE.c04_docOrigem, '');

  if GNRE.c06_valorPrincipal > 0 then
    Gerador.wCampo(tcDe2, '', 'c06_valorPrincipal   ', 001, 015, 1, GNRE.c06_valorPrincipal, '');

  if GNRE.c10_valorTotal > 0 then
    Gerador.wCampo(tcDe2, '', 'c10_valorTotal   ', 001, 015, 1, GNRE.c10_valorTotal, '');

  Gerador.wCampo(tcDat, '', 'c14_dataVencimento   ', 010, 010, 1, GNRE.c14_dataVencimento, '');

  if GNRE.c15_convenio <> '' then
    Gerador.wCampo(tcStr, '', 'c15_convenio   ', 001, 030, 1, GNRE.c15_convenio, '');

  if GNRE.c16_razaoSocialEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c16_razaoSocialEmitente   ', 001, 060, 1, GNRE.c16_razaoSocialEmitente, '');

  if GNRE.c17_inscricaoEstadualEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c17_inscricaoEstadualEmitente   ', 002, 016, 1, GNRE.c17_inscricaoEstadualEmitente, DSC_IE + ' Emitente');

  if GNRE.c18_enderecoEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c18_enderecoEmitente   ', 001, 060, 1, GNRE.c18_enderecoEmitente, '');

  if GNRE.c19_municipioEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c19_municipioEmitente   ', 001, 005, 1, GNRE.c19_municipioEmitente, DSC_CMUN + ' Emitente');

  if GNRE.c20_ufEnderecoEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c20_ufEnderecoEmitente   ', 002, 002, 1, GNRE.c20_ufEnderecoEmitente, DSC_UF + ' Emitente');

  if GNRE.c21_cepEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c21_cepEmitente   ', 008, 008, 1, GNRE.c21_cepEmitente, DSC_CEP + ' Emitente');

  if GNRE.c22_telefoneEmitente <> '' then
    Gerador.wCampo(tcStr, '', 'c22_telefoneEmitente   ', 006, 011, 1, GNRE.c22_telefoneEmitente, DSC_FONE + ' Emitente');

  if GNRE.c34_tipoIdentificacaoDestinatario > 0 then
    Gerador.wCampo(tcInt, '', 'c34_tipoIdentificacaoDestinatario   ', 001, 001, 1, GNRE.c34_tipoIdentificacaoDestinatario, '');

  if GNRE.c35_idContribuinteDestinatario <> '' then
  begin
    Gerador.wGrupo('c35_idContribuinteDestinatario');
    if GNRE.c34_tipoIdentificacaoDestinatario = 1 then
    begin
      Doc := GNRE.c35_idContribuinteDestinatario;
      Doc := StringReplace(Doc, '<CNPJ>', '', [rfReplaceAll]);
      Doc := StringReplace(Doc, '</CNPJ>', '', [rfReplaceAll]);
      if not ValidarCNPJ(Doc) then
        Gerador.wAlerta('', 'CNPJ', DSC_CNPJ + ' Destinat�rio', ERR_MSG_INVALIDO);

     // Gerador.wGrupo('CNPJ');
      Gerador.wCampo(tcStr, '', 'CNPJ   ', 014, 014, 1, GNRE.c35_idContribuinteDestinatario, DSC_CNPJ + ' Destinat�rio');
      //Gerador.wGrupo('/CNPJ');
    end
    else
    begin
      Doc := GNRE.c35_idContribuinteDestinatario;
      Doc := StringReplace(Doc, '<CPF>', '', [rfReplaceAll]);
      Doc := StringReplace(Doc, '</CPF>', '', [rfReplaceAll]);
      if not ValidarCPF(Doc) then
        Gerador.wAlerta('', 'CPF', DSC_CPF + ' Destinat�rio', ERR_MSG_INVALIDO);

     // Gerador.wGrupo('CPF');
      Gerador.wCampo(tcStr, '', 'CPF   ', 011, 011, 1, GNRE.c35_idContribuinteDestinatario, DSC_CPF + ' Destinat�rio');
      //Gerador.wGrupo('/CPF');
    end;
    Gerador.wGrupo('/c35_idContribuinteDestinatario');
  end;

  if GNRE.c36_inscricaoEstadualDestinatario <> '' then
    Gerador.wCampo(tcStr, '', 'c36_inscricaoEstadualDestinatario   ', 002, 016, 1, GNRE.c36_inscricaoEstadualDestinatario, DSC_IE + ' Destinat�rio');

  if GNRE.c37_razaoSocialDestinatario <> '' then
    Gerador.wCampo(tcStr, '', 'c37_razaoSocialDestinatario   ', 001, 060, 1, GNRE.c37_razaoSocialDestinatario, DSC_XNOME + ' Destinat�rio');

  if GNRE.c38_municipioDestinatario <> '' then
    Gerador.wCampo(tcStr, '', 'c38_municipioDestinatario   ', 001, 005, 1, GNRE.c38_municipioDestinatario, DSC_CMUN + ' Destinat�rio');

  Gerador.wCampo(tcDat, '', 'c33_dataPagamento   ', 010, 010, 1, GNRE.c33_dataPagamento, '');

  if (GNRE.referencia.periodo >= 0) or (GNRE.referencia.mes <> '') or (GNRE.referencia.ano > 0) or
    (GNRE.referencia.parcela > 0) then
  begin
    Gerador.wGrupo('c05_referencia');
    if GNRE.referencia.periodo >= 0 then
      Gerador.wCampo(tcInt, '', 'periodo   ', 001, 001, 1, GNRE.referencia.periodo, '');

    if GNRE.referencia.mes <> '' then
      Gerador.wCampo(tcInt, '', 'mes   ', 002, 002, 1, GNRE.referencia.mes, '');

    if GNRE.referencia.ano > 0 then
      Gerador.wCampo(tcInt, '', 'ano   ', 004, 004, 1, GNRE.referencia.ano, '');

    if GNRE.referencia.parcela > 0 then
      Gerador.wCampo(tcInt, '', 'parcela   ', 001, 003, 1, GNRE.referencia.parcela, '');
    Gerador.wGrupo('/c05_referencia');
  end;

  if GNRE.camposExtras.Count > 0 then
  begin
    Gerador.wGrupo('c39_camposExtras');
    for i := 0 to GNRE.camposExtras.Count - 1 do
    begin
      Gerador.wGrupo('campoExtra');
      Gerador.wCampo(tcInt, '', 'codigo   ', 001, 003, 1, GNRE.camposExtras.Items[i].CampoExtra.codigo, '');
      Gerador.wCampo(tcStr, '', 'tipo   ', 001, 001, 1, GNRE.camposExtras.Items[i].CampoExtra.tipo, '');
      Gerador.wCampo(tcStr, '', 'valor   ', 001, 100, 1, GNRE.camposExtras.Items[i].CampoExtra.valor, '');
      Gerador.wGrupo('/campoExtra');
    end;
    Gerador.wGrupo('/c39_camposExtras');
  end;

  if GNRE.c42_identificadorGuia <> '' then
    Gerador.wCampo(tcStr, '', 'c42_identificadorGuia   ', 001, 010, 1, GNRE.c42_identificadorGuia, '');
  Gerador.wGrupo('/TDadosGNRE');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

function TGNREW.ObterNomeArquivo: string;
begin
  Result := '';
end;

end.
