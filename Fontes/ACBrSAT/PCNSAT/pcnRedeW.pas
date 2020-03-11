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

unit pcnRedeW;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador, pcnRede, ACBrUtil;

type

  { TRedeW }

  TRedeW = class(TPersistent)
  private
    FGerador: TGerador;
    FRede: TRede;
    function GetOpcoes: TGeradorOpcoes;
  public
    constructor Create(AOwner: TRede);
    destructor Destroy; override;
    function GerarXml: boolean;
  published
    property Gerador: TGerador read FGerador;
    property Rede: TRede read FRede write FRede;
    property Opcoes: TGeradorOpcoes read GetOpcoes;
  end;

implementation

{ TCFeW }

constructor TRedeW.Create(AOwner: TRede);
begin
  inherited Create;
  FRede := AOwner;
  FGerador := TGerador.Create;
end;

destructor TRedeW.Destroy;
begin
  FGerador.Free;
  inherited Destroy;
end;

function TRedeW.GetOpcoes: TGeradorOpcoes;
begin
  Result := FGerador.Opcoes;
end;

function TRedeW.GerarXml(): boolean;
begin
  Gerador.LayoutArquivoTXT.Clear;

  {$IFDEF UNICODE}
   Gerador.ArquivoFormatoXML := '<'+ENCODING_UTF8+'>';
   if Gerador.Opcoes.IdentarXML then
     Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML + #13#10;
  {$ELSE}
   Gerador.ArquivoFormatoXML := '';
  {$ENDIF}

  Gerador.ArquivoFormatoTXT := '';

  Gerador.wGrupo('config');
  Gerador.wCampo(tcStr, 'C01', 'tipoInter', 1, 4, 1, TipoInterfaceToStr(Rede.tipoInter),
    'Tipo de interface de rede utilizada pelo Equipamento');

  if Rede.tipoInter = infWIFI then
  begin
    Gerador.wCampo(tcStr, 'C02', 'SSID', 1, 32, 0, Rede.SSID, 'Nome da rede sem fio do estabelecimento');
    Gerador.wCampo(tcStr, 'C03', 'seg', 1, 25, 0, SegSemFioToStr(Rede.seg),
      'Se a rede sem fio possui algum tipo de seguran�a');
    Gerador.wCampo(tcStr, 'C04', 'codigo', 1, 64, 0, Rede.codigo, 'Frase ou chave de acesso � rede sem fio');
  end;

  Gerador.wCampo(tcStr, 'C05', 'tipoLan', 1, 8, 1, TipoLanToStr(Rede.tipoLan), 'Tipo de Rede LAN utilizada');

  case Rede.tipoLan of
    lanIPFIX :
      begin
        Gerador.wCampo(tcStr, 'C06', 'lanIP', 1, 15, 0, Rede.lanIP, 'Endere�o IP');
        Gerador.wCampo(tcStr, 'C07', 'lanMask', 1, 15, 0, Rede.lanMask, 'M�scara de sub-rede');
        Gerador.wCampo(tcStr, 'C08', 'lanGW', 1, 15, 0, Rede.lanGW, 'Gateway Padr�o');
        Gerador.wCampo(tcStr, 'C09', 'lanDNS1', 1, 15, 0, Rede.lanDNS1, 'DNS preferencial');
        Gerador.wCampo(tcStr, 'C10', 'lanDNS2', 1, 15, 0, Rede.lanDNS2, 'DNS alternativo');
      end;

    lanPPPoE :
      begin
        Gerador.wCampo(tcStr, 'C11', 'usuario', 1, 64, 0, Rede.usuario,
           'Se a rede necessitar de usu�rio para obten��o do endere�o IP');
        Gerador.wCampo(tcStr, 'C12', 'senha', 1, 64, 0, Rede.senha,
           'Se a rede necessitar de senha para obten��o do endere�o IP');
      end;
  end;

  Gerador.wCampo(tcInt, 'C13', 'proxy', 1, 1, 1, Rede.proxy,
     '0= N�o usa proxy, 1= Proxy com configura��o, 2= Proxy transparente');

  if Rede.proxy > 0 then
  begin
    Gerador.wCampo(tcStr, 'C14', 'proxy_ip', 1, 15, 0, Rede.proxy_ip, 'Endere�o IP do Servidor Proxy');
    Gerador.wCampo(tcInt, 'C15', 'proxy_porta', 1, 5, 0, Rede.proxy_porta, 'Porta TCP do Servidor Proxy');
    Gerador.wCampo(tcStr, 'C16', 'proxy_user', 1, 64, 0, Rede.proxy_user,
       'Se o proxy necessitar de usu�rio para navega��o');
    Gerador.wCampo(tcStr, 'C17', 'proxy_senha', 1, 64, 0, Rede.proxy_senha,
       'Se o proxy necessitar de senha para navega��o');
  end;

  Gerador.wGrupo('/config');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

