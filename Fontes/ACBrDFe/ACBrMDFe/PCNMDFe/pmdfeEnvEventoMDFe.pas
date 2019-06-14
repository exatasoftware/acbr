{******************************************************************************}
{ Projeto: Componente ACBrMDFe                                                 }
{  Biblioteca multiplataforma de componentes Delphi                            }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
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
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{*******************************************************************************
|* Historico
|*
|* 01/08/2012: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit pmdfeEnvEventoMDFe;

interface

uses
  SysUtils, Classes, Contnrs,
//{$IFNDEF VER130}
//  Variants,
//{$ENDIF}
  pcnConversao, pcnGerador, pcnConsts, //pcnLeitor,
  pmdfeEventoMDFe, pcnSignature;

type
  EventoException          = class(Exception);

  TInfEventoCollectionItem = class(TObject)
  private
    FInfEvento: TInfEvento;
    FRetInfEvento: TRetInfEvento;
    Fsignature: Tsignature;
  public
    constructor Create;
    destructor Destroy; override;
    property InfEvento: TInfEvento       read FInfEvento    write FInfEvento;
    property signature: Tsignature       read Fsignature    write Fsignature;
    property RetInfEvento: TRetInfEvento read FRetInfEvento write FRetInfEvento;
  end;

  TInfEventoCollection = class(TObjectList)
  private
    function GetItem(Index: Integer): TInfEventoCollectionItem;
    procedure SetItem(Index: Integer; Value: TInfEventoCollectionItem);
  public
    function Add: TInfEventoCollectionItem; overload; deprecated {$IfDef SUPPORTS_DEPRECATED_DETAILS} 'Obsoleta: Use a fun��o New'{$EndIf};
    function New: TInfEventoCollectionItem;
    property Items[Index: Integer]: TInfEventoCollectionItem read GetItem write SetItem; default;
  end;

  { TEventoMDFe }

  TEventoMDFe = class(TObject)
  private
    FGerador: TGerador;
    FidLote: Integer;
    FEvento: TInfEventoCollection;
    FVersao: String;
    
    procedure SetEvento(const Value: TInfEventoCollection);
  public
    constructor Create;
    destructor Destroy; override;
    function GerarXML: Boolean;
    function LerXML(const CaminhoArquivo: String): Boolean;
    function LerXMLFromString(const AXML: String): Boolean;
    function ObterNomeArquivo(tpEvento: TpcnTpEvento): String;
    function LerFromIni(const AIniString: String): Boolean;
    property Gerador: TGerador             read FGerador write FGerador;
    property idLote: Integer               read FidLote  write FidLote;
    property Evento: TInfEventoCollection  read FEvento  write SetEvento;
    property Versao: String                read FVersao  write FVersao;
  end;

implementation

uses
  IniFiles,
  pcnAuxiliar, pmdfeRetEnvEventoMDFe,  pmdfeConversaoMDFe,
  ACBrUtil, ACBrDFeUtil;

{ TEventoMDFe }

constructor TEventoMDFe.Create;
begin
  inherited Create;
  FGerador   := TGerador.Create;
  FEvento    := TInfEventoCollection.Create;
end;

destructor TEventoMDFe.Destroy;
begin
  FGerador.Free;
  FEvento.Free;
  inherited;
end;

function TEventoMDFe.GerarXML: Boolean;
var
  sDoc: String;
begin
  Gerador.ArquivoFormatoXML := '';
  Gerador.wGrupo('eventoMDFe ' + NAME_SPACE_MDFE + ' versao="' + Versao + '"');

  Evento.Items[0].InfEvento.Id := 'ID'+ Evento.Items[0].InfEvento.TipoEvento +
                                        OnlyNumber(Evento.Items[0].InfEvento.chMDFe) +
                                        Format('%.2d', [Evento.Items[0].InfEvento.nSeqEvento]);

  Gerador.wGrupo('infEvento Id="' + Evento.Items[0].InfEvento.id + '"');
  if Length(Evento.Items[0].InfEvento.Id) < 54
   then Gerador.wAlerta('EP04', 'ID', '', 'ID de Evento inv�lido');

  Gerador.wCampo(tcInt, 'EP05', 'cOrgao', 1, 2, 1, Evento.Items[0].InfEvento.cOrgao);
  Gerador.wCampo(tcStr, 'EP06', 'tpAmb ', 1, 1, 1, TpAmbToStr(Evento.Items[0].InfEvento.tpAmb), DSC_TPAMB);

  sDoc := OnlyNumber(Evento.Items[0].InfEvento.CNPJCPF);

  case Length(sDoc) of
    14: begin
         Gerador.wCampo(tcStr, 'EP07', 'CNPJ', 14, 14, 1, sDoc , DSC_CNPJ);
         if not ValidarCNPJ(sDoc) then Gerador.wAlerta('HP10', 'CNPJ', DSC_CNPJ, ERR_MSG_INVALIDO);
        end;
    11: begin
         Gerador.wCampo(tcStr, 'EP07', 'CPF ', 11, 11, 1, sDoc, DSC_CPF);
         if not ValidarCPF(sDoc) then Gerador.wAlerta('HP11', 'CPF', DSC_CPF, ERR_MSG_INVALIDO);
        end;
  end;

  Gerador.wCampo(tcStr, 'EP08', 'chMDFe', 44, 44, 1, Evento.Items[0].InfEvento.chMDFe, DSC_CHAVE);

  if not ValidarChave(Evento.Items[0].InfEvento.chMDFe)
   then Gerador.wAlerta('EP08', 'chMDFe', '', 'Chave de MDFe inv�lida');

  if Versao = '3.00' then
    Gerador.wCampo(tcStr, 'EP09', 'dhEvento', 01, 25, 1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Evento.Items[0].InfEvento.dhEvento)
                                                             + GetUTC(CodigoParaUF(Evento.Items[0].InfEvento.cOrgao),
                                                                       Evento.Items[0].InfEvento.dhEvento))
  else
    Gerador.wCampo(tcStr, 'EP09', 'dhEvento', 01, 25, 1, FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', Evento.Items[0].InfEvento.dhEvento));

  Gerador.wCampo(tcInt, 'EP10', 'tpEvento  ', 6, 6, 1, Evento.Items[0].InfEvento.TipoEvento);
  Gerador.wCampo(tcInt, 'EP11', 'nSeqEvento', 1, 2, 1, Evento.Items[0].InfEvento.nSeqEvento);

  Gerador.wGrupo('detEvento versaoEvento="' + Versao + '"');
  case Evento.Items[0].InfEvento.tpEvento of
   teCancelamento:
     begin
       Gerador.wGrupo('evCancMDFe');
       Gerador.wCampo(tcStr, 'EP02', 'descEvento', 005, 012, 1, Evento.Items[0].InfEvento.DescEvento);
       Gerador.wCampo(tcStr, 'EP03', 'nProt     ', 015, 015, 1, Evento.Items[0].InfEvento.detEvento.nProt);
       Gerador.wCampo(tcStr, 'EP04', 'xJust     ', 015, 255, 1, Evento.Items[0].InfEvento.detEvento.xJust);
       Gerador.wGrupo('/evCancMDFe');
     end;
   teEncerramento:
     begin
       Gerador.wGrupo('evEncMDFe');
       Gerador.wCampo(tcStr, 'EP02', 'descEvento', 05, 12, 1, Evento.Items[0].InfEvento.DescEvento);
       Gerador.wCampo(tcStr, 'EP03', 'nProt     ', 15, 15, 1, Evento.Items[0].InfEvento.detEvento.nProt);
       Gerador.wCampo(tcDat, 'EP04', 'dtEnc     ', 10, 10, 1, Evento.Items[0].InfEvento.detEvento.dtEnc);
       Gerador.wCampo(tcInt, 'EP05', 'cUF       ', 02, 02, 1, Evento.Items[0].InfEvento.detEvento.cUF);
       Gerador.wCampo(tcInt, 'EP06', 'cMun      ', 07, 07, 1, Evento.Items[0].InfEvento.detEvento.cMun);
       Gerador.wGrupo('/evEncMDFe');
     end;
   teInclusaoCondutor:
     begin
       Gerador.wGrupo('evIncCondutorMDFe');
       Gerador.wCampo(tcStr, 'EP02', 'descEvento', 05, 12, 1, Evento.Items[0].InfEvento.DescEvento);
       Gerador.wGrupo('condutor');
       Gerador.wCampo(tcStr, 'EP04', 'xNome     ', 01, 60, 1, Evento.Items[0].InfEvento.detEvento.xNome);
       Gerador.wCampo(tcStr, 'EP05', 'CPF       ', 11, 11, 1, Evento.Items[0].InfEvento.detEvento.CPF);
       Gerador.wGrupo('/condutor');
       Gerador.wGrupo('/evIncCondutorMDFe');
     end;
  end;
  Gerador.wGrupo('/detEvento');
  Gerador.wGrupo('/infEvento');

  if Evento.Items[0].signature.URI <> '' then
  begin
    Evento.Items[0].signature.Gerador.Opcoes.IdentarXML := Gerador.Opcoes.IdentarXML;
    Evento.Items[0].signature.GerarXML;
    Gerador.ArquivoFormatoXML := Gerador.ArquivoFormatoXML + Evento.Items[0].signature.Gerador.ArquivoFormatoXML;
  end;

  Gerador.wGrupo('/eventoMDFe');

  Result := (Gerador.ListaDeAlertas.Count = 0);
end;

procedure TEventoMDFe.SetEvento(const Value: TInfEventoCollection);
begin
  FEvento.Assign(Value);
end;

function TEventoMDFe.LerXML(const CaminhoArquivo: String): Boolean;
var
  ArqEvento: TStringList;
begin
  ArqEvento := TStringList.Create;
  try
     ArqEvento.LoadFromFile(CaminhoArquivo);
     Result := LerXMLFromString(ArqEvento.Text);
  finally
     ArqEvento.Free;
  end;
end;

function TEventoMDFe.LerXMLFromString(const AXML: String): Boolean;
var
  RetEventoMDFe: TRetEventoMDFe;
begin
  RetEventoMDFe := TRetEventoMDFe.Create;
  try
     RetEventoMDFe.Leitor.Arquivo := AXML;
     Result := RetEventoMDFe.LerXml;
     with FEvento.New do
      begin
        infEvento.Id         := RetEventoMDFe.InfEvento.Id;
        InfEvento.cOrgao     := RetEventoMDFe.InfEvento.cOrgao;
        infEvento.tpAmb      := RetEventoMDFe.InfEvento.tpAmb;
        infEvento.CNPJCPF    := RetEventoMDFe.InfEvento.CNPJCPF;
        infEvento.chMDFe     := RetEventoMDFe.InfEvento.chMDFe;
        infEvento.dhEvento   := RetEventoMDFe.InfEvento.dhEvento;
        infEvento.tpEvento   := RetEventoMDFe.InfEvento.tpEvento;
        infEvento.nSeqEvento := RetEventoMDFe.InfEvento.nSeqEvento;

        infEvento.VersaoEvento         := RetEventoMDFe.InfEvento.VersaoEvento;
        infEvento.detEvento.descEvento := RetEventoMDFe.InfEvento.detEvento.descEvento;
        infEvento.detEvento.nProt      := RetEventoMDFe.InfEvento.detEvento.nProt;
        infEvento.detEvento.dtEnc      := RetEventoMDFe.InfEvento.detEvento.dtEnc;
        infEvento.detEvento.cUF        := RetEventoMDFe.InfEvento.detEvento.cUF;
        infEvento.detEvento.cMun       := RetEventoMDFe.InfEvento.detEvento.cMun;
        infEvento.detEvento.xJust      := RetEventoMDFe.InfEvento.detEvento.xJust;
        infEvento.detEvento.xNome      := RetEventoMDFe.InfEvento.detEvento.xNome;
        infEvento.detEvento.CPF        := RetEventoMDFe.InfEvento.detEvento.CPF;

        signature.URI             := RetEventoMDFe.signature.URI;
        signature.DigestValue     := RetEventoMDFe.signature.DigestValue;
        signature.SignatureValue  := RetEventoMDFe.signature.SignatureValue;
        signature.X509Certificate := RetEventoMDFe.signature.X509Certificate;

        if RetEventoMDFe.retEvento.Count > 0 then
         begin
           FRetInfEvento.Id          := RetEventoMDFe.retEvento.Items[0].RetInfEvento.Id;
           FRetInfEvento.tpAmb       := RetEventoMDFe.retEvento.Items[0].RetInfEvento.tpAmb;
           FRetInfEvento.verAplic    := RetEventoMDFe.retEvento.Items[0].RetInfEvento.verAplic;
           FRetInfEvento.cOrgao      := RetEventoMDFe.retEvento.Items[0].RetInfEvento.cOrgao;
           FRetInfEvento.cStat       := RetEventoMDFe.retEvento.Items[0].RetInfEvento.cStat;
           FRetInfEvento.xMotivo     := RetEventoMDFe.retEvento.Items[0].RetInfEvento.xMotivo;
           FRetInfEvento.chMDFe      := RetEventoMDFe.retEvento.Items[0].RetInfEvento.chMDFe;
           FRetInfEvento.tpEvento    := RetEventoMDFe.retEvento.Items[0].RetInfEvento.tpEvento;
           FRetInfEvento.xEvento     := RetEventoMDFe.retEvento.Items[0].RetInfEvento.xEvento;
           FRetInfEvento.nSeqEvento  := RetEventoMDFe.retEvento.Items[0].RetInfEvento.nSeqEvento;
           FRetInfEvento.CNPJDest    := RetEventoMDFe.retEvento.Items[0].RetInfEvento.CNPJDest;
           FRetInfEvento.emailDest   := RetEventoMDFe.retEvento.Items[0].RetInfEvento.emailDest;
           FRetInfEvento.dhRegEvento := RetEventoMDFe.retEvento.Items[0].RetInfEvento.dhRegEvento;
           FRetInfEvento.nProt       := RetEventoMDFe.retEvento.Items[0].RetInfEvento.nProt;
           FRetInfEvento.XML         := RetEventoMDFe.retEvento.Items[0].RetInfEvento.XML;
         end;
      end;
  finally
     RetEventoMDFe.Free;
  end;
end;

function TEventoMDFe.ObterNomeArquivo(tpEvento: TpcnTpEvento): String;
begin
  case tpEvento of
    teCancelamento:     Result := Evento.Items[0].InfEvento.chMDFe + '-can-eve.xml';
    teEncerramento:     Result := Evento.Items[0].InfEvento.chMDFe + '-ped-eve.xml';
    teInclusaoCondutor: Result := Evento.Items[0].InfEvento.chMDFe + '-inc-eve.xml';
  else
    raise EventoException.Create('Obter nome do arquivo de Evento n�o Implementado!');
  end;
end;

function TEventoMDFe.LerFromIni(const AIniString: String): Boolean;
var
  I: Integer;
  sSecao, sFim: String;
  INIRec: TMemIniFile;
  Ok: Boolean;
begin
  Self.Evento.Clear;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    idLote := INIRec.ReadInteger('EVENTO', 'idLote', 0);

    I := 1;
    while true do
    begin
      sSecao := 'EVENTO'+IntToStrZero(I,3);
      sFim   := INIRec.ReadString(sSecao, 'chMDFe', 'FIM');
      if (sFim = 'FIM') or (Length(sFim) <= 0) then
        break;

      with Self.Evento.New do
      begin
        infEvento.chMDFe     := INIRec.ReadString(sSecao, 'chMDFe', '');
        infEvento.cOrgao     := INIRec.ReadInteger(sSecao, 'cOrgao', 0);
        infEvento.CNPJCPF    := INIRec.ReadString(sSecao, 'CNPJCPF', '');
        infEvento.dhEvento   := StringToDateTime(INIRec.ReadString(sSecao, 'dhEvento', ''));
        infEvento.tpEvento   := StrToTpEventoMDFe(Ok, INIRec.ReadString(sSecao, 'tpEvento', ''));
        infEvento.nSeqEvento := INIRec.ReadInteger(sSecao, 'nSeqEvento', 1);

        // Usado no detalhamento do evento
        infEvento.detEvento.xJust := INIRec.ReadString(sSecao, 'xJust', '');
        infEvento.detEvento.nProt := INIRec.ReadString(sSecao, 'nProt', '');
        InfEvento.detEvento.dtEnc := StringToDateTime(INIRec.ReadString(sSecao, 'dtEnc', ''));
        InfEvento.detEvento.cUF   := INIRec.ReadInteger(sSecao, 'cUF', 0);
        InfEvento.detEvento.cMun  := INIRec.ReadInteger(sSecao, 'cMun', 0);
        infEvento.detEvento.xNome := INIRec.ReadString(sSecao, 'xNome', '');
        infEvento.detEvento.CPF   := INIRec.ReadString(sSecao, 'CPF', '');
      end;
      Inc(I);
    end;

  finally
    INIRec.Free;
  end;
  Result := True;
end;

{ TInfEventoCollection }

function TInfEventoCollection.Add: TInfEventoCollectionItem;
begin
  Result := Self.New;
end;

function TInfEventoCollection.GetItem(
  Index: Integer): TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem(inherited GetItem(Index));
end;

procedure TInfEventoCollection.SetItem(Index: Integer;
  Value: TInfEventoCollectionItem);
begin
  inherited SetItem(Index, Value);
end;

function TInfEventoCollection.New: TInfEventoCollectionItem;
begin
  Result := TInfEventoCollectionItem.Create;
  Self.Add(Result);
end;

{ TInfEventoCollectionItem }

constructor TInfEventoCollectionItem.Create;
begin
  inherited Create;
  FInfEvento := TInfEvento.Create;
  Fsignature := Tsignature.Create;
  FRetInfEvento := TRetInfEvento.Create;
end;

destructor TInfEventoCollectionItem.Destroy;
begin
  FInfEvento.Free;
  Fsignature.Free;
  FRetInfEvento.Free;
  inherited;
end;

end.
