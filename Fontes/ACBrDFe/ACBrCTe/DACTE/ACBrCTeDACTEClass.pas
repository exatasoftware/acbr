{******************************************************************************}
{ Projeto: Componente ACBrCTe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Conhecimen-}
{ to de Transporte eletr�nico - CTe - http://www.cte.fazenda.gov.br            }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Wiliam Zacarias da Silva Rosa          }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Desenvolvimento                                                              }
{         de Cte: Wiliam Zacarias da Silva Rosa                                }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Wiliam Zacarias da Silva Rosa - wiliamzsr@motta.com.br                       }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 19/08/2009: Wiliam Rosa
|*  - Defini��o de classes para impress�o do DACTE
*******************************************************************************}

{$I ACBr.inc}

unit ACBrCTeDACTEClass;

interface

uses
  SysUtils, Classes, ACBrBase,
  pcteCTE, pcnConversao;

type
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrCTeDACTEClass = class(TACBrComponent)
  private
    function GetPathPDF: String;
    procedure SetPathPDF(const Value: String);
    procedure SetCTE(const Value: TComponent);
    procedure ErroAbstract(NomeProcedure: String);
  protected
    FACBrCTE: TComponent;
    FLogo: String;
    FSistema: String;
    FUsuario: String;
    FPathPDF: String;
    FUsarSeparadorPathPDF: Boolean;
    FImpressora: String;
    FImprimirHoraSaida: Boolean;
    FImprimirHoraSaida_Hora: String;
    FMostrarPreview: Boolean;
    FMostrarStatus: Boolean;
    FTipoDACTE: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FNumCopias: Integer;
    FExpandirLogoMarca: Boolean;
    FFax: String;
    FSite: String;
    FEmail: String;
	  FProtocoloCTE: String;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    FCTeCancelada: Boolean;
    FResumoCanhoto: Boolean;
    FEPECEnviado: Boolean;
    FPosCanhoto: TPosRecibo;
    FImprimirDescPorc: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDACTE(CTE: TCTE = nil); virtual;
    procedure ImprimirDACTEPDF(CTE: TCTE = nil); virtual;
    procedure ImprimirEVENTO(CTE: TCTe = nil); virtual;
    procedure ImprimirEVENTOPDF(CTE: TCTe = nil); virtual;
    procedure ImprimirINUTILIZACAO(CTE: TCTe = nil); virtual;
    procedure ImprimirINUTILIZACAOPDF(CTE: TCTe = nil); virtual;
  published
    property ACBrCTE: TComponent            read FACBrCTE                write SetCTE;
    property Logo: String                   read FLogo                   write FLogo;
    property Sistema: String                read FSistema                write FSistema;
    property Usuario: String                read FUsuario                write FUsuario;
    property PathPDF: String                read GetPathPDF              write SetPathPDF;
    property UsarSeparadorPathPDF: Boolean  read FUsarSeparadorPathPDF   write FUsarSeparadorPathPDF default False;
    property Impressora: String             read FImpressora             write FImpressora;
    property ImprimirHoraSaida: Boolean     read FImprimirHoraSaida      write FImprimirHoraSaida;
    property ImprimirHoraSaida_Hora: String read FImprimirHoraSaida_Hora write FImprimirHoraSaida_Hora;
    property MostrarPreview: Boolean        read FMostrarPreview         write FMostrarPreview;
    property MostrarStatus: Boolean         read FMostrarStatus          write FMostrarStatus;
    property TipoDACTE: TpcnTipoImpressao   read FTipoDACTE              write FTipoDACTE;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel           write FTamanhoPapel;
    property NumCopias: Integer             read FNumCopias              write FNumCopias;
    property Fax: String                    read FFax                    write FFax;
    property Site: String                   read FSite                   write FSite;
    property Email: String                  read FEmail                  write FEmail;
    property ProtocoloCTE: String           read FProtocoloCTE           write FProtocoloCTE;
    property MargemInferior: Double         read FMargemInferior         write FMargemInferior;
    property MargemSuperior: Double         read FMargemSuperior         write FMargemSuperior;
    property MargemEsquerda: Double         read FMargemEsquerda         write FMargemEsquerda;
    property MargemDireita: Double          read FMargemDireita          write FMargemDireita;
    property ExpandirLogoMarca: Boolean     read FExpandirLogoMarca      write FExpandirLogoMarca default false;
    property CTeCancelada: Boolean          read FCTeCancelada           write FCTeCancelada;
    property ExibirResumoCanhoto: Boolean   read FResumoCanhoto          write FResumoCanhoto;
    property EPECEnviado: Boolean           read FEPECEnviado            write FEPECEnviado;
    property PosCanhoto: TPosRecibo         read FPosCanhoto             write FPosCanhoto default prCabecalho;
    property ImprimirDescPorc: Boolean      read FImprimirDescPorc       write FImprimirDescPorc;
  end;

implementation

uses
  ACBrCTe, ACBrUtil;

constructor TACBrCTeDACTEClass.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FACBrCTE    := nil;
  FLogo       := '';
  FSistema    := '';
  FUsuario    := '';
  FUsarSeparadorPathPDF := False;
  FPathPDF    := '';
  FImpressora := '';

  FImprimirHoraSaida      := False;
  FImprimirHoraSaida_Hora := '';

  FMostrarPreview := True;
  FMostrarStatus  := True;
  FNumCopias      := 1;

  FFax   := '';
  FSite  := '';
  FEmail := '';

  FProtocoloCTE    := '';

  FMargemInferior := 0.8;
  FMargemSuperior := 0.8;
  FMargemEsquerda := 0.6;
  FMargemDireita  := 0.51;
  FCTeCancelada   := False;

  FResumoCanhoto := False; 
  FEPECEnviado   := False;
end;

destructor TACBrCTeDACTEClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrCTeDACTEClass.ImprimirDACTE(CTE: TCTE = nil);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirDACTEPDF(CTE: TCTE = nil);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrCTeDACTEClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrCTE <> nil) and (AComponent is TACBrCTE) then
     FACBrCTE := nil;
end;

procedure TACBrCTeDACTEClass.SetCTE(const Value: TComponent);
var
 OldValue: TACBrCTE;
begin
  if Value <> FACBrCTE then
  begin
     if Value <> nil then
        if not (Value is TACBrCTE) then
           raise Exception.Create('DACTE deve ser do tipo TACBrCTE');

     if Assigned(FACBrCTE) then
        FACBrCTE.RemoveFreeNotification(Self);

     OldValue := TACBrCTE(FACBrCTE);   // Usa outra variavel para evitar Loop Infinito
     FACBrCTE := Value;                // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.DACTE) then
           OldValue.DACTE := nil;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrCTE(Value).DACTE := self;
     end;
  end;
end;

procedure TACBrCTeDACTEClass.ErroAbstract(NomeProcedure: String);
begin
  raise Exception.Create(NomeProcedure);
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTO(CTE: TCTe);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirEVENTOPDF(CTE: TCTe);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAO(CTE: TCTe);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrCTeDACTEClass.ImprimirINUTILIZACAOPDF(CTE: TCTe);
begin
  ErroAbstract('ImprimirPDF');
end;

function TACBrCTeDACTEClass.GetPathPDF: String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  ACTe: TCTe;
begin
  if (csDesigning in ComponentState) then
  begin
    Result := FPathPDF;
    Exit;
  end;

  Result := Trim(FPathPDF);

  if EstaVazio(Result) then  // Se n�o pode definir o Parth, use o Path da Aplica�ao
    Result := PathWithDelim( ExtractFilePath(ParamStr(0))) + 'pdf';

  if FUsarSeparadorPathPDF then
  begin
    if Assigned(ACBrCTe) then  // Se tem o componente ACBrCTe
    begin
      if TACBrCTe(ACBrCTe).Conhecimentos.Count > 0 then  // Se tem algum Conhecimento carregado
      begin
        ACTe := TACBrCTe(ACBrCTe).Conhecimentos.Items[0].CTe;
        if TACBrCTe(ACBrCTe).Configuracoes.Arquivos.EmissaoPathCTe then
          dhEmissao := ACTe.Ide.dhEmi
        else
          dhEmissao := Now;

        DescricaoModelo := '';
        if TACBrCTe(ACBrCTe).Configuracoes.Arquivos.AdicionarLiteral then
        begin
           case ACTe.Ide.modelo of
             0: DescricaoModelo := TACBrCTe(FACBrCTe).GetNomeModeloDFe;
             57: DescricaoModelo := 'CTe';
             67: DescricaoModelo := 'CTeOS';
           end;
        end;

        Result := TACBrCTe(FACBrCTe).Configuracoes.Arquivos.GetPath(
                         Result,
                         DescricaoModelo,
                         ACTe.Emit.CNPJ,
                         dhEmissao,
                         DescricaoModelo);
      end;
    end;
  end;

  Result := PathWithDelim( Result );
end;

procedure TACBrCTeDACTEClass.SetPathPDF(const Value: String);
begin
  FPathPDF := PathWithDelim(Value);
end;

end.
