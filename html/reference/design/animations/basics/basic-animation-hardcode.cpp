std::lambda<double(TimeStamp)> lambda = [](TimeStamp now) {
  return now.seconds() * 5;
};

Animation<double> anim = make_animation( from_lambda(lambda), 1_s );
