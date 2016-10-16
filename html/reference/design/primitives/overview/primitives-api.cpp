// Primitives namespace
namespace raytracer
{
  namespace primitives
  {
    Primitive* sphere();
    Primitive* translate(const Vector3D& v, Primitive* transformee);
    Primitive* scale(double x, double y, double z, Primitive* transformee);
    Primitive* rotate_around_x(Angle angle, Primitive* transformee);
    Primitive* rotate_around_y(Angle angle, Primitive* transformee);
    Primitive* rotate_around_z(Angle angle, Primitive* transformee);
  }
}

// Building a 2-radius sphere centered at (1, 2, 3)
using namespace raytracer::primitives;

Primitive* primitive = translate(1, 2, 3, scale(2, 2, 2, sphere()));
