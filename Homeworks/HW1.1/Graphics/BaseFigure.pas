UNIT BaseFigure;

INTERFACE

uses ExtCtrls, Graphics;

type _TBaseFigure = class
  protected
    image : TImage;
    _pen : TPen;
    procedure setPen(pen : TPen);
    function getPen : TPen;
  public
    constructor Create(img : TImage; pen_color : TColor = clBlack);
    destructor Destroy; reintroduce;
    property pen : TPen read getPen write setPen;
    procedure Clear;
    procedure Draw; virtual; abstract;
end;

IMPLEMENTATION

constructor _TBaseFigure.Create(img : TImage;
    pen_color : TColor = clBlack);
begin
  image := TImage.Create(img.GetParentComponent);
  image := img;
  _pen := TPen.Create;
  _pen.Color := pen_color;
end;

{$REGION ' Сеттеры и геттеры '}

procedure _TBaseFigure.setPen(pen : TPen);
begin
  _pen := pen;
end;

function _TBaseFigure.getPen : TPen;
begin
  Result := _pen;
end;
{$ENDREGION}

// Очистка фигуры цветом фона
procedure _TBaseFigure.Clear;
var
  temp_pen : TPen;
begin
  temp_pen := TPen.Create;
  temp_pen.Color := _pen.Color;
  _pen.Color := image.Canvas.Brush.Color;
  Draw;   {нарисовать фигуру цветом фона - стереть}
  _pen.Color := temp_pen.Color;
end;

destructor _TBaseFigure.Destroy;
begin
  Clear;
  inherited Destroy;
end;

END.
