object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 702
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmDados: TMemo
    Left = 351
    Top = 16
    Width = 493
    Height = 384
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object grbBasic: TGroupBox
    Left = 8
    Top = 49
    Width = 337
    Height = 161
    Caption = 'Basic Auth    '
    TabOrder = 1
    object edtLogin: TLabeledEdit
      Left = 16
      Top = 36
      Width = 233
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Login '
      TabOrder = 0
      Text = 'admin@factorymoney.com'
    end
    object edtSenha: TLabeledEdit
      Left = 16
      Top = 83
      Width = 233
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha'
      PasswordChar = '*'
      TabOrder = 1
      Text = 'admin'
    end
    object btnLogar: TButton
      Left = 16
      Top = 114
      Width = 75
      Height = 25
      Caption = 'Logar'
      TabOrder = 2
    end
  end
  object grbOauth: TGroupBox
    Left = 8
    Top = 216
    Width = 337
    Height = 457
    Caption = 'OAuth 2'
    Enabled = False
    TabOrder = 2
    object edtLoginOauth2: TLabeledEdit
      Left = 16
      Top = 36
      Width = 233
      Height = 21
      EditLabel.Width = 28
      EditLabel.Height = 13
      EditLabel.Caption = 'Login '
      TabOrder = 0
      Text = 'admin@factorymoney.com'
    end
    object edtSenhaOauth2: TLabeledEdit
      Left = 16
      Top = 81
      Width = 233
      Height = 21
      EditLabel.Width = 30
      EditLabel.Height = 13
      EditLabel.Caption = 'Senha'
      PasswordChar = '*'
      TabOrder = 1
      Text = 'admin'
    end
    object BtnToken: TButton
      Left = 16
      Top = 195
      Width = 75
      Height = 25
      Caption = 'Get Token'
      TabOrder = 2
      OnClick = BtnTokenClick
    end
    object edtClientId: TLabeledEdit
      Left = 16
      Top = 125
      Width = 121
      Height = 21
      EditLabel.Width = 40
      EditLabel.Height = 13
      EditLabel.Caption = 'Client Id'
      TabOrder = 3
      Text = 'angular'
    end
    object edtSecretID: TLabeledEdit
      Left = 16
      Top = 168
      Width = 121
      Height = 21
      EditLabel.Width = 44
      EditLabel.Height = 13
      EditLabel.Caption = 'Secret Id'
      PasswordChar = '*'
      TabOrder = 4
      Text = '@ngul@r0'
    end
    object mmToken: TMemo
      Left = 2
      Top = 238
      Width = 333
      Height = 217
      Align = alBottom
      ScrollBars = ssVertical
      TabOrder = 5
    end
  end
  object btnGetAll: TButton
    Left = 351
    Top = 452
    Width = 75
    Height = 25
    Caption = 'Get All'
    TabOrder = 3
    OnClick = btnGetAllClick
  end
  object chkAutorizacao: TCheckBox
    Left = 10
    Top = 18
    Width = 97
    Height = 17
    Caption = 'OAuth 2'
    TabOrder = 4
    OnClick = chkAutorizacaoClick
  end
  object edtAuthorization: TLabeledEdit
    Left = 351
    Top = 425
    Width = 493
    Height = 21
    EditLabel.Width = 64
    EditLabel.Height = 13
    EditLabel.Caption = 'Authorization'
    TabOrder = 5
  end
  object btnGet: TButton
    Left = 351
    Top = 483
    Width = 75
    Height = 25
    Caption = 'Get'
    TabOrder = 6
    OnClick = btnGetClick
  end
  object btnPost: TButton
    Left = 351
    Top = 514
    Width = 75
    Height = 25
    Caption = 'Post'
    TabOrder = 7
    OnClick = btnPostClick
  end
  object btnPut: TButton
    Left = 351
    Top = 545
    Width = 75
    Height = 25
    Caption = 'Put'
    TabOrder = 8
    OnClick = btnPutClick
  end
  object Button1: TButton
    Left = 351
    Top = 576
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 9
    OnClick = Button1Click
  end
end
