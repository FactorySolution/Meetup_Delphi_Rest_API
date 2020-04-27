unit Pessoa;

interface

uses
  Generics.Collections,
  Rest.Json;

type
  TContatosDTO = class
  private
    FCodigo: Integer;
    FEmail: string;
    FNome: string;
    FTelefone: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Email: string read FEmail write FEmail;
    property Nome: string read FNome write FNome;
    property Telefone: string read FTelefone write FTelefone;
  end;

  TEnderecoDTO = class
  private
    FBairro: string;
    FCep: string;
    FCidade: string;
    FEstado: string;
    FLogradouro: string;
    FNumero: string;
  public
    property Bairro: string read FBairro write FBairro;
    property Cep: string read FCep write FCep;
    property Cidade: string read FCidade write FCidade;
    property Estado: string read FEstado write FEstado;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Numero: string read FNumero write FNumero;
  end;

  TPessoaDTO = class
  private
    FAtivo: Boolean;
    FCodigo: Integer;
    FContatos: TArray<TContatosDTO>;
    FEndereco: TEnderecoDTO;
    FNome: string;
  public
    property Ativo: Boolean read FAtivo write FAtivo;
    property Codigo: Integer read FCodigo write FCodigo;
    property Contatos: TArray<TContatosDTO> read FContatos write FContatos;
    property Endereco: TEnderecoDTO read FEndereco write FEndereco;
    property Nome: string read FNome write FNome;
    constructor Create;
    destructor Destroy; override;
    class function FromJsonString(const AValue: string): TPessoaDTO; static;
    function ToJsonString: string;

  end;

  TContent = class
  private
    FContent: TArray<TPessoaDTO>;
  public
    class function FromJsonString(const AValue: string): TContent; static;

    function ToJsonString: string;

    class function ToJsonList(const AVAlue: string): TList<TPessoaDTO>;

    property Content: TArray<TPessoaDTO> read FContent write FContent;


    destructor Destroy; override;
  end;

implementation

uses
  System.JSON;

{ TPessoaDTO }

constructor TPessoaDTO.Create;
begin
  inherited;
  FEndereco := TEnderecoDTO.Create;
end;

destructor TPessoaDTO.Destroy;
var
  Element: TContatosDTO;
begin
  FEndereco.Free;
  for Element in FContatos do
    Element.Free;
  inherited;
end;

class function TPessoaDTO.FromJsonString(const AValue: string): TPessoaDTO;
begin
  Result := TJson.JsonToObject<TPessoaDTO>(AValue);
end;

function TPessoaDTO.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

{ TRootDTO }

destructor TContent.Destroy;
var
  Element: TObject;
begin
  for Element in FContent do
    Element.Free;
  inherited;
end;


class function TContent.ToJsonList(const AVAlue: string): TList<TPessoaDTO>;
var
  Return: TJSONArray;
begin
  Return := TJSONObject.ParseJSONValue(AVAlue) as TJSONArray;

end;


class function TContent.FromJsonString(const AValue: string): TContent;
begin
  Result := TJson.JsonToObject<TContent>(AValue);
end;

function TContent.ToJsonString: string;
begin
  Result := TJson.ObjectToJsonString(self);
end;

end.
