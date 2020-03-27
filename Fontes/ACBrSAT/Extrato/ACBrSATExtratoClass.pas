{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Andr� Ferreira de Moraes                        }
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
     ,ACBrBase, ACBrConsts, pcnCFe, pcnCFeCanc,
     ACBrDFeReport;

const
  cMsgAppQRCode = 'Consulte o QR Code pelo aplicativo  "De olho na nota", '+
                  'dispon�vel na AppStore (Apple) e PlayStore (Android)';

type
   TACBrSATExtratoFiltro = (fiNenhum, fiPDF, fiHTML ) ;

   TACBrSATExtratoLayOut = (lCompleto, lResumido, lCancelamento) ;

  { TACBrSATExtratoClass }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSATExtratoClass = class( TACBrDFeReport )
  private
    FACBrSAT : TComponent;
    FImprimeQRCode: Boolean;
    FImprimeMsgOlhoNoImposto : Boolean;
    FImprimeCPFNaoInformado : Boolean;
    FImprimeQRCodeLateral: Boolean;
    FImprimeLogoLateral: Boolean;

    FCFe: TCFe;
    FCFeCanc: TCFeCanc;

    FFiltro: TACBrSATExtratoFiltro;
    FMsgAppQRCode: String;
    {$IFNDEF NOGUI}
     FPictureLogo: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF};
    {$ENDIF}
    FImprimeDescAcrescItem: Boolean;
    FImprimeEmUmaLinha: Boolean;
    FImprimeCodigoEan: Boolean;


    procedure ErroAbstract(const NomeProcedure : String) ;
    {$IFNDEF NOGUI}
     procedure SetPictureLogo(AValue: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF});
    {$ENDIF}
    procedure SetSAT(const Value: TComponent);

    procedure SetInternalCFeCanc(ACFeCanc: TCFeCanc);
    procedure VerificaExisteACBrSAT;
  protected
    FLayOut: TACBrSATExtratoLayOut;

    function GetSeparadorPathPDF(const aInitialPath: String): String; override;
    procedure SetInternalCFe(ACFe: TCFe);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property LayOut  : TACBrSATExtratoLayOut read FLayOut ;
    property CFe     : TCFe                  read FCFe;
    property CFeCanc : TCFeCanc              read FCFeCanc;

    procedure ImprimirExtrato(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoResumido(ACFe : TCFe = nil); virtual;
    procedure ImprimirExtratoCancelamento(ACFe : TCFe = nil; ACFeCanc: TCFeCanc = nil); virtual;

    function CalcularConteudoQRCode(const ID: String; dEmi_hEmi: TDateTime;
      Valor: Double; const CNPJCPF: String; const assinaturaQRCODE: String): String;
  published
    property ACBrSAT  : TComponent  read FACBrSAT write SetSAT ;
    property ImprimeQRCode  : Boolean  read FImprimeQRCode  write FImprimeQRCode  default True ;
    property ImprimeMsgOlhoNoImposto : Boolean read FImprimeMsgOlhoNoImposto write FImprimeMsgOlhoNoImposto default True;
    property ImprimeCPFNaoInformado : Boolean read FImprimeCPFNaoInformado write FImprimeCPFNaoInformado default True;
    {$IFNDEF NOGUI}
    property PictureLogo: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF} read FPictureLogo    write SetPictureLogo ;
    {$ENDIF}
    property Filtro: TACBrSATExtratoFiltro read FFiltro write FFiltro default fiNenhum ;
    property MsgAppQRCode: String   read FMsgAppQRCode   write FMsgAppQRCode;
    property ImprimeEmUmaLinha: Boolean     read FImprimeEmUmaLinha     write FImprimeEmUmaLinha     default True;
    property ImprimeDescAcrescItem: Boolean read FImprimeDescAcrescItem write FImprimeDescAcrescItem default True;
    property ImprimeCodigoEan: Boolean read FImprimeCodigoEan write FImprimeCodigoEan default False;
    property ImprimeQRCodeLateral: Boolean read FImprimeQRCodeLateral write FImprimeQRCodeLateral default True;
    property ImprimeLogoLateral: Boolean read FImprimeLogoLateral write FImprimeLogoLateral default True;
    property FormularioContinuo;
  end ;

implementation

uses ACBrSAT, ACBrSATClass, ACBrUtil;

{ TACBrSATExtratoClass }

constructor TACBrSATExtratoClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FLayOut := lCompleto;

  FACBrSAT := nil;
  FCFe     := nil;
  FCFeCanc := nil;

  {$IFNDEF NOGUI}
   FPictureLogo := {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF}.Create;
  {$ENDIF}
  FImprimeQRCode  := True;
  FFiltro         := fiNenhum;
  FMsgAppQRCode   := ACBrStr(cMsgAppQRCode);
  FImprimeMsgOlhoNoImposto := True;
  FImprimeCPFNaoInformado := True;
  FImprimeEmUmaLinha := True;
  FImprimeDescAcrescItem := True;
  FImprimeCodigoEan := False;
  FImprimeQRCodeLateral := True;
  FImprimeLogoLateral := True;

  FormularioContinuo := True;
end;

destructor TACBrSATExtratoClass.Destroy;
begin
  {$IFNDEF NOGUI}
   FPictureLogo.Free;
  {$ENDIF}

  inherited Destroy ;
end;

procedure TACBrSATExtratoClass.ImprimirExtrato(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  FLayOut := lCompleto;
end;

procedure TACBrSATExtratoClass.ImprimirExtratoCancelamento(ACFe: TCFe;
  ACFeCanc: TCFeCanc);
begin
  SetInternalCFe( ACFe );
  SetInternalCFeCanc( ACFeCanc );
  FLayOut := lCancelamento;
end;

function TACBrSATExtratoClass.CalcularConteudoQRCode(const ID: String;
  dEmi_hEmi:TDateTime; Valor: Double; const CNPJCPF: String;
  const assinaturaQRCODE: String): String;
begin
  Result := ID + '|' +
            FormatDateTime('yyyymmddhhmmss',dEmi_hEmi) + '|' +
            FloatToString(Valor,'.','0.00') + '|' +
            Trim(CNPJCPF) + '|' +
            assinaturaQRCODE;
end;

procedure TACBrSATExtratoClass.ImprimirExtratoResumido(ACFe: TCFe);
begin
  SetInternalCFe( ACFe );
  FLayOut := lResumido;
end;

procedure TACBrSATExtratoClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrSAT <> nil) and (AComponent is TACBrSAT) then
     FACBrSAT := nil ;
end;

procedure TACBrSATExtratoClass.ErroAbstract(const NomeProcedure : String) ;
begin
  raise EACBrSATErro.create( Format( 'Procedure: %s '+ sLineBreak +
                                     ' n�o implementada para o Extrato: %s' ,
                                     [NomeProcedure, ClassName] )) ;
end ;

function TACBrSATExtratoClass.GetSeparadorPathPDF(const aInitialPath: String): String;
begin
   Result := PathWithDelim(aInitialPath) + 'SAT';
end;

{$IFNDEF NOGUI}
procedure TACBrSATExtratoClass.SetPictureLogo(AValue: {$IFDEF FMX}TBitmap{$ELSE}TPicture{$ENDIF});
begin
  FPictureLogo.Assign( AValue );
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
    FCFe := TACBrSAT(ACBrSAT).CFe;
  end
  else
    FCFe := ACFe;
end;

procedure TACBrSATExtratoClass.SetInternalCFeCanc(ACFeCanc: TCFeCanc);
begin
  if ACFeCanc = nil then
  begin
    VerificaExisteACBrSAT;
    FCFeCanc := TACBrSAT(ACBrSAT).CFeCanc;
  end
  else
    FCFeCanc := ACFeCanc;
end;

procedure TACBrSATExtratoClass.VerificaExisteACBrSAT;
begin
  if not Assigned(ACBrSAT) then
     raise Exception.Create('Componente ACBrSAT n�o atribu�do');
end;

end.
