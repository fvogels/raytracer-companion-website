using PS = std::shared_ptr<S>;
using PA = std::shared_ptr<A>;
using PB = std::shared_ptr<B>;

PA pa = std::make_shared<A>();
PS ps = pa;
ps->m();     // Prints A
