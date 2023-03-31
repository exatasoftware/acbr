{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit pcnConsPlaca;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnGerador, ACBrUtil.Base,
  pcnConsts, pcnONEConsts;

type

  TConsPlaca = class
  private
    FGerador: TGerador;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FPlaca: String;
    FVersao: String;
    FdtRef: TDateTime;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;

    property Gerador: TGerador       read FGerador    write FGerador;
    property tpAmb: TpcnTipoAmbiente read FtpAmb      write FtpAmb;
    property verAplic: String        read FverAplic   write FverAplic;
    property Placa: String           read FPlaca      write FPlaca;
    property Versao: String          read FVersao     write FVersao;
    property dtRef: TDateTime        read FdtRef      write FdtRef;
  end;

implementation

{ TConsPlaca }

constructor TConsPlaca.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TConsPlaca.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TConsPlaca.GerarXML: Boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('oneConsPorPlaca ' + NAME_SPACE_ONE + ' versao="' + Versao + '"');

  Gerador.wCampo(tcStr, 'EP03', 'tpAmb     ', 01, 01, 1, tpAmbToStr(tpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'EP04', 'verAplic  ', 01, 20, 1, verAplic, DSC_verAplic);
  Gerador.wCampo(tcStr, 'EP06', 'placa     ', 07, 07, 1, Placa, DSC_Placa);
  Gerador.wCampo(tcDat, 'EP07', 'dtRef     ', 10, 10, 0, FdtRef, DSC_DataRef);
  Gerador.wCampo(tcStr, 'EP08', 'indCompRet', 01, 01, 1, '1');

  Gerador.wGrupo('/oneConsPorPlaca');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

