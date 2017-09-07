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
    // ��������������� �� ����������� ��������� ���� ��������� ������
    ConductorsSorted : Rows;
    { ��������� ������ ��������� element arr �� x ����������
    �� ������� first �� ������� last }
    procedure ConductorsSort(arr : PRows; first, last : Integer);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  periodic_chemical_system : TextFile;  // CSV ���� � �������� ���������
  periodic_table : CSVTable;  // ������� ���������

IMPLEMENTATION

{$R *.dfm}

// �������������
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Cursor := crAppStart;  // ���������� ������ ��������
  // ��������� ������� ��������� �� ����� CSV
  periodic_table := CSVTable.Create('../Periodic_table.csv');
  Cursor := crDefault;  // ������� ������
end;

{$REGION ' ������ '}

// ��������� ������
procedure TfrmMain.btnGraphicClick(Sender: TObject);
var
  points : TPointArray;  // ������ �����
  i : Integer;
begin
  Cursor := crAppStart;  // ���������� ������ ��������
  imgTable.Visible := False;  // �������� ��������
  strGrdElems.Visible := False;  // �������� �������
  SetLength(points, length(periodic_table.elements));  // ����� ����� ������� �����

  // ��������� ������ �����
  for i := 0 to periodic_table.elements_count - 1 do
  begin
    points[i].x := periodic_table.elements[i].number;  // ����� ��������
    points[i].y := round(periodic_table.elements[i].weight*100);  // ��� �������� * 100 (��� ��������  ����������� ����������)
  end;

  // ������ ������ �� ��� ������ ����� ������� �� ������ �� �������
  Graphic.paint(points, periodic_table.elements_count, 0, 0, imgGraphic.Width, imgGraphic.Height, imgGraphic);

  imgGraphic.Visible := True;  // ���������� ������
  Cursor := crDefault;  // ������� ������
end;

// ����������
procedure TfrmMain.btnConductorsClick(Sender: TObject);
begin
  Cursor := crAppStart;  // ���������� ������ ��������
  imgTable.Visible := False;  // �������� ��������
  imgGraphic.Visible := False;  // �������� ������
  strGrdElems.ColCount := 3;  // ���������� ������� : 3

  // ��������� ��������� �������
  strGrdElems.Cells[0, 0] := '�����';
  strGrdElems.Cells[1, 0] := '��������';
  strGrdElems.Cells[2, 0] := '�������� ���';

  ConductorsSorted := Copy(periodic_table.elements);

  // ��������� �������� �� ������������ ��������� ����
  ConductorsSort(@ConductorsSorted, 0, periodic_table.elements_count - 1);

  // ������� ���������� �������
  periodic_table.showConductors(frmMain.strGrdElems, ConductorsSorted);

  strGrdElems.Visible := True;  // ���������� �������
  Cursor := crDefault;  // ������� ������
end;

// ���������
procedure TfrmMain.btnIsolatorsClick(Sender: TObject);
var
  answer : string;
  value : Real;
  status : Integer;
begin
  // ����� ���� � ��������
  answer := InputBox('���������', '����������, ������� ������������ �������� ���.'
      + ' �������� ���� ������, ����� ������� ��� ���������.', '');
  val(answer, value, status);  // �������� �������� � �����
  // ���� ������������ ��� ������������ ������, ������� ���
  if status <> 0 then value := -1;

  Cursor := crAppStart;  // ���������� ������ ��������
  imgTable.Visible := False;  // �������� ��������
  imgGraphic.Visible := False;  // �������� ������
  strGrdElems.ColCount := 3;  // ���������� ������� : 3

  // ��������� ��������� �������
  strGrdElems.Cells[0, 0] := '�����';
  strGrdElems.Cells[1, 0] := '��������';
  strGrdElems.Cells[2, 0] := '�������� ���';

  // ������� ���������� �������
  periodic_table.showNonConductors(frmMain.strGrdElems, value);

  strGrdElems.Visible := True;  // ���������� �������
  Cursor := crDefault;  // ������� ������
end;

// ��������������
procedure TfrmMain.btnSemiClick(Sender: TObject);
begin
  Cursor := crAppStart;  // ���������� ������ ��������
  imgTable.Visible := False;  // �������� ��������
  imgGraphic.Visible := False;  // �������� ������
  strGrdElems.ColCount := 3;  // ���������� ������� : 3

  // ��������� ��������� �������
  strGrdElems.Cells[0, 0] := '�����';
  strGrdElems.Cells[1, 0] := '��������';
  strGrdElems.Cells[2, 0] := '�������� ���';

  // ������� ���������� �������
  periodic_table.showSemiConductors(frmMain.strGrdElems);

  strGrdElems.Visible := True;  // ���������� �������
  Cursor := crDefault;  // ������� ������
end;

// �������� ���
procedure TfrmMain.btnShowAllClick(Sender: TObject);
begin
  Cursor := crAppStart;  // ���������� ������ ��������
  imgTable.Visible := False;  // �������� ��������
  imgGraphic.Visible := False;  // �������� ������
  strGrdElems.ColCount := 4;  // ���������� ������� : 4

  // ��������� ��������� �������
  strGrdElems.Cells[0, 0] := '�����';
  strGrdElems.Cells[1, 0] := '��������';
  strGrdElems.Cells[2, 0] := '�������� ���';
  strGrdElems.Cells[3, 0] := '������������';

  // ������� ���������� �������
  periodic_table.showAll(frmMain.strGrdElems);

  strGrdElems.Visible := True;  // ���������� �������
  Cursor := crDefault;  // ������� ������
end;

// �����
procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

{$ENDREGION}

// ������� ����������
{ ��������� ������ ����� ��������� element arr �� x ����������
  �� ������� first �� ������� last }
procedure TfrmMain.ConductorsSort(arr : PRows; first, last : Integer);

var
  i, j : Integer;  // ��������
  middle : Real;
  temp : element;

begin
  i := first; j := last;
  middle := arr^[(first + last) div 2].weight;  // ������� �������� �������

  // ���������
  repeat
  begin
    // ����������� i �� ��� ���, ���� ��� �������� �� i �� ����� ������ ��������
    while (arr^[i].weight < middle) do inc(i);
    // ����������� j �� ��� ���, ���� ��� �������� ����� j �� ����� ������ ��������
    while (middle < arr^[j].weight) do dec(j);

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
    ConductorsSort(arr, first, j);
  // � �� i �� �����
  if (i < last) then
    ConductorsSort(arr, i, last);
end;

// ��������� �������
procedure TfrmMain.strGrdElemsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
type
  TSave = record
    FontColor : TColor;  // ���� ������
    FontStyle : TFontStyles;  // ����� ������
    BrColor : TColor;  // ���� �����
  end;
var
  Sg : TStringGrid;
  Save : TSave;
begin
  Sg := Sender as TStringGrid;

  with Sg.Canvas, Save do
  begin
    // ���������� ��������� ������ � �����.
    FontColor := Font.Color;
    FontStyle := Font.Style;
    BrColor := Brush.Color;

    // ������������� ����� ��������
    // ������������� ������
    if ARow <= Sg.FixedRows then
    begin
      Font.Color := clWhite;  // �����
      Font.Style := Font.Style + [fsBold];  // ������ �����
      Brush.Color := RGB($CC, $99, $66);  // ����������
    end
    // ��������������� ������ � ������� ���������
    else if ARow mod 2 = 0 then
    begin
      Font.Color := RGB(0, 0, 0);  // ������
      Brush.Color := RGB($FF, $FF, $CC);  // ������-�����
    end
    else
    // ��������������� ������ � ��������� ���������
    begin
      Font.Color := clBlack;  // ������
      Brush.Color := RGB($CC, $FF, $FF);  // ������-�����
    end;

    // ����������� �������������
    FillRect(Rect);

    // ������������� � ������ �����
    TextOut(Rect.Left + 4, Rect.Top + 4, Sg.Cells[ACol, ARow]);

    // ��������������� ������� ��������� �����
    Font.Color := FontColor;
    Font.Style := FontStyle;
    Brush.Color := BrColor;
  end;
end;

END.
