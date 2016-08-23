require 'MetaData2'
require 'Html2'
require 'Template2'
require 'Upload2'
require 'Shortcuts'
require 'LaTeX2'
require 'Image2'
require 'Contracts'
require 'Environment'
repo_require 'html/shared.rb'


class Context < SharedContext

end


meta_object do
  extend MetaData2
  extend Template2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions

  inherit_remote_directory(Pathname.pwd.basename.to_s)

  template_files = Dir['*.template']
  if template_files.size != 1 then
    abort "Exactly one .template file expected"
  else
    template_file = template_files[0]
  end
  
  bind( { :html => template(input: template_file,
                            context: Context.new) } )

  uploadable( *Dir['*.html'] )
  uploadable( *Dir['*.png'] )

  quick_all(:html)
end
