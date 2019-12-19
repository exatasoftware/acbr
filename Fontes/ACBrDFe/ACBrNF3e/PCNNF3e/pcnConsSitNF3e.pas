{******************************************************************************}
{ Projeto: Componente ACBrNF3e                                                 }
{  Nota Fiscal de Energia Eletrica Eletr�nica - NF3e                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2019                                        }
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

{*******************************************************************************
|* Historico
|*
|* 18/12/2019: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnConsSitNF3e;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador, pcnConsts, pcnNF3eConsts;

type

  TConsSitNF3e = class
  private
    FGerador: TGerador;
    FtpAmb: TpcnTipoAmbiente;
    FchNF3e: String;
    FVersao: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function ObterNomeArquivo: String;

    property Gerador: TGerador       read FGerador write FGerador;
    property tpAmb: TpcnTipoAmbiente read FtpAmb   write FtpAmb;
    property chNF3e: String          read FchNF3e  write FchNF3e;
    property Versao: String          read FVersao  write FVersao;
  end;

implementation

uses
  ACBrUtil;

{ TConsSitNF3e }

constructor TConsSitNF3e.Create;
begin
  inherited Create;

  FGerador := TGerador.Create;
end;

destructor TConsSitNF3e.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TConsSitNF3e.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(FchNF3e) + '-ped-sit.xml';
end;

function TConsSitNF3e.GerarXML: Boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('consSitNF3e ' + NAME_SPACE_NF3e + ' versao="' + Versao + '"');
  Gerador.wCampo(tcStr, 'EP03', 'tpAmb', 001, 001, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'EP04', 'xServ', 009, 009, 1, 'CONSULTAR', DSC_XSERV);
  Gerador.wCampo(tcEsp, 'EP05', 'chNF3e', 044, 044, 1, FchNF3e, DSC_CHNF3e);
  Gerador.wGrupo('/consSitNF3e');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

