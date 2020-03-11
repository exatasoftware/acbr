{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
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

unit pcnRedeR;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnLeitor, pcnRede;

type

{ TCFeR }

  TRedeR = class(TPersistent)
  private
    FLeitor: TLeitor;
    FRede: TRede;
  public
    constructor Create(AOwner: TRede);
    destructor Destroy; override;
    function LerXml: boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property Rede: TRede read FRede write FRede;
  end;

implementation

uses ACBrConsts;

{ TCFeR }

constructor TRedeR.Create(AOwner: TRede);
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FRede := AOwner;
end;

destructor TRedeR.Destroy;
begin
  FLeitor.Free;
  inherited Destroy;
end;

function TRedeR.LerXml: boolean;
var
  ok: boolean;
begin
  Rede.Clear;
  ok := true;

  if Leitor.rExtrai(1, 'config') <> '' then
  begin
    Rede.tipoInter  := StrToTipoInterface(ok, Leitor.rCampo(tcStr, 'tipoInter'));
    Rede.SSID       := Leitor.rCampo(tcStr, 'SSID');
    Rede.seg        := StrToSegSemFio(ok, Leitor.rCampo(tcStr, 'sef'));
    Rede.codigo     := Leitor.rCampo(tcStr, 'codigo');
    Rede.tipoLan    := StrToTipoLan(ok, Leitor.rCampo(tcStr, 'tipoLan'));
    Rede.lanIP      := Leitor.rCampo(tcStr, 'lanIP');
    Rede.lanMask    := Leitor.rCampo(tcStr, 'lanMask');
    Rede.lanGW      := Leitor.rCampo(tcStr, 'lanGW');
    Rede.lanDNS1    := Leitor.rCampo(tcStr, 'lanDNS1');
    Rede.lanDNS2    := Leitor.rCampo(tcStr, 'lanDNS2');
    Rede.usuario    := Leitor.rCampo(tcStr, 'usuario');
    Rede.senha      := Leitor.rCampo(tcStr, 'senha');
    Rede.proxy      := Leitor.rCampo(tcInt, 'proxy');
    Rede.proxy_ip   := Leitor.rCampo(tcStr, 'proxy_ip');
    Rede.proxy_porta:= Leitor.rCampo(tcInt, 'proxy_porta');
    Rede.proxy_user := Leitor.rCampo(tcStr, 'proxy_user');
    Rede.proxy_senha:= Leitor.rCampo(tcStr, 'proxy_senha');
  end;

  Result := True;
end;

end.
