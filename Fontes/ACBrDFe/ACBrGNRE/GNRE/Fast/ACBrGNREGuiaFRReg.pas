{******************************************************************************}
{ Projeto: Componente ACBrGNRE                                                 }
{  Biblioteca multiplataforma de componentes Delphi/Lazarus para emiss�o da    }
{  Guia Nacional de Recolhimento de Tributos Estaduais                         }
{  http://www.gnre.pe.gov.br/                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2013 Claudemir Vitor Pereira                }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                       Juliomar Marchetti                     }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
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

{******************************************************************************
|* Historico
|*
|* 09/12/2013 - Claudemir Vitor Pereira
|*  - Doa��o do componente para o Projeto ACBr
******************************************************************************}
{$I ACBr.inc}

unit ACBrGNREGuiaFRReg;

interface

uses
  SysUtils, Classes, ACBrGNREGuiaFR, ACBrReg, DesignIntf
  {$IFDEF FPC}
     ,LResources
  {$ENDIF} ;

Type
  { Editor de Proriedades de Componente para chamar OpenDialog dos Relatorios }

  { TACBrGNREGuiaFRFileNameProperty }

  TACBrGNREGuiaFRFileNameProperty = class(TACBrFileProperty)
  protected
    function GetFilter: String; override;
  end;


procedure Register;

implementation

{$IFNDEF FPC}
   {$R ACBrGNRE.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrGNRE', [TACBrGNREGuiaFR]);

  RegisterPropertyEditor(TypeInfo(String), TACBrGNREGuiaFR, 'FastFile',
     TACBrGNREGuiaFRFileNameProperty);
end;

{ TACBrGNREGuiaFRFileNameProperty }

function TACBrGNREGuiaFRFileNameProperty.GetFilter: String;
begin
  Result := 'Arquivos do FastReport|*.fr3|Todos os arquivos|*.*';
end;

end.
