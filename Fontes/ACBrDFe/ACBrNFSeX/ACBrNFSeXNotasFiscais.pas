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
  pcnConversao, pcnAuxiliar,
  ACBrBase, ACBrDFe, ACBrNFSeXConfiguracoes,
  ACBrDFeUtil, ACBrNFSeXClass, ACBrNFSeXConversao;

type

  { NotaFiscal }

  NotaFiscal = class
  private
    FNFSe: TNFSe;
    FAOwner: TACBrDFe;

    FXMLNFSe: String;
    FXMLAssinado: String;
    FXMLOriginal: String;
    FAlertas: String;
    FNomeArq: String;
    FNomeArqRps: String;
    FConfirmada: Boolean;

    function CalcularNomeArquivo: String;
    function CalcularPathArquivo: String;

    function GetXMLAssinado: String;
    procedure SetXML(const Value: String);
    procedure SetXMLOriginal(const Value: String);

  public
    constructor Create(AOwner: TACBrDFe);
    destructor Destroy; override;

    procedure Imprimir;
    procedure ImprimirPDF;

    function LerXML(const AXML: String): Boolean;
    function LerArqIni(const AIniString: String): Boolean;

    function GerarXML: String;
    function GravarXML(const NomeArquivo: String = '';
      const PathArquivo: String = ''): Boolean;

    function GravarStream(AStream: TStream): Boolean;

    procedure EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings = nil;
      EnviaPDF: Boolean = True; sCC: TStrings = nil; Anexos: TStrings = nil;
      sReplyTo: TStrings = nil; ManterPDFSalvo: Boolean = True);

    property NomeArq: String    read FNomeArq    write FNomeArq;
    property NomeArqRps: String read FNomeArqRps write FNomeArqRps;

    function CalcularNomeArquivoCompleto(NomeArquivo: String = '';
      PathArquivo: String = ''): String;

    property NFSe: TNFSe read FNFSe;

    // Atribuir a "XML", faz o componente transferir os dados lido para as propriedades internas e "XMLAssinado"
    property XML: String         read FXMLOriginal   write SetXML;
    // Atribuir a "XMLOriginal", reflete em XMLAssinado, se existir a tag de assinatura
    property XMLOriginal: String read FXMLOriginal   write SetXMLOriginal;
    property XMLAssinado: String read GetXMLAssinado write FXMLAssinado;
    property XMLNFSe: String     read FXMLNFSe       write FXMLNFSe;
    property Confirmada: Boolean read FConfirmada    write FConfirmada;
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

    function GetItem(Index: integer): NotaFiscal;
    procedure SetItem(Index: integer; const Value: NotaFiscal);

    procedure VerificarDANFSE;
  public
    constructor Create(AOwner: TACBrDFe);

    procedure GerarNFSe;
    procedure Imprimir;
    procedure ImprimirPDF;

    function New: NotaFiscal; reintroduce;
    function Add(ANota: NotaFiscal): Integer; reintroduce;
    Procedure Insert(Index: Integer; ANota: NotaFiscal); reintroduce;
    function FindByRps(ANumRPS: string): NotaFiscal;
    function FindByNFSe(ANumNFSe: string): NotaFiscal;

    property Items[Index: integer]: NotaFiscal read GetItem write SetItem; default;

    function GetNamePath: String;

    // Incluido o Parametro AGerarNFSe que determina se ap�s carregar os dados da NFSe
    // para o componente, ser� gerado ou n�o novamente o XML da NFSe.
    function LoadFromFile(const CaminhoArquivo: String; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromStream(AStream: TStringStream; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromString(AXMLString: String; AGerarNFSe: Boolean = True): Boolean;
    function LoadFromIni(const AIniString: String): Boolean;

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
  ACBrUtil, synautil, IniFiles,
  ACBrNFSeX, ACBrNFSeXInterface;

function CompRpsPorNumero(const Item1,
  Item2: {$IfDef HAS_SYSTEM_GENERICS}TObject{$Else}Pointer{$EndIf}): Integer;
var
  NumRps1, NumRps2: Integer;
begin
  NumRps1 := StrToInt(NotaFiscal(Item1).NFSe.IdentificacaoRps.Numero);
  NumRps2 := StrToInt(NotaFiscal(Item2).NFSe.IdentificacaoRps.Numero);

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
  NumNFSe1, NumNFSe2: Integer;
begin
  NumNFSe1 := StrToInt(NotaFiscal(Item1).NFSe.Numero);
  NumNFSe2 := StrToInt(NotaFiscal(Item2).NFSe.Numero);

  if NumNFSe1 < NumNFSe2 then
    Result := -1
  else if NumNFSe1 > NumNFSe2 then
    Result := 1
  else
    Result := 0;
end;

{ NotaFiscal }

constructor NotaFiscal.Create(AOwner: TACBrDFe);
begin
  if not (AOwner is TACBrNFSeX) then
    raise EACBrNFSeException.Create('AOwner deve ser do tipo TACBrNFSeX');

  FAOwner := AOwner;
  FNFSe := TNFSe.Create;
end;

destructor NotaFiscal.Destroy;
begin
  FNFSe.Free;

  inherited Destroy;
end;

procedure NotaFiscal.Imprimir;
begin
  with TACBrNFSeX(FAOwner) do
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

procedure NotaFiscal.ImprimirPDF;
begin
  with TACBrNFSeX(FAOwner) do
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

function NotaFiscal.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  sSecao, sFim: String;
  Ok: Boolean;
  i: Integer;
begin
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

      Producao := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'Producao', '1'));
      Status := StrToStatusRPS(Ok, INIRec.ReadString(sSecao, 'Status', '1'));
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

      RegimeEspecialTributacao := StrToRegimeEspecialTributacao(Ok, INIRec.ReadString(sSecao, 'Regime', '0'));
      OptanteSimplesNacional := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'OptanteSN', '1'));
      IncentivadorCultural := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'IncentivadorCultural', '1'));

      with Prestador do
      begin
        IdentificacaoPrestador.Cnpj := INIRec.ReadString(sSecao, 'CNPJ', '');
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

        AtualizaTomador := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'AtualizaTomador', '1'));
        TomadorExterior := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'TomadorExterior', '1'));
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
        ResponsavelRetencao := StrToResponsavelRetencao(Ok, INIRec.ReadString(sSecao, 'ResponsavelRetencao', '1'));

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
            CodServ := INIRec.ReadString(sSecao, 'CodServico', '');
            codLCServ := INIRec.ReadString(sSecao, 'codLCServico', '');
            ItemListaServico := INIRec.ReadString(sSecao, 'ItemListaServico', '');

            Quantidade := StringToFloatDef(INIRec.ReadString(sSecao, 'Quantidade', ''), 0);
            ValorUnitario := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorUnitario', ''), 0);

            ValorDeducoes := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorDeducoes', ''), 0);
            ValorIss := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorIss', ''), 0);
            Aliquota := StringToFloatDef(INIRec.ReadString(sSecao, 'Aliquota', ''), 0);
            BaseCalculo := StringToFloatDef(INIRec.ReadString(sSecao, 'BaseCalculo', ''), 0);
            DescontoIncondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoIncondicionado', ''), 0);
            DescontoCondicionado := StringToFloatDef(INIRec.ReadString(sSecao, 'DescontoCondicionado', ''), 0);

            ValorTotal := StringToFloatDef(INIRec.ReadString(sSecao, 'ValorTotal', ''), 0);

            Tributavel := StrToSimNao(Ok, INIRec.ReadString(sSecao, 'Tributavel', '1'));
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

          ISSRetido := StrToSituacaoTributaria(Ok, INIRec.ReadString(sSecao, 'ISSRetido', '0'));

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

    {
      Verificar a necessidade de gerar o Xml logo ap�s ler o arquivo ini,
      ou deixar para gerar pelo m�todo Emitir.
    }
//    GerarXML; // ?????

    Result := True;
  finally
    INIRec.Free;
  end;
end;

function NotaFiscal.LerXML(const AXML: String): Boolean;
var
  FProvider: IACBrNFSeXProvider;
begin
  FProvider := TACBrNFSeX(FAOwner).Provider;

  if not Assigned(FProvider) then
    raise EACBrNFSeException.Create(ERR_SEM_PROVEDOR);

  Result := FProvider.LerXML(AXml, FNFSe);
  FXMLOriginal := String(AXML);
end;

function NotaFiscal.GravarXML(const NomeArquivo: String; const PathArquivo: String): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  FNomeArqRps := CalcularNomeArquivoCompleto(NomeArquivo, PathArquivo);
  Result := TACBrNFSeX(FAOwner).Gravar(FNomeArqRps, FXMLOriginal);
end;

function NotaFiscal.GravarStream(AStream: TStream): Boolean;
begin
  if EstaVazio(FXMLOriginal) then
    GerarXML;

  AStream.Size := 0;
  WriteStrToStream(AStream, AnsiString(FXMLOriginal));
  Result := True;
end;

procedure NotaFiscal.EnviarEmail(const sPara, sAssunto: String; sMensagem: TStrings;
  EnviaPDF: Boolean; sCC: TStrings; Anexos: TStrings; sReplyTo: TStrings;
  ManterPDFSalvo: Boolean);
var
  NomeArqTemp: String;
  AnexosEmail:TStrings;
  StreamNFSe: TMemoryStream;
begin
  if not Assigned(TACBrNFSeX(FAOwner).MAIL) then
    raise EACBrNFSeException.Create('Componente ACBrMail n�o associado');

  AnexosEmail := TStringList.Create;
  StreamNFSe  := TMemoryStream.Create;
  try
    AnexosEmail.Clear;

    if Assigned(Anexos) then
      AnexosEmail.Assign(Anexos);

    with TACBrNFSeX(FAOwner) do
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

function NotaFiscal.GerarXML: String;
var
  FProvider: IACBrNFSeXProvider;
begin
  FProvider := TACBrNFSeX(FAOwner).Provider;

  if not Assigned(FProvider) then
    raise EACBrNFSeException.Create(ERR_SEM_PROVEDOR);

  FProvider.GerarXml(NFSe, FXMLOriginal, FAlertas);
  Result := XMLOriginal;
end;

function NotaFiscal.CalcularNomeArquivo: String;
var
  xID: String;
begin
  xID := TACBrNFSeX(FAOwner).NumID[NFSe];

  if EstaVazio(xID) then
    raise EACBrNFSeException.Create('ID Inv�lido. Imposs�vel Salvar XML');

  Result := xID + '-rps.xml';
end;

function NotaFiscal.CalcularPathArquivo: String;
var
  Data: TDateTime;
begin
  with TACBrNFSeX(FAOwner) do
  begin
    if Configuracoes.Arquivos.EmissaoPathNFSe then
      Data := FNFSe.DataEmissaoRps
    else
      Data := Now;

    Result := PathWithDelim(Configuracoes.Arquivos.GetPathRPS(Data,
      FNFSe.Prestador.IdentificacaoPrestador.Cnpj,
      FNFSe.Prestador.IdentificacaoPrestador.InscricaoEstadual));
  end;
end;

function NotaFiscal.CalcularNomeArquivoCompleto(NomeArquivo: String;
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

function NotaFiscal.GetXMLAssinado: String;
begin
  Result := FXMLAssinado;
end;

procedure NotaFiscal.SetXML(const Value: String);
begin
  LerXML(Value);
end;

procedure NotaFiscal.SetXMLOriginal(const Value: String);
begin
  FXMLOriginal := Value;

  if XmlEstaAssinado(FXMLOriginal) then
    FXMLAssinado := FXMLOriginal
  else
    FXMLAssinado := '';
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

function TNotasFiscais.New: NotaFiscal;
begin
  Result := NotaFiscal.Create(FACBrNFSe);
  Add(Result);
end;

function TNotasFiscais.Add(ANota: NotaFiscal): Integer;
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

function TNotasFiscais.GetItem(Index: integer): NotaFiscal;
begin
  Result := NotaFiscal(inherited Items[Index]);
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
  TACBrNFSeX(FACBrNFSe).DANFSE.ImprimirDANFSEPDF(nil);
end;

procedure TNotasFiscais.Insert(Index: Integer; ANota: NotaFiscal);
begin
  inherited Insert(Index, ANota);
end;

function TNotasFiscais.FindByNFSe(ANumNFSe: string): NotaFiscal;
var
  AItem: NotaFiscal;
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

  AItem := NotaFiscal.Create(FACBrNFSe);
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

function TNotasFiscais.FindByRps(ANumRPS: string): NotaFiscal;
var
  AItem: NotaFiscal;
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

  AItem := NotaFiscal.Create(FACBrNFSe);
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

procedure TNotasFiscais.SetItem(Index: integer; const Value: NotaFiscal);
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
