#include <iostream>

int main( int argc, char *argv[] )
{

    using std::cout;
    using std::cin;
    using std::endl;

    char str[255];
    cout << "Введите строку для проверки баланса скобок: " << endl;
    cin >> str;

    // Начальная иницализация
    bool find = false, done = false;
    char *open_p = NULL, *close_p = NULL;
    int checker = 0;
    int counter = 0;

    // Считываем строку либо до конца, либо пока не будет перевеса закрывающих скобок
    for( int i=0; str[i] != '\0' && checker >= 0; i++ ) {
        switch( str[i] ) {
          case '(':
            counter++;
            checker++;
            // Нашли вторую открывающую скобку, сбрасываем счётчик
            if( !find && counter == 2 ) {
                open_p = str + i;
                find = true;
                counter = 0;
            }
            break;
          case ')':
            // Нашли соответствующую 2-ой открывающей закрывающую скобку
            if( !done && find && counter == 0 ) {
                close_p = str + i;
                done = true;
            }
            if( find ) counter--;
            checker--;
        }
    }

    // Проверяем сбалансированность
    if( checker != 0 )
        cout<<"ОШИБКА: Скобки НЕ сбалансированы!"<<endl;
    else {
        cout<<"Скобки сбалансированы."<<endl;
        // Выводим содержимое между второй парой скобок, если это возможно
        if( open_p && close_p && open_p < close_p ) {
            cout<<"Между 2-ой парой скобок находится следующее: \"";
            for( char *i = open_p + 1; i < close_p; i++ ) cout<<*i;
            cout<<'\"'<<endl;
        }
    }

    return 0;
}
