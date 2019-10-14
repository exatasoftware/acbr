{******************************************************************************}
{ Projeto: Componente ACBrONE                                                  }
{  Operador Nacional dos Estados - ONE                                         }
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
|* 14/10/2019: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnDistLeitura;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador, pcnConsts, pcnConversaoONE;

type

  { TDistLeitura }

  TDistLeitura = class
  private
    FGerador: TGerador;

    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FtpDist: TtpDist;
    FultNSU: String;
    FNSUFin: String;
    FCNPJOper: String;
    FcEQP: String;
    FcUF: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    function GerarXML: boolean;
    function ObterNomeArquivo: string;

    property Gerador: TGerador       read FGerador  write FGerador;
    property versao: String          read Fversao   write Fversao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: String        read FverAplic write FverAplic;
    property tpDist: TtpDist         read FtpDist    write FtpDist;
    property ultNSU: String          read FultNSU   write FultNSU;
    property NSUFin: String          read FNSUFin   write FNSUFin;
    property CNPJOper: String        read FCNPJOper  write FCNPJOper;
    property cEQP: String            read FcEQP      write FcEQP;
    property cUF: Integer            read FcUF       write FcUF;
  end;

implementation

uses
  pcnAuxiliar, pcnONEConsts;

{ TDistLeitura }

constructor TDistLeitura.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TDistLeitura.Destroy;
begin
  FGerador.Free;

  inherited;
end;

function TDistLeitura.ObterNomeArquivo: string;
var
  DataHora: TDateTime;
  Year, Month, Day, Hour, Min, Sec, Milli: Word;
  AAAAMMDDTHHMMSS: string;
begin
  Datahora := now;
  DecodeTime(DataHora, Hour, Min, Sec, Milli);
  DecodeDate(DataHora, Year, Month, Day);
  AAAAMMDDTHHMMSS := IntToStrZero(Year, 4) + IntToStrZero(Month, 2) + IntToStrZero(Day, 2) +
    IntToStrZero(Hour, 2) + IntToStrZero(Min, 2) + IntToStrZero(Sec, 2);
  Result := AAAAMMDDTHHMMSS + '-con-dist-lei.xml';
end;

function TDistLeitura.GerarXML: boolean;
var
 sNSU, sNSUFin: String;
begin
  Gerador.ArquivoFormatoXML := '';

  sNSU := IntToStrZero(StrToInt64Def(ultNSU, 0), 15);

  if NSUFin <> '' then
    sNSUFin := IntToStrZero(StrToIntDef(NSUFin, 0), 15);

  Gerador.wGrupo('oneDistLeitura ' + NAME_SPACE_ONE + ' versao="' + Versao + '"');

  Gerador.wCampo(tcStr, 'CP03', 'tpAmb   ', 01, 01, 1, TpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'CP04', 'verAplic', 01, 20, 1, FverAplic, DSC_verAplic);
  Gerador.wCampo(tcStr, 'CP05', 'tpDist  ', 01, 01, 1, TpDistToStr(FtpDist), DSC_tpDist);
  Gerador.wCampo(tcStr, 'CP06', 'ultNSU  ', 01, 15, 1, sNSU, DSC_ULTNSU);
  Gerador.wCampo(tcStr, 'CP07', 'NSUFin  ', 01, 15, 0, sNSUFin, DSC_NSUFin);

  case tpDist of
    tdEquipamento,
    tdOperador:
      begin
        if cEQP = '' then
          Gerador.wCampo(tcStr, 'CP08', 'CNPJOper', 01, 14, 1, CNPJOper, DSC_CNPJOper);

        if tpDist = tdEquipamento then
          Gerador.wCampo(tcStr, 'CP09', 'cEQP', 01, 15, 0, cEQP, DSC_cEQP);
      end;

    tdUFMDFe,
    tdUFCaptura:
      Gerador.wCampo(tcInt, 'CP10', 'cUF', 01, 02, 1, FcUF, DSC_cUF);
  end;

  Gerador.wGrupo('/oneDistLeitura');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

