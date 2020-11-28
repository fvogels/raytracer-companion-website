require 'asciidoctor'
require 'asciidoctor/extensions'
require 'fileutils'
require 'pathname'
require 'find'
require_relative './scripts/overview-block'



Asciidoctor::Extensions.register do
  block OverviewBlock
end



def find_asciidoc_files
  Find.find('.').filter do |entry|
    entry.end_with? '.asciidoc'
  end.map do |filename|
    Pathname.new(filename).expand_path
  end
end

def compile_asciidoc
  puts "Compiling asciidocs..."

  root_docs_path = Pathname.pwd.join('docs')
  root_dist_path = Pathname.pwd.join('dist')

  find_asciidoc_files.each do |asciidoc_absolute_input_path|
    asciidoc_relative_input_path = asciidoc_absolute_input_path.relative_path_from root_docs_path
    asciidoc_absolute_output_path = (root_dist_path.join asciidoc_relative_input_path).sub_ext('.html')

    puts "#{asciidoc_absolute_input_path} -> #{asciidoc_absolute_output_path}"

    asciidoc_absolute_output_path.dirname.mkpath
    Asciidoctor.convert_file(asciidoc_absolute_input_path.to_s, safe: :safe, backend: 'html', to_file: asciidoc_absolute_output_path.to_s)
  end
end



task :clean do
  FileUtils.rm_rf 'dist'
end

task :build do
  compile_asciidoc
end


# ONLY DO THIS WHEN EVERYTHING IS FINISHED
# MAKE BACKUP OF OLD MATERIAL FIRST
# task :upload do
#   Dir.chdir 'dist' do
#     `ssh -p 22345 -l upload leone.ucll.be rm -rf /home/frederic/courses/3dcg/volume/*`
#     puts `scp -P 22345 -r * upload@leone.ucll.be:/home/frederic/courses/3dcg/volume`
#   end
# end