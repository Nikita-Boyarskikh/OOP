#include <iostream>
#include <string>

#include "HW3.1.h"

using std::cout;
using std::cin;
using std::endl;
using std::string;

int main(int argc, char **argv) {

    string s;
    cout << "Демонстрация работы конструкторов класса Word:" << endl;

    cout << "Введите первое слово: ";
    cin >> s;
    cin.ignore();
    Word w1(s);

    cout << "Второе слово будет создано из первого." << endl;
    Word w2(w1);

    cout << "Третье слово будет создано программно из постоянной строки." << endl;
    Word w3("Third");
    cout << endl;

    cout << "Демонстрация работы функции print() класса Word:" << endl;
    cout << "Первое слово: "; w1.print();
    cout << "Второе слово: "; w2.print();
    cout << "Третье слово: "; w3.print();
    cout << endl;

    cout << "Демонстрация работы функции to_cstr(char*) класса Word:" << endl;
    char a[99], b[99], c[99];
    w1.to_cstr(a);
    w2.to_cstr(b);
    w3.to_cstr(c);

    cout << "Первое слово: " << a << endl;
    cout << "Второе слово: " << b << endl;
    cout << "Третье слово: " << c << endl << endl;

    cout << "Демонстрация работы функции to_str() класса Word:" << endl;
    cout << "Первое слово: " << w1.to_str()<<endl;
    cout << "Второе слово: " << w2.to_str()<<endl;
    cout << "Третье слово: " << w3.to_str()<<endl;
    cout << endl;

    cout << "Демонстрация работы функций подсчёта гласных/согласных букв, " <<
            "нахождения их процентного соотношения класса Word:" << endl << endl;

    cout << "В первом слове:" << endl;
    cout << "Количество глассных букв: " << w1.count_vowels() << endl;
    cout << "Количество согласных букв: " << w1.count_consonants() << endl;
    cout << "Процент гласных: " << 100*w1.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*w1.consonant_percentage() << "%" << endl;
    cout << endl;

    cout << "Во втором слове:" << endl;
    cout << "Количество гласных букв: " << w2.count_vowels() << endl;
    cout << "Количество согласных букв: " << w2.count_consonants() << endl;
    cout << "Процент гласных: " << 100*w2.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*w2.consonant_percentage() << "%" << endl;
    cout << endl;

    cout << "В третьем слове:" << endl;
    cout << "Количество глассных букв: " << w3.count_vowels() << endl;
    cout << "Количество согласных букв: " << w3.count_consonants() << endl;
    cout << "Процент гласных: " << 100*w3.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*w3.consonant_percentage() << "%" << endl;
    cout << endl;

    cout << "---------------------------------------------------------------" << endl;
    cout << endl;

    cout << "Демонстрация работы конструкторов класса Sentence:" << endl;
    cout << "Введите первое предложение: ";
    getline(cin, s);
    Sentence sen1(s);

    cout << "Второе предложение будет создано из первого." << endl;
    Sentence sen2(sen1);

    cout << "Третье предложение будет составлено из первого слова." << endl;
    Sentence sen3(w1);

    cout << "Четвёртое предложение будет создано программно из слов, разделённых пробелами." << endl;
    Sentence sen4(w1.to_str() + string(" ") + w2.to_str() + string(" ") + w3.to_str());

    cout << endl;

    cout << "Демонстрация работы функции print() класса Sentence:" << endl;
    cout << "Первое предложение: "; sen1.print();
    cout << "Второе предложение: "; sen2.print();
    cout << "Третье предложение: "; sen3.print();
    cout << "Четвёртое предложение: "; sen4.print();
    cout << endl;

    cout << "Демонстрация работы функций подсчёта гласных/согласных букв, " <<
            "нахождения их процентного соотношения класса Word:" << endl << endl;

    cout << "В первом предложении:" << endl;
    cout << "Количество слов: " << sen1.count() << endl;
    cout << "Количество гласных букв: " << sen1.count_vowels() << endl;
    cout << "Количество согласных букв: " << sen1.count_consonants() << endl;
    cout << "Процент гласных: " << 100*sen1.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*sen1.consonant_percentage() << "%" << endl;
    cout << endl;

    cout << "Во втором предложении:" << endl;
    cout << "Количество слов: " << sen2.count() << endl;
    cout << "Количество гласных букв: " << sen2.count_vowels() << endl;
    cout << "Количество согласных букв: " << sen2.count_consonants() << endl;
    cout << "Процент гласных: " << 100*sen2.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*sen2.consonant_percentage() << "%" << endl;
    cout << endl;

    cout << "В третьем предложении:" << endl;
    cout << "Количество слов: " << sen3.count() << endl;
    cout << "Количество гласных букв: " << sen3.count_vowels() << endl;
    cout << "Количество согласных букв: " << sen3.count_consonants() << endl;
    cout << "Процент гласных: " << 100*sen3.vowel_percentage() << "%" << endl;
    cout << "Процент согласных: " << 100*sen3.consonant_percentage() << "%" << endl;
    cout << endl;

    return 0;
}
