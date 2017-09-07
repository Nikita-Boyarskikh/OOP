UNIT ExtendedPrism;

INTERFACE

uses SysUtils, ExtCtrls, Graphics,
ExtendedFigure, ExtendedVector, ExtendedLine, ExtendedTriangle;

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

type TPrism = class (TFigure)
  private
    _AB, _BC, _AC,
    _AA1, _BB1, _CC1,
    _A1B1, _B1C1, _A1C1 : TLine3;

    function getPerimetr() : T;
    function getSquare() : T;
    function getVolume() : T;
    function getA : TVector3;
    function getB : TVector3;
    function getC : TVector3;
    function getA1 : TVector3;
    function getB1 : TVector3;
    function getC1 : TVector3;
    function getABC : TTriangle;
    function getA1B1C1 : TTriangle;

  public
    property Volume : T read getVolume;
    property Square : T read getSquare;
    property Perimetr : T read getPerimetr;
    property A : TVector3 read getA;
    property B : TVector3 read getB;
    property C : TVector3 read getC;
    property A1 : TVector3 read getA1;
    property B1 : TVector3 read getB1;
    property C1 : TVector3 read getC1;
    property A_B : TLine3 read _AB;
    property B_C : TLine3 read _BC;
    property A_C : TLine3 read _AC;
    property A_A1 : TLine3 read _AA1;
    property B_B1 : TLine3 read _BB1;
    property C_C1 : TLine3 read _CC1; 
    property A1_B1 : TLine3 read _A1B1;
    property B1_C1 : TLine3 read _B1C1;
    property A1_C1 : TLine3 read _A1C1;
    property ABC : TTriangle read getABC;
    property A1B1C1 : TTriangle read getA1B1C1;
    { TODO: get side areas (AA1BB1)}

    constructor Create(ABC : TTriangle; A1 : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(ABC : TTriangle; height : T; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(A, B, C : TVector3; height : T; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(A, B, C, A1 : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(ABCA1B1C1 : TPrism); overload;

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

constructor TPrism.Create(ABC : TTriangle; A1 : TVector3; img : TImage;
  pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _AB := TLine3.Create(ABC.AB);
  _AC := TLine3.Create(ABC.AC);
  _BC := TLine3.Create(ABC.BC);
  _AA1 := TLine3.FromAtoB(ABC.A, A1, img, pen_color);
  _BB1 := TLine3.FromAtoB(ABC.B, TVector3.Create(ABC.B.x, A1.y, ABC.B.z),
    img, pen_color);
  _CC1 := TLine3.FromAtoB(ABC.C, TVector3.Create(ABC.C.x, A1.y, ABC.C.z),
    img, pen_color);
  _A1B1 := TLine3.FromAtoB(A1, TVector3.Create(ABC.B.x, A1.y, ABC.B.z), img, pen_color);
  _A1C1 := TLine3.FromAtoB(A1, TVector3.Create(ABC.C.x, A1.y, ABC.C.z), img, pen_color);
  _B1C1 := TLine3.FromAtoB(TVector3.Create(ABC.B.x, A1.y, ABC.B.z),
    TVector3.Create(ABC.C.x, A1.y, ABC.C.z), img, pen_color);
end;

constructor TPrism.Create(ABC : TTriangle; height : T; img : TImage;
  pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _AB := TLine3.Create(ABC.AB);
  _AC := TLine3.Create(ABC.AC);
  _BC := TLine3.Create(ABC.BC);
  _AA1 := TLine3.FromAtoB(ABC.A, TVector3.Create(ABC.A.x, ABC.A.y - height, ABC.A.z),
    img, pen_color);
  _BB1 := TLine3.FromAtoB(ABC.B, TVector3.Create(ABC.B.x, ABC.B.y - height, ABC.B.z),
    img, pen_color);
  _CC1 := TLine3.FromAtoB(ABC.C, TVector3.Create(ABC.C.x, ABC.C.y - height, ABC.C.z),
    img, pen_color);
  _A1B1 := TLine3.FromAtoB(TVector3.Create(ABC.A.x, ABC.A.y - height, ABC.A.z),
    TVector3.Create(ABC.B.x, ABC.B.y - height, ABC.B.z), img, pen_color);
  _A1C1 := TLine3.FromAtoB(TVector3.Create(ABC.A.x, ABC.A.y - height, ABC.A.z),
    TVector3.Create(ABC.C.x, ABC.C.y - height, ABC.C.z), img, pen_color);
  _B1C1 := TLine3.FromAtoB(TVector3.Create(ABC.B.x, ABC.B.y - height, ABC.B.z),
    TVector3.Create(ABC.C.x, ABC.C.y - height, ABC.C.z), img, pen_color);
end;

constructor TPrism.Create(A, B, C : TVector3; height : T; img : TImage;
  pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _AB := TLine3.FromAtoB(A, B, img, pen_color);
  _AC := TLine3.FromAtoB(A, C, img, pen_color);
  _BC := TLine3.FromAtoB(B, C, img, pen_color);
  _AA1 := TLine3.FromAtoB(A, TVector3.Create(A.x, A.y - height, A.z), img, pen_color);
  _BB1 := TLine3.FromAtoB(B, TVector3.Create(B.x, B.y - height, B.z), img, pen_color);
  _CC1 := TLine3.FromAtoB(C, TVector3.Create(C.x, C.y - height, C.z), img, pen_color);
  _A1B1 := TLine3.FromAtoB(TVector3.Create(A.x, A.y - height, A.z),
    TVector3.Create(B.x, B.y - height, B.z), img, pen_color);
  _A1C1 := TLine3.FromAtoB(TVector3.Create(A.x, A.y - height, A.z),
    TVector3.Create(C.x, C.y - height, C.z), img, pen_color);
  _B1C1 := TLine3.FromAtoB(TVector3.Create(B.x, B.y - height, B.z),
    TVector3.Create(C.x, C.y - height, C.z), img, pen_color);
end;

constructor TPrism.Create(A, B, C, A1 : TVector3; img : TImage;
  pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _AB := TLine3.FromAtoB(A, B, img, pen_color);
  _AC := TLine3.FromAtoB(A, C, img, pen_color);
  _BC := TLine3.FromAtoB(B, C, img, pen_color);
  _AA1 := TLine3.FromAtoB(A, A1, img, pen_color);
  _BB1 := TLine3.FromAtoB(B, TVector3.Create(B.x, A1.y, B.z), img, pen_color);
  _CC1 := TLine3.FromAtoB(C, TVector3.Create(C.x, A1.y, C.z), img, pen_color);
  _A1B1 := TLine3.FromAtoB(A1, TVector3.Create(B.x, A1.y, B.z), img, pen_color);
  _A1C1 := TLine3.FromAtoB(A, TVector3.Create(C.x, A1.y, C.z), img, pen_color);
  _B1C1 := TLine3.FromAtoB(TVector3.Create(B.x, A1.y, B.z),
    TVector3.Create(C.x, A1.y, C.z), img, pen_color);
end;

constructor TPrism.Create(ABCA1B1C1 : TPrism);
begin
  inherited Create(image, _pen.Color);
  _AB := TLine3.Create(ABCA1B1C1.A_B);
  _BC := TLine3.Create(ABCA1B1C1.B_C);
  _AC := TLine3.Create(ABCA1B1C1.A_C);
  _AA1 := TLine3.Create(ABCA1B1C1.A_A1);
  _BB1 := TLine3.Create(ABCA1B1C1.B_B1);
  _CC1 := TLine3.Create(ABCA1B1C1.C_C1);
  _A1B1 := TLine3.Create(ABCA1B1C1.A1_B1);
  _B1C1 := TLine3.Create(ABCA1B1C1.B1_C1);
  _A1C1 := TLine3.Create(ABCA1B1C1.A1_C1);
end;

{$ENDREGION}

{$REGION ' Функции доступа к свойствам '}

function TPrism.getPerimetr() : T;
begin
  Result := _AB.length + _BC.length + _AC.length +
    _A1B1.length + _B1C1.length + _A1C1.length +
    _AA1.length + _BB1.length + _CC1.length;
end;

function TPrism.getSquare() : T;
var ABC, A1B1C1 : TTriangle;
begin          
  ABC := TTriangle.Create(_AB.getA, _AB.getB, _BC.getB, image, _pen.Color);
  A1B1C1 := TTriangle.Create(_A1B1.getA, _A1B1.getB, _B1C1.getB, image, _pen.Color);
  Result := ABC.Square + A1B1C1.Square + _AA1.length * ABC.Perimetr;
end;

function TPrism.getVolume() : T;
var ABC : TTriangle;
begin
  { TODO: Only for ortogonal prism }
  ABC := TTriangle.Create(_AB.getA, _AB.getB, _AC.getB, image, _pen.Color);
  Result := ABC.Square * _AA1.length;
end;

function TPrism.getA : TVector3;
begin
  Result := _AB.getA;
end;

function TPrism.getB : TVector3;
begin
  Result := _AB.getB;
end;

function TPrism.getC : TVector3;
begin
  Result := _AC.getB;
end;

function TPrism.getA1 : TVector3;
begin 
  Result := _A1C1.getA;
end;

function TPrism.getB1 : TVector3;
begin
  Result := _A1B1.getB;
end;

function TPrism.getC1 : TVector3;
begin
  Result := _A1C1.getB;
end;

function TPrism.getABC : TTriangle;
begin
  Result := TTriangle.Create(_AB.getA, _AB.getB, _BC.getB, image, _pen.Color);
end;

function TPrism.getA1B1C1 : TTriangle;
begin
  Result := TTriangle.Create(_A1B1.getA, _A1B1.getB, _B1C1.getB, image, _pen.Color);
end;

{$ENDREGION}

{$REGION ' Функции преобразования '}

procedure TPrism.Rotate(center : TVector3; alpha : T = 0;
    beta : T = 0; gamma : T = 0);
begin
  _AB.Rotate(center, alpha, beta, gamma);
  _AC.Rotate(center, alpha, beta, gamma);
  _BC.Rotate(center, alpha, beta, gamma);
  _AA1.Rotate(center, alpha, beta, gamma);
  _BB1.Rotate(center, alpha, beta, gamma);
  _CC1.Rotate(center, alpha, beta, gamma);
  _A1B1.Rotate(center, alpha, beta, gamma);
  _A1C1.Rotate(center, alpha, beta, gamma);
  _B1C1.Rotate(center, alpha, beta, gamma);
end;

procedure TPrism.Rotate(alpha : T = 0; beta : T = 0; gamma : T = 0);
begin
  _AB.Rotate(alpha, beta, gamma);
  _AC.Rotate(alpha, beta, gamma);
  _BC.Rotate(alpha, beta, gamma);
  _AA1.Rotate(alpha, beta, gamma);
  _BB1.Rotate(alpha, beta, gamma);
  _CC1.Rotate(alpha, beta, gamma);
  _A1B1.Rotate(alpha, beta, gamma);
  _A1C1.Rotate(alpha, beta, gamma);
  _B1C1.Rotate(alpha, beta, gamma);
end;

procedure TPrism.Move(dx : T = 0; dy : T = 0; dz : T = 0);
begin
  _AB.Move(dx, dy, dz);
  _AC.Move(dx, dy, dz);
  _BC.Move(dx, dy, dz);
  _AA1.Move(dx, dy, dz);
  _BB1.Move(dx, dy, dz);
  _CC1.Move(dx, dy, dz);
  _A1B1.Move(dx, dy, dz);
  _A1C1.Move(dx, dy, dz);
  _B1C1.Move(dx, dy, dz);
end;

procedure TPrism.Move(delta : TVector3);
begin
  _AB.Move(delta);
  _AC.Move(delta);
  _BC.Move(delta);
  _AA1.Move(delta);
  _BB1.Move(delta);
  _CC1.Move(delta);
  _A1B1.Move(delta);
  _A1C1.Move(delta);
  _B1C1.Move(delta);
end;

procedure TPrism.Scale(center : TVector3; x : T = 1; y : T = 1; z : T = 1);
begin  
  _AB.Scale(center, x, y, z);
  _AC.Scale(center, x, y, z);
  _BC.Scale(center, x, y, z);
  _AA1.Scale(center, x, y, z);
  _BB1.Scale(center, x, y, z);
  _CC1.Scale(center, x, y, z);
  _A1B1.Scale(center, x, y, z);
  _A1C1.Scale(center, x, y, z);
  _B1C1.Scale(center, x, y, z);
end;

procedure TPrism.Scale(center : TVector3; scale : TVector3);
begin 
  _AB.Scale(center, scale);
  _AC.Scale(center, scale);
  _BC.Scale(center, scale);
  _AA1.Scale(center, scale);
  _BB1.Scale(center, scale);
  _CC1.Scale(center, scale);
  _A1B1.Scale(center, scale);
  _A1C1.Scale(center, scale);
  _B1C1.Scale(center, scale);
end;

procedure TPrism.Scale(x : T = 1; y : T = 1; z : T = 1);
begin
  _AB.Scale(x, y, z);
  _AC.Scale(x, y, z);
  _BC.Scale(x, y, z);
  _AA1.Scale(x, y, z);
  _BB1.Scale(x, y, z);
  _CC1.Scale(x, y, z);
  _A1B1.Scale(x, y, z);
  _A1C1.Scale(x, y, z);
  _B1C1.Scale(x, y, z);
end;

{$ENDREGION}

procedure TPrism.Draw;
var
  center : TVector3;
  temp_pen : TPen;
begin
  temp_pen := TPen.Create;
  temp_pen.Color := image.Canvas.Pen.Color;
  image.Canvas.Pen.Color := _pen.Color;
  _AB.pen.Color := _pen.Color;
  _AC.pen.Color := _pen.Color;
  _BC.pen.Color := _pen.Color;
  _AA1.pen.Color := _pen.Color;
  _BB1.pen.Color := _pen.Color;
  _CC1.pen.Color := _pen.Color;
  _A1B1.pen.Color := _pen.Color;
  _A1C1.pen.Color := _pen.Color;
  _B1C1.pen.Color := _pen.Color;
  _AB.Draw;
  _AC.Draw;
  _BC.Draw;
  _AA1.Draw;
  _BB1.Draw;
  _CC1.Draw;
  _A1B1.Draw;
  _A1C1.Draw;
  _B1C1.Draw;
  image.Canvas.Pen.Color := temp_pen.Color;
end;

END.
