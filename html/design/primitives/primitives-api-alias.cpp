// Primitives namespace
namespace raytracer
{
  namespace primitives
  {
    // PPrimitive is an alias for std::shared_ptr<Primitive>
    using PPrimitive = std::shared_ptr<Primitive>;
    
    PPrimitive sphere();
    PPrimitive translate(double x, double y, double z, PPrimitive transformee);
    PPrimitive scale(double x, double y, double z, PPrimitive transformee);
    PPrimitive rotate_around_x(double angle, PPrimitive transformee);
    PPrimitive rotate_around_y(double angle, PPrimitive transformee);
    PPrimitive rotate_around_z(double angle, PPrimitive transformee);
  }
}

// Building a 2-radius sphere centered at (1, 2, 3)
using namespace raytracer::primitives;

PPrimitive primitive = translate(1, 2, 3, scale(2, 2, 2, sphere()));
