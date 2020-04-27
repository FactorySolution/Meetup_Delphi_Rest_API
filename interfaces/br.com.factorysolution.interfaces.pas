unit br.com.factorysolution.interfaces;

interface

uses
  System.Generics.Collections, Vcl.StdCtrls, Token;

type
  IParams = interface
    ['{4CA08E97-EB6A-4D5C-9651-4F212D65CB65}']
    function SetLogin(const AValue: string): IParams;
    function SetPassword(const AValue: string): IParams;
    function SetUrl(const AValue: string): IParams;
    function GetLogin: string;
    function GetPassword: string;
    function GetUrl: string;
  end;

  IParamsBasic = interface(IParams)
    ['{BF9D4B6B-8D3B-414C-8ED0-16727F4B0680}']
  end;

  IParamsOAuth = interface(IParams)
    ['{458D749A-EF0E-4FD7-BE4C-87939E7879DF}']
    function SetClientID(const AValue: string) : IParamsOAuth;
    function SetClientSecret(const AValue: string) : IParamsOAuth;
    function SetSecretKey(const AValue: string) : IParamsOAuth;
    function GetClientID : string;
    function GetClientSecret: string;
    function GetSecretKey: string;
  end;

  IRest<T> = interface
    ['{61105668-021C-4160-9E1A-C56B7132EC88}']
    function Get(const AContext: string): T; overload;
    function Get(const AContext, AID: string): T; overload;
    function Post(const AContext: string; AObject: T): T;
    function Put(const AContext: string; AObject: T): T;
    procedure Delete(const AContext: string; AID: Integer);
  end;

  IRestOAuth<T> = interface(IRest<T>)
    ['{9E754C3A-3813-4DD0-95EB-2077DB44DCFF}']
    function GetToken: string;
    function ValidateToken(AToken: string): TToken;
  end;


implementation

end.
