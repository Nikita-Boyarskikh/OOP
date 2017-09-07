program PR1;

uses
  Forms,
  Main in 'Main.pas' {frmMain},
  CSVParser in 'CSVParser.pas',
  Graphic in 'Graphic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Таблица Менделеева';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
