require 'erb'
require 'Make'
require 'Contracts'
require 'LaTeX'
require 'Files'
require 'Util'
require 'RayTracer'


TP = Contracts::TypeChecking


def compile(files = [])
  if files.length == 0 then
    files = Files.pathnames( 'html.ts', 'task.ts', 'toc.ts', 'quiz.ts' )
  end
  
  files.each do |file|
    basename = file.basename '.ts'

    TypeScript.compile(file, output: "#{basename}.js")
  end
end

Make.commands do
  command 'tex' do
    short_description { 'Builds pdf' }
    action do |args|
      LaTeX.compile 'full-edition.tex'
      LaTeX.compile 'limited-edition.tex'
    end
  end

  command 'images' do
    short_description { 'Performs ray tracing of .pov and .cfg files' }
    action do |args|
      Dir['*.pov'].each do |pov|
        path = Pathname.new(pov)
        output_file = path.basename(".pov").to_s + ".png"

        if File.exists?(output_file)
          puts "Skipping #{path}"
        else
          `pvengine /EXIT #{pov}`
        end
      end

      Dir['*.cfg'].each do |cfg|
        path = Pathname.new(cfg)
        ppm_file = path.basename(".cfg").to_s + ".ppm"
        png_file = path.basename(".cfg").to_s + ".png"

        if File.exists? png_file then
          puts "Skipping #{cfg}"
        else
          RayTracer.raytrace(Pathname.new cfg)
          `convert #{ppm_file} #{png_file}`
        end
      end
    end
  end
end
