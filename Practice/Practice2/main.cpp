#include <iostream>
#include <cstdio>
#include <sstream>
#include <iomanip>

#include "Complex.h"

void clear_stdin()
{
    char c;
    while( scanf("%c", &c) == 1 && c != '\n' );
}

int main() {

    using std::cout;
    using std::cin;
    using std::endl;
    using std::setw;

    Complex <int> isum, idif, imul, ci1(-1);
    Complex <float> fsum, fdif, fmul, cf1(0.0, 3.4);
    Complex <double> dsum, ddif, dmul, cd1(999.99, -23.9402);

    // Вывод значений средствами C++
    cout << "Инициализированы комплексные числа следующих типов:" << endl;
    cout << setw(20) << "Operation     |" << setw(20) << "Int       |" << setw(20) <<
        "Float      |" << setw(20) << "Double       " << endl;
    cout << setw(20) << std::setfill('-') << "+" << setw(20) << "+" << setw(20) << "+" <<
        setw(20) << "-" << endl << std::setfill(' ');
    cout << setw(20) << "C1= |" << setw(18) << ci1 << " |" << setw(18) << cf1 << " |" <<
        setw(20) << cd1 << endl;

    cout << "Введите ещё по 2 числа каждого из типов:" << endl;
    bool done = false;
	
    // Ввод средствами C++
    cout << "Ввод первых чисел (C2=):" << endl;

    Complex<int> ci2;
    Complex<float> cf2;
    Complex<double> cd2;
	
    while( ! done ) {
        try {
            cout << "Введите комплексное число с целыми действительной и мнимой частью:" << endl;
            cin >> ci2;
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }

    done = false;
    while( ! done ) {
        try {
            cout << "Введите комплексное число с рациональными действительной и мнимой частью:" << endl;
            cin >> cf2;
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }

    done = false;
    while( ! done ) {
        try {
            cout << "Введите комплексное число с рациональными двойной точности действительной и мнимой частью:" << endl;
            cin >> cd2;
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }

    // Ввод средствами C
    char* str = new char[255];
    Complex<int>* ci3;
    done = false;
    while( ! done ) {
        try {
            printf("Ввод вторых чисел (C3=):\n");
            printf("Введите комплексное число с целыми действительной и мнимой частью:\n");
            if( scanf("%255[^\n]", str) != 1 ) {
                printf("Ошибка ввода!\n");
                return 1;
            }
            clear_stdin();
            ci3 = new Complex<int>(str, (size_t)255);
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }

    Complex<float>* cf3;
    done = false;
    while( ! done ) {
        try {
            cout << "Введите комплексное число с рациональными действительной и мнимой частью:" << endl; 
            if( scanf("%255[^\n]", str) != 1 ) {
                printf("Ошибка ввода!\n");
                return 1;
            }
            clear_stdin();
            cf3 = new Complex<float>(str, (size_t)255);
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }

    Complex<double>* cd3;
    done = false;
    while( ! done ) {
        try {
            cout << "Введите комплексное число с рациональными двойной точности действительной и мнимой частью:" << endl; 
            if( scanf("%255[^\n]", str) != 1 ) {
                printf("Ошибка ввода!\n");
                return 1;
            }
            clear_stdin();
            cd3 = new Complex<double>(str, (size_t)255);
            done = true;
        } catch( WrongFormat e ) {
            cout << e.msg << endl;
            done = false;
        }
    }
    delete[] str;
    
    cout << "С введёнными числами будут произведены операции сложения, вычитания и умножения на скаляр." << endl;
 
    // Операция сложения со всеми типами
    isum = ci2 + *ci3;
    fsum = cf2 + *cf3;
    dsum = cd2 + *cd3;
 
    // Операция вычитания со всеми типами
    idif = ci2 - *ci3;
    fdif = cf2 - *cf3;
    ddif = cd2 - *cd3;
 
    // Операция умножения на число со всеми типами
    double num;
    cout << "Введите число, с которым будет производиться операция умножения: N = ";
    cin >> num; cin.ignore();
	
    imul = ci1 * num;
    fmul = cf1 * num;
    dmul = cd1 * num;
 
    // Вывод результатов средствами C
    const char delimiter[] = "-------------------+-------------------+-------------------+--------------------\n";
    const char format[] = "%19s|%19s|%19s|%20s\n";
	
    printf(format, "Operation     ", "Int       ", "Float      ", "Double       ");
    printf(delimiter);
	
    char *si = new char[20];
    char *sf = new char[20];
    char *sd = new char[20];
	
    ci1.to_c_str(si);
    cf1.to_c_str(sf);
    cd1.to_c_str(sd);
    printf(format, "=C1", si, sf, sd);
    printf(delimiter);
	
    ci2.to_c_str(si);
    cf2.to_c_str(sf);
    cd2.to_c_str(sd);
    printf(format, "=C2", si, sf, sd);
    printf(delimiter);
	
    ci3->to_c_str(si);
    cf3->to_c_str(sf);
    cd3->to_c_str(sd);
    printf(format, "=C3", si, sf, sd);
    printf(delimiter);
	
    printf("%19s|%30lf\n", "N=", num);
    printf(delimiter);
	
    isum.to_c_str(si);
    fsum.to_c_str(sf);
    dsum.to_c_str(sd);
    printf(format, "=C2+C3", si, sf, sd);
    printf(delimiter);
	
    idif.to_c_str(si);
    fdif.to_c_str(sf);
    ddif.to_c_str(sd);
    printf(format, "=C2-C3", si, sf, sd);
    printf(delimiter);
	
    imul.to_c_str(si);
    fmul.to_c_str(sf);
    dmul.to_c_str(sd);
    printf(format, "=C1*N", si, sf, sd);
    printf(delimiter);

    delete ci3;
    delete cf3;
    delete cd3;
    delete[] si;
    delete[] sf;
    delete[] sd;

    return 0;
}
