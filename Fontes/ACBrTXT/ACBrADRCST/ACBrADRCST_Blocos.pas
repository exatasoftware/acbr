{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Ribamar M. Santos                               }
{                              Juliomar Marchetti                              }
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

unit ACBrADRCST_Blocos;

interface

Uses
  SysUtils,
  Classes,
  DateUtils,
  ACBrTXTClass,
  StrUtils;

type
  { TBlocos }

  TBlocos = class
  private
    FREG: string;
  public
    constructor Create;overload;
    property REG: string read FREG;
  end;

  { TCloseBlocos }

  TCloseBlocos = class(TBlocos)
  private
    FQTD_LIN: integer; /// quantidade de linhas
  public
    constructor Create;

    property QTD_LIN: integer read FQTD_LIN;
    procedure Incrementa;
  end;

implementation

{ TCloseBlocos }

constructor TCloseBlocos.Create;
begin
  inherited Create;
  FQTD_LIN := 0;
end;

procedure TCloseBlocos.Incrementa;
begin
  FQTD_LIN := FQTD_LIN + 1;
end;

constructor TBlocos.Create;
begin
  inherited Create;
  FREG := UpperCase(MidStr(ClassName, Length(ClassName) - 3, 4));
  if Length(FREG) <> 4 then
    raise Exception.Create('O tipo do Registro n�o foi informado corretamente!');
end;

end.
