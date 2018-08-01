{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2012   Albert Eije                          }
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
|* 04/07/2012: Albert Eije
|*  - Cria��o e distribui��o da Primeira Versao
*******************************************************************************}

unit ACBrPonto_AFDT_Class;

interface

uses SysUtils, Classes, DateUtils, ACBrTXTClass, ACBrPonto_AFDT;

type
  // TACBrPonto_AFDT
  TPonto_AFDT = class(TACBrTXTClass)
  private
    FCabecalho: TCabecalho;
    FRegistro2: TRegistro2List;
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
    function WriteTrailer: String;

    property Cabecalho: TCabecalho     read FCabecalho write FCabecalho;
    property Registro2: TRegistro2List     read FRegistro2 write FRegistro2;
    property Trailer: TTrailer     read FTrailer write FTrailer;
    property NSR: Integer read FNSR write FNSR;
  end;

implementation

{ TPonto_AFDT }

constructor TPonto_AFDT.Create;
begin
   CriaRegistros;
end;

procedure TPonto_AFDT.CriaRegistros;
begin
  FCabecalho := TCabecalho.Create;       
  FRegistro2 := TRegistro2List.Create;       
  FTrailer := TTrailer.Create;       

  FNSR := 0;
end;

destructor TPonto_AFDT.Destroy;
begin
  LiberaRegistros;
  inherited;
end;

procedure TPonto_AFDT.LiberaRegistros;
begin
  FCabecalho.Free;
  FRegistro2.Free;
  FTrailer.Free;
end;

procedure TPonto_AFDT.LimpaRegistros;
begin
  LiberaRegistros;
  CriaRegistros;
end;

function TPonto_AFDT.WriteCabecalho: String;
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

function TPonto_AFDT.WriteRegistro2: String;
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
                                         LFill(Campo03, 8) +
                                         LFill(Campo04, 4) +
                                         LFill(Campo05, 12) +
                                         LFill(Campo06, 17) +
                                         LFill(Campo07, 1) +
                                         LFill(Campo08, 2) +
                                         LFill(Campo09, 1) +
                                         RFill(Campo10, 100) +
                                         sLineBreak;
        end;
     end;

     Result := strRegistro2;
  end;
end;

function TPonto_AFDT.WriteTrailer: String;
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
