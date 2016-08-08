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

  def raytrace(script_name)
    path = Pathname.new("#{script_name}.chai")
    
    typecheck do
      assert(path: file('.chai'))
    end

    RayTracer3.render(path)
  end

  def youtube(id)
    <<-END
      <div class="video">
        <iframe width="420" height="315" src="https://www.youtube.com/embed/#{id}" frameborder="0" allowfullscreen></iframe>
      </div>
    END
  end
end
