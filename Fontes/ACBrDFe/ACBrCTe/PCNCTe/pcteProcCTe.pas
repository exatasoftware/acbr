////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar CTe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da CTe          //
//                                                                            //
//        site: www.projetocooperar.org/cte                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_cte/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: (c) 2009 - Paulo Casagrande                                   //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU Lesser General Public License (GNU LGPL)                  //
//                                                                            //
//              - Este programa � software livre; voc� pode redistribu�-lo    //
//              e/ou modific�-lo sob os termos da Licen�a P�blica Geral GNU,  //
//              conforme publicada pela Free Software Foundation; tanto a     //
//              vers�o 2 da Licen�a como (a seu crit�rio) qualquer vers�o     //
//              mais nova.                                                    //
//                                                                            //
//              - Este programa � distribu�do na expectativa de ser �til,     //
//              mas SEM QUALQUER GARANTIA; sem mesmo a garantia impl�cita de  //
//              COMERCIALIZA��O ou de ADEQUA��O A QUALQUER PROP�SITO EM       //
//              PARTICULAR. Consulte a Licen�a P�blica Geral GNU para obter   //
//              mais detalhes. Voc� deve ter recebido uma c�pia da Licen�a    //
//              P�blica Geral GNU junto com este programa; se n�o, escreva    //
//              para a Free Software Foundation, Inc., 59 Temple Place,       //
//              Suite 330, Boston, MA - 02111-1307, USA ou consulte a         //
//              licen�a oficial em http://www.gnu.org/licenses/gpl.txt        //
//                                                                            //
//    Nota (1): - Esta  licen�a  n�o  concede  o  direito  de  uso  do nome   //
//              "PCN  -  Projeto  Cooperar  NFe", n�o  podendo o mesmo ser    //
//              utilizado sem previa autoriza��o.                             //
//                                                                            //
//    Nota (2): - O uso integral (ou parcial) das units do projeto esta       //
//              condicionado a manuten��o deste cabe�alho junto ao c�digo     //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

{$I ACBr.inc}

unit pcteProcCTe;

interface

uses
  SysUtils, Classes,
  pcnConversao, pcnGerador, pcnLeitor, pcteConversaoCTe;

type

//  TPcnPadraoNomeProcCTe = (tpnPublico, tpnPrivado);

  TProcCTe = class(TObject)
  private
    FGerador: TGerador;
    FPathCTe: String;
    FPathRetConsReciCTe: String;
    FPathRetConsSitCTe: String;
    FtpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FchCTe: String;
    FdhRecbto: TDateTime;
    FnProt: String;
    FdigVal: String;
    FcStat: Integer;
    FxMotivo: String;
    FId: String;
    FVersao: String;
    FcMsg: Integer;
    FxMsg: String;
    FXML_CTe: String;
    FXML_prot: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;
//    function ObterNomeArquivo(const PadraoNome: TPcnPadraoNomeProcCTe = tpnPrivado): String;
    property Gerador: TGerador          read FGerador            write FGerador;
    property PathCTe: String            read FPathCTe            write FPathCTe;
    property PathRetConsReciCTe: String read FPathRetConsReciCTe write FPathRetConsReciCTe;
    property PathRetConsSitCTe: String  read FPathRetConsSitCTe  write FPathRetConsSitCTe;
    property tpAmb: TpcnTipoAmbiente    read FtpAmb              write FtpAmb;
    property verAplic: String           read FverAplic           write FverAplic;
    property chCTe: String              read FchCTe              write FchCTe;
    property dhRecbto: TDateTime        read FdhRecbto           write FdhRecbto;
    property nProt: String              read FnProt              write FnProt;
    property digVal: String             read FdigVal             write FdigVal;
    property cStat: Integer             read FcStat              write FcStat;
    property xMotivo: String            read FxMotivo            write FxMotivo;
    property Id: String                 read FId                 write FId;
    property Versao: String             read FVersao             write FVersao;
    property cMsg: Integer              read FcMsg               write FcMsg;
    property xMsg: String               read FxMsg               write FxMsg;
    // Usando na Montagem do cteProc
    property XML_CTe: String            read FXML_CTe            write FXML_CTe;
    property XML_prot: String           read FXML_prot           write FXML_prot;
  end;

implementation

uses
  pcnAuxiliar, ACBrUtil;

{ TProcCTe }

constructor TProcCTe.Create;
begin
  inherited Create;
  FGerador := TGerador.Create;
end;

destructor TProcCTe.Destroy;
begin
  FGerador.Free;
  inherited;
end;
(*
function TProcCTe.ObterNomeArquivo(const PadraoNome: TPcnPadraoNomeProcCTe = tpnPrivado): String;
begin
  Result := FchCTe + '-procCTe.xml';
  if PadraoNome = tpnPublico then
  begin
    Result := FnProt + '_v' + Versao + '-procCTe.xml';
  end;
end;
*)
function TProcCTe.GerarXML: boolean;

function PreencherTAG(const TAG: String; Texto: String): String;
begin
  result := '<' + TAG + '>' + RetornarConteudoEntre(Texto, '<' + TAG + '>', '</' + TAG + '>') + '</' + TAG + '>';
end;

var
  XMLCTe: TStringList;
  XMLinfProt: TStringList;
  XMLinfProt2: TStringList;
  wCstat: String;
  xProtCTe: String;
  xId: String;
  LocLeitor: TLeitor;
  i: Integer;
  ProtLido: Boolean; // Protocolo lido do Arquivo
  Modelo: Integer;
begin
  XMLCTe      := TStringList.Create;
  XMLinfProt  := TStringList.Create;
  XMLinfProt2 := TStringList.Create;
  Gerador.ListaDeAlertas.Clear;

  try
    if (FXML_CTe = '') and (FXML_prot = '') then
    begin
      ProtLido := False;
      xProtCTe := '';
      FnProt := '';

      // Arquivo CTe
      if not FileExists(FPathCTe) then
        Gerador.wAlerta('XR04', 'CTe', 'CTe', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
      else
        XMLCTe.LoadFromFile(FPathCTe);

      FchCTe := RetornarConteudoEntre(XMLCTe.Text, 'Id="CTe', '"');
      if trim(FchCTe) = '' then
        Gerador.wAlerta('XR01', 'ID/CTe', 'Numero da chave do CTe', ERR_MSG_VAZIO);

      if (FPathRetConsReciCTe = '') and (FPathRetConsSitCTe = '') then
      begin
        if (FchCTe = '') and (FnProt = '') then
          Gerador.wAlerta('XR06', 'RECIBO/SITUA��O', 'RECIBO/SITUA��O', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else
          ProtLido := True;
      end;

      // Gerar arquivo pelo Recibo do CTe
      if (FPathRetConsReciCTe <> '') and (FPathRetConsSitCTe = '') and
         (not ProtLido) then
      begin
        if not FileExists(FPathRetConsReciCTe) then
          Gerador.wAlerta('XR06', 'PROTOCOLO', 'PROTOCOLO', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else begin
          I := 0;
          LocLeitor := TLeitor.Create;
          try
            LocLeitor.CarregarArquivo(FPathRetConsReciCTe);
            while LocLeitor.rExtrai(1, 'protCTe', '', i + 1) <> '' do
            begin
              if LocLeitor.rCampo(tcStr, 'chCTe') = FchCTe then
                FnProt := LocLeitor.rCampo(tcStr, 'nProt');
              if trim(FnProt) = '' then
                Gerador.wAlerta('XR01', 'PROTOCOLO/CTe', 'Numero do protocolo', ERR_MSG_VAZIO)
              else begin
                xProtCTe := LocLeitor.rExtrai(1, 'protCTe', '', i + 1); // +'</protCTe>';
                Gerador.ListaDeAlertas.Clear;
                break;
              end;
              inc(I);
            end;
          finally
            LocLeitor.Free;
          end;
        end;
      end;

      // Gerar arquivo pelo arquivo de consulta da situa��o do CTe
      if (FPathRetConsReciCTe = '') and (FPathRetConsSitCTe <> '') and
         (not ProtLido) then
      begin
        if not FileExists(FPathRetConsSitCTe) then
          Gerador.wAlerta('XR06', 'SITUA��O', 'SITUA��O', ERR_MSG_ARQUIVO_NAO_ENCONTRADO)
        else begin
          XMLinfProt.LoadFromFile(FPathRetConsSitCTe);

          wCstat:=RetornarConteudoEntre(XMLinfProt.text, '<cStat>', '</cStat>');
          if trim(wCstat) = '101' then
          begin //esta cancelada
            XMLinfProt2.Text := RetornarConteudoEntre(XMLinfProt.text, '<infCanc', '</infCanc>');
            // Na vers�o 2.00 pode n�o constar o grupo infCanc no retConsSitCTe
            if XMLinfProt2.Text = '' then
              XMLinfProt2.Text := RetornarConteudoEntre(XMLinfProt.text, '<infProt', '</infProt>');
          end
          else
            XMLinfProt2.Text := RetornarConteudoEntre(XMLinfProt.text, '<infProt', '</infProt>');

          xId := RetornarConteudoEntre(XMLinfProt2.text, 'Id="', '">');

          xProtCTe :=
                '<protCTe versao="' + Versao + '">' +
                  '<infProt' + IIf( (xId <> ''), ' Id="' + xId + '">', '>') +
                    PreencherTAG('tpAmb',    XMLinfProt2.text) +
                    PreencherTAG('verAplic', XMLinfProt2.text) +
                    PreencherTAG('chCTe',    XMLinfProt2.text) +
                    PreencherTAG('dhRecbto', XMLinfProt2.text) +
                    PreencherTAG('nProt',    XMLinfProt2.text) +
                    PreencherTAG('digVal',   XMLinfProt2.text) +
                    PreencherTAG('cStat',    XMLinfProt2.text) +
                    PreencherTAG('xMotivo',  XMLinfProt2.text) +
                  '</infProt>' +
                  IIF( (PreencherTAG('cMsg', XMLinfProt2.text) <> ''),
                  '<infFisco>' +
                    PreencherTAG('cMsg', XMLinfProt2.text) +
                    PreencherTAG('xMsg', XMLinfProt2.text) +
                  '</infFisco>',
                  '') +
                '</protCTe>';
        end;
      end;

      if ProtLido then
      begin
        xProtCTe :=
              '<protCTe versao="' + Versao + '">' +
                '<infProt' + IIf( (FId <> ''), ' Id="' + FId + '">', '>') +
                  '<tpAmb>' + TpAmbToStr(FtpAmb) + '</tpAmb>' +
                  '<verAplic>' + FverAplic + '</verAplic>' +
                  '<chCTe>' + FchCTe + '</chCTe>' +
                  '<dhRecbto>' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', FdhRecbto) + '</dhRecbto>' +
                  '<nProt>' + FnProt + '</nProt>' +
                  '<digVal>' + FdigVal + '</digVal>' +
                  '<cStat>' + IntToStr(FcStat) + '</cStat>' +
                  '<xMotivo>' + FxMotivo + '</xMotivo>' +
                '</infProt>' +
                IIF( (cMsg > 0) or (xMsg <> ''),
                '<infFisco>' +
                  '<cMsg>' + IntToStr(FcMsg) + '</cMsg>' +
                  '<xMsg>' + FxMsg + '</xMsg>' +
                '</infFisco>',
                '') +
              '</protCTe>';
      end;

      FXML_CTe := XMLCTe.Text;
      FXML_prot := xProtCTe;
    end;

    // Gerar arquivo
    if (Gerador.ListaDeAlertas.Count = 0) and
       (FXML_CTe <> '') and (FXML_prot <> '') then
    begin
      FchCTe := RetornarConteudoEntre(FXML_CTe, 'Id="CTe', '"');

      Modelo := StrToIntDef(ExtrairModeloChaveAcesso(FchCTe), 57);

      Gerador.ArquivoFormatoXML := '';
      Gerador.wGrupo(ENCODING_UTF8, '', False);
      if Modelo = 57 then
      begin
        Gerador.wGrupo('cteProc versao="' + Versao + '" ' + NAME_SPACE_CTE, '');
        Gerador.wTexto('<CTe xmlns' + RetornarConteudoEntre(FXML_CTe, '<CTe xmlns', '</CTe>') + '</CTe>');
        Gerador.wTexto(FXML_prot);
        Gerador.wGrupo('/cteProc');
      end
      else
      begin
        Gerador.wGrupo('cteOSProc versao="' + Versao + '" ' + NAME_SPACE_CTE, '');
        Gerador.wTexto('<CTeOS xmlns' + RetornarConteudoEntre(FXML_CTe, '<CTeOS xmlns', '</CTeOS>') + '</CTeOS>');
        Gerador.wTexto(FXML_prot);
        Gerador.wGrupo('/cteOSProc');
      end;
    end;

    Result := (Gerador.ListaDeAlertas.Count = 0);

  finally
    XMLCTe.Free;
    XMLinfProt.Free;
    XMLinfProt2.Free;
  end;
end;

end.

