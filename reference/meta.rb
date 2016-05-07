require 'MetaData'
require 'PovRay'
require 'LaTeX'
require 'RayTracer'
require 'Upload'


meta_object do
  extend MetaData::Actions
  extend LaTeX::Actions
  extend PovRay::Actions
  extend RayTracer::Actions
  extend Upload::Mixin

  basenames = ['full-edition', 'limited-edition']
  tex_files = basenames.map { |basename| basename + ".tex" }
  pdf_files = basenames.map { |basename| basename + ".pdf" }
  
  tex_actions(*tex_files, group_name: :tex)
  group_action(:all, [ :tex ])

  def remote_directory
    world.parent.remote_directory + 'reference'
  end

  uploadable(*pdf_files)

  upload_action
end
