{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrMDFeDAMDFeClass;

interface

uses
  SysUtils, Classes, ACBrBase,
  pmdfeMDFe, pcnConversao;

type
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}	
  TACBrMDFeDAMDFeClass = class(TACBrComponent)
   private
    procedure SetMDFe(const Value: TComponent);
    procedure ErroAbstract(NomeProcedure: String);
    function GetPathPDF: String;
    procedure SetPathPDF(const Value: String);
  protected
    FACBrMDFe: TComponent;
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
    FTipoDAMDFe: TpcnTipoImpressao;
    FTamanhoPapel: TpcnTamanhoPapel;
    FNumCopias: Integer;
    FExpandirLogoMarca: Boolean;
    FFax: String;
    FSite: String;
    FEmail: String;
	  FProtocoloMDFe: String;
    FMargemInferior: Double;
    FMargemSuperior: Double;
    FMargemEsquerda: Double;
    FMargemDireita: Double;
    FMDFeCancelada: Boolean;
    FMDFeEncerrado: Boolean;

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ImprimirDAMDFe(MDFe: TMDFe = nil); virtual;
    procedure ImprimirDAMDFePDF(MDFe: TMDFe = nil); virtual;
    procedure ImprimirEVENTO(MDFe: TMDFe = nil); virtual;
    procedure ImprimirEVENTOPDF(MDFe: TMDFe = nil); virtual;
  published
    property ACBrMDFe: TComponent           read FACBrMDFe               write SetMDFe;
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
    property TipoDAMDFe: TpcnTipoImpressao  read FTipoDAMDFe             write FTipoDAMDFe;
    property TamanhoPapel: TpcnTamanhoPapel read FTamanhoPapel           write FTamanhoPapel;
    property NumCopias: Integer             read FNumCopias              write FNumCopias;
    property Fax: String                    read FFax                    write FFax;
    property Site: String                   read FSite                   write FSite;
    property Email: String                  read FEmail                  write FEmail;
    property ProtocoloMDFe: String          read FProtocoloMDFe          write FProtocoloMDFe;
    property MargemInferior: Double         read FMargemInferior         write FMargemInferior;
    property MargemSuperior: Double         read FMargemSuperior         write FMargemSuperior;
    property MargemEsquerda: Double         read FMargemEsquerda         write FMargemEsquerda;
    property MargemDireita: Double          read FMargemDireita          write FMargemDireita;
    property ExpandirLogoMarca: Boolean     read FExpandirLogoMarca      write FExpandirLogoMarca default False;
    property MDFeCancelada: Boolean         read FMDFeCancelada          write FMDFeCancelada;
    property MDFeEncerrado: Boolean         read FMDFeEncerrado          write FMDFeEncerrado;
  end;

implementation

uses
  ACBrMDFe, ACBrUtil;

constructor TACBrMDFeDAMDFeClass.Create(AOwner: TComponent);
begin
  inherited create(AOwner);

  FACBrMDFe   := nil;
  FLogo       := '';
  FSistema    := '';
  FUsuario    := '';
  FPathPDF    := '';
  FUsarSeparadorPathPDF := False;
  FImpressora := '';

  FImprimirHoraSaida      := False;
  FImprimirHoraSaida_Hora := '';

  FMostrarPreview := True;
  FMostrarStatus  := True;
  FNumCopias      := 1;

  FFax   := '';
  FSite  := '';
  FEmail := '';

  FProtocoloMDFe := '';

  FMargemInferior := 0.8;
  FMargemSuperior := 0.8;
  FMargemEsquerda := 0.6;
  FMargemDireita  := 0.51;
  FMDFeCancelada  := False;
  FMDFeEncerrado  := False;
end;

destructor TACBrMDFeDAMDFeClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrMDFeDAMDFeClass.ImprimirDAMDFe(MDFe: TMDFe = nil);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirDAMDFePDF(MDFe: TMDFe = nil);
begin
  ErroAbstract('ImprimirPDF');
end;

procedure TACBrMDFeDAMDFeClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrMDFe <> nil) and (AComponent is TACBrMDFe) then
     FACBrMDFe := nil;
end;

procedure TACBrMDFeDAMDFeClass.SetMDFe(const Value: TComponent);
var
  OldValue: TACBrMDFe;
begin
  if Value <> FACBrMDFe then
  begin
     if Value <> nil then
        if not (Value is TACBrMDFe) then
           raise Exception.Create('DAMDFe deve ser do tipo TACBrMDFe');

     if Assigned(FACBrMDFe) then
        FACBrMDFe.RemoveFreeNotification(Self);

     OldValue := TACBrMDFe(FACBrMDFe);   // Usa outra variavel para evitar Loop Infinito
     FACBrMDFe := Value;                 // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.DAMDFe) then
           OldValue.DAMDFe := nil;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrMDFe(Value).DAMDFe := self;
     end;
  end;
end;

procedure TACBrMDFeDAMDFeClass.ErroAbstract(NomeProcedure: String);
begin
  raise Exception.Create(NomeProcedure);
end;

procedure TACBrMDFeDAMDFeClass.ImprimirEVENTO(MDFe: TMDFe);
begin
  ErroAbstract('Imprimir');
end;

procedure TACBrMDFeDAMDFeClass.ImprimirEVENTOPDF(MDFe: TMDFe);
begin
  ErroAbstract('ImprimirPDF');
end;

function TACBrMDFeDAMDFeClass.GetPathPDF: String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  AMDFe: TMDFe;
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
    if Assigned(ACBrMDFe) then  // Se tem o componente ACBrMDFe
    begin
      if TACBrMDFe(ACBrMDFe).Manifestos.Count > 0 then  // Se tem algum Manifesto carregado
      begin
        AMDFe := TACBrMDFe(ACBrMDFe).Manifestos.Items[0].MDFe;
        if TACBrMDFe(ACBrMDFe).Configuracoes.Arquivos.EmissaoPathMDFe then
          dhEmissao := AMDFe.Ide.dhEmi
        else
          dhEmissao := Now;

        DescricaoModelo := 'MDFe';

        Result := TACBrMDFe(FACBrMDFe).Configuracoes.Arquivos.GetPath(
                         Result,
                         DescricaoModelo,
                         AMDFe.Emit.CNPJCPF,
                         dhEmissao,
                         DescricaoModelo);
      end;
    end;
  end;

  Result := PathWithDelim( Result );
end;

procedure TACBrMDFeDAMDFeClass.SetPathPDF(const Value: String);
begin
  FPathPDF := PathWithDelim(Value);
end;

end.
