UNIT ExtendedPiramid;

INTERFACE

uses SysUtils, ExtCtrls, Graphics,
ExtendedFigure, ExtendedVector, ExtendedLine, ExtendedTriangle;

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

type TPiramid = class (TFigure)
  private
    _AB, _BC, _AC, _AS, _BS, _CS : TLine3;

    function getPerimetr() : T;
    function getSquare() : T;
    function getVolume() : T;
    function getA : TVector3;
    function getB : TVector3;
    function getC : TVector3;
    function getS : TVector3;
    function getABC : TTriangle;
    function getBCS : TTriangle;
    function getACS : TTriangle;
    function getABS : TTriangle;

  public
    property Volume : T read getVolume;
    property Square : T read getSquare;
    property Perimetr : T read getPerimetr;
    property A : TVector3 read getA;
    property B : TVector3 read getB;
    property C : TVector3 read getC;
    property S : TVector3 read getS;
    property A_B : TLine3 read _AB;
    property B_C : TLine3 read _BC;
    property A_C : TLine3 read _AC;
    property A_S : TLine3 read _AS;
    property B_S : TLine3 read _BC;
    property C_S : TLine3 read _CS;
    property ABC : TTriangle read getABC;
    property ABS : TTriangle read getABS;
    property BCS : TTriangle read getBCS;
    property ACS : TTriangle read getACS;

    constructor Create(ABC : TTriangle; S : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(A, B, C, S : TVector3; img : TImage;
        pen_color : TColor = clBlack); overload;
    constructor Create(ABCS : TPiramid); overload;
    { TODO: Constructors for true and simmetrical piramid }

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

constructor TPiramid.Create(ABC : TTriangle; S : TVector3; img : TImage;
  pen_color : TColor = clBlack);
begin  
  inherited Create(img, pen_color);
  _AB := TLine3.Create(ABC.AB);
  _BC := TLine3.Create(ABC.BC);
  _AC := TLine3.Create(ABC.AC);
  _AS := TLine3.FromAtoB(ABC.A, S, image, pen_color);
  _BS := TLine3.FromAtoB(ABC.B, S, image, pen_color);
  _CS := TLine3.FromAtoB(ABC.C, S, image, pen_color);
end;

constructor TPiramid.Create(A, B, C, S : TVector3; img : TImage;
  pen_color : TColor = clBlack);
begin
  inherited Create(img, pen_color);
  _AB := TLine3.FromAtoB(A, B, image, pen_color);
  _BC := TLine3.FromAtoB(B, C, image, pen_color);
  _AC := TLine3.FromAtoB(A, C, image, pen_color);
  _AS := TLine3.FromAtoB(A, S, image, pen_color);
  _BS := TLine3.FromAtoB(B, S, image, pen_color);
  _CS := TLine3.FromAtoB(C, S, image, pen_color);
end;

constructor TPiramid.Create(ABCS : TPiramid);
begin
  inherited Create(ABCS.image, ABCS.getPen.Color);
  _AB := TLine3.Create(ABCS.A_B);
  _BC := TLine3.Create(ABCS.B_C);
  _AC := TLine3.Create(ABCS.A_C);
  _AS := TLine3.Create(ABCS.A_S);
  _BS := TLine3.Create(ABCS.B_S);
  _CS := TLine3.Create(ABCS.C_S);
end;

{$ENDREGION}

{$REGION ' Функции доступа к свойствам '}

function TPiramid.getPerimetr() : T;
begin
  Result := _AB.length + _BC.length + _AC.length +
    _AS.length + _BS.length + _CS.length;
end;

function TPiramid.getSquare() : T;
var ABC, ABS, BCS, ACS : TTriangle;
begin          
  ABC := TTriangle.Create(_AB.getA, _AB.getB, _BC.getB, image, _pen.Color);
  ABS := TTriangle.Create(_AB.getA, _AB.getB, _BS.getB, image, _pen.Color);
  BCS := TTriangle.Create(_BC.getA, _BC.getB, _CS.getB, image, _pen.Color);
  ACS := TTriangle.Create(_AC.getA, _AC.getB, _CS.getB, image, _pen.Color);
  Result := ABC.Square + ABS.Square + ACS.Square + BCS.Square;
end;

function TPiramid.getVolume() : T;
begin
  { TODO: Not Implemented Yet }
end;

function TPiramid.getA : TVector3;
begin
  Result := _AB.getA;
end;

function TPiramid.getB : TVector3;
begin
  Result := _AB.getB;
end;

function TPiramid.getC : TVector3;
begin
  Result := _AC.getB;
end;
 
function TPiramid.getS : TVector3;
begin
  Result := _AS.getB;
end;

function TPiramid.getABC : TTriangle;
begin
  Result := TTriangle.Create(A_B.getA, A_B.getB, B_C.getB, image, _pen.Color);
end;

function TPiramid.getBCS : TTriangle;
begin
  Result := TTriangle.Create(_BC.getA, _BC.getB, _CS.getB, image, _pen.Color);
end;

function TPiramid.getACS : TTriangle;
begin
  Result := TTriangle.Create(_AC.getA, _AC.getB, _CS.getB, image, _pen.Color);
end;

function TPiramid.getABS : TTriangle;
begin
  Result := TTriangle.Create(_AB.getA, _AB.getB, _BS.getB, image, _pen.Color);
end;

{$ENDREGION}

{$REGION ' Функции преобразования '}

procedure TPiramid.Rotate(center : TVector3; alpha : T = 0;
    beta : T = 0; gamma : T = 0);
begin
  _AB.Rotate(center, alpha, beta, gamma);
  _AC.Rotate(center, alpha, beta, gamma);
  _AS.Rotate(center, alpha, beta, gamma);
  _BC.Rotate(center, alpha, beta, gamma);
  _BS.Rotate(center, alpha, beta, gamma);
  _CS.Rotate(center, alpha, beta, gamma);
end;

procedure TPiramid.Rotate(alpha : T = 0; beta : T = 0; gamma : T = 0);
begin 
  _AB.Rotate(alpha, beta, gamma);
  _AC.Rotate(alpha, beta, gamma);
  _AS.Rotate(alpha, beta, gamma);
  _BC.Rotate(alpha, beta, gamma);
  _BS.Rotate(alpha, beta, gamma);
  _CS.Rotate(alpha, beta, gamma);
end;

procedure TPiramid.Move(dx : T = 0; dy : T = 0; dz : T = 0);
begin 
  _AB.Move(dx, dy, dz);
  _AC.Move(dx, dy, dz);
  _AS.Move(dx, dy, dz);
  _BC.Move(dx, dy, dz);
  _BS.Move(dx, dy, dz);
  _CS.Move(dx, dy, dz);
end;

procedure TPiramid.Move(delta : TVector3);
begin 
  _AB.Move(delta);
  _AC.Move(delta);
  _AS.Move(delta);
  _BC.Move(delta);
  _BS.Move(delta);
  _CS.Move(delta);
end;

procedure TPiramid.Scale(center : TVector3; x : T = 1; y : T = 1; z : T = 1);
begin  
  _AB.Scale(center, x, y, z);
  _AC.Scale(center, x, y, z);
  _AS.Scale(center, x, y, z);
  _BC.Scale(center, x, y, z);
  _BS.Scale(center, x, y, z);
  _CS.Scale(center, x, y, z);
end;

procedure TPiramid.Scale(center : TVector3; scale : TVector3);
begin 
  _AB.Scale(center, scale);
  _AC.Scale(center, scale);
  _AS.Scale(center, scale);
  _BC.Scale(center, scale);
  _BS.Scale(center, scale);
  _CS.Scale(center, scale);
end;

procedure TPiramid.Scale(x : T = 1; y : T = 1; z : T = 1);
begin
  _AB.Scale(x, y, z);
  _AC.Scale(x, y, z);
  _AS.Scale(x, y, z);
  _BC.Scale(x, y, z);
  _BS.Scale(x, y, z);
  _CS.Scale(x, y, z);
end;

{$ENDREGION}

procedure TPiramid.Draw;
var
  center : TVector3;
  temp_pen : TPen;
begin
  temp_pen := TPen.Create;
  temp_pen.Color := image.Canvas.Pen.Color;
  image.Canvas.Pen.Color := _pen.Color;
  _AB.pen.Color := _pen.Color;
  _AC.pen.Color := _pen.Color;
  _AS.pen.Color := _pen.Color;
  _BC.pen.Color := _pen.Color;
  _BS.pen.Color := _pen.Color;
  _CS.pen.Color := _pen.Color;
  _AB.Draw;
  _AC.Draw;
  _AS.Draw;
  _BC.Draw;
  _BS.Draw;
  _CS.Draw;
  image.Canvas.Pen.Color := temp_pen.Color;
end;

END.
