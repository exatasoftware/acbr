{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                          }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
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
|* 11/08/2010: Itamar Luiz Bermond
|*  - Inicio do desenvolvimento
|*
******************************************************************************}
{$I ACBr.inc}

unit ACBrNFeDANFEFRReg;

interface

uses
  SysUtils, Classes, ACBrNFeDANFEFR, ACBrReg, DesignIntf
  {$IFDEF FPC}
     , LResources
  {$ENDIF} ;

Type
  { Editor de Proriedades de Componente para chamar OpenDialog dos Relatorios }

  { TACBrNFeDANFEFRFileNameProperty }

  TACBrNFeDANFEFRFileNameProperty = class(TACBrFileProperty)
  protected
    function GetFilter: String; override;
  end;


procedure Register;

implementation

{$IFNDEF FPC}
   {$R ACBrNFe.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrNFe', [TACBrNFeDANFEFR]);

  RegisterPropertyEditor(TypeInfo(String), TACBrNFeDANFEFR, 'FastFile',
     TACBrNFeDANFEFRFileNameProperty);
  RegisterPropertyEditor(TypeInfo(String), TACBrNFeDANFEFR, 'FastFileEvento',
     TACBrNFeDANFEFRFileNameProperty);
  RegisterPropertyEditor(TypeInfo(String), TACBrNFeDANFEFR, 'FastFileInutilizacao',
     TACBrNFeDANFEFRFileNameProperty);
end;

{ TACBrNFeDANFERaveFileNameProperty }

function TACBrNFeDANFEFRFileNameProperty.GetFilter: String;
begin
  Result := 'Arquivos do FastReport|*.fr3|Todos os arquivos|*.*';
end;

end.
