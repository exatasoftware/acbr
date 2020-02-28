{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrSped;

interface

uses
  SysUtils, Classes, DateUtils, ACBrTXTClass;

type
  TWriteRegistroEvent = procedure(var ALinha: String) of object;
  TCheckRegistroEvent = procedure(ARegistro: TObject; var AAbortar: Boolean) of object;

  EACBrSPEDException = class(Exception);

  { TACBrSPED }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSPED = class(TACBrTXTClass)
  private
    FDT_INI: TDateTime;  /// Data inicial das informa��es contidas no arquivo
    FDT_FIN: TDateTime;  /// Data final das informa��es contidas no arquivo
    FGravado: Boolean;
    procedure CriaRegistros; virtual;
    procedure LiberaRegistros; virtual;
  public
    procedure LimpaRegistros;virtual;
    property DT_INI : TDateTime read FDT_INI  write FDT_INI;
    property DT_FIN : TDateTime read FDT_FIN  write FDT_FIN;
    property Gravado: Boolean   read FGravado write FGravado ;
  end;

implementation

{ TACBrSPED }

procedure TACBrSPED.CriaRegistros;
begin

end;

procedure TACBrSPED.LiberaRegistros;
begin

end;

procedure TACBrSPED.LimpaRegistros;
begin
  /// Limpa os Registros
  LiberaRegistros;
  Conteudo.Clear;

  /// Recriar os Registros Limpos
  CriaRegistros;
end;

end.
