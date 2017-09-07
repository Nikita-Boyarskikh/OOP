#include <iostream>
#include <string>

#include "HW2.3.h"

using std::cout;
using std::endl;
using std::cin;
using std::string;

int main(int argc, char **argv) {
    int n;
    Expression* arr = NULL;
    node* list = NULL;
    do {
        cout << "Введите, сколько выражений добавить в массив: ";
        cin >> n;
        if(n < 0) {
            cout << "> Введите неотрицательное число!" << endl;
        }
    } while(n < 0); 
    size_t array_size = n;
    cin.ignore();
    if(n > 0) {
        arr = new Expression[n];
        cout << "Введите " << n << " выражений:" << endl;
    }
    for(size_t i = 0; i < array_size; i++) {
        string s;
        getline(cin, s);
        try {
            arr[i] = Expression(s);
            cout << "В введённом выражении " << arr[i].count_operations() << " операций" <<endl;
        } catch(WrongExpression) {
            cout << "> Введено некорректное выражение! Попробуйте ещё раз..." << endl;
            i--;
        }
    }

    do {
        cout << "Введите, сколько выражений добавить в список: ";
        cin >> n;
        if(n < 0) {
            cout << "> Введите неотрицательное число!" << endl;
        }
    } while(n < 0);
    size_t list_size = n;
    cin.ignore();
    node* cur = NULL;
    if(n > 0) {
        list = new node;
        cur = list;
        cout << "Введите " << n << " выражений:" << endl;
    }
    for(size_t i = 0; i < list_size; i++) {
        string s;
        getline(cin, s);
        try {
            Expression expr(s);
            cur->data = expr;
            cout << "В введённом выражении " << expr.count_operations() << " операций" <<endl;
            if(i < list_size - 1) {
                cur->next = new node;
                cur = cur->next;
            }
        } catch(WrongExpression) {
            cout << "> Введено некорректное выражение! Попробуйте ещё раз..." << endl;
            i--;
        }
    }

    cout << "На введённых данных будет создано двоичное дерево" << endl;

    // Создание двоичного дерева
    Tree<string, int> tree;

    for(size_t i = 0; i < array_size; i++) {
        tree.add(arr[i].sum_of_numbers(), arr[i].expr);
    }

    cur = list;
    while(cur != NULL) {
        tree.add((cur->data).sum_of_numbers(), (cur->data).expr);
        cur = cur->next;
    }

    // Освобождение выделенной памяти
    delete[] arr;
    while(list != NULL) {
        cur = list->next;
        delete list;
        list = cur;
    }

    cout << "Введите выражение для поиска (для выхода введите 'end'): ";
    string s;
    do {
        getline(cin, s);
        Expression* expr;
        if(s == "end") break;
        try {
            expr = new Expression(s);
        } catch(WrongExpression) {
            cout << "> Введено некорректное выражение! Попробуйте ещё раз..." << endl;
            continue;
        }

        bool found = true;
        try {
            tree.find(expr->sum_of_numbers());
        } catch(NotFound) {
            cout << "> Выражение не найдено!" << endl;
            found = false;
        }
        if(found) {
            cout << "> Выражение найдено!" << endl;
        }
    } while(s != "end");

    return 0;
}
