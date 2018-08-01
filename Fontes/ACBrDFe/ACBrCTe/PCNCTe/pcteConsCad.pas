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

unit pcteConsCad;

interface

uses
  SysUtils, Classes, pcnAuxiliar, pcnConversao, pcnGerador, pcteConversaoCTe,
  pcnConsts;

type

  TConsCad = class(TPersistent)
  private
    FGerador: TGerador;
    FUF: String;
    FIE: String;
    FCNPJ: String;
    FCPF: String;
    FVersao: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
  published
    property Gerador: TGerador read FGerador write FGerador;
    property UF: String        read FUF      write FUF;
    property IE: String        read FIE      write FIE;
    property CNPJ: String      read FCNPJ    write FCNPJ;
    property CPF: String       read FCPF     write FCPF;
    property Versao: String    read FVersao  write FVersao;
  end;

implementation

{ TConsCad }

constructor TConsCad.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TConsCad.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TConsCad.GerarXML: Boolean;
var
  i: integer;
begin
  Gerador.ArquivoFormatoXML := '';

  Gerador.wGrupo('ConsCad ' + NAME_SPACE + ' versao="' + Versao + '"');
  Gerador.wGrupo('infCons');
  Gerador.wCampo(tcStr, 'GP04', 'xServ ', 008, 008, 1, 'CONS-CAD', DSC_XSERV);
  Gerador.wCampo(tcStr, 'GP05', 'UF    ', 002, 002, 1, FUF, DSC_UF);
  i := 0;
  if FIE <> EmptyStr then
   begin
    i := 1;
    Gerador.wCampo(tcStr, 'GP06', 'IE  ', 002, 014, 1, FIE, DSC_IE);
   end;
  if (FCNPJ <> EmptyStr) and (i = 0) then
   begin
    i := 1;
    Gerador.wCampoCNPJCPF('GP07', 'CNPJ', FCNPJ);
   end;
  if (FCPF <> EmptyStr) and (i = 0) then
    Gerador.wCampoCNPJCPF('GP08', 'CPF ', FCPF);
  Gerador.wGrupo('/infCons');
  Gerador.wGrupo('/ConsCad');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

