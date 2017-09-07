UNIT Graphic;

INTERFACE

uses ExtCtrls, Graphics;

{$REGION ' Константы и типы '}

const MARGIN = 40;  // внутренние отступы вокруг графика
      TEXT_SIZE_X = 6;  // размер выводимых подписей по x
      TEXT_SIZE_Y = 10;  // размер выводимых подписей по y
      GRID_STEP_X = 5;  // Частота шага сетки по x (через каждые GRID_STEP единиц)
      GRID_STEP_Y = 200;  // Частота шага сетки по y (через каждые GRID_STEP единиц)

// тип "точка" - запись из 2-х координат
type TPoint = record x, y : Integer; end;

type TPointArray = array of TPoint;
type PTPointArray = ^TPointArray;

{$ENDREGION}

// быстрая сортировка
{ сортирует массив точек TPoint arr по x координате
  от индекса first до индекса last }
procedure qSort(arr : PTPointArray; first, last : Integer);

// прототип процедуры, выводящей график по массиву точек
procedure paint(arr : TPointArray;  // массив точек 
    len,  // его длина
    // координаты левой верхней точки прямоугольника для отрисовки
    left_top_x, left_top_y,
    right_bottom_x, right_bottom_y : integer;
    Image : TImage  // изображение, на которое производить отрисовку
);

IMPLEMENTATION

// быстрая сортировка
// сортирует массив точек TPoint arr по x координате от индекса first до индекса last
procedure qSort(arr : PTPointArray; first, last : Integer);

var
  i, j : Integer;  // счётчики
  middle : Integer;
  temp : TPoint;

begin
  i := first; j := last;
  middle := arr^[(first + last) div 2].x;  // находим середину массива

  // сортируем
  repeat
  begin
    // проматываем i до тех пор, пока все элементы до i не будут меньше среднего
    while (arr^[i].x < middle) do inc(i);
    // проматываем j до тех пор, пока все элементы после j не будут больше среднего
    while (middle < arr^[j].x) do dec(j);

    // меняем местами i и j элементы
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

  // сортируем от начала до j
  if (first < j) then
    qSort(arr, first, j);
  // и от i до конца
  if (i < last) then
    qSort(arr, i, last);
end;


// процедура, выводящая график по массиву точек
procedure paint(arr : TPointArray;  // массив точек
    len,  // его длина
    // координаты левой верхней точки прямоугольника для отрисовки
    left_top_x, left_top_y,
    right_bottom_x, right_bottom_y : integer;
    Image : TImage  // изображение, на которое производить отрисовку
);

var
  y_min, y_max,  // минимальное и максимальное значение y
  mx, my : Double;  // масштабы
  screen_width, screen_height,  // размеры "окна"
  x, y,  // координаты
  i : integer;  // счётчик
  s : string[10];  // строки для вывода координат x и y на экран

begin
  // рисуем рамку
  Image.Canvas.Pen.Color := clGreen;
  Image.Canvas.Rectangle(left_top_x, left_top_y,
      right_bottom_x, right_bottom_y);

  // определяем размеры "окна"
  screen_width := right_bottom_x - left_top_x + 1;
  screen_height := right_bottom_y - left_top_y + 1;

  // сортируем массив по x координате
  qSort(@arr, 0, len - 1);

  // определяем минимальное и максимальное значения x и y
  y_min := 9999;
  y_max := -1;
  for i:=1 to len - 1 do
  begin
    if arr[i].y > y_max then
      y_max := arr[i].y;
    if (arr[i].y > 0) and (arr[i].y < y_min) then
      y_min := arr[i].y;
  end;

  // определяем масштабы по x и y
  mx := (screen_width - 2*MARGIN) / abs(arr[1].x - arr[len - 1].x) ;
  my := (screen_height - 2*MARGIN) / abs(y_max - y_min);

  // рисуем график
  Image.Canvas.Pen.Color := clRed;  // красный
  Image.Canvas.Pen.Width := 3;  // шириной 3px
  x := left_top_x + MARGIN;
  y := right_bottom_y - round(my*(arr[1].y - y_min)) - MARGIN;
  Image.Canvas.MoveTo(x, y);  // начальное положение курсора
  for i := 1 to len - 1 do
    if arr[i].y > 0 then  // Игнорируем неизвестные значения
    begin
      x := round(mx*(arr[i].x - arr[1].x)) + left_top_x + MARGIN;
      y := right_bottom_y - round(my*(arr[i].y - y_min)) - MARGIN;
      Image.Canvas.LineTo(x, y);  // линия до следующей точки
    end;

  // Выводим вертикальные линии сетки
  Image.Canvas.Pen.Width := 1;  // шириной 1px
  Image.Canvas.Pen.Color := clBlue;  // синие
  i := arr[0].x;
  while i < arr[len - 1].x do
  begin
    Str(i, s);  // преобразуем число в строку для вывода

    // выводим подпись
    x := round(mx*(i - arr[0].x)) + left_top_x + MARGIN - TEXT_SIZE_X;
    y := right_bottom_y - 5 - TEXT_SIZE_Y;
    Image.Canvas.TextOut(x, y, s);

    // рисуем линию
    x := x + TEXT_SIZE_X;
    y := left_top_y + MARGIN;
    Image.Canvas.MoveTo(x, y);
    Image.Canvas.LineTo(x, right_bottom_y - MARGIN);

    // увеличиваем счётчик
    i := i + GRID_STEP_X;
  end;

  // выводим  горизонтальные линии сетки
  i := round(y_min);
  while i < y_max do
  begin
    Str((i/100):4:2, s);  // преобразуем число в строку для вывода

    // выводим подпись
    x := left_top_x + 5;
    y := right_bottom_y - round(my*(i - y_min)) - MARGIN - TEXT_SIZE_Y;
    Image.Canvas.TextOut(x, y, s);

    // рисуем линию
    x := left_top_x + MARGIN;
    y := y + TEXT_SIZE_Y;
    Image.Canvas.MoveTo(x, y);
    Image.Canvas.LineTo(right_bottom_x - MARGIN, y);
                        
    // увеличиваем счётчик
    i := i + GRID_STEP_Y;
  end;
end;

END.
