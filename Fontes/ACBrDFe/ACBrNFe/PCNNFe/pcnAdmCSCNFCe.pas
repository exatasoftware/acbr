{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{																			   }
{ Colaboradores neste arquivo: Italo Jurisato Junior                           }
{																			   }
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

unit pcnAdmCSCNFCe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador;

type

  TAdmCSCNFCe = class(TObject)
  private
    FGerador: TGerador;
    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FindOP: TpcnIndOperacao;
    FraizCNPJ: String;
    FidCsc: Integer;
    FcodigoCsc: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;
    function ObterNomeArquivo: String;
    property Gerador: TGerador       read FGerador   write FGerador;
    property Versao: String          read FVersao    write FVersao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb     write FtpAmb;
    property indOP: TpcnIndOperacao  read FindOP     write FindOP;
    property raizCNPJ: String        read FraizCNPJ  write FraizCNPJ;
    property idCsc: Integer          read FidCsc     write FidCsc;
    property codigoCsc: String       read FcodigoCsc write FcodigoCsc;
  end;

const
  DSC_INDOP    = 'Indicador de Opera��o';
  DSC_RAIZCNPJ = 'Raiz do CNPJ';
  DSC_IDCSC    = 'Identificador do CSC';
  DSC_CODCSC   = 'C�digo do CSC';

implementation

Uses pcnAuxiliar;

{ TAdmCSCNFCe }

constructor TAdmCSCNFCe.Create;
begin
  inherited Create;
  FGerador := TGerador.Create;
end;

destructor TAdmCSCNFCe.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TAdmCSCNFCe.ObterNomeArquivo: String;
var
  DataHora: TDateTime;
  Year, Month, Day, Hour, Min, Sec, Milli: Word;
  AAAAMMDDTHHMMSS: String;
begin
  Datahora:=now;
  DecodeTime(DataHora, Hour, Min, Sec, Milli);
  DecodeDate(DataHora, Year, Month, Day);
  AAAAMMDDTHHMMSS := IntToStrZero(Year, 4) + IntToStrZero(Month, 2) + IntToStrZero(Day, 2) +
    IntToStrZero(Hour, 2) + IntToStrZero(Min, 2) + IntToStrZero(Sec, 2);
  Result := AAAAMMDDTHHMMSS + '-ped-csc.xml';
end;

function TAdmCSCNFCe.GerarXML: boolean;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('admCscNFCe ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wCampo(tcStr, 'AP03', 'tpAmb   ', 01, 01, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'AP04', 'indOp   ', 01, 01, 1, IndOperacaoToStr(FindOp), DSC_INDOP);
  Gerador.wCampo(tcStr, 'AP05', 'raizCNPJ', 08, 08, 1, FraizCNPJ, DSC_RAIZCNPJ);

  if FindOp = ioRevogaCSC then
  begin
    Gerador.wGrupo('dadosCsc');
    Gerador.wCampo(tcStr, 'AP07', 'idCsc    ', 06, 06, 1, FormatFloat('000000', FidCsc), DSC_IDCSC);
    Gerador.wCampo(tcStr, 'AP08', 'codigoCsc', 16, 16, 1, FcodigoCsc, DSC_CODCSC);
    Gerador.wGrupo('/dadosCsc');
  end;

  Gerador.wGrupo('/admCscNFCe');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

