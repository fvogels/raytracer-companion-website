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
    Image2.convert(pdf_path, png_path, trim: false, quality: quality, density: density)

    style = if style
            then style = " style=\"#{style}\""
            else style = ""
            end

    %{<img class="#{html_class}" src="#{png_filename}"#{style} />}
  end

  def raytrace_script(script_name)
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

    png_path
  end
  
  def raytrace(script_name, html_class: 'centered large', style: nil)
    png_path = raytrace_script(script_name)

    if style
    then style = %{style="#{style}" }
    else style = ""
    end
    
    %{<a href="#{png_path.basename}"><img src="#{png_path.basename}" class="#{html_class}" #{style}/></a>}
  end

  def raytrace_comparison(left, right, style: nil)
    left_path = raytrace_script(left)
    right_path = raytrace_script(right)

    if style
    then style = %{style="#{style}"}
    else style = ""
    end

    <<-END
      <div class="slider responsive" #{style}>
        <div class="left image">
          <img src="#{left_path}" />
        </div>
        <div class="right image">
          <img src="#{right_path} "/>
        </div>
      </div>
    END
  end

  def youtube(id)
    <<-END
      <div class="video">
        <iframe width="420" height="315" src="https://www.youtube.com/embed/#{id}" frameborder="0" allowfullscreen></iframe>
      </div>
    END
  end

  def source(filename, **opts)
    opts = { :auto_height => true }.merge(opts)
    
    contents = IO.read(filename)
    source_editor(contents, **opts)
  end

  def raytrace_movie(script_name, html_class: 'video', width: 500, height: 500)
    script_path = Pathname.new("#{script_name}.chai").expand_path
    output_path = Pathname.new("#{script_name}.mp4").expand_path
    
    RayTracer3.render_mp4(script_path, output_path)

    <<-END
      <video width="#{width}" height="#{height}" loop autoplay>
        <source src="#{script_name}.mp4" type="video/mp4">
        Your browser does not seem to be able to handle video tags.
      </video>
    END
  end

  def link(relative_path_to_root, text)
    absolute_path = Environment.git_root + 'html' + relative_path_to_root
    current_path = Pathname.pwd
               
    %{<a href="#{absolute_path.relative_path_from current_path}/explanations.html">#{text}</a>}
  end
end

def shared_metaobject(context = SharedContext.new)
  extend MetaData2
  extend Template2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions

  inherit_remote_directory(Pathname.pwd.basename.to_s)

  template_files = Dir['*.template']
  if template_files.size != 1 then
    STDERR.puts "Exactly one .template file expected in #{Dir.pwd}"
    abort
  else
    template_file = template_files[0]
  end
  
  bind( { :html => template(input: template_file,
                            context: context) } )

  uploadable( *Dir['*.html'] )
  uploadable( *Dir['*.png'] )
  uploadable( *Dir['*.mp4'] )

  quick_all(:html)
end
