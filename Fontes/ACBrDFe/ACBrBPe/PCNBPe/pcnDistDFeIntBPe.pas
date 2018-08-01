////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//              PCN - Projeto Cooperar BPe                                    //
//                                                                            //
//   Descri��o: Classes para gera��o/leitura dos arquivos xml do BPe          //
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
|* 20/06/2017: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pcnDistDFeIntBPe;

interface

uses
  SysUtils, Classes, pcnConversao, pcnGerador, pcnConsts;

type

  TDistDFeInt = class(TPersistent)
  private
    FGerador: TGerador;
    FVersao: String;
    FtpAmb: TpcnTipoAmbiente;
    FcUFAutor: Integer;
    FCNPJCPF: String;
    FultNSU: String;
    // Usado no Grupo de informa��es para consultar um DF-e a partir de um
    // NSU espec�fico.
    FNSU: String;
    // Usado no Grupo de informa��es para consultar um DF-e a partir de uma
    // chave de BP-e espec�fica.
    FchBPe: String;
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
  published
    property Gerador: TGerador       read FGerador  write FGerador;
    property Versao: String          read FVersao   write FVersao;
    property tpAmb: TpcnTipoAmbiente read FtpAmb    write FtpAmb;
    property cUFAutor: Integer       read FcUFAutor write FcUFAutor;
    property CNPJCPF: String         read FCNPJCPF  write FCNPJCPF;
    property ultNSU: String          read FultNSU   write FultNSU;
    property NSU: String             read FNSU      write FNSU;
    property chBPe: String           read FchBPe    write FchBPe;
  end;

implementation

uses
  pcnAuxiliar;

{ TDistDFeInt }

constructor TDistDFeInt.Create;
begin
  FGerador := TGerador.Create;
end;

destructor TDistDFeInt.Destroy;
begin
  FGerador.Free;
  inherited;
end;

function TDistDFeInt.GerarXML: Boolean;
var
 sNSU: String;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('BPeDadosMsg');
  Gerador.wGrupo('distDFeInt ' + NAME_SPACE_BPE + ' versao="' + Versao + '"');
  Gerador.wCampo(tcStr, 'A03', 'tpAmb   ', 01, 01, 1, tpAmbToStr(FtpAmb), DSC_TPAMB);
  Gerador.wCampo(tcInt, 'A04', 'cUFAutor', 02, 02, 0, FcUFAutor, DSC_UF);
  Gerador.wCampoCNPJCPF('A05', 'A06', FCNPJCPF);

  if FNSU = '' then
  begin
    if FchBPe = '' then
    begin
      sNSU := IntToStrZero(StrToIntDef(FultNSU, 0), 15);
      Gerador.wGrupo('distNSU');
      Gerador.wCampo(tcStr, 'A08', 'ultNSU', 01, 15, 1, sNSU, DSC_ULTNSU);
      Gerador.wGrupo('/distNSU');
    end
    else begin
      Gerador.wGrupo('consChBPe');
      Gerador.wCampo(tcStr, 'A12', 'chBPe', 44, 44, 1, FchBPe, DSC_CHAVE);

      if not ValidarChave(FchBPe) then
        Gerador.wAlerta('A12', 'chBPe', '', 'Chave de BPe inv�lida');

      Gerador.wGrupo('/consChBPe');
    end;
  end
  else
  begin
    sNSU := IntToStrZero(StrToIntDef(FNSU, 0), 15);
    Gerador.wGrupo('consNSU');
    Gerador.wCampo(tcStr, 'A10', 'NSU', 01, 15, 1, sNSU, DSC_NSU);
    Gerador.wGrupo('/consNSU');
  end;

  Gerador.wGrupo('/distDFeInt');
  Gerador.wGrupo('/BPeDadosMsg');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

end.

