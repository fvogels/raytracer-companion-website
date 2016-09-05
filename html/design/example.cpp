raytracer::Material create_lens_material()
{
    using namespace raytracer::materials;

    MaterialProperties material_properties(colors::green() * 0.1, colors::green() * 0.1, colors::white(), 10, 0, 0.8, 1.5);

    return uniform(material_properties);
}

raytracer::Primitive create_lens()
{
    using namespace raytracer::primitives;

    auto left_sphere = translate(Vector3D(0, 0, 0.8), sphere());
    auto right_sphere = translate(Vector3D(0, 0, -0.8), sphere());
    auto lens = intersection(left_sphere, right_sphere);

    return decorate(create_lens_material(), lens);
}

raytracer::Material create_floor_material()
{
    using namespace raytracer::materials;

    MaterialProperties white(colors::white() * 0.1, colors::white(), colors::white(), 10);
    MaterialProperties black(colors::black(), colors::black(), colors::white(), 10);

    return grid(0.1, uniform(white), uniform(black));
}

raytracer::Primitive create_floor()
{
    using namespace raytracer::primitives;

    auto floor = translate(Vector3D(0, -1, 0), xz_plane());

    return decorate(create_floor_material(), floor);
}

raytracer::Primitive create_root()
{
    using namespace raytracer::primitives;

    std::vector<Primitive> primitives = { create_floor(), create_lens() };

    return make_union(primitives);
}

std::vector<raytracer::LightSource> create_light_sources()
{
    using namespace raytracer::lights;

    std::vector<LightSource> light_sources;
    light_sources.push_back(omnidirectional(Point3D(0, 5, 5), colors::white()));

    return light_sources;
}

raytracer::Camera create_camera(TimeStamp now)
{
    auto eye_animation = animation::circular(Point3D(0, 0, 2), Point3D(0, 0, 0), Vector3D::y_axis(), interval(0_degrees, 360_degrees), 5_s);

    return raytracer::cameras::perspective(eye_animation(now), Point3D(0, 0, 0), Vector3D(0, 1, 0), 1, 1);
}

Animation<std::shared_ptr<Scene>> create_scene_animation()
{
    std::function<std::shared_ptr<Scene>(TimeStamp)> lambda = [](TimeStamp now) {
        auto camera = create_camera(now);
        auto root = create_root();
        auto light_sources = create_light_sources();
        auto scene = std::make_shared<Scene>(camera, root, light_sources);

        return scene;
    };

    auto function = from_lambda(lambda);

    return make_animation<std::shared_ptr<Scene>>(function, Duration::from_seconds(5));
}

void render()
{
    auto scene_animation = create_scene_animation();
    auto ray_tracer = raytracer::raytracers::v6();
    auto renderer = raytracer::renderers::standard(500, 500, raytracer::samplers::multi_jittered(2), ray_tracer, loopers::smart_looper(4));

    pipeline::start(create_scene_animation()) >> pipeline::animation(30)
                                              >> pipeline::renderer(renderer)
                                              >> pipeline::wif("test.wif");
}
