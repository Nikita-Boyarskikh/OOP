#ifndef _COMPLEX_
#define _COMPLEX_

//----------------------------Подключение заголовочных файлов-----------------------------

#include <string>
#include <iostream>
#include <sstream>
#include <regex>
#include <iomanip>

//----------------------------Импорт из пространства имён std-----------------------------

using std::istream;
using std::ostream;
using std::string;
using std::regex;

//------------------------------Реализация шаблонных методов------------------------------
//--------------------------------------Конструкторы--------------------------------------

template <class T>
void Complex<T>::_init(const char *str, size_t len) {
	
    regex full_complex_number("[ \t]*([-+]?[0-9]*\\.?[0-9]+)[ \t]+([-+]([0-9]*\\.?[0-9]+)?)i[ \t]*");
    regex real_number("[ \t]*([-+]?[0-9]*\\.?[0-9]+)[ \t]*");
    regex complex_number_wo_dec_part("[ \t]*([-+]?([0-9]*\\.?[0-9]+)?)i[ \t]*");
	
    std::smatch mr_full;
    std::smatch mr_real;
    std::smatch mr_wo_dec;
	
    string to_match(str);
    bool is_full = regex_match(to_match, mr_full, full_complex_number);
    bool is_real = regex_match(to_match, mr_real, real_number);
    bool is_complex = regex_match(to_match, mr_wo_dec, complex_number_wo_dec_part);
    size_t full_size = mr_full.size();
    size_t real_size = mr_real.size();
    size_t complex_size = mr_wo_dec.size();
	
    for(size_t i = 0; i < mr_full.size(); i++) if(mr_full[i].str() == "") full_size--;
    for(size_t i = 0; i < mr_real.size(); i++) if(mr_real[i].str() == "") real_size--;
    for(size_t i = 0; i < mr_wo_dec.size(); i++) if(mr_wo_dec[i].str() == "") complex_size--;
	
    if( !is_full && !is_real && !is_complex ) {
        throw WrongFormat(string("String '") + string(str) + string("' is not a complex number\n"));
    } else {
        if(is_full) {
            if(full_size == 3) {
                _dec = (T)atof(mr_full[1].str().c_str());
                _comp = (mr_full[2].str()[0] == '-') ? -1 : 1;
            } else {
                _dec = (T)atof(mr_full[1].str().c_str());
                _comp = (T)atof(mr_full[2].str().c_str());
            }
        } else if (is_real) {
            _comp = 0;
            _dec = (T)atof(mr_real[1].str().c_str());
        } else if (is_complex) {
            _dec = 0;
            if(complex_size == 1) {
                _comp = 1;
            } else if(complex_size == 2) {
                _comp = (mr_wo_dec[1].str()[0] == '-') ? -1 : 1;
            } else {
                _comp = (T)atof(mr_wo_dec[2].str().c_str());
            }
        }
    }
}

template <class T>
Complex<T>::Complex() {
    _dec = 0;
    _comp = 0;
}

template <class T>
Complex<T>::Complex(T dec) {
    _dec = dec;
    _comp = 0;
}

template <class T>
Complex<T>::Complex(T dec, T comp) {
    _dec = dec;
    _comp = comp;
}

template <class T>
Complex<T>::Complex(string str) {
    _init(str.c_str(), str.size());
}

template <class T>
Complex<T>::Complex(char *str, size_t len) {
    _init(str, len);
}

template <class T>
Complex<T>::Complex(const Complex<T> &c) {
    _dec = c._dec;
    _comp = c._comp;
}

//------------------------------Операторы------------------------------

template <class T>
Complex<T> Complex<T>::operator+(Complex<T> c) {
    Complex<T> tmp(_dec + c._dec, _comp + c._comp);
    return tmp;
}

template <class T>
Complex<T> Complex<T>::operator-(Complex<T> c) {
    Complex<T> tmp(_dec - c._dec, _comp - c._comp);
    return tmp;
}

template <typename T>
template <class SCALAR>
Complex<T> Complex<T>::operator*(SCALAR n) {
    Complex<T> tmp(_dec * n, _comp * n);
    return tmp;
}

template <class T>
Complex<T> &Complex<T>::operator=(Complex<T> c) {
    _dec = c._dec;
    _comp = c._comp;
}

template <class T>
Complex<T> &Complex<T>::operator=(T num) {
    _dec = num;
    _comp = 0;
}

template <class T>
Complex<T> &Complex<T>::operator=(string str) {
    _init(str.c_str(), str.size());
}

template <class T>
Complex<T> &Complex<T>::operator=(char *str) {
    _init(str, strlen(str));
}

//---------------------Операторы приведения типов----------------------

template <class T>
void Complex<T>::to_str(string str) const {
    if(str.size() == 0) return;
    char* c_str = new char[str.size()];
    to_c_str(c_str, str.size());
    str = (const char*)(c_str);
    delete[] c_str;
}

template <>
void Complex<float>::to_c_str(char *str) const {
    sprintf(str, "%4.2f %+4.2fi", _dec, _comp);
}

template <>
void Complex<double>::to_c_str(char *str) const {
    sprintf(str, "%4.2lf %+4.2lfi", _dec, _comp);
}

template <>
void Complex<int>::to_c_str(char *str) const {
    sprintf(str, "%4d %+4di", _dec, _comp);
}

template <>
void Complex<long>::to_c_str(char *str) const {
    sprintf(str, "%4ld %+4ldi", _dec, _comp);
}
//------------------------Операторы ввода-вывода------------------------

template <class T>
istream &operator>>(istream &is, Complex<T> &c) {
    char *c_str = new char[255];
    is.getline(c_str, 255);
    string str(c_str);
    c = str;
    is.clear();
    return is;
}

template <class T>
ostream &operator<<(ostream &os, Complex<T> &c) {
    char str[255] = {};
    c.to_c_str(str);
    os << str;
    return os;
}

#endif  // _COMPLEX_
