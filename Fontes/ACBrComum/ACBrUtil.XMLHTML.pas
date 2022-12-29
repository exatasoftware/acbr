{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
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
{                                                                              }
{  Algumas fun�oes dessa Unit foram extraidas de outras Bibliotecas, veja no   }
{ cabe�alho das Fun�oes no c�digo abaixo a origem das informa�oes, e autores...}
{                                                                              }
{******************************************************************************}

{$I ACBr.inc}

{$IFDEF FPC}
 {$IFNDEF NOGUI}
  {$DEFINE USE_LCLIntf}
 {$ENDIF}
{$ENDIF}

unit ACBrUtil.XMLHTML;

interface

Uses
  SysUtils, Math, Classes,
  ACBrBase, ACBrConsts, IniFiles,
  {$IfDef COMPILER6_UP} StrUtils, DateUtils {$Else} ACBrD5, FileCtrl {$EndIf}
  {$IfDef FPC}
    ,dynlibs, LazUTF8, LConvEncoding, LCLType
    {$IfDef USE_LCLIntf} ,LCLIntf {$EndIf}
  {$EndIf}
  {$IfDef MSWINDOWS}
    ,Windows, ShellAPI
  {$Else}
    {$IfNDef FPC}
      {$IfDef ANDROID}
      ,System.IOUtils
      {$EndIf}
      {$IfDef  POSIX}
      ,Posix.Stdlib
      ,Posix.Unistd
      ,Posix.Fcntl
      {$Else}
      ,Libc
      {$EndIf}
    {$Else}
      ,unix, BaseUnix
    {$EndIf}
    {$IfNDef NOGUI}
      {$IfDef FMX}
        ,FMX.Forms
      {$Else}
        ,Forms
      {$EndIf}
    {$EndIf}
  {$EndIf} ;


function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True) : String;

function LerTagXML( const AXML, ATag: String; IgnoreCase: Boolean = True) : String; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Use o m�todo SeparaDados()' {$ENDIF};
function XmlEhUTF8(const AXML: String): Boolean;
function ConverteXMLtoUTF8(const AXML: String): String;
function ConverteXMLtoNativeString(const AXML: String): String;
function ObtemDeclaracaoXML(const AXML: String): String;
function RemoverDeclaracaoXML(const AXML: String; aTodas: Boolean = False): String;
function InserirDeclaracaoXMLSeNecessario(const AXML: String;
   const ADeclaracao: String = CUTF8DeclaracaoXML): String;

function SeparaDados(const AString: String; const Chave: String; const MantemChave : Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True) : String;
function SeparaDadosArray(const AArray: Array of String; const AString: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True) : String;
procedure EncontrarInicioFinalTag(const aText, ATag: String; var PosIni, PosFim: integer;const PosOffset: integer = 0);
function StripHTML(const AHTMLString : String) : String;
procedure AcharProximaTag(const ABinaryString: AnsiString; const PosIni: Integer; var ATag: AnsiString; var PosTag: Integer);

function ExtrairTextoEntreTags(const UmXmlString: string; const UmaTag: string): string;

implementation

uses
  ACBrUtil.Compatibilidade, ACBrUtil.Base, ACBrUtil.Strings, StrUtilsEx;

{------------------------------------------------------------------------------
   Realiza o tratamento de uma String recebida de um Servi�o Web
   Transforma caracteres HTML Entity em ASCII ou vice versa.
   No caso de decodifica��o, tamb�m transforma o Encoding de UTF8 para a String
   nativa da IDE
 ------------------------------------------------------------------------------}
function ParseText( const Texto : AnsiString; const Decode : Boolean = True;
   const IsUTF8: Boolean = True ) : String;
var
  AStr: String;

  function InternalStringReplace(const S, OldPatern, NewPattern: String ): String;
  begin
    if pos(OldPatern, S) > 0 then
      Result := FastStringReplace(S, OldPatern, ACBrStr(NewPattern), [rfReplaceAll])
    else
      Result := S;
  end;

begin
  if Decode then
  begin
    Astr := DecodeToString( Texto, IsUTF8 ) ;

    Astr := InternalStringReplace(AStr, '&amp;'   , '&');
    AStr := InternalStringReplace(AStr, '&lt;'    , '<');
    AStr := InternalStringReplace(AStr, '&gt;'    , '>');
    AStr := InternalStringReplace(AStr, '&quot;'  , '"');
    AStr := InternalStringReplace(AStr, '&#39;'   , #39);
    AStr := InternalStringReplace(AStr, '&#45;'   , '-');
    AStr := InternalStringReplace(AStr, '&aacute;', '�');
    AStr := InternalStringReplace(AStr, '&Aacute;', '�');
    AStr := InternalStringReplace(AStr, '&acirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Acirc;' , '�');
    AStr := InternalStringReplace(AStr, '&atilde;', '�');
    AStr := InternalStringReplace(AStr, '&Atilde;', '�');
    AStr := InternalStringReplace(AStr, '&agrave;', '�');
    AStr := InternalStringReplace(AStr, '&Agrave;', '�');
    AStr := InternalStringReplace(AStr, '&eacute;', '�');
    AStr := InternalStringReplace(AStr, '&Eacute;', '�');
    AStr := InternalStringReplace(AStr, '&ecirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Ecirc;' , '�');
    AStr := InternalStringReplace(AStr, '&iacute;', '�');
    AStr := InternalStringReplace(AStr, '&Iacute;', '�');
    AStr := InternalStringReplace(AStr, '&oacute;', '�');
    AStr := InternalStringReplace(AStr, '&Oacute;', '�');
    AStr := InternalStringReplace(AStr, '&otilde;', '�');
    AStr := InternalStringReplace(AStr, '&Otilde;', '�');
    AStr := InternalStringReplace(AStr, '&ocirc;' , '�');
    AStr := InternalStringReplace(AStr, '&Ocirc;' , '�');
    AStr := InternalStringReplace(AStr, '&uacute;', '�');
    AStr := InternalStringReplace(AStr, '&Uacute;', '�');
    AStr := InternalStringReplace(AStr, '&uuml;'  , '�');
    AStr := InternalStringReplace(AStr, '&Uuml;'  , '�');
    AStr := InternalStringReplace(AStr, '&ccedil;', '�');
    AStr := InternalStringReplace(AStr, '&Ccedil;', '�');
    AStr := InternalStringReplace(AStr, '&apos;'  , '''');
  end
  else
  begin
    AStr := string(Texto);
    AStr := StringReplace(AStr, '&', '&amp;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '<', '&lt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '>', '&gt;'  , [rfReplaceAll]);
    AStr := StringReplace(AStr, '"', '&quot;', [rfReplaceAll]);
    AStr := StringReplace(AStr, #39, '&#39;' , [rfReplaceAll]);
    AStr := StringReplace(AStr, '''','&apos;', [rfReplaceAll]);
  end;

  Result := AStr;
end;

{------------------------------------------------------------------------------
   Retorna o conteudo de uma Tag dentro de um arquivo XML
 ------------------------------------------------------------------------------}
function LerTagXML(const AXML, ATag: String; IgnoreCase: Boolean): String;
begin
  Result := SeparaDados(AXML, ATag, False, True, IgnoreCase);
end ;

{------------------------------------------------------------------------------
   Retorna True se o XML cont�m a TAG de encoding em UTF8, no seu in�cio.
 ------------------------------------------------------------------------------}
function XmlEhUTF8(const AXML: String): Boolean;
var
  XmlStart: String;
  P: Integer;
begin
  XmlStart := LowerCase(LeftStr(AXML, 50));
  P := pos('encoding', XmlStart);
  Result := (P > 0) and (pos('utf-8', XmlStart) > P);
end;

{------------------------------------------------------------------------------
   Se XML n�o contiver a TAG de encoding em UTF8, no seu in�cio, adiciona a TAG
   e converte o conteudo do mesmo para UTF8 (se necess�rio, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoUTF8(const AXML: String): String;
var
  UTF8Str: AnsiString;
begin
  if not XmlEhUTF8(AXML) then   // J� foi convertido antes ou montado em UTF8 ?
  begin
    UTF8Str := NativeStringToUTF8(AXML);
    Result := CUTF8DeclaracaoXML + String(UTF8Str);
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Retorna a Declara��o do XML, Ex: <?xml version="1.0"?>
   http://www.tizag.com/xmlTutorial/xmlprolog.php
 ------------------------------------------------------------------------------}
function ObtemDeclaracaoXML(const AXML: String): String;
var
  P1, P2: Integer;
begin
  Result := '';
  P1 := pos('<?', AXML);
  if P1 > 0 then
  begin
    P2 := PosEx('?>', AXML, P1+2);
    if P2 > 0 then
      Result := copy(AXML, P1, P2-P1+2);
  end;
end;

{------------------------------------------------------------------------------
   Retorna XML sem a Declara��o, Ex: <?xml version="1.0"?>
 ------------------------------------------------------------------------------}
function RemoverDeclaracaoXML(const AXML: String; aTodas: Boolean = False): String;
var
  DeclaracaoXML: String;
begin
  DeclaracaoXML := ObtemDeclaracaoXML(AXML);

  if DeclaracaoXML <> '' then
  begin
    if aTodas then
      Result := FastStringReplace(AXML, DeclaracaoXML, '', [rfReplaceAll])
    else
      Result := FastStringReplace(AXML, DeclaracaoXML, '', []);
  end
  else
    Result := AXML;
end;

{------------------------------------------------------------------------------
   Insere uma Declara��o no XML, caso o mesmo n�o tenha nenhuma
   Se "ADeclaracao" n�o for informado, usar� '<?xml version="1.0" encoding="UTF-8"?>'
 ------------------------------------------------------------------------------}
function InserirDeclaracaoXMLSeNecessario(const AXML: String;
  const ADeclaracao: String): String;
var
  DeclaracaoXML: String;
begin
 Result := AXML;

 // Verificando se a Declara��o informada � v�lida
  if (LeftStr(ADeclaracao,2) <> '<?') or (RightStr(ADeclaracao,2) <> '?>') then
    Exit;

  DeclaracaoXML := ObtemDeclaracaoXML(AXML);
  if EstaVazio(DeclaracaoXML) then
    Result := ADeclaracao + Result;
end;

{------------------------------------------------------------------------------
   Se XML contiver a TAG de encoding em UTF8, no seu in�cio, remove a TAG
   e converte o conteudo do mesmo para String Nativa da IDE (se necess�rio, dependendo da IDE)
 ------------------------------------------------------------------------------}
function ConverteXMLtoNativeString(const AXML: String): String;
begin
  if XmlEhUTF8(AXML) then   // J� foi convertido antes ou montado em UTF8 ?
  begin
    Result := UTF8ToNativeString(AnsiString(AXML));
    {$IfNDef FPC}
     Result := RemoverDeclaracaoXML(Result);
    {$EndIf}
  end
  else
    Result := AXML;
end;


function SeparaDados(const AString: String; const Chave: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True): String;
var
  PosIni, PosFim: Integer;
  UTexto, UChave: String;
  Prefixo: String;
begin
  Result := '';
  PosFim := 0;
  Prefixo := '';

  if AIgnoreCase then
  begin
    UTexto := AnsiUpperCase(AString);
    UChave := AnsiUpperCase(Chave);
  end
  else
  begin
    UTexto := AString;
    UChave := Chave;
  end;

  PosIni := Pos('<' + UChave, UTexto);
  while (PosIni > 0) and not CharInSet(UTexto[PosIni + Length('<' + UChave)], ['>', ' ']) do
    PosIni := PosEx('<' + UChave, UTexto, PosIni + 1);

  if PosIni > 0 then
  begin
    if MantemChave then
      PosFim := Pos('/' + UChave, UTexto) + length(UChave) + 3
    else
    begin
      PosIni := PosIni + Pos('>', copy(UTexto, PosIni, length(UTexto)));
      PosFim := Pos('/' + UChave + '>', UTexto);
    end;
  end;

  if (PosFim = 0) and PermitePrefixo then
  begin
    PosIni := Pos(':' + Chave, AString);
    if PosIni > 1 then
    begin
      while (PosIni > 1) and (AString[PosIni - 1] <> '<') do
      begin
        Prefixo := AString[PosIni - 1] + Prefixo;
        PosIni := PosIni - 1;
      end;
      Result := SeparaDados(AString, Prefixo + ':' + Chave, MantemChave, False, AIgnoreCase);
    end
  end
  else
    Result := copy(AString, PosIni, PosFim - (PosIni + 1));

end;

function SeparaDadosArray(const AArray: array of String; const AString: String; const MantemChave: Boolean = False;
  const PermitePrefixo: Boolean = True; const AIgnoreCase: Boolean = True): String;
var
  I : Integer;
begin
  Result := '';
 for I:=Low(AArray) to High(AArray) do
 begin
   Result := Trim(SeparaDados(AString,AArray[I], MantemChave, PermitePrefixo, AIgnoreCase));
   if Result <> '' then
      Exit;
 end;
end;


{------------------------------------------------------------------------------
   Retorna a posi��o inicial e final da Tag do XML
 ------------------------------------------------------------------------------}
procedure EncontrarInicioFinalTag(const aText, ATag: String;
  var PosIni, PosFim: integer; const PosOffset: integer = 0);
begin
  PosFim := 0;
  PosIni := PosEx('<' + ATag + '>', aText, PosOffset);
  if (PosIni > 0) then
  begin
    PosIni := PosIni + Length(ATag) + 1;
    PosFim := PosLast('</' + ATag + '>', aText);
    if PosFim < PosIni then
      PosFim := 0;
  end;
end;

{-----------------------------------------------------------------------------
   Localiza uma Tag dentro de uma String, iniciando a busca em PosIni.
   Se encontrar uma Tag, Retorna a mesma em ATag, e a posi��o inicial dela em PosTag
 ---------------------------------------------------------------------------- }
procedure AcharProximaTag(const ABinaryString: AnsiString;
  const PosIni: Integer; var ATag: AnsiString; var PosTag: Integer);
var
   PosTagAux, FimTag, LenTag : Integer ;
begin
  ATag   := '';
  PosTag := PosExA( '<', ABinaryString, PosIni);
  if PosTag > 0 then
  begin
    PosTagAux := PosExA( '<', ABinaryString, PosTag + 1);  // Verificando se Tag � inv�lida
    FimTag    := PosExA( '>', ABinaryString, PosTag + 1);
    if FimTag = 0 then                             // Tag n�o fechada ?
    begin
      PosTag := 0;
      exit ;
    end ;

    while (PosTagAux > 0) and (PosTagAux < FimTag) do  // Achou duas aberturas Ex: <<e>
    begin
      PosTag    := PosTagAux;
      PosTagAux := PosExA( '<', ABinaryString, PosTag + 1);
    end ;

    LenTag := FimTag - PosTag + 1 ;
    ATag   := LowerCase( copy( ABinaryString, PosTag, LenTag ) );
  end ;
end ;

{-----------------------------------------------------------------------------
   Remove todas as TAGS de HTML de uma String, retornando a String alterada
 ---------------------------------------------------------------------------- }
function StripHTML(const AHTMLString: String): String;
var
  ATag, VHTMLString: AnsiString;
  PosTag, LenTag: Integer;
begin
  VHTMLString := AHTMLString;
  ATag   := '';
  PosTag := 0;

  AcharProximaTag( VHTMLString, 1, ATag, PosTag);
  while ATag <> '' do
  begin
    LenTag := Length( ATag );
    Delete(VHTMLString, PosTag, LenTag);

    ATag := '';
    AcharProximaTag( VHTMLString, PosTag, ATag, PosTag );
  end ;
  Result := VHTMLString;
end;

{-----------------------------------------------------------------------------
   Extrai o texto entre uma Tag de XML.
   Bug Conhecido:
     Tags que s�o repetidas dentro de si mesmas podem gerar erro.
     Isso deve ser corrigido numa vers�o posterior.
     Mas o melhor nesses casos � usar um parse de XML e n�o uma fun��o que manipula strings.
   Por exemplo: Dados:
    UmXmlString = '<xml>blabla<xml></xml>bloblo<xml></xml><xml>'
    UmaTag = 'xml'
    Retorno ser� = 'blabla<xml></xml>' e n�o 'blabla<xml></xml>bloblo<xml></xml>'
 ---------------------------------------------------------------------------- }
function ExtrairTextoEntreTags(const UmXmlString: string; const UmaTag: string): string;
var
  vTagAbertura, vTagFechamento: string;
  posInicioDaTagAbertura, posFinalTagAbertura: integer;
begin
  vTagAbertura := '<'+UmaTag;
  posInicioDaTagAbertura := pos(vTagAbertura, UmXmlString);

  if (posInicioDaTagAbertura <= 0) then
  begin
    Result := UmXmlString;
    Exit;
  end;

  posFinalTagAbertura := Pos('>', UmXmlString, posInicioDaTagAbertura);
  vTagAbertura := Copy(UmXmlString, posInicioDaTagAbertura, posFinalTagAbertura - posInicioDaTagAbertura+1);
  vTagFechamento := '</'+UmaTag+'>';
  Result := Trim(RetornarConteudoEntre(UmXmlString, vTagAbertura, vTagAbertura));
end;


end.
