require 'asciidoctor'
require 'asciidoctor/extensions'
require 'fileutils'
require 'pathname'
require_relative './scripts/overview-block'
require_relative './scripts/task-block'
require_relative './scripts/preview-block-macro'


RAYTRACER = 'G:\repos\ucll\3dcg\raytracer\raytracer\x64\Release\raytracer.exe'
WIF = 'C:\Python37\Scripts\wif'


Asciidoctor::Extensions.register do
  block OverviewBlock
  block TaskBlock
  docinfo_processor TaskBlockDocinfoProcessor if document.basebackend? 'html'
  block_macro PreviewBlockMacro
  docinfo_processor PreviewBlockMacroDocinfoProcessor if document.basebackend? 'html'
end


def render_movie(chai_path, movie_path)
  puts "Rendering #{chai_path} -> #{movie_path}"
  movie_path.dirname.mkpath
  puts `#{RAYTRACER} --quiet -s #{chai_path.to_s} | #{WIF} convert #{movie_path}`
end


def compile_asciidoc(source, destination)
  puts "#{source} -> #{destination}"

  destination.dirname.mkpath

  p(Asciidoctor.convert_file(source.to_s, safe: :safe, backend: 'html', to_file: destination.to_s, attributes: { 'nofooter' => true }).attributes)
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


Rake::FileList.new('docs/**/*.asciidoc').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.html')

  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    compile_asciidoc(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  task :html => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.chai').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.mp4')

  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    render_movie(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  task :chai => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.tex').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')

  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    latex_to_png(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  task :tex => paths.map(&:to_s)
end

task :clean do
  FileUtils.rm_rf 'dist'
  FileUtils.rm_rf 'temp'
end

task :default => [ :html, :chai, :tex ]


# ONLY DO THIS WHEN EVERYTHING IS FINISHED
# MAKE BACKUP OF OLD MATERIAL FIRST
# task :upload do
#   Dir.chdir 'dist' do
#     `ssh -p 22345 -l upload leone.ucll.be rm -rf /home/frederic/courses/3dcg/volume/*`
#     puts `scp -P 22345 -r * upload@leone.ucll.be:/home/frederic/courses/3dcg/volume`
#   end
# end
