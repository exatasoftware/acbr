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

unit ACBrPonto_AFD_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrPonto_AFD;

type
  // TACBrPonto_AFD
  TPonto_AFD = class(TACBrTXTClass)
  private
    FCabecalho: TCabecalho;
    FRegistro2: TRegistro2;
    FRegistro3: TRegistro3List;
    FRegistro4: TRegistro4List;
    FRegistro5: TRegistro5List;
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
    function WriteRegistro4: String;
    function WriteRegistro5: String;
    function WriteTrailer: String;

    property Cabecalho: TCabecalho     read FCabecalho write FCabecalho;
    property Registro2: TRegistro2     read FRegistro2 write FRegistro2;
    property Registro3: TRegistro3List     read FRegistro3 write FRegistro3;
    property Registro4: TRegistro4List     read FRegistro4 write FRegistro4;
    property Registro5: TRegistro5List     read FRegistro5 write FRegistro5;
    property Trailer: TTrailer     read FTrailer write FTrailer;
    property NSR: Integer read FNSR write FNSR;
  end;

implementation

{ TPonto_AFD }

constructor TPonto_AFD.Create;
begin
   inherited Create;
   CriaRegistros;
end;

procedure TPonto_AFD.CriaRegistros;
begin
  FCabecalho := TCabecalho.Create;       
  FRegistro2 := TRegistro2.Create;
  FRegistro3 := TRegistro3List.Create;       
  FRegistro4 := TRegistro4List.Create;       
  FRegistro5 := TRegistro5List.Create;       
  FTrailer := TTrailer.Create;       

  FTrailer.Campo02 := 0;
  FTrailer.Campo03 := 0;
  FTrailer.Campo04 := 0;
  FTrailer.Campo05 := 0;
  FNSR := 0;
end;

destructor TPonto_AFD.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPonto_AFD.LiberaRegistros;
begin
  FCabecalho.Free;
  FRegistro2.Free;
  FRegistro3.Free;
  FRegistro4.Free;
  FRegistro5.Free;
  FTrailer.Free;
end;

procedure TPonto_AFD.LimpaRegistros;
begin
  LiberaRegistros;
  CriaRegistros;
end;

function TPonto_AFD.WriteCabecalho: String;
begin
   if Assigned(FCabecalho) then
   begin
      with FCabecalho do
      begin
        Result := LFill('000000000') +
				  LFill('1') +
                  LFill(Campo03, 1) +
        		  LFill(Campo04, 14) +
                  LFill(Campo05, 12) +
                  RFill(Campo06, 150) +
                  LFill(Campo07, 17) +
                  LFill(Campo08, 8) +
                  LFill(Campo09, 8) +
                  LFill(Campo10, 8) +
                  LFill(Campo11, 4) +
                  sLineBreak;
      end;
   end;
end;

function TPonto_AFD.WriteRegistro2: String;
begin
   if Assigned(FRegistro2) then
   begin
      with FRegistro2 do
      begin
        Result := LFill(FNSR, 9) +
				  LFill('2') +
                  LFill(Campo03, 8) +
        		  LFill(Campo04, 4) +
                  LFill(Campo05, 1) +
                  LFill(Campo06, 14) +
                  LFill(Campo07, 12) +
                  RFill(Campo08, 150) +
                  RFill(Campo09, 100) +
                  sLineBreak;
      end;
   end;
end;

function TPonto_AFD.WriteRegistro3: String;
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
                                         LFill(Campo03, 8) +
                                         LFill(Campo04, 4) +
                                         LFill(Campo05, 12) +
                                         sLineBreak;
        end;

        FTrailer.Campo03 := FTrailer.Campo03 + 1;
     end;

     Result := strRegistro3;
  end;
end;

function TPonto_AFD.WriteRegistro4: String;
var
  i: integer;
  strRegistro4: String;
begin
  strRegistro4 := '';

  if Assigned(FRegistro4) then
  begin

     for i := 0 to FRegistro4.Count - 1 do
     begin
        with FRegistro4.Items[i] do
        begin
          inc(FNSR);
          strRegistro4 := strRegistro4 + LFill(FNSR, 9) +
                                         LFill('4') +
                                         LFill(Campo03, 8) +
                                         LFill(Campo04, 4) +
                                         LFill(Campo05, 8) +
                                         LFill(Campo06, 4) +
                                         sLineBreak;
        end;

        FTrailer.Campo04 := FTrailer.Campo04 + 1;
     end;

     Result := strRegistro4;
  end;
end;

function TPonto_AFD.WriteRegistro5: String;
var
  i: integer;
  strRegistro5: String;
begin
  strRegistro5 := '';

  if Assigned(FRegistro5) then
  begin

     for i := 0 to FRegistro5.Count - 1 do
     begin
        with FRegistro5.Items[i] do
        begin
          inc(FNSR);
          strRegistro5 := strRegistro5 + LFill(FNSR, 9) +
                                         LFill('5') +
                                         LFill(Campo03, 8) +
                                         LFill(Campo04, 4) +
                                         LFill(Campo05, 1) +
                                         LFill(Campo06, 12) +
                                         RFill(Campo07, 52) +
                                         sLineBreak;
        end;

        FTrailer.Campo05 := FTrailer.Campo05 + 1;
     end;

     Result := strRegistro5;
  end;
end;

function TPonto_AFD.WriteTrailer: String;
begin
   if Assigned(FTrailer) then
   begin
      with FTrailer do
      begin
        Result := LFill('999999999') +
                  LFill(Campo02, 9) +
        		  LFill(Campo03, 9) +
                  LFill(Campo04, 9) +
                  LFill(Campo05, 9) +
                  LFill('9') +
                  sLineBreak;
      end;
   end;
end;


end.
