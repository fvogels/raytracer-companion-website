class PS
{
public:
  explicit PS(std::shared_ptr<S> impl)
    : m_impl(impl) { }

  S* operator ->()
  {
    return m_impl.get();
  }

private:
  std::shared_ptr<S> m_impl;
};
