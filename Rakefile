require 'asciidoctor'
require 'asciidoctor/extensions'
require 'fileutils'
require 'pathname'
require_relative './scripts/overview-block'
require_relative './scripts/task-block'
require_relative './scripts/preview-block-macro'
require_relative './scripts/util'


RAYTRACER = 'G:\repos\ucll\3dcg\raytracer\raytracer\x64\Release\raytracer.exe'
WIF = 'C:\Python39\Scripts\wif'


Asciidoctor::Extensions.register do
  block OverviewBlock
  docinfo_processor OverviewBlockMacroDocinfoProcessor if document.basebackend? 'html'
  block TaskBlock
  docinfo_processor TaskBlockDocinfoProcessor if document.basebackend? 'html'
  block_macro PreviewBlockMacro
  docinfo_processor PreviewBlockMacroDocinfoProcessor if document.basebackend? 'html'
end


Rake::FileList.new('docs/**/*.asciidoc').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.html')

  desc "Convert #{absolute_source_path}"
  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    compile_asciidoc(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  desc 'Convert asciidocs to htmls'
  task :html => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.chai').map do |path|
  absolute_source_path = Pathname.new(path).expand_path

  case chai_type absolute_source_path
  when 'movie'
    absolute_target_path = dist_path(absolute_source_path).sub_ext('.mp4')

    desc "Render #{absolute_source_path}"
    file absolute_target_path.to_s => absolute_source_path.to_s do |task|
      render_movie(absolute_source_path, absolute_target_path)
    end
  when 'image'
    absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')

    desc "Render #{absolute_source_path}"
    file absolute_target_path.to_s => absolute_source_path.to_s do |task|
      render_image(absolute_source_path, absolute_target_path)
    end
  when 'skip'
    # Skip
    absolute_source_path = nil
  else
    abort 'Unrecognized chai type'
  end

  absolute_target_path
end.then do |paths|
  desc 'Render chai files'
  task :chai => paths.compact.map(&:to_s)
end

Rake::FileList.new('docs/**/*.tex').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')

  desc "Compile #{absolute_source_path}"
  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    latex_to_png(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  desc "Compile tex files"
  task :tex => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.svg').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path)

  file absolute_target_path.to_s => absolute_source_path.to_s do |task|
    puts "Copying #{absolute_source_path} -> #{absolute_target_path}"
    FileUtils.cp(absolute_source_path, absolute_target_path)
  end

  absolute_target_path
end.then do |paths|
  desc 'Copies all files to dist that need to be preserved as-is'
  task :copy => paths.map(&:to_s)
end

desc 'Removed dist and temp directories'
task :clean do
  FileUtils.rm_rf 'dist'
  FileUtils.rm_rf 'temp'
end

desc 'Makes a full build'
task :default => [ :html, :chai, :tex, :copy ]


# ONLY DO THIS WHEN EVERYTHING IS FINISHED
# MAKE BACKUP OF OLD MATERIAL FIRST
# task :upload do
#   Dir.chdir 'dist' do
#     `ssh -p 22345 -l upload leone.ucll.be rm -rf /home/frederic/courses/3dcg/volume/*`
#     puts `scp -P 22345 -r * upload@leone.ucll.be:/home/frederic/courses/3dcg/volume`
#   end
# end
