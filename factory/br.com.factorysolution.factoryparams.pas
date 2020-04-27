unit br.com.factorysolution.factoryparams;

interface

uses
  br.com.factorysolution.interfaces;

type
  TParams = class(TInterfacedObject, IFactoryParams)
  private
    FParams: IParams;
  public
    function Basic: IParamsBasic;
    function OAuth: IParamsOAuth;

    class function New(const AParams: IParams): IFactoryParams;
    constructor Create(const AParams: IParams);
    destructor Destroy; override;

  end;


implementation

{ TParams }

function TParams.Basic: IParamsBasic;
begin

end;

constructor TParams.Create(const AParams: IParams);
begin

end;

destructor TParams.Destroy;
begin

  inherited;
end;

class function TParams.New(const AParams: IParams): IFactoryParams;
begin

end;

function TParams.OAuth: IParamsOAuth;
begin

end;

end.
