#ifndef HW31_H
#define HW31_H

#include <string>
#include <vector>

using std::string;
using std::vector;

class Word {
  protected:
    Word() {};
    constexpr static char _vowels[] = "AEUIOaeuio";
    void _init(const char *s);
    string _data;
    size_t _num_vowels;
    size_t _spaces;

  public:
    Word(const Word &w) : _data(w._data), _num_vowels(w._num_vowels), _spaces(w._spaces) {};
    Word(string s);
    Word(const char *s);
    void print();
    string to_str();
    void to_cstr(char *arr);
    size_t count_vowels();
    size_t count_consonants();
    float consonant_percentage();
    float vowel_percentage();
};


class Sentence : public Word {

  private:
    size_t counter;

  public:
    Sentence(const Sentence &sen) : Word(sen._data), counter(sen.counter) {};
    Sentence(string s);
    Sentence(const char *s);
    Sentence(Word w);
    Sentence(vector <string> v);
    vector <string> to_str_vec();
    size_t count();
};

#include "HW3.1.hpp"
#endif  // HW31_H
