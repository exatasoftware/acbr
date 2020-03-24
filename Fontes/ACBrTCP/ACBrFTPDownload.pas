{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Isaque Pinheiro                                 }
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

unit ACBrFTPDownload;

interface

uses
  Classes, SysUtils,
  ACBrDownloadClass, ACBrBase,
  ftpsend, blcksock, synautil;

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrFTPDownload = class(TACBrDownloadClass)
  private
    fFTPSend: TFTPSend;
    fFTP: TACBrFTP;

  protected
    procedure DoHookStatus(Sender: TObject; Reason: THookSocketReason;
      const Value: String); override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    procedure StartDownload; override;
  published
    property FTP: TACBrFTP read fFTP write fFTP;
  end;

implementation

uses ACBrDownload;

{ TACBrFTPDownload }

constructor TACBrFTPDownload.Create(AOwner: TComponent);
begin
  fFTPSend                 := TFTPSend.Create;
  fFTPSend.DSock.OnStatus  := DoHookStatus;
  fFTPSend.DSock.OnMonitor := DoHookMonitor;

  fDocument := fFTPSend.DataStream;
  fSock     := fFTPSend.DSock;
  inherited Create(AOwner);

  fFTP := TACBrDownload(AOwner).FTP;
end;

destructor TACBrFTPDownload.Destroy;
begin
  fFTPSend.DSock.OnStatus  := nil;
  fFTPSend.DSock.OnMonitor := nil;

  if Assigned(fFTP) then
     fFTP := nil;

  fFTPSend.Free;
  inherited Destroy;
end;

procedure TACBrFTPDownload.DoHookStatus(Sender: TObject; Reason: THookSocketReason;
  const Value: String);
begin
  fResultCode := fFTPSend.ResultCode;
  case Reason of
     HR_SocketClose:
     begin
       if fResultCode = 227  then // Inicializando
          Exit;
     end;
  end;
  inherited;
end;

procedure TACBrFTPDownload.StartDownload;
var
  Prot, User, Pass, Host, Port, Path, Para : String;
begin
  try
    if (fFilePart = '') and (fDownloadStatus <> stRedirect) then
    begin
       Prot := '';
       User := '';
       Pass := '';
       Host := '';
       Port := '';
       Path := '';
       Para := '';
       ParseURL(fDownloadUrl, Prot, User, Pass, Host, Port, Path, Para);

       // Configura��o FTP
       fFTPSend.TargetHost := fFTP.FtpHost;
       fFTPSend.TargetPort := fFTP.FtpPort;
       fFTPSend.Username   := fFTP.FtpUser;
       fFTPSend.Password   := fFTP.FtpPass;
       fFTPSend.Timeout    := fFTP.FtpTimeout;

       // Defini��o do Proxy
//       fFTPSend.DSock.SocksIP       := fProxy.ProxyHost;
//       fFTPSend.DSock.SocksPort     := fProxy.ProxyPort;
//       fFTPSend.DSock.SocksUsername := fProxy.ProxyUser;
//       fFTPSend.DSock.SocksPassword := fProxy.ProxyPass;

       // StringReplace() foi chamado aqui porque no Delphi n�o reconhece barra "/"
       // como o Lazarus que reconhece os dois.
       fFilePart := ExtractFileName(StringReplace(Path, '/', '\', [rfReplaceAll]));

       if fFilePart <> '' then
          fFilePart := fFilePart + '.part';
    end;
    // FTP Login
    if not fFTPSend.Login then
      raise Exception.Create('N�o foi poss�vel efetuar o login!');

//    if fProxy.ProxyHost <> '' then
//    begin
//       if not fFTPSend.DSock Login then
//         Exit;
//    end;

    if fFilePart = '' then
       raise Exception.Create('File To Save not found');

    // Abrir ou Criar o arquivo de download
    OpenCreateFile;

    fFTPSend.DirectFileName := fFilePart;
    fFTPSend.DirectFile := False;

    fDownloadSize := fFTPSend.FileSize(Path);
//    fDownloadSize := fDownloadSize - fFileStream.Size;

    // Evento
    if Assigned(fOnBeforeDownload) then
       fOnBeforeDownload(Self);

    fFTPSend.RetrieveFile(Path, True);

    // Evento
    if Assigned(fOnAfterDownload) then
       fOnAfterDownload(Self);

  finally
     fFTPSend.Logout;
  end;
end;

end.
