﻿{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para interação com equipa- }
{ mentos de Automação Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Jurisato Junior                           }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la }
{ sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a versão 2.1 da Licença, ou (a seu critério) }
{ qualquer versão posterior.                                                   }
{                                                                              }
{  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU      }
{ ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto}
{ com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,  }
{ no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Você também pode obter uma copia da licença em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Simões de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatuí - SP - 18270-170         }
{******************************************************************************}

unit ACBrLibDISDataModule;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, ACBrLibConfig, syncobjs, ACBrDIS;

type

  { TLibDISDM }

  TLibDISDM = class(TDataModule)
    ACBrDIS1: TACBrDIS;

    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FLock: TCriticalSection;

  public
    procedure AplicarConfiguracoes;
    procedure GravarLog(AMsg: String; NivelLog: TNivelLog; Traduzir: Boolean = False);
    procedure Travar;
    procedure Destravar;
  end;

implementation

uses
  ACBrUtil,
  ACBrLibDISConfig, ACBrLibComum, ACBrLibDISClass;

{$R *.lfm}

{ TLibDISDM }

procedure TLibDISDM.DataModuleCreate(Sender: TObject);
begin
  FLock := TCriticalSection.Create;
end;

procedure TLibDISDM.DataModuleDestroy(Sender: TObject);
begin
  FLock.Destroy;
end;

procedure TLibDISDM.AplicarConfiguracoes;
var
  pLibConfig: TLibDISConfig;
begin
  pLibConfig := TLibDISConfig(TACBrLibDIS(pLib).Config);

  with ACBrDIS1 do
  begin
    Porta               := pLibConfig.DISConfig.Porta;
    Modelo              := pLibConfig.DISConfig.Modelo;
    Alinhamento         := pLibConfig.DISConfig.Alinhamento;
    LinhasCount         := pLibConfig.DISConfig.LinhasCount;
    Colunas             := pLibConfig.DISConfig.Colunas;
    Intervalo           := pLibConfig.DISConfig.Intervalo;
    Passos              := pLibConfig.DISConfig.Passos;
    IntervaloEnvioBytes := pLibConfig.DISConfig.IntervaloEnvioBytes;
    RemoveAcentos       := pLibConfig.DISConfig.RemoveAcentos;
  end;

  pLibConfig.DeviceConfig.Apply(ACBrDIS1.Device);
end;

procedure TLibDISDM.GravarLog(AMsg: String; NivelLog: TNivelLog;
  Traduzir: Boolean);
begin
  if Assigned(pLib) then
    pLib.GravarLog(AMsg, NivelLog, Traduzir);
end;

procedure TLibDISDM.Travar;
begin
  GravarLog('Travar', logParanoico);
  FLock.Acquire;
end;

procedure TLibDISDM.Destravar;
begin
  GravarLog('Destravar', logParanoico);
  FLock.Release;
end;

end.

