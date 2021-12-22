{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
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

unit ACBrDeviceLPT;

interface

uses
  Classes, SysUtils,
  ACBrDeviceClass, ACBrBase;

type
  { TACBrThreadEnviaLPT }
  { Essa classe � usada pela fun��o EnviaStringThread para detectar se os Dados
    estao sendo "gravados" com sucesso na porta paralela ou arquivo. }

  TACBrThreadEnviaLPT = class(TThread)
  private
    fsTextoAEnviar: String;
    fsBytesSent: Integer;
    fsOwner: TObject;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TObject; const AString: String);
    property BytesSent: Integer read fsBytesSent;
  end;

  { TACBrDeviceLPT }

  TACBrDeviceLPT = class(TACBrDeviceClass)
  private
    fsUsarStream: Boolean;
    fsUsarThread: Boolean;
    fsFileStream: TFileStream;
    fsArqPrn: TextFile;

    function IsTXTFilePort: Boolean;
    function ObterNomeArquivo(const APorta: String): String;
    procedure EnviarStringThread(AString: AnsiString);

    procedure AbrirArquivo;
    procedure EnviarDados(const ABuffer: AnsiString);
    procedure FecharArquivo;
  protected
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure Conectar(const APorta: String; const ATimeOutMilissegundos: Integer); override;
    procedure Desconectar(IgnorarErros: Boolean = True); override;

    procedure EnviarStringNormal(const AString: AnsiString);
    procedure EnviaString(const AString: AnsiString); override;

    property UsarThread: Boolean read fsUsarThread write fsUsarThread;
    property UsarStream: Boolean read fsUsarStream write fsUsarStream;
  end;

implementation

uses
  dateutils, strutils,
  {$IFNDEF NOGUI}
   {$If defined(VisualCLX)}
    QForms,
   {$ElseIf defined(FMX)}
    FMX.Forms,
   {$Else}
    Forms,
   {$IfEnd}
  {$EndIf}
  {$IF defined(POSIX)}
   Posix.Unistd,
  {$IfEnd}
  ACBrDevice, ACBrUtil, ACBrConsts;

{ TACBrThreadEnviaLPT }

constructor TACBrThreadEnviaLPT.Create(AOwner: TObject; const AString: String);
begin
  if not (AOwner is TACBrDeviceLPT) then
    raise Exception.Create(ACBrStr('Uso Inv�lido da TACBrThreadEnviaLPT'));

  inherited Create(False); { Rodar Imediatemanete }
  FreeOnTerminate := True;

  fsOwner := AOwner;
  fsTextoAEnviar := AString;
end;

procedure TACBrThreadEnviaLPT.Execute;
var
  I, MaxLen, BufferLen: Integer;
begin
  if (fsTextoAEnviar <> '') then
  begin
    fsBytesSent := 0;
    I := 1;
    MaxLen := Length(fsTextoAEnviar);
    BufferLen := 256;

    with TACBrDeviceLPT(fsOwner) do
    begin
      while (I <= MaxLen) and (not Terminated) do
      begin
        EnviarStringNormal(copy(fsTextoAEnviar, I, BufferLen));
        fsBytesSent := fsBytesSent + BufferLen;
        I := I + BufferLen;
      end;
    end;
  end;

  Terminate;
end;

{ TACBrDeviceLPT }

constructor TACBrDeviceLPT.Create(AOwner: TComponent);
begin
  inherited;
  fsUsarThread := False;
  {$IfDef FPC}
  fsUsarStream := True;
  {$Else}
   {$IfDef FMX}
   fsUsarStream := True;
   {$Else}
   fsUsarStream := False;
   {$EndIf}
  {$EndIf}
end;

destructor TACBrDeviceLPT.Destroy;
begin
  FecharArquivo;
  inherited Destroy;
end;

procedure TACBrDeviceLPT.Conectar(const APorta: String; const ATimeOutMilissegundos: Integer);
var
  NomeArq, ErrorMsg: String;
begin
  inherited;

  NomeArq := ObterNomeArquivo(APorta);
  GravaLog('  NomeArq: ' + NomeArq);

  { Tenta Abrir Arquivo/Porta para ver se existe e est� disponivel}
  if IsTXTFilePort and FileExists(NomeArq) then
  begin
    GravaLog('  DeleteFile(' + NomeArq + ')');
    SysUtils.DeleteFile(NomeArq);
  end;

  try
    EnviarStringNormal('');
  except
    on E: EFOpenError do
    begin
      ErrorMsg := '';
      if not IsTXTFilePort then
      begin
        {$IfNDef MSWINDOWS}
        if not FileExists(APorta) then
          ErrorMsg := Format(ACBrStr(cACBrDeviceAtivarPortaNaoEncontrada), [APorta])
        else
        {$EndIf}
          ErrorMsg := Format(ACBrStr(cACBrDeviceAtivarPortaNaoAcessivel), [APorta]);
      end;

      if (ErrorMsg = '') then
        ErrorMsg := E.Message;

      if fsUsarStream then
        DoException(EStreamError.Create(ErrorMsg))
      else
        DoException(Exception.Create(ErrorMsg));
    end;

    On E: Exception do
      DoException(Exception.Create(E.ClassName + ': ' + E.Message));
  end;
end;

procedure TACBrDeviceLPT.Desconectar(IgnorarErros: Boolean);
begin
  inherited;
  FecharArquivo;
end;

function TACBrDeviceLPT.ObterNomeArquivo(const APorta: String): String;
begin
  Result := APorta;
  if (copy(UpperCase(Result), 1, 5) = 'FILE:') then
    Result := copy(Result, 6, Length(Result));
end;

procedure TACBrDeviceLPT.EnviarStringNormal(const AString: AnsiString);
var
  I, Max, NBytes: Integer;
  Buffer: AnsiString;
begin
  with TACBrDevice(fpOwner) do
  begin
    I := 1;
    Max := Length(AString);
    NBytes := SendBytesCount;
    if NBytes = 0 then
      NBytes := Max;

    AbrirArquivo;
    try
      while I <= Max do
      begin
        GravaLog('  BytesToSend:' + IntToStr(NBytes));
        Buffer := copy(AString, I, NBytes);
        EnviarDados(Buffer);

        if SendBytesInterval > 0 then
        begin
          GravaLog('  Sleep(' + IntToStr(SendBytesInterval) + ')');
          Sleep(SendBytesInterval);
        end;

        I := I + NBytes;
      end;
    finally
      FecharArquivo;
    end;
  end;
end;

function TACBrDeviceLPT.IsTXTFilePort: Boolean;
begin
  Result := TACBrDevice(fpOwner).IsTXTFilePort;
end;

procedure TACBrDeviceLPT.AbrirArquivo;
var
  CreateModeFlag: Integer;
  NomeArq: String;
begin
  NomeArq := ObterNomeArquivo(fpPorta);

  if fsUsarStream then
  begin
    if IsTXTFilePort and FileExists(NomeArq) then
      CreateModeFlag := fmOpenReadWrite
    else
      CreateModeFlag := fmCreate;

    CreateModeFlag := CreateModeFlag or fmShareDenyWrite;
    // Tentando abrir o arquivo
    fsFileStream := TFileStream.Create(NomeArq, CreateModeFlag);
    fsFileStream.Seek(0, soEnd);  // vai para EOF
  end
  else
  begin
    AssignFile(fsArqPrn, NomeArq);
    if IsTXTFilePort and FileExists(NomeArq) then
      Append(fsArqPrn)
    else
      Rewrite(fsArqPrn);
  end;
end;

procedure TACBrDeviceLPT.EnviarDados(const ABuffer: AnsiString);
begin
  if fsUsarStream then
  begin
    if Assigned(fsFileStream) then
      fsFileStream.Write(Pointer(ABuffer)^, Length(ABuffer));
  end
  else
    Write(fsArqPrn, ABuffer);
end;

procedure TACBrDeviceLPT.FecharArquivo;
begin
  if fsUsarStream then
  begin
    if Assigned(fsFileStream) then
      FreeAndNil(fsFileStream);
  end
  else
  begin
    {$I-}
    Flush(fsArqPrn);
    {$IfNDef FPC}System.{$EndIf}CloseFile(fsArqPrn);
    IOResult;
    {$I+}
  end;
end;


{ A ideia dessa Thread � testar se os dados est�o sendo gravados com sucesso na
  Porta Paralela (ou arquivo). � criada uma Thread para "gravar" os dados em
  segundo plano, enquanto o programa monitora se as linhas est�o sendo enviadas.
  Caso a Thread nao consiga enviar uma linha dentro do Timeout definido a Thread
  � cancelada e � gerado um TIMEOUT. Isso evita o "travamento" do programa
  quando a porta ou arquivo n�o est�o prontos para a grava��o com o comando
  Write() }
procedure TACBrDeviceLPT.EnviarStringThread(AString: AnsiString);
var
  IsTimeOut: Boolean;
  TempoFinal: TDateTime;
  UltimoBytesSent: Integer;
  ThreadEnviaLPT: TACBrThreadEnviaLPT;
begin
  { Criando Thread para monitorar o envio de dados a Porta Paralela }
  IsTimeOut := False;
  UltimoBytesSent := -1;
  TempoFinal := -1;
  ThreadEnviaLPT := TACBrThreadEnviaLPT.Create(Self, AString);
  try
    while not ThreadEnviaLPT.Terminated do
    begin
      if UltimoBytesSent <> ThreadEnviaLPT.BytesSent then
      begin
        TempoFinal := IncMilliSecond(now, TimeOutMilissegundos);
        UltimoBytesSent := ThreadEnviaLPT.BytesSent;
      end;

      {$IFNDEF NOGUI}
      if TACBrDevice(fpOwner).ProcessMessages then
        Application.ProcessMessages;
      {$ENDIF}
      IsTimeOut := (now > TempoFinal); {Verifica se estourou o tempo TIMEOUT}
      if IsTimeOut then
        Break;

      sleep(200);
    end;
  finally
    ThreadEnviaLPT.Terminate;

    if IsTimeOut then
      DoException(Exception.Create(Format(ACBrStr(cACBrDeviceEnviaStrThreadException), [fpPorta])));
  end;
end;

procedure TACBrDeviceLPT.EnviaString(const AString: AnsiString);
begin
  GravaLog('  TACBrDeviceLPT.EnviaString '+IfThen(fsUsarThread,' - UsarThread',''));

  if UsarThread then
    EnviarStringThread(AString)
  else
    EnviarStringNormal(AString);
end;

end.
