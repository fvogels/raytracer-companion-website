def chai_type(chai_path)
  abort "Tag not found in #{chai_path}" unless %r{// (movie|image|skip)} =~ chai_path.readlines.first.strip
  type = $1
end

def render_movie(chai_path, render_path)
  puts "Rendering #{chai_path} -> #{render_path}"
  render_path.dirname.mkpath

  puts `#{RAYTRACER} -s #{chai_path.to_s} | #{WIF} movie #{render_path}`
end

def render_image(chai_path, render_path)
  puts "Rendering #{chai_path} -> #{render_path}"
  render_path.dirname.mkpath

  puts `#{RAYTRACER} -s #{chai_path.to_s} | #{WIF} frames -i STDIN -o #{render_path}`
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

  puts "Converting #{source.to_s} -> #{destination}"

  puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
  puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
  puts `magick -quality 90 -density 150 #{pdf_path} -trim #{destination}`
end


def dist_path(path)
  docs_root = Pathname.new('docs').expand_path
  dist_root = Pathname.new('dist').expand_path
  dist_root.join(path.relative_path_from(docs_root)).expand_path
end