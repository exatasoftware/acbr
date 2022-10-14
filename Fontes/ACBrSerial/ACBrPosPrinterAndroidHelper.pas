{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit ACBrPosPrinterAndroidHelper;

interface
uses
  Classes, SysUtils,
  FMX.Graphics,
  FMX.Surfaces,
  Androidapi.JNI.GraphicsContentViewText;

procedure AndroidBeep(ADuration: Integer);
Function BitmapToJBitmap(const ABitmap: TBitmap): JBitmap;
procedure ConteudoBlocoToBitmap(ConteudoBloco: AnsiString; ABitMap: TBitmap);

implementation

uses
  StrUtils,
  Androidapi.JNI.Media,
  FMX.Helpers.Android,
  synacode,
  ACBrImage,
  ACBrUtil.Strings;

procedure AndroidBeep(ADuration: Integer);
begin
  // https://stackoverflow.com/questions/30938946/how-do-i-make-a-beep-sound-in-android-using-delphi-and-the-api
  TJToneGenerator.JavaClass.init( TJAudioManager.JavaClass.ERROR,
                                  TJToneGenerator.JavaClass.MAX_VOLUME)
    .startTone( TJToneGenerator.JavaClass.TONE_DTMF_0,
                ADuration );
end;

//https://forums.embarcadero.com/thread.jspa?threadID=245452&tstart=0
Function BitmapToJBitmap(const ABitmap: TBitmap): JBitmap;
var
  LSurface: TBitmapSurface;
  LBitmap : JBitmap;
begin
  Result := nil;
  LSurface := TBitmapSurface.Create;
  try
    LSurface.Assign(ABitmap);
    LBitmap := TJBitmap.JavaClass.createBitmap( LSurface.Width,
                                                LSurface.Height,
                                                TJBitmap_Config.JavaClass.ARGB_8888);
    if SurfaceToJBitmap(LSurface, LBitmap) then
      Result := LBitmap;
  finally
    LSurface.Free;
  end;
end;


procedure ConteudoBlocoToBitmap(ConteudoBloco: AnsiString; ABitMap: TBitmap);
var
  ARasterStr: AnsiString;
  AHeight, AWidth: Integer;
  SL: TStringList;
  AData: String;
  MS: TMemoryStream;
  SS: TStringStream;
begin
  AData := Trim(ConteudoBloco);
  if (AData = '') then
    Exit;

  if StrIsBinary(LeftStr(AData,10)) then           // AscII Art
  begin
    SL := TStringList.Create;
    MS := TMemoryStream.Create;
    try
      SL.Text := AData;
      AWidth := 0; AHeight := 0; ARasterStr := '';
      AscIIToRasterStr(SL, AWidth, AHeight, ARasterStr);
      RasterStrToBMPMono(ARasterStr, AWidth, False, MS);
      MS.Position := 0;
      ABitMap.LoadFromStream(MS);
    finally
      SL.Free;
      MS.Free;
    end;
  end

  else if StrIsBase64(AData) then
  begin
    SS := TStringStream.Create(DecodeBase64(AData));
    try
      SS.Position := 0;
      ABitMap.LoadFromStream(SS);
    finally
      SS.Free;
    end;
  end

  else
    ABitMap.LoadFromFile(AData);
end;

end.
