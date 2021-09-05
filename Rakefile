require 'asciidoctor'
require 'asciidoctor/extensions'
require 'fileutils'
require 'pathname'
require_relative './scripts/overview-block'
require_relative './scripts/task-block'
require_relative './scripts/preview-block-macro'
require_relative './scripts/challenge-block-macro'
require_relative './scripts/util'
require_relative './scripts/verify'
require_relative './scripts/toc-generator'


Asciidoctor::Extensions.register do
  block OverviewBlock
  docinfo_processor OverviewBlockMacroDocinfoProcessor if document.basebackend? 'html'
  block TaskBlock
  docinfo_processor TaskBlockDocinfoProcessor if document.basebackend? 'html'
  block_macro PreviewBlockMacro
  docinfo_processor PreviewBlockMacroDocinfoProcessor if document.basebackend? 'html'
  block_macro ChallengeBlockMacro
end


Rake::FileList.new('docs/**/*.asciidoc').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.html')
  relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

  desc "Convert #{absolute_source_path}"
  file relative_target_path.to_s => absolute_source_path.to_s do |task|
    compile_asciidoc_file(absolute_source_path, absolute_target_path)
  end

  relative_target_path
end.then do |paths|
  desc 'Convert asciidocs to htmls'
  task :html => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.chai').map do |path|
  absolute_source_path = Pathname.new(path).expand_path

  case chai_type absolute_source_path
  when 'movie'
    absolute_target_path = dist_path(absolute_source_path).sub_ext('.mp4')
    relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

    desc "Render #{absolute_source_path}"
    file relative_target_path.to_s => absolute_source_path.to_s do |task|
      render_movie(absolute_source_path, absolute_target_path)
    end
  when 'image'
    absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')
    relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

    desc "Render #{absolute_source_path}"
    file relative_target_path.to_s => absolute_source_path.to_s do |task|
      render_image(absolute_source_path, absolute_target_path)
    end
  when 'skip'
    # Skip
    absolute_source_path = nil
  else
    abort 'Unrecognized chai type'
  end

  relative_target_path
end.then do |paths|
  desc 'Render chai files'
  task :chai => paths.compact.map(&:to_s)
end

Rake::FileList.new('docs/**/*.tex').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')
  relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

  desc "Compile #{absolute_source_path}"
  file relative_target_path.to_s => absolute_source_path.to_s do |task|
    latex_to_png(absolute_source_path, absolute_target_path)
  end

  relative_target_path
end.then do |paths|
  desc "Compile tex files"
  task :tex => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.gp').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path).sub_ext('.png')
  relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

  desc "Render #{absolute_source_path}"
  file relative_target_path.to_s => absolute_source_path.to_s do |task|
    gnuplot_render(absolute_source_path, absolute_target_path)
  end

  relative_target_path
end.then do |paths|
  desc "Compile gnuplot files"
  task :gnuplot => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.svg').map do |path|
  absolute_source_path = Pathname.new(path).expand_path
  absolute_target_path = dist_path(absolute_source_path)
  relative_target_path = absolute_target_path.relative_path_from(Pathname.pwd)

  file relative_target_path.to_s => absolute_source_path.to_s do |task|
    puts "Copying #{absolute_source_path} -> #{absolute_target_path}"
    FileUtils.cp(absolute_source_path, absolute_target_path)
  end

  relative_target_path
end.then do |paths|
  desc 'Copies all files to dist that need to be preserved as-is'
  task :copy => paths.map(&:to_s)
end

Rake::FileList.new('docs/**/*.gv').then do |graphviz_files|
  svg_files = graphviz_files.pathmap('%{^docs/,dist/}X.svg')

  graphviz_files.zip(svg_files).each do |graphviz_file, svg_file|
    source = Pathname.new graphviz_file
    target = Pathname.new svg_file

    desc "Compile #{graphviz_file}"
    file svg_file.to_s => graphviz_file.to_s do
      compile_graphviz(source, target)
    end
  end

  desc 'Compiles graphviz to svg'
  task :graphviz => svg_files
end

desc 'Removed dist and temp directories'
task :clean do
  FileUtils.rm_rf 'dist'
  FileUtils.rm_rf 'temp'
end

desc 'Verifies links in dist'
task :verify do
  verify_links_in_dist
end

desc 'Generates table of contents'
task :toc do
  puts "Generating TOC"
  generate_toc
end

desc 'Makes a full build'
task :default => [ :toc, :html, :chai, :tex, :gnuplot, :graphviz, :copy ]


# ONLY DO THIS WHEN EVERYTHING IS FINISHED
# MAKE BACKUP OF OLD MATERIAL FIRST
# task :upload do
#   Dir.chdir 'dist' do
#     `ssh -p 22345 -l upload leone.ucll.be rm -rf /home/frederic/courses/3dcg/volume/*`
#     puts `scp -P 22345 -r * upload@leone.ucll.be:/home/frederic/courses/3dcg/volume`
#   end
# end
