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

unit ACBrEPCBloco_C_Events;

interface

uses
  SysUtils, Classes, ACBrEPCBloco_C_Class;

type
  { TEventsBloco_0 }
  TEventsBloco_C = class(TComponent)
  private
    FOwner: TComponent;
    function GetOnBeforeWriteRegistroC481: TWriteRegistroC481Event;
    function GetOnBeforeWriteRegistroC485: TWriteRegistroC485Event;
    procedure SetOnBeforeWriteRegistroC481(const Value: TWriteRegistroC481Event);
    procedure SetOnBeforeWriteRegistroC485(const Value: TWriteRegistroC485Event);
    function GetOnBeforeWriteRegistroC491: TWriteRegistroC491Event;
    function GetOnBeforeWriteRegistroC495: TWriteRegistroC495Event;
    procedure SetOnBeforeWriteRegistroC491(const Value: TWriteRegistroC491Event);
    procedure SetOnBeforeWriteRegistroC495(const Value: TWriteRegistroC495Event);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnBeforeWriteRegistroC481: TWriteRegistroC481Event read GetOnBeforeWriteRegistroC481 write SetOnBeforeWriteRegistroC481;
    property OnBeforeWriteRegistroC485: TWriteRegistroC485Event read GetOnBeforeWriteRegistroC485 write SetOnBeforeWriteRegistroC485;
    property OnBeforeWriteRegistroC491: TWriteRegistroC491Event read GetOnBeforeWriteRegistroC491 write SetOnBeforeWriteRegistroC491;
    property OnBeforeWriteRegistroC495: TWriteRegistroC495Event read GetOnBeforeWriteRegistroC495 write SetOnBeforeWriteRegistroC495;
  end;

implementation

uses ACBrSpedPisCofins;

{ TEventsBloco_0 }

constructor TEventsBloco_C.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FOwner := AOwner;
end;

destructor TEventsBloco_C.Destroy;
begin
   FOwner := nil;
   inherited Destroy;
end;

function TEventsBloco_C.GetOnBeforeWriteRegistroC481: TWriteRegistroC481Event;
begin
   Result := TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC481;
end;

function TEventsBloco_C.GetOnBeforeWriteRegistroC485: TWriteRegistroC485Event;
begin
   Result := TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC485;
end;

function TEventsBloco_C.GetOnBeforeWriteRegistroC491: TWriteRegistroC491Event;
begin
   Result := TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC491;
end;

function TEventsBloco_C.GetOnBeforeWriteRegistroC495: TWriteRegistroC495Event;
begin
   Result := TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC495;
end;

procedure TEventsBloco_C.SetOnBeforeWriteRegistroC481(
  const Value: TWriteRegistroC481Event);
begin
  TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC481 := Value;
end;

procedure TEventsBloco_C.SetOnBeforeWriteRegistroC485(
  const Value: TWriteRegistroC485Event);
begin
  TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC485 := Value;
end;

procedure TEventsBloco_C.SetOnBeforeWriteRegistroC491(
  const Value: TWriteRegistroC491Event);
begin
  TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC491 := Value;
end;

procedure TEventsBloco_C.SetOnBeforeWriteRegistroC495(
  const Value: TWriteRegistroC495Event);
begin
  TACBrSPEDPisCofins(FOwner).Bloco_C.OnBeforeWriteRegistroC495 := Value;
end;

end.
