object Form1: TForm1
  Left = 203
  Top = 130
  Width = 862
  Height = 637
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TopPanel: TPanel
    Left = 0
    Top = 0
    Width = 854
    Height = 25
    Align = alTop
    TabOrder = 0
    object ToolBar1: TToolBar
      Left = 1
      Top = 1
      Width = 196
      Height = 23
      Align = alLeft
      AutoSize = True
      ButtonHeight = 21
      ButtonWidth = 56
      Caption = 'ToolBar1'
      Color = clMenu
      EdgeBorders = []
      EdgeInner = esNone
      EdgeOuter = esNone
      Flat = True
      Menu = MainMenu1
      ParentColor = False
      ShowCaptions = True
      TabOrder = 0
      Wrapable = False
    end
    object ChildControl: TPanel
      Left = 811
      Top = 1
      Width = 42
      Height = 23
      Align = alRight
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        42
        23)
      object BtnCloseChild: TBitBtn
        Left = 22
        Top = 2
        Width = 20
        Height = 20
        Anchors = [akTop, akRight]
        TabOrder = 0
        OnClick = CloseChildClick
      end
      object BtnRestoreChild: TBitBtn
        Left = 0
        Top = 2
        Width = 20
        Height = 20
        Anchors = [akTop, akRight]
        TabOrder = 1
        OnClick = RestoreChildClick
      end
    end
  end
  object MultiForm1: TMultiForm
    Left = 0
    Top = 25
    Width = 854
    Height = 574
    Align = alClient
    BorderWidth = 3
    Caption = 'MultiForm1'
    Color = clBlack
    TabOrder = 1
    Maximized = False
    TitleHeight = 12
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 56
    object File1: TMenuItem
      Caption = 'File'
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object NewChild1: TMenuItem
      Caption = 'New Child'
      OnClick = NewChild1Click
    end
    object SendText1: TMenuItem
      Caption = 'Send Text'
      OnClick = SendText1Click
    end
    object Window1: TMenuItem
      Caption = 'Window'
      object Cascade1: TMenuItem
        Caption = 'Cascade'
        OnClick = Cascade1Click
      end
      object Tile1: TMenuItem
        Caption = 'Tile vertically'
        OnClick = Tile1Click
      end
      object Tile2: TMenuItem
        Caption = 'Tile horizontally'
        OnClick = Tile2Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
    end
  end
end
