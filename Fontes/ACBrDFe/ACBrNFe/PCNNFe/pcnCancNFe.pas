////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org                                       //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
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

{*******************************************************************************
|* Historico
|*
|* 28/09/2012: Italo
|*  - Revisado gera��o do XML e adicionado propriedade para controle de Vers�o
|*    do WebService Utilizado
*******************************************************************************}

{$I ACBr.inc}

unit pcnCancNFe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador, pcnConsts, pcnNFeConsts;

type

  TcancNFe = class(TPersistent)
  private
    FGerador: TGerador;
    FChave: String;
    FtpAmb: TpcnTipoAmbiente;
    FchNFe: String;
    FnProt: String;
    FxJust: String;
    FVersao: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function ObterNomeArquivo: String;
  published
    property Gerador: TGerador       read FGerador write FGerador;
    property Chave: String           read FChave   write FChave;
    property tpAmb: TpcnTipoAmbiente read FtpAmb   write FtpAmb;
    property chNFe: String           read FchNFe   write FchNFe;
    property nProt: String           read FnProt   write FnProt;
    property xJust: String           read FxJust   write FxJust;
    property Versao: String          read FVersao  write FVersao;
  end;

implementation

Uses pcnAuxiliar,
  ACBrUtil;

{ TcancNFe }

constructor TcancNFe.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TcancNFe.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TcancNFe.ObterNomeArquivo: String;
begin
  Result := OnlyNumber(FchNFe) + '-ped-can.xml';
end;

function TcancNFe.GerarXML: Boolean;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('cancNFe ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wGrupo('infCanc Id="ID' + OnlyNumber(FchNFe) + '"');
  Gerador.wCampo(tcStr, 'CP05', 'tpAmb', 001, 001, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'CP06', 'xServ', 008, 008, 1, 'CANCELAR', DSC_XSERV);
  Gerador.wCampo(tcEsp, 'CP07', 'chNFe', 044, 044, 1, OnlyNumber(FchNFe), DSC_CHNFE);
  if not ValidarChave(FchNFe) then
    Gerador.wAlerta('CP07', 'chNFe', '', 'Chave de NFe inv�lida');
  Gerador.wCampo(tcEsp, 'CP08', 'nProt', 015, 015, 1, OnlyNumber(FnProt), DSC_NPROT);
  Gerador.wCampo(tcStr, 'CP09', 'xJust', 015, 255, 1, FiltrarTextoXML(true, FxJust), DSC_XJUST);
  Gerador.wGrupo('/infCanc');
  Gerador.wGrupo('/cancNFe');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

