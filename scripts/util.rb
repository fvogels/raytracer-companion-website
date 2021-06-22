require 'open3'

def chai_type(chai_path)
  abort "Tag not found in #{chai_path}\nFirst line should contain comment with movie, image or skip" unless %r{// (movie|image|skip)} =~ chai_path.readlines.first.strip
  type = $1
end

def read_chai_script(chai_path)
  script = chai_path.read
  script.gsub(/use\("(.*)"\)/) do
    IO.read(chai_path.dirname + $1)
  end
end

def render_movie(chai_path, render_path)
  puts "Rendering #{chai_path} -> #{render_path}"
  render_path.dirname.mkpath

  script = read_chai_script(chai_path)

  out, err, status = Open3.capture3("#{RAYTRACER} -s - | #{WIF} movie #{render_path}", stdin_data: script)
  puts err
  # puts `#{RAYTRACER} -s #{chai_path.to_s} | #{WIF} movie #{render_path}`
end

def render_image(chai_path, render_path)
  puts "Rendering #{chai_path} -> #{render_path}"
  render_path.dirname.mkpath

  script = read_chai_script(chai_path)

  out, err, status = Open3.capture3("#{RAYTRACER} -s - | #{WIF} frames -i STDIN -o #{render_path}", stdin_data: script)
  puts err
end


def compile_asciidoc(source, destination)
  puts "#{source} -> #{destination}"

  destination.dirname.mkpath

  attributes = {
    'nofooter' => true,
    'source-highlighter' => 'pygments',
    'stem' => 'latexmath'
  }

  Asciidoctor.convert_file(source.to_s, safe: :safe, backend: 'html', to_file: destination.to_s, attributes: attributes)
end


def latex_to_png(source, destination)
  destination.dirname.mkpath
  temp_root = Pathname.new 'temp'
  temp_root.mkpath
  pdf_path = temp_root.join(source.basename).sub_ext '.pdf'

  if %r{%\s+(magick .*)} =~ source.readlines[0]
    conversion_template = $1
  else
    conversion_template = "magick -quality 90 -density 150 $input -trim $output"
  end

  conversion_command = conversion_template.gsub(/\$input/, pdf_path.to_s).gsub(/\$output/, destination.to_s)

  puts "Converting #{source.to_s} -> #{destination}"

  puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
  puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
  puts `#{conversion_command}`
end


def dist_path(path)
  docs_root = Pathname.new('docs').expand_path
  dist_root = Pathname.new('dist').expand_path
  dist_root.join(path.relative_path_from(docs_root)).expand_path
end