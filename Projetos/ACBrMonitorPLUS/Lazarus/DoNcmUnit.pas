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

unit DoNcmUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil, ACBrNCMs,
  ACBrMonitorConsts, ACBrMonitorConfig;

type

{ TACBrObjetoNcm }

TACBrObjetoNcm = class(TACBrObjetoDFe)
private
  fACBrNcm: TACBrNcms;
public
  constructor Create(AConfig: TMonitorConfig; ACBrNcm: TACBrNcms); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  property ACBrNcm: TACBrNcms read fACBrNcm;
end;

{ TMetodoValidar}
TMetodoValidar = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoBaixarLista}
TMetodoBaixarLista = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoDescricaoNCM}
TMetodoDescricaoNCM = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

{ TACBrObjetoNcm }

constructor TACBrObjetoNcm.Create(AConfig: TMonitorConfig; ACBrNcm: TACBrNcms);
begin
  inherited Create(AConfig);

  fACBrNcm := ACBrNcm;

  ListaDeMetodos.Add(CMetodoValidar);
  ListaDeMetodos.Add(CMetodoBaixarLista);
  ListaDeMetodos.Add(CMetodoDescricaoNCM);
end;

procedure TACBrObjetoNcm.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoValidar;
    1  : AMetodoClass := TMetodoBaixarLista;
    2  : AMetodoClass := TMetodoDescricaoNCM;
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

{ TMetodoValidar }

{ Params: 0 - String com o codigo Ncm
}
procedure TMetodoValidar.Executar;
var
  ANCM: String;
begin
  ANCM := OnlyNumber(fpCmd.Params(0));

  with TACBrObjetoNcm(fpObjetoDono) do
  begin
    fpCmd.Resposta := 'NCM Valido';

    if (Length(ANCM) <> 8) then
      raise Exception.Create('O codigo do NCM deve conter 8 Caracteres');

    if not  ACBrNcm.validar(ANCM) then
      raise Exception.Create('NCM Invalido');
  end;
end;

{ TMetodoBaixarLista }

{ Params: 0 - String com o nome do Arquivo a ser salvo em disco
}
procedure TMetodoBaixarLista.Executar;
var
  FileName: String;
begin
  FileName := fpCmd.Params(0);

  with TACBrObjetoNcm(fpObjetoDono) do
  begin
    ACBrNcm.ListarNcms();
    ACBrNcm.NCMS.SaveToFile( FileName );

    fpCmd.Resposta := 'Arquivo salvo em: ' + FileName;
  end;
end;

{ TMetodoDescricaoNCM }

{ Params: 0 - String com o NCM
}
procedure TMetodoDescricaoNCM.Executar;
begin
  with TACBrObjetoNcm(fpObjetoDono) do
  begin
    fpCmd.Resposta := ACBrNcm.DescricaoNcm( fpCmd.Params(0) );
  end;
end;

end.
