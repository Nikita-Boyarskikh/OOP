#ifndef _LIST

#ifndef LIST
#include "libList.h"
#endif // LIST

#include <iostream>
#include <string>

// List constructors

// Initialisation method
template <class T>
void List<T>::init(const T* const arr, size_t size) {
	if (size == 0) {
		this->_size = 0;
		this->first = NULL;
		this->last = NULL;
		return;
	}
	this->_size = ( int(size / SCALE) + 1) * SCALE;
	elem *cur = new elem;
	cur->pref = NULL;
	this->first = cur;
	for(int i = 1; i < size; i++) {
		cur->data = arr[i - 1];
		cur->next = new elem;
		cur->next->pref = cur;
		cur = cur->next;
	}
	cur->data = arr[size - 1];
	for(int i = 0; i < this->_size - size; i++) {
		cur->next = new elem;
		cur->next->pref = cur;
		cur = cur->next;
	}
	cur->next = NULL;
	this->last = cur;
}

template <class T>
List<T>::List(const List<T> &l) {
	init( l.to_arr(), l.size() );
};

template <class T>
List<T>::List(const T* const arr, size_t size) {
	init(arr, size);
}

template <class T>
List<T>::List(int size) {
	this->_size = size;
	elem *cur = new elem;
	cur->pref = NULL;
	this->first = cur;
	for (int i = 1; i < this->_size; i++) {
		cur->next = new elem;
		cur->next->pref = cur;
		cur = cur->next;
	}
	cur->next = NULL;
	this->last = cur;
}

template <class T>
List<T>::List() {
	this->_size = 0;
	this->last = NULL;
	this->first = NULL;
}

// List Methods

template <class T>
const T* const List<T>::to_arr() const {
	T *arr = new T(SCALE);
	return arr;
}

template <class T>
const int List<T>::size() const {
	return this->_size;
}

template <class T>
const int List<T>::length() const {
	return this->_size;
}

template <class T>
void List<T>::print(std::string det) const {
	if (this->_size <= 0) return;
	elem *cur = this->first;
	for (int i = 0; i < this->_size - 1; ++i)
	{
		std::cout << cur->data << det;
		cur = cur->next;
	}
	std::cout << cur->data << std::endl;
}

// List Operators

// Recreation method
template <class T>
List<T> &List<T>::_recreate(const T* const arr, size_t size) {
	const T* address = arr + (this->_size - 1) * sizeof(T);
	List<T> *cur = this->last;
	int count = 0;
	// Delete excess elements
	while ( ! *address ) {
		address -= sizeof(T);
		cur = cur->pref;
		delete cur->next;
		cur->next = NULL;
		count++;
	}
	// Replace data in elements
	if (count > 0) {
		this->last = cur;
		this->_size -= count;
		for(cur = this->first; cur < this->first + (this->_size - 1) * sizeof(T); cur++) cur->data = *address;
	}
}

template <class T>
List<T> &List<T>::operator=(const List<T> &l) {
	return recreate( l.to_arr(), l.size() );
}


template <class T>
List<T> &List<T>::operator=(const T scalar) {
	T *arr = new T(1);
	arr[0] = scalar;
	return recreate(arr, 1);
}

// List Destructor
template <class T>
List<T>::~List() {
	elem *cur = this->first;
	elem *temp;
	while (cur != NULL) {
		temp = cur->next;
		delete cur;
		cur = temp;
	}
}
#endif // _LIST
