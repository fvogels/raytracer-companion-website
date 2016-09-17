require 'MetaData2'
require 'Html2'
require 'Template2'
require 'Upload2'
require 'Shortcuts'
require 'find'
require 'pathname'


class Context
  include Html2::Generation
  
  def find_paths_to_all_extensions
    relative_paths = []
    overview_path = Pathname.new('./overview.html').expand_path
    base_path = Pathname.pwd.expand_path

    Find.find('.').each do |file|
      if /^(.*\.html)\.template$/ =~ file then
        path = Pathname.new($1).expand_path

        unless path == overview_path
          relative_path = path.relative_path_from(base_path)
          relative_paths << relative_path
        end
      end
    end

    relative_paths
  end

  def generate_links_to_extensions
    relative_paths = find_paths_to_all_extensions

    links = relative_paths.map do |relative_path|
      %{<li><a href="#{relative_path.to_s}">#{relative_path}</a></li>}
    end.join("\n")

    %{<ul>#{links}</ul>}
  end
end


meta_object do
  extend MetaData2
  extend Template2::Actions
  extend Upload2::Actions
  extend Shortcuts::Actions

  inherit_remote_directory 'extensions'

  quick_recursive_all

  template_files = Dir['*.template']
  if template_files.size != 1 then
    STDERR.puts "Exactly one .template file expected in #{Dir.pwd}"
    abort
  else
    template_file = template_files[0]
  end
  
  bind( { :html => template(input: template_file,
                            context: Context.new) } )

  uploadable( *Dir['*.html'] )
end
