UNIT Stack;

INTERFACE

uses SysUtils;

type
  TMetaStack = class
    public type EStack = class(Exception);
    private
      const FRAME_SIZE = 8;
            MAX_SIZE = 1024*1024;
      type
        EStackOverflow = class(EStack);
        EStackIsEmpty = class(EStack);
        TPnode = ^Tnode;
        Tnode = record
          data : real;
          pref, next : TPnode;
        end;
      var
        Pfirst, Pcur, Plast : TPnode;
        size, current_size : integer;
    public
      constructor Create(data : array of real); overload;
      constructor Create; overload;
      procedure push(a : real);
      function pop() : real;
      procedure print(simbol : string = ' '; space : integer = 0; precision : integer = 5);
      procedure erase;
      destructor Destroy; override;
  end;

  TStack = class(TMetaStack)
    private
      procedure _asc_qsort(first, last : TMetaStack.TPnode);
      procedure _desc_qsort(first, last : TMetaStack.TPnode);
    public
      procedure sort(asc : boolean);
  end;

IMPLEMENTATION

{ TMetaStack methods }
constructor TMetaStack.Create(data : array of real);
var
  i : integer;
  p : TPnode;
begin
  if Length(data) > MAX_SIZE then
    raise EStackOverflow.Create('ERROR: Length of input array is too long');
  if Length(data) = 0 then
  begin
    Pfirst := nil;
    Pcur := nil;
    Plast := nil;
    size := 0;
    current_size := 0;
    exit;
  end;
  new(p);
  Pfirst := p;
  p^.pref := nil;
  size := 1;
  current_size := 0;
  for i := 0 to (Length(data) div FRAME_SIZE + 1)*FRAME_SIZE - 1 do
  begin
    new(p^.next);
    p^.next^.pref := p;
    if i < Length(data) then
    begin
      p^.data := data[i];
      Pcur := p;
      current_size := current_size + 1;
    end
    else
      p^.data := 0;
    p := p^.next;
    size := size + 1;
  end;
  p^.next := nil;
  p^.data := 0;
  Plast := p;
end;

constructor TMetaStack.Create;
begin
  Pfirst := nil;
  Pcur := nil;
  Plast := nil;
  size := 0;  
  current_size := 0;
end;

procedure TMetaStack.push(a : real);
var p : TPnode;
    i : integer;
    tmp : array[0..0] of real;
begin
  if (Pcur = nil) or (size = 0) then
  begin
    tmp[0] := a;
    self.Create(tmp);
    exit;
  end;
  if (size >= MAX_SIZE) and (Pcur = Plast) then
    raise EStackOverflow.Create('ERROR: Cannot push new element in stack');

  // Выделяем недостающую память
  if current_size = size then
  begin
    new(Pcur.next);
    Pcur^.next^.pref := Pcur;
    p := Pcur^.next;
    size := size + FRAME_SIZE;
    for i := 0 to FRAME_SIZE do
    begin
      new(p^.next);
      p^.next^.pref := p;
      p := p^.next;
      p^.data := 0;
    end;
    p^.next := nil;
    Plast := p;
  end;
  Pcur := Pcur^.next;
  Pcur^.data := a;
  current_size := current_size + 1;
end;

function TMetaStack.pop() : real;
var i : integer;
    p : TPnode;
begin
  if Pcur <> nil then
  begin
    Result := Pcur^.data;
    Pcur^.data := 0;
    Pcur := Pcur^.pref;
    current_size := current_size - 1;
  end
  else  
    raise EStackIsEmpty.Create('ERROR: Cannot pop next element from stack');

  // Освобождаем лишнюю память
  if current_size <= size - FRAME_SIZE*2 + 1 then
  begin
    p := Plast;
    for i := 1 to 8 do
    begin
      p := p^.pref;
      Dispose(p^.next);
      size := size - 1;
    end;
    Plast := p;
    p^.next := nil;
  end;
end;

procedure TMetaStack.print(simbol : string = ' '; space : integer = 0; precision : integer = 5);
var p : TPnode;
begin
  if Pcur = nil then
    raise EStackIsEmpty.Create('ERROR: No data in stack to be printed');
  p := Pfirst;
  while p <> Pcur do
  begin
    Write(p^.data:space:precision, simbol);
    p := p^.next;
  end;
  Write(p^.data:space:precision, simbol);
end;

procedure TMetaStack.erase;
begin
  self.Destroy;
  self := TStack.Create;
end;

destructor TMetaStack.Destroy;
var p, next : TPnode;
begin
  if Pfirst <> nil then
  begin
    p := Pfirst;
    while size > 0 do
    begin
      next := p.next;
      Dispose(p);
      p := next;
      size := size - 1;
    end;
  end;
end;

{ TStack methods }
procedure TStack.sort(asc : boolean);
begin
  if asc then
    _asc_qsort(Pfirst, Pcur)
  else
    _desc_qsort(Pfirst, Pcur);
end;
   
// Быстрая сортировка по возрастанию
procedure TStack._asc_qsort(first, last : TStack.TPnode);
var
  middle, i, j : TPnode;
  temp : real;
  counter, i_indx, j_indx, cur_size : integer;

begin
  i := first; j := last;
  j_indx := 0;
  while i <> j do
  begin
    inc(j_indx);
    i := i.next;
  end;
  i_indx := 0;
  i := first;
  cur_size := j_indx + 1;

  // находим средний элемент
  middle := i;
  for counter := 1 to cur_size div 2 do
    middle := middle.next;

  // сортируем
  while i_indx < j_indx do
  begin
    // проматываем i до тех пор, пока все элементы до i не будут меньше среднего
    while (i^.data < middle^.data) do
    begin
      i := i.next;
      inc(i_indx);
    end;
    // проматываем j до тех пор, пока все элементы после j не будут больше среднего
    while (middle^.data < j^.data) do
    begin
      j := j.pref;
      dec(j_indx);
    end;

    // меняем местами i и j элементы
    if i_indx <= j_indx then
    begin
      temp := i^.data;
      i^.data := j^.data;
      j^.data := temp;
      i := i.next;
      inc(i_indx);
      j := j.pref;
      dec(j_indx);
    end;
  end;

  // сортируем от начала до j
  if 0 < j_indx then
    _asc_qsort(first, j);
  // и от i до конца
  if i_indx < cur_size - 1 then
    _asc_qsort(i, last);
end;

// Быстрая сортировка по убыванию
procedure TStack._desc_qsort(first, last : TStack.TPnode);
var
  middle, i, j : TPnode;
  temp : real;
  counter, i_indx, j_indx, cur_size : integer;

begin
  i := first; j := last;
  j_indx := 0;
  while i <> j do
  begin
    inc(j_indx);
    i := i.next;
  end;
  i_indx := 0;
  i := first;
  cur_size := j_indx + 1;

  // находим средний элемент
  middle := i;
  for counter := 1 to cur_size div 2 do
    middle := middle.next;

  // сортируем
  while i_indx < j_indx do
  begin
    // проматываем i до тех пор, пока все элементы до i не будут меньше среднего
    while (i^.data > middle^.data) do
    begin
      i := i.next;
      inc(i_indx);
    end;
    // проматываем j до тех пор, пока все элементы после j не будут больше среднего
    while (middle^.data > j^.data) do
    begin
      j := j.pref;
      dec(j_indx);
    end;

    // меняем местами i и j элементы
    if i_indx <= j_indx then
    begin
      temp := i^.data;
      i^.data := j^.data;
      j^.data := temp;
      i := i.next;
      inc(i_indx);
      j := j.pref;
      dec(j_indx);
    end;
  end;

  // сортируем от начала до j
  if 0 < j_indx then
    _desc_qsort(first, j);
  // и от i до конца
  if i_indx < cur_size - 1 then
    _desc_qsort(i, last);
end;

END.
