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

unit ACBrEscZJiang;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrEscPosEpson
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  { TACBrEscCustomPos }

  { TACBrEscZJiang }

  TACBrEscZJiang = class(TACBrEscPosEpson)
  protected
    procedure VerificarKeyCodes; override;
  public
    constructor Create(AOwner: TACBrPosPrinter);

    function ComandoQrCode(const ACodigo: AnsiString): AnsiString; override;
  end;

implementation

uses
  strutils, math,
  ACBrUtil, ACBrConsts;

{ TACBrEscZJiang }

constructor TACBrEscZJiang.Create(AOwner: TACBrPosPrinter);
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscZJiang';

  {(*}
    with Cmd  do
    begin
      CorteTotal        := GS  + 'V' + #1;        // Only the partial cut is available; there is no full cut
      Beep              := ESC + 'B' + #1 + #3;   // n - Refers to the number of buzzer times,
      LigaModoPagina    := '';
      DesligaModoPagina := '';
      ImprimePagina     := '';
    end;
    {*)}

    TagsNaoSuportadas.Add( cTagModoPaginaLiga );
    TagsNaoSuportadas.Add( cTagModoPaginaDesliga );
    TagsNaoSuportadas.Add( cTagModoPaginaImprimir );
    TagsNaoSuportadas.Add( cTagModoPaginaDirecao );
    TagsNaoSuportadas.Add( cTagModoPaginaPosEsquerda );
    TagsNaoSuportadas.Add( cTagModoPaginaPosTopo );
    TagsNaoSuportadas.Add( cTagModoPaginaLargura );
    TagsNaoSuportadas.Add( cTagModoPaginaAltura );
    TagsNaoSuportadas.Add( cTagModoPaginaEspaco );
    TagsNaoSuportadas.Add( cTagModoPaginaConfigurar );
end;

procedure TACBrEscZJiang.VerificarKeyCodes;
begin
  with fpPosPrinter.ConfigLogo do
  begin
    if (KeyCode1 <> 1) or (KeyCode2 <> 0) then
      raise EPosPrinterException.Create(fpModeloStr+' apenas aceitas KeyCode1=1, KeyCode2=0');
  end;
end;

function TACBrEscZJiang.ComandoQrCode(const ACodigo: AnsiString): AnsiString;
var
  EC: AnsiChar;
begin
  with fpPosPrinter.ConfigQRCode do
  begin
     case ErrorLevel of
       1: EC := 'M';
       2: EC := 'Q';
       3: EC := 'H';
     else
       EC := 'L';
     end;

     Result := ESC + 'Z' +                          // Coamndo de QRCode
               #0 +                             // m means specified version.(1~40,0:Auto size)
               EC +                             // n specifies the EC level.(L:7%,M:15%,Q:25%,H:30%)
               AnsiChr(min(8,LarguraModulo)) +  // k specified component type.(1~8)
               IntToLEStr(length(ACodigo))   +  // dL + dH
               ACodigo;
  end;
end;

end.

