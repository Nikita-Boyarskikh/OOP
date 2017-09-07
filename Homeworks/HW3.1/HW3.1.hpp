#ifndef HW31_HPP
#define HW31_HPP

#include <cstring>
#include <cmath>
#include <cstdlib>
#include <sstream>
#include <iterator>

using std::istringstream;
using std::cout;
using std::endl;

// Implementation of Word's methods
// Constants
constexpr char Word::_vowels[];

// Private methods
void Word::_init(const char *s) {
    _num_vowels = 0;
    _spaces = 0;
    for(size_t i=0; i<strlen(s); i++) {
        if(s[i] == ' ') {
            _spaces++;
            i++;
        }
        for(size_t j=0; j<(sizeof(_vowels)/sizeof(_vowels[0])); j++) {
            if(s[i] == _vowels[j]) {
                _num_vowels++;
                break;
            }
        }
    }
}

// Constructors
Word::Word(string s) : _data(s) {
    _init(s.c_str());
}

Word::Word(const char *s) : _data(s) {
    _init(s);
}

// Printer
void Word::print() {
    cout<<_data<<endl;
}

// Getters
string Word::to_str() {
    return _data;
}

void Word::to_cstr(char *arr) {
    strncpy(arr, _data.c_str(), _data.size());
    arr[_data.size()] = '\0';
}

// Counters
size_t Word::count_vowels() {
    return _num_vowels;
}

size_t Word::count_consonants() {
    return _data.length() - _num_vowels - _spaces;
}

float Word::consonant_percentage() {
    if(_num_vowels == _data.length()) return 0.0;
    return fabs((float)(_data.length() - _num_vowels - _spaces)/_data.length());
}

float Word::vowel_percentage() {
    if(_num_vowels == _data.length()) return 1.0;
    return (float)_num_vowels/_data.length();
}

// Implementation of Sentencese's methods
Sentence::Sentence(string s) : Word(s) {
    counter = 0;
    istringstream iss(s);
    string temp;
    while(iss>>temp) counter++;
}

Sentence::Sentence(const char *s) : Word(s) {
    counter = 0;
    istringstream iss(s);
    string temp;
    while(iss>>temp) counter++;
}

Sentence::Sentence(Word word) : Word(word) {
    counter = 0;
    istringstream iss(word.to_str());
    string temp;
    while(iss>>temp) counter++;
}

// Constructors
Sentence::Sentence(vector <string> v) {
    string temp, result;
    counter = 0;
    for(auto i : v) {
        istringstream iss(i);
        while(iss>>temp) {
            result += temp;
            counter++;
        }
    }
    _init(result.c_str());
}

// Getters
vector <string> Sentence::to_str_vec() {
    istringstream iss(_data);
    vector <string> result;
    std::copy(std::istream_iterator <string> (iss), std::istream_iterator <string> (),
              std::back_inserter < vector <string> > (result));
    return result;
}

size_t Sentence::count() {
    return counter;
}

#endif  // HW31_HPP
