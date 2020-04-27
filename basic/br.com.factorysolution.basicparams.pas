unit br.com.factorysolution.basicparams;

interface

uses
  br.com.factorysolution.interfaces;

type
  TBaseParams = class(TInterfacedObject, IParamsBasic, IParams)
  private
    FLogin: string;
    FPassword: string;
    FUrl: string;
  public
    function SetLogin(const AValue: string): IParams;
    function SetPassword(const AValue: string): IParams;
    function SetUrl(const AValue: string): IParams;
    function GetLogin: string;
    function GetPassword: string;
    function GetUrl: string;

    class function New: IParamsBasic;
    constructor Create;
    destructor Destroy; override;

  end;

implementation

{ TBaseParams }

constructor TBaseParams.Create;
begin

end;

destructor TBaseParams.Destroy;
begin

  inherited;
end;

function TBaseParams.GetLogin: string;
begin
  Result := FLogin;
end;

function TBaseParams.GetPassword: string;
begin
  Result := FPassword;
end;

function TBaseParams.GetUrl: string;
begin
  Result := FUrl;
end;

class function TBaseParams.New: IParamsBasic;
begin
  Result := Self.Create;
end;

function TBaseParams.SetLogin(const AValue: string): IParams;
begin
  Result := Self;
  FLogin := AValue;
end;

function TBaseParams.SetPassword(const AValue: string): IParams;
begin
  Result := Self;
  FPassword := AValue;
end;

function TBaseParams.SetUrl(const AValue: string): IParams;
begin
  Result := Self;
  FUrl := AValue;
end;

end.
