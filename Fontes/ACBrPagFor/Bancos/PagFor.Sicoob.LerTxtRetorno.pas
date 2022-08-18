{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

unit PagFor.Sicoob.LerTxtRetorno;

interface

uses
  SysUtils, Classes,
  ACBrPagForClass, ACBrPagForConversao,
  CNAB240.LerTxtRetorno;

type
 { TArquivoR_Sicoob }

  TArquivoR_Sicoob = class(TArquivoR_CNAB240)
  protected
    {
    procedure LerRegistro0; override;

    procedure LerRegistro1(I: Integer); override;

    procedure LerRegistro5(I: Integer); override;

    procedure LerRegistro9(I: Integer); override;

    procedure LerSegmentoA(I: Integer); override;

    procedure LerSegmentoB(mSegmentoBList: TSegmentoBList; I: Integer); override;

    procedure LerSegmentoC(mSegmentoCList: TSegmentoCList; I: Integer); override;

    procedure LerSegmentoE(mSegmentoEList: TSegmentoEList; I: Integer); override;

    procedure LerSegmentoF(mSegmentoFList: TSegmentoFList; I: Integer); override;

    procedure LerSegmentoG(I: Integer); override;

    procedure LerSegmentoH(mSegmentoHList: TSegmentoHList; I: Integer); override;

    procedure LerSegmentoJ(I: Integer; var LeuRegistroJ: boolean); override;

    procedure LerSegmentoJ52(mSegmentoJ52List: TSegmentoJ52List; I: Integer); override;

    procedure LerSegmentoJ99(mSegmentoJ99List: TSegmentoJ99List; I: Integer); override;

    procedure LerSegmentoN(mSegmentoN: TSegmentoN); override;

    procedure LerSegmentoN1(I: Integer); override;

    procedure LerSegmentoN2(I: Integer); override;

    procedure LerSegmentoN3(I: Integer); override;

    procedure LerSegmentoN4(I: Integer); override;

    procedure LerSegmentoN567(I: Integer); override;

    procedure LerSegmentoN8(I: Integer); override;

    procedure LerSegmentoN9(I: Integer); override;

    procedure LerSegmentoO(I: Integer); override;

    procedure LerSegmentoW(mSegmentoWList: TSegmentoWList; I: Integer); override;

    procedure LerSegmentoZ(mSegmentoZList: TSegmentoZList; I: Integer); override;

    function GetOcorrencia(aOcorrencia: TOcorrencia): string; override;
    }
  end;

implementation

{ TArquivoR_Sicoob }

{
Se as ocorrencias seguem o padr�o FEBRABAN esse bloco pode ser excluido

function TArquivoR_Sicoob.GetOcorrencia(aOcorrencia: TOcorrencia): string;
begin
  case aOcorrencia of
    to00: Result := 'Descri��o da ocorrencia que � fora do padr�o FEBRABAN';
  else
    Result := inherited GetOcorrencia(aOcorrencia);
  end;
end;
}
end.

