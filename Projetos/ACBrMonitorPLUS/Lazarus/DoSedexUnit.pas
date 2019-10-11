{******************************************************************************}
{ Projeto: ACBr Monitor                                                        }
{  Executavel multiplataforma que faz uso do conjunto de componentes ACBr para }
{ criar uma interface de comunica��o com equipamentos de automacao comercial.  }

{ Direitos Autorais Reservados (c) 2009 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na p�gina do Projeto ACBr     }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

{  Este programa � software livre; voc� pode redistribu�-lo e/ou modific�-lo   }
{ sob os termos da Licen�a P�blica Geral GNU, conforme publicada pela Free     }
{ Software Foundation; tanto a vers�o 2 da Licen�a como (a seu crit�rio)       }
{ qualquer vers�o mais nova.                                                   }

{  Este programa � distribu�do na expectativa de ser �til, mas SEM NENHUMA     }
{ GARANTIA; nem mesmo a garantia impl�cita de COMERCIALIZA��O OU DE ADEQUA��O A}
{ QUALQUER PROP�SITO EM PARTICULAR. Consulte a Licen�a P�blica Geral GNU para  }
{ obter mais detalhes. (Arquivo LICENCA.TXT ou LICENSE.TXT)                    }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral GNU junto com este}
{ programa; se n�o, escreva para a Free Software Foundation, Inc., 59 Temple   }
{ Place, Suite 330, Boston, MA 02111-1307, USA. Voc� tamb�m pode obter uma     }
{ copia da licen�a em:  http://www.opensource.org/licenses/gpl-license.php     }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}
{$I ACBr.inc}

unit DoSedexUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil, ACBrSedex,
  ACBrMonitorConsts, ACBrMonitorConfig, ACBrLibResposta, ACBrLibSedexRespostas,
  ACBrLibSedexConsts;

type

{ TACBrObjetoSedex }

TACBrObjetoSedex = class(TACBrObjetoDFe)
private
  fACBrSedex: TACBrSedex;
public
  constructor Create(AConfig: TMonitorConfig; ACBrSedex: TACBrSedex); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  procedure LerIniSedex(aStr: String);

  procedure RespostaConsulta;
  procedure RespostaItensRastreio(ItemID: integer = 0);

  function ProcessarRespostaSedex : String;
  function ProcessarRespostaRastreio : String;

  property ACBrSedex: TACBrSedex read fACBrSedex;
end;

{ TMetodoConsultar}
TMetodoConsultar = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoRastrear}
TMetodoRastrear = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

{ TACBrObjetoSedex }

constructor TACBrObjetoSedex.Create(AConfig: TMonitorConfig; ACBrSedex: TACBrSedex);
begin
  inherited Create(AConfig);

  fACBrSedex := ACBrSedex;

  ListaDeMetodos.Add(CMetodoConsultar);
  ListaDeMetodos.Add(CMetodoRastrear);
end;

procedure TACBrObjetoSedex.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoConsultar;
    1  : AMetodoClass := TMetodoRastrear;
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

procedure TACBrObjetoSedex.LerIniSedex(aStr: String);
begin
  if not ( ACBrSedex.LerArqIni( aStr ) ) then
      raise exception.Create('Erro ao ler arquivo de entrada ou '+
         'par�metro incorreto.');

end;

procedure TACBrObjetoSedex.RespostaConsulta;
var
  Resp: TLibSedexConsulta;
begin
  Resp := TLibSedexConsulta.Create(resINI, codUTF8);
  try
    with fACBrSedex do
    begin
      Resp.CodigoServico := retCodigoServico;
      Resp.Valor := retValor;
      Resp.PrazoEntrega := retPrazoEntrega;
      Resp.ValorSemAdicionais := retValorSemAdicionais;
      Resp.ValorMaoPropria := retValorMaoPropria;
      Resp.ValorAvisoRecebimento := retValorAvisoRecebimento;
      Resp.ValorValorDeclarado := retValorValorDeclarado;
      Resp.EntregaDomiciliar := retEntregaDomiciliar;
      Resp.EntregaSabado := retEntregaSabado;
      Resp.Erro := retErro;
      Resp.MsgErro := retMsgErro;

      fpCmd.Resposta := retMsgErro + sLineBreak;
      fpCmd.Resposta := fpCmd.Resposta + Resp.Gerar;
    end;
  finally
    Resp.Free;
  end;
end;

procedure TACBrObjetoSedex.RespostaItensRastreio(ItemID: integer);
var
  Resp: TLibSedexRastreio;
begin
  Resp := TLibSedexRastreio.Create(
          CSessaoRespRastreio + Trim(IntToStrZero(ItemID +1, 2)), resINI, codUTF8);
  try
    with fACBrSedex.retRastreio[ItemID] do
    begin
      Resp.DataHora := DataHora;
      Resp.Local := Local;
      Resp.Situacao := Situacao;
      Resp.Observacao := Observacao;

      fpCmd.Resposta := fpCmd.Resposta + Resp.Gerar;
    end;
  finally
    Resp.Free;
  end;
end;

function TACBrObjetoSedex.ProcessarRespostaSedex: String;
begin
  RespostaConsulta;
  Result := fpCmd.Resposta;
end;

function TACBrObjetoSedex.ProcessarRespostaRastreio: String;
var
  I: integer;
begin
  for I := 0 to ACBrSedex.retRastreio.Count - 1 do
    RespostaItensRastreio(I);

  Result := fpCmd.Resposta;
end;

{ TMetodoConsultar }

{ Params: 0 - String com o Path e nome do arquivo ini
}
procedure TMetodoConsultar.Executar;
var
  AIni: String;
begin
  AIni := fpCmd.Params(0);

  with TACBrObjetoSedex(fpObjetoDono) do
  begin
    if AIni <> '' then
      LerIniSedex(AIni);

    ACBrSedex.Consultar;
    RespostaConsulta;
  end;
end;

{ TMetodoRastrear }

{ Params: 0 - String com o c�digo de rastreio
}
procedure TMetodoRastrear.Executar;
var
  I: integer;
begin
  with TACBrObjetoSedex(fpObjetoDono) do
  begin
    ACBrSedex.Rastrear( fpCmd.Params(0) );

    for I := 0 to ACBrSedex.retRastreio.Count - 1 do
      RespostaItensRastreio(I);
  end;
end;

end.
