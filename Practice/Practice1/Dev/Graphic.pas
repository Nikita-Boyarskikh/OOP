UNIT Graphic;

INTERFACE

uses ExtCtrls, Graphics;

{$REGION ' ��������� � ���� '}

const MARGIN = 40;  // ���������� ������� ������ �������
      TEXT_SIZE_X = 6;  // ������ ��������� �������� �� x
      TEXT_SIZE_Y = 10;  // ������ ��������� �������� �� y
      GRID_STEP_X = 5;  // ������� ���� ����� �� x (����� ������ GRID_STEP ������)
      GRID_STEP_Y = 200;  // ������� ���� ����� �� y (����� ������ GRID_STEP ������)

// ��� "�����" - ������ �� 2-� ���������
type TPoint = record x, y : Integer; end;

type TPointArray = array of TPoint;
type PTPointArray = ^TPointArray;

{$ENDREGION}

// ������� ����������
{ ��������� ������ ����� TPoint arr �� x ����������
  �� ������� first �� ������� last }
procedure qSort(arr : PTPointArray; first, last : Integer);

// �������� ���������, ��������� ������ �� ������� �����
procedure paint(arr : TPointArray;  // ������ ����� 
    len,  // ��� �����
    // ���������� ����� ������� ����� �������������� ��� ���������
    left_top_x, left_top_y,
    right_bottom_x, right_bottom_y : integer;
    Image : TImage  // �����������, �� ������� ����������� ���������
);

IMPLEMENTATION

// ������� ����������
// ��������� ������ ����� TPoint arr �� x ���������� �� ������� first �� ������� last
procedure qSort(arr : PTPointArray; first, last : Integer);

var
  i, j : Integer;  // ��������
  middle : Integer;
  temp : TPoint;

begin
  i := first; j := last;
  middle := arr^[(first + last) div 2].x;  // ������� �������� �������

  // ���������
  repeat
  begin
    // ����������� i �� ��� ���, ���� ��� �������� �� i �� ����� ������ ��������
    while (arr^[i].x < middle) do inc(i);
    // ����������� j �� ��� ���, ���� ��� �������� ����� j �� ����� ������ ��������
    while (middle < arr^[j].x) do dec(j);

    // ������ ������� i � j ��������
    if (i <= j) then
    begin
      temp := arr^[i];
      arr^[i] := arr^[j];
      arr^[j] := temp;
      inc(i);
      dec(j);
    end;
  end;
  until (i > j);

  // ��������� �� ������ �� j
  if (first < j) then
    qSort(arr, first, j);
  // � �� i �� �����
  if (i < last) then
    qSort(arr, i, last);
end;


// ���������, ��������� ������ �� ������� �����
procedure paint(arr : TPointArray;  // ������ �����
    len,  // ��� �����
    // ���������� ����� ������� ����� �������������� ��� ���������
    left_top_x, left_top_y,
    right_bottom_x, right_bottom_y : integer;
    Image : TImage  // �����������, �� ������� ����������� ���������
);

var
  y_min, y_max,  // ����������� � ������������ �������� y
  mx, my : Double;  // ��������
  screen_width, screen_height,  // ������� "����"
  x, y,  // ����������
  i : integer;  // �������
  s : string[10];  // ������ ��� ������ ��������� x � y �� �����

begin
  // ������ �����
  Image.Canvas.Pen.Color := clGreen;
  Image.Canvas.Rectangle(left_top_x, left_top_y,
      right_bottom_x, right_bottom_y);

  // ���������� ������� "����"
  screen_width := right_bottom_x - left_top_x + 1;
  screen_height := right_bottom_y - left_top_y + 1;

  // ��������� ������ �� x ����������
  qSort(@arr, 0, len - 1);

  // ���������� ����������� � ������������ �������� x � y
  y_min := 9999;
  y_max := -1;
  for i:=1 to len - 1 do
  begin
    if arr[i].y > y_max then
      y_max := arr[i].y;
    if (arr[i].y > 0) and (arr[i].y < y_min) then
      y_min := arr[i].y;
  end;

  // ���������� �������� �� x � y
  mx := (screen_width - 2*MARGIN) / abs(arr[1].x - arr[len - 1].x) ;
  my := (screen_height - 2*MARGIN) / abs(y_max - y_min);

  // ������ ������
  Image.Canvas.Pen.Color := clRed;  // �������
  Image.Canvas.Pen.Width := 3;  // ������� 3px
  x := left_top_x + MARGIN;
  y := right_bottom_y - round(my*(arr[1].y - y_min)) - MARGIN;
  Image.Canvas.MoveTo(x, y);  // ��������� ��������� �������
  for i := 1 to len - 1 do
    if arr[i].y > 0 then  // ���������� ����������� ��������
    begin
      x := round(mx*(arr[i].x - arr[1].x)) + left_top_x + MARGIN;
      y := right_bottom_y - round(my*(arr[i].y - y_min)) - MARGIN;
      Image.Canvas.LineTo(x, y);  // ����� �� ��������� �����
    end;

  // ������� ������������ ����� �����
  Image.Canvas.Pen.Width := 1;  // ������� 1px
  Image.Canvas.Pen.Color := clBlue;  // �����
  i := arr[0].x;
  while i < arr[len - 1].x do
  begin
    Str(i, s);  // ����������� ����� � ������ ��� ������

    // ������� �������
    x := round(mx*(i - arr[0].x)) + left_top_x + MARGIN - TEXT_SIZE_X;
    y := right_bottom_y - 5 - TEXT_SIZE_Y;
    Image.Canvas.TextOut(x, y, s);

    // ������ �����
    x := x + TEXT_SIZE_X;
    y := left_top_y + MARGIN;
    Image.Canvas.MoveTo(x, y);
    Image.Canvas.LineTo(x, right_bottom_y - MARGIN);

    // ����������� �������
    i := i + GRID_STEP_X;
  end;

  // �������  �������������� ����� �����
  i := round(y_min);
  while i < y_max do
  begin
    Str((i/100):4:2, s);  // ����������� ����� � ������ ��� ������

    // ������� �������
    x := left_top_x + 5;
    y := right_bottom_y - round(my*(i - y_min)) - MARGIN - TEXT_SIZE_Y;
    Image.Canvas.TextOut(x, y, s);

    // ������ �����
    x := left_top_x + MARGIN;
    y := y + TEXT_SIZE_Y;
    Image.Canvas.MoveTo(x, y);
    Image.Canvas.LineTo(right_bottom_x - MARGIN, y);
                        
    // ����������� �������
    i := i + GRID_STEP_Y;
  end;
end;

END.
