{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                 }
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

{$I ACBr.inc}

unit pcteDistDFeInt;

interface

uses
  SysUtils, Classes,
  pcnAuxiliar, pcnConversao, pcnGerador, pcnConsts;

type

  { TDistDFeInt }

  TDistDFeInt = class(TPersistent)
  private
    FGerador: TGerador;
    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FcUFAutor: Integer;
    FCNPJCPF: String;
    FultNSU: String;
    FNSU: String;
    FchCTe: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;
  published
    property Gerador: TGerador       read FGerador  write FGerador;
    property Versao: String          read FVersao   write FVersao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property cUFAutor: Integer       read FcUFAutor write FcUFAutor;
    property CNPJCPF: String         read FCNPJCPF  write FCNPJCPF;
    property ultNSU: String          read FultNSU   write FultNSU;
    // Usado no Grupo de informa��es para consultar um DF-e a partir de um
    // NSU espec�fico.
    property NSU: String             read FNSU      write FNSU;
    property chCTe: String           read FchCTe    write FchCTe;
  end;

implementation

{ TDistDFeInt }

constructor TDistDFeInt.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TDistDFeInt.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TDistDFeInt.GerarXML: boolean;
var
 sNSU: String;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('cteDadosMsg');
  Gerador.wGrupo('distDFeInt ' + NAME_SPACE_CTE + ' versao="' + Versao + '"');
  Gerador.wCampo(tcStr, 'A03', 'tpAmb   ', 01, 01, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcInt, 'A04', 'cUFAutor', 02, 02, 1, FcUFAutor, '***');
  Gerador.wCampoCNPJCPF('A05', 'A06', FCNPJCPF);

  if FNSU = '' then
  begin
    if FchCTe = '' then
    begin
      sNSU := IntToStrZero(StrToIntDef(FultNSU,0),15);
      Gerador.wGrupo('distNSU');
      Gerador.wCampo(tcStr, 'A08', 'ultNSU', 01, 15, 1, sNSU, DSC_ULTNSU);
      Gerador.wGrupo('/distNSU');
    end
    else begin
      Gerador.wGrupo('consChCTe');
      Gerador.wCampo(tcStr, 'A12', 'chCTe', 44, 44, 1, FchCTe, DSC_CHAVE);

      if not ValidarChave(FchCTe) then
        Gerador.wAlerta('A12', 'chCTe', '', 'Chave de CTe inv�lida');

      Gerador.wGrupo('/consChCTe');
    end;
  end
  else
  begin
    sNSU := IntToStrZero(StrToIntDef(FNSU,0),15);
    Gerador.wGrupo('consNSU');
    Gerador.wCampo(tcStr, 'A10', 'NSU', 01, 15, 1, sNSU, DSC_NSU);
    Gerador.wGrupo('/consNSU');
  end;

  Gerador.wGrupo('/distDFeInt');
  Gerador.wGrupo('/cteDadosMsg');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

