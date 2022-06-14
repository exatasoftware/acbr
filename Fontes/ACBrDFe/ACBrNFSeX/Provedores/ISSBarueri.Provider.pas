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
unit ISSBarueri.Provider;

interface

uses
  SysUtils, Classes, Variants,
  ACBrDFeSSL,
  ACBrXmlBase, ACBrXmlDocument,
  ACBrNFSeXNotasFiscais,
  ACBrNFSeXClass, ACBrNFSeXConversao,
  ACBrNFSeXGravarXml, ACBrNFSeXLerXml,
  ACBrNFSeXProviderProprio,
  ACBrNFSeXWebserviceBase, ACBrNFSeXWebservicesResponse;

type

  { TACBrNFSeXWebserviceISSBarueri }

  TACBrNFSeXWebserviceISSBarueri = class(TACBrNFSeXWebserviceSoap12)
  public
    function Recepcionar(ACabecalho, AMSG: String): string; override;
    function ConsultarSituacao(ACabecalho, AMSG: String): string; override;
    function ConsultarLote(ACabecalho, AMSG: String): string; override;
    function Cancelar(ACabecalho, AMSG: String): string; override;
  end;

  { TACBrNFSeProviderISSBarueri }

  TACBrNFSeProviderISSBarueri = class(TACBrNFSeProviderProprio)
  private
    function ExisteErroRegistro(const ALinha: String): Boolean;
  protected
    procedure Configuracao; override;
    function CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass; override;
    function CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass; override;
    function CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice; override;
    procedure TratarRetornoEmitir(Response: TNFSeEmiteResponse); override;
    procedure GerarMsgDadosEmitir(Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse); override;
    function PrepararRpsParaLote(const aXml: string): string; override;
    procedure PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse); override;
    procedure PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse); override;
    procedure PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    procedure TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse); override;
    function AplicarXMLtoUTF8(AXMLRps: String): String; override;
    function AplicarLineBreak(AXMLRps: String; const ABreak: String): String; override;
    procedure ProcessarMensagemErros(RootNode: TACBrXmlNode;
                                     Response: TNFSeWebserviceResponse;
                                     const AListTag: string = 'ListaMensagemRetorno';
                                     const AMessageTag: string = 'MensagemRetorno'); override;
  end;

  { TACBrNFSeProviderBarueriErros }

  TACBrNFSeProviderBarueriErros = class(TStringList)
  public
    constructor Create;
    function Causa(const ACodigo: String): String;
    function Solucao(const ACodigo: String): String;
  end;

implementation

uses
  synacode, synautil,
  pcnAuxiliar, ACBrConsts,
  ACBrUtil.Base,
  ACBrUtil.DateTime,
  ACBrUtil.Strings,
  ACBrUtil.XMLHTML,
  ACBrDFeException,
  ACBrNFSeX, ACBrNFSeXConfiguracoes, ACBrNFSeXConsts,
  ISSBarueri.GravarXml, ISSBarueri.LerXml;

{ TACBrNFSeProviderBarueriErros }

constructor TACBrNFSeProviderBarueriErros.Create;
begin
  Add('100=Tipo de Registro Inv�lido|Informar Tipo Especificado: 1');
  Add('101=Inscri��o do Prestador de Servi�os n�o encontrada na base de dados da PMB|Informar N�mero Correto do Prestador de Servi�os');
  Add('102=Identifica��o da Remessa do Contribuinte inv�lida ou j� informada em outro arquivo de remessa|Informar N�mero v�lido e �nico/exclusivo. Um n�mero outra enviado jamais poder� ser enviado novamente');
  Add('200=Tipo de Registro Inv�lido|Informar Tipo Especificado: 2');
  Add('201=Tipo de RPS Inv�lido|Informar Tipo Especificado: RPS / RPS-C');
  Add('202=N�mero de S�rie do RPS Inv�lida|Informar o N�mero de S�rie do RPS V�lida');
  Add('203=N�mero de S�rie da Nf-e Inv�lida|Informar o N�mero de S�rie da NF-e V�lida');
  Add('204=N�mero de RPS n�o Informado ou inv�lido. Numera��o m�xima permitida 0009999999|Informar o N�mero do RPS');
  Add('205=N�mero de RPS j� enviado|Informar um N�mero de RPS V�lido');
  Add('206=Numero do RPS enviado em Duplicidade no Arquivo|Informar o RPS apenas uma vez no arquivo, caso envie v�rios arquivos simult�neos enviar o RPS uma vez em apenas 1 dos arquivos.');
  Add('207=NF-e n�o consta na base de dados da PMB, n�o pode ser cancelada/substituida|Informar NF-e V�lida.');
  Add('208=Data Inv�lida|A data informada dever� estar no formato AAAAMMDD, ou seja, 4 d�gitos para ano seguido de 2 d�gitos para o m�s seguido de 2 d�gitos para o dia.');
  Add('209=Data de Emiss�o n�o poder� ser inferior a 09/09/2008|Informar uma Data V�lida');
  Add('210=Data de Emiss�o do RPS n�o pode ser superior a Data de Hoje|Informar uma Data V�lida');
  Add('211=Hora de Emiss�o do RPS Inv�lida|A hora informada dever� estar no formato HHMMSS, ou seja, 2 d�gitos para hora em seguida 2 d�gitos para os minutos e e 2 d�gitos para os segundos.');
  Add('212=Situa��o do RPS Inv�lida|Informar a Situa��o Especificada: E para RPS Enviado / C para RPS Cancelado');
  Add('213=C�digo do Motivo de Cancelamento Inv�lido|Informar o C�digo Especificado: 01 para Extravio / 02 para Dados Incorretos / 03 para Substitui��o');
  Add('214=Campo Descri��o do Cancelamento n�o informado|Informar a Descri��o do Cancelamento');
  Add('215=NFe n�o pode ser cancelada, guia em aberto para nota fiscal correspondente|Cancelar a guia correspondente a nota fiscal');
  Add('216=C�digo de Atividade n�o encontrada na base da PMB|Informar C�digo de Atividade V�lido');
  Add('217=Local da Presta��o do Servi�o Inv�lido|Informar o Local Especificado:1 para servi�o prestado no Munic�pio / 2 para servi�o prestado fora do Munic�pio / 3 para servi�o prestado fora do Pa�s');
  Add('218=Servi�o Prestado em Vias P�blicas Inv�lido|Informe 1 para servi�o prestado em vias p�blicas / 2 para servi�o n�o prestado em vias p�blicas.');
  Add('219=Campo Endereco do Servi�o Prestado � obrigat�rio|Informar Endere�o');
  Add('220=Campo N�mero do Logradouro do Servi�o Prestado � obrigat�rio|Informar N�mero');
  Add('221=Campo Bairro do Servi�o Prestado � obrigat�rio|Informar Bairro');
  Add('222=Campo Cidade do Servi�o Prestado � obrigat�rio|Informar Cidade');
  Add('223=Campo UF do Servi�o Prestado � obrigat�rio|Informar UF Tomador');
  Add('224=Campo UF do Servi�o Prestado invalido|Informar UF Tomador V�lida');
  Add('225=Campo CEP do Servi�o Prestado invalido|Informar CEP');
  Add('226=Quantidade de Servi�o n�o dever� ser inferior a zero e/ou Quantidade de Servi�o dever� ser num�rico|Informar um Valor V�lido.');
  Add('227=Valor do Servi�o n�o pode ser menor que zero e/ou Valor do Servi�o dever� ser num�rico|Informar um Valor V�lido');
  Add('228=Reservado');
  Add('229=Reservado');
  Add('230=Valor Total das Reten��es n�o dever� ser inferior a zero e/ou Valor Total das Reten��es dever� ser num�rico|Informar um Valor V�lido.');
  Add('231=Valor Total das Reten��es n�o poder� ser superior ao Valor Total do servi�o prestado|Informar um Valor V�lido.');
  Add('232=Valor Total dos Reten��es n�o confere com os valores dedu�oes informadas para este RPS|Informar Somat�ria dos Valores de Reten��es informadas no registro 3 referente a este RPS');
  Add('233=Identificador de tomodor estrangeiro inv�lido|Informe 1 Para Tomador Estrangeiro 2 para Tomador Brasileiro');
  Add('234=C�digo do Pais de Nacionalidade do Tomador Estrangeiro inv�lido|Informe um c�digo de pais v�lido');
  Add('235=Identificador se Servi�o Prestado � exporta��o inv�lido|Informe 1 Para Servi�o exportado 2 para Servi�o n�o exportado.');
  Add('236=Indicador CPF/CNPJ Inv�lido|Informar Indicador do CPF/CNPJ Especificado:1 para CPF / 2 para CNPJ');
  Add('237=CPNJ do Tomador Inv�lido|Informar o CPNJ do Tomador V�lido');
  Add('238=Campo Nome ou Raz�o Social do Tomador de Servi�os � Obrigat�rio|Informar Raz�o Social');
  Add('239=Campo Endere�o do Tomador de Servi�os � Obrigat�rio|Informar Endere�o');
  Add('240=Campo N�mero do Logradouro do Tomador de Servi�os|Informar N�mero');
  Add('241=Campo Bairro do Tomador de Servi�os � Obrigat�rio|Informar Bairro');
  Add('242=Campo Cidade do Tomador de Servi�os � Obrigat�rio|Informar Cidade');
  Add('243=Campo UF do Tomador de Servi�os � Obrigat�rio|Informar UF Tomador');
  Add('244=Campo UF do Tomador de Servi�os Inv�lido|Informar UF Tomador V�lida');
  Add('245=Campo CEP do Tomador de Servi�os Inv�lido|Informar CEP');
  Add('246=Email do Tomador de Servi�os Inv�lido|Informar e-mail V�lido');
  Add('247=Campo Fatura dever� ser num�rico|Informar um conteudo v�lido.');
  Add('248=Valor da Fatura n�o dever� ser inferior a zero e/ou Valor da Fatura dever� ser num�rico|Informar um Valor V�lido');
  Add('249=Campo Forma de Pagamento n�o informado|Informar Forma de Pagamento');
  Add('250=Campo Discrimina��o de Servi�o n�o informado e/ou fora dos padr�es estabelecidos no layout|Informar a Discrimina��o do Servi�o');
  Add('251=Valor Total do Servi�o superior ao permitido (campo valor do servi�o multiplicado pelo campo quantidade)|Informar valores validos');
  Add('252=Data Inv�lida|A data informada dever� estar no formato AAAAMMDD, ou seja, 4 d�gitos para ano seguido de 2 d�gitos para o m�s seguido de 2 d�gitos para o dia.');
  Add('253=NFe n�o pode ser cancelada, data de emiss�o superior a 90 dias|Informar NF-e valida para cancelamento/substitui��o');
  Add('254=Nota Fiscal J� Cancelada|Informar NF-e valida para cancelamento/substitui��o');
  Add('255=Nota Fiscal com valores zerados|O valor da nota fiscal � calculado: (quantidade do servi�o x pre�o unit�rio) + valor "VN" informado no registro 3. Esse resultado pode ser zero desde que o valor do servi�o ou VN seja diferente de zero.');
  Add('256=Contribuinte com condi��o diferente de ativo|Artigo 3�. Os contribuintes com restri��es cadastrais est�o impedidos de utilizar os sistemas ora institu�dos. ' +
      '-Contribuinte com situa��o diferente de ativo n�o poder� converter RPS emitidos ap�s a data da altera��o da situa��o. D�vidas entrar em contato com o Depto. T�cnico de Tributos Mobili�rios no Tel. 4199-8050.');
  Add('257=Nota Fiscal enviada em Duplicidade no Arquivo|Informar a Nota Fiscal apenas uma vez no arquivo, caso envie v�rios arquivos simult�neos enviar a Nota uma vez em apenas 1 dos arquivos.');
  Add('258=NFe n�o pode ser cancelada ou substituida compet�ncia j� encerrada|Para prosseguir � necess�rio retificar o movimento atrav�s do menu "Retificar Servi�os Prestados"');
  Add('259=Data de Emiss�o do RPS refere-se a compet�ncia j� encerrada|Para prosseguir � necess�rio retificar o movimento atrav�s do menu "Retificar Servi�os Prestados"');
  Add('260=C�digo de Atividade n�o permitido|Informar um C�digo de Atividade vinculado ao Perfil do Contribuinte ou um C�digo de Atividade tributada.');
  Add('261=C�digo de Atividade Bloqueado|Informar um C�digo de Atividade vinculado ao Perfil do Contribuinte (Atingido o limite permitido de notas para atividade n�o vinculadas ao cadastro do contribuinte).');
  Add('300=Tipo de Registro Inv�lido|Informar Tipo Especificado: 3');
  Add('301=C�digo de Outros Valores Inv�lido|Informar o C�digo Especificado: 01 - para IRRF 02 - para PIS/PASEP 03 - para COFINS 04 - ' +
      'para CSLL VN - para Valor n�o Incluso na Base de C�lculo (exceto tributos federais). Esse campo somado ao valor total dos servi�os resulta no Valor total da nota.');
  Add('302=Caso seja reten��o: Valor da Reten��o n�o poder� ser menor/igual a zero Caso seja "VN" Valor deve ser diferente de zero|Caso ' +
      'n�o tenha reten��o n�o informar o registro ou informe um valor maior que zero. Se for "VN" informar um valor diferente de zero ou simplesmente n�o informe esse registro');
  Add('303=Soma do servi�o prestado e valor "VN" n�o poder� ser inferior a zero.|Informar um Valor V�lido.');
  Add('304=C�digo de Outros Valores envia|Informar C�digo de Reten��o V�lido');
  Add('305=Conforme Lei Complementar 419 / 2017, ficam revogados, a partir de 30 de dezembro de 2017, todos os regimes especiais e solu��es ' +
      'de consulta cujo resultado ermitiu redu��o do pre�o do servi�o ou da base de c�lculo do Imposto Sobre Servi�o de Qualquer Natureza.|N�o informar este tipo de dedu��o para RPS cuja a data base de c�lculo seja superior � 29/12/2017.');
  Add('400=Tipo de Registro Inv�lido|Informar Tipo Especificado: 9');
  Add('401=N�mero de Linhas n�o confere com n�mero de linhas do tipo 1,2,3 e 9 enviadas no arquivo|Informe o n�mero de linhas (tipo 1,2,3 e 9)');
  Add('402=Valor Total dos Servi�os n�o confere os valores de servi�os enviados no arquivo|Informar Somat�ria dos Valores Totais de Servi�os Prestados (Soma dos valores dos servi�os multiplicados pelas quantidades de cada servi�o)');
  Add('403=Valor Total das Reten��es e Total de outros valores informados no registro 3 n�o confere com total informado|Informar Somat�ria dos Valores Totais lan�ados no Registro tipo 3.');
  Add('000=Lay-Out do arquivo fora dos padr�es|O arquivo enviado n�o � um arquivo de Remessa da NFe de Barueri. Enviar um arquivo com os Registros: 1, 2, 9 e opcionalmente o registro tipo 3');
  Add('500=Lay-Out do arquivo fora dos padr�es|Os registros v�lidos esperados no arquivo s�o tipo: 1,2,3 e 9');
  Add('600=Lay-Out do arquivo fora dos padr�es|Deve haver apenas 1 registro tipo 9 e esse deve ser o �ltimo registro do arquivo');
  Add('700=Quantidade de RPS superior ao padr�o|Enviar um arquivo com no m�ximo 1000 RPS');
  Add('900=Tamanho do Registro diferente da especifica��o do layout|Reveja as posi��es/tamanho para cada registro, certifique-se que o tamanho dos registros conferem com o layout e cont�m o caracter de fim de linha conforme especificado no layout');
  Add('901=Arquivo com aus�ncia de um dos Registros: 1, 2 ou 9|Reveja os registros do arquivo, certifique-se que todos registros mencionados est�o presentes em seu arquivo. ' +
      'Tamb�m certifique-se que todos os registros do arquivo cont�m o caracter de fim de linha conforme especificado no layout');
end;

function TACBrNFSeProviderBarueriErros.Causa(const ACodigo: String): String;
//var
//  S: TStringList;
begin
  try
    Result := Copy(Values[ACodigo], 1, Pos('|', Values[ACodigo])-1);
  except
    Result := '';
  end;
 {
    S := TStringList.Create;
  try
    S.Delimiter := '|';
//n�o � compativel com o D7    S.StrictDelimiter := True;
    S.DelimitedText := Values[ACodigo];
    Result := S[0];
  except
    Result := '';
  end;
  S.Free;
}
end;

function TACBrNFSeProviderBarueriErros.Solucao(const ACodigo: String): String;
//var
//  S: TStringList;
begin
  try
    Result := Copy(Values[ACodigo], Pos('|', Values[ACodigo])+1, Length(Values[ACodigo]));
  except
    Result := '';
  end;
 {
  S := TStringList.Create;
  try
    S.Delimiter := '|';
//n�o � compativel com o D7    S.StrictDelimiter := True;
    S.DelimitedText := Values[ACodigo];
    Result := S[1];
  except
    Result := '';
  end;
  S.Free;
  }
end;

{ TACBrNFSeXWebserviceISSBarueri }

function TACBrNFSeXWebserviceISSBarueri.Recepcionar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteEnviarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteEnviarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteEnviarArquivo',
    Request,
    ['NFeLoteEnviarArquivoResult'],
    ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']
  );
end;

function TACBrNFSeXWebserviceISSBarueri.ConsultarSituacao(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteStatusArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteStatusArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteStatusArquivo',
    Request,
    ['NFeLoteStatusArquivoResult'],
    ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']
  );
end;

function TACBrNFSeXWebserviceISSBarueri.ConsultarLote(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteBaixarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteBaixarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteBaixarArquivo',
    Request,
    ['NFeLoteBaixarArquivoResult'],
    ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']
  );
end;

function TACBrNFSeXWebserviceISSBarueri.Cancelar(ACabecalho, AMSG: String): string;
var
  Request: string;
begin
  FPMsgOrig := AMSG;

  Request := '<nfe:NFeLoteEnviarArquivo>';
  Request := Request + '<nfe:VersaoSchema>1</nfe:VersaoSchema>';
  Request := Request + '<nfe:MensagemXML>';
  Request := Request + IncluirCDATA(AMSG);
  Request := Request + '</nfe:MensagemXML>';
  Request := Request + '</nfe:NFeLoteEnviarArquivo>';

  Result := Executar('http://www.barueri.sp.gov.br/nfe/NFeLoteEnviarArquivo',
    Request,
    ['NFeLoteEnviarArquivoResult'],
    ['xmlns:nfe="http://www.barueri.sp.gov.br/nfe"']
  );
end;

{ TACBrNFSeProviderISSBarueri }

function TACBrNFSeProviderISSBarueri.ExisteErroRegistro(const ALinha: String): Boolean;
begin
  Result := (Length(ALinha) > 1971) and (
    (ALinha[1] = '1') or
    (ALinha[1] = '2') or
    (ALinha[1] = '3') or
    (ALinha[1] = '9')
  );
end;

procedure TACBrNFSeProviderISSBarueri.Configuracao;
begin
  inherited Configuracao;

  with ConfigGeral do
  begin
    Identificador := '';
    UseCertificateHTTP := True;
    ModoEnvio := meLoteAssincrono;
    ConsultaNFSe := False;
  end;

  with ConfigMsgDados do
  begin
    Prefixo := 'nfe';
    LoteRps.DocElemento := 'NFeLoteEnviarArquivo';
    LoteRps.xmlns := 'http://www.barueri.sp.gov.br/nfe';
    ConsultarSituacao.DocElemento := 'NFeLoteStatusArquivo';
    ConsultarSituacao.xmlns := 'http://www.barueri.sp.gov.br/nfe';
    ConsultarLote.DocElemento := 'NFeLoteBaixarArquivo';
    ConsultarLote.xmlns := 'http://www.barueri.sp.gov.br/nfe';
    GerarNSLoteRps := False;
    GerarPrestadorLoteRps := False;
    UsarNumLoteConsLote := False;
  end;

  SetXmlNameSpace('http://www.barueri.sp.gov.br/nfe');
  ConfigSchemas.Validar := False;
end;

function TACBrNFSeProviderISSBarueri.CriarGeradorXml(const ANFSe: TNFSe): TNFSeWClass;
begin
  Result := TNFSeW_ISSBarueri.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSBarueri.CriarLeitorXml(const ANFSe: TNFSe): TNFSeRClass;
begin
  Result := TNFSeR_ISSBarueri.Create(Self);
  Result.NFSe := ANFSe;
end;

function TACBrNFSeProviderISSBarueri.CriarServiceClient(const AMetodo: TMetodo): TACBrNFSeXWebservice;
var
  URL: string;
begin
  URL := GetWebServiceURL(AMetodo);

  if URL <> '' then
    Result := TACBrNFSeXWebserviceISSBarueri.Create(FAOwner, AMetodo, URL)
  else
    raise EACBrDFeException.Create('ERR_SEM_URL');
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoEmitir(Response: TNFSeEmiteResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;
  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);
      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');
      Response.Sucesso := (Response.Erros.Count = 0);
      ANode := Document.Root;
      Response.Data := Now;
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('ProtocoloRemessa'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.GerarMsgDadosEmitir(Response: TNFSeEmiteResponse; Params: TNFSeParamsResponse);
var
  XML, NumeroRps: String;
  Emitente: TEmitenteConfNFSe;
begin
  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;
  NumeroRps := TACBrNFSeX(FAOwner).NotasFiscais.Items[0].NFSe.IdentificacaoRps.Numero;

  if (EstaVazio(NumeroRps)) then
    NumeroRps := FormatDateTime('yyyymmddzzz', Now);

  XML := '<NFeLoteEnviarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArquivoRPS>' + Format('Rps-0%s.txt', [NumeroRps]) + '</NomeArquivoRPS>';
  XML := XML + '<ApenasValidaArq>false</ApenasValidaArq>';
  XML := XML + '<ArquivoRPSBase64>' + string(EncodeBase64(AnsiString(Params.Xml))) + '</ArquivoRPSBase64>';
  XML := XML + '</NFeLoteEnviarArquivo>';

  Response.ArquivoEnvio := XML;
end;
function TACBrNFSeProviderISSBarueri.PrepararRpsParaLote(const aXml: string): string;
begin
  Result := aXml;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML: String;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := Desc101;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteStatusArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<ProtocoloRemessa>' + Response.Protocolo + '</ProtocoloRemessa>';
  XML := XML + '</NFeLoteStatusArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoConsultaSituacao(Response: TNFSeConsultaSituacaoResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode, AuxNode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      AuxNode := ANode.Childrens.FindAnyNs('ListaNfeArquivosRPS');

      if (AuxNode = Nil) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      Response.Data := Iso8601ToDateTime(ObterConteudoTag(AuxNode.Childrens.FindAnyNs('DataEnvioArq'), tcStr));
      Response.NumeroRps := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('CodigoRemessa'), tcStr);
      Response.Protocolo := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('NomeArqRetorno'), tcStr);
      Response.Situacao := ObterConteudoTag(AuxNode.Childrens.FindAnyNs('SituacaoArq'), tcStr);

      if (Response.Situacao = '-2') then
        Response.DescSituacao := 'Aguardando Processamento'
      else if (Response.Situacao = '-1') then
        Response.DescSituacao := 'Em Processamento'
      else if (Response.Situacao = '0') then
        Response.DescSituacao := 'Arquivo Validado'
      else if (Response.Situacao = '1') then
        Response.DescSituacao := 'Arquivo Importado'
      else if (Response.Situacao = '2') then
        Response.DescSituacao := 'Arquivo com Erros';
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML, NumeroRps, xRps: String;
  Nota: TNotaFiscal;
begin
  if EstaVazio(Response.InfCancelamento.NumeroNFSe) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod108;
    AErro.Descricao := Desc108;
  end;
  {
  if (Response.InfCancelamento.DataEmissaoNFSe <= 0) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod122;
    AErro.Descricao := Desc122;
  end;
  }
  if EstaVazio(Response.InfCancelamento.CodCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod109;
    AErro.Descricao := Desc109;
  end;

  if EstaVazio(Response.InfCancelamento.MotCancelamento) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod110;
    AErro.Descricao := Desc110;
  end;

  if (TACBrNFSeX(FAOwner).NotasFiscais.Count <= 0) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod002;
    AErro.Descricao := Desc002;
  end;

  if (Response.Erros.Count > 0) then
  begin
    Response.Sucesso := False;
    Exit;
  end;

  Nota := Nil;
  NumeroRps := '';

  if (Response.InfCancelamento.NumeroRps > 0) then
  begin
    NumeroRps := IntToStr(Response.InfCancelamento.NumeroRps);
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumeroRps);
  end;

  if (EstaVazio(NumeroRps)) then
  begin
    NumeroRps := Response.InfCancelamento.NumeroNFSe;
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.FindByNFSe(NumeroRps);
  end;

  if (Nota = Nil) then
    Nota := TACBrNFSeX(FAOwner).NotasFiscais.Items[0];

  Nota.NFSe.StatusRps := srCancelado;
  Nota.NFSe.MotivoCancelamento := Response.InfCancelamento.MotCancelamento;
  Nota.NFSe.CodigoCancelamento := Response.InfCancelamento.CodCancelamento;
  Nota.GerarXML;

  Nota.XmlRps := AplicarXMLtoUTF8(Nota.XmlRps);
  Nota.XmlRps := AplicarLineBreak(Nota.XmlRps, '');

  SalvarXmlRps(Nota);

  xRps := RemoverDeclaracaoXML(Nota.XmlRps);
  xRps := PrepararRpsParaLote(xRps);

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteEnviarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArquivoRPS>' + Format('Rps-Canc-%s.txt', [NumeroRps]) + '</NomeArquivoRPS>';
  XML := XML + '<ApenasValidaArq>false</ApenasValidaArq>';
  XML := XML + '<ArquivoRPSBase64>' + string(EncodeBase64(AnsiString(xRps))) + '</ArquivoRPSBase64>';
  XML := XML + '</NFeLoteEnviarArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoCancelaNFSe(Response: TNFSeCancelaNFSeResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
begin
  Document := TACBrXmlDocument.Create;

  try
    try
      if Response.ArquivoRetorno = '' then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      Response.Data := Now;
      Response.Protocolo := ObterConteudoTag(ANode.Childrens.FindAnyNs('ProtocoloRemessa'), tcStr);
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.PrepararConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  AErro: TNFSeEventoCollectionItem;
  Emitente: TEmitenteConfNFSe;
  XML: String;
begin
  if EstaVazio(Response.Protocolo) then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := Cod101;
    AErro.Descricao := Desc101;
    Exit;
  end;

  Emitente := TACBrNFSeX(FAOwner).Configuracoes.Geral.Emitente;

  XML := '<NFeLoteBaixarArquivo xmlns="http://www.barueri.sp.gov.br/nfe">';
  XML := XML + '<InscricaoMunicipal>' + Emitente.InscMun + '</InscricaoMunicipal>';
  XML := XML + '<CPFCNPJContrib>' + Emitente.CNPJ + '</CPFCNPJContrib>';
  XML := XML + '<NomeArqRetorno>' + Response.Protocolo + '</NomeArqRetorno>';
  XML := XML + '</NFeLoteBaixarArquivo>';

  Response.ArquivoEnvio := XML;
end;

procedure TACBrNFSeProviderISSBarueri.TratarRetornoConsultaLoteRps(Response: TNFSeConsultaLoteRpsResponse);
var
  Document: TACBrXmlDocument;
  AErro: TNFSeEventoCollectionItem;
  ANode: TACBrXmlNode;
  ArquivoBase64: String;
  Dados: TStringList;
  NumRps: String;
  ListaErros: TACBrNFSeProviderBarueriErros;
  Erros: TStringList;
  ANota: TNotaFiscal;
  I, X: Integer;
  XML: string;
begin
  Document := TACBrXmlDocument.Create;
  Dados := TStringList.Create;
  ListaErros := TACBrNFSeProviderBarueriErros.Create;
  Erros := TStringList.Create;
  Erros.Delimiter := ';';

  try
    try
      if EstaVazio(Response.ArquivoRetorno) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      Document.LoadFromXml(Response.ArquivoRetorno);

      ProcessarMensagemErros(Document.Root, Response, 'ListaMensagemRetorno');

      Response.Sucesso := (Response.Erros.Count = 0);

      ANode := Document.Root;
      ArquivoBase64 := ObterConteudoTag(ANode.Childrens.FindAnyNs('ArquivoRPSBase64'), tcStr);

      if (EstaVazio(ArquivoBase64) and (not ACBrUtil.Strings.StrIsBase64(ArquivoBase64))) then
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod201;
        AErro.Descricao := Desc201;
        Exit;
      end;

      {$IFDEF FPC}
      Dados.LineBreak := CRLF;
      {$ELSE}
        {$IFDEF DELPHI2006_UP}
        Dados.LineBreak := CRLF;
        {$ENDIF}
      {$ENDIF}

      Dados.Text := string(DecodeBase64(AnsiString(ArquivoBase64)));

      for I := 0 to Pred(Dados.Count) do
      begin
        if (ExisteErroRegistro(Dados[I])) then
        begin
          // A partir do caractere 1971, � a listagem de codigo de erros
          Erros.DelimitedText := Trim(Copy(Dados[I], 1971, Length(Dados[I])));

          for X := 0 to Pred(Erros.Count) do
          begin
            if NaoEstaVazio(Erros[X]) then
            begin
              AErro := Response.Erros.New;
              AErro.Codigo := Erros[X];
              AErro.Descricao := ListaErros.Causa(Erros[X]);
              AErro.Correcao := ListaErros.Solucao(Erros[X]);
            end;
          end;
        end;
      end;

      Response.Sucesso := (Response.Erros.Count = 0);

      NumRps := Trim(Copy(Dados[0], Pos('PMB002', Dados[0]), Length(Dados[0])));
      NumRps := StringReplace(NumRps, 'PMB002', '', [rfReplaceAll]);
      Response.NumeroRps := NumRps;

      //Retorno do Txt de um RPS Processado com sucesso...
      if ( (Response.Sucesso) and (Length(Dados[0]) > 26) ) then
      begin
        //1XXXXXXX0000000000000000PMB00200000000004
        //2     00000120220318211525723K.1473.0553.5240699-I...
        //Onde 723K.1473.0553.5240699-I � o Codigo de verificacao para fazer download do XML
        Response.Situacao := '1';
        Response.DescSituacao := 'Arquivo Importado';
        Response.Protocolo := Trim(Copy(Dados[1], 27, 24));
        Response.NumeroNota := Trim(Copy(Dados[1], 7, 6));
        Response.SerieRps := Trim(Copy(Dados[1], 51, 4));
        Response.SerieNota := Trim(Copy(Dados[1], 2, 5));

        if NaoEstaVazio(Trim(Copy(Dados[1], 22, 6))) then
        begin
          Response.Data := EncodeDataHora(Trim(Copy(Dados[1], 13, 8)), 'YYYYMMDD');
          Response.Data := Response.Data + StrToTime(Format('%S:%S:%S', [Trim(Copy(Dados[1], 21, 2)), Trim(Copy(Dados[1], 23, 2)), Trim(Copy(Dados[1], 25, 2))]));
        end
        else
          Response.Data := EncodeDataHora(Trim(Copy(Dados[1], 13, 8)), 'YYYYMMDD');

        if (FAOwner.Configuracoes.WebServices.AmbienteCodigo = 1) then
        begin
          Response.Link := 'https://www.barueri.sp.gov.br/nfe/xmlNFe.ashx?codigoautenticidade=' + Response.Protocolo + '&numdoc=' + Trim(Copy(Dados[1], 94, 14));
        end;

        if NaoEstaVazio(Response.Link) then
        begin
          XML := string(FAOwner.SSL.HTTPGet(Response.Link));

          if (NaoEstaVazio(XML) and (Pos('<ConsultarNfeServPrestadoResposta', XML) > 0) ) then
          begin
            XML := RemoverDeclaracaoXML(XML);
            XML := ConverteXMLtoUTF8(XML);
            Document.Clear();
            Document.LoadFromXml(XML);
            Dados.Clear;
            Dados.Text := XML;
          end;
        end;

        ANota := TACBrNFSeX(FAOwner).NotasFiscais.FindByRps(NumRps);

        ANota := CarregarXmlNfse(ANota, Dados.Text);
        SalvarXmlNfse(ANota);
      end;
    except
      on E:Exception do
      begin
        AErro := Response.Erros.New;
        AErro.Codigo := Cod999;
        AErro.Descricao := Desc999 + E.Message;
      end;
    end;
  finally
    FreeAndNil(Document);
    FreeAndNil(Dados);
    FreeAndNil(Erros);
    FreeAndNil(ListaErros);
  end;
end;

procedure TACBrNFSeProviderISSBarueri.ProcessarMensagemErros(
  RootNode: TACBrXmlNode; Response: TNFSeWebserviceResponse;
  const AListTag: string; const AMessageTag: string);
var
  Codigo: String;
  ANode: TACBrXmlNode;
  AErro: TNFSeEventoCollectionItem;
begin
  ANode := RootNode.Childrens.FindAnyNs(AListTag);

  if (ANode = Nil) then Exit;
  Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);

  if (Codigo <> 'OK200') then
  begin
    AErro := Response.Erros.New;
    AErro.Codigo := ObterConteudoTag(ANode.Childrens.FindAnyNs('Codigo'), tcStr);
    AErro.Descricao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Mensagem'), tcStr);
    AErro.Correcao := ObterConteudoTag(ANode.Childrens.FindAnyNs('Correcao'), tcStr);
  end;
  {
    As tag que contem o c�digo, mensagem e corre��o do erro s�o diferentes do padr�o
    <NFeLoteEnviarArquivoResult>
        <ListaMensagemRetorno>
            <Codigo>OK200</Codigo>
            <Mensagem>Procedimento executado com sucesso - Arquivo agendado para processamento: RPS-1.txt</Mensagem>
            <Correcao/>
        </ListaMensagemRetorno>
        <ProtocoloRemessa>ENV555318486B20220316155838</ProtocoloRemessa>
    </NFeLoteEnviarArquivoResult>
    <ListaMensagemRetorno>
        <Codigo>E0001</Codigo>
        <Mensagem>Certificado digital inv�lido ou n�o informado</Mensagem>
        <Correcao>Informe um certificado v�lido padr�o ICP-Brasil</Correcao>
    </ListaMensagemRetorno>
  }
end;

function TACBrNFSeProviderISSBarueri.AplicarXMLtoUTF8(AXMLRps: String): String;
begin
  Result := string(NativeStringToUTF8(AXMLRps));
end;

function TACBrNFSeProviderISSBarueri.AplicarLineBreak(AXMLRps: String; const ABreak: String): String;
begin
  Result := AXMLRps;
end;

end.

