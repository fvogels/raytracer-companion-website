require 'MetaData2'
require 'Upload2'


meta_object do
  extend MetaData2
  extend Upload2::Actions
  
  inherit_remote_directory 'shared'


  uploadable( *Dir['*.css'] )
  uploadable( *Dir['*.js'] )
end
