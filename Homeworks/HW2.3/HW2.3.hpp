#ifndef HW23_HPP
#define HW23_HPP

#include <cstring>
using std::string;

// Константы Expression
constexpr char Expression::operations[12];
constexpr char Expression::numbers[11];

// Методы Expression
Expression::Expression(string s)
{
    operations_counter = 0;
    sum = 0;
    bool lastop = false;
    for(size_t i = 0; i < s.length(); i++) {
        bool wrong = true;
        for(size_t j = 0; j < strlen(operations) + strlen(numbers); j++) {
            if( j < strlen(operations) ) {
                if(s[i] == operations[j]) {
                    if(lastop) {
                        wrong = true;
                        break;
                    }
                    wrong = false;
                    lastop = true;
                    operations_counter++;
                    break;
                }
            } else {
                if( s[i] == numbers[j - strlen(operations)] ) {
                    wrong = false;
                    lastop = false;
                    break;
                }
            }
        }
        if( (s.length() == 1 && lastop) || wrong ) {
            throw WrongExpression();
        }
    }
    for(size_t i = 0; i < s.length(); i++) {
        int num = 0;
        while(s[i] - '0' >= 0 && s[i] - '0' <= 9) {
            num = num * 10 + s[i] - '0';
            i++;
        }
        sum += num;
    }
    expr = s;
}

size_t Expression::count_operations()
{
    return operations_counter;
}

int Expression::sum_of_numbers()
{
    return sum;
}

// Методы Tree
template <class T, class K>
Tree<T, K>::Tree()
{
    _size = 0;
    _data = NULL;
}

template <class T, class K>
size_t Tree<T, K>::size()
{
    return _size;
}

template <class T, class K>
void Tree<T, K>::add(K key, T data)
{
    _add_data(&_data, NULL, key, data);
    _size++;
}

template <class T, class K>
void Tree<T, K>::_add_data(tree_node** tree, tree_node* parent, K key, T data)
{
    if(*tree == NULL) {
        *tree = new tree_node;
        (*tree)->key = key;
        (*tree)->value = data;
        (*tree)->parent = parent;
        (*tree)->left = NULL;
        (*tree)->right = NULL;
        return;
    }
    if(key < (*tree)->key) {
        _add_data(&(*tree)->left, *tree, key, data);
    } else {
        _add_data(&(*tree)->right, *tree, key, data);
    }
}

template <class T, class K>
T Tree<T, K>::find(K key)
{
    return _find(_data, key);
}

template <class T, class K>
T Tree<T, K>::_find(tree_node* tree, K key)
{
    if(tree == NULL) throw NotFound();
    if(tree->key == key) return tree->value;
    if(tree->key < key) return _find(tree->right, key);
    return _find(tree->left, key);
}

template <class T, class K>
void Tree<T, K>::_destroy(tree_node* tree)
{
    if(tree == NULL) return;
    _destroy(tree->left);
    _destroy(tree->right);
    delete tree;
}

template <class T, class K>
Tree<T, K>::~Tree()
{
    _destroy(_data);
}

#endif  // HW23_HPP
