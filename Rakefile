require 'asciidoctor'
require 'asciidoctor/extensions'
require 'fileutils'
require 'pathname'
require_relative './scripts/overview-block'
require_relative './scripts/task-block'


Asciidoctor::Extensions.register do
  block OverviewBlock
  block TaskBlock
  docinfo_processor TaskBlockDocinfoProcessor if document.basebackend? 'html'
end


def raytrace(absolute_chai_path)
  puts "Rendering #{absolute_chai_path}"
  # wif extract --format png -i STDIN -o STDOUT
end





def compile_asciidoc(source, destination)
  puts "#{source} -> #{destination}"

  destination.dirname.mkpath
  Asciidoctor.convert_file(source.to_s, safe: :safe, backend: 'html', to_file: destination.to_s)
end

def dist_path(path)
  docs_root = Pathname.new('docs').expand_path
  dist_root = Pathname.new('dist').expand_path
  dist_root.join(path.relative_path_from(docs_root)).expand_path
end

Rake::FileList.new('**/*.asciidoc').map do |path|
  absolute_asciidoc_path = Pathname.new(path).expand_path
  absolute_html_path = dist_path(absolute_asciidoc_path).sub_ext('.html')

  file absolute_html_path.to_s => absolute_asciidoc_path.to_s do |task|
    compile_asciidoc(absolute_asciidoc_path, absolute_html_path)
  end

  absolute_html_path
end.then do |paths|
  task :html => paths.map(&:to_s)
end


task :clean do
  FileUtils.rm_rf 'dist'
end

task :default do
  # compile_asciidoc
end


# ONLY DO THIS WHEN EVERYTHING IS FINISHED
# MAKE BACKUP OF OLD MATERIAL FIRST
# task :upload do
#   Dir.chdir 'dist' do
#     `ssh -p 22345 -l upload leone.ucll.be rm -rf /home/frederic/courses/3dcg/volume/*`
#     puts `scp -P 22345 -r * upload@leone.ucll.be:/home/frederic/courses/3dcg/volume`
#   end
# end