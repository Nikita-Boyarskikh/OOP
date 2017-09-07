UNIT Main;

INTERFACE

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, CustomizeDlg, StdCtrls, Grids, jpeg, CSVParser, Graphic;

type
  TfrmMain = class(TForm)
    imgGraphic: TImage;
    btnIsolators: TButton;
    btnConductors: TButton;
    btnSemi: TButton;
    strGrdElems: TStringGrid;
    btnGraphic: TButton;
    imgTable: TImage;
    btnShowAll: TButton;
    btnExit: TButton;
    procedure FormCreate(Sender: TObject);
    procedure strGrdElemsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnExitClick(Sender: TObject);
    procedure btnSemiClick(Sender: TObject);
    procedure btnIsolatorsClick(Sender: TObject);
    procedure btnConductorsClick(Sender: TObject);
    procedure btnShowAllClick(Sender: TObject);
    procedure btnGraphicClick(Sender: TObject);
  private
    // отсортированный по возрастанию удельного веса элементов массив
    ConductorsSorted : Rows;
    { сортирует массив элементов element arr по x координате
    от индекса first до индекса last }
    procedure ConductorsSort(arr : PRows; first, last : Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  periodic_chemical_system : TextFile;  // CSV файл с таблицей элементов
  periodic_table : CSVTable;  // таблица элементов

IMPLEMENTATION

{$R *.dfm}

// инициализация
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Cursor := crAppStart;  // показываем курсор загрузки
  // загружаем таблицу элементов из файла CSV
  periodic_table := CSVTable.Create('../Periodic_table.csv');
  Cursor := crDefault;  // обычный курсор
end;

{$REGION ' Кнопки '}

// построить график
procedure TfrmMain.btnGraphicClick(Sender: TObject);
var
  points : TPointArray;  // массив точек
  i : Integer;
begin
  Cursor := crAppStart;  // показываем курсор загрузки
  imgTable.Visible := False;  // скрываем картинку
  strGrdElems.Visible := False;  // скрываем таблицу
  SetLength(points, length(periodic_table.elements));  // задаём длину массиву точек

  // заполняем массив точек
  for i := 0 to periodic_table.elements_count - 1 do
  begin
    points[i].x := periodic_table.elements[i].number;  // номер элемента
    points[i].y := round(periodic_table.elements[i].weight*100);  // вес элемента * 100 (для простоты  дальнейшего построения)
  end;

  // рисуем график на всю ширину канвы графика по точкам из массива
  Graphic.paint(points, periodic_table.elements_count, 0, 0, imgGraphic.Width, imgGraphic.Height, imgGraphic);

  imgGraphic.Visible := True;  // показываем график
  Cursor := crDefault;  // обычный курсор
end;

// проводники
procedure TfrmMain.btnConductorsClick(Sender: TObject);
begin
  Cursor := crAppStart;  // показываем курсор загрузки
  imgTable.Visible := False;  // скрываем картинку
  imgGraphic.Visible := False;  // скрываем график
  strGrdElems.ColCount := 3;  // количество колонок : 3

  // заполняем заголовок таблицы
  strGrdElems.Cells[0, 0] := 'Номер';
  strGrdElems.Cells[1, 0] := 'Название';
  strGrdElems.Cells[2, 0] := 'Удельный вес';

  ConductorsSorted := Copy(periodic_table.elements);

  // сортируем элементы по возрастранию удельного веса
  ConductorsSort(@ConductorsSorted, 0, periodic_table.elements_count - 1);

  // выводим содержимое таблицы
  periodic_table.showConductors(frmMain.strGrdElems, ConductorsSorted);

  strGrdElems.Visible := True;  // показываем таблицу
  Cursor := crDefault;  // обычный курсор
end;

// изоляторы
procedure TfrmMain.btnIsolatorsClick(Sender: TObject);
var
  answer : string;
  value : Real;
  status : Integer;
begin
  // выдаём окно с запросом
  answer := InputBox('Изоляторы', 'Пожалуйста, введите максимальный удельный вес.'
      + ' Оставьте поле пустым, чтобы вывести все изоляторы.', '');
  val(answer, value, status);  // пытаемся привести к числу
  // если пользователь ввёл некорректные данные, выводим все
  if status <> 0 then value := -1;

  Cursor := crAppStart;  // показываем курсор загрузки
  imgTable.Visible := False;  // скрываем картинку
  imgGraphic.Visible := False;  // скрываем график
  strGrdElems.ColCount := 3;  // количество колонок : 3

  // заполняем заголовок таблицы
  strGrdElems.Cells[0, 0] := 'Номер';
  strGrdElems.Cells[1, 0] := 'Название';
  strGrdElems.Cells[2, 0] := 'Удельный вес';

  // выводим содержимое таблицы
  periodic_table.showNonConductors(frmMain.strGrdElems, value);

  strGrdElems.Visible := True;  // показываем таблицу
  Cursor := crDefault;  // обычный курсор
end;

// полупроводники
procedure TfrmMain.btnSemiClick(Sender: TObject);
begin
  Cursor := crAppStart;  // показываем курсор загрузки
  imgTable.Visible := False;  // скрываем картинку
  imgGraphic.Visible := False;  // скрываем график
  strGrdElems.ColCount := 3;  // количество колонок : 3

  // заполняем заголовок таблицы
  strGrdElems.Cells[0, 0] := 'Номер';
  strGrdElems.Cells[1, 0] := 'Название';
  strGrdElems.Cells[2, 0] := 'Удельный вес';

  // выводим содержимое таблицы
  periodic_table.showSemiConductors(frmMain.strGrdElems);

  strGrdElems.Visible := True;  // показываем таблицу
  Cursor := crDefault;  // обычный курсор
end;

// показать все
procedure TfrmMain.btnShowAllClick(Sender: TObject);
begin
  Cursor := crAppStart;  // показываем курсор загрузки
  imgTable.Visible := False;  // скрываем картинку
  imgGraphic.Visible := False;  // скрываем график
  strGrdElems.ColCount := 4;  // количество колонок : 4

  // заполняем заголовок таблицы
  strGrdElems.Cells[0, 0] := 'Номер';
  strGrdElems.Cells[1, 0] := 'Название';
  strGrdElems.Cells[2, 0] := 'Удельный вес';
  strGrdElems.Cells[3, 0] := 'Проводимость';

  // выводим содержимое таблицы
  periodic_table.showAll(frmMain.strGrdElems);

  strGrdElems.Visible := True;  // показываем таблицу
  Cursor := crDefault;  // обычный курсор
end;

// выход
procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

{$ENDREGION}

// быстрая сортировка
{ сортирует массив точек элементов element arr по x координате
  от индекса first до индекса last }
procedure TfrmMain.ConductorsSort(arr : PRows; first, last : Integer);

var
  i, j : Integer;  // счётчики
  middle : Real;
  temp : element;

begin
  i := first; j := last;
  middle := arr^[(first + last) div 2].weight;  // находим середину массива

  // сортируем
  repeat
  begin
    // проматываем i до тех пор, пока все элементы до i не будут меньше среднего
    while (arr^[i].weight < middle) do inc(i);
    // проматываем j до тех пор, пока все элементы после j не будут больше среднего
    while (middle < arr^[j].weight) do dec(j);

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
    ConductorsSort(arr, first, j);
  // и от i до конца
  if (i < last) then
    ConductorsSort(arr, i, last);
end;

// раскраска таблицы
procedure TfrmMain.strGrdElemsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
type
  TSave = record
    FontColor : TColor;  // цвет шрифта
    FontStyle : TFontStyles;  // стиль шрифта
    BrColor : TColor;  // цвет кисти
  end;
var
  Sg : TStringGrid;
  Save : TSave;
begin
  Sg := Sender as TStringGrid;

  with Sg.Canvas, Save do
  begin
    // запоминаем параметры шрифта и кисти.
    FontColor := Font.Color;
    FontStyle := Font.Style;
    BrColor := Brush.Color;

    // устанавливаем новые парметры
    // фиксированные строки
    if ARow <= Sg.FixedRows then
    begin
      Font.Color := clWhite;  // белый
      Font.Style := Font.Style + [fsBold];  // жирный шрифт
      Brush.Color := RGB($CC, $99, $66);  // коричневый
    end
    // нефиксированные строки с чётными индексами
    else if ARow mod 2 = 0 then
    begin
      Font.Color := RGB(0, 0, 0);  // чёрный
      Brush.Color := RGB($FF, $FF, $CC);  // светло-жёлтый
    end
    else
    // нефиксированные строки с нечётными индексами
    begin
      Font.Color := clBlack;  // чёрный
      Brush.Color := RGB($CC, $FF, $FF);  // светло-синий
    end;

    // закрашиваем прямоугольник
    FillRect(Rect);

    // прорисовываем в ячейке текст
    TextOut(Rect.Left + 4, Rect.Top + 4, Sg.Cells[ACol, ARow]);

    // восстанавливаем прежние параметры канвы
    Font.Color := FontColor;
    Font.Style := FontStyle;
    Brush.Color := BrColor;
  end;
end;

END.
