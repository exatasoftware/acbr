object frmDemo_ACBrANe: TfrmDemo_ACBrANe
  Left = 224
  Top = 128
  Caption = 'Demo ACBrANe'
  ClientHeight = 633
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 633
    Align = alLeft
    TabOrder = 0
    object lblColaborador: TLabel
      Left = 10
      Top = 550
      Width = 261
      Height = 13
      Cursor = crHandPoint
      Caption = 'Veja a lista de Colaboradores do Projeto ACBr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblColaboradorClick
    end
    object lblPatrocinador: TLabel
      Left = 8
      Top = 574
      Width = 265
      Height = 13
      Cursor = crHandPoint
      Caption = 'Veja a lista de Patrocinadores do Projeto ACBr'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblPatrocinadorClick
    end
    object lblDoar1: TLabel
      Left = 13
      Top = 598
      Width = 255
      Height = 13
      Cursor = crHandPoint
      Caption = 'Para se tornar Patrocinador do Projeto ACBr,'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = lblDoar1Click
    end
    object lblDoar2: TLabel
      Left = 109
      Top = 614
      Width = 63
      Height = 13
      Cursor = crHandPoint
      Caption = 'clique aqui'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnSalvarConfig: TBitBtn
      Left = 62
      Top = 520
      Width = 153
      Height = 25
      Caption = 'Salvar Configura'#231#245'es'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333330070
        7700333333337777777733333333008088003333333377F73377333333330088
        88003333333377FFFF7733333333000000003FFFFFFF77777777000000000000
        000077777777777777770FFFFFFF0FFFFFF07F3333337F3333370FFFFFFF0FFF
        FFF07F3FF3FF7FFFFFF70F00F0080CCC9CC07F773773777777770FFFFFFFF039
        99337F3FFFF3F7F777F30F0000F0F09999937F7777373777777F0FFFFFFFF999
        99997F3FF3FFF77777770F00F000003999337F773777773777F30FFFF0FF0339
        99337F3FF7F3733777F30F08F0F0337999337F7737F73F7777330FFFF0039999
        93337FFFF7737777733300000033333333337777773333333333}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnSalvarConfigClick
    end
    object PageControl3: TPageControl
      Left = 8
      Top = 9
      Width = 283
      Height = 504
      ActivePage = TabSheet11
      TabOrder = 1
      object TabSheet11: TTabSheet
        Caption = 'Configura'#231#245'es'
        object PageControl4: TPageControl
          Left = 0
          Top = 0
          Width = 275
          Height = 476
          ActivePage = TabSheet13
          Align = alClient
          MultiLine = True
          TabOrder = 0
          object TabSheet12: TTabSheet
            Caption = 'Certificado'
            object lSSLLib: TLabel
              Left = 35
              Top = 16
              Width = 34
              Height = 13
              Alignment = taRightJustify
              Caption = 'SSLLib'
              Color = clBtnFace
              ParentColor = False
            end
            object lCryptLib: TLabel
              Left = 31
              Top = 43
              Width = 38
              Height = 13
              Alignment = taRightJustify
              Caption = 'CryptLib'
              Color = clBtnFace
              ParentColor = False
            end
            object lHttpLib: TLabel
              Left = 35
              Top = 70
              Width = 34
              Height = 13
              Alignment = taRightJustify
              Caption = 'HttpLib'
              Color = clBtnFace
              ParentColor = False
            end
            object lXmlSign: TLabel
              Left = 12
              Top = 97
              Width = 57
              Height = 13
              Alignment = taRightJustify
              Caption = 'XMLSignLib'
              Color = clBtnFace
              ParentColor = False
            end
            object gbCertificado: TGroupBox
              Left = 2
              Top = 118
              Width = 263
              Height = 144
              Caption = 'Certificado'
              TabOrder = 0
              object Label33: TLabel
                Left = 8
                Top = 16
                Width = 41
                Height = 13
                Caption = 'Caminho'
              end
              object Label34: TLabel
                Left = 8
                Top = 56
                Width = 31
                Height = 13
                Caption = 'Senha'
              end
              object sbtnCaminhoCert: TSpeedButton
                Left = 235
                Top = 32
                Width = 23
                Height = 24
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                  333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                  0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                  07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                  07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                  0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                  B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                  3BB33773333773333773B333333B3333333B7333333733333337}
                NumGlyphs = 2
                OnClick = sbtnCaminhoCertClick
              end
              object Label35: TLabel
                Left = 8
                Top = 96
                Width = 79
                Height = 13
                Caption = 'N'#250'mero de S'#233'rie'
              end
              object sbtnListaCert: TSpeedButton
                Left = 235
                Top = 110
                Width = 23
                Height = 24
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                  333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                  0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                  07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                  07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                  0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                  B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                  3BB33773333773333773B333333B3333333B7333333733333337}
                NumGlyphs = 2
                OnClick = sbtnListaCertClick
              end
              object sbtnGetCert: TSpeedButton
                Left = 206
                Top = 110
                Width = 23
                Height = 24
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                  333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                  0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                  07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                  07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                  0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                  B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                  3BB33773333773333773B333333B3333333B7333333733333337}
                NumGlyphs = 2
                OnClick = sbtnGetCertClick
              end
              object edtCaminho: TEdit
                Left = 8
                Top = 32
                Width = 225
                Height = 21
                TabOrder = 0
              end
              object edtSenha: TEdit
                Left = 8
                Top = 72
                Width = 249
                Height = 21
                PasswordChar = '*'
                TabOrder = 1
              end
              object edtNumSerie: TEdit
                Left = 8
                Top = 112
                Width = 193
                Height = 21
                TabOrder = 2
              end
            end
            object btnDataValidade: TButton
              Left = 8
              Top = 266
              Width = 99
              Height = 25
              Caption = 'Data de Validade'
              TabOrder = 1
              OnClick = btnDataValidadeClick
            end
            object btnNumSerie: TButton
              Left = 112
              Top = 266
              Width = 73
              Height = 25
              Caption = 'Num.S'#233'rie'
              TabOrder = 2
              OnClick = btnNumSerieClick
            end
            object btnSubjectname: TButton
              Left = 8
              Top = 298
              Width = 99
              Height = 25
              Caption = 'Subject Name'
              TabOrder = 3
              OnClick = btnSubjectnameClick
            end
            object btnCNPJ: TButton
              Left = 112
              Top = 298
              Width = 73
              Height = 25
              Caption = 'CNPJ'
              TabOrder = 4
              OnClick = btnCNPJClick
            end
            object btnIssuerName: TButton
              Left = 188
              Top = 298
              Width = 76
              Height = 25
              Caption = 'Issuer Name'
              TabOrder = 5
              OnClick = btnIssuerNameClick
            end
            object GroupBox6: TGroupBox
              Left = 2
              Top = 328
              Width = 263
              Height = 69
              Caption = 'Calculo de Hash e assinatura'
              TabOrder = 6
              object edtHash: TEdit
                Left = 3
                Top = 14
                Width = 249
                Height = 21
                TabOrder = 0
                Text = '0548133600013704583493000190'
              end
              object btnSHA256: TButton
                Left = 8
                Top = 41
                Width = 99
                Height = 25
                Caption = 'SHA256+RSA'
                TabOrder = 1
                OnClick = btnSHA256Click
              end
              object cbAssinar: TCheckBox
                Left = 144
                Top = 41
                Width = 54
                Height = 19
                Caption = 'Assinar'
                Checked = True
                State = cbChecked
                TabOrder = 2
              end
            end
            object btnHTTPS: TButton
              Left = 8
              Top = 403
              Width = 128
              Height = 25
              Caption = 'HTTPS sem Certificado'
              TabOrder = 7
              OnClick = btnHTTPSClick
            end
            object btnLeituraX509: TButton
              Left = 144
              Top = 403
              Width = 115
              Height = 25
              Caption = 'Leitura de X509'
              TabOrder = 8
              OnClick = btnLeituraX509Click
            end
            object cbSSLLib: TComboBox
              Left = 80
              Top = 8
              Width = 160
              Height = 21
              Style = csDropDownList
              TabOrder = 9
              OnChange = cbSSLLibChange
            end
            object cbCryptLib: TComboBox
              Left = 80
              Top = 35
              Width = 160
              Height = 21
              Style = csDropDownList
              TabOrder = 10
              OnChange = cbCryptLibChange
            end
            object cbHttpLib: TComboBox
              Left = 80
              Top = 62
              Width = 160
              Height = 21
              Style = csDropDownList
              TabOrder = 11
              OnChange = cbHttpLibChange
            end
            object cbXmlSignLib: TComboBox
              Left = 80
              Top = 89
              Width = 160
              Height = 21
              Style = csDropDownList
              TabOrder = 12
              OnChange = cbXmlSignLibChange
            end
          end
          object TabSheet13: TTabSheet
            Caption = 'Geral'
            ImageIndex = 1
            object GroupBox7: TGroupBox
              Left = 0
              Top = 4
              Width = 265
              Height = 381
              Caption = 'Geral'
              TabOrder = 0
              object sbtnPathSalvar: TSpeedButton
                Left = 235
                Top = 311
                Width = 23
                Height = 24
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                  333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                  0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                  07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                  07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                  0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                  B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                  3BB33773333773333773B333333B3333333B7333333733333337}
                NumGlyphs = 2
                OnClick = sbtnPathSalvarClick
              end
              object Label36: TLabel
                Left = 8
                Top = 88
                Width = 86
                Height = 13
                Caption = 'Forma de Emiss'#227'o'
              end
              object Label37: TLabel
                Left = 8
                Top = 50
                Width = 68
                Height = 13
                Caption = 'Formato Alerta'
              end
              object Label38: TLabel
                Left = 8
                Top = 126
                Width = 123
                Height = 13
                Caption = 'Modelo Documento Fiscal'
              end
              object Label39: TLabel
                Left = 8
                Top = 165
                Width = 121
                Height = 13
                Caption = 'Vers'#227'o Documento Fiscal'
              end
              object Label42: TLabel
                Left = 8
                Top = 336
                Width = 199
                Height = 13
                Caption = 'Diret'#243'rios com os arquivos XSD(Schemas)'
              end
              object sbPathSchemas: TSpeedButton
                Left = 235
                Top = 351
                Width = 23
                Height = 24
                Glyph.Data = {
                  76010000424D7601000000000000760000002800000020000000100000000100
                  04000000000000010000130B0000130B00001000000000000000000000000000
                  800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                  FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                  333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                  0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                  07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                  07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                  0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                  33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                  B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                  3BB33773333773333773B333333B3333333B7333333733333337}
                NumGlyphs = 2
                OnClick = sbPathSchemasClick
              end
              object Label30: TLabel
                Left = 8
                Top = 204
                Width = 36
                Height = 13
                Caption = 'Usu'#225'rio'
              end
              object Label31: TLabel
                Left = 138
                Top = 204
                Width = 31
                Height = 13
                Caption = 'Senha'
              end
              object Label32: TLabel
                Left = 8
                Top = 242
                Width = 59
                Height = 13
                Caption = 'C'#243'digo ATM'
              end
              object Label1: TLabel
                Left = 135
                Top = 242
                Width = 55
                Height = 13
                Caption = 'Seguradora'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object edtPathLogs: TEdit
                Left = 8
                Top = 315
                Width = 228
                Height = 21
                TabOrder = 0
              end
              object ckSalvar: TCheckBox
                Left = 8
                Top = 299
                Width = 209
                Height = 15
                Caption = 'Salvar Arquivos de Envio e Resposta'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
              end
              object cbFormaEmissao: TComboBox
                Left = 8
                Top = 104
                Width = 248
                Height = 21
                TabOrder = 2
              end
              object edtFormatoAlerta: TEdit
                Left = 8
                Top = 66
                Width = 248
                Height = 21
                TabOrder = 3
              end
              object cbModeloDF: TComboBox
                Left = 8
                Top = 142
                Width = 248
                Height = 21
                TabOrder = 4
              end
              object cbxRetirarAcentos: TCheckBox
                Left = 8
                Top = 281
                Width = 193
                Height = 17
                Caption = 'Retirar Acentos dos XMLs enviados'
                TabOrder = 5
              end
              object cbVersaoDF: TComboBox
                Left = 8
                Top = 181
                Width = 248
                Height = 21
                TabOrder = 6
              end
              object edtPathSchemas: TEdit
                Left = 8
                Top = 352
                Width = 228
                Height = 21
                TabOrder = 7
              end
              object edtUsuarioATM: TEdit
                Left = 8
                Top = 220
                Width = 123
                Height = 21
                TabOrder = 8
              end
              object edtSenhaATM: TEdit
                Left = 135
                Top = 220
                Width = 123
                Height = 21
                PasswordChar = '*'
                TabOrder = 9
              end
              object edtCodATM: TEdit
                Left = 8
                Top = 258
                Width = 123
                Height = 21
                TabOrder = 10
              end
              object rgAverbar: TRadioGroup
                Left = 8
                Top = 16
                Width = 249
                Height = 33
                Caption = ' Averbar '
                Columns = 2
                ItemIndex = 0
                Items.Strings = (
                  'NF-e'
                  'CT-e')
                TabOrder = 11
              end
              object cbSeguradora: TComboBox
                Left = 135
                Top = 258
                Width = 122
                Height = 24
                Style = csDropDownList
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemIndex = 0
                ParentFont = False
                TabOrder = 12
                Text = 'ATM'
                Items.Strings = (
                  'ATM'
                  'ELT')
              end
            end
          end
          object TabSheet14: TTabSheet
            Caption = 'WebService'
            ImageIndex = 2
            object GroupBox8: TGroupBox
              Left = 0
              Top = 4
              Width = 265
              Height = 190
              Caption = 'WebService'
              TabOrder = 0
              object Label43: TLabel
                Left = 8
                Top = 16
                Width = 205
                Height = 13
                Caption = 'Selecione UF do Web Services Autorizador'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object lTimeOut: TLabel
                Left = 167
                Top = 116
                Width = 40
                Height = 13
                Caption = 'TimeOut'
                Color = clBtnFace
                ParentColor = False
              end
              object lSSLLib1: TLabel
                Left = 16
                Top = 168
                Width = 44
                Height = 13
                Alignment = taRightJustify
                Caption = 'SSLType'
                Color = clBtnFace
                ParentColor = False
              end
              object cbxVisualizar: TCheckBox
                Left = 8
                Top = 118
                Width = 153
                Height = 17
                Caption = 'Visualizar Mensagem'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
              end
              object cbUF: TComboBox
                Left = 8
                Top = 32
                Width = 249
                Height = 24
                Style = csDropDownList
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -13
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemIndex = 24
                ParentFont = False
                TabOrder = 1
                Text = 'SP'
                Items.Strings = (
                  'AC'
                  'AL'
                  'AP'
                  'AM'
                  'BA'
                  'CE'
                  'DF'
                  'ES'
                  'GO'
                  'MA'
                  'MT'
                  'MS'
                  'MG'
                  'PA'
                  'PB'
                  'PR'
                  'PE'
                  'PI'
                  'RJ'
                  'RN'
                  'RS'
                  'RO'
                  'RR'
                  'SC'
                  'SP'
                  'SE'
                  'TO')
              end
              object rgTipoAmb: TRadioGroup
                Left = 8
                Top = 61
                Width = 249
                Height = 52
                Caption = 'Selecione o Ambiente de Destino'
                Columns = 2
                ItemIndex = 0
                Items.Strings = (
                  'Produ'#231#227'o'
                  'Homologa'#231#227'o')
                TabOrder = 2
              end
              object cbxSalvarSOAP: TCheckBox
                Left = 8
                Top = 136
                Width = 153
                Height = 17
                Caption = 'Salvar envelope SOAP'
                TabOrder = 3
              end
              object seTimeOut: TSpinEdit
                Left = 167
                Top = 132
                Width = 66
                Height = 22
                Increment = 10
                MaxValue = 999999
                MinValue = 1000
                TabOrder = 4
                Value = 5000
              end
              object cbSSLType: TComboBox
                Left = 72
                Top = 160
                Width = 160
                Height = 21
                Hint = 'Depende de configura'#231#227'o de  SSL.HttpLib'
                Style = csDropDownList
                TabOrder = 5
                OnChange = cbSSLTypeChange
              end
            end
            object GroupBox9: TGroupBox
              Left = 0
              Top = 283
              Width = 265
              Height = 104
              Caption = 'Proxy'
              TabOrder = 1
              object Label44: TLabel
                Left = 8
                Top = 16
                Width = 22
                Height = 13
                Caption = 'Host'
              end
              object Label45: TLabel
                Left = 208
                Top = 16
                Width = 25
                Height = 13
                Caption = 'Porta'
              end
              object Label46: TLabel
                Left = 8
                Top = 56
                Width = 36
                Height = 13
                Caption = 'Usu'#225'rio'
              end
              object Label47: TLabel
                Left = 138
                Top = 56
                Width = 31
                Height = 13
                Caption = 'Senha'
              end
              object edtProxyHost: TEdit
                Left = 8
                Top = 32
                Width = 193
                Height = 21
                TabOrder = 0
              end
              object edtProxyPorta: TEdit
                Left = 208
                Top = 32
                Width = 50
                Height = 21
                TabOrder = 1
              end
              object edtProxyUser: TEdit
                Left = 8
                Top = 72
                Width = 123
                Height = 21
                TabOrder = 2
              end
              object edtProxySenha: TEdit
                Left = 135
                Top = 72
                Width = 123
                Height = 21
                PasswordChar = '*'
                TabOrder = 3
              end
            end
            object gbxRetornoEnvio: TGroupBox
              Left = 0
              Top = 200
              Width = 265
              Height = 77
              Caption = 'Retorno de Envio de ANe'
              TabOrder = 2
              object Label48: TLabel
                Left = 93
                Top = 27
                Width = 50
                Height = 13
                Caption = 'Tentativas'
              end
              object Label49: TLabel
                Left = 176
                Top = 27
                Width = 41
                Height = 13
                Caption = 'Intervalo'
              end
              object Label50: TLabel
                Left = 8
                Top = 27
                Width = 43
                Height = 13
                Hint = 
                  'Aguardar quantos segundos para primeira consulta de retorno de e' +
                  'nvio'
                Caption = 'Aguardar'
              end
              object cbxAjustarAut: TCheckBox
                Left = 8
                Top = 12
                Width = 234
                Height = 17
                Caption = 'Ajustar Automaticamente prop. "Aguardar"'
                TabOrder = 0
              end
              object edtTentativas: TEdit
                Left = 93
                Top = 43
                Width = 57
                Height = 21
                TabOrder = 2
              end
              object edtIntervalo: TEdit
                Left = 176
                Top = 43
                Width = 57
                Height = 21
                TabOrder = 3
              end
              object edtAguardar: TEdit
                Left = 8
                Top = 43
                Width = 57
                Height = 21
                Hint = 
                  'Aguardar quantos segundos para primeira consulta de retorno de e' +
                  'nvio'
                TabOrder = 1
              end
            end
          end
          object TabSheet15: TTabSheet
            Caption = 'Emitente'
            ImageIndex = 3
            object Label51: TLabel
              Left = 8
              Top = 4
              Width = 27
              Height = 13
              Caption = 'CNPJ'
            end
            object Label52: TLabel
              Left = 136
              Top = 4
              Width = 41
              Height = 13
              Caption = 'Insc.Est.'
            end
            object Label53: TLabel
              Left = 8
              Top = 44
              Width = 63
              Height = 13
              Caption = 'Raz'#227'o Social'
            end
            object Label54: TLabel
              Left = 8
              Top = 84
              Width = 40
              Height = 13
              Caption = 'Fantasia'
            end
            object Label55: TLabel
              Left = 8
              Top = 164
              Width = 54
              Height = 13
              Caption = 'Logradouro'
            end
            object Label56: TLabel
              Left = 208
              Top = 164
              Width = 37
              Height = 13
              Caption = 'N'#250'mero'
            end
            object Label57: TLabel
              Left = 8
              Top = 204
              Width = 64
              Height = 13
              Caption = 'Complemento'
            end
            object Label58: TLabel
              Left = 136
              Top = 204
              Width = 27
              Height = 13
              Caption = 'Bairro'
            end
            object Label59: TLabel
              Left = 8
              Top = 244
              Width = 61
              Height = 13
              Caption = 'C'#243'd. Cidade '
            end
            object Label60: TLabel
              Left = 76
              Top = 244
              Width = 33
              Height = 13
              Caption = 'Cidade'
            end
            object Label61: TLabel
              Left = 225
              Top = 244
              Width = 14
              Height = 13
              Caption = 'UF'
            end
            object Label62: TLabel
              Left = 136
              Top = 124
              Width = 21
              Height = 13
              Caption = 'CEP'
            end
            object Label63: TLabel
              Left = 8
              Top = 124
              Width = 24
              Height = 13
              Caption = 'Fone'
            end
            object edtEmitCNPJ: TEdit
              Left = 8
              Top = 20
              Width = 123
              Height = 21
              TabOrder = 0
            end
            object edtEmitIE: TEdit
              Left = 137
              Top = 20
              Width = 123
              Height = 21
              TabOrder = 1
            end
            object edtEmitRazao: TEdit
              Left = 8
              Top = 60
              Width = 252
              Height = 21
              TabOrder = 2
            end
            object edtEmitFantasia: TEdit
              Left = 8
              Top = 100
              Width = 252
              Height = 21
              TabOrder = 3
            end
            object edtEmitFone: TEdit
              Left = 8
              Top = 140
              Width = 125
              Height = 21
              TabOrder = 4
            end
            object edtEmitCEP: TEdit
              Left = 137
              Top = 140
              Width = 123
              Height = 21
              TabOrder = 5
            end
            object edtEmitLogradouro: TEdit
              Left = 8
              Top = 180
              Width = 196
              Height = 21
              TabOrder = 6
            end
            object edtEmitNumero: TEdit
              Left = 210
              Top = 180
              Width = 50
              Height = 21
              TabOrder = 7
            end
            object edtEmitComp: TEdit
              Left = 8
              Top = 220
              Width = 123
              Height = 21
              TabOrder = 8
            end
            object edtEmitBairro: TEdit
              Left = 137
              Top = 220
              Width = 123
              Height = 21
              TabOrder = 9
            end
            object edtEmitCodCidade: TEdit
              Left = 8
              Top = 260
              Width = 61
              Height = 21
              TabOrder = 10
            end
            object edtEmitCidade: TEdit
              Left = 76
              Top = 260
              Width = 142
              Height = 21
              TabOrder = 11
            end
            object edtEmitUF: TEdit
              Left = 225
              Top = 260
              Width = 35
              Height = 21
              TabOrder = 12
            end
          end
          object TabSheet16: TTabSheet
            Caption = 'Arquivos'
            ImageIndex = 4
            object sbPathANe: TSpeedButton
              Left = 240
              Top = 130
              Width = 23
              Height = 24
              Glyph.Data = {
                76010000424D7601000000000000760000002800000020000000100000000100
                04000000000000010000130B0000130B00001000000000000000000000000000
                800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
                FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
                333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
                0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
                07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
                07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
                0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
                33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
                B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
                3BB33773333773333773B333333B3333333B7333333733333337}
              NumGlyphs = 2
              OnClick = sbPathANeClick
            end
            object Label64: TLabel
              Left = 6
              Top = 116
              Width = 95
              Height = 13
              Caption = 'Pasta Arquivos ANe'
            end
            object cbxSalvarArqs: TCheckBox
              Left = 6
              Top = 0
              Width = 210
              Height = 17
              Caption = 'Salvar Arquivos'
              TabOrder = 0
            end
            object cbxPastaMensal: TCheckBox
              Left = 6
              Top = 16
              Width = 210
              Height = 17
              Caption = 'Criar Pastas Mensalmente'
              TabOrder = 1
            end
            object cbxAdicionaLiteral: TCheckBox
              Left = 6
              Top = 32
              Width = 210
              Height = 17
              Caption = 'Adicionar Literal no nome das pastas'
              TabOrder = 2
            end
            object cbxEmissaoPathANe: TCheckBox
              Left = 6
              Top = 48
              Width = 233
              Height = 17
              Caption = 'Salvar ANe pelo campo Data de Emiss'#227'o'
              TabOrder = 3
            end
            object cbxSepararPorCNPJ: TCheckBox
              Left = 6
              Top = 64
              Width = 233
              Height = 17
              Caption = 'Separar Arqs pelo CNPJ do Certificado'
              TabOrder = 4
            end
            object edtPathANe: TEdit
              Left = 6
              Top = 132
              Width = 235
              Height = 21
              TabOrder = 5
            end
            object cbxSepararPorModelo: TCheckBox
              Left = 6
              Top = 80
              Width = 251
              Height = 17
              Caption = 'Separar Arqs pelo Modelo do Documento'
              TabOrder = 6
            end
          end
        end
      end
      object TabSheet17: TTabSheet
        Caption = 'DAANE'
        ImageIndex = 1
        object Label70: TLabel
          Left = 8
          Top = 8
          Width = 57
          Height = 13
          Caption = 'Logo Marca'
        end
        object sbtnLogoMarca: TSpeedButton
          Left = 235
          Top = 20
          Width = 23
          Height = 24
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
            333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
            0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
            07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
            07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
            0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
            B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
            3BB33773333773333773B333333B3333333B7333333733333337}
          NumGlyphs = 2
          OnClick = sbtnLogoMarcaClick
        end
        object edtLogoMarca: TEdit
          Left = 8
          Top = 24
          Width = 228
          Height = 21
          TabOrder = 0
        end
        object rgTipoDAANE: TRadioGroup
          Left = 8
          Top = 56
          Width = 249
          Height = 49
          Caption = 'DAANE'
          Columns = 2
          ItemIndex = 0
          Items.Strings = (
            'Retrato'
            'Paisagem')
          TabOrder = 1
        end
      end
      object TabSheet18: TTabSheet
        Caption = 'Email'
        ImageIndex = 2
        object Label71: TLabel
          Left = 8
          Top = 8
          Width = 72
          Height = 13
          Caption = 'Servidor SMTP'
        end
        object Label72: TLabel
          Left = 206
          Top = 8
          Width = 25
          Height = 13
          Caption = 'Porta'
        end
        object Label73: TLabel
          Left = 8
          Top = 48
          Width = 36
          Height = 13
          Caption = 'Usu'#225'rio'
        end
        object Label74: TLabel
          Left = 137
          Top = 48
          Width = 31
          Height = 13
          Caption = 'Senha'
        end
        object Label75: TLabel
          Left = 8
          Top = 88
          Width = 121
          Height = 13
          Caption = 'Assunto do email enviado'
        end
        object Label76: TLabel
          Left = 8
          Top = 160
          Width = 95
          Height = 13
          Caption = 'Mensagem do Email'
        end
        object edtSmtpHost: TEdit
          Left = 8
          Top = 24
          Width = 193
          Height = 21
          TabOrder = 0
        end
        object edtSmtpPort: TEdit
          Left = 206
          Top = 24
          Width = 51
          Height = 21
          TabOrder = 1
        end
        object edtSmtpUser: TEdit
          Left = 8
          Top = 64
          Width = 120
          Height = 21
          TabOrder = 2
        end
        object edtSmtpPass: TEdit
          Left = 137
          Top = 64
          Width = 120
          Height = 21
          TabOrder = 3
        end
        object edtEmailAssunto: TEdit
          Left = 8
          Top = 104
          Width = 249
          Height = 21
          TabOrder = 4
        end
        object cbEmailSSL: TCheckBox
          Left = 10
          Top = 136
          Width = 167
          Height = 17
          Caption = 'SMTP exige conex'#227'o segura'
          TabOrder = 5
        end
        object mmEmailMsg: TMemo
          Left = 8
          Top = 176
          Width = 249
          Height = 130
          TabOrder = 6
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 297
    Top = 0
    Width = 564
    Height = 633
    Align = alClient
    TabOrder = 1
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 562
      Height = 40
      Align = alTop
      TabOrder = 0
      object btnCriarEnviar: TButton
        Left = 192
        Top = 8
        Width = 177
        Height = 25
        Caption = 'Criar e Enviar'
        TabOrder = 0
        OnClick = btnCriarEnviarClick
      end
      object btnGerarANe: TButton
        Left = 8
        Top = 8
        Width = 177
        Height = 25
        Caption = 'Gerar ANe'
        TabOrder = 1
        OnClick = btnGerarANeClick
      end
      object btnEnviarANeEmail: TButton
        Left = 376
        Top = 7
        Width = 177
        Height = 25
        Caption = 'Enviar ANe Email'
        TabOrder = 2
        OnClick = btnEnviarANeEmailClick
      end
    end
    object pcRespostas: TPageControl
      Left = 1
      Top = 41
      Width = 562
      Height = 591
      ActivePage = tsDados
      Align = alClient
      TabOrder = 1
      object tsRespostas: TTabSheet
        Caption = 'Respostas'
        object MemoResp: TMemo
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          TabOrder = 0
        end
      end
      object tsXMLResposta: TTabSheet
        Caption = 'XML Resposta'
        ImageIndex = 1
        object WBResposta: TWebBrowser
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          TabOrder = 0
          ControlData = {
            4C00000042390000303A00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
      object tsLog: TTabSheet
        Caption = 'Log'
        ImageIndex = 2
        object memoLog: TMemo
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object tsANe: TTabSheet
        Caption = 'ANe'
        ImageIndex = 3
        object trvwANe: TTreeView
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          Indent = 19
          TabOrder = 0
        end
      end
      object tsRetorno: TTabSheet
        Caption = 'Retorno Completo WS'
        ImageIndex = 4
        object memoRespWS: TMemo
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          TabOrder = 0
        end
      end
      object tsDados: TTabSheet
        Caption = 'Dados'
        ImageIndex = 5
        object MemoDados: TMemo
          Left = 0
          Top = 0
          Width = 554
          Height = 563
          Align = alClient
          TabOrder = 0
        end
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*-ane.XML'
    Filter = 
      'Arquivos ANe (*-ane.XML)|*-ane.XML|Arquivos XML (*.XML)|*.XML|To' +
      'dos os Arquivos (*.*)|*.*'
    Title = 'Selecione a ANe'
    Left = 384
    Top = 296
  end
  object ACBrANe1: TACBrANe
    MAIL = ACBrMail1
    OnStatusChange = ACBrANe1StatusChange
    Configuracoes.Geral.SSLLib = libCapicom
    Configuracoes.Geral.SSLCryptLib = cryCapicom
    Configuracoes.Geral.SSLHttpLib = httpWinINet
    Configuracoes.Geral.SSLXmlSignLib = xsMsXmlCapicom
    Configuracoes.Geral.FormatoAlerta = 'TAG:%TAGNIVEL% ID:%ID%/%TAG%(%DESCRICAO%) - %MSG%.'
    Configuracoes.Geral.RetirarAcentos = False
    Configuracoes.Geral.TipoDoc = tdCTe
    Configuracoes.Arquivos.OrdenacaoPath = <>
    Configuracoes.WebServices.UF = 'SP'
    Configuracoes.WebServices.AguardarConsultaRet = 0
    Configuracoes.WebServices.QuebradeLinha = '|'
    Left = 424
    Top = 296
  end
  object ACBrMail1: TACBrMail
    Host = '127.0.0.1'
    Port = '25'
    SetSSL = False
    SetTLS = False
    Attempts = 3
    DefaultCharset = UTF_8
    IDECharset = CP1252
    Left = 464
    Top = 296
  end
end
