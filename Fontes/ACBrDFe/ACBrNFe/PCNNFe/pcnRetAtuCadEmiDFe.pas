////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar NFe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml da NFe          //
//                                                                            //
//        site: www.projetocooperar.org/nfe                                   //
//       email: projetocooperar@zipmail.com.br                                //
//       forum: http://br.groups.yahoo.com/group/projeto_cooperar_nfe/        //
//     projeto: http://code.google.com/p/projetocooperar/                     //
//         svn: http://projetocooperar.googlecode.com/svn/trunk/              //
//                                                                            //
// Coordena��o: Paulo Casagrande                                              //
//                                                                            //
//      Equipe: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//      Vers�o: Vide o arquivo leiame.txt na pasta raiz do projeto            //
//                                                                            //
//     Licen�a: GNU General Public License (GNU GPL)                          //
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

unit pcnRetAtuCadEmiDFe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnLeitor;

type

  TretAtuCadEmiDFe = class(TPersistent)
  private
    FXML: TLeitor;
    FCNPJ: String;
    FresOpe: Integer;
    FUF: String;
    Fope: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function LerXml: Boolean;
  published
    property XML: TLeitor    read FXML    write FXML;
    property UF: String      read FUF     write FUF;
    property CNPJ: String    read FCNPJ   write FCNPJ;
    property ope: Integer    read Fope    write Fope;
    property resOpe: Integer read FresOpe write FresOpe;
  end;

implementation

{ TretAtuCadEmiDFe }

constructor TretAtuCadEmiDFe.Create;
begin
  FXML := TLeitor.Create;
end;

destructor TretAtuCadEmiDFe.Destroy;
begin
  FXML.Free;
  inherited;
end;

function TretAtuCadEmiDFe.LerXml: Boolean;
begin
  result := true;
  try
    (*N05*)FUF     := xml.rCampo(tcStr, 'UF');
    (*N06*)FCNPJ   := xml.rCampo(tcStr, 'CNPJ');
    (*N07*)Fope    := xml.rCampo(tcInt, 'ope');
    (*N08*)FresOpe := xml.rCampo(tcInt, 'resOpe');
  except
    result := false;
  end;
end;

end.

