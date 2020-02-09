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

{$I ACBr.inc}

unit ACBrDeviceHook;

interface


uses
  Classes, SysUtils,
  ACBrDeviceClass, ACBrBase;

type
  TACBrDeviceHookAtivar = procedure(const APort: String; Params: String) of object;
  TACBrDeviceHookDesativar = procedure(const APort: String) of object;
  TACBrDeviceHookEnviaString = procedure(const cmd: AnsiString) of object;
  TACBrDeviceHookLeString = procedure(const NumBytes, ATimeOut: Integer; var Retorno: AnsiString) of object;

  { TACBrDeviceHook }

  TACBrDeviceHook = class(TACBrDeviceClass)
  private
    fsHookAtivar: TACBrDeviceHookAtivar;
    fsHookDesativar: TACBrDeviceHookDesativar;
    fsHookEnviaString: TACBrDeviceHookEnviaString;
    fsHookLeString: TACBrDeviceHookLeString;
  protected
  public
    constructor Create(AOwner: TComponent);

    procedure Conectar(const APorta: String; const ATimeOutMilissegundos: Integer); override;
    procedure Desconectar(IgnorarErros: Boolean = True); override;

    procedure EnviaString(const AString: AnsiString); override;
    function LeString(ATimeOutMilissegundos: Integer = 0; NumBytes: Integer = 0;
      const Terminador: AnsiString = ''): AnsiString; override;
    procedure Limpar; override;

    property HookAtivar: TACBrDeviceHookAtivar read fsHookAtivar write fsHookAtivar;
    property HookDesativar: TACBrDeviceHookDesativar read fsHookDesativar write fsHookDesativar;
    property HookEnviaString: TACBrDeviceHookEnviaString read fsHookEnviaString write fsHookEnviaString;
    property HookLeString: TACBrDeviceHookLeString read fsHookLeString write fsHookLeString;
  end;

implementation

uses
  DateUtils, Math, StrUtils,
  ACBrDevice;

{ TACBrDeviceHook }

constructor TACBrDeviceHook.Create(AOwner: TComponent);
begin
  inherited;
  fsHookAtivar := nil;
  fsHookDesativar := nil;
  fsHookEnviaString := nil;
  fsHookLeString := nil;
end;

procedure TACBrDeviceHook.Conectar(const APorta: String; const ATimeOutMilissegundos: Integer);
begin
  inherited;
  if Assigned(fsHookAtivar) then
    fsHookAtivar(APorta, TACBrDevice(fpOwner).DeviceToString(False));
end;

procedure TACBrDeviceHook.Desconectar(IgnorarErros: Boolean);
begin
  inherited;
  if Assigned(fsHookDesativar) then
    fsHookDesativar(fpPorta);
end;

procedure TACBrDeviceHook.EnviaString(const AString: AnsiString);
begin
  if Assigned(fsHookEnviaString) then
  begin
    GravaLog('  TACBrDeviceHook.EnviaString');
    fsHookEnviaString(AString);
  end;
end;

function TACBrDeviceHook.LeString(ATimeOutMilissegundos: Integer; NumBytes: Integer;
  const Terminador: AnsiString): AnsiString;
var
  Buffer: AnsiString;
  Fim: TDateTime;
  LenTer, LenBuf: Integer;
begin
  Result := '';
  with TACBrDevice(fpOwner) do
  begin
    if Assigned( fsHookLeString ) then
    begin
      LenTer := Length(Terminador);
      NumBytes := max(NumBytes,1);
      Fim := IncMilliSecond(Now, ATimeOutMilissegundos);
      repeat
        Buffer := '';
        fsHookLeString(NumBytes, ATimeOutMilissegundos, Buffer);
        LenBuf := Length(Buffer);
        if (LenTer > 0) and (LenBuf > 0) then
        begin
          if (RightStr(Buffer, LenTer) = Terminador) then
          begin
            SetLength(Buffer, (LenBuf-LenTer));
            NumBytes := 0; // for�a saida
          end;
        end;

        Result := Result + Buffer;
      until (Length(Result) >= NumBytes) or (now > Fim) ;
    end;
  end;
end;

procedure TACBrDeviceHook.Limpar;
begin
  inherited Limpar;
end;

end.



