struct S
{
  virtual void m() { std::cout << "S"; }
};

struct A : public S
{
  void m() override { std::cout << "A"; }
};

struct B : public S
{
  void m() override { std::cout << "B"; }
};


A a;
S s = a;
s.m();     // prints S


A* pa = new A;
S* ps = pa;
ps->m();   // prints A
