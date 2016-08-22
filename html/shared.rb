require 'Raytracer3'
require 'Html2'

class SharedContext
  include Contracts::TypeChecking
  include Html2::Generation

  def tex_image(basename, quality: 90, density: 300, html_class: 'centered large', style: nil)
    typecheck do
      assert(basename: string)
    end

    tex_filename = "#{basename}.tex"
    png_filename = "#{basename}.png"
    tex_path = Pathname.new tex_filename
    png_path = Pathname.new png_filename
    
    pdf_path = LaTeX2.compile(tex_path)
    Image2.convert(pdf_path, png_path, trim: true, quality: quality, density: density)

    style = if style
            then style = " style=\"#{style}\""
            else style = ""
            end

    %{<img class="#{html_class}" src="#{png_filename}"#{style} />}
  end

  def raytrace(script_name, html_class: 'centered large')
    script_path = Pathname.new("#{script_name}.chai")
    bmp_path = script_path.sub_ext('.bmp')
    png_path = script_path.sub_ext('.png')
    
    typecheck do
      assert(script_path: file('.chai'))
    end

    if Dynamic.lookup(:quick, false) and png_path.file? and script_path.mtime < png_path.mtime
    then
      puts "Skipping rendering #{script_name}"
    else
      RayTracer3.render(script_path)
      
      abort "Could not find render output #{bmp_path}" unless bmp_path.file?
      
      Image2.convert(bmp_path, png_path)
    end
    
    %{<a href="#{png_path.basename}"><img src="#{png_path.basename}" class="#{html_class}" /></a>}
  end

  def youtube(id)
    <<-END
      <div class="video">
        <iframe width="420" height="315" src="https://www.youtube.com/embed/#{id}" frameborder="0" allowfullscreen></iframe>
      </div>
    END
  end

  def source(filename, **opts)
    contents = IO.read(filename)
    source_editor(contents, **opts)
  end
end
