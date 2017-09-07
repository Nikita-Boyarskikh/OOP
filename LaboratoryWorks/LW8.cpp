#include <iostream>
#include <vector>
#include <algorithm>
#include <cstring>

template <class T>
class Stack {
  protected:
    T* data;
    size_t size;
    size_t length;
    void expand_data_size();
    void restrict_data_size();
  public:
    Stack(std::vector<T> vec);
    ~Stack();
    T pop();
    void push(T elem);
    void print();
};

template <class T>
class StackWithSort : public Stack<T> {
  public:
    StackWithSort(std::vector<T> vec) : Stack<T>(vec) {};
    void sort();
};

int main( int argc, char *argv[] )
{
    std::vector<int> ivec = {3, -5, 2, 8, -1, 45};
    StackWithSort<int> istack(ivec);
    istack.pop();
    istack.push(3);
    std::cout << "Int stack contains: ";
    istack.print();
    istack.sort();
    std::cout << "Int stack after sorting: ";
    istack.print();

    std::vector<char> cvec = {'C', 'H', 'E', 'B', 'U', 'R', 'E', 'B'};
    StackWithSort<char> cstack(cvec);
    cstack.pop();
    cstack.push('K');
    std::cout << "Char stack contains: ";
    cstack.print();
    cstack.sort();
    std::cout << "Char stack after sorting: ";
    cstack.print();

    return 0;
}

template <class T>
Stack<T>::Stack(std::vector<T> vec)
{
    size = vec.size();
    length = size;
    data = new T[vec.size()];
    if(!data) {
        throw std::runtime_error("Bad allocation");
    }
    for( size_t i = 0; i < vec.size(); i++ ) {
        data[i] = vec[i];
    }
}

template <class T>
void Stack<T>::push(T elem)
{
    if( length + 1 > size ) expand_data_size();
    data[length] = elem;
    length++;
}

template <class T>
T Stack<T>::pop()
{
    if( length - 1 < size/4 ) restrict_data_size();
    length--;
    return data[length];
}

template <class T>
void Stack<T>::print()
{
    for( size_t i = 0; i < length; i++ ) std::cout << data[i] << ' ';
    std::cout << std::endl;
}

template <class T>
Stack<T>::~Stack()
{
    if(data) delete[] data;
}

template <class T>
void Stack<T>::expand_data_size() {
    T *temp = new T[size *= 2];
    if(!temp) {
        delete[] data;
        throw std::runtime_error("Bad allocation");
    }
    memmove(temp, data, size*sizeof(data[0]));
    delete[] data;
    data = temp;
}

template <class T>
void Stack<T>::restrict_data_size() {
    T *temp = new T[size /= 2];
    if(!temp) {
        delete[] data;
        throw std::runtime_error("Bad allocation");
    }
    memmove(temp, data, size*sizeof(data[0]));
    delete[] data;
    data = temp;
}

template <class T>
void StackWithSort<T>::sort()
{
    std::sort(this->data, this->data + this->length);
}
