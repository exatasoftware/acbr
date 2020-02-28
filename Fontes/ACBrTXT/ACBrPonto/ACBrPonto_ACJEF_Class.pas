{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Albert Eije                                     }
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

unit ACBrPonto_ACJEF_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrPonto_ACJEF;

type
  // TACBrPonto_ACJEF
  TPonto_ACJEF = class(TACBrTXTClass)
  private
    FCabecalho: TCabecalho;
    FRegistro2: TRegistro2List;
    FRegistro3: TRegistro3List;
    FTrailer: TTrailer;
    FNSR: Integer;

    procedure CriaRegistros;
    procedure LiberaRegistros;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LimpaRegistros;

    function WriteCabecalho: String;
    function WriteRegistro2: String;
    function WriteRegistro3: String;
    function WriteTrailer: String;

    property Cabecalho: TCabecalho     read FCabecalho write FCabecalho;
    property Registro2: TRegistro2List     read FRegistro2 write FRegistro2;
    property Registro3: TRegistro3List     read FRegistro3 write FRegistro3;
    property Trailer: TTrailer     read FTrailer write FTrailer;
    property NSR: Integer read FNSR write FNSR;
  end;

implementation

{ TPonto_ACJEF }

constructor TPonto_ACJEF.Create;
begin
   inherited Create;
   CriaRegistros;
end;

procedure TPonto_ACJEF.CriaRegistros;
begin
  FCabecalho := TCabecalho.Create;       
  FRegistro2 := TRegistro2List.Create;
  FRegistro3 := TRegistro3List.Create;       
  FTrailer := TTrailer.Create;       

  FNSR := 0;
end;

destructor TPonto_ACJEF.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPonto_ACJEF.LiberaRegistros;
begin
  FCabecalho.Free;
  FRegistro2.Free;
  FRegistro3.Free;
  FTrailer.Free;
end;

procedure TPonto_ACJEF.LimpaRegistros;
begin
  LiberaRegistros;
  CriaRegistros;
end;

function TPonto_ACJEF.WriteCabecalho: String;
begin
   if Assigned(FCabecalho) then
   begin
      with FCabecalho do
      begin
        inc(FNSR);
        Result := LFill(FNSR, 9) +
				  LFill('1') +
                  LFill(Campo03, 1) +
        		  LFill(Campo04, 14) +
                  LFill(Campo05, 12) +
                  RFill(Campo06, 150) +
                  LFill(Campo07, 8) +
                  LFill(Campo08, 8) +
                  LFill(Campo09, 8) +
                  LFill(Campo10, 4) +
                  sLineBreak;
      end;
   end;
end;

function TPonto_ACJEF.WriteRegistro2: String;
var
  i: integer;
  strRegistro2: String;
begin
  strRegistro2 := '';

  if Assigned(FRegistro2) then
  begin

     for i := 0 to FRegistro2.Count - 1 do
     begin
        with FRegistro2.Items[i] do
        begin
          inc(FNSR);
          strRegistro2 := strRegistro2 + LFill(FNSR, 9) +
                                         LFill('2') +
                                         LFill(Campo03, 4) +
                                         LFill(Campo04, 4) +
                                         LFill(Campo05, 4) +
                                         LFill(Campo06, 4) +
										 LFill(Campo07, 4) +
                                         sLineBreak;
        end;

     end;

     Result := strRegistro2;
  end;
end;

function TPonto_ACJEF.WriteRegistro3: String;
var
  i: integer;
  strRegistro3: String;
begin
  strRegistro3 := '';

  if Assigned(FRegistro3) then
  begin

     for i := 0 to FRegistro3.Count - 1 do
     begin
        with FRegistro3.Items[i] do
        begin
          inc(FNSR);
          strRegistro3 := strRegistro3 + LFill(FNSR, 9) +
                                         LFill('3') +
                                         LFill(Campo03, 12) +
                                         LFill(Campo04, 8) +
                                         LFill(Campo05, 4) +
										 LFill(Campo06, 4) +
										 LFill(Campo07, 4) +
										 LFill(Campo08, 4) +
										 LFill(Campo09, 4) +
										 LFill(Campo10, 4) +
										 LFill(Campo11, 1) +
										 LFill(Campo12, 4) +
										 LFill(Campo13, 4) +
										 LFill(Campo14, 1) +
										 LFill(Campo15, 4) +
										 LFill(Campo16, 4) +
										 LFill(Campo17, 1) +
										 LFill(Campo18, 4) +
										 LFill(Campo19, 4) +
										 LFill(Campo20, 1) +
										 LFill(Campo21, 4) +
										 LFill(Campo22, 1) +
										 LFill(Campo23, 4) +
                                         sLineBreak;
        end;

     end;

     Result := strRegistro3;
  end;
end;

function TPonto_ACJEF.WriteTrailer: String;
begin
   if Assigned(FTrailer) then
   begin
      with FTrailer do
      begin
        Result := LFill(FNSR, 9) +
                  LFill('9') +
                  sLineBreak;
      end;
   end;
end;


end.
