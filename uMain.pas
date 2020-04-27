unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  JOSE.Core.JWT,
  JOSE.Core.JWS,
  JOSE.Core.JWK,
  JOSE.Core.JWA,
  JOSE.Types.JSON,
  JOSE.Core.Base,
  JOSE.Encoding.Base64,
  Pessoa,
  br.com.factorysolution.interfaces;

type

  TForm1 = class(TForm)
    mmDados: TMemo;
    grbBasic: TGroupBox;
    edtLogin: TLabeledEdit;
    edtSenha: TLabeledEdit;
    btnLogar: TButton;
    grbOauth: TGroupBox;
    edtLoginOauth2: TLabeledEdit;
    edtSenhaOauth2: TLabeledEdit;
    BtnToken: TButton;
    edtClientId: TLabeledEdit;
    edtSecretID: TLabeledEdit;
    mmToken: TMemo;
    btnGetAll: TButton;
    chkAutorizacao: TCheckBox;
    edtAuthorization: TLabeledEdit;
    btnGet: TButton;
    btnPost: TButton;
    btnPut: TButton;
    Button1: TButton;
    procedure BtnTokenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetAllClick(Sender: TObject);
    procedure chkAutorizacaoClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure btnPostClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FToken: string;
    function GetUrl: string;
    procedure GetOne;
    procedure Post;
    procedure Put;
    procedure Delete;
    procedure GetAll;
    procedure printPerson(const APerson: TPessoaDTO);
    function GetParams: IParams;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation

uses
  System.DateUtils,
  Token,
  br.com.factorysolution.basicrest,
  br.com.factorysolution.basicparams,
  br.com.factorysolution.oauthparams,
  System.StrUtils,
  br.com.factorysolution.oauth;


const
  cUrlBasic = 'http://localhost:8090/%s';
  cUrlOAuth = 'http://localhost:8091/%s';
  cSecretKey = 'factory';

{$R *.dfm}

function TForm1.GetParams: IParams;
begin
  if chkAutorizacao.Checked then  
    Result := TOAuthParams
                  .New
                  .SetClientID(edtClientId.Text)
                  .SetClientSecret(edtSecretID.Text)
                  .SetSecretKey(cSecretKey)
                  .SetLogin(edtLoginOauth2.Text)
                  .SetPassword(edtSenhaOauth2.Text)
                  .SetUrl(GetUrl)
                  
  else
    Result := TBaseParams
                  .New
                  .SetLogin(edtLogin.Text)
                  .SetPassword(edtSenha.Text)
                  .SetUrl(GetUrl);
end;

procedure TForm1.btnGetAllClick(Sender: TObject);
begin
  GetAll;
end;

procedure TForm1.GetAll;
var
  Params: IParams;
  Content: TContent;
begin
  Params := GetParams;
  if chkAutorizacao.Checked then
     Content := TOAuthRest<TContent>.New(Params, FToken).Get('pessoas')
  else
     Content := TBasicRest<TContent>.New(params).Get('pessoas');

  mmDados.Lines.Clear;

  mmDados.Lines.Add(Content.ToJsonString);

  if Assigned(Content) then Content.Free;
end;

function TForm1.GetUrl: string;
begin
  Result := ifthen(chkAutorizacao.Checked, cUrlOAuth, cUrlBasic);
end;

procedure TForm1.GetOne;
var
  Params: IParams;
  Person: TPessoaDTO;
  ID: string;
begin
  ID := InputBox('Informe o id da pessoa', '', '');
  Person := nil;
  if not Id.Trim.IsEmpty then
  begin
    Params := GetParams;
    if chkAutorizacao.Checked then
      Person := TOAuthRest<TPessoaDTO>.New(Params, FToken).Get('pessoas',ID)
    else
      Person := TBasicRest<TPessoaDTO>.New(params).Get('pessoas',ID);
    printPerson(Person);
  end;
  if Assigned(Person) then Person.Free;
end;

procedure TForm1.printPerson(const APerson: TPessoaDTO);
var
  Contato: TContatosDTO;
begin
  mmDados.Lines.Clear;

  with APerson, mmDados.Lines do
  begin
    Add('ID: ' + Codigo.ToString);
    Add('Name: ' + Nome);
    Add('Endereco  ');
    Add('   Cidade: '  + Endereco.Cidade);
    Add('   Estado: '  + Endereco.Estado);
    Add('   Logr.: '  + Endereco.Logradouro);
    Add('          ');
    Add('Contatos  [ ');
    for Contato in Contatos do
    begin
      Add('   Nome: ' + Contato.Nome);
      Add('   Telefone: ' + Contato.Telefone);
    end;
    Add('             ] ');

  end;
end;

procedure TForm1.btnGetClick(Sender: TObject);
begin
  GetOne;
end;

procedure TForm1.Post;
var
  Person: TPessoaDTO;

  function CreatePerson: TPessoaDTO;
  var
    LContato: TContatosDTO;
    LContatos: TArray<TContatosDTO>;
  begin
    Result := TPessoaDTO.Create;
    LContato := TContatosDTO.Create;
    with Result do
    begin
      Nome  := 'Andre Oliveira _';
      Ativo := True;
      with Endereco do
      begin
        Bairro := 'Centro';
        Cep := '87070-000';
        Cidade := 'Maringa';
        Estado := 'PR';
        Logradouro := 'Rua XPTO';
        Numero := '123';
      end;

      with LContato do
      begin
        Email := 'andre.oliveiras@tecnospeed.com.br';
        Telefone := '123456789';
        Nome := 'Patroa';
      end;
      LContatos := TArray<TContatosDTO>.Create(LContato);
      Contatos := LContatos;
    end;
  end;
begin
  Person := CreatePerson;
  if chkAutorizacao.Checked then
    Person := TOAuthRest<TPessoaDTO>.New(GetParams, FToken).Post('pessoas',Person)
  else
    Person := TBasicRest<TPessoaDTO>.New(GetParams).Post('pessoas',Person);

  printPerson(Person);

  if Assigned(Person) then Person.Free;

end;

procedure TForm1.Put;
var
  ID: string;
  Person, Temp :  TPessoaDTO;

  function GetPerson: TPessoaDTO;
  begin
    ID := InputBox('Informe o id da pessoa', '', '');
    if not Id.Trim.IsEmpty then
    begin
      if chkAutorizacao.Checked then
        Result := TOAuthRest<TPessoaDTO>.New(GetParams, FToken).Get('pessoas',ID)
      else
        Result := TBasicRest<TPessoaDTO>.New(GetParams).Get('pessoas',ID);
    end;
  end;

begin
  Temp := GetPerson;
  Temp.Nome := Temp.Nome + '_update';
  if chkAutorizacao.Checked then
     Person := TOAuthRest<TPessoaDTO>.New(GetParams, FToken).Put(Format('pessoas/%s', [ID]), Temp)
  else
     Person := TBasicRest<TPessoaDTO>.New(GetParams).Put(Format('pessoas/%s', [ID]),Temp);
  printPerson(Person);

  if Assigned(Person) then Person.Free;
  if Assigned(Temp) then Temp.Free;

end;

procedure TForm1.btnPostClick(Sender: TObject);
begin
  Post;
end;

procedure TForm1.btnPutClick(Sender: TObject);
begin
  Put;
end;

procedure TForm1.BtnTokenClick(Sender: TObject);
var
  LRestOAuth : IRestOAuth<TPessoaDTO>;

  procedure LoadJWT(const AToken: TToken);
  var
    _date: TDateTime;
    Authoritie, _Scope: string;
  begin
    with AToken do
    begin
      with mmDados.Lines do
      begin
        Add('User Name: ' + User_Name);
        Add('Name: ' + Nome);
        Add('Client Id: ' + Client_Id);
        _date := IncHour(UnixToDateTime(Exp), -3);
        Add('Expiration: ' + MinutesBetween(_date, Now).ToString + ' minutes');
        Add('Authorities : [ ');
        for Authoritie in authorities do
        begin
          Add('      ' + Authoritie);
        end;
        Add(']');
        Add('Scope: [ ') ;
        for _Scope in Scope do
        begin
         Add('  ' + _Scope);
        end;
        Add(']');
      end;
      Free;
    end;
  end;
begin
  LRestOAuth :=  TOAuthRest<TPessoaDTO>.New(GetParams);
  FToken := LRestOAuth.GetToken;
  edtAuthorization.Text := 'Bearer ' + FToken;
  LoadJWT(LRestOAuth.ValidateToken(FToken));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Delete;
end;

procedure TForm1.Delete;
var
  ID: string;
begin
  ID := InputBox('Informe o id da pessoa', '', '');
  if not ID.Trim.IsEmpty then
  begin
    if chkAutorizacao.Checked then
       TOAuthRest<TPessoaDTO>.New(GetParams, FToken).Delete('pessoas', ID.ToInteger) //TBasicRest<TPessoaDTO>.New(params).Get('pessoas',ID);
    else
     TBasicRest<TPessoaDTO>.New(GetParams).Delete('pessoas', ID.ToInteger);
  end;
end;

procedure TForm1.chkAutorizacaoClick(Sender: TObject);
begin
  grbOauth.Enabled := chkAutorizacao.Checked;
  grbBasic.Enabled := not grbOauth.Enabled;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  chkAutorizacaoClick(sender);
end;

end.
