{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Willian H�bner e Elton Barbosa (EMBarbosa)      }
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
unit Registro0000;

interface

uses
  LCDPRBlocos;

type
  TRegistro0000 = Class
  private
    FDT_INI: TDateTime;
    FDT_SIT_ESP: TDateTime;
    FIND_SIT_INI_PER: TIndInicio;
    FCPF: String;
    FCOD_VER: TCodVer;
    FDT_FIN: TDateTime;
    FSIT_ESPECIAL: TIndSitEsp;
    FNOME: String;
    procedure SetCOD_VER(const Value: TCodVer);
    procedure SetCPF(const Value: String);
    procedure SetDT_FIN(const Value: TDateTime);
    procedure SetDT_INI(const Value: TDateTime);
    procedure SetDT_SIT_ESP(const Value: TDateTime);
    procedure SetIND_SIT_INI_PER(const Value: TIndInicio);
    procedure SetNOME(const Value: String);
    procedure SetSIT_ESPECIAL(const Value: TIndSitEsp);
  public
    property COD_VER : TCodVer read FCOD_VER write SetCOD_VER;
    property CPF : String read FCPF write SetCPF;
    property NOME : String read FNOME write SetNOME;
    property IND_SIT_INI_PER : TIndInicio read FIND_SIT_INI_PER write SetIND_SIT_INI_PER;
    property SIT_ESPECIAL : TIndSitEsp read FSIT_ESPECIAL write SetSIT_ESPECIAL;
    property DT_SIT_ESP : TDateTime read FDT_SIT_ESP write SetDT_SIT_ESP;
    property DT_INI : TDateTime read FDT_INI write SetDT_INI;
    property DT_FIN : TDateTime read FDT_FIN write SetDT_FIN;
  End;

implementation

uses
  SysUtils, ACBrUtil;

{ TRegistro0000 }

procedure TRegistro0000.SetCOD_VER(const Value: TCodVer);
begin
  FCOD_VER := Value;
end;

procedure TRegistro0000.SetCPF(const Value: String);
var
  TempCPF: string;
begin
  TempCPF := OnlyNumber(Value);
  if (Length(TempCPF) <> 11) then
    raise Exception.Create('CPF precisa possuir 11 caracteres!');

  FCPF := TempCPF;
end;

procedure TRegistro0000.SetDT_FIN(const Value: TDateTime);
begin
  FDT_FIN := Value;
end;

procedure TRegistro0000.SetDT_INI(const Value: TDateTime);
begin
  FDT_INI := Value;
end;

procedure TRegistro0000.SetDT_SIT_ESP(const Value: TDateTime);
begin
  FDT_SIT_ESP := Value;
end;

procedure TRegistro0000.SetIND_SIT_INI_PER(const Value: TIndInicio);
begin
  FIND_SIT_INI_PER := Value;
end;

procedure TRegistro0000.SetNOME(const Value: String);
begin
  FNOME := Value;
end;

procedure TRegistro0000.SetSIT_ESPECIAL(const Value: TIndSitEsp);
begin
  FSIT_ESPECIAL := Value;
end;

end.
