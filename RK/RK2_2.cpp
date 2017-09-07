#include <iostream>
#include <string>
#include <sstream>
#include <vector>
#include <regex>

// Элемент двусвязного списка
template <typename T>
struct node {
    node* next;
    node* pref;
    T data;
};

// Класс "Очередь"
template <typename T>
class Queue {
  private:
    node<T>* first;
    node<T>* last;
  public:
    Queue(std::vector<unsigned int> numbers);
    ~Queue();
    void pop();
    void push(T data);
    node<T>* top();
};

int main()
{
    using std::cout;
    using std::cin;
    using std::endl;

    cout << "Введите строку чисел:" << endl;
    std::string str;
    std::getline(cin, str);

    // Проверка корректности строки
    for(auto ch: str) {
        if((ch < '0' || ch > '9') && ch != ' ') {
            cout << "Ошибка: Неверная строка!" << endl;
            return 1;
        }
    }

    std::stringstream ss;
    ss << str;

    std::vector<unsigned int> vec;
    long num;
    while(ss >> num) {
        if(num > 65535 || num < 0) {
            cout << "Ошибка: Недопустимое число!" << endl;
            return 1;
        }
        vec.push_back((unsigned int)num);
    }

    // Создание очереди
    Queue<unsigned int> queue(vec);


    queue.top();
    int row_a, row_b;
    cout << "Введите границы диапазона: ";
    cin >> row_a >> row_b;
    if(row_a < 0 || row_b < row_a) {
        cout << "Ошибка: неверные границы!" << endl;
        return 1;
    }
    unsigned int a = row_a;
    unsigned int b = row_b;

    // Посчёт чисел, попавших в диапазон
    size_t counter = 0;
    if(queue.top() != NULL) {
        unsigned int top = queue.top()->data;
        while(queue.top() != NULL) {
            if(a <= top && top <= b) counter++;
            queue.pop();
            top = queue.top()->data;
        }
    }
    cout << "Количество чисел, входящий в диапазон [" << a << ", " << b << "]: " << counter << endl;
    
    return 0;
}

template <typename T>
Queue<T>::Queue(std::vector<unsigned int> numbers)
{
    first = NULL;
    last = NULL;
    if(numbers.size() == 0) return;

    // Создаём первый элемент
    node<T>* cur;
    if( ! (cur = new node<T>) ) return;
    first = cur;
    cur->pref = NULL;
    cur->data = numbers[0];
    if( ! (cur->next = new node<T>) ) {
        delete cur;
        delete first;
        first = NULL;
        return;
    }
    cur = cur->next;
    cur->pref = first;

    // Создаём промежуточные элементы
    for(size_t i = 1; i < numbers.size() - 1; i++)
    {
        node<T>* pref = cur;
        cur->data = numbers[i];
        if( ! (cur->next = new node<T>) ) {
            while(cur != NULL) {
                cur = cur->pref;
                delete cur->next;
            }
            first = NULL;
            return;
        }
        cur = cur->next;
        cur->pref = pref;
    }

    last = cur;
    cur->data = numbers[numbers.size() - 1];
    cur->next = NULL;
    return;
}

template <typename T>
Queue<T>::~Queue()
{
    if(first == NULL || last == NULL) return;
    while(first != last) {
        first = first->next;
        delete first->pref;
    }
    delete last;
}

template <typename T>
node<T>* Queue<T>::top()
{
    return last;
}

template <typename T>
void Queue<T>::pop()
{
    if(!last) return;
    last = last->pref;
    if(!last) return;
    delete last->next;
    last->next = NULL;
}

template <typename T>
void Queue<T>::push(T data)
{
    first->pref = new node<T>;
    first = first->pref;
    first->data = data;
    first->pref = NULL;
}
