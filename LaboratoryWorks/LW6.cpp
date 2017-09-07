#include <iostream>
#include <string>
#include <vector>

// Дерево ссортировки
template <class T>
class Sorting_tree {
  private:
    struct node {
        node* parent;
        node* left;
        node* right;
        std::string value;
    };
    node* _data;
    size_t _size;
    void _destroy(node* tree);
    void _add_data(node** tree, node* parent, T data);
    void _preorder(node* tree, std::vector<T> &arr);
    void _postorder(node* tree, std::vector<T> &arr);
  public:
    Sorting_tree();
    ~Sorting_tree();
    size_t size();
    void add(T data);
    void asc_walk(T* data);
    void desc_walk(T* data);
};

int main(int argc, char **argv)
{
    using std::cout;
    using std::cin;
    using std::endl;

    Sorting_tree<std::string> tree;
    std::string s;

    cout << "Введите строки для сортировки:" << endl;
    while( getline(cin, s) ) {
        tree.add(s);
    }

    cout << endl << "Отсортированные по возрастанию данные:" << endl;
    std::string* asc = new std::string[tree.size()];
    tree.asc_walk(asc);
    for(size_t i = 0; i < tree.size(); i++) {
        cout << asc[i] << ' ';
    }

    cout << endl << "Отсортированные по убыванию данные:" << endl;
    std::string* desc = new std::string[tree.size()];
    tree.desc_walk(desc);
    for(size_t i = 0; i < tree.size(); i++) {
        cout << desc[i] << ' ';
    }
    cout << endl;

    delete[] asc;
    delete[] desc;

    return 0;
}

template <class T>
Sorting_tree<T>::Sorting_tree()
{
    _size = 0;
    _data = NULL;
}

template <class T>
size_t Sorting_tree<T>::size()
{
    return _size;
}

template <class T>
void Sorting_tree<T>::add(T data)
{
    _add_data(&_data, NULL, data);
    _size++;
}

template <class T>
void Sorting_tree<T>::_add_data(node** tree, node* parent, T data)
{
    if(*tree == NULL) {
        *tree = new node;
        (*tree)->value = data;
        (*tree)->parent = parent;
        (*tree)->left = NULL;
        (*tree)->right = NULL;
        return;
    }
    if(data < (*tree)->value) {
        _add_data(&(*tree)->left, *tree, data);
    } else {
        _add_data(&(*tree)->right, *tree, data);
    }
}

template <class T>
void Sorting_tree<T>::asc_walk(T* data)
{
    if(data == NULL) return;
    if(_data == NULL) return;
    std::vector<T> vec;
    _preorder(_data, vec);
    for(size_t i = 0; i < vec.size(); i++) data[i] = vec[i];
}

template <class T>
void Sorting_tree<T>::_preorder(node* tree, std::vector<T> &vec)
{
    if(tree == NULL) return;
    _preorder(tree->left, vec);
    vec.push_back(tree->value);
    _preorder(tree->right, vec);
}

template <class T>
void Sorting_tree<T>::desc_walk(T* data)
{
    if(data == NULL) return;
    if(_data == NULL) return;
    std::vector<T> vec;
    _postorder(_data, vec);
    for(size_t i = 0; i < vec.size(); i++) data[i] = vec[i];
}

template <class T>
void Sorting_tree<T>::_postorder(node* tree, std::vector<T> &vec)
{
    if(tree == NULL) return;
    _postorder(tree->right, vec);
    vec.push_back(tree->value);
    _postorder(tree->left, vec);
}

template <class T>
void Sorting_tree<T>::_destroy(node* tree)
{
    if(tree == NULL) return;
    _destroy(tree->left);
    _destroy(tree->right);
    delete tree;
}

template <class T>
Sorting_tree<T>::~Sorting_tree()
{
    _destroy(_data);
}
