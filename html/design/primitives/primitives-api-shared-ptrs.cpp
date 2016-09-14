// Primitives namespace
namespace raytracer
{
  namespace primitives
  {
    std::shared_ptr<Primitive> sphere();
    std::shared_ptr<Primitive> translate(const Vector3D& v, std::shared_ptr<Primitive> transformee);
    std::shared_ptr<Primitive> scale(double x, double y, double z, std::shared_ptr<Primitive> transformee);
    std::shared_ptr<Primitive> rotate_around_x(Angle angle, std::shared_ptr<Primitive> transformee);
    std::shared_ptr<Primitive> rotate_around_y(Angle angle, std::shared_ptr<Primitive> transformee);
    std::shared_ptr<Primitive> rotate_around_z(Angle angle, std::shared_ptr<Primitive> transformee);
  }
}

// Building a 2-radius sphere centered at (1, 2, 3)
using namespace raytracer::primitives;

std::shared_ptr<Primitive> primitive = translate(1, 2, 3, scale(2, 2, 2, sphere()));
