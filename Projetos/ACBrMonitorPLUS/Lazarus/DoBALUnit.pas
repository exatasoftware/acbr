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

unit DoBALUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil, ACBrBAL,
  ACBrMonitorConsts, ACBrMonitorConfig;

// ACBrLibBALRespostas, ACBrLibResposta, ACBrDFeUtil, UtilUnit, DoACBrDFeUnit;

type

{ TACBrObjetoBAL }

TACBrObjetoBAL = class(TACBrObjetoDFe)
private
  fACBrBAL: TACBrBAL;
public
  constructor Create(AConfig: TMonitorConfig; ACBrBAL: TACBrBAL); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  property ACBrBAL: TACBrBAL read fACBrBAL;
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

{ TMetodoIntervalo}
TMetodoIntervalo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoSetIntervalo}
TMetodoSetIntervalo = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoLePeso}
TMetodoLePeso = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoUltimoPesoLido}
TMetodoUltimoPesoLido = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoUltimaResposta}
TMetodoUltimaResposta = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoMonitorarBalanca}
TMetodoMonitorarBalanca = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

(*
uses
  {$IFNDEF NOGUI}ACBrMonitor1 {$ELSE}ACBrMonitorConsoleDM {$ENDIF} ;
  IniFiles, DateUtils, Forms, strutils,
  ACBrDFeConfiguracoes, pcnConversao, pcnAuxiliar, DoACBrUnit;
*)
{ TACBrObjetoBAL }

constructor TACBrObjetoBAL.Create(AConfig: TMonitorConfig; ACBrBAL: TACBrBAL);
begin
  inherited Create(AConfig);

  fACBrBAL := ACBrBAL;

  ListaDeMetodos.Add(CMetodoAtivar);
  ListaDeMetodos.Add(CMetodoDesativar);
  ListaDeMetodos.Add(CMetodoAtivo);
  ListaDeMetodos.Add(CMetodoModeloStr);
  ListaDeMetodos.Add(CMetodoModelo);
  ListaDeMetodos.Add(CMetodoPorta);
  ListaDeMetodos.Add(CMetodoIntervalo);
  ListaDeMetodos.Add(CMetodoSetIntervalo);
  ListaDeMetodos.Add(CMetodoLePeso);
  ListaDeMetodos.Add(CMetodoUltimoPesoLido);
  ListaDeMetodos.Add(CMetodoUltimaResposta);
  ListaDeMetodos.Add(CMetodoMonitorarBalanca);
end;

procedure TACBrObjetoBAL.Executar(ACmd: TACBrCmd);
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
    6  : AMetodoClass := TMetodoIntervalo;
    7  : AMetodoClass := TMetodoSetIntervalo;
    8  : AMetodoClass := TMetodoLePeso;
    9  : AMetodoClass := TMetodoUltimoPesoLido;
    10 : AMetodoClass := TMetodoUltimaResposta;
    11 : AMetodoClass := TMetodoMonitorarBalanca;
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
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    ACBrBAL.Ativar;

    ACBrBAL.LePeso;
    if ACBrBAL.UltimaResposta = '' then
    begin
      ACBrBAL.Desativar;

      fpCmd.Resposta := 'Balan�a n�o responde!';

      raise Exception.Create('Balan�a n�o responde!');
    end;
  end;
end;

{ TMetodoDesativar }

procedure TMetodoDesativar.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    ACBrBAL.Desativar;

    fpCmd.Resposta := 'Balan�a desativada.';
  end;
end;

{ TMetodoAtivo }

procedure TMetodoAtivo.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := BoolToStr(ACBrBAL.Ativo, true);
  end;
end;

{ TMetodoModeloStr }

procedure TMetodoModeloStr.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrBAL.ModeloStr;
  end;
end;

{ TMetodoModelo }

procedure TMetodoModelo.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := GetEnumName(TypeInfo(TACBrBALModelo), Integer(ACBrBAL.Modelo));
  end;
end;

{ TMetodoPorta }

procedure TMetodoPorta.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrBAL.Porta;
  end;
end;

{ TMetodoIntervalo }

procedure TMetodoIntervalo.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := IntToStr( ACBrBAL.Intervalo );
  end;
end;

{ TMetodoSetIntervalo }

{ Params: 0 - Intervalo - Numero Inteiro
}
procedure TMetodoSetIntervalo.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    ACBrBAL.Intervalo := StrToInt( fpCmd.Params(0) );
  end;
end;

{ TMetodoLePeso }

procedure TMetodoLePeso.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    ACBrBAL.LePeso;
    if ACBrBAL.UltimaResposta <> '' then
       fpCmd.Resposta := FormatFloat('#####0.000', ACBrBAL.UltimoPesoLido)
    else
       raise Exception.Create('Timeout');
  end;
end;

{ TMetodoUltimoPesoLido }

procedure TMetodoUltimoPesoLido.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := FormatFloat('#####0.000', ACBrBAL.UltimoPesoLido);
  end;
end;

{ TMetodoUltimaResposta }

procedure TMetodoUltimaResposta.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrBAL.UltimaResposta;
  end;
end;

{ TMetodoMonitorarBanlaca }

procedure TMetodoMonitorarBalanca.Executar;
begin
  with TACBrObjetoBAL(fpObjetoDono) do
  begin
    fpCmd.Resposta := BoolToStr( ACBrBAL.MonitorarBalanca, true );
  end;
end;

end.
