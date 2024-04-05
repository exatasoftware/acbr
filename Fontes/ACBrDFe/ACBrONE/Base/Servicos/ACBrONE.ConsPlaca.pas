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

unit ACBrONE.ConsPlaca;

interface

uses
  SysUtils, Classes,
  pcnConversao;

type

  TConsPlaca = class
  private
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: string;
    FPlaca: string;
    FVersao: string;
    FdtRef: TDateTime;
  public
    function GerarXML: string;

    property tpAmb: TpcnTipoAmbiente read FtpAmb      write FtpAmb;
    property verAplic: string        read FverAplic   write FverAplic;
    property Placa: string           read FPlaca      write FPlaca;
    property Versao: string          read FVersao     write FVersao;
    property dtRef: TDateTime        read FdtRef      write FdtRef;
  end;

implementation

uses
  ACBrONE.Consts;

{ TConsPlaca }

function TConsPlaca.GerarXML: string;
begin
  Result := '<oneConsPorPlaca ' + NAME_SPACE_ONE + ' versao="' + Versao + '">' +
              '<tpAmb>' + tpAmbToStr(tpAmb) + '</tpAmb>' +
              '<verAplic>' + verAplic + '</verAplic>' +
              '<placa>' + Placa + '</placa>' +
              '<dtRef>' + FormatDateTime('yyyy-mm-dd', FdtRef) + '</dtRef>' +
              '<indCompRet>' + '1' + '</indCompRet>' +
            '</oneConsPorPlaca>';
end;

end.

