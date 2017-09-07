#ifndef _COMPLEX_HEADER
#define _COMPLEX_HEADER

#include <iostream>
#include <string>

using std::istream;
using std::ostream;
using std::string;

class WrongFormat : public std::exception {
  public:
    string msg;
    WrongFormat() { msg = "WrongFormat"; };
    WrongFormat(string str) { msg = str; };
};

// Шаблонный класс "Комплексное число"
template <typename T>
class Complex {
  private:
    T _dec;   // Действительная часть
    T _comp;  // Мнимая часть

  protected:
    void _init(const char *str, size_t len);

  public:
    // Конструкторы
    Complex();
    Complex(T dec);  // comp = 0
    Complex(T dec, T comp);
    Complex(char *str, size_t len);
    Complex(string str);
    Complex(const Complex<T> &c);

    // Арифметические операторы
    Complex<T> operator+(Complex<T> c);
    Complex<T> operator-(Complex<T> c);
    template <typename SCALAR>
    Complex<T> operator*(SCALAR n);

    // Операторы присваивания
    Complex<T> &operator=(Complex<T> c);
    Complex<T> &operator=(T num);
    Complex<T> &operator=(string str);
    Complex<T> &operator=(char *str);

    // Методы приведения типов
    void to_str(string str) const;
    void to_c_str(char* str) const;

    // Дружественные операторы ввода-вывода
    template <typename U>
    friend istream& operator>>(istream &is, Complex<U> &c);
    template <typename U>
    friend ostream& operator<<(ostream &os, Complex<U> &c);
};

#include "Complex.hpp"
#endif  // _COMPLEX_HEADER
