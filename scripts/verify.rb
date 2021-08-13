require 'set'
require 'find'


module Verification
  def self.collect_html_files
    Enumerator.new do |yielder|
      Find.find('.') do |entry|
        yielder.yield(Pathname.new(entry)) if entry.end_with? 'html'
      end
    end.to_a
  end

  def self.collect_absolute_links(html_pathname)
    html_pathname.read.scan(%r{<a href="(/[^"]+)"}).map do |urls|
      url = urls.first
      Pathname.new ".#{url}"
    end
  end

  def self.find_corresponding_asciidoc_file(root, html_pathname)
    root.join("docs", html_pathname.relative_path_from('.').sub_ext('.asciidoc'))
  end

  def self.verify
    root = Pathname.pwd
    dist = Pathname.new 'dist'

    Dir.chdir('dist') do
      html_files = collect_html_files
      set = html_files.to_set

      html_files.each do |html_file|
        links = collect_absolute_links(html_file)

        links.each do |link|
          unless set.member? link
            asciidoc_file = find_corresponding_asciidoc_file(root, html_file)
            puts "#{asciidoc_file} refers to nonexistent #{link}"
          end
        end
      end
    end
  end
end

def verify_links_in_dist
  Verification.verify
end