UNIT ExtendedVector;

INTERFACE

{$DEFINE Extended_Template}
{$INCLUDE Graphics/Templater}

{$REGION ' TVector3 '}
type TVector3 = record
    x, y, z : T;
    length : T;
    class function Create(x : T = 0; y : T = 0; z : T = 0) : TVector3; overload; static;
    class function Create(vector : TVector3) : TVector3; overload; static;
    class operator Add(a, b : TVector3) : TVector3; overload;
    class operator Subtract(a, b : TVector3) : TVector3; overload;
    class operator Multiply(a, b : TVector3) : T; overload;
    class operator LogicalAnd(a, b : TVector3) : TVector3; overload;
    class operator Multiply(a : T; b : TVector3) : TVector3; overload;
    class operator Multiply(b : TVector3; a : T) : TVector3; overload;
    class operator Negative(vector : TVector3) : TVector3; overload;
    class operator Equal(a, b : TVector3) : Boolean; overload;
    class operator NotEqual(a, b: TVector3) : Boolean; overload;
    class operator Positive(a : TVector3) : TVector3;
end;

function normalize(a : TVector3) : TVector3;
{$ENDREGION}

IMPLEMENTATION

{$REGION ' TVector3 '}

// Нормализация длины вектора
function normalize(a : TVector3) : TVector3;
begin
  Result := a * (1/a.length);
end;

{$REGION ' Конструкторы '}
class function TVector3.Create(x : T = 0; y : T = 0; z : T = 0) : TVector3;
var rec : TVector3;
begin
  rec.x := x;
  rec.y := y;
  rec.z := z;
  rec.length := sqrt(x*x + y*y + z*z);
  Result := rec;
end;

class function TVector3.Create(vector : TVector3) : TVector3;
var rec : TVector3;
begin
  rec.x := vector.x;
  rec.y := vector.y;
  rec.z := vector.z;
  rec.length := vector.length;
  Result := rec;
end;
{$ENDREGION}

{$REGION ' Арифметические операторы '}
// C := A + B;
class operator TVector3.Add(a, b : TVector3): TVector3;
begin
  Result := TVector3.Create(a.x + b.x, a.y + b.y, a.z + b.z);
end;

// C := A - B;
class operator TVector3.Subtract(a, b : TVector3): TVector3;
begin
  Result := TVector3.Create(a.x - b.x, a.y - b.y, a.z - b.z);
end;

// number := A * B (скалярное произведение векторов);
class operator TVector3.Multiply(a, b : TVector3): T;
begin
  Result := a.x*b.x + a.y*b.y + a.z*b.z;
end;

// C := A and B (векторное произведение векторов);
class operator TVector3.LogicalAnd(a, b : TVector3): TVector3;
begin
  Result := TVector3.Create(a.y*b.z - a.z*b.y, a.z*b.x - a.x*b.z, a.x*b.y - a.y*b.x);
end;

// C := 3 * A;
class operator TVector3.Multiply(a : T; b : TVector3): TVector3;
begin
  Result := TVector3.Create(b.x * a, b.y * a, b.z * a);
end;

// C := A * 3;
class operator TVector3.Multiply(b : TVector3; a : T): TVector3;
begin
  Result := TVector3.Create(b.x * a, b.y * a, b.z * a);
end;

// C := -B;
class operator TVector3.Negative(vector : TVector3): TVector3;
begin
  Result := TVector3.Create(-vector.x, -vector.y, -vector.z);
end;

// C := +A; (нормализация вектора A)
class operator TVector3.Positive(a : TVector3) : TVector3;
begin
  Result := a * (1/a.length);
end;
{$ENDREGION}

{$REGION ' Операторы сравнения '} 
// C = B;
class operator TVector3.Equal(a, b : TVector3): Boolean;
begin
  Result := (a.x = b.x) and (a.y = b.y) and (a.z = b.z);
end;

// C <> B;
class operator TVector3.NotEqual(a, b: TVector3): Boolean;
begin
  Result := (a.x <> b.x) or (a.y <> b.y) or (a.z <> b.z);
end;
{$ENDREGION}

{$ENDREGION}

END.
