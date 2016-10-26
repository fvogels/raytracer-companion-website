Animation<double> create_basic_animation(double to)
{
  // to captured by reference
  std::lambda<double(TimeStamp)> lambda = [&to](TimeStamp now) {
    return now.seconds() * to;
  };

  // Dangerous: the animation contains a lambda that refers to local variable to
  // but local variable to goes out of scope
  return make_animation( from_lambda(lambda), 1_s );
}

auto anim = create_basic_animation(5);
auto value = anim(0.1_s); // calls lambda, which refers to 'to', which does not exist anymore at this point
