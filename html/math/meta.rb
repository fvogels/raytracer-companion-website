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

  def tex_image(basename, quality: nil, density: nil)
    typecheck do
      assert(basename: string)
    end

    tex_filename = "#{basename}.tex"
    png_filename = "#{basename}.png"
    tex_path = Pathname.new tex_filename
    png_path = Pathname.new png_filename
    
    # LaTeX::tex_to_png(tex_path: tex_path,
    #                   png_path: png_path,
    #                   force: false)

    pdf_path = LaTeX2.compile(tex_path)
    Image2.convert(pdf_path, png_path, quality: quality, density: density)

    %{<img class="centered" src="#{png_filename}" />}
  end
end


meta_object do
  extend MetaData2
  extend Template2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions

  inherit_remote_directory(Pathname.pwd.basename.to_s)

  bind( { :html => template(input: 'math.html.template',
                            context: Context.new) } )

  uploadable('math.html')
  uploadable( *Dir['*.png'] )
  uploadable( *Dir['*.gif'] )

  quick_all(:html)
end
