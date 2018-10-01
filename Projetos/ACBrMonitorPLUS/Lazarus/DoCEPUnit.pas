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

unit DoCEPUnit;

interface

uses
  Classes, TypInfo, SysUtils, CmdUnit, ACBrUtil, ACBrCEP,
  ACBrMonitorConsts, ACBrMonitorConfig, ACBrLibResposta, ACBrLibCEPRespostas,
  ACBrLibCEPConsts;

type

{ TACBrObjetoCEP }

TACBrObjetoCEP = class(TACBrObjetoDFe)
private
  fACBrCEP: TACBrCEP;
public
  constructor Create(AConfig: TMonitorConfig; ACBrCEP: TACBrCEP); reintroduce;
  procedure Executar(ACmd: TACBrCmd); override;

  procedure RespostaItensConsulta(ItemID: integer = 0);

  property ACBrCEP: TACBrCEP read fACBrCEP;
end;

{ TMetodoBuscarPorCEP}
TMetodoBuscarPorCEP = class(TACBrMetodo)
public
  procedure Executar; override;
end;

{ TMetodoBuscarPorLogradouro}
TMetodoBuscarPorLogradouro = class(TACBrMetodo)
public
  procedure Executar; override;
end;

implementation

{ TACBrObjetoCEP }

constructor TACBrObjetoCEP.Create(AConfig: TMonitorConfig; ACBrCEP: TACBrCEP);
begin
  inherited Create(AConfig);

  fACBrCEP := ACBrCEP;

  ListaDeMetodos.Add(CMetodoBuscarPorCEP);
  ListaDeMetodos.Add(CMetodoBuscarPorLogradouro);
end;

procedure TACBrObjetoCEP.Executar(ACmd: TACBrCmd);
var
  AMetodoClass: TACBrMetodoClass;
  CmdNum: Integer;
  Ametodo: TACBrMetodo;
begin
  inherited Executar(ACmd);

  CmdNum := ListaDeMetodos.IndexOf(LowerCase(ACmd.Metodo));
  AMetodoClass := Nil;

  case CmdNum of
    0  : AMetodoClass := TMetodoBuscarPorCEP;
    1  : AMetodoClass := TMetodoBuscarPorLogradouro;
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

procedure TACBrObjetoCEP.RespostaItensConsulta(ItemID: integer);
var
  Resp: TLibCEPResposta;
begin
  Resp := TLibCEPResposta.Create(
          CSessaoRespConsulta + IntToStr(ItemID +1), resINI);
  try
    with fACBrCEP.Enderecos[ItemID] do
    begin
      Resp.CEP := CEP;
      Resp.Tipo_Logradouro := Tipo_Logradouro;
      Resp.Logradouro := Logradouro;
      Resp.Logradouro := Logradouro;
      Resp.Complemento := Complemento;
      Resp.Bairro := Bairro;
      Resp.Municipio := Municipio;
      Resp.UF := UF;
      Resp.IBGE_Municipio := IBGE_Municipio;
      Resp.IBGE_UF := IBGE_UF;

      fpCmd.Resposta := fpCmd.Resposta + Resp.Gerar;
    end;
  finally
    Resp.Free;
  end;
end;

{ TMetodoBuscarPorCEP }

{ Params: 0 - CEP
}
procedure TMetodoBuscarPorCEP.Executar;
begin
  with TACBrObjetoCEP(fpObjetoDono) do
  begin
    ACBrCEP.BuscarPorCEP( fpCmd.Params(0) );
    RespostaItensConsulta(0);
  end;
end;

{ TMetodoBuscarPorLogradouro }

{ Params: 0 - Cidade
          1 - Tipo Logradouro Ex: "Rua"
          2 - Logradouro
          3 - UF
          4 - Bairo
}
procedure TMetodoBuscarPorLogradouro.Executar;
var
  I: integer;
begin
  with TACBrObjetoCEP(fpObjetoDono) do
  begin
    ACBrCEP.BuscarPorLogradouro( fpCmd.Params(0), fpCmd.Params(1),
                                 fpCmd.Params(2), fpCmd.Params(3),
                                 fpCmd.Params(4) );

    for I := 0 to ACBrCEP.Enderecos.Count - 1 do
      RespostaItensConsulta(I);
  end;
end;

end.
