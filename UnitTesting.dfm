object FrmTesting: TFrmTesting
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Testing'
  ClientHeight = 582
  ClientWidth = 543
  Color = clWhite
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnMouseMove = FormMouseMove
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object crvypnl1: TCurvyPanel
    Left = 8
    Top = 8
    Width = 257
    Height = 553
    BorderColor = cl3DLight
    Color = cl3DLight
    Rounding = 20
    TabOrder = 0
    object ImageAvatar: TImage
      Left = 24
      Top = 23
      Width = 200
      Height = 200
      Stretch = True
    end
    object BtnChangePic: TButton
      Left = 24
      Top = 247
      Width = 200
      Height = 25
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      TabOrder = 0
      OnClick = BtnChangePicClick
    end
  end
  object dlgOpen1: TOpenDialog
    Left = 312
    Top = 16
  end
end
