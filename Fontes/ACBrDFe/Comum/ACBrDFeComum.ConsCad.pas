{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2024 Daniel Simoes de Almeida               }
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

unit ACBrDFeComum.ConsCad;

interface

uses
  SysUtils, Classes;

type

  TConsCad = class(TPersistent)
  private
    FUF: string;
    FIE: string;
    FCNPJ: string;
    FCPF: string;
    FVersao: string;
  public
    function GerarXML: string;

  published
    property UF: string     read FUF     write FUF;
    property IE: string     read FIE     write FIE;
    property CNPJ: string   read FCNPJ   write FCNPJ;
    property CPF: string    read FCPF    write FCPF;
    property Versao: string read FVersao write FVersao;
  end;

const
  NAME_SPACE = 'xmlns="http://www.portalfiscal.inf.br/nfe"';

implementation

{ TConsCad }

function TConsCad.GerarXML: string;
var
  xDoc: string;
begin
  if FIE <> EmptyStr then
    xDoc := '<IE>' + FIE + '</IE>'
  else
  begin
    if FCNPJ <> EmptyStr then
      xDoc := '<CNPJ>' + FCNPJ + '</CNPJ>'
    else
      xDoc := '<CPF>' + FCPF + '</CPF>';
  end;

  Result := '<ConsCad ' + NAME_SPACE + ' versao="' + Versao + '">' +
              '<infCons>' +
                '<xServ>CONS-CAD</xServ>' +
                '<UF>' + FUF + '</UF>' +
                xDoc +
              '</infCons>' +
            '</ConsCad>';
end;

end.

