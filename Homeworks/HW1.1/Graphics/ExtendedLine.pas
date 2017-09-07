UNIT ExtendedLine;

INTERFACE

uses ExtCtrls, Graphics, ExtendedFigure, ExtendedVector;

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

const EPS = 3.4e-4932;  // ������ �����������

type TLine3 = class (TFigure)
  private
    A, B : TVector3;
    function _length : T;
    function getVector() : TVector3;
    procedure _scale(scale : TVector3);
    procedure _rotate(alpha, beta, gamma : Extended);
  public
    property length : T read _length;
    property getA : TVector3 read A;
    property getB : TVector3 read B;
    constructor FromAtoB(A, B : TVector3; image : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(dot, coords : TVector3; image : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(line : TLine3); overload;
    property vector : TVector3 read getVector;
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

uses Math;

{$REGION ' ������������ '}
constructor TLine3.FromAtoB(A, B : TVector3; image : TImage;
    pen_color : TColor = clBlack);
begin
  inherited Create(image, pen_color);
  self.A := A;
  self.B := B;
end;

constructor TLine3.Create(dot, coords : TVector3; image : TImage;
    pen_color : TColor = clBlack);
begin
  inherited Create(image, pen_color);
  A := dot;
  B := dot + coords;
end;

constructor TLine3.Create(line : TLine3);
begin
  inherited Create(line.image, line.pen.color);
  A := line.A;
  B := line.B;
end;
{$ENDREGION}

{$REGION ' ������� ������� � ��������� '}
function TLine3.getVector() : TVector3;
begin
  Result := B - A;
end;

function TLine3._length : T;
var vector : TVector3;
begin
  vector := self.getVector;
  Result := vector.length;
end;
{$ENDREGION}

{$REGION ' ������� �������������� '}
{ �������� ����� � ������������ ������������ center
  �� ����: ������ ��� x - alpha, ������ y - beta, ������ z - gamma }
procedure TLine3.Rotate(center : TVector3; alpha : T = 0; beta : T = 0; gamma : T = 0);
begin
  if (abs(alpha) >= EPS) or (abs(beta) >= EPS)
      or (abs(gamma) >= EPS) then
  begin
    // ������� ������ ��������� � ����� center
    A := A - center;
    B := B - center;
    while alpha >= 2*PI do
      alpha := alpha - 2*PI;
    while beta >= 2*PI do
      beta := beta - 2*PI;
    while gamma >= 2*PI do
      gamma := gamma - 2*PI;
    while alpha <= -2*PI do
      alpha := alpha + 2*PI;
    while beta <= -2*PI do
      beta := beta + 2*PI;
    while gamma <= -2*PI do
      gamma := gamma + 2*PI;
    _rotate(alpha, beta, gamma);
    // ������� � ������� ������ ���������
    A := A + center;
    B := B + center;
  end;
end;

{ �������� ����� � ������������ ������������ ������ ���������
  �� ����: ������ ��� x - alpha, ������ y - beta, ������ z - gamma }
procedure TLine3.Rotate(alpha : T = 0; beta : T = 0; gamma : T = 0);
begin
  if (abs(alpha) >= EPS) or (abs(beta) >= EPS)
      or (abs(gamma) >= EPS) then
  begin
    while alpha >= 2*PI do
      alpha := alpha - 2*PI;
    while beta >= 2*PI do
      beta := beta - 2*PI;
    while gamma >= 2*PI do
      gamma := gamma - 2*PI;
    while alpha <= -2*PI do
      alpha := alpha + 2*PI;
    while beta <= -2*PI do
      beta := beta + 2*PI;
    while gamma <= -2*PI do
      gamma := gamma + 2*PI;
    _rotate(alpha, beta, gamma);
  end;
end;

{ ����������� ����� � ������������ �� ����������:
  ����� ��� x - dx, ����� y - dy, ����� z - dz }
procedure TLine3.Move(dx : T = 0; dy : T = 0; dz : T = 0);
begin
  A := A + TVector3.Create(dx, dy, dz);
  B := B + TVector3.Create(dx, dy, dz);
end;

{ ����������� ����� � ������������ �� ����������:
  ����� ��� x - delta.x, ����� y - delta.y, ����� z - delta.z }
procedure TLine3.Move(delta : TVector3);
begin
  A := A + delta;
  B := B + delta;
end;

{ ��������������� ����� � ������������ ������������ center
  �� ������������: ������������ ��� x - x,
  ������������ y - y, ������������ z - z }
procedure TLine3.Scale(center : TVector3; x : T = 1; y : T = 1; z : T = 1);
begin
  if (x <> 0) or (y <> 0) or (z <> 0) then
  begin
    // ������� ������ ��������� � ����� center
    A := A - center;
    B := B - center;
    // ���������������
    _scale(TVector3.Create(x, y, z));
    // ������� � ������� ������ ���������
    A := A + center;
    B := B + center;
  end;
end;

{ ��������������� ����� � ������������ ������������ center
  �� ������������: ������������ ��� x - scale.x,
  ������������ y - scale.y, ������������ z - scale.z }
procedure TLine3.Scale(center : TVector3; scale : TVector3);
begin
  if (scale.x <> 0) or (scale.y <> 0) or (scale.z <> 0) then
  begin
    // ������� ������ ��������� � ����� center
    A := A - center;
    B := B - center;
    // ���������������
    _scale(TVector3.Create(scale));
    // ������� � ������� ������ ���������
    A := A + center;
    B := B + center;
  end;
end;

{ ��������������� ����� � ������������ ������������ ������ ���������
  �� ������������: ������������ ��� x - x,
  ������������ y - y, ������������ z - z }
procedure TLine3.Scale(x : T = 1; y : T = 1; z : T = 1);
begin
  if (x <> 0) or (y <> 0) or (z <> 0) then
    _scale(TVector3.Create(x, y, z));
end;
{$ENDREGION}

procedure TLine3.Draw;
var
  temp_pen : TPen;
begin
  temp_pen := image.Canvas.Pen;
  image.Canvas.Pen := _pen;
  image.Canvas.MoveTo(round(A.x), round(A.y));
  image.Canvas.LineTo(round(B.x), round(B.y));  
  image.Canvas.Pen := temp_pen;
end;

{$REGION ' ��������� ������� '}
// �������� ������������ ������ ���������
procedure TLine3._rotate(alpha, beta, gamma : Extended);
var sin_x, cos_x, sin_y, cos_y, sin_z, cos_z : T;
begin
  SinCos(alpha, sin_x, cos_x);
  SinCos(beta, sin_y, cos_y);
  SinCos(gamma, sin_z, cos_z);
  with A do
  begin
    // ������� ������ ��� X
    y := y*cos_x + z*sin_x;
    z := -y*sin_x + z*cos_x;
    // ������� ������ ��� Y
    x := x*cos_y + z*sin_y;
    z := -x*sin_y + z*cos_y;
    // ������� ������ ��� Z
    x := x*cos_z - y*sin_z;
    y := x*sin_z + y*cos_z;
  end;
  with B do
  begin
    // ������� ������ ��� X
    y := y*cos_x + z*sin_x;
    z := -y*sin_x + z*cos_x;
    // ������� ������ ��� Y
    x := x*cos_y + z*sin_y;
    z := -x*sin_y + z*cos_y;
    // ������� ������ ��� Z
    x := x*cos_z - y*sin_z;
    y := x*sin_z + y*cos_z;
  end;
end;

// ��������������� ������������ ������ ���������
procedure TLine3._scale(scale : TVector3);
begin
  // ������ �������� ��� ������������� ���������
  if scale.x < 0 then
    scale.x := -1/scale.x;
  if scale.y < 0 then
    scale.y := -1/scale.y;
  if scale.z < 0 then
    scale.z := -1/scale.z;

  // ��������������� ����� A0
  A.x := A.x * scale.x;
  A.y := A.y * scale.y;
  A.z := A.z * scale.z;

  // ��������������� ����� B0
  B.x := B.x * scale.x;
  B.y := B.y * scale.y;
  B.z := B.z * scale.z;
end;
{$ENDREGION}

END.
