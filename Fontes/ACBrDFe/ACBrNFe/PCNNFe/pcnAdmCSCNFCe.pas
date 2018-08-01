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

{$I ACBr.inc}

unit pcnAdmCSCNFCe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador;

type

  TAdmCSCNFCe = class(TPersistent)
  private
    FGerador: TGerador;
    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FindOP: TpcnIndOperacao;
    FraizCNPJ: String;
    FidCsc: Integer;
    FcodigoCsc: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: boolean;
    function ObterNomeArquivo: String;
  published
    property Gerador: TGerador       read FGerador   write FGerador;
    property Versao: String          read FVersao    write FVersao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb     write FtpAmb;
    property indOP: TpcnIndOperacao  read FindOP     write FindOP;
    property raizCNPJ: String        read FraizCNPJ  write FraizCNPJ;
    property idCsc: Integer          read FidCsc     write FidCsc;
    property codigoCsc: String       read FcodigoCsc write FcodigoCsc;
  end;

const
  DSC_INDOP    = 'Indicador de Opera��o';
  DSC_RAIZCNPJ = 'Raiz do CNPJ';
  DSC_IDCSC    = 'Identificador do CSC';
  DSC_CODCSC   = 'C�digo do CSC';

implementation

Uses pcnAuxiliar;

{ TAdmCSCNFCe }

constructor TAdmCSCNFCe.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TAdmCSCNFCe.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TAdmCSCNFCe.ObterNomeArquivo: String;
var
  DataHora: TDateTime;
  Year, Month, Day, Hour, Min, Sec, Milli: Word;
  AAAAMMDDTHHMMSS: String;
begin
  Datahora:=now;
  DecodeTime(DataHora, Hour, Min, Sec, Milli);
  DecodeDate(DataHora, Year, Month, Day);
  AAAAMMDDTHHMMSS := IntToStrZero(Year, 4) + IntToStrZero(Month, 2) + IntToStrZero(Day, 2) +
    IntToStrZero(Hour, 2) + IntToStrZero(Min, 2) + IntToStrZero(Sec, 2);
  Result := AAAAMMDDTHHMMSS + '-ped-csc.xml';
end;

function TAdmCSCNFCe.GerarXML: boolean;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('admCscNFCe ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wCampo(tcStr, 'AP03', 'tpAmb   ', 01, 01, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcStr, 'AP04', 'indOp   ', 01, 01, 1, IndOperacaoToStr(FindOp), DSC_INDOP);
  Gerador.wCampo(tcStr, 'AP05', 'raizCNPJ', 08, 08, 1, FraizCNPJ, DSC_RAIZCNPJ);

  if FindOp = ioRevogaCSC then
  begin
    Gerador.wGrupo('dadosCsc');
    Gerador.wCampo(tcStr, 'AP07', 'idCsc    ', 06, 06, 1, FormatFloat('000000', FidCsc), DSC_IDCSC);
    Gerador.wCampo(tcStr, 'AP08', 'codigoCsc', 16, 16, 1, FcodigoCsc, DSC_CODCSC);
    Gerador.wGrupo('/dadosCsc');
  end;

  Gerador.wGrupo('/admCscNFCe');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

