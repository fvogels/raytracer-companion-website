require 'MetaData2'
require 'Html2'
require 'Template2'
require 'Upload2'
require 'Shortcuts'
require 'LaTeX2'
require 'Image2'
require 'RayTracer3'
require 'Contracts'
repo_require 'html/shared.rb'


meta_object do
  instance_eval(&shared_metaobject)
end
