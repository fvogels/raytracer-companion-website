require 'MetaData'
require 'PovRay'
require 'LaTeX'
require 'RayTracer'
require 'Upload'
require 'Image'


meta_object do
  extend MetaData::Actions
  extend LaTeX::Actions
  extend PovRay::Actions
  extend RayTracer::Actions
  extend Image::Actions
  extend Upload::Mixin

  basenames = ['model-exam']
  tex_files = basenames.map { |basename| basename + ".tex" }
  pdf_files = basenames.map { |basename| basename + ".pdf" }
  
  tex_actions(*tex_files, group_name: :tex)
  pov_actions(*Dir['*.pov'], group_name: :pov)
  raytracer_actions(*Dir['*.cfg'], group_name: :cfg)

  actions = Dir['*.cfg'].map do |cfg_file|
    cfg_path = Pathname.new cfg_file
    ppm_path = cfg_path.sub_ext '.ppm'
    png_path = cfg_path.sub_ext '.png'
    action_name = png_path.basename.to_s
    
    image_conversion(ppm_path, png_path, action_name: action_name)

    action_name
  end

  group_action(:png, actions)
      
  group_action(:all, [ :pov, :cfg, :png, :tex ])

  def remote_directory
    world.parent.remote_directory + 'model-exam'
  end

  uploadable(*pdf_files)

  upload_action
end
