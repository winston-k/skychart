object Form1: TForm1
  Left = 258
  Top = 18
  Caption = 'Form1'
  ClientHeight = 159
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 160
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 16
    Top = 88
    Width = 225
    Height = 21
    ReadOnly = True
    TabOrder = 2
  end
  object Ttyc: TTable
    DatabaseName = 'astroTYC'
    TableName = 'TYCHO'
    Left = 304
    Top = 80
  end
  object astrotyc: TDatabase
    AliasName = 'astroTYC'
    DatabaseName = 'astrotyc'
    Params.Strings = (
      'USER NAME=STARS')
    SessionName = 'Default'
    TransIsolation = tiDirtyRead
    OnLogin = astrotycLogin
    Left = 304
    Top = 32
  end
end
