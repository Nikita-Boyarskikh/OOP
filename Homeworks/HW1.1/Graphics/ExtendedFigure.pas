UNIT ExtendedFigure;

INTERFACE

uses BaseFigure, ExtendedVector;

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

type TFigure = class (_TBaseFigure)
  public                
    procedure Rotate(center : TVector3; alpha, beta, gamma : T); virtual; abstract;
    procedure Move(dx, dy, dz : T); virtual; abstract;
    procedure Scale(center : TVector3; x, y, z : T); virtual; abstract;
end;

IMPLEMENTATION

END.
