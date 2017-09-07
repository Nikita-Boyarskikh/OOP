#include <iostream>

class X {
  protected:
    char C;
  public:
    virtual void Out();
    X(char ch) : C(ch) {};
};

class Y : public X {
  private:
    int A, B;
  public:
    Y(char ch, int a, int b) : X(ch) { A = a; B = b; };
    virtual void Out();
};

class Z : public Y {
  public:
    Z(char ch) : Y(ch, 0, 0) {};
    virtual void Out();
};

void Print(X* adr)
{
    adr->Out();
    std::cout << std::endl;
}

int main()
{
    X x('X');
    Y y('Y', 1, 2);
    Z z('Z');
    Print(&x);
    Print(&y);
    Print(&z);
    return 0;
}

void X::Out()
{
    std::cout << C;
}

void Y::Out()
{
    for(size_t i = 0; i < A + B; i++) std::cout << '.';
    std::cout << C;
}

void Z::Out()
{
    for(size_t i = 0; i < 10; i++) std::cout << '.';
    for(size_t i = 0; i < 5; i++) std::cout << C;
}
