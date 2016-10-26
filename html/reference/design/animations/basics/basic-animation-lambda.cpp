std::function<double(TimeStamp)> func = [](TimeStamp ts) -> double {
  return ts.seconds();
};
