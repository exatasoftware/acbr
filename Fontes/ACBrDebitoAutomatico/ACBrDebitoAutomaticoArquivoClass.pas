{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2023 Daniel Simoes de Almeida               }
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

unit ACBrDebitoAutomaticoArquivoClass;

interface

uses
  Forms, SysUtils, Classes,
  ACBrDebitoAutomaticoClass, ACBrDebitoAutomaticoConversao;

type
  TACBrDebitoAutomaticoArquivoClass = class( TComponent )
   private
     procedure SetACBrDebitoAutomatico(const Value: TComponent);
   protected
     FACBrDebitoAutomatico : TComponent;
     procedure ErroAbstract(const NomeProcedure : String );
     procedure Notification(AComponent: TComponent; Operation: TOperation); override;
   public
     constructor Create(AOwner: TComponent); override;
     destructor Destroy; override;
   published
     property ACBrDebitoAutomatico: TComponent read FACBrDebitoAutomatico write SetACBrDebitoAutomatico;
  end;

implementation

uses
  ACBrDebitoAutomatico;

{ TACBrDebitoAutomaticoArquivoClass }

constructor TACBrDebitoAutomaticoArquivoClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FACBrDebitoAutomatico := nil;
end;

destructor TACBrDebitoAutomaticoArquivoClass.Destroy;
begin

  inherited Destroy;
end;

procedure TACBrDebitoAutomaticoArquivoClass.ErroAbstract(const NomeProcedure: String);
begin
  raise EACBrDebitoAutomaticoException.Create( NomeProcedure );
end;

procedure TACBrDebitoAutomaticoArquivoClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrDebitoAutomatico <> nil) and (AComponent is TACBrDebitoAutomatico) then
    FACBrDebitoAutomatico := nil;
end;

procedure TACBrDebitoAutomaticoArquivoClass.SetACBrDebitoAutomatico(const Value: TComponent);
var
  OldValue: TACBrDebitoAutomatico;
begin
  if Value <> FACBrDebitoAutomatico then
  begin
    if Value <> nil then
      if not (Value is TACBrDebitoAutomatico) then
        raise EACBrDebitoAutomaticoException.Create('ACBrDebitoAutomatico deve ser do tipo TACBrDebitoAutomatico');

    if Assigned(FACBrDebitoAutomatico) then
      FACBrDebitoAutomatico.RemoveFreeNotification(Self);

    OldValue := TACBrDebitoAutomatico(FACBrDebitoAutomatico);   // Usa outra variavel para evitar Loop Infinito
    FACBrDebitoAutomatico := Value;                 // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.Arquivo) then
        OldValue.Arquivo := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrDebitoAutomatico(Value).Arquivo := self;
    end;
  end;
end;

end.
