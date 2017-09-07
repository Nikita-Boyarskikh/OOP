object frmMain: TfrmMain
  Left = 300
  Top = 200
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AlphaBlendValue = 0
  BorderIcons = [biSystemMenu]
  Caption = #1042#1088#1072#1097#1072#1090#1077#1083#1100' '#1092#1080#1075#1091#1088
  ClientHeight = 500
  ClientWidth = 892
  Color = clWhite
  Constraints.MaxHeight = 534
  Constraints.MaxWidth = 900
  Constraints.MinHeight = 534
  Constraints.MinWidth = 900
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 0
    Top = 0
    Width = 890
    Height = 450
    Cursor = crCross
    OnMouseDown = ImageMouseDown
    OnMouseUp = ImageMouseUp
  end
  object lblSpeed: TLabel
    Left = 8
    Top = 467
    Width = 102
    Height = 13
    Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1074#1088#1072#1097#1077#1085#1080#1103
  end
  object lblColor: TLabel
    Left = 707
    Top = 467
    Width = 26
    Height = 13
    Caption = #1062#1074#1077#1090
  end
  object udSpeed: TUpDown
    Left = 243
    Top = 462
    Width = 17
    Height = 25
    Min = -10
    Max = 10
    TabOrder = 0
    TabStop = True
    Thousands = False
    OnClick = udSpeedClick
  end
  object edtSpeed: TEdit
    Left = 116
    Top = 464
    Width = 121
    Height = 21
    TabStop = False
    Enabled = False
    TabOrder = 1
    Text = '0'
  end
  object ColorBox: TColorBox
    Left = 739
    Top = 464
    Width = 145
    Height = 22
    ItemHeight = 16
    TabOrder = 2
    OnChange = ColorBoxChange
  end
end
