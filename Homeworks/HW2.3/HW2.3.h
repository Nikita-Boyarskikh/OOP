#ifndef HW23_H
#define HW23_H

#include <string>

// Исключения
class WrongExpression : public std::exception {};
class NotFound : public std::exception {};

// Выражение
class Expression {
  private:
    constexpr static char operations[12] = "+-*/^&|%!:~";
    constexpr static char numbers[11] = "0123456789";
    size_t operations_counter;
    int sum;
  public:
    std::string expr;
    Expression(std::string s);
    Expression() {};
    size_t count_operations();
    int sum_of_numbers();
};

// Элемент списка
struct node {
    Expression data;
    node* next;
};

// Дерево
template <class T, class K>
class Tree {
  private:
    struct tree_node {
        tree_node* parent;
        tree_node* left;
        tree_node* right;
        T value;
        K key;
    };
    tree_node* _data;
    size_t _size;
    void _destroy(tree_node* tree);
    void _add_data(tree_node** tree, tree_node* parent, K key, T data);
    T _find(tree_node* tree, K key);
  public:
    Tree();
    ~Tree();
    size_t size();
    void add(K key, T data);
    T find(K key);
};

#include "HW2.3.hpp"
#endif  // HW23_H
