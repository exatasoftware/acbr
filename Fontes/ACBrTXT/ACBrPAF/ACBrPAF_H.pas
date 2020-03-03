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

unit ACBrPAF_H;

interface

uses
  SysUtils, Classes, Contnrs, DateUtils, ACBrPAFRegistros;

type
  /// REGISTRO TIPO H1 - IDENTIFICA��O DO ESTABELECIMENTO USU�RIO DO PAF-ECF

  TRegistroH1 = class(TRegistroX1)
  private
    fDT_EST: TDateTime;
    fMODELO_ECF: string;
    fMARCA_ECF: string;
    fTIPO_ECF: string;
    fNUM_FAB: string;
    fMF_ADICIONAL: string;
    fRegistroValido: Boolean;
  public
    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;
    property NUM_FAB: string read fNUM_FAB write fNUM_FAB;
    property MF_ADICIONAL: string read fMF_ADICIONAL write fMF_ADICIONAL;
    property TIPO_ECF: string read fTIPO_ECF write fTIPO_ECF;
    property MARCA_ECF: string read fMARCA_ECF write fMARCA_ECF;
    property MODELO_ECF: string read fMODELO_ECF write fMODELO_ECF;
    property DT_EST: TDateTime read fDT_EST write fDT_EST;
  end;

  /// REGISTRO TIPO H2 - TROCO EM CART�O CONFORME ANEXO XV

  TRegistroH2 = class
  private
    fRegistroValido: boolean;
    fCNPJ_CRED_CARTAO : string; /// Identifica��o da credenciadora do cart�o
    fNUM_FAB: string;                // N�mero de fabrica��o do ECF
    fMF_ADICIONAL: string;           // Letra indicativa de MF adicional
    fTIPO_ECF: string;               // Tipo de ECF
    fMARCA_ECF: string;              // Marca do ECF
    fMODELO_ECF: string;             // Modelo do ECF
    fCOO: Integer;     /// Contador de Ordem de Opera��o do Cupom Fiscal onde o troco foi registrado
    fCCF: Integer;    /// N� do contador do respectivo documento emitido
    fVLR_TROCO: Currency;       /// Valor do troco, para o meio de pagamento cart�o de cr�dito ou d�bito
    fDT_TROCO: TDateTime;   /// Data da emiss�o do Cupom Fiscal
    fCPF : string; /// CPF do adquirente do t�tulo de captaliza��o
    fTitulo : Integer; /// N� do t�tulo de captaliza��o adquirido
    FCNPJ: string; /// CNPJ da entidade recebedora da doa��o
  public
    constructor Create; virtual; /// Create

    property RegistroValido: Boolean read fRegistroValido write fRegistroValido default True;

    property CNPJ_CRED_CARTAO: string read fCNPJ_CRED_CARTAO write fCNPJ_CRED_CARTAO;
    property NUM_FAB: string      read fNUM_FAB      write fNUM_FAB;
    property MF_ADICIONAL: string read fMF_ADICIONAL write fMF_ADICIONAL;
    property TIPO_ECF: string     read fTIPO_ECF     write fTIPO_ECF;
    property MARCA_ECF: string    read fMARCA_ECF    write fMARCA_ECF;
    property MODELO_ECF: string   read fMODELO_ECF   write fMODELO_ECF;
    property COO: Integer read fCOO write fCOO;
    property CCF: Integer read fCCF write fCCF;
    property VLR_TROCO: Currency read fVLR_TROCO write fVLR_TROCO;
    property DT_TROCO: TDateTime read fDT_TROCO write fDT_TROCO;
    property CPF: string read fCPF write fCPF;
    property Titulo: Integer read fTitulo write fTitulo;
    property CNPJ: string read FCNPJ write FCNPJ;
  end;

  /// REGISTRO H2 - Lista

  TRegistroH2List = class(TObjectList)
  private
    function GetItem(Index: Integer): TRegistroH2;
    procedure SetItem(Index: Integer; const Value: TRegistroH2);
  public
    function New: TRegistroH2;
    property Items[Index: Integer]: TRegistroH2 read GetItem write SetItem;
  end;

  /// REGISTRO TIPO H9 - TOTALIZA��O DO ARQUIVO

  TRegistroH9 = class(TRegistroX9)
  end;

implementation

(* TRegistroH2List *)

function TRegistroH2List.GetItem(Index: Integer): TRegistroH2;
begin
  Result := TRegistroH2(inherited Items[Index]);
end;

function TRegistroH2List.New: TRegistroH2;
begin
  Result := TRegistroH2.Create;
  Add(Result);
end;

procedure TRegistroH2List.SetItem(Index: Integer; const Value: TRegistroH2);
begin
  Put(Index, Value);
end;

{ TRegistroH2 }

constructor TRegistroH2.Create;
begin
   fRegistroValido := True;
end;

end.
