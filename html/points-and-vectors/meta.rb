require 'MetaData2'
require 'Html2'
require 'Template2'
require 'Upload2'
require 'Shortcuts'
require 'LaTeX2'
require 'Image2'
require 'Contracts'


class Context
  include Contracts::TypeChecking
  include Html2::Generation

  def tex_image(basename, quality: 90, density: 300, html_class: 'centered large')
    typecheck do
      assert(basename: string)
    end

    tex_filename = "#{basename}.tex"
    png_filename = "#{basename}.png"
    tex_path = Pathname.new tex_filename
    png_path = Pathname.new png_filename
    
    pdf_path = LaTeX2.compile(tex_path)
    Image2.convert(pdf_path, png_path, trim: true, quality: quality, density: density)

    %{<img class="#{html_class}" src="#{png_filename}" />}
  end
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
