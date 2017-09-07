UNIT CSVParser;

INTERFACE

uses Grids;

// элемент периодической системы химических элементов
type element = record
  number : Integer;  // порядковый номер
  name : String;  // название
  weight : Real;  // удельный вес
  conduction : (unknown, conductive, nonconductive, semiconductor);  // проводимость
end;

// строки в таблице
type Rows = array of element;
type PRows = ^Rows;

// сама таблица
type CSVTable = class
  private
    const CHUNK = 8;  // по сколько элементов за раз добалять в таблицу
    var
    text_table : TextFile;  // CSV файл, откуда читать таблицу
    procedure addElement(table : TStringGrid; elements : Rows; i, j : Integer);
  public
    elements : Rows;  // элементы - строки в таблице
    elements_count : Integer;  // количество элементов в таблице
    constructor Create(filename : string; separator : char = ';');
    procedure showConductors(table : TStringGrid; ConductorsSorted : Rows);
    procedure showSemiConductors(table : TStringGrid);
    procedure showNonConductors(table : TStringGrid; maxWeight : Real = 0);
    procedure showAll(table : TStringGrid);
end;

IMPLEMENTATION

uses Main, SysUtils;

// загрузка данных из CSV файла filename, разделённых separator
constructor CSVTable.Create(filename: string; separator: char = ';');

var
  str : string;
  status, i : integer;

begin
  i := 0;
  elements_count := 0;

  // открываем файл для чтения
  AssignFile (text_table, filename);
  Reset(text_table);

  // читаем данные из файла
  while not EOF(text_table) do
  begin
    // увеличиваем размер таблицы, если нужно
    if i >= elements_count then
    begin
      elements_count := elements_count + CHUNK;
      SetLength(elements, elements_count);
    end;

    ReadLn(text_table, str);
    val(copy(str, 1, pos(separator, str) - 1), elements[i].number, status);
    // если данные некоректны, принимаем номер, равным 0
    if status <> 0 then elements[i].number := 0;
    delete (str, 1, pos(separator, str));  // отрезаем от строки прочитанную часть
    elements[i].name := copy(str, 1, pos(separator, str) - 1);
    delete (str, 1, pos(separator, str));  // отрезаем от строки прочитанную часть
    val(copy(str, 1, pos(separator, str) - 1), elements[i].weight, status);
    // если данные некоректны, принимаем удельный вес, равным 0
    if status <> 0 then elements[i].weight := 0;
    delete (str, 1, pos(separator, str));  // отрезаем от строки прочитанную часть

    // устанавливаем проводимость
    if str = 'проводник' then elements[i].conduction := conductive
    else if str = 'изолятор' then elements[i].conduction := nonconductive
    else if str = 'полупроводник' then elements[i].conduction := semiconductor
    else elements[i].conduction := unknown;

    inc(i);  // увеличиваем счётчик
  end;
  
  elements_count := i;
  CloseFile(text_table);
end;

// заполняем таблицу table всеми элементами
procedure CSVTable.showAll(table : TStringGrid);
var
  i : Integer;
  s : string;
begin
  for i := 0 to elements_count do
  begin
    addElement(table, elements, i, i);
    // заполняем четвёртую ячейку типом проводимости i-го элемента
    if elements[i].conduction = Conductive then s := 'Проводник'
    else if elements[i].conduction = NonConductive then s := 'Изолятор'
    else if elements[i].conduction = SemiConductor then s := 'Полупроводник'
    else s := 'не известно';  // Если тип проводимости не известен, выведем "не известно"
    table.Cells[3, i + 1] := s;
  end;
end;

// заполняем таблицу table проводниками
procedure CSVTable.showConductors(table : TStringGrid; ConductorsSorted : Rows);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if elements[i].conduction = conductive then
    begin
      // добавляем новый элемент
      addElement(table, ConductorsSorted, i, j);
      inc(j);  // увеличиваем счётчик
    end;
end;

// заполняем таблицу table полупроводниками
procedure CSVTable.showSemiConductors(table : TStringGrid);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if elements[i].conduction = semiConductor then
    begin
      // добавляем новый элемент
      addElement(table, elements, i, j);
      inc(j);  // увеличиваем счётчик
    end;
end;

// заполняем таблицу table изоляторами
procedure CSVTable.showNonConductors(table : TStringGrid; maxWeight : Real = 0);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if (elements[i].conduction = nonConductive) and ( (maxWeight < 0) or
       (elements[i].weight <= maxWeight) ) then
    begin
      // добавляем новый элемент
      addElement(table, elements, i, j);
      inc(j);  // увеличиваем счётчик
    end;
end;

// добавляет i-ый элемент в j-ую строку таблицы table
procedure CSVTable.addElement(table: TStringGrid; elements : Rows; i, j: Integer);
var s : string;
begin
  table.RowCount := j + 1;
  // заполняем первую ячейку номером i-го элемента
  if elements[i].number = 0 then
    s := 'не известно'
  else
    Str(elements[i].number, s);
  table.Cells[0, j + 1] := s;
  // заполняем вторую ячейку названием i-го элемента
  table.Cells[1, j + 1] := elements[i].name;
  // заполняем третью ячейку удельным весом i-го элемента                       
  if elements[i].weight = 0 then
    s := 'не известно'
  else
  Str(elements[i].weight:4:2, s);
  table.Cells[2, j + 1] := s;
end;

END.
