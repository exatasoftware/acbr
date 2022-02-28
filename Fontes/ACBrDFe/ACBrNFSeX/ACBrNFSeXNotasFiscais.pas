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

unit ACBrNFSeXNotasFiscais;

interface

uses
  Classes, SysUtils,
  {$IF DEFINED(HAS_SYSTEM_GENERICS)}
   System.Generics.Collections, System.Generics.Defaults,
  {$ELSEIF DEFINED(DELPHICOMPILER16_UP)}
   System.Contnrs,
  {$Else}
   Contnrs,
  {$IfEnd}
  ACBrBase, ACBrDFe, ACBrNFSeXConfiguracoes, ACBrNFSeXClass, ACBrNFSeXConversao;

type

  { TNotaFiscal }

  TNotaFiscal = class
  private
    FNFSe: TNFSe;
    FACBrNFSe: TACBrDFe;

    FAlertas: String;
    FNomeArq: String;
    FNomeArqRps: String;
    FConfirmada: Boolean;
    FXmlRps: String;
    FXmlNfse: String;

    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;
  public
    constructor Create(AOwner: TACBrDFe);
    destructor Destroy; override;

    procedure Imprimir;
    procedure ImprimirPDF;

    function LerXML(const AXML: String): Boolean;
    function LerArqIni(const AIniString: String): Boolean;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = '';
      const PathArquivo: String = ''; aTipo: TtpXML = txmlNFSe): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil; ManterPDFSalvo: Boolean = True);

    property NomeArq: String    read FNomeArq    write FNomeArq;
    property NomeArqRps: String read FNomeArqRps write FNomeArqRps;

    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NFSe: TNFSe read FNFSe;

    property XmlRps: String read FXmlRps write FXmlRps;
    property XmlNfse: String read FXmlNfse write FXmlNfse;

    property Confirmada: Boolean read FConfirmada write FConfirmada;
    property Alertas: String     read FAlertas;

  end;

  { TNotasFiscais }

  TNotasFiscais = class(TACBrObjectList)
  private
    FTransacao: Boolean;
    FNumeroLote: String;
    FACBrNFSe: TACBrDFe;
    FConfiguracoes: TConfiguracoesNFSe;
    FXMLLoteOriginal: String;
    FXMLLoteAssinado: String;
    FAlertas: String;

    function GetItem(Index: integer): TNotaFiscal;
    procedure SetItem(Index: integer; const Value: TNotaFiscal);

    procedure VerificarDANFSE;
  public
    constructor Create(AOwner: TACBrDFe);

    procedure GerarNFSe;
    procedure Imprimir;
    procedure ImprimirPDF;

    function New: TNotaFiscal; reintroduce;
    function Add(ANota: TNotaFiscal): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: TNotaFiscal); reintroduce;
    function FindByRps(ANumRPS: string): TNotaFiscal;
    function FindByNFSe(ANumNFSe: string): TNotaFiscal;

    property Items[Index: integer]: TNotaFiscal read GetItem write SetItem; default;

    function GetNamePath: String;

    // Incluido o Parametro AGerarNFSe que determina se ap�s carregar os dados da NFSe
    // para o componente, ser� gerado ou n�o novamente o XML da NFSe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromString(AXMLString: String; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;
    function LoadFromLoteNfse(const CaminhoArquivo: String): Boolean;

    function GravarXML(const PathNomeArquivo: String = ''): Boolean;

    property XMLLoteOriginal: String read FXMLLoteOriginal write FXMLLoteOriginal;
    property XMLLoteAssinado: String read FXMLLoteAssinado write FXMLLoteAssinado;
    property NumeroLote: String      read FNumeroLote      write FNumeroLote;
    property Transacao: Boolean      read FTransacao       write FTransacao;
    property Alertas: String         read FAlertas;

    property ACBrNFSe: TACBrDFe read FACBrNFSe;
  end;

  function CompRpsPorNumero(const Item1,
    Item2: {$IfDef HAS_SYSTEM_GENERICS}TObject{$Else}Pointer{$EndIf}): Integer;
  function CompNFSePorNumero(const Item1,
    Item2: {$IfDef HAS_SYSTEM_GENERICS}TObject{$Else}Pointer{$EndIf}): Integer;

implementation

uses
  synautil, IniFiles, StrUtilsEx,
  pcnAuxiliar,
  ACBrUtil,
  ACBrDFeUtil,
  ACBrNFSeX, ACBrNFSeXInterface;

function CompRpsPorNumero(const Item1,
  Item2: {$IfDef HAS_SYSTEM_GENERICS}TObject{$Else}Pointer{$EndIf}): Integer;
var
  NumRps1, NumRps2: Integer;
begin
  NumRps1 := StrToIntDef(TNotaFiscal(Item1).NFSe.IdentificacaoRps.Numero, 0);
  NumRps2 := StrToIntDef(TNotaFiscal(Item2).NFSe.IdentificacaoRps.Numero, 0);

  if NumRps1 < NumRps2 then
    Result := -1
  else if NumRps1 > NumRps2 then
    Result := 1
  else
    Result := 0;
end;

function CompNFSePorNumero(const Item1,
  Item2: {$IfDef HAS_SYSTEM_GENERICS}TObject{$Else}Pointer{$EndIf}): Integer;
var
  NumNFSe1, NumNFSe2: Int64;
begin
  NumNFSe1 := StrToInt64Def(TNotaFiscal(Item1).NFSe.Numero, 0);
  NumNFSe2 := StrToInt64Def(TNotaFiscal(Item2).NFSe.Numero, 0);

  if NumNFSe1 < NumNFSe2 then
    Result := -1
  else if NumNFSe1 > NumNFSe2 then
    Result := 1
  else
    Result := 0;
end;

{ TNotaFiscal }

constructor TNotaFiscal.Create(AOwner: TACBrDFe);
begin
  if not (AOwner is TACBrNFSeX) then
    raise EACBrNFSeException.Create('AOwner deve ser do tipo TACBrNFSeX');

  FACBrNFSe := TACBrNFSeX(AOwner);
  FNFSe := TNFSe.Create;
end;

destructor TNotaFiscal.Destroy;
begin
  FNFSe.Free;

  inherited Destroy;
end;

procedure TNotaFiscal.Imprimir;
begin
  with TACBrNFSeX(FACBrNFSe) do
  begin
    DANFSE.Provedor := Configuracoes.Geral.Provedor;

    if Configuracoes.WebServices.AmbienteCodigo = 1 then
      DANFSE.Producao := snSim
    else
      DANFSE.Producao := snNao;

    if not Assigned(DANFSE) then
      raise EACBrNFSeException.Create('Componente DANFSE n�o associado.')
    else
      DANFSE.ImprimirDANFSE(NFSe);
  end;
end;

procedure TNotaFiscal.ImprimirPDF;
begin
  with TACBrNFSeX(FACBrNFSe) do
  begin
    DANFSE.Provedor := Configuracoes.Geral.Provedor;

    if Configuracoes.WebServices.AmbienteCodigo = 1 then
      DANFSE.Producao := snSim
    else
      DANFSE.Producao := snNao;

    if not Assigned(DANFSE) then
      raise EACBrNFSeException.Create('Componente DANFSE n�o associado.')
    else
      DANFSE.ImprimirDANFSEPDF(NFSe);
  end;
end;

function TNotaFiscal.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  sSecao, sFim: String;
  Ok: Boolean;
  i: Integer;
  FProvider: IACBrNFSeXProvider;
begin
  FProvider := TACBrNFSeX(FACBrNFSe).Provider;

  if not Assigned(FProvider) then
    raise EACBrNFSeException.Create(ERR_SEM_PROVEDOR);

  INIRec := TMemIniFile.Create('');

  try
    LerIniArquivoOuString(AIniString, INIRec);

    with FNFSe do
    begin
      // Provedor Infisc - Layout Proprio
      sSecao := 'IdentificacaoNFSe';

      Numero := INIRec.ReadString(sSecao, 'Numero', '');
      cNFSe := GerarCodigoDFe(StrToIntDef(Numero, 0));

      sSecao := 'IdentificacaoRps';

      SituacaoTrib := StrToSituacaoTrib(Ok, INIRec.ReadString(sSecao, 'SituacaoTrib', 'tp'));

      // Provedor AssessorPublico
      Situacao := INIRec.ReadInteger(sSecao, 'Situacao', 0);

      Producao := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'Producao', '1'));
      StatusRps := StrToStatusRPS(Ok, INIRec.ReadString(sSecao, 'Status', '1'));
      OutrasInformacoes := INIRec.ReadString(sSecao, 'OutrasInformacoes', '');

      // Provedor ISSDSF e Siat
      SeriePrestacao := INIRec.ReadString(sSecao, 'SeriePrestacao', '');

      IdentificacaoRps.Numero := INIRec.ReadString(sSecao, 'Numero', '0');
      IdentificacaoRps.Serie := INIRec.ReadString(sSecao, 'Serie', '0');
      IdentificacaoRps.Tipo := StrToTipoRPS(Ok, INIRec.ReadString(sSecao, 'Tipo', '1'));

      DataEmissao := INIRec.ReadDate(sSecao, 'DataEmissao', Now);
      Competencia := INIRec.ReadDate(sSecao, 'Competencia', Now);
      DataEmissaoRPS := INIRec.ReadDate(sSecao, 'DataEmissao', Now);
      NaturezaOperacao := StrToNaturezaOperacao(Ok, INIRec.ReadString(sSecao, 'NaturezaOperacao', '0'));

      // Provedor Tecnos
      PercentualCargaTributaria := StringToFloatDef(INIRec.ReadString(sSecao, 'PercentualCargaTributaria', ''), 0);
      ValorCargaTributaria := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCargaTributaria', ''), 0);
      PercentualCargaTributariaMunicipal := StringToFloatDef(INIRec.ReadString(sSecao, 'PercentualCargaTributariaMunicipal', ''), 0);
      ValorCargaTributariaMunicipal := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCargaTributariaMunicipal', ''), 0);
      PercentualCargaTributariaEstadual := StringToFloatDef(INIRec.ReadString(sSecao, 'PercentualCargaTributariaEstadual', ''), 0);
      ValorCargaTributariaEstadual := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCargaTributariaEstadual', ''), 0);

      sSecao := 'RpsSubstituido';

      RpsSubstituido.Numero := INIRec.ReadString(sSecao, 'Numero', '0');
      RpsSubstituido.Serie := INIRec.ReadString(sSecao, 'Serie', '0');
      RpsSubstituido.Tipo := StrToTipoRPS(Ok, INIRec.ReadString(sSecao, 'Tipo', '1'));

      sSecao := 'Prestador';

      RegimeEspecialTributacao := FProvider.StrToRegimeEspecialTributacao(Ok, INIRec.ReadString(sSecao, 'Regime', '0'));
      OptanteSimplesNacional := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'OptanteSN', '1'));
      IncentivadorCultural := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'IncentivadorCultural', '1'));

      with Prestador do
      begin
        IdentificacaoPrestador.CpfCnpj := INIRec.ReadString(sSecao, 'CNPJ', '');
        IdentificacaoPrestador.InscricaoMunicipal := INIRec.ReadString(sSecao, 'InscricaoMunicipal', '');

        // Para o provedor ISSDigital deve-se informar tamb�m:
        cUF := UFparaCodigo(INIRec.ReadString(sSecao, 'UF', 'SP'));

        RazaoSocial := INIRec.ReadString(sSecao, 'RazaoSocial', '');
        NomeFantasia := INIRec.ReadString(sSecao, 'NomeFantasia', '');

        with Endereco do
        begin
          Endereco := INIRec.ReadString(sSecao, 'Logradouro', '');
          Numero := INIRec.ReadString(sSecao, 'Numero', '');
          Bairro := INIRec.ReadString(sSecao, 'Bairro', '');
          CodigoMunicipio := INIRec.ReadString(sSecao, 'CodigoMunicipio', '');
          xMunicipio := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
          UF := INIRec.ReadString(sSecao, 'UF', '');
          CodigoPais := INIRec.ReadInteger(sSecao, 'CodigoPais', 0);
          xPais := INIRec.ReadString(sSecao, 'xPais', '');
          CEP := INIRec.ReadString(sSecao, 'CEP', '');
        end;

        with Contato do
        begin
          Telefone := INIRec.ReadString(sSecao, 'Telefone', '');
          Email := INIRec.ReadString(sSecao, 'Email', '');
        end;
      end;

      sSecao := 'Tomador';

      with Tomador do
      begin
        with IdentificacaoTomador do
        begin
          Tipo := StrToTipoPessoa(Ok, INIRec.ReadString(sSecao, 'Tipo', '1'));
          CpfCnpj := INIRec.ReadString(sSecao, 'CNPJCPF', '');
          InscricaoMunicipal := INIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
          InscricaoEstadual := INIRec.ReadString(sSecao, 'InscricaoEstadual', '');
        end;

        RazaoSocial := INIRec.ReadString(sSecao, 'RazaoSocial', '');

        with Endereco do
        begin
          TipoLogradouro := INIRec.ReadString(sSecao, 'TipoLogradouro', '');
          Endereco := INIRec.ReadString(sSecao, 'Logradouro', '');
          Numero := INIRec.ReadString(sSecao, 'Numero', '');
          Complemento := INIRec.ReadString(sSecao, 'Complemento', '');
          Bairro := INIRec.ReadString(sSecao, 'Bairro', '');
          CodigoMunicipio := INIRec.ReadString(sSecao, 'CodigoMunicipio', '');
          xMunicipio := CodIBGEToCidade(StrToIntDef(CodigoMunicipio, 0));
          UF := INIRec.ReadString(sSecao, 'UF', '');
          CodigoPais := INIRec.ReadInteger(sSecao, 'CodigoPais', 0);
          CEP := INIRec.ReadString(sSecao, 'CEP', '');
          // Provedor Equiplano � obrigat�rio o pais e IE
          xPais := INIRec.ReadString(sSecao, 'xPais', '');
        end;

        with Contato do
        begin
          Telefone := INIRec.ReadString(sSecao, 'Telefone', '');
          Email := INIRec.ReadString(sSecao, 'Email', '');
        end;

        AtualizaTomador := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'AtualizaTomador', '1'));
        TomadorExterior := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'TomadorExterior', '1'));
      end;

      sSecao := 'Intermediario';

      with IntermediarioServico do
      begin
        CpfCnpj := INIRec.ReadString(sSecao, 'CNPJCPF', '');
        InscricaoMunicipal := INIRec.ReadString(sSecao, 'InscricaoMunicipal', '');
        RazaoSocial := INIRec.ReadString(sSecao, 'RazaoSocial', '');
      end;

      sSecao := 'ConstrucaoCivil';

      with ConstrucaoCivil do
      begin
        CodigoObra := INIRec.ReadString(sSecao, 'CodigoObra', '');
        Art := INIRec.ReadString(sSecao, 'Art', '');
      end;

      with Servico do
      begin
        sSecao := 'Servico';

        ItemListaServico := INIRec.ReadString(sSecao, 'ItemListaServico', '');
        CodigoCnae := INIRec.ReadString(sSecao, 'CodigoCnae', '');
        CodigoTributacaoMunicipio := INIRec.ReadString(sSecao, 'CodigoTributacaoMunicipio', '');
        Discriminacao := INIRec.ReadString(sSecao, 'Discriminacao', '');
        CodigoMunicipio := INIRec.ReadString(sSecao, 'CodigoMunicipio', '');
        CodigoPais := INIRec.ReadInteger(sSecao, 'CodigoPais', 1058);
        ExigibilidadeISS := StrToExigibilidadeISS(Ok, INIRec.ReadString(sSecao, 'ExigibilidadeISS', '1'));
        MunicipioIncidencia := INIRec.ReadInteger(sSecao, 'MunicipioIncidencia', 0);
        UFPrestacao := INIRec.ReadString(sSecao, 'UFPrestacao', '');
        ResponsavelRetencao := FProvider.StrToResponsavelRetencao(Ok, INIRec.ReadString(sSecao, 'ResponsavelRetencao', '1'));

        i := 1;
        while true do
        begin
          sSecao := 'Itens' + IntToStrZero(i, 3);
          sFim := INIRec.ReadString(sSecao, 'Descricao'  ,'FIM');

          if (sFim = 'FIM') then
            break;

          with ItemServico.New do
          begin
            Descricao := sFim;
            ItemListaServico := INIRec.ReadString(sSecao, 'ItemListaServico', '');
            CodServ := INIRec.ReadString(sSecao, 'CodServico', '');
            codLCServ := INIRec.ReadString(sSecao, 'codLCServico', '');

            TipoUnidade := StrToUnidade(Ok, INIRec.ReadString(sSecao, 'TipoUnidade', '2'));
            Unidade := INIRec.ReadString(sSecao, 'Unidade', '');
            Quantidade := StringToFloatDef(INIRec.ReadString(sSecao, 'Quantidade', ''), 0);
            ValorUnitario := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorUnitario', ''), 0);

            QtdeDiaria := StringToFloatDef(INIRec.ReadString(sSecao, 'QtdeDiaria', ''), 0);
            ValorTaxaTurismo := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorTaxaTurismo', ''), 0);

            ValorDeducoes := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
            xJustDeducao := INIRec.ReadString(sSecao, 'xJustDeducao', '');

            AliqReducao := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqReducao', ''), 0);
            ValorReducao := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorReducao', ''), 0);

            ValorISS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorISS', ''), 0);
            Aliquota := StringToFloatDef(INIRec.ReadString(sSecao, 'Aliquota', ''), 0);
            BaseCalculo := StringToFloatDef(INIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
            DescontoIncondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
            DescontoCondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);

            AliqISSST := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqISSST', ''), 0);
            ValorISSST := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorISSST', ''), 0);

            ValorBCCSLL := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorBCCSLL', ''), 0);
            AliqRetCSLL := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqRetCSLL', ''), 0);
            ValorCSLL := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCSLL', ''), 0);

            ValorBCPIS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorBCPIS', ''), 0);
            AliqRetPIS := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqRetPIS', ''), 0);
            ValorPIS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorPIS', ''), 0);

            ValorBCCOFINS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorBCCOFINS', ''), 0);
            AliqRetCOFINS := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqRetCOFINS', ''), 0);
            ValorCOFINS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCOFINS', ''), 0);

            ValorBCINSS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorBCINSS', ''), 0);
            AliqRetINSS := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqRetINSS', ''), 0);
            ValorINSS := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorINSS', ''), 0);

            ValorBCRetIRRF := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorBCRetIRRF', ''), 0);
            AliqRetIRRF := StringToFloatDef(INIRec.ReadString(sSecao, 'AliqRetIRRF', ''), 0);
            ValorIRRF := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorIRRF', ''), 0);

            ValorTotal := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorTotal', ''), 0);

            Tributavel := FProvider.StrToSimNao(Ok, INIRec.ReadString(sSecao, 'Tributavel', '1'));
          end;

          Inc(i);
        end;

        with Valores do
        begin
          sSecao := 'Valores';

          ValorServicos := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorServicos', ''), 0);
          ValorDeducoes := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);

          ValorPis := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorPis', ''), 0);
          AliquotaPis := StringToFloatDef(INIRec.ReadString(sSecao, 'AliquotaPis', ''), 0);

          ValorCofins := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCofins', ''), 0);
          AliquotaCofins := StringToFloatDef(INIRec.ReadString(sSecao, 'AliquotaCofins', ''), 0);

          ValorInss := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorInss', ''), 0);
          ValorIr := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorIr', ''), 0);
          ValorCsll := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorCsll', ''), 0);

          ISSRetido := FProvider.StrToSituacaoTributaria(Ok, INIRec.ReadString(sSecao, 'ISSRetido', '0'));

          OutrasRetencoes := StringToFloatDef(INIRec.ReadString(sSecao, 'OutrasRetencoes', ''), 0);
          DescontoIncondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
          DescontoCondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);

          BaseCalculo := StringToFloatDef(INIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
          Aliquota := StringToFloatDef(INIRec.ReadString(sSecao, 'Aliquota', ''), 0);
          ValorIss := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorIss', ''), 0);
          ValorIssRetido := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorIssRetido', ''), 0);

          ValorLiquidoNfse := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorLiquidoNfse', ''), 0);
        end;
      end;

      // Condi��o de Pagamento usado pelo provedor Betha vers�o 1 do Layout da ABRASF
      sSecao := 'CondicaoPagamento';

      with CondicaoPagamento do
      begin
        QtdParcela := INIRec.ReadInteger(sSecao, 'QtdParcela', 0);
        Condicao := StrToCondicao(Ok, INIRec.ReadString(sSecao, 'Condicao', 'A_VISTA'));

        i := 1;
        while true do
        begin
          sSecao := 'Parcelas' + IntToStrZero(i, 2);
          sFim := INIRec.ReadString(sSecao, 'Parcela'  ,'FIM');

          if (sFim = 'FIM') then
            break;

          with Parcelas.New do
          begin
            Parcela := StrToIntDef(sFim, 1);
            DataVencimento := INIRec.ReadDate(sSecao, 'DataVencimento', Now);
            Valor := StringToFloatDef(INIRec.ReadString(sSecao, 'Valor', ''), 0);
          end;

          Inc(i);
        end;
      end;
    end;

    Result := True;
  finally
    INIRec.Free;
  end;
end;

function TNotaFiscal.LerXML(const AXML: String): Boolean;
var
  FProvider: IACBrNFSeXProvider;
  TipoXml: TtpXML;
begin
  FProvider := TACBrNFSeX(FACBrNFSe).Provider;

  if not Assigned(FProvider) then
    raise EACBrNFSeException.Create(ERR_SEM_PROVEDOR);

  Result := FProvider.LerXML(AXml, FNFSe, TipoXml);

  if TipoXml = txmlNFSe then
    FXmlNfse := AXML
  else
    FXmlRps := AXML;
end;

function TNotaFiscal.GravarXML(const NomeArquivo: String;
  const PathArquivo: String; aTipo: TtpXML): Boolean;
begin
  if EstaVazio(FXmlRps) then
    GerarXML;

  if aTipo = txmlNFSe then
  begin
    FNomeArq := TACBrNFSeX(FACBrNFSe).GetNumID(NFSe) + '-nfse.xml';
    Result := TACBrNFSeX(FACBrNFSe).Gravar(FNomeArq, FXmlNfse, PathArquivo);
  end
  else
  begin
    FNomeArqRps := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
    Result := TACBrNFSeX(FACBrNFSe).Gravar(FNomeArqRps, FXmlRps);
  end;
end;

function TNotaFiscal.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXmlRps) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXmlRps));
  Result := True;
end;

procedure TNotaFiscal.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings;
  ManterPDFSalvo: Boolean);
var
  NomeArqTemp: String;
  AnexosEmail:TStrings;
  StreamNFSe: TMemoryStream;
begin
  if not Assigned(TACBrNFSeX(FACBrNFSe).MAIL) then
    raise EACBrNFSeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamNFSe  := TMemoryStream.Create;
  try
    AnexosEmail.Clear;

    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrNFSeX(FACBrNFSe) do
    begin
      GravarStream(StreamNFSe);

      if (EnviaPDF) then
      begin
        if Assigned(DANFSE) then
        begin
          DANFSE.ImprimirDANFSEPDF(FNFSe);
          NomeArqTemp := DANFSE.ArquivoPDF;
          AnexosEmail.Add(NomeArqTemp);
        end;
      end;

      EnviarEmail( sPara, sAssunto, sMensagem, sCC, AnexosEmail, StreamNFSe,
                   NumID[FNFSe] +'-nfse.xml', sReplyTo);
    end;
  finally
    if not ManterPDFSalvo then
      DeleteFile(NomeArqTemp);

    AnexosEmail.Free;
    StreamNFSe.Free;
  end;
end;

function TNotaFiscal.GerarXML: String;
var
  FProvider: IACBrNFSeXProvider;
begin
  FProvider := TACBrNFSeX(FACBrNFSe).Provider;

  if not Assigned(FProvider) then
    raise EACBrNFSeException.Create(ERR_SEM_PROVEDOR);

  FProvider.GerarXml(NFSe, FXmlRps, FAlertas);
  Result := FXmlRps;
end;

function TNotaFiscal.CalcularNomeArquivo: String;
var
  xID: String;
begin
  xID := TACBrNFSeX(FACBrNFSe).NumID[NFSe];

  if EstaVazio(xID) then
    raise EACBrNFSeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  Result := xID + '-rps.xml';
end;

function TNotaFiscal.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrNFSeX(FACBrNFSe) do
  begin
    if Configuracoes.Arquivos.EmissaoPathNFSe then
      Data := FNFSe.DataEmissaoRps
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathRPS(Data,
      FNFSe.Prestador.IdentificacaoPrestador.CpfCnpj,
      FNFSe.Prestador.IdentificacaoPrestador.InscricaoEstadual));
  end;
end;

function TNotaFiscal.CalcularNomeArquivoCompleto(NomeArquivo: String;
  PathArquivo: String): String;
begin
  if EstaVazio(NomeArquivo) then
    NomeArquivo := CalcularNomeArquivo;

  if EstaVazio(PathArquivo) then
    PathArquivo := CalcularPathArquivo
  else
    PathArquivo := PathWithDelim(PathArquivo);

  Result := PathArquivo + NomeArquivo;
end;

{ TNotasFiscais }

constructor TNotasFiscais.Create(AOwner: TACBrDFe);
begin
  if not (AOwner is TACBrNFSeX) then
    raise EACBrNFSeException.Create('AOwner deve ser do tipo TACBrNFSeX');

  inherited Create();

  FACBrNFSe := TACBrNFSeX(AOwner);
  FConfiguracoes := TACBrNFSeX(FACBrNFSe).Configuracoes;
end;

function TNotasFiscais.New: TNotaFiscal;
begin
  Result := TNotaFiscal.Create(FACBrNFSe);
  Add(Result);
end;

function TNotasFiscais.Add(ANota: TNotaFiscal): Integer;
begin
  Result := inherited Add(ANota);
end;

procedure TNotasFiscais.GerarNFSe;
var
  i: integer;
begin
  for i := 0 to Self.Count - 1 do
    Self.Items[i].GerarXML;
end;

function TNotasFiscais.GetItem(Index: integer): TNotaFiscal;
begin
  Result := TNotaFiscal(inherited Items[Index]);
end;

function TNotasFiscais.GetNamePath: String;
begin
  Result := 'NotaFiscal';
end;

procedure TNotasFiscais.VerificarDANFSE;
begin
  if not Assigned(TACBrNFSeX(FACBrNFSe).DANFSE) then
    raise EACBrNFSeException.Create('Componente DANFSE n�o associado.');
end;

procedure TNotasFiscais.Imprimir;
begin
  VerificarDANFSE;
  TACBrNFSeX(FACBrNFSe).DANFSE.ImprimirDANFSE(nil);
end;

procedure TNotasFiscais.ImprimirPDF;
begin
  VerificarDANFSE;
  TACBrNFSeX(FACBrNFSe).DANFSE.ImprimirDANFSEPDF;
end;

procedure TNotasFiscais.Insert(Index: Integer; ANota: TNotaFiscal);
begin
  inherited Insert(Index, ANota);
end;

function TNotasFiscais.FindByNFSe(ANumNFSe: string): TNotaFiscal;
var
  AItem: TNotaFiscal;
  AItemIndex: Integer;
begin
  Result := nil;

  if Self.Count = 0 then Exit;

  if not Self.fIsSorted then
  begin
  {$IfDef HAS_SYSTEM_GENERICS}
    Sort(TComparer<TObject>.Construct(CompNFSePorNumero));
  {$Else}
    Sort(@CompNFSePorNumero);
  {$EndIf}
  end;

  AItem := TNotaFiscal.Create(FACBrNFSe);
  try
    AItem.NFSe.Numero := ANumNFSe;
    {$IfDef HAS_SYSTEM_GENERICS}
     AItemIndex := FindObject(AItem, TComparer<TObject>.Construct(CompNFSePorNumero));
    {$Else}
     AItemIndex := FindObject(Pointer(AItem), @CompNFSePorNumero);
    {$EndIf}
  finally
    AItem.Free;
  end;

  if AItemIndex = -1 then Exit;

  Result := Self.Items[AItemIndex];
end;

function TNotasFiscais.FindByRps(ANumRPS: string): TNotaFiscal;
var
  AItem: TNotaFiscal;
  AItemIndex: Integer;
begin
  Result := nil;

  if Self.Count = 0 then Exit;

  if not Self.fIsSorted then
  begin
  {$IfDef HAS_SYSTEM_GENERICS}
    Sort(TComparer<TObject>.Construct(CompRpsPorNumero));
  {$Else}
    Sort(@CompRpsPorNumero);
  {$EndIf}
  end;

  AItem := TNotaFiscal.Create(FACBrNFSe);
  try
    AItem.NFSe.IdentificacaoRps.Numero := ANumRPS;
    {$IfDef HAS_SYSTEM_GENERICS}
     AItemIndex := FindObject(AItem, TComparer<TObject>.Construct(CompRpsPorNumero));
    {$Else}
     AItemIndex := FindObject(Pointer(AItem), @CompRpsPorNumero);
    {$EndIf}
  finally
    AItem.Free;
  end;

  if AItemIndex = -1 then Exit;

  Result := Self.Items[AItemIndex];
end;

procedure TNotasFiscais.SetItem(Index: integer; const Value: TNotaFiscal);
begin
  inherited Items[Index] := Value;
end;

function TNotasFiscais.LoadFromFile(const CaminhoArquivo: String;
  AGerarNFSe: Boolean = True): Boolean;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  i, l: integer;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  l := Self.Count; // Indice da �ltima nota j� existente

  // Converte de UTF8 para a String nativa da IDE //
  XMLStr := DecodeToString(XMLUTF8, True);
  Result := LoadFromString(XMLStr, AGerarNFSe);

  if Result then
  begin
    // Atribui Nome do arquivo a novas notas inseridas //
    for i := l to Self.Count - 1 do
    begin
      if Pos('-rps.xml', CaminhoArquivo) > 0 then
        Self.Items[i].NomeArqRps := CaminhoArquivo
      else
        Self.Items[i].NomeArq := CaminhoArquivo;
    end;
  end;
end;

function TNotasFiscais.LoadFromIni(const AIniString: String): Boolean;
begin
  with Self.New do
    LerArqIni(AIniString);

  Result := Self.Count > 0;
end;

function TNotasFiscais.LoadFromLoteNfse(const CaminhoArquivo: String): Boolean;
var
  XMLStr: String;
  XMLUTF8: AnsiString;
  i, l: integer;
  MS: TMemoryStream;
  P, N, TamTag, j: Integer;
  aXml, aXmlLote: string;
  TagF: Array[1..14] of String;

  function PrimeiraNFSe: Integer;
  begin
    TagF[01] := '<CompNfse>';
    TagF[02] := '<ComplNfse>';
    TagF[03] := '<NFS-e>';
    TagF[04] := '<Nfse>';
    TagF[05] := '<nfse>';             // Provedor IPM
    TagF[06] := '<Nota>';
    TagF[07] := '<NFe>';
    TagF[08] := '<tbnfd>';
    TagF[09] := '<nfs>';
    TagF[10] := '<nfeRpsNotaFiscal>'; // Provedor EL
    TagF[11] := '<notasFiscais>';     // Provedor EL
    TagF[12] := '<notaFiscal>';       // Provedor GIAP
    TagF[13] := '<NOTA>';             // Provedor AssessorPublico
    TagF[14] := '<NOTA_FISCAL>';      // Provedor ISSDSF

    j := 0;

    repeat
      inc(j);
      TamTAG := Length(TagF[j]) -1;
      Result := Pos(TagF[j], aXmlLote);
    until (j = High(TagF)) or (Result <> 0);
  end;

  function PosNFSe: Integer;
  begin
    TagF[01] := '</CompNfse>';
    TagF[02] := '</ComplNfse>';
    TagF[03] := '</NFS-e>';
    TagF[04] := '</Nfse>';
    TagF[05] := '</nfse>';             // Provedor IPM
    TagF[06] := '</Nota>';
    TagF[07] := '</NFe>';
    TagF[08] := '</tbnfd>';
    TagF[09] := '</nfs>';
    TagF[10] := '</nfeRpsNotaFiscal>'; // Provedor EL
    TagF[11] := '</notasFiscais>';     // Provedor EL
    TagF[12] := '</notaFiscal>';       // Provedor GIAP
    TagF[13] := '</NOTA>';             // Provedor AssessorPublico
    TagF[14] := '</NOTA_FISCAL>';      // Provedor ISSDSF

    j := 0;

    repeat
      inc(j);
      TamTAG := Length(TagF[j]) -1;
      Result := Pos(TagF[j], aXmlLote);
    until (j = High(TagF)) or (Result <> 0);
  end;

  function LimparXml(const XMLStr: string): string;
  begin
    Result := FaststringReplace(XMLStr, ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"', '', [rfReplaceAll]);
    Result := FaststringReplace(Result, ' xmlns:xsd="http://www.w3.org/2001/XMLSchema"', '', [rfReplaceAll]);
  end;
begin
  MS := TMemoryStream.Create;
  try
    MS.LoadFromFile(CaminhoArquivo);
    XMLUTF8 := ReadStrFromStream(MS, MS.Size);
  finally
    MS.Free;
  end;

  l := Self.Count; // Indice da �ltima nota j� existente

  // Converte de UTF8 para a String nativa da IDE //
  XMLStr := DecodeToString(XMLUTF8, True);
  XMLStr := LimparXml(XMLStr);

  aXmlLote := XMLStr;
  Result := False;
  P := PrimeiraNFSe;
  aXmlLote := copy(aXmlLote, P, length(aXmlLote));
  N := PosNFSe;

  while N > 0 do
  begin
    aXml := copy(aXmlLote, 1, N + TamTAG);
    aXmlLote := Trim(copy(aXmlLote, N + TamTAG + 1, length(aXmlLote)));

    Result := LoadFromString(aXml, False);

    N := PosNFSe;
  end;

  if Result then
  begin
    // Atribui Nome do arquivo a novas notas inseridas //
    for i := l to Self.Count - 1 do
    begin
      if Pos('-rps.xml', CaminhoArquivo) > 0 then
        Self.Items[i].NomeArqRps := CaminhoArquivo
      else
        Self.Items[i].NomeArq := CaminhoArquivo;
    end;
  end;
end;

function TNotasFiscais.LoadFromStream(AStream: TStringStream;
  AGerarNFSe: Boolean = True): Boolean;
var
  AXML: AnsiString;
begin
  AStream.Position := 0;
  AXML := ReadStrFromStream(AStream, AStream.Size);

  Result := Self.LoadFromString(String(AXML), AGerarNFSe);
end;

function TNotasFiscais.LoadFromString(AXMLString: String;
  AGerarNFSe: Boolean = True): Boolean;
begin
  with Self.New do
  begin
    LerXML(AXMLString);

    if AGerarNFSe then
      GerarXML;
  end;

  Result := Self.Count > 0;
end;

function TNotasFiscais.GravarXML(const PathNomeArquivo: String): Boolean;
var
  i: integer;
  NomeArq, PathArq : String;
begin
  Result := True;
  i := 0;

  while Result and (i < Self.Count) do
  begin
    PathArq := ExtractFilePath(PathNomeArquivo);
    NomeArq := ExtractFileName(PathNomeArquivo);
    Result := Self.Items[i].GravarXML(NomeArq, PathArq);
    Inc(i);
  end;
end;

end.
