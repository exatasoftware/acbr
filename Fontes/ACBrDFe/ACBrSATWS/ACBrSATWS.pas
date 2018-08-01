{******************************************************************************}
{ Projeto: Componente ACBrSATWS                                               }
{ Biblioteca multiplataforma de componentes Delphi para Gera��o de arquivos    }
{ do Bloco X                                                                   }
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
{******************************************************************************}

{$I ACBr.inc}

unit ACBrSATWS;

interface

uses
  Classes, SysUtils,
  ACBrDFe, ACBrDFeConfiguracoes, ACBrSATWS_WebServices,
  ACBrUtil;

const
  ACBRSATWS_VERSAO = '0.1';

type

  { TConfiguracoesSATWS }

  TConfiguracoesSATWS = class(TConfiguracoes)
  public
    procedure Assign(DeConfiguracoesSATWS: TConfiguracoesSATWS); overload;
  published
    property Geral;
    property WebServices;
  end;

  { TACBrSATWS }
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}	
  TACBrSATWS = class(TACBrDFe)
  private
    FWebServices: TACBrSATWS_WebServices;
    function GetConfiguracoes: TConfiguracoesSATWS;
    procedure SetConfiguracoes(const Value: TConfiguracoesSATWS);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
    function GetAbout: String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property WebServices: TACBrSATWS_WebServices read FWebServices write FWebServices;
  published
    property Configuracoes: TConfiguracoesSATWS read GetConfiguracoes Write SetConfiguracoes;
  end;

implementation

{ TConfiguracoesSATWS }

procedure TConfiguracoesSATWS.Assign(
  DeConfiguracoesSATWS: TConfiguracoesSATWS);
begin
  WebServices.Assign(DeConfiguracoesSATWS.WebServices);
end;

{ TACBrSATWS }

constructor TACBrSATWS.Create(AOwner: TComponent);
begin
  inherited;

  FWebServices  := TACBrSATWS_WebServices.Create(Self);
end;

destructor TACBrSATWS.Destroy;
begin
  FWebServices.Free;

  inherited;
end;

function TACBrSATWS.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesSATWS.Create(Self);
end;

function TACBrSATWS.GetAbout: String;
begin
  Result := 'ACBrSATWS Ver: ' + ACBRSATWS_VERSAO;
end;

function TACBrSATWS.GetConfiguracoes: TConfiguracoesSATWS;
begin
  Result := TConfiguracoesSATWS(FPConfiguracoes);
end;

procedure TACBrSATWS.SetConfiguracoes(const Value: TConfiguracoesSATWS);
begin
  FPConfiguracoes := Value;
end;

end.
