{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2014 Daniel Simoes de Almeida               }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 04/04/2013:  Andr� Ferreira de Moraes
|*   Inicio do desenvolvimento
******************************************************************************}

{$I ACBr.inc}

unit ACBrSATExtratoClass;

interface

uses SysUtils,
     Classes
     {$IFNDEF NOGUI}
      {$IF DEFINED(VisualCLX)}
         ,QGraphics
      {$ELSEIF DEFINED(FMX)}
         ,FMX.Graphics
      {$ELSE}
         ,Graphics
      {$IFEND}
     {$ENDIF}
     ,ACBrBase, ACBrConsts, pcnCFe, pcnCFeCanc;

const
  cMsgAppQRCode = 'Consulte o QR Code pelo aplicativo  "De olho na nota", '+
                  'dispon�vel na AppStore (Apple) e PlayStore (Android)';

type
   TACBrSATExtratoFiltro = (fiNenhum, fiPDF, fiHTML ) ;

   TACBrSATExtratoLayOut = (lCompleto, lResumido, lCancelamento) ;

  { TACBrSATExtratoClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrSATExtratoClass = class( TACBrComponent )
  private
    fACBrSAT : TComponent;
    fImprimeQRCode: Boolean;
    fImprimeMsgOlhoNoImposto : Boolean;
    fImprimeCPFNaoInformado : Boolean;

    fCFe: TCFe;
    fCFeCanc: TCFeCanc;

    fFiltro: TACBrSATExtratoFiltro;
    fMask_qCom: String;
    fMask_vUnCom: String;
    fMostrarPreview: Boolean;
    fMostrarSetup: Boolean;
    fMsgAppQRCode: String;
    fNomeArquivo: String;
    fNumCopias: Integer;
    fPrinterName : String;
    {$IFNDEF NOGUI}
     fPictureLogo: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF};
    {$ENDIF}
    fSoftwareHouse: String;
    fSite: String;
    fImprimeDescAcrescItem: Boolean;
    fImprimeEmUmaLinha: Boolean;
    fUsaCodigoEanImpressao: Boolean;


    procedure ErroAbstract(NomeProcedure : String) ;
    function GetAbout: String;
    function GetNomeArquivo: String;
    procedure SetAbout(AValue: String);
    procedure SetNumCopias(AValue: Integer);
    {$IFNDEF NOGUI}
     procedure SetPictureLogo(AValue: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF});
    {$ENDIF}
    procedure SetSAT(const Value: TComponent);

    procedure SetInternalCFeCanc(ACFeCanc: TCFeCanc);
    procedure VerificaExisteACBrSAT;
  protected
    fpAbout : String ;
    fpLayOut: TACBrSATExtratoLayOut;

    procedure SetInternalCFe(ACFe: TCFe);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    property PrinterName    : String   read fPrinterName    write fPrinterName;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LayOut  : TACBrSATExtratoLayOut read fpLayOut ;
    property CFe     : TCFe                  read fCFe;
    property CFeCanc : TCFeCanc              read fCFeCanc;

    procedure ImprimirExtrato(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoResumido(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoCancelamento(ACFe : TCFe = nil; ACFeCanc: TCFeCanc = nil); virtual;

    function CalcularConteudoQRCode(ID: String; dEmi_hEmi: TDateTime;
      Valor: Double; CNPJCPF: String; assinaturaQRCODE: String): String;

    function FormatQuantidade(dValor: Double; dForcarDecimais: Boolean = True): String;
  published
    property ACBrSAT  : TComponent  read FACBrSAT write SetSAT ;

    property About  : String read GetAbout write SetAbout stored False ;

    property Mask_qCom      : String   read fMask_qCom      write fMask_qCom;
    property Mask_vUnCom    : String   read fMask_vUnCom    write fMask_vUnCom;
    property ImprimeQRCode  : Boolean  read fImprimeQRCode  write fImprimeQRCode  default True ;
    property ImprimeMsgOlhoNoImposto : Boolean read fImprimeMsgOlhoNoImposto write fImprimeMsgOlhoNoImposto default True;
    property ImprimeCPFNaoInformado : Boolean read fImprimeCPFNaoInformado write fImprimeCPFNaoInformado default True;
                  
    {$IFNDEF NOGUI}
     property PictureLogo    : {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF} read fPictureLogo    write SetPictureLogo ;
    {$ENDIF}
    property MostrarPreview : Boolean  read fMostrarPreview write fMostrarPreview default False ;
    property MostrarSetup   : Boolean  read fMostrarSetup   write fMostrarSetup   default False ;
    property NumCopias      : Integer  read fNumCopias      write SetNumCopias    default 1;
    property NomeArquivo    : String   read GetNomeArquivo  write fNomeArquivo ;
    property SoftwareHouse  : String   read fSoftwareHouse  write fSoftwareHouse;
    property Site           : String   read fSite           write fSite;
    property Filtro         : TACBrSATExtratoFiltro read fFiltro write fFiltro default fiNenhum ;
    property MsgAppQRCode   : String   read fMsgAppQRCode   write fMsgAppQRCode;

    property ImprimeEmUmaLinha: Boolean     read fImprimeEmUmaLinha     write fImprimeEmUmaLinha     default True;
    property ImprimeDescAcrescItem: Boolean read fImprimeDescAcrescItem write fImprimeDescAcrescItem default True;
    property UsaCodigoEanImpressao: Boolean read fUsaCodigoEanImpressao write fUsaCodigoEanImpressao default False;
  end ;

implementation

uses ACBrSAT, ACBrSATClass, ACBrUtil;

{ TACBrSATExtratoClass }

constructor TACBrSATExtratoClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  fpAbout  := 'ACBrSATExtratoClass' ;
  fpLayOut := lCompleto;

  fACBrSAT := nil;
  fCFe     := nil;
  fCFeCanc := nil;

  {$IFNDEF NOGUI}
   fPictureLogo := {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF}.Create;
  {$ENDIF}

  fNumCopias      := 1;
  fMostrarPreview := False;
  fMostrarSetup   := False;
  fImprimeQRCode  := True;
  fFiltro         := fiNenhum;
  fNomeArquivo    := '' ;
  fMask_qCom      := ',0.0000';
  fMask_vUnCom    := ',0.000';
  fPrinterName    := '' ;
  fSite           := 'http://www.projetoacbr.com.br';
  fSoftwareHouse  := 'Projeto ACBr';
  fMsgAppQRCode   := ACBrStr(cMsgAppQRCode);
  fImprimeMsgOlhoNoImposto := True;
  fImprimeCPFNaoInformado := True;
  fImprimeEmUmaLinha := True;
  fImprimeDescAcrescItem := True;
  fUsaCodigoEanImpressao := False;
end;

destructor TACBrSATExtratoClass.Destroy;
begin
  {$IFNDEF NOGUI}
   fPictureLogo.Free;
  {$ENDIF}

  inherited Destroy ;
end;

procedure TACBrSATExtratoClass.ImprimirExtrato(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  fpLayOut := lCompleto;
end;

procedure TACBrSATExtratoClass.ImprimirExtratoCancelamento(ACFe: TCFe;
  ACFeCanc: TCFeCanc);
begin
  SetInternalCFe( ACFe );
  SetInternalCFeCanc( ACFeCanc );
  fpLayOut := lCancelamento;
end;

function TACBrSATExtratoClass.CalcularConteudoQRCode(ID: String;
  dEmi_hEmi:TDateTime; Valor: Double; CNPJCPF: String;
  assinaturaQRCODE: String): String;
begin
  Result := ID + '|' +
            FormatDateTime('yyyymmddhhmmss',dEmi_hEmi) + '|' +
            FloatToString(Valor,'.','0.00') + '|' +
            Trim(CNPJCPF) + '|' +
            assinaturaQRCODE;
end;

function TACBrSATExtratoClass.FormatQuantidade(dValor: Double;
  dForcarDecimais: Boolean): String;
begin
  if (Frac(dValor) > 0) or (dForcarDecimais) then
    Result := FormatFloatBr(dValor, Mask_qCom)
  else
    // caso contr�rio mostrar somente o n�mero inteiro
    Result := FloatToStr( dValor );
end;

procedure TACBrSATExtratoClass.ImprimirExtratoResumido(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  fpLayOut := lResumido;
end;

procedure TACBrSATExtratoClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrSAT <> nil) and (AComponent is TACBrSAT) then
     FACBrSAT := nil ;
end;

procedure TACBrSATExtratoClass.ErroAbstract(NomeProcedure : String) ;
begin
  raise EACBrSATErro.create( Format( 'Procedure: %s '+ sLineBreak +
                                     ' n�o implementada para o Extrato: %s' ,
                                     [NomeProcedure, ClassName] )) ;
end ;

function TACBrSATExtratoClass.GetAbout: String;
begin
  Result := fpAbout ;
end;

function TACBrSATExtratoClass.GetNomeArquivo: String;
var
  wPath, wFile: String;
begin
   wPath  := ExtractFilePath(fNomeArquivo);
   wFile  := ExtractFileName(fNomeArquivo);
   Result := '';

   if wPath = '' then
   begin
      if not (csDesigning in Self.ComponentState) then
      begin
         wPath := ExtractFilePath(ParamStr(0));  // Pasta da aplica��o
      end;
   end;

   if wFile = '' then
   begin
      if not (csDesigning in Self.ComponentState) then
      begin
         if Assigned(fACBrSAT) then
           wFile := TACBrSAT(FACBrSAT).CFe.infCFe.ID+'.pdf';
      end;
   end;

   Result := PathWithDelim(wPath) + Trim(wFile);
end;

procedure TACBrSATExtratoClass.SetAbout(AValue: String);
begin
  {}
end;

procedure TACBrSATExtratoClass.SetNumCopias(AValue: Integer);
begin
  if fNumCopias = AValue then Exit;
  fNumCopias := AValue;
end;

{$IFNDEF NOGUI}
procedure TACBrSATExtratoClass.SetPictureLogo(AValue: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF});
begin
  fPictureLogo.Assign( AValue );
end;
{$ENDIF}

procedure TACBrSATExtratoClass.SetSAT(const Value: TComponent);
var
  OldValue : TACBrSAT ;
begin
  if Value <> FACBrSAT then
  begin
     if Value <> nil then
        if not (Value is TACBrSAT) then
           raise Exception.Create('ACBrSATExtrato.SAT deve ser do tipo TACBrSAT') ;

     if Assigned(FACBrSAT) then
        FACBrSAT.RemoveFreeNotification(Self);

     OldValue := TACBrSAT(FACBrSAT) ;   // Usa outra variavel para evitar Loop Infinito
     FACBrSAT := Value;                 // na remo��o da associa��o dos componentes

     if Assigned(OldValue) then
        if Assigned(OldValue.Extrato) then
           OldValue.Extrato := nil ;

     if Value <> nil then
     begin
        Value.FreeNotification(self);
        TACBrSAT(Value).Extrato := self ;
     end ;
  end ;
end;

procedure TACBrSATExtratoClass.SetInternalCFe(ACFe: TCFe);
begin
  if ACFe = nil then
  begin
    VerificaExisteACBrSAT;
    fCFe := TACBrSAT(ACBrSAT).CFe;
  end
  else
    fCFe := ACFe;
end;

procedure TACBrSATExtratoClass.SetInternalCFeCanc(ACFeCanc: TCFeCanc);
begin
  if ACFeCanc = nil then
  begin
    VerificaExisteACBrSAT;
    fCFeCanc := TACBrSAT(ACBrSAT).CFeCanc;
  end
  else
    fCFeCanc := ACFeCanc;
end;

procedure TACBrSATExtratoClass.VerificaExisteACBrSAT;
begin
  if not Assigned(ACBrSAT) then
     raise Exception.Create('Componente ACBrSAT n�o atribu�do');
end;

end.
