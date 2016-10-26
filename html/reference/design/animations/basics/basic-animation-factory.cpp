Animation<double> create_basic_animation(double to)
{
  std::lambda<double(TimeStamp)> lambda = [to](TimeStamp now) {
    return now.seconds() * to;
  };

  return make_animation( from_lambda(lambda), 1_s );
}
