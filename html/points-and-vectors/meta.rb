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

  def inline_tex(tex)
    tex_source = <<-'END'.gsub(/XXX/, tex)
      \documentclass{standalone}
      \begin{document}
      \[ XXX \]
      \end{document}
    END

    @tex_counter = (@texcounter || 0) + 1
    tex_filename = "aux#{@tex_counter}.tex"
    png_filename = "aux#{@tex_counter}.png"
    tex_path = Pathname.new tex_filename
    png_path = Pathname.new png_filename

    File.open(tex_filename, "w") do |out|
      out.write(tex_source)
    end

    pdf_path = LaTeX2.compile(tex_path)
    Image2.convert(pdf_path, png_path)

    %{<img class="inline" src="#{png_path.basename.to_s}" />}
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
