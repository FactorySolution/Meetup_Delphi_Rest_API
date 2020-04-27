unit br.com.factorysolution.abstract;

interface

uses
  System.Generics.Collections,
  REST.Types,
  REST.Client,
  REST.Authenticator.Basic,
  br.com.factorysolution.interfaces;

type
  TTypeAuthentication = (taBasic, taOauth);
  TTypeMethod = (tmPost, tmUpdate);

  TAbstractAPi<T: class, constructor> = class abstract (TInterfacedObject)
  private
    FParams: IParams;
    FToken: string;
    FTypeAuthentication: TTypeAuthentication;
    FRESTClient: TRESTClient;
    FRESTRequest: TRESTRequest;
    FRESTResponse: TRESTResponse;
    FHTTPBasicAuthenticator: THTTPBasicAuthenticator;
    procedure SetAuthorization;
    procedure SetContentType;
  public
    procedure Configure(const AParams: IParams;
      ATypeAuthentication: TTypeAuthentication = taBasic; AToken: string = '');


    function Execute(const AUrl: string): T;  overload;
    function Execute(const AUrl: string; const AObject:  T;
      const AMethod: TTypeMethod): T; overload;
    procedure ExecuteDelete(const AUrl: string);

    function GenerateToken: string;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, REST.Json;

{ TAbstractAPi }

procedure TAbstractAPi<T>.Configure(const AParams: IParams;
  ATypeAuthentication: TTypeAuthentication; AToken: string);
begin
  FParams := AParams;
  FToken  := AToken;
  FTypeAuthentication := ATypeAuthentication;
  FRESTClient    := TRESTClient.Create(nil);
  FRESTRequest   := TRESTRequest.Create(nil);
  FRESTResponse  := TRESTResponse.Create(nil);

  FRESTRequest.Client   := FRESTClient;
  FRESTRequest.Response := FRESTResponse;

  if ATypeAuthentication = taBasic then
  begin
    FHTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);
    FRESTClient.Authenticator := FHTTPBasicAuthenticator;
    FHTTPBasicAuthenticator.Username := AParams.GetLogin;
    FHTTPBasicAuthenticator.Password := AParams.GetPassword;
  end;
end;

destructor TAbstractAPi<T>.Destroy;
begin
  FRESTClient.Free;
  FRESTRequest.Free;
  FRESTResponse.Free;
  FHTTPBasicAuthenticator.Free;
  inherited;
end;

function TAbstractAPi<T>.Execute(const AUrl: string): T;
begin
  SetAuthorization;
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);
  FRESTRequest.Method := rmGET;
  FRESTRequest.Execute;
  Result := TJson.JsonToObject<T>(FRESTRequest.Response.JSONText);
end;

function TAbstractAPi<T>.Execute(const AUrl: string; const AObject:  T;
  const AMethod: TTypeMethod): T;
begin
  SetAuthorization;
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);
  FRESTClient.ContentType := 'application/json';

  if AMethod = tmPost then
    FRESTRequest.Method := rmPOST
  else
    FRESTRequest.Method := rmPUT;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkREQUESTBODY;
    Name  := 'body';
    Value := TJson.ObjectToJsonString(AObject).Trim;
  end;

  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;

  FRESTRequest.Execute;
  Result := TJson.JsonToObject<T>(FRESTRequest.Response.JSONText);
end;

procedure TAbstractAPi<T>.ExecuteDelete(const AUrl: string);
begin
  SetAuthorization;
  FRESTClient.BaseURL := Format(FParams.GetUrl, [AUrl]);;
  FRESTClient.ContentType := 'application/json';
  FRESTRequest.Method := rmDELETE;
  FRESTRequest.Execute;
end;

function TAbstractAPi<T>.GenerateToken: string;
begin
  if FTypeAuthentication = taBasic then
    raise Exception.Create('Método disponível somente para OAuth');

  FRESTClient.BaseURL := Format(FParams.GetUrl, ['oauth/token']);
  FRESTClient.ContentType := 'application/x-www-form-urlencoded';

  FRESTRequest.Method := rmPOST;

  FHTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);
  FRESTClient.Authenticator := FHTTPBasicAuthenticator;

  FRESTClient.Authenticator := FHTTPBasicAuthenticator;
  FHTTPBasicAuthenticator.Username := IParamsOAuth(FParams).GetClientID;
  FHTTPBasicAuthenticator.Password := IParamsOAuth(FParams).GetClientSecret;

  with FRESTRequest.Params.AddItem do
  begin
    Kind  := pkGETorPOST;
    Name  := 'username';
    Value := FParams.GetLogin;
    Options := [poDoNotEncode];
  end;

  with FRESTRequest.Params.AddItem do
  begin
    Kind  := pkGETorPOST;
    Name  := 'password';
    Value := FParams.GetPassword;
    Options := [poDoNotEncode];
  end;

  with FRESTRequest.Params.AddItem do
  begin
    Kind  := pkGETorPOST;
    Name  := 'grant_type';
    Value := 'password';
    Options := [poDoNotEncode];
  end;
  FRESTRequest.Execute;
  Result := FRESTRequest.Response.JSONValue.GetValue<string>('access_token');

end;

procedure TAbstractAPi<T>.SetAuthorization;
begin
  if FTypeAuthentication = taBasic then Exit;
  
  if FToken.Trim.IsEmpty then
    raise Exception.Create('Token não informado');


  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'Authorization';
    Value := 'Bearer ' + FToken;
  end;

  SetContentType;
end;

procedure TAbstractAPi<T>.SetContentType;
begin
  with FRESTRequest.Params.AddItem do
  begin
    Options := [poDoNotEncode];
    Kind  := pkHTTPHEADER;
    Name  := 'Content-Type';
    Value := 'application/json;charset=UTF-8';
  end;
end;

end.
