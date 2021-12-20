require 'pathname'
require 'find'
require 'json'
require_relative './util.rb'


def collect_extensions
  Enumerator.new do |y|
    Find.find('./docs/extensions') do |file|
      if file.end_with? '.asciidoc'
        y.yield Pathname.new(file)
      end
    end
  end
end


def collect_weights
  table = collect_extensions.each_with_object({}) do |path, h|
    title = explanations_title(path).strip
    weight = extension_difficulty(path).to_i

    h[title] = weight
  end

  puts(JSON.pretty_generate(table))
end
