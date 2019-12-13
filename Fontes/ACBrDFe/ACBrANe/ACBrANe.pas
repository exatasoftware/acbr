{******************************************************************************}
{ Projeto: Componente ACBrANe                                                  }
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
|* 24/02/2016: Italo Jurisato Junior
|*  - Doa��o do componente para o Projeto ACBr
*******************************************************************************}

{$I ACBr.inc}

unit ACBrANe;

interface

uses
  Classes, SysUtils,
  ACBrUtil, ACBrDFe, ACBrDFeConfiguracoes, ACBrDFeException, ACBrBase,
  ACBrANeConfiguracoes, ACBrANeWebServices, ACBrANeDocumentos,
  pcnConversao, pcaConversao;

const
  ACBRANe_NAMESPACE = 'ATMWenSvr';
  ACBRANe_CErroAmbienteDiferente = 'Ambiente do XML (tpAmb) � diferente do '+
               'configurado no Componente (Configuracoes.WebServices.Ambiente)';

type
  EACBrANeException = class(EACBrDFeException);

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}

  TACBrANe = class(TACBrDFe)
  private
    FDocumentos: TDocumentos;
    FStatus: TStatusACBrANe;
    FWebServices: TWebServices;

    function GetConfiguracoes: TConfiguracoesANe;
    procedure SetConfiguracoes(AValue: TConfiguracoesANe);
  protected
    function CreateConfiguracoes: TConfiguracoes; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    function NomeServicoToNomeSchema(const NomeServico: String): String; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure EnviarEmail(const sPara, sAssunto: String;
      sMensagem: TStrings = nil; sCC: TStrings = nil; Anexos: TStrings = nil;
      StreamANe: TStream = nil; const NomeArq: String = ''; sReplyTo: TStrings = nil); override;

    function Enviar: Boolean;

    function AverbarCTe: Boolean;
    function AverbarNFe: Boolean;
    function DeclararMDFe: Boolean;
    function AddBackMail: Boolean;

    function GetNomeModeloDFe: String; override;
    function GetNameSpaceURI: String; override;

    function cStatConfirmado(AValue: integer): Boolean;
    function cStatProcessado(AValue: integer): Boolean;

    procedure LerServicoDeParams(LayOutServico: TLayOutANe; var Versao: Double;
      var URL: String); reintroduce; overload;
    function LerVersaoDeParams(LayOutServico: TLayOutANe): String; reintroduce; overload;

    function IdentificaSchema(const AXML: String): TSchemaANe;

    function GerarNomeArqSchema(const ALayOut: TLayOutANe; VersaoServico: Double): String;

    property WebServices: TWebServices read FWebServices write FWebServices;
    property Documentos: TDocumentos read FDocumentos write FDocumentos;
    property Status: TStatusACBrANe read FStatus;

    procedure SetStatus(const stNewStatus: TStatusACBrANe);

  published
    property Configuracoes: TConfiguracoesANe read GetConfiguracoes write SetConfiguracoes;
  end;

implementation

uses
  dateutils,
  pcnAuxiliar;

{$IFDEF FPC}
 {$R ACBrANeServicos.rc}
{$ELSE}
 {$R ACBrANeServicos.res}
{$ENDIF}

{ TACBrANe }

constructor TACBrANe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDocumentos := TDocumentos.Create(Self, Documento);
  FWebServices := TWebServices.Create(Self);
end;

destructor TACBrANe.Destroy;
begin
  FDocumentos.Free;
  FWebServices.Free;

  inherited;
end;

procedure TACBrANe.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  sCC: TStrings; Anexos: TStrings; StreamANe: TStream; const NomeArq: String;
  sReplyTo: TStrings);
begin
  SetStatus( stANeEmail );

  try
    inherited EnviarEmail(sPara, sAssunto, sMensagem, sCC, Anexos, StreamANe, NomeArq,
      sReplyTo);
  finally
    SetStatus( stANeIdle );
  end;
end;

procedure TACBrANe.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  {
  if (Operation = opRemove) and (FDAANe <> nil) and
     (AComponent is TACBrANeDAANeClass) then
    FDAANe := nil;
 }
end;

function TACBrANe.CreateConfiguracoes: TConfiguracoes;
begin
  Result := TConfiguracoesANe.Create(Self);
end;

function TACBrANe.GetNomeModeloDFe: String;
begin
  Result := 'ANe';
end;

function TACBrANe.GetNameSpaceURI: String;
begin
  Result := ACBRANe_NAMESPACE;
end;

function TACBrANe.cStatConfirmado(AValue: integer): Boolean;
begin
  case AValue of
    100, 150: Result := True;
    else
      Result := False;
  end;
end;

function TACBrANe.cStatProcessado(AValue: integer): Boolean;
begin
  case AValue of
    100, 110, 150, 301, 302: Result := True;
    else
      Result := False;
  end;
end;

function TACBrANe.IdentificaSchema(const AXML: String): TSchemaANe;
//var
// lTipoEvento: TpcnTpEvento;
// I: Integer;
// Ok: Boolean;
begin
  Result := schAverbacao;
(*
  Result := schANe;

  I := pos('<infANe', AXML);
  if I = 0 then
  begin
    I := pos('<infEvento', AXML);
    if I > 0 then
    begin
      lTipoEvento := StrToTpEvento(Ok, Trim(RetornarConteudoEntre(AXML, '<tpEvento>', '</tpEvento>')));

      case lTipoEvento of
        teCancelamento: Result := schevCancANe;
        teEncerramento: Result := schevEncANe;
        else Result := schevIncCondutorANe;
      end;
    end;
  end;
*)
end;

function TACBrANe.GerarNomeArqSchema(const ALayOut: TLayOutANe;
  VersaoServico: Double): String;
var
  NomeServico, NomeSchema, ArqSchema: String;
  Versao: Double;
begin
  // Procura por Vers�o na pasta de Schemas //
  NomeServico := LayOutToServico(ALayOut);
  NomeSchema := NomeServicoToNomeSchema(NomeServico);
  ArqSchema := '';
  if NaoEstaVazio(NomeSchema) then
  begin
    Versao := VersaoServico;
    AchaArquivoSchema( NomeSchema, Versao, ArqSchema );
  end;

  Result := ArqSchema;
end;

function TACBrANe.GetConfiguracoes: TConfiguracoesANe;
begin
  Result := TConfiguracoesANe(FPConfiguracoes);
end;

procedure TACBrANe.SetConfiguracoes(AValue: TConfiguracoesANe);
begin
  FPConfiguracoes := AValue;
end;

function TACBrANe.LerVersaoDeParams(LayOutServico: TLayOutANe): String;
var
  Versao: Double;
  UF: String;
begin
  // Para qual quer UF a URL � sempre a mesma.
  if Configuracoes.Geral.Seguradora = tsATM then
    UF := 'ATM'
  else
    UF := 'ELT';

  Versao := LerVersaoDeParams(GetNomeModeloDFe, UF,
    Configuracoes.WebServices.Ambiente, LayOutToServico(LayOutServico),
    VersaoANeToDbl(Configuracoes.Geral.VersaoDF));

  Result := FloatToString(Versao, '.', '0.00');
end;

function TACBrANe.NomeServicoToNomeSchema(const NomeServico: String): String;
//var
//  ok: Boolean;
//  ALayout: TLayOutANe;
begin
  Result := '';
  (*
  ALayout := ServicoToLayOut(ok, NomeServico);
  if ok then
    Result := SchemaANeToStr( LayOutToSchema( ALayout ) )
  else
    Result := '';
  *)  
end;

procedure TACBrANe.LerServicoDeParams(LayOutServico: TLayOutANe;
  var Versao: Double; var URL: String);
var
  UF: String;
begin
  Versao := VersaoANeToDbl(Configuracoes.Geral.VersaoDF);
  URL := '';
  // Para qual quer UF a URL � sempre a mesma.
  if Configuracoes.Geral.Seguradora = tsATM then
    UF := 'ATM'
  else
    UF := 'ELT';

  LerServicoDeParams(GetNomeModeloDFe, UF,
    Configuracoes.WebServices.Ambiente, LayOutToServico(LayOutServico),
    Versao, URL);
end;

procedure TACBrANe.SetStatus(const stNewStatus: TStatusACBrANe);
begin
  if stNewStatus <> FStatus then
  begin
    FStatus := stNewStatus;
    if Assigned(OnStatusChange) then
      OnStatusChange(Self);
  end;
end;

function TACBrANe.Enviar: Boolean;
begin
  case Configuracoes.Geral.TipoDoc of
    tdNFe:  AverbarNFe;
    tdCTe:  AverbarCTe;
    tdMDFe: DeclararMDFe;
  end;

  Result := WebServices.Envia;
end;

function TACBrANe.AverbarCTe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum CT-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de CT-e transmitidos (m�ximo de 1 CT-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));

  Documentos.Assinar;
end;

function TACBrANe.AverbarNFe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum NF-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de NF-e transmitidos (m�ximo de 1 NF-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));

  Documentos.Assinar;
end;

function TACBrANe.DeclararMDFe: Boolean;
begin
  Result := True;

  if Documentos.Count <= 0 then
    GerarException(ACBrStr('ERRO: Nenhum MDF-e adicionado'));

  if Documentos.Count > 1 then
    GerarException(ACBrStr('ERRO: Conjunto de MDF-e transmitidos (m�ximo de 1 MDF-e)' +
      ' excedido. Quantidade atual: ' + IntToStr(Documentos.Count)));

  Documentos.Assinar;
end;

function TACBrANe.AddBackMail: Boolean;
begin
  {a}
  Result := True;
end;

end.
