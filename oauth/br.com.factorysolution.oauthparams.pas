unit br.com.factorysolution.oauthparams;

interface

uses
  br.com.factorysolution.interfaces;

type
  TOAuthParams = class(TInterfacedObject, IParamsOAuth, IParams)
  private
    FLogin: string;
    FPassword: string;
    FUrl: string;
    FClientID: string;
    FClientSecret: string;
    FSecretKey: string;
  public
    function GetLogin: string;
    function GetPassword: string;
    function GetUrl: string;
    function GetClientID: string;
    function GetClientSecret: string;
    function GetSecretKey: string;
    function SetLogin(const AValue: string): IParams;
    function SetPassword(const AValue: string): IParams;
    function SetUrl(const AValue: string): IParams;
    function SetClientID(const AValue: string): IParamsOAuth;
    function SetClientSecret(const AValue: string): IParamsOAuth;
    function SetSecretKey(const AValue: string): IParamsOAuth;

    class function New: IParamsOAuth;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TOAuthParams }

constructor TOAuthParams.Create;
begin

end;

destructor TOAuthParams.Destroy;
begin

  inherited;
end;

function TOAuthParams.GetClientID: string;
begin
  Result := FClientID;
end;

function TOAuthParams.GetClientSecret: string;
begin
  Result := FClientSecret;
end;

function TOAuthParams.GetLogin: string;
begin
  Result := FLogin;
end;

function TOAuthParams.GetPassword: string;
begin
  Result := FPassword;
end;

function TOAuthParams.GetSecretKey: string;
begin
  Result := FSecretKey;
end;

function TOAuthParams.GetUrl: string;
begin
  Result := FUrl;
end;

class function TOAuthParams.New: IParamsOAuth;
begin
  Result := Self.Create;
end;

function TOAuthParams.SetClientID(const AValue: string): IParamsOAuth;
begin
  Result := Self;
  FClientID := AValue;
end;

function TOAuthParams.SetClientSecret(const AValue: string): IParamsOAuth;
begin
  Result := Self;
  FClientSecret := AValue;
end;

function TOAuthParams.SetLogin(const AValue: string): IParams;
begin
  Result := Self;
  FLogin := AValue;
end;

function TOAuthParams.SetPassword(const AValue: string): IParams;
begin
  Result := Self;
  FPassword := AValue;
end;

function TOAuthParams.SetSecretKey(const AValue: string): IParamsOAuth;
begin
  Result := Self;
  FSecretKey := AValue;
end;

function TOAuthParams.SetUrl(const AValue: string): IParams;
begin
  Result := Self;
  FUrl := AValue;
end;

end.
