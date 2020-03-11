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

unit pcnCFeCancR;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnLeitor, pcnCFeCanc;

type

{ TCFeCancR }

  TCFeCancR = class(TPersistent)
  private
    FLeitor: TLeitor;
    FCFeCanc: TCFeCanc;
  public
    constructor Create(AOwner: TCFeCanc);
    destructor Destroy; override;
    function LerXml: boolean;
  published
    property Leitor: TLeitor read FLeitor write FLeitor;
    property CFeCanc: TCFeCanc read FCFeCanc write FCFeCanc;
  end;

implementation

uses
  ACBrConsts, ACBrUtil;

{ TCFeCancR }

constructor TCFeCancR.Create(AOwner: TCFeCanc);
begin
  inherited Create;
  FLeitor := TLeitor.Create;
  FCFeCanc := AOwner;
end;

destructor TCFeCancR.Destroy;
begin
  FLeitor.Free;
  inherited Destroy;
end;

function TCFeCancR.LerXml: boolean;
var
  i : integer;
begin
  CFeCanc.Clear;

  (* Grupo da TAG <ide> *******************************************************)
  if Leitor.rExtrai(1, 'infCFe') <> '' then
  begin
    CFeCanc.infCFe.ID     := Leitor.rAtributo( 'Id' ) ;
    CFeCanc.infCFe.ID     := StringReplace( UpperCase(CFeCanc.infCFe.ID), 'CFE', '', [rfReplaceAll] ) ;
    CFeCanc.infCFe.versao := StringToFloatDef( Leitor.rAtributo( 'versao' ), 0) ;

    (*A06*) CFeCanc.infCFe.chCanc := Leitor.rAtributo('chCanc');
    (*A07*) CFeCanc.infCFe.dEmi := Leitor.rCampo(tcDatCFe, 'dEmi');
    (*A08*) CFeCanc.infCFe.hEmi := Leitor.rCampo(tcHorCFe, 'hEmi');
  end;

  (* Grupo da TAG <ide> *******************************************************)
  if Leitor.rExtrai(1, 'ide') <> '' then
  begin
    (*B02*) CFeCanc.ide.cUF := Leitor.rCampo(tcInt, 'cUF');
    (*B03*) CFeCanc.ide.cNF := Leitor.rCampo(tcInt, 'cNF');
    (*B04*) CFeCanc.ide.modelo := Leitor.rCampo(tcInt, 'mod');
    (*B05*) CFeCanc.ide.nserieSAT := Leitor.rCampo(tcInt, 'nserieSAT');
    (*B06*) CFeCanc.ide.nCFe := Leitor.rCampo(tcInt, 'nCFe');
    (*B07*) CFeCanc.ide.dEmi := Leitor.rCampo(tcDatCFe, 'dEmi');
    (*B08*) CFeCanc.ide.hEmi := Leitor.rCampo(tcHorCFe, 'hEmi');
    (*B09*) CFeCanc.Ide.cDV := Leitor.rCampo(tcInt, 'cDV');
    (*B11*) CFeCanc.Ide.CNPJ := Leitor.rCampo(tcEsp, 'CNPJ');
    (*B12*) CFeCanc.Ide.signAC := Leitor.rCampo(tcStr, 'signAC');
    (*B13*) CFeCanc.Ide.assinaturaQRCODE := Leitor.rCampo(tcStr, 'assinaturaQRCODE');
    (*B14*) CFeCanc.ide.numeroCaixa := Leitor.rCampo(tcInt, 'numeroCaixa');
  end;

  (* Grupo da TAG <emit> ******************************************************)
  if Leitor.rExtrai(1, 'emit') <> '' then
  begin
    (*C02/C02a*)CFeCanc.Emit.CNPJ := Leitor.rCampoCNPJCPF;
    (*C03*)CFeCanc.Emit.xNome := Leitor.rCampo(tcStr, 'xNome');
    (*C04*)CFeCanc.Emit.xFant := Leitor.rCampo(tcStr, 'xFant');
    (*C12*)CFeCanc.Emit.IE := Leitor.rCampo(tcStr, 'IE');
    (*C13*)CFeCanc.Emit.IM := Leitor.rCampo(tcStr, 'IM');

    if Leitor.rExtrai(2, 'enderEmit') <> '' then
    begin
      (*C06*)CFeCanc.Emit.enderEmit.xLgr := Leitor.rCampo(tcStr, 'xLgr');
      (*C07*)CFeCanc.Emit.enderEmit.nro := Leitor.rCampo(tcStr, 'nro');
      (*C08*)CFeCanc.Emit.enderEmit.xCpl := Leitor.rCampo(tcStr, 'xCpl');
      (*C09*)CFeCanc.Emit.enderEmit.xBairro := Leitor.rCampo(tcStr, 'xBairro');
      (*C10*)CFeCanc.Emit.enderEmit.xMun := Leitor.rCampo(tcStr, 'xMun');
      (*C11*)CFeCanc.Emit.enderEmit.CEP := Leitor.rCampo(tcInt, 'CEP');
    end;
  end;

  (* Grupo da TAG <dest> ******************************************************)
  if Leitor.rExtrai(1, 'dest') <> '' then
  begin
    (*E02/E03*)CFeCanc.Dest.CNPJCPF := Leitor.rCampoCNPJCPF;
  end;

  (* Grupo da TAG <total> *****************************************************)
  if Leitor.rExtrai(1, 'total') <> '' then
  begin
    (*W11*)CFeCanc.Total.vCFe := Leitor.rCampo(tcDe2, 'vCFe');
  end;

  (* Grupo da TAG <InfAdic> ***************************************************)
  if Leitor.rExtrai(1, 'infAdic') <> '' then
  begin
    i := 0;
    while Leitor.rExtrai(2, 'obsFisco', '', i + 1) <> '' do
    begin
      CFeCanc.InfAdic.obsFisco.New;
      (*Z04*)CFeCanc.InfAdic.obsFisco[i].xCampo := Leitor.rAtributo('xCampo');
      (*Z05*)CFeCanc.InfAdic.obsFisco[i].xTexto := Leitor.rCampo(tcStr, 'xTexto');
      inc(i)
    end;
  end;

  (* Grupo da TAG <signature> *************************************************)
  leitor.Grupo := Leitor.Arquivo;

  CFeCanc.signature.URI := Leitor.rAtributo('Reference URI=');
  CFeCanc.signature.DigestValue := Leitor.rCampo(tcStr, 'DigestValue');
  CFeCanc.signature.SignatureValue := Leitor.rCampo(tcStr, 'SignatureValue');
  CFeCanc.signature.X509Certificate := Leitor.rCampo(tcStr, 'X509Certificate');

  Result := True;
end;

end.
