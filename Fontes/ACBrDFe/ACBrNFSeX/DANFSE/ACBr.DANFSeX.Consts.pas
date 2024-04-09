unit ACBr.DANFSeX.Consts;

interface

const

  {Marca d'�gua}
  SMsgHomologacaoSemValorFiscal : string = 'AMBIENTE DE HOMOLOGA��O - SEM VALOR FISCAL';
  SMsgNFSeCancelada             : string = 'NFS-e CANCELADA';
  {Cabe�alho}
  STituloNFSe         : string = 'Nota Fiscal de Servi�o Eletr�nica - NFS-e';
  SNumNota            : string = 'N�mero da Nota';
  SDataHoraEmissao    : string = 'Data e Hora de Emiss�o';
  SNumNFSeSubstituida : string = 'N�mero NFSe substitu�da:';
  SCompetencia        : string = 'Compet�ncia:';
  SNumRPS             : string = 'Num. RPS/Ser.:';
  SMunicipioPrestacao : string = 'Munic�pio de Presta��o do Servi�o:';
  SCodigoVerificacao  : string = 'C�digo de Verifica��o';
  SPagina             : string = 'P�gina';
  {Prestador}
  STituloPrestadorServicos  : string = 'PRESTADOR DE SERVI�OS';
  SPrestadorNomeRazaoSocial : string = 'Nome/Raz�o Social: ';
  SPrestadorCPFCNPJ         : string = 'CPF/CNPJ: ';
  SPrestadorInscEst         : string = 'IE: ';
  SPrestadorInscMuni        : string = 'IM: ';
  {Tomador}
  STituloTomadorServicos      : string = 'TOMADOR DE SERVI�OS';
  STomadorNomeRazaoSocial     : string = 'Nome/Raz�o Social: ';
  STomadorCPFCNPJ             : string = 'CPF/CNPJ: ';
  STomadorNIF                 : string = 'NIF: ';
  STomadorInscEst             : string = 'Inscri��o Estadual: ';
  STomadorInscMuni            : string = 'Inscri��o Municipal: ';
  STomadorEndereco            : string = 'Endere�o: ';
  STomadorEnderecoComplemento : string = 'Complemento: ';
  STomadorMunicipio           : string = 'Munic�pio: ';
  STomadorUF                  : string = 'UF: ';
  STomadorEmail               : string = 'e-mail: ';
  STomadorTelefone            : string = 'Telefone: ';
  {Servicos}
  STituloDiscriminacaoServicos : string = 'DISCRIMINA��O DOS SERVI�OS';
  SServTitColunaDescricao      : string = 'Descri��o';
  SServTitColunaValorUnitario  : string = 'Valor Unit�rio';
  SServTitColunaQuantidade     : string = 'Qtde';
  SServTitColunaValorServico   : string = 'Valor do Servi�o';
  SServTitColunaBaseCalculo    : string = 'Base de C�lc.(%)';
  SServTitColunaISS            : string = 'ISS';
  SServCodigoServico             : string = 'C�digo do Servi�o: ';
  SServAtividade                 : string = 'Atividade: ';
  SServCodigoTributacaoMunicipio : string = 'C�digo de Tributa��o do Munic�pio: ';
  {Constru��o Civil}
  STituloConstrucaoCivil       : string = 'DETALHAMENTO ESPECIFICO DA CONSTRU��O CIVIL';
  SConstrCivilCodObra          : string = 'C�digo da Obra: ';
  SConstrCivilCodART           : string = 'C�digo ART: ';
  {Tributos e Detalhes}
  STituloTributosFederais : string = 'TRIBUTOS FEDERAIS';
  STribFedPIS             : string = 'PIS (R$)';
  STribFedCOFINS          : string = 'COFINS (R$)';
  STribFedIR              : string = 'IR (R$)';
  STribFedINSS            : string = 'INSS (R$)';
  STribFedCSLL            : string = 'CSLL (R$)';

  SCabecalhoTribDetalhamentoValores  : string = 'Detalhamento de Valores - Prestador dos Servi�os ';
  STribDetVal_ValorServicos          : string = 'Valor dos Servi�os';
  STribDetVal_DescontoIncondicionado : string = '(-) Desconto Incondicionado';
  STribDetVal_DescontoCondicionado   : string = '(-) Desconto Condicionado';
  STribDetVal_RetencoesFederais      : string = '(-) Reten��es Federais';
  STribDetVal_OutrasRetencoes        : string = '(-) Outras Reten��es';
  STribDetVal_ISSRetido              : string = '(-) ISS Retido';
  STribDetVal_ValorLiquido           : string = '(=) Valor L�quido';

  SCabecalhoTribOutrasInformacoes   : string = 'Outras Informa��es ';
  STribOutrInf_NaturezaOperacao     : string = 'Natureza da Opera��o';
  STribOutrInf_RegimeEspecial       : string = 'Regime Especial de Tributa��o';
  STribOutrInf_OpcaoSimplesNacional : string = 'Op��o Simples Nacional = ';
  STribOutrInf_IncentivadorCultural : string = 'Incentivador Cultural = ';

  SCabecalhoTribCalculoISSQNDevido      : string = 'C�lculo do ISSQN devido no Munic�pio';
  STribCalcISSQN_ValorServicos          : string = 'Valor dos Servi�os';
  STribCalcISSQN_DeducoesPermitidas     : string = '(-) Dedu��es permitidas em Lei';
  STribCalcISSQN_DescontoIncondicionado : string = '(-) Desconto Incondicionado';
  STribCalcISSQN_BaseCalculo            : string = '(=) Base de C�lculo';
  STribCalcISSQN_Aliquota               : string = '(x) Al�quota (%) 2,00';
  STribCalcISSQN_ISSAReter              : string = 'ISS a reter:';
  STribCalcISSQN_ValorISS               : string = '(=) Valor ISS';

  STribValorTotalNota: string = 'VALOR TOTAL DA NOTA = R$ ';
  {Outras Informa��es}
  STituloOutrasInformacoes  : string = 'OUTRAS INFORMA��ES';
  sOutrasInfDataHora        : string = 'DATA E HORA DA IMPRESS�O:';
  sOutrasInfUsuario         : string = 'USU�RIO:';
  sOutrasInfDesenvolvidoPor : string = 'Desenvolvido por';
  {CanhotoRecibo}
  SCanhotoRecibo_Recebemos                : string = 'Recebi(emos) de';
  SCanhotoRecibo_OsServicosConstantes     : string = 'os servi�os constantes da Nota Fiscal Eletronica de Servi�o  (NFSe) ao lado.';
  SCanhotoRecibo_Emissao                  : string = 'Emiss�o:';
  SCanhotoRecibo_Tomador                  : string = '-Tomador:';
  SCanhotoRecibo_Total                    : string = '-Total:';
  SCanhotoRecibo_Data                     : string = 'DATA';
  SCanhotoRecibo_DataPlaceHolder          : string = '_______ / _______ / __________';
  SCanhotoRecibo_IntentificacaoAssinatura : string = 'Identifica��o e Assinatura do Recebedor';
  SCanhotoRecibo_NumeroNota               : string = 'N�mero da Nota';

implementation

end.
