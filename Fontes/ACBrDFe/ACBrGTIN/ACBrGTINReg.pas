{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

unit ACBrGTINReg;

interface

uses
  SysUtils, Classes, ACBrGTIN,
  {$IFDEF FPC}
     LResources, LazarusPackageIntf, PropEdits, componenteditors
  {$ELSE}
     {$IFNDEF COMPILER6_UP}
        DsgnIntf
     {$ELSE}
        DesignIntf,
        DesignEditors
     {$ENDIF}
  {$ENDIF} ;

procedure Register;

implementation

uses
  ACBrReg, ACBrDFeConfiguracoes, ACBrGTINConfiguracoes, ACBrDFeRegUtil,
  ACBrMail, ACBrIntegrador;

{$IFNDEF FPC}
   {$R ACBrGTIN.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrGTIN', [TACBrGTIN]);

  RegisterPropertyEditor(TypeInfo(TConfiguracoes),   TACBrGTIN,         'Configuracoes', TClassProperty);

  RegisterPropertyEditor(TypeInfo(TArquivosConfGTIN),TConfiguracoes,    'Arquivos',      TClassProperty);
  RegisterPropertyEditor(TypeInfo(TCertificadosConf),TConfiguracoes,    'Certificados',  TClassProperty);
  RegisterPropertyEditor(TypeInfo(TGeralConfGTIN),   TConfiguracoes,    'Geral',         TClassProperty);
  RegisterPropertyEditor(TypeInfo(TWebServicesConf), TConfiguracoes,    'WebServices',   TClassProperty);

  RegisterPropertyEditor(TypeInfo(String),           TWebServicesConf,  'UF',            TACBrUFProperty);
  RegisterPropertyEditor(TypeInfo(String),           TGeralConfGTIN,    'PathSalvar',    TACBrDirProperty);
  RegisterPropertyEditor(TypeInfo(String),           TArquivosConfGTIN, 'PathGTIN',      TACBrDirProperty);

  {$IFDEF FPC}

    RegisterPropertyEditor(TypeInfo(boolean),  TGeralConfGTIN,   'RetirarAcentos',            THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(boolean),  TGeralConfGTIN,   'RetirarEspacos',            THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(string),   TGeralConfGTIN,   'QuebradeLinha',             THiddenPropertyEditor);

    RegisterPropertyEditor(TypeInfo(string),   TDownloadConf,    'PathDownload',              THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(boolean),  TDownloadConf,    'SepararPorNome',            THiddenPropertyEditor);

    RegisterPropertyEditor(TypeInfo(boolean),  TWebServicesConf, 'AjustaAguardaConsultaRet',  THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(Cardinal), TWebServicesConf, 'AguardarConsultaRet',       THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(Cardinal), TWebServicesConf, 'IntervaloTentativas',       THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(integer),  TWebServicesConf, 'Tentativas',                THiddenPropertyEditor);

    RegisterPropertyEditor(TypeInfo(TRespTecConf),     TConfiguracoesGTIN, 'RespTec',         THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(TACBrIntegrador),  TACBrGTIN,          'Integrador',      THiddenPropertyEditor);
    RegisterPropertyEditor(TypeInfo(TACBrMail),        TACBrGTIN,          'MAIL',            THiddenPropertyEditor);



  {$ELSE}
    UnlistPublishedProperty(TGeralConfGTIN,    'RetirarAcentos');
    UnlistPublishedProperty(TGeralConfGTIN,    'RetirarEspacos');
    UnlistPublishedProperty(TGeralConfGTIN,    'QuebradeLinha');

    UnlistPublishedProperty(TDownloadConf,     'PathDownload');
    UnlistPublishedProperty(TDownloadConf,     'SepararPorNome');

    UnlistPublishedProperty(TWebServicesConf,  'AjustaAguardaConsultaRet');
    UnlistPublishedProperty(TWebServicesConf,  'AguardarConsultaRet');
    UnlistPublishedProperty(TWebServicesConf,  'IntervaloTentativas');
    UnlistPublishedProperty(TWebServicesConf,  'Tentativas');

    UnlistPublishedProperty(TConfiguracoesGTIN,'RespTec');

    UnlistPublishedProperty(TACBrGTIN,         'Integrador');
    UnlistPublishedProperty(TACBrGTIN,         'MAIL');
  {$ENDIF}


end;

{$IFDEF FPC}
initialization
   {$I ACBrGTIN.lrs}
{$ENDIF}

end.
