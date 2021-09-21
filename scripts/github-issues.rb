require 'find'


class IssueScriptGenerator
  def generate
    Find.find('docs/extensions').map do |filename|
      Pathname.new(filename).expand_path
    end.select do |pathname|
      pathname.basename.to_s == 'explanations.asciidoc'
    end.map do |pathname|
      contents = pathname.read
      %r{^= (.*)$} =~ contents or abort "Could not find title in #{pathname}"
      title = $1
      relative_path = pathname.dirname.relative_path_from(Pathname.new('./docs').expand_path)
      url = "http://3dcg.leone.ucll.be/#{relative_path}/explanations.html"
      [title, url]
    end.each do |extension_name, url|
      puts "gh issue create --title \"#{extension_name}\" --label enhancement --body #{url} --project raytracer"
    end
  end
end

def create_issue_script
  IssueScriptGenerator.new.generate
end