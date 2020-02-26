{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2010   Macgayver Armini Apolonio            }
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
|* 23/02/2015: Macgayver Armini Apolonio
|*  - Cria��o
|* 08/05/2019: Rodrigo Coelho | Bunny Soft - Tratamento de exce��o
|*  - Verifica��o se existe mais de um delimitador para cada linha no momento da
|*    importa��o. Isso se faz necess�rio pois em arquivos SPED que j� foram
|*    assinados existem linhas ap�s a finaliza��o do arquivo (Bloco 9999) e estas
|*    linhas devem ser ignoradas na importa��o para n�o ocasionarem erro
*******************************************************************************}

unit ACBrEPCImportar;

interface

uses
  Classes,
  SysUtils, ACBrBase,
  {$IFDEF FPC}
    LResources,
  {$ENDIF}
  ACBrUtil, ACBrSpedPisCofins, ACBrEPCBlocos,
  ACBrEPCBase,
  ACBrEPCBloco_0_Importar,
  ACBrEPCBloco_1_Importar,
  ACBrEPCBloco_A_Importar,
  ACBrEPCBloco_C_Importar,
  ACBrEPCBloco_D_Importar,
  ACBrEPCBloco_F_Importar,
  ACBrEPCBloco_I_Importar,
  ACBrEPCBloco_M_Importar,
  ACBrEPCBloco_P_Importar;

const
  CACBrSpedPisCofinsImportar_Versao = '1.00';

type

  // Permite alterar o conte�do da linha ou coluna antes de ser adicionado ao componente da ACBR.
  TACBrSpedPCImportarLinha = procedure(var Linha: string; const LinhaI: integer) of Object;
  TACBrSpedPCImportarColuna = TACBrSpedPCImportarGetColumn;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrSpedPCImportar = class(TACBrComponent)
  private
    FArquivo: string;
    FACBrSPEDPisCofins: TACBrSPEDPisCofins;
    FAntesDeInserirLinha: TACBrSpedPCImportarLinha;
    FAntesDeInserirColuna: TACBrSpedPCImportarColuna;

    procedure ProcessaBloco(Bloco: TACBrSpedPCImportar_Base; const Delimiter: TStrings);
    procedure ProcessaBloco0(const Delimiter: TStrings);
    procedure ProcessaBlocoA(const Delimiter: TStrings);
    procedure ProcessaBlocoC(const Delimiter: TStrings);
    procedure ProcessaBlocoD(const Delimiter: TStrings);
    procedure ProcessaBlocoF(const Delimiter: TStrings);
    procedure ProcessaBlocoI(const Delimiter: TStrings);
    procedure ProcessaBlocoM(const Delimiter: TStrings);
    procedure ProcessaBlocoP(const Delimiter: TStrings);
    procedure ProcessaBloco1(const Delimiter: TStrings);
  public
    procedure Importar;
  published
    property ACBrSpedPisCofins: TACBrSPEDPisCofins read FACBrSPEDPisCofins write FACBrSPEDPisCofins;
    property Arquivo: string read FArquivo write FArquivo;

    property AntesDeInserirLinha: TACBrSpedPCImportarLinha read FAntesDeInserirLinha write FAntesDeInserirLinha;
    property AntesDeInserirColuna: TACBrSpedPCImportarColuna read FAntesDeInserirColuna write FAntesDeInserirColuna;
  end;

implementation

{$IFNDEF FPC}
 {$R ACBrSPEDPisCofinsImportar.dcr}
{$ENDIF}

{ TACBrSpedPCImportar }

procedure TACBrSpedPCImportar.Importar;
var
  LinhaAtual: string;
  FileStr, Delimitador: TStrings;
  I: Integer;
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

      if Assigned(FAntesDeInserirLinha) then
        FAntesDeInserirLinha(LinhaAtual, I);

      Delimitador.Text := StringReplace(LinhaAtual, Delimiter, sLineBreak, [rfReplaceAll]);
      // Verificar se a linha tem mais de um delimitador (ver hist�rico)
      if (Delimitador.Count > 1) then
      begin
        Bloco := Delimitador[1][1];

        if (Bloco = '0') then
          ProcessaBloco0(Delimitador)
        else if (Bloco = 'A') then
          ProcessaBlocoA(Delimitador)
        else if (Bloco = 'C') then
          ProcessaBlocoC(Delimitador)
        else if (Bloco = 'D') then
          ProcessaBlocoD(Delimitador)
        else if (Bloco = 'F') then
          ProcessaBlocoF(Delimitador)
        else if (Bloco = 'I') then
          ProcessaBlocoI(Delimitador)
        else if (Bloco = 'M') then
          ProcessaBlocoM(Delimitador)
        else if (Bloco = 'P') then
          ProcessaBlocoP(Delimitador)
        else if (Bloco = '1') then
          ProcessaBloco1(Delimitador);
      end;
    end;
  finally
    FileStr.Free;
    Delimitador.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBloco0(const Delimiter: TStrings);
var
  ImportarBloco0: TACBrSpedPCImportar_Bloco0;
begin
  ImportarBloco0 := TACBrSpedPCImportar_Bloco0.Create;
  try
    ProcessaBloco(ImportarBloco0, Delimiter);
  finally
    ImportarBloco0.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBloco1(const Delimiter: TStrings);
var
  ImportarBloco1: TACBrSpedPCImportar_Bloco1;
begin
  ImportarBloco1 := TACBrSpedPCImportar_Bloco1.Create;
  try
    ProcessaBloco(ImportarBloco1, Delimiter);
  finally
    ImportarBloco1.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoA(const Delimiter: TStrings);
var
  ImportarBlocoA: TACBrSpedPCImportar_BlocoA;
begin
  ImportarBlocoA := TACBrSpedPCImportar_BlocoA.Create;
  try
    ProcessaBloco(ImportarBlocoA, Delimiter);
  finally
    ImportarBlocoA.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoC(const Delimiter: TStrings);
var
  ImportarBlocoC: TACBrSpedPCImportar_BlocoC;
begin
  ImportarBlocoC := TACBrSpedPCImportar_BlocoC.Create;
  try
    ProcessaBloco(ImportarBlocoC, Delimiter);
  finally
    ImportarBlocoC.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoD(const Delimiter: TStrings);
var
  ImportarBlocoD: TACBrSpedPCImportar_BlocoD;
begin
  ImportarBlocoD := TACBrSpedPCImportar_BlocoD.Create;
  try
    ProcessaBloco(ImportarBlocoD, Delimiter);
  finally
    ImportarBlocoD.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoF(const Delimiter: TStrings);
var
  ImportarBlocoF: TACBrSpedPCImportar_BlocoF;
begin
  ImportarBlocoF := TACBrSpedPCImportar_BlocoF.Create;
  try
    ProcessaBloco(ImportarBlocoF, Delimiter);
  finally
    ImportarBlocoF.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoI(const Delimiter: TStrings);
var
  ImportarBlocoI: TACBrSpedPCImportar_BlocoI;
begin
  ImportarBlocoI := TACBrSpedPCImportar_BlocoI.Create;
  try
    ProcessaBloco(ImportarBlocoI, Delimiter);
  finally
    ImportarBlocoI.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoM(const Delimiter: TStrings);
var
  ImportarBlocoM: TACBrSpedPCImportar_BlocoM;
begin
  ImportarBlocoM := TACBrSpedPCImportar_BlocoM.Create;
  try
    ProcessaBloco(ImportarBlocoM, Delimiter);
  finally
    ImportarBlocoM.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBlocoP(const Delimiter: TStrings);
var
  ImportarBlocoP: TACBrSpedPCImportar_BlocoP;
begin
  ImportarBlocoP := TACBrSpedPCImportar_BlocoP.Create;
  try
    ProcessaBloco(ImportarBlocoP, Delimiter);
  finally
    ImportarBlocoP.Free;
  end;
end;

procedure TACBrSpedPCImportar.ProcessaBloco(Bloco: TACBrSpedPCImportar_Base; const Delimiter: TStrings);
begin
  Bloco.AntesInserirValor := FAntesDeInserirColuna;
  Bloco.ACBrSpedPisCofins := ACBrSpedPisCofins;
  Bloco.AnalisaRegistro(Delimiter);
end;

{$ifdef FPC}
initialization
  {$i ACBrSPEDPisCofinsImportar.lrs}
{$endif}


end.
