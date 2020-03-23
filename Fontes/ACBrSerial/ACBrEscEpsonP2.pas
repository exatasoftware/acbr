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

unit ACBrEscEpsonP2;

interface

uses
  Classes, SysUtils,
  ACBrPosPrinter, ACBrConsts;

type

  { TACBrEscEpsonP2 }

  TACBrEscEpsonP2 = class(TACBrPosPrinterClass)
  private
  public
    constructor Create(AOwner: TACBrPosPrinter);
  end;


implementation

{ TACBrEscEpsonP2 }

constructor TACBrEscEpsonP2.Create(AOwner: TACBrPosPrinter);
var
  I: Integer;
begin
  inherited Create(AOwner);

  fpModeloStr := 'EscEpsonP2';

{(*}
  with Cmd  do
  begin
    Zera                    := ESC + '@'+SI;
    PuloDeLinha             := LF;
    EspacoEntreLinhasPadrao := ESC + '2';
    EspacoEntreLinhas       := ESC + '0';
    LigaNegrito             := ESC + 'G';
    DesligaNegrito          := ESC + 'H';
    LigaExpandido           := ESC + 'W1';
    DesligaExpandido        := ESC + 'W0';
    LigaSublinhado          := ESC + '-' + #1;
    DesligaSublinhado       := ESC + '-' + #0;
    LigaItalico             := ESC + '4';
    DesligaItalico          := ESC + '5';
    LigaCondensado          := SI;
    DesligaCondensado       := DC2;
    FonteNormal             := LigaCondensado;   //ESC + 'P' + DesligaCondensado + DesligaItalico;
    FonteA                  := DesligaCondensado;
    FonteB                  := LigaCondensado;
  end;
  {*)}

  For I := 0 to (Length(cTAGS_BARRAS) -1)  do
    TagsNaoSuportadas.Add( cTAGS_BARRAS[I] );

  For I := 0 to (Length(cTAGS_ALINHAMENTO) -1)  do
    TagsNaoSuportadas.Add( cTAGS_ALINHAMENTO[I] );

  TagsNaoSuportadas.Add( cTagLigaInvertido );
  TagsNaoSuportadas.Add( cTagDesligaInvertido );
  TagsNaoSuportadas.Add( cTagCorteParcial );
  TagsNaoSuportadas.Add( cTagCorteTotal );
  TagsNaoSuportadas.Add( cTagLogoImprimir );
  TagsNaoSuportadas.Add( cTagAbreGaveta );
  TagsNaoSuportadas.Add( cTagAbreGavetaEsp );
  TagsNaoSuportadas.Add( cTagBeep );
  TagsNaoSuportadas.Add( cTagModoPaginaLiga );
end;

end.
