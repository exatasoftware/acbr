object frlDANFeRL: TfrlDANFeRL
  Left = 944
  Height = 634
  Top = 336
  Width = 810
  Caption = 'frlDANFeLR'
  ClientHeight = 634
  ClientWidth = 810
  Color = clBtnFace
  PixelsPerInch = 96
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  Position = poMainFormCenter
  Visible = False
  object RLNFe: TRLReport
    Left = 8
    Height = 1123
    Top = -2
    Width = 794
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Arial'
    PreviewOptions.ShowModal = True
    PreviewOptions.Caption = 'DANFe'
    RealBounds.Left = 0
    RealBounds.Top = 0
    RealBounds.Width = 0
    RealBounds.Height = 0
    ShowProgress = False
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Author = 'FortesReport 3.23 - Copyright � 1999-2009 Fortes Inform�tica'
    DocumentInfo.Creator = 'Projeto ACBr (Componente NF-e)'
    DisplayName = 'Documento PDF'
    left = 288
    top = 96
  end
end
