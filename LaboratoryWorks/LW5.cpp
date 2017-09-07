#include <iostream>
#include <string>
#include <cstring>

// Односвязный список
class List {
  private:
    // Структура одного элемента списка
    struct node {
        std::string data;
        struct node *next;
    };

    // Гласные буквы
    char const VOWELS[11] = "AEUIOaeiou";

    // Гласная ли буква
    bool isVowel(char c);

    // Количество слов, начинающихся с гласной буквы
    size_t vowel_start;

    // Указатели на начало и на конец списка
    node *first;
    node *last;

  public:
    List();
    ~List();
    void push(std::string word);
    size_t get_vowel_start();
};

int main(int argc, char **argv) {

    using std::cin;
    using std::cout;
    using std::endl;

    List odd, even;
    std::string word;

    // Счётчик слов
    size_t word_counter = 0;

    cout << "Введите слова:" << endl;

    // Читвем слова, пока они есть в STDIN
    while(cin>>word) {
        // Чётные пишем в один список ...
        if(++word_counter % 2 == 0)
            even.push(word);
        // ... нечётные в другой
        else
            odd.push(word);
    }

    // Выводим результаты
    cout<<"Слов, начинающихся на гласную букву в первом списке: "<<odd.get_vowel_start()<<endl;
    cout<<"Слов, начинающихся на гласную букву во втором списке: "<<even.get_vowel_start()<<endl;

    if(odd.get_vowel_start() < even.get_vowel_start()) {
        cout<<"Слов, начинающихся на гласную букву во втором списке больше, чем в первом"<<endl;
    }
    else if(odd.get_vowel_start() > even.get_vowel_start())  {
        cout<<"Слов, начинающихся на гласную букву в первом списке больше, чем во втором"<<endl;
    } else {
        cout<<"Слов, начинающихся на гласную букву в обоих списках одинаковое количество"<<endl;
    }

    return 0;
}

// Конструктор
List::List() {
    vowel_start = 0;
    first = NULL;
    last = NULL;
}

// Вставка элемента
void List::push(std::string str) {
    if(first == NULL) {
        first = new node;
        last = first;
    }
    else {
        last->next = new node;
        last = last->next;
    }
    last->data = str;
    last->next = NULL;
    if( isVowel(str[0]) ) vowel_start++;
}

// Геттер счётчика слов, начинающихся на гласную букву
size_t List::get_vowel_start() {
    return vowel_start;
}

// Гласная ли буква
bool List::isVowel(char c) {
    return (strchr(VOWELS, c));
}

// Деструктор
List::~List() {
    while(first != NULL) {
        node *temp = first;
        first = first->next;
        delete temp;
    }
}
