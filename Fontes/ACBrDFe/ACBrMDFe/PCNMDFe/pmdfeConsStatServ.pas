{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
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

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pmdfeConsStatServ;

interface
uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnGerador, pmdfeConversaoMDFe, pcnConsts;

type

  TConsStatServ = class(TPersistent)
  private
    FGerador: TGerador;
    FtpAmb: TpcnTipoAmbiente;
    FcUF: Integer;
    FVersao: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
  published
    property Gerador: TGerador       read FGerador write FGerador;
    property tpAmb: TpcnTipoAmbiente read FtpAmb   write FtpAmb;
    property cUF: Integer            read FcUF     write FcUF;
    property Versao: String          read FVersao  write FVersao;
  end;

implementation

{ TConsStatServ }

constructor TConsStatServ.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TConsStatServ.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TConsStatServ.GerarXML: Boolean;
begin
 Gerador.ArquivoFormatoXML := '';

 Gerador.wGrupo('consStatServMDFe ' + NAME_SPACE_MDFE + ' versao="' + Versao + '"');
 Gerador.wCampo(tcStr, 'DP03', 'tpAmb', 1, 1, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
 Gerador.wCampo(tcStr, 'DP04', 'xServ', 6, 6, 1, 'STATUS', DSC_XSERV);
 Gerador.wGrupo('/consStatServMDFe');

 Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

