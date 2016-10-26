Animation<Color> color_animation(const Color& from, const Color& to, Duration duration)
{
  auto r = double_animation(from.r, to.r, duration);
  auto g = double_animation(from.g, to.g, duration);
  auto b = double_animation(from.b, to.b, duration);
  
  std::lambda<Color(TimeStamp)> lambda = [r, g, b](TimeStamp now) {
    return Color( r(now), g(now), b(now) );
  };

  return make_animation( from_lambda(lambda), duration );
}
