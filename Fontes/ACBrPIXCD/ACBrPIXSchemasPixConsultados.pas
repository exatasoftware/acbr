{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2021 Daniel Simoes de Almeida               }
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
{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

(*

  Documenta��o:
  https://github.com/bacen/pix-api

*)

{$I ACBr.inc}

unit ACBrPIXSchemasPixConsultados;

interface

uses
  Classes, SysUtils,
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   JsonDataObjects_ACBr,
  {$Else}
   Jsons,
  {$EndIf}
  ACBrPIXBase,
  ACBrPIXSchemasParametrosConsultaPix, ACBrPIXSchemasPix;

type

  { TACBrPIXConsultados }

  TACBrPIXConsultados = class(TACBrPIXSchema)
  private
    fparametros: TACBrPIXParametrosConsultaPix;
    fpix: TACBrPIXArray;
  public
    constructor Create;
    procedure Clear; override;
    destructor Destroy; override;
    procedure Assign(Source: TACBrPIXConsultados);

    property parametros: TACBrPIXParametrosConsultaPix read fparametros;
    property pix: TACBrPIXArray read fpix;

    procedure WriteToJSon(AJSon: TJsonObject); override;
    procedure ReadFromJSon(AJSon: TJsonObject); override;
  end;

implementation

{ TACBrPIXConsultados }

constructor TACBrPIXConsultados.Create;
begin
  inherited;
  fparametros := TACBrPIXParametrosConsultaPix.Create;
  fpix := TACBrPIXArray.Create('pix');
  Clear;
end;

destructor TACBrPIXConsultados.Destroy;
begin
  fparametros.Free;
  fpix.Free;
  inherited Destroy;
end;

procedure TACBrPIXConsultados.Clear;
begin
  fparametros.Clear;
  fpix.Clear;
end;

procedure TACBrPIXConsultados.Assign(Source: TACBrPIXConsultados);
begin
  fparametros.Assign(Source.parametros);
  fpix.Assign(Source.pix);
end;

procedure TACBrPIXConsultados.WriteToJSon(AJSon: TJsonObject);
var
  jsp: TJsonObject;
begin
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   jsp := AJSon.O['parametros'];
  {$Else}
   jsp := AJSon['parametros'].AsObject;
  {$EndIf}
  fparametros.WriteToJSon(jsp);
  fpix.WriteToJSon(AJSon);
end;

procedure TACBrPIXConsultados.ReadFromJSon(AJSon: TJsonObject);
var
  jsp: TJsonObject;
begin
  Clear;
  {$IfDef USE_JSONDATAOBJECTS_UNIT}
   jsp := AJSon.O['parametros'];
  {$Else}
   jsp := AJSon['parametros'].AsObject;
  {$EndIf}
  fparametros.ReadFromJSon(jsp);
  fpix.ReadFromJSon(AJSon);
end;

end.

