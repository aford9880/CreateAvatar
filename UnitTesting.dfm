object FrmTesting: TFrmTesting
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Testing'
  ClientHeight = 197
  ClientWidth = 186
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ImageAvatar: TImage
    Left = 16
    Top = 39
    Width = 145
    Height = 137
    Stretch = True
  end
  object BtnChangePic: TButton
    Left = 16
    Top = 8
    Width = 145
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 0
    OnClick = BtnChangePicClick
  end
  object dlgOpen1: TOpenDialog
    Left = 136
    Top = 152
  end
end
