{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Macgayver Armini Apolonio                       }
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

unit ACBrEFDImportar;

interface

uses
  Classes,
  SysUtils, ACBrBase,
  {$IFDEF FPC}
    LResources,
  {$ENDIF}
  ACBrUtil, ACBrSpedFiscal, ACBrEFDBlocos,
  ACBrEFDBase,
  ACBrEFDBloco_0_Importar,
  ACBrEFDBloco_C_Importar,
  ACBrEFDBloco_D_Importar,
  ACBrEFDBloco_E_Importar,
  ACBrEFDBloco_H_Importar,
  ACBrEFDBloco_1_Importar;

const
  CACBrSpedFiscalImportar_Versao = '1.00';

type

  // Permite alterar o conte�do da linha ou coluna antes de ser adicionado ao componente da ACBR.
  TACBrSpedFiscalImportarLinha = procedure(var Linha: string; const LinhaI: integer) of Object;
  TACBrSpedFiscalImportarColuna = TACBrSpedFiscalImportarGetColumn;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSpedFiscalImportar = class(TACBrComponent)
  private
    FArquivo: string;
    FACBrSPEDFiscal: TACBrSPEDFiscal;
    FAntesDeInserirLinha: TACBrSpedFiscalImportarLinha;
    FAntesDeInserirColuna: TACBrSpedFiscalImportarColuna;

    procedure ProcessaBloco(Bloco: TACBrSpedFiscalImportar_Base; const Delimiter: TStrings);
    procedure ProcessaBloco0(const Delimiter: TStrings);
    procedure ProcessaBlocoC(const Delimiter: TStrings);
    procedure ProcessaBlocoD(const Delimiter: TStrings);
    procedure ProcessaBlocoE(const Delimiter: TStrings);
    procedure ProcessaBlocoH(const Delimiter: TStrings);
    procedure ProcessaBloco1(const Delimiter: TStrings);
  public
    procedure Importar;
  published
    property ACBrSpedFiscal: TACBrSPEDFiscal read FACBrSPEDFiscal write FACBrSPEDFiscal;
    property Arquivo: string read FArquivo write FArquivo;

    property AntesDeInserirLinha: TACBrSpedFiscalImportarLinha read FAntesDeInserirLinha write FAntesDeInserirLinha;
    property AntesDeInserirColuna: TACBrSpedFiscalImportarColuna read FAntesDeInserirColuna write FAntesDeInserirColuna;
  end;

implementation

{$IFNDEF FPC}
 {$R ACBrSPEDFiscalImportar.dcr}
{$ENDIF}

{ TACBrSpedFiscalImportar }

procedure TACBrSpedFiscalImportar.Importar;
var
  LinhaAtual: string;
  FileStr, Delimitador: TStrings;
  I: integer;
  Bloco: Char;
const
  Delimiter = '|';
begin
  if FArquivo = '' then
    raise Exception.Create(ACBrStr('Nome do arquivo de importa��o n�o foi informado.'));

  if not FileExists(FArquivo) then
    raise Exception.Create(ACBrStr('Arquivo informado n�o existe.'));

  FileStr := TStringList.Create;
  Delimitador := TStringList.Create;
  try
    FileStr.LoadFromFile(FArquivo);

    for I := 0 to FileStr.Count - 1 do
    begin
      LinhaAtual := FileStr[I];
      if pos('|', LinhaAtual) = 0 then continue;

      if Assigned(FAntesDeInserirLinha) then
        FAntesDeInserirLinha(LinhaAtual, I);

      Delimitador.Text := StringReplace(LinhaAtual, Delimiter, sLineBreak, [rfReplaceAll]);
      // Verificar se a linha tem mais de um delimitador (ver hist�rico)
      if (Delimitador.Count > 1) then
      begin
        Bloco := Delimitador[1][1];

        if (Bloco = '0') then
          ProcessaBloco0(Delimitador)
        else if (Bloco = 'C') then
          ProcessaBlocoC(Delimitador)
        else if (Bloco = 'D') then
          ProcessaBlocoD(Delimitador)
        else if (Bloco = 'E') then
          ProcessaBlocoE(Delimitador)
        else if (Bloco = 'H') then
          ProcessaBlocoH(Delimitador)
        else if (Bloco = '1') then
          ProcessaBloco1(Delimitador);
      end;
    end;
  finally
    FileStr.Free;
    Delimitador.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBloco0(const Delimiter: TStrings);
var
  ImportarBloco0: TACBrSpedFiscalImportar_Bloco0;
begin
  ImportarBloco0 := TACBrSpedFiscalImportar_Bloco0.Create;
  try
    ProcessaBloco(ImportarBloco0, Delimiter);
  finally
    ImportarBloco0.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBlocoC(const Delimiter: TStrings);
var
  ImportarBlocoC: TACBrSpedFiscalImportar_BlocoC;
begin
  ImportarBlocoC := TACBrSpedFiscalImportar_BlocoC.Create;
  try
    ProcessaBloco(ImportarBlocoC, Delimiter);
  finally
    ImportarBlocoC.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBlocoD(const Delimiter: TStrings);
var
  ImportarBlocoD: TACBrSpedFiscalImportar_BlocoD;
begin
  ImportarBlocoD := TACBrSpedFiscalImportar_BlocoD.Create;
  try
    ProcessaBloco(ImportarBlocoD, Delimiter);
  finally
    ImportarBlocoD.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBlocoE(const Delimiter: TStrings);
var
  ImportarBlocoE: TACBrSpedFiscalImportar_BlocoE;
begin
  ImportarBlocoE := TACBrSpedFiscalImportar_BlocoE.Create;
  try
    ProcessaBloco(ImportarBlocoE, Delimiter);
  finally
    ImportarBlocoE.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBlocoH(const Delimiter: TStrings);
var
  ImportarBlocoH: TACBrSpedFiscalImportar_BlocoH;
begin
  ImportarBlocoH := TACBrSpedFiscalImportar_BlocoH.Create;
  try
    ProcessaBloco(ImportarBlocoH, Delimiter);
  finally
    ImportarBlocoH.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBloco1(const Delimiter: TStrings);
var
  ImportarBloco1: TACBrSpedFiscalImportar_Bloco1;
begin
  ImportarBloco1 := TACBrSpedFiscalImportar_Bloco1.Create;
  try
    ProcessaBloco(ImportarBloco1, Delimiter);
  finally
    ImportarBloco1.Free;
  end;
end;

procedure TACBrSpedFiscalImportar.ProcessaBloco(Bloco: TACBrSpedFiscalImportar_Base; const Delimiter: TStrings);
begin
  Bloco.AntesInserirValor := FAntesDeInserirColuna;
  Bloco.ACBrSpedFiscal := ACBrSpedFiscal;
  Bloco.AnalisaRegistro(Delimiter);
end;

{$ifdef FPC}
initialization
  {$i ACBrSpedFiscalImportar.lrs}
{$endif}


end.
