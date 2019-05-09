{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{ Colaboradores nesse arquivo:                                                 }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 19/01/2018: Rafael Dias/DSA
|*  - Cria��o do componente
******************************************************************************}

{$I ACBr.inc}

unit ACBrDFeReportFortes;

interface

uses
  Classes, SysUtils, math,
  RLReport, RLPrinters, RLPDFFilter,
  ACBrUtil, ACBrDFeReport;

type
  TDFeReportFortes = class
  public
    class procedure AjustarReport(FReport: TRLReport; AConfig: TACBrDFeReport);
    class procedure AjustarMargem(FReport: TRLReport; AConfig: TACBrDFeReport);
    class procedure AjustarFiltroPDF(PDFFilter: TRLPDFFilter; AConfig: TACBrDFeReport; const AFile: String);
    class function CarregarLogo(ALogoImage: TRLImage; const ALogo: string): Boolean;
  end;


implementation

class procedure TDFeReportFortes.AjustarReport(FReport: TRLReport; AConfig: TACBrDFeReport);
begin
  FReport.ShowProgress := AConfig.MostraStatus;
  FReport.PrintDialog := (not (AConfig.MostraPreview)) and EstaVazio(AConfig.Impressora) or (AConfig.MostraSetup);

  if NaoEstaVazio(AConfig.Impressora) then
      RLPrinter.PrinterName := AConfig.Impressora;

  if RLPrinter.SupportsDuplex Then
     RLPrinter.Duplex := false;
	 
  if RLPrinter.Copies <> AConfig.NumCopias then
  begin
    RLPrinter.Copies := AConfig.NumCopias;
  end;
end;

class procedure TDFeReportFortes.AjustarMargem(FReport: TRLReport; AConfig: TACBrDFeReport);
begin
  // AJuste das Margens
  with FReport.Margins do
  begin
    TopMargin := AConfig.MargemSuperior * 10;
    BottomMargin := AConfig.MargemInferior * 10;
    LeftMargin := AConfig.MargemEsquerda * 10;
    RightMargin := AConfig.MargemDireita * 10;
  end;
end;

class procedure TDFeReportFortes.AjustarFiltroPDF(PDFFilter: TRLPDFFilter; AConfig: TACBrDFeReport; const AFile: String);
Var
  ADir: String;
  NomeArquivoFinal: String;
begin
  NomeArquivoFinal := Trim(AFile);
  if EstaVazio(NomeArquivoFinal) then
    raise Exception.Create('Erro ao gerar PDF. Arquivo n�o informado');

  ADir := ExtractFilePath(NomeArquivoFinal);
  if EstaVazio(ADir) then
    NomeArquivoFinal := ApplicationPath + ExtractFileName(NomeArquivoFinal)
  else
  begin
    if not ForceDirectories(ADir) then
      raise Exception.Create('Erro ao gerar PDF. Diret�rio: ' + ADir + ' n�o pode ser criado');
  end;

  PDFFilter.ShowProgress := AConfig.MostraStatus;
  PDFFilter.FileName := NomeArquivoFinal;
end;

class function TDFeReportFortes.CarregarLogo(ALogoImage: TRLImage; const ALogo: string): Boolean;
var
  LogoStream: TStringStream;
begin
  Result := False;
  ALogoImage.Picture := nil;
  if EstaVazio(Trim(ALogo)) then
    Exit;

  if FileExists(ALogo) then
  begin
    ALogoImage.Picture.LoadFromFile(ALogo);
    Result := True;
  end
  else
  begin
    LogoStream := TStringStream.Create(ALogo);
    try
      try
        ALogoImage.Picture.Bitmap.LoadFromStream(LogoStream);
        Result := True;
      except
        ALogoImage.Picture := nil;
      end;
    finally
      LogoStream.Free;
    end;
  end;
end;

end.
