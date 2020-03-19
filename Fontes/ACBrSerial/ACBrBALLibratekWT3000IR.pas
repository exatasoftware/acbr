{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andre Adami                                     }
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

{ ******************************************************************************
  |* Historico
  |*
  |* 19/12/2019 - Andre Adami
  |*  - Primeira Versao ACBrBALLibratekWT3000IR
  ****************************************************************************** }

{$I ACBr.inc}

unit ACBrBALLibratekWT3000IR;

interface

uses
  Classes,
  ACBrBALClass
  {$IFDEF NEXTGEN}
   ,ACBrBase
  {$ENDIF};

type

  TACBrBALLibratekWT3000IR = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

Uses
  SysUtils, Math,
  ACBrConsts, ACBrUtil,
  {$IFDEF COMPILER6_UP}
   DateUtils, StrUtils
  {$ELSE}
   ACBrD5, Windows
  {$ENDIF};

{ TACBrBALLibratekWT3000IRWT3000IR }

constructor TACBrBALLibratekWT3000IR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fpModeloStr := 'Libratek WT3000IR';
end;

function TACBrBALLibratekWT3000IR.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  TempResposta: string;
begin
  TempResposta := Trim(Copy(aResposta, 1, 19));

  //ST,GS,+   0.298  kg[CR][LF]

  //ST,GS,+   0.298  kg[CR][LF]

  { Ajustando o separador de Decimal corretamente }
  TempResposta := trim(StringReplace(TempResposta, '.', DecimalSeparator, [rfReplaceAll]));
  TempResposta := trim(StringReplace(TempResposta, ',', DecimalSeparator, [rfReplaceAll]));

  case AnsiIndexStr(Copy(aResposta, 1, 2), ['ST', 'OL', 'US']) of
    0:
      fpUltimoPesoLido := StrToFloat(copy(TempResposta, 8, 8)); // Est�vel
    1:
      if fpUltimaResposta[7] = '-' then
        fpUltimoPesoLido := -2 // Peso negativo
      else
        fpUltimoPesoLido := -10; // Sobrecarga de peso
    2:
      fpUltimoPesoLido := -1; // Inst�vel
  else
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;
  Result := fpUltimoPesoLido;
end;

end.
