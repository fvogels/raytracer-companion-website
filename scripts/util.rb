require 'pathname'


WIF = 'C:\Python39\Scripts\wif'


def chai_type(chai_path)
  raise "File #{chai_path} does not exist" unless chai_path.file?
  raise "Tag not found in #{chai_path}\nFirst line should contain comment with movie, image or skip" unless %r{// (movie|image|skip)} =~ chai_path.readlines.first.strip
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

  Dir.chdir(chai_path.dirname) do
    sh "#{WIF} movie #{chai_path} #{render_path}"
  end
end

def render_image(chai_path, render_path)
  puts "Rendering #{chai_path} -> #{render_path}"
  render_path.dirname.mkpath

  Dir.chdir(chai_path.dirname) do
    sh "#{WIF} frame #{chai_path} 0 #{render_path}"
  end
end


def asciidoc_attributes
  {
    'nofooter' => true,
    'source-highlighter' => 'pygments',
    'stem' => 'latexmath',
    'toc' => 'left',
    'toclevels' => 4,
    'cpp' => 'C++',
  }
end


def compile_asciidoc_file(source_pathname, destination_pathname)
  puts "#{source_pathname} -> #{destination_pathname}"

  destination_pathname.dirname.mkpath
  Asciidoctor.convert_file(source_pathname.to_s, safe: :safe, backend: 'html', to_file: destination_pathname.to_s, attributes: asciidoc_attributes)
end


def compile_asciidoc_string(string, destination_pathname)
  destination_pathname.dirname.mkpath

  Asciidoctor.convert(string, safe: :safe, backend: 'html', to_file: destination_pathname.to_s, attributes: asciidoc_attributes)
end


def latex_to_png(source, destination)
  destination.dirname.mkpath
  temp_root = Pathname.new 'temp'
  temp_root.mkpath
  pdf_path = temp_root.join(source.basename).sub_ext '.pdf'

  if %r{%\s+(magick .*)} =~ source.readlines[0]
    conversion_template = $1
  else
    conversion_template = "magick -density 2400 $input -resize 640x $output"
  end

  conversion_command = conversion_template.gsub(/\$input/, pdf_path.to_s).gsub(/\$output/, destination.to_s)

  puts "Converting #{source.to_s} -> #{destination}"

  Dir.chdir(source.dirname) do
    puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
    puts `pdflatex -output-directory #{temp_root.to_s} #{source.to_s}`
    puts `#{conversion_command}`
  end
end


def dist_path(path)
  docs_root = Pathname.new('docs').expand_path
  dist_root = Pathname.new('dist').expand_path
  dist_root.join(path.relative_path_from(docs_root)).expand_path
end


def read_explanations_as_lines(explanations)
  case explanations
  when Pathname
    explanations.readlines
  when String
    explanations.lines
  when Array
    explanations
  else
    raise "Argument should be String, Pathname or Array; instead, it is #{asciidoc.class}"
  end
end


def extract_overview(asciidoc)
  lines = read_explanations_as_lines asciidoc

  start_index = lines.find_index { |line| line.strip == '[overview]'} + 2
  raise "No overview found in #{asciidoc}" unless start_index
  raise "Expected ---- on line after overview in #{asciidoc}" unless lines[start_index - 1].strip == '----'
  end_index = (start_index...lines.size).find { |i| lines[i].strip == '----' }
  raise "Could not find finishing ---- for overview in #{asciidoc}" unless end_index

  lines[start_index...end_index]
end


def parse_explanations_overview(lines)
  result = { requires: [], excludes: [], reading: [], difficulty: nil, order: nil }

  lines.each_with_object(result) do |line, result|
    case line
    when /^(requires|excludes|reading) (.*)$/
      result[$1.to_sym] << $2
    when /^difficulty (.*)$/
      result[:difficulty] = $1
    when /^order (\d+)$/
      result[:order] = $1.to_i
    else
      abort "Unknown overview entry: #{line}"
    end
  end
end


def extension_difficulty(extension)
  overview = extract_overview(extension)
  data = parse_explanations_overview(overview)
  data[:difficulty]
end


def extension_order(extension)
  overview = extract_overview(extension)
  data = parse_explanations_overview(overview)
  data[:order]
end


def explanations_title(extension)
  lines = read_explanations_as_lines(extension)
  line = lines.find { |line| line.start_with? '= ' }

  raise "Could not find title in #{extension}" unless line

  line[2..-1]
end


def gnuplot_render(source, destination)
  destination.dirname.mkpath

  Dir.chdir(source.dirname.to_s) do
    sh "gnuplot -e \"set terminal pngcairo; set output '#{destination.expand_path.to_s}'\" -c #{source}"
  end
end
