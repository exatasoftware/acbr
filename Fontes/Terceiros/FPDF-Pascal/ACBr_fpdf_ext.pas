{

 FPDF Pascal Extensions
 https://github.com/Projeto-ACBr-Oficial/FPDF-Pascal

 Copyright (C) 2023 Projeto ACBr - Daniel Sim�es de Almeida

 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 Except as contained in this notice, the name of <Projeto ACBr> shall not be
 used in advertising or otherwise to promote the sale, use or other dealings in
 this Software without prior written authorization from <Projeto ACBr>.

 Based on:
 - The FPDF Scripts    - http://www.fpdf.org/en/script/index.php
   TFPDFScriptCodeEAN  - http://www.fpdf.org/en/script/script5.php  - Olivier
   TFPDFScriptCode39   - http://www.fpdf.org/en/script/script46.php - The-eh
   TFPDFScriptCodeI25  - http://www.fpdf.org/en/script/script67.php - Matthias Lau
   TFPDFScriptCode128  - http://www.fpdf.org/en/script/script88.php - Roland Gautier
   TFPDFExt.Rotate     - http://www.fpdf.org/en/script/script2.php  - Olivier
   TFPDFExt.RoundedRect- http://www.fpdf.org/en/script/script35.php - Christophe Prugnaud
   TFPDFExt.AddLayer   - http://www.fpdf.org/en/script/script97.php - Oliver

- Free JPDF Pascal from Jean Patrick e Gilson Nunes
   https://github.com/jepafi/Free-JPDF-Pascal
}

unit ACBr_fpdf_ext;

// Define USE_SYNAPSE if you want to force use of Unit synapse.pas
// http://www.ararat.cz/synapse
{$DEFINE USE_SYNAPSE}

// If you don't want the AnsiString vs String warnings to bother you
{$DEFINE REMOVE_CAST_WARN}

// If you have DelphiZXingQRCode Unit on you LibPath
// https://github.com/foxitsoftware/DelphiZXingQRCode
{$DEFINE DelphiZXingQRCode}

{$IfNDef FPC}
  {$IFDEF REMOVE_CAST_WARN}
   {$IF CompilerVersion >= 16}
    {$WARN IMPLICIT_STRING_CAST OFF}
    {$WARN IMPLICIT_STRING_CAST_LOSS OFF}
   {$IfEnd}
  {$EndIf}
{$EndIf}

{$IfDef FPC}
  {$Mode objfpc}{$H+}
  {$Define USE_UTF8}
  {$Define HAS_HTTP}
{$EndIf}

{$IfDef USE_SYNAPSE}
  {$Define HAS_HTTP}
{$EndIf}

{$IfDef POSIX}
  {$IfDef LINUX}
    {$Define USE_UTF8}
  {$EndIf}
  {$Define FMX}
{$EndIf}

{$IfDef NEXTGEN}
  {$ZEROBASEDSTRINGS OFF}
  {$Define USE_UTF8}
{$EndIf}

interface

uses
  Classes, SysUtils,
  ACBr_fpdf
  {$IfDef DelphiZXingQRCode}
   ,ACBrDelphiZXingQRCode
  {$EndIf}
  {$IFDEF HAS_HTTP}
   {$IFDEF USE_SYNAPSE}
    ,httpsend, ssl_openssl
   {$ELSE}
    ,fphttpclient, opensslsockets
   {$ENDIF}
  {$ENDIF};

{$IfDef NEXTGEN}
type
  AnsiString = RawByteString;
  AnsiChar = UTF8Char;
  PAnsiChar = MarshaledAString;
  PPAnsiChar = ^MarshaledAString;
  WideString = String;
{$EndIf}

const
  cDefBarHeight = 8;
  cDefBarWidth = 0.5; //0.35;

type

  TFPDFExt = class;

  { TFPDFScripts }

  TFPDFScripts = class
  protected
    fpFPDF: TFPDFExt;
  public
    constructor Create(AFPDF: TFPDFExt); virtual;
  end;


  { TFPDFScriptCodeEAN }
  { http://www.fpdf.org/en/script/script5.php - Olivier }

  TFPDFScriptCodeEAN = class(TFPDFScripts)
  private
    procedure CheckBarCode(var ABarCode: string; BarCodeLen: integer;
      const BarCodeName: string);
    function AdjustBarCodeSize(const ABarCode: string; BarCodeLen: integer): string;
    function CalcBinCode(const ABarCode: string): String;
    procedure DrawBarcode(const BinCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    function GetCheckDigit(const ABarCode: string; const BarCodeName: string): integer;
    function TestCheckDigit(const ABarCode: string; const BarCodeName: string): boolean;
  public
    procedure CodeEAN13(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    procedure CodeEAN8(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
  end;

  { TFPDFScriptCode39 }
  { http://www.fpdf.org/en/script/script46.php - The-eh }

  TFPDFScriptCode39 = class(TFPDFScripts)
  private
  public
    procedure Code39(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
  end;

  { TFPDFScriptCodeI25 }
  { http://www.fpdf.org/en/script/script67.php - Matthias Lau }

  TFPDFScriptCodeI25 = class(TFPDFScripts)
  private
  public
    procedure CodeI25(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
  end;

  { TFPDFScriptCode128 }
  { http://www.fpdf.org/en/script/script88.php - Roland Gautier }

  TCode128 = (code128A, code128B, code128C);
  TFPDFScriptCode128 = class(TFPDFScripts)
  private
    fABCSet: String;                                  // C128 eligible character set
    fASet: String;                                    // Set A eligible Character
    fBSet: String;                                    // Set B eligible Character
    fCSet: String;                                    // Set C eligible character
    fSetTo: array [TCode128] of string;
    fSetFrom: array [TCode128] of string;
  public
    constructor Create(AFPDF: TFPDFExt); override;
    procedure Code128(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
  end;

  TFPDFLayer =  record
    Name: String;
    Visible: Boolean;
    n: Integer;
  end;

  TByteArray = array of Byte;
  TFPDF2DMatrix = array of TByteArray;

  { TFPDFExt }

  TFPDFExt = class(TFPDF)
  private
    fProxyHost: string;
    fProxyPass: string;
    fProxyPort: string;
    fProxyUser: string;

    {$IfDef HAS_HTTP}
     procedure GetImageFromURL(const aURL: string; const aResponse: TStream);
    {$EndIf}
  protected
    angle: Double;
    layers: array of TFPDFLayer;
    current_layer: Integer;
    open_layer_pane: Boolean;

    procedure _endpage; override;
    procedure _putresourcedict; override;
    procedure _putresources; override;
    procedure _putlayers;
    procedure _putcatalog; override;
    procedure _enddoc; override;

    procedure _Arc(vX1, vY1, vX2, vY2, vX3, vY3: Double);
  public
    procedure InternalCreate; override;

    procedure Rotate(NewAngle: Double = 0; vX: Double = -1; vY: Double = -1);

    procedure RoundedRect(vX, vY, vWidth, vHeight: Double;
      vRadius: Double = 5; vCorners: String = '1234'; vStyle: String = '');

    function AddLayer(const LayerName: String; IsVisible: Boolean = true): Integer;
    procedure BeginLayer(LayerId: Integer); overload;
    procedure BeginLayer(const LayerName: String); overload;
    procedure EndLayer;
    procedure OpenLayerPane;

    {$IfDef HAS_HTTP}
    procedure Image(const vFileOrURL: string; vX: double = -9999;
      vY: double = -9999; vWidth: double = 0; vHeight: double = 0;
      const vLink: string = ''); overload; override;
    {$EndIf}

    procedure CodeEAN13(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    procedure CodeEAN8(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    procedure CodeI25(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    procedure Code39(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);
    procedure Code128(const ABarCode: string; vX: double; vY: double;
      BarHeight: double = 0; BarWidth: double = 0);

    {$IfDef DelphiZXingQRCode}
    procedure QRCode(vX: double; vY: double; const QRCodeData: String;
      DotSize: Double = 0; AEncoding: TQRCodeEncoding = qrAuto);
    {$EndIf}
    procedure Draw2DMatrix(AMatrix: TFPDF2DMatrix; vX: double; vY: double;
      DotSize: Double = 0);

    property ProxyHost: string read fProxyHost write fProxyHost;
    property ProxyPort: string read fProxyPort write fProxyPort;
    property ProxyUser: string read fProxyUser write fProxyUser;
    property ProxyPass: string read fProxyPass write fProxyPass;
  end;

implementation

uses
  Math, StrUtils;

{ TFPDFScripts }

constructor TFPDFScripts.Create(AFPDF: TFPDFExt);
begin
  inherited Create;
  fpFPDF := AFPDF;
end;

{ TFPDFScriptCodeEAN }

procedure TFPDFScriptCodeEAN.CodeEAN13(const ABarCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
var
  s, BinCode: string;
begin
  s := Trim(ABarCode);
  CheckBarCode(s, 13, 'EAN13');
  BinCode := CalcBinCode(s);
  DrawBarcode(BinCode, vx, vY, BarHeight, BarWidth);
end;

procedure TFPDFScriptCodeEAN.CodeEAN8(const ABarCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
var
  s, BinCode: string;
begin
  s := Trim(ABarCode);
  CheckBarCode(s, 8, 'EAN8');
  BinCode := CalcBinCode(s);
  DrawBarcode(BinCode, vx, vY, BarHeight, BarWidth);
end;

procedure TFPDFScriptCodeEAN.CheckBarCode(var ABarCode: string;
  BarCodeLen: integer; const BarCodeName: string);
var
  l: integer;
begin
  ABarCode := Trim(ABarCode);
  l := Length(ABarCode);

  if (l < BarCodeLen - 1) then
    ABarCode := AdjustBarCodeSize(ABarCode, BarCodeLen - 1);

  if (l = BarCodeLen - 1) then
    ABarCode := ABarCode + IntToStr(GetCheckDigit(ABarCode, BarCodeName))
  else if (l = BarCodeLen) then
  begin
    if not TestCheckDigit(ABarCode, BarCodeName) then
      fpFPDF.Error(Format('Invalid %s Check Digit: %s', [BarCodeName, ABarCode]));
  end
  else
    fpFPDF.Error(Format('Invalid %s Code Len: %s', [BarCodeName, ABarCode]));
end;

function TFPDFScriptCodeEAN.AdjustBarCodeSize(const ABarCode: string;
  BarCodeLen: integer): string;
begin
  Result := Trim(copy(ABarCode, 1, BarCodeLen));
  if (BarCodeLen > Length(ABarCode)) then
    Result := StringOfChar('0', BarCodeLen - Length(Result)) + Result;
end;

function TFPDFScriptCodeEAN.GetCheckDigit(const ABarCode: string;
  const BarCodeName: string): integer;
var
  t, l, i: integer;
  v: integer;
begin
  //Compute the check digit
  t := 0;
  l := Length(ABarCode);
  for i := l downto 1 do
  begin
    v := StrToIntDef(ABarCode[i], -1);
    if (v < 0) then
      fpFPDF.Error(Format('Invalid Digits in %s: %s', [BarCodeName, ABarCode]));
    t := t + (v * IfThen(odd(i), 1, 3));
  end;

  Result := (10 - (t mod 10)) mod 10;
end;

function TFPDFScriptCodeEAN.TestCheckDigit(const ABarCode: string;
  const BarCodeName: string): boolean;
var
  l: integer;
begin
  l := Length(ABarCode);
  Result := (l > 0) and (StrToIntDef(ABarCode[l], -1) = GetCheckDigit(copy(ABarCode, 1, l-1), BarCodeName));
end;

function TFPDFScriptCodeEAN.CalcBinCode(const ABarCode: string): String;
type
 TParity = array[0..5] of Byte;
 
const
  codes: array[0..2] of array[0..9] of string =
    (('0001101', '0011001', '0010011', '0111101', '0100011', '0110001',
      '0101111', '0111011', '0110111', '0001011'),
     ('0100111', '0110011', '0011011', '0100001', '0011101', '0111001',
      '0000101', '0010001', '0001001', '0010111'),
     ('1110010', '1100110', '1101100', '1000010', '1011100', '1001110',
      '1010000', '1000100', '1001000', '1110100'));
  parities: array[0..9] of TParity =
    ((0, 0, 0, 0, 0, 0),
     (0, 0, 1, 0, 1, 1),
     (0, 0, 1, 1, 0, 1),
     (0, 0, 1, 1, 1, 0),
     (0, 1, 0, 0, 1, 1),
     (0, 1, 1, 0, 0, 1),
     (0, 1, 1, 1, 0, 0),
     (0, 1, 0, 1, 0, 1),
     (0, 1, 0, 1, 1, 0),
     (0, 1, 1, 0, 1, 0));
var
  v, i, l, p, m: integer;
  pa: TParity;

begin
  l := Length(ABarCode);
  Result := '101';
  if odd(l) then
  begin
    p := 1;
    v := StrToInt(ABarCode[1]);
    pa := parities[v];
  end
  else
  begin
    p := 0;
    pa := parities[0];
  end;

  m := (l - p) div 2;
  for i := p+1 to m+p do
  begin
    v := StrToInt(ABarCode[i]);
    Result := Result + codes[pa[i-1-p], v];
  end;

  Result := Result + '01010';

  for i := m+1+p to l do
  begin
    v := StrToInt(ABarCode[i]);
    Result := Result + codes[2, v];
  end;

  Result := Result + '101';
end;

procedure TFPDFScriptCodeEAN.DrawBarcode(const BinCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
var
  l, i: Integer;
begin
  if (BarHeight = 0) then
    BarHeight := cDefBarHeight;

  if (BarWidth = 0) then
    BarWidth := cDefBarWidth;

  //Draw bars
  l := Length(BinCode);
  for i := 1 to l do
    if (BinCode[i] = '1') then
      fpFPDF.Rect(vX+i*BarWidth, vY, BarWidth, BarHeight, 'F');
end;

{ TFPDFScriptCode39 }

procedure TFPDFScriptCode39.Code39(const ABarCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
type
  TBarSeq = array[0..8] of Byte;
const
  Chars: String = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. *$/+%';
  Bars: array[0..43] of TBarSeq =
    ( (0,0,0,1,1,0,1,0,0), (1,0,0,1,0,0,0,0,1), (0,0,1,1,0,0,0,0,1), (1,0,1,1,0,0,0,0,0),
      (0,0,0,1,1,0,0,0,1), (1,0,0,1,1,0,0,0,0), (0,0,1,1,1,0,0,0,0), (0,0,0,1,0,0,1,0,1),
      (1,0,0,1,0,0,1,0,0), (0,0,1,1,0,0,1,0,0), (1,0,0,0,0,1,0,0,1), (0,0,1,0,0,1,0,0,1),
      (1,0,1,0,0,1,0,0,0), (0,0,0,0,1,1,0,0,1), (1,0,0,0,1,1,0,0,0), (0,0,1,0,1,1,0,0,0),
      (0,0,0,0,0,1,1,0,1), (1,0,0,0,0,1,1,0,0), (0,0,1,0,0,1,1,0,0), (0,0,0,0,1,1,1,0,0),
      (1,0,0,0,0,0,0,1,1), (0,0,1,0,0,0,0,1,1), (1,0,1,0,0,0,0,1,0), (0,0,0,0,1,0,0,1,1),
      (1,0,0,0,1,0,0,1,0), (0,0,1,0,1,0,0,1,0), (0,0,0,0,0,0,1,1,1), (1,0,0,0,0,0,1,1,0),
      (0,0,1,0,0,0,1,1,0), (0,0,0,0,1,0,1,1,0), (1,1,0,0,0,0,0,0,1), (0,1,1,0,0,0,0,0,1),
      (1,1,1,0,0,0,0,0,0), (0,1,0,0,1,0,0,0,1), (1,1,0,0,1,0,0,0,0), (0,1,1,0,1,0,0,0,0),
      (0,1,0,0,0,0,1,0,1), (1,1,0,0,0,0,1,0,0), (0,1,1,0,0,0,1,0,0), (0,1,0,0,1,0,1,0,0),
      (0,1,0,1,0,1,0,0,0), (0,1,0,1,0,0,0,1,0), (0,1,0,0,0,1,0,1,0), (0,0,0,1,0,1,0,1,0) );
var
  wide, narrow, gap, lineWidth: Double;
  s: String;
  l, i, j, p: Integer;
  c: Char;
  seq: TBarSeq;
begin
  if (BarHeight = 0) then
    BarHeight := cDefBarHeight;

  if (BarWidth = 0) then
    BarWidth := cDefBarWidth;

  s := UpperCase(ABarCode);
  l := Length(s);
  if (l = 0) then
    Exit;

  wide := BarWidth;
  narrow := wide / 3 ;
  gap := narrow;

  if (s[l] <> '*') then
    s := s+'*';
  if (s[1] <> '*') then
    s := '*'+s;

  l := Length(s);
  for i := 1 to l do
  begin
    c := s[i];
    p := pos(c, Chars);
    if (p = 0) then
      fpFPDF.Error('Code39, invalid Char: '+c);

    seq := Bars[p-1];
    for j := 0 to High(seq) do
    begin
      lineWidth := IfThen(seq[j] = 0, narrow, wide);
      if ((j mod 2) = 0) then
        fpFPDF.Rect(vX, vY, lineWidth, BarHeight, 'F');

      vX := vX + lineWidth;
    end;

    vX := vX + gap;
  end;
end;

{ TFPDFScriptCodeI25 }

procedure TFPDFScriptCodeI25.CodeI25(const ABarCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
const
  Chars: String = '0123456789AZ';
  Bars: array[1..12] of String =
    (  'nnwwn', 'wnnnw', 'nwnnw', 'wwnnn', 'nnwnw', 'wnwnn', 'nwwnn',
       'nnnww', 'wnnwn', 'nwnwn', 'nn', 'wn');
var
  wide, narrow, lineWidth: Double;
  s, seq: String;
  l, i, j, pcb, pcs: Integer;
  charBar, charSpace: Char;
begin
  s := LowerCase(trim(ABarCode));
  if (s = '') then
    Exit;

  if (BarHeight = 0) then
    BarHeight := cDefBarHeight;

  if (BarWidth = 0) then
    BarWidth := cDefBarWidth;

  wide := BarWidth;
  narrow := wide / 3;

  // add leading zero if code-length is odd
  l := Length(s);
  if ((l mod 2) <> 0) then
    s := '0' + s;

  // add start and stop codes
  s := 'AA' + s + 'ZA';
  l := Length(s);

  i := 1;
  while (i <= l) do
  begin
    // choose next pair of digits
    charBar := s[i];
    charSpace := s[i+1];

    // check whether it is a valid digit
    pcb := pos(charBar, Chars);
    if (pcb = 0) then
      fpFPDF.Error('CodeI25, Invalid character: '+charBar);

    pcs := pos(charSpace, Chars);
    if (pcs = 0) then
      fpFPDF.Error('CodeI25, Invalid character: '+charSpace);

    // create a wide/narrow-sequence (first digit=bars, second digit=spaces)
    seq := '';
    for j := 1 to Length(Bars[pcb]) do
      seq := seq + Bars[pcb][j] + Bars[pcs][j];

    for j := 1 to Length(seq) do
    begin
      // set lineWidth depending on value
      lineWidth := IfThen(seq[j] = 'n', narrow, wide);

      // draw every second value, because the second digit of the pair is represented by the spaces
      if (((j-1) mod 2) = 0) then
        fpFPDF.Rect(vX, vY, lineWidth, BarHeight, 'F');

      vX :=  vX + lineWidth;
    end;

    Inc(i, 2);
  end;
end;

{ TFPDFScriptCode128 }

constructor TFPDFScriptCode128.Create(AFPDF: TFPDFExt);
var
  i: Integer;
  set128: TCode128;
begin
  inherited Create(AFPDF);

  fABCSet := '';
  for i := 32 to 95 do                     // character sets
    fABCSet := fABCSet + chr(i);

  fASet := fABCSet;
  fBSet := fABCSet;

  for i := 0 to 31 do
  begin
    fABCSet := fABCSet + chr(i);
    fASet := fASet + chr(i);
  end;

  for i := 96 to 127 do
  begin
   fABCSet := fABCSet + chr(i);
   fBSet := fBSet + chr(i);
  end;

  for i := 200 to 210 do                   // control 128
  begin
    fABCSet := fABCSet + chr(i);
    fASet := fASet + chr(i);
    fBSet := fBSet + chr(i);
  end;

  fCSet := '0123456789'+chr(206);

  for set128 := Low(TCode128) to High(TCode128) do
  begin
    fSetFrom[set128] := '';
    fSetTo[set128] := '';
  end;

  for i := 0 to 95 do                      // converters for sets A & B
  begin
    fSetFrom[code128A] := fSetFrom[code128A] + chr(i);
    fSetFrom[code128B] := fSetFrom[code128B] + chr(i + 32);
    fSetTo[code128A] := fSetTo[code128A] + chr( IfThen(i < 32, i+64, i-32) );
    fSetTo[code128B] := fSetTo[code128B] + chr(i);
  end;

  for i := 96 to 106 do                    // control of sets A & B
  begin
    fSetFrom[code128A] := fSetFrom[code128A] + chr(i + 104);
    fSetFrom[code128B] := fSetFrom[code128B] + chr(i + 104);
    fSetTo[code128A] := fSetTo[code128A] + chr(i);
    fSetTo[code128B] := fSetTo[code128B] + chr(i);
  end;
end;

procedure TFPDFScriptCode128.Code128(const ABarCode: string; vX: double;
  vY: double; BarHeight: double; BarWidth: double);
type
  T128Parity = array [0..5] of Byte;
const
  C128Start: array[TCode128] of Byte = (103, 104, 105);  // Set selection characters at the start of C128
  C128Swap: array[TCode128] of Byte  = (101, 100, 99);   // Set change characters

  C128Table: array [0..107] of T128Parity =             // Code table 128
       (
         (2, 1, 2, 2, 2, 2),           //0 : [ ]
         (2, 2, 2, 1, 2, 2),           //1 : [!]
         (2, 2, 2, 2, 2, 1),           //2 : ["]
         (1, 2, 1, 2, 2, 3),           //3 : [#]
         (1, 2, 1, 3, 2, 2),           //4 : [$]
         (1, 3, 1, 2, 2, 2),           //5 : [%]
         (1, 2, 2, 2, 1, 3),           //6 : [&]
         (1, 2, 2, 3, 1, 2),           //7 : [']
         (1, 3, 2, 2, 1, 2),           //8 : [(]
         (2, 2, 1, 2, 1, 3),           //9 : [)]
         (2, 2, 1, 3, 1, 2),           //10 : [*]
         (2, 3, 1, 2, 1, 2),           //11 : [+]
         (1, 1, 2, 2, 3, 2),           //12 : [,]
         (1, 2, 2, 1, 3, 2),           //13 : [-]
         (1, 2, 2, 2, 3, 1),           //14 : [.]
         (1, 1, 3, 2, 2, 2),           //15 : [/]
         (1, 2, 3, 1, 2, 2),           //16 : [0]
         (1, 2, 3, 2, 2, 1),           //17 : [1]
         (2, 2, 3, 2, 1, 1),           //18 : [2]
         (2, 2, 1, 1, 3, 2),           //19 : [3]
         (2, 2, 1, 2, 3, 1),           //20 : [4]
         (2, 1, 3, 2, 1, 2),           //21 : [5]
         (2, 2, 3, 1, 1, 2),           //22 : [6]
         (3, 1, 2, 1, 3, 1),           //23 : [7]
         (3, 1, 1, 2, 2, 2),           //24 : [8]
         (3, 2, 1, 1, 2, 2),           //25 : [9]
         (3, 2, 1, 2, 2, 1),           //26 : [:]
         (3, 1, 2, 2, 1, 2),           //27 : [,]
         (3, 2, 2, 1, 1, 2),           //28 : [<]
         (3, 2, 2, 2, 1, 1),           //29 : [=]
         (2, 1, 2, 1, 2, 3),           //30 : [>]
         (2, 1, 2, 3, 2, 1),           //31 : [?]
         (2, 3, 2, 1, 2, 1),           //32 : [@]
         (1, 1, 1, 3, 2, 3),           //33 : [A]
         (1, 3, 1, 1, 2, 3),           //34 : [B]
         (1, 3, 1, 3, 2, 1),           //35 : [C]
         (1, 1, 2, 3, 1, 3),           //36 : [D]
         (1, 3, 2, 1, 1, 3),           //37 : [E]
         (1, 3, 2, 3, 1, 1),           //38 : [F]
         (2, 1, 1, 3, 1, 3),           //39 : [G]
         (2, 3, 1, 1, 1, 3),           //40 : [H]
         (2, 3, 1, 3, 1, 1),           //41 : [I]
         (1, 1, 2, 1, 3, 3),           //42 : [J]
         (1, 1, 2, 3, 3, 1),           //43 : [K]
         (1, 3, 2, 1, 3, 1),           //44 : [L]
         (1, 1, 3, 1, 2, 3),           //45 : [M]
         (1, 1, 3, 3, 2, 1),           //46 : [N]
         (1, 3, 3, 1, 2, 1),           //47 : [O]
         (3, 1, 3, 1, 2, 1),           //48 : [P]
         (2, 1, 1, 3, 3, 1),           //49 : [Q]
         (2, 3, 1, 1, 3, 1),           //50 : [R]
         (2, 1, 3, 1, 1, 3),           //51 : [S]
         (2, 1, 3, 3, 1, 1),           //52 : [T]
         (2, 1, 3, 1, 3, 1),           //53 : [U]
         (3, 1, 1, 1, 2, 3),           //54 : [V]
         (3, 1, 1, 3, 2, 1),           //55 : [W]
         (3, 3, 1, 1, 2, 1),           //56 : [X]
         (3, 1, 2, 1, 1, 3),           //57 : [Y]
         (3, 1, 2, 3, 1, 1),           //58 : [Z]
         (3, 3, 2, 1, 1, 1),           //59 : [[]
         (3, 1, 4, 1, 1, 1),           //60 : [\]
         (2, 2, 1, 4, 1, 1),           //61 : []]
         (4, 3, 1, 1, 1, 1),           //62 : [^]
         (1, 1, 1, 2, 2, 4),           //63 : [_]
         (1, 1, 1, 4, 2, 2),           //64 : [`]
         (1, 2, 1, 1, 2, 4),           //65 : [a]
         (1, 2, 1, 4, 2, 1),           //66 : [b]
         (1, 4, 1, 1, 2, 2),           //67 : [c]
         (1, 4, 1, 2, 2, 1),           //68 : [d]
         (1, 1, 2, 2, 1, 4),           //69 : [e]
         (1, 1, 2, 4, 1, 2),           //70 : [f]
         (1, 2, 2, 1, 1, 4),           //71 : [g]
         (1, 2, 2, 4, 1, 1),           //72 : [h]
         (1, 4, 2, 1, 1, 2),           //73 : [i]
         (1, 4, 2, 2, 1, 1),           //74 : [j]
         (2, 4, 1, 2, 1, 1),           //75 : [k]
         (2, 2, 1, 1, 1, 4),           //76 : [l]
         (4, 1, 3, 1, 1, 1),           //77 : [m]
         (2, 4, 1, 1, 1, 2),           //78 : [n]
         (1, 3, 4, 1, 1, 1),           //79 : [o]
         (1, 1, 1, 2, 4, 2),           //80 : [p]
         (1, 2, 1, 1, 4, 2),           //81 : [q]
         (1, 2, 1, 2, 4, 1),           //82 : [r]
         (1, 1, 4, 2, 1, 2),           //83 : [s]
         (1, 2, 4, 1, 1, 2),           //84 : [t]
         (1, 2, 4, 2, 1, 1),           //85 : [u]
         (4, 1, 1, 2, 1, 2),           //86 : [v]
         (4, 2, 1, 1, 1, 2),           //87 : [w]
         (4, 2, 1, 2, 1, 1),           //88 : [x]
         (2, 1, 2, 1, 4, 1),           //89 : [y]
         (2, 1, 4, 1, 2, 1),           //90 : [z]
         (4, 1, 2, 1, 2, 1),           //91 : [{]
         (1, 1, 1, 1, 4, 3),           //92 : [|]
         (1, 1, 1, 3, 4, 1),           //93 : [}]
         (1, 3, 1, 1, 4, 1),           //94 : [~]
         (1, 1, 4, 1, 1, 3),           //95 : [DEL]
         (1, 1, 4, 3, 1, 1),           //96 : [FNC3]
         (4, 1, 1, 1, 1, 3),           //97 : [FNC2]
         (4, 1, 1, 3, 1, 1),           //98 : [SHIFT]
         (1, 1, 3, 1, 4, 1),           //99 : [Cswap]
         (1, 1, 4, 1, 3, 1),           //100 : [Bswap]
         (3, 1, 1, 1, 4, 1),           //101 : [Aswap]
         (4, 1, 1, 1, 3, 1),           //102 : [FNC1]
         (2, 1, 1, 4, 1, 2),           //103 : [Astart]
         (2, 1, 1, 2, 1, 4),           //104 : [Bstart]
         (2, 1, 1, 2, 3, 2),           //105 : [Cstart]
         (2, 3, 3, 1, 1, 1),           //106 : [STOP]
         (2, 1, 0, 0, 0, 0)            //107 : [END BAR]
       );
var
  s, Aguid, Bguid, Cguid, needle, SminiC: String;
  crypt, cryptb: AnsiString;
  l, i, j, p, IminiC, made, madeA, madeB, check: Integer;
  set128: TCode128;
  modul: Double;
  c: T128Parity;
begin
  s := ABarCode;
  if (s = '') then
    Exit;

  if (BarHeight = 0) then
    BarHeight := cDefBarHeight;

  if (BarWidth = 0) then
    BarWidth := cDefBarWidth;

  if (BarWidth < 1) then
    BarWidth := BarWidth * 100;

  Aguid := '';                                                                      // Creation of ABC choice guides
  Bguid := '';
  Cguid := '';
  l := Length(s);
  for i := 1 to l do
  begin
    needle := copy(s, i, 1);
    Aguid := Aguid + ifthen(pos(needle, fASet) > 0, 'O', 'N');
    Bguid := Bguid + ifthen(pos(needle, fBSet) > 0, 'O', 'N');
    Cguid := Cguid + ifthen(pos(needle, fCSet) > 0, 'O', 'N');
  end;

  SminiC := 'OOOO';
  IminiC := 4;
  crypt := '';
  while (s <> '') do                                                           // MAIN CODING LOOP
  begin
    p := pos(SminiC, Cguid);                                                    // forcing of set C, if possible
    if (p > 0) then
    begin
      Aguid[p] := 'N';
      Bguid[p] := 'N';
    end;

     if (copy(Cguid, 1, IminiC) = SminiC) then                                  // set C
     begin
       crypt := crypt + chr( IfThen(crypt <> '', C128Swap[code128C],  C128Start[code128C]) );  // start Cstart, otherwise Cswap
       made := pos('N', Cguid);                                                 // extended set C
       if (made = 0) then
         made := Length(Cguid)
       else
         Dec(made);

       if ((made mod 2) = 1) then
         Dec(made);                                                             // only an even number

       i := 1;
       while (i <= made) do
       begin
         crypt := crypt + chr(StrToInt(Copy(s, i, 2)));                         // 2 by 2 conversion
         Inc(i, 2);
       end;
     end
     else
     begin
       madeA := pos('N', Aguid);                                                // set A range
       if (madeA = 0) then
         madeA := Length(Aguid)
       else
         Dec(madeA);

       madeB := pos('N', Bguid);                                                // set B range
       if (madeB = 0 ) then
         madeB := Length(Bguid)
       else
         Dec(madeB);

       if (madeA < madeB) then                                                  // treated area and Set in progress
       begin
         made := madeB;
         set128 := code128B;
       end
       else
       begin
         made := madeA;
         set128 := code128A;
       end;

       crypt := crypt + chr(IfThen(crypt <> '', C128Swap[set128], C128Start[set128])); // start, otherwise swap
       cryptb := Copy(s, 1, made);
       for j := 1 to Length(fSetFrom[set128]) do
          cryptb := StringReplace(cryptb, fSetFrom[set128][j], fSetTo[set128][j], [rfReplaceAll]); // conversion according to Set
       crypt := crypt + cryptb;
     end;

     s := Copy(s, made+1, l);                                                   // shorten legend and guides of the treated area
     Aguid := Copy(Aguid, made+1, Length(Aguid));
     Bguid := Copy(Bguid, made+1, Length(Bguid));
     Cguid := Copy(Cguid, made+1, Length(Cguid));
  end;                                                                          // END OF MAIN LOOP

  check := ord(crypt[1]);                                                       // calculation of the checksum
  l := Length(crypt);
  for i := 1 to l do
    check := check + (ord(crypt[i]) * (i-1));
  check := check mod 103;

  crypt := crypt + chr(check) + chr(106) + chr(107);                            // Complete encrypted channel
  l := Length(crypt);
  i := (l * 11) - 8;                                                            // calculation of the module width
  modul := BarWidth/i;

  for i := 1 to l do                                                            // PRINTING LOOP
  begin
    c := C128Table[ord(crypt[i])];
    j := 0;
    while (j <= 5) do
    begin
      if (c[j] > 0) then
      begin
        fpFPDF.Rect(vX, vY, c[j] * modul, BarHeight, 'F');
        Inc(j);
        vX := vX + (c[j-1]+c[j]) * modul;
      end;

      Inc(j);
    end;
  end;
end;


{ TFPDFExt }

procedure TFPDFExt.InternalCreate;
begin
  inherited;
  fProxyHost := '';
  fProxyPass := '';
  fProxyPort := '';
  fProxyUser := '';

  angle := 0;

  SetLength(layers,0);
  current_layer := -1;
  open_layer_pane := False;
end;

{ http://www.fpdf.org/en/script/script2.php - Olivier }
{ See also: http://www.fpdf.org/en/script/script9.php - Watermark }
procedure TFPDFExt.Rotate(NewAngle: Double; vX: Double; vY: Double);
var
  c, s: Extended;
  cx, cy: Double;
begin
  if (vX=-1) then
    vX := Self.x;

  if (vY=-1) then
    vY := Self.y;

  if (Self.angle <> 0) then
    _out('Q');

  Self.angle := NewAngle;
  if (NewAngle <> 0) then
  begin
    NewAngle := NewAngle * Pi/180;
    c := cos(NewAngle);
    s := sin(NewAngle);
    cx := vX * Self.k;
    cy := (Self.h-vY) * Self.k;
    _out(Format('q %.5f %.5f %.5f %.5f %.2f %.2f cm 1 0 0 1 %.2f %.2f cm', [c, s, -s, c, cx, cy, -cx, -cy], FPDFFormatSetings));
  end;
end;

{ http://www.fpdf.org/en/script/script35.php - Christophe Prugnaud }
procedure TFPDFExt.RoundedRect(vX, vY, vWidth, vHeight: Double;
  vRadius: Double = 5; vCorners: String = '1234'; vStyle: String = '');
var
  vK, hp, xc, yc: Double;
  op: Char;
  MyArc: Extended;
begin
  vK := Self.k;
  hp := Self.h;
  if (vStyle='F') then
    op := 'f'
  else if (vStyle='FD') or (vStyle='DF') then
    op := 'B'
  else
    op := 'S';

  MyArc := 4/3 * (sqrt(2) - 1);
  _out(Format('%.2f %.2f m', [(vX+vRadius)*vk, (hp-vY)*k], FPDFFormatSetings));

  xc := vx+vWidth-vRadius;
  yc := vY+vRadius;
  _out(Format('%.2f %.2f l', [xc*vK, (hp-vY)*vK], FPDFFormatSetings));
  if (pos('2', vCorners) = 0) then
    _out(Format('%.2f %.2f l', [(vX+vWidth)*vK,(hp-vY)*vK], FPDFFormatSetings))
  else
    _Arc(xc+vRadius*MyArc, yc-vRadius, xc+vRadius, yc-vRadius*MyArc, xc+vRadius, yc);

  xc := vX+vWidth-vRadius;
  yc := vY+vHeight-vRadius;
  _out(Format('%.2f %.2f l', [(vX+vWidth)*vK,(hp-yc)*vK], FPDFFormatSetings));
  if (pos('3', vCorners) = 0) then
    _out(Format('%.2f %.2f l', [(vX+vWidth)*vk,(hp-(vY+vHeight))*vK], FPDFFormatSetings))
  else
    _Arc(xc+vRadius, yc+vRadius*MyArc, xc+vRadius*MyArc, yc+vRadius, xc, yc+vRadius);

  xc := vX+vRadius;
  yc := vY+vHeight-vRadius;
  _out(Format('%.2f %.2f l', [xc*vK,(hp-(vY+vHeight))*vK] , FPDFFormatSetings));
  if (pos('4', vCorners) = 0) then
    _out(Format('%.2f %.2f l', [(vX)*vK,(hp-(vY+vHeight))*vK], FPDFFormatSetings))
  else
    _Arc(xc-vRadius*MyArc, yc+vRadius, xc-vRadius, yc+vRadius*MyArc, xc-vRadius, yc);

  xc := vx+vRadius;
  yc := vY+vRadius;
  _out(Format('%.2f %.2f l', [(vX)*vK, (hp-yc)*vK], FPDFFormatSetings));
  if (pos('1', vCorners) = 0) then
  begin
    _out(Format('%.2f %.2f l', [(vX)*vK, (hp-vY)*vK], FPDFFormatSetings));
    _out(Format('%.2f %.2f l', [(vx+vRadius)*vK,(hp-vY)*vK], FPDFFormatSetings));
  end
  else
    _Arc(xc-vRadius, yc-vRadius*MyArc, xc-vRadius*MyArc, yc-vRadius, xc, yc-vRadius);

  _out(op);
end;

procedure TFPDFExt._Arc(vX1, vY1, vX2, vY2, vX3, vY3: Double);
var
  vh: Double;
begin
  vh := Self.h;
  _out(Format('%.2f %.2f %.2f %.2f %.2f %.2f c ',
          [vX1*Self.k, (vh-vY1)*Self.k, vX2*Self.k, (vh-vY2)*Self.k, vX3*Self.k, (vh-vY3)*Self.k],
          FPDFFormatSetings));
end;


{ http://www.fpdf.org/en/script/script97.php - Oliver }
function TFPDFExt.AddLayer(const LayerName: String; IsVisible: Boolean = true): Integer;
var
  s: String;
  id: Integer;
begin
  s := ConvertTextToAnsi(LayerName);
  id := Length(layers);
  SetLength(layers, id+1);
  layers[id].Name := LayerName;
  layers[id].Visible := IsVisible;
  layers[id].n := -1;
  Result := id;
end;

procedure TFPDFExt.BeginLayer(LayerId: Integer);
begin
  if (LayerId >= Length(Self.layers)) then
    Error('Invalid Layer Id: '+IntToStr(LayerId));

  EndLayer();
  _out('/OC /OC'+IntToStr(LayerId)+' BDC');
  Self.current_layer := LayerId;
end;

procedure TFPDFExt.BeginLayer(const LayerName: String);
var
  i, Id: Integer;
begin
  Id := -1;
  for i := 0 to Length(Self.layers)-1 do
  begin
    if (LayerName = Self.layers[i].Name) then
    begin
      Id := i;
      Break;
    end;
  end;

  if (Id < 0) then
    Error('Layer Name not found: '+LayerName);

  BeginLayer(Id);
end;

procedure TFPDFExt.EndLayer();
begin
  if (Self.current_layer >= 0) then
  begin
    _out('EMC');
    Self.current_layer := -1;
  end;
end;

procedure TFPDFExt.OpenLayerPane();
begin
  Self.open_layer_pane := true;
end;

{$IfDef HAS_HTTP}
procedure TFPDFExt.Image(const vFileOrURL: string; vX: double; vY: double;
  vWidth: double; vHeight: double; const vLink: string);
var
  s, ext: string;
  ms: TMemoryStream;
  img: TFPDFImageInfo;
  i: integer;
begin
  //Put an image From Web on the page
  s := LowerCase(vFileOrURL);
  if ((Pos('http://', s) > 0) or (Pos('https://', s) > 0)) then
  begin
    img := FindUsedImage(vFileOrURL);
    if (img.Data = '') then
    begin
      ext := '';
      if (Pos('.jpg', s) > 0) or (Pos('.jpeg', s) > 0) then
        ext := 'JPG'
      else if (Pos('.png', s) > 0) then
        ext := 'PNG'
      else
        Error('Supported image not found in URL: ' + vFileOrURL);

      ms := TMemoryStream.Create;
      try
        GetImageFromURL(vFileOrURL, ms);
        inherited Image(ms, ext, vX, vY, vWidth, vHeight, vLink);
        i := Length(Self.images) - 1;
        Self.images[i].ImageName := vFileOrURL;
      finally
        ms.Free;
      end;
    end
    else
      inherited Image(img, vX, vY, vWidth, vHeight, vLink);
  end
  else
    inherited Image(vFileOrURL, vX, vY, vWidth, vHeight, vLink);
end;
{$EndIf}

procedure TFPDFExt.CodeEAN13(const ABarCode: string; vX: double; vY: double;
  BarHeight: double; BarWidth: double);
var
  script: TFPDFScriptCodeEAN;
begin
  script := TFPDFScriptCodeEAN.Create(Self);
  try
    script.CodeEAN13(ABarCode, vX, vY, BarHeight, BarWidth);
  finally
    script.Free;
  end;
end;

procedure TFPDFExt.CodeEAN8(const ABarCode: string; vX: double; vY: double;
  BarHeight: double; BarWidth: double);
var
  script: TFPDFScriptCodeEAN;
begin
  script := TFPDFScriptCodeEAN.Create(Self);
  try
    script.CodeEAN8(ABarCode, vX, vY, BarHeight, BarWidth);
  finally
    script.Free;
  end;
end;

procedure TFPDFExt.CodeI25(const ABarCode: string; vX: double; vY: double;
  BarHeight: double; BarWidth: double);
var
  script: TFPDFScriptCodeI25;
begin
  script := TFPDFScriptCodeI25.Create(Self);
  try
    script.CodeI25(ABarCode, vX, vY, BarHeight, BarWidth);
  finally
    script.Free;
  end;
end;

procedure TFPDFExt.Code39(const ABarCode: string; vX: double; vY: double;
  BarHeight: double; BarWidth: double);
var
  script: TFPDFScriptCode39;
begin
  script := TFPDFScriptCode39.Create(Self);
  try
    script.Code39(ABarCode, vX, vY, BarHeight, BarWidth);
  finally
    script.Free;
  end;
end;

procedure TFPDFExt.Code128(const ABarCode: string; vX: double; vY: double;
  BarHeight: double; BarWidth: double);
var
  script: TFPDFScriptCode128;
begin
  script := TFPDFScriptCode128.Create(Self);
  try
    script.Code128(ABarCode, vX, vY, BarHeight, BarWidth);
  finally
    script.Free;
  end;
end;

{$IfDef DelphiZXingQRCode}
procedure TFPDFExt.QRCode(vX: double; vY: double; const QRCodeData: String;
  DotSize: Double; AEncoding: TQRCodeEncoding);
var
  qr: TDelphiZXingQRCode;
  PDF2DMatrix: TFPDF2DMatrix;
  r, c: Integer;
begin
  qr := TDelphiZXingQRCode.Create;
  try
    qr.Encoding  := AEncoding;
    qr.QuietZone := 1;
    qr.Data := widestring(QRCodeData);

    SetLength(PDF2DMatrix, qr.Rows);
    for r := 0 to qr.Rows-1 do
    begin
      SetLength(PDF2DMatrix[r], qr.Columns);
      for c := 0 to qr.Columns-1 do
      begin
        if (qr.IsBlack[r, c]) then
          PDF2DMatrix[r][c] := 1
        else
          PDF2DMatrix[r][c] := 0;
      end;
    end;
  finally
    qr.Free;
  end;

  Draw2DMatrix(PDF2DMatrix, vX, vY, DotSize);
end;
{$EndIf}

procedure TFPDFExt.Draw2DMatrix(AMatrix: TFPDF2DMatrix; vX: double; vY: double;
  DotSize: Double);
var
  rows, cols, r, c: Integer;
  wX: Double;
begin
  rows := Length(AMatrix);
  if (rows < 1) then
    Exit;

  cols := Length(AMatrix[0]);
  if (cols < 1) then
    Exit;

  if DotSize = 0 then
    DotSize := cDefBarWidth;

  wX := vX;
  for r := 0 to rows-1 do
  begin
    vX := wX;
    for c := 0 to cols-1 do
    begin
      if (AMatrix[r][c] <> 0) then
        Rect(vX, vY, DotSize, DotSize, 'F');
      vX := vX + DotSize;
    end;
    vY := vY + DotSize;
  end;
end;

{$IfDef HAS_HTTP}
{$IfDef USE_SYNAPSE}
procedure TFPDFExt.GetImageFromURL(const aURL: string; const aResponse: TStream);
var
  vHTTP: THTTPSend;
  Ok: boolean;
begin
  vHTTP := THTTPSend.Create;
  try
    if (ProxyHost <> '') then
    begin
      vHTTP.ProxyHost := ProxyHost;
      vHTTP.ProxyPort := ProxyPort;
      vHTTP.ProxyUser := ProxyUser;
      vHTTP.ProxyPass := ProxyPass;
    end;
    Ok := vHTTP.HTTPMethod('GET', aURL);
    if Ok then
    begin
      aResponse.Seek(0, soBeginning);
      aResponse.CopyFrom(vHTTP.Document, 0);
    end
    else
      Error('Http Error: ' + IntToStr(vHTTP.ResultCode) +
        ' when downloading from: ' + aURL);
  finally
    vHTTP.Free;
  end;
end;
{$Else}
procedure TFPDFExt.GetImageFromURL(const aURL: string; const aResponse: TStream);
var
  vHTTP: TFPHTTPClient;
begin
  vHTTP := TFPHTTPClient.Create(nil);
  try
    if (ProxyHost <> '') then
    begin
      vHTTP.Proxy.Host := ProxyHost;
      vHTTP.Proxy.Port := StrToIntDef(ProxyPort, 0);
      vHTTP.Proxy.UserName := ProxyUser;
      vHTTP.Proxy.Password := ProxyPass;
    end;

    vHTTP.Get(aURL, aResponse);
  finally
    vHTTP.Free;
  end;
end;
{$EndIf}
{$EndIf}

procedure TFPDFExt._endpage;
begin
  if (Self.angle <> 0) then
  begin
    Self.angle := 0;
    _out('Q');
  end;

  EndLayer();

  inherited _endpage;
end;

procedure TFPDFExt._putresourcedict;
var
  i, l: Integer;
begin
  inherited _putresourcedict;

  l := Length(Self.layers);
  if (l > 0) then
  begin
    _put('/Properties <<');
    for i := 0 to l-1 do
      _put('/OC'+IntToStr(i)+' '+IntToStr(Self.layers[i].n)+' 0 R');
    _put('>>');
  end;
end;

procedure TFPDFExt._putresources;
begin
  _putlayers;
  inherited _putresources;
end;

procedure TFPDFExt._putlayers;
var
  i, l: Integer;
begin
  l := Length(Self.layers)-1;
  for i := 0 to l do
  begin
    _newobj();
    Self.layers[i].n := Self.n;
    _put('<</Type /OCG /Name '+_textstring(Self.layers[i].Name)+'>>');
    _put('endobj');
  end;
end;

procedure TFPDFExt._putcatalog;
var
  l_off, s: String;
  l, i: Integer;
begin
  inherited _putcatalog;
  s := '';
  l_off := '';
  l := Length(Self.layers)-1;
  for i := 0 to l do
  begin
    s := s + IntToStr(Self.layers[i].n)+' 0 R ';
    if (not Self.layers[i].Visible) then
      l_off := l_off + IntToStr(Self.layers[i].n)+' 0 R ';
  end;

  _put('/OCProperties <</OCGs ['+s+'] /D <</OFF ['+l_off+'] /Order ['+s+']>>>>');
  if (Self.open_layer_pane) then
    _put('/PageMode /UseOC');
end;

procedure TFPDFExt._enddoc;
begin
  if (Self.PDFVersion < 1.5) then
    Self.PDFVersion := 1.5;

  inherited _enddoc;
end;

end.

