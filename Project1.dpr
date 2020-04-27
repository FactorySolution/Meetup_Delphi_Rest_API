program Project1;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form1},
  Token in 'Token.pas',
  Pessoa in 'Pessoa.pas',
  br.com.factorysolution.interfaces in 'interfaces\br.com.factorysolution.interfaces.pas',
  br.com.factorysolution.basicparams in 'basic\br.com.factorysolution.basicparams.pas',
  br.com.factorysolution.basicrest in 'basic\br.com.factorysolution.basicrest.pas',
  br.com.factorysolution.abstract in 'abstract\br.com.factorysolution.abstract.pas',
  br.com.factorysolution.oauth in 'oauth\br.com.factorysolution.oauth.pas',
  br.com.factorysolution.oauthparams in 'oauth\br.com.factorysolution.oauthparams.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown := true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
