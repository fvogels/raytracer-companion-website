std::shared_ptr<A> pa = std::make_shared<A>();
std::shared_ptr<S> ps = pa;
ps->m();     // prints A
