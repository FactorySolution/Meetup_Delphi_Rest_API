unit br.com.factorysolution.oauth;

interface

uses
  br.com.factorysolution.interfaces,
  System.Generics.Collections,
  REST.Types,
  REST.Client,
  br.com.factorysolution.abstract,
  Vcl.StdCtrls,
  JOSE.Core.JWT,
  JOSE.Core.JWS,
  JOSE.Core.JWK,
  JOSE.Core.JWA,
  JOSE.Types.JSON,
  JOSE.Core.Base,
  JOSE.Encoding.Base64, Token;

type
  TOAuthRest<T: class, constructor> = class(TAbstractAPi<T>, IRest<T>, IRestOAuth<T>)
  private
    FParams: IParams;
    FToken: string;
    FJWT: TJWT;
    FAlg: TJOSEAlgorithmId;
    function GenerateKeyPair: TKeyPair;
    function VerifyToken(AKey: TJWK; AToken: string; out Token: TToken): Boolean;
  public
    function Get(const AContext: string): T; overload;
    function Get(const AContext, AID: string): T; overload;

    function Post(const AContext: string; AObject: T): T;
    function Put(const AContext: string; AObject: T): T;
    procedure Delete(const AContext: string; AID: Integer);

    function GetToken: string;
    function ValidateToken(AToken: string): TToken;

    class function New(const Params: Iparams): IRestOAuth<T>; overload;
    class function New(const Params: Iparams; const AToken: string): IRestOAuth<T>; overload;
    constructor Create(const Params: Iparams); overload;
    constructor Create(const Params: Iparams; const AToken: string); overload;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, System.DateUtils;

{ TOAuthRest<T> }

constructor TOAuthRest<T>.Create(const Params: Iparams);
begin
  FParams := Params;
  FJWT := TJWT.Create(TJWTClaims);
  FAlg := TJOSEAlgorithmId.HS256;
  Configure(FParams, taOauth, FToken);
end;

constructor TOAuthRest<T>.Create(const Params: Iparams; const AToken: string);
begin
  FToken := AToken;
  Create(Params);
end;

procedure TOAuthRest<T>.Delete(const AContext: string; AID: Integer);
begin
  ExecuteDelete(AContext + '/' + AID.ToString);
end;

destructor TOAuthRest<T>.Destroy;
begin
  FJWT.Free;
  inherited;
end;

function TOAuthRest<T>.Get(const AContext, AID: string): T;
begin
  Result := Execute(AContext + '/' + AID);
end;

function TOAuthRest<T>.GetToken: string;
begin
  Result := GenerateToken;
end;

class function TOAuthRest<T>.New(const Params: Iparams;
  const AToken: string): IRestOAuth<T>;
begin
  Result := self.Create(Params, AToken);
end;

function TOAuthRest<T>.Post(const AContext: string; AObject: T): T;
begin
  Result := Execute(AContext, AObject, tmPost);
end;

function TOAuthRest<T>.Put(const AContext: string; AObject: T): T;
begin
  Result := Execute(AContext, AObject, tmUpdate);
end;

class function TOAuthRest<T>.New(const Params: Iparams): IRestOAuth<T>;
begin
  Result := Self.Create(Params);
end;

function TOAuthRest<T>.GenerateKeyPair: TKeyPair;
begin
  Result := TKeyPair.Create;
  Result.PrivateKey.Key := IParamsOAuth(FParams).GetSecretKey;
  Result.PublicKey.Key := Result.PrivateKey.Key;
end;

function TOAuthRest<T>.VerifyToken(AKey: TJWK; AToken: string; out Token: TToken): Boolean;
var
  LToken: TJWT;
  LSigner: TJWS;
begin
  Result := False;
  try
    LToken := TJWT.Create;
    try
      LSigner := TJWS.Create(LToken);
      LSigner.SkipKeyValidation := True;
      try
        LSigner.SetKey(AKey);
        LSigner.CompactToken := AToken;
        LSigner.VerifySignature;
      finally
        LSigner.Free;
      end;

      if LToken.Verified then
      begin
        Token := TToken.FromJsonString(LToken.Claims.JSON.ToJSON);
        Exit(True);
      end;
    finally
      LToken.Free;
    end;
  except
    on E: Exception do
    begin
      raise Exception.Create('Não foi possível validar o Token!');
    end;
  end;
end;

function TOAuthRest<T>.ValidateToken(AToken: string): TToken;
var
  LSigner: TJWS;
  LKeyPair: TKeyPair;
begin
  if AToken.Trim.IsEmpty then
    AToken := GetToken;
  try
    if Assigned(FJWT.Header.JSON) and Assigned(FJWT.Claims.JSON) then
    begin
      LSigner := TJWS.Create(FJWT);
      LKeyPair := GenerateKeyPair;
      try
        LSigner.SkipKeyValidation := True;
        LSigner.Sign(LKeyPair.PrivateKey, FAlg);
        if not VerifyToken(LKeyPair.PublicKey, AToken, Result) then
          raise Exception.Create('Token inválido');
      finally
        LKeyPair.Free;
        LSigner.Free;
      end;
    end
  except
    on E: Exception do
      raise;
  end;
end;

function TOAuthRest<T>.Get(const AContext: string): T;
begin
  Result := Execute(AContext);
end;

end.
