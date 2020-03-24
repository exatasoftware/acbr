{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

unit ACBrFeriadoWSClass;

interface

uses
  Classes, ACBrBase;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrFeriadoWSClass = class
  protected
    fOwner: TComponent;
    fpURL: String;

    procedure BuscaEfetuada;
    procedure ErrorAbstract;
    procedure TestarToken;
    procedure TestarPathArquivo;
  public
    constructor Create(AOwner: TComponent); virtual;

    procedure Buscar(const AAno: Integer; const AUF: String = '';
      const ACidade: String = ''); virtual;

    property URL: String read fpURL;
  end;

implementation

uses
  SysUtils, ACBrFeriado, ACBrUtil;

{ TACBrFeriadoWSClass }

procedure TACBrFeriadoWSClass.BuscaEfetuada;
begin
  if (Assigned(TACBrFeriado(fOwner).OnBuscaEfetuada)) then
    TACBrFeriado(fOwner).OnBuscaEfetuada(fOwner);
end;

procedure TACBrFeriadoWSClass.Buscar(const AAno: Integer; const AUF,
  ACidade: String);
begin
  ErrorAbstract;
end;

constructor TACBrFeriadoWSClass.Create(AOwner: TComponent);
begin
  inherited Create;
  if not(AOwner is TACBrFeriado) then
    raise EACBrFeriadoException.Create(ACBrStr('Essa classe deve ser instanciada por TACBrFeriado'));

  fOwner := AOwner;
  fpURL  := '';
end;

procedure TACBrFeriadoWSClass.ErrorAbstract;
begin
  raise EACBrFeriadoException.Create(ACBrStr('Nenhum WebService selecionado'));
end;

procedure TACBrFeriadoWSClass.TestarPathArquivo;
begin
  if (TACBrFeriado(fOwner).PathArquivo = EmptyStr) then
    raise EACBrFeriadoException.Create(ACBrStr('Arquivo n�o informado'));
  if not(FileExists(TACBrFeriado(fOwner).PathArquivo)) then
    raise EACBrFeriadoException.Create(ACBrStr('Arquivo informado n�o existe'));
end;

procedure TACBrFeriadoWSClass.TestarToken;
begin
  if (TACBrFeriado(fOwner).Token = EmptyStr) then
    raise EACBrFeriadoException.Create(ACBrStr('Token n�o informado'));
end;

end.
