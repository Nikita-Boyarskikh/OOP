#include <iostream>

#define MAX 500

bool isPalindrome(int a) {
    int temp = 0, copy = a;
    while( copy != 0 ) {
        temp = temp*10 + copy%10;
        copy /= 10;
    }
    return temp == a;
}

int main(int argc, char **argv) {

    std::cout << "Первые " << MAX << " палиндромов:" << std::endl;
    int n = 1;
    for( int i = 0; i < MAX; i++ ) {
        if( isPalindrome( i * i ) ) {
            std::cout << n << "\t" << i << "\t" << i*i << std::endl;
        }
    }
    
    return 0;
}

