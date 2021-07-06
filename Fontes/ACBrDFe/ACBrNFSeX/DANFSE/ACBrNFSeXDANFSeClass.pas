{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2020 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo: Italo Giurizzato Junior                         }
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

{$I ACBr.inc}

unit ACBrNFSeXDANFSeClass;

interface

uses
  SysUtils, Classes,
  ACBrBase, ACBrDFeReport,
  ACBrNFSeXClass, ACBrNFSeXConversao;

type
  { TPrestadorConfig }
  TPrestadorConfig = class
  private
    FRazaoSocial: String;
    FNomeFantasia: String;
    FInscMunicipal: String;
    FCNPJ: String;
    FEndereco : String;
    FComplemento : String;
    FMunicipio : String;
    FUF : String;
    FEMail: String;
    FFone : String;
    FLogo: String;

  published
    property RazaoSocial: String read FRazaoSocial write FRazaoSocial;
    property NomeFantasia: String read FNomeFantasia write FNomeFantasia;
    property InscricaoMunicipal: String read FInscMunicipal write FInscMunicipal;
    property CNPJ: String read FCNPJ write FCNPJ;
    property Endereco: String read FEndereco write FEndereco;
    property Complemento: String read FComplemento write FComplemento;
    property Municipio: String read FMunicipio write FMunicipio;
    property UF: String read FUF write FUF;
    property Fone: String read FFone write FFone;
    property EMail: String read FEMail write FEMail;
    property Logo: String read FLogo write FLogo;

  end;

  { TTomadorConfig }
  TTomadorConfig = class
  private
    FInscEstadual : String;
    FInscMunicipal : String;
    FFone          : String;
    FEndereco      : String;
    FComplemento   : String;
    FEmail         : String;

  published
    property InscricaoEstadual: String read FInscEstadual write FInscEstadual;
    property InscricaoMunicipal: String read FInscMunicipal write FInscMunicipal;
    property Fone: String read FFone write FFone;
    property Endereco: String read FEndereco write FEndereco;
    property Complemento: String read FComplemento write FComplemento;
    property Email: String read FEmail write FEmail;

  end;

  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(piacbrAllPlatforms)]
  {$ENDIF RTL230_UP}
  TACBrNFSeXDANFSeClass = class(TACBrDFeReport)
  private
    FProducao: TnfseSimNao;
    procedure SetACBrNFSe(const Value: TComponent);
    procedure ErroAbstract( const NomeProcedure: String );

  protected
    FACBrNFSe: TComponent;
    FPrefeitura: String;
    FOutrasInformacaoesImp : String;
    FFormatarNumeroDocumentoNFSe  : Boolean;
    FAtividade : String;
    FNFSeCancelada: boolean;
    FImprimeCanhoto: Boolean;
    FTipoDANFSE: TTipoDANFSE;
    FProvedor: TNFSeProvedor;
    FTamanhoFonte: Integer;
    FPrestador: TPrestadorConfig;
    FTomador: TTomadorConfig;


    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetSeparadorPathPDF(const aInitialPath: String): String; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure VisualizarDANFSe(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSe(NFSe: TNFSe = nil); virtual;
    procedure ImprimirDANFSePDF(NFSe: TNFSe = nil); virtual;

  published
    property ACBrNFSe: TComponent  read FACBrNFSe write SetACBrNFSe;
    property Prestador: TPrestadorConfig read FPrestador;
    property Tomador: TTomadorConfig read FTomador;
    property OutrasInformacaoesImp: String read FOutrasInformacaoesImp write FOutrasInformacaoesImp;
    property Prefeitura: String read FPrefeitura write FPrefeitura;
    property Atividade: String read FAtividade write FAtividade;
    property Cancelada: Boolean read FNFSeCancelada write FNFSeCancelada;
    property ImprimeCanhoto: Boolean read FImprimeCanhoto write FImprimeCanhoto default False;
    property TipoDANFSE: TTipoDANFSE read FTipoDANFSE   write FTipoDANFSE default tpPadrao;
    property Provedor: TNFSeProvedor read FProvedor     write FProvedor;
    property TamanhoFonte: Integer   read FTamanhoFonte write FTamanhoFonte;
    property FormatarNumeroDocumentoNFSe: Boolean read FFormatarNumeroDocumentoNFSe write FFormatarNumeroDocumentoNFSe;
    property Producao: TnfseSimNao   read FProducao     write FProducao;

  end;

implementation

uses
  ACBrNFSeX, ACBrUtil;

{ TACBrNFSeXDANFSeClass }

constructor TACBrNFSeXDANFSeClass.Create(AOwner: TComponent);
begin
  inherited create( AOwner );

  FACBrNFSe := nil;

  FPrestador := TPrestadorConfig.Create;
  FPrestador.RazaoSocial := '';
  FPrestador.Endereco := '';
  FPrestador.Complemento := '';
  FPrestador.Fone := '';
  FPrestador.Municipio := '';
  FPrestador.InscricaoMunicipal := '';
  FPrestador.EMail := '';
  FPrestador.Logo := '';
  FPrestador.UF := '';

  FTomador := TTomadorConfig.Create;
  FTomador.Fone := '';
  FTomador.Endereco := '';
  FTomador.Complemento := '';
  FTomador.Email := '';
  FTomador.InscricaoEstadual := '';
  FTomador.InscricaoMunicipal := '';

  FPrefeitura := '';
  FTamanhoFonte := 6;
  FOutrasInformacaoesImp := '';
  FAtividade := '';
  FFormatarNumeroDocumentoNFSe := True;
  FNFSeCancelada := False;
  FProvedor := proNenhum;
end;

destructor TACBrNFSeXDANFSeClass.Destroy;
begin
  FPrestador.Destroy;
  FTomador.Destroy;

  inherited Destroy;
end;

procedure TACBrNFSeXDANFSeClass.ErroAbstract(const NomeProcedure: String);
begin
  raise Exception.Create( NomeProcedure );
end;

procedure TACBrNFSeXDANFSeClass.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (FACBrNFSe <> nil) and (AComponent is TACBrNFSeX) then
    FACBrNFSe := nil;
end;

procedure TACBrNFSeXDANFSeClass.SetACBrNFSe(const Value: TComponent);
var
  OldValue: TACBrNFSeX;
begin
  if Value <> FACBrNFSe then
  begin
    if Value <> nil then
      if not (Value is TACBrNFSeX) then
        raise Exception.Create('ACBrDANFSe.NFSe deve ser do tipo TACBrNFSe');

    if Assigned(FACBrNFSe) then
      FACBrNFSe.RemoveFreeNotification(Self);

    OldValue  := TACBrNFSeX(FACBrNFSe);  // Usa outra variavel para evitar Loop Infinito
    FACBrNFSe := Value;                 // na remo��o da associa��o dos componentes

    if Assigned(OldValue) then
      if Assigned(OldValue.DANFSe) then
        OldValue.DANFSe := nil;

    if Value <> nil then
    begin
      Value.FreeNotification(self);
      TACBrNFSeX(Value).DANFSe := self;
    end;
  end;
end;

function TACBrNFSeXDANFSeClass.GetSeparadorPathPDF(const aInitialPath: String): String;
var
  dhEmissao: TDateTime;
  DescricaoModelo: String;
  ANFSe: TNFSe;
begin
  Result := aInitialPath;

  if Assigned(ACBrNFSe) then  // Se tem o componente ACBrNFSe
  begin
    if TACBrNFSeX(ACBrNFSe).NotasFiscais.Count > 0 then  // Se tem alguma Nota carregada
    begin
      ANFSe := TACBrNFSeX(ACBrNFSe).NotasFiscais.Items[0].NFSe;
      if TACBrNFSeX(ACBrNFSe).Configuracoes.Arquivos.EmissaoPathNFSe then
        dhEmissao := ANFSe.DataEmissao
      else
        dhEmissao := Now;

      DescricaoModelo := '';
      if TACBrNFSeX(ACBrNFSe).Configuracoes.Arquivos.AdicionarLiteral then
      begin
        DescricaoModelo := TACBrNFSeX(ACBrNFSe).GetNomeModeloDFe;
      end;

      Result := TACBrNFSeX(ACBrNFSe).Configuracoes.Arquivos.GetPath(
                Result, DescricaoModelo,
                OnlyNumber(ANFSe.Prestador.IdentificacaoPrestador.CNPJ),
                OnlyNumber(ANFSe.Prestador.IdentificacaoPrestador.InscricaoEstadual),
                dhEmissao);
    end;
  end;
end;

procedure TACBrNFSeXDANFSeClass.VisualizarDANFSe(NFSe: TNFSe);
begin
  ErroAbstract('VisualizarDANFSe');
end;

procedure TACBrNFSeXDANFSeClass.ImprimirDANFSe(NFSe: TNFSe);
begin
  ErroAbstract('ImprimirDANFSe');
end;

procedure TACBrNFSeXDANFSeClass.ImprimirDANFSePDF(NFSe: TNFSe);
begin
  ErroAbstract('ImprimirDANFSePDF');
end;

end.
