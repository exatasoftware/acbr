{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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
unit ACBrPAF_M;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils;

type
  //M2 - Cupom de embarque
  TRegistroM2 = class
  private
    fCNPJ: string;                   // CNPJ da matriz da empresa do servi�o de transporte
    fIE: string;                     // Inscri��o Estadual da empresa do servi�o de transporte
    fIM: string;                     // Inscri��o Municipal da empresa do servi�o de transporte
    fNUM_FAB: string;                // N�mero de fabrica��o do ECF
    fMF_ADICIONAL: string;           // Letra indicativa de MF adicional
    fTIPO_ECF: string;               // Tipo de ECF
    fMARCA_ECF: string;              // Marca do ECF
    fMODELO_ECF: string;             // Modelo do ECF
    fNUM_USU: integer;               // N� de ordem do usu�rio do ECF
    fCCF: Integer;                   // CCF
    fCOO: Integer;                   // COO do DAV
    fDT_EMI: TDateTime;              // Data e hora de emiss�o do bilhete de passagem
    fCOD_MOD: String;                // C�digo da modalidade do transporte
    fCOD_CAT: String;                // C�digo da categoria do transporte
    fID_LINHA: string;               // Identifica��o da linha
    fCOD_ORIG: string;               // Codigo do ponto de origem da presta��o do servi�o
    fCOD_DEST: string;               // Codigo do ponto de destino da presta��o do servi�o
    fCOD_TSER: string;               // Codigo do tipo de servi�o
    fDT_VIA: TDateTime;              // Data e hora da viagem
    fTIP_VIA: String;                // Tipo de viagem
    fPOLTRONA: Integer;              // N� da poltrona
    fPLATAFORMA: string;             // Plataforma de embarque
    fCOD_DESC: string;               // C�digo do desconto
    fVL_TARIFA: Currency;            // Valor da tarifa
    fALIQ: currency;                 // Al�quota de ICMS
    fVL_PEDAGIO: Currency;           // Valor do ped�gio
    fVL_TAXA: Currency;              // Valor da taxa de embarque
    fVL_TOTAL: Currency;             // Valor total
    fFORM_PAG: String;               // Forma de pagamento
    fVL_PAGO: Currency;              // Valor pago
    fNOME_PAS: string;               // Nome do passageiro
    fNDOC_PAS: string;               // N� documento do passageiro
    fSAC: string;                    // N� SAC
    fAGENCIA: string;                // Raz�o social da agencia emissora do bilhete
  public
    property CNPJ: string         read fCNPJ         write fCNPJ;
    property IE: string           read fIE           write FIE;
    property IM: string           read FIM           write FIM;
    property NUM_FAB: string      read fNUM_FAB      write fNUM_FAB;
    property MF_ADICIONAL: string read fMF_ADICIONAL write fMF_ADICIONAL;
    property TIPO_ECF: string     read fTIPO_ECF     write fTIPO_ECF;
    property MARCA_ECF: string    read fMARCA_ECF    write fMARCA_ECF;
    property MODELO_ECF: string   read fMODELO_ECF   write fMODELO_ECF;
    property NUM_USU: integer     read fNUM_USU      write fNUM_USU;
    property COO: integer         read fCOO          write fCOO;
    property CCF: integer         read fCCF          write fCCF;
    property DT_EMI: TDateTime    read fDT_EMI       write fDT_EMI;
    property COD_MOD: String      read fCOD_MOD      write fCOD_MOD;
    property COD_CAT: String      read fCOD_CAT      write fCOD_CAT;
    property ID_LINHA: String     read fID_LINHA     write fID_LINHA;
    property COD_ORIG: String     read fCOD_ORIG     write fCOD_ORIG;
    property COD_DEST: String     read fCOD_DEST     write fCOD_DEST;
    property COD_TSER: string     read fCOD_TSER     write fCOD_TSER;
    property DT_VIA: TDateTime    read fDT_VIA       write fDT_VIA;
    property TIP_VIA: String      read fTIP_VIA      write fTIP_VIA;
    property POLTRONA: Integer    read fPOLTRONA     write fPOLTRONA;
    property PLATAFORMA: string   read fPLATAFORMA   write fPLATAFORMA;
    property COD_DESC: string     read fCOD_DESC     write fCOD_DESC;
    property VL_TARIFA: Currency  read fVL_TARIFA    write fVL_TARIFA;
    property ALIQ: Currency       read fALIQ         write fALIQ;
    property VL_PEDAGIO: Currency read fVL_PEDAGIO   write fVL_PEDAGIO;
    property VL_TAXA: Currency    read fVL_TAXA      write fVL_TAXA;
    property VL_TOTAL: Currency   read fVL_TOTAL     write fVL_TOTAL;
    property FORM_PAG: String     read fFORM_PAG     write fFORM_PAG;
    property VL_PAGO: Currency    read fVL_PAGO      write fVL_PAGO;
    property NOME_PAS: string     read fNOME_PAS     write fNOME_PAS;
    property NDOC_PAS: string     read fNDOC_PAS     write fNDOC_PAS;
    property SAC: string          read fSAC          write fSAC;
    property AGENCIA: string      read fAGENCIA      write fAGENCIA;
  end;

  TRegistroM2List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroM2;
    procedure SetItem(Index: Integer; const Value: TRegistroM2);
  public
    function New: TRegistroM2;
    property Items[Index: Integer]: TRegistroM2 read GetItem write SetItem;
  end;

  
implementation

{ TRegistroM2List }
function TRegistroM2List.GetItem(Index: Integer): TRegistroM2;
begin
  Result := TRegistroM2(inherited Items[Index]);
end;

function TRegistroM2List.New: TRegistroM2;
begin
  Result := TRegistroM2.Create;
  Add(Result);
end;

procedure TRegistroM2List.SetItem(Index: Integer;
  const Value: TRegistroM2);
begin
  Put(Index, Value);
end;

end.
