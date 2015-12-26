require 'Make'


Make.tex_command('full-edition.tex', 'limited-edition.tex')

Make.command 'pov' do
  def description
    'Renders pov-ray images'
  end

  def perform(*args)
    options = { :compile? =>
                lambda do |pov_path|
                  not pov_path.sub_ext('.png').exist?
                end }

    OptionParser.new do |opts|
      opts.on('--force', 'Force compilation') do
        options[:compile?] = lambda { |x| true }
      end
    end.parse(args)
    
    Dir['*.pov'].each do |pov|
      path = Pathname.new(pov).expand_path
      output_file = path.sub_ext('.png')

      if options[:compile?][path]
        puts "Rendering #{pov}"
        `pvengine /EXIT #{pov}`
      else
        puts "Skipping #{path}"
      end
    end
  end
end

Make.command 'cfg' do
  def description
    'Renders cfg files'
  end

  def perform(*args)
    require 'RayTracer'
    
    options = { :compile? =>
                lambda do |pov_path|
                  not pov_path.sub_ext('.png').exist?
                end }

    OptionParser.new do |opts|
      opts.on('--force', 'Force compilation') do
        options[:compile?] = lambda { |x| true }
      end
    end.parse(args)
    
    Dir['*.cfg'].each do |cfg|
      path = Pathname.new(cfg).expand_path
      ppm_file = path.sub_ext('.ppm')
      png_file = path.sub_ext('.png')

      if options[:compile?][path] then
        RayTracer.raytrace(Pathname.new cfg)

        puts "Converting #{ppm_file} to #{png_file}"
        `convert #{ppm_file} #{png_file}`
      else
        puts "Skipping #{path}"
      end
    end
  end
end

Make.group('all', [ 'pov', 'cfg', 'tex' ])
