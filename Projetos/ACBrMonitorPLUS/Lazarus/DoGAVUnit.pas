{*******************************************************************************}
{ Projeto: ACBrMonitor                                                          }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para  }
{ criar uma interface de comunica��o com equipamentos de automacao comercial.   }
{                                                                               }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida                }
{                                                                               }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr       }
{                                                                               }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la  }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela   }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio)  }
{ qualquer vers�o posterior.                                                    }
{                                                                               }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM    }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU       }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor }
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)               }
{                                                                               }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto }
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,   }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.           }
{ Voc� tamb�m pode obter uma copia da licen�a em:                               }
{ http://www.opensource.org/licenses/gpl-license.php                            }
{                                                                               }
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br }
{        Rua Cel.Aureliano de Camargo, 963 - Tatu� - SP - 18270-170             }
{                                                                               }
{*******************************************************************************}
{$I ACBr.inc}

unit DoGAVUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil, ACBrGAV, ACBrDevice,
  ACBrMonitorConsts, ACBrMonitorConfig;

type

{ TACBrObjetoGAV }

TACBrObjetoGAV = class(TACBrObjetoDFe)
private
  fACBrGAV: TACBrGAV;
public
  constructor Create(AConfig: TMonitorConfig; ACBrGAV: TACBrGAV); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  property ACBrGAV: TACBrGAV read fACBrGAV;
end;

{ TMetodoAtivar}
TMetodoAtivar = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoDesativar}
TMetodoDesativar = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoAtivo}
TMetodoAtivo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoModeloStr}
TMetodoModeloStr = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoModelo}
TMetodoModelo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoPorta}
TMetodoPorta = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoAbreGaveta}
TMetodoAbreGaveta = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoGavetaAberta}
TMetodoGavetaAberta = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoStrComando}
TMetodoStrComando = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetStrComando}
TMetodoSetStrComando = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoAberturaIntervalo}
TMetodoAberturaIntervalo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetAberturaIntervalo}
TMetodoSetAberturaIntervalo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoAberturaAntecipada}
TMetodoAberturaAntecipada = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

{ TACBrObjetoGAV }

constructor TACBrObjetoGAV.Create(AConfig: TMonitorConfig; ACBrGAV: TACBrGAV);
begin
  inherited Create(AConfig);

  fACBrGAV := ACBrGAV;

  ListaDeMetodos.Add(CMetodoAtivar);
  ListaDeMetodos.Add(CMetodoDesativar);
  ListaDeMetodos.Add(CMetodoAtivo);
  ListaDeMetodos.Add(CMetodoModeloStr);
  ListaDeMetodos.Add(CMetodoModelo);
  ListaDeMetodos.Add(CMetodoPorta);
  ListaDeMetodos.Add(CMetodoAbreGaveta);
  ListaDeMetodos.Add(CMetodoGavetaAberta);
  ListaDeMetodos.Add(CMetodoStrComando);
  ListaDeMetodos.Add(CMetodoSetStrComando);
  ListaDeMetodos.Add(CMetodoAberturaIntervalo);
  ListaDeMetodos.Add(CMetodoSetAberturaIntervalo);
  ListaDeMetodos.Add(CMetodoAberturaAntecipada);
end;

procedure TACBrObjetoGAV.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoAtivar;
    1  : AMetodoClass := TMetodoDesativar;
    2  : AMetodoClass := TMetodoAtivo;
    3  : AMetodoClass := TMetodoModeloStr;
    4  : AMetodoClass := TMetodoModelo;
    5  : AMetodoClass := TMetodoPorta;
    6  : AMetodoClass := TMetodoAbreGaveta;
    7  : AMetodoClass := TMetodoGavetaAberta;
    8  : AMetodoClass := TMetodoStrComando;
    9  : AMetodoClass := TMetodoSetStrComando;
   10  : AMetodoClass := TMetodoAberturaIntervalo;
   11  : AMetodoClass := TMetodoSetAberturaIntervalo;
   12  : AMetodoClass := TMetodoAberturaAntecipada;
  end;

  if Assigned(AMetodoClass) then
  begin
    Ametodo := AMetodoClass.Create(ACmd, Self);
    try
      Ametodo.Executar;
    finally
      Ametodo.Free;
    end;
  end;
end;

{ TMetodoAtivar }

procedure TMetodoAtivar.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    ACBrGAV.Ativar;
  end;
end;

{ TMetodoDesativar }

procedure TMetodoDesativar.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    ACBrGAV.Desativar;
  end;
end;

{ TMetodoAtivo }

procedure TMetodoAtivo.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := BoolToStr(ACBrGAV.Ativo, true);
  end;
end;

{ TMetodoModeloStr }

procedure TMetodoModeloStr.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrGAV.ModeloStr;
  end;
end;

{ TMetodoModelo }

procedure TMetodoModelo.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := GetEnumName(TypeInfo(TACBrGAVModelo),Integer(ACBrGAV.Modelo));
  end;
end;

{ TMetodoPorta }

procedure TMetodoPorta.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrGAV.Porta;
  end;
end;

{ TMetodoAbreGaveta }

procedure TMetodoAbreGaveta.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    ACBrGAV.AbreGaveta;
  end;
end;

{ TMetodoGavetaAberta }

procedure TMetodoGavetaAberta.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := BoolToStr( ACBrGAV.GavetaAberta, true );
  end;
end;

{ TMetodoStrComando }

procedure TMetodoStrComando.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrGAV.StrComando;
  end;
end;

{ TMetodoSetStrComando }

{ Params: 0 - String com os comandos
}
procedure TMetodoSetStrComando.Executar;
var
  AComando: String;
begin
  AComando := fpCmd.Params(0);

  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    ACBrGAV.StrComando := AComando;

    with MonitorConfig.GAV do
      StringAbertura := AComando;

    MonitorConfig.SalvarArquivo;
  end;
end;

{ TMetodoAberturaIntervalo }

procedure TMetodoAberturaIntervalo.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := IntToStr( ACBrGAV.AberturaIntervalo );
  end;
end;

{ TMetodoSetAberturaIntervalo }

{ Params: 0 - inteiro com o intervalor em milisegundos
}
procedure TMetodoSetAberturaIntervalo.Executar;
var
  AIntervalo: Integer;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    AIntervalo := StrToIntDef( fpCmd.Params(0), ACBrGAV.AberturaIntervalo);

    ACBrGAV.AberturaIntervalo := AIntervalo;

    with MonitorConfig.GAV do
      AberturaIntervalo := AIntervalo;

    MonitorConfig.SalvarArquivo;
  end;
end;

{ TMetodoAberturaAntecipada }

procedure TMetodoAberturaAntecipada.Executar;
begin
  with TACBrObjetoGAV(fpObjetoDono) do
  begin
    fpCmd.Resposta := GetEnumName(TypeInfo(TACBrGAVAberturaAntecipada),Integer(ACBrGAV.AberturaAntecipada));
  end;
end;

end.
