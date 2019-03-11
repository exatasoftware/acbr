{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}

{$I ACBr.inc}

unit pcnReinfConsulta;

interface

uses
  SysUtils, Classes, pcnConversao, pcnConversaoReinf, pcnGerador, pcnConsts;

type

  TReinfConsulta = class(TPersistent)
  private
    FGerador: TGerador;
    FSoapEnvelope: String;
    FtpInsc: String;
    FnrInsc: String;
    FnrInscEstab: String;
    FTipoEvento: TTipoEvento;
    FperApur: String;
    FtpInscTomador: String;
    FcnpjPrestadorTomador: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
  published
    property Gerador: TGerador            read FGerador              write FGerador;
    property SoapEnvelope: String         read FSoapEnvelope         write FSoapEnvelope;
    property tpInsc: String               read FtpInsc               write FtpInsc;
    property nrInsc: String               read FnrInsc               write FnrInsc;
    property nrInscEstab: String          read FnrInscEstab          write FnrInscEstab;
    property TipoEvento: TTipoEvento      read FTipoEvento           write FTipoEvento;
    property perApur: String              read FperApur              write FperApur;
    property tpInscTomador: String        read FtpInscTomador        write FtpInscTomador;
    property cnpjPrestadorTomador: String read FcnpjPrestadorTomador write FcnpjPrestadorTomador;
  end;

implementation

Uses pcnAuxiliar;

{ TReinfConsulta }

constructor TReinfConsulta.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TReinfConsulta.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TReinfConsulta.GerarXML: Boolean;
var
  tpEvento: string;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.Prefixo           := 'v1:';
  tpEvento := Copy(TipoEventoToStr(TipoEvento), 3, 4);

  Gerador.wGrupo('consultar ' + SoapEnvelope);
  {
  Esta sendo usado o wCampoNFSe pois as tags devem ser geradas com prefixo.
  }
  Gerador.wCampoNFSe(tcStr, 'C02', 'tipoEvento', 04, 04, 1, tpEvento, 'XXX');
  Gerador.wCampoNFSe(tcInt, 'C03', 'tpInsc    ', 01, 01, 1, tpInsc, 'XXX');
  Gerador.wCampoNFSe(tcStr, 'C05', 'nrInsc    ', 11, 14, 1, nrInsc, 'XXX');

  case TipoEvento of
//    teR1000:
//    teR1070:
    teR2010:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur      ', 07, 07, 1, perApur, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscEstab  ', 01, 01, 1, tpInscTomador, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C08', 'nrInscEstab  ', 11, 14, 1, nrInscEstab, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C09', 'cnpjPrestador', 11, 14, 1, cnpjPrestadorTomador, 'XXX');
      end;
    teR2020:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur         ', 07, 07, 1, perApur, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C07', 'nrInscEstabPrest', 11, 14, 1, nrInscEstab, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscTomador   ', 01, 01, 1, tpInscTomador, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C09', 'nrInscTomador   ', 11, 14, 1, cnpjPrestadorTomador, 'XXX');
      end;
//    teR2030:
//    teR2040:
//    teR2050:
    teR2060:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur      ', 07, 07, 1, perApur, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C07', 'tpInscEstab  ', 01, 01, 1, tpInsc, 'XXX');
        Gerador.wCampoNFSe(tcStr, 'C08', 'nrInscEstab  ', 11, 14, 1, nrInscEstab, 'XXX');
      end;
//    teR2070:
    teR2098,
    teR2099:
      begin
        Gerador.wCampoNFSe(tcStr, 'C06', 'perApur', 07, 07, 1, perApur, 'XXX');
      end;
//    teR3010:
//    teR5001:
//    teR5011:
//    teR9000:
  end;

  Gerador.wGrupo('/consultar');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

