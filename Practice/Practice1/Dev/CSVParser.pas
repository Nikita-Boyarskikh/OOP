UNIT CSVParser;

INTERFACE

uses Grids;

// ������� ������������� ������� ���������� ���������
type element = record
  number : Integer;  // ���������� �����
  name : String;  // ��������
  weight : Real;  // �������� ���
  conduction : (unknown, conductive, nonconductive, semiconductor);  // ������������
end;

// ������ � �������
type Rows = array of element;
type PRows = ^Rows;

// ���� �������
type CSVTable = class
  private
    const CHUNK = 8;  // �� ������� ��������� �� ��� �������� � �������
    var
    text_table : TextFile;  // CSV ����, ������ ������ �������
    procedure addElement(table : TStringGrid; elements : Rows; i, j : Integer);
  public
    elements : Rows;  // �������� - ������ � �������
    elements_count : Integer;  // ���������� ��������� � �������
    constructor Create(filename : string; separator : char = ';');
    procedure showConductors(table : TStringGrid; ConductorsSorted : Rows);
    procedure showSemiConductors(table : TStringGrid);
    procedure showNonConductors(table : TStringGrid; maxWeight : Real = 0);
    procedure showAll(table : TStringGrid);
end;

IMPLEMENTATION

uses Main, SysUtils;

// �������� ������ �� CSV ����� filename, ���������� separator
constructor CSVTable.Create(filename: string; separator: char = ';');

var
  str : string;
  status, i : integer;

begin
  i := 0;
  elements_count := 0;

  // ��������� ���� ��� ������
  AssignFile (text_table, filename);
  Reset(text_table);

  // ������ ������ �� �����
  while not EOF(text_table) do
  begin
    // ����������� ������ �������, ���� �����
    if i >= elements_count then
    begin
      elements_count := elements_count + CHUNK;
      SetLength(elements, elements_count);
    end;

    ReadLn(text_table, str);
    val(copy(str, 1, pos(separator, str) - 1), elements[i].number, status);
    // ���� ������ ����������, ��������� �����, ������ 0
    if status <> 0 then elements[i].number := 0;
    delete (str, 1, pos(separator, str));  // �������� �� ������ ����������� �����
    elements[i].name := copy(str, 1, pos(separator, str) - 1);
    delete (str, 1, pos(separator, str));  // �������� �� ������ ����������� �����
    val(copy(str, 1, pos(separator, str) - 1), elements[i].weight, status);
    // ���� ������ ����������, ��������� �������� ���, ������ 0
    if status <> 0 then elements[i].weight := 0;
    delete (str, 1, pos(separator, str));  // �������� �� ������ ����������� �����

    // ������������� ������������
    if str = '���������' then elements[i].conduction := conductive
    else if str = '��������' then elements[i].conduction := nonconductive
    else if str = '�������������' then elements[i].conduction := semiconductor
    else elements[i].conduction := unknown;

    inc(i);  // ����������� �������
  end;
  
  elements_count := i;
  CloseFile(text_table);
end;

// ��������� ������� table ����� ����������
procedure CSVTable.showAll(table : TStringGrid);
var
  i : Integer;
  s : string;
begin
  for i := 0 to elements_count do
  begin
    addElement(table, elements, i, i);
    // ��������� �������� ������ ����� ������������ i-�� ��������
    if elements[i].conduction = Conductive then s := '���������'
    else if elements[i].conduction = NonConductive then s := '��������'
    else if elements[i].conduction = SemiConductor then s := '�������������'
    else s := '�� ��������';  // ���� ��� ������������ �� ��������, ������� "�� ��������"
    table.Cells[3, i + 1] := s;
  end;
end;

// ��������� ������� table ������������
procedure CSVTable.showConductors(table : TStringGrid; ConductorsSorted : Rows);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if elements[i].conduction = conductive then
    begin
      // ��������� ����� �������
      addElement(table, ConductorsSorted, i, j);
      inc(j);  // ����������� �������
    end;
end;

// ��������� ������� table ����������������
procedure CSVTable.showSemiConductors(table : TStringGrid);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if elements[i].conduction = semiConductor then
    begin
      // ��������� ����� �������
      addElement(table, elements, i, j);
      inc(j);  // ����������� �������
    end;
end;

// ��������� ������� table �����������
procedure CSVTable.showNonConductors(table : TStringGrid; maxWeight : Real = 0);
var
  i, j : Integer;
begin
  j := 0;
  for i := 0 to elements_count do
    if (elements[i].conduction = nonConductive) and ( (maxWeight < 0) or
       (elements[i].weight <= maxWeight) ) then
    begin
      // ��������� ����� �������
      addElement(table, elements, i, j);
      inc(j);  // ����������� �������
    end;
end;

// ��������� i-�� ������� � j-�� ������ ������� table
procedure CSVTable.addElement(table: TStringGrid; elements : Rows; i, j: Integer);
var s : string;
begin
  table.RowCount := j + 1;
  // ��������� ������ ������ ������� i-�� ��������
  if elements[i].number = 0 then
    s := '�� ��������'
  else
    Str(elements[i].number, s);
  table.Cells[0, j + 1] := s;
  // ��������� ������ ������ ��������� i-�� ��������
  table.Cells[1, j + 1] := elements[i].name;
  // ��������� ������ ������ �������� ����� i-�� ��������                       
  if elements[i].weight = 0 then
    s := '�� ��������'
  else
  Str(elements[i].weight:4:2, s);
  table.Cells[2, j + 1] := s;
end;

END.
