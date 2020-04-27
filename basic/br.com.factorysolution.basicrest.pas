unit br.com.factorysolution.basicrest;

interface

uses
  br.com.factorysolution.interfaces,
  System.Generics.Collections,
  br.com.factorysolution.abstract;

type
  TBasicRest<T: class, constructor> = class(TAbstractAPi<T>, IRest<T>)
  private
    FParams: IParams;
  public
    function Get(const AContext: string): T; overload;
    function Get(const AContext, AID: string): T; overload;

    function Post(const AContext: string; AObject: T): T;
    function Put(const AContext: string; AObject: T): T;
    procedure Delete(const AContext: string; AID: Integer);

    class function New(const Params: Iparams): IRest<T>;
    constructor Create(const Params: Iparams);
    destructor Destroy; override;
  end;

implementation

uses
  Pessoa,
  REST.Json,
  System.SysUtils;

{ TBasicRest<T> }

constructor TBasicRest<T>.Create(const Params: Iparams);
begin
  Configure(Params, taBasic);
end;

procedure TBasicRest<T>.Delete(const AContext: string; AID: Integer);
begin
  ExecuteDelete(AContext + '/' + AID.ToString);
end;

destructor TBasicRest<T>.Destroy;
begin
  inherited;
end;

{$Region GET}
function TBasicRest<T>.Get(const AContext, AID: string): T;
begin
  Result := Execute(AContext + '/' + AID);
end;

function TBasicRest<T>.Get(const AContext: string): T;
begin
  Result := Execute(AContext);
end;
{$EndRegion}

class function TBasicRest<T>.New(const Params: Iparams): IRest<T>;
begin
  Result := Self.Create(Params);
end;

function TBasicRest<T>.Post(const AContext: string; AObject: T): T;
begin
  Result := Execute(AContext, AObject, tmPost);
end;

function TBasicRest<T>.Put(const AContext: string; AObject: T): T;
begin
  Result := Execute(AContext, AObject, tmUpdate);
end;

end.
