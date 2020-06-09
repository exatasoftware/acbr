object dmForte: TdmForte
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ACBrBoletoReport: TACBrBoletoFCFortes
    MostrarSetup = False
    SoftwareHouse = 'Projeto ACBr - http://acbr.sf.net'
    DirLogo = '..\..\..\Fontes\ACBrBoleto\Logos\Colorido'
    NomeArquivo = 'boleto.pdf'
    Left = 128
    Top = 30
  end
  object ACBrBoleto: TACBrBoleto
    Banco.Numero = 341
    Banco.TamanhoMaximoNossoNum = 8
    Banco.TipoCobranca = cobItau
    Banco.LayoutVersaoArquivo = 0
    Banco.LayoutVersaoLote = 0
    Banco.CasasDecimaisMoraJuros = 2
    Banco.DensidadeGravacao = '0'
    Cedente.Nome = 'TodaObra Materias p/ Construcao'
    Cedente.CodigoCedente = '4266443'
    Cedente.Agencia = '0284'
    Cedente.AgenciaDigito = '5'
    Cedente.Conta = '79489'
    Cedente.ContaDigito = '9'
    Cedente.CNPJCPF = '05.481.336/0001-37'
    Cedente.TipoInscricao = pJuridica
    Cedente.CedenteWS.ClientID = 'SGCBS02P'
    Cedente.IdentDistribuicao = tbBancoDistribui
    DirArqRemessa = 'c:\temp'
    NumeroArquivo = 0
    ACBrBoletoFC = ACBrBoletoReport
    Configuracoes.Arquivos.LogRegistro = True
    Configuracoes.WebService.SSLHttpLib = httpOpenSSL
    Configuracoes.WebService.SSLType = LT_TLSv1_2
    Configuracoes.WebService.StoreName = 'My'
    Configuracoes.WebService.TimeOut = 30000
    Configuracoes.WebService.UseCertificateHTTP = False
    Configuracoes.WebService.Ambiente = taHomologacao
    Configuracoes.WebService.Operacao = tpInclui
    Configuracoes.WebService.VersaoDF = '1.2'
    Left = 32
    Top = 30
  end
end
