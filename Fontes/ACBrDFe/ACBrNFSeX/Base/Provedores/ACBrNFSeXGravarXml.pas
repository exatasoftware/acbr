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

unit ACBrNFSeXGravarXml;

interface

uses
{$IFDEF FPC}
  LResources, Controls, Graphics, Dialogs,
{$ENDIF}
  SysUtils, Classes, StrUtils,
  ACBrUtil,
  ACBrDFeException,
  ACBrXmlBase, ACBrXmlDocument, ACBrXmlWriter, ACBrNFSeXInterface,
  ACBrNFSeXParametros, ACBrNFSeXClass, ACBrNFSeXConversao;

type

  TXmlWriterOptions = class(TACBrXmlWriterOptions)
  private
    FAjustarTagNro: boolean;
    FNormatizarMunicipios: boolean;
    FGerarTagAssinatura: TACBrTagAssinatura;
    FPathArquivoMunicipios: string;
    FValidarInscricoes: boolean;
    FValidarListaServicos: boolean;

  public
    property AjustarTagNro: boolean read FAjustarTagNro write FAjustarTagNro;
    property NormatizarMunicipios: boolean read FNormatizarMunicipios write FNormatizarMunicipios;
    property GerarTagAssinatura: TACBrTagAssinatura read FGerarTagAssinatura write FGerarTagAssinatura;
    property PathArquivoMunicipios: string read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property ValidarInscricoes: boolean read FValidarInscricoes write FValidarInscricoes;
    property ValidarListaServicos: boolean read FValidarListaServicos write FValidarListaServicos;

  end;

  TNFSeWClass = class(TACBrXmlWriter)
  private
    FNFSe: TNFSe;

    FVersaoNFSe: TVersaoNFSe;
    FAmbiente: TACBrTipoAmbiente;
    FCodMunEmit: Integer;
    FUsuario: string;
    FSenha: string;
    FMunicipio: string;
    FChaveAcesso: string;
    FChaveAutoriz: string;
    FFraseSecreta: string;
    FCNPJPrefeitura: string;

    FFormatoEmissao: TACBrTipoCampo;
    FFormatoCompetencia: TACBrTipoCampo;

    FFormatoAliq: TACBrTipoCampo;
    FDivAliq100: Boolean;

    FNrMinExigISS: Integer;
    FNrMaxExigISS: Integer;

    FNrOcorrItemListaServico: Integer;

    FGerarIDRps: Boolean;

    function GetOpcoes: TACBrXmlWriterOptions;
    procedure SetOpcoes(AValue: TACBrXmlWriterOptions);

  protected
    FAOwner: IACBrNFSeXProvider;

    function CreateOptions: TACBrXmlWriterOptions; override;

    procedure Configuracao; virtual;

    procedure DefinirIDRps; virtual;
    procedure DefinirIDDeclaracao; virtual;

    function GerarCNPJ(const CNPJ: string): TACBrXmlNode; virtual;
    function GerarCPFCNPJ(const CPFCNPJ: string): TACBrXmlNode; virtual;

 public
    constructor Create(AOwner: IACBrNFSeXProvider); virtual;

    function ObterNomeArquivo: String; Override;
    function GerarXml: Boolean; Override;

    property Opcoes: TACBrXmlWriterOptions read GetOpcoes write SetOpcoes;

    property NFSe: TNFSe                 read FNFSe           write FNFSe;
    property VersaoNFSe: TVersaoNFSe     read FVersaoNFSe     write FVersaoNFSe;
    property Ambiente: TACBrTipoAmbiente read FAmbiente       write FAmbiente default taHomologacao;
    property CodMunEmit: Integer         read FCodMunEmit     write FCodMunEmit;
    property Usuario: string             read FUsuario        write FUsuario;
    property Senha: string               read FSenha          write FSenha;
    property Municipio: string           read FMunicipio      write FMunicipio;
    property ChaveAcesso: string         read FChaveAcesso    write FChaveAcesso;
    property ChaveAutoriz: string        read FChaveAutoriz   write FChaveAutoriz;
    property FraseSecreta: string        read FFraseSecreta   write FFraseSecreta;
    property CNPJPrefeitura: string      read FCNPJPrefeitura write FCNPJPrefeitura;

    property FormatoEmissao: TACBrTipoCampo     read FFormatoEmissao     write FFormatoEmissao;
    property FormatoCompetencia: TACBrTipoCampo read FFormatoCompetencia write FFormatoCompetencia;

    property FormatoAliq: TACBrTipoCampo read FFormatoAliq  write FFormatoAliq;
    property DivAliq100: Boolean         read FDivAliq100   write FDivAliq100;
    property NrMinExigISS: Integer       read FNrMinExigISS write FNrMinExigISS;
    property NrMaxExigISS: Integer       read FNrMaxExigISS write FNrMaxExigISS;

    property NrOcorrItemListaServico: Integer read FNrOcorrItemListaServico write FNrOcorrItemListaServico;

    property GerarIDRps: Boolean read FGerarIDRps write FGerarIDRps;
  end;

implementation

{ TNFSeWClass }

constructor TNFSeWClass.Create(AOwner: IACBrNFSeXProvider);
begin
  inherited Create;

  FAOwner := AOwner;

  TXmlWriterOptions(Opcoes).AjustarTagNro := True;
  TXmlWriterOptions(Opcoes).NormatizarMunicipios := False;
  TXmlWriterOptions(Opcoes).PathArquivoMunicipios := '';
  TXmlWriterOptions(Opcoes).ValidarInscricoes := False;
  TXmlWriterOptions(Opcoes).ValidarListaServicos := False;

  Configuracao;
end;

procedure TNFSeWClass.Configuracao;
begin
  // Propriedades de Formata��o de informa��es
  FFormatoEmissao     := tcDatHor;
  FFormatoCompetencia := tcDatHor;

  FFormatoAliq := tcDe4;
  FDivAliq100  := False;

  FNrMinExigISS := 1;
  FNrMaxExigISS := 1;

  FNrOcorrItemListaServico := 1;

  FGerarIDRps := False;
end;

procedure TNFSeWClass.DefinirIDRps;
begin
  FNFSe.InfID.ID := 'Rps_' + OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                    FNFSe.IdentificacaoRps.Serie;
end;

procedure TNFSeWClass.DefinirIDDeclaracao;
begin
  FNFSe.InfID.ID := 'Dec_' + OnlyNumber(FNFSe.IdentificacaoRps.Numero) +
                    FNFSe.IdentificacaoRps.Serie;
end;

function TNFSeWClass.CreateOptions: TACBrXmlWriterOptions;
begin
  Result := TXmlWriterOptions.Create();
end;

function TNFSeWClass.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(NFSe.infID.ID) + '.xml';
end;

function TNFSeWClass.GetOpcoes: TACBrXmlWriterOptions;
begin
  Result := TXmlWriterOptions(FOpcoes);
end;

procedure TNFSeWClass.SetOpcoes(AValue: TACBrXmlWriterOptions);
begin
  FOpcoes := AValue;
end;

function TNFSeWClass.GerarCNPJ(const CNPJ: string): TACBrXmlNode;
begin
  Result := AddNode(tcStr, '#34', 'Cnpj', 14, 14, 1, OnlyNumber(CNPJ), DSC_CNPJ);
end;

function TNFSeWClass.GerarCPFCNPJ(const CPFCNPJ: string): TACBrXmlNode;
var
  aDoc: string;
begin
  // Em conformidade com a vers�o 1 do layout da ABRASF n�o deve ser alterado
  aDoc := OnlyNumber(CPFCNPJ);

  Result := CreateElement('CpfCnpj');

  if length(aDoc) <= 11 then
    Result.AppendChild(AddNode(tcStr, '#34', 'Cpf ', 11, 11, 1, aDoc, DSC_CPF))
  else
    Result.AppendChild(AddNode(tcStr, '#34', 'Cnpj', 14, 14, 1, aDoc, DSC_CNPJ));
end;

function TNFSeWClass.GerarXml: Boolean;
begin
  Result := False;
  raise EACBrDFeException.Create(ClassName + '.GerarXml, n�o implementado');
end;

end.
