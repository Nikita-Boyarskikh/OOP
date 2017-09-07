UNIT ExtendedTriangle;

INTERFACE

uses SysUtils, ExtCtrls, Graphics, ExtendedFigure, ExtendedVector, ExtendedLine;

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

const EPS = 3.4e-4932;  // Допуск погрешности

type TTriangle = class (TFigure)
  private
    _a, _b, _c : TLine3;
    function getNormal : TVector3;
    function getPerimetr : T;
    function getSquare : T;
    function getA : TVector3;
    function getB : TVector3;
    function getC : TVector3;
  public
    property normal : TVector3 read getNormal;
    property Square : T read getSquare;
    property Perimetr : T read getPerimetr;
    property A : TVector3 read getA;
    property B : TVector3 read getB;
    property C : TVector3 read getC;
    property AB : TLine3 read _a;
    property BC : TLine3 read _b;
    property AC : TLine3 read _c;
    constructor Create(A, B, C : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(AB : TLine3; C : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(ABC : TTriangle); overload; 
    { TODO: Constructors for true and ortogonal triangle }
    procedure Draw; override;
    procedure Rotate(center : TVector3; alpha : T = 0;
        beta : T = 0; gamma : T = 0); reintroduce; overload;
    procedure Rotate(alpha : T = 0; beta : T = 0; gamma : T = 0); reintroduce; overload;
    procedure Move(dx : T = 0; dy : T = 0; dz : T = 0); reintroduce; overload;
    procedure Move(delta : TVector3); reintroduce; overload;
    procedure Scale(center : TVector3; x : T = 1; y : T = 1; z : T = 1); reintroduce; overload;
    procedure Scale(center : TVector3; scale : TVector3); reintroduce; overload;
    procedure Scale(x : T = 1; y : T = 1; z : T = 1); reintroduce; overload;
end;

IMPLEMENTATION

{$REGION ' Конструкторы '}
constructor TTriangle.Create(A, B, C : TVector3; img : TImage;
    pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _a := TLine3.FromAtoB(A, B, img, pen_color);
  _b := TLine3.FromAtoB(B, C, img, pen_color);
  _c := TLine3.FromAtoB(C, A, img, pen_color);
end;

constructor TTriangle.Create(AB : TLine3; C : TVector3; img : TImage;
    pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _a := AB;
  _b := TLine3.FromAtoB(AB.getB, C, img, pen_color);
  _c := TLine3.FromAtoB(C, AB.getA, img, pen_color);
end;

constructor TTriangle.Create(ABC : TTriangle);
begin
  inherited Create(ABC.image, ABC.getPen.Color);
  _a := ABC.AB;
  _b := ABC.BC;
  _c := ABC.AC;
end;
{$ENDREGION}

{$REGION ' Функции доступа к свойствам '}
function TTriangle.getA() : TVector3;
begin
  Result := _a.getA;
end;

function TTriangle.getB() : TVector3;
begin
  Result := _a.getB;
end;

function TTriangle.getC() : TVector3;
begin
  Result := _b.getB;
end;

function TTriangle.getNormal() : TVector3;
var ort : TVector3;
begin
  ort := (_a.vector and _b.vector);
  Result := +ort;
end;

function TTriangle.getPerimetr() : T;
begin
  Result := _a.length + _b.length + _c.length;
end;

function TTriangle.getSquare() : T;
var P : T;
begin
  p := getPerimetr/2;
  Result := sqrt((p - _a.length)*(p - _b.length)*(p - _c.length)*p);
end;
{$ENDREGION}
 
{$REGION ' Функции преобразования '}
procedure TTriangle.Move(dx : T = 0; dy : T = 0; dz : T = 0);
begin
  _a.Move(dx, dy, dz);
  _b.Move(dx, dy, dz);
  _c.Move(dx, dy, dz);
end;

procedure TTriangle.Move(delta : TVector3);
begin
  _c.Move(delta);
  _b.Move(delta);
  _c.Move(delta);
end;

procedure TTriangle.Rotate(center : TVector3; alpha : T = 0; beta : T = 0; gamma : T = 0);
begin
  _a.Rotate(center, alpha, beta, gamma);
  _b.Rotate(center, alpha, beta, gamma);
  _c.Rotate(center, alpha, beta, gamma);
end;

procedure TTriangle.Rotate(alpha : T = 0; beta : T = 0; gamma : T = 0);
begin
  _a.Rotate(alpha, beta, gamma);
  _b.Rotate(alpha, beta, gamma);
  _c.Rotate(alpha, beta, gamma);
end;

procedure TTriangle.Scale(center : TVector3; x : T = 1; y : T = 1; z : T = 1);
begin
  _a.Scale(center, x, y, z);
  _b.Scale(center, x, y, z);
  _c.Scale(center, x, y, z);
end;

procedure TTriangle.Scale(center : TVector3; scale : TVector3);
begin
  _a.Scale(center, scale);
  _b.Scale(center, scale);
  _c.Scale(center, scale);
end;

procedure TTriangle.Scale(x : T = 1; y : T = 1; z : T = 1);
begin
  _a.Scale(x, y, z);
  _b.Scale(x, y, z);
  _c.Scale(x, y, z);
end;
{$ENDREGION}

procedure TTriangle.Draw;
var
  center : TVector3;
  temp_pen : TPen;
begin
  temp_pen := TPen.Create;
  temp_pen.Color := image.Canvas.Pen.Color;
  _a.pen.Color := _pen.Color;
  _b.pen.Color := _pen.Color;
  _c.pen.Color := _pen.Color;
  _a.Draw;
  _b.Draw;
  _c.Draw;
  image.Canvas.Pen.Color := _pen.Color;
end;

END.
