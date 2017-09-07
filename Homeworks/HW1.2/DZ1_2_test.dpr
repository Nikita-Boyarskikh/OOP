PROGRAM DZ1_2_test;

{$APPTYPE CONSOLE}

USES
  SysUtils,
  Stack in 'Stack.pas';

VAR
  num : real;
  done : boolean;
  i, n : integer;
  arr : array of real;
  command : string;
  stack : TStack;

// Справка по доступным командам для пользователя
procedure help;
begin
  WriteLn('Available commands:');
  WriteLn('help          -   show this tips');
  WriteLn('push          -   add an element in the stack');
  WriteLn('pop           -   get an element from the stack and print it to the screen');
  WriteLn('print         -   print a stack content to the screen');
  WriteLn('sort          -   sort the stack');
  WriteLn('erase         -   delete all elements from the stack');
  WriteLn('end/exit/quit -   terminate the programm');
end;

// Процедура сортировки стека
procedure sort(stack : TStack);
var order : string;
begin
  Write('Sort order (asc/desc): ');
  ReadLn(order);
  if AnsiLowerCase(order) = 'asc' then stack.sort(True)
  else if AnsiLowerCase(order) = 'desc' then stack.sort(False)
  else
    WriteLn('Wrong sort order');
end;

// Процедура добавления элемента в конец стека
procedure add;
begin
  Write('Enter number: ');
  try
    ReadLn(num);
  except
    on e : EInOutError do
    begin
      WriteLn(e.message);
      exit;
    end;
  end;
  stack.push(num);
end;

BEGIN
  // Пытаемся выяснить, какого же размера стек нам создать
  done := false;
  while not done do
  begin
    try
      Write('Please, enter the initial size of stack: ');
        try
          ReadLn(n);
        except
          on e : EInOutError do  // Сообщаем в случае ошибки
          begin
            // И считаем, что стек у нас не будет предварительно инициализирован
            n := 0;
            WriteLn(e.message);
          end;
        end;
      if n > 0 then
      begin
        setLength(arr, n);
        // Просим пользователя заполнить эти данные
        Write('Please, enter the initial values in stack: ');
        for i := 0 to n - 1 do
          try
            Read(arr[i]);
          except
            on e : EInOutError do  // Сообщаем в случае ошибки
            begin
              arr[i] := 0;
              WriteLn(e.message);
            end;
          end;
        ReadLn;
        // Создаём стек
        stack := TStack.Create(arr);
      end
      else
        // Создаём стек
        stack := TStack.Create;
      done := true;
    except
      // В случае ошибки работы со стеком сообщаем о произошедшем пользователю
      // и спрашиваем, продолжать ли работу или завершить программу
      on e : TStack.EStack do
      begin
        WriteLn(e.message);
        Write('Continue? (y): ');
        ReadLn(command);
        if AnsiLowerCase(command) = 'n' then
        begin
          done := true;
          WriteLn('Sorry, unable to create stack :(');
          WriteLn('The programm will be terminated. Please, enter to continue...');
          ReadLn;
          exit;
        end
        else
          done := false;
      end;
    end;
  end;
  Write('Stack, size of ');
  Write(n);
  WriteLn(' successfully created! :)');
  WriteLn;

  help;  // Показываем подсказку
  command := '';
  while True do  // Интерактивный event-loop
  begin
    Write('Enter your command: ');
    ReadLn(command);
    try
      if (AnsiLowerCase(command) = 'end') or (AnsiLowerCase(command) = 'exit') or
         (AnsiLowerCase(command) = 'quit') then break
      else if AnsiLowerCase(command) = 'help' then help
      else if AnsiLowerCase(command) = 'push' then add
      else if AnsiLowerCase(command) = 'pop' then WriteLn('> ', stack.pop:0:5)
      else if AnsiLowerCase(command) = 'print' then begin stack.print; WriteLn; end
      else if AnsiLowerCase(command) = 'sort' then sort(stack)
      else if AnsiLowerCase(command) = 'erase' then stack.erase
      else if command <> '' then
        WriteLn('Unsupported command! (for tips, please, enter help)');
    except
      on e : TStack.EStack do WriteLn(e.message);
    end;
    command := '';
  end;
  stack.Destroy;  // Освобождаем память
END.
