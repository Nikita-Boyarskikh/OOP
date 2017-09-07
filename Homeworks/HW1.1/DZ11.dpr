program DZ11;



uses
  Forms,
  Main in 'Main.pas',
  ExtendedVector in 'Graphics\ExtendedVector.pas',
  BaseFigure in 'Graphics\BaseFigure.pas',
  ExtendedFigure in 'Graphics\ExtendedFigure.pas',
  ExtendedLine in 'Graphics\ExtendedLine.pas',
  ExtendedTriangle in 'Graphics\ExtendedTriangle.pas',
  ExtendedPiramid in 'Graphics\ExtendedPiramid.pas',
  ExtendedPrism in 'Graphics\ExtendedPrism.pas';

//  ExtendedPiramide in 'Graphics\ExtendedPiramide.pas',
 // ExtendedPrism in 'Graphics\ExtendedPrism.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
