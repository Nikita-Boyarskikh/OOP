UNIT Main;

INTERFACE

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  ExtendedVector, ExtendedLine,
  ExtendedTriangle, ExtendedPiramid, ExtendedPrism;
   
const SPEED_STEP = 1;  // ���, �� ������� ����� ������������� ��������
      MAX_SPEED = 10;  // ������������ �������� ��������

type
  TfrmMain = class(TForm)
    lblSpeed: TLabel;
    lblColor: TLabel;
    Image: TImage;
    udSpeed: TUpDown;
    edtSpeed: TEdit;
    ColorBox: TColorBox;
    {$REGION ' ����������� ������� '}
    procedure FormPaint(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure udSpeedClick(Sender: TObject; Button: TUDBtnType);
    procedure ColorBoxChange(Sender: TObject);
    {$ENDREGION}
  private
    { Private declarations }
    isActive : Boolean;  // �������� ���������� ������ ����� isActive = True
    speed : Integer;  // �������� ��������
    procedure CMDialogKey(var Message: TCMDialogKey);
    message CM_DIALOGKEY;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  Triangle : TTriangle;
  Piramid : TPiramid;
  Prism : TPrism;

IMPLEMENTATION

{$R *.dfm}

{$REGION ' ���������� ���������� ���� '}
// ��������� ������������� �������� ����������
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  image.Canvas.Brush.Color := clWhite;
  speed := 0;
  isActive := True;
  Triangle := TTriangle.Create(
      TVector3.Create(0, 300), TVector3.Create(200, 300),
      TVector3.Create(100, 100), Image
  ); 
  Piramid := TPiramid.Create(
      TVector3.Create(300, 300), TVector3.Create(500, 300),
      TVector3.Create(400, 300, 200), TVector3.Create(400, 100, 100), Image
  );
  Prism := TPrism.Create(
      TVector3.Create(500, 300), TVector3.Create(700, 300),
      TVector3.Create(600, 300, 200), 200, Image
  );
  FormPaint(frmMain);
  frmMain.Refresh;
end;

{ ���������� �������� ��� ������������ ����� ��� ��������
  ������������� ������� � ������ ������� ���������� ������������ }
procedure TfrmMain.FormHide(Sender: TObject);
begin
  isActive := False;
end;

// ��� �������������� ���� ���������� ��������
procedure TfrmMain.FormShow(Sender: TObject);
begin
  isActive := True;
  FormPaint(frmMain);
end;
{$ENDREGION}

{$REGION ' ���������� ����������� '}
// ��������� ������� ���������� ������ (���������� ���������� ���������)
procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if isActive then
  begin
    // ������� 0..9 �������� ������������� 0..9 ��������
    case Key of
      '0' : speed := 0*round(MAX_SPEED/10);
      '1' : speed := 1*round(MAX_SPEED/10);
      '2' : speed := 2*round(MAX_SPEED/10);
      '3' : speed := 3*round(MAX_SPEED/10);
      '4' : speed := 4*round(MAX_SPEED/10);
      '5' : speed := 5*round(MAX_SPEED/10);
      '6' : speed := 6*round(MAX_SPEED/10);
      '7' : speed := 7*round(MAX_SPEED/10);
      '8' : speed := 8*round(MAX_SPEED/10);
      '9' : speed := 9*round(MAX_SPEED/10);
    end;

    if speed > 0 then
    begin
      if speed > MAX_SPEED then
        speed := MAX_SPEED;
    end
    else
      if speed < -MAX_SPEED then
        speed := -MAX_SPEED;

    frmMain.Refresh;
  end;
end;

// ��� ��� ��������� ��������� ���������� ��������� ����������
procedure TfrmMain.CMDialogKey(var Message: TCMDialogKey);
begin
  // ������������� ������� ������� TAB
  if Message.CharCode <> VK_TAB then
    inherited;
end;

// ��������� ������� ������ ����������
procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // ��� ����������� ������
  if Shift = [] then
  begin
    case Key of
      // ������������� �������� ������� Enter, Esc
      // � ������� Space ��� ������� ������������ �����������
      VK_RETURN : isActive := not isActive;
      VK_ESCAPE : isActive := not isActive;
      VK_SPACE : isActive := not isActive;
    end;
    if isActive then
    begin
      case Key of
        { ��������� ��������� (�����������/���������)
          ������� PageUp/PageDown, Home/End, +/-,
          ������� �����/����, ������/����� }
        VK_PRIOR : speed := speed + SPEED_STEP;
        VK_NEXT : speed := speed - SPEED_STEP;
        VK_HOME : speed := speed + SPEED_STEP;
        VK_END : speed := speed - SPEED_STEP;
        VK_ADD : speed := speed + SPEED_STEP;
        VK_SUBTRACT : speed := speed - SPEED_STEP;
        VK_RIGHT : speed := speed + SPEED_STEP;
        VK_LEFT : speed := speed - SPEED_STEP;
        VK_UP : speed := speed + SPEED_STEP;
        VK_DOWN : speed := speed - SPEED_STEP;

        // ������� TAB ������������� �������� � ��������������� �������
        VK_TAB : speed := -speed;

        { ������� 0..9 �� NUMPAD-������
          �������� ������������� 0..9 �������� }
        VK_NUMPAD0 : speed := 0*round(MAX_SPEED/10);
        VK_NUMPAD1 : speed := 1*round(MAX_SPEED/10);
        VK_NUMPAD2 : speed := 2*round(MAX_SPEED/10);
        VK_NUMPAD3 : speed := 3*round(MAX_SPEED/10);
        VK_NUMPAD4 : speed := 4*round(MAX_SPEED/10);
        VK_NUMPAD5 : speed := 5*round(MAX_SPEED/10);
        VK_NUMPAD6 : speed := 6*round(MAX_SPEED/10);
        VK_NUMPAD7 : speed := 7*round(MAX_SPEED/10);
        VK_NUMPAD8 : speed := 8*round(MAX_SPEED/10);
        VK_NUMPAD9 : speed := 9*round(MAX_SPEED/10);
      end;
    end;
    if speed > 0 then
    begin
      if speed > MAX_SPEED then
        speed := MAX_SPEED;
    end
    else
    if speed < -MAX_SPEED then
      speed := -MAX_SPEED;
  end;
  FormPaint(frmMain);
  frmMain.Refresh;
end;

// ������� � �������� ��������� ����� ���������� ������
procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // ��� ���������� Space ��� ����������� ������ ���������� ��������
  if (Shift = []) and (Key = VK_SPACE) then
    isActive := not isActive;
  FormPaint(frmMain);
  frmMain.Refresh;
end;
{$ENDREGION}

{$REGION ' ���������� ����� '}
// ���������� ��������� �������� � ������� ������� ����
procedure TfrmMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if isActive then
  begin
    if WheelDelta > 0 then
      if speed <= MAX_SPEED - SPEED_STEP then
        speed := speed + SPEED_STEP
    else
      if speed >= -MAX_SPEED + SPEED_STEP then
        speed := speed - SPEED_STEP;
    FormPaint(frmMain);
    frmMain.Refresh;
  end;
end;

// ��� ������� ������� ���� �� ����������� ���������� ��������
procedure TfrmMain.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isActive := False;
end;

// ��� ���������� ������� ���� �� ����������� ����������� ��������
procedure TfrmMain.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isActive := True;
  FormPaint(frmMain);
  frmMain.Refresh;
end;

{$ENDREGION}

{$REGION ' ����������� ������� '}

procedure TfrmMain.udSpeedClick(Sender: TObject; Button: TUDBtnType);
begin
  if Button = btNext then
  begin
    speed := speed + SPEED_STEP;
    if speed > MAX_SPEED then
      speed := MAX_SPEED;
  end
  else if Button = btPrev then
  begin
    speed := speed - SPEED_STEP;
    if speed < -MAX_SPEED then
      speed := -MAX_SPEED;
  end;
  FormPaint(frmMain);
  frmMain.Refresh;
end;

procedure TfrmMain.ColorBoxChange(Sender: TObject);
var pen : TPen;
begin
  pen := TPen.Create;
  pen.Color := ColorBox.Selected;
  Triangle.pen := pen;
  Piramid.pen := pen;
  Prism.pen := pen;
end;

{$ENDREGION}

// ��������� ����
procedure TfrmMain.FormPaint(Sender: TObject);
var Line2 : TLine3;
begin
  if isActive then
  begin
    Triangle.Clear;
    Triangle.Rotate(TVector3.Create(100, 200), 0, 0.001*speed);
    Triangle.Draw;
    Piramid.Clear;
    Piramid.Rotate(TVector3.Create(400, 200, 100), 0, 0.001*speed);
    Piramid.Draw;
    Prism.Clear;
    Prism.Rotate(TVector3.Create(600, 200, 100), 0, 0.001*speed);
    Prism.Draw;
    edtSpeed.Text := IntToStr(speed);
  end;
end;

END.
