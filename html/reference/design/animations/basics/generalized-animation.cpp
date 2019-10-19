Animation<double> double_animation(double from, double to, Duration duration)
{
  std::function<double(TimeStamp)> lambda = [from, to, duration](TimeStamp now) {
    return from + (to - from) * now.seconds() / duration.seconds();
  };

  return make_animation( from_lambda(lambda), duration );
}
