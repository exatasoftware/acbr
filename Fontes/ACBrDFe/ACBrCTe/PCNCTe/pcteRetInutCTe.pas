{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
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

unit pcteRetInutCTe;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnLeitor;

type

  TRetInutCTe = class(TObject)
  private
    FLeitor: TLeitor;
    Fversao: String;
    FId: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: Integer;
    FxMotivo: String;
    FxJust: String;
    FcUF: Integer;
    Fano: Integer;
    FCNPJ: String;
    FModelo: Integer;
    FSerie: Integer;
    FnCTIni: Integer;
    FnCTFin: Integer;
    FdhRecbto: TDateTime;
    FnProt: String;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: boolean;
    property Leitor: TLeitor         read FLeitor   write FLeitor;
    property versao: String          read Fversao   write Fversao;
    property Id: String              read FId       write FId;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property verAplic: String        read FverAplic write FverAplic;
    property cStat: Integer          read FcStat    write FcStat;
    property xMotivo: String         read FxMotivo  write FxMotivo;
    property xJust: String           read FxJust    write FxJust;
    property cUF: Integer            read FcUF      write FcUF;
    property ano: Integer            read Fano      write Fano;
    property CNPJ: String            read FCNPJ     write FCNPJ;
    property Modelo: Integer         read FModelo   write FModelo;
    property Serie: Integer          read FSerie    write FSerie;
    property nCTIni: Integer         read FnCTIni   write FnCTIni;
    property nCTFin: Integer         read FnCTFin   write FnCTFin;
    property dhRecbto: TDateTime     read FdhRecbto write FdhRecbto;
    property nProt: String           read FnProt    write FnProt;
  end;

implementation

{ TretAtuCadEmiDFe }

constructor TRetInutCTe.Create;
begin
  inherited Create;
  FLeitor := TLeitor.Create;
end;

destructor TRetInutCTe.Destroy;
begin
  FLeitor.Free;
  inherited;
end;

function TRetInutCTe.LerXml: boolean;
var
  ok: boolean;
begin
  Result := False;
  try
    if (leitor.rExtrai(1, 'inutCTe') <> '') then
      FId := Leitor.rAtributo('Id=');

    if (leitor.rExtrai(1, 'retInutCTe') <> '') or (leitor.rExtrai(1, 'infInut') <> '') then
    begin
               Fversao   := Leitor.rAtributo('versao', 'retInutCTe');
      (*DR05 *)FtpAmb    := StrToTpAmb(ok, Leitor.rCampo(tcStr, 'tpAmb'));
      (*DR06 *)FverAplic := Leitor.rCampo(tcStr, 'verAplic');
      (*DR07 *)FcStat    := Leitor.rCampo(tcInt, 'cStat');
      (*DR08 *)FxMotivo  := Leitor.rCampo(tcStr, 'xMotivo');
      (*DR09 *)FcUF      := Leitor.rCampo(tcInt, 'cUF');

      if cStat = 102 then
      begin
        (*DR10 *)Fano      := Leitor.rCampo(tcInt, 'ano');
        (*DR11 *)FCNPJ     := Leitor.rCampo(tcStr, 'CNPJ');
        (*DR12 *)FModelo   := Leitor.rCampo(tcInt, 'mod');
        (*DR13 *)FSerie    := Leitor.rCampo(tcInt, 'serie');
        (*DR14 *)FnCTIni   := Leitor.rCampo(tcInt, 'nCTIni');
        (*DR15 *)FnCTFin   := Leitor.rCampo(tcInt, 'nCTFin');
        (*DR16 *)FdhRecbto := Leitor.rCampo(tcDatHor, 'dhRecbto');
        (*DR17 *)FnProt    := Leitor.rCampo(tcStr, 'nProt');
      end;

      if leitor.rExtrai(1, 'infInut') <> '' then
        FxJust := Leitor.rCampo(tcStr, 'xJust');

      Result := True;
    end;
  except
    result := False;
  end;
end;

end.

