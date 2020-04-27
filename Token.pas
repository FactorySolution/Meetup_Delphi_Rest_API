unit Token;

interface

uses Generics.Collections, Rest.Json;

type
  TToken = class
  private
    FAuthorities: TArray<string>;
    FClient_Id: string;
    FExp: Integer;
    FJti: string;
    FNome: string;
    FScope: TArray<string>;
    FUser_Name: string;
  public
    function ToJsonString: string;
    class function FromJsonString(const AValue: string): TToken;
  published
    property Authorities: TArray<string> read FAuthorities write FAuthorities;
    property Client_Id: string read FClient_Id write FClient_Id;
    property Exp: Integer read FExp write FExp;
    property Jti: string read FJti write FJti;
    property Nome: string read FNome write FNome;
    property Scope: TArray<string> read FScope write FScope;
    property User_Name: string read FUser_Name write FUser_Name;
  end;
  
implementation

{ TToken }

class function TToken.FromJsonString(const AValue: string): TToken;
begin
 result := TJson.JsonToObject<TToken>(AValue);
end;

function TToken.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

end.
