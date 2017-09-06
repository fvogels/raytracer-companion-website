require 'MetaData2'
require 'Html2'
require 'Template2'
require 'Upload2'
require 'Shortcuts'
require 'Contracts'
repo_require 'html/shared.rb'



meta_object do
  extend MetaData2
  extend LaTeX2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions
  extend Template2::Actions
  

  inherit_remote_directory

  template_files = Dir['*.template']
  if template_files.size != 1 then
    STDERR.puts "Exactly one .template file expected in #{Dir.pwd}"
    abort
  else
    template_file = template_files[0]
  end

  bind( { :html => template(input: template_file,
                            context: SharedContext.new) } )

  uploadable( *Dir['*.html'] )
end
