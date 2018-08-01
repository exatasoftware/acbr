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

{ ******************************************************************************
|* Historico
|*
|* 09/08/2012: Albert Eije
|*  - Cria��o e distribui��o da Primeira Versao
******************************************************************************* }


{$I ACBr.inc}
unit ACBrPonto;

interface

uses
  SysUtils, Classes, DateUtils, ACBrBase,
  {$IFNDEF Framework}
    {$IFDEF FPC}
      LResources,
    {$ENDIF}
  {$ENDIF}
  Forms,
  ACBrTXTClass, ACBrUtil,
  ACBrPonto_AFD, ACBrPonto_AFD_Class,
  ACBrPonto_AFDT, ACBrPonto_AFDT_Class,
  ACBrPonto_ACJEF, ACBrPonto_ACJEF_Class;

const
  CACBrPonto_Versao = '0.01';

type

  // DECLARANDO O COMPONENTE:

  { TACBrPonto }
	{$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  {$ENDIF RTL230_UP}
  TACBrPonto = class(TACBrComponent)
  private
    FOnError: TErrorEvent;

    FPath: String; // Path do arquivo a ser gerado
    FDelimitador: String; // Caracter delimitador de campos
    FTrimString: boolean; // Retorna a string sem espa�os em branco iniciais e finais
    FCurMascara: String; // Mascara para valores tipo currency

    FPonto_AFD: TPonto_AFD;
    FPonto_AFDT: TPonto_AFDT;
    FPonto_ACJEF: TPonto_ACJEF;

    function GetAbout: String;
    function GetDelimitador: String;
    function GetTrimString: boolean;
    function GetCurMascara: String;
    procedure SetDelimitador(const Value: String);
    procedure SetTrimString(const Value: boolean);
    procedure SetCurMascara(const Value: String);

    function GetOnError: TErrorEvent; // M�todo do evento OnError
    procedure SetOnError(const Value: TErrorEvent); // M�todo SetError

  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override; // Create
    destructor Destroy; override; // Destroy

    function SaveFileTXT_AFD(Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_AFDT(Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro
    function SaveFileTXT_ACJEF(Arquivo: String): boolean; // M�todo que escreve o arquivo texto no caminho passado como par�metro

    function ProcessarArquivo_AFD(Arquivo: String): TPonto_AFD;

    property Ponto_AFD: TPonto_AFD read FPonto_AFD write FPonto_AFD;
    property Ponto_AFDT: TPonto_AFDT read FPonto_AFDT write FPonto_AFDT;
    property Ponto_ACJEF: TPonto_ACJEF read FPonto_ACJEF write FPonto_ACJEF;

  published
    property About: String read GetAbout stored False;
    property Path: String read FPath write FPath;

    property Delimitador: String read GetDelimitador write SetDelimitador;
    property TrimString: boolean read GetTrimString write SetTrimString default True;
    property CurMascara: String read GetCurMascara write SetCurMascara;

    property OnError: TErrorEvent read GetOnError write SetOnError;
  end;

procedure Register;

implementation

Uses
{$IFDEF COMPILER6_UP} StrUtils {$ELSE} ACBrD5 {$ENDIF};
{$IFNDEF FPC}
{$R ACBrPonto.dcr}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('ACBrTXT', [TACBrPonto]);
end;

constructor TACBrPonto.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPonto_AFD := TPonto_AFD.Create;
  FPonto_AFDT := TPonto_AFDT.Create;
  FPonto_ACJEF := TPonto_ACJEF.Create;

  // Define o delimitador
  SetDelimitador('');

  // Define a mascara dos campos num�ricos
  SetCurMascara('');

  FPath := ExtractFilePath(ParamStr(0));
  FDelimitador := '';
  FCurMascara := '';
  FTrimString := True;
end;

destructor TACBrPonto.Destroy;
begin
  FPonto_AFD.Free;
  FPonto_AFDT.Free;
  FPonto_ACJEF.Free;

  inherited;
end;

function TACBrPonto.GetAbout: String;
begin
  Result := 'ACBrPonto Ver: ' + CACBrPonto_Versao;
end;

function TACBrPonto.GetDelimitador: String;
begin
  Result := FDelimitador;
end;

procedure TACBrPonto.SetDelimitador(const Value: String);
begin
  FDelimitador := Value;

  FPonto_AFD.Delimitador := Value;
  FPonto_AFDT.Delimitador := Value;
  FPonto_ACJEF.Delimitador := Value;
end;

function TACBrPonto.GetCurMascara: String;
begin
  Result := FCurMascara;
end;

procedure TACBrPonto.SetCurMascara(const Value: String);
begin
  FCurMascara := Value;

  FPonto_AFD.CurMascara := Value;
  FPonto_AFDT.CurMascara := Value;
  FPonto_ACJEF.CurMascara := Value;
end;

function TACBrPonto.GetTrimString: boolean;
begin
  Result := FTrimString;
end;

procedure TACBrPonto.SetTrimString(const Value: boolean);
begin
  FTrimString := Value;

  FPonto_AFD.TrimString := Value;
  FPonto_AFDT.TrimString := Value;
  FPonto_ACJEF.TrimString := Value;
end;

function TACBrPonto.GetOnError: TErrorEvent;
begin
  Result := FOnError;
end;

procedure TACBrPonto.SetOnError(const Value: TErrorEvent);
begin
  FOnError := Value;

  FPonto_AFD.OnError := Value;
  FPonto_AFDT.OnError := Value;
  FPonto_ACJEF.OnError := Value;
end;

function TACBrPonto.SaveFileTXT_AFD(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_AFD.WriteCabecalho);

      Write(txtFile, FPonto_AFD.WriteRegistro2);

      if FPonto_AFD.Registro3.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro3);

      if FPonto_AFD.Registro4.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro4);

      if FPonto_AFD.Registro5.Count > 0 then
        Write(txtFile, FPonto_AFD.WriteRegistro5);

      Write(txtFile, FPonto_AFD.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FPonto_AFD.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.SaveFileTXT_AFDT(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_AFDT.WriteCabecalho);

      if FPonto_AFDT.Registro2.Count > 0 then
        Write(txtFile, FPonto_AFDT.WriteRegistro2);

      Write(txtFile, FPonto_AFDT.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa de todos os Blocos as listas de todos os registros.
    FPonto_AFDT.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.SaveFileTXT_ACJEF(Arquivo: String): boolean;
var
  txtFile: TextFile;
begin
  Result := True;

  if (Trim(Arquivo) = '') or (Trim(FPath) = '') then
    raise Exception.Create('Caminho ou nome do arquivo n�o informado!');

  try
    AssignFile(txtFile, FPath + Arquivo);
    try
      Rewrite(txtFile);

      Write(txtFile, FPonto_ACJEF.WriteCabecalho);

      if FPonto_ACJEF.Registro2.Count > 0 then
        Write(txtFile, FPonto_ACJEF.WriteRegistro2);

      if FPonto_ACJEF.Registro3.Count > 0 then
        Write(txtFile, FPonto_ACJEF.WriteRegistro3);

      Write(txtFile, FPonto_ACJEF.WriteTrailer);

    finally
      CloseFile(txtFile);
    end;

    // Limpa todos os registros.
    FPonto_ACJEF.LimpaRegistros;
  except
    on E: Exception do
    begin
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TACBrPonto.ProcessarArquivo_AFD(Arquivo: String): TPonto_AFD;
var
  LerArquivo: TStringList;
  i: Integer;
begin
  try
    Result := TPonto_AFD.Create;

    LerArquivo := TStringList.Create;
    LerArquivo.LoadFromFile(Arquivo);
    for i := 0 to LerArquivo.Count - 1 do
    begin
      //cabecalho
      if Copy(LerArquivo[i], 10, 1) = '1' then
      begin
        with Result.Cabecalho.Create do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := Copy(LerArquivo[i], 10, 1);
          Campo03 := Copy(LerArquivo[i], 11, 1);
          Campo04 := Copy(LerArquivo[i], 12, 14);
          Campo05 := Copy(LerArquivo[i], 26, 12);
          Campo06 := Copy(LerArquivo[i], 38, 150);
          Campo07 := Copy(LerArquivo[i], 188, 17);
          Campo08 := Copy(LerArquivo[i], 205, 8);
          Campo09 := Copy(LerArquivo[i], 213, 8);
          Campo10 := Copy(LerArquivo[i], 221, 8);
          Campo11 := Copy(LerArquivo[i], 229, 4);
        end;
      end

      //registro tipo 2
      else if Copy(LerArquivo[i], 10, 1) = '2' then
      begin
        with Result.Registro2.Create do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := Copy(LerArquivo[i], 10, 1);
          Campo03 := Copy(LerArquivo[i], 11, 8);
          Campo04 := Copy(LerArquivo[i], 19, 4);
          Campo05 := Copy(LerArquivo[i], 23, 1);
          Campo06 := Copy(LerArquivo[i], 24, 14);
          Campo07 := Copy(LerArquivo[i], 38, 12);
          Campo08 := Copy(LerArquivo[i], 50, 150);
          Campo09 := Copy(LerArquivo[i], 200, 100);
        end;
      end

      //registros tipo 3
      else if Copy(LerArquivo[i], 10, 1) = '3' then
      begin
        with Result.Registro3.New do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := Copy(LerArquivo[i], 10, 1);
          Campo03 := Copy(LerArquivo[i], 11, 8);
          Campo04 := Copy(LerArquivo[i], 19, 4);
          Campo05 := Copy(LerArquivo[i], 23, 12);
        end;
      end

      //registros tipo 4
      else if Copy(LerArquivo[i], 10, 1) = '4' then
      begin
        with Result.Registro4.New do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := Copy(LerArquivo[i], 10, 1);
          Campo03 := Copy(LerArquivo[i], 11, 8);
          Campo04 := Copy(LerArquivo[i], 19, 4);
          Campo05 := Copy(LerArquivo[i], 23, 8);
          Campo06 := Copy(LerArquivo[i], 31, 4);
        end;
      end

      //registros tipo 5
      else if Copy(LerArquivo[i], 10, 1) = '5' then
      begin
        with Result.Registro5.New do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := Copy(LerArquivo[i], 10, 1);
          Campo03 := Copy(LerArquivo[i], 11, 8);
          Campo04 := Copy(LerArquivo[i], 19, 4);
          Campo05 := Copy(LerArquivo[i], 23, 1);
          Campo06 := Copy(LerArquivo[i], 24, 12);
          Campo07 := Copy(LerArquivo[i], 36, 52);
        end;
      end

      //trailer
      else if Copy(LerArquivo[i], 1, 9) = '999999999' then
      begin
        with Result.Trailer.Create do
        begin
          Campo01 := Copy(LerArquivo[i], 1, 9);
          Campo02 := StrToInt(Copy(LerArquivo[i], 10, 9));
          Campo03 := StrToInt(Copy(LerArquivo[i], 19, 9));
          Campo04 := StrToInt(Copy(LerArquivo[i], 28, 9));
          Campo05 := StrToInt(Copy(LerArquivo[i], 37, 9));
          Campo06 := Copy(LerArquivo[i], 46, 1);
        end;
      end;

    end;
  finally
  end;
end;

procedure TACBrPonto.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
end;

{$IFDEF FPC}
initialization
   {$I ACBrPonto.lrs}
{$ENDIF}

end.
