{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }

{ Direitos Autorais Reservados (c) 2022 Daniel Simoes de Almeida               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }

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

{ Daniel Sim�es de Almeida - daniel@projetoacbr.com.br - www.projetoacbr.com.br}
{       Rua Coronel Aureliano de Camargo, 963 - Tatu� - SP - 18270-170         }
{******************************************************************************}

{$I ACBr.inc}

unit ACBrOpenSSLUtils;

interface

uses
  Classes, SysUtils, StrUtils,
  OpenSSLExt,
  ACBrConsts, ACBrBase;

resourcestring
  sErrDigstNotFound = 'Algorithm %s not found in OpenSSL';
  sErrFileNotInformed = 'FileName is empty';
  sErrFileNotExists = 'File: %s does not exists';
  sErrLoadingRSAKey = 'Error loading RSA Key';
  sErrSettingRSAKey = 'Error setting RSA Key';
  sErrGeneratingRSAKey = 'Error generating RSA Key';
  sErrKeyNotLoaded = '%s Key not loaded';
  sErrLoadingKey = 'Error loading %s Key';
  sErrLoadingCertificate = 'Error loading %s Certificate';
  sErrCertificateNotLoaded = 'Certificate not loaded';
  sErrParamIsEmpty = 'Param %s is Empty';
  sErrParamIsInvalid = 'Param %s has invalid value';
  sErrInvalidOpenSSHKey = 'OpenSSH Key is Invalid';

const
  CBufferSize = 32768;
  COpenSSHPrefix = 'ssh-rsa';
  CPrivate = 'Private';
  CPublic = 'Public';
  CPFX = 'PFX';
  CPEM = 'PEM';

type
  TACBrOpenSSLAlgorithm = ( algMD2, algMD4, algMD5, algRMD160, algSHA, algSHA1,
                       algSHA256, algSHA512);
  TACBrOpenSSLStrType = (sttHexa, sttBase64, sttBinary);
  TACBrOpenSSLKeyBits = (bit512, bit1024, bit2048);
  TACBrOpenSSLCredential = (crePubKey, crePrivKey, crePFX, creCertX09);

  TACBrOpenSSLOnProgress = procedure(const PosByte, TotalSize: int64) of object;
  TACBrOpenSSLOnNeedCredentials = procedure(const CredentialNeeded: TACBrOpenSSLCredential) of object;

  EACBrOpenSSLException = class(Exception);

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  { TACBrOpenSSLUtils }

  TACBrOpenSSLUtils = class(TACBrComponent)
  private
    fVersion: String;
    fOldLib: Boolean;
    fBufferSize: Integer;
    fOnProgress: TACBrOpenSSLOnProgress;
    fOnNeedCredentials: TACBrOpenSSLOnNeedCredentials;

    fEVP_PrivateKey: pEVP_PKEY;
    fEVP_PublicKey: pEVP_PKEY;
    fCertX509: pX509;

    function GetVersion: String;
    procedure SetBufferSize(AValue: Integer);

  private
    fPassword: AnsiString;
    procedure FreeKeys;
    Procedure FreePrivateKey;
    Procedure FreePublicKey;
    procedure FreeCert;
    function GetPrivateKeyAsString: AnsiString;
    function GetPublicKeyAsString: AnsiString;
    function GetPublicKeyAsOpenSSH: AnsiString;
    function GetCertificateAsString: AnsiString;

    function IsOldLib: Boolean;
    procedure CheckFileExists(const AFile: String);
    procedure CheckPublicKeyIsLoaded;
    procedure CheckPrivateKeyIsLoaded;
    procedure CheckCertificateIsLoaded;

    function GetEVPAlgorithmByName(Algorithm: TACBrOpenSSLAlgorithm): PEVP_MD;
    procedure LoadPublicKeyFromCertificate(AX509: pX509);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CalcHashFromStream(AStream: TStream; Algorithm: TACBrOpenSSLAlgorithm;
      OutputType: TACBrOpenSSLStrType = sttHexa; Sign: Boolean = False): AnsiString;
    function CalcHashFromString(const AStr: AnsiString; Algorithm: TACBrOpenSSLAlgorithm;
      OutputType: TACBrOpenSSLStrType = sttHexa; Sign: Boolean = False): AnsiString;
    function CalcHashFromFile(const AFile: String; Algorithm: TACBrOpenSSLAlgorithm;
      OutputType: TACBrOpenSSLStrType = sttHexa; Sign: Boolean = False): AnsiString;

    function MD5FromFile(const AFile: String): String;
    function MD5FromString(const AString: AnsiString): String;

    function VerifyHashFromStream(AStream: TStream; Algorithm: TACBrOpenSSLAlgorithm;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = sttHexa;
      Signed: Boolean = False): Boolean;
    function VerifyHashFromString(const AStr: AnsiString; Algorithm: TACBrOpenSSLAlgorithm;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = sttHexa;
      Signed: Boolean = False): Boolean;
    function VerifyHashFromFile(const AFile: String; Algorithm: TACBrOpenSSLAlgorithm;
      const AHash: AnsiString; HashType: TACBrOpenSSLStrType = sttHexa;
      Signed: Boolean = False): Boolean;

    function CryptFromStream(AStream: TStream; Algorithm: TACBrOpenSSLAlgorithm;
      OutputType: TACBrOpenSSLStrType = sttHexa): AnsiString;

  public
    property Version: String read GetVersion;

    procedure LoadPFXFromFile(const APFXFile: String; const Password: AnsiString = '');
    procedure LoadPFXFromStr(const APFXData: AnsiString; const Password: AnsiString = '');
    procedure LoadCertificateFromFile(const ACertificateFile: String; const Password: AnsiString = '');
    procedure LoadCertificateFromString(const ACertificate: AnsiString; const Password: AnsiString = '');

    procedure LoadPrivateKeyFromFile(const APrivateKeyFile: String; const Password: AnsiString = '');
    procedure LoadPrivateKeyFromString(const APrivateKey: AnsiString; const Password: AnsiString = '');
    procedure LoadPublicKeyFromFile(const APublicKeyFile: String);
    procedure LoadPublicKeyFromString(const APublicKey: AnsiString);
    procedure LoadPublicKeyFromModulusAndExponent(const Modulus, Exponent: String);
    function ExtractModulusAndExponentFromPublicKey(out Modulus: String; out Exponent: String): Boolean;
    function GeneratePublicKeyFromPrivateKey: String;

    function CreateCertificateSignRequest(const CN_CommonName: String;
      O_OrganizationName: String = ''; OU_OrganizationalUnitName: String = '';
      L_Locality: String = ''; ST_StateOrProvinceName: String = '';
      C_CountryName: String = ''; EMAIL_EmailAddress: String = '';
      Algorithm: TACBrOpenSSLAlgorithm = algSHA512): String;

    property PrivateKeyAsString: AnsiString read GetPrivateKeyAsString;
    property PublicKeyAsString: AnsiString read GetPublicKeyAsString;
    property PublicKeyAsOpenSSH: AnsiString read GetPublicKeyAsOpenSSH;
    property CertificateAsString: AnsiString read GetCertificateAsString;
  published
    property BufferSize: Integer read fBufferSize write SetBufferSize default CBufferSize;
    property OnProgress: TACBrOpenSSLOnProgress read fOnProgress write fOnProgress;
    property OnNeedCredentials: TACBrOpenSSLOnNeedCredentials read fOnNeedCredentials
      write fOnNeedCredentials;
    //property Password: AnsiString read fPassword write fPassword;
  end;

procedure InitOpenSSL;
procedure FreeOpenSSL;

// Genreral auxiliary functions
function OpenSSLFullVersion: String;
function BioToStr(ABio: pBIO): AnsiString;

// Key functions
function ExtractModulusAndExponentFromKey(AKey: PEVP_PKEY;
  out Modulus: String; out Exponent: String): Boolean;
procedure SetModulusAndExponentToKey(AKey: PEVP_PKEY;
  const Modulus: String; const Exponent: String);

function ConvertPEMToOpenSSH(APubKey: PEVP_PKEY): String;
function ConvertOpenSSHToPEM(const AOpenSSHKey: String): String;

function PublicKeyToString(APubKey: PEVP_PKEY): String;
function PrivateKeyToString(APrivKey: PEVP_PKEY; const Password: AnsiString = ''): String;
function CertificateToString(ACertX509: pX509): String;

procedure GenerateKeyPair(out APrivateKey: String; out APublicKey: String;
  const Password: AnsiString = ''; KeyBits: TACBrOpenSSLKeyBits = bit1024);

// Internal auxiliary functions
function GetLastOpenSSLError: String;
function PasswordCallback(buf:PAnsiChar; size:Integer; rwflag:Integer; userdata: Pointer):Integer; cdecl;
function OpenSSLAlgorithmToStr(Algorithm: TACBrOpenSSLAlgorithm): String;
function ConvertToStrType(ABinaryStr: AnsiString;
  OutputType: TACBrOpenSSLStrType = sttHexa): AnsiString;
function ConvertFromStrType(ABinaryStr: AnsiString;
  InputType: TACBrOpenSSLStrType = sttHexa): AnsiString;

var
  OpenSSLLoaded: Boolean;

implementation

uses
  Math, TypInfo,
  synacode, synautil,
  ACBrUtil;

procedure InitOpenSSL;
begin
  if OpenSSLLoaded then
    exit;

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

// Genreral auxiliary functions

function OpenSSLFullVersion: String;
var
  n: LongInt;
  s: String;
  ps, pe: Integer;
begin
  InitOpenSSL;
  Result := '';
  n := OpenSSLExt.OpenSSLVersionNum;
  if (n > 0) then
  begin
    s := IntToHex(n, 9);
    Result := copy(s, 1, 2) + '.' + copy(s, 3, 2) + '.' + copy(s, 5, 2) + '.' + copy(s, 7, 10);
  end
  else
  begin
    s := String(OpenSSLExt.OpenSSLVersion(0));
    ps := pos(' ', s);
    if (ps > 0) then
    begin
      pe := PosEx(' ', s, ps + 1);
      if (pe = 0) then
        pe := Length(s);
      Result := Trim(copy(s, ps, pe - ps));
    end;
  end;
end;

function BioToStr(ABio: pBIO): AnsiString;
Var
  n: Integer ;
  s: AnsiString ;
begin
  Result := '';
  SetLength(s, 1024);
  repeat
    n := BioRead(ABio, s, 1024);
    if (n > 0) then
      Result := Result + copy(s,1,n);
  until (n <= 0);
end;

// Key functions

function ExtractModulusAndExponentFromKey(AKey: PEVP_PKEY; out Modulus: String;
  out Exponent: String): Boolean;
Var
  bio: pBIO;
  RsaKey: pRSA;
begin
  InitOpenSSL;
  Modulus := '';
  Exponent := '';
  Result := False;
  bio := BioNew(BioSMem);
  RsaKey := EvpPkeyGet1RSA(AKey);
  try
    if (RsaKey = Nil) then
      raise EACBrOpenSSLException.Create(sErrLoadingRSAKey + sLineBreak + GetLastOpenSSLError);
    BN_print(bio, RsaKey^.e);
    Modulus := String(BioToStr(bio));
    BIOReset(bio);
    BN_print(bio, RsaKey^.d);
    Exponent := String(BioToStr(bio));
    Result := True;
  finally
    if (RsaKey <> Nil) then
      RSA_free(RsaKey);
    BioFreeAll(bio);
  end ;
end;

procedure SetModulusAndExponentToKey(AKey: PEVP_PKEY; const Modulus: String;
  const Exponent: String);
var
  e, m: AnsiString;
  bnMod, bnExp: PBIGNUM;
  rsa: pRSA ;
  err: longint ;
begin
  InitOpenSSL;
  m := Trim(Modulus);
  e := Trim(Exponent);

  if (m = '') then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsEmpty, ['Modulus']) ;
  if (e = '') then
    raise EACBrOpenSSLException.CreateFmt(sErrParamIsEmpty, ['Exponent']) ;

  bnExp := BN_new();
  err := BN_hex2bn(bnExp, PAnsiChar(e));
  if (err < 1) then
    raise EACBrOpenSSLException.Create( Format(sErrParamIsInvalid, ['Exponent']) +
                                        sLineBreak + GetLastOpenSSLError);
  bnMod := BN_new();
  err := BN_hex2bn( bnMod, PAnsiChar(m) );
  if err < 1 then
    raise EACBrOpenSSLException.Create( Format(sErrParamIsInvalid, ['Modulus']) +
                                        sLineBreak + GetLastOpenSSLError);

  if (AKey <> Nil) then
    rsa := EvpPkeyGet1RSA(AKey)
  else
  begin
    AKey := EvpPkeyNew;
    rsa := Nil;
  end;
  if (rsa = Nil) then
    rsa := RSA_new;
  if (rsa = nil) then
    raise EACBrOpenSSLException.Create(sErrGeneratingRSAKey + sLineBreak + GetLastOpenSSLError);
  rsa^.e := bnMod;
  rsa^.d := bnExp;
  err := EvpPkeyAssign(AKey, EVP_PKEY_RSA, rsa);
  if (err < 1) then
    raise EACBrOpenSSLException.Create(sErrSettingRSAKey + sLineBreak + GetLastOpenSSLError);
end;

// https://www.netmeister.org/blog/ssh2pkcs8.html
function ConvertPEMToOpenSSH(APubKey: PEVP_PKEY): String;
  function EncodeHexaSSH(const HexaStr: String): AnsiString;
  var
    l: Integer;
    s: String;
  begin
    l := Length(HexaStr);
    if odd(l) then
    begin
      s := '0'+HexaStr;
      Inc(l);
    end
    else
      s := HexaStr;

    Result := IntToBEStr(Trunc(l/2), 4) + HexToAsciiDef(s, ' ');
  end;
Var
  s, m, e: String;
begin
  ExtractModulusAndExponentFromKey(APubKey, m, e);

  s := EncodeHexaSSH(AsciiToHex(COpenSSHPrefix)) +
       EncodeHexaSSH(e) +
       EncodeHexaSSH('00' + m);

  Result := COpenSSHPrefix+' '+EncodeBase64(s);
end;

function ConvertOpenSSHToPEM(const AOpenSSHKey: String): String;
  function ReadChunk(s: AnsiString; var p: Integer): AnsiString;
  var
    l: Integer;
  begin
    l := BEStrToInt(copy(s,P,4));
    Result := Copy(s, P+4, l);
    p := p+4+l;
  end;
var
  s, m, e: AnsiString;
  ps, pe: Integer;
  bio: PBIO;
  key: PEVP_PKEY;
begin
  ps := pos(' ', AOpenSSHKey);
  pe := PosEx(' ', AOpenSSHKey, ps+1);
  if (pe = 0) then
    pe := Length(AOpenSSHKey)+1;

  s := DecodeBase64( copy(AOpenSSHKey, ps+1, pe-ps-1) );
  ps := 1;
  if (ReadChunk(s, ps) <> COpenSSHPrefix) then
    raise EACBrOpenSSLException.Create(sErrInvalidOpenSSHKey);
  e := AsciiToHex(ReadChunk(s, ps));
  m := AsciiToHex(ReadChunk(s, ps));

  key := EvpPkeynew;
  try
    SetModulusAndExponentToKey(key, m, e);
    Result := PublicKeyToString(key);
  finally
    EVP_PKEY_free(key);
  end;
end;

function PublicKeyToString(APubKey: PEVP_PKEY): String;
var
  bio: PBIO;
begin
  Result := '';
  bio := BioNew(BioSMem);
  try
    if (PEM_write_bio_PUBKEY(bio, APubKey) = 1) then
      Result := String(BioToStr(bio))
    else
      raise EACBrOpenSSLException.Create(GetLastOpenSSLError);
  finally
    BioFreeAll(bio);
  end ;
end;

function PrivateKeyToString(APrivKey: PEVP_PKEY; const Password: AnsiString): String;
var
  bio: PBIO;
  rsa: pRSA;
  ret: Integer;
begin
  Result := '';
  bio := BioNew(BioSMem);
  try
    rsa := EvpPkeyGet1RSA(APrivKey);
    if (Password <> '') then
      ret := PEM_write_bio_RSAPrivateKey( bio, rsa,
                                          EVP_aes_256_cbc,
                                          PAnsiChar(Password), Length(Password),
                                          Nil, Nil)
    else
      ret := PEM_write_bio_RSAPrivateKey( bio, rsa, Nil, Nil, 0, Nil, Nil);

    if (ret = 1) then
      Result := String(BioToStr(bio))
    else
      raise EACBrOpenSSLException.Create(GetLastOpenSSLError);
  finally
    if (rsa <> Nil) then
      RSA_free(rsa);
    BioFreeAll(bio);
  end ;
end;

function CertificateToString(ACertX509: pX509): String;
var
  bio: PBIO;
begin
  Result := '';
  bio := BioNew(BioSMem);
  try
    if (PEM_write_bio_X509(bio, ACertX509) = 1) then
      Result := String(BioToStr(bio))
    else
      raise EACBrOpenSSLException.Create(GetLastOpenSSLError);
  finally
    BioFreeAll(bio);
  end ;
end;

procedure GenerateKeyPair(out APrivateKey: String; out APublicKey: String;
  const Password: AnsiString; KeyBits: TACBrOpenSSLKeyBits);
Var
  rsa: pRSA ;
  bits: LongInt;
  key: PEVP_PKEY;
begin
  InitOpenSSL;
  // Creating RSA Keys
  case KeyBits of
    bit512: bits := 512;
    bit2048: bits := 2048;
  else
    bits := 1024;
  end;
  rsa := RsaGenerateKey(bits, RSA_F4, nil, nil);
  if (rsa = nil) then
    raise EACBrOpenSSLException.Create(sErrGeneratingRSAKey + sLineBreak + GetLastOpenSSLError);

  key := EvpPkeynew;
  try
    EvpPkeyAssign(key, EVP_PKEY_RSA, rsa);
    APrivateKey := PrivateKeyToString(key, Password);
    APublicKey := PublicKeyToString(key);
  finally
    EVP_PKEY_free(key);
  end;
end;

// Internal auxiliary functions

function GetLastOpenSSLError: String;
var
  e: LongInt;
  s: AnsiString;
begin
  e := ErrGetError;
  SetLength(s,1024);
  ErrErrorString(e, s, 1024);
  Result := Format('Error: %d - %s', [e,s]);
end;

function PasswordCallback(buf:PAnsiChar; size:Integer; rwflag:Integer; userdata: Pointer):Integer; cdecl;
var
  Password: AnsiString;
begin
  Password := PAnsiChar(userdata);
  if Length(Password) > (Size - 1) then
    SetLength(Password, Size - 1);
  Result := Length(Password);
  Password := Password+#0;
  Move(Password[1], buf^, Result+1);
  //synafpc.StrLCopy(buf, PAnsiChar(Password+#0), Result+1);
end;

function OpenSSLAlgorithmToStr(Algorithm: TACBrOpenSSLAlgorithm): String;
begin
  case Algorithm of
    algMD2: Result := 'md2';
    algMD4: Result := 'md4';
    algMD5: Result := 'md5';
    algRMD160: Result := 'rmd160';
    algSHA: Result := 'sha';
    algSHA1: Result := 'sha1';
    algSHA256: Result := 'sha256';
    algSHA512: Result := 'sha512';
    else
      Result := '';
  end;
end;

function ConvertToStrType(ABinaryStr: AnsiString;
  OutputType: TACBrOpenSSLStrType): AnsiString;
begin
  case OutputType of
    sttBase64: Result := Trim(EncodeBase64(ABinaryStr));
    sttHexa: Result := AsciiToHex(ABinaryStr);
  else
    Result := ABinaryStr;
  end;
end;

function ConvertFromStrType(ABinaryStr: AnsiString;
  InputType: TACBrOpenSSLStrType): AnsiString;
begin
  case InputType of
    sttBase64: Result := DecodeBase64(ABinaryStr);
    sttHexa: Result := HexToAscii(ABinaryStr);
  else
    Result := ABinaryStr;
  end;
end;

{ TACBrOpenSSLUtils }

constructor TACBrOpenSSLUtils.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fVersion := '';
  fOldLib := False;
  fBufferSize := CBufferSize;

  fOnProgress := Nil;
  fOnNeedCredentials := Nil;
  fEVP_PrivateKey := Nil;
  fEVP_PublicKey := Nil;
  fCertX509 := Nil;
end;

destructor TACBrOpenSSLUtils.Destroy;
begin
  FreeCert;
  FreeKeys;
  inherited Destroy;
end;

function TACBrOpenSSLUtils.CalcHashFromStream(AStream: TStream; Algorithm: TACBrOpenSSLAlgorithm;
  OutputType: TACBrOpenSSLStrType; Sign: Boolean): AnsiString;
var
  s: AnsiString;
  md: PEVP_MD;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  md_value_bin: array [0..1023] of AnsiChar;
  buffer: Pointer;
  p: int64;
  b: longint;
begin
  InitOpenSSL;
  if Sign then
    CheckPrivateKeyIsLoaded;

  pmd_ctx := nil;
  GetMem(buffer, fBufferSize);
  try
    md := GetEVPAlgorithmByName(Algorithm);
    if IsOldLib then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();
    EVP_DigestInit(pmd_ctx, md);

    p := 0;
    AStream.Position := 0;
    if Assigned(fOnProgress) then
      fOnProgress(p, AStream.Size);
    while (p < AStream.Size) do
    begin
      b := AStream.Read(buffer^, BufferSize);
      if (b <= 0) then
        Break;
      EVP_DigestUpdate(pmd_ctx, buffer, b);
      Inc(p, b);
      if Assigned(fOnProgress) then
        fOnProgress(p, AStream.Size);
    end;

    md_len := 0;
    if Sign then
      EVP_SignFinal(pmd_ctx, @md_value_bin, md_len, fEVP_PrivateKey)
    else
      EVP_DigestFinal(pmd_ctx, @md_value_bin, @md_len);

    s := '';
    SetString(s, md_value_bin, md_len);
    Result := ConvertToStrType(s, OutputType);
  finally
    if (not IsOldLib) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free(pmd_ctx);

    Freemem(buffer);
  end;
end;

function TACBrOpenSSLUtils.CalcHashFromString(const AStr: AnsiString;
  Algorithm: TACBrOpenSSLAlgorithm; OutputType: TACBrOpenSSLStrType; Sign: Boolean
  ): AnsiString;
Var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(Pointer(AStr)^, Length(AStr));
    Result := CalcHashFromStream(ms, Algorithm, OutputType, Sign);
  finally
    ms.Free ;
  end ;
end;

function TACBrOpenSSLUtils.CalcHashFromFile(const AFile: String;
  Algorithm: TACBrOpenSSLAlgorithm; OutputType: TACBrOpenSSLStrType; Sign: Boolean
  ): AnsiString;
Var
  fs: TFileStream ;
begin
  CheckFileExists(AFile);
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := CalcHashFromStream(fs, Algorithm, OutputType, Sign);
  finally
    fs.Free ;
  end ;
end;

function TACBrOpenSSLUtils.MD5FromFile(const AFile: String): String;
begin
  Result := String(CalcHashFromFile(AFile, algMD5));
end;

function TACBrOpenSSLUtils.MD5FromString(const AString: AnsiString): String;
begin
  Result := String(CalcHashFromString(AString, algMD5));
end;

function TACBrOpenSSLUtils.VerifyHashFromStream(AStream: TStream; Algorithm: TACBrOpenSSLAlgorithm;
  const AHash: AnsiString; HashType: TACBrOpenSSLStrType; Signed: Boolean
  ): Boolean;
Var
  s, h: AnsiString;
  md : PEVP_MD ;
  md_len: cardinal;
  md_ctx: EVP_MD_CTX;
  pmd_ctx: PEVP_MD_CTX;
  md_value_bin : array [0..1023] of AnsiChar;
  buffer: Pointer;
  p: Int64;
  b: LongInt;
begin
  InitOpenSSL;
  if Signed then
    CheckPublicKeyIsLoaded;

  pmd_ctx := Nil;
  GetMem(buffer, CBufferSize);
  try
    md := GetEVPAlgorithmByName(Algorithm);
    if IsOldLib then
      pmd_ctx := @md_ctx
    else
      pmd_ctx := EVP_MD_CTX_new();
    EVP_DigestInit(pmd_ctx, md);

    p := 0;
    AStream.Position := 0;
    if Assigned(fOnProgress) then
      fOnProgress(p, AStream.Size);
    while (p < AStream.Size) do
    begin
      b := AStream.Read(buffer^, CBufferSize);
      if (b <= 0) then
        Break;
      EVP_DigestUpdate(pmd_ctx, buffer, b);
      Inc(p, b);
      if Assigned(fOnProgress) then
        fOnProgress(p, AStream.Size);
    end;

    h := ConvertFromStrType(AHash, HashType);
    if Signed then
      Result := (EVP_VerifyFinal(pmd_ctx, PAnsiChar(h), Length(h), fEVP_PublicKey) = 1)
    else
    begin
      md_len := 0;
      EVP_DigestFinal(pmd_ctx, @md_value_bin, @md_len);
      SetString(s, md_value_bin, md_len);
      Result := (Pos(s, h) > 0);
    end;
  finally
    if (not IsOldLib) and (pmd_ctx <> nil) then
      EVP_MD_CTX_free(pmd_ctx);

    Freemem(buffer);
  end;
end;

function TACBrOpenSSLUtils.VerifyHashFromString(const AStr: AnsiString;
  Algorithm: TACBrOpenSSLAlgorithm; const AHash: AnsiString;
  HashType: TACBrOpenSSLStrType; Signed: Boolean): Boolean;
Var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    ms.Write(Pointer(AStr)^, Length(AStr));
    Result := VerifyHashFromStream(ms, Algorithm, AHash, HashType, Signed);
  finally
    ms.Free ;
  end ;
end;

function TACBrOpenSSLUtils.VerifyHashFromFile(const AFile: String;
  Algorithm: TACBrOpenSSLAlgorithm; const AHash: AnsiString;
  HashType: TACBrOpenSSLStrType; Signed: Boolean): Boolean;
Var
  fs: TFileStream ;
begin
  CheckFileExists(AFile);
  fs := TFileStream.Create(AFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := VerifyHashFromStream(fs, Algorithm, AHash, HashType, Signed);
  finally
    fs.Free ;
  end ;
end;

function TACBrOpenSSLUtils.CryptFromStream(AStream: TStream;
  Algorithm: TACBrOpenSSLAlgorithm; OutputType: TACBrOpenSSLStrType): AnsiString;
begin

end;

procedure TACBrOpenSSLUtils.LoadPFXFromFile(const APFXFile: String;
  const Password: AnsiString);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APFXFile);
  fs := TFileStream.Create(APFXFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPFXFromStr(s, Password);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSLUtils.LoadPFXFromStr(const APFXData: AnsiString;
  const Password: AnsiString);
var
  ca, p12: Pointer;
  bio: PBIO;
begin
  FreeKeys;
  FreeCert;
  bio := BioNew(BioSMem);
  try
    BioWrite(bio, APFXData, Length(APFXData));
    p12 := d2iPKCS12bio(bio, nil);
    if not Assigned(p12) then
      raise EACBrOpenSSLException.CreateFmt(sErrLoadingCertificate, [CPFX]);

    try
      ca := nil;
      if (PKCS12parse(p12, Password, fEVP_PrivateKey, fCertX509, ca) <= 0) then
        raise EACBrOpenSSLException.Create( Format(sErrLoadingCertificate, [CPFX]) +
                                            sLineBreak + GetLastOpenSSLError);
    finally
      PKCS12free(p12);
    end;
  finally
    BioFreeAll(bio);
  end;
  LoadPublicKeyFromCertificate(fCertX509);
end;

procedure TACBrOpenSSLUtils.LoadCertificateFromFile(
  const ACertificateFile: String; const Password: AnsiString);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(ACertificateFile);
  fs := TFileStream.Create(ACertificateFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadCertificateFromString(s, Password);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSLUtils.LoadCertificateFromString(
  const ACertificate: AnsiString; const Password: AnsiString);
var
  bio: pBIO;
  buf: AnsiString;
begin
  InitOpenSSL ;
  FreeCert;

  buf := AnsiString(ChangeLineBreak(Trim(ACertificate), LF));  // Use Linux LineBreak
  bio := BIO_new_mem_buf(PAnsiChar(buf), Length(buf)+1) ;
  try
    fCertX509 := PEM_read_bio_X509(bio, nil, @PasswordCallback, PAnsiChar(Password));
  finally
    BioFreeAll(bio);
  end ;

  if (fCertX509 = nil) then
    raise EACBrOpenSSLException.Create( Format(sErrLoadingCertificate, [CPEM]) +
                                        sLineBreak + GetLastOpenSSLError);
  LoadPublicKeyFromCertificate(fCertX509);
end;

procedure TACBrOpenSSLUtils.LoadPrivateKeyFromFile(const APrivateKeyFile: String;
  const Password: AnsiString);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APrivateKeyFile);
  fs := TFileStream.Create(APrivateKeyFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPrivateKeyFromString(s, Password);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSLUtils.LoadPrivateKeyFromString(const APrivateKey: AnsiString;
  const Password: AnsiString);
var
  bio: pBIO;
  buf: AnsiString;
begin
  InitOpenSSL ;
  FreePrivateKey;

  buf := AnsiString(ChangeLineBreak(Trim(APrivateKey), LF));  // Use Linux LineBreak
  bio := BIO_new_mem_buf(PAnsiChar(buf), Length(buf)+1) ;
  try
    fEVP_PrivateKey := PEM_read_bio_PrivateKey(bio, nil, @PasswordCallback, PAnsiChar(Password));
  finally
    BioFreeAll(bio);
  end ;

  if (fEVP_PrivateKey = nil) then
    raise EACBrOpenSSLException.Create( Format(sErrLoadingKey, [CPrivate]) +
                                        sLineBreak + GetLastOpenSSLError)
end;

procedure TACBrOpenSSLUtils.LoadPublicKeyFromFile(const APublicKeyFile: String);
Var
  fs: TFileStream ;
  s: AnsiString;
begin
  CheckFileExists(APublicKeyFile);
  fs := TFileStream.Create(APublicKeyFile, fmOpenRead or fmShareDenyWrite);
  try
    fs.Position := 0;
    s := ReadStrFromStream(fs, fs.Size);
    LoadPublicKeyFromString(s);
  finally
    fs.Free ;
  end ;
end;

procedure TACBrOpenSSLUtils.LoadPublicKeyFromString(const APublicKey: AnsiString);
var
  bio: pBIO;
  buf: AnsiString;
  x: pEVP_PKEY;
begin
  InitOpenSSL ;
  FreePublicKey;

  buf := AnsiString(ChangeLineBreak(Trim(APublicKey), LF));  // Use Linux LineBreak
  bio := BIO_new_mem_buf(PAnsiChar(buf), Length(buf)+1) ;
  try
    x := Nil;
    fEVP_PublicKey := PEM_read_bio_PUBKEY(bio, x, nil, nil) ;
  finally
    BioFreeAll(bio);
  end ;

  if (fEVP_PublicKey = nil) then
    raise EACBrOpenSSLException.Create( Format(sErrLoadingKey, [CPublic]) +
                                        sLineBreak + GetLastOpenSSLError);
end;

procedure TACBrOpenSSLUtils.LoadPublicKeyFromModulusAndExponent(const Modulus,
  Exponent: String);
begin
  FreePublicKey;
  SetModulusAndExponentToKey(fEVP_PublicKey, Modulus, Exponent);
end;

function TACBrOpenSSLUtils.ExtractModulusAndExponentFromPublicKey(out
  Modulus: String; out Exponent: String): Boolean;
begin
  CheckPublicKeyIsLoaded;
  Result := ExtractModulusAndExponentFromKey(fEVP_PublicKey, Modulus, Exponent);
end;

function TACBrOpenSSLUtils.GeneratePublicKeyFromPrivateKey: String;
begin
  CheckPrivateKeyIsLoaded;
  Result := PublicKeyToString(fEVP_PrivateKey);;
end;

// https://en.wikipedia.org/wiki/Certificate_signing_request
// https://cpp.hotexamples.com/pt/examples/-/-/X509_REQ_new/cpp-x509_req_new-function-examples.html

function TACBrOpenSSLUtils.CreateCertificateSignRequest(
  const CN_CommonName: String; O_OrganizationName: String;
  OU_OrganizationalUnitName: String; L_Locality: String;
  ST_StateOrProvinceName: String; C_CountryName: String;
  EMAIL_EmailAddress: String; Algorithm: TACBrOpenSSLAlgorithm): String;
var
  x: PX509_REQ;
  name: PX509_NAME;
  bio: PBIO;
  md: PEVP_MD;
begin
  CheckPrivateKeyIsLoaded;
  CheckPublicKeyIsLoaded;

  Result := '';
  md := GetEVPAlgorithmByName(Algorithm);
  x := X509_REQ_new;
  try
    name := X509_NAME_new;
    try
      if (EMAIL_EmailAddress <> '') then
        X509NameAddEntryByTxt(name, 'EMAIL', MBSTRING_ASC, EMAIL_EmailAddress, -1, -1, 0);
      if (C_CountryName <> '') then
        X509NameAddEntryByTxt(name, 'C', MBSTRING_ASC, C_CountryName, -1, -1, 0);
      if (ST_StateOrProvinceName <> '') then
        X509NameAddEntryByTxt(name, 'ST', MBSTRING_ASC, ST_StateOrProvinceName, -1, -1, 0);
      if (L_Locality <> '') then
        X509NameAddEntryByTxt(name, 'L', MBSTRING_ASC, L_Locality, -1, -1, 0);
      if (OU_OrganizationalUnitName <> '') then
        X509NameAddEntryByTxt(name, 'OU', MBSTRING_ASC, OU_OrganizationalUnitName, -1, -1, 0);
      if (O_OrganizationName <> '') then
        X509NameAddEntryByTxt(name, 'O', MBSTRING_ASC, O_OrganizationName, -1, -1, 0);
      X509NameAddEntryByTxt(name, 'CN', MBSTRING_ASC, CN_CommonName, -1, -1, 0);

      if (X509_REQ_set_subject_name(x, name) <> 1) then
        raise EACBrOpenSSLException.Create('X509_REQ_set_subject_name' + sLineBreak + GetLastOpenSSLError);
    finally
      X509_NAME_free(name);
    end;

    if (X509_REQ_set_pubkey(x, fEVP_PublicKey) <> 1) then
      raise EACBrOpenSSLException.Create('X509_REQ_set_pubkey' + sLineBreak + GetLastOpenSSLError);
    if (X509_REQ_sign(x, fEVP_PrivateKey, md) = 0) then
      raise EACBrOpenSSLException.Create('X509_REQ_sign' + sLineBreak + GetLastOpenSSLError);

    bio := BioNew(BioSMem);
    try
      if (PEM_write_bio_X509_REQ(bio, x) <> 1) then
        raise EACBrOpenSSLException.Create('PEM_write_bio_X509_REQ' + sLineBreak + GetLastOpenSSLError);
      Result := BioToStr(bio);
    finally
      BioFreeAll(bio);
    end;
  finally
    X509_REQ_free(x);
  end;
end;

function TACBrOpenSSLUtils.GetEVPAlgorithmByName(Algorithm: TACBrOpenSSLAlgorithm): PEVP_MD;
var
  s: AnsiString;
begin
  s := OpenSSLAlgorithmToStr(Algorithm);
  Result := EVP_get_digestbyname(PAnsiChar(s));
  if (Result = nil) then
    raise EACBrOpenSSLException.CreateFmt(sErrDigstNotFound,
      [GetEnumName(TypeInfo(TACBrOpenSSLAlgorithm), Integer(Algorithm))]);
end;

procedure TACBrOpenSSLUtils.LoadPublicKeyFromCertificate(AX509: pX509);
var
  key: PEVP_PKEY;
begin
  if (AX509 = Nil) then
    Exit;

  key := X509GetPubkey(AX509);
  if (key <> Nil) then
  begin
    FreePublicKey;
    fEVP_PublicKey := key;
  end;
end;

function TACBrOpenSSLUtils.GetVersion: String;
begin
  InitOpenSSL;
  if (fVersion = '') then
  begin
    fVersion := OpenSSLFullVersion;
    fOldLib := (CompareVersions(fVersion, '1.1.0') < 0);
  end;
  Result := fVersion;
end;

function TACBrOpenSSLUtils.IsOldLib: Boolean;
begin
  GetVersion;
  Result := fOldLib;
end;

procedure TACBrOpenSSLUtils.CheckFileExists(const AFile: String);
var
  s: String;
begin
  s := Trim(AFile);
  if (s = '') then
    raise EACBrOpenSSLException.Create(sErrFileNotInformed);

  if not FileExists(s) then
    raise EACBrOpenSSLException.CreateFmt(sErrFileNotExists, [s]);
end;

procedure TACBrOpenSSLUtils.CheckPublicKeyIsLoaded;
begin
  if (not Assigned(fEVP_PublicKey)) and Assigned(fEVP_PrivateKey) then
    LoadPublicKeyFromString(PublicKeyToString(fEVP_PrivateKey));

  if not Assigned(fEVP_PublicKey) and Assigned(fOnNeedCredentials) then
    fOnNeedCredentials(crePubKey);

  if not Assigned(fEVP_PublicKey) then
    raise EACBrOpenSSLException.CreateFmt(sErrKeyNotLoaded, [CPublic]);
end;

procedure TACBrOpenSSLUtils.CheckPrivateKeyIsLoaded;
begin
  if not Assigned(fEVP_PrivateKey) and Assigned(fOnNeedCredentials) then
    fOnNeedCredentials(crePrivKey);

  if not Assigned(fEVP_PrivateKey) then
    raise EACBrOpenSSLException.CreateFmt(sErrKeyNotLoaded, [CPrivate]);
end;

procedure TACBrOpenSSLUtils.CheckCertificateIsLoaded;
begin
  if not Assigned(fCertX509) and Assigned(fOnNeedCredentials) then
    fOnNeedCredentials(creCertX09);

  if not Assigned(fCertX509) then
    raise EACBrOpenSSLException.Create(sErrCertificateNotLoaded);
end;

procedure TACBrOpenSSLUtils.SetBufferSize(AValue: Integer);
begin
  if fBufferSize = AValue then
    Exit;

  fBufferSize := max(1024, AValue);
end;

procedure TACBrOpenSSLUtils.FreeKeys;
begin
  FreePrivateKey;
  FreePublicKey;
end;

procedure TACBrOpenSSLUtils.FreePrivateKey;
begin
  if (fEVP_PrivateKey <> Nil) then
  begin
    EVP_PKEY_free(fEVP_PrivateKey);
    fEVP_PrivateKey := Nil;
  end ;
end;

procedure TACBrOpenSSLUtils.FreePublicKey;
begin
  if (fEVP_PublicKey <> Nil) then
  begin
    EVP_PKEY_free(fEVP_PublicKey);
    fEVP_PublicKey := Nil;
  end ;
end;

procedure TACBrOpenSSLUtils.FreeCert;
begin
  if (fCertX509 <> Nil) then
  begin
    X509free(fCertX509);
    fCertX509 := Nil;
  end;
end;

function TACBrOpenSSLUtils.GetCertificateAsString: AnsiString;
begin
  CheckCertificateIsLoaded;
  Result := CertificateToString(fCertX509);
end;

function TACBrOpenSSLUtils.GetPrivateKeyAsString: AnsiString;
begin
  CheckPrivateKeyIsLoaded;
  Result := PrivateKeyToString(fEVP_PrivateKey);
end;

function TACBrOpenSSLUtils.GetPublicKeyAsString: AnsiString;
begin
  CheckPublicKeyIsLoaded;
  Result := PublicKeyToString(fEVP_PublicKey);
end;

function TACBrOpenSSLUtils.GetPublicKeyAsOpenSSH: AnsiString;
begin
  CheckPublicKeyIsLoaded;
  Result := ConvertPEMToOpenSSH(fEVP_PublicKey);
end;

initialization
  OpenSSLLoaded := False;

finalization
  FreeOpenSSL;

end.

property KeyPassword: String read fKeyPassword write fKeyPassword;

property PFXFile: String read fPFXFile write fPFXFile;
property CertificateFile: String read fCertificateFile write fCertificateFile;
property PrivateKeyFile: String read fPrivateKeyFile write fPrivateKeyFile;
property PublicKeyFile: String read fPublicKeyFile write fPublicKeyFile;

property PFXStr: AnsiString read fPFXStr write fPFXStr;
property CertificateStr: AnsiString read fCertificateStr write fCertificateStr;
property PrivateKeyStr: AnsiString read fPrivateKeyStr write fPrivateKeyStr;
property PublicKeyStr: AnsiString read fPublicKeyStr write fPublicKeyStr;

fCertificateFile: String;
fCertificateStr: AnsiString;
fPFXFile: String;
fPFXStr: AnsiString;
fPrivateKeyFile: String;
fPrivateKeyStr: AnsiString;
fPublicKeyFile: String;
fPublicKeyStr: AnsiString;

fKeyPassword := '';
fCertificateFile := '';
fCertificateStr := '';
fPFXFile := '';
fPFXStr := '';
fPrivateKeyFile := '';
fPrivateKeyStr := '';
fPublicKeyFile := '';
fPublicKeyStr := '';

