{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2015 Daniel Simoes de Almeida               }
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

{$I ACBr.inc}

unit ACBrDFeXsMsXmlCapicom;

interface

uses
  Classes, SysUtils,
  ACBrDFeSSL, ACBrDFeXsMsXml;

type

  { TDFeSSLXmlSignMsXmlCapicom }

  TDFeSSLXmlSignMsXmlCapicom = class( TDFeSSLXmlSignMsXml )
   private
   protected
   public
     function Assinar(const ConteudoXML, docElement, infElement: String;
       SignatureNode: String = ''; SelectionNamespaces: String = '';
       IdSignature: String = ''; IdAttr: String = ''): String; override;
   end;


implementation

uses
  ActiveX, ComObj,
  ACBrUtil, ACBrDFeUtil, ACBrDFeException, ACBrDFeCapicom,
  ACBrCAPICOM_TLB, ACBrMSXML2_TLB;

{ TDFeSSLXmlSignMsXmlCapicom }

function TDFeSSLXmlSignMsXmlCapicom.Assinar(const ConteudoXML, docElement,
  infElement: String; SignatureNode: String; SelectionNamespaces: String;
  IdSignature: String; IdAttr: String): String;
var
  AXml, XmlAss: AnsiString;
  xmldoc: IXMLDOMDocument3;
  xmldsig: IXMLDigitalSignature;
  dsigKey: IXMLDSigKey;
  signedKey: IXMLDSigKey;
  PrivateKey: IPrivateKey;
  Inicializado: Boolean;
begin
  if not (FpDFeSSL.SSLCryptClass is TDFeCapicom) then
    raise EACBrDFeException.Create('Erro de configura��o. SSLCryptClass n�o � TDFeCapicom');

  Inicializado := (CoInitialize(nil) in [ S_OK, S_FALSE ]);
  try
     FpDFeSSL.CarregarCertificadoSeNecessario;

    // IXMLDOMDocument3 deve usar a String Nativa da IDE //
    {$IfDef FPC2}
     AXml := ACBrUTF8ToAnsi(ConteudoXML);
    {$Else}
     AXml := UTF8ToNativeString(ConteudoXML);
    {$EndIf}
    XmlAss := '';

    // Usa valores default, se n�o foram informados //
    VerificarValoresPadrao(SignatureNode, SelectionNamespaces);

    // Inserindo Template da Assinatura digital //
    if (not XmlEstaAssinado(AXml)) or (SignatureNode <> CSIGNATURE_NODE) then
      AXml := AdicionarSignatureElement(AXml, False, docElement, IdSignature, IdAttr);

    try
      // Criando XMLDOC //
      xmldoc := CoDOMDocument50.Create;
      xmldoc.async := False;
      xmldoc.validateOnParse := False;
      xmldoc.preserveWhiteSpace := True;

      // Carregando o AXml em XMLDOC
      if (not xmldoc.loadXML( WideString(AXml) )) then
        raise EACBrDFeException.Create('N�o foi poss�vel carregar XML'+sLineBreak+ AXml);

      xmldoc.setProperty('SelectionNamespaces', SelectionNamespaces);

      //DEBUG
      //xmldoc.save('c:\temp\xmldoc.xml');

      // Criando Elemento de assinatura //
      xmldsig := CoMXDigitalSignature50.Create;

      // Lendo elemento de Assinatura de XMLDOC //
      xmldsig.signature := xmldoc.selectSingleNode( WideString(SignatureNode) );
      if (xmldsig.signature = nil) then
        raise EACBrDFeException.Create('� preciso carregar o template antes de assinar.');

      // Lendo Chave Privada do Certificado //
      with TDFeCapicom(FpDFeSSL.SSLCryptClass) do
      begin
        OleCheck(IDispatch(Certificado.PrivateKey).QueryInterface(IPrivateKey, PrivateKey));
        xmldsig.store := Store;
      end;

      dsigKey := xmldsig.createKeyFromCSP(PrivateKey.ProviderType,
        PrivateKey.ProviderName, PrivateKey.ContainerName, 0);
      if (dsigKey = nil) then
        raise EACBrDFeException.Create('Erro ao criar a chave do CSP.');

      // Assinando com MSXML e CryptoLib //
      signedKey := xmldsig.sign(dsigKey, CERTIFICATES);
      if (signedKey = nil) then
        raise EACBrDFeException.Create('Assinatura Falhou.');

      //DEBUG
      //xmldoc.save('c:\temp\ass2.xml');
      XmlAss := AnsiString(xmldoc.xml);

      // Convertendo novamente para UTF8
      {$IfDef FPC2}
       XmlAss := ACBrAnsiToUTF8( XmlAss );
      {$Else}
       XmlAss := NativeStringToUTF8( String(XmlAss) );
      {$EndIf}

      // Ajustando o XML... CAPICOM insere um cabe�alho inv�lido
      XmlAss := AjustarXMLAssinado(XmlAss);
    finally
      dsigKey := nil;
      signedKey := nil;
      xmldoc := nil;
      xmldsig := nil;
    end;

    Result := XmlAss;
  finally
    if Inicializado then
      CoUninitialize;
  end;
end;

end.

