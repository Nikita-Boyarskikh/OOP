#include <iostream>
#include <vector>
#include <cmath>
#include <cstdio>

typedef long long LL;

int length(const LL n)
{
    int len = 0;
    LL copy = n;
    while( copy != 0 ) {
        len++;
        copy /= 10;
    }
    return len;
}

LL palindrome(const LL half, int len)
{
    LL copy = half;
    LL result = half;
    if( len%2 == 1 ) result *= 10;
    while( copy != 0 ) {
        result = result*10 + copy%10;
        copy /= 10;
    }
    return result;
}

int main(int argc, char **argv)
{
    using std::cout;
    using std::cin;
    using std::endl;

    LL n;
    while( cout << "Введите число. " <<
                "Программа выведет все квадраты-палиндромы чисел, меньших введённого" << endl <<
                "(Введите 0 для выхода): ",
                cin >> n, n > 0 ) {
        const char delimiter[] = "|------+--------------------+----------------------|";
        const char format[] = "| %4d | %18lld | %20lld |";
        cout << delimiter << endl << "|    i |               x(i) |               x(i)^2 |" << endl << delimiter << endl;
        int counter = 0;
        for( LL i=1; i <= n; i++ ) {
            int len = length(i*i);
            if( len == 1 ) {
                counter++;
                printf(format, counter, i, i*i);
                cout << endl << delimiter << endl;
                continue;
            }
            LL half = i * i / pow( 10, len/2 + len%2 );
            LL palin = palindrome(half, len);
            const LL delta = palin - i*i;
            if( delta % (LL)pow(10, len/2) == 0 && delta / (LL)pow(10, len/2 + 1) == 0 ) {
                counter++;
                printf(format, counter, i, i*i);
                cout<<endl<<delimiter<<endl;
            }
        }
        cout << "  Количество полученных палиндромов: " << counter << endl;
    }

    return 0;
}
