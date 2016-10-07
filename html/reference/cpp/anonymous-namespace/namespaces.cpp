// A.cpp
namespace A_private
{
  void helper() { ... }
}

using namespace A_private;

void a()
{
  ...
  helper();
  ...
}


// B.cpp
namespace B_private
{
  void helper() { ... }
}

using namespace B_private;

void b()
{
  ...
  helper();
  ...
}
