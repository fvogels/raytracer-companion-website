require 'MetaData2'
require 'Upload2'
require 'Shortcuts'


meta_object do
  extend MetaData2
  extend Upload2::Actions
  extend Shortcuts::Actions
  

  inherit_remote_directory 'html'

  quick_recursive_all

  register_transfer( Pathname.new('3dcg.css').expand_path,
                     Pathname.new('/var/www/courses/shared/3dcg.css') )
end
