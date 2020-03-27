{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Elton M. Barbosa                                }
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

unit ACBrEAD;

interface

uses
   Classes, SysUtils, strutils, ACBrConsts, ACBrBase,
   ACBrUtil, OpenSSLExt;

const
   CBufferSize = 32768;
   cRFDRSAKey = '-----BEGIN RSA PRIVATE KEY-----' + sLineBreak +
                'MIICXQIBAAKBgQCtpPqcoOX4rwgdoKi6zJwPX9PA2iX2KxgvyxjE+daI5ZmYxcg0'+ sLineBreak +
                'NScjX59nXRaLmtltVRfsRc1n4+mLSXiWMh3jIbw+TWn+GXKQhS2GitpLVhO3A6Ns'+ sLineBreak +
                'vO1+RuP77s+uGYhqVvbD0Pziq+I2r4oktsjTbpnC7Mof3BjJdIUFsTHKYwIDAQAB'+ sLineBreak +
                'AoGAXXqwU7umsi8ADnsb+pwF85zh8TM/NnvSpIAQkJHzNXVtL7ph4gEvVbK3rLyH'+ sLineBreak +
                'U5aEMICbxV16i9A9PPfLjAfk4CuPpZlTibgfBRIG3MXirum0tjcyzbPyiDrk0qwM'+ sLineBreak +
                'e83MyRkrnGlss6cRT3mZk67txEamqTVmDwz/Sfo1fVlCQAkCQQDW3N/EKyT+8tPW'+ sLineBreak +
                '1EuPXafRONMel4xB1RiBmHYJP1bo/sDebLpocL6oiVlUX/k/zPRo1wMvlXJxPyiz'+ sLineBreak +
                'mnf37cZ9AkEAzuPcDvGxwawr7EPGmPQ0f7aWv87tS/rt9L3nKiz8HfrT6WT0R1Bh'+ sLineBreak +
                'I7lLGq4VFWE29I6hQ2lPNGX9IGFjiflKXwJBALgsO+J62QtwOgU7lEkfjmnYu57N'+ sLineBreak +
                'aHxFnOv5M7RZhrXRKKF/sYk0mzj8AoZAffYiSJ5VL3XqNF6+NLU/AvaR6kECQQCV'+ sLineBreak +
                'nY6sd/kWmA4DhFgAkMnOehq2h0xwH/0pepPLmlCQ1a2eIVXOpMA692rq1m2E0pLN'+ sLineBreak +
                'dMAGYgfXWtIdMpCrXM59AkB5npcELeGBv1K8B41fmrlA6rEq4aqmfwAFRKcQTj8a'+ sLineBreak +
                'n09FVtccLVPJ42AM1/QXK6a8DGCtB9R+j5j3UO/iL0+3'+ sLineBreak +
                '-----END RSA PRIVATE KEY-----' ;

{    **** IMPORTANTE ****
    Por motivos de seguran�a, GERE A SUA PROPRIA CHAVE e informe-a em:
     "OnGetChavePrivada" }

type
  TACBrEADDgst = (dgstMD2, dgstMD4, dgstMD5, dgstRMD160, dgstSHA, dgstSHA1, dgstSHA256, dgstSHA512) ;
  TACBrEADDgstOutput = (outHexa, outBase64, outBinary) ;

  TACBrEADCalc = procedure(Arquivo: String) of object ;
  TACBrEADGetChave = procedure(var Chave: AnsiString) of object ;
  TACBrEADOnProgress = procedure(const PosByte, TotalSize: Int64) of object ;

  EACBrEADException = class(Exception);

  { TACBrEAD }
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrEAD = class(TACBrComponent)
  private
    fsOnGetChavePrivada: TACBrEADGetChave;
    fsOnGetChavePublica : TACBrEADGetChave ;
    fsOnProgress: TACBrEADOnProgress;

    fsKey : pEVP_PKEY ;
    fsIsXMLeECFc : Boolean ;
    fsBufferSize: Integer;
    fsVersao: String;
    fsVersaoEhAntiga: Boolean;

    function GetOpenSSL_Version: String;

    Function GetChavePrivada : AnsiString;
    procedure LerChavePrivada ;
    Function GetChavePublica : AnsiString;
    procedure LerChavePublica ;
    Procedure LerChave_eECFc( const ConteudoXML: AnsiString) ;
    Procedure LerChaveModuloExpoente( Modulo, Expoente: AnsiString) ;
    procedure LerChave(const Chave : AnsiString; Privada: Boolean) ;
    procedure LiberarChave ;

    function CriarMemBIO: pBIO ;
    procedure LiberarBIO( Bio : pBIO);

    function BioToStr( ABio : pBIO) : String ;

    procedure SetBufferSize(AValue: Integer);

    function GetDigestName(ADigest: TACBrEADDgst): String;

    procedure VerificaNomeArquivo( const NomeArquivo : String ) ;
    function InternalDigest( const AStream : TStream;
       const ADigest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa;
       const Assinar: Boolean =  False): AnsiString;
    function InternalVerify( const AStream : TStream;
       const BinarySignature: AnsiString;
       const ADigest: TACBrEADDgst): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy  ; override;

    procedure LerChavesArquivoPFX(const AArquivoPFX, Senha: String;
      var AChavePublica: AnsiString; var AChavePrivada: AnsiString);
    procedure LerChavesPFX(const ADadosPFX: AnsiString; const Senha: String;
      var AChavePublica: AnsiString; var AChavePrivada: AnsiString); overload;
    procedure LerChavesPFX(const AStreamPFX: TStream; const Senha: String;
      var AChavePublica: AnsiString; var AChavePrivada: AnsiString); overload;
    Procedure GerarChaves( var AChavePublica : AnsiString; var AChavePrivada : AnsiString ) ;

    Function GerarXMLeECFc(const NomeSwHouse, Diretorio: String): Boolean; overload;
    Function GerarXMLeECFc(const NomeSwHouse: String): AnsiString; overload;
    Procedure CalcularModuloeExpoente( var Modulo, Expoente : AnsiString );
    Function CalcularChavePublica : AnsiString ;
    Function ConverteXMLeECFcParaOpenSSL(const  ArquivoXML: String) : AnsiString;

    function ConverteChavePublicaParaOpenSSH(): String;
    function ConverterChavePublicaDeOpenSSH(const AChavePublicaOpenSSH: String): String;

    function CalcularHashArquivo( const NomeArquivo: String;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ;
    function CalcularHash( const AString : AnsiString;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;
    function CalcularHash( const AStringList : TStringList;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;
    function CalcularHash( const AStream : TStream;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;

    function CalcularAssinaturaArquivo( const NomeArquivo: String;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;
    function CalcularAssinatura( const AString : AnsiString;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;
    function CalcularAssinatura( const AStringList : TStringList;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;
    function CalcularAssinatura( const AStream : TStream;
       const Digest: TACBrEADDgst;
       const OutputType: TACBrEADDgstOutput = outHexa ): AnsiString ; overload ;

    function VerificarAssinatura( const AString, Assinatura : AnsiString;
       const Digest: TACBrEADDgst): Boolean ; overload ;
    function VerificarAssinatura(const AStringList : TStringList;
       const Assinatura : AnsiString;
       const Digest: TACBrEADDgst): Boolean ; overload ;
    function VerificarAssinatura(const AStream : TStream;
       const Assinatura : AnsiString;
       const Digest: TACBrEADDgst): Boolean ; overload ;

    function CalcularEADArquivo( const NomeArquivo: String): AnsiString ; overload ;
    function CalcularEAD( const AString : AnsiString): AnsiString ; overload ;
    function CalcularEAD( const AStringList : TStringList): AnsiString ; overload ;
    function CalcularEAD( const AStream: TStream): AnsiString; overload;

    function AssinarArquivoComEAD( const NomeArquivo: String;
       RemoveEADSeExistir : Boolean = False ) : AnsiString ;

    Function RemoveEADArquivo( const NomeArquivo: String): AnsiString ;
    Function RemoveEAD( AStream : TStream ): AnsiString;

    Function LeEADArquivo( const NomeArquivo: String): AnsiString;
    Function LeEAD( AStream : TStream ) : AnsiString;

    function VerificarEADArquivo( const NomeArquivo: String): Boolean ; overload ;
    function VerificarEAD( const AString : AnsiString): Boolean ; overload ;
    function VerificarEAD( const AStringList : TStringList): Boolean ; overload ;
    function VerificarEAD(const AStream : TStream ; EAD : String = '') : Boolean ;
      overload ;

    property OpenSSL_Version : String read GetOpenSSL_Version ;
    function OpenSSL_OldVersion: Boolean;

    function MD5FromFile(const APathArquivo: String): String;
    function MD5FromString(const AString: String): String;

  published
    property BufferSize: Integer read fsBufferSize write SetBufferSize default CBufferSize;

    property OnGetChavePrivada: TACBrEADGetChave read fsOnGetChavePrivada
       write fsOnGetChavePrivada;
    property OnGetChavePublica: TACBrEADGetChave read fsOnGetChavePublica
       write fsOnGetChavePublica;
    property OnProgress: TACBrEADOnProgress read fsOnProgress write fsOnProgress;
  end;

procedure InitOpenSSL ;
procedure FreeOpenSSL ;

Var
 OpenSSLLoaded : Boolean ;


implementation

uses synacode;

procedure InitOpenSSL;
begin
  if OpenSSLLoaded then
    exit ;

  OpenSSL_add_all_algorithms;
  OpenSSL_add_all_ciphers;
  OpenSSL_add_all_digests;
  ERR_load_crypto_strings;

  OpenSSLLoaded := True;
end;

procedure FreeOpenSSL;
begin
  if not OpenSSLLoaded then
    exit;

  EVPcleanup();
  OpenSSLLoaded := False;
end;

function TACBrEAD.MD5FromFile(const APathArquivo: String): String;
begin
  Result := String(CalcularHashArquivo(APathArquivo, dgstMD5));
end;

function TACBrEAD.MD5FromString(const AString: String): String;
begin
  Result := String(CalcularHash(AnsiString(AString), dgstMD5));
end;

function TACBrEAD.ConverteChavePublicaParaOpenSSH(): String;
Var
  Buffer, Modulo, Expoente: AnsiString;

  function EncodeHexaSSH(HexaStr: String): AnsiString;
  var
    LenHexa: Integer;
  begin
    LenHexa := Length(HexaStr);
    if odd(LenHexa) then
    begin
      HexaStr := '0'+HexaStr;
      Inc( LenHexa );
    end;

    Result := IntToBEStr(Trunc(LenHexa/2), 4) + HexToAsciiDef(HexaStr, ' ');
  end;

  function EncodeBufferSSH(ABuffer: AnsiString): AnsiString;
  var
    HexaStr: String;
  begin
    HexaStr := AsciiToHex(ABuffer);
    Result := EncodeHexaSSH(HexaStr);
  end;

begin
  // https://www.netmeister.org/blog/ssh2pkcs8.html

  CalcularModuloeExpoente(Modulo, Expoente);

  Buffer := EncodeBufferSSH('ssh-rsa') +
            EncodeHexaSSH(Expoente)  +
            EncodeHexaSSH('00'+Modulo);
  Result := 'ssh-rsa '+ EncodeBase64(Buffer);
end;

function TACBrEAD.ConverterChavePublicaDeOpenSSH(
  const AChavePublicaOpenSSH: String): String;

  function LerBloco( ABinStr: AnsiString; var P: Integer ): AnsiString;
  var
    LenBloco: Integer;
  begin
    LenBloco := BEStrToInt(copy(ABinStr,P,4));
    Result := Copy(ABinStr,P+4, LenBloco);
    P := P + 4 + LenBloco;
  end;

var
  ABinStr, Header, Modulo, Expoente: AnsiString;
  P1, P2: Integer;
  Bio: PBIO;
  Base64Key: String;
begin
  Result := '';
  P1 := pos(' ', AChavePublicaOpenSSH);
  P2 := PosEx(' ', AChavePublicaOpenSSH, P1 + 1);
  if P2 = 0 then
    P2 := Length(AChavePublicaOpenSSH)+1;

  Base64Key := copy(AChavePublicaOpenSSH, P1 + 1, P2-P1-1);

  ABinStr := DecodeBase64(Base64Key);
  P1 := 1;
  Header   := LerBloco(ABinStr, P1);
  if (Header <> 'ssh-rsa') then
    raise EACBrEADException.Create( ACBrStr('Conteudo de chave Publica de OpenSSH inv�lido') );

  Expoente := AsciiToHex(LerBloco(ABinStr, P1));
  Modulo   := AsciiToHex(LerBloco(ABinStr, P1));

  LerChaveModuloExpoente(Modulo, Expoente);

  Bio := CriarMemBIO;
  try
    if PEM_write_bio_PUBKEY(Bio, fsKey) = 1 then
      Result := AnsiString( BioToStr( Bio ) );
  finally
    LiberarBIO( Bio ) ;
  end ;
end;

{ ------------------------------ TACBrEAD ------------------------------ }

procedure TACBrEAD.SetBufferSize(AValue: Integer);
begin
  if fsBufferSize = AValue then Exit;

  if AValue < 1024 then
     fsBufferSize := 1024
  else
     fsBufferSize := AValue;
end;

function TACBrEAD.GetDigestName(ADigest: TACBrEADDgst): String;
begin
  case ADigest of
    dgstMD2    : Result := 'md2';
    dgstMD4    : Result := 'md4';
    dgstMD5    : Result := 'md5';
    dgstRMD160 : Result := 'rmd160';
    dgstSHA    : Result := 'sha';
    dgstSHA1   : Result := 'sha1';
    dgstSHA256 : Result := 'sha256';
    dgstSHA512 : Result := 'sha512';
  else
    Result := '';
  end;
end;

constructor TACBrEAD.Create(AOwner : TComponent) ;
begin
   inherited Create(AOwner) ;

   fsIsXMLeECFc := False ;
   fsBufferSize := CBufferSize ;
   fsVersao := '';
   fsVersaoEhAntiga := False;
   fsOnGetChavePrivada := Nil;
   fsOnGetChavePublica := Nil;
   fsOnProgress        := Nil ;

   InitOpenSSL;
end ;

destructor TACBrEAD.Destroy ;
begin
  LiberarChave;

  inherited Destroy ;
end ;

procedure TACBrEAD.LerChavesArquivoPFX(const AArquivoPFX, Senha: String;
  var AChavePublica: AnsiString; var AChavePrivada: AnsiString);
Var
   FS : TFileStream ;
begin
  VerificaNomeArquivo( AArquivoPFX );

  FS := TFileStream.Create(AArquivoPFX, fmOpenRead or fmShareDenyWrite);
  try
    LerChavesPFX( FS, Senha, AChavePublica, AChavePrivada );
  finally
    FS.Free ;
  end ;
end;

procedure TACBrEAD.LerChavesPFX(const ADadosPFX: AnsiString; const Senha: String;
  var AChavePublica: AnsiString; var AChavePrivada: AnsiString);
Var
   MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(ADadosPFX)^, Length(ADadosPFX) );
    LerChavesPFX( MS, Senha, AChavePublica, AChavePrivada );
  finally
    MS.Free ;
  end ;
end;

procedure TACBrEAD.LerChavesPFX(const AStreamPFX: TStream; const Senha: String;
  var AChavePublica: AnsiString; var AChavePrivada: AnsiString);
var
  ca, p12: Pointer;
  Cert: pX509;
  b, BioKey: PBIO;
  PFXData: AnsiString;
  PFXLen: Integer;
  RsaKey: pRSA;
begin
  InitOpenSSL;

  AChavePublica := '';
  AChavePrivada := '';
  AStreamPFX.Position := 0;
  PFXLen := AStreamPFX.Size;
  Setlength(PFXData, PFXLen);
  PFXLen := AStreamPFX.Read(PAnsiChar(PFXData)^, PFXLen);
  SetLength(PFXData, PFXLen);

  LiberarChave;

  b := CriarMemBIO;
  try
    BioWrite(b, PFXData, Length(PFXData));
    p12 := d2iPKCS12bio(b, nil);
    if not Assigned(p12) then
      raise EACBrEADException.Create( 'Erro ao ler PFX');

    try
      ca := nil;
      if PKCS12parse(p12, Senha, fsKey, Cert, ca) > 0 then
      begin
        RsaKey := EvpPkeyGet1RSA(fsKey);

        // Lendo Conteudo da Chave
        BioKey := CriarMemBIO;
        try
          PEM_write_bio_RSAPrivateKey(BioKey, RsaKey, nil, nil, 0, nil, nil);
          AChavePrivada := AnsiString(BioToStr( BioKey ));

          BIOReset( BioKey );
          PEM_write_bio_PUBKEY( BioKey, fsKey);
          AChavePublica := AnsiString(BioToStr( BioKey ));
        finally
          LiberarBIO( BioKey );
        end ;
      end
      else
        raise EACBrEADException.Create( 'Erro ao interpretar PFX');
    finally
      PKCS12free(p12);
    end;
  finally
    LiberarBIO(b);
  end;
end;

function TACBrEAD.GetOpenSSL_Version: String;
begin
  OpenSSL_OldVersion;
  Result := OpenSSLExt.OpenSSLVersion(0);
end;

function TACBrEAD.OpenSSL_OldVersion: Boolean;
var
  VersaoStr: String;
  VersaoNum: Integer;
  P1, P2: Integer;
begin
  if (fsVersao = '') then
  begin
    VersaoNum := OpenSSLExt.OpenSSLVersionNum;
    if (VersaoNum > 0) then
    begin
      VersaoStr := IntToHex(VersaoNum, 9);
      fsVersao := copy(VersaoStr,1,2)+'.'+copy(VersaoStr,3,2)+'.'+copy(VersaoStr,5,2)+'.'+copy(VersaoStr,7,10);
    end
    else
    begin
      VersaoStr := OpenSSLExt.OpenSSLVersion(0);

      P1 := pos(' ', VersaoStr);
      if P1 > 0 then
      begin
        P2 := PosEx(' ', VersaoStr, P1+1 );
        if P2 = 0 then
          P2 := Length(VersaoStr);

        fsVersao := Trim(copy(VersaoStr, P1, P2-P1));
      end;
    end;

    fsVersaoEhAntiga := (CompareVersions(fsVersao, '1.1.0') < 0);
  end;

  Result := fsVersaoEhAntiga;
end;

function TACBrEAD.BioToStr(ABio : pBIO) : String ;
Var
  Ret : Integer ;
  Lin : AnsiString ;
begin
  Result := '';

  repeat
    SetLength(Lin,1024);
    Ret := BioRead( ABio, Lin, 1024);
    if Ret > 0 then
    begin
      Lin := copy(Lin,1,Ret) ;
      Result := Result + Lin;
    end ;
  until (Ret <= 0);
end ;

procedure TACBrEAD.GerarChaves(var AChavePublica : AnsiString ;
  var AChavePrivada : AnsiString) ;

  {$WARN SYMBOL_PLATFORM OFF}
  function FindFileSeed : String ;
  var
    TmpFile : TSearchRec ;
    TmpDir : String ;
  begin
    Result := '';
    TmpDir := GetEnvironmentVariable('TEMP');
    if FindFirst(TmpDir + '\*', faReadOnly and faHidden and faSysFile and faArchive, TmpFile) = 0 then
       Result := TmpFile.Name
    else
       if FindFirst(ApplicationPath + '*', faReadOnly and faHidden and faSysFile and faArchive, TmpFile) = 0 then
          Result := TmpFile.Name ;

    FindClose(TmpFile);
  end ;
  {$WARN SYMBOL_PLATFORM ON}

Var
  FileSeed : String ;
  BioKey : pBIO;
  RSAKey : pRSA ;
begin
  InitOpenSSL;

  AChavePublica := '';
  AChavePrivada := '';

  // Load a pseudo random file
  FileSeed := FindFileSeed;
  RAND_load_file(PAnsiChar(AnsiString(FileSeed)), -1);

  // Gera a Chave RSA
  LiberarChave;
  RSAKey := RsaGenerateKey( 1024, RSA_F4, nil, nil);
  if RSAKey = nil then
     raise EACBrEADException.Create( 'Erro ao gerar par de Chaves RSA');

  // Lendo Conteudo da Chave
  BioKey := CriarMemBIO;
  try
     PEM_write_bio_RSAPrivateKey(BioKey, RSAKey, nil, nil, 0, nil, nil);
     AChavePrivada := AnsiString(BioToStr( BioKey ));

     LerChave( AChavePrivada, True );

     BIOReset( BioKey );
     PEM_write_bio_PUBKEY( BioKey, fsKey);
     AChavePublica := AnsiString(BioToStr( BioKey ));
  finally
     LiberarBIO( BioKey );
  end ;
end ;

function TACBrEAD.GetChavePrivada : AnsiString ;
begin
  Result := '';
  if Assigned( fsOnGetChavePrivada ) then
     fsOnGetChavePrivada( Result ) ;

  if Result = '' then
     Result := cRFDRSAKey;
     //raise EACBrEADException.Create( ACBrStr('Chave RSA Privada n�o especificada no evento: "OnGetChavePrivada"') ) ;
end ;

procedure TACBrEAD.LerChavePrivada ;
var
  Chave : AnsiString ;
begin
  Chave := GetChavePrivada;

  if pos('<modulo>', String( Chave ) ) > 0 then
     LerChave_eECFc( Chave )
  else
     LerChave(Chave, True) ;
end ;

function TACBrEAD.GetChavePublica : AnsiString ;
begin
  Result := '';
  if Assigned( fsOnGetChavePublica ) then
    fsOnGetChavePublica( Result ) ;

  if Result = '' then
    raise EACBrEADException.Create( ACBrStr('Chave RSA Publica n�o especificada no evento: "OnGetChavePublica"') ) ;
end ;

procedure TACBrEAD.LerChavePublica ;
var
  Chave : AnsiString ;
begin
  Chave := GetChavePublica;

  if pos('<modulo>', String( Chave ) ) > 0 then
     LerChave_eECFc( Chave )
  else
     LerChave( Chave, False ) ;
end ;

function TACBrEAD.ConverteXMLeECFcParaOpenSSL(const ArquivoXML: String): AnsiString;
Var
  SL : TStringList ;
  Bio : PBIO ;
begin
  Result := '';

  if not FileExists( ArquivoXML ) then
    raise EACBrEADException.Create( ACBrStr(AnsiString('Arquivo: ' + ArquivoXML + ' n�o encontrado!')) );

  SL := TStringList.Create;
  try
    SL.LoadFromFile( ArquivoXML );
    LerChave_eECFc( AnsiString( SL.Text ) )
  finally
    SL.Free ;
  end ;

  Bio := CriarMemBIO;
  try
    if PEM_write_bio_PUBKEY(Bio, fsKey) = 1 then
      Result := AnsiString( BioToStr( Bio ) );
  finally
    LiberarBIO( Bio ) ;
  end ;
end ;

procedure TACBrEAD.LerChave_eECFc(const ConteudoXML : AnsiString ) ;
Var
  Modulo, Expoente : AnsiString ;
begin
  Modulo   := LerTagXML( ConteudoXML, 'modulo' );
  Expoente := LerTagXML( ConteudoXML, 'expoente_publico' );
  fsIsXMLeECFc := True;

  LerChaveModuloExpoente( Modulo, Expoente );
end ;

procedure TACBrEAD.LerChaveModuloExpoente(Modulo, Expoente: AnsiString);
var
  bnMod, bnExp : PBIGNUM;
  RSAKey : pRSA ;
  Erro   : longint ;
begin
  Modulo := AnsiString(Trim(String(Modulo)));
  if Modulo = '' then
     raise EACBrEADException.Create( ACBrStr('Erro: Modulo n�o informada') ) ;

  Expoente := AnsiString(Trim(String(Expoente)));
  if Expoente = '' then
     raise EACBrEADException.Create( ACBrStr('Erro: Expoente n�o informado') ) ;

  InitOpenSSL ;

  LiberarChave ;

  bnExp := BN_new();
  Erro := BN_hex2bn( bnExp, PAnsiChar(Expoente) );
  if Erro < 1 then
     raise EACBrEADException.Create( ACBrStr('Erro: Expoente inv�lido') ) ;

  bnMod := BN_new();
  Erro := BN_hex2bn( bnMod, PAnsiChar(Modulo) );
  if Erro < 1 then
     raise EACBrEADException.Create( ACBrStr('Erro: Modulo inv�lido') ) ;

  fsKey := EvpPkeyNew;
  RSAKey := RSA_new;
  RSAKey^.e := bnMod;
  RSAKey^.d := bnExp;

  Erro := EvpPkeyAssign( fsKey, EVP_PKEY_RSA, RSAKey );
  if Erro < 1 then
     raise EACBrEADException.Create('Erro ao atribuir Chave lida');
end ;

procedure TACBrEAD.LerChave(const Chave : AnsiString; Privada: Boolean) ;
var
   A : pEVP_PKEY ;
   BioKey : pBIO ;
   Buffer : AnsiString;
begin
  InitOpenSSL ;
  fsIsXMLeECFc := False;

  Buffer := AnsiString(Trim(String(Chave)));
  if (sLineBreak <> #10) then
     Buffer := AnsiString(StringReplace(String(Buffer), sLineBreak, #10, [rfReplaceAll] ) ) ;

  LiberarChave ;

  BioKey := BIO_new_mem_buf( PAnsiChar(Buffer), Length(Buffer) + 1 ) ;
  try
     A := nil ;
     if Privada then
        fsKey := PEM_read_bio_PrivateKey( BioKey, nil, nil, nil)
     else
        fsKey := PEM_read_bio_PUBKEY( BioKey, A, nil, nil) ;
  finally
     LiberarBIO( BioKey );
  end ;

  if fsKey = nil then
     raise EACBrEADException.Create('Erro ao ler a Chave');
end ;

procedure TACBrEAD.LiberarChave ;
begin
  if fsKey <> Nil then
  begin
     EVP_PKEY_free( fsKey );
     fsKey := nil;
  end ;
end ;

function TACBrEAD.CriarMemBIO : pBIO ;
begin
  Result := BioNew(BioSMem());
end ;

procedure TACBrEAD.LiberarBIO( Bio : pBIO);
begin
  BioFreeAll( Bio );
end ;

function TACBrEAD.GerarXMLeECFc(const NomeSwHouse, Diretorio: String): Boolean;
begin
  WriteToTXT(
    PathWithDelim(Diretorio) + NomeSwHouse + '.xml',
    GerarXMLeECFc(NomeSwHouse),
    False
  );
  Result := True;
end;

function TACBrEAD.GerarXMLeECFc(const NomeSwHouse: String): AnsiString;
Var
  Modulo, Expoente : AnsiString ;
  SL : TStringList ;
begin
  Modulo   := '';
  Expoente := '';
  CalcularModuloeExpoente( Modulo, Expoente );

  SL := TStringList.Create;
  try
    SL.Add( '<?xml version="1.0"?>' ) ;
    SL.Add( '' );
    SL.Add( '<empresa_desenvolvedora>' ) ;
    SL.Add( '  <nome>'+NomeSwHouse+'</nome>' ) ;
    SL.Add( '  <chave>' ) ;
    SL.Add( '    <modulo>'+String(Modulo)+'</modulo>' ) ;
    SL.Add( '    <expoente_publico>'+String(Expoente)+'</expoente_publico>' ) ;
    SL.Add( '  </chave>' );
    SL.Add( '</empresa_desenvolvedora>' ) ;

    Result := AnsiString(SL.Text);
  finally
    SL.Free;
  end ;
end ;

procedure TACBrEAD.CalcularModuloeExpoente(var Modulo, Expoente: AnsiString);
Var
  Bio: pBIO;
  RsaKey: pRSA;
begin
  LerChavePublica;

  Modulo   := '';
  Expoente := '';
  Bio := CriarMemBIO;
  RsaKey := EvpPkeyGet1RSA(fsKey);
  try
    if (RsaKey <> Nil) then
    begin
      BN_print( Bio, RsaKey^.e);
      Modulo := AnsiString(BioToStr( Bio ));

      BIOReset( Bio );
      BN_print( Bio, RsaKey^.d);
      Expoente := AnsiString(BioToStr( Bio ));
    end
    else
      raise EACBrEADException.Create( 'Erro ao ler chave Publica RSA' );
  finally
    if (RsaKey <> Nil) then
      RSA_free(RsaKey);

    LiberarBIO( Bio ) ;
    LiberarChave;
  end ;
end ;

function TACBrEAD.CalcularChavePublica : AnsiString ;
Var
  Bio : pBIO;
begin
  LerChavePrivada();

  Result := '';
  Bio    := CriarMemBIO;
  try
    if PEM_write_bio_PUBKEY( Bio, fsKey) = 1 then
       Result := AnsiString(BioToStr( Bio ));
  finally
    LiberarBIO( Bio );
    LiberarChave;
  end ;
end ;

function TACBrEAD.CalcularHashArquivo(const NomeArquivo : String;
   const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput ) : AnsiString ;
Var
   FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenRead or fmShareDenyWrite);
  try
    Result := CalcularHash( FS, Digest, OutputType );
  finally
    FS.Free ;
  end ;
end ;

function TACBrEAD.CalcularHash(const AString : AnsiString;
   const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput ) : AnsiString ;
Var
   MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(AString)^, Length(AString) );
    Result := CalcularHash( MS, Digest, OutputType );
  finally
    MS.Free ;
  end ;
end ;

function TACBrEAD.CalcularHash(const AStringList : TStringList;
   const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput ) : AnsiString ;
Var
  MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    AStringList.SaveToStream( MS );
    Result := CalcularHash( MS, Digest, OutputType );
  finally
    MS.Free ;
  end ;
end ;

function TACBrEAD.CalcularHash(const AStream: TStream;
  const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput): AnsiString;
begin
  Result := InternalDigest( AStream, Digest, OutputType, False);
end ;

function TACBrEAD.CalcularAssinaturaArquivo(const NomeArquivo: String;
  const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput): AnsiString;
Var
   FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenRead or fmShareDenyWrite);
  try
    Result := CalcularAssinatura( FS, Digest, OutputType );
  finally
    FS.Free ;
  end ;
end;

function TACBrEAD.CalcularAssinatura(const AString: AnsiString;
  const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput): AnsiString;
Var
   MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(AString)^, Length(AString) );
    Result := CalcularAssinatura( MS, Digest, OutputType );
  finally
    MS.Free ;
  end ;
end;

function TACBrEAD.CalcularAssinatura(const AStringList: TStringList;
  const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput): AnsiString;
Var
  MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    AStringList.SaveToStream( MS );
    Result := CalcularAssinatura( MS, Digest, OutputType );
  finally
    MS.Free ;
  end ;
end;

function TACBrEAD.CalcularAssinatura(const AStream: TStream;
  const Digest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput): AnsiString;
begin
  Result := InternalDigest(AStream, Digest, OutputType, True);
end;

function TACBrEAD.VerificarAssinatura(const AString, Assinatura: AnsiString;
  const Digest: TACBrEADDgst): Boolean;
Var
  MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(AString)^, Length(AString) );
    Result := VerificarAssinatura( MS, Assinatura, Digest);
  finally
    MS.Free ;
  end ;
end;

function TACBrEAD.VerificarAssinatura(const AStringList: TStringList;
  const Assinatura: AnsiString; const Digest: TACBrEADDgst): Boolean;
Var
  MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    AStringList.SaveToStream( MS );
    Result := VerificarAssinatura( MS, Assinatura, Digest);
  finally
    MS.Free ;
  end ;
end;

function TACBrEAD.VerificarAssinatura(const AStream: TStream;
  const Assinatura: AnsiString; const Digest: TACBrEADDgst): Boolean;
begin
  Result := InternalVerify(AStream, Assinatura, Digest);
end;

function TACBrEAD.CalcularEADArquivo(const NomeArquivo : String) : AnsiString ;
Var
   FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenRead or fmShareDenyWrite);
  try
    FS.Position := 0;
    Result := CalcularEAD( FS );
  finally
    FS.Free ;
  end ;
end ;

function TACBrEAD.CalcularEAD(const AString : AnsiString) : AnsiString ;
Var
   MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(AString)^, Length(AString) );
    Result := CalcularEAD( MS );
  finally
    MS.Free ;
  end ;
end ;

function TACBrEAD.CalcularEAD(const AStringList : TStringList) : AnsiString ;
Var
   MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    AStringList.SaveToStream( MS );
    Result := CalcularEAD( MS );
  finally
    MS.Free ;
  end ;
end ;

function TACBrEAD.CalcularEAD(const AStream: TStream): AnsiString;
begin
  Result := InternalDigest( AStream, dgstMD5, outHexa, True );
end ;

procedure TACBrEAD.VerificaNomeArquivo( const NomeArquivo : String ) ;
begin
  if ( Trim(NomeArquivo) = '' ) then
     raise EACBrEADException.Create( ACBrStr('Nome do arquivo n�o informado!') );

  if not FileExists( NomeArquivo ) then
     raise EACBrEADException.Create( ACBrStr(AnsiString('Arquivo: ' + NomeArquivo + ' n�o encontrado!')) );
end ;

function TACBrEAD.InternalDigest(const AStream: TStream;
  const ADigest: TACBrEADDgst; const OutputType: TACBrEADDgstOutput;
  const Assinar: Boolean): AnsiString;
Var
  md : PEVP_MD ;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  md_value_bin : array [0..1023] of AnsiChar;
  NameDgst : AnsiString;
  ABinStr, Base64Str: AnsiString;
  Memory: Pointer;
  PosStream: Int64;
  BytesRead: LongInt;
begin
  InitOpenSSL ;
  NameDgst := GetDigestName(ADigest);

  if Assinar then
    LerChavePrivada;

  pmd_ctx := nil;
  PosStream := 0;
  AStream.Position := 0;
  GetMem(Memory, BufferSize);
  try
    md_len := 0;
    md := EVP_get_digestbyname( PAnsiChar(NameDgst) );

    if OpenSSL_OldVersion then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();

    EVP_DigestInit( pmd_ctx, md );

    if Assigned( fsOnProgress ) then
      fsOnProgress( PosStream, AStream.Size );

    while (PosStream < AStream.Size) do
    begin
      BytesRead := AStream.Read(Memory^,BufferSize);
      if BytesRead <= 0 then
        Break;

      EVP_DigestUpdate( pmd_ctx, Memory, BytesRead );
      PosStream := PosStream + BytesRead;

      if Assigned( fsOnProgress ) then
        fsOnProgress( PosStream, AStream.Size );
    end;

    if Assinar then
      EVP_SignFinal( pmd_ctx, @md_value_bin, md_len, fsKey)
    else
      EVP_DigestFinal( pmd_ctx, @md_value_bin, @md_len);

    case OutputType of
      outBase64:
        begin
          SetString( ABinStr, md_value_bin, md_len);
          Base64Str := EncodeBase64( ABinStr );
          Result := Trim(Base64Str);
        end;

      outHexa:
        begin
          SetString( ABinStr, md_value_bin, md_len);
          Result := AsciiToHex(ABinStr);
        end;

      outBinary:
        begin
          SetString( ABinStr, md_value_bin, md_len);
          Result := ABinStr;
        end;
    end;
  finally
    if (not OpenSSL_OldVersion) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free( pmd_ctx );

    Freemem(Memory);
    LiberarChave;
  end;
end;

function TACBrEAD.InternalVerify(const AStream: TStream;
  const BinarySignature: AnsiString; const ADigest: TACBrEADDgst): Boolean;
Var
  md: PEVP_MD ;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  Ret, BytesReaded : LongInt ;
  Memory: Pointer;
  PosStream: Int64;
  NameDgst: AnsiString;
begin
  InitOpenSSL;
  NameDgst := GetDigestName(ADigest);
  LerChavePublica;

  pmd_ctx := Nil;
  PosStream := 0;
  AStream.Position := 0;
  GetMem(Memory, BufferSize);
  md_len := Length(BinarySignature);
  try
    md := EVP_get_digestbyname( PAnsiChar(NameDgst) );
    if md = Nil then
      raise EACBrEADException.Create('Erro ao carregar Digest: '+NameDgst);

    if OpenSSL_OldVersion then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();

    EVP_DigestInit( pmd_ctx, md );

    if Assigned( fsOnProgress ) then
      fsOnProgress( PosStream, AStream.Size );

    while (PosStream < AStream.Size) do
    begin
      BytesReaded := AStream.Read(Memory^,BufferSize);
      if BytesReaded <= 0 then
        Break;

      EVP_DigestUpdate( pmd_ctx, Memory, BytesReaded ) ;
      PosStream := PosStream + BytesReaded;

      if Assigned( fsOnProgress ) then
        fsOnProgress( PosStream, AStream.Size );
    end;

    Ret := EVP_VerifyFinal( pmd_ctx, @BinarySignature[1], md_len, fsKey) ;

    Result := (Ret = 1);
  finally
    if (not OpenSSL_OldVersion) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free( pmd_ctx );

    Freemem(Memory);
    LiberarChave;
  end ;
end;


function TACBrEAD.AssinarArquivoComEAD(const NomeArquivo : String ;
  RemoveEADSeExistir : Boolean) : AnsiString ;
Var
  FS : TFileStream ;
  LB : AnsiString ;
  Buffer: AnsiChar;
  Ret: Integer;
begin
  // Abrindo o arquivo com FileStream //
  FS := TFileStream.Create(NomeArquivo, fmOpenReadWrite or fmShareDenyWrite);
  try
     if RemoveEADSeExistir then
        RemoveEAD( FS );

     // Verificando se j� existe LF no final do arquivo //
     Buffer := #0;
     FS.Seek(-1, soEnd);  // vai para EOF - 1
     FS.Read(Buffer, 1);
     if Buffer <> LF then
     begin
        LB := sLineBreak;
        Ret := FS.Write(Pointer(LB)^,Length(LB));
        if Ret <= 0 then
          raise EACBrEADException.Create('Erro ao gravar LineBreak');
     end ;

     Result := 'EAD'+CalcularEAD( FS );

     if Result <> '' then
     begin
       FS.Seek(0,soEnd);
       FS.Write(Pointer(Result)^,Length(Result));
     end ;
  finally
     FS.Free ;
  end;
end;

function TACBrEAD.RemoveEADArquivo(const NomeArquivo: String): AnsiString;
Var
  FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenReadWrite or fmShareDenyWrite);
  try
    Result := RemoveEAD( FS ) ;
  finally
    FS.Free;
  end;
end ;

function TACBrEAD.RemoveEAD(AStream: TStream): AnsiString;
begin
  Result := LeEAD( AStream );

  // Removendo o EAD do MemoryStream //
  if Length(Result) > 0 then
     AStream.Size := AStream.Size - Length(Result) ;
end ;

function TACBrEAD.LeEADArquivo(const NomeArquivo: String): AnsiString;
Var
  FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenRead or fmShareDenyWrite);
  try
    Result := LeEAD( FS ) ;
  finally
    FS.Free;
  end;
end;

function TACBrEAD.LeEAD(AStream: TStream): AnsiString;
Var
  Buffer: array[0..259] of AnsiChar;
begin
  Result := '';

  // Verificando se tem CRLF no final da linha do EAD //
  Buffer := #0;
  AStream.Seek(-1, soEnd);  // vai para EOF - 1
  AStream.Read(Buffer, 1);
  while (Buffer[0] in [CR, LF]) do
  begin
     Result := Buffer[0] + Result;

     Buffer := #0;
     AStream.Seek(-2, soCurrent);  // Volta 2 bytes
     AStream.Read(Buffer, 1);
  end ;

  // Procurando por ultimo EAD //
  Buffer[0] := #0;
  AStream.Seek(-259,soCurrent);     // 259 = Tamanho da Linha EAD
  AStream.Read(Buffer, 259 );
  Result := UpperCase( Trim( String( Buffer ) ) ) + Result;

  // Achou o EAD no MemoryStream //
  if copy(Result,1,3) <> 'EAD' then
     Result := '';
end;

function TACBrEAD.VerificarEADArquivo(const NomeArquivo : String) : Boolean ;
Var
  FS : TFileStream ;
begin
  VerificaNomeArquivo( NomeArquivo );

  FS := TFileStream.Create(NomeArquivo, fmOpenRead or fmShareDenyWrite);
  try
    Result := VerificarEAD( FS );
  finally
    FS.Free ;
  end ;
end ;

function TACBrEAD.VerificarEAD(const AString : AnsiString) : Boolean ;
Var
  MS : TMemoryStream ;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write( Pointer(AString)^, Length(AString) );
    Result := VerificarEAD( MS );
  finally
    MS.Free;
  end;
end ;

function TACBrEAD.VerificarEAD(const AStringList : TStringList) : Boolean ;
Var
  MS : TMemoryStream ;
  EAD : String ;
  SLBottom : Integer ;
begin
  if AStringList.Count < 1 then
     raise EACBrEADException.Create( ACBrStr('Conteudo Informado � vazio' ) );

  SLBottom := AStringList.Count-1;                 // Pega a �ltima linha do arquivo,
  EAD := AStringList[ SLBottom ]  ;                // pois ela contem o EAD, e depois,
  AStringList.Delete( SLBottom );                  // remove a linha do EAD

  MS := TMemoryStream.Create;
  try
    AStringList.SaveToStream( MS );
    Result := VerificarEAD( MS, EAD );
  finally
    MS.Free ;
  end ;
end ;

function TACBrEAD.VerificarEAD(const AStream: TStream; EAD: String): Boolean;
Var
  md : PEVP_MD ;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  EAD_crypt, EAD_decrypt : array [0..127] of AnsiChar;
  md5_bin : array [0..15] of AnsiChar;
  Ret, BytesToRead, BytesReaded : LongInt ;
  Memory: Pointer;
  StreamSize, PosStream, BytesToEnd: Int64;
  EADAnsi : AnsiString;
  RsaKey: pRSA;
  ABinStr: AnsiString;
begin
  EAD := Trim(EAD);

  StreamSize := AStream.Size ;

  // N�o enviou EAD ?, ent�o ache e Remova a linha do EAD no MemoryStream
  if EAD = '' then
  begin
     EADAnsi := LeEAD( AStream );
     StreamSize := StreamSize - Length(EADAnsi);
     EAD := Trim(String(EADAnsi))  // Remove CR,LF, se houver..
  end;

  // Remove "EAD" do inicio da linha
  if UpperCase(String(copy(EAD,1,3))) = 'EAD' then
     EAD := copy(EAD,4,Length(EAD));

  if EAD = '' then
     raise EACBrEADException.Create( ACBrStr('Registro EAD n�o informado ou n�o existe no final do Arquivo') );

  // Convertendo o EAD para bin�rio //
  md_len := trunc(Length(EAD) / 2);
  if md_len <> 128 then
     raise EACBrEADException.Create('EAD deve conter 256 caracteres');

  //HexToBin( PAnsiChar(AnsiString(EAD)), EAD_crypt, md_len );
  ABinStr := HexToAscii(EAD);
  Move(ABinStr[1], EAD_crypt[0], md_len);

  LerChavePublica;
  PosStream := 0;
  AStream.Position := 0;
  GetMem(Memory, BufferSize);
  RsaKey := Nil;
  pmd_ctx := Nil;
  try
    // Fazendo verifica��o tradicional de SignDigest
    md := EVP_get_digestbyname('md5');
    if OpenSSL_OldVersion then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();

     EVP_DigestInit( pmd_ctx, md );

    if Assigned( fsOnProgress ) then
       fsOnProgress( PosStream, StreamSize );

    while (PosStream < StreamSize) do
    begin
       BytesToEnd := (StreamSize - PosStream);

       if BytesToEnd <= 0 then
          Break;

       if BytesToEnd > BufferSize then
          BytesToRead := BufferSize
       else
          BytesToRead := BytesToEnd;

       BytesReaded := AStream.Read(Memory^,BytesToRead);
       if BytesReaded <= 0 then
          Break;

       EVP_DigestUpdate( pmd_ctx, Memory, BytesReaded ) ;
       PosStream := PosStream + BytesReaded;

       if Assigned( fsOnProgress ) then
          fsOnProgress( PosStream, StreamSize );
    end;

    Ret := EVP_VerifyFinal( pmd_ctx, @EAD_crypt, md_len, fsKey);
    Result := (Ret = 1);

    // Se falhou, faz verifica��o manual do EAD
    if (not Result) then
    begin
       // Calculando o MD5 do arquivo sem a linha do EAD salva em "md5_bin" //
       EVP_DigestFinal( pmd_ctx, @md5_bin, @md_len);
       if md_len <> 16 then
          raise EACBrEADException.Create('Erro ao calcular MD5 do arquivo sem EAD');

       // Descriptografando o EAD //
       RsaKey := EvpPkeyGet1RSA(fsKey);
       md_len := RSA_public_decrypt( 128, @EAD_crypt, @EAD_decrypt,
                                     RsaKey, RSA_NO_PADDING);
       if md_len <> 128 then
          raise EACBrEADException.Create('Erro ao descriptografar EAD');

       Result := (Pos( md5_bin, EAD_decrypt ) > 0) ;
    end ;

    if (not Result)  then
    begin
       { Se o aqruivo foi assinado pelos fabricantes como: Bematech, Itautec,
         etc, ent�o o MD5 � criptografado antes de rodar a criptografia do RSA
         (sic)... nesse caso n�o temos como conferir o MD5 a n�o ser usando a
         DLL do eECFc (que ser� desenvolvida) }
       raise EACBrEADException.Create( ACBrStr(
        'N�o foi poss�vel verificar a assinatura do arquivo:' + sLineBreak +
        sLineBreak +
        'Verifique se a chave informada � mesmo a chave correta antes de continuar.' + sLineBreak +
        sLineBreak +
        'Verifique tamb�m se o arquivo foi assinado com a DLL de algum fabricante de ' +
        'impressoras fiscais, os fabricantes de impressoras fiscais criptografam o MD5 ' +
        'do arquivo antes de efetuar a criptografia para a assinatura EAD o que torna ' +
        'poss�vel a verifica��o da assinatura somente utilizando o aplicativo eECFc, ' +
        'somente este aplicativo possui as rotinas de descriptografia para cada fabricante.'
       ));
    end ;

  finally
    if (RsaKey <> Nil) then
      RSA_free(RsaKey);

    if (not OpenSSL_OldVersion) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free( pmd_ctx );

    Freemem(Memory);
    LiberarChave;
  end ;
end ;

initialization
  OpenSSLLoaded := False;

finalization
  FreeOpenSSL;

end.

