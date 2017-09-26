require 'MetaData2'
require 'Upload2'
require 'Shortcuts'
require 'LaTeX2'
require 'Image2'
require 'Contracts'


meta_object do
  extend MetaData2
  extend LaTeX2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions

  inherit_remote_directory

  quick_all_tex
  quick_all(:pdf)
end
