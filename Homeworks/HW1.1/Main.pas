UNIT Main;

INTERFACE

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  ExtendedVector, ExtendedLine,
  ExtendedTriangle, ExtendedPiramid, ExtendedPrism;
   
const SPEED_STEP = 1;  // Шаг, на который будет увеличиваться скорость
      MAX_SPEED = 10;  // Максимальная скорость вращения

type
  TfrmMain = class(TForm)
    lblSpeed: TLabel;
    lblColor: TLabel;
    Image: TImage;
    udSpeed: TUpDown;
    edtSpeed: TEdit;
    ColorBox: TColorBox;
    {$REGION ' Обработчики событий '}
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
    isActive : Boolean;  // Вращение происходит только когда isActive = True
    speed : Integer;  // Скорость вращения
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

{$REGION ' Управление состоянием окна '}
// Начальная инициализация значений переменных
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

{ Прекратить вращение при сворачивании формы для экономии
  процессорного времени и заряда батареи устройства пользователя }
procedure TfrmMain.FormHide(Sender: TObject);
begin
  isActive := False;
end;

// При разворачивании окна продолжить вращение
procedure TfrmMain.FormShow(Sender: TObject);
begin
  isActive := True;
  FormPaint(frmMain);
end;
{$ENDREGION}

{$REGION ' Управление клавиатурой '}
// Обработка нажатия символьных клавиш (дискретное управление скоростью)
procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if isActive then
  begin
    // клавиши 0..9 включают положительную 0..9 скорость
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

// Хук для перехвата сообщений диалоговых сообщений клавиатуры
procedure TfrmMain.CMDialogKey(var Message: TCMDialogKey);
begin
  // Перехватываем нажатие клавиши TAB
  if Message.CharCode <> VK_TAB then
    inherited;
end;

// Обработка нажатия клавиш клавиатуры
procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // Без управляющих клавиш
  if Shift = [] then
  begin
    case Key of
      // Останавливают вращение клавиши Enter, Esc
      // А клавиша Space при нажатии замораживает изображение
      VK_RETURN : isActive := not isActive;
      VK_ESCAPE : isActive := not isActive;
      VK_SPACE : isActive := not isActive;
    end;
    if isActive then
    begin
      case Key of
        { Управляют скоростью (увеличивают/уменьшают)
          клавиши PageUp/PageDown, Home/End, +/-,
          стрелки вверх/вниз, вправо/влево }
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

        // Клавиша TAB разворачивает вращение в противоположную сторону
        VK_TAB : speed := -speed;

        { клавиши 0..9 на NUMPAD-панели
          включают положительную 0..9 скорость }
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

// Возврат в исходное состояние после отпускания клавиш
procedure TfrmMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // При отпускании Space без управляющих клавиш продолжить вращение
  if (Shift = []) and (Key = VK_SPACE) then
    isActive := not isActive;
  FormPaint(frmMain);
  frmMain.Refresh;
end;
{$ENDREGION}

{$REGION ' Управление мышью '}
// Управление скоростью вращения с помощью колёсика мыши
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

// При зажатии клавиши мыши на изображении заморозить вращение
procedure TfrmMain.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isActive := False;
end;

// При отпускании клавиши мыши на изображении разморозить вращение
procedure TfrmMain.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  isActive := True;
  FormPaint(frmMain);
  frmMain.Refresh;
end;

{$ENDREGION}

{$REGION ' Обработчики событий '}

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

// Отрисовка окна
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
