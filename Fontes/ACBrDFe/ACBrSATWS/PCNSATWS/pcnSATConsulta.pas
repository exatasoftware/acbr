{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Ferreira de Moraes                        }
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

unit pcnSATConsulta;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador, pcnConsts;

type

  TSATConsulta = class(TObject)
  private
    FGerador        : TGerador;
    FtpAmb          : TpcnTipoAmbiente;
    FcUF            : Integer;
    FversaoDados    : String;
    FnserieSAT      : Integer;
    FdhInicial      : TDateTime;
    FdhFinal        : TDateTime;
    FchaveSeguranca : String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function ObterNomeArquivo: string;
    property Gerador        : TGerador         read FGerador        write FGerador;
    property tpAmb          : TpcnTipoAmbiente read FtpAmb          write FtpAmb;
    property cUF            : Integer          read FcUF            write FcUF;
    property versaoDados    : String           read FversaoDados    write FversaoDados;
    property nserieSAT      : Integer          read FnserieSAT      write FnserieSAT;
    property dhInicial      : TDateTime        read FdhInicial      write FdhInicial;
    property dhFinal        : TDateTime        read FdhFinal        write FdhFinal;
    property chaveSeguranca : String           read FchaveSeguranca write FchaveSeguranca;
  end;

implementation

Uses pcnAuxiliar;

{ TSATConsulta }

constructor TSATConsulta.Create;
begin
  inherited Create;
  FGerador := TGerador.Create;
end;

destructor TSATConsulta.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TSATConsulta.ObterNomeArquivo: string;
var
  DataHora: TDateTime;
  Year, Month, Day, Hour, Min, Sec, Milli: Word;
  AAAAMMDDTHHMMSS: string;
begin
  Datahora:=now;
  DecodeTime(DataHora, Hour, Min, Sec, Milli);
  DecodeDate(DataHora, Year, Month, Day);
  AAAAMMDDTHHMMSS := IntToStrZero(Year, 4) + IntToStrZero(Month, 2) + IntToStrZero(Day, 2) +
    IntToStrZero(Hour, 2) + IntToStrZero(Min, 2) + IntToStrZero(Sec, 2);
  Result := AAAAMMDDTHHMMSS + '-ped-con-sat.xml';
end;

function TSATConsulta.GerarXML: Boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('consLote ' + NAME_SPACE_SAT + ' versao="' + versaoDados + '"');
  Gerador.wCampo(tcInt, 'SAT01', 'nserieSAT', 9, 9, 1, nserieSAT, DSC_NSERIESAT);
  Gerador.wCampo(tcStr, 'SAT02', 'dhInicial  ', 14, 14, 1, DateTimeToDataHora(dhInicial), DSC_DHINICIAL);
  Gerador.wCampo(tcStr, 'SAT03', 'dhFinal  ', 14, 14, 1, DateTimeToDataHora(dhFinal), DSC_DHFINAL);
  Gerador.wCampo(tcStr, 'SAT04', 'chaveSeguranca', 0, 999, 1, chaveSeguranca, DSC_CHAVESEGURANCA);
  Gerador.wGrupo('/consLote');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

