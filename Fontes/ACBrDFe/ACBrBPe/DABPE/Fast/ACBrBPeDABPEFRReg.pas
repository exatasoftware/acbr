{******************************************************************************}
{ Projeto: Componente ACBrBPe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Bilhete de }
{ Passagem Eletr�nica - BPe                                                    }
{                                                                              }
{ Direitos Autorais Reservados (c) 2017                                        }
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

{$I ACBr.inc}

unit ACBrBPeDABPEFRReg;

interface

uses
  SysUtils, Classes, ACBrBPeDABPEFR, ACBrReg, DesignIntf
  {$IFDEF FPC}
     , LResources
  {$ENDIF} ;

type
  { Editor de Proriedades de Componente para chamar OpenDialog dos Relatorios }

  { TACBrCTeDACTEFRFileNameProperty }

  TACBrBPeDABPEFRFileNameProperty = class(TACBrFileProperty)
  protected
    function GetFilter: String; override;
  end;

procedure Register;

implementation

uses
  ACBrDFeUtil, pcnAuxiliar,frxQRCode;

procedure Register;
begin
  RegisterComponents('ACBrBPe', [TACBrBPeDABPeFR]);
  RegisterPropertyEditor(TypeInfo(String), TACBrCTeDACTEFR, 'FastFile',
     TACBrBPeDABPEFRFileNameProperty);
end;

{ TACBrCTeDACTEFRFileNameProperty }

function TACBrBPeDABPEFRFileNameProperty.GetFilter: String;
begin
  Result := 'Arquivos do FastReport|*.fr3|Todos os arquivos|*.*'
end;

end.
